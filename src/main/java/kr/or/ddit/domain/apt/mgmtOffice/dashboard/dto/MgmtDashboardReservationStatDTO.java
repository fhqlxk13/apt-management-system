package kr.or.ddit.domain.apt.mgmtOffice.dashboard.dto;

import java.util.List;
import lombok.Data;

@Data
public class MgmtDashboardReservationStatDTO {
    private int todayCount;
    private int pendingCount;
    private int weekApprovedCount;
    private int weekRejectedCount;
    private String topFacilityNm;
    private Integer topFacilityCount;
    private List<MgmtDashboardTopFacilityDTO> topFacilityList;
    private List<MgmtDashboardRecentReservationDTO> recentList;
}
