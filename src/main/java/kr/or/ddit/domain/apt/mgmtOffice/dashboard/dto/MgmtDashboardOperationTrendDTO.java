package kr.or.ddit.domain.apt.mgmtOffice.dashboard.dto;

import lombok.Data;

@Data
public class MgmtDashboardOperationTrendDTO {
    private String dayLabel;
    private int cvplCnt;
    private int checkCnt;
    private int authCnt;
}
