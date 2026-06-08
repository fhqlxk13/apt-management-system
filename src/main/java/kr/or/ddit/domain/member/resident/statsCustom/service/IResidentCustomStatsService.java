package kr.or.ddit.domain.member.resident.statsCustom.service;

import kr.or.ddit.domain.member.resident.statsCustom.dto.ResidentCustomStatsResponseDTO;

public interface IResidentCustomStatsService {

    /* 우리집맞춤통계 조회 */
    ResidentCustomStatsResponseDTO selectCustomStats(String userNo, String aptCmplexNo);

    /* 기본 우리집맞춤통계 조회 */
    ResidentCustomStatsResponseDTO selectCustomStats(String userNo);
}
