package kr.or.ddit.domain.apt.mgmtOffice.dashboard.dto;

import lombok.Data;

@Data
public class MgmtDashboardMonthlyStatDTO {
    private int cvplTotal;
    private int cvplDone;
    private int checkTotal;
    private int checkDone;
    private int authTotal;
    private int authDone;
}
