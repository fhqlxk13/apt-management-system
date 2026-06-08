package kr.or.ddit.domain.apt.mgmtOffice.bill.controller;

import kr.or.ddit.common.model.PaginationInfoVO;
import kr.or.ddit.domain.apt.main.service.IAptComplexService;
import kr.or.ddit.domain.apt.main.vo.AptComplexVO;
import kr.or.ddit.domain.apt.mgmtOffice.bill.service.IBillChargeService;
import kr.or.ddit.domain.apt.mgmtOffice.bill.service.IBillIssueService;
import kr.or.ddit.domain.apt.mgmtOffice.bill.service.IMeterChargeService;
import kr.or.ddit.domain.apt.mgmtOffice.bill.vo.BillVO;
import kr.or.ddit.domain.apt.mgmtOffice.common.service.IManagerModelService;
import kr.or.ddit.domain.member.vo.CustomUser;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Controller
@RequestMapping("/manager")
@PreAuthorize("hasRole('MNGR')")  // 계층 구조상 ADMIN도 통과
@RequiredArgsConstructor
public class BillController {

    // ADMIN/MNGR 접근 기준 및 화면 공통 모델 처리
    @Autowired
    private IManagerModelService managerAccessService;

    @Autowired
    private IAptComplexService aptComplexService;

    @Autowired
    private IBillChargeService billChargeService;

    @Autowired
    private IBillIssueService billIssueService;

    @Autowired
    private IMeterChargeService meterChargeService;

    /**
     * @Author 이윤진
     * @param mgmtOfcNo 관리사무소번호
     * @param customUser
     * @param model
     * @return 관리비부과 화면
     */

    // 관리비 부과
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/bill/charge/{mgmtOfcNo}")
    public String billCharge(
            @PathVariable String mgmtOfcNo,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {
        managerAccessService.addManagerViewModel(model, customUser, mgmtOfcNo);
        return "apt/mgmtOffice/bill/mngr_billCharge";
    }

    /**
     * 관리비 부과 미리보기
     *
     * 요청 예시:
     * GET /manager/bill/charge/preview/4?billYm=202605
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/bill/charge/preview/{mgmtOfcNo}")
    public ResponseEntity<Map<String, Object>> previewBillCharge(
            @PathVariable String mgmtOfcNo,
            @RequestParam String billYm,
            @AuthenticationPrincipal CustomUser customUser
    ) {
        Map<String, Object> result = new HashMap<>();

        try {
            AptComplexVO aptComplexVO = aptComplexService.selectMgmtOfcNoAptComplex(mgmtOfcNo);

            if (aptComplexVO == null) {
                result.put("success", false);
                result.put("message", "관리사무소에 연결된 아파트 단지 정보가 없습니다.");
                return ResponseEntity.ok(result);
            }

            Map<String, Object> preview =
                    billChargeService.previewBillCharge(aptComplexVO.getAptCmplexNo(), billYm);

            result.put("success", true);
            result.putAll(preview);

        } catch (Exception e) {
            log.error("관리비 부과 미리보기 실패", e);
            result.put("success", false);
            result.put("message", e.getMessage());
        }

        return ResponseEntity.ok(result);
    }

    /**
     * 관리비 부과 실행
     *
     * 요청 예시:
     * POST /manager/bill/charge/execute/4
     *
     * 요청 JSON:
     * {
     *   "billYm": "202605",
     *   "dueDt": "2026-06-10"
     * }
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @PostMapping("/bill/charge/execute/{mgmtOfcNo}")
    public ResponseEntity<Map<String, Object>> executeBillCharge(
            @PathVariable String mgmtOfcNo,
            @RequestBody Map<String, String> body,
            @AuthenticationPrincipal CustomUser customUser
    ) {
        Map<String, Object> result = new HashMap<>();

        try {
            String billYm = body.get("billYm");
            String dueDt = body.get("dueDt");

            AptComplexVO aptComplexVO = aptComplexService.selectMgmtOfcNoAptComplex(mgmtOfcNo);

            if (aptComplexVO == null) {
                result.put("success", false);
                result.put("message", "관리사무소에 연결된 아파트 단지 정보가 없습니다.");
                return ResponseEntity.ok(result);
            }

            Map<String, Object> chargeResult =
                    billChargeService.executeBillCharge(aptComplexVO.getAptCmplexNo(), billYm, dueDt);

            result.put("success", true);
            result.put("message", "관리비 부과가 완료되었습니다.");
            result.putAll(chargeResult);

        } catch (Exception e) {
            log.error("관리비 부과 실패", e);
            result.put("success", false);
            result.put("message", e.getMessage());
        }

        return ResponseEntity.ok(result);
    }

    /**
     * 검 침요금 계산 화면
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/bill/meter-charge/{mgmtOfcNo}")
    public String meterChargePage(
            @PathVariable String mgmtOfcNo,
            Model model,
            Authentication authentication
    ) {
        CustomUser customUser = (CustomUser) authentication.getPrincipal();

        managerAccessService.addManagerViewModel(model, customUser, mgmtOfcNo);

        return "apt/mgmtOffice/bill/mngr_meterCharge";
    }

    /**
     * 세대별 검침요금 목록 조회
     * - PaginationInfoVO 기반 DB 페이징 적용
     * - 항목, 동/호수 검색조건 적용
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/bill/meter-charge/list/{mgmtOfcNo}")
    public ResponseEntity<Map<String, Object>> selectMeterChargeList(
            @PathVariable String mgmtOfcNo,
            @RequestParam String billYm,
            @RequestParam(required = false) String billItemCd,
            @RequestParam(required = false) String keyword,
            @RequestParam(defaultValue = "1") int currentPage
    ) {

        Map<String, Object> result = new HashMap<>();

        try {
            /*
             * 관리사무소 번호로 해당 아파트 단지번호 조회
             */
            AptComplexVO aptComplexVO =
                    aptComplexService.selectMgmtOfcNoAptComplex(mgmtOfcNo);

            if (aptComplexVO == null) {
                result.put("success", false);
                result.put("message", "관리사무소에 연결된 아파트 단지 정보가 없습니다.");

                return ResponseEntity.ok(result);
            }

            /*
             * 검침년월 검증
             * 예: 202605
             */
            if (billYm == null || !billYm.matches("\\d{6}")) {
                result.put("success", false);
                result.put("message", "검침년월 형식이 올바르지 않습니다.");

                return ResponseEntity.ok(result);
            }

            /*
             * 기존 전체조회 메서드가 아니라
             * PaginationInfoVO 기반 페이징 조회 메서드를 호출해야 한다.
             */
            result = meterChargeService.selectMeterChargePagingList(
                    aptComplexVO.getAptCmplexNo(),
                    billYm,
                    billItemCd,
                    keyword,
                    currentPage
            );

            result.put("success", true);
            result.put("billYm", billYm);

        } catch (Exception e) {
            log.error("검침요금 계산 조회 실패", e);

            result.put("success", false);
            result.put("message", "검침요금 계산 조회 중 오류가 발생했습니다.");
        }

        return ResponseEntity.ok(result);
    }

    /**
     * 세대별 검침값 입력 및 저장
     * 요청 URL:
     * POST /manager/bill/meter-charge/save/{mgmtOfcNo}
     *
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @PostMapping("/bill/meter-charge/save/{mgmtOfcNo}")
    @ResponseBody
    @SuppressWarnings("unchecked")
    public ResponseEntity<Map<String, Object>> saveMeterCharge(
            @PathVariable String mgmtOfcNo,
            @RequestBody Map<String, Object> body
    ) {
        Map<String, Object> result = new HashMap<>();

        try {
            // 1. JSP에서 전송한 검침년월과 검침 목록을 꺼냅니다.
            String billYm = (String) body.get("billYm");
            List<Map<String, Object>> meterList =
                    (List<Map<String, Object>>) body.get("meterList");

            // 2. 기본값 검증
            if (billYm == null || billYm.isBlank()) {
                result.put("success", false);
                result.put("message", "검침년월을 선택해 주세요.");
                return ResponseEntity.ok(result);
            }

            if (meterList == null || meterList.isEmpty()) {
                result.put("success", false);
                result.put("message", "저장할 검침값이 없습니다.");
                return ResponseEntity.ok(result);
            }

            // 3. 관리사무소가 관리하는 아파트 단지번호를 조회합니다.
            AptComplexVO aptComplexVO =
                    aptComplexService.selectMgmtOfcNoAptComplex(mgmtOfcNo);

            if (aptComplexVO == null) {
                result.put("success", false);
                result.put("message", "관리사무소에 연결된 아파트 단지 정보가 없습니다.");
                return ResponseEntity.ok(result);
            }

            // 4. 실제 저장 처리는 Service에 전달합니다.
            Map<String, Object> saveResult =
                    meterChargeService.saveMeterCharge(
                            aptComplexVO.getAptCmplexNo(),
                            billYm,
                            meterList
                    );

            // 5. 저장 성공 결과 반환
            result.put("success", true);
            result.put("message", "검침값 저장이 완료되었습니다.");
            result.putAll(saveResult);

        } catch (Exception e) {
            log.error("검침값 저장 실패", e);

            result.put("success", false);
            result.put("message", e.getMessage());
        }

        return ResponseEntity.ok(result);
    }

    // 고지서 등록
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/bill/issue/{mgmtOfcNo}")
    public String billIssue(
            @PathVariable String mgmtOfcNo,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {
        managerAccessService.addManagerViewModel(model, customUser, mgmtOfcNo);
        return "apt/mgmtOffice/bill/mngr_billIssue";
    }

    // 고지서 동 목록 조회
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/bill/issue/dong-list/{mgmtOfcNo}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> selectBillDongList(
            @PathVariable String mgmtOfcNo
    ) {
        Map<String, Object> result = new HashMap<>();

        try {
            AptComplexVO aptComplexVO = aptComplexService.selectMgmtOfcNoAptComplex(mgmtOfcNo);

            if (aptComplexVO == null) {
                result.put("success", false);
                result.put("message", "관리사무소에 연결된 아파트 단지 정보가 없습니다.");
                return ResponseEntity.ok(result);
            }

            List<BillVO> dongList =
                    billIssueService.selectBillDongList(aptComplexVO.getAptCmplexNo());

            result.put("success", true);
            result.put("dongList", dongList);

        } catch (Exception e) {
            log.error("고지서 동 목록 조회 실패", e);
            result.put("success", false);
            result.put("message", e.getMessage());
        }

        return ResponseEntity.ok(result);
    }

    // 고지서 목록 조회
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/bill/issue/list/{mgmtOfcNo}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> selectBillIssueList(
            @PathVariable String mgmtOfcNo,
            @RequestParam(required = false) String billYm,
            @RequestParam(required = false) String pymtSttsCd,
            @RequestParam(required = false) String dongNo,
            @RequestParam(required = false) String ho,
            @RequestParam(defaultValue = "1") int currentPage
    ) {
        Map<String, Object> result = new HashMap<>();

        try {
            AptComplexVO aptComplexVO = aptComplexService.selectMgmtOfcNoAptComplex(mgmtOfcNo);

            if (aptComplexVO == null) {
                result.put("success", false);
                result.put("message", "관리사무소에 연결된 아파트 단지 정보가 없습니다.");
                return ResponseEntity.ok(result);
            }

            BillVO searchVO = new BillVO();
            searchVO.setAptCmplexNo(aptComplexVO.getAptCmplexNo());
            searchVO.setBillYm(billYm);
            searchVO.setPymtSttsCd(pymtSttsCd);
            searchVO.setDongNo(dongNo);
            searchVO.setHo(ho);

            PaginationInfoVO<BillVO> pagingVO = new PaginationInfoVO<>(20, 10);
            pagingVO.setSearchVO(searchVO);
            pagingVO.setCurrentPage(currentPage);

            pagingVO = billIssueService.selectBillIssueList(pagingVO);


            long pageTotalAmount = 0L;
            if (pagingVO.getDataList() != null) {
                for (BillVO billVO : pagingVO.getDataList()) {
                    if (billVO.getBillTotAmt() != null) {
                        pageTotalAmount += billVO.getBillTotAmt();
                    }
                }
            }

            result.put("success", true);
            result.put("list", pagingVO.getDataList());
            result.put("totalCount", pagingVO.getTotalRecord());
            result.put("totalPage", pagingVO.getTotalPage());
            result.put("currentPage", pagingVO.getCurrentPage());
            result.put("startPage", pagingVO.getStartPage());
            result.put("endPage", pagingVO.getEndPage());
            result.put("screenSize", pagingVO.getScreenSize());
            result.put("pagingHTML", pagingVO.getPagingHTML());
            result.put("pageTotalAmount", pageTotalAmount);

        } catch (Exception e) {
            log.error("고지서 목록 조회 실패", e);
            result.put("success", false);
            result.put("message", e.getMessage());
        }

        return ResponseEntity.ok(result);
    }

    // 고지서 상세 조회
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/bill/issue/detail/{mgmtOfcNo}/{billNo}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> selectBillIssueDetail(
            @PathVariable String mgmtOfcNo,
            @PathVariable String billNo
    ) {
        Map<String, Object> result = new HashMap<>();

        try {
            AptComplexVO aptComplexVO = aptComplexService.selectMgmtOfcNoAptComplex(mgmtOfcNo);

            if (aptComplexVO == null) {
                result.put("success", false);
                result.put("message", "관리사무소에 연결된 아파트 단지 정보가 없습니다.");
                return ResponseEntity.ok(result);
            }

            BillVO billVO = billIssueService.selectBillIssueDetail(
                    aptComplexVO.getAptCmplexNo(),
                    billNo
            );

            result.put("success", true);
            result.put("bill", billVO);

        } catch (Exception e) {
            log.error("고지서 상세 조회 실패", e);
            result.put("success", false);
            result.put("message", e.getMessage());
        }

        return ResponseEntity.ok(result);
    }

    // 관리비 항목 요약
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/bill/item-summary/{mgmtOfcNo}")
    public String billItemSummary(
            @PathVariable String mgmtOfcNo,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {
        managerAccessService.addManagerViewModel(model, customUser, mgmtOfcNo);
        return "apt/mgmtOffice/mngr_billItemSummary";
    }

    // 연체 관리
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/account/arrears/{mgmtOfcNo}")
    public String accountArrears(
            @PathVariable String mgmtOfcNo,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {
        managerAccessService.addManagerViewModel(model, customUser, mgmtOfcNo);
        return "apt/mgmtOffice/mngr_accountArrears";
    }
}
