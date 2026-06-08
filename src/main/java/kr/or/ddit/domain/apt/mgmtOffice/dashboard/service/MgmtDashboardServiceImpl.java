package kr.or.ddit.domain.apt.mgmtOffice.dashboard.service;

import java.util.ArrayList;

import org.springframework.stereotype.Service;

import kr.or.ddit.domain.apt.mgmtOffice.common.service.IManagerModelService;
import kr.or.ddit.domain.apt.mgmtOffice.dashboard.dto.MgmtDashboardBillStatDTO;
import kr.or.ddit.domain.apt.mgmtOffice.dashboard.dto.MgmtDashboardKpiDTO;
import kr.or.ddit.domain.apt.mgmtOffice.dashboard.dto.MgmtDashboardMonthlyStatDTO;
import kr.or.ddit.domain.apt.mgmtOffice.dashboard.dto.MgmtDashboardReservationStatDTO;
import kr.or.ddit.domain.apt.mgmtOffice.dashboard.dto.MgmtDashboardResponseDTO;
import kr.or.ddit.domain.apt.mgmtOffice.dashboard.mapper.IMgmtDashboardMapper;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class MgmtDashboardServiceImpl implements IMgmtDashboardService {

    private final IMgmtDashboardMapper dashboardMapper;
    private final IManagerModelService managerModelService;

    @Override
    public MgmtDashboardResponseDTO selectDashboard(String mgmtOfcNo) {
        String aptCmplexNo = managerModelService.getAptComplexNo(mgmtOfcNo);

        MgmtDashboardResponseDTO response = new MgmtDashboardResponseDTO();

        MgmtDashboardKpiDTO kpi = new MgmtDashboardKpiDTO();
        kpi.setCvplPending(dashboardMapper.countPendingComplaint(aptCmplexNo));
        kpi.setResidentAuthPending(dashboardMapper.countPendingResidentAuth(aptCmplexNo));
        kpi.setUseRestrictWithin7(dashboardMapper.countUseRestrictWithin7(mgmtOfcNo));
        kpi.setBillUnpaidOverdue(dashboardMapper.countBillUnpaidOverdue(aptCmplexNo));
        response.setKpi(kpi);

        MgmtDashboardBillStatDTO billStat = dashboardMapper.selectBillStat(aptCmplexNo);
        response.setBillStat(billStat == null ? new MgmtDashboardBillStatDTO() : billStat);

        MgmtDashboardMonthlyStatDTO monthlyStat = dashboardMapper.selectMonthlyStat(aptCmplexNo, mgmtOfcNo);
        response.setMonthlyStat(monthlyStat == null ? new MgmtDashboardMonthlyStatDTO() : monthlyStat);

        MgmtDashboardReservationStatDTO reservationStat = dashboardMapper.selectReservationStat(aptCmplexNo);
        if (reservationStat == null) reservationStat = new MgmtDashboardReservationStatDTO();
        reservationStat.setRecentList(defaultList(dashboardMapper.selectRecentReservationList(aptCmplexNo)));
        reservationStat.setTopFacilityList(defaultList(dashboardMapper.selectTopFacilityList(aptCmplexNo)));
        response.setReservationStat(reservationStat);

        response.setOperationTrend(defaultList(dashboardMapper.selectOperationTrend(aptCmplexNo, mgmtOfcNo)));
        response.setCvplList(defaultList(dashboardMapper.selectRecentComplaintList(aptCmplexNo)));
        response.setRqstList(defaultList(dashboardMapper.selectRecentResidentAuthList(aptCmplexNo)));
        response.setCheckList(defaultList(dashboardMapper.selectRecentCheckList(mgmtOfcNo)));

        return response;
    }

    private <T> java.util.List<T> defaultList(java.util.List<T> list) {
        return list == null ? new ArrayList<>() : list;
    }
}
