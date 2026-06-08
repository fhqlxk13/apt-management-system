package kr.or.ddit.domain.apt.mgmtOffice.main.mapper;

import kr.or.ddit.domain.apt.main.vo.AptDetailGridDTO;
import kr.or.ddit.domain.apt.mgmtOffice.main.vo.UpdateBuildingStructureDTO;
import kr.or.ddit.domain.apt.mgmtOffice.main.vo.UpdateHoStatusDTO;
import org.apache.ibatis.annotations.Mapper;

import java.util.Map;

@Mapper
public interface IMgmtAptComplexEditMapper {
    void updateStructureRemoved(String hoNo);

    int restoreStructureHo(String hoNo);

    int insertAptDetail(AptDetailGridDTO dto);

    void recalculateMaxFloor(String aptCmplexNo);

    void recalculateTotalHousehold(String aptCmplexNo);

    void updateHoStatus(UpdateHoStatusDTO dto);

    void updateHoType(Map<String, Object> hoNoList);

    void updateDongName(UpdateBuildingStructureDTO dto);
}
