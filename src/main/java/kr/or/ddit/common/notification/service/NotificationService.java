package kr.or.ddit.common.notification.service;

import kr.or.ddit.common.notification.dto.NotificationDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class NotificationService {

    private final SimpMessagingTemplate messagingTemplate;

    public void send(
            String userNo,
            NotificationDTO notification
    ) {

        String destination = "/sub/notification/" + userNo;

        messagingTemplate.convertAndSend(
                destination,
                (Object) notification
        );
    }
}