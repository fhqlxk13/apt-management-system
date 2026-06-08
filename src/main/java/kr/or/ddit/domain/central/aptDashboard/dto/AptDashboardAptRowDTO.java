package kr.or.ddit.domain.central.aptDashboard.dto;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class AptDashboardAptRowDTO {
    /* 단지 번호 */
    private String aptCmplexNo;

    /* 단지명 */
    private String aptCmplexNm;

    /* 지역명 */
    private String region;

    /* 세대 수 */
    private Integer unitCnt;

    /* 공고 수 */
    private Integer announcementCnt;

    /* 임대 매물 수 */
    private Integer rentListingCnt;

    /* 계약 완료 매물 수 */
    private Integer approvedContractCnt;

    /* 임대계약률 */
    private BigDecimal rentContractRate;
}
