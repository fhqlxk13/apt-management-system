package kr.or.ddit.domain.apt.mgmtOffice.reservation.controller;

import kr.or.ddit.common.model.PaginationInfoVO;
import kr.or.ddit.domain.apt.mgmtOffice.common.service.IManagerModelService;
import kr.or.ddit.domain.apt.mgmtOffice.reservation.service.IPublicFacilityReservationService;
import kr.or.ddit.domain.apt.mgmtOffice.reservation.vo.PublicFacilityReservationVO;
import kr.or.ddit.domain.member.vo.CustomUser;
import lombok.RequiredArgsConstructor;
// [추가] 비즈니스 예외 메시지를 HTTP 본문/상태코드로 전달하기 위해 사용
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * Controller란? 브라우저 요청 URL을 받아 JSP 화면 또는 JSON 응답으로 연결하는 클래스입니다.
 * 권한: 단지관리자(MNGR), 입주민(RESIDENT)을 메서드별로 분리했습니다.
 */
@Controller
@RequiredArgsConstructor
@RequestMapping
public class PublicFacilityReservationController {

    private final IPublicFacilityReservationService service;
    private final IManagerModelService managerModelService;

    /** 단지관리자 - 편의시설 목록 */
    @PreAuthorize("hasRole('MNGR') and @authService.canMgmtCrud(principal, #mgmtOfcNo)")
    @GetMapping("/manager/publicFacility/reservation/facilities/{mgmtOfcNo}")
    public String managerFacilityList(@PathVariable String mgmtOfcNo,
                                      @RequestParam(defaultValue = "1") int currentPage,
                                      PublicFacilityReservationVO searchVO,
                                      @AuthenticationPrincipal CustomUser customUser,
                                      Model model) {
        managerModelService.addManagerViewModel(model, customUser, mgmtOfcNo);
        searchVO.setAptCmplexNo(service.getManagerAptCmplexNo(mgmtOfcNo));
        PaginationInfoVO<PublicFacilityReservationVO> pagingVO = service.getFacilityPaging(searchVO, currentPage);
        model.addAttribute("pagingVO", pagingVO);
        model.addAttribute("searchVO", searchVO);
        model.addAttribute("mgmtOfcNo", mgmtOfcNo);
        return "apt/mgmtOffice/facility/reservation/managerFacilityList";
    }

    /** 단지관리자 - 예약승인관리 */
    @PreAuthorize("hasRole('MNGR') and @authService.canMgmtCrud(principal, #mgmtOfcNo)")
    @GetMapping("/manager/publicFacility/reservation/approval/{mgmtOfcNo}")
    public String approvalList(@PathVariable String mgmtOfcNo,
                               @RequestParam(defaultValue = "1") int currentPage,
                               PublicFacilityReservationVO searchVO,
                               @AuthenticationPrincipal CustomUser customUser,
                               Model model) {
        managerModelService.addManagerViewModel(model, customUser, mgmtOfcNo);
        searchVO.setAptCmplexNo(service.getManagerAptCmplexNo(mgmtOfcNo));
        PaginationInfoVO<PublicFacilityReservationVO> pagingVO = service.getApprovalPaging(searchVO, currentPage);
        model.addAttribute("pagingVO", pagingVO);
        model.addAttribute("searchVO", searchVO);
        model.addAttribute("mgmtOfcNo", mgmtOfcNo);

        model.addAttribute("historyFacilityList", service.getHistoryFacilityFilterList(searchVO));
        model.addAttribute("historyItemList", service.getHistoryItemFilterList(searchVO));

        return "apt/mgmtOffice/facility/reservation/managerReservationApproval";
    }

    /** 단지관리자 - 승인 */
    @PreAuthorize("hasRole('MNGR') and @authService.canMgmtCrud(principal, #mgmtOfcNo)")
    @PostMapping("/manager/publicFacility/reservation/approval/{mgmtOfcNo}/{rsvtNo}/approve")
    @ResponseBody
    public String approve(@PathVariable String mgmtOfcNo, @PathVariable String rsvtNo, PublicFacilityReservationVO vo) {
        vo.setRsvtNo(rsvtNo);
        vo.setAptCmplexNo(service.getManagerAptCmplexNo(mgmtOfcNo));
        service.approve(vo);
        return "OK";
    }

    /** 단지관리자 - 거절 */
    @PreAuthorize("hasRole('MNGR') and @authService.canMgmtCrud(principal, #mgmtOfcNo)")
    @PostMapping("/manager/publicFacility/reservation/approval/{mgmtOfcNo}/{rsvtNo}/reject")
    @ResponseBody
    public String reject(@PathVariable String mgmtOfcNo, @PathVariable String rsvtNo, PublicFacilityReservationVO vo) {
        vo.setRsvtNo(rsvtNo);
        vo.setAptCmplexNo(service.getManagerAptCmplexNo(mgmtOfcNo));
        service.reject(vo);
        return "OK";
    }

    /** 단지관리자 - 예약시설 이용이력 */
    @PreAuthorize("hasRole('MNGR') and @authService.canMgmtCrud(principal, #mgmtOfcNo)")
    @GetMapping("/manager/publicFacility/reservation/history/{mgmtOfcNo}")
    public String useHistory(@PathVariable String mgmtOfcNo,
                             @RequestParam(defaultValue = "1") int currentPage,
                             PublicFacilityReservationVO searchVO,
                             @AuthenticationPrincipal CustomUser customUser,
                             Model model) {

        managerModelService.addManagerViewModel(model, customUser, mgmtOfcNo);

        searchVO.setAptCmplexNo(service.getManagerAptCmplexNo(mgmtOfcNo));

        PaginationInfoVO<PublicFacilityReservationVO> pagingVO =
                service.getUseHistoryPaging(searchVO, currentPage);

        model.addAttribute("pagingVO", pagingVO);
        model.addAttribute("searchVO", searchVO);
        model.addAttribute("mgmtOfcNo", mgmtOfcNo);

        // 셀렉트박스용 목록
        model.addAttribute("historyFacilityList", service.getHistoryFacilityFilterList(searchVO));
        model.addAttribute("historyItemList", service.getHistoryItemFilterList(searchVO));

        return "apt/mgmtOffice/facility/reservation/managerUseHistory";
    }

    /**
     * 입주민 - 공용시설 예약 메인
     *
     * aptCmplexNo는 URL에 표시하지만,
     * 실제 조회 기준은 로그인 사용자 기준 단지번호를 사용합니다.
     */
    @PreAuthorize("hasRole('RESIDENT')")
    @GetMapping("/resident/publicFacility/reservation/{aptCmplexNo}")
    public String residentReservePage(
            @PathVariable String aptCmplexNo,
            PublicFacilityReservationVO searchVO,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {
        String loginUserAptCmplexNo =
                service.getResidentAptCmplexNo(customUser.getMember().getUserNo());

        searchVO.setAptCmplexNo(loginUserAptCmplexNo);

        model.addAttribute("facilityList", service.getResidentFacilityGroupList(searchVO));
        model.addAttribute("aptCmplexNo", loginUserAptCmplexNo);

        return "member/resident/facility/residentReservation";
    }

    /**
     * 입주민 - 공용시설 상세 예약 화면
     */
    @PreAuthorize("hasRole('RESIDENT')")
    @GetMapping("/resident/publicFacility/reservation/{aptCmplexNo}/{cmnFacilityNo}")
    public String residentReserveDetailPage(
            @PathVariable String aptCmplexNo,
            @PathVariable String cmnFacilityNo,
            PublicFacilityReservationVO searchVO,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {
        String loginUserAptCmplexNo =
                service.getResidentAptCmplexNo(customUser.getMember().getUserNo());

        searchVO.setAptCmplexNo(loginUserAptCmplexNo);
        searchVO.setSearchCmnFacilityNo(cmnFacilityNo);

        List<PublicFacilityReservationVO> itemList =
                service.getResidentFacilityItemList(searchVO);

        PublicFacilityReservationVO facility = null;
        if (itemList != null && !itemList.isEmpty()) {
            facility = itemList.get(0);
        }

        model.addAttribute("facility", facility);
        model.addAttribute("itemList", itemList);
        model.addAttribute("aptCmplexNo", loginUserAptCmplexNo);
        model.addAttribute("cmnFacilityNo", cmnFacilityNo);

        return "member/resident/facility/residentReservationDetail";
    }

    /**
     * 입주민 - 선택 시간 기준 예약된 좌석 조회
     */
    @PreAuthorize("hasRole('RESIDENT')")
    @GetMapping("/resident/publicFacility/reservation/{cmnFacilityNo}/reserved-items")
    @ResponseBody
    public List<String> reservedItemList(
            @PathVariable String cmnFacilityNo,
            PublicFacilityReservationVO searchVO,
            @AuthenticationPrincipal CustomUser customUser
    ) {
        searchVO.setAptCmplexNo(service.getResidentAptCmplexNo(customUser.getMember().getUserNo()));
        searchVO.setSearchCmnFacilityNo(cmnFacilityNo);

        return service.getReservedItemNoList(searchVO);
    }

    /**
     * 입주민 - 예약 등록
     */
    @PreAuthorize("hasRole('RESIDENT')")
    @PostMapping("/resident/publicFacility/reservation")
    @ResponseBody
    // [변경] 반환 타입을 String → ResponseEntity<String>로 변경
    //  왜? 시설 점검/중복 예약 등 IllegalStateException 메시지를 HTTP 400 본문으로 클라이언트에 전달하기 위함
    public ResponseEntity<String> reserve(
            PublicFacilityReservationVO vo,
            @AuthenticationPrincipal CustomUser customUser
    ) {
        vo.setUserNo(customUser.getMember().getUserNo());
        vo.setAptCmplexNo(service.getResidentAptCmplexNo(customUser.getMember().getUserNo()));

        // [추가] 서비스 호출을 try-catch로 감싸 비즈니스 예외를 400 응답 + 메시지 본문으로 변환
        //  - 정상: 200 OK + 예약번호(rsvtNo)
        //  - 비즈니스 차단(점검/중복 등): 400 Bad Request + 예외 메시지
        try {
            return ResponseEntity.ok(service.reserve(vo));
        } catch (IllegalStateException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    /**
     * 입주민 예약내역 조회
     * 아래 2개 URL 모두 처리합니다.
     * 1.
     /resident/publicFacility/myReservation
     * 2.
     /resident/publicFacility/myReservation/{aptCmplexNo}
     */
    @PreAuthorize("hasRole('RESIDENT')")
    @GetMapping({
            "/resident/publicFacility/myReservation",
            "/resident/publicFacility/myReservation/{aptCmplexNo}"
    })
    public String myReservation(
            @PathVariable(required = false) String aptCmplexNo,
            @RequestParam(defaultValue = "1") int currentPage,
            PublicFacilityReservationVO searchVO,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {
        /*
         * 로그인 입주민 단지 조회
         */
        String loginUserAptCmplexNo =
                service.getResidentAptCmplexNo(customUser.getMember().getUserNo());

        searchVO.setAptCmplexNo(loginUserAptCmplexNo);
        searchVO.setUserNo(customUser.getMember().getUserNo());

        /*
         * 예약내역 페이징 조회
         */
        PaginationInfoVO<PublicFacilityReservationVO> pagingVO =
                service.getMyReservationPaging(searchVO, currentPage);

        /*
         * 시설명 필터 목록
         *
         * 왜 사용?
         * 검색조건의 시설명 select box 데이터를 만들기 위해 사용.
         */
        model.addAttribute(
                "facilityFilterList",
                service.getHistoryFacilityFilterList(searchVO)
        );

        /*
         * 예약대상 필터 목록
         *
         * 예:
         * 독서실 의자1
         * 러닝머신1
         * 회의실 테이블A
         */
        model.addAttribute(
                "itemFilterList",
                service.getHistoryItemFilterList(searchVO)
        );

        model.addAttribute("pagingVO", pagingVO);
        model.addAttribute("searchVO", searchVO);
        model.addAttribute("aptCmplexNo", loginUserAptCmplexNo);

        return "member/resident/facility/residentMyReservation";
    }

    /**
     * 입주민 - 예약 상세 JSON
     */
    @PreAuthorize("hasRole('RESIDENT')")
    @GetMapping("/resident/publicFacility/myReservation/detail/{rsvtNo}")
    @ResponseBody
    public PublicFacilityReservationVO myReservationDetail(
            @PathVariable String rsvtNo,
            @AuthenticationPrincipal CustomUser customUser
    ) {
        PublicFacilityReservationVO searchVO = new PublicFacilityReservationVO();
        searchVO.setRsvtNo(rsvtNo);
        searchVO.setUserNo(customUser.getMember().getUserNo());
        searchVO.setAptCmplexNo(service.getResidentAptCmplexNo(customUser.getMember().getUserNo()));

        return service.getMyReservationDetail(searchVO);
    }

    /**
     * 입주민 - 예약 취소
     *
     * cancel이란? 예약 상태를 취소(CANCELLED)로 바꾸는 기능입니다.
     * 왜 POST? DB 데이터가 변경되기 때문에 GET이 아니라 POST를 사용합니다.
     */
    @PreAuthorize("hasRole('RESIDENT')")
    @PostMapping("/resident/publicFacility/myReservation/cancel/{rsvtNo}")
    @ResponseBody
    public String cancel(
            @PathVariable String rsvtNo,
            @AuthenticationPrincipal CustomUser customUser
    ) {
        PublicFacilityReservationVO vo = new PublicFacilityReservationVO();

        vo.setRsvtNo(rsvtNo);
        vo.setUserNo(customUser.getMember().getUserNo());
        vo.setAptCmplexNo(service.getResidentAptCmplexNo(customUser.getMember().getUserNo()));

        service.cancel(vo);

        return "OK";
    }

    /**
     * 입주민 - 선택한 시설의 시간표 조회
     */
    @PreAuthorize("hasRole('RESIDENT')")
    @GetMapping("/resident/publicFacility/reservation/{cmnFacilityNo}/time-slots")
    @ResponseBody
    public List<PublicFacilityReservationVO> reservationTimeSlots(
            @PathVariable String cmnFacilityNo,
            PublicFacilityReservationVO searchVO,
            @AuthenticationPrincipal CustomUser customUser
    ) {
        searchVO.setAptCmplexNo(service.getResidentAptCmplexNo(customUser.getMember().getUserNo()));
        searchVO.setSearchCmnFacilityNo(cmnFacilityNo);

        return service.getReservationTimeSlotList(searchVO);
    }


}
