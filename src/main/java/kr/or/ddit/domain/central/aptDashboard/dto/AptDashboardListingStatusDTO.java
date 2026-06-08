package kr.or.ddit.domain.central.aptDashboard.dto;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class AptDashboardListingStatusDTO {
    /* 매물 상태 코드 */
    private String listingStatusCd;

    /* 매물 상태명 */
    private String listingStatusNm;

    /* 임대 매물 수 */
    private Integer rentListingCnt;

    /* 비율 */
    private BigDecimal ratio;
}
