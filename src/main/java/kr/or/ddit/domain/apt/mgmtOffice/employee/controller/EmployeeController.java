package kr.or.ddit.domain.apt.mgmtOffice.employee.controller;

import kr.or.ddit.domain.apt.mgmtOffice.employee.service.IEmployeeService;
import kr.or.ddit.domain.member.manager.vo.ManagerVO;
import kr.or.ddit.domain.apt.mgmtOffice.employee.DTO.MemberSearchDTO;
import kr.or.ddit.domain.apt.mgmtOffice.employee.vo.MngrRqstVO;
import kr.or.ddit.domain.member.vo.CustomUser;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Controller

/**
 * 관리사무소 직원 계정 API 컨트롤러
 *
 * @PreAuthorize("hasRole('MNGR')")
 * - 관리사무소 기능 접근 권한 확인
 * - RoleHierarchy 설정 기준 ADMIN도 MNGR 권한 상속
 * - 상세 관리사무소 번호 검사는 각 메서드의 hasAccess에서 처리
 */
@PreAuthorize("hasRole('MNGR')")
@RequestMapping("/manager/employee")
public class EmployeeController {

    @Autowired
    private IEmployeeService employeeService;

    /**
     * [재직 직원 목록 조회]
     * GET /manager/employee/list/{mgmtOfcNo}
     *
     * @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
     * - URL의 mgmtOfcNo 접근 권한 확인
     * - ADMIN은 전체 관리사무소 접근 가능
     * - MNGR은 본인 소속 관리사무소만 접근 가능
     *
     * @ResponseBody
     * - JSP 이동이 아닌 JSON 응답
     *
     * @PathVariable
     * - URL의 관리사무소 번호
     *
     * @RequestParam(required = false, defaultValue = "")
     * - 검색조건 선택값
     * - 값이 없을 때 빈 문자열 처리
     * - XML에서 빈 문자열이면 조건 제외*/
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/list/{mgmtOfcNo}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> selectEmployeeList(
            @PathVariable String mgmtOfcNo,
            @RequestParam(required = false, defaultValue = "") String keyword,
            @RequestParam(required = false, defaultValue = "") String mngrDutyCd
    ) {
        Map<String, Object> result = new HashMap<>();

        try {
            // 검색/필터 조건 전달용 Map
            Map<String, Object> paramMap = new HashMap<>();
            paramMap.put("mgmtOfcNo", mgmtOfcNo);
            paramMap.put("keyword", keyword);
            paramMap.put("mngrDutyCd", mngrDutyCd);

            // 재직 직원 목록
            List<ManagerVO> list = employeeService.selectEmployeeList(paramMap);
            result.put("list", list);

        } catch (Exception e) {
            log.error("재직 직원 목록 조회 오류", e);
            result.put("list", new ArrayList<>());
        }

        // HTTP 200 + JSON 응답
        return ResponseEntity.ok(result);
    }

    /**
     * [재직 직원 상세 조회]
     * GET /manager/employee/{userNo}/detail/{mgmtOfcNo}
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/{userNo}/detail/{mgmtOfcNo}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> selectEmployeeDetail(
            @PathVariable String userNo,
            @PathVariable String mgmtOfcNo
    ) {
        Map<String, Object> result = new HashMap<>();

        try {
            // 관리사무소 번호 + 직원 번호 기준 상세 조회
            ManagerVO detail = employeeService.selectEmployeeDetail(userNo, mgmtOfcNo);
            result.put("detail", detail);

        } catch (Exception e) {
            log.error("재직 직원 상세 조회 오류", e);
            result.put("detail", null);
        }

        return ResponseEntity.ok(result);
    }

    /**
     * [재직 직원 직무 수정]
     * POST /manager/employee/duty/update/{mgmtOfcNo}
     *
     * @param mgmtOfcNo 요청 URL의 관리사무소 번호
     * @param vo 수정할 직원 직무 정보
     * @return 직무 수정 처리 결과
     * - ADMIN 조회 전용 정책
     * - ADMIN의 등록/수정/삭제/취소/비활성화 처리 차단
     - MNGR만 실제 처리 가능
     */
    @PreAuthorize("@authService.canMgmtCrud(principal, #mgmtOfcNo)")
    @PostMapping("/duty/update/{mgmtOfcNo}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> updateEmployeeDuty(
            @PathVariable String mgmtOfcNo,
            @RequestBody ManagerVO vo
    ) {
        Map<String, Object> result = new HashMap<>();

        try {
            // URL 관리사무소 번호를 수정 조건으로 사용
            vo.setMgmtOfcNo(mgmtOfcNo);

            // 직원 직무 수정 결과
            boolean success = employeeService.updateEmployeeDuty(vo);

            result.put("success", success);
            result.put("message", success ? "직무가 수정되었습니다." : "직무 수정에 실패했습니다.");

        } catch (Exception e) {
            log.error("재직 직원 직무 수정 오류", e);
            result.put("success", false);
            result.put("message", "처리 중 오류가 발생했습니다.");
        }

        return ResponseEntity.ok(result);
    }

    /**
     * [직원 계정 요청 목록 조회]
     * GET /manager/employee/request/list/{mgmtOfcNo}
     *
     * keyword    : 요청자 이름/아이디/연락처 검색
     * rqstDutyCd : 요청 직무 필터
     * rqstSttsCd : 요청 상태 필터
     * dateType/searchDate : 요청일/처리일 기준 날짜 필터
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/request/list/{mgmtOfcNo}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> selectRequestList(
            @PathVariable String mgmtOfcNo,
            @RequestParam(required = false, defaultValue = "") String keyword,
            @RequestParam(required = false, defaultValue = "") String rqstDutyCd,
            @RequestParam(required = false, defaultValue = "") String rqstSttsCd,
            @RequestParam(required = false, defaultValue = "RQST") String dateType,
            @RequestParam(required = false, defaultValue = "") String searchDate
    ) {
        Map<String, Object> result = new HashMap<>();

        try {
            // 요청 목록 검색/필터 조건
            Map<String, Object> paramMap = new HashMap<>();
            paramMap.put("mgmtOfcNo", mgmtOfcNo);
            paramMap.put("keyword", keyword);
            paramMap.put("rqstDutyCd", rqstDutyCd);
            paramMap.put("rqstSttsCd", rqstSttsCd);
            paramMap.put("dateType", dateType);
            paramMap.put("searchDate", searchDate);

            // 직원 계정 요청 목록
            List<MngrRqstVO> list = employeeService.selectRequestList(paramMap);
            result.put("list", list);

        } catch (Exception e) {
            log.error("직원 계정 요청 목록 조회 오류", e);
            result.put("list", new ArrayList<>());
        }

        return ResponseEntity.ok(result);
    }

    /**
     * [직원 계정 요청 상세 조회]
     * GET /manager/employee/request/{rqstNo}/detail/{mgmtOfcNo}
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/request/{rqstNo}/detail/{mgmtOfcNo}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> selectRequestDetail(
            @PathVariable String rqstNo,
            @PathVariable String mgmtOfcNo
    ) {
        Map<String, Object> result = new HashMap<>();

        try {
            // 관리사무소 번호 + 요청 번호 기준 상세 조회
            MngrRqstVO detail = employeeService.selectRequestDetail(rqstNo, mgmtOfcNo);
            result.put("detail", detail);

        } catch (Exception e) {
            log.error("직원 계정 요청 상세 조회 오류", e);
            result.put("detail", null);
        }

        return ResponseEntity.ok(result);
    }

    /**
     * [직원 계정 요청 등록]
     * POST /manager/employee/request/insert/{mgmtOfcNo}
     */
    @PreAuthorize("@authService.canMgmtCrud(principal, #mgmtOfcNo)")
    @PostMapping("/request/insert/{mgmtOfcNo}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> insertRequest(
            @PathVariable String mgmtOfcNo,
            @RequestBody MngrRqstVO vo,
            @AuthenticationPrincipal CustomUser customUser
    ) {
        Map<String, Object> result = new HashMap<>();

        try {
            // 요청 등록자 USER_NO
            vo.setUserNo(customUser.getMember().getUserNo());

            // 직원 계정 요청 등록 결과
            boolean success = employeeService.insertRequest(vo, mgmtOfcNo);

            result.put("success", success);
            result.put("message", success ? "요청이 등록되었습니다." : "등록에 실패했습니다.");

        } catch (Exception e) {
            log.error("직원 계정 요청 등록 오류", e);
            result.put("success", false);
            result.put("message", "처리 중 오류가 발생했습니다.");
        }

        return ResponseEntity.ok(result);
    }

    /**
     * [직원 계정 요청 수정]
     * POST /manager/employee/request/update/{mgmtOfcNo}
     */
    @PreAuthorize("@authService.canMgmtCrud(principal, #mgmtOfcNo)")
    @PostMapping("/request/update/{mgmtOfcNo}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> updateRequest(
            @PathVariable String mgmtOfcNo,
            @RequestBody MngrRqstVO vo
    ) {
        Map<String, Object> result = new HashMap<>();

        try {
            // 직원 계정 요청 수정 결과
            boolean success = employeeService.updateRequest(vo, mgmtOfcNo);

            result.put("success", success);
            result.put("message", success ? "요청이 수정되었습니다." : "수정에 실패했습니다.");

        } catch (Exception e) {
            log.error("직원 계정 요청 수정 오류", e);
            result.put("success", false);
            result.put("message", "처리 중 오류가 발생했습니다.");
        }

        return ResponseEntity.ok(result);
    }

    /**
     * [직원 계정 요청 취소]
     * POST /manager/employee/request/cancel/{mgmtOfcNo}
     */
    @PreAuthorize("@authService.canMgmtCrud(principal, #mgmtOfcNo)")
    @PostMapping("/request/cancel/{mgmtOfcNo}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> cancelRequest(
            @PathVariable String mgmtOfcNo,
            @RequestBody MngrRqstVO vo
    ) {
        Map<String, Object> result = new HashMap<>();

        try {
            // 직원 계정 요청 취소 결과
            boolean success = employeeService.cancelRequest(vo, mgmtOfcNo);

            result.put("success", success);
            result.put("message", success ? "요청이 취소되었습니다." : "취소에 실패했습니다.");

        } catch (Exception e) {
            log.error("직원 계정 요청 취소 오류", e);
            result.put("success", false);
            result.put("message", "처리 중 오류가 발생했습니다.");
        }

        return ResponseEntity.ok(result);
    }

    /**
     * [직원 등록용 회원 검색]
     * GET /manager/employee/member/search/{mgmtOfcNo}?keyword=홍길동
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/member/search/{mgmtOfcNo}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> selectMemberSearchList(
            @PathVariable String mgmtOfcNo,
            @RequestParam(required = false, defaultValue = "") String keyword
    ) {
        Map<String, Object> result = new HashMap<>();

        try {
            // 직원 등록 가능 회원 목록
            List<MemberSearchDTO> list = employeeService.selectMemberSearchList(keyword, mgmtOfcNo);
            result.put("list", list);

        } catch (Exception e) {
            log.error("직원 등록용 회원 검색 오류", e);
            result.put("list", new ArrayList<>());
        }

        return ResponseEntity.ok(result);
    }
}
