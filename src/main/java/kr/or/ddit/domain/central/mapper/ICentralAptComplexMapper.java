package kr.or.ddit.domain.central.mapper;

import kr.or.ddit.domain.apt.main.vo.AptComplexVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface ICentralAptComplexMapper {


    int selectAptComplexCount(
            @Param("searchWord") String searchWord,
            @Param("searchType") String searchType,
            @Param("searchVO") AptComplexVO searchVO

    );

    // 아파트 단지 목록 조회 (페이징)
    List<AptComplexVO> selectAptComplexList(
            @Param("searchWord") String searchWord,
            @Param("searchType") String searchType,
            @Param("startRow") int startRow,
            @Param("endRow") int endRow,
            @Param("searchVO") AptComplexVO searchVO
    );

    // 시/도 목록 조회
    List<String> selectSidoList();

    // 시/군/구 목록 조회
    List<String> selectSigunguList(@Param("sidoNm") String sidoNm);

    // 검색
    List<AptComplexVO> searchApt(String keyword);

    // 단지 상세화면
    AptComplexVO selectAptComplexDetail(@Param("aptCmplexNo") String aptCmplexNo);


    List<String> selectDongList(@Param("sidoNm") String sidoNm,@Param("sigunguNm") String sigunguNm);

    List<AptComplexVO> selectAptMapList();

}

