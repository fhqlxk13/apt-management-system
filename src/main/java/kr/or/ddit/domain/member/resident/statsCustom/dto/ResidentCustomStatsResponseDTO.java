package kr.or.ddit.domain.member.resident.statsCustom.dto;

import lombok.Data;

import java.util.List;

@Data
public class ResidentCustomStatsResponseDTO {

    /* 세대 정보 */
    private ResidentCustomStatsHouseDTO house;

    /* 요약 통계 */
    private ResidentCustomStatsSummaryDTO summary;

    /* 월별 관리비 비교 */
    private List<ResidentCustomStatsMonthlyDTO> monthlyList;

    /* 검침 사용량 비교 */
    private List<ResidentCustomStatsMeterDTO> meterList;

    /* 시설 이용 현황 */
    private List<ResidentCustomStatsFacilityDTO> facilityList;

    /* 민원 처리 현황 */
    private ResidentCustomStatsComplaintDTO complaint;
}
