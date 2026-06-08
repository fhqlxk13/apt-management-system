package kr.or.ddit.domain.apt.apiApartment.service;

import kr.or.ddit.common.api.react.vo.AptManageDetailDTO;
import kr.or.ddit.domain.apt.apiApartment.mapper.IAptApiMapper;
import kr.or.ddit.domain.apt.apiApartment.vo.*;
import kr.or.ddit.domain.apt.main.vo.AptComplexVO;
import kr.or.ddit.domain.apt.main.vo.AptDetailVO;
import kr.or.ddit.domain.apt.main.vo.AptUnitVO;
import kr.or.ddit.domain.apt.mgmtOffice.main.service.IMgmtAptComplexEditService;
import kr.or.ddit.domain.apt.mgmtOffice.main.vo.UpdateBuildingStructureDTO;
import kr.or.ddit.domain.member.manager.vo.ManagerVO;
import kr.or.ddit.domain.member.vo.AuthVO;
import kr.or.ddit.domain.member.vo.MemberVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@Slf4j
@Transactional
public class AptApiServiceImpl implements IAptApiService {

    @Autowired
    private IAptApiMapper aptMapper;

    @Autowired
    private ISeqService seqService;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private IMgmtAptComplexEditService mgmtAptComplexEditService;

    private final String serviceKey = "279564b17283c0863ff904cbfee96deb15c26cd426ec71fe7c5966a865f64f2f";

    private final RestTemplate rt = new RestTemplate();

    @Override
    public void updateLatLng() {

        log.info("좌표 업데이트 시작");

        List<AptComplexEntity> list =
                aptMapper.selectNoCoordList();

        for (AptComplexEntity apt : list) {

            try {

                log.info("좌표 조회 : {}", apt.getAptCmplexNm());

                Map<String, String> coord =
                        getLatLng(apt.getDorojuso());

                if (coord != null) {

                    apt.setLatVal(
                            Double.parseDouble(coord.get("lat"))
                    );

                    apt.setLonVal(
                            Double.parseDouble(coord.get("lng"))
                    );

                    aptMapper.updateLatLng(apt);
                }

                Thread.sleep(200);

            } catch (Exception e) {

                log.error(
                        "좌표 업데이트 실패 : {}",
                        apt.getAptCmplexNo(),
                        e
                );
            }
        }

        log.info("좌표 업데이트 종료");
    }

    @Override
    public List<AptBass> checkBaseInfo(
            String sido,
            String sigungu,
            String emd
    ) {

        log.info(
                "기본정보 조회 : {} {} {}",
                sido,
                sigungu,
                emd
        );

        List<AptBass> result =
                new ArrayList<>();

        List<String> lawdCdList =
                aptMapper.selectLawdCdList(
                        sido,
                        sigungu,
                        emd
                );

        log.info("LAWD_CD 조회 결과 : {}", lawdCdList);

        for (String bjdCode : lawdCdList) {

            int pageNo = 1;

            while (true) {

                try {

                    String listUrl =
                            "https://apis.data.go.kr/1613000/AptListService3/getLegaldongAptList3"
                                    + "?serviceKey=" + serviceKey
                                    + "&pageNo=" + pageNo
                                    + "&numOfRows=100"
                                    + "&bjdCode=" + bjdCode;

                    ResponseEntity<AptListResponse> response =
                            rt.getForEntity(
                                    listUrl,
                                    AptListResponse.class
                            );

                    AptListResponse dto =
                            response.getBody();

                    if (dto == null
                            || dto.getResponse() == null
                            || dto.getResponse().getBody() == null
                            || dto.getResponse()
                            .getBody()
                            .getItems() == null
                    ) {
                        break;
                    }

                    List<AptListItem> items =
                            dto.getResponse()
                                    .getBody()
                                    .getItems();

                    if (items.isEmpty()) {
                        break;
                    }

                    for (AptListItem item : items) {

                        AptBass bass =
                                getBassInfo(
                                        item.getKaptCode()
                                );

                        if (bass != null) {
                            result.add(bass);
                        }
                    }

                    pageNo++;

                } catch (Exception e) {

                    log.error(
                            "기본정보 조회 실패",
                            e
                    );

                    break;
                }
            }
        }


        return result;
    }

    /**
     * 체크된 아파트 등록
     */
    @Override
    public void registerAptList(List<String> kaptCodeList) {

        if (kaptCodeList == null || kaptCodeList.isEmpty()) {
            return;
        }

        for (String kaptCode : kaptCodeList) {

            try {

                // 이미 등록된 경우 skip
                if (aptMapper.existsApt(kaptCode) > 0) {

                    log.info("이미 등록된 단지 : {}", kaptCode);
                    continue;
                }

                registerSingleApt(kaptCode);

            } catch (Exception e) {

                log.error("단지 등록 실패 : {}", kaptCode, e);
            }
        }
    }

    @Override
    public AptManageDetailDTO getDetail(
            String kaptCode
    ) {
        AptManageDetailDTO dto = new AptManageDetailDTO();
        AptComplexVO complex = aptMapper.selectAptComplex(kaptCode);

        // 등록된 단지
        if (complex != null) {

            dto.setRegistered(true);
            dto.setComplex(complex);
            dto.setUnitList(
                    aptMapper.selectAptUnitList(
                            kaptCode
                    )
            );
            return dto;
        }

// 미등록 단지
        AptBass bass =
                getBassInfo(kaptCode);

        AptDetail detail =
                getDetailInfo(kaptCode);

        dto.setRegistered(false);

        dto.setComplex(
                createComplexVO(
                        bass,
                        detail
                )
        );

        dto.setUnitList(
                createUnitList(bass)
        );

        return dto;
    }

    private AptComplexVO createComplexVO(
            AptBass bass,
            AptDetail detail
    ) {

        AptComplexVO vo =
                new AptComplexVO();

        vo.setAptCmplexNo(
                bass.getKaptCode()
        );

        vo.setAptCmplexNm(
                bass.getKaptName()
        );

        vo.setDorojuso(
                bass.getDoroJuso()
        );

        vo.setCnscoNm(
                bass.getKaptBcompany()
        );

        vo.setHeatTy(
                bass.getCodeHeatNm()
        );

        vo.setBldYr(
                bass.getKaptUsedate()
        );

        vo.setDongCnt(
                safeParseInt(
                        bass.getKaptDongCnt()
                )
        );

        vo.setUnitCnt(
                safeParseInt(
                        bass.getKaptdaCnt()
                )
        );

        vo.setMaxFloor(
                Math.max(
                        bass.getKaptTopFloor(),
                        bass.getKtownFlrNo()
                )
        );

        if (detail != null) {

            vo.setPkgCnt(
                    safeParseInt(
                            detail.getKaptdPcnt()
                    )
                            +
                            safeParseInt(
                                    detail.getKaptdPcntu()
                            )
            );

            vo.setCcCnt(
                    String.valueOf(
                            safeParseInt(
                                    detail.getKaptdCccnt()
                            )
                    )
            );

        }

        return vo;
    }

    /**
     * 단지 하나 등록
     */
    private void registerSingleApt(String kaptCode) {

        log.info("단지 등록 시작 : {}", kaptCode);

        AptBass bass = getBassInfo(kaptCode);
        AptDetail detail = getDetailInfo(kaptCode);

        if (bass == null) {
            throw new RuntimeException("기본정보 조회 실패");
        }

        // =========================
        // 단지
        // =========================
        AptComplexEntity aptEntity =
                createAptEntity(bass, detail);

        aptMapper.insertApt(aptEntity);

        // =========================
        // 관리사무소
        // =========================
        String mgmtOfcNo = seqService.getMgmtSeq();

        MgmtOfficeEntity mgmt =
                createMgmtOffice(bass, mgmtOfcNo);

        aptMapper.insertMgmtOffice(mgmt);

        // =========================
        // 관리자 회원
        // =========================
        String userNo = seqService.getMemberSeq();

        MemberVO member =
                createManagerMember(bass, userNo);

        aptMapper.insertMember(member);

        // =========================
        // 관리자 정보
        // =========================
        ManagerVO manager =
                createManager(userNo, mgmtOfcNo);

        aptMapper.insertManager(manager);

        // =========================
        // 권한
        // =========================
        AuthVO auth =
                createAuth(userNo);

        aptMapper.insertAuth(auth);

        // =========================
        // 동 생성
        // =========================
        List<AptUnitVO> unitList =
                createUnitList(bass);

        if (!unitList.isEmpty()) {
            aptMapper.insertAptUnitBatch(unitList);
        }

        // =========================
        // 호 타입
        // =========================
        List<AptHoTyDTO> hoTyList =
                createHoTypeList(bass);

        if (!hoTyList.isEmpty()) {
            aptMapper.insertAptHoTyBatch(hoTyList);
        }

        // =========================
        // 호 생성
        // =========================
        List<AptDetailVO> detailList =
                createHoList(bass);

        if (!detailList.isEmpty()) {
            aptMapper.insertAptDetailBatch(detailList);
        }

        // =========================
        // 인프라
        // =========================
        insertInfra(detail, kaptCode);

        log.info("단지 등록 완료 : {}", kaptCode);
    }

    /**
     * 기본정보 조회
     */
    private AptBass getBassInfo(String kaptCode) {

        try {

            String url =
                    "https://apis.data.go.kr/1613000/AptBasisInfoServiceV4/getAphusBassInfoV4"
                            + "?serviceKey=" + serviceKey
                            + "&kaptCode=" + kaptCode;

            ResponseEntity<AptBassResponse> response =
                    rt.getForEntity(url, AptBassResponse.class);

            AptBassResponse dto = response.getBody();

            if (dto == null
                    || dto.getResponse() == null
                    || dto.getResponse().getBody() == null
                    || dto.getResponse().getBody().getItem() == null) {

                return null;
            }

            return dto.getResponse().getBody().getItem();

        } catch (Exception e) {

            log.error("기본정보 조회 실패 : {}", kaptCode, e);
            return null;
        }
    }

    /**
     * 상세정보 조회
     */
    private AptDetail getDetailInfo(String kaptCode) {

        try {

            String url =
                    "https://apis.data.go.kr/1613000/AptBasisInfoServiceV4/getAphusDtlInfoV4"
                            + "?serviceKey=" + serviceKey
                            + "&kaptCode=" + kaptCode;

            ResponseEntity<AptDetailResponse> response =
                    rt.getForEntity(url, AptDetailResponse.class);

            AptDetailResponse dto = response.getBody();

            if (dto == null
                    || dto.getResponse() == null
                    || dto.getResponse().getBody() == null
                    || dto.getResponse().getBody().getItem() == null) {

                return null;
            }

            return dto.getResponse().getBody().getItem();

        } catch (Exception e) {

            log.error("상세정보 조회 실패 : {}", kaptCode, e);
            return null;
        }
    }

    /**
     * 단지 entity 생성
     */
    private AptComplexEntity createAptEntity(
            AptBass bass,
            AptDetail detail
    ) {

        AptComplexEntity apt = new AptComplexEntity();

        apt.setAptCmplexNo(bass.getKaptCode());
        apt.setAptCmplexNm(bass.getKaptName());

        apt.setHeatTy(bass.getCodeHeatNm());
        apt.setBldYr(bass.getKaptUsedate());
        apt.setCnscoNm(bass.getKaptBcompany());

        apt.setDorojuso(bass.getDoroJuso());

        apt.setDongCnt(
                safeParseInt(bass.getKaptDongCnt())
        );

        apt.setUnitCnt(
                safeParseInt(bass.getKaptdaCnt())
        );

        int maxFloor = Math.max(
                bass.getKaptTopFloor(),
                bass.getKtownFlrNo()
        );

        apt.setMaxFloor(maxFloor);

        if (detail != null) {

            apt.setPkgCnt(
                    safeParseInt(detail.getKaptdPcnt())
                            + safeParseInt(detail.getKaptdPcntu())
            );

            apt.setCcCnt(
                    safeParseInt(detail.getKaptdCccnt())
            );
        }

        return apt;
    }

    /**
     * 관리사무소 생성
     */
    private MgmtOfficeEntity createMgmtOffice(
            AptBass bass,
            String mgmtOfcNo
    ) {

        MgmtOfficeEntity entity =
                new MgmtOfficeEntity();

        entity.setMgmtOfcNo(mgmtOfcNo);

        entity.setAptCmplexNo(
                bass.getKaptCode()
        );

        entity.setMgmtOfcNm(
                bass.getKaptName() + " 관리사무소"
        );

        entity.setMgmtOfcTelno(
                bass.getKaptTel()
        );

        entity.setMgmtOfcBankCd("KB");

        entity.setMgmtOfcAcntNo("0000-0000");

        entity.setMgmtOfcAcntHldrNm(
                bass.getKaptName() + " 관리사무소"
        );

        return entity;
    }

    /**
     * 관리자 회원 생성
     */
    private MemberVO createManagerMember(
            AptBass bass,
            String userNo
    ) {

        MemberVO member = new MemberVO();

        member.setUserNo(userNo);

        member.setUserId(
                bass.getKaptCode()
        );

        member.setUserPw(
                passwordEncoder.encode("1234")
        );

        member.setUserNm(
                bass.getKaptName() + "_관리소장"
        );

        member.setUserTelno(
                bass.getKaptTel()
        );

        member.setUserRrno("1234561234567");

        return member;
    }

    /**
     * 관리자 생성
     */
    private ManagerVO createManager(
            String userNo,
            String mgmtOfcNo
    ) {

        ManagerVO manager = new ManagerVO();

        manager.setUserNo(userNo);

        manager.setMgmtOfcNo(mgmtOfcNo);

        manager.setMngrDutyCd("HEAD");

        return manager;
    }

    /**
     * 권한 생성
     */
    private AuthVO createAuth(String userNo) {

        AuthVO auth = new AuthVO();

        auth.setUserNo(userNo);

        auth.setAuth("ROLE_MNGR");

        return auth;
    }

    /**
     * 동 생성
     */
    private List<AptUnitVO> createUnitList(
            AptBass bass
    ) {

        List<AptUnitVO> list =
                new ArrayList<>();

        int dongCnt =
                safeParseInt(bass.getKaptDongCnt());

        int totalCnt =
                safeParseInt(bass.getKaptdaCnt());

        if (dongCnt == 0) {
            return list;
        }

        int perDong = totalCnt / dongCnt;

        int remain = totalCnt % dongCnt;

        int maxFloor = Math.max(
                bass.getKaptTopFloor(),
                bass.getKtownFlrNo()
        );

        for (int i = 1; i <= dongCnt; i++) {

            AptUnitVO unit = new AptUnitVO();

            unit.setDongNo(
                    bass.getKaptCode() + "_" + i
            );

            unit.setAptCmplexNo(
                    bass.getKaptCode()
            );

            unit.setDongNm(i + "");

            unit.setFloor(maxFloor);

            if (i == dongCnt) {
                unit.setUnitCnt(perDong + remain);
            } else {
                unit.setUnitCnt(perDong);
            }

            list.add(unit);
        }

        return list;
    }

    /**
     * 호 생성
     */
    private List<AptDetailVO> createHoList(
            AptBass bass
    ) {

        List<AptDetailVO> list =
                new ArrayList<>();

        int totalUnitCnt =
                safeParseInt(bass.getKaptdaCnt());

        int dongCnt =
                safeParseInt(bass.getKaptDongCnt());

        int maxFloor = Math.max(
                bass.getKaptTopFloor(),
                bass.getKtownFlrNo()
        );

        if (dongCnt == 0 || maxFloor == 0) {
            return list;
        }

        int householdsPerFloor =
                (int) Math.ceil(
                        (double) totalUnitCnt
                                / dongCnt
                                / maxFloor
                );

        for (int i = 1; i <= dongCnt; i++) {

            int unitCnt =
                    totalUnitCnt / dongCnt;

            if (i == dongCnt) {
                unitCnt += totalUnitCnt % dongCnt;
            }

            int unitIndex = 1;

            for (int f = 1; f <= maxFloor; f++) {

                for (int h = 1; h <= householdsPerFloor; h++) {

                    if (unitIndex > unitCnt) {
                        break;
                    }

                    AptDetailVO detail =
                            new AptDetailVO();

                    detail.setDongNo(
                            bass.getKaptCode() + "_" + i
                    );

                    detail.setFloor(f);

                    detail.setHo(
                            String.valueOf(f * 100 + h)
                    );

                    detail.setHoNo(
                            bass.getKaptCode()
                                    + "_" + i
                                    + "_" + (f * 100 + h)
                    );

                    detail.setHoTyNo(
                            bass.getKaptCode() + "_1"
                    );

                    list.add(detail);

                    unitIndex++;
                }
            }
        }

        return list;
    }

    /**
     * 호 타입 생성
     */
    private List<AptHoTyDTO> createHoTypeList(
            AptBass bass
    ) {

        List<AptHoTyDTO> list =
                new ArrayList<>();

        AptHoTyDTO dto = new AptHoTyDTO();

        dto.setHoTyNo(
                bass.getKaptCode() + "_1"
        );

        dto.setAptCmplexNo(
                bass.getKaptCode()
        );

        dto.setTyNm("A타입");

        dto.setExclusiveSize("84");

        dto.setRoomCnt(3);

        dto.setBathroomCnt(2);

        list.add(dto);

        return list;
    }

    /**
     * 인프라 저장
     */
    private void insertInfra(
            AptDetail detail,
            String kaptCode
    ) {

        if (detail == null) {
            return;
        }

        addInfra(
                detail.getWelfareFacility(),
                "WELFARE",
                kaptCode
        );

        addInfra(
                detail.getConvenientFacility(),
                "CONVENIENCE",
                kaptCode
        );

        addInfra(
                detail.getEducationFacility(),
                "EDUCATION",
                kaptCode
        );
    }

    /**
     * 인프라 등록
     */
    private void addInfra(
            String value,
            String categoryCd,
            String kaptCode
    ) {

        if (value == null || value.trim().isEmpty()) {
            return;
        }

        String[] arr = value.split(",");

        for (String item : arr) {

            AptInfraEntity infra =
                    new AptInfraEntity();

            infra.setAptCmplexNo(kaptCode);

            infra.setCategoryCd(categoryCd);

            infra.setInfraNm(item.trim());

            aptMapper.insertInfraOne(infra);
        }
    }

    /**
     * 숫자 변환
     */
    private int safeParseInt(String str) {

        if (str == null || str.trim().isEmpty()) {
            return 0;
        }

        return (int) Double.parseDouble(str);
    }

    private String getRandomBankCd() {

        String[] arr = {
                "KB",
                "SH",
                "WR",
                "HN",
                "NH",
                "IBK"
        };

        return arr[
                (int) (
                        Math.random()
                                * arr.length
                )
                ];
    }

    private String createRandomAccountNo() {

        return (100 + (int) (Math.random() * 900))
                + "-"
                + (100000 + (int) (Math.random() * 900000))
                + "-"
                + (10 + (int) (Math.random() * 90));
    }

    private String createRandomTelNo() {

        return "042-"
                + (100 + (int) (Math.random() * 900))
                + "-"
                + (1000 + (int) (Math.random() * 9000));
    }

    private Map<String, String> getLatLng(
            String address
    ) {

        try {

            String kakaoKey =
                    "e91015a224888fbe9e2afc3320c22a1b";

            String url =
                    "https://dapi.kakao.com/v2/local/search/address.json?query="
                            + URLEncoder.encode(
                            address,
                            StandardCharsets.UTF_8
                    );

            HttpHeaders headers =
                    new HttpHeaders();

            headers.set(
                    "Authorization",
                    "KakaoAK " + kakaoKey
            );

            HttpEntity<String> entity =
                    new HttpEntity<>(headers);

            ResponseEntity<Map> response =
                    rt.exchange(
                            url,
                            HttpMethod.GET,
                            entity,
                            Map.class
                    );

            Map body = response.getBody();

            if (body == null) {
                return null;
            }

            List<Map<String, Object>> docs =
                    (List<Map<String, Object>>)
                            body.get("documents");

            if (docs == null || docs.isEmpty()) {
                return null;
            }

            Map<String, Object> first =
                    docs.get(0);

            Map<String, String> result =
                    new HashMap<>();

            result.put(
                    "lat",
                    String.valueOf(first.get("y"))
            );

            result.put(
                    "lng",
                    String.valueOf(first.get("x"))
            );

            return result;

        } catch (Exception e) {

            log.error(
                    "좌표 조회 실패 : {}",
                    address,
                    e
            );

            return null;
        }
    }

    @Override
    @Transactional
    public void saveApartment(AptManageDetailDTO dto) {
        AptComplexVO complex = dto.getComplex();
        int exists = aptMapper.existsApt(complex.getAptCmplexNo());
        if (exists > 0) {
            updateApartment(dto);
        } else {
            registerApartment(dto);
        }
    }

    private void registerApartment(
            AptManageDetailDTO dto
    ) {

        AptComplexVO complex =
                dto.getComplex();

        List<AptUnitVO> unitList =
                dto.getUnitList();

        // 단지
        AptComplexEntity apt =
                new AptComplexEntity();

        apt.setAptCmplexNo(
                complex.getAptCmplexNo()
        );

        apt.setAptCmplexNm(
                complex.getAptCmplexNm()
        );

        apt.setBjdCd(
                complex.getBjdCd()
        );

        apt.setSidoNm(
                complex.getSidoNm()
        );

        apt.setSigunguNm(
                complex.getSigunguNm()
        );

        apt.setEmdNm(
                complex.getEmdNm()
        );

        apt.setLatVal(
                complex.getLatVal() == null
                        ? 0
                        : complex.getLatVal().doubleValue()
        );

        apt.setLonVal(
                complex.getLonVal() == null
                        ? 0
                        : complex.getLonVal().doubleValue()
        );

        apt.setUnitCnt(
                complex.getUnitCnt()
        );

        apt.setBldYr(
                complex.getBldYr()
        );

        apt.setCnscoNm(
                complex.getCnscoNm()
        );

        apt.setHeatTy(
                complex.getHeatTy()
        );

        apt.setPkgCnt(
                complex.getPkgCnt()
        );

        apt.setMaxFloor(
                complex.getMaxFloor()
        );

        apt.setDongCnt(
                complex.getDongCnt()
        );

        apt.setDorojuso(
                complex.getDorojuso()
        );

        apt.setCcCnt(
                safeParseInt(
                        complex.getCcCnt()
                )
        );

        aptMapper.insertApt(
                apt
        );

        // 관리사무소
        String mgmtOfcNo =
                seqService.getMgmtSeq();

        MgmtOfficeEntity mgmt =
                new MgmtOfficeEntity();

        mgmt.setMgmtOfcNo(
                mgmtOfcNo
        );

        mgmt.setAptCmplexNo(
                complex.getAptCmplexNo()
        );

        mgmt.setMgmtOfcNm(
                complex.getAptCmplexNm()
                        + " 관리사무소"
        );

        mgmt.setMgmtOfcTelno(
                createRandomTelNo()
        );

        String bankCd =
                getRandomBankCd();

        mgmt.setMgmtOfcBankCd(
                bankCd
        );

        mgmt.setMgmtOfcAcntNo(
                createRandomAccountNo()
        );

        mgmt.setMgmtOfcAcntHldrNm(
                complex.getAptCmplexNm()
                        + " 관리사무소"
        );

        aptMapper.insertMgmtOffice(
                mgmt
        );

        aptMapper.insertMgmtOfficeBank(
                mgmt
        );

        // Member
        String userNo =
                seqService.getMemberSeq();

        MemberVO member =
                new MemberVO();

        member.setUserNo(userNo);

        member.setUserId(
                complex.getAptCmplexNo()
        );

        member.setUserPw(
                passwordEncoder.encode("1234")
        );

        member.setUserNm(
                complex.getAptCmplexNm()
                        + "_관리소장"
        );

        member.setUserTelno(
                mgmt.getMgmtOfcTelno()
        );

        member.setUserRrno(
                "1234561234567"
        );

        aptMapper.insertMember(member);

        // Manager
        ManagerVO manager =
                new ManagerVO();

        manager.setUserNo(
                userNo
        );

        manager.setMgmtOfcNo(
                mgmtOfcNo
        );

        manager.setMngrDutyCd(
                "HEAD"
        );

        aptMapper.insertManager(
                manager
        );
        // Auth
        AuthVO auth =
                new AuthVO();

        auth.setUserNo(
                userNo
        );

        auth.setAuth(
                "ROLE_MNGR"
        );

        aptMapper.insertAuth(
                auth
        );
        // AptUnit
        if(!unitList.isEmpty()){

            aptMapper.insertAptUnitBatch(
                    unitList
            );
        }
        // AptHoTy
        AptHoTyDTO hoType =
                new AptHoTyDTO();

        hoType.setHoTyNo(
                complex.getAptCmplexNo()
                        + "_1"
        );

        hoType.setAptCmplexNo(
                complex.getAptCmplexNo()
        );

        hoType.setTyNm("A타입");
        hoType.setExclusiveSize("84");
        hoType.setRoomCnt(3);
        hoType.setBathroomCnt(2);

        aptMapper.insertAptHoTy(hoType);
        for(AptUnitVO unit : unitList){
            UpdateBuildingStructureDTO
                    structureDto =
                    new UpdateBuildingStructureDTO();
            structureDto.setDongNo(
                    unit.getDongNo()
            );
            structureDto.setDongNm(
                    unit.getDongNm()
            );
            structureDto.setAptCmplexNo(
                    unit.getAptCmplexNo()
            );
            structureDto.setTotalFloor(
                    unit.getFloor()
            );
            structureDto.setHoPerFloor(
                    unit.getFloor() > 0
                            ? unit.getUnitCnt()
                            / unit.getFloor()
                            : 0
            );
            mgmtAptComplexEditService
                    .updateBuildingStructure(
                            structureDto
                    );
        }
    }

    private void updateApartment(
            AptManageDetailDTO dto
    ) {

        for (AptUnitVO unit
                : dto.getUnitList()) {

            int cnt1 = aptMapper.updateUnit(unit);

            log.info(
                    "updateUnit result={}",
                    cnt1
            );

            UpdateBuildingStructureDTO structureDto =
                    new UpdateBuildingStructureDTO();

            structureDto.setDongNo(unit.getDongNo());
            structureDto.setDongNm(unit.getDongNm());
            structureDto.setAptCmplexNo(unit.getAptCmplexNo());

            structureDto.setTotalFloor(unit.getFloor());

            structureDto.setHoPerFloor(
                    unit.getFloor() > 0
                            ? unit.getUnitCnt()
                            / unit.getFloor()
                            : 0
            );

            mgmtAptComplexEditService
                    .updateBuildingStructure(
                            structureDto
                    );
        }

        int cnt2 =
                aptMapper.updateComplex(
                        dto.getComplex()
                );

        log.info(
                "updateComplex result={}",
                cnt2
        );
    }


}