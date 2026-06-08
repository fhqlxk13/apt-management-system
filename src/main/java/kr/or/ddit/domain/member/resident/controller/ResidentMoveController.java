package kr.or.ddit.domain.member.resident.controller;

import kr.or.ddit.domain.member.resident.service.IResidentMoveService;
import kr.or.ddit.domain.member.vo.CustomUser;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@Slf4j
@RestController
@RequestMapping("/resident")
@RequiredArgsConstructor
public class ResidentMoveController {

    private final IResidentMoveService residentMoveService;

    // 호수 목록 조회 (비동기)
    @GetMapping("/service/moving/hoList")
    public Object getHoList(@RequestParam String userNo,
                            @RequestParam String aptCmplexNo) {
        return residentMoveService.selectHoList(userNo, aptCmplexNo);
    }

    // 전입신고 POST
    @PostMapping("/service/moving/in")
    public Map<String, Object> insertMoveIn(
            @RequestBody Map<String, Object> params,
            @AuthenticationPrincipal CustomUser principal) {
        Map<String, Object> result = new HashMap<>();
        try {
            params.put("userNo", principal.getMember().getUserNo());
            residentMoveService.insertMoveIn(params);
            result.put("success", true);
        } catch (Exception e) {
            log.error("전입신고 오류: {}", e.getMessage());
            result.put("success", false);
        }
        return result;
    }

    // 전출신고 POST
    @PostMapping("/service/moving/out")
    public Map<String, Object> insertMoveOut(
            @RequestBody Map<String, Object> params,
            @AuthenticationPrincipal CustomUser principal) {
        Map<String, Object> result = new HashMap<>();
        try {
            params.put("userNo", principal.getMember().getUserNo());
            residentMoveService.insertMoveOut(params);
            result.put("success", true);
        } catch (Exception e) {
            log.error("전출신고 오류: {}", e.getMessage());
            result.put("success", false);
        }
        return result;
    }

}