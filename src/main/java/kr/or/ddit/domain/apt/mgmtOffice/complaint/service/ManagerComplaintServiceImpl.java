package kr.or.ddit.domain.apt.mgmtOffice.complaint.service;

import kr.or.ddit.common.model.PaginationInfoVO;
import kr.or.ddit.domain.apt.mgmtOffice.complaint.dto.ManagerComplaintDTO;
import kr.or.ddit.domain.apt.mgmtOffice.complaint.mapper.ManagerComplaintMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class ManagerComplaintServiceImpl implements ManagerComplaintService{

    private final ManagerComplaintMapper managerComplaintMapper;

    @Override
    public int selectComplaintCount(PaginationInfoVO<ManagerComplaintDTO> page) {
        return managerComplaintMapper.selectComplaintCount(page);
    }

    @Override
    public List<ManagerComplaintDTO> selectComplaintList(PaginationInfoVO<ManagerComplaintDTO> page) {
        return managerComplaintMapper.selectComplaintList(page);
    }

    @Transactional
    public void updateComplaint(ManagerComplaintDTO dto) {
        if (List.of("COMP", "RJCT", "END").contains(dto.getCvplSttsCd())) {
            String today = new SimpleDateFormat("yyyy.MM.dd").format(new Date());
            dto.setCvplEndDt(today);
        }
        managerComplaintMapper.updateCvplStts(dto);
        managerComplaintMapper.insertCvplHstry(dto);
    }

    @Override
    public List<ManagerComplaintDTO> selectMngrList(String mgmtOfcNo) {
        return managerComplaintMapper.selectMngrList(mgmtOfcNo);
    }

    @Override
    public List<Map<String, Object>> selectCvplFileList(String cvplFileNo) {
        return managerComplaintMapper.selectCvplFileList(cvplFileNo);
    }
}
