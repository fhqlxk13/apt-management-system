package kr.or.ddit.domain.apt.mgmtOffice.complaint.service;

import kr.or.ddit.common.model.PaginationInfoVO;
import kr.or.ddit.domain.apt.mgmtOffice.complaint.dto.ManagerComplaintDTO;

import java.util.List;
import java.util.Map;

public interface ManagerComplaintService {
    int selectComplaintCount(PaginationInfoVO<ManagerComplaintDTO> page);

    List<ManagerComplaintDTO> selectComplaintList(PaginationInfoVO<ManagerComplaintDTO> page);

    void updateComplaint(ManagerComplaintDTO dto);

    List<ManagerComplaintDTO> selectMngrList(String mgmtOfcNo);

    List<Map<String, Object>> selectCvplFileList(String cvplFileNo);
}
