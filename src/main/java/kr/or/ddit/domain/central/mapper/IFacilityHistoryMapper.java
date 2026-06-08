package kr.or.ddit.domain.central.mapper;

import kr.or.ddit.domain.central.vo.FacilityHistoryVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface IFacilityHistoryMapper {


    List<FacilityHistoryVO> selectFacilityHistoryList();

    FacilityHistoryVO selectFacilityHistoryDetail(String id);
}
