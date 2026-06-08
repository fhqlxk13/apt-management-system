package kr.or.ddit.domain.central.admin.controller;

import kr.or.ddit.domain.central.admin.dto.MngrRqstAprvDTO;
import kr.or.ddit.domain.central.admin.service.IMngrRqstAprvService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@Slf4j
@RequestMapping("/api/react/adm/mngrRqstAprv")
@RequiredArgsConstructor
@PreAuthorize("hasRole('ADMIN')")
public class MngrRqstAprvRestController {

    private final IMngrRqstAprvService service;

    /** 신청 계정 목록 조회 */
    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/requestList")
    public ResponseEntity<List<MngrRqstAprvDTO>> requestList(
            @ModelAttribute MngrRqstAprvDTO aprvDTO
    ) {
        return ResponseEntity.ok(service.getRequestList(aprvDTO));
    }

    /** 운영 계정 목록 조회 */
    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/accountList")
    public ResponseEntity<List<MngrRqstAprvDTO>> accountList(
            @ModelAttribute MngrRqstAprvDTO aprvDTO
    ) {
        return ResponseEntity.ok(service.getAccountList(aprvDTO));
    }

    /** 운영 계정 상세 조회 */
    @GetMapping("/account/{userNo}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<MngrRqstAprvDTO> accountDetail(
            @PathVariable String userNo
    ) {
        return ResponseEntity.ok(service.getAccount(userNo));
    }

    /** 신청 승인 */
    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/approve/{rqstNo}")
    public ResponseEntity<Map<String, Object>> approve(
            @PathVariable String rqstNo,
            Authentication authentication
    ) {
        String aprvId = authentication != null
                ? authentication.getName()
                : "central_admin";

        return ResponseEntity.ok(result(
                service.approveRequest(rqstNo, aprvId)
        ));
    }

    /** 신청 반려 */
    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/reject/{rqstNo}")
    public ResponseEntity<Map<String, Object>> reject(
            @PathVariable String rqstNo,
            @RequestBody MngrRqstAprvDTO vo,
            Authentication authentication
    ) {
        String aprvId = authentication != null
                ? authentication.getName()
                : "central_admin";

        return ResponseEntity.ok(result(
                service.rejectRequest(rqstNo, aprvId, vo.getRjctRsnCn())
        ));
    }

    /** 계정 사용/미사용 변경 */
    @PreAuthorize("hasRole('ADMIN')")
    @PutMapping("/accountUse/{userNo}")
    public ResponseEntity<Map<String, Object>> updateUseYn(
            @PathVariable String userNo,
            @RequestBody MngrRqstAprvDTO vo
    ) {
        return ResponseEntity.ok(result(
                service.updateAccountUseYn(userNo, vo.getUserYn())
        ));
    }

    private Map<String, Object> result(int cnt) {
        Map<String, Object> map = new HashMap<>();
        map.put("success", cnt > 0);
        map.put("count", cnt);
        return map;
    }
}