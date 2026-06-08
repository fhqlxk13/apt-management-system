package kr.or.ddit.domain.member.resident.statsCustom.dto;

import lombok.Data;

@Data
public class ResidentCustomStatsComplaintDTO {

    /* 접수 건수 */
    private Integer appliedCnt;

    /* 처리중 건수 */
    private Integer processingCnt;

    /* 완료 건수 */
    private Integer doneCnt;
}
