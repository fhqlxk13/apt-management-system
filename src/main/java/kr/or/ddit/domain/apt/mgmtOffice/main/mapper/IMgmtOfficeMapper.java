package kr.or.ddit.domain.apt.mgmtOffice.main.mapper;

import kr.or.ddit.domain.apt.mgmtOffice.main.vo.MgmtOfficeVO;
import kr.or.ddit.domain.apt.mgmtOffice.main.vo.ManagerPaginationVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface IMgmtOfficeMapper {

    MgmtOfficeVO selectMgmtOfficeByManagerUserNo(String userNo);

    MgmtOfficeVO selectMgmtOfficeByMgmtOfcNo(String mgmtOfcNo);

    MgmtOfficeVO selectOneMgmtOffice(String aptCmplexNo);


    // 전체 관리사무소 조회
    //List<MgmtOfficeVO> selectAllMgmtOffice();
    // ADMIN 관리사무소 모달 전체 건수 조회
    int selectAdminMgmtOfficeCount(ManagerPaginationVO<MgmtOfficeVO> pagingVO);
    // ADMIN 관리사무소 모달 현재 페이지 목록 조회
    List<MgmtOfficeVO> selectAdminMgmtOfficeList(ManagerPaginationVO<MgmtOfficeVO> pagingVO);
    // ADMIN 관리사무소 모달 시도 목록 조회
    List<String> selectAdminMgmtOfficeSidoList();
    // ADMIN 관리사무소 모달 시군구 목록 조회
    List<String> selectAdminMgmtOfficeSigunguList(String sidoNm);

    // 아파트 단지번호로 관리사무소 정보 조회
    MgmtOfficeVO selectMgmtOfficeByAptCmplexNo(String aptCmplexNo);

    String selectAptComplexNo(String mgmtOfcNo);
}
