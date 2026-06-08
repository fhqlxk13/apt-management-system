package kr.or.ddit.domain.apt.mgmtOffice.facility.publicFacility.vo;

import lombok.Data;

/**
 * 공용시설 아이템 VO
 * - PUBLIC_ITEM 테이블 기준 조회/등록/수정용 VO
 * - 공용시설 하위 자원/비품 단위 관리
 */
@Data
public class PublicItemVO {

    /** 공용시설 아이템 번호 */
    private String cmnFacilityItemNo;
    /**
     * 연결 시설자산 번호
     */
    private String facilityNo;

    /** 공용시설 번호 */
    private String cmnFacilityNo;

    /** 아이템명 */
    private String itemNm;

    /** 아이템 상태 코드 */
    private String cmnFacilitySttsCd;

    /** 편의시설명 (목록 전체 조회 시 JOIN) */
    private String cmnFacilityNm;

    /** 등록일자 */
    private String regDt;

    /** 수정일자 */
    private String mdfDt;
}
