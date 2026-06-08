package kr.or.ddit.domain.apt.mgmtOffice.facility.check.controller;

import kr.or.ddit.common.model.PaginationInfoVO;
import kr.or.ddit.domain.apt.mgmtOffice.common.service.IManagerModelService;
import kr.or.ddit.domain.apt.mgmtOffice.facility.check.service.IFacilityCheckService;
import kr.or.ddit.domain.apt.mgmtOffice.facility.check.vo.FacilityCheckHstryVO;
import kr.or.ddit.domain.member.vo.CustomUser;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 시설 점검 이력 Controller
 *
 * 역할
 * - 시설 점검 이력 목록/상세/등록/수정 화면 이동
 * - 후속 이력 등록 화면 이동
 * - 등록/수정 통합 폼 화면에 필요한 모델 구성
 * - 시설 선택/협력업체 선택/같은 시설 이력 조회 AJAX 처리
 */
@Slf4j
@Controller
@PreAuthorize("hasRole('MNGR')")
@RequiredArgsConstructor
@RequestMapping("/manager/checkHistory")
public class FacilityCheckController {

    /** 시설 점검 이력 Service */
    private final IFacilityCheckService facilityCheckService;

    /** 관리사무소 공통 모델 Service */
    private final IManagerModelService managerModelService;

    /**
     * 시설 점검 이력 목록 화면
     *
     * 화면 역할
     * - 점검 이력 목록 조회
     * - 현황 카드 조회
     * - 점검유형/점검상태/기간/검색어 필터 처리
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/{mgmtOfcNo}")
    public String list(
            @PathVariable String mgmtOfcNo,
            @RequestParam(required = false, defaultValue = "1") int page,
            @RequestParam(required = false, defaultValue = "") String searchWord,
            @RequestParam(required = false, defaultValue = "") String facilityNo,
            @RequestParam(required = false, defaultValue = "") String partnerNo,
            @RequestParam(required = false, defaultValue = "") String chkCtgryCd,
            @RequestParam(required = false, defaultValue = "") String chkTyCd,
            @RequestParam(required = false, defaultValue = "") String chkSttsCd,
            @RequestParam(required = false, defaultValue = "") String useRestrictYn,
            @RequestParam(required = false, defaultValue = "") String useRestrictStatusCd,
            @RequestParam(required = false, defaultValue = "") String chkStartDt,
            @RequestParam(required = false, defaultValue = "") String chkEndDt,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {
        /* 관리사무소 공통 화면 모델 세팅 */
        managerModelService.addManagerViewModel(model, customUser, mgmtOfcNo);

        /* 목록 검색 조건 VO 생성 */
        FacilityCheckHstryVO searchVO = new FacilityCheckHstryVO();
        searchVO.setMgmtOfcNo(mgmtOfcNo);
        /* 시설 상세 화면에서 넘어온 시설번호 필터 */
        searchVO.setFacilityNo(facilityNo);
        /* 협력업체 상세 화면에서 넘어온 협력업체번호 필터 */
        searchVO.setPartnerNo(partnerNo);
        searchVO.setChkCtgryCd(chkCtgryCd);
        searchVO.setChkTyCd(chkTyCd);
        searchVO.setChkSttsCd(chkSttsCd);
        /* 이용제한 여부 검색 조건 */
        searchVO.setUseRestrictYn(useRestrictYn);
        searchVO.setUseRestrictStatusCd(useRestrictStatusCd);
        searchVO.setChkStartDt(chkStartDt);
        searchVO.setChkEndDt(chkEndDt);

        /* 공통 페이지네이션 VO 생성 */
        PaginationInfoVO<FacilityCheckHstryVO> pagingVO = new PaginationInfoVO<>();
        pagingVO.setSearchWord(searchWord);
        pagingVO.setSearchVO(searchVO);

        /* 전체 건수 조회 */
        int totalRecord = facilityCheckService.selectFacilityCheckCount(pagingVO);
        pagingVO.setTotalRecord(totalRecord);

        /* 현재 페이지 세팅 */
        pagingVO.setCurrentPage(page);

        /* 현재 페이지 목록 조회 */
        List<FacilityCheckHstryVO> dataList = facilityCheckService.selectFacilityCheckList(pagingVO);
        pagingVO.setDataList(dataList);

        /* 화면 표시 모델 세팅 */
        model.addAttribute("mgmtOfcNo", mgmtOfcNo);
        model.addAttribute("pagingVO", pagingVO);
        model.addAttribute("searchVO", searchVO);
        model.addAttribute("searchWord", searchWord);
        model.addAttribute("facilityNo", facilityNo);
        model.addAttribute("partnerNo", partnerNo);

        /* 현황 카드 건수 */
        FacilityCheckHstryVO summary = facilityCheckService.selectFacilityCheckSummary(mgmtOfcNo);
        model.addAttribute("summary", summary == null ? new FacilityCheckHstryVO() : summary);

        /* 오늘 날짜와 겹치는 이용제한 이력 */
        model.addAttribute("todayUseRestrictList", facilityCheckService.selectTodayUseRestrictList(mgmtOfcNo));

        /* [추가] 내일 이후 시작 예정인 이용제한 이력 - 카드 클릭 모달의 '예정 일정' 섹션에서 사용 */
        model.addAttribute("futureUseRestrictList", facilityCheckService.selectFutureUseRestrictList(mgmtOfcNo));

        /* 필터용 공통코드 목록 */
        model.addAttribute("checkCategoryList", facilityCheckService.selectCheckCategoryList());
        model.addAttribute("checkTypeList", facilityCheckService.selectCheckTypeList());
        model.addAttribute("checkStatusList", facilityCheckService.selectCheckStatusList());

        return "apt/mgmtOffice/facility/check/mngr_facility_check_list";
    }

    /**
     * 시설 점검 이력 상세 화면
     *
     * 화면 역할
     * - 선택한 점검 이력 상세 조회
     * - 같은 시설의 다른 점검 이력 목록 조회
     * - 같은 시설의 자체점검/협력업체점검 흐름 확인
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/detail/{mgmtOfcNo}/{facChkHstryNo}")
    public String detail(
            @PathVariable String mgmtOfcNo,
            @PathVariable String facChkHstryNo,
            @AuthenticationPrincipal CustomUser customUser,
            Model model,
            RedirectAttributes redirectAttributes
    ) {
        /* 관리사무소 공통 화면 모델 세팅 */
        managerModelService.addManagerViewModel(model, customUser, mgmtOfcNo);

        /* 상세 대상 조회 */
        FacilityCheckHstryVO check = facilityCheckService.selectFacilityCheckDetail(mgmtOfcNo, facChkHstryNo);

        /* 상세 대상 없음 */
        if (check == null) {
            redirectAttributes.addFlashAttribute("message", "조회된 시설 점검 이력이 없습니다.");
            return "redirect:/manager/checkHistory/" + mgmtOfcNo;
        }

        /* 점검 주체 화면값 세팅 */
        setCheckOwnerType(check);

        /* 같은 시설 이력 목록 조회 */
        List<FacilityCheckHstryVO> sameFacilityCheckList =
                facilityCheckService.selectSameFacilityCheckList(mgmtOfcNo, check.getFacilityNo());

        /* 화면 표시 모델 세팅 */
        model.addAttribute("mgmtOfcNo", mgmtOfcNo);
        model.addAttribute("check", check);
        model.addAttribute("sameFacilityCheckList", sameFacilityCheckList);

        return "apt/mgmtOffice/facility/check/mngr_facility_check_detail";
    }

    /**
     * 시설 점검 이력 등록 화면
     *
     * 화면 역할
     * - 새 점검 흐름 등록
     * - facilityNo 파라미터가 있으면 특정 시설 기준 등록
     * - chkFlowNo는 비워두고 XML에서 새 이력번호를 흐름번호로 사용
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/register/{mgmtOfcNo}")
    public String registerPage(
            @PathVariable String mgmtOfcNo,
            @RequestParam(required = false, defaultValue = "") String facilityNo,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {
        /* 관리사무소 공통 화면 모델 세팅 */
        managerModelService.addManagerViewModel(model, customUser, mgmtOfcNo);

        /* 등록 화면 기본 객체 생성 */
        FacilityCheckHstryVO check = new FacilityCheckHstryVO();
        check.setMgmtOfcNo(mgmtOfcNo);

        /* 점검 주체 기본값 세팅 */
        check.setChkOwnerType("SELF");

        /* 시설 상세에서 진입한 경우 시설번호 세팅 */
        if (facilityNo != null && !facilityNo.isBlank()) {
            check.setFacilityNo(facilityNo);
        }

        /* 등록 화면 공통 모델 세팅 */
        setFormModel(mgmtOfcNo, "register", check, model);

        return "apt/mgmtOffice/facility/check/mngr_facility_check_form";
    }

    /**
     * 시설 점검 후속 이력 등록 화면
     *
     * 화면 역할
     * - 기존 점검 이력의 같은 흐름으로 새 이력 등록
     * - 기존 이력의 시설번호와 점검흐름번호 유지
     * - 자체점검/협력업체점검은 후속 등록 시 다시 선택 가능
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/follow/{mgmtOfcNo}/{facChkHstryNo}")
    public String followRegisterPage(
            @PathVariable String mgmtOfcNo,
            @PathVariable String facChkHstryNo,
            @AuthenticationPrincipal CustomUser customUser,
            Model model,
            RedirectAttributes redirectAttributes
    ) {
        /* 관리사무소 공통 화면 모델 세팅 */
        managerModelService.addManagerViewModel(model, customUser, mgmtOfcNo);

        /* 기준 이력 조회 */
        FacilityCheckHstryVO baseCheck =
                facilityCheckService.selectFacilityCheckDetail(mgmtOfcNo, facChkHstryNo);

        /* 기준 이력 없음 */
        if (baseCheck == null) {
            redirectAttributes.addFlashAttribute("message", "후속 이력을 등록할 기준 점검 이력이 없습니다.");
            return "redirect:/manager/checkHistory/" + mgmtOfcNo;
        }

        /* 기준 이력 점검 주체 세팅 */
        setCheckOwnerType(baseCheck);

        /* 후속 등록 기본 객체 생성 */
        FacilityCheckHstryVO check = new FacilityCheckHstryVO();
        check.setMgmtOfcNo(mgmtOfcNo);

        /* 같은 시설번호 유지 */
        check.setFacilityNo(baseCheck.getFacilityNo());

        /* 기준 이력 처리과정번호 검증 */
        /* - 후속 이력은 기존 처리과정번호가 있어야만 등록 가능 */
        /* - 처리과정번호가 없으면 FCH 이력번호로 대체하지 않음 */
        if (baseCheck.getChkFlowNo() == null || baseCheck.getChkFlowNo().isBlank()) {
            redirectAttributes.addFlashAttribute("message", "기준 이력에 처리과정번호가 없어 후속 이력을 등록할 수 없습니다.");
            return "redirect:/manager/checkHistory/detail/" + mgmtOfcNo + "/" + facChkHstryNo;
        }

        /* 같은 처리과정번호 유지 */
        check.setChkFlowNo(baseCheck.getChkFlowNo());

        /* 점검 주체 기본값 세팅 */
        check.setChkOwnerType("SELF");

        /* 등록 화면 공통 모델 세팅 */
        setFormModel(mgmtOfcNo, "follow", check, model);

        /* 후속 등록 기준 이력 전달 */
        model.addAttribute("baseCheck", baseCheck);

        return "apt/mgmtOffice/facility/check/mngr_facility_check_form";
    }

    /**
     * 시설 점검 이력 등록 처리
     *
     * 처리 기준
     * - 일반 등록: 새 CHK_FLOW_NO 생성
     * - 후속 등록: 기존 CHK_FLOW_NO 유지
     */
    @PreAuthorize("@authService.canMgmtCrud(principal, #mgmtOfcNo)")
    @PostMapping("/register/{mgmtOfcNo}")
    public String register(
            @PathVariable String mgmtOfcNo,
            @ModelAttribute FacilityCheckHstryVO facilityCheckHstryVO,
            RedirectAttributes redirectAttributes
    ) {
        /* 관리사무소 번호 보정 */
        facilityCheckHstryVO.setMgmtOfcNo(mgmtOfcNo);

        /* 시설 점검 이력 등록 */
        String facChkHstryNo = facilityCheckService.insertFacilityCheckHistory(facilityCheckHstryVO);

        /* 완료 메시지 */
        redirectAttributes.addFlashAttribute("message", "시설 점검 이력이 등록되었습니다.");

        return "redirect:/manager/checkHistory/detail/" + mgmtOfcNo + "/" + facChkHstryNo;
    }

    /**
     * 시설 점검 이력 수정 화면
     *
     * 화면 역할
     * - 등록/수정 통합 폼의 수정 모드
     * - 기존 이력의 partnerNo 기준으로 점검 주체 표시
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/update/{mgmtOfcNo}/{facChkHstryNo}")
    public String updatePage(
            @PathVariable String mgmtOfcNo,
            @PathVariable String facChkHstryNo,
            @AuthenticationPrincipal CustomUser customUser,
            Model model,
            RedirectAttributes redirectAttributes
    ) {
        /* 관리사무소 공통 화면 모델 세팅 */
        managerModelService.addManagerViewModel(model, customUser, mgmtOfcNo);

        /* 수정 대상 조회 */
        FacilityCheckHstryVO check = facilityCheckService.selectFacilityCheckDetail(mgmtOfcNo, facChkHstryNo);

        /* 수정 대상 없음 */
        if (check == null) {
            redirectAttributes.addFlashAttribute("message", "수정할 시설 점검 이력이 없습니다.");
            return "redirect:/manager/checkHistory/" + mgmtOfcNo;
        }

        /* 점검 주체 화면값 세팅 */
        setCheckOwnerType(check);

        /* 수정 화면 공통 모델 세팅 */
        setFormModel(mgmtOfcNo, "update", check, model);

        return "apt/mgmtOffice/facility/check/mngr_facility_check_form";
    }

    /**
     * 시설 점검 이력 수정 처리
     *
     * 처리 기준
     * - 기존 FACILITY_CHECK_HSTRY update
     * - CHK_FLOW_NO는 hidden 값으로 유지
     */
    @PreAuthorize("@authService.canMgmtCrud(principal, #mgmtOfcNo)")
    @PostMapping("/update/{mgmtOfcNo}/{facChkHstryNo}")
    public String update(
            @PathVariable String mgmtOfcNo,
            @PathVariable String facChkHstryNo,
            @ModelAttribute FacilityCheckHstryVO facilityCheckHstryVO,
            RedirectAttributes redirectAttributes
    ) {
        /* 수정 기준값 보정 */
        facilityCheckHstryVO.setMgmtOfcNo(mgmtOfcNo);
        facilityCheckHstryVO.setFacChkHstryNo(facChkHstryNo);

        /* 시설 점검 이력 수정 */
        facilityCheckService.updateFacilityCheckHistory(facilityCheckHstryVO);

        /* 완료 메시지 */
        redirectAttributes.addFlashAttribute("message", "시설 점검 이력이 수정되었습니다.");

        return "redirect:/manager/checkHistory/detail/" + mgmtOfcNo + "/" + facChkHstryNo;
    }

    /**
     * 등록/수정/후속 폼 공통 모델 세팅
     *
     * 모델 구성
     * - formMode                : register / update / follow
     * - check                   : 등록 기본값 또는 수정 대상
     * - facilityList            : 시설 선택 모달 기본 목록
     * - partnerList             : 협력업체 선택 모달 기본 목록
     * - checkTypeList           : 점검유형 공통코드
     * - checkStatusList         : 점검상태 공통코드
     * - assetFacilityTypeList   : 일반 시설자산 유형 목록
     * - publicFacilityTypeList  : 편의시설 유형 목록
     * - sameFacilityCheckList   : 선택 시설의 기존 점검 이력 목록
     */
    private void setFormModel(String mgmtOfcNo, String formMode, FacilityCheckHstryVO check, Model model) {
        /* null 방지용 기본 객체 보정 */
        if (check == null) {
            check = new FacilityCheckHstryVO();
        }

        /* 관리사무소 번호 보정 */
        check.setMgmtOfcNo(mgmtOfcNo);

        /* 점검 주체 기본값 보정 */
        setCheckOwnerType(check);

        /* 화면 기본값 */
        model.addAttribute("mgmtOfcNo", mgmtOfcNo);
        model.addAttribute("formMode", formMode);
        model.addAttribute("check", check);

        /*
         * 선택 모달 기본 목록
         * - 초기 진입 시 모달 안에 기본 목록 표시
         * - 상세 필터는 AJAX API에서 다시 조회
         */
        model.addAttribute("facilityList", facilityCheckService.selectFacilitySelectList(mgmtOfcNo));
        model.addAttribute("partnerList", facilityCheckService.selectPartnerSelectList(mgmtOfcNo));

        /* 공통코드 목록 */
        model.addAttribute("checkCategoryList", facilityCheckService.selectCheckCategoryList());
        model.addAttribute("checkTypeList", facilityCheckService.selectCheckTypeList());
        model.addAttribute("checkStatusList", facilityCheckService.selectCheckStatusList());

        /* 시설유형 목록 */
        model.addAttribute("assetFacilityTypeList", facilityCheckService.selectAssetFacilityTypeList());
        model.addAttribute("publicFacilityTypeList", facilityCheckService.selectPublicFacilityTypeList());

        /*
         * 같은 시설의 기존 점검 이력 목록
         * - 자체점검과 협력업체점검 모두 포함
         * - CHK_FLOW_NO 기준 후속 흐름 확인 가능
         */
        if (check.getFacilityNo() != null && !check.getFacilityNo().isBlank()) {
            List<FacilityCheckHstryVO> sameFacilityCheckList =
                    facilityCheckService.selectSameFacilityCheckList(mgmtOfcNo, check.getFacilityNo());

            model.addAttribute("sameFacilityCheckList", sameFacilityCheckList);
        }
    }

    /**
     * 점검 주체 화면값 세팅
     * - partnerNo가 없으면 자체점검
     * - partnerNo가 있으면 협력업체점검
     * - 이미 chkOwnerType이 있으면 기존 값 유지
     */
    private void setCheckOwnerType(FacilityCheckHstryVO check) {
        /* 요청 객체 없음 */
        if (check == null) {
            return;
        }

        /* 기존 화면값 유지 */
        if (check.getChkOwnerType() != null && !check.getChkOwnerType().isBlank()) {
            return;
        }

        /* partnerNo 기준 점검 주체 판단 */
        if (check.getPartnerNo() == null || check.getPartnerNo().isBlank()) {
            check.setChkOwnerType("SELF");
        } else {
            check.setChkOwnerType("PARTNER");
        }
    }

    /**
     * 선택한 시설의 기존 점검 이력 목록 AJAX 조회
     *
     * 사용 위치
     * - 등록 화면에서 시설 선택 후 왼쪽 이력 목록 다시 그리기
     * - 수정 통합폼에서 시설 변경 시 이력 목록 갱신
     */
    @ResponseBody
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/history/list/{mgmtOfcNo}/{facilityNo}")
    public Map<String, Object> selectSameFacilityCheckList(
            @PathVariable String mgmtOfcNo,
            @PathVariable String facilityNo
    ) {
        Map<String, Object> result = new HashMap<>();

        try {
            /* 선택한 시설번호 기준 기존 점검 이력 조회 */
            List<FacilityCheckHstryVO> historyList =
                    facilityCheckService.selectSameFacilityCheckList(mgmtOfcNo, facilityNo);

            /* JSON 응답 데이터 */
            result.put("success", true);
            result.put("historyList", historyList);
        } catch (Exception e) {
            log.error("시설 점검 이력 목록 AJAX 조회 실패. mgmtOfcNo={}, facilityNo={}", mgmtOfcNo, facilityNo, e);

            result.put("success", false);
            result.put("message", "시설 점검 이력 조회 중 오류가 발생했습니다.");
        }

        return result;
    }

    /**
     * 시설 점검 이력 상세 AJAX 조회
     *
     * 사용 위치
     * - 상세 화면의 간략 이력 목록 클릭 시 모달 상세 표시
     * - 등록/수정 통합폼에서 이력 미리보기 또는 향후 AJAX 폼 전환 시 재사용 가능
     */
    @ResponseBody
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/detail-json/{mgmtOfcNo}/{facChkHstryNo}")
    public Map<String, Object> selectFacilityCheckDetailJson(
            @PathVariable String mgmtOfcNo,
            @PathVariable String facChkHstryNo
    ) {
        Map<String, Object> result = new HashMap<>();

        try {
            /* 점검 이력 단건 상세 조회 */
            FacilityCheckHstryVO check =
                    facilityCheckService.selectFacilityCheckDetail(mgmtOfcNo, facChkHstryNo);

            /* 점검 주체 화면값 세팅 */
            setCheckOwnerType(check);

            /* 조회 결과 응답 */
            result.put("success", check != null);
            result.put("check", check);

            if (check == null) {
                result.put("message", "조회된 시설 점검 이력이 없습니다.");
            }
        } catch (Exception e) {
            log.error("시설 점검 이력 상세 AJAX 조회 실패. mgmtOfcNo={}, facChkHstryNo={}", mgmtOfcNo, facChkHstryNo, e);

            result.put("success", false);
            result.put("message", "시설 점검 이력 상세 조회 중 오류가 발생했습니다.");
        }

        return result;
    }

    /**
     * 시설 선택 모달 서버 검색
     *
     * 검색 조건
     * - 시설유형
     * - 동
     * - 사용여부
     * - 위치
     * - 시설명/시설번호 통합검색
     */
    @ResponseBody
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/facility/search/{mgmtOfcNo}")
    public Map<String, Object> selectFacilitySearchList(
            @PathVariable String mgmtOfcNo,
            @RequestParam(required = false, defaultValue = "") String facilityTyCd,
            @RequestParam(required = false, defaultValue = "") String dongNo,
            @RequestParam(required = false, defaultValue = "") String facilityUseYn,
            @RequestParam(required = false, defaultValue = "") String facilityLocCn,
            @RequestParam(required = false, defaultValue = "") String facilitySearchWord
    ) {
        Map<String, Object> result = new HashMap<>();

        try {
            /* 시설 선택 모달 검색 조건 VO */
            FacilityCheckHstryVO searchVO = new FacilityCheckHstryVO();
            searchVO.setMgmtOfcNo(mgmtOfcNo);
            searchVO.setFacilityTyCd(facilityTyCd);
            searchVO.setDongNo(dongNo);
            searchVO.setFacilityUseYn(facilityUseYn);
            searchVO.setFacilityLocCn(facilityLocCn);
            searchVO.setFacilitySearchWord(facilitySearchWord);

            /* 조건 기준 시설 목록 조회 */
            List<FacilityCheckHstryVO> facilityList =
                    facilityCheckService.selectFacilitySearchList(searchVO);

            /* JSON 응답 데이터 */
            result.put("success", true);
            result.put("facilityList", facilityList);
        } catch (Exception e) {
            log.error("시설 선택 모달 검색 실패. mgmtOfcNo={}", mgmtOfcNo, e);

            result.put("success", false);
            result.put("message", "시설 목록 조회 중 오류가 발생했습니다.");
        }

        return result;
    }

    /**
     * 협력업체 선택 모달 서버 검색
     *
     * 검색 조건
     * - 업종
     * - 사용여부
     * - 담당자명
     * - 업체명/업체번호/사업자번호 통합검색
     */
    @ResponseBody
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/partner/search/{mgmtOfcNo}")
    public Map<String, Object> selectPartnerSearchList(
            @PathVariable String mgmtOfcNo,
            @RequestParam(required = false, defaultValue = "") String bizTyNm,
            @RequestParam(required = false, defaultValue = "") String partnerUseYn,
            @RequestParam(required = false, defaultValue = "") String picNm,
            @RequestParam(required = false, defaultValue = "") String partnerSearchWord
    ) {
        Map<String, Object> result = new HashMap<>();

        try {
            /* 협력업체 선택 모달 검색 조건 VO */
            FacilityCheckHstryVO searchVO = new FacilityCheckHstryVO();
            searchVO.setMgmtOfcNo(mgmtOfcNo);
            searchVO.setBizTyNm(bizTyNm);
            searchVO.setPartnerUseYn(partnerUseYn);
            searchVO.setPicNm(picNm);
            searchVO.setPartnerSearchWord(partnerSearchWord);

            /* 조건 기준 협력업체 목록 조회 */
            List<FacilityCheckHstryVO> partnerList =
                    facilityCheckService.selectPartnerSearchList(searchVO);

            /* JSON 응답 데이터 */
            result.put("success", true);
            result.put("partnerList", partnerList);
        } catch (Exception e) {
            log.error("협력업체 선택 모달 검색 실패. mgmtOfcNo={}", mgmtOfcNo, e);

            result.put("success", false);
            result.put("message", "협력업체 목록 조회 중 오류가 발생했습니다.");
        }

        return result;
    }

    /**
     * 시설 + 파트너 기준 계약 목록 AJAX 조회
     *
     * 사용 위치
     * - 등록/수정 폼에서 시설 선택 후 협력업체를 선택했을 때 계약 select 동적 표시
     *
     * 조회 기준
     * - 관리사무소 번호
     * - 선택한 시설번호
     * - 선택한 협력업체번호
     * - 진행중 계약 상태 ACTIVE
     */
    @ResponseBody
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/partner/contracts/{mgmtOfcNo}/{facilityNo}/{partnerNo}")
    public Map<String, Object> selectPartnerContractList(
            @PathVariable String mgmtOfcNo,
            @PathVariable String facilityNo,
            @PathVariable String partnerNo
    ) {
        Map<String, Object> result = new HashMap<>();

        try {
            /* 선택한 시설 + 선택한 협력업체 기준 ACTIVE 계약 조회 */
            List<Map<String, Object>> contractList =
                    facilityCheckService.selectPartnerContractList(mgmtOfcNo, facilityNo, partnerNo);

            result.put("success", true);
            result.put("contractList", contractList);
        } catch (Exception e) {
            log.error(
                    "시설+파트너 계약 목록 AJAX 조회 실패. mgmtOfcNo={}, facilityNo={}, partnerNo={}",
                    mgmtOfcNo,
                    facilityNo,
                    partnerNo,
                    e
            );

            result.put("success", false);
            result.put("message", "계약 목록 조회 중 오류가 발생했습니다.");
        }

        return result;
    }

    /**
     * 시설 선택 기준 최신 유지보수성 계약 목록 AJAX 조회
     *
     * 사용 위치
     * - 등록/수정 폼에서 시설을 선택했을 때 협력업체/계약 자동 세팅
     *
     * 조회 기준
     * - FACILITY_CONTRACT_TARGET 연결 기준
     * - 시설 대상 계약
     * - 설치공사/검침 계약 제외
     */
    @ResponseBody
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/facility/recommended-contracts/{mgmtOfcNo}/{facilityNo}")
    public Map<String, Object> selectRecommendedFacilityContractList(
            @PathVariable String mgmtOfcNo,
            @PathVariable String facilityNo
    ) {
        Map<String, Object> result = new HashMap<>();

        try {
            /* ***# 시설 기준 유지보수성 계약 목록 조회 */
            List<Map<String, Object>> contractList =
                    facilityCheckService.selectRecommendedFacilityContractList(mgmtOfcNo, facilityNo);

            result.put("success", true);
            result.put("contractList", contractList);
        } catch (Exception e) {
            log.error(
                    "시설 기준 유지보수성 계약 목록 AJAX 조회 실패. mgmtOfcNo={}, facilityNo={}",
                    mgmtOfcNo,
                    facilityNo,
                    e
            );

            result.put("success", false);
            result.put("message", "시설 기준 계약 목록 조회 중 오류가 발생했습니다.");
        }

        return result;
    }
}
