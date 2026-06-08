package kr.or.ddit.domain.central.admin.mapper;

import kr.or.ddit.domain.apt.main.vo.AptDetailVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;

@Mapper
public interface IReactSalesMapper {
    List<String> selectBuildingList(String aptCmplexNo);

    List<AptDetailVO> selectHoList(String aptCmplexNo, String dongNm);

    void insertRentListing(Map<String, Object> map);

    String selectExistRentListing(String hoNo);

    void updateRentListing(Map<String, Object> map);

    Map<String, Object> selectCurrentContractInfo(String hoNo);

    void insertRentContractDoc(Map<String, Object> docMap);

    void deleteRentContractDoc(String rentLstgNo);

    void deleteRentListing(String rentLstgNo);
}
