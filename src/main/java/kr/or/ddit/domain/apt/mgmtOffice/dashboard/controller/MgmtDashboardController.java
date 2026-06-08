package kr.or.ddit.domain.apt.mgmtOffice.dashboard.controller;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import kr.or.ddit.domain.apt.mgmtOffice.dashboard.dto.MgmtDashboardResponseDTO;
import kr.or.ddit.domain.apt.mgmtOffice.dashboard.service.IMgmtDashboardService;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/manager/dashboard")
@RequiredArgsConstructor
public class MgmtDashboardController {

    private final IMgmtDashboardService dashboardService;

    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/{mgmtOfcNo}")
    public MgmtDashboardResponseDTO dashboard(@PathVariable String mgmtOfcNo) {
        return dashboardService.selectDashboard(mgmtOfcNo);
    }
}
