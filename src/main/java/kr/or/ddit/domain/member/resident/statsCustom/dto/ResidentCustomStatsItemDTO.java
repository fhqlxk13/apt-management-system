package kr.or.ddit.domain.member.resident.statsCustom.dto;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class ResidentCustomStatsItemDTO {

    /* 관리비 항목 코드 */
    private String billItemCd;

    /* 관리비 항목명 */
    private String billItemNm;

    /* 우리집 항목 금액 */
    private Long myItemAmt;

    /* 비슷한 세대 평균 금액 */
    private Long similarAvgAmt;

    /* 평균 대비 금액 */
    private Long diffAmt;

    /* 평균 대비 비율 */
    private BigDecimal diffRate;
}
