package kr.or.ddit.domain.apt.mgmtOffice.broadcast.service;

/**
 * 방송 TTS(텍스트 → 음성) 서비스 계약.
 * <p>
 * 구현체 {@link ManagerBroadcastServiceImpl} — Google Cloud Text-to-Speech REST.
 */
public interface IManagerBroadcastService {

    /**
     * 방송 문구를 MP3 바이트로 합성합니다.
     *
     * @param text         합성할 문구
     * @param languageCode Google TTS languageCode (예: ko-KR)
     * @param voiceName    Google TTS voice name (예: ko-KR-Standard-C)
     * @return MP3 raw bytes
     */
    byte[] convertTextToSpeech(String text, String languageCode, String voiceName) throws Exception;
}
