package kr.or.ddit.domain.apt.mgmtOffice.facility.check.service;

import kr.or.ddit.common.model.PaginationInfoVO;
import kr.or.ddit.domain.apt.mgmtOffice.facility.check.mapper.IFacilityCheckHstryMapper;
import kr.or.ddit.domain.apt.mgmtOffice.facility.check.vo.FacilityCheckCodeVO;
import kr.or.ddit.domain.apt.mgmtOffice.facility.check.vo.FacilityCheckHstryVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

/**
 * 시설 점검 이력 Service 구현체
 */
@Service
@RequiredArgsConstructor
public class FacilityCheckServiceImpl implements IFacilityCheckService {

    /** 시설 점검 이력 Mapper */
    private final IFacilityCheckHstryMapper facilityCheckHstryMapper;

    /** 시설 점검 이력 목록 건수 조회 */
    @Override
    public int selectFacilityCheckCount(PaginationInfoVO<FacilityCheckHstryVO> pagingVO) {
        return facilityCheckHstryMapper.selectFacilityCheckCount(pagingVO);
    }

    /** 시설 점검 이력 목록 조회 */
    @Override
    public List<FacilityCheckHstryVO> selectFacilityCheckList(PaginationInfoVO<FacilityCheckHstryVO> pagingVO) {
        return facilityCheckHstryMapper.selectFacilityCheckList(pagingVO);
    }

    /** 시설 점검 이력 현황 카드 건수 조회 */
    @Override
    public FacilityCheckHstryVO selectFacilityCheckSummary(String mgmtOfcNo) {
        return facilityCheckHstryMapper.selectFacilityCheckSummary(mgmtOfcNo);
    }

    /** 시설 점검 이력 상세 조회 */
    @Override
    public FacilityCheckHstryVO selectFacilityCheckDetail(String mgmtOfcNo, String facChkHstryNo) {
        return facilityCheckHstryMapper.selectFacilityCheckDetail(mgmtOfcNo, facChkHstryNo);
    }

    /** 오늘의 이용제한 점검 이력 목록 조회 */
    @Override
    public List<FacilityCheckHstryVO> selectTodayUseRestrictList(String mgmtOfcNo) {
        return facilityCheckHstryMapper.selectTodayUseRestrictList(mgmtOfcNo);
    }

    /** [추가] 내일 이후 시작 예정인 이용제한 점검 이력 목록 조회 */
    @Override
    public List<FacilityCheckHstryVO> selectFutureUseRestrictList(String mgmtOfcNo) {
        return facilityCheckHstryMapper.selectFutureUseRestrictList(mgmtOfcNo);
    }

    /** 시설 선택 모달 기본 목록 조회 */
    @Override
    public List<FacilityCheckHstryVO> selectFacilitySelectList(String mgmtOfcNo) {
        return facilityCheckHstryMapper.selectFacilitySelectList(mgmtOfcNo);
    }

    /** 협력업체 선택 모달 기본 목록 조회 */
    @Override
    public List<FacilityCheckHstryVO> selectPartnerSelectList(String mgmtOfcNo) {
        return facilityCheckHstryMapper.selectPartnerSelectList(mgmtOfcNo);
    }

    /** 점검유형 공통코드 목록 조회 */
    @Override
    public List<FacilityCheckCodeVO> selectCheckTypeList() {
        return facilityCheckHstryMapper.selectCommonCodeList("CHECK_TY");
    }

    /** 점검분류 공통코드 목록 조회 */
    @Override
    public List<FacilityCheckCodeVO> selectCheckCategoryList() {
        return facilityCheckHstryMapper.selectCommonCodeList("CHECK_CTGRY");
    }

    /** 점검상태 공통코드 목록 조회 */
    @Override
    public List<FacilityCheckCodeVO> selectCheckStatusList() {
        return facilityCheckHstryMapper.selectCommonCodeList("CHECK_STTS");
    }

    /**
     * 일반 시설자산 유형 목록 조회
     * - 시설 선택 모달 optgroup(일반시설) 렌더링용
     */
    @Override
    public List<FacilityCheckCodeVO> selectAssetFacilityTypeList() {
        return facilityCheckHstryMapper.selectAssetFacilityTypeList();
    }

    /**
     * 편의시설 유형 목록 조회
     * - 시설 선택 모달 optgroup(편의시설) 렌더링용
     */
    @Override
    public List<FacilityCheckCodeVO> selectPublicFacilityTypeList() {
        return facilityCheckHstryMapper.selectPublicFacilityTypeList();
    }

    /**
     * 시설 점검 이력 등록
     * - 자체점검/협력업체점검 기준값 보정
     * - 처리과정번호가 없으면 신규 처리과정번호 생성
     * - 후속 등록은 화면에서 넘어온 기존 처리과정번호 유지
     * - 필수값 검증 후 등록 처리
     */
    @Override
    @Transactional
    public String insertFacilityCheckHistory(FacilityCheckHstryVO facilityCheckHstryVO) {

        // 점검 주체 기준값 보정
        normalizeCheckOwner(facilityCheckHstryVO);

        // 등록 시 처리과정번호 기준값 보정
        normalizeCheckFlowNoForInsert(facilityCheckHstryVO);

        // 이용제한 기준값 보정
        normalizeUseRestriction(facilityCheckHstryVO);

        // 점검 이력 등록 전 필수값 검증
        validateCheckRequired(facilityCheckHstryVO);

        // 시설 점검 이력 등록
        facilityCheckHstryMapper.insertFacilityCheckHistory(facilityCheckHstryVO);

        // selectKey로 채번된 점검이력번호 반환
        return facilityCheckHstryVO.getFacChkHstryNo();
    }

    /**
     * 시설 점검 이력 수정
     * - 자체점검/협력업체점검 기준값 보정
     * - hidden 값 누락 시 기존 처리과정번호 유지
     * - 필수값 검증 후 수정 처리
     */
    @Override
    @Transactional
    public boolean updateFacilityCheckHistory(FacilityCheckHstryVO facilityCheckHstryVO) {

        // 점검 주체 기준값 보정
        normalizeCheckOwner(facilityCheckHstryVO);

        // 수정 시 처리과정번호 기준값 보정
        normalizeCheckFlowNoForUpdate(facilityCheckHstryVO);

        // 이용제한 기준값 보정
        normalizeUseRestriction(facilityCheckHstryVO);

        // 점검 이력 수정 전 필수값 검증
        validateCheckRequired(facilityCheckHstryVO);

        // 시설 점검 이력 수정
        return facilityCheckHstryMapper.updateFacilityCheckHistory(facilityCheckHstryVO) > 0;
    }

    /**
     * 선택한 시설의 기존 점검 이력 목록 조회
     * - 상세/폼 왼쪽 이력 목록, AJAX 갱신 공통 사용
     */
    @Override
    public List<FacilityCheckHstryVO> selectSameFacilityCheckList(String mgmtOfcNo, String facilityNo) {
        return facilityCheckHstryMapper.selectSameFacilityCheckList(mgmtOfcNo, facilityNo);
    }

    /** 시설 선택 모달 서버 검색 목록 조회 */
    @Override
    public List<FacilityCheckHstryVO> selectFacilitySearchList(FacilityCheckHstryVO searchVO) {
        return facilityCheckHstryMapper.selectFacilitySearchList(searchVO);
    }

    /** 협력업체 선택 모달 서버 검색 목록 조회 */
    @Override
    public List<FacilityCheckHstryVO> selectPartnerSearchList(FacilityCheckHstryVO searchVO) {
        return facilityCheckHstryMapper.selectPartnerSearchList(searchVO);
    }

    /**
     * 점검 주체 기준값 보정
     * - SELF 선택 시 협력업체번호 제거
     * - PARTNER 선택 시 협력업체번호 유지
     * - 점검 주체가 비어 있으면 partnerNo 기준 자동 판단
     */
    private void normalizeCheckOwner(FacilityCheckHstryVO checkVO) {

        // 요청 객체 없음
        if (checkVO == null) {
            return;
        }

        // 점검 주체 미선택 시 partnerNo 기준 자동 판단
        if (isBlank(checkVO.getChkOwnerType())) {
            if (isBlank(checkVO.getPartnerNo())) {
                checkVO.setChkOwnerType("SELF");
            } else {
                checkVO.setChkOwnerType("PARTNER");
            }
        }

        // 자체점검 선택 시 협력업체번호 제거
        if ("SELF".equals(checkVO.getChkOwnerType())) {
            checkVO.setPartnerNo(null);
        }
    }

    /**
     * 등록 시 처리과정번호 기준값 보정
     * - DONE 단건 완료는 처리과정번호를 생성하지 않음
     * - WAIT/ING/FAULT 등 진행 상태는 새 처리과정번호 생성
     * - 후속 등록은 화면에서 넘어온 기존 처리과정번호 유지
     */
    private void normalizeCheckFlowNoForInsert(FacilityCheckHstryVO checkVO) {

        // 요청 객체 없음
        if (checkVO == null) {
            return;
        }

        // 처리과정번호가 이미 있으면 후속 등록이므로 그대로 유지
        if (!isBlank(checkVO.getChkFlowNo())) {
            return;
        }

        // 완료 상태는 단건 완료 이력으로 보고 처리과정번호를 생성하지 않음
        if ("DONE".equals(checkVO.getChkSttsCd())) {
            return;
        }

        // 완료가 아닌 상태는 상태 흐름 추적 대상이므로 새 FCF 번호 생성
        checkVO.setChkFlowNo(facilityCheckHstryMapper.selectNextCheckFlowNo());
    }

    /**
     * 수정 시 처리과정번호 기준값 보정
     * - hidden 값 누락으로 처리과정번호가 null 저장되는 것을 방지
     * - 기존 상세 조회 후 기존 처리과정번호 유지
     */
    private void normalizeCheckFlowNoForUpdate(FacilityCheckHstryVO checkVO) {

        // 요청 객체 없음
        if (checkVO == null) {
            return;
        }

        // 처리과정번호가 있으면 그대로 사용
        if (!isBlank(checkVO.getChkFlowNo())) {
            return;
        }

        // 수정 기준값 없음
        if (isBlank(checkVO.getMgmtOfcNo()) || isBlank(checkVO.getFacChkHstryNo())) {
            return;
        }

        // 기존 이력 상세 조회
        FacilityCheckHstryVO savedCheck =
                facilityCheckHstryMapper.selectFacilityCheckDetail(
                        checkVO.getMgmtOfcNo(),
                        checkVO.getFacChkHstryNo()
                );

        // 기존 처리과정번호 유지
        if (savedCheck != null && !isBlank(savedCheck.getChkFlowNo())) {
            checkVO.setChkFlowNo(savedCheck.getChkFlowNo());
        }
    }

    /**
     * 이용제한 기준값 보정
     * - 미선택 시 N으로 저장
     * - 제한 없음이면 시작/종료일시를 저장하지 않음
     */
    private void normalizeUseRestriction(FacilityCheckHstryVO checkVO) {
        if (checkVO == null) {
            return;
        }

        if (isBlank(checkVO.getUseRestrictYn())) {
            checkVO.setUseRestrictYn("N");
        }

        if (!"Y".equals(checkVO.getUseRestrictYn())) {
            checkVO.setUseRestrictYn("N");
            checkVO.setUseRestrictBgngDt(null);
            checkVO.setUseRestrictEndDt(null);
        }
    }

    /**
     * 시설 점검 이력 필수값 검증
     * - 화면 JS 검증을 우회해도 서버에서 빈 값 저장을 막기 위한 검증
     * - 자체점검은 partnerNo 없이 등록 가능
     * - 협력업체점검은 partnerNo 필수
     */
    private void validateCheckRequired(FacilityCheckHstryVO checkVO) {

        // 요청 객체 검증
        if (checkVO == null) {
            throw new IllegalArgumentException("시설 점검 이력 정보가 없습니다.");
        }

        // 시설번호 필수 검증
        if (isBlank(checkVO.getFacilityNo())) {
            throw new IllegalArgumentException("점검 대상 시설을 선택해 주세요.");
        }

        // 진행 상태 이력의 처리과정번호 필수 검증
        // - DONE 단건 완료는 처리과정번호 없이 저장 가능
        // - WAIT/ING/FAULT 등 완료가 아닌 상태는 처리과정번호 필요
        if (!"DONE".equals(checkVO.getChkSttsCd()) && isBlank(checkVO.getChkFlowNo())) {
            throw new IllegalArgumentException("진행 중인 점검 이력은 처리과정번호가 필요합니다.");
        }

        // 협력업체점검 업체번호 필수 검증
        if ("PARTNER".equals(checkVO.getChkOwnerType()) && isBlank(checkVO.getPartnerNo())) {
            throw new IllegalArgumentException("협력업체 점검은 협력업체를 선택해 주세요.");
        }

        // 점검분류 필수 검증
        if (isBlank(checkVO.getChkCtgryCd())) {
            throw new IllegalArgumentException("점검분류를 선택해 주세요.");
        }

        // 작업유형 필수 검증
        if (isBlank(checkVO.getChkTyCd())) {
            throw new IllegalArgumentException("작업유형을 선택해 주세요.");
        }

        // 점검상태 필수 검증
        if (isBlank(checkVO.getChkSttsCd())) {
            throw new IllegalArgumentException("점검상태를 선택해 주세요.");
        }

        // 점검일자 필수 검증
        if (isBlank(checkVO.getChkDt())) {
            throw new IllegalArgumentException("점검일자를 입력해 주세요.");
        }

        // 점검내용 필수 검증
        if (isBlank(checkVO.getChkCn())) {
            throw new IllegalArgumentException("점검내용을 입력해 주세요.");
        }

        // 이용제한 일시 필수 검증
        if ("Y".equals(checkVO.getUseRestrictYn())
                && (isBlank(checkVO.getUseRestrictBgngDt()) || isBlank(checkVO.getUseRestrictEndDt()))) {
            throw new IllegalArgumentException("이용제한 시작일시와 종료일시를 입력해 주세요.");
        }
    }

    /**
     * 문자열 공백 여부 확인
     * - null, 빈 문자열, 공백 문자열을 모두 빈 값으로 판단
     */
    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    /** 시설 + 파트너 기준 계약 목록 조회 */
    @Override
    public List<Map<String, Object>> selectPartnerContractList(String mgmtOfcNo, String facilityNo, String partnerNo) {
        // 선택 시설과 협력업체가 함께 연결된 진행중 계약만 조회한다.
        return facilityCheckHstryMapper.selectPartnerContractList(mgmtOfcNo, facilityNo, partnerNo);
    }

    /** ***# 시설 선택 기준 최신 유지보수성 계약 목록 조회 */
    @Override
    public List<Map<String, Object>> selectRecommendedFacilityContractList(String mgmtOfcNo, String facilityNo) {
        return facilityCheckHstryMapper.selectRecommendedFacilityContractList(mgmtOfcNo, facilityNo);
    }


}
