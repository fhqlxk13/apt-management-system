package kr.or.ddit.domain.apt.mgmtOffice.partner.vo;

import lombok.Data;

/**
 * 협력업체 검색 VO
 * - JSP 검색 조건과 페이지 번호 보관
 * - 화면에 실제로 있는 검색 조건만 사용
 */
@Data
public class PartnerSearchVO {

    /** 관리사무소번호 */
    private String mgmtOfcNo;

    /** 아파트단지번호 */
    private String aptCmplexNo;

    /** 업종명 */
    private String bizTyNm;

    /** 사용여부 */
    private String useYn;

    /** 계약여부 */
    private String contractYn;

    /** 최근점검 시작일 */
    private String checkStartDt;

    /** 최근점검 종료일 */
    private String checkEndDt;

    /** 최근검침 시작일 */
    private String meterStartDt;

    /** 최근검침 종료일 */
    private String meterEndDt;

    /** 통합검색어 */
    private String searchWord;

    /** 현재 페이지 */
    private int page = 1;

    /** 시작 행 번호 */
    private int startRow;

    /** 종료 행 번호 */
    private int endRow;
}
