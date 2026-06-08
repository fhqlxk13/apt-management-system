package kr.or.ddit.domain.apt.mgmtOffice.resident.mapper;

import kr.or.ddit.domain.apt.mgmtOffice.resident.vo.MngResidentAuthVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;

@Mapper
public interface IMngResidentAuthMapper {

    List<MngResidentAuthVO> selectResidentAuthList();

    int rejectResidentAuth(MngResidentAuthVO vo);

    int approveResidentAuth(MngResidentAuthVO vo);

    MngResidentAuthVO selectResidentAuthByRqstNo(int rqstNo);

    int updateResidentLive(Map<String, Object> param);


    void updateAuth(String userNo);
}
