package kr.or.ddit.domain.apt.mgmtOffice.bill.controller;

import kr.or.ddit.domain.apt.mgmtOffice.bill.service.IBillStatisticsService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.Map;

@Slf4j
@Controller
@RequestMapping("/manager/bill/statistics")
public class BillStatisticsController {

    @Autowired
    private IBillStatisticsService billStatisticsService;

    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/{mgmtOfcNo}")
    public String statisticsPage(
            @PathVariable String mgmtOfcNo,
            Model model
    ) {
        LocalDate now = LocalDate.now();

        String toYm = now.format(DateTimeFormatter.ofPattern("yyyyMM"));
        String fromYm = now.minusMonths(12).format(DateTimeFormatter.ofPattern("yyyyMM"));

        model.addAttribute("mgmtOfcNo", mgmtOfcNo);
        model.addAttribute("fromYm", fromYm);
        model.addAttribute("toYm", toYm);

        return "apt/mgmtOffice/bill/bill_statistics";
    }

    /**
     * 관리비 통계 데이터 API
     *
     * 예:
     * /manager/bill/statistics/api/52?fromYm=202504&toYm=202604
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/api/{mgmtOfcNo}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> statisticsApi(
            @PathVariable String mgmtOfcNo,
            @RequestParam String fromYm,
            @RequestParam String toYm
    ) {
        Map<String, Object> result = new HashMap<>();

        try {
            Map<String, Object> statistics =
                    billStatisticsService.selectBillStatistics(mgmtOfcNo, fromYm, toYm);

            result.put("success", true);
            result.putAll(statistics);

        } catch (Exception e) {
            log.error("관리비 통계 조회 실패", e);

            result.put("success", false);
            result.put("message", e.getMessage());
        }

        return ResponseEntity.ok(result);
    }

}
