package kr.or.ddit.domain.apt.mgmtOffice.broadcast.controller;

import kr.or.ddit.common.config.AuthService;
import kr.or.ddit.domain.apt.mgmtOffice.broadcast.vo.BroadcastAckMessageVO;
import kr.or.ddit.domain.apt.mgmtOffice.broadcast.vo.BroadcastDongTargetVO;
import kr.or.ddit.domain.apt.mgmtOffice.broadcast.vo.BroadcastDoneRequestVO;
import kr.or.ddit.domain.apt.mgmtOffice.broadcast.vo.BroadcastPlayMessageVO;
import kr.or.ddit.domain.apt.mgmtOffice.broadcast.vo.BroadcastStartRequestVO;
import kr.or.ddit.domain.member.vo.CustomUser;
import lombok.RequiredArgsConstructor;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;

import java.security.Principal;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * 관리사무소 방송 — <b>STOMP WebSocket</b> 메시지 처리.
 * <p>
 * Spring {@link org.springframework.messaging.simp.SimpMessagingTemplate} 로
 * Simple Broker({@code /sub/**}) 에 publish 합니다.
 * 클라이언트는 {@code WebSocketConfig} 의 {@code /ws} (SockJS) 로 연결 후
 * {@code /pub/broadcast/*} 로 send, {@code /sub/broadcast/*} 로 subscribe 합니다.
 * <p>
 * <b>송출 시작</b> — 클라이언트: {@code stomp.send('/pub/broadcast/start', {}, json)}
 * <br>서버: 대상 동마다 {@code /sub/broadcast/{mgmtOfcNo}/{topicKey(dongNo)}} 에
 * {@link BroadcastPlayMessageVO} (action=PLAY) 전송.
 * <p>
 * <b>수신 완료 ACK</b> — 수신기: {@code stomp.send('/pub/broadcast/done', {}, json)}
 * <br>서버: {@code /sub/broadcast/sender/{mgmtOfcNo}/{topicKey(senderUserNo)}} 에
 * {@link BroadcastAckMessageVO} (action=ACK) 전송 → 송출 화면이 완료·실패 집계.
 * <p>
 * topicKey 규칙: dongNo·userNo 의 {@code /} → {@code _}, 공백 → {@code _} (송출·수신 JS와 동일해야 함).
 */
@Controller
@RequiredArgsConstructor
public class ManagerBroadcastWsController {

    private final SimpMessagingTemplate messagingTemplate;
    private final AuthService authService;

    /**
     * 방송 송출 명령 처리.
     * <p>
     * 요청 본문: {@link BroadcastStartRequestVO} (JSON).
     * {@code targets} 가 비어 있으면 아무 구독자에게도 전달하지 않음.
     * 「전체」 선택 여부는 서버가 판단하지 않고, 클라이언트가 보낸 targets 목록만 사용합니다.
     */
    @MessageMapping("/broadcast/start")
    public void startBroadcast(BroadcastStartRequestVO request, Principal principal) {
        if (request == null || principal == null || !(principal instanceof Authentication auth)) {
            return;
        }
        if (!(auth.getPrincipal() instanceof CustomUser user)) {
            return;
        }

        String mgmtOfcNo = trim(request.getMgmtOfcNo());
        String text = trim(request.getText());
        if (mgmtOfcNo.isEmpty() || text.isEmpty()) {
            return;
        }
        if (!authService.hasAccess(user, mgmtOfcNo)) {
            return;
        }

        List<BroadcastDongTargetVO> targets = normalizeTargets(request.getTargets());
        if (targets.isEmpty()) {
            return;
        }

        String languageCode = defaultIfBlank(request.getLanguageCode(), "ko-KR");
        String voiceName = defaultIfBlank(request.getVoiceName(), "ko-KR-Standard-C");
        List<String> areas = request.getAreas() != null ? request.getAreas() : List.of("전체");

        long sentAt = System.currentTimeMillis();
        String senderUserNo = user.getMember().getUserNo();
        String senderUserNm = user.getMember().getUserNm();
        String broadcastId = defaultIfBlank(request.getBroadcastId(), UUID.randomUUID().toString());

        for (BroadcastDongTargetVO target : targets) {
            String dongNo = trim(target.getDongNo());
            if (dongNo.isEmpty()) {
                continue;
            }

            BroadcastPlayMessageVO payload = new BroadcastPlayMessageVO();
            payload.setAction("PLAY");
            payload.setMgmtOfcNo(mgmtOfcNo);
            payload.setText(text);
            payload.setLanguageCode(languageCode);
            payload.setVoiceName(voiceName);
            payload.setAreas(areas);
            payload.setTargetDongNo(dongNo);
            payload.setTargetDongLabel(defaultIfBlank(target.getDongLabel(), dongNo));
            payload.setSenderUserNo(senderUserNo);
            payload.setSenderUserNm(senderUserNm);
            payload.setSentAt(sentAt);
            payload.setBroadcastId(broadcastId);

            messagingTemplate.convertAndSend(
                    "/sub/broadcast/" + mgmtOfcNo + "/" + topicKey(dongNo),
                    payload
            );
        }
    }

    /**
     * 동별 수신기 재생 완료(또는 실패) 보고.
     * <p>
     * 수신 JS가 TTS 재생 종료·오류 시 호출하며, 송출자 전용 구독 경로로 ACK 를 돌려줍니다.
     */
    @MessageMapping("/broadcast/done")
    public void broadcastDone(BroadcastDoneRequestVO request, Principal principal) {
        if (request == null || principal == null || !(principal instanceof Authentication auth)) {
            return;
        }
        if (!(auth.getPrincipal() instanceof CustomUser user)) {
            return;
        }

        String mgmtOfcNo = trim(request.getMgmtOfcNo());
        String broadcastId = trim(request.getBroadcastId());
        String dongNo = trim(request.getDongNo());
        String senderUserNo = trim(request.getSenderUserNo());
        String status = trim(request.getStatus());
        if (mgmtOfcNo.isEmpty() || broadcastId.isEmpty() || dongNo.isEmpty() || senderUserNo.isEmpty()) {
            return;
        }
        if (!authService.hasAccess(user, mgmtOfcNo)) {
            return;
        }
        if (!"DONE".equals(status) && !"FAILED".equals(status)) {
            status = "FAILED";
        }

        BroadcastAckMessageVO ack = new BroadcastAckMessageVO();
        ack.setAction("ACK");
        ack.setBroadcastId(broadcastId);
        ack.setMgmtOfcNo(mgmtOfcNo);
        ack.setTargetDongNo(dongNo);
        ack.setTargetDongLabel(defaultIfBlank(request.getDongLabel(), dongNo));
        ack.setSenderUserNo(senderUserNo);
        ack.setStatus(status);

        messagingTemplate.convertAndSend(
                "/sub/broadcast/sender/" + mgmtOfcNo + "/" + topicKey(senderUserNo),
                ack
        );
    }

    /** 클라이언트 targets 배열 정제 (null·빈 dongNo 제거). */
    private List<BroadcastDongTargetVO> normalizeTargets(List<BroadcastDongTargetVO> raw) {
        List<BroadcastDongTargetVO> out = new ArrayList<>();
        if (raw == null) {
            return out;
        }
        for (BroadcastDongTargetVO t : raw) {
            if (t == null) {
                continue;
            }
            String dongNo = trim(t.getDongNo());
            if (dongNo.isEmpty()) {
                continue;
            }
            BroadcastDongTargetVO copy = new BroadcastDongTargetVO();
            copy.setDongNo(dongNo);
            copy.setDongLabel(defaultIfBlank(t.getDongLabel(), dongNo));
            out.add(copy);
        }
        return out;
    }

    /** STOMP destination 세그먼트용 — JS topicKey / topicKeySegment 와 동일 규칙. */
    private String topicKey(String dongNo) {
        return dongNo.replace("/", "_").replace(" ", "_");
    }

    private String trim(String s) {
        return s == null ? "" : s.trim();
    }

    private String defaultIfBlank(String value, String fallback) {
        String v = trim(value);
        return v.isEmpty() ? fallback : v;
    }
}
