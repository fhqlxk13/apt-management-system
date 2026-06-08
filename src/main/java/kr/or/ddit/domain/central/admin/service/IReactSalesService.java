package kr.or.ddit.domain.central.admin.service;

import kr.or.ddit.domain.apt.main.vo.AptDetailVO;

import java.util.List;
import java.util.Map;

public interface IReactSalesService {
    List<String> selectBuildingList(String aptCmplexNo);

    List<AptDetailVO> selectHoList(String aptCmplexNo, String dongNm);

    void registerRentListing(Map<String, Object> param);

    void deleteRentListing(List<String> hoNos);
}
