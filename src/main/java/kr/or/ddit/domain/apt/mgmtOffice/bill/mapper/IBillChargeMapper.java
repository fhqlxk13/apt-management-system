package kr.or.ddit.domain.apt.mgmtOffice.bill.mapper;

import kr.or.ddit.domain.apt.mgmtOffice.bill.vo.BillDetailVO;
import kr.or.ddit.domain.apt.mgmtOffice.bill.vo.BillVO;
import kr.or.ddit.domain.apt.mgmtOffice.bill.vo.ExpenseVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface IBillChargeMapper {

    /**
     * @Author 이윤진
     * @param aptCmplexNo
     * @param billYm
     * 해당단지/월에 이미 관리비가 부과되었는지 확인
     */
    public int selectBillChargeExistsCount(@Param ("aptCmplexNo") String aptCmplexNo,
                                           @Param ("billYm") String billYm);

    // 관리비 부과 대상 세대 목록 조회
    public List<BillVO> selectBillTargetHouseList(@Param("aptCmplexNo") String aptCmplexNo);

    // 관리비 부과용 월별 지출 항목 합계 조회
    public List<ExpenseVO> selectExpenseSummaryForCharge(@Param("aptCmplexNo") String aptCmplexNo,
                                                         @Param("expenseYr")int expenseYr,
                                                         @Param("expenseMm") int expenseMm);

    // 관리비 등록
    void insertBill(BillVO billVO);

    // 관리비상세 등록
    void insertBillDetail(BillDetailVO detailVO);

    int insertBillBatch(BillVO batchVO);

    int insertExpenseBillDetailBatch(BillVO batchVO);

    int insertMeterBillDetailBatch(BillVO batchVO);

    int updateBillTotalAmtBatch(BillVO batchVO);
}
