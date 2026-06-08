package kr.or.ddit.domain.central.admin.controller;

import kr.or.ddit.common.model.PaginationInfoVO;
import kr.or.ddit.domain.central.admin.vo.*;
import lombok.RequiredArgsConstructor;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/*  전체 중앙관리자 콘트롤러 */

@Controller
@RequiredArgsConstructor
@RequestMapping("/centralAdmin")
public class CentralController {



    @GetMapping("/dashboard")
    public String dashboardForm() {
        return "centralAdmin/dashboard";
    }

    @GetMapping("/buildSearch")
    public String buildSearchForm() {
        return "centralAdmin/buildSearch";
    }

    @GetMapping("/buildRegister")
    public String buildRegisterForm() {
        return "centralAdmin/buildRegister";
    }

    @GetMapping("/residentList")
    public String residentListForm() {
        return "centralAdmin/residentList";
    }

    @GetMapping("/statistics")
    public String statisticsForm() {
        return "centralAdmin/statistics";
    }

    @GetMapping("/conManagement")
    public String conManagementForm() {
        return "centralAdmin/conManagement";
    }

    // 호환(오타/이전 링크) 경로 방어: /centralAdmin/contractManagement → 계약목록으로 이동
    /*@GetMapping("/contractManagement")
    public String contractManagementAlias() {
        return "redirect:/centralAdmin/contractList.do";
    }*/

    @GetMapping("/ai")
    public String aiForm() {
        return "centralAdmin/ai";
    }

    @GetMapping("/civilCom")
    public String civilComForm() {
        return "centralAdmin/civilCom";
    }

   /* @GetMapping("/announcement")
    public String announcementForm() {
        return "centralAdmin/announcement";
    }*/

    @GetMapping("/notice")
    public String noticeForm() {
        return "centralAdmin/notice";
    }

    @GetMapping("/proHistory")
    public String proHistoryForm() {
        return "centralAdmin/proHistory";
    }

    @GetMapping("/resident")
    public String residentForm() {
        return "centralAdmin/resident";
    }

    @GetMapping("/residentStatus")
    public String residentStatusForm() {
        return "centralAdmin/residentStatus";
    }

    @GetMapping("/facility")
    public String facilityForm() {
        return "centralAdmin/facility";
    }

    /* 중앙관리자 직원계정요청 승인 */
    @GetMapping("/mngrRqstAprv")
    public String mngrRqstAprvForm() {
        return "centralAdmin/mngrRqstAprv";
    }

    /*@GetMapping("/contractForm.do")
    public String contractForm() {
        return "redirect:/centralAdmin/contractFormList.do";
    }

    @GetMapping("/contractDoc.do")
    public String contractDocForm(){
        return "centralAdmin/contractDoc";
    }*/

/* 못 씀
    @GetMapping("/contractList.do")
    public String contractList(
            @RequestParam(name = "page", required = false, defaultValue = "1") int currentPage,
            @RequestParam(name = "ctrtNo", required = false) String ctrtNo,
            @RequestParam(name = "type", required = false) String type,
            @RequestParam(name = "user", required = false) String user,
            @RequestParam(name = "status", required = false) String status,
            @RequestParam(name = "expiry", required = false) String expiry,
            Model model) {

        PaginationInfoVO<ContractVO> pagingVO = new PaginationInfoVO<>();

        if (StringUtils.isNotBlank(type)) {
            pagingVO.setType(type);
            model.addAttribute("type", type);
        }
        if (StringUtils.isNotBlank(status)) {
            pagingVO.setStatus(status);
            model.addAttribute("status", status);
        }
        if (StringUtils.isNotBlank(user)) {
            pagingVO.setUser(user);
            model.addAttribute("user", user);
        }
        if (StringUtils.isNotBlank(expiry)) {
            pagingVO.setExpiry(expiry);
            model.addAttribute("expiry", expiry);
        }
        if (StringUtils.isNotBlank(ctrtNo)) {
            pagingVO.setCtrtNo(ctrtNo);
            model.addAttribute("ctrtNo", ctrtNo);
        }

        pagingVO.setCurrentPage(currentPage);
        int totalRecord = service.selectContractCount(pagingVO);
        pagingVO.setTotalRecord(totalRecord);

        List<ContractVO> dataList = service.selectContractList(pagingVO);
        pagingVO.setDataList(dataList);

        model.addAttribute("pagingVO", pagingVO);

        return "centralAdmin/conManagement";
    }

    @GetMapping("/contractFormList.do")
    public String contractFormList(
            @RequestParam(name = "page", required = false, defaultValue = "1") int currentPage,
            @RequestParam(name = "frmNm", required = false) String frmNm,
            @RequestParam(name = "aptCmplexNo", required = false) String aptCmplexNo,
            @RequestParam(name = "rentTypeCd", required = false) String rentTypeCd,
            Model model) {

        PaginationInfoVO<ContractFormVO> pagingVO = new PaginationInfoVO<>();

        if (StringUtils.isNotBlank(frmNm)) {
            pagingVO.setFrmNm(frmNm);
            model.addAttribute("frmNm", frmNm);
        }
        if (StringUtils.isNotBlank(aptCmplexNo)) {
            pagingVO.setAptCmplexNo(aptCmplexNo);
            model.addAttribute("aptCmplexNo", aptCmplexNo);
        }
        if (StringUtils.isNotBlank(rentTypeCd)) {
            // PaginationInfoVO는 rentTypeNm 필드를 사용
            pagingVO.setRentTypeCd(rentTypeCd);
            model.addAttribute("rentTypeCd", rentTypeCd);
        }

        pagingVO.setCurrentPage(currentPage);
        int totalRecord = service.selectContractFormCount(pagingVO);
        pagingVO.setTotalRecord(totalRecord);

        List<ContractFormVO> dataList = service.selectContractFormList(pagingVO);
        pagingVO.setDataList(dataList);

        // 아파트 목록 드롭다운용
        model.addAttribute("aptList", service.contractForm(model));
        model.addAttribute("pagingVO", pagingVO);

        return "centralAdmin/contractForm";
    }
*/

    /*@PostMapping("/contractInsert.do")
    public String contractInsert(ContractVO contractVO,
                                 MultipartFile contractFile,
                                 MultipartFile idFile,
                                 MultipartFile etcFile,
                                 Model model) throws Exception {
        contractVO.setCtrtSttsCd("SUB");
        contractVO.setMvinYn("N");
        service.insertContract(contractVO, new MultipartFile[]{contractFile, idFile, etcFile});
        return "redirect:/centralAdmin/contractList.do";
    }

    @GetMapping("/contractDetail.do")
    @ResponseBody
    public ContractVO contractDetail(@RequestParam String ctrtNo) {
        return service.selectOneContract(ctrtNo);
    }
    @PostMapping("/contractModifyStatus")
    @ResponseBody
    public Map<String, Object> contractModifyStatus(
            @RequestParam String rentCtrtNo,
            @RequestParam String status) {
        Map<String, Object> result = new HashMap<>();
        try {
            service.contractModifyStatus(rentCtrtNo, status);
            result.put("success", true);
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }

    @PostMapping("/contractUpdate.do")
    public String contractUpdate(ContractVO contractVO,
                                 MultipartFile contractFile,
                                 MultipartFile idFile,
                                 MultipartFile etcFile) throws Exception {
        service.updateContract(contractVO, new MultipartFile[]{contractFile, idFile, etcFile});
        return "redirect:/centralAdmin/contractList.do";
    }
    
    @GetMapping("/contractFormDetail.do")
    @ResponseBody
    public ContractFormVO selectOneContractForm(@RequestParam String frmNo) {

        return service.selectOneContractForm(frmNo);
    }

    @PostMapping("/contractFormInsert.do")
    public String contractFormInsert(ContractFormVO contractFormVO,
                                     MultipartFile formFile) throws Exception {
        service.insertContractForm(contractFormVO, formFile);
        return "redirect:/centralAdmin/contractFormList.do";
    }

    @PostMapping("contractFormUpdate.do")
    @ResponseBody
    public Map<String, Object> contractFormUpdate(ContractFormVO contractFormVO){
        Map<String, Object> result = new HashMap<>();
        try {
            service.contractFormUpdate(contractFormVO);
            result.put("success", true);
        } catch (Exception e){
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }

    @PostMapping("/contractFormDelete.do")
    public String contractFormDelete(@RequestParam(name = "frmNo") String frmNo) {
        if (StringUtils.isNotBlank(frmNo)) {
            service.deleteContractForm(frmNo);
        }
        return "redirect:/centralAdmin/contractFormList.do";
    }*/

/*
    // 작성자 : 오수아
    @GetMapping("/contractDocList.do")
    public String contractDocList(
            @RequestParam(name = "page", required = false, defaultValue = "1") int currentPage,
            @RequestParam(name = "sbmsnDocNo", required = false) String sbmsnDocNo,
            @RequestParam(name = "sbmsnDocTyCd", required = false) String sbmsnDocTyCd,
            @RequestParam(name = "rentTypeCd", required = false) String rentTypeCd,
            Model model) {

        PaginationInfoVO<ContractDocVO> pagingVO = new PaginationInfoVO<>();

        if (StringUtils.isNotBlank(sbmsnDocNo)) {
            pagingVO.setSbmsnDocNo(sbmsnDocNo);
            model.addAttribute("sbmsnDocNo", sbmsnDocNo);
        }
        if (StringUtils.isNotBlank(sbmsnDocTyCd)) {
            pagingVO.setSbmsnDocTyCd(sbmsnDocTyCd);
            model.addAttribute("sbmsnDocTyCd", sbmsnDocTyCd);
        }
        if (StringUtils.isNotBlank(rentTypeCd)) {
            // PaginationInfoVO는 rentTypeNm 필드를 사용
            pagingVO.setRentTypeCd(rentTypeCd);
            model.addAttribute("rentTypeCd", rentTypeCd);
        }

        pagingVO.setCurrentPage(currentPage);
        int totalRecord = service.selectContractDocCount(pagingVO);
        pagingVO.setTotalRecord(totalRecord);

        List<ContractDocVO> dataList = service.selectContractDocList(pagingVO);
        pagingVO.setDataList(dataList);


        return "centralAdmin/contractDoc";
    }
*/

}
