package kr.or.ddit.common.sms.sender;

import kr.or.ddit.common.sms.dto.SmsReceiver;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Component;

/**
 * Mock 문자 발송기
 * 실제 문자는 보내지 않고 콘솔 로그만 출력.
 * @ConditionalOnProperty (-> SMS 기능을 Mock ↔ 실제 발송으로 전환 시 사용.)
 * (-> 이게 있음 콘트롤러,서비스,매퍼 수정안하고, application.properties만 변경하면 됨.)
 */
@Slf4j
@Component
@ConditionalOnProperty(name = "sms.sender-type", havingValue = "mock", matchIfMissing = true)
public class MockSmsSender implements SmsSender {

    @Override
    public void send(SmsReceiver receiver, String message) {
        log.info("========== MOCK SMS ==========");
        log.info("수신자 USER_NO : {}", receiver.getUserNo());
        log.info("수신번호 : {}", receiver.getUserTel());
        log.info("내용 : {}", message);
        log.info("==============================");
    }
}