package kr.or.ddit.domain.apt.mgmtOffice.broadcast.vo;

import lombok.Data;

/**
 * 서버 → 송출자 STOMP 메시지 (action = {@code ACK}).
 * <p>
 * Publish 경로: {@code /sub/broadcast/sender/{mgmtOfcNo}/{topicKey(senderUserNo)}}
 * <p>
 * 송출 JS {@code mngr-broadcast.js} 가 구독하여 동별 완료·실패를 모아 「방송 송출 완료」 토스트를 냅니다.
 */
@Data
public class BroadcastAckMessageVO {

    /** 고정값 "ACK" */
    private String action;

    private String broadcastId;
    private String mgmtOfcNo;
    private String targetDongNo;
    private String targetDongLabel;
    private String senderUserNo;

    /** {@code DONE} | {@code FAILED} */
    private String status;
}
