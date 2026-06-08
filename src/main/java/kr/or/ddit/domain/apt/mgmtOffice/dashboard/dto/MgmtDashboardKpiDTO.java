package kr.or.ddit.domain.apt.mgmtOffice.dashboard.dto;

import lombok.Data;

@Data
public class MgmtDashboardKpiDTO {
    private int cvplPending;
    private int residentAuthPending;
    private int useRestrictWithin7;
    private int billUnpaidOverdue;
}
