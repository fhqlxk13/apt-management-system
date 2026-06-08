package kr.or.ddit.domain.apt.complaint.controller;

import kr.or.ddit.common.enums.ServiceResult;
import kr.or.ddit.common.file.service.IAttachFileService;
import kr.or.ddit.common.file.vo.AttachFileVO;
import kr.or.ddit.common.model.PaginationInfoVO;
import kr.or.ddit.domain.apt.complaint.service.ICvplService;
import kr.or.ddit.domain.apt.complaint.vo.CvplVO;
import kr.or.ddit.domain.apt.main.dto.AptMainPageDTO;
import kr.or.ddit.domain.apt.main.service.IAptComplexService;
import kr.or.ddit.domain.member.resident.vo.MyAptVO;
import kr.or.ddit.domain.member.resident.vo.ResidentVO;
import kr.or.ddit.domain.member.vo.CustomUser;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author 이용로
 */
@Slf4j
@Controller
@PreAuthorize("hasRole('RESIDENT')")
@RequestMapping("/apt/complaint")
public class CvplController {

    @Autowired
    private IAptComplexService aptComplexService;

    @Autowired
    private ICvplService cvplService;

    @Autowired
    private IAttachFileService attachFileService;

    @Autowired
    private kr.or.ddit.domain.apt.complaint.mapper.ICvplMapper cvplMapper;

    /**
     * 민원신청 페이지
     *
     * @author 이용로
     */
    @PreAuthorize("@authService.isResidentOnly(principal, #aptCmplexNo)")
    @GetMapping("/apply.do/{aptCmplexNo}")
    public String complaintApplyForm(
            @AuthenticationPrincipal CustomUser customUser
            , @PathVariable String aptCmplexNo
            , @RequestParam(defaultValue = "1") int curPage
            , Model model) {
        log.info("complaintApplyForm() 실행");
        ResidentVO residentVO = (ResidentVO) customUser.getMember();

        PaginationInfoVO<CvplVO> page = new PaginationInfoVO<>(11, 5);

        CvplVO searchVO = new CvplVO();
        searchVO.setAptCmplexNo(aptCmplexNo);
        searchVO.setUserNo(residentVO.getUserNo());
        page.setSearchVO(searchVO);

        int totalRecord = cvplService.selectCvplCount(page.getSearchVO());
        page.setTotalRecord(totalRecord);
        page.setCurrentPage(curPage);

        List<CvplVO> cvplList = cvplService.selectMyCvplList(page);
        page.setDataList(cvplList);

        model.addAttribute("page", page);

        AptMainPageDTO.ResponseDto aptCommonDTO = aptComplexService.selectAptCommonDTO(aptCmplexNo);
        model.addAttribute("aptInfo", aptCommonDTO);
        return "apt/complaint/complaint_apply";
    }

    /**
     * 민원 신청 비동기
     *
     * @author 이용로
     */
    @PreAuthorize("@authService.isResidentOnly(principal, #aptCmplexNo)")
    @ResponseBody
    @PostMapping(value = "/apply/{aptCmplexNo}")
    public ResponseEntity<Map<String, String>> complaintApply(
            @AuthenticationPrincipal CustomUser customUser
            , @PathVariable String aptCmplexNo
            , @RequestParam(required = false) MultipartFile[] attachFiles
            , CvplVO cvplVO) {
        log.info("complaintApply() 실행");

        ResidentVO resident = (ResidentVO) customUser.getMember();

        for (MyAptVO apt : resident.getMyAptList()) {
            if (apt.getAptCmplexNo().equals(aptCmplexNo)) {
                cvplVO.setHoNo(apt.getHoNo());
            }
        }
        cvplVO.setUserNo(resident.getUserNo());
        cvplVO.setAptCmplexNo(aptCmplexNo);

        Map<String, String> resp = new HashMap<>();

        List<MultipartFile> validFileList = new ArrayList<>();
        if (attachFiles != null) {
            for (MultipartFile file : attachFiles) {
                if (file != null && !file.isEmpty()) {
                    validFileList.add(file);
                }
            }
        }
        MultipartFile[] finalFiles = validFileList.isEmpty() ? null : validFileList.toArray(new MultipartFile[0]);

        try {
            ServiceResult result = cvplService.applyCvpl(cvplVO, finalFiles);

            if (ServiceResult.OK.equals(result)) {
                resp.put("message", "민원이 접수되었습니다.");
                return new ResponseEntity<>(resp, HttpStatus.OK);
            } else {
                resp.put("message", "민원 접수에 실패했습니다.");
                return new ResponseEntity<>(resp, HttpStatus.BAD_REQUEST);
            }
        } catch (Exception e) {
            resp.put("message", "서버에러");
            return new ResponseEntity<>(resp, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    /**
     * 비동기 민원 내역 리스트 불러오기 (내 민원 및 신청 페이지용)
     */
    @PreAuthorize("@authService.hasAccess(principal, #aptCmplexNo)")
    @ResponseBody
    @GetMapping(value = "/ajax/load-cvpl/{aptCmplexNo}")
    public ResponseEntity<List<CvplVO>> ajaxLoadCvpl(
            @AuthenticationPrincipal CustomUser customUser
            , @PathVariable String aptCmplexNo
            , Model model) {
        PaginationInfoVO<CvplVO> page = new PaginationInfoVO<>(11, 5);
        ResidentVO resident = (ResidentVO) customUser.getMember();

        CvplVO searchVO = new CvplVO();
        searchVO.setAptCmplexNo(aptCmplexNo);
        searchVO.setUserNo(resident.getUserNo());
        page.setSearchVO(searchVO);

        int totalRecord = cvplService.selectCvplCount(page.getSearchVO());
        page.setTotalRecord(totalRecord);
        page.setCurrentPage(1);

        List<CvplVO> cvplList = cvplService.selectMyCvplList(page);
        page.setDataList(cvplList);

        model.addAttribute("page", page);

        return ResponseEntity.ok(cvplList);
    }

    /**
     * 단지 민원 내역 리스트 페이지 (페이징)
     */
    /*@PreAuthorize("@authService.hasAccess(principal, #aptCmplexNo)")
    @GetMapping("/list/{aptCmplexNo}")
    public String cvplList(
            @AuthenticationPrincipal CustomUser customUser
            , @PathVariable String aptCmplexNo
            , @RequestParam(defaultValue = "1") int curPage
            , Model model) {

        PaginationInfoVO<CvplVO> page = new PaginationInfoVO<>(10, 5);

        CvplVO searchVO = new CvplVO();
        searchVO.setAptCmplexNo(aptCmplexNo);
        page.setSearchVO(searchVO);

        int totalRecord = cvplService.selectCvplCountByAptCmplexNo(searchVO);
        page.setTotalRecord(totalRecord);
        page.setCurrentPage(curPage);

        List<CvplVO> cvplList = cvplService.selectCvplListAllByAptCmplexNoPaged(page);
        page.setDataList(cvplList);

        model.addAttribute("page", page);
        model.addAttribute("cvplList", cvplList);

        AptMainPageDTO.ResponseDto aptCommonDTO = aptComplexService.selectAptCommonDTO(aptCmplexNo);
        model.addAttribute("aptInfo", aptCommonDTO);

        return "apt/complaint/complaint_list";
    }*/

    /**
     * 민원 상세 조회 (같은 단지 주민이면 접근 가능)
     */
    @PreAuthorize("@authService.hasAccess(principal, #aptCmplexNo)")
    @ResponseBody
    @GetMapping("/detail/{aptCmplexNo}/{cvplNo}")
    public ResponseEntity<Map<String, Object>> cvplDetail(
            @AuthenticationPrincipal CustomUser customUser
            , @PathVariable String cvplNo
            , @PathVariable String aptCmplexNo) {
        log.info("cvplDetail() 실행");
        Map<String, Object> resp = new HashMap<>();

        CvplVO detail = cvplService.selectCvplDetailByCvplNo(cvplNo);

        if (detail == null) {
            return ResponseEntity.notFound().build();
        }

        if (detail.getCvplFileNo() != null && !detail.getCvplFileNo().equals("")) {
            List<AttachFileVO> files = attachFileService.setFileMetaData(detail.getCvplFileNo());
            log.info("#### files {}", files);
            resp.put("files", files);
        }

        resp.put("detail", detail);

        // 본인 민원일 때만 처리 메모/반려 사유 노출
        String myUserNo = customUser.getMember().getUserNo();
        if (myUserNo != null && myUserNo.equals(detail.getUserNo())) {
            String cvplAns = cvplMapper.selectLatestCvplAns(cvplNo);
            if (cvplAns != null && !cvplAns.isBlank()) {
                resp.put("cvplAns", cvplAns);
            }
        }

        return ResponseEntity.ok(resp);
    }

    @PreAuthorize("@authService.hasAccess(principal, #aptCmplexNo)")
    @GetMapping("/list/{aptCmplexNo}")
    public String cvplList(
            @AuthenticationPrincipal CustomUser customUser
            , @PathVariable String aptCmplexNo
            , @RequestParam(defaultValue = "1") int curPage
            , @RequestParam(required = false) String cvplTyCd
            , @RequestParam(required = false) String cvplSttsCd
            , @RequestParam(required = false) String searchWord
            , Model model) {

        PaginationInfoVO<CvplVO> page = new PaginationInfoVO<>(10, 5);

        CvplVO searchVO = new CvplVO();
        searchVO.setAptCmplexNo(aptCmplexNo);
        searchVO.setCvplTyCd(cvplTyCd);
        searchVO.setCvplSttsCd(cvplSttsCd);
        page.setSearchVO(searchVO);
        page.setSearchWord(searchWord);

        int totalRecord = cvplService.selectCvplCountByAptCmplexNo(page);
        page.setTotalRecord(totalRecord);
        page.setCurrentPage(curPage);


        List<CvplVO> cvplList = cvplService.selectCvplListAllByAptCmplexNoPaged(page);
        page.setDataList(cvplList);

        model.addAttribute("page", page);
        model.addAttribute("searchWord", searchWord);
        model.addAttribute("cvplList", cvplList);
        model.addAttribute("cvplTyCd", cvplTyCd);
        model.addAttribute("cvplSttsCd", cvplSttsCd);

        AptMainPageDTO.ResponseDto aptCommonDTO = aptComplexService.selectAptCommonDTO(aptCmplexNo);
        model.addAttribute("aptInfo", aptCommonDTO);

        return "apt/complaint/complaint_list";
    }

    /**
     * 민원 취소 (본인 민원만 가능)
     */
    @PreAuthorize("@authService.canAccessCvpl(principal, #cvplNo)")
    @ResponseBody
    @PostMapping("/cancel/{aptCmplexNo}/{cvplNo}")
    public ResponseEntity<String> cancelCvpl(
            @PathVariable String cvplNo
            , @PathVariable String aptCmplexNo) {
        int res = cvplService.cancelCvpl(cvplNo);
        return (res < 1) ? ResponseEntity.badRequest().body("취소 처리에 실패하였습니다")
                : ResponseEntity.ok("취소 처리에 성공하였습니다.");
    }

    // 민원 테스트용 뷰 컨트롤러
    @GetMapping("/abc")
    public String cvpltestabc() {
        return "apt/complaint/complaint_status";
    }

}