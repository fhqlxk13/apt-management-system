package kr.or.ddit.domain.member.resident.statsApartment.dto;

import lombok.Data;

@Data
public class ResidentApartmentStatsCheckDTO {

    /* 전체 점검 건수 */
    private Integer totalCnt;

    /* 대기 건수 */
    private Integer pendingCnt;

    /* 진행중 건수 */
    private Integer inProgressCnt;

    /* 완료 건수 */
    private Integer doneCnt;

    /* 사용 제한 시설 수 */
    private Integer restrictedCnt;
}
