package kr.or.ddit.domain.member.resident.statsApartment.dto;

import lombok.Data;

@Data
public class ResidentApartmentStatsMeterDTO {

    /* 검침 유형 코드 */
    private String meterTyCd;

    /* 검침 유형명 */
    private String meterTyNm;

    /* 단위명 */
    private String unitNm;

    /* 검침 세대 수 */
    private Integer hshldCnt;

    /* 평균 사용량 */
    private Long avgUsage;

    /* 최소 사용량 */
    private Long minUsage;

    /* 최대 사용량 */
    private Long maxUsage;

    /* 정상 건수 */
    private Integer normalCnt;

    /* 오류 건수 */
    private Integer errorCnt;

    /* 누락 건수 */
    private Integer missCnt;

    /* 확인필요 건수 */
    private Integer checkCnt;
}
