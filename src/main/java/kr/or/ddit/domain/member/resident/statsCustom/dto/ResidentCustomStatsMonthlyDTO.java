package kr.or.ddit.domain.member.resident.statsCustom.dto;

import lombok.Data;

@Data
public class ResidentCustomStatsMonthlyDTO {

    /* 관리년월 */
    private String billYm;

    /* 우리집 관리비 */
    private Long myBillAmt;

    /* 비슷한 세대 평균 */
    private Long similarAvgAmt;
}
