package kr.or.ddit.domain.member.resident.statsApartment.service;

import kr.or.ddit.domain.member.resident.statsApartment.dto.ResidentApartmentStatsResponseDTO;

public interface IResidentApartmentStatsService {

    /* 아파트통계 조회 */
    ResidentApartmentStatsResponseDTO selectApartmentStats(String aptCmplexNo);
}
