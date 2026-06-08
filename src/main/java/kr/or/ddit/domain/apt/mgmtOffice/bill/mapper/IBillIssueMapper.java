package kr.or.ddit.domain.apt.mgmtOffice.bill.mapper;

import kr.or.ddit.common.model.PaginationInfoVO;
import kr.or.ddit.domain.apt.mgmtOffice.bill.vo.BillDetailVO;
import kr.or.ddit.domain.apt.mgmtOffice.bill.vo.BillVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface IBillIssueMapper {

    // 동 목록 조회
    List<BillVO> selectBillDongList(@Param("aptCmplexNo") String aptCmplexNo);

    // 고지서 총 개수
    int selectBillIssueCount(PaginationInfoVO<BillVO> pagingVO);

    // 고지서 페이징 목록 조회
    List<BillVO> selectBillIssueList(PaginationInfoVO<BillVO> pagingVO);

    // 고지서 상세 마스터 조회
    BillVO selectBillIssueDetail(
            @Param("aptCmplexNo") String aptCmplexNo,
            @Param("billNo") String billNo
    );

    // 고지서 상세 항목 조회
    List<BillDetailVO> selectBillDetailList(String billNo);
}
