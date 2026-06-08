package kr.or.ddit.domain.central.aptDashboard.dto;

import lombok.Data;

@Data
public class AptDashboardSearchDTO {
    /* 지역명 */
    private String sidoNm;

    /* 단지 번호 */
    private String aptCmplexNo;

    /* 조회 연도 */
    private Integer year;

    /* 현재 페이지 */
    private Integer currentPage;
}
