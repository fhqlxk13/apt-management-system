package kr.or.ddit.domain.apt.mgmtOffice.employee.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.domain.member.manager.vo.ManagerVO;
import kr.or.ddit.domain.apt.mgmtOffice.employee.DTO.MemberSearchDTO;
import kr.or.ddit.domain.apt.mgmtOffice.employee.vo.MngrRqstVO;

public interface IEmployeeService {

    // 재직 직원
    // 재직 직원 목록 조회
    List<ManagerVO> selectEmployeeList(Map<String, Object> paramMap);
    // 직원 상세 조회
    ManagerVO selectEmployeeDetail(String userNo, String mgmtOfcNo);
    // 직원 직무 수정
    boolean updateEmployeeDuty(ManagerVO vo);


    // 신청 직원
    // 직원 계정 요청 목록 조회
    List<MngrRqstVO> selectRequestList(Map<String, Object> paramMap);
    // 직원 계정 요청 상세 조회
    MngrRqstVO selectRequestDetail(String rqstNo, String mgmtOfcNo);
    // 직원 계정 요청 등록
    boolean insertRequest(MngrRqstVO vo, String mgmtOfcNo);
    // 직원 계정 요청 수정
    boolean updateRequest(MngrRqstVO vo, String mgmtOfcNo);
    // 직원 계정 요청 취소
    boolean cancelRequest(MngrRqstVO vo, String mgmtOfcNo);
    // 직원 등록용 회원 검색
    List<MemberSearchDTO> selectMemberSearchList(String keyword, String mgmtOfcNo);
}