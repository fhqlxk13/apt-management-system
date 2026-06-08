package kr.or.ddit.domain.apt.mgmtOffice.employee.service;

import kr.or.ddit.domain.apt.mgmtOffice.employee.vo.VstVhclRsvtVO;

import java.util.List;

public interface IVisitVhclService {
    List<VstVhclRsvtVO> getVisitVehicleList(String aptCmplexNo);

    void registerVisitVehicle(VstVhclRsvtVO vo);

    VstVhclRsvtVO getVisitVehicle(String vstVhclRsvtNo);

    void modifyVisitVehicle(VstVhclRsvtVO vo);

    void removeVisitVehicle(String vstVhclRsvtNo);
}
