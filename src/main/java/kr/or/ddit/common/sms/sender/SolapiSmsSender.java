package kr.or.ddit.common.sms.sender;

import kr.or.ddit.common.sms.dto.SmsReceiver;
import lombok.extern.slf4j.Slf4j;
import net.nurigo.sdk.NurigoApp;
import net.nurigo.sdk.message.model.Message;
import net.nurigo.sdk.message.service.DefaultMessageService;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Component;

@Slf4j
@Component
@ConditionalOnProperty(name = "sms.sender-type", havingValue = "solapi")
public class SolapiSmsSender implements SmsSender {

    @Value("${solapi.api-key}")
    private String apiKey;

    @Value("${solapi.api-secret}")
    private String apiSecret;

    @Value("${solapi.from}")
    private String from;

    @Override
    public void send(SmsReceiver receiver, String message) {

        DefaultMessageService messageService =
                NurigoApp.INSTANCE.initialize(
                        apiKey,
                        apiSecret,
                        "https://api.coolsms.co.kr"
                );

        Message solapiMessage = new Message();

        String to = receiver.getUserTel().replaceAll("[^0-9]", "");
        String sender = from.replaceAll("[^0-9]", "");

        solapiMessage.setFrom(sender);
        solapiMessage.setTo(to);
        solapiMessage.setText(message);

        try {
            messageService.send(solapiMessage);

            log.info("Solapi SMS 실제 발송 요청 완료 - to={}", to);

        } catch (Exception e) {
            log.error("Solapi SMS 발송 실패 - to={}, error={}", to, e.getMessage(), e);

            throw new RuntimeException("Solapi SMS 발송 실패: " + e.getMessage(), e);
        }
    }
}