package kr.or.ddit.domain.apt.mgmtOffice.main.service;

import kr.or.ddit.common.model.PaginationInfoVO;
import kr.or.ddit.domain.apt.mgmtOffice.main.mapper.IAptScheduleCalendarMapper;
import kr.or.ddit.domain.apt.mgmtOffice.main.vo.AptScheduleCalendarDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.YearMonth;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 단지 일정 캘린더 Service 구현체
 * 구현체란? 인터페이스에 선언한 기능을 실제로 동작하게 만드는 클래스입니다.
 */
@Service
@RequiredArgsConstructor
public class AptScheduleCalendarServiceImpl implements IAptScheduleCalendarService {

    private final IAptScheduleCalendarMapper aptScheduleCalendarMapper;

    @Override
    public List<AptScheduleCalendarDTO> selectScheduleCalendarList(AptScheduleCalendarDTO searchDTO) {
        setSearchDefault(searchDTO);
        return aptScheduleCalendarMapper.selectScheduleCalendarList(searchDTO);
    }

    @Override
    public AptScheduleCalendarDTO selectScheduleCalendarStat(AptScheduleCalendarDTO searchDTO) {
        setSearchDefault(searchDTO);
        AptScheduleCalendarDTO statDTO = aptScheduleCalendarMapper.selectScheduleCalendarStat(searchDTO);
        return statDTO == null ? new AptScheduleCalendarDTO() : statDTO;
    }

    @Override
    public List<AptScheduleCalendarDTO> selectManagerEmployeeList(String mgmtOfcNo) {
        return aptScheduleCalendarMapper.selectManagerEmployeeList(mgmtOfcNo);
    }

    @Override
    @Transactional
    public int insertVacationSchedule(AptScheduleCalendarDTO aptScheduleCalendarDTO) {
        /*
         * @Transactional이란? SQL 여러 개를 하나의 작업 단위로 묶는 기능입니다.
         * 왜 사용? 중간에 오류가 나면 전체 작업을 취소해서 DB 데이터가 꼬이지 않게 하기 위해 사용합니다.
         */
        if (aptScheduleCalendarDTO.getScheduleNo() == null || aptScheduleCalendarDTO.getScheduleNo().isBlank()) {
            aptScheduleCalendarDTO.setScheduleNo(aptScheduleCalendarMapper.selectNextVacationScheduleNo());
        }
        return aptScheduleCalendarMapper.insertVacationSchedule(aptScheduleCalendarDTO);
    }

    @Override
    @Transactional
    public int updateVacationSchedule(AptScheduleCalendarDTO aptScheduleCalendarDTO) {
        /*
         * 휴가 일정 수정
         *
         * @Transactional이란?
         * DB 작업을 하나의 작업 단위로 묶는 기능입니다.
         * 왜 사용?
         * 수정 중 오류가 나면 DB 반영을 취소하기 위해 사용합니다.
         */
        return aptScheduleCalendarMapper.updateVacationSchedule(aptScheduleCalendarDTO);
    }

    @Override
    @Transactional
    public int deleteVacationSchedule(AptScheduleCalendarDTO aptScheduleCalendarDTO) {
        return aptScheduleCalendarMapper.deleteVacationSchedule(aptScheduleCalendarDTO);
    }

    /** 월 검색 시작일/종료일 기본값 세팅 */
    private void setSearchDefault(AptScheduleCalendarDTO searchDTO) {
        if (searchDTO.getAptCmplexNo() == null || searchDTO.getAptCmplexNo().isBlank()) {
            String aptCmplexNo = aptScheduleCalendarMapper.selectAptCmplexNoByMgmtOfcNo(searchDTO.getMgmtOfcNo());
            searchDTO.setAptCmplexNo(aptCmplexNo);
        }

        if (searchDTO.getMonthStartDt() == null || searchDTO.getMonthStartDt().isBlank()
                || searchDTO.getMonthEndDt() == null || searchDTO.getMonthEndDt().isBlank()) {
            YearMonth thisMonth = YearMonth.from(LocalDate.now());
            searchDTO.setMonthStartDt(thisMonth.atDay(1).toString());
            searchDTO.setMonthEndDt(thisMonth.atEndOfMonth().toString());
        }
    }

    @Override
    public Map<String, Object> selectScheduleCalendarPage(
            AptScheduleCalendarDTO searchVO,
            int currentPage
    ) {
        /*
         * 기본 검색조건 세팅
         * 왜 필요?
         * monthStartDt, monthEndDt, aptCmplexNo가 없으면
         * SQL에서 날짜 조건 오류가 나거나 조회가 안 될 수 있다.
         */
        setSearchDefault(searchVO);

        Map<String, Object> result = new HashMap<>();

        List<AptScheduleCalendarDTO> calendarList =
                aptScheduleCalendarMapper.selectScheduleCalendarList(searchVO);

        PaginationInfoVO<AptScheduleCalendarDTO> pagingVO =
                new PaginationInfoVO<>(10, 5);

        int totalRecord =
                aptScheduleCalendarMapper.selectScheduleCalendarCount(searchVO);

        pagingVO.setTotalRecord(totalRecord);
        pagingVO.setCurrentPage(currentPage);

        searchVO.setStartRow(pagingVO.getStartRow());
        searchVO.setEndRow(pagingVO.getEndRow());

        List<AptScheduleCalendarDTO> pageList =
                aptScheduleCalendarMapper.selectScheduleCalendarPagingList(searchVO);

        AptScheduleCalendarDTO stat =
                aptScheduleCalendarMapper.selectScheduleCalendarStat(searchVO);

        result.put("calendarList", calendarList);
        result.put("list", pageList);
        result.put("stat", stat == null ? new AptScheduleCalendarDTO() : stat);
        result.put("pagingHTML", pagingVO.getPagingHTML());
        result.put("currentPage", currentPage);
        result.put("totalRecord", totalRecord);

        return result;
    }

    @Override
    public String selectAptCmplexNoByMgmtOfcNo(String mgmtOfcNo) {
        return aptScheduleCalendarMapper.selectAptCmplexNoByMgmtOfcNo(mgmtOfcNo);
    }

    @Override
    public List<AptScheduleCalendarDTO> selectVacationTypeCodeList() {
        return aptScheduleCalendarMapper.selectVacationTypeCodeList();
    }

}
