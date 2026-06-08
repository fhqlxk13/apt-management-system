package kr.or.ddit.domain.apt.mgmtOffice.bill.service;

import java.util.Map;

public interface IBillStatisticsService {

    Map<String, Object> selectBillStatistics(String mgmtOfcNo, String fromYm, String toYm);
}
