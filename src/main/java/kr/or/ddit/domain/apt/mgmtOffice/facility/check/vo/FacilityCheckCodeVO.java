package kr.or.ddit.domain.apt.mgmtOffice.facility.check.vo;

import lombok.Data;

/**
 * 시설 점검 이력 공통코드 VO
 * - CHECK_TY, CHECK_STTS, FACILITY_TY 표시용 코드 조회 결과
 */
@Data
public class FacilityCheckCodeVO {

    /** 코드 그룹 번호 */
    private String groupCodeNo;

    /** 코드 번호 */
    private String codeNoCd;

    /** 코드 이름 */
    private String codeName;

    /** 코드 설명 */
    private String codeContent;

    /** 정렬 순서 */
    private Integer sortOrder;

    /** 사용 여부 */
    private String useYn;
}
