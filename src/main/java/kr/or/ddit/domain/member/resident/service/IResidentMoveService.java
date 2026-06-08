package kr.or.ddit.domain.member.resident.service;

import java.util.List;
import java.util.Map;

public interface IResidentMoveService {
    List<Map<String, Object>> selectHoList(String userNo, String aptCmplexNo);

    void insertMoveIn(Map<String, Object> params);

    void insertMoveOut(Map<String, Object> params);
}
