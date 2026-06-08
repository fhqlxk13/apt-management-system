package kr.or.ddit.domain.apt.mgmtOffice.bill.service;

import kr.or.ddit.domain.apt.mgmtOffice.bill.mapper.IBillStatisticsMapper;
import kr.or.ddit.domain.apt.mgmtOffice.bill.vo.BillStatisticsVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

@Service
public class BillStatisticsServiceImpl implements IBillStatisticsService {

    @Autowired
    private IBillStatisticsMapper billStatisticsMapper;

    @Override
    public Map<String, Object> selectBillStatistics(String mgmtOfcNo, String fromYm, String toYm) {
        validateSearchCondition(mgmtOfcNo, fromYm, toYm);

        String aptCmplexNo = billStatisticsMapper.selectAptCmplexNoByMgmtOfcNo(mgmtOfcNo);

        if (aptCmplexNo == null || aptCmplexNo.isBlank()) {
            throw new IllegalArgumentException("관리사무소에 연결된 단지 정보를 찾을 수 없습니다.");
        }

        BillStatisticsVO searchVO = new BillStatisticsVO();
        searchVO.setMgmtOfcNo(mgmtOfcNo);
        searchVO.setAptCmplexNo(aptCmplexNo);
        searchVO.setFromYm(fromYm);
        searchVO.setToYm(toYm);

        Map<String, Object> result = new HashMap<>();

        result.put("summary", billStatisticsMapper.selectBillSummary(searchVO));
        result.put("monthlyList", billStatisticsMapper.selectMonthlyBillStats(searchVO));
        result.put("itemList", billStatisticsMapper.selectBillItemStats(searchVO));
        result.put("statusList", billStatisticsMapper.selectPaymentStatusStats(searchVO));
        result.put("houseTopList", billStatisticsMapper.selectHouseTopStats(searchVO));

        result.put("aptCmplexNo", aptCmplexNo);
        result.put("fromYm", fromYm);
        result.put("toYm", toYm);

        return result;
    }

    private void validateSearchCondition(String mgmtOfcNo, String fromYm, String toYm) {

        if (mgmtOfcNo == null || mgmtOfcNo.isBlank()) {
            throw new IllegalArgumentException("관리사무소 번호가 없습니다.");
        }

        if (fromYm == null || !fromYm.matches("\\d{6}")) {
            throw new IllegalArgumentException("시작월은 YYYYMM 형식이어야 합니다.");
        }

        if (toYm == null || !toYm.matches("\\d{6}")) {
            throw new IllegalArgumentException("종료월은 YYYYMM 형식이어야 합니다.");
        }

        if (fromYm.compareTo(toYm) > 0) {
            throw new IllegalArgumentException("시작월은 종료월보다 클 수 없습니다.");
        }
    }
}
