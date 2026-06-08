package kr.or.ddit.common.sms.sender;

import kr.or.ddit.common.sms.dto.SmsReceiver;

public interface SmsSender {

    /**
     * 실제 문자 발송 담당
     * Mock, Solapi를 같은 방식으로 호출하기 위해 인터페이스로 분리
     */
    void send(SmsReceiver receiver, String message);  // void -> 문자발송만 결과값X
}