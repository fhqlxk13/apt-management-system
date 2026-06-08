package kr.or.ddit.domain.central.service;

import kr.or.ddit.domain.central.vo.FacilityHistoryVO;

import java.util.List;

public interface IFacilityHistoryService {
    List<FacilityHistoryVO> getFacilityHistoryList();

    FacilityHistoryVO getFacilityHistoryDetail(String id);
}
