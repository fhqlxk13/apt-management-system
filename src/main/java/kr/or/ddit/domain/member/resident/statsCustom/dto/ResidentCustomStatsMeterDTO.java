package kr.or.ddit.domain.member.resident.statsCustom.dto;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class ResidentCustomStatsMeterDTO {

    /* 검침 유형 코드 */
    private String meterTyCd;

    /* 검침 유형명 */
    private String meterTyNm;

    /* 단위명 */
    private String unitNm;

    /* 우리집 사용량 */
    private Long myUsageVal;

    /* 단지 평균 사용량 */
    private Long avgUsageVal;

    /* 평균 대비 사용량 */
    private Long diffVal;

    /* 평균 대비 비율 */
    private BigDecimal diffRate;
}
