package kr.or.ddit.domain.member.resident.controller;

import kr.or.ddit.domain.apt.main.dto.AptMainPageDTO;
import kr.or.ddit.domain.apt.main.service.IAptComplexService;
import kr.or.ddit.domain.apt.mgmtOffice.bill.vo.BillVO;
import kr.or.ddit.domain.member.resident.service.IResidentBillService;
import kr.or.ddit.domain.member.vo.CustomUser;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Controller
@RequestMapping("/resident/bill")
@PreAuthorize("hasRole('RESIDENT') or hasRole('MEMBER')")
public class ResidentBillController {

    @Autowired
    private IResidentBillService residentBillService;

    @Autowired
    private IAptComplexService aptComplexService;

    @Value("${portone.imp-code}")
    private String portOneImpCode;

    @Value("${portone.channel-key}")
    private String portOneChannelKey;

    // 관리비 조회 화면
    @GetMapping("/inquiry/{aptCmplexNo}")
    public String billInquiry(@AuthenticationPrincipal CustomUser customUser,
                              @PathVariable String aptCmplexNo,
                              Model model) {

        AptMainPageDTO.ResponseDto aptMainPageDTO = aptComplexService.selectAptMainDTO(aptCmplexNo);

        model.addAttribute("aptInfo", aptMainPageDTO);

        return "member/resident/bill/bill_inquiry";
    }

    // 내 세대 정보 조회
    @GetMapping("/my-houses")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> selectMyHouseList(
            @AuthenticationPrincipal CustomUser customUser
    ) {
        Map<String, Object> result = new HashMap<>();

        try {
            String userNo = customUser.getMember().getUserNo();

            List<BillVO> houseList = residentBillService.selectMyHouseList(userNo);

            result.put("success", true);
            result.put("houseList", houseList);

        } catch (Exception e) {
            log.error("내 세대 목록 조회 실패", e);
            result.put("success", false);
            result.put("message", e.getMessage());
        }

        return ResponseEntity.ok(result);
    }

    // 내 관리비 목록 조회
    @GetMapping("/list")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> selectMyBillList(
            @AuthenticationPrincipal CustomUser customUser,
            @RequestParam String hoNo,
            @RequestParam(required = false) String billYm
    ) {
        Map<String, Object> result = new HashMap<>();

        try {
            String userNo = customUser.getMember().getUserNo();

            List<BillVO> list = residentBillService.selectMyBillList(userNo, hoNo, billYm);

            BillVO latestBill = null;
            Long latestAmount = 0L;

            if (list != null && !list.isEmpty()) {
                latestBill = list.get(0);
                latestAmount = latestBill.getBillTotAmt() == null ? 0L : latestBill.getBillTotAmt();
            }

            result.put("success", true);
            result.put("list", list);
            result.put("latestBill", latestBill);
            result.put("latestAmount", latestAmount);

        } catch (Exception e) {
            log.error("내 관리비 목록 조회 실패", e);
            result.put("success", false);
            result.put("message", e.getMessage());
        }

        return ResponseEntity.ok(result);
    }

    // 내 관리비 상세 조회
    @GetMapping("/detail/{billNo}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> selectMyBillDetail(
            @AuthenticationPrincipal CustomUser customUser,
            @PathVariable String billNo
    ) {
        Map<String, Object> result = new HashMap<>();

        try {
            String userNo = customUser.getMember().getUserNo();

            BillVO billVO = residentBillService.selectMyBillDetail(userNo, billNo);

            result.put("success", true);
            result.put("bill", billVO);

        } catch (Exception e) {
            log.error("내 관리비 상세 조회 실패", e);
            result.put("success", false);
            result.put("message", e.getMessage());
        }

        return ResponseEntity.ok(result);
    }

    /**
     * 선택 세대의 연도별 관리비 고지서 목록 조회
     * GET /resident/bill/year-list?hoNo=A12127003_7_1901&billYear=2026
     */
    @GetMapping("/year-list")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> selectYearBillList(
            @RequestParam String hoNo,
            @RequestParam String billYear
    ) {
        Map<String, Object> result = new HashMap<>();

        try {
            List<BillVO> billList = residentBillService.selectYearBillList(hoNo, billYear);

            result.put("success", true);
            result.put("list", billList);
            result.put("billYear", billYear);
            result.put("hoNo", hoNo);

        } catch (Exception e) {
            log.error("연도별 관리비 목록 조회 실패", e);

            result.put("success", false);
            result.put("message", e.getMessage());
        }

        return ResponseEntity.ok(result);
    }

    // 납부안내
    @GetMapping("/guide/{aptCmplexNo}")
    public String billGuide(@AuthenticationPrincipal CustomUser customUser,
                            @PathVariable String aptCmplexNo,
                            Model model) {
        AptMainPageDTO.ResponseDto aptMainPageDTO = aptComplexService.selectAptMainDTO(aptCmplexNo);

        model.addAttribute("aptInfo", aptMainPageDTO);
        model.addAttribute("portOneImpCode", portOneImpCode);
        model.addAttribute("portOneChannelKey", portOneChannelKey);
        return "member/resident/bill/bill_guide";
    }

    // 자동이체신청
//    @GetMapping("/auto")
//    public String billAuto() {
//        return "member/resident/bill/bill_auto";
//    }

    // 납부영수증
    @GetMapping("/receipt/{aptCmplexNo}")
    public String billReceipt(@AuthenticationPrincipal CustomUser customUser,
                              @PathVariable String aptCmplexNo,
                              Model model) {
       AptMainPageDTO.ResponseDto aptMainPageDTO = aptComplexService.selectAptMainDTO(aptCmplexNo);

       model.addAttribute("aptInfo", aptMainPageDTO);
       return "member/resident/bill/bill_receipt";
    }
}