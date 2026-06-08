package kr.or.ddit.domain.apt.mgmtOffice.partner.vo;

import lombok.Data;

/**
 * 협력업체 VO
 * - PARTNER 테이블 기본 컬럼과 협력업체 목록 화면의 조인/집계 표시값 보관
 * - 저장 컬럼과 화면 표시값을 한 파일에서 확인하기 위한 단순 구조
 */
@Data
public class PartnerVO {

    /** 업체번호 */
    private String partnerNo;

    /** 아파트단지번호 */
    private String aptCmplexNo;

    /** 아파트단지명  join용*/
    private String aptCmplexNm;

    /** 업종명 */
    private String bizTyNm;

    /** 업체명 */
    private String partnerNm;

    /** 사업자등록번호 */
    private String bizrno;

    /** 사용여부 */
    private String useYn;

    /** 담당자명 */
    private String picNm;

    /** 담당자 전화번호 */
    private String picTelno;

    /** 담당자 이메일 */
    private String picEmail;

    /** 등록일자 */
    private String regDt;

    /** 수정일자 */
    private String mdfDt;

    /** 전체 계약건수 */
    private int contractCnt;


/******************** join용*/
    /** 유효 계약건수 */
    private int activeContractCnt;

    /** 전체 점검건수 */
    private int checkCnt;

    /** 최근 점검일자 */
    private String recentCheckDt;

    /** 검침 공급자번호 */
    private String utilityProviderNo;

    /** 검침 연결여부 */
    private String meterLinkedYn;

    /** 전체 검침건수 */
    private int meterCnt;

    /** 단지별 검침건수 */
    private int complexMeterCnt;

    /** 시설 검침건수 */
    private int facilityMeterCnt;

    /** 최근 검침일자 */
    private String recentMeterDt;

    /** 최근 단지별 검침일자 */
    private String recentComplexMeterDt;

    /** 최근 시설 검침일자 */
    private String recentFacilityMeterDt;

}
