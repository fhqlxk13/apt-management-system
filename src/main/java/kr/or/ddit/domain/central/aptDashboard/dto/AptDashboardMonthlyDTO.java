package kr.or.ddit.domain.central.aptDashboard.dto;

import lombok.Data;

@Data
public class AptDashboardMonthlyDTO {
    /* 월 */
    private String month;

    /* 공고 수 */
    private Integer announcementCnt;

    /* 계약 완료 매물 수 */
    private Integer contractCnt;
}
