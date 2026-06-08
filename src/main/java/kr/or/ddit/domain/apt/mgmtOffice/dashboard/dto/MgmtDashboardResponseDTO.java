package kr.or.ddit.domain.apt.mgmtOffice.dashboard.dto;

import java.util.List;
import lombok.Data;

@Data
public class MgmtDashboardResponseDTO {
    private MgmtDashboardKpiDTO kpi;
    private MgmtDashboardBillStatDTO billStat;
    private MgmtDashboardMonthlyStatDTO monthlyStat;
    private MgmtDashboardReservationStatDTO reservationStat;
    private List<MgmtDashboardOperationTrendDTO> operationTrend;
    private List<MgmtDashboardRecentComplaintDTO> cvplList;
    private List<MgmtDashboardRecentResidentAuthDTO> rqstList;
    private List<MgmtDashboardRecentCheckDTO> checkList;
}
