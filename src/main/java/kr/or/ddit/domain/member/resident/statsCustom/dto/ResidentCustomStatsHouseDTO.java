package kr.or.ddit.domain.member.resident.statsCustom.dto;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class ResidentCustomStatsHouseDTO {

    /* 단지 번호 */
    private String aptCmplexNo;

    /* 단지명 */
    private String aptCmplexNm;

    /* 동 번호 */
    private String dongNo;

    /* 동 이름 */
    private String dongNm;

    /* 호 번호 */
    private String hoNo;

    /* 호 이름 */
    private String ho;

    /* 화면 표시 동호 */
    private String displayDongHo;

    /* 세대 유형 번호 */
    private String hoTyNo;

    /* 전용 면적 */
    private BigDecimal exclusiveSize;
}
