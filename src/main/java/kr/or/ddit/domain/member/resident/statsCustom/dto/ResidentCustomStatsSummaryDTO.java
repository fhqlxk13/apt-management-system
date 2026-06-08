package kr.or.ddit.domain.member.resident.statsCustom.dto;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class ResidentCustomStatsSummaryDTO {

    /* 관리년월 */
    private String billYm;

    /* 관리비 번호 */
    private String billNo;

    /* 이번 달 관리비 */
    private Long currentBillAmt;

    /* 전월 관리비 */
    private Long previousBillAmt;

    /* 비슷한 세대 평균 */
    private Long similarAvgAmt;

    /* 전월 대비 금액 */
    private Long previousDiffAmt;

    /* 전월 대비 비율 */
    private BigDecimal previousDiffRate;

    /* 평균 대비 금액 */
    private Long averageDiffAmt;

    /* 평균 대비 비율 */
    private BigDecimal averageDiffRate;
}
