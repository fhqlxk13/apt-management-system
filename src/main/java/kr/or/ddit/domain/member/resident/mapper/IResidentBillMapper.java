package kr.or.ddit.domain.member.resident.mapper;

import kr.or.ddit.domain.apt.mgmtOffice.bill.vo.BillDetailVO;
import kr.or.ddit.domain.apt.mgmtOffice.bill.vo.BillVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface IResidentBillMapper {

    // 로그인 사용자의 세대 정보 조회
    List<BillVO> selectMyHouseList(@Param("userNo") String userNo);

    // 내 관리비 목록 조회
    List<BillVO> selectMyBillList(BillVO billVO);

    // 내 관리비 상세 마스터 조회
    BillVO selectMyBillDetail(@Param("userNo") String userNo,
                              @Param("billNo") String billNo);

    List<BillDetailVO> selectBillDetailList(@Param("billNo") String billNo);

    /**
     * 선택 세대의 연도별 관리비 고지서 목록 조회
     * @param hoNo
     * @param billYear
     * @return 해당 연도 관리비 고지서 목록
     */
    List<BillVO> selectYearBillList(
            @Param("hoNo") String hoNo,
            @Param("billYear") String billYear
    );
}
