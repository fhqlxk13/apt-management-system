package kr.or.ddit.domain.apt.mgmtOffice.facility.check.service;

import kr.or.ddit.common.model.PaginationInfoVO;
import kr.or.ddit.domain.apt.mgmtOffice.facility.check.vo.FacilityCheckCodeVO;
import kr.or.ddit.domain.apt.mgmtOffice.facility.check.vo.FacilityCheckHstryVO;

import java.util.List;
import java.util.Map;

/**
 * 시설 점검 이력 Service 인터페이스
 */
public interface IFacilityCheckService {

    /** 시설 점검 이력 목록 건수 조회 */
    int selectFacilityCheckCount(PaginationInfoVO<FacilityCheckHstryVO> pagingVO);

    /** 시설 점검 이력 목록 조회 */
    List<FacilityCheckHstryVO> selectFacilityCheckList(PaginationInfoVO<FacilityCheckHstryVO> pagingVO);

    /** 시설 점검 이력 현황 카드 건수 조회 */
    FacilityCheckHstryVO selectFacilityCheckSummary(String mgmtOfcNo);

    /** 오늘의 이용제한 점검 이력 목록 조회 */
    List<FacilityCheckHstryVO> selectTodayUseRestrictList(String mgmtOfcNo);

    /** [추가] 내일 이후 시작 예정인 이용제한 점검 이력 목록 조회 */
    List<FacilityCheckHstryVO> selectFutureUseRestrictList(String mgmtOfcNo);

    /** 시설 점검 이력 상세 조회 */
    FacilityCheckHstryVO selectFacilityCheckDetail(String mgmtOfcNo, String facChkHstryNo);

    /** 시설 선택 모달 기본 목록 조회 */
    List<FacilityCheckHstryVO> selectFacilitySelectList(String mgmtOfcNo);

    /** 협력업체 선택 모달 기본 목록 조회 */
    List<FacilityCheckHstryVO> selectPartnerSelectList(String mgmtOfcNo);

    /** 점검유형 공통코드 목록 조회 */
    List<FacilityCheckCodeVO> selectCheckTypeList();

    /** 점검분류 공통코드 목록 조회 */
    List<FacilityCheckCodeVO> selectCheckCategoryList();

    /** 점검상태 공통코드 목록 조회 */
    List<FacilityCheckCodeVO> selectCheckStatusList();

    /**
     * 일반 시설자산 유형 목록 조회
     * - 시설 선택 모달 optgroup(일반시설) 렌더링용
     */
    List<FacilityCheckCodeVO> selectAssetFacilityTypeList();

    /**
     * 편의시설 유형 목록 조회
     * - 시설 선택 모달 optgroup(편의시설) 렌더링용
     */
    List<FacilityCheckCodeVO> selectPublicFacilityTypeList();

    /** 시설 점검 이력 등록 */
    String insertFacilityCheckHistory(FacilityCheckHstryVO facilityCheckHstryVO);

    /** 시설 점검 이력 수정 */
    boolean updateFacilityCheckHistory(FacilityCheckHstryVO facilityCheckHstryVO);

    /** 선택한 시설의 기존 점검 이력 목록 조회 */
    List<FacilityCheckHstryVO> selectSameFacilityCheckList(String mgmtOfcNo, String facilityNo);

    /** 시설 선택 모달 서버 검색 목록 조회 */
    List<FacilityCheckHstryVO> selectFacilitySearchList(FacilityCheckHstryVO searchVO);

    /** 협력업체 선택 모달 서버 검색 목록 조회 */
    List<FacilityCheckHstryVO> selectPartnerSearchList(FacilityCheckHstryVO searchVO);

    /** 시설 + 파트너 기준 계약 목록 조회 */
    List<Map<String, Object>> selectPartnerContractList(String mgmtOfcNo, String facilityNo, String partnerNo);

    /** ***# 시설 선택 기준 최신 유지보수성 계약 목록 조회 */
    List<Map<String, Object>> selectRecommendedFacilityContractList(String mgmtOfcNo, String facilityNo);
}
