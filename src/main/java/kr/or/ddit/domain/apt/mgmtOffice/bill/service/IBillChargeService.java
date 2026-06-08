package kr.or.ddit.domain.apt.mgmtOffice.bill.service;

import java.util.Map;

public interface IBillChargeService {
    public Map<String, Object> previewBillCharge(String aptCmplexNo, String billYm);

    public Map<String, Object> executeBillCharge(java.lang.String aptCmplexNo, java.lang.String billYm, java.lang.String dueDt);
}
