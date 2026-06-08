//package kr.or.ddit.domain.apt.mgmtOffice.facility.publicFacility;
//
//import kr.or.ddit.domain.apt.mgmtOffice.common.service.IManagerModelService;
////import kr.or.ddit.domain.apt.mgmtOffice.facility.publicfacility.service.IPublicFacilityService;
////import kr.or.ddit.domain.apt.mgmtOffice.facility.publicfacility.vo.PublicFacilityVO;
//import kr.or.ddit.domain.member.vo.CustomUser;
//import lombok.extern.slf4j.Slf4j;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.security.access.prepost.PreAuthorize;
//import org.springframework.security.core.annotation.AuthenticationPrincipal;
//import org.springframework.stereotype.Controller;
//import org.springframework.ui.Model;
//import org.springframework.web.bind.annotation.*;
//
//import java.util.HashMap;
//import java.util.Map;
//
///**
// * 운영관리 -> 공용시설 관리 Controller
// * - fetch 사용하지 않는 동기식 화면 이동 기준
// * - 목록, 등록, 상세, 수정, 삭제를 JSP return / redirect로 처리
// */
//@Slf4j
//@Controller
//@PreAuthorize("hasRole('MNGR')")
//@RequestMapping("/manager/publicFacility")
//public class PublicFacilityController {
//
////    /** 공용시설 업무 Service */
////    @Autowired
////    private IPublicFacilityService publicFacilityService;
//
//    /** 관리사무소 화면 공통 model Service */
//    @Autowired
//    private IManagerModelService managerModelService;
//
//    /**
//     * 공용시설 목록 화면
//     * - 검색 조건 기준 목록 조회
//     * - JSP에서 c:forEach로 출력
//     */
//    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
//    @GetMapping("/list/{mgmtOfcNo}")
//    public String list(
//            @PathVariable String mgmtOfcNo,
//            @RequestParam(required = false, defaultValue = "") String cmnFacilitySttsCd,
//            @RequestParam(required = false, defaultValue = "") String rsvYn,
//            @RequestParam(required = false, defaultValue = "") String keyword,
//            @AuthenticationPrincipal CustomUser customUser,
//            Model model
//    ) {
//        managerModelService.addManagerViewModel(model, customUser, mgmtOfcNo); // 헤더/사이드바 공통 화면값 세팅
//
//        Map<String, Object> paramMap = new HashMap<>();       // 목록 검색 조건 Map
//        paramMap.put("mgmtOfcNo", mgmtOfcNo);                 // 관리사무소 번호 조건
//        paramMap.put("cmnFacilitySttsCd", cmnFacilitySttsCd); // 운영상태 검색 조건
//        paramMap.put("rsvYn", rsvYn);                         // 예약가능여부 검색 조건
//        paramMap.put("keyword", keyword);                     // 키워드 검색 조건
//
//      //  List<PublicFacilityVO> publicFacilityList = publicFacilityService.selectPublicFacilityList(paramMap); // 공용시설 목록 조회
//
//      //  model.addAttribute("publicFacilityList", publicFacilityList);       // 공용시설 목록 데이터
//        model.addAttribute("cmnFacilitySttsCd", cmnFacilitySttsCd);         // 운영상태 검색값 유지
//        model.addAttribute("rsvYn", rsvYn);                                 // 예약가능여부 검색값 유지
//        model.addAttribute("keyword", keyword);                             // 키워드 검색값 유지
//
//        return "apt/mgmtOffice/facility/publicFacility/publicFacilityList";
//    }
//
//
//    /**
//     * 공용시설 상세 화면
//     * - 목록 Grid의 상세 버튼에서 이동
//     * - DB 상세 조회 연결 전 화면 확인용
//     */
//    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
//    @GetMapping("/detail-page/{mgmtOfcNo}/{cmnFacilityNo}")
//    public String detailPage(
//            @PathVariable String mgmtOfcNo,
//            @PathVariable String cmnFacilityNo,
//            @AuthenticationPrincipal CustomUser customUser,
//            Model model
//    ) {
//        // 헤더/사이드바 공통 화면값 세팅
//        managerModelService.addManagerViewModel(model, customUser, mgmtOfcNo);
//
//        // 상세 JSP 화면 확인용 번호 전달
//        model.addAttribute("cmnFacilityNo", cmnFacilityNo);
//
//        return "apt/mgmtOffice/facility/publicFacility/publicFacilityDetail";
//    }
//
//    /**
//     * 공용시설 수정 화면
//     * - 목록 Grid의 수정 버튼에서 이동
//     * - DB 상세 조회 연결 전 화면 확인용
//     */
//    @PreAuthorize("@authService.canMgmtCrud(principal, #mgmtOfcNo)")
//    @GetMapping("/update-page/{mgmtOfcNo}/{cmnFacilityNo}")
//    public String updatePage(
//            @PathVariable String mgmtOfcNo,
//            @PathVariable String cmnFacilityNo,
//            @AuthenticationPrincipal CustomUser customUser,
//            Model model
//    ) {
//        // 헤더/사이드바 공통 화면값 세팅
//        managerModelService.addManagerViewModel(model, customUser, mgmtOfcNo);
//
//        // 수정 JSP 화면 확인용 번호 전달
//        model.addAttribute("cmnFacilityNo", cmnFacilityNo);
//
//        return "apt/mgmtOffice/facility/publicFacility/publicFacilityUpdate";
//    }
//
//    /**
//     * 공용 아이템 상세 화면
//     * - 공용 아이템 탭 Grid의 상세 버튼에서 이동
//     * - DB 상세 조회 연결 전 화면 확인용
//     */
//    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
//    @GetMapping("/item/detail-page/{mgmtOfcNo}/{cmnFacilityItemNo}")
//    public String itemDetailPage(
//            @PathVariable String mgmtOfcNo,
//            @PathVariable String cmnFacilityItemNo,
//            @AuthenticationPrincipal CustomUser customUser,
//            Model model
//    ) {
//        // 헤더/사이드바 공통 화면값 세팅
//        managerModelService.addManagerViewModel(model, customUser, mgmtOfcNo);
//
//        // 아이템 상세 JSP 화면 확인용 번호 전달
//        model.addAttribute("cmnFacilityItemNo", cmnFacilityItemNo);
//
//        return "apt/mgmtOffice/facility/publicFacility/item/publicFacilityItemDetail";
//    }
//
//    /**
//     * 공용 아이템 수정 화면
//     * - 공용 아이템 탭 Grid의 수정 버튼에서 이동
//     * - DB 상세 조회 연결 전 화면 확인용
//     */
//    @PreAuthorize("@authService.canMgmtCrud(principal, #mgmtOfcNo)")
//    @GetMapping("/item/update-page/{mgmtOfcNo}/{cmnFacilityItemNo}")
//    public String itemUpdatePage(
//            @PathVariable String mgmtOfcNo,
//            @PathVariable String cmnFacilityItemNo,
//            @AuthenticationPrincipal CustomUser customUser,
//            Model model
//    ) {
//        // 헤더/사이드바 공통 화면값 세팅
//        managerModelService.addManagerViewModel(model, customUser, mgmtOfcNo);
//
//        // 아이템 수정 JSP 화면 확인용 번호 전달
//        model.addAttribute("cmnFacilityItemNo", cmnFacilityItemNo);
//
//        return "apt/mgmtOffice/facility/publicFacility/item/publicFacilityItemUpdate";
//    }
////
////    /**
////     * 공용시설 등록 화면
////     * - 등록 폼 화면 이동
////     */
////    @PreAuthorize("@authService.canMgmtCrud(principal, #mgmtOfcNo)")
////    @GetMapping("/register/{mgmtOfcNo}")
////    public String register(
////            @PathVariable String mgmtOfcNo,
////            @AuthenticationPrincipal CustomUser customUser,
////            Model model
////    ) {
////        managerModelService.addManagerViewModel(model, customUser, mgmtOfcNo); // 헤더/사이드바 공통 화면값 세팅
////
////        return "apt/mgmtOffice/facility/publicFacility/publicFacilityRegister";
////    }
////
////    /**
////     * 공용시설 등록 처리
////     * - form submit 기준 등록 처리
////     * - 등록 후 목록 화면으로 redirect
////     */
////    @PreAuthorize("@authService.canMgmtCrud(principal, #mgmtOfcNo)")
////    @PostMapping("/insert/{mgmtOfcNo}")
////    public String insert(
////            @PathVariable String mgmtOfcNo,
////            PublicFacilityVO publicFacilityVO,
////            @RequestParam(required = false) List<MultipartFile> facilityFiles
////    ) {
////        publicFacilityVO.setMgmtOfcNo(mgmtOfcNo); // 관리사무소 번호 세팅
////
////        publicFacilityService.insertPublicFacility(publicFacilityVO, facilityFiles); // 공용시설 등록 처리
////
////        return "redirect:/manager/publicFacility/list/" + mgmtOfcNo;
////    }
////
//    /**
//     * 공용시설 상세 화면
//     * - 상세 데이터 조회 후 JSP 출력
//     */
//    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
//    @GetMapping("/detail/{mgmtOfcNo}/{cmnFacilityNo}")
//    public String detail(
//            @PathVariable String mgmtOfcNo,
//            @PathVariable String cmnFacilityNo,
//            @AuthenticationPrincipal CustomUser customUser,
//            Model model
//    ) {
//        managerModelService.addManagerViewModel(model, customUser, mgmtOfcNo); // 헤더/사이드바 공통 화면값 세팅
//
//        Map<String, Object> paramMap = new HashMap<>(); // 상세 조회 조건 Map
//        paramMap.put("mgmtOfcNo", mgmtOfcNo);           // 관리사무소 번호 조건
//        paramMap.put("cmnFacilityNo", cmnFacilityNo);   // 공용시설 번호 조건
//
//      //  PublicFacilityVO detail = publicFacilityService.selectPublicFacilityDetail(paramMap); // 공용시설 상세 조회
//
//    //    model.addAttribute("detail", detail); // 상세 화면 데이터
//
//        return "apt/mgmtOffice/facility/publicFacility/publicFacilityDetail";
//    }
////
////    /**
////     * 공용시설 수정 화면
////     * - 기존 상세 데이터 조회 후 수정폼 출력
////     */
////    @PreAuthorize("@authService.canMgmtCrud(principal, #mgmtOfcNo)")
////    @GetMapping("/update/{mgmtOfcNo}/{cmnFacilityNo}")
////    public String updateForm(
////            @PathVariable String mgmtOfcNo,
////            @PathVariable String cmnFacilityNo,
////            @AuthenticationPrincipal CustomUser customUser,
////            Model model
////    ) {
////        managerModelService.addManagerViewModel(model, customUser, mgmtOfcNo); // 헤더/사이드바 공통 화면값 세팅
////
////        Map<String, Object> paramMap = new HashMap<>(); // 수정 화면 조회 조건 Map
////        paramMap.put("mgmtOfcNo", mgmtOfcNo);           // 관리사무소 번호 조건
////        paramMap.put("cmnFacilityNo", cmnFacilityNo);   // 공용시설 번호 조건
////
////        PublicFacilityVO detail = publicFacilityService.selectPublicFacilityDetail(paramMap); // 공용시설 상세 조회
////
////        model.addAttribute("detail", detail); // 수정 화면 데이터
////
////        return "apt/mgmtOffice/facility/publicfacility/publicFacilityUpdate";
////    }
////
////    /**
////     * 공용시설 수정 처리
////     * - form submit 기준 수정 처리
////     * - 수정 후 상세 화면으로 redirect
////     */
////    @PreAuthorize("@authService.canMgmtCrud(principal, #mgmtOfcNo)")
////    @PostMapping("/update/{mgmtOfcNo}")
////    public String update(
////            @PathVariable String mgmtOfcNo,
////            PublicFacilityVO publicFacilityVO,
////            @RequestParam(required = false) List<MultipartFile> facilityFiles,
////            @RequestParam(required = false) List<String> deleteFileNoList
////    ) {
////        publicFacilityVO.setMgmtOfcNo(mgmtOfcNo); // 관리사무소 번호 세팅
////
////        publicFacilityService.updatePublicFacility(publicFacilityVO, facilityFiles, deleteFileNoList); // 공용시설 수정 처리
////
////        return "redirect:/manager/publicFacility/detail/" + mgmtOfcNo + "/" + publicFacilityVO.getCmnFacilityNo();
////    }
////
////    /**
////     * 공용시설 삭제 처리
////     * - 실제 삭제 또는 사용여부 변경은 Service에서 결정
////     * - 처리 후 목록 화면으로 redirect
////     */
////    @PreAuthorize("@authService.canMgmtCrud(principal, #mgmtOfcNo)")
////    @PostMapping("/delete/{mgmtOfcNo}")
////    public String delete(
////            @PathVariable String mgmtOfcNo,
////            @RequestParam String cmnFacilityNo
////    ) {
////        Map<String, Object> paramMap = new HashMap<>(); // 삭제 조건 Map
////        paramMap.put("mgmtOfcNo", mgmtOfcNo);           // 관리사무소 번호 조건
////        paramMap.put("cmnFacilityNo", cmnFacilityNo);   // 공용시설 번호 조건
////
////        publicFacilityService.deletePublicFacility(paramMap); // 공용시설 삭제 처리
////
////        return "redirect:/manager/publicFacility/list/" + mgmtOfcNo;
////    }
//}