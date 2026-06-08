package kr.or.ddit.domain.member.resident.statsCustom.dto;

import lombok.Data;

@Data
public class ResidentCustomStatsFacilityDTO {

    /* 시설명 */
    private String facilityNm;

    /* 이용 횟수 */
    private Integer useCnt;
}
