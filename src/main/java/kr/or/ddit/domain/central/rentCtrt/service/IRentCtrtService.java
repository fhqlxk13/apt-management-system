package kr.or.ddit.domain.central.rentCtrt.service;

import java.util.List;
import java.util.Map;

public interface IRentCtrtService {

    List<Map<String, Object>> selectCtrt(int startRow, int endRow);

    // 오버로딩 필터 조회용
    List<Map<String, Object>> selectCtrt(Map<String, Object> params);

    int selectCtrtCount(String userNo);

    // 오버로딩 필터 조회용 카운트
    int selectCtrtCount(Map<String, Object> params);

    Map<String, Object> selectCtrtDashboard();

    Map<String, Object> selectOneCtrtDetail(String rentCtrtNo);

    int updateCtrt(String rentCtrtNo, Map<String, Object> detail);

    List<Map<String, Object>> selectCtrtXls(Map<String, Object> params);
}
