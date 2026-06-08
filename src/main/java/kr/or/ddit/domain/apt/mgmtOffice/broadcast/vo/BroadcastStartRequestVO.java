package kr.or.ddit.domain.apt.mgmtOffice.broadcast.vo;

import lombok.Data;

import java.util.List;

/**
 * STOMP {@code /pub/broadcast/start} 요청 본문 (송출 PC → 서버).
 * <p>
 * 송출 JS {@code mngr-broadcast.js} 의 {@code publishBroadcastViaWebSocket} 가 JSON 으로 전송합니다.
 */
@Data
public class BroadcastStartRequestVO {

    /** 관리사무소 번호 */
    private String mgmtOfcNo;

    /** 방송 안내 문구 (수신기가 TTS 재요청할 때도 사용) */
    private String text;

    private String languageCode;
    private String voiceName;

    /** UI 선택 구역 라벨 목록 (예: ["전체"] 또는 ["101동","102동"]) — 수신 payload 에 그대로 전달 */
    private List<String> areas;

    /** 실제 WS publish 대상 동 목록. 「전체」여도 서버는 이 리스트만큼만 전송 */
    private List<BroadcastDongTargetVO> targets;

    /** 송출 세션 ID (클라이언트 생성, ACK 매칭용) */
    private String broadcastId;
}
