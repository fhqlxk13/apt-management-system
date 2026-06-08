package kr.or.ddit.domain.apt.mgmtOffice.broadcast.dto;

import lombok.Data;

/**
 * 방송 관련 DTO (예비·미사용).
 * <p>
 * 현재 송출·수신 흐름은 WebSocket VO({@code vo} 패키지)와
 * TTS API의 raw {@code byte[]} 응답만 사용하며, 이 클래스를 참조하는 코드는 없습니다.
 * 향후 REST로 Base64 오디오를 내려줄 때 재사용할 수 있습니다.
 */
@Data
public class BroadcastDTO {

    /** Base64 인코딩된 MP3 (미사용 필드) */
    private String audioBase64;

    /** 대상 동 표시명 (미사용 필드) */
    private String dong;
}
