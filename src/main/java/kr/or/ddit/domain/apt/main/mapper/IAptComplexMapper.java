package kr.or.ddit.domain.apt.main.mapper;

import kr.or.ddit.common.model.PaginationInfoVO;
import kr.or.ddit.domain.apt.apiApartment.vo.AptHoTyDTO;
import kr.or.ddit.domain.apt.main.dto.AptMainPageDTO;
import kr.or.ddit.domain.apt.main.vo.AptComplexVO;
import kr.or.ddit.domain.apt.main.vo.AptDetailGridDTO;
import kr.or.ddit.domain.apt.main.vo.AptDetailVO;
import kr.or.ddit.domain.apt.main.vo.ComplexEditDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface IAptComplexMapper {
    AptComplexVO selectAptComplex(String aptCmplexNo);   // 단지 1건 조회

//  AptComplexVO selectAptDetailList(String aptCmplexNo);    // 단지 세대/호실 목록 조회

    List<String> selectSidoList();

    int selectMainAptCount(@Param("sidoNm") String sidoNm,
                           @Param("keyword") String keyword);

    List<AptComplexVO> selectMainAptList(@Param("pagingVO") PaginationInfoVO<AptComplexVO> pagingVO,
                                         @Param("sidoNm") String sidoNm,
                                         @Param("keyword") String keyword);

    AptComplexVO selectMgmtOfcNoAptComplex(String mgmtOfcNo);

    List<AptDetailGridDTO> selectComplexList(String aptCmplexNo);

    void updateComplex(ComplexEditDTO.SaveRequest request);

    String selectOneAptCmplexByMgmtOfcNo(String mgmtOfcNo);

    List<AptDetailGridDTO> selectAllHoByDong(String dongNo);

    List<AptHoTyDTO> getHoTypeList(String aptCmplexNo);
}
