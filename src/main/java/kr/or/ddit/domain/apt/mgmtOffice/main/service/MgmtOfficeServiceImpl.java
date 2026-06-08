package kr.or.ddit.domain.apt.mgmtOffice.main.service;

import kr.or.ddit.domain.apt.mgmtOffice.main.mapper.IMgmtOfficeMapper;
import kr.or.ddit.domain.apt.mgmtOffice.main.vo.MgmtOfficeVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class MgmtOfficeServiceImpl implements IMgmtOfficeService {

    @Autowired
    private IMgmtOfficeMapper mgmtOfficeMapper;

    @Override
    public MgmtOfficeVO selectMgmtOfficeByManagerUserNo(String userId) {
        return mgmtOfficeMapper.selectMgmtOfficeByManagerUserNo(userId);
    }

    /**
     * 아파트 단지번호 기준으로 관리사무소 정보를 조회한다.
     * HeaderModelAdvice에서 관리소장/입주민 공통으로 사용한다.
     */
    @Override
    public MgmtOfficeVO selectMgmtOfficeByAptCmplexNo(String aptCmplexNo) {
        return mgmtOfficeMapper.selectMgmtOfficeByAptCmplexNo(aptCmplexNo);
    }
}
