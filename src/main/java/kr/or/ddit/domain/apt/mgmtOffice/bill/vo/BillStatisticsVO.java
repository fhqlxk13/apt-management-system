package kr.or.ddit.domain.apt.mgmtOffice.bill.vo;

import lombok.Data;

@Data
public class BillStatisticsVO {

    /* =========================
       조회 조건
       ========================= */
    private String mgmtOfcNo;
    private String aptCmplexNo;
    private String fromYm;
    private String toYm;

    /* =========================
       요약 통계
       ========================= */
    private int billCnt;              // 고지서 건수
    private int paidCnt;              // 납부완료 건수
    private int unpaidCnt;            // 미납/고지완료 건수
    private int overdueCnt;           // 연체 건수

    private long totalBillAmt;        // 총 부과금액
    private long totalPaidAmt;        // 총 납부금액
    private long totalUnpaidAmt;      // 미납/연체 금액
    private double paidRate;          // 납부율

    private long avgBillAmt;          // 평균 관리비
    private long minBillAmt;          // 최소 관리비
    private long maxBillAmt;          // 최대 관리비

    /* =========================
       월별 통계
       ========================= */
    private String billYm;
    private long monthBillAmt;
    private long monthPaidAmt;
    private int monthBillCnt;
    private int monthPaidCnt;

    /* =========================
       항목별 통계
       ========================= */
    private String billItemCd;
    private String billItemNm;
    private long itemTotalAmt;
    private double itemRate;

    /* =========================
       납부상태 통계
       ========================= */
    private String pymtSttsCd;
    private String pymtSttsNm;
    private int statusCnt;
    private long statusAmt;

    /* =========================
       세대별 TOP
       ========================= */
    private String hoNo;
    private String dongNm;
    private String ho;
    private String displayDongHo;
    private long houseTotalAmt;

}
