package kr.or.ddit.domain.apt.mgmtOffice.reservation.vo;

import lombok.Data;

/**
 * 공용시설 예약 통합 VO
 * VO란? DB 조회 결과를 Java에서 담는 바구니입니다.
 * 왜 사용? Mapper XML의 SELECT 결과를 Controller/JSP까지 안전하게 전달하기 위해 사용합니다.
 */
@Data
public class PublicFacilityReservationVO {
    private String rsvtNo;
    private String cmnFacilityItemNo;
    private String cmnFacilityNo;
    private String facilityNo;
    private String aptCmplexNo;
    private String userNo;
    private String userId;
    private String userNm;
    private String hoNo;
    private String dongNo;
    private String dongNm;
    private String ho;
    private String cmnFacilityNm;
    private String itemNm;
    private String facilityTyCd;
    private String facilityTyNm;
    private String locCn;
    private String cmnFacilityRsvYn;
    private String cmnFacilityOprHr;
    private Integer cmnFacilityAmt;
    private String cmnFacilitySttsCd;
    private String rsvtDt;
    private String rsvtBgngDttm;
    private String rsvtEndDttm;
    private String rsvtSttsCd;
    private String rsvtSttsNm;
    private String rejectReason;
    private String purposeCn;
    private Integer usePeopleCnt;
    private String regDt;
    private String mdfDt;

    // 검색/페이징용
    private int startRow;
    private int endRow;
    private String searchFacilityNo;
    private String searchCmnFacilityNo;
    private String searchItemNo;
    private String searchUserNm;
    private String searchStartDt;
    private String searchEndDt;
    private String searchRsvtSttsCd;
    private String searchDongNo;
    private String searchLocCn;
    private String searchWord;
    private String searchAutoApproveYn; // 자동승인 여부 검색용: Y/N

    /*
     * 공용시설 설명
     * 예: 독서실 이용 안내, 주민회의실 예약 안내
     */
    private String cmnFacilityCn;

    /*
     * 예약 가능 여부 표시용
     * Y: 이미 예약됨
     * N: 예약 가능
     */
    private String reservedYn;

    /*
     * 시간표 표시용
     * 예: 08:00 ~ 09:00
     */
    private String timeLabel;

    /*
     * 자동승인 여부
     * Y: 독서실/피트니스센터처럼 예약 즉시 승인
     * N: 회의실/커뮤니티룸처럼 관리자 승인 필요
     */
    private String autoApproveYn;

    /*
     * 동 검색어
     * 예: 101
     */
    private String searchDongNm;

    /*
     * 호 검색어
     * 예: 305
     */
    private String searchHo;

    /**
     *   예약시설 이용목적
     */
    private String usePrpsCn;   // 이용목적

}
