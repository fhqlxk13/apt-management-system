package kr.or.ddit.domain.apt.mgmtOffice.dashboard.service;

import kr.or.ddit.domain.apt.mgmtOffice.dashboard.dto.MgmtDashboardResponseDTO;

public interface IMgmtDashboardService {
    MgmtDashboardResponseDTO selectDashboard(String mgmtOfcNo);
}
