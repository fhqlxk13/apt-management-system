package kr.or.ddit.domain.apt.mgmtOffice.contract.vo;

import lombok.Data;

/**
 * 계약 목록 검색조건 VO
 *
 * JSP 검색조건과 Mapper where절을 연결한다.
 */
@Data
public class FacilityContractSearchVO {

    /** 현재 화면 관리사무소 번호 */
    private String mgmtOfcNo;

    /** 협력업체 상세 바로가기 필터 */
    private String partnerNo;

    /** 계약유형 */
    private String contTyCd;

    /** 대상구분 */
    private String contTargetCd;

    /** 계약상태 */
    private String contSttsCd;

    /** 계약기간 시작일 */
    private String periodStartDt;

    /** 계약기간 종료일 */
    private String periodEndDt;

    /** 계약금액 최소 */
    private Long minContAmt;

    /** 계약금액 최대 */
    private Long maxContAmt;

    /** 계약명/번호, 업체명/번호, 대상 통합검색 */
    private String keyword;
}
