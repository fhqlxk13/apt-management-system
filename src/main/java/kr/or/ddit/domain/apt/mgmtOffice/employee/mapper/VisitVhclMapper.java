package kr.or.ddit.domain.apt.mgmtOffice.employee.mapper;

import kr.or.ddit.domain.apt.mgmtOffice.employee.vo.VstVhclRsvtVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface VisitVhclMapper {
    List<VstVhclRsvtVO> selectVisitVehicleList(String aptCmplexNo);

    void insertVisitVehicle(VstVhclRsvtVO vo);

    VstVhclRsvtVO selectVisitVehicle(String vstVhclRsvtNo);

    void updateVisitVehicle(VstVhclRsvtVO vo);

    void deleteVisitVehicle(String vstVhclRsvtNo);
}
