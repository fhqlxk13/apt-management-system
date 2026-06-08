package kr.or.ddit.domain.central.aptDashboard.mapper;

import kr.or.ddit.common.model.PaginationInfoVO;
import kr.or.ddit.domain.central.aptDashboard.dto.AptDashboardAptRowDTO;
import kr.or.ddit.domain.central.aptDashboard.dto.AptDashboardListingStatusDTO;
import kr.or.ddit.domain.central.aptDashboard.dto.AptDashboardMonthlyDTO;
import kr.or.ddit.domain.central.aptDashboard.dto.AptDashboardOptionDTO;
import kr.or.ddit.domain.central.aptDashboard.dto.AptDashboardSearchDTO;
import kr.or.ddit.domain.central.aptDashboard.dto.AptDashboardSummaryDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface IAptDashboardMapper {
    /* 지역 목록 조회 */
    List<AptDashboardOptionDTO> selectSidoList();

    /* 단지 목록 조회 */
    List<AptDashboardOptionDTO> selectAptList(AptDashboardSearchDTO search);

    /* 요약 통계 조회 */
    AptDashboardSummaryDTO selectSummary(AptDashboardSearchDTO search);

    /* 월별 통계 조회 */
    List<AptDashboardMonthlyDTO> selectMonthlyList(AptDashboardSearchDTO search);

    /* 임대 매물 상태 통계 조회 */
    List<AptDashboardListingStatusDTO> selectListingStatusList(AptDashboardSearchDTO search);

    /* 단지별 목록 수 조회 */
    int selectAptRowCount(AptDashboardSearchDTO search);

    /* 단지별 목록 조회 */
    List<AptDashboardAptRowDTO> selectAptRowList(
            @Param("search") AptDashboardSearchDTO search,
            @Param("pagingVO") PaginationInfoVO<AptDashboardAptRowDTO> pagingVO
    );
}
