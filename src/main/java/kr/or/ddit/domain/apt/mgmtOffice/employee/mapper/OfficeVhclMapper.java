package kr.or.ddit.domain.apt.mgmtOffice.employee.mapper;


import kr.or.ddit.domain.member.resident.vo.RsidVhclVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@SuppressWarnings("MybatisXMapperMethodInspection")
@Mapper
public interface OfficeVhclMapper {

    int insertVehicle(RsidVhclVO vo);

    List<RsidVhclVO> getVehicleList(
            @Param("aptCmplexNo") String aptCmplexNo);

    RsidVhclVO selectVehicleById(String rsidVhclNo);

    int updateVehicle(RsidVhclVO vo);

    int deleteVehicle(String rsidVhclNo);

    Map<String, Object> searchResident(Map<String, Object> param);

    void updateVehicleStatus(
            @Param("rsidVhclNo") String rsidVhclNo,
            @Param("status") String status
    );
}
