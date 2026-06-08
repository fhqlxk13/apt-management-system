package kr.or.ddit.domain.member.resident.controller;

import kr.or.ddit.common.config.AuthService;
import kr.or.ddit.domain.apt.main.dto.AptMainPageDTO;
import kr.or.ddit.domain.apt.main.service.IAptComplexService;
import kr.or.ddit.domain.apt.mgmtOffice.main.service.IAptScheduleCalendarService;
import kr.or.ddit.domain.apt.mgmtOffice.main.service.IMgmtOfficeService;
import kr.or.ddit.domain.apt.mgmtOffice.main.vo.AptScheduleCalendarDTO;
import kr.or.ddit.domain.apt.mgmtOffice.survey.dto.MngSurveyDTO;
import kr.or.ddit.domain.apt.mgmtOffice.survey.service.IMngSurveyService;
import kr.or.ddit.domain.central.dto.FacilityInfoDTO;
import kr.or.ddit.domain.member.resident.dto.ResidentFacilityHistoryDTO;
import kr.or.ddit.domain.member.resident.service.IResidentFacilityService;
import kr.or.ddit.domain.member.resident.service.IResidentMoveService;
import kr.or.ddit.domain.member.resident.service.IResidentNoticeBoardService;
import kr.or.ddit.domain.member.resident.vo.MyAptVO;
import kr.or.ddit.domain.member.resident.vo.ResidentVO;
import kr.or.ddit.domain.member.vo.CustomUser;
import kr.or.ddit.domain.member.vo.MemberVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import kr.or.ddit.common.model.PaginationInfoVO;
import kr.or.ddit.domain.member.resident.dto.ResidentNoticeBoardDTO;
import tools.jackson.databind.ObjectMapper;
import kr.or.ddit.common.sms.service.ISmsService;

import java.util.HashMap;

import java.util.List;
import java.util.Map;

@Slf4j
@Controller
@RequestMapping("/resident")
public class ResidentMainController {

    @Autowired
    private IMgmtOfficeService mgmtOfficeService;

    @Autowired
    private IAptComplexService aptComplexService;

    @Autowired
    private IResidentFacilityService residentFacilityService;

    @Autowired
    private IResidentMoveService residentMoveService;

    @Autowired
    private IResidentNoticeBoardService residentNoticeBoardService;

    @Autowired
    private IMngSurveyService surveyService;
    @Autowired
    private AuthService authService;

    @Autowired
    private IAptScheduleCalendarService aptScheduleCalendarService;

    @Autowired
    private ISmsService smsService;

    /**
     * 내 아파트 목록 조회 컨트롤러
     *
     * @param customUser 인증 객체
     * @param model
     * @return myApt.jsp 내 아파트 목록 조회 페이지
     * @author 이용로
     */
    @PreAuthorize("hasRole('MEMBER')")
    @GetMapping("/myApt")
    public String myApt(@AuthenticationPrincipal CustomUser customUser, Model model) {
        log.info("myApt() 실행");
        MemberVO member = customUser.getMember();

        // 입주민이라면 customUser가 member=resident로 초기화 된 member를 반환받아 갖고 있음
        if (member instanceof ResidentVO resident) {  // 따라서 순수 member객체인지 resident를 담고있는 member객체인지 확인
            // 다운캐스팅
            log.info("RESIDENT INFO : {}", resident);

            model.addAttribute("resident", resident);
        }

        return "member/resident/myApt";
    }

    @GetMapping("/manage/operation")
    public String manageOperation() {
        return "member/resident/manage_operation";
    }


    /**
     * 입주민 우리 단지 일정 캘린더 화면 조회
     *
     * 왜 사용?
     * → 입주민이 단지의 공지, 행사, 공사, 검침, 점검,
     *   직원 휴가 일정을 캘린더 형태로 확인할 때 사용한다.
     *
     * @param aptCmplexNo 아파트 단지 번호
     * @param model JSP 화면 전달 객체
     * @return residentScheduleCalendar.jsp
     * 입주민 단지 일정 캘린더 화면 반환
     * @author 김보라
     */
    @GetMapping("/calendar/{aptCmplexNo}")
    public String residentScheduleCalendar(
            @PathVariable String aptCmplexNo,
            Model model
    ) {

        /*
         * @PathVariable 이란?
         * → URL 경로에 있는 값을 Java 변수로 받는 방식.
         *
         * 예:
         * /calendar/A10023118
         * → aptCmplexNo = A10023118
         */

        AptMainPageDTO.ResponseDto aptCommonDTO =
                aptComplexService.selectAptCommonDTO(aptCmplexNo);

        // aptInfo란?
        // header.jsp, sidebar.jsp에서 로고명/단지번호를 출력할 때 쓰는 공통 아파트 정보입니다.
        model.addAttribute("aptInfo", aptCommonDTO);

        /*
         * model.addAttribute란?
         * → Controller 데이터를 JSP로 전달하는 방식.
         *
         * 왜 사용?
         * → JSP에서 단지번호를 사용하기 위해 전달한다.
         */
        model.addAttribute("aptCmplexNo", aptCmplexNo);

        /*
         * 현재 활성화 메뉴명 전달
         *
         * 왜 사용?
         * → 사이드바에서 현재 메뉴를 강조(active) 처리하기 위해.
         */
        model.addAttribute("activeMenu", "residentCalendar");

        /*
         * 이동할 JSP 경로 반환
         */
        return "member/resident/calendar/residentScheduleCalendar";
    }

    /**
     * 입주민 우리 단지 일정 목록 AJAX 조회
     *
     * AJAX란?
     * → 화면 전체를 새로고침하지 않고
     *   필요한 데이터만 서버에서 받아오는 방식.
     *
     * 왜 사용?
     * → 달력 월 이동, 검색 시 화면 전체를 새로고침하지 않고
     *   일정 목록만 비동기로 조회하기 위해 사용한다.
     *
     * @param aptCmplexNo 아파트 단지 번호
     * @param searchVO 일정 검색조건 DTO
     * @return 일정 목록 JSON 반환
     * @author 김보라
     */
    @GetMapping("/calendar/{aptCmplexNo}/list")
    @ResponseBody
    public Map<String, Object> residentScheduleCalendarList(
            @PathVariable String aptCmplexNo,
            @RequestParam(value = "currentPage", defaultValue = "1") int currentPage,
            AptScheduleCalendarDTO searchVO
    ) {
        searchVO.setAptCmplexNo(aptCmplexNo);

        return aptScheduleCalendarService.selectScheduleCalendarPage(searchVO, currentPage);
    }

    /**
     * 입주민 우리 단지 일정 통계 AJAX 조회
     *
     * 왜 사용?
     * → 화면 상단의
     *   전체 일정 수, 오늘 일정 수, 월간 일정 수,
     *   직원 휴가 수 통계를 비동기로 조회하기 위해 사용한다.
     *
     * @param aptCmplexNo 아파트 단지 번호
     * @param searchVO 일정 검색조건 DTO
     * @return 일정 통계 JSON 반환
     * @author 김보라
     */
    @GetMapping("/calendar/{aptCmplexNo}/stat")
    @ResponseBody
    public AptScheduleCalendarDTO residentScheduleCalendarStat(
            @PathVariable String aptCmplexNo,
            AptScheduleCalendarDTO searchVO
    ) {
        /*
         * 단지번호 설정
         * → 해당 단지 기준 통계 조회.
         */
        searchVO.setAptCmplexNo(aptCmplexNo);
        /*
         * 일정 통계 조회 후 JSON 반환
         */
        return aptScheduleCalendarService.selectScheduleCalendarStat(searchVO);
    }

    /**
     * 입주민 시설관리이력 조회
     *
     * @param customUser        로그인 사용자 인증 객체
     * @param aptCmplexNo       아파트 단지 번호
     * @param currentPage       점검이력 현재 페이지 번호
     * @param facilityTyCd      시설 유형 코드
     * @param facilityPage      시설 목록 현재 페이지 번호
     * @param facilityNm        시설명 검색어
     * @param locCn             위치 검색어
     * @param dongNo            동 번호 검색조건
     * @param keyword           점검이력 통합 검색어
     * @param historyChkDt      점검일 검색조건
     * @param historyFacilityNm 점검 시설명 검색조건
     * @param historyChkCn      점검내용 검색조건
     * @param historyChkStts    점검상태 검색조건
     * @param historyPicNm      담당자 검색조건
     * @param sortColumn        시설정보 정렬 컬럼
     * @param sortOrder         시설정보 정렬 방향
     * @param historySortColumn 점검이력 정렬 컬럼
     * @param historySortOrder  점검이력 정렬 방향
     * @param model             JSP 화면 전달 객체
     * @return manage_facility.jsp
     * 입주민 시설정보 및 시설 점검이력 화면 반환
     * @author 김보라
     */
    @PreAuthorize("hasRole('RESIDENT')")
    @GetMapping("/manage/facility/{aptCmplexNo}")
    public String manageFacility(
            @AuthenticationPrincipal CustomUser customUser,
            @PathVariable String aptCmplexNo,
            @RequestParam(value = "currentPage", required = false, defaultValue = "1") int currentPage,
            @RequestParam(value = "facilityTyCd", required = false) String facilityTyCd,
            @RequestParam(value = "facilityPage", required = false, defaultValue = "1") int facilityPage,
            @RequestParam(value = "facilityNm", required = false) String facilityNm,
            @RequestParam(value = "locCn", required = false) String locCn,
            @RequestParam(value = "dongNo", required = false) String dongNo,
            @RequestParam(value = "keyword", required = false) String keyword,
            @RequestParam(value = "historyChkDt", required = false) String historyChkDt,
            @RequestParam(value = "historyFacilityNm", required = false) String historyFacilityNm,
            @RequestParam(value = "historyChkCn", required = false) String historyChkCn,
            @RequestParam(value = "historyChkStts", required = false) String historyChkStts,
            @RequestParam(value = "historyPicNm", required = false) String historyPicNm,
            @RequestParam(value = "sortColumn", required = false, defaultValue = "facility_ty_cd") String sortColumn,
            @RequestParam(value = "sortOrder", required = false, defaultValue = "ASC") String sortOrder,
            @RequestParam(value = "historySortColumn", required = false, defaultValue = "chk_dt") String historySortColumn,
            @RequestParam(value = "historySortOrder", required = false, defaultValue = "DESC") String historySortOrder,
            Model model
    ) {

        /*
         * @PreAuthorize("hasRole('RESIDENT')")
         * → 입주민 이상만 접근 가능.
         * SecurityConfig의 권한 계층 때문에 MNGR, ADMIN도 접근 가능.
         */

        String userNo = customUser.getMember().getUserNo();

        /*
         * aptCmplexNo가 없으면 로그인한 입주민의 단지번호를 DB에서 조회한다.
         */
        if (aptCmplexNo == null || aptCmplexNo.isBlank()) {
            aptCmplexNo = residentFacilityService.getResidentAptCmplexNo(userNo);
        }

        /* 공지게시글 수 */
        int screenSize = 10;
        int startRow = (currentPage - 1) * screenSize + 1;
        int endRow = currentPage * screenSize;

        List<ResidentFacilityHistoryDTO> statusCardList =
                residentFacilityService.getFacilityStatusCardList(aptCmplexNo);

        /*
         * 입주민 시설관리이력 화면용 단지 기본정보
         */
        FacilityInfoDTO facilityAptInfo = residentFacilityService.getAptInfo(aptCmplexNo);

        /*
         * 입주민 화면에 보여줄 단지 시설 목록
         */

        /*
         * 정렬 컬럼 검증
         * → 사용자가 임의로 이상한 컬럼명을 보내면 SQL 오류가 날 수 있다.
         * → 허용한 컬럼명만 ORDER BY에 사용한다.
         */
        switch (sortColumn) {
            case "facility_ty_cd":
            case "facility_nm":
            case "dong_no":
            case "loc_cn":
                break;
            default:
                sortColumn = "facility_ty_cd";
        }

        /*
         * 정렬 방향 검증
         * → ASC 또는 DESC만 허용한다.
         */
        if (!"DESC".equalsIgnoreCase(sortOrder)) {
            sortOrder = "ASC";
        } else {
            sortOrder = "DESC";
        }

        /*
         * 시설정보 전체 개수
         * → 총 몇 건인지 표시하고, 전체 페이지 수 계산에 사용한다.
         */
        int facilityTotalRecord = residentFacilityService.getResidentFacilityInfoCount(
                aptCmplexNo,
                facilityTyCd,
                facilityNm,
                dongNo,
                locCn
        );

        /* 동 정보 검색 */
        List<FacilityInfoDTO> facilityDongList =
                residentFacilityService.getFacilityDongList(aptCmplexNo);

        model.addAttribute("facilityDongList", facilityDongList);
        model.addAttribute("dongNo", dongNo);

        /*
         * PaginationInfoVO
         * screenSize = 5
         * → 한 페이지에 시설정보 5개씩 출력.
         * blockSize = 5
         * → 페이지 번호를 1 2 3 4 5 단위로 출력.
         */
        PaginationInfoVO<FacilityInfoDTO> facilityPagingVO = new PaginationInfoVO<>(5, 5);
        facilityPagingVO.setTotalRecord(facilityTotalRecord);
        facilityPagingVO.setCurrentPage(facilityPage);

        /*
         * 입주민 화면에 보여줄 단지 시설 목록
         * → 검색조건 + 정렬조건 + 페이징 범위를 같이 넘긴다.
         */
        List<FacilityInfoDTO> facilityInfoList =
                residentFacilityService.getResidentFacilityInfoList(
                        aptCmplexNo,
                        facilityTyCd,
                        facilityNm,
                        dongNo,
                        locCn,
                        sortColumn,
                        sortOrder,
                        facilityPagingVO.getStartRow(),
                        facilityPagingVO.getEndRow()
                );

        facilityPagingVO.setDataList(facilityInfoList);

        /*
         * 시설 점검 상세 이력 정렬 컬럼 검증
         *
         * 왜 필요?
         * → 사용자가 URL에 이상한 컬럼명을 넣으면 SQL 오류가 나거나
         *   SQL Injection 위험이 생길 수 있어서 허용된 컬럼만 사용한다.
         */
        switch (historySortColumn) {
            case "chk_dt":
            case "facility_nm":
            case "chk_cn":
            case "chk_stts_cd":
            case "pic_nm":
                break;
            default:
                historySortColumn = "chk_dt";
        }

        /*
         * 정렬 방향 검증
         */
        if (!"ASC".equalsIgnoreCase(historySortOrder)) {
            historySortOrder = "DESC";
        } else {
            historySortOrder = "ASC";
        }

        ResidentFacilityHistoryDTO historySearchDTO = new ResidentFacilityHistoryDTO();
        historySearchDTO.setAptCmplexNo(aptCmplexNo);
        historySearchDTO.setFacilityTyCd(facilityTyCd);
        historySearchDTO.setKeyword(keyword);
        historySearchDTO.setStartRow(startRow);
        historySearchDTO.setEndRow(endRow);
        historySearchDTO.setSortColumn(historySortColumn);
        historySearchDTO.setSortOrder(historySortOrder);
        /*
         * 시설 점검 상세 이력 총 건수
         * → 페이징 계산에 사용한다.
         */
        int totalRecord = residentFacilityService.getFacilityHistoryCount(historySearchDTO);

        /*
         * 총 페이지 수
         * → 총 건수 / 한 페이지 개수.
         */
        int totalPage = (int) Math.ceil((double) totalRecord / screenSize);

        /*
         * 시설 점검 상세 이력 목록 조회
         * → 검색/정렬/페이징 조건을 DTO에 담아서 조회한다.
         */
        List<ResidentFacilityHistoryDTO> historyList =
                residentFacilityService.getFacilityHistoryList(historySearchDTO);

        /* 입주민 아파트 헤더레이아웃 */
        AptMainPageDTO.ResponseDto aptCommonDTO = aptComplexService.selectAptCommonDTO(aptCmplexNo);
        model.addAttribute("aptInfo", aptCommonDTO);
        model.addAttribute("aptCmplexNo", aptCmplexNo);
        model.addAttribute("statusCardList", statusCardList);
        model.addAttribute("historyList", historyList);
        model.addAttribute("currentPage", currentPage);
        model.addAttribute("totalPage", totalPage);
        model.addAttribute("totalRecord", totalRecord);

        model.addAttribute("facilityAptInfo", facilityAptInfo);
        model.addAttribute("facilityInfoList", facilityInfoList);
        model.addAttribute("facilityTyCd", facilityTyCd);

        /*
         * 시설정보 페이징 객체
         * → JSP에서 총 건수, 현재 페이지, 시작/끝 페이지를 사용할 수 있다.
         */
        model.addAttribute("facilityPagingVO", facilityPagingVO);
        model.addAttribute("facilityTotalRecord", facilityPagingVO.getTotalRecord());
        model.addAttribute("facilityTotalPage", facilityPagingVO.getTotalPage());
        model.addAttribute("facilityPage", facilityPagingVO.getCurrentPage());

        /*
         * 시설정보 검색/페이징/정렬 값을 JSP로 다시 넘긴다.
         * 왜 필요?
         * → 검색 후에도 입력값, 현재 페이지, 정렬 상태를 화면에 유지하기 위해.
         */
        model.addAttribute("facilityNm", facilityNm);
        model.addAttribute("locCn", locCn);
        model.addAttribute("sortColumn", sortColumn);
        model.addAttribute("sortOrder", sortOrder);

        /*
         * 시설 점검 상세 이력 검색어 유지
         * → 검색 후에도 입력창에 사용자가 입력한 값이 남아있게 한다.
         */
        model.addAttribute("keyword", keyword);
        model.addAttribute("historySortColumn", historySortColumn);
        model.addAttribute("historySortOrder", historySortOrder);

        /* 시설 점검 상세 이력 셀렉트 박스 */
        model.addAttribute("historyChkDt", historyChkDt);
        model.addAttribute("historyFacilityNm", historyFacilityNm);
        model.addAttribute("historyChkCn", historyChkCn);
        model.addAttribute("historyChkStts", historyChkStts);
        model.addAttribute("historyPicNm", historyPicNm);

        return "member/resident/manage_facility";
    }


    /**
     * 입주민 시설정보 목록 AJAX 조회 컨트롤러
     *
     * @param aptCmplexNo  아파트 단지 번호
     * @param facilityPage 시설 목록 현재 페이지 번호
     * @param facilityTyCd 시설 유형 코드
     * @param facilityNm   시설명 검색어
     * @param locCn        위치 검색어
     * @param dongNo       동 번호 검색조건
     * @param sortColumn   정렬 컬럼명
     * @param sortOrder    정렬 방향(ASC / DESC)
     * @return 시설 목록 및 페이징 정보 JSON 반환
     * @author 김보라
     */
    @ResponseBody
    @PreAuthorize("hasRole('RESIDENT')")
    @GetMapping("/manage/facility/{aptCmplexNo}/facility/list")
    public Map<String, Object> manageFacilityInfoListAjax(
            @PathVariable String aptCmplexNo,
            @RequestParam(value = "facilityPage", defaultValue = "1") int facilityPage,
            @RequestParam(value = "facilityTyCd", required = false) String facilityTyCd,
            @RequestParam(value = "facilityNm", required = false) String facilityNm,
            @RequestParam(value = "locCn", required = false) String locCn,
            @RequestParam(value = "dongNo", required = false) String dongNo,
            @RequestParam(value = "sortColumn", defaultValue = "facility_ty_cd") String sortColumn,
            @RequestParam(value = "sortOrder", defaultValue = "ASC") String sortOrder
    ) {

        /*
         * 한 페이지에 출력할 시설 개수
         * → 시설정보 5개씩 조회
         */
        int pageSize = 5;

        /*
         * 정렬 컬럼 검증
         *
         * 왜 사용?
         * → 사용자가 URL에 임의 컬럼명을 넣는 것을 방지.
         */
        switch (sortColumn) {
            case "facility_ty_cd":
            case "facility_nm":
            case "dong_no":
            case "loc_cn":
                break;
            default:
                sortColumn = "facility_ty_cd";
        }

        /*
         * 정렬 방향 검증
         * → ASC 또는 DESC만 허용.
         */
        sortOrder = "DESC".equalsIgnoreCase(sortOrder) ? "DESC" : "ASC";

        PaginationInfoVO<FacilityInfoDTO> pagingVO = new PaginationInfoVO<>(5, 5);

        /*
         * 시설정보 전체 개수 조회
         *
         * 왜 사용?
         * → 전체 페이지 수 계산 및 페이징 처리에 사용.
         */
        int totalRecord = residentFacilityService.getResidentFacilityInfoCount(
                aptCmplexNo,
                facilityTyCd,
                facilityNm,
                dongNo,
                locCn
        );

        /*
         * 현재 페이지 및 전체 건수 설정
         */
        pagingVO.setTotalRecord(totalRecord);
        pagingVO.setCurrentPage(facilityPage);

        /*
         * 시설 목록 조회
         *
         * 검색조건 + 정렬조건 + 페이징 범위를 함께 전달한다.
         */
        List<FacilityInfoDTO> facilityInfoList =
                residentFacilityService.getResidentFacilityInfoList(
                        aptCmplexNo,
                        facilityTyCd,
                        facilityNm,
                        dongNo,
                        locCn,
                        sortColumn,
                        sortOrder,
                        pagingVO.getStartRow(),
                        pagingVO.getEndRow()
                );

        /*
         * AJAX 응답 데이터 생성
         *
         * Map<String, Object>
         * → JSON 형태로 변환되어 프론트로 전달된다.
         */
        Map<String, Object> result = new HashMap<>();
        result.put("facilityInfoList", facilityInfoList);
        /*
         * 현재 페이지 번호
         */
        result.put("facilityPage", facilityPage);
        result.put("facilityTotalPage", pagingVO.getTotalPage());
        result.put("facilityTotalRecord", totalRecord);

        return result;
    }

    /**
     * 시설 점검 상세 이력 AJAX 조회 컨트롤러
     * 비동기(AJAX) 방식으로 조회
     *
     * @param aptCmplexNo       아파트 단지 번호
     * @param currentPage       현재 페이지 번호
     * @param historyChkStartDt 점검 시작일 검색조건
     * @param historyChkEndDt   점검 종료일 검색조건
     * @param historyFacilityNm 시설명 검색조건
     * @param historyChkCn      점검내용 검색조건
     * @param historyChkStts    점검상태 검색조건
     * @param historyPicNm      담당자 검색조건
     * @param sortColumn        정렬 컬럼명
     * @param sortOrder         정렬 방향(ASC / DESC)
     * @return 시설 점검이력 목록 및 페이징 정보 JSON 반환
     * @author 김보라
     */
    @ResponseBody
    @PreAuthorize("hasRole('RESIDENT')")
    @GetMapping("/manage/facility/{aptCmplexNo}/history/list")
    public Map<String, Object> manageFacilityHistoryListAjax(
            @PathVariable String aptCmplexNo,
            @RequestParam(value = "currentPage", defaultValue = "1") int currentPage,
            @RequestParam(value = "historyChkStartDt", required = false) String historyChkStartDt,
            @RequestParam(value = "historyChkEndDt", required = false) String historyChkEndDt,
            @RequestParam(value = "historyFacilityNm", required = false) String historyFacilityNm,
            @RequestParam(value = "historyChkCn", required = false) String historyChkCn,
            @RequestParam(value = "historyChkStts", required = false) String historyChkStts,
            @RequestParam(value = "historyPicNm", required = false) String historyPicNm,
            @RequestParam(value = "sortColumn", defaultValue = "chk_dt") String sortColumn,
            @RequestParam(value = "sortOrder", defaultValue = "DESC") String sortOrder
    ) {
        int screenSize = 5;
        /*
         * Oracle 페이징용 시작 ROW 번호
         */
        int startRow = (currentPage - 1) * screenSize + 1;
        /*
         * Oracle 페이징용 끝 ROW 번호
         */
        int endRow = currentPage * screenSize;

        /*
         * 정렬 컬럼 검증
         *
         * 왜 사용?
         * → 사용자가 URL에 임의 컬럼명을 넣는 것을 방지.
         * → SQL 오류 및 SQL Injection 예방 목적.
         */
        switch (sortColumn) {
            case "chk_dt":
            case "facility_nm":
            case "chk_cn":
            case "chk_stts_cd":
            case "pic_nm":
                break;
            default:
                sortColumn = "chk_dt";
        }

        sortOrder = "ASC".equalsIgnoreCase(sortOrder) ? "ASC" : "DESC";

        ResidentFacilityHistoryDTO dto = new ResidentFacilityHistoryDTO();

        /*
         * 검색조건 설정
         */
        dto.setAptCmplexNo(aptCmplexNo);
        dto.setHistoryChkStartDt(historyChkStartDt);
        dto.setHistoryChkEndDt(historyChkEndDt);
        dto.setHistoryFacilityNm(historyFacilityNm);
        dto.setHistoryChkCn(historyChkCn);
        dto.setHistoryChkStts(historyChkStts);
        dto.setHistoryPicNm(historyPicNm);
        /*
         * 정렬조건 설정
         */
        dto.setSortColumn(sortColumn);
        dto.setSortOrder(sortOrder);
        /*
         * 페이징 범위 설정
         */
        dto.setStartRow(startRow);
        dto.setEndRow(endRow);

        /*
         * 시설 점검이력 전체 개수 조회
         *
         * 왜 사용?
         * → 전체 페이지 수 계산에 사용.
         */
        int totalRecord = residentFacilityService.getFacilityHistoryCount(dto);
        /*
         * 전체 페이지 수 계산
         */
        int totalPage = (int) Math.ceil((double) totalRecord / screenSize);

        /*
         * 시설 점검이력 목록 조회
         */
        List<ResidentFacilityHistoryDTO> historyList =
                residentFacilityService.getFacilityHistoryList(dto);

        /*
         * AJAX 응답용 JSON 데이터 생성
         */
        Map<String, Object> result = new HashMap<>();
        result.put("historyList", historyList);
        result.put("totalRecord", totalRecord);
        result.put("totalPage", totalPage);
        result.put("currentPage", currentPage);

        return result;
    }

    @GetMapping("/manage/favorite")
    public String manageFavorite() {
        return "member/resident/manage_favorite";
    }

    /* =========================
     * 생활지원서비스
     * ========================= */

/*    @PreAuthorize("@authService.hasAccess(principal, #aptCmplexNo)")*/
    @PreAuthorize("hasRole('MEMBER')")
    @GetMapping("/service/moving/{aptCmplexNo}")
    public String serviceMoving(
            @PathVariable String aptCmplexNo,
            @AuthenticationPrincipal CustomUser principal,
            Model model) {

        MemberVO memberVO = principal.getMember();
        String userNo = memberVO.getUserNo();
        List<MyAptVO> aptList = List.of();

        if (memberVO instanceof ResidentVO resident) {

            aptList = resident.getMyAptList().stream()
                    .filter(apt ->
                            apt.getAptCmplexNo().equals(aptCmplexNo)
                    )
                    .toList();
        }

        AptMainPageDTO.ResponseDto aptCommonDTO =
                aptComplexService.selectAptCommonDTO(aptCmplexNo);

        model.addAttribute("aptInfo", aptCommonDTO);

        model.addAttribute("userNo", userNo);
        model.addAttribute("aptCmplexNo", aptCmplexNo);
        model.addAttribute("aptList", aptList);

        model.addAttribute(
                "memberType",
                memberVO.getClass().getSimpleName()
        );
        return "member/resident/service/service_moving";
    }

    @GetMapping("/service/moving/in/{aptCmplexNo}")
    public String seriveMoveIn(@PathVariable String aptCmplexNo,
                               @AuthenticationPrincipal CustomUser principal,
                               Model model) {
        MemberVO memberVO = principal.getMember();
        String userNo = memberVO.getUserNo();
        List<Map<String, Object>> hoList = residentMoveService.selectHoList(userNo, aptCmplexNo);

        model.addAttribute("hoList", hoList);
        model.addAttribute("aptCmplexNo", aptCmplexNo);
        model.addAttribute("principal", principal);
        return "member/resident/service/service_move_in";
    }

    @PreAuthorize("@authService.hasAccess(principal, #aptCmplexNo)")
    @GetMapping("/service/moving/out/{aptCmplexNo}")
    public String seriveMoveOut(@PathVariable String aptCmplexNo,
                                @AuthenticationPrincipal CustomUser principal,
                                Model model) {
        MemberVO memberVO = principal.getMember();
        String userNo = memberVO.getUserNo();
        List<MyAptVO> aptList = List.of();

        if (memberVO instanceof ResidentVO resident) {
            aptList = resident.getMyAptList().stream()
                    .filter(apt -> apt.getAptCmplexNo().equals(aptCmplexNo))
                    .toList();
        }

        AptMainPageDTO.ResponseDto aptCommonDTO =
                aptComplexService.selectAptCommonDTO(aptCmplexNo);

        List<Map<String, Object>> hoList = residentMoveService.selectHoList(userNo, aptCmplexNo);

        model.addAttribute("aptInfo", aptCommonDTO);
        model.addAttribute("userNo", userNo);
        model.addAttribute("aptCmplexNo", aptCmplexNo);
        model.addAttribute("aptList", aptList);
        model.addAttribute("hoList", hoList);
        model.addAttribute("principal", principal);
        model.addAttribute("memberType", memberVO.getClass().getSimpleName());
        return "member/resident/service/service_move_out";
    }

    @PreAuthorize("@authService.hasAccess(principal, #aptCmplexNo)")
    @GetMapping("/service/moving/settlement/{aptCmplexNo}")
    public String seriveMoveSettlement(@PathVariable String aptCmplexNo,
                                       @AuthenticationPrincipal CustomUser principal,
                                       Model model) {
        MemberVO memberVO = principal.getMember();
        String userNo = memberVO.getUserNo();
        List<MyAptVO> aptList = List.of();

        if (memberVO instanceof ResidentVO resident) {

            aptList = resident.getMyAptList().stream()
                    .filter(apt ->
                            apt.getAptCmplexNo().equals(aptCmplexNo)
                    )
                    .toList();
        }
        AptMainPageDTO.ResponseDto aptCommonDTO =
                aptComplexService.selectAptCommonDTO(aptCmplexNo);

        model.addAttribute("aptInfo", aptCommonDTO);

        model.addAttribute("principal", principal);
        model.addAttribute("userNo", userNo);
        model.addAttribute("aptCmplexNo", aptCmplexNo);
        model.addAttribute("aptList", aptList);

        model.addAttribute(
                "memberType",
                memberVO.getClass().getSimpleName()
        );
        return "member/resident/service/service_move_settlement";
    }


    @PreAuthorize("@authService.hasAccess(principal, #aptCmplexNo)")
    @GetMapping("/service/car/{aptCmplexNo}")
    public String serviceCar(
            @AuthenticationPrincipal CustomUser principal,
            @PathVariable String aptCmplexNo,
            Model model
    ) {

        MemberVO member = principal.getMember();

        String userNo = member.getUserNo();

        List<MyAptVO> aptList = List.of();

        if (member instanceof ResidentVO resident) {

            aptList = resident.getMyAptList().stream()
                    .filter(apt ->
                            apt.getAptCmplexNo().equals(aptCmplexNo)
                    )
                    .toList();
        }

        AptMainPageDTO.ResponseDto aptCommonDTO =
                aptComplexService.selectAptCommonDTO(aptCmplexNo);

        model.addAttribute("aptInfo", aptCommonDTO);

        model.addAttribute("userNo", userNo);
        model.addAttribute("aptCmplexNo", aptCmplexNo);
        model.addAttribute("aptList", aptList);

        model.addAttribute(
                "memberType",
                member.getClass().getSimpleName()
        );

        return "member/resident/service/service_car";
    }

    @PreAuthorize("@authService.hasAccess(principal, #aptCmplexNo)")
    @GetMapping("/service/visitor/{aptCmplexNo}")
    public String serviceVisitor(
            @AuthenticationPrincipal CustomUser principal,
            @PathVariable String aptCmplexNo,
            Model model
    ) {

        AptMainPageDTO.ResponseDto aptCommonDTO =
                aptComplexService.selectAptCommonDTO(aptCmplexNo);

        model.addAttribute("aptInfo", aptCommonDTO);

        MemberVO member = principal.getMember();

        model.addAttribute(
                "memberType",
                member.getClass().getSimpleName()
        );

        return "member/resident/service/service_visitor";
    }

    @GetMapping("/service/facility")
    public String serviceFacility(
            @AuthenticationPrincipal CustomUser principal,
            Model model
    ) {
        /*
         * Controller란?
         * 사용자의 요청 URL을 받아서 Service를 호출하고,
         * 조회 결과를 JSP로 전달하는 클래스입니다.
         */

        String userNo = principal.getMember().getUserNo();

        // 로그인한 입주민이 속한 단지번호 조회
        String aptCmplexNo = residentFacilityService.getResidentAptCmplexNo(userNo);

        // 예약제 편의시설 목록 조회
        List<FacilityInfoDTO> reservableFacilityList =
                residentFacilityService.getReservablePublicFacilityCardList(aptCmplexNo);

        model.addAttribute("reservableFacilityList", reservableFacilityList);

        return "member/resident/service/service_facility";
    }

    @GetMapping("/service/facility/reservations")
    public String serviceFacilityReservation() {
        return "member/resident/facility/facility_reservation_list";
    }

    @GetMapping("/service/facility/detail")
    public String serviceFacilityDetail() {
        return "member/resident/facility/facility_reservation_detail";
    }

    @GetMapping("/service/facility/meeting-room")
    public String serviceMeetingroom() {
        return "member/resident/facility/facility_meeting_room";
    }

    @GetMapping("/service/facility/reading-room")
    public String serviceReadingroom() {
        return "member/resident/facility/facility_reading_room";
    }

    @GetMapping("/service/facility/tennis")
    public String serviceTennis() {
        return "member/resident/facility/facility_tennis";
    }

    /* =========================
     * 민원접수
     * ========================= */

    @GetMapping("/complaint/live")
    public String complaintLive() {
        return "apt/complaint/complaint_live";
    }

    @GetMapping("/complaint/chatbot")
    public String complaintChatbot() {
        return "apt/complaint/complaint_chatbot";
    }

    @GetMapping("/complaint/status")
    public String complaintStatus() {
        return "apt/complaint/complaint_status";
    }

    /* =========================
     * 전자투표 및 설문
     * ========================= */
    @GetMapping("/vote")
    public String voteResident() {
        return "member/resident/survey/vote_resident";
    }

    @GetMapping("/vote/list")
    public String voteList(Model model) {

        model.addAttribute(
                "surveyList",
                surveyService.selectSurveyList("OPEN_ONLY")
        );

        return "member/resident/survey/vote_resident_list";
    }

    @GetMapping("/survey/detail/{aptCmplexNo}/{surveyNo}")
    public String surveyDetail(
            @PathVariable String aptCmplexNo,
            @PathVariable String surveyNo,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {

        String userNo =
                customUser.getMember().getUserNo();

        boolean alreadyParticipated =
                surveyService.existsSurveyResponse(
                        surveyNo,
                        userNo
                );

        // 이미 참여했으면 결과페이지로 이동
        if (alreadyParticipated) {

            return "redirect:/resident/survey/result/{aptCmplexNo}/{surveyNo}";
        }

        // 미참여자만 설문 상세 진입
        model.addAttribute(
                "survey",
                surveyService.selectSurveyDetail(surveyNo)
        );

        AptMainPageDTO.ResponseDto aptMainPageDTO = aptComplexService.selectAptMainDTO(aptCmplexNo);

        model.addAttribute("aptInfo", aptMainPageDTO);
        return "member/resident/survey/survey_detail";
    }

    @GetMapping("/survey/result/{aptCmplexNo}/{surveyNo}")
    public String surveyResult(@PathVariable String aptCmplexNo,
                               @PathVariable String surveyNo,
                               @AuthenticationPrincipal CustomUser customUser,
                               Model model
    ) throws Exception {

        model.addAttribute(
                "survey",
                surveyService.selectSurveyDetail(surveyNo)
        );

        String userNo =
                customUser.getMember().getUserNo();

        model.addAttribute(
                "myResponse",
                surveyService.selectMySurveyResponse(
                        surveyNo,
                        userNo
                )
        );

        List<Map<String, Object>> statistics =
                surveyService.selectSurveyStatistics(
                        surveyNo
                );

        ObjectMapper mapper =
                new ObjectMapper();

        model.addAttribute(
                "statisticsJson",
                mapper.writeValueAsString(statistics)
        );

        AptMainPageDTO.ResponseDto aptMainPageDTO = aptComplexService.selectAptMainDTO(aptCmplexNo);

        model.addAttribute("aptInfo", aptMainPageDTO);
        return "member/resident/survey/survey_result";
    }

    @GetMapping("/survey/list/{aptCmplexNo}")
    public String surveyList(

            @RequestParam(defaultValue = "ALL") String type,
            @AuthenticationPrincipal CustomUser customUser,
            @PathVariable String aptCmplexNo,
            Model model
    ) {

        String aptCd = aptCmplexNo;


        System.out.println("resident aptCd = " + aptCd);

        List<MngSurveyDTO> surveyList;

        if ("SURVEY".equals(type)) {

            surveyList =
                    surveyService
                            .selectSurveyTypeList(
                                    "SURVEY",
                                    aptCd
                            );

        } else if ("VOTE".equals(type)) {

            surveyList =
                    surveyService
                            .selectSurveyTypeList(
                                    "VOTE",
                                    aptCd
                            );

        } else {

            surveyList =
                    surveyService
                            .selectSurveyList(
                                    aptCd
                            );
        }

        model.addAttribute(
                "surveyList",
                surveyList
        );

        model.addAttribute(
                "type",
                type
        );

        return "member/resident/survey/survey_list";
    }


    @PostMapping("/survey/submit/{surveyNo}")
    @ResponseBody
    public ResponseEntity<?> submitSurvey(

            @PathVariable String surveyNo,
            @AuthenticationPrincipal CustomUser customUser,
            @RequestBody Map<String, String> body

    ) {

        String response =
                body.get("response");

        if (response == null
                || response.trim().isEmpty()
                || hasBlankSurveyAnswer(response)) {

            return ResponseEntity.badRequest()
                    .body("empty");
        }

        if (surveyService.existsSurveyResponse(

                surveyNo,
                customUser.getMember().getUserNo()

        )) {
            return ResponseEntity.badRequest()
                    .body("already");
        }

        ResidentVO resident =
                (ResidentVO) customUser.getMember();

        String hoNo = null;

        if (resident.getMyAptList() != null
                && !resident.getMyAptList().isEmpty()) {

            hoNo =
                    resident.getMyAptList()
                            .get(0)
                            .getHoNo();
        }

        surveyService.insertSurveyResponse(

                surveyNo,
                response,
                customUser.getMember().getUserNo(),
                hoNo

        );


        return ResponseEntity.ok().build();
    }

    private boolean hasBlankSurveyAnswer(String response) {

        try {

            List<Map<String, Object>> answerList =
                    new com.fasterxml.jackson.databind.ObjectMapper()
                            .readValue(
                                    response,
                                    new com.fasterxml.jackson.core.type.TypeReference<>() {
                                    }
                            );

            if (answerList == null || answerList.isEmpty()) {
                return true;
            }

            for (Map<String, Object> answer : answerList) {

                Object value =
                        answer.get("answer");

                if (value == null
                        || value.toString().trim().isEmpty()) {

                    return true;
                }
            }

            return false;

        } catch (Exception e) {

            return true;
        }
    }


    /**
     * 입주민 공지게시판 조회
     *
     * @param aptCmplexNo
     * @param currentPage
     * @param searchTtl
     * @param searchStartDt
     * @param searchEndDt
     * @param model
     * @return board_notice.jsp 입주민 공지게시판
     * @author 김보라
     */
    @GetMapping("/board/notice/{aptCmplexNo}")
    public String boardNotice(
            @PathVariable String aptCmplexNo,
            @RequestParam(value = "currentPage", required = false, defaultValue = "1") int currentPage,
            @RequestParam(value = "searchTtl", required = false) String searchTtl,
            @RequestParam(value = "searchStartDt", required = false) String searchStartDt,
            @RequestParam(value = "searchEndDt", required = false) String searchEndDt,
            Model model
    ) {
        PaginationInfoVO<ResidentNoticeBoardDTO> pagingVO = new PaginationInfoVO<>(10, 5);
        // 10: 한 페이지에 10개 출력
        // 5: 페이지 번호를 5개 단위로 출력

        ResidentNoticeBoardDTO searchDTO = new ResidentNoticeBoardDTO();
        searchDTO.setAptCmplexNo(aptCmplexNo);
        searchDTO.setSearchTtl(searchTtl);
        searchDTO.setSearchStartDt(searchStartDt);
        searchDTO.setSearchEndDt(searchEndDt);

        int totalRecord = residentNoticeBoardService.selectResidentBoardNoticeCount(searchDTO);

        pagingVO.setTotalRecord(totalRecord);
        pagingVO.setCurrentPage(currentPage);

        searchDTO.setStartRow(pagingVO.getStartRow());
        searchDTO.setEndRow(pagingVO.getEndRow());

        List<ResidentNoticeBoardDTO> noticeList =
                residentNoticeBoardService.selectResidentBoardNoticeList(searchDTO);

        pagingVO.setDataList(noticeList);

        model.addAttribute("aptCmplexNo", aptCmplexNo);
        model.addAttribute("noticeList", noticeList);
        model.addAttribute("pagingVO", pagingVO);
        model.addAttribute("searchDTO", searchDTO);
        model.addAttribute("pagingHTML", pagingVO.getPagingHTML());

        model.addAttribute("totalRecord", totalRecord);
        model.addAttribute("searchTtl", searchTtl);
        model.addAttribute("searchStartDt", searchStartDt);
        model.addAttribute("searchEndDt", searchEndDt);

        return "member/resident/board/board_notice";
    }

    /**
     * 입주민 공지사항 상세 조회 페이지
     */
    @PreAuthorize("@authService.hasAccess(principal, #aptCmplexNo)")
    @GetMapping("/board/notice/detail/{aptCmplexNo}/{annNo}")
    public String boardNoticeDetail(
            @PathVariable String aptCmplexNo,
            @PathVariable String annNo,
            Model model
    ) {

        /*
         * DTO 생성
         * → 검색조건/조회조건 담는 객체
         */
        ResidentNoticeBoardDTO searchDTO = new ResidentNoticeBoardDTO();

        searchDTO.setAptCmplexNo(aptCmplexNo);
        searchDTO.setAnnNo(annNo);

        /*
         * 공지 상세 조회
         */
        ResidentNoticeBoardDTO notice =
                residentNoticeBoardService.selectResidentBoardNoticeDetail(searchDTO);

        /*
         * 이전글 / 다음글 조회
         */
        ResidentNoticeBoardDTO prevNotice =
                residentNoticeBoardService.selectPrevResidentNotice(searchDTO);

        ResidentNoticeBoardDTO nextNotice =
                residentNoticeBoardService.selectNextResidentNotice(searchDTO);

        /*
         * JSP로 데이터 전달
         */
        model.addAttribute("aptCmplexNo", aptCmplexNo);
        model.addAttribute("notice", notice);
        model.addAttribute("prevNotice", prevNotice);
        model.addAttribute("nextNotice", nextNotice);

        /*
         * 이동할 JSP
         */
        return "member/resident/board/board_notice_detail";
    }

    /**
     * 입주민 - 공지게시판 비동기
     *
     * @param aptCmplexNo
     * @param annNo
     * @return 입주민 공지글 상세내용 보기
     * @author 김보라
     */
    @ResponseBody
    @PreAuthorize("hasRole('RESIDENT')")
    @GetMapping("/board/notice/detail-ajax/{aptCmplexNo}/{annNo}")
    public ResidentNoticeBoardDTO residentNoticeDetailAjax(
            @PathVariable String aptCmplexNo,
            @PathVariable String annNo
    ) {
        /*
         * AJAX란?
         * → 화면 전체를 새로고침하지 않고 서버에서 필요한 데이터만 받아오는 방식.
         * 왜 사용?
         * → 공지 제목 클릭 시 목록 페이지는 그대로 두고, 상세 내용만 위에 보여주기 위해.
         */
        ResidentNoticeBoardDTO searchDTO = new ResidentNoticeBoardDTO();
        searchDTO.setAptCmplexNo(aptCmplexNo);
        searchDTO.setAnnNo(annNo);

        return residentNoticeBoardService.selectResidentBoardNoticeDetail(searchDTO);
    }

    @PreAuthorize("@authService.hasAccess(principal, #aptCmplexNo)")
    @GetMapping("/board/free/{aptCmplexNo}")
    public String boardFree(@PathVariable String aptCmplexNo, Model model) {
        model.addAttribute("aptCmplexNo", aptCmplexNo);
        return "member/resident/board/board_free";
    }

    @PreAuthorize("@authService.hasAccess(principal, #aptCmplexNo)")
    @GetMapping("/board/free/list/{aptCmplexNo}")
    public String boardFreeList(@PathVariable String aptCmplexNo, Model model) {
        return "redirect:/resident/boardFreeList/" + aptCmplexNo;
    }

    @PreAuthorize("@authService.hasAccess(principal, #aptCmplexNo)")
    @GetMapping("/board/free/write/{aptCmplexNo}")
    public String boardFreeWrite(@PathVariable String aptCmplexNo, Model model) {
        model.addAttribute("aptCmplexNo", aptCmplexNo);
        return "member/resident/board/board_free_write";
    }

    @PreAuthorize("@authService.hasAccess(principal, #aptCmplexNo)")
    @GetMapping("/board/free/detail/{postNo}/{aptCmplexNo}")
    public String boardFreeDetail(@PathVariable String aptCmplexNo,
                                  @PathVariable String postNo, Model model,
                                  @AuthenticationPrincipal CustomUser principal
    ) {
        model.addAttribute("aptCmplexNo", aptCmplexNo);
        model.addAttribute("postNo", postNo);
        return "member/resident/board/board_free_detail";
    }

    @PreAuthorize("@authService.hasAccess(principal, #aptCmplexNo)")
    @GetMapping("/board/chat/{aptCmplexNo}")
    public String boardChat(@AuthenticationPrincipal CustomUser principal,
                            @PathVariable String aptCmplexNo,
                            Model model
    ) {
        model.addAttribute("userNo", principal.getMember().getUserNo());
        model.addAttribute("aptCmplexNo", aptCmplexNo);

        return "member/resident/board/board_chat";
    }


    /** 우리집맞춤통계 진입 (번호 없는 URL → 번호 붙은 URL 로 리다이렉트) */
    @PreAuthorize("hasRole('RESIDENT')")
    @GetMapping("/stats/custom")
    public String statsCustom(@AuthenticationPrincipal CustomUser principal) {
        // 로그인 사용자의 첫 단지번호 추출
        ResidentVO resident = (ResidentVO) principal.getMember();
        // 등록된 단지가 없으면 폴백으로 기존 JSP 반환
        if (resident.getMyAptList() == null || resident.getMyAptList().isEmpty()) {
            return "member/resident/stats_custom";
        }
        // 번호 붙은 URL 로 302 리다이렉트 → ResidentCustomStatsController 가 처리
        String aptCmplexNo = resident.getMyAptList().get(0).getAptCmplexNo();
        return "redirect:/resident/stats/custom/" + aptCmplexNo;
    }

    /** 아파트통계 진입 (번호 없는 URL → 번호 붙은 URL 로 리다이렉트) */
    @PreAuthorize("hasRole('RESIDENT')")
    @GetMapping("/stats/apartment")
    public String statsApartment(@AuthenticationPrincipal CustomUser principal) {
        // 로그인 사용자의 첫 단지번호 추출
        ResidentVO resident = (ResidentVO) principal.getMember();
        // 등록된 단지가 없으면 폴백으로 기존 JSP 반환
        if (resident.getMyAptList() == null || resident.getMyAptList().isEmpty()) {
            return "member/resident/stats_apartment";
        }
        // 번호 붙은 URL 로 302 리다이렉트 → ResidentCustomStatsController 가 처리
        String aptCmplexNo = resident.getMyAptList().get(0).getAptCmplexNo();
        return "redirect:/resident/stats/apartment/" + aptCmplexNo;
    }

    /* SMS 발송 테스트용 */
    @GetMapping("/test/sms")
    @ResponseBody
    public String testSms() {

        smsService.sendResidentApproved(
                "t_1101", // 문자를 받을 입주민 회원번호
                "admin"   // 등록자/처리자 ID
        );

        return "OK";
    }


}

