package kr.or.ddit.domain.apt.mgmtOffice.bill.controller;

import kr.or.ddit.domain.apt.main.service.IAptComplexService;
import kr.or.ddit.domain.apt.main.vo.AptComplexVO;
import kr.or.ddit.domain.apt.mgmtOffice.bill.mapper.IMeterChargeMapper;
import kr.or.ddit.domain.apt.mgmtOffice.bill.service.IMeterChargeService;
import kr.or.ddit.domain.apt.mgmtOffice.bill.service.IMgmtExpenseService;
import kr.or.ddit.domain.apt.mgmtOffice.bill.vo.ExpenseVO;
import kr.or.ddit.domain.apt.mgmtOffice.common.service.IManagerModelService;
import kr.or.ddit.domain.member.vo.CustomUser;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Controller
@RequestMapping("/manager")
@PreAuthorize("hasRole('MNGR')")
public class MgmtExpenseController {

    @Autowired
    private IMgmtExpenseService expenseService;

    @Autowired
    private IAptComplexService aptComplexService;

    @Autowired
    private IMeterChargeService meterChargeService;

    @Autowired
    private IManagerModelService managerAccessService;
    /**
     * 지출 등록 화면
     *
     * 화면 주소:
     * GET /manager/bill/expense/{mgmtOfcNo}
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/bill/expense/{mgmtOfcNo}")
    public String expensePage(
            @PathVariable String mgmtOfcNo,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {
        managerAccessService.addManagerViewModel(model, customUser, mgmtOfcNo);

        return "apt/mgmtOffice/bill/mngr_billExpense";
    }

    /**
     * 지출 목록 조회
     *
     * 요청 예시:
     * GET /manager/expense/MO00001?expenseYr=2026&expenseMm=5&expenseCd=SAL
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/expense/{mgmtOfcNo}")
    public ResponseEntity<Map<String, Object>> selectExpenseList(
            @PathVariable String mgmtOfcNo,
            @RequestParam(required = false) Integer expenseYr,
            @RequestParam(required = false) Integer expenseMm,
            @RequestParam(required = false) String expenseCd
    ) {
        Map<String, Object> result = new HashMap<>();

        try {
            // 1. 관리사무소 번호로 아파트 단지 정보 조회
            AptComplexVO aptComplexVO = aptComplexService.selectMgmtOfcNoAptComplex(mgmtOfcNo);

            if (aptComplexVO == null) {
                result.put("success", false);
                result.put("message", "관리사무소에 연결된 아파트 단지 정보가 없습니다.");
                return ResponseEntity.ok(result);
            }

            // 2. 연도/월이 없으면 현재 연월 기본값 사용
            LocalDate now = LocalDate.now();

            Integer searchYear = expenseYr == null ? now.getYear() : expenseYr;
            Integer searchMonth = expenseMm == null ? now.getMonthValue() : expenseMm;

            // 3. 검색 조건을 ExpenseVO에 담아서 전달
            ExpenseVO expenseVO = new ExpenseVO();
            expenseVO.setAptCmplexNo(aptComplexVO.getAptCmplexNo());
            expenseVO.setExpenseYr(searchYear);
            expenseVO.setExpenseMm(searchMonth);
            expenseVO.setExpenseCd(expenseCd);

            // 4. 지출 목록 및 합계 조회
            List<ExpenseVO> expenseList = expenseService.selectExpenseList(expenseVO);
            Integer totalAmount = expenseService.selectExpenseTotalAmount(expenseVO);

            result.put("success", true);
            result.put("list", expenseList);
            result.put("totalAmount", totalAmount);
            result.put("aptCmplexNo", aptComplexVO.getAptCmplexNo());
            result.put("expenseYr", searchYear);
            result.put("expenseMm", searchMonth);

        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }

        return ResponseEntity.ok(result);
    }

    /**
     * 지출 등록
     *
     * 요청 예시:
     * POST /manager/expense/MO00001
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @PostMapping("/expense/{mgmtOfcNo}")
    public ResponseEntity<Map<String, Object>> insertExpense(
            @PathVariable String mgmtOfcNo,
            @RequestBody ExpenseVO expenseVO
    ) {
        Map<String, Object> result = new HashMap<>();

        try {
            // 1. 관리사무소 번호로 아파트 단지 정보 조회
            AptComplexVO aptComplexVO = aptComplexService.selectMgmtOfcNoAptComplex(mgmtOfcNo);

            if (aptComplexVO == null) {
                result.put("success", false);
                result.put("message", "관리사무소에 연결된 아파트 단지 정보가 없습니다.");
                return ResponseEntity.ok(result);
            }

            /*
             * 핵심 수정:
             * EXPENSE 테이블의 APT_CMPLEX_NO는 NOT NULL이므로
             * 관리사무소 번호로 조회한 단지번호를 ExpenseVO에 반드시 세팅한다.
             */
            expenseVO.setAptCmplexNo(aptComplexVO.getAptCmplexNo());

            /*
             * 같은 단지, 같은 연도, 같은 월, 같은 지출항목은
             * 한 번만 등록할 수 있도록 중복 여부를 검사합니다.
             *
             * aptCmplexNo를 세팅한 뒤 검사해야 정확히 중복 체크된다.
             */
            int duplicateCount = expenseService.selectExpenseDuplicateCount(expenseVO);

            if (duplicateCount > 0) {
                result.put("success", false);
                result.put("message", "해당 연월에 이미 등록된 지출항목입니다.");
                return ResponseEntity.ok(result);
            }

            // 3. 등록
            int row = expenseService.insertExpense(expenseVO);

            result.put("success", row > 0);
            result.put("message", row > 0 ? "지출이 등록되었습니다." : "지출 등록에 실패했습니다.");

        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }

        return ResponseEntity.ok(result);
    }

    /**
     * 지출 수정
     *
     * 요청 예시:
     * PUT /manager/expense/MO00001/EX2605140000001
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @PutMapping("/expense/{mgmtOfcNo}/{expenseNo}")
    public ResponseEntity<Map<String, Object>> updateExpense(
            @PathVariable String mgmtOfcNo,
            @PathVariable String expenseNo,
            @RequestBody ExpenseVO expenseVO
    ) {
        Map<String, Object> result = new HashMap<>();

        try {
            // 1. 관리사무소 번호로 아파트 단지 정보 조회
            AptComplexVO aptComplexVO = aptComplexService.selectMgmtOfcNoAptComplex(mgmtOfcNo);

            if (aptComplexVO == null) {
                result.put("success", false);
                result.put("message", "관리사무소에 연결된 아파트 단지 정보가 없습니다.");
                return ResponseEntity.ok(result);
            }

            // 2. 수정 대상 번호와 단지번호를 서버에서 세팅
            expenseVO.setExpenseNo(expenseNo);
            expenseVO.setAptCmplexNo(aptComplexVO.getAptCmplexNo());

            // 3. 필수값 검증
            if (expenseVO.getExpenseYr() <= 0
                    || expenseVO.getExpenseMm() < 1
                    || expenseVO.getExpenseMm() > 12
                    || expenseVO.getExpenseCd() == null
                    || expenseVO.getExpenseCd().isBlank()
                    || expenseVO.getExpenseAmt() <= 0) {

                result.put("success", false);
                result.put("message", "연도, 월, 지출항목을 모두 선택해 주세요.");
                return ResponseEntity.ok(result);
            }

            // 4. 자기 자신을 제외하고 같은 연월, 같은 항목이 있는지 확인
            int duplicateCount = expenseService.selectExpenseDuplicateCount(expenseVO);

            if (duplicateCount > 0) {
                result.put("success", false);
                result.put("message", "해당 연월에 이미 등록된 지출항목입니다.");
                return ResponseEntity.ok(result);
            }

            // 5. 수정
            int row = expenseService.updateExpense(expenseVO);

            result.put("success", row > 0);
            result.put("message", row > 0 ? "지출이 수정되었습니다." : "수정할 지출 내역이 없습니다.");

        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }

        return ResponseEntity.ok(result);
    }

    /**
     * 지출 삭제
     *
     * 요청 예시:
     * DELETE /manager/expense/MO00001/EX2605140000001
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @DeleteMapping("/expense/{mgmtOfcNo}/{expenseNo}")
    public ResponseEntity<Map<String, Object>> deleteExpense(
            @PathVariable String mgmtOfcNo,
            @PathVariable String expenseNo
    ) {
        Map<String, Object> result = new HashMap<>();

        try {
            // 1. 관리사무소 번호로 아파트 단지 정보 조회
            AptComplexVO aptComplexVO = aptComplexService.selectMgmtOfcNoAptComplex(mgmtOfcNo);

            if (aptComplexVO == null) {
                result.put("success", false);
                result.put("message", "관리사무소에 연결된 아파트 단지 정보가 없습니다.");
                return ResponseEntity.ok(result);
            }

            // 2. 삭제 조건 VO 생성
            ExpenseVO expenseVO = new ExpenseVO();
            expenseVO.setExpenseNo(expenseNo);
            expenseVO.setAptCmplexNo(aptComplexVO.getAptCmplexNo());

            // 3. 삭제
            int row = expenseService.deleteExpense(expenseVO);

            result.put("success", row > 0);
            result.put("message", row > 0 ? "지출이 삭제되었습니다." : "삭제할 지출 내역이 없습니다.");

        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }

        return ResponseEntity.ok(result);
    }
}
