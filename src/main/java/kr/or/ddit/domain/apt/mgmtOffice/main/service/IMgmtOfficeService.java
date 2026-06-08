package kr.or.ddit.domain.apt.mgmtOffice.main.service;

import kr.or.ddit.domain.apt.mgmtOffice.main.vo.MgmtOfficeVO;

public interface IMgmtOfficeService {
    MgmtOfficeVO selectMgmtOfficeByManagerUserNo(String userId);

    /**
     * 아파트 단지번호로 관리사무소 정보를 조회한다.
     *
     * 기존 selectMgmtOfficeByManagerUserNo는 관리소장 계정 기준 조회이므로
     * 입주민이 보는 화면의 공통 office 조회에는 사용할 수 없다.
     */
    MgmtOfficeVO selectMgmtOfficeByAptCmplexNo(String aptCmplexNo);
}
