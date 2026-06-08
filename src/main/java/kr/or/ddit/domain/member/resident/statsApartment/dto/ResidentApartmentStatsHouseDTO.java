package kr.or.ddit.domain.member.resident.statsApartment.dto;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class ResidentApartmentStatsHouseDTO {

    /* 단지 번호 */
    private String aptCmplexNo;

    /* 단지명 */
    private String aptCmplexNm;

    /* 전체 세대 수 */
    private Integer totalUnitCnt;

    /* 입주 세대 수 */
    private Integer occupiedCnt;

    /* 공실 세대 수 */
    private Integer emptyCnt;

    /* 입주율 */
    private BigDecimal occupancyRate;

    /* 동 수 */
    private Integer dongCnt;
}
