package kr.or.ddit.domain.apt.mgmtOffice.broadcast.vo;

import lombok.Data;

import java.util.List;

/**
 * 서버 → 수신기 STOMP 메시지 (action = {@code PLAY}).
 * <p>
 * Publish 경로: {@code /sub/broadcast/{mgmtOfcNo}/{topicKey(targetDongNo)}}
 * <p>
 * 수신 JS는 본문의 text·languageCode·voiceName 으로
 * {@code POST /tts/synthesize/{mgmtOfcNo}} 를 다시 호출해 MP3 를 받은 뒤 재생합니다.
 * (오디오 바이트는 WS 로 넘기지 않음 — 문구만 전달)
 */
@Data
public class BroadcastPlayMessageVO {

    /** 고정값 "PLAY" */
    private String action;

    private String mgmtOfcNo;
    private String text;
    private String languageCode;
    private String voiceName;
    private List<String> areas;

    /** 이 메시지를 받아야 할 동 코드 */
    private String targetDongNo;
    private String targetDongLabel;

    /** 송출한 관리자 userNo / 이름 (ACK·로그용) */
    private String senderUserNo;
    private String senderUserNm;

    private long sentAt;
    private String broadcastId;
}
