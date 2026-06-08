package kr.or.ddit.domain.apt.mgmtOffice.dashboard.dto;

import lombok.Data;

@Data
public class MgmtDashboardBillStatDTO {
    private String billYm;
    private int total;
    private int paid;
    private int unpaid;
    private int overdue;
    private long totalAmount;
}
