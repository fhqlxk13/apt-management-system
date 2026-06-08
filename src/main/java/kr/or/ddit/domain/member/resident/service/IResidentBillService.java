package kr.or.ddit.domain.member.resident.service;

import kr.or.ddit.domain.apt.mgmtOffice.bill.vo.BillVO;

import java.util.List;

public interface IResidentBillService {

    public List<BillVO> selectMyHouseList(String userNo);

    public List<BillVO> selectMyBillList(String userNo, String hoNo, String billYm);

    public BillVO selectMyBillDetail(String userNo, String billNo);

    List<BillVO> selectYearBillList(String hoNo, String billYear);
}
