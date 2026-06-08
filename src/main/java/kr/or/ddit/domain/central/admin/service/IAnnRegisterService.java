package kr.or.ddit.domain.central.admin.service;

import kr.or.ddit.domain.apt.main.vo.AptComplexVO;

import java.util.List;
import java.util.Map;

public interface IAnnRegisterService {

    List<String> selectSidoList();

    List<String> selectSigunguList(String sidoNm);

    List<String> selectEmdList(String sidoNm, String sigunguNm);

    List<AptComplexVO> selectAptList(String sidoNm, String sigunguNm, String emdNm);

    Map<String, Object> selectOneAptDetail(String aptCmplexNo);

    List<Map<String, Object>> selectSbmsnDocList(List<String> rentLstgNoList);

    void insertAnn(Map<String, Object> params);

    List<Map<String, Object>> selectRentList(String aptCmplexNo);



}
