package kr.or.ddit.domain.apt.mgmtOffice.complaint.mapper;

import kr.or.ddit.common.model.PaginationInfoVO;
import kr.or.ddit.domain.apt.mgmtOffice.complaint.dto.ManagerComplaintDTO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;

@Mapper
public interface ManagerComplaintMapper {
    int selectComplaintCount(PaginationInfoVO<ManagerComplaintDTO> page);

    List<ManagerComplaintDTO> selectComplaintList(PaginationInfoVO<ManagerComplaintDTO> page);

    int updateCvplStts(ManagerComplaintDTO dto);

    void insertCvplHstry(ManagerComplaintDTO dto);

    List<ManagerComplaintDTO> selectMngrList(String mgmtOfcNo);

    List<Map<String, Object>> selectCvplFileList(String cvplFileNo);
}
