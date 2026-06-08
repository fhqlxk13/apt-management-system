package kr.or.ddit.domain.central.aptDashboard.service;

import kr.or.ddit.domain.central.aptDashboard.dto.AptDashboardResponseDTO;
import kr.or.ddit.domain.central.aptDashboard.dto.AptDashboardSearchDTO;

public interface IAptDashboardService {
    AptDashboardResponseDTO selectDashboard(AptDashboardSearchDTO search);
}
