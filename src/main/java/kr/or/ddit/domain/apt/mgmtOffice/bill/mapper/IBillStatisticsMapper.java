package kr.or.ddit.domain.apt.mgmtOffice.bill.mapper;

import kr.or.ddit.domain.apt.mgmtOffice.bill.vo.BillStatisticsVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface IBillStatisticsMapper {

    // 관리사무소 번호로 단지 조회
    String selectAptCmplexNoByMgmtOfcNo(String mgmtOfcNo);

    // 전체 요약 통계
    BillStatisticsVO selectBillSummary(BillStatisticsVO searchVO);

    // 월별 관리비 추이
    List<BillStatisticsVO> selectMonthlyBillStats(BillStatisticsVO searchVO);

    // 항목별 관리비 비중
    List<BillStatisticsVO> selectBillItemStats(BillStatisticsVO searchVO);

    // 납부상태별 통계
    List<BillStatisticsVO> selectPaymentStatusStats(BillStatisticsVO searchVO);

    // 세대별 관리비 TOP10
    List<BillStatisticsVO> selectHouseTopStats(BillStatisticsVO searchVO);
}
