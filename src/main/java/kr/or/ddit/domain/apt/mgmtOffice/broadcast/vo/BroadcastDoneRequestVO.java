package kr.or.ddit.domain.apt.mgmtOffice.broadcast.vo;

import lombok.Data;

/**
 * STOMP {@code /pub/broadcast/done} 요청 본문 (수신기 → 서버).
 * <p>
 * 수신 JS가 해당 동에서 TTS 재생을 끝냈거나 실패했을 때 송출자에게 ACK 를 돌리기 위해 전송합니다.
 */
@Data
public class BroadcastDoneRequestVO {

    private String broadcastId;
    private String mgmtOfcNo;

    /** 수신기가 담당하는 동 코드 (ACK 의 targetDongNo 로 전달) */
    private String dongNo;
    private String dongLabel;

    /** PLAY 메시지에 있던 송출자 userNo — sender 구독 경로 생성에 사용 */
    private String senderUserNo;

    /** {@code DONE} = 재생 완료, {@code FAILED} = 재생·TTS 실패 */
    private String status;
}
