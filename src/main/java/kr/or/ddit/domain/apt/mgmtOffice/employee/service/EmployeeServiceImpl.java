package kr.or.ddit.domain.apt.mgmtOffice.employee.service;

import kr.or.ddit.common.enums.member.mngr.MngrRqstStatusCd;
import kr.or.ddit.domain.apt.mgmtOffice.employee.mapper.IEmployeeMapper;
import kr.or.ddit.domain.member.manager.vo.ManagerVO;
import kr.or.ddit.domain.apt.mgmtOffice.employee.DTO.MemberSearchDTO;
import kr.or.ddit.domain.apt.mgmtOffice.employee.vo.MngrRqstVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class EmployeeServiceImpl implements IEmployeeService {

    @Autowired
    private IEmployeeMapper employeeMapper;

    // 재직 직원 목록 조회
    @Override
    public List<ManagerVO> selectEmployeeList(Map<String, Object> paramMap) {
        return employeeMapper.selectEmployeeList(paramMap);
    }

    // 재직 직원 상세 조회
    @Override
    public ManagerVO selectEmployeeDetail(String userNo, String mgmtOfcNo) {
        return employeeMapper.selectEmployeeDetail(userNo, mgmtOfcNo);
    }

    // 재직 직원 직무 수정
    @Override
    public boolean updateEmployeeDuty(ManagerVO vo) {
        int result = employeeMapper.updateEmployeeDuty(vo);
        return result > 0;
    }

    // 직원 계정 요청 목록 조회
    @Override
    public List<MngrRqstVO> selectRequestList(Map<String, Object> paramMap) {
        return employeeMapper.selectRequestList(paramMap);
    }

    // 직원 계정 요청 상세 조회
    @Override
    public MngrRqstVO selectRequestDetail(String rqstNo, String mgmtOfcNo) {
        return employeeMapper.selectRequestDetail(rqstNo, mgmtOfcNo);
    }

    // 직원 계정 요청 등록
    @Override
    public boolean insertRequest(MngrRqstVO vo, String mgmtOfcNo) {
        vo.setMgmtOfcNo(mgmtOfcNo);
        vo.setRqstSttsCd(MngrRqstStatusCd.WAIT.name());

        int result = employeeMapper.insertRequest(vo);
        return result > 0;
    }

    // 직원 계정 요청 수정
    @Override
    public boolean updateRequest(MngrRqstVO vo, String mgmtOfcNo) {
        vo.setMgmtOfcNo(mgmtOfcNo);

        int result = employeeMapper.updateRequest(vo);
        return result > 0;
    }

    // 직원 계정 요청 취소
    @Override
    public boolean cancelRequest(MngrRqstVO vo, String mgmtOfcNo) {
        vo.setMgmtOfcNo(mgmtOfcNo);
        vo.setRqstSttsCd(MngrRqstStatusCd.CNL.name());

        int result = employeeMapper.cancelRequest(vo);
        return result > 0;
    }

    // 직원 등록용 회원 검색
    @Override
    public List<MemberSearchDTO> selectMemberSearchList(String keyword, String mgmtOfcNo) {
        return employeeMapper.selectMemberSearchList(keyword, mgmtOfcNo);
    }
}