package kr.or.ddit.domain.central.admin.mapper;

import kr.or.ddit.domain.central.admin.dto.AplctDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface IAplctMapper {

    List<AplctDTO> selectAplctList();

    int updateAplctStatus(@Param("updateList") List<Map<String, Object>> updateList);

    List<String> getRentLstgNoByAplctNo(@Param("aplctNo") String aplctNo);

    int updateDealSttsCdByRentLstgNo(@Param("rentLstgNo") String selected);
}
