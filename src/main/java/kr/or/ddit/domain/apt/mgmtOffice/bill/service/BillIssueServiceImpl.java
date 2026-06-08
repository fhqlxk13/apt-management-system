package kr.or.ddit.domain.apt.mgmtOffice.bill.service;

import kr.or.ddit.common.model.PaginationInfoVO;
import kr.or.ddit.domain.apt.mgmtOffice.bill.mapper.IBillIssueMapper;
import kr.or.ddit.domain.apt.mgmtOffice.bill.vo.BillDetailVO;
import kr.or.ddit.domain.apt.mgmtOffice.bill.vo.BillVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class BillIssueServiceImpl implements IBillIssueService{

    @Autowired
    private IBillIssueMapper billIssueMapper;

    @Override
    public List<BillVO> selectBillDongList(String aptCmplexNo) {
        return billIssueMapper.selectBillDongList(aptCmplexNo);
    }

    @Override
    public PaginationInfoVO<BillVO> selectBillIssueList(PaginationInfoVO<BillVO> pagingVO) {
        // 1. 총 건수 조회
        int totalRecord = billIssueMapper.selectBillIssueCount(pagingVO);

        // 2. totalRecord 세팅 시 totalPage 자동 계산
        pagingVO.setTotalRecord(totalRecord);

        // 3. currentPage 세팅 시 startRow/endRow/startPage/endPage 자동 계산
        pagingVO.setCurrentPage(pagingVO.getCurrentPage());

        // 4. 목록 조회
        List<BillVO> dataList = billIssueMapper.selectBillIssueList(pagingVO);
        pagingVO.setDataList(dataList);

        return pagingVO;
    }

    @Override
    public BillVO selectBillIssueDetail(String aptCmplexNo, String billNo) {
        BillVO billVO = billIssueMapper.selectBillIssueDetail(aptCmplexNo, billNo);

        if (billVO == null) {
            throw new IllegalArgumentException("고지서 정보를 찾을 수 없습니다.");
        }

        List<BillDetailVO> detailList = billIssueMapper.selectBillDetailList(billNo);
        billVO.setDetailList(detailList);

        return billVO;
    }
}
