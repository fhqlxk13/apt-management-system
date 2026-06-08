package kr.or.ddit.domain.apt.mgmtOffice.resident.service;

import kr.or.ddit.domain.apt.mgmtOffice.resident.dto.MngResidentListSearchDTO;
import kr.or.ddit.domain.apt.mgmtOffice.resident.mapper.IMngResidentListMapper;
import kr.or.ddit.domain.apt.mgmtOffice.resident.vo.MngResidentListVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.Collections;
import java.util.List;

@Service
@RequiredArgsConstructor
public class MngResidentListServiceImpl implements IMngResidentListService {

    private final IMngResidentListMapper residentListMapper;

    @Override
    public List<MngResidentListVO> selectResidentList(MngResidentListSearchDTO searchDTO) {
        if (searchDTO == null || searchDTO.getMgmtOfcNo() == null || searchDTO.getMgmtOfcNo().isBlank()) {
            return Collections.emptyList();
        }
        List<MngResidentListVO> list = residentListMapper.selectResidentList(searchDTO);
        return list == null ? Collections.emptyList() : list;
    }

    @Override
    public MngResidentListVO selectResidentDetail(String mgmtOfcNo, String userNo) {
        if (mgmtOfcNo == null || mgmtOfcNo.isBlank() || userNo == null || userNo.isBlank()) {
            return null;
        }
        return residentListMapper.selectResidentDetail(mgmtOfcNo, userNo);
    }
}
