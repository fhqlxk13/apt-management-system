package kr.or.ddit.domain.apt.mgmtOffice.main.service;

import kr.or.ddit.domain.apt.mgmtOffice.main.vo.UpdateBuildingStructureDTO;
import kr.or.ddit.domain.apt.mgmtOffice.main.vo.UpdateHoStatusDTO;

import java.util.Map;

public interface IMgmtAptComplexEditService {
    void updateBuildingStructure(UpdateBuildingStructureDTO dto);

    void updateHoStatus(UpdateHoStatusDTO dto);

    void updateHoType(Map<String, Object> paramMap);
}
