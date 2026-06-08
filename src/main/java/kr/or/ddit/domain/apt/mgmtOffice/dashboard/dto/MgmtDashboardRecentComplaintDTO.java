package kr.or.ddit.domain.apt.mgmtOffice.dashboard.dto;

import lombok.Data;

@Data
public class MgmtDashboardRecentComplaintDTO {
    private String cvplNo;
    private String ttl;
    private String hoNo;
    private String regDt;
    private String cvplSttsCd;
    private String prrtCd;
}
