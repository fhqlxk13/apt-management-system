package kr.or.ddit.domain.apt.mgmtOffice.resident.service;

import kr.or.ddit.domain.apt.mgmtOffice.resident.dto.MngResidentListSearchDTO;
import kr.or.ddit.domain.apt.mgmtOffice.resident.vo.MngResidentListVO;

import java.util.List;

public interface IMngResidentListService {

    List<MngResidentListVO> selectResidentList(MngResidentListSearchDTO searchDTO);

    MngResidentListVO selectResidentDetail(String mgmtOfcNo, String userNo);
}
