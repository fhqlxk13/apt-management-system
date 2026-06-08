package kr.or.ddit.domain.central.service;

import kr.or.ddit.domain.central.mapper.IFacilityHistoryMapper;
import kr.or.ddit.domain.central.vo.FacilityHistoryVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Slf4j
@Service
public class FaciltyHistoryImpl implements IFacilityHistoryService {

    @Autowired
    private IFacilityHistoryMapper mapper;

    @Override
    public List<FacilityHistoryVO> getFacilityHistoryList() {
        return mapper.selectFacilityHistoryList();
    }

    @Override
    public FacilityHistoryVO getFacilityHistoryDetail(String id) {
        return mapper.selectFacilityHistoryDetail(id);
    }
}
