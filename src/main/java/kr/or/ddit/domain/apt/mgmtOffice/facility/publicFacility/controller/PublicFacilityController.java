package kr.or.ddit.domain.apt.mgmtOffice.facility.publicFacility.controller;

import kr.or.ddit.common.file.vo.AttachFileVO;
import kr.or.ddit.domain.apt.mgmtOffice.common.service.IManagerModelService;
import kr.or.ddit.domain.apt.mgmtOffice.contract.service.IFacilityContractService;
import kr.or.ddit.domain.apt.mgmtOffice.facility.publicFacility.dto.PublicFacilityFormDTO;
import kr.or.ddit.domain.apt.mgmtOffice.facility.service.IFacilityService;
import kr.or.ddit.domain.apt.mgmtOffice.facility.publicFacility.service.IPublicFacilityService;
import kr.or.ddit.domain.apt.mgmtOffice.facility.publicFacility.service.IPublicItemService;
import kr.or.ddit.domain.apt.mgmtOffice.facility.publicFacility.vo.PublicFacilityVO;
import kr.or.ddit.domain.apt.mgmtOffice.facility.publicFacility.vo.PublicItemVO;
import kr.or.ddit.domain.apt.mgmtOffice.facility.vo.FacilityVO;
import kr.or.ddit.domain.member.vo.CustomUser;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Controller
@PreAuthorize("hasRole('MNGR')")
@RequestMapping("/manager/publicFacility")
public class PublicFacilityController {

    @Autowired
    private IPublicFacilityService publicFacilityService;

    @Autowired
    private IFacilityService facilityService;

    @Autowired
    private IPublicItemService publicItemService;

    @Autowired
    private IManagerModelService managerModelService;

    @Autowired
    private IFacilityContractService facilityContractService; // ***# 설치계약 목록 조회 서비스


    @PreAuthorize("@authService.canMgmtCrud(principal, #mgmtOfcNo)")
    @GetMapping("/register/{mgmtOfcNo}")
    public String register(
            @PathVariable String mgmtOfcNo,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {
        managerModelService.addManagerViewModel(model, customUser, mgmtOfcNo);
        model.addAttribute("mgmtOfcNo", mgmtOfcNo);
        List<FacilityVO> dongList = facilityService.selectDongList(mgmtOfcNo);
        model.addAttribute("dongList", dongList == null ? Collections.emptyList() : dongList);
        model.addAttribute("publicFacilityTypeList", facilityService.selectPublicFacilityTypeList());
        List<FacilityVO> facilityCandidateList = publicFacilityService.selectFacilityCandidateList(mgmtOfcNo);
        model.addAttribute("facilityCandidateList", facilityCandidateList);
        /* ***# 연결 가능 설치계약 목록 모델 */
        model.addAttribute("installContractList", facilityContractService.selectAvailableInstallContractList(mgmtOfcNo));
        return "apt/mgmtOffice/facility/publicFacility/publicFacilityRegister";
    }

    /**
     * 공용시설/자원 목록 데이터 조회
     * - viewType=PUBLIC_FACILITY : 공용시설 목록 (기존)
     * - viewType=PUBLIC_ITEM     : 전체 자원 목록 (신규)
     */
    @ResponseBody
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/grid-list/{mgmtOfcNo}")
    public Map<String, Object> gridList(
            @PathVariable String mgmtOfcNo,
            @RequestParam(required = false, defaultValue = "") String keyword,
            @RequestParam(required = false, defaultValue = "") String facilityTyCd,
            @RequestParam(required = false, defaultValue = "") String dongNo,
            @RequestParam(required = false, defaultValue = "") String rsvYn,
            @RequestParam(required = false, defaultValue = "") String operStatus,
            @RequestParam(required = false, defaultValue = "PUBLIC_FACILITY") String viewType
    ) {
        Map<String, Object> result = new HashMap<>();

        // PUBLIC_ITEM 탭 - 전체 자원 목록 반환
        if ("PUBLIC_ITEM".equals(viewType)) {
            try {
                List<PublicItemVO> itemList = publicItemService.selectPublicItemListAll(mgmtOfcNo);
                result.put("success", true);
                result.put("list", itemList == null ? Collections.emptyList() : itemList);
                result.put("totalCount", itemList == null ? 0 : itemList.size());
            } catch (Exception e) {
                log.error("전체 자원 목록 조회 중 오류", e);
                result.put("success", false);
                result.put("list", Collections.emptyList());
                result.put("totalCount", 0);
            }
            return result;
        }

        // PUBLIC_FACILITY 탭 - 공용시설 목록 반환 (기존 로직 그대로)
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("mgmtOfcNo", mgmtOfcNo);
        paramMap.put("keyword", keyword);
        paramMap.put("facilityTyCd", facilityTyCd);
        paramMap.put("dongNo", dongNo);
        paramMap.put("rsvYn", rsvYn);
        paramMap.put("operStatus", operStatus);

        List<PublicFacilityVO> publicFacilityList = publicFacilityService.selectPublicFacilityList(paramMap);

        result.put("success", true);
        result.put("list", publicFacilityList);
        result.put("totalCount", publicFacilityList.size());

        return result;
    }

    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/detail-page/{mgmtOfcNo}/{cmnFacilityNo}")
    public String detailPage(
            @PathVariable String mgmtOfcNo,
            @PathVariable String cmnFacilityNo,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {
        managerModelService.addManagerViewModel(model, customUser, mgmtOfcNo);

        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("mgmtOfcNo", mgmtOfcNo);
        paramMap.put("cmnFacilityNo", cmnFacilityNo);

        PublicFacilityVO detail = publicFacilityService.selectPublicFacilityDetail(paramMap);

        if (detail == null) {
            return "redirect:/manager/publicFacility/list/" + mgmtOfcNo;
        }

        List<AttachFileVO> fileList = detail.getFileGroupNo() == null
                ? Collections.emptyList()
                : facilityService.selectFacilityFileList(detail.getFileGroupNo());
        List<PublicItemVO> itemList = publicItemService.selectPublicItemList(cmnFacilityNo);

        model.addAttribute("mgmtOfcNo", mgmtOfcNo);
        model.addAttribute("cmnFacilityNo", cmnFacilityNo);
        model.addAttribute("detail", detail);
        model.addAttribute("fileList", fileList == null ? Collections.emptyList() : fileList);
        model.addAttribute("itemList", itemList == null ? Collections.emptyList() : itemList);

        return "apt/mgmtOffice/facility/publicFacility/publicFacilityDetail";
    }

    @PreAuthorize("@authService.canMgmtCrud(principal, #mgmtOfcNo)")
    @GetMapping("/update-page/{mgmtOfcNo}/{cmnFacilityNo}")
    public String updatePage(
            @PathVariable String mgmtOfcNo,
            @PathVariable String cmnFacilityNo,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {
        managerModelService.addManagerViewModel(model, customUser, mgmtOfcNo);

        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("mgmtOfcNo", mgmtOfcNo);
        paramMap.put("cmnFacilityNo", cmnFacilityNo);

        PublicFacilityVO detail = publicFacilityService.selectPublicFacilityDetail(paramMap);

        if (detail == null) {
            return "redirect:/manager/publicFacility/list/" + mgmtOfcNo;
        }

        List<AttachFileVO> fileList = detail.getFileGroupNo() == null
                ? Collections.emptyList()
                : facilityService.selectFacilityFileList(detail.getFileGroupNo());

        List<FacilityVO> dongList = facilityService.selectDongList(mgmtOfcNo);
        List<PublicItemVO> itemList = publicItemService.selectPublicItemList(cmnFacilityNo);

        model.addAttribute("mgmtOfcNo", mgmtOfcNo);
        model.addAttribute("cmnFacilityNo", cmnFacilityNo);
        model.addAttribute("detail", detail);
        model.addAttribute("fileList", fileList == null ? Collections.emptyList() : fileList);
        model.addAttribute("dongList", dongList == null ? Collections.emptyList() : dongList);
        model.addAttribute("itemList", itemList == null ? Collections.emptyList() : itemList);

        return "apt/mgmtOffice/facility/publicFacility/publicFacilityUpdate";
    }

    @PreAuthorize("@authService.canMgmtCrud(principal, #mgmtOfcNo)")
    @ResponseBody
    @PostMapping("/insert/{mgmtOfcNo}")
    public Map<String, Object> insert(
            @PathVariable String mgmtOfcNo,
            PublicFacilityFormDTO formDTO,
            @RequestParam(required = false) List<MultipartFile> facilityFiles,
            @AuthenticationPrincipal CustomUser customUser
    ) {
        Map<String, Object> result = new HashMap<>();

        try {
            //** AJAX 등록 응답 형식 통일
            formDTO.setMgmtOfcNo(mgmtOfcNo);
            String userNo = customUser.getMember().getUserNo(); // 업로드 사용자 번호
            String cmnFacilityNo = publicFacilityService.insertPublicFacility(formDTO, facilityFiles, userNo);
            result.put("success", true);
            result.put("message", "편의시설 운영정보가 등록되었습니다.");
            result.put("cmnFacilityNo", cmnFacilityNo);
        } catch (Exception e) {
            log.error("편의시설 운영정보 등록 오류", e);
            result.put("success", false);
            result.put("message", e.getMessage() == null ? "편의시설 운영정보 등록 중 오류가 발생했습니다." : e.getMessage());
        }

        return result;
    }

    @PreAuthorize("@authService.canMgmtCrud(principal, #mgmtOfcNo)")
    @ResponseBody
    @PostMapping("/update/{mgmtOfcNo}")
    public Map<String, Object> update(
            @PathVariable String mgmtOfcNo,
            PublicFacilityFormDTO formDTO,
            @RequestParam(required = false) List<MultipartFile> facilityFiles,
            @AuthenticationPrincipal CustomUser customUser
    ) {
        Map<String, Object> result = new HashMap<>();

        try {
            formDTO.setMgmtOfcNo(mgmtOfcNo);
            String userNo = customUser.getMember().getUserNo(); // 업로드 사용자 번호
            publicFacilityService.updatePublicFacility(formDTO, facilityFiles, userNo);
            result.put("success", true);
            result.put("message", "편의시설 운영정보가 저장되었습니다.");
            result.put("cmnFacilityNo", formDTO.getCmnFacilityNo());
        } catch (Exception e) {
            log.error("편의시설 운영정보 저장 오류", e);
            result.put("success", false);
            result.put("message", e.getMessage() == null ? "편의시설 운영정보 저장 중 오류가 발생했습니다." : e.getMessage());
        }

        return result;
    }

    @ResponseBody
    @PreAuthorize("@authService.canMgmtCrud(principal, #mgmtOfcNo)")
    @PostMapping("/delete/{mgmtOfcNo}")
    public Map<String, Object> delete(
            @PathVariable String mgmtOfcNo,
            @RequestBody Map<String, String> body
    ) {
        Map<String, Object> result = new HashMap<>();

        String cmnFacilityNo = body == null ? null : body.get("cmnFacilityNo");

        if (cmnFacilityNo == null || cmnFacilityNo.trim().isEmpty()) {
            result.put("success", false);
            result.put("message", "삭제할 편의시설 번호가 없습니다.");
            return result;
        }

        try {
            Map<String, Object> paramMap = new HashMap<>();
            paramMap.put("mgmtOfcNo", mgmtOfcNo);
            paramMap.put("cmnFacilityNo", cmnFacilityNo);

            publicFacilityService.deletePublicFacility(paramMap);

            result.put("success", true);
            result.put("message", "공용시설이 삭제되었습니다.");
            return result;

        } catch (Exception e) {
            result.put("success", false);
            result.put("message", " 이용 이력, 자원 정보(연결 데이터)가 있어 삭제할 수 없습니다.");
            return result;
        }
    }

    @ResponseBody
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/dong-option/{mgmtOfcNo}")
    public Map<String, Object> selectDongOptionList(@PathVariable String mgmtOfcNo) {
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("list", publicFacilityService.selectPublicFacilityDongOptionList(mgmtOfcNo));
        return result;
    }

    @ResponseBody
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/location-option/{mgmtOfcNo}")
    public Map<String, Object> selectLocationOptionList(
            @PathVariable String mgmtOfcNo,
            @RequestParam(required = false) String dongNo
    ) {
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("mgmtOfcNo", mgmtOfcNo);
        paramMap.put("dongNo", dongNo);

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("list", publicFacilityService.selectPublicFacilityLocationOptionList(paramMap));
        return result;
    }

    @ResponseBody
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/name-suggest/{mgmtOfcNo}")
    public Map<String, Object> selectNameSuggestList(
            @PathVariable String mgmtOfcNo,
            @RequestParam(required = false) String keyword
    ) {
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("mgmtOfcNo", mgmtOfcNo);
        paramMap.put("keyword", keyword);

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("list", publicFacilityService.selectPublicFacilityNameSuggestList(paramMap));
        return result;
    }
}
