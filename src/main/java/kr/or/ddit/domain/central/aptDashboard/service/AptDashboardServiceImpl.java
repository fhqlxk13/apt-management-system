package kr.or.ddit.domain.central.aptDashboard.service;

import kr.or.ddit.common.model.PaginationInfoVO;
import kr.or.ddit.domain.central.aptDashboard.dto.AptDashboardAptRowDTO;
import kr.or.ddit.domain.central.aptDashboard.dto.AptDashboardResponseDTO;
import kr.or.ddit.domain.central.aptDashboard.dto.AptDashboardSearchDTO;
import kr.or.ddit.domain.central.aptDashboard.mapper.IAptDashboardMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;

@Service
@RequiredArgsConstructor
public class AptDashboardServiceImpl implements IAptDashboardService {

    private final IAptDashboardMapper aptDashboardMapper;

    @Override
    public AptDashboardResponseDTO selectDashboard(AptDashboardSearchDTO search) {
        /* 조회 조건 정리 */
        AptDashboardSearchDTO normalizedSearch = normalize(search);

        AptDashboardResponseDTO response = new AptDashboardResponseDTO();
        response.setSearch(normalizedSearch);
        response.setSidoList(aptDashboardMapper.selectSidoList());
        response.setAptList(aptDashboardMapper.selectAptList(normalizedSearch));
        response.setSummary(aptDashboardMapper.selectSummary(normalizedSearch));
        response.setMonthlyList(aptDashboardMapper.selectMonthlyList(normalizedSearch));
        response.setListingStatusList(aptDashboardMapper.selectListingStatusList(normalizedSearch));

        /* 페이지 정보 */
        PaginationInfoVO<AptDashboardAptRowDTO> pagingVO = new PaginationInfoVO<>(10, 5);
        pagingVO.setTotalRecord(aptDashboardMapper.selectAptRowCount(normalizedSearch));
        pagingVO.setCurrentPage(normalizedSearch.getCurrentPage());
        pagingVO.setDataList(aptDashboardMapper.selectAptRowList(normalizedSearch, pagingVO));

        response.setPagingVO(pagingVO);
        response.setAptRowList(pagingVO.getDataList());
        return response;
    }

    private AptDashboardSearchDTO normalize(AptDashboardSearchDTO search) {
        AptDashboardSearchDTO normalized = search == null ? new AptDashboardSearchDTO() : search;

        /* 기본 연도 */
        if (normalized.getYear() == null || normalized.getYear() <= 0) {
            normalized.setYear(LocalDate.now().getYear());
        }

        /* 빈 지역 조건 */
        if (isBlank(normalized.getSidoNm())) {
            normalized.setSidoNm(null);
        }

        /* 빈 단지 조건 */
        if (isBlank(normalized.getAptCmplexNo())) {
            normalized.setAptCmplexNo(null);
        }

        /* 기본 페이지 번호 */
        if (normalized.getCurrentPage() == null || normalized.getCurrentPage() <= 0) {
            normalized.setCurrentPage(1);
        }
        return normalized;
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
