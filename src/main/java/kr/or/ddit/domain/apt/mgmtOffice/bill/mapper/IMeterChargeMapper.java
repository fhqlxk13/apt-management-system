package kr.or.ddit.domain.apt.mgmtOffice.bill.mapper;

import kr.or.ddit.common.model.PaginationInfoVO;
import kr.or.ddit.domain.apt.mgmtOffice.bill.vo.MeterChargeVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface IMeterChargeMapper {

    /*
     * 세대별 검침 사용량 전체 조회
     * XML의 #{searchVO.xxx} 조건과 맞추기 위해 PaginationInfoVO를 전달한다.
     */
    List<MeterChargeVO> selectMeterChargeList(PaginationInfoVO<MeterChargeVO> pagingVO);

    /* 검침값 저장 */
    int mergeMeterHistory(
            @Param("aptCmplexNo") String aptCmplexNo,
            @Param("billYm") String billYm,
            @Param("meter") MeterChargeVO meter
    );

    /* 현재 페이지 목록 조회 */
    List<MeterChargeVO> selectMeterChargePagingList(
            PaginationInfoVO<MeterChargeVO> pagingVO
    );

    /* 상단 합계 카드 조회 */
    List<MeterChargeVO> selectMeterChargeSummary(PaginationInfoVO<MeterChargeVO> pagingVO);

    /* 페이징 처리용 전체 건수 조회 */
    int selectMeterChargeCount(PaginationInfoVO<MeterChargeVO> pagingVO);
}
