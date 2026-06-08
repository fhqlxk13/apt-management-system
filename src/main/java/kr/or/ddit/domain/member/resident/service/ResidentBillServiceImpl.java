package kr.or.ddit.domain.member.resident.service;

import kr.or.ddit.domain.apt.mgmtOffice.bill.vo.BillDetailVO;
import kr.or.ddit.domain.apt.mgmtOffice.bill.vo.BillVO;
import kr.or.ddit.domain.member.resident.mapper.IResidentBillMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ResidentBillServiceImpl implements IResidentBillService{

    @Autowired
    private IResidentBillMapper residentBillMapper;

    @Override
    public List<BillVO> selectMyHouseList(String userNo) {
        List<BillVO> houseList = residentBillMapper.selectMyHouseList(userNo);

        if (houseList == null || houseList.isEmpty()) {
            throw new IllegalArgumentException("입주민 세대 정보를 찾을 수 없습니다.");
        }

        return houseList;
    }

    @Override
    public List<BillVO> selectMyBillList(String userNo, String hoNo, String billYm) {
        if (hoNo == null || hoNo.isBlank()) {
            throw new IllegalArgumentException("조회할 세대를 선택해 주세요.");
        }

        BillVO searchVO = new BillVO();
        searchVO.setUserNo(userNo);
        searchVO.setHoNo(hoNo);
        searchVO.setBillYm(billYm);

        return residentBillMapper.selectMyBillList(searchVO);
    }

    @Override
    public BillVO selectMyBillDetail(String userNo, String billNo) {
        BillVO billVO = residentBillMapper.selectMyBillDetail(userNo, billNo);

        if (billVO == null) {
            throw new IllegalArgumentException("관리비 고지서를 찾을 수 없습니다.");
        }

        List<BillDetailVO> detailList = residentBillMapper.selectBillDetailList(billNo);
        billVO.setDetailList(detailList);

        return billVO;
    }

    @Override
    public List<BillVO> selectYearBillList(String hoNo, String billYear) {
        if (hoNo == null || hoNo.isBlank()) {
            throw new IllegalArgumentException("세대번호가 없습니다.");
        }

        if (billYear == null || !billYear.matches("\\d{4}")) {
            throw new IllegalArgumentException("조회연도는 YYYY 형식이어야 합니다.");
        }

        return residentBillMapper.selectYearBillList(hoNo, billYear);
    }

}
