package kr.or.ddit.domain.central.admin.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import kr.or.ddit.domain.central.admin.service.IMngrRqstAprvService;
import kr.or.ddit.domain.central.admin.dto.MngrRqstAprvDTO;
import lombok.RequiredArgsConstructor;

/**
 * 중앙관리자의 단지관리자 직원계정 승인 Controller
 */
@RestController
@RequiredArgsConstructor
@RequestMapping("/centralAdmin/mngrRqstAprv")
@PreAuthorize("hasRole('ADMIN')")  /* 중앙관리자만 허용 */
public class MngrRqstAprvController {

    private final IMngrRqstAprvService service;


    /*
     * 주의:
     * @GetMapping
     * public String page(...)ㅋ
     * 이 메서드는 만들면 안 된다.
     *
     * 이유:
     * ContractController#subAdminForm()이 이미
     * GET /central/subAdmin 주소를 사용하고 있기 때문이다.
     */

    /** 신청 계정 목록 조회 */
    /*@GetMapping("/requests")
    @ResponseBody
    public List<MngrRqstAprvDTO> requestList(@ModelAttribute MngrRqstAprvDTO aprvDTO) {
        return service.getRequestList(aprvDTO);
    }*/

    /** 승인 완료 후 실제 계정 목록 조회 */
    @GetMapping("/accounts")
    @ResponseBody
    public List<MngrRqstAprvDTO> accountList(@ModelAttribute MngrRqstAprvDTO aprvDTO) {
        return service.getAccountList(aprvDTO);
    }

    /** 계정 상세 조회 */
    @GetMapping("/accounts/{userNo}")
    @ResponseBody
    public MngrRqstAprvDTO accountDetail(@PathVariable String userNo) {
        return service.getAccount(userNo);
    }


    /** 신청 계정 수정 */
    @PutMapping("/requests/{rqstNo}")
    @ResponseBody
    public Map<String, Object> updateRequest(@PathVariable String rqstNo, @RequestBody MngrRqstAprvDTO vo) {
        vo.setRqstNo(rqstNo);
        return result(service.updateRequest(vo));
    }

    /**
     * 신청 계정 승인
     * 승인 시 MEMBER, AUTH, MANAGER 테이블에 실제 계정을 생성한다.
     */
    @PostMapping("/requests/{rqstNo}/approve")
    @ResponseBody
    public Map<String, Object> approve(@PathVariable String rqstNo) {
        // TODO 로그인 연동 후에는 SecurityContext에서 로그인한 중앙관리자 ID를 가져오면 된다.
        String aprvId = "central_admin";
        return result(service.approveRequest(rqstNo, aprvId));
    }

    /** 신청 계정 반려 */
    @PostMapping("/requests/{rqstNo}/reject")
    @ResponseBody
    public Map<String, Object> reject(@PathVariable String rqstNo, @RequestBody MngrRqstAprvDTO vo) {
        String aprvId = "central_admin";
        return result(service.rejectRequest(rqstNo, aprvId, vo.getRjctRsnCn()));
    }

    /** 신청 계정 삭제 */
    @DeleteMapping("/requests/{rqstNo}")
    @ResponseBody
    public Map<String, Object> deleteRequest(@PathVariable String rqstNo) {
        return result(service.deleteRequest(rqstNo));
    }


    /** 계정 사용/미사용 변경 */
    @PutMapping("/accounts/{userNo}/use")
    @ResponseBody
    public Map<String, Object> updateUseYn(@PathVariable String userNo, @RequestBody MngrRqstAprvDTO vo) {
        return result(service.updateAccountUseYn(userNo, vo.getUserYn()));
    }

    /** 계정 삭제 */
    @DeleteMapping("/accounts/{userNo}")
    @ResponseBody
    public Map<String, Object> deleteAccount(@PathVariable String userNo) {
        return result(service.deleteAccount(userNo));
    }

    /**
     * 공통 응답 형식
     * JSON이란?
     * → 자바스크립트에서 읽기 쉬운 데이터 형식. fetch/AJAX 응답으로 많이 사용한다.
     */
    private Map<String, Object> result(int cnt) {
        Map<String, Object> map = new HashMap<>();
        map.put("success", cnt > 0);
        map.put("count", cnt);
        return map;
    }

    /* 중앙관리자 - 단지관리자 관리 승인여부쪽  */
    @PostMapping("/requests/{rqstNo}/add-account")
    @ResponseBody
    public ResponseEntity<?> addApprovedAccount(@PathVariable String rqstNo) {
        service.addApprovedAccount(rqstNo);
        return ResponseEntity.ok(Map.of("result", "OK"));
    }



}
