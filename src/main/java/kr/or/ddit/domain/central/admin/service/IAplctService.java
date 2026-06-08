package kr.or.ddit.domain.central.admin.service;

import kr.or.ddit.domain.central.admin.dto.AplctDTO;

import java.util.List;
import java.util.Map;

public interface IAplctService {

    List<AplctDTO> selectAplctList();

    int approveAplct(List<Map<String, Object>> updateList, String manager);

}
