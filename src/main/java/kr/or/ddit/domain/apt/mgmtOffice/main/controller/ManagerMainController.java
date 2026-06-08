package kr.or.ddit.domain.apt.mgmtOffice.main.controller;

import kr.or.ddit.domain.apt.main.service.IAptComplexService;
import kr.or.ddit.domain.apt.main.vo.AptComplexVO;
import kr.or.ddit.domain.apt.mgmtOffice.main.mapper.IMgmtOfficeMapper;
import kr.or.ddit.domain.apt.mgmtOffice.main.vo.MgmtOfficeVO;
import kr.or.ddit.domain.apt.mgmtOffice.main.vo.ManagerPaginationVO;
import kr.or.ddit.domain.apt.mgmtOffice.common.service.IManagerModelService;
import kr.or.ddit.domain.apt.mgmtOffice.facility.service.IFacilityService;
import kr.or.ddit.domain.apt.mgmtOffice.resident.service.IMngResidentAuthService;
import kr.or.ddit.domain.apt.mgmtOffice.resident.vo.MngResidentAuthVO;
import kr.or.ddit.domain.member.manager.vo.MngrVO;
import kr.or.ddit.domain.member.vo.CustomUser;
import kr.or.ddit.domain.member.vo.MemberVO;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import kr.or.ddit.domain.apt.mgmtOffice.employee.service.IVisitVhclService;
import kr.or.ddit.domain.apt.mgmtOffice.employee.vo.VstVhclRsvtVO;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import kr.or.ddit.domain.apt.mgmtOffice.main.service.IAptScheduleCalendarService;
import kr.or.ddit.domain.apt.mgmtOffice.main.vo.AptScheduleCalendarDTO;

@Controller
@RequestMapping("/manager")
@PreAuthorize("hasRole('MNGR')")  // 계층 구조상 ADMIN도 통과
@RequiredArgsConstructor
public class ManagerMainController {

    // 관리사무소 목록 조회용 Mapper
    private final IMgmtOfficeMapper mgmtOfficeMapper;
    private final IVisitVhclService visitVhclService;

    private final IMngResidentAuthService residentAuthService;

    // ADMIN/MNGR 접근 기준 및 화면 공통 모델 처리
    private final IManagerModelService managerAccessService;
    private final IFacilityService facilityService;

    //관리사무소 - 단지일정캘린더
    private final IAptScheduleCalendarService aptScheduleCalendarService;


    @Autowired
    private IAptComplexService aptComplexService;

    // ──/manager/main 진입─────────────────────────────────────
    // ADMIN은 관리사무소 선택 모달 표시
    // MNGR은 본인 관리사무소 번호가 붙은 대시보드로 이동
    @GetMapping("/main")
    public String managerMain(
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {
        boolean admin = managerAccessService.isAdmin(customUser);

        if (admin) {
            managerAccessService.addManagerViewModel(model, customUser, null);
            return "apt/mgmtOffice/office";
        }

        MemberVO member = customUser.getMember();

        if (member instanceof MngrVO) {
            MngrVO loginMngr = (MngrVO) member;
            return "redirect:/manager/main/" + loginMngr.getMgmtOfcNo();
        }

        return "apt/mgmtOffice/office";
    }

    // 관리사무소 번호 기준 대시보드
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/main/{mgmtOfcNo}")
    public String managerDashboard(
            @PathVariable String mgmtOfcNo,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {
        managerAccessService.addManagerViewModel(model, customUser, mgmtOfcNo);
        return "apt/mgmtOffice/office";
    }

    // ── ADMIN 전용 API ────────────────────────────────────────

    // ADMIN 관리사무소 선택 모달 목록 조회
    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/admin-mgmt-ofc/list")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getAdminMgmtOfcList(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(required = false) String searchWord,
            @RequestParam(required = false) String sidoNm,
            @RequestParam(required = false) String sigunguNm
    ) {
        Map<String, Object> result = new HashMap<>();

        try {
            // 모달 페이징 기준 생성
            ManagerPaginationVO<MgmtOfficeVO> pagingVO = new ManagerPaginationVO<>(8, 5);

            // 현재 페이지 기준 row 계산
            pagingVO.setCurrentPage(page);

            // 검색/지역 필터 조건 세팅
            pagingVO.setSearchWord(searchWord);
            pagingVO.setSidoNm(sidoNm);
            pagingVO.setSigunguNm(sigunguNm);

            // 전체 건수 조회
            int totalRecord = mgmtOfficeMapper.selectAdminMgmtOfficeCount(pagingVO);
            pagingVO.setTotalRecord(totalRecord);

            // 현재 페이지 목록 조회
            List<MgmtOfficeVO> list = mgmtOfficeMapper.selectAdminMgmtOfficeList(pagingVO);
            pagingVO.setDataList(list);

            // 모달 목록/페이징 응답
            result.put("list", pagingVO.getDataList());
            result.put("pagingHTML", pagingVO.getPagingHTML());
            result.put("currentPage", pagingVO.getCurrentPage());
            result.put("totalPage", pagingVO.getTotalPage());
            result.put("totalRecord", pagingVO.getTotalRecord());

        } catch (Exception e) {
            // 조회 실패 시 빈 목록 반환
            result.put("list", new ArrayList<>());
            result.put("pagingHTML", "");
            result.put("message", e.getMessage());
        }

        return ResponseEntity.ok(result);
    }

    // 관리사무소 선택 완료
    // 세션 저장 없이 선택한 관리사무소 번호만 반환
    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/admin-mgmt-ofc/select")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> selectAdminMgmtOfc(
            @RequestBody Map<String, String> body
    ) {
        Map<String, Object> result = new HashMap<>();

        try {
            String mgmtOfcNo = body.get("mgmtOfcNo");

            if (mgmtOfcNo == null || mgmtOfcNo.isBlank()) {
                result.put("success", false);
                result.put("message", "관리사무소를 선택해 주세요.");
                return ResponseEntity.ok(result);
            }

            result.put("success", true);
            result.put("mgmtOfcNo", mgmtOfcNo);
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }

        return ResponseEntity.ok(result);
    }
        //시도 목록 조회 API
        @PreAuthorize("hasRole('ADMIN')")
        @GetMapping("/admin-mgmt-ofc/sido/list")
        @ResponseBody
        public List<String> getAdminMgmtOfcSidoList() {
            return mgmtOfficeMapper.selectAdminMgmtOfficeSidoList();
        }
        //시군구 목록 조회 API
        @PreAuthorize("hasRole('ADMIN')")
        @GetMapping("/admin-mgmt-ofc/sigungu/list")
        @ResponseBody
        public List<String> getAdminMgmtOfcSigunguList(
                @RequestParam String sidoNm
        ) {
            return mgmtOfficeMapper.selectAdminMgmtOfficeSigunguList(sidoNm);
        }


    // ── 화면 이동 매핑 ────────────────────────────────────────
    // 대시보드를 제외한 관리사무소 화면은 모두 mgmtOfcNo를 주소에 포함

    // 직원 계정 관리
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/employee/account/{mgmtOfcNo}")
    public String employeeAccount(
            @PathVariable String mgmtOfcNo,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {
        // JSP 표시용 기본값 세팅
        // - 관리자 여부, 관리사무소 번호, 로그인 사용자명
        // - 관리사무소명, 단지명
        managerAccessService.addManagerViewModel(model, customUser, mgmtOfcNo);
        return "apt/mgmtOffice/employee/mngr_account";
    }

    // 관리사무소 - 단지 일정 캘린더
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/aptScheduleCalendar/{mgmtOfcNo}")
    public String aptScheduleCalendar(
            @PathVariable String mgmtOfcNo,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {
        managerAccessService.addManagerViewModel(model, customUser, mgmtOfcNo);

        /*
         * 직원 목록을 미리 넣는 이유
         * - 휴가 등록 모달의 직원 select box에서 DB 직원 목록을 보여주기 위해서입니다.
         */
        model.addAttribute("managerEmployeeList", aptScheduleCalendarService.selectManagerEmployeeList(mgmtOfcNo));
        model.addAttribute( "vacationTypeCodeList", aptScheduleCalendarService.selectVacationTypeCodeList());
        return "apt/mgmtOffice/calendar/aptScheduleCalendar";
    }

    // 관리사무소 - 단지 일정 캘린더 - 월간 일정 조회 Ajax API
    /*
     * 관리사무소 단지 일정 목록 조회 Ajax API
     *
     * 왜 Map<String, Object> 로 반환?
     * - 일정 목록만 아니라
     *   현재페이지, 전체페이지 같은 페이징 정보도 같이 보내기 위해 사용합니다.
     */
    @ResponseBody
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/aptScheduleCalendar/{mgmtOfcNo}/list")
    public Map<String, Object> aptScheduleCalendarList(
            @PathVariable String mgmtOfcNo,
            @RequestParam(value = "currentPage", defaultValue = "1") int currentPage,
            AptScheduleCalendarDTO searchVO
    ) {

        /*
         * 관리사무소 번호로 단지번호 조회
         *
         * 왜 필요?
         * - 일정 데이터는 실제로 단지번호 기준으로 조회되기 때문입니다.
         */
        String aptCmplexNo =
                aptScheduleCalendarService.selectAptCmplexNoByMgmtOfcNo(mgmtOfcNo);

        /*
         * 검색조건 DTO 세팅
         */
        searchVO.setMgmtOfcNo(mgmtOfcNo);
        searchVO.setAptCmplexNo(aptCmplexNo);

        /*
         * 페이징 처리 서비스 호출
         *
         * 반환 데이터 예시:
         * - list
         * - pagingHTML
         * - currentPage
         * - totalPage
         * - totalRecord
         */
        return aptScheduleCalendarService
                .selectScheduleCalendarPage(searchVO, currentPage);
    }

    // 관리사무소 - 단지 일정 캘린더 - 직원 휴가 등록 Ajax API
    @ResponseBody
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @PostMapping("/aptScheduleCalendar/{mgmtOfcNo}/vacation")
    public ResponseEntity<Map<String, Object>> insertVacationSchedule(
            @PathVariable String mgmtOfcNo,
            @RequestBody AptScheduleCalendarDTO aptScheduleCalendarDTO
    ) {
        aptScheduleCalendarDTO.setMgmtOfcNo(mgmtOfcNo);

        Map<String, Object> result = new HashMap<>();
        int cnt = aptScheduleCalendarService.insertVacationSchedule(aptScheduleCalendarDTO);
        result.put("success", cnt > 0);
        result.put("message", cnt > 0 ? "휴가 일정이 등록되었습니다." : "휴가 일정 등록에 실패했습니다.");

        return ResponseEntity.ok(result);
    }

    // 관리사무소 - 단지 일정 캘린더 - 직원 휴가 수정 Ajax API
    @ResponseBody
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @PutMapping("/aptScheduleCalendar/{mgmtOfcNo}/vacation/{scheduleNo}")
    public ResponseEntity<Map<String, Object>> updateVacationSchedule(
            @PathVariable String mgmtOfcNo,
            @PathVariable String scheduleNo,
            @RequestBody AptScheduleCalendarDTO aptScheduleCalendarDTO
    ) {
        /*
         * @PutMapping이란?
         * 기존 데이터를 수정할 때 주로 사용하는 요청 방식입니다.
         *
         * 왜 사용?
         * 휴가 일정은 이미 등록된 데이터이므로 POST가 아니라 PUT으로 수정 요청을 보냅니다.
         */
        aptScheduleCalendarDTO.setMgmtOfcNo(mgmtOfcNo);
        aptScheduleCalendarDTO.setScheduleNo(scheduleNo);

        Map<String, Object> result = new HashMap<>();

        int cnt = aptScheduleCalendarService.updateVacationSchedule(aptScheduleCalendarDTO);

        result.put("success", cnt > 0);
        result.put("message", cnt > 0 ? "휴가 일정이 수정되었습니다." : "수정할 휴가 일정이 없습니다.");

        return ResponseEntity.ok(result);
    }

    // 관리사무소 - 단지 일정 캘린더 - 직원 휴가 삭제 Ajax API
    @ResponseBody
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @DeleteMapping("/aptScheduleCalendar/{mgmtOfcNo}/vacation/{scheduleNo}")
    public ResponseEntity<Map<String, Object>> deleteVacationSchedule(
            @PathVariable String mgmtOfcNo,
            @PathVariable String scheduleNo
    ) {
        AptScheduleCalendarDTO deleteDTO = new AptScheduleCalendarDTO();
        deleteDTO.setMgmtOfcNo(mgmtOfcNo);
        deleteDTO.setScheduleNo(scheduleNo);

        Map<String, Object> result = new HashMap<>();
        int cnt = aptScheduleCalendarService.deleteVacationSchedule(deleteDTO);
        result.put("success", cnt > 0);
        result.put("message", cnt > 0 ? "휴가 일정이 삭제되었습니다." : "삭제할 휴가 일정이 없습니다.");

        return ResponseEntity.ok(result);
    }


    // 입주민 목록
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/resident/list/{mgmtOfcNo}")
    public String residentList(
            @PathVariable String mgmtOfcNo,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {
        //////////////


        /////////////////
        managerAccessService.addManagerViewModel(model, customUser, mgmtOfcNo);
        return "apt/mgmtOffice/mngr_resident_list";
    }

    // 입주민 승인
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/resident/auth/{mgmtOfcNo}")
    public String residentAuth(
            @PathVariable String mgmtOfcNo,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {

        List<MngResidentAuthVO> residentAuthList
                = residentAuthService.selectResidentAuthList();

        System.out.println("residentAuthList = " + residentAuthList);

        model.addAttribute("residentAuthList", residentAuthList);

        managerAccessService.addManagerViewModel(model, customUser, mgmtOfcNo);

        return "apt/mgmtOffice/mngr_resident_auth";
    }
    // 전출입 관리
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/resident/moveList/{mgmtOfcNo}")
    public String moveList(
            @PathVariable String mgmtOfcNo,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {
        managerAccessService.addManagerViewModel(model, customUser, mgmtOfcNo);
        return "apt/mgmtOffice/mngr_resident_moveList";
    }

    // 입주민 자동 처리
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/resident/auto/{mgmtOfcNo}")
    public String residentAuto(
            @PathVariable String mgmtOfcNo,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {
        managerAccessService.addManagerViewModel(model, customUser, mgmtOfcNo);
        return "redirect:/manager/resident/auto/list/" + mgmtOfcNo;
    }




    // 방문 차량 자동 처리
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/visit/auto/{mgmtOfcNo}")
    public String visitAuto(
            @PathVariable String mgmtOfcNo,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {

        managerAccessService.addManagerViewModel(model, customUser, mgmtOfcNo);

        String aptCmplexNo =
                aptComplexService
                        .selectOneAptCmplexByMgmtOfcNo(mgmtOfcNo);

        List<VstVhclRsvtVO> vehicleList =
                visitVhclService
                        .getVisitVehicleList(aptCmplexNo);

        model.addAttribute("vehicleList", vehicleList);

        return "apt/mgmtOffice/mngr_visit_auto";
    }





    // 시설 목록
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("facility/page/{mgmtOfcNo}")
    public String facilityList(
            @PathVariable String mgmtOfcNo,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {
        managerAccessService.addManagerViewModel(model, customUser, mgmtOfcNo);
        model.addAttribute("dongList", facilityService.selectDongList(mgmtOfcNo));
        return "apt/mgmtOffice/facility/mngr_facility_list";
    }

    // 편의 시설
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/publicFacility/page/{mgmtOfcNo}")
    public String publicFacilityList(
            @PathVariable String mgmtOfcNo,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {
        managerAccessService.addManagerViewModel(model, customUser, mgmtOfcNo);
        model.addAttribute("activeMenu", "publicFacility");
        return "apt/mgmtOffice/facility/publicFacility/publicFacilityList";
    }


    // 작업 일정
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/facility/workCalendar/{mgmtOfcNo}")
    public String workCalendar(
            @PathVariable String mgmtOfcNo,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {
        managerAccessService.addManagerViewModel(model, customUser, mgmtOfcNo);
        return "apt/mgmtOffice/mngr_facility_workCalendar";
    }

    // 협력업체
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/partner/partnerList/{mgmtOfcNo}")
    public String partnerList(
            @PathVariable String mgmtOfcNo,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {
        managerAccessService.addManagerViewModel(model, customUser, mgmtOfcNo);
        return "apt/mgmtOffice/partner/mngr_partner_list";
    }

    // 계약 관리
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/contract/{mgmtOfcNo}")
    public String contractList(
            @PathVariable String mgmtOfcNo,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {
        // 관리사무소 공통 화면 모델 구성
        managerAccessService.addManagerViewModel(model, customUser, mgmtOfcNo);

        // 계약 화면에서 사용할 관리사무소 번호 전달
        model.addAttribute("mgmtOfcNo", mgmtOfcNo);

        return "apt/mgmtOffice/contract/mngr_contract_list";
    }



    // 단지 구조 정보 수정페이지
    @GetMapping({"/complex/buildingLayOut/{mgmtOfcNo}"})
    public String complexEdit(
            @PathVariable String mgmtOfcNo,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {
        // mgmtOfcNo 로 아파트 정보 가져오는 메서드
        AptComplexVO aptComplexVO = aptComplexService.selectMgmtOfcNoAptComplex(mgmtOfcNo);

        model.addAttribute("complex",aptComplexVO);
        managerAccessService.addManagerViewModel(model, customUser, mgmtOfcNo);

        return "apt/mgmtOffice/mngr_building_layout_edit";
    }



    // 단지 정보 수정페이지
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping({"/complex/edit/{mgmtOfcNo}"})
    public String complexEditt(
            @PathVariable String mgmtOfcNo,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {
        // mgmtOfcNo 로 아파트 정보 가져오는 메서드
        AptComplexVO aptComplexVO = aptComplexService.selectMgmtOfcNoAptComplex(mgmtOfcNo);

        managerAccessService.addManagerViewModel(model, customUser, mgmtOfcNo);
        System.out.println("mgmtOfcNo = " + mgmtOfcNo);
        System.out.println("complex = " + aptComplexVO);

        return "apt/mgmtOffice/mngr_complex_edit";
    }

    // 민원 접수 현황 페이지
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping({"/complex/complaint/{mgmtOfcNo}"})
    public String cvplList(
            @PathVariable String mgmtOfcNo,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {
        // mgmtOfcNo 로 아파트 정보 가져오는 메서드
        AptComplexVO aptComplexVO = aptComplexService.selectMgmtOfcNoAptComplex(mgmtOfcNo);


        managerAccessService.addManagerViewModel(model, customUser, mgmtOfcNo);
        model.addAttribute("mgmtOfcNo", mgmtOfcNo);
        System.out.println("mgmtOfcNo = " + mgmtOfcNo);
        System.out.println("complex = " + aptComplexVO);

        return "apt/mgmtOffice/complaint/mngrComplaint";
    }

    /**
     * 방송 안내 <b>송출·작성</b> 화면 (JSP: mngr_broadcast.jsp).
     * TTS·WS 송출 로직은 broadcast 패키지 API/WS 를 쓰고, 뷰 라우팅만 여기서 처리합니다.
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/complex/broadcast/{mgmtOfcNo}")
    public String broadcastForm(
            @PathVariable String mgmtOfcNo,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {
        // mgmtOfcNo 로 아파트 정보 가져오는 메서드
        AptComplexVO aptComplexVO = aptComplexService.selectMgmtOfcNoAptComplex(mgmtOfcNo);

        managerAccessService.addManagerViewModel(model, customUser, mgmtOfcNo);
        model.addAttribute("mgmtOfcNo", mgmtOfcNo);
        model.addAttribute("dongList", facilityService.selectDongList(mgmtOfcNo));

        return "apt/mgmtOffice/broadcast/mngr_broadcast";
    }

    /**
     * 동별 방송 <b>수신기</b> 화면.
     * <ul>
     *   <li>{@code dongNo} 없음 → mngr_broadcast_receive_pick.jsp (동 선택)</li>
     *   <li>{@code dongNo} 있음 → mngr_broadcast_receive.jsp (WS 구독·TTS 재생)</li>
     * </ul>
     * model: mgmtOfcNo, dongList, dongNo, dongLabel, dongValid(등록 동 여부)
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/complex/broadcast/receive/{mgmtOfcNo}")
    public String broadcastReceive(
            @PathVariable String mgmtOfcNo,
            @RequestParam(required = false) String dongNo,
            @RequestParam(required = false) String dongLabel,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {
        managerAccessService.addManagerViewModel(model, customUser, mgmtOfcNo);
        model.addAttribute("mgmtOfcNo", mgmtOfcNo);

        var dongList = facilityService.selectDongList(mgmtOfcNo);
        model.addAttribute("dongList", dongList);

        if (dongNo == null || dongNo.isBlank()) {
            return "apt/mgmtOffice/broadcast/mngr_broadcast_receive_pick";
        }

        String resolvedLabel = dongLabel;
        boolean validDong = false;
        if (dongList != null) {
            for (var dong : dongList) {
                if (dongNo.equals(dong.getDongNo())) {
                    validDong = true;
                    if (resolvedLabel == null || resolvedLabel.isBlank()) {
                        String base = dong.getDongNo();
                        if (base != null && base.contains("_")) {
                            base = base.substring(base.indexOf('_') + 1);
                        }
                        if (dong.getDongNm() != null && !dong.getDongNm().isBlank()) {
                            base = dong.getDongNm();
                        }
                        resolvedLabel = (base != null && base.endsWith("동")) ? base : base + "동";
                    }
                    break;
                }
            }
        }
        if (!validDong) {
            resolvedLabel = resolvedLabel != null && !resolvedLabel.isBlank() ? resolvedLabel : dongNo;
        }

        model.addAttribute("dongNo", dongNo);
        model.addAttribute("dongLabel", resolvedLabel != null ? resolvedLabel : dongNo);
        model.addAttribute("dongValid", validDong);

        return "apt/mgmtOffice/broadcast/mngr_broadcast_receive";
    }


}
