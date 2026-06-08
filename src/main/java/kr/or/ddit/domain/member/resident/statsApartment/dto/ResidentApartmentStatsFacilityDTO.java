package kr.or.ddit.domain.member.resident.statsApartment.dto;

import lombok.Data;

@Data
public class ResidentApartmentStatsFacilityDTO {

    /* 시설명 */
    private String facilityNm;

    /* 예약 건수 */
    private Integer reservationCnt;

    /* 랭킹 */
    private Integer rank;
}
