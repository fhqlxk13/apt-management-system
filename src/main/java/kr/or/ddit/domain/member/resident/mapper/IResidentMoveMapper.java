package kr.or.ddit.domain.member.resident.mapper;

import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;

@Mapper
public interface IResidentMoveMapper {
    List<Map<String, Object>> selectHoList(Map<String, Object> params);

    void insertMoveIn(Map<String, Object> params);

    void insertMoveOut(Map<String, Object> params);

    String selectMngNo(String aptCmplexNo);

    void updateInoutCd(Map<String, Object> params);
}
