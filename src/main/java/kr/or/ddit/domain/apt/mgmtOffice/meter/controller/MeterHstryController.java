package kr.or.ddit.domain.apt.mgmtOffice.meter.controller;

import kr.or.ddit.domain.apt.mgmtOffice.common.service.IManagerModelService;
import kr.or.ddit.domain.apt.mgmtOffice.meter.service.IMeterHstryService;
import kr.or.ddit.domain.apt.mgmtOffice.meter.vo.MeterHstryVO;
import kr.or.ddit.domain.member.vo.CustomUser;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ContentDisposition;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 검침 이력 Controller
 * - 검침 이력 목록 화면 조회
 * - CSV 파일 업로드 후 METER_HSTRY 등록 처리
 */
@Controller
@RequiredArgsConstructor
@RequestMapping("/manager/meter/hstry")
public class MeterHstryController {

    private static final int DEFAULT_PAGE_SIZE = 10;
    private static final int MAX_PAGE_SIZE = 100;

    private final IMeterHstryService meterHstryService;
    private final IManagerModelService managerModelService;

    /**
     * 검침 이력 목록 화면
     * - 단지별 검침(ho_no IS NOT NULL)과 시설 검침(ho_no IS NULL)을 각각 조회하여 model에 담음
     * - 탭별 검색 파라미터를 분리하여 처리함
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/{mgmtOfcNo}")
    public String list(
            @PathVariable String mgmtOfcNo,
            // 단지별 검침 검색 파라미터
            @RequestParam(required = false) String complexUtilityProviderNo,
            @RequestParam(value = "complexMeterTyCd", required = false) List<String> complexMeterTyCdList,
            @RequestParam(required = false) String complexMeterRsltCd,
            @RequestParam(required = false) String complexStartDt,
            @RequestParam(required = false) String complexEndDt,
            @RequestParam(required = false) String complexKeyword,
            // 단지 탭 전용: 동/호 범위
            @RequestParam(required = false) String complexDongStart,
            @RequestParam(required = false) String complexDongEnd,
            @RequestParam(required = false) String complexHoStart,
            @RequestParam(required = false) String complexHoEnd,
            // 단지 탭: 검침값 범위 (이전값/현재값/사용량)
            @RequestParam(required = false) String complexPreValStart,
            @RequestParam(required = false) String complexPreValEnd,
            @RequestParam(required = false) String complexCurrValStart,
            @RequestParam(required = false) String complexCurrValEnd,
            @RequestParam(required = false) String complexUsageValStart,
            @RequestParam(required = false) String complexUsageValEnd,
            // 시설 검침 검색 파라미터
            @RequestParam(required = false) String utilityProviderNo,
            @RequestParam(value = "meterTyCd", required = false) List<String> meterTyCdList,
            @RequestParam(required = false) String meterRsltCd,
            @RequestParam(required = false) String startDt,
            @RequestParam(required = false) String endDt,
            @RequestParam(required = false) String keyword,
            // 시설 탭: 검침값 범위
            @RequestParam(required = false) String preValStart,
            @RequestParam(required = false) String preValEnd,
            @RequestParam(required = false) String currValStart,
            @RequestParam(required = false) String currValEnd,
            @RequestParam(required = false) String usageValStart,
            @RequestParam(required = false) String usageValEnd,
            // 협력업체 상세에서 검침 이력으로 이동할 때 유지할 협력업체 필터
            @RequestParam(required = false) String partnerNo,
            @RequestParam(required = false) String meterScope,
            @RequestParam(required = false) String uploadedFrom,
            @RequestParam(required = false) String uploadedTo,
            @RequestParam(required = false) String sortField,
            @RequestParam(required = false) String sortDir,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int pageSize,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {
        String activeScope = "FACILITY".equals(meterScope) ? "FACILITY" : "COMPLEX";
        int currentPage = normalizePage(page);
        int currentPageSize = normalizePageSize(pageSize);
        int offset = (currentPage - 1) * currentPageSize;
        complexMeterTyCdList = cleanValues(complexMeterTyCdList);
        meterTyCdList = cleanValues(meterTyCdList);
        String meterSortField = normalizeSortField(sortField);
        String meterSortDir = normalizeSortDir(sortDir);

        // 단지별 검침 조회 조건
        Map<String, Object> complexParamMap = new HashMap<>();
        complexParamMap.put("mgmtOfcNo", mgmtOfcNo);
        complexParamMap.put("meterScope", "COMPLEX");
        complexParamMap.put("utilityProviderNo", complexUtilityProviderNo);
        complexParamMap.put("meterTyCdList", complexMeterTyCdList);
        complexParamMap.put("meterTyCd", firstValue(complexMeterTyCdList));
        complexParamMap.put("meterTyCdJoined", complexMeterTyCdList == null ? "" : String.join(",", complexMeterTyCdList));
        // JSP에서 체크박스 checked 판단용 - 콤마 join 문자열
        complexParamMap.put("meterTyCdJoined", complexMeterTyCdList == null ? "" : String.join(",", complexMeterTyCdList));
        complexParamMap.put("meterRsltCd", complexMeterRsltCd);
        complexParamMap.put("startDt", complexStartDt);
        complexParamMap.put("endDt", complexEndDt);
        complexParamMap.put("keyword", complexKeyword);
        complexParamMap.put("dongStart", complexDongStart);
        complexParamMap.put("dongEnd", complexDongEnd);
        complexParamMap.put("hoStart", complexHoStart);
        complexParamMap.put("hoEnd", complexHoEnd);
        complexParamMap.put("preValStart", complexPreValStart);
        complexParamMap.put("preValEnd", complexPreValEnd);
        complexParamMap.put("currValStart", complexCurrValStart);
        complexParamMap.put("currValEnd", complexCurrValEnd);
        complexParamMap.put("usageValStart", complexUsageValStart);
        complexParamMap.put("usageValEnd", complexUsageValEnd);
        complexParamMap.put("partnerNo", partnerNo);
        complexParamMap.put("uploadedFrom", uploadedFrom);
        complexParamMap.put("uploadedTo", uploadedTo);
        // 협력업체 상세에서 넘어온 경우 단지별 검침에도 같은 업체 필터를 적용함
        complexParamMap.put("partnerNo", partnerNo);

        // 시설 검침 조회 조건
        Map<String, Object> facilityParamMap = new HashMap<>();
        facilityParamMap.put("mgmtOfcNo", mgmtOfcNo);
        facilityParamMap.put("meterScope", "FACILITY");
        facilityParamMap.put("utilityProviderNo", utilityProviderNo);
        facilityParamMap.put("meterTyCdList", meterTyCdList);
        facilityParamMap.put("meterTyCd", firstValue(meterTyCdList));
        facilityParamMap.put("meterTyCdJoined", meterTyCdList == null ? "" : String.join(",", meterTyCdList));
        facilityParamMap.put("meterRsltCd", meterRsltCd);
        facilityParamMap.put("startDt", startDt);
        facilityParamMap.put("endDt", endDt);
        facilityParamMap.put("keyword", keyword);
        facilityParamMap.put("preValStart", preValStart);
        facilityParamMap.put("preValEnd", preValEnd);
        facilityParamMap.put("currValStart", currValStart);
        facilityParamMap.put("currValEnd", currValEnd);
        facilityParamMap.put("usageValStart", usageValStart);
        facilityParamMap.put("usageValEnd", usageValEnd);
        facilityParamMap.put("partnerNo", partnerNo);
        facilityParamMap.put("uploadedFrom", uploadedFrom);
        facilityParamMap.put("uploadedTo", uploadedTo);
        // 협력업체 상세에서 넘어온 경우 시설 검침에도 같은 업체 필터를 적용함
        facilityParamMap.put("partnerNo", partnerNo);

        Map<String, Object> activeParamMap = "FACILITY".equals(activeScope) ? facilityParamMap : complexParamMap;
        activeParamMap.put("offset", offset);
        activeParamMap.put("pageSize", currentPageSize);
        activeParamMap.put("sortField", meterSortField);
        activeParamMap.put("sortDir", meterSortDir);

        int totalCount = meterHstryService.selectMeterHstryCount(activeParamMap);
        int totalPage = Math.max(1, (int) Math.ceil((double) totalCount / currentPageSize));
        if (currentPage > totalPage) {
            currentPage = totalPage;
            offset = (currentPage - 1) * currentPageSize;
            activeParamMap.put("offset", offset);
        }

        // 관리사무소 공통 화면 모델 세팅
        managerModelService.addManagerViewModel(model, customUser, mgmtOfcNo);

        model.addAttribute("activeMeterScope", activeScope);
        model.addAttribute("meterPage", currentPage);
        model.addAttribute("meterPageSize", currentPageSize);
        model.addAttribute("meterTotalPage", totalPage);
        model.addAttribute("meterSortField", meterSortField);
        model.addAttribute("meterSortDir", meterSortDir);
        model.addAttribute("complexSearch", complexParamMap);
        model.addAttribute("search", facilityParamMap);
        if ("FACILITY".equals(activeScope)) {
            model.addAttribute("complexMeterList", Collections.emptyList());
            model.addAttribute("complexTotalCount", 0);
            model.addAttribute("complexStartNo", 0);
            model.addAttribute("facilityMeterList", meterHstryService.selectMeterHstryList(activeParamMap));
            model.addAttribute("facilityTotalCount", totalCount);
            model.addAttribute("facilityStartNo", totalCount - offset);
        } else {
            model.addAttribute("complexMeterList", meterHstryService.selectMeterHstryList(activeParamMap));
            model.addAttribute("complexTotalCount", totalCount);
            model.addAttribute("complexStartNo", totalCount - offset);
            model.addAttribute("facilityMeterList", Collections.emptyList());
            model.addAttribute("facilityTotalCount", 0);
            model.addAttribute("facilityStartNo", 0);
        }
        // 검침 스코프별 업체 목록 (탭별 필터 + 다운로드 모달 공용, 실제 검침이력이 있는 업체만)
        model.addAttribute("complexProviderList", meterHstryService.selectUtilityProviderListByScope(mgmtOfcNo, "COMPLEX"));
        model.addAttribute("facilityProviderList", meterHstryService.selectUtilityProviderListByScope(mgmtOfcNo, "FACILITY"));
        model.addAttribute("rsltCodeList", meterHstryService.selectMeterRsltCodeList());
        model.addAttribute("meterTyCodeList", meterHstryService.selectMeterTyCodeList());

        return "apt/mgmtOffice/meter/mngr_meter_hstry";
    }

    private int normalizePage(int page) {
        return Math.max(page, 1);
    }

    private int normalizePageSize(int pageSize) {
        if (pageSize <= 0) {
            return DEFAULT_PAGE_SIZE;
        }
        return Math.min(pageSize, MAX_PAGE_SIZE);
    }

    private String firstValue(List<String> values) {
        return values == null || values.isEmpty() ? null : values.get(0);
    }

    private String normalizeSortField(String sortField) {
        if ("METER_HSTRY_NO".equals(sortField) || "METER_DT".equals(sortField) || "HO_NO".equals(sortField) || "PRE_VAL".equals(sortField) || "CURR_VAL".equals(sortField) || "USAGE_VAL".equals(sortField)) {
            return sortField;
        }
        return "METER_DT";
    }

    private String normalizeSortDir(String sortDir) {
        return "ASC".equals(sortDir) ? "ASC" : "DESC";
    }

    private List<String> cleanValues(List<String> values) {
        if (values == null || values.isEmpty()) {
            return null;
        }
        List<String> cleaned = new ArrayList<>();
        for (String value : values) {
            if (value != null && !value.trim().isEmpty()) {
                cleaned.add(value.trim());
            }
        }
        return cleaned.isEmpty() ? null : cleaned;
    }


    /**
     * CSV 업로드 전 미리보기/자동 매칭
     * - CSV 내부 csv_idntf_key, ext_cust_no를 읽어 공급/검침 설정을 자동으로 찾음
     * - 실제 등록은 하지 않고 화면 확인용 요약과 일부 행만 반환함
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @PostMapping("/preview/{mgmtOfcNo}")
    @ResponseBody
    public Map<String, Object> previewCsv(
            @PathVariable String mgmtOfcNo,
            @RequestParam String meterScope,
            @RequestParam("csvFile") MultipartFile csvFile
    ) {
        Map<String, Object> result = new HashMap<>();
        try {
            result = meterHstryService.previewMeterCsv(mgmtOfcNo, meterScope, csvFile);
            result.put("success", true);
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }

    /**
     * 검침 CSV 업로드
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @PostMapping("/upload/{mgmtOfcNo}")
    public String uploadCsv(
            @PathVariable String mgmtOfcNo,
            @RequestParam String utilityProviderNo,
            @RequestParam String meterScope,
            @RequestParam("csvFile") MultipartFile csvFile,
            @AuthenticationPrincipal CustomUser customUser,
            RedirectAttributes redirectAttributes
    ) {
        try {
            String uploadUserNo = customUser.getMember().getUserNo();
            Map<String, Object> uploadResult = meterHstryService.uploadMeterCsv(mgmtOfcNo, utilityProviderNo, meterScope, csvFile, uploadUserNo);
            Object insertCnt = uploadResult.get("insertCnt");
            redirectAttributes.addFlashAttribute("successMessage", insertCnt + "건의 검침 이력이 등록되었습니다. 방금 업로드된 행만 표시합니다.");
            redirectAttributes.addAttribute("meterScope", uploadResult.get("meterScope"));
            redirectAttributes.addAttribute("uploadedFrom", uploadResult.get("uploadedFrom"));
            redirectAttributes.addAttribute("uploadedTo", uploadResult.get("uploadedTo"));
            if ("COMPLEX".equals(uploadResult.get("meterScope"))) {
                redirectAttributes.addAttribute("complexUtilityProviderNo", uploadResult.get("utilityProviderNo"));
            } else {
                redirectAttributes.addAttribute("utilityProviderNo", uploadResult.get("utilityProviderNo"));
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }
        return "redirect:/manager/meter/hstry/" + mgmtOfcNo;
    }

    /**
     * 다운로드 조건 기준 검침 미리보기
     * - 건수와 함께 상위 3건의 샘플 행을 반환함
     * - 모달에서 사용자가 다운로드 전에 실제 CSV 모양을 확인할 수 있게 함
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/download/check/{mgmtOfcNo}")
    @ResponseBody
    public Map<String, Object> checkDownloadCsv(
            @PathVariable String mgmtOfcNo,
            DownloadFilterParam params
    ) {
        Map<String, Object> preview = meterHstryService.previewDownloadMeter(mgmtOfcNo, params.toMap());
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("count", preview.get("count"));
        result.put("sampleRows", preview.get("sampleRows"));
        result.put("filename", preview.get("filename"));
        return result;
    }

    /**
     * 다운로드 조건 기준 검침 CSV 응답
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/download/{mgmtOfcNo}")
    public ResponseEntity<byte[]> downloadCsv(
            @PathVariable String mgmtOfcNo,
            DownloadFilterParam params
    ) {
        byte[] csvBytes = meterHstryService.downloadMeterCsv(mgmtOfcNo, params.toMap());
        String filename = meterHstryService.buildDownloadFilename(mgmtOfcNo);

        HttpHeaders headers = new HttpHeaders();
        // 한국 엑셀 호환을 위해 MS949(CP949)로 인코딩한 CSV 본문에 맞춰 Content-Type 도 동일하게 지정
        headers.setContentType(new MediaType("text", "csv", java.nio.charset.Charset.forName("MS949")));
        headers.setContentDisposition(ContentDisposition.attachment()
                .filename(filename, StandardCharsets.UTF_8)
                .build());

        return ResponseEntity.ok()
                .headers(headers)
                .body(csvBytes);
    }

    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/detail/{mgmtOfcNo}/{meterHstryNo}")
    @ResponseBody
    public Map<String, Object> detail(
            @PathVariable String mgmtOfcNo,
            @PathVariable String meterHstryNo
    ) {
        Map<String, Object> result = new HashMap<>();
        try {
            MeterHstryVO vo = meterHstryService.selectMeterHstryDetail(meterHstryNo);
            result.put("success", true);
            result.put("meterHstry", vo);
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }

    /**
     * 검침 이력 수정
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @PostMapping("/update/{mgmtOfcNo}")
    public String update(
            @PathVariable String mgmtOfcNo,
            MeterHstryVO meterHstryVO,
            @RequestParam(required = false) String returnQueryString,
            RedirectAttributes redirectAttributes
    ) {
        try {
            meterHstryService.updateMeterHstry(meterHstryVO);
            redirectAttributes.addFlashAttribute("successMessage", "검침 이력이 수정되었습니다.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }
        return "redirect:/manager/meter/hstry/" + mgmtOfcNo + normalizeReturnQueryString(returnQueryString);
    }

    private String normalizeReturnQueryString(String returnQueryString) {
        if (returnQueryString == null || returnQueryString.isBlank()) {
            return "";
        }

        String queryString = returnQueryString.trim();
        if (queryString.startsWith("?")) {
            return queryString;
        }

        return "?" + queryString;
    }

    /**
     * 다운로드 모달이 폼으로 보내는 필터 파라미터 묶음
     * - 리스트 화면에서 적용한 모든 필터가 다운로드에도 그대로 반영되도록 항목을 다 받음
     * - Spring이 같은 이름의 query param을 자동으로 바인딩해 줌
     */
    @lombok.Data
    public static class DownloadFilterParam {
        private String meterScope;
        private String utilityProviderNo;
        private String partnerNo;
        private java.util.List<String> meterTyCdList;
        private String meterRsltCd;
        private String startDt;
        private String endDt;
        private String keyword;
        // 단지 탭에서만 채워지는 동/호 범위
        private String dongStart;
        private String dongEnd;
        private String hoStart;
        private String hoEnd;
        // 검침값 범위 (양쪽 탭 공통)
        private String preValStart;
        private String preValEnd;
        private String currValStart;
        private String currValEnd;
        private String usageValStart;
        private String usageValEnd;

        Map<String, Object> toMap() {
            Map<String, Object> map = new HashMap<>();
            map.put("meterScope", meterScope);
            map.put("utilityProviderNo", utilityProviderNo);
            map.put("partnerNo", partnerNo);
            map.put("meterTyCdList", meterTyCdList);
            map.put("meterRsltCd", meterRsltCd);
            map.put("startDt", startDt);
            map.put("endDt", endDt);
            map.put("keyword", keyword);
            map.put("dongStart", dongStart);
            map.put("dongEnd", dongEnd);
            map.put("hoStart", hoStart);
            map.put("hoEnd", hoEnd);
            map.put("preValStart", preValStart);
            map.put("preValEnd", preValEnd);
            map.put("currValStart", currValStart);
            map.put("currValEnd", currValEnd);
            map.put("usageValStart", usageValStart);
            map.put("usageValEnd", usageValEnd);
            return map;
        }
    }
}
