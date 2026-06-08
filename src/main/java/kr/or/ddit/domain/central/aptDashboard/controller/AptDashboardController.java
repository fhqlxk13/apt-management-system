package kr.or.ddit.domain.central.aptDashboard.controller;

import kr.or.ddit.domain.central.aptDashboard.dto.AptDashboardResponseDTO;
import kr.or.ddit.domain.central.aptDashboard.dto.AptDashboardSearchDTO;
import kr.or.ddit.domain.central.aptDashboard.service.IAptDashboardService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@RequestMapping("/main/apt/dashboard")
public class AptDashboardController {

    private final IAptDashboardService aptDashboardService;

    @GetMapping("/data")
    public AptDashboardResponseDTO dashboardData(@ModelAttribute AptDashboardSearchDTO search) {
        /* 대시보드 통계 조회 */
        return aptDashboardService.selectDashboard(search);
    }
}
