package kr.or.ddit.domain.apt.mgmtOffice.facility.check.vo;

import lombok.Data;

/**
 * 시설 점검 이력 VO
 * - FACILITY_CHECK_HSTRY 테이블 기준 CRUD
 * - FACILITY, PARTNER, COMMON_CODE 조인 표시값 포함
 * - 시설 선택 모달, 협력업체 선택 모달 검색 조건 포함
 */
@Data
public class FacilityCheckHstryVO {

    /* =========================================================
     * 1. FACILITY_CHECK_HSTRY 테이블 컬럼
     * ========================================================= */

    /** 시설점검이력번호 */
    private String facChkHstryNo;

    /** 시설번호 */
    private String facilityNo;

    /** 업체번호
     * - null이면 자체점검
     * - 값이 있으면 협력업체 점검
     */
    private String partnerNo;

    /** 점검 흐름번호
     * - 같은 문제/후속 이력 흐름 묶음 번호
     */
    private String chkFlowNo;

    /** 점검일자 */
    private String chkDt;

    /** 점검상태코드 */
    private String chkSttsCd;

    /** 점검내용 */
    private String chkCn;

    /** 비고 */
    private String rmk;

    /** 등록일자 */
    private String regDt;

    /** 수정일자 */
    private String mdfDt;

    /** 점검유형코드 */
    private String chkTyCd;

    /** 점검분류코드
     * - REVIEW  : 점검·확인
     * - SERVICE : 관리·용역
     */
    private String chkCtgryCd;

    /** 이용제한 여부 */
    private String useRestrictYn;

    /** 이용제한 시작일시 */
    private String useRestrictBgngDt;

    /** 이용제한 종료일시 */
    private String useRestrictEndDt;

    /** 이용제한 화면상태코드
     * - ONGOING : 제한중
     * - UPCOMING : 예정
     * - ENDED : 종료
     * - DB 저장 컬럼 아님
     */
    private String useRestrictStatusCd;

    /** 이용제한 화면상태명 */
    private String useRestrictStatusNm;


    /* =========================================================
     * 2. FACILITY 조인 표시값
     * ========================================================= */

    /** 시설명 */
    private String facilityNm;

    /** 시설유형코드 */
    private String facilityTyCd;

    /** 시설유형명 */
    private String facilityTyNm;

    /** 시설 위치 */
    private String locCn;

    /** 시설 설치일자 */
    private String instlDt;

    /** 시설 사용여부 */
    private String useYn;

    /** 동 번호 */
    private String dongNo;

    /** 동 이름 */
    private String dongNm;


    /* =========================================================
     * 3. PARTNER 조인 표시값
     * ========================================================= */

    /** 업체명 */
    private String partnerNm;

    /** 업종명 */
    private String bizTyNm;

    /** 사업자등록번호 */
    private String bizrno;

    /** 업체 담당자명 */
    private String picNm;

    /** 업체 담당자 전화번호 */
    private String picTelno;

    /** 업체 담당자 이메일 */
    private String picEmail;

    /* =========================================================
     * 3-1. FACILITY_CONTRACT 조인 표시값
     * ========================================================= */

    /** 계약번호 */
    private String contNo;

    /** 계약명 */
    private String contNm;

    private String contCn;

    /** 계약시작일 */
    private String contBgngDt;

    /** 계약종료일 */
    private String contEndDt;


    /* =========================================================
     * 4. COMMON_CODE 조인 표시값
     * ========================================================= */

    /** 점검유형명 */
    private String chkTyNm;

    /** 점검분류명 */
    private String chkCtgryNm;

    /** 점검상태명 */
    private String chkSttsNm;


    /* =========================================================
     * 5. 목록 검색 조건
     * ========================================================= */

    /** 관리사무소 번호 검색 조건 */
    private String mgmtOfcNo;

    /** 검색 시작 점검일자 */
    private String chkStartDt;

    /** 검색 종료 점검일자 */
    private String chkEndDt;


    /* =========================================================
     * 6. 시설 선택 모달 검색 조건
     * ========================================================= */

    /** 시설 선택 모달 검색어 */
    private String facilitySearchWord;

    /** 시설 선택 모달 사용여부 검색 조건 */
    private String facilityUseYn;

    /** 시설 선택 모달 위치 검색 조건 */
    private String facilityLocCn;


    /* =========================================================
     * 7. 협력업체 선택 모달 검색 조건
     * ========================================================= */

    /** 협력업체 선택 모달 사용여부 검색 조건 */
    private String partnerUseYn;

    /** 협력업체 선택 모달 검색어 */
    private String partnerSearchWord;


    /* =========================================================
     * 8. 현황 카드 값
     * ========================================================= */

    /** 현황 카드 전체 이력 건수 */
    private Integer totalCnt;

    /** 현황 카드 점검대기 건수 */
    private Integer waitCnt;

    /** 현황 카드 점검중 건수 */
    private Integer ingCnt;

    /** 현황 카드 이상발견 건수 */
    private Integer faultCnt;


    /* =========================================================
     * 9. 화면 제어용 값
     * ========================================================= */

    /** 점검 주체 구분
     * - SELF    : 자체점검
     * - PARTNER : 협력업체 점검
     * - DB 저장 컬럼 아님
     * - 화면 제어와 서버 검증용
     */
    private String chkOwnerType;


}
