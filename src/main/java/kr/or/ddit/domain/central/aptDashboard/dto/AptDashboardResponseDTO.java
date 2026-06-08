package kr.or.ddit.domain.central.aptDashboard.dto;

import kr.or.ddit.common.model.PaginationInfoVO;
import lombok.Data;

import java.util.List;

@Data
public class AptDashboardResponseDTO {
    /* 조회 조건 */
    private AptDashboardSearchDTO search;

    /* 요약 통계 */
    private AptDashboardSummaryDTO summary;

    /* 월별 통계 */
    private List<AptDashboardMonthlyDTO> monthlyList;

    /* 임대 매물 상태 통계 */
    private List<AptDashboardListingStatusDTO> listingStatusList;

    /* 단지별 목록 */
    private List<AptDashboardAptRowDTO> aptRowList;

    /* 지역 선택 목록 */
    private List<AptDashboardOptionDTO> sidoList;

    /* 단지 선택 목록 */
    private List<AptDashboardOptionDTO> aptList;

    /* 페이지 정보 */
    private PaginationInfoVO<AptDashboardAptRowDTO> pagingVO;
}
