package kr.or.ddit.domain.central.service;

import kr.or.ddit.domain.apt.main.vo.AptComplexVO;
import kr.or.ddit.common.model.PaginationInfoVO;

import java.util.List;

public interface ICentralAptComplexService {

    List<AptComplexVO> selectAptComplexList(
            PaginationInfoVO<AptComplexVO> pagingVO
    );

    List<AptComplexVO> searchApt(String keyword);

    int selectAptComplexCount(
            PaginationInfoVO<AptComplexVO> pagingVO
    );

    List<String> selectSigunguList(String sidoNm);

    List<String> selectSidoList();

    AptComplexVO selectAptComplexDetail(String aptCmplexNo);

    List<AptComplexVO> selectAptMapList();

    List<String> selectDongList(String sidoNm, String sigunguNm);
}
