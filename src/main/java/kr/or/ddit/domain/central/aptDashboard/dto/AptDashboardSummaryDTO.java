package kr.or.ddit.domain.central.aptDashboard.dto;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class AptDashboardSummaryDTO {
    /* 총 세대 수 */
    private Integer totalUnitCnt;

    /* 공고 수 */
    private Integer announcementCnt;

    /* 임대 매물 수 */
    private Integer rentListingCnt;

    /* 계약 완료 매물 수 */
    private Integer approvedContractCnt;

    /* 임대계약률 */
    private BigDecimal rentContractRate;
}
