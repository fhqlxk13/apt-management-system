package kr.or.ddit.domain.apt.mgmtOffice.employee.mapper;

import kr.or.ddit.domain.member.manager.vo.ManagerVO;
import kr.or.ddit.domain.apt.mgmtOffice.employee.DTO.MemberSearchDTO;
import kr.or.ddit.domain.apt.mgmtOffice.employee.vo.MngrRqstVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface IEmployeeMapper {

    // 재직 직원 목록 조회
    List<ManagerVO> selectEmployeeList(Map<String, Object> paramMap);

    // 재직 직원 상세 조회
    ManagerVO selectEmployeeDetail(
            @Param("userNo") String userNo,
            @Param("mgmtOfcNo") String mgmtOfcNo
    );

    // 재직 직원 직무 수정
    int updateEmployeeDuty(ManagerVO vo);

    // 직원 계정 요청 목록 조회
    List<MngrRqstVO> selectRequestList(Map<String, Object> paramMap);

    // 직원 계정 요청 상세 조회
    MngrRqstVO selectRequestDetail(
            @Param("rqstNo") String rqstNo,
            @Param("mgmtOfcNo") String mgmtOfcNo
    );

    // 직원 계정 요청 등록
    int insertRequest(MngrRqstVO vo);

    // 직원 계정 요청 수정
    int updateRequest(MngrRqstVO vo);

    // 직원 계정 요청 취소
    int cancelRequest(MngrRqstVO vo);

    // 직원 등록용 회원 검색
    List<MemberSearchDTO> selectMemberSearchList(
            @Param("keyword") String keyword,
            @Param("mgmtOfcNo") String mgmtOfcNo
    );
}