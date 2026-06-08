package kr.or.ddit.domain.apt.mgmtOffice.bill.service;

import kr.or.ddit.domain.apt.mgmtOffice.bill.mapper.IBillChargeMapper;
import kr.or.ddit.domain.apt.mgmtOffice.bill.vo.BillVO;
import kr.or.ddit.domain.apt.mgmtOffice.bill.vo.ExpenseVO;
import kr.or.ddit.domain.apt.mgmtOffice.bill.vo.MeterChargeVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.sql.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Service
public class BillChargeServiceImpl implements IBillChargeService {

    @Autowired
    private IBillChargeMapper billChargeMapper;

    @Autowired
    private IMeterChargeService meterChargeService;

    /**
     * 관리비 부과 전 미리보기
     * @Author 이윤진
     * @param aptCmplexNo
     * @param billYm
     * @return
     */
    @Override
    public Map<String, Object> previewBillCharge(String aptCmplexNo, String billYm) {

        validateBillYm(billYm);

        int expenseYr = Integer.parseInt(billYm.substring(0, 4));
        int expenseMm = Integer.parseInt(billYm.substring(4, 6));

        int alreadyChargedCount =
                billChargeMapper.selectBillChargeExistsCount(aptCmplexNo, billYm);

        List<BillVO> houseList =
                billChargeMapper.selectBillTargetHouseList(aptCmplexNo);

        List<ExpenseVO> expenseSummaryList =
                billChargeMapper.selectExpenseSummaryForCharge(aptCmplexNo, expenseYr, expenseMm);

        int householdCount = houseList == null ? 0 : houseList.size();

        long totalExpenseAmt = 0L;

        if (expenseSummaryList != null) {
            for (ExpenseVO expense : expenseSummaryList) {
                    totalExpenseAmt += expense.getExpenseAmt();
            }
        }

        /*
         * 검침요금 계산 목록 조회
         * - ELC/WTR/GAS 세대별 계산금액이 들어온다.
         * - 미리보기에서는 총 검침요금과 평균 예상금액만 계산한다.
         */
        List<MeterChargeVO> meterChargeList =
                meterChargeService.selectCalculatedMeterChargeList(aptCmplexNo, billYm);

        long totalMeterChargeAmt = 0L;

        if (meterChargeList != null) {
            for (MeterChargeVO meter : meterChargeList) {
                if (meter.getChargeAmt() != null) {
                    totalMeterChargeAmt += meter.getChargeAmt();
                }
            }
        }

        long expectedPerHouseAmt = 0L;
        long expectedAvgMeterAmt = 0L;
        long expectedAvgTotalAmt = 0L;

        if (householdCount > 0) {
            expectedPerHouseAmt = totalExpenseAmt / householdCount;
            expectedAvgMeterAmt = totalMeterChargeAmt / householdCount;
            expectedAvgTotalAmt = (totalExpenseAmt + totalMeterChargeAmt) / householdCount;
        }

        Map<String, Object> result = new HashMap<>();
        result.put("billYm", billYm);
        result.put("expenseYr", expenseYr);
        result.put("expenseMm", expenseMm);
        result.put("alreadyChargedCount", alreadyChargedCount);
        result.put("householdCount", householdCount);

        // 공용 지출 합계
        result.put("totalExpenseAmt", totalExpenseAmt);

        // 검침요금 합계
        result.put("totalMeterChargeAmt", totalMeterChargeAmt);

        // 기존 화면 호환용: 공용관리비 세대당 예상금액
        result.put("expectedPerHouseAmt", expectedPerHouseAmt);

        // 추가 미리보기용
        result.put("expectedAvgMeterAmt", expectedAvgMeterAmt);
        result.put("expectedAvgTotalAmt", expectedAvgTotalAmt);

        result.put("expenseSummaryList", expenseSummaryList);
        result.put("meterChargeCount", meterChargeList == null ? 0 : meterChargeList.size());

        return result;
    }

    @Transactional
    @Override
    public Map<String, Object> executeBillCharge(String aptCmplexNo, String billYm, String dueDt) {
        validateBillYm(billYm);
        validateDueDt(dueDt);

        int expenseYr = Integer.parseInt(billYm.substring(0, 4));
        int expenseMm = Integer.parseInt(billYm.substring(4, 6));

        /*
         * 1. 이미 해당 월 관리비가 부과되었는지 확인
         */
        int alreadyChargedCount =
                billChargeMapper.selectBillChargeExistsCount(aptCmplexNo, billYm);

        if (alreadyChargedCount > 0) {
            throw new IllegalStateException("이미 해당 월 관리비가 부과되어 있습니다.");
        }

        /*
         * 2. 부과 대상 세대 존재 여부 확인
         * - 기존 화면 결과와 householdCount 반환을 위해 조회는 유지한다.
         * - INSERT 자체는 Mapper 일괄 INSERT에서 처리한다.
         */
        List<BillVO> houseList =
                billChargeMapper.selectBillTargetHouseList(aptCmplexNo);

        if (houseList == null || houseList.isEmpty()) {
            throw new IllegalStateException("부과 대상 세대가 없습니다.");
        }

        /*
         * 3. 해당 월 지출 항목 존재 여부 확인
         */
        List<ExpenseVO> expenseSummaryList =
                billChargeMapper.selectExpenseSummaryForCharge(aptCmplexNo, expenseYr, expenseMm);

        if (expenseSummaryList == null || expenseSummaryList.isEmpty()) {
            throw new IllegalStateException("해당 월 지출 내역이 없습니다.");
        }

        /*
         * 4. 일괄 처리용 파라미터 세팅
         */
        BillVO batchVO = new BillVO();
        batchVO.setAptCmplexNo(aptCmplexNo);
        batchVO.setBillYm(billYm);
        batchVO.setDueDt(Date.valueOf(dueDt));

        /*
         * 5. BILL / BILL_DETAIL 일괄 INSERT
         * - 기존 Java 반복 INSERT 제거
         * - DB에서 INSERT SELECT로 한 번에 처리
         */
        int billInsertCount = billChargeMapper.insertBillBatch(batchVO);

        int expenseDetailCount = billChargeMapper.insertExpenseBillDetailBatch(batchVO);

        int meterDetailCount = billChargeMapper.insertMeterBillDetailBatch(batchVO);

        int billTotalUpdateCount = billChargeMapper.updateBillTotalAmtBatch(batchVO);

        /*
         * 6. 결과 집계
         */
        Map<String, Object> result = new HashMap<>();
        result.put("billYm", billYm);
        result.put("householdCount", houseList.size());
        result.put("billInsertCount", billInsertCount);
        result.put("detailInsertCount", expenseDetailCount + meterDetailCount);
        result.put("expenseDetailCount", expenseDetailCount);
        result.put("meterDetailCount", meterDetailCount);
        result.put("billTotalUpdateCount", billTotalUpdateCount);
        result.put("message", "관리비 부과가 완료되었습니다.");

        return result;
    }

    private void validateBillYm(String billYm) {
        if (billYm == null || !billYm.matches("\\d{6}")) {
            throw new IllegalArgumentException("관리년월은 YYYYMM 형식이어야 합니다.");
        }

        int month = Integer.parseInt(billYm.substring(4, 6));

        if (month < 1 || month > 12) {
            throw new IllegalArgumentException("관리월은 01월부터 12월 사이여야 합니다.");
        }
    }

    private void validateDueDt(String dueDt) {
        if (dueDt == null || !dueDt.matches("\\d{4}-\\d{2}-\\d{2}")) {
            throw new IllegalArgumentException("납부기한은 YYYY-MM-DD 형식이어야 합니다.");
        }
    }

}