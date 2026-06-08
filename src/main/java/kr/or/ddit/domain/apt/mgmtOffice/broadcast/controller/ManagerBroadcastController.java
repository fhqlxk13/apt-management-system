package kr.or.ddit.domain.apt.mgmtOffice.broadcast.controller;

import kr.or.ddit.domain.apt.mgmtOffice.broadcast.service.ManagerBroadcastServiceImpl;
import kr.or.ddit.domain.member.vo.CustomUser;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

/**
 * 관리사무소 방송 — <b>HTTP TTS(음성 합성)</b> API.
 * <p>
 * WebSocket 송출·ACK는 {@link ManagerBroadcastWsController} 가 담당하고,
 * 이 컨트롤러는 <b>텍스트 → MP3 바이트</b> 변환만 제공합니다.
 * <p>
 * 호출 주체:
 * <ul>
 *   <li>송출 화면 {@code mngr-broadcast.js} — 「음성 변환」, 「미리듣기」</li>
 *   <li>수신 화면 {@code mngr-broadcast-receive.js} — WS PLAY 수신 후 동일 문구·음성으로 재합성</li>
 * </ul>
 * <p>
 * 보안: {@code @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")}
 * — 해당 관리사무소에 접근 권한이 있는 로그인 사용자만 호출 가능.
 * <p>
 * URL 예 (context-path 포함 시 앞에 붙음):
 * {@code GET|POST /tts/synthesize/{mgmtOfcNo}?text=...&languageCode=ko-KR&voiceName=ko-KR-Standard-C}
 */
@RestController
@RequiredArgsConstructor
@Slf4j
public class ManagerBroadcastController {

    private final ManagerBroadcastServiceImpl managerBroadcastService;

    /**
     * GET 방식 TTS (쿼리스트링). 내부적으로 {@link #synthesize} 에 위임.
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping(value = "/tts/synthesize/{mgmtOfcNo}", produces = "audio/mpeg")
    public ResponseEntity<byte[]> synthesizeGet(
            @PathVariable String mgmtOfcNo,
            @AuthenticationPrincipal CustomUser principal,
            @RequestParam String text,
            @RequestParam(defaultValue = "ko-KR") String languageCode,
            @RequestParam(defaultValue = "ko-KR-Standard-C") String voiceName) {
        return synthesize(mgmtOfcNo, principal, text, languageCode, voiceName);
    }

    /**
     * POST 방식 TTS — 송출·수신 JS에서 주로 사용.
     *
     * @param mgmtOfcNo   관리사무소 번호 (권한 검사·로깅용; TTS 엔진에는 미전달)
     * @param text        방송 문구 (필수, 공백만 있으면 400)
     * @param languageCode BCP-47 언어 (기본 ko-KR)
     * @param voiceName   Google 음성 이름 (기본 ko-KR-Standard-C)
     * @return MP3 바이트 (audio/mpeg), 실패 시 400/422/500
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @PostMapping(value = "/tts/synthesize/{mgmtOfcNo}", produces = "audio/mpeg")
    public ResponseEntity<byte[]> synthesize(
            @PathVariable String mgmtOfcNo,
            @AuthenticationPrincipal CustomUser principal,
            @RequestParam String text,
            @RequestParam(defaultValue = "ko-KR") String languageCode,
            @RequestParam(defaultValue = "ko-KR-Standard-C") String voiceName) {
        try {
            if (text == null || text.isBlank()) {
                return ResponseEntity.badRequest().build();
            }

            byte[] audio = managerBroadcastService.convertTextToSpeech(text.trim(), languageCode, voiceName);

            if (audio == null || audio.length < 128) {
                log.warn("TTS 빈 응답 mgmtOfcNo={}, voice={}, textLen={}", mgmtOfcNo, voiceName, text.length());
                return ResponseEntity.unprocessableEntity().build();
            }

            return ResponseEntity.ok()
                    .contentType(MediaType.parseMediaType("audio/mpeg"))
                    .header(HttpHeaders.CACHE_CONTROL, "no-store")
                    .body(audio);

        } catch (Throwable t) {
            String cause = t.getMessage();
            if (t.getCause() != null && t.getCause().getMessage() != null) {
                cause = t.getCause().getMessage();
            }
            log.error("TTS 변환 실패 mgmtOfcNo={}, voice={}, textLen={}, cause={}",
                    mgmtOfcNo, voiceName, text != null ? text.length() : 0, cause, t);
            return ResponseEntity.internalServerError().build();
        }
    }
}
