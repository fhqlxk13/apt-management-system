package kr.or.ddit.domain.apt.mgmtOffice.dashboard.dto;

import lombok.Data;

@Data
public class MgmtDashboardRecentResidentAuthDTO {
    private String rqstNo;
    private String userNm;
    private String hoNo;
    private String rqstTy;
    private String regDt;
    private String rqstSttsCd;
}
