package kr.or.ddit.domain.apt.mgmtOffice.dashboard.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.or.ddit.domain.apt.mgmtOffice.dashboard.dto.MgmtDashboardBillStatDTO;
import kr.or.ddit.domain.apt.mgmtOffice.dashboard.dto.MgmtDashboardMonthlyStatDTO;
import kr.or.ddit.domain.apt.mgmtOffice.dashboard.dto.MgmtDashboardOperationTrendDTO;
import kr.or.ddit.domain.apt.mgmtOffice.dashboard.dto.MgmtDashboardRecentCheckDTO;
import kr.or.ddit.domain.apt.mgmtOffice.dashboard.dto.MgmtDashboardRecentComplaintDTO;
import kr.or.ddit.domain.apt.mgmtOffice.dashboard.dto.MgmtDashboardRecentReservationDTO;
import kr.or.ddit.domain.apt.mgmtOffice.dashboard.dto.MgmtDashboardRecentResidentAuthDTO;
import kr.or.ddit.domain.apt.mgmtOffice.dashboard.dto.MgmtDashboardReservationStatDTO;
import kr.or.ddit.domain.apt.mgmtOffice.dashboard.dto.MgmtDashboardTopFacilityDTO;

@Mapper
public interface IMgmtDashboardMapper {
    int countPendingComplaint(String aptCmplexNo);

    int countPendingResidentAuth(String aptCmplexNo);

    int countUseRestrictWithin7(String mgmtOfcNo);

    int countBillUnpaidOverdue(String aptCmplexNo);

    MgmtDashboardBillStatDTO selectBillStat(String aptCmplexNo);

    MgmtDashboardMonthlyStatDTO selectMonthlyStat(
            @Param("aptCmplexNo") String aptCmplexNo,
            @Param("mgmtOfcNo") String mgmtOfcNo
    );

    List<MgmtDashboardRecentComplaintDTO> selectRecentComplaintList(String aptCmplexNo);

    List<MgmtDashboardRecentResidentAuthDTO> selectRecentResidentAuthList(String aptCmplexNo);

    List<MgmtDashboardRecentCheckDTO> selectRecentCheckList(String mgmtOfcNo);

    MgmtDashboardReservationStatDTO selectReservationStat(String aptCmplexNo);

    List<MgmtDashboardRecentReservationDTO> selectRecentReservationList(String aptCmplexNo);

    List<MgmtDashboardTopFacilityDTO> selectTopFacilityList(String aptCmplexNo);

    List<MgmtDashboardOperationTrendDTO> selectOperationTrend(
            @Param("aptCmplexNo") String aptCmplexNo,
            @Param("mgmtOfcNo") String mgmtOfcNo
    );
}
