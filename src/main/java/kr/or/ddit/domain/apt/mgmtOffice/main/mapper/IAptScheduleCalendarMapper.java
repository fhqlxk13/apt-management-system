package kr.or.ddit.domain.apt.mgmtOffice.main.mapper;

import kr.or.ddit.domain.apt.mgmtOffice.main.vo.AptScheduleCalendarDTO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

/**
 * 단지 일정 캘린더 Mapper
 * Mapper란? Java 메서드와 MyBatis XML SQL을 연결하는 인터페이스입니다.
 * 왜 사용? Java 코드에서 SQL 문자열을 직접 작성하지 않고 XML로 분리하기 위해 사용합니다.
 */
@Mapper
public interface IAptScheduleCalendarMapper {

    /** 관리사무소 번호로 단지 번호 조회 */
    String selectAptCmplexNoByMgmtOfcNo(String mgmtOfcNo);

    /** 월간 캘린더 일정 목록 조회 */
    List<AptScheduleCalendarDTO> selectScheduleCalendarList(
            AptScheduleCalendarDTO searchDTO
    );

    /** 일정 통계 조회 */
    AptScheduleCalendarDTO selectScheduleCalendarStat(
            AptScheduleCalendarDTO searchDTO
    );

    /** 관리사무소 직원 목록 조회: 휴가 등록 select box용 */
    List<AptScheduleCalendarDTO> selectManagerEmployeeList(String mgmtOfcNo);

    /** 직원 휴가 일정 번호 채번 */
    String selectNextVacationScheduleNo();

    /** 직원 휴가 등록 */
    int insertVacationSchedule(
            AptScheduleCalendarDTO aptScheduleCalendarDTO
    );

    /** 직원 휴가 수정 */
    int updateVacationSchedule(
            AptScheduleCalendarDTO aptScheduleCalendarDTO
    );

    /** 직원 휴가 삭제 */
    int deleteVacationSchedule(
            AptScheduleCalendarDTO aptScheduleCalendarDTO
    );

    /** 일정 전체 개수 조회 */
    int selectScheduleCalendarCount(
            AptScheduleCalendarDTO searchVO
    );

    /** 일정 페이징 목록 조회 */
    List<AptScheduleCalendarDTO> selectScheduleCalendarPagingList(
            AptScheduleCalendarDTO searchVO
    );

    /** 휴가종류 공통코드 목록 조회 */
    List<AptScheduleCalendarDTO> selectVacationTypeCodeList();

}