package kr.or.ddit.domain.apt.mgmtOffice.dashboard.dto;

import lombok.Data;

@Data
public class MgmtDashboardRecentReservationDTO {
    private String cmnFacilityNm;
    private String userNm;
    private String hoNo;
    private String rsvtDt;
    private String rsvtBgngDttm;
    private String rsvtSttsCd;
}
