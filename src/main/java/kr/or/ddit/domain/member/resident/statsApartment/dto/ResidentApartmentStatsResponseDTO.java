package kr.or.ddit.domain.member.resident.statsApartment.dto;

import lombok.Data;

import java.util.List;

@Data
public class ResidentApartmentStatsResponseDTO {

    /* 세대 현황 */
    private ResidentApartmentStatsHouseDTO house;

    /* 검침 유형별 통계 */
    private List<ResidentApartmentStatsMeterDTO> meterList;

    /* 민원 현황 */
    private ResidentApartmentStatsComplaintDTO complaint;

    /* 시설 이용 랭킹 */
    private List<ResidentApartmentStatsFacilityDTO> facilityList;

    /* 시설 점검 현황 */
    private ResidentApartmentStatsCheckDTO check;

    /* 협력업체 통계 */
    private ResidentApartmentStatsPartnerDTO partner;
}
