package kr.or.ddit.domain.apt.mgmtOffice.resident.service;

import kr.or.ddit.domain.apt.mgmtOffice.resident.vo.MngResidentAuthVO;

import java.util.List;

public interface IMngResidentAuthService {
    List<MngResidentAuthVO> selectResidentAuthList();


    int rejectResidentAuth(MngResidentAuthVO vo);

    int approveResidentAuth(MngResidentAuthVO vo);
}
