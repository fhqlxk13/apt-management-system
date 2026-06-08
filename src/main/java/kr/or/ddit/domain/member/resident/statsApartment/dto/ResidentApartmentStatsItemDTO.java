package kr.or.ddit.domain.member.resident.statsApartment.dto;

import lombok.Data;

@Data
public class ResidentApartmentStatsItemDTO {

    /* 항목 코드 */
    private String itemCd;

    /* 항목명 */
    private String itemNm;

    /* 건수 */
    private Integer cnt;
}
