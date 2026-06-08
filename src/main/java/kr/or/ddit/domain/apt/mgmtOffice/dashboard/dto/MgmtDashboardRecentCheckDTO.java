package kr.or.ddit.domain.apt.mgmtOffice.dashboard.dto;

import lombok.Data;

@Data
public class MgmtDashboardRecentCheckDTO {
    private String facilityNm;
    private String chkTyCd;
    private String chkDt;
    private String chkSttsCd;
}
