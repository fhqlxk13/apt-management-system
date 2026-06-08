package kr.or.ddit.domain.apt.mgmtOffice.facility.publicFacility.service;

import com.google.api.services.drive.Drive;
import kr.or.ddit.common.api.google.service.GoogleDriveService;
import kr.or.ddit.common.file.mapper.IAttachFileMapper;
import kr.or.ddit.common.file.vo.AttachFileVO;
import kr.or.ddit.domain.apt.mgmtOffice.contract.service.IFacilityContractService;
import kr.or.ddit.domain.apt.mgmtOffice.facility.publicFacility.dto.PublicFacilityFormDTO;
import kr.or.ddit.domain.apt.mgmtOffice.facility.publicFacility.mapper.IPublicFacilityMapper;
import kr.or.ddit.domain.apt.mgmtOffice.facility.publicFacility.vo.PublicFacilityVO;
import kr.or.ddit.domain.apt.mgmtOffice.facility.vo.FacilityVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import java.util.*;

/**
 * 편의시설 Service 구현체
 * - Controller 요청을 받아 편의시설 업무 흐름 처리
 * - FACILITY 신규 등록 / 기존 FACILITY 연결 / PUBLIC_FACILITY 등록 분기 담당
 * - ATTACH_FILE 직접 SQL은 기존 IAttachFileMapper를 사용
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class PublicFacilityServiceImpl implements IPublicFacilityService {

    /** 편의시설 Mapper */
    private final IPublicFacilityMapper publicFacilityMapper;

    /** 공통 첨부파일 Mapper */
    private final IAttachFileMapper attachFileMapper;

    /** Google Drive 업로드/삭제 Service */
    private final GoogleDriveService googleDriveService;

    /** 설치계약 시설 연결 Service */
    private final IFacilityContractService facilityContractService;

    /** 기존 시설자산 선택 등록 모드 */
    private static final String REGISTER_MODE_EXISTING = "EXISTING";

    /** 새 시설자산 등록 모드 */
    private static final String REGISTER_MODE_NEW = "NEW";

    /** 편의 위치 구분값 */
    private static final String LOCATION_TYPE_COMMON = "COMMON";

    /** 기본 사용여부 */
    private static final String DEFAULT_USE_YN = "Y";

    /** 시설 사진 파일 카테고리 */
    private static final String FACILITY_FILE_CATEGORY = "시설사진";

    /**
     * 운영관리 미등록 시설자산 후보 목록 조회
     * - 편의시설 등록 화면의 시설자산 선택 모달에서 사용
     */
    @Override
    public List<FacilityVO> selectFacilityCandidateList(String mgmtOfcNo) {
        // 관리사무소 번호 기준으로 후보 시설 목록 조회
        return publicFacilityMapper.selectFacilityCandidateList(mgmtOfcNo);
    }

    /**
     * 편의시설 목록 조회
     * - AG Grid rowData용 목록 조회
     */
    @Override
    public List<PublicFacilityVO> selectPublicFacilityList(Map<String, Object> paramMap) {
        // 검색 조건 Map을 그대로 Mapper에 전달
        return publicFacilityMapper.selectPublicFacilityList(paramMap);
    }

    /**
     * 편의시설 상세 조회
     * - 상세/수정 화면에서 공통으로 사용
     */
    @Override
    public PublicFacilityVO selectPublicFacilityDetail(Map<String, Object> paramMap) {
        // 편의시설번호 + 관리사무소번호 기준 단건 조회
        return publicFacilityMapper.selectPublicFacilityDetail(paramMap);
    }

    /**
     * 편의시설 등록 처리
     * - EXISTING: 기존 시설자산 선택 후 PUBLIC_FACILITY만 등록
     * - NEW: FACILITY 먼저 등록 후 PUBLIC_FACILITY 등록
     * - 트랜잭션으로 묶어서 중간 실패 시 전체 rollback
     */
    @Override
    @Transactional
    public String insertPublicFacility(PublicFacilityFormDTO formDTO, List<MultipartFile> facilityFiles, String userNo) {
        // 요청값 기본값 정리
        normalizeInsertForm(formDTO);

        // 관리사무소번호 기준 아파트단지번호 조회
        String aptCmplexNo = publicFacilityMapper.selectAptCmplexNoByMgmtOfcNo(formDTO.getMgmtOfcNo());
        if (!StringUtils.hasText(aptCmplexNo)) {
            throw new IllegalArgumentException("관리사무소에 연결된 아파트단지번호를 찾을 수 없습니다.");
        }

        // 등록 방식에 따라 FACILITY 번호 확보
        String facilityNo = resolveFacilityNoForInsert(formDTO, aptCmplexNo);

        // 동일 시설자산이 이미 운영관리 대상으로 등록되어 있는지 확인
        int existsCount = publicFacilityMapper.selectPublicFacilityExistsByFacilityNo(facilityNo);
        if (existsCount > 0) {
            throw new IllegalStateException("이미 편의시설 운영관리에 등록된 시설자산입니다.");
        }

        // 신규 편의시설번호 생성
        String cmnFacilityNo = publicFacilityMapper.selectNextCmnFacilityNo();

        // PUBLIC_FACILITY 등록 파라미터 생성
        Map<String, Object> publicFacilityParam = createPublicFacilityParam(formDTO, aptCmplexNo, facilityNo, cmnFacilityNo);

        // PUBLIC_FACILITY 등록 처리
        publicFacilityMapper.insertPublicFacility(publicFacilityParam);

        // ***# 새 시설자산 설치계약 시설번호 연결
        connectInstallContractForNewFacility(formDTO, facilityNo);

        // 시설 사진 추가/삭제 처리
        processFacilityFiles(facilityNo, facilityFiles, formDTO.getDeleteFileUuids(), userNo);

        // 등록 후 Controller에 편의시설번호 반환
        return cmnFacilityNo;
    }

    /**
     * 편의시설 수정 처리
     * - PUBLIC_FACILITY 운영정보 수정
     * - 사진 처리 기준은 연결된 FACILITY.FILE_GROUP_NO
     */
    @Override
    @Transactional
    public void updatePublicFacility(PublicFacilityFormDTO formDTO, List<MultipartFile> facilityFiles, String userNo) {
        // 수정 대상 편의시설번호 확인
        if (!StringUtils.hasText(formDTO.getCmnFacilityNo())) {
            throw new IllegalArgumentException("편의시설번호가 없습니다.");
        }

        // 수정 대상 상세 조회 조건 생성
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("mgmtOfcNo", formDTO.getMgmtOfcNo());
        paramMap.put("cmnFacilityNo", formDTO.getCmnFacilityNo());

        // 기존 상세 조회로 연결된 facilityNo 확인
        PublicFacilityVO detail = publicFacilityMapper.selectPublicFacilityDetail(paramMap);
        if (detail == null) {
            throw new IllegalArgumentException("수정할 편의시설을 찾을 수 없습니다.");
        }

        // 화면에서 facilityNo가 넘어오지 않아도 상세 조회값으로 보정
        formDTO.setFacilityNo(detail.getFacilityNo());

        // PUBLIC_FACILITY 운영정보 수정
        publicFacilityMapper.updatePublicFacility(formDTO);

        // 시설 사진 추가/삭제 처리
        processFacilityFiles(detail.getFacilityNo(), facilityFiles, formDTO.getDeleteFileUuids(), userNo);
    }

    /**
     * 편의시설 삭제 처리
     * - 현재는 PUBLIC_FACILITY 연결 데이터 삭제 기준
     * - FACILITY와 ATTACH_FILE은 유지
     */
    @Override
    @Transactional
    public void deletePublicFacility(Map<String, Object> paramMap) {
        // 삭제 대상 편의시설 존재 여부 확인
        PublicFacilityVO detail = publicFacilityMapper.selectPublicFacilityDetail(paramMap);
        if (detail == null) {
            throw new IllegalArgumentException("삭제할 편의시설을 찾을 수 없습니다.");
        }

        // PUBLIC_FACILITY 삭제 처리
        publicFacilityMapper.deletePublicFacility(paramMap);
    }

    /**
     * 등록 요청값 기본값 정리
     * - registerMode 미입력 시 EXISTING 처리
     * - useYn 미입력 시 Y 처리
     * - COMMON 위치 선택 시 dongNo 제거
     */
    private void normalizeInsertForm(PublicFacilityFormDTO formDTO) {
        // 등록 방식 기본값 처리
        if (!StringUtils.hasText(formDTO.getRegisterMode())) {
            formDTO.setRegisterMode(REGISTER_MODE_EXISTING);
        }

        // 새 시설자산 사용여부 기본값 처리
        if (!StringUtils.hasText(formDTO.getUseYn())) {
            formDTO.setUseYn(DEFAULT_USE_YN);
        }

        // ***# 설치계약 연결값 기본값 처리
        if (!REGISTER_MODE_NEW.equals(formDTO.getRegisterMode())) {
            formDTO.setInstallContractYn("N");
            formDTO.setInstallContractNo(null);
        } else if (!"Y".equals(formDTO.getInstallContractYn())) {
            formDTO.setInstallContractYn("N");
            formDTO.setInstallContractNo(null);
        } else if (!StringUtils.hasText(formDTO.getInstallContractNo())) {
            throw new IllegalArgumentException("설치계약이 있는 경우 설치계약을 선택하세요.");
        }

        // 편의 위치 선택 시 동번호는 DB에 저장하지 않음
        if (LOCATION_TYPE_COMMON.equals(formDTO.getLocationType())) {
            formDTO.setDongNo(null);
        }
    }

    /**
     * 새 시설자산 설치계약 연결
     * - NEW 모드에서 설치계약 있음 선택 시 계약관리 설치공사에 시설번호 반영
     */
    private void connectInstallContractForNewFacility(PublicFacilityFormDTO formDTO, String facilityNo) {
        // ***# 새 시설자산 설치계약 연결 조건
        if (!REGISTER_MODE_NEW.equals(formDTO.getRegisterMode()) || !"Y".equals(formDTO.getInstallContractYn())) {
            return;
        }

        facilityContractService.connectInstallContractToFacility(formDTO.getInstallContractNo(), facilityNo);
    }

    /**
     * 등록 방식에 따른 시설번호 확보
     * - EXISTING: 화면에서 선택한 facilityNo 사용
     * - NEW: 신규 facilityNo 생성 후 FACILITY insert
     */
    private String resolveFacilityNoForInsert(PublicFacilityFormDTO formDTO, String aptCmplexNo) {
        // 새 시설자산 등록 모드 처리
        if (REGISTER_MODE_NEW.equals(formDTO.getRegisterMode())) {
            return insertNewFacility(formDTO, aptCmplexNo);
        }

        // 기존 시설자산 선택 모드 처리
        if (!StringUtils.hasText(formDTO.getFacilityNo())) {
            throw new IllegalArgumentException("기존 시설자산을 선택해 주세요.");
        }

        return formDTO.getFacilityNo();
    }

    /**
     * 새 시설자산 등록
     * - 편의시설 등록 화면의 NEW 탭에서 입력한 FACILITY 정보를 저장
     */
    private String insertNewFacility(PublicFacilityFormDTO formDTO, String aptCmplexNo) {
        // 신규 시설번호 생성
        String facilityNo = publicFacilityMapper.selectNextFacilityNo();

        // FACILITY 등록 파라미터 생성
        Map<String, Object> facilityParam = new HashMap<>();
        facilityParam.put("facilityNo", facilityNo);                    // 시설번호
        facilityParam.put("facilityTyCd", formDTO.getFacilityTyCd());   // 시설유형코드
        facilityParam.put("facilityNm", formDTO.getFacilityNm());       // 시설명
        facilityParam.put("aptCmplexNo", aptCmplexNo);                  // 아파트단지번호
        facilityParam.put("dongNo", formDTO.getDongNo());               // 동번호
        facilityParam.put("locCn", formDTO.getLocCn());                 // 상세위치
        facilityParam.put("useYn", formDTO.getUseYn());                 // 사용여부
        facilityParam.put("fileGroupNo", null);                         // 사진 저장 시 최초 1회 update로 연결

        // FACILITY 등록 처리
        publicFacilityMapper.insertFacility(facilityParam);

        return facilityNo;
    }

    /**
     * PUBLIC_FACILITY 등록 파라미터 생성
     * - DB insert에 필요한 값만 Map으로 구성
     */
    private Map<String, Object> createPublicFacilityParam(
            PublicFacilityFormDTO formDTO,
            String aptCmplexNo,
            String facilityNo,
            String cmnFacilityNo
    ) {
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("cmnFacilityNo", cmnFacilityNo);                     // 편의시설번호
        paramMap.put("aptCmplexNo", aptCmplexNo);                         // 아파트단지번호
        paramMap.put("facilityNo", facilityNo);                           // 시설번호
        paramMap.put("cmnFacilityNm", formDTO.getCmnFacilityNm());         // 편의시설명
        paramMap.put("cmnFacilityCn", formDTO.getCmnFacilityCn());         // 편의시설 안내/내용
        paramMap.put("cmnFacilityAmt", formDTO.getCmnFacilityAmt());       // 이용요금
        paramMap.put("cmnFacilityRsvYn", formDTO.getCmnFacilityRsvYn());   // 예약여부
        paramMap.put("cmnFacilityOprHr", formDTO.getCmnFacilityOprHr());   // 운영시간
        return paramMap;
    }

    /**
     * 시설 사진 처리
     * - 편의시설 화면에서 업로드하더라도 저장 기준은 FACILITY.FILE_GROUP_NO
     * - ATTACH_FILE 조회/삭제/채번/insert는 기존 IAttachFileMapper 사용
     *
     * 처리 순서
     * 1. 파일 처리 요청이 있으면 FACILITY 단건 조회
     * 2. 삭제 요청 UUID가 있으면 기존 파일을 Google Drive 휴지통 이동 후 ATTACH_FILE 삭제
     * 3. 신규 업로드 파일이 있으면 FACILITY.FILE_GROUP_NO 확인
     * 4. FILE_GROUP_NO가 없으면 IAttachFileMapper.getSeqFileGroupNo()로 신규 채번 후 FACILITY에 연결
     * 5. Google Drive 업로드 후 ATTACH_FILE INSERT
     */
    private void processFacilityFiles(String facilityNo, List<MultipartFile> facilityFiles, String deleteFileUuids, String userNo) {
        // 업로드 파일 존재 여부 확인
        boolean hasUploadFiles = hasUploadFiles(facilityFiles);

        // 삭제 요청 존재 여부 확인
        boolean hasDeleteFiles = StringUtils.hasText(deleteFileUuids);

        // 파일 처리 요청이 없으면 종료
        if (!hasUploadFiles && !hasDeleteFiles) {
            return;
        }

        // 시설번호 기준 FACILITY 정보 조회
        FacilityVO facilityVO = publicFacilityMapper.selectFacilityForFile(facilityNo);
        if (facilityVO == null) {
            throw new IllegalArgumentException("사진을 연결할 시설자산을 찾을 수 없습니다.");
        }

        // 현재 시설자산 파일그룹번호 세팅
        Long fileGroupNo = facilityVO.getFileGroupNo();

        // 삭제 요청 먼저 처리
        if (hasDeleteFiles) {
            deleteFacilityFiles(fileGroupNo, deleteFileUuids);
        }

        // 신규 업로드 파일이 없으면 삭제 처리만 하고 종료
        if (!hasUploadFiles) {
            return;
        }

        // 파일그룹번호가 없으면 기존 파일 Mapper에서 신규 채번 후 FACILITY에 연결
        if (fileGroupNo == null) {
            fileGroupNo = attachFileMapper.getSeqFileGroupNo();
            facilityVO.setFileGroupNo(fileGroupNo);
            publicFacilityMapper.updateFacilityFileGroupNo(facilityNo, fileGroupNo);
        }

        // 신규 시설 사진 업로드 처리
        uploadFacilityFiles(facilityVO, facilityFiles, userNo);
    }

    /**
     * 업로드 파일 존재 여부 확인
     * - null 파일과 빈 파일은 제외
     */
    private boolean hasUploadFiles(List<MultipartFile> facilityFiles) {
        // 파일 목록 자체가 없으면 false
        if (facilityFiles == null || facilityFiles.isEmpty()) {
            return false;
        }

        // 실제 업로드 가능한 파일이 하나라도 있으면 true
        return facilityFiles.stream().anyMatch(file -> file != null && !file.isEmpty());
    }

    /**
     * 시설 첨부파일 삭제
     * - deleteFileUuids 문자열은 콤마 구분으로 전달됨
     * - Google Drive 휴지통 이동 후 기존 IAttachFileMapper.deleteOne으로 ATTACH_FILE 레코드 삭제
     */
    private void deleteFacilityFiles(Long fileGroupNo, String deleteFileUuids) {
        // 파일그룹번호가 없으면 삭제할 첨부파일도 없음
        if (fileGroupNo == null || !StringUtils.hasText(deleteFileUuids)) {
            return;
        }

        Drive drive = null;

        try {
            // Google Drive 서비스 객체 생성
            drive = googleDriveService.getDriveService();

            // 콤마 구분 UUID 반복 처리
            for (String rawUuid : deleteFileUuids.split(",")) {
                String fileSaveUuid = rawUuid == null ? "" : rawUuid.trim();

                // 빈 UUID는 무시
                if (!StringUtils.hasText(fileSaveUuid)) {
                    continue;
                }

                // 기존 파일 Mapper로 삭제 대상 파일 조회
                AttachFileVO file = attachFileMapper.getAttachFile(String.valueOf(fileGroupNo), fileSaveUuid);
                if (file == null) {
                    continue;
                }

                // Google Drive 파일이 있으면 휴지통 이동
                if (StringUtils.hasText(file.getGoogleId())) {
                    googleDriveService.moveToTrash(drive, file.getGoogleId());

                    // ATTACH_FILE 레코드 삭제
                    attachFileMapper.deleteOne(file.getGoogleId());
                }
            }
        } catch (Exception e) {
            log.error("편의시설 시설사진 삭제 오류 - fileGroupNo={}, deleteFileUuids={}", fileGroupNo, deleteFileUuids, e);
            throw new RuntimeException(e.getMessage(), e);
        }
    }

    /**
     * 시설 첨부파일 업로드
     * - 기존 시설자산관리 uploadFacilityFiles 로직 이식
     * - 저장 기준: FACILITY.FILE_GROUP_NO
     * - 파일 카테고리: 시설사진
     *
     * 처리 순서
     * 1. Google Drive 서비스 객체 생성
     * 2. Google Drive 업로드
     * 3. ATTACH_FILE INSERT용 VO 생성
     * 4. ATTACH_FILE INSERT
     * 5. 중간 실패 시 이미 업로드된 Google Drive 파일 휴지통 이동
     */
    private void uploadFacilityFiles(FacilityVO facilityVO, List<MultipartFile> facilityFiles, String userNo) {
        // 업로드할 파일이 없으면 종료
        if (!hasUploadFiles(facilityFiles)) {
            return;
        }

        // 파일그룹번호 없으면 업로드 불가
        if (facilityVO.getFileGroupNo() == null) {
            throw new IllegalStateException("시설 사진을 저장할 파일그룹번호가 없습니다.");
        }

        // 롤백용 Google Drive ID 목록
        List<String> uploadedGoogleIds = new ArrayList<>();

        // catch 블록에서도 사용하기 위한 Drive 객체
        Drive drive = null;

        try {
            // Google Drive 서비스 객체 생성
            drive = googleDriveService.getDriveService();

            // ATTACH_FILE INSERT용 정렬 순서
            int sortOrder = 0;

            // 파일 목록 반복 처리
            for (MultipartFile multipartFile : facilityFiles) {
                // null 또는 빈 파일 제외
                if (multipartFile == null || multipartFile.isEmpty()) {
                    continue;
                }

                // 원본 파일명 보정
                String originalFilename = StringUtils.hasText(multipartFile.getOriginalFilename())
                        ? multipartFile.getOriginalFilename()
                        : "facility_image";

                // 저장 파일명 생성
                String uuid = UUID.randomUUID().toString().replace("-", "");
                String savedFileName = uuid + "_" + originalFilename;

                // Google Drive 폴더 경로 생성
                String folderPath = createFacilityFolderPath(facilityVO, userNo);

                // DB 저장용 전체 경로
                String fullPath = folderPath + "/" + savedFileName;

                // Google Drive 업로드
                String googleId = googleDriveService.uploadFile(
                        multipartFile,
                        folderPath,
                        savedFileName
                );

                // 롤백용 Google Drive ID 저장
                uploadedGoogleIds.add(googleId);

                // ATTACH_FILE VO 생성
                AttachFileVO file = AttachFileVO.fileSettings(
                        multipartFile,
                        facilityVO.getFileGroupNo(),
                        FACILITY_FILE_CATEGORY,
                        savedFileName,
                        googleId,
                        fullPath,
                        sortOrder++
                );

                // ATTACH_FILE INSERT
                attachFileMapper.insertAttachFile(file);
            }
        } catch (Exception e) {
            log.error("편의시설 시설사진 업로드 오류 - facilityNo={}", facilityVO.getFacilityNo(), e);

            // 이미 업로드된 Google Drive 파일 롤백
            if (drive != null && !uploadedGoogleIds.isEmpty()) {
                for (String googleId : uploadedGoogleIds) {
                    try {
                        googleDriveService.moveToTrash(drive, googleId);
                    } catch (Exception rollbackEx) {
                        log.error("편의시설 시설사진 롤백 실패 googleId={}", googleId, rollbackEx);
                    }
                }
            }

            throw new RuntimeException(e.getMessage(), e);
        }
    }

    /**
     * Google Drive 시설 사진 폴더 경로 생성
     * - 저장 기준은 DB의 FACILITY.FILE_GROUP_NO
     * - 경로는 Drive 폴더 정리용
     */
    private String createFacilityFolderPath(FacilityVO facilityVO, String userNo) {
        // 시설유형코드 보정
        String facilityTyCd = StringUtils.hasText(facilityVO.getFacilityTyCd())
                ? facilityVO.getFacilityTyCd()
                : "ETC";

        // 아파트단지번호 보정
        String aptCmplexNo = StringUtils.hasText(facilityVO.getAptCmplexNo())
                ? facilityVO.getAptCmplexNo()
                : "unknownApt";

        // 업로드 사용자번호 보정
        String uploadUserNo = StringUtils.hasText(userNo)
                ? userNo
                : "unknownUser";

        return "apt/facility/"
                + uploadUserNo + "/"
                + aptCmplexNo + "/"
                + facilityTyCd + "/"
                + facilityVO.getFacilityNo();
    }

    /**
     * 편의시설 동 옵션 조회
     * - 목록 필터의 동 select 구성용
     */
    @Override
    public List<PublicFacilityVO> selectPublicFacilityDongOptionList(String mgmtOfcNo) {
        // 관리사무소 번호 기준 동 옵션 조회
        return publicFacilityMapper.selectPublicFacilityDongOptionList(mgmtOfcNo);
    }

    /**
     * 편의시설 위치 옵션 조회
     * - 동 선택값 기준 위치 select 구성용
     */
    @Override
    public List<String> selectPublicFacilityLocationOptionList(Map<String, Object> paramMap) {
        // 관리사무소 번호와 동 번호 기준 위치 옵션 조회
        return publicFacilityMapper.selectPublicFacilityLocationOptionList(paramMap);
    }

    /**
     * 편의시설명 자동완성 조회
     * - 검색어 일부 입력 시 편의시설명 후보 조회
     */
    @Override
    public List<String> selectPublicFacilityNameSuggestList(Map<String, Object> paramMap) {
        // 관리사무소 번호와 검색어 기준 편의시설명 후보 조회
        return publicFacilityMapper.selectPublicFacilityNameSuggestList(paramMap);
    }

}
