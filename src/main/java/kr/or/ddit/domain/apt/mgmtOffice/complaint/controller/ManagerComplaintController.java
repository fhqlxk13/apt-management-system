package kr.or.ddit.domain.apt.mgmtOffice.complaint.controller;

import kr.or.ddit.common.model.PaginationInfoVO;
import kr.or.ddit.domain.apt.main.service.IAptComplexService;
import kr.or.ddit.domain.apt.main.vo.AptComplexVO;
import kr.or.ddit.domain.apt.mgmtOffice.complaint.dto.ManagerComplaintDTO;
import kr.or.ddit.domain.apt.mgmtOffice.complaint.service.ManagerComplaintService;
import kr.or.ddit.domain.member.vo.CustomUser;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.eclipse.tags.shaded.org.apache.xpath.operations.Mod;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/manager/complex")
@Slf4j
@RequiredArgsConstructor
public class ManagerComplaintController {

    private final IAptComplexService aptComplexService;

    private final ManagerComplaintService managerComplaintService;

    /**
     * 관리사무소 민원 접수 현황 민원 목록
     * 검색 필터링 및 페이징 처리
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/complaintList/{mgmtOfcNo}")
    public ResponseEntity<Map<String, Object>> selectComplaintList(
            @PathVariable String mgmtOfcNo,
            @AuthenticationPrincipal CustomUser principal,
            @RequestParam(defaultValue = "1") int curPage,
            @RequestParam(required = false) String cvplTyCd,
            @RequestParam(required = false) String cvplSttsCd,
            @RequestParam(required = false, defaultValue = "") String keyword,
            @RequestParam(required = false) String searchDateFrom,  // 추가
            @RequestParam(required = false) String searchDateTo     // 추가
    ) {
        Map<String, Object> result = new HashMap<>();

        // 단지번호 조회
        AptComplexVO aptComplexVO = aptComplexService.selectMgmtOfcNoAptComplex(mgmtOfcNo);
        String aptCmplexNo = aptComplexVO.getAptCmplexNo();

        // 페이징 + 검색조건 세팅
        PaginationInfoVO<ManagerComplaintDTO> page = new PaginationInfoVO<>(10, 5);

        ManagerComplaintDTO searchDTO = new ManagerComplaintDTO();
        searchDTO.setAptCmplexNo(aptCmplexNo);
        searchDTO.setCvplTyCd(cvplTyCd);
        searchDTO.setCvplSttsCd(cvplSttsCd);
        searchDTO.setSearchDateFrom(searchDateFrom); // 추가
        searchDTO.setSearchDateTo(searchDateTo);     // 추가

        page.setSearchVO(searchDTO);
        page.setSearchWord(keyword);
        page.setCurrentPage(curPage);

        // 건수 조회
        int totalRecord = managerComplaintService.selectComplaintCount(page);
        page.setTotalRecord(totalRecord);
        page.setCurrentPage(curPage); // totalRecord 세팅 후 다시 세팅 (startRow/endRow 재계산)

        // 목록 조회
        List<ManagerComplaintDTO> list = managerComplaintService.selectComplaintList(page);
        page.setDataList(list);

        result.put("list", list);
        result.put("page", page);

        return ResponseEntity.ok(result);
    }

    /**
     * 민원 처리 상태 update
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @PostMapping("/updateComplaint/{mgmtOfcNo}")
    public ResponseEntity<Map<String, Object>> updateComplaint(
            @PathVariable String mgmtOfcNo,
            @RequestBody ManagerComplaintDTO dto,
            @AuthenticationPrincipal CustomUser principal
    ) {
        Map<String, Object> result = new HashMap<>();
        try {
            if (principal != null && principal.getMember() != null) {
                dto.setPicId(principal.getMember().getUserNo());
            }
            managerComplaintService.updateComplaint(dto);
            result.put("success", true);
        } catch (Exception e) {
            log.error("[updateComplaint] 오류: {}", e.getMessage());
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return ResponseEntity.ok(result);
    }

    /**
     * 민원 상세 조회
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/mngrList/{mgmtOfcNo}")
    public ResponseEntity<List<ManagerComplaintDTO>> selectMngrList(
            @PathVariable String mgmtOfcNo
    ) {
        return ResponseEntity.ok(managerComplaintService.selectMngrList(mgmtOfcNo));
    }

    /**
     * 증빙서류 조회
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/cvplFileList/{mgmtOfcNo}")
    public ResponseEntity<List<Map<String, Object>>> selectCvplFileList(@PathVariable String mgmtOfcNo,
                                                                        @RequestParam String cvplFileNo,
                                                                        @AuthenticationPrincipal CustomUser principal,
                                                                        Model model){
        model.addAttribute("mgmtOfcNo", mgmtOfcNo);
        model.addAttribute("currentUserId", principal.getMember().getUserId());
        return ResponseEntity.ok(managerComplaintService.selectCvplFileList(cvplFileNo));
    }


}



