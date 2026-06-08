package kr.or.ddit.domain.apt.mgmtOffice.facility.publicFacility.vo;

import lombok.Data;

/**
 * 공용시설 VO
 * - PUBLIC_FACILITY 테이블 기준 조회용 VO
 * - 목록/상세 화면에서 필요한 FACILITY 조인 컬럼 포함
 * - insert/update form 요청값은 PublicFacilityFormDTO에서 별도 수신
 */
@Data
public class PublicFacilityVO {

    /*
     * ============================================================
     * PUBLIC_FACILITY 테이블 컬럼
     * ============================================================
     */

    /** 공용시설번호 */
    private String cmnFacilityNo;

    /** 아파트단지번호 */
    private String aptCmplexNo;

    /** 시설번호 */
    private String facilityNo;

    /** 공용시설명 */
    private String cmnFacilityNm;

    /** 공용시설 내용 / 안내문 */
    private String cmnFacilityCn;

    /** 공용시설 비용 */
    private Integer cmnFacilityAmt;

    /** 공용시설 예약 여부 */
    private String cmnFacilityRsvYn;

    /** 공용시설 운영 시간 */
    private String cmnFacilityOprHr;

    /** 등록일자 */
    private String regDt;

    /** 수정일자 */
    private String mdfDt;


    /*
     * ============================================================
     * FACILITY 조인 표시용 컬럼
     * - PUBLIC_FACILITY에 직접 저장되는 값 아님
     * - 목록/상세/후보 표시용
     * ============================================================
     */

    /** 시설명 */
    private String facilityNm;

    /** 시설유형코드 */
    private String facilityTyCd;

    /** 시설유형명 */
    private String facilityTyNm;

    /** 설치일자 */
    private String instlDt;

    /** 동번호 */
    private String dongNo;

    /** 동명 */
    private String dongNm;

    /** 상세위치 */
    private String locCn;

    /** 사용여부 */
    private String useYn;

    /** 파일그룹번호 */
    private Long fileGroupNo;


    /*
     * ============================================================
     * PUBLIC_ITEM 집계 표시용 컬럼
     * - 공용시설 운영현황 계산용
     * - DB 저장값이 아니라 조회 결과용
     * ============================================================
     */

    /** 공용아이템 전체 개수 */
    private Integer itemCnt;

    /** 점검중 아이템 개수 */
    private Integer repairCnt;

    /** 사용중지 아이템 개수 */
    private Integer closeCnt;

    /** 화면 표시용 운영상태 */
    private String operStatus;
}