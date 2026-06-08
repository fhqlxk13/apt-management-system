package kr.or.ddit.domain.apt.mgmtOffice.partner.controller;

import kr.or.ddit.common.model.PaginationInfoVO;
import kr.or.ddit.domain.apt.mgmtOffice.common.service.IManagerModelService;
import kr.or.ddit.domain.apt.mgmtOffice.partner.service.IPartnerService;
import kr.or.ddit.domain.apt.mgmtOffice.partner.vo.PartnerSearchVO;
import kr.or.ddit.domain.apt.mgmtOffice.partner.vo.PartnerStatVO;
import kr.or.ddit.domain.apt.mgmtOffice.partner.vo.PartnerVO;
import kr.or.ddit.domain.member.vo.CustomUser;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

/**
 * 협력업체 Controller
 *
 * 역할
 * - 협력업체 목록 화면 이동
 * - 협력업체 등록 처리
 * - 협력업체 수정 처리
 * - 협력업체 비활성화 처리
 *
 * 주소 기준
 * - 목록       : GET  /manager/facility/partner/list/{mgmtOfcNo}
 * - 등록 처리  : POST /manager/facility/partner/insert/{mgmtOfcNo}
 * - 수정 처리  : POST /manager/facility/partner/update/{mgmtOfcNo}/{partnerNo}
 * - 비활성 처리: POST /manager/facility/partner/deactivate/{mgmtOfcNo}
 */
@Slf4j
@Controller
@RequiredArgsConstructor
@PreAuthorize("hasRole('MNGR')")
@RequestMapping("/manager/facility/partner")
public class PartnerController {

    /** 협력업체 Service */
    private final IPartnerService partnerService;

    /** 관리사무소 공통 모델 Service */
    private final IManagerModelService managerModelService;

    /**
     * 협력업체 목록 화면
     *
     * 처리 내용
     * - 관리사무소 공통 모델 세팅
     * - 검색 조건 세팅
     * - 페이지 계산
     * - 협력업체 목록 조회
     * - 현황 카드 조회
     * - 업종 필터 목록 조회
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/list/{mgmtOfcNo}")
    public String list(
            @PathVariable String mgmtOfcNo,
            @ModelAttribute PartnerSearchVO searchVO,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {
        /* 관리사무소 공통 화면 모델 세팅 */
        managerModelService.addManagerViewModel(model, customUser, mgmtOfcNo);

        /* 관리사무소 번호 세팅 */
        searchVO.setMgmtOfcNo(mgmtOfcNo);

        /* 관리사무소 기준 단지번호 조회 */
        String aptCmplexNo = partnerService.selectAptCmplexNoByMgmtOfcNo(mgmtOfcNo);
        searchVO.setAptCmplexNo(aptCmplexNo);

        /* 현재 페이지 기본값 보정 */
        if (searchVO.getPage() < 1) {
            searchVO.setPage(1);
        }

        /* 공통 페이지네이션 객체 생성 */
        PaginationInfoVO<PartnerSearchVO> pagingVO = new PaginationInfoVO<>(10, 5);
        pagingVO.setSearchVO(searchVO);
        pagingVO.setSearchWord(searchVO.getSearchWord());

        /* 전체 건수 조회 */
        int totalRecord = partnerService.selectPartnerCount(searchVO);
        pagingVO.setTotalRecord(totalRecord);

        /* 현재 페이지 계산 */
        pagingVO.setCurrentPage(searchVO.getPage());

        /* row 범위 세팅 */
        searchVO.setStartRow(pagingVO.getStartRow());
        searchVO.setEndRow(pagingVO.getEndRow());

        /* 협력업체 목록 조회 */
        List<PartnerVO> partnerList = partnerService.selectPartnerList(searchVO);

        /* 협력업체 현황 조회 */
        PartnerStatVO partnerStat = partnerService.selectPartnerStat(searchVO);
        if (partnerStat == null) {
            partnerStat = new PartnerStatVO();
        }

        /* 업종 필터 목록 조회 */
        List<String> bizTypeList = partnerService.selectBizTypeList(aptCmplexNo);

        /* 화면 모델 세팅 */
        model.addAttribute("mgmtOfcNo", mgmtOfcNo);
        model.addAttribute("aptCmplexNo", aptCmplexNo);
        model.addAttribute("partnerList", partnerList);
        model.addAttribute("partnerStat", partnerStat);
        model.addAttribute("bizTypeList", bizTypeList);
        model.addAttribute("pageInfo", pagingVO);
        model.addAttribute("searchVO", searchVO);
        model.addAttribute("searchWord", searchVO.getSearchWord());

        return "apt/mgmtOffice/partner/mngr_partner_list";
    }

    /**
     * 협력업체 등록 처리
     *
     * 처리 내용
     * - 관리자 CRUD 권한 확인
     * - 관리사무소 기준 단지번호 세팅
     * - PARTNER 등록
     * - 목록 화면 이동
     */
    @PreAuthorize("@authService.canMgmtCrud(principal, #mgmtOfcNo)")
    @PostMapping("/insert/{mgmtOfcNo}")
    public String insert(
            @PathVariable String mgmtOfcNo,
            @ModelAttribute PartnerVO partnerVO,
            @RequestParam(required = false, defaultValue = "") String returnType,
            RedirectAttributes redirectAttributes
    ) {
        /* 관리사무소 기준 단지번호 조회 */
        String aptCmplexNo = partnerService.selectAptCmplexNoByMgmtOfcNo(mgmtOfcNo);

        /* 단지번호 보정 */
        partnerVO.setAptCmplexNo(aptCmplexNo);

        /* 협력업체 등록 */
        partnerService.insertPartner(partnerVO);

        /* 완료 메시지 */
        redirectAttributes.addFlashAttribute("message", "협력업체가 등록되었습니다.");

        /*
         * 계약 등록/수정 폼에서 신규 협력업체 등록 모달을 통해 들어온 경우
         * - returnUrl을 직접 받지 않고 returnType 값만 허용.
         * - 허용된 내부 경로로만 redirect하여 임의 경로 이동 제한.
         */
        if ("contractForm".equals(returnType)) {
            redirectAttributes.addFlashAttribute("partnerMessage", "협력업체가 등록되었습니다. 목록에서 새 업체를 선택하세요.");
            return "redirect:/manager/facility/contract/form/" + mgmtOfcNo;
        }

        return "redirect:/manager/facility/partner/list/" + mgmtOfcNo;
    }

    /**
     * 협력업체 수정 처리
     *
     * 처리 내용
     * - 관리자 CRUD 권한 확인
     * - 업체번호 세팅
     * - PARTNER 기본정보 수정
     * - 목록 화면 이동
     */
    @PreAuthorize("@authService.canMgmtCrud(principal, #mgmtOfcNo)")
    @PostMapping("/update/{mgmtOfcNo}/{partnerNo}")
    public String update(
            @PathVariable String mgmtOfcNo,
            @PathVariable String partnerNo,
            @ModelAttribute PartnerVO partnerVO,
            RedirectAttributes redirectAttributes
    ) {
        /* 수정 기준 업체번호 보정 */
        partnerVO.setPartnerNo(partnerNo);

        /* 협력업체 수정 */
        partnerService.updatePartner(partnerVO);

        /* 완료 메시지 */
        redirectAttributes.addFlashAttribute("message", "협력업체가 수정되었습니다.");

        return "redirect:/manager/facility/partner/list/" + mgmtOfcNo;
    }

    /**
     * 협력업체 비활성화 처리
     *
     * 처리 내용
     * - 관리자 CRUD 권한 확인
     * - PARTNER.USE_YN = 'N' 변경
     * - 계약/점검/검침 이력 미수정
     */
    @PreAuthorize("@authService.canMgmtCrud(principal, #mgmtOfcNo)")
    @PostMapping("/deactivate/{mgmtOfcNo}")
    public String deactivate(
            @PathVariable String mgmtOfcNo,
            @ModelAttribute PartnerVO partnerVO,
            RedirectAttributes redirectAttributes
    ) {
        /* 관리사무소 기준 단지번호 조회 */
        String aptCmplexNo = partnerService.selectAptCmplexNoByMgmtOfcNo(mgmtOfcNo);

        /* 협력업체 비활성화 */
        partnerService.deactivatePartner(partnerVO.getPartnerNo(), aptCmplexNo);

        /* 완료 메시지 */
        redirectAttributes.addFlashAttribute("message", "협력업체가 비활성화되었습니다.");

        return "redirect:/manager/facility/partner/list/" + mgmtOfcNo;
    }

    /**
     * 협력업체 활성화 처리
     *
     * 처리 내용
     * - 비활성 상태의 협력업체를 다시 사용 가능 상태로 변경
     * - PARTNER.USE_YN = 'Y'
     * - 계약/점검/검침 이력은 수정하지 않음
     */
    @PreAuthorize("@authService.canMgmtCrud(principal, #mgmtOfcNo)")
    @PostMapping("/activate/{mgmtOfcNo}")
    public String activate(
            @PathVariable String mgmtOfcNo,
            @ModelAttribute PartnerVO partnerVO,
            RedirectAttributes redirectAttributes
    ) {
        /* 관리사무소 기준 단지번호 조회 */
        String aptCmplexNo = partnerService.selectAptCmplexNoByMgmtOfcNo(mgmtOfcNo);

        /* 협력업체 활성화 처리 */
        partnerService.activatePartner(partnerVO.getPartnerNo(), aptCmplexNo);

        /* 완료 메시지 */
        redirectAttributes.addFlashAttribute("message", "협력업체가 활성화되었습니다.");

        /* 협력업체 목록으로 이동 */
        return "redirect:/manager/facility/partner/list/" + mgmtOfcNo;
    }
}
