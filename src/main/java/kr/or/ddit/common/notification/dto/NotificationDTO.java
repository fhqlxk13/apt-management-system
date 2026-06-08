package kr.or.ddit.common.notification.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class NotificationDTO {

    private String title;
    private String message;
    private String type;
    private String url;


    /*  굳이 메서드 안쓰고 builder 써도 됨
    *   success 는 제목, 메시지, + (url) 이렇게 넣어주면 됨
    *   notificationService.Send( userNo, NotificationDTO. + success or error info)
    *  */
    public static NotificationDTO success(String title, String message) {
        return NotificationDTO.builder()
                .title(title)
                .message(message)
                .type("success")
                .build();
    }

    public static NotificationDTO success(String title,String message,String url) {

        return NotificationDTO.builder()
                .title(title)
                .message(message)
                .type("success")
                .url(url)
                .build();
    }

    public static NotificationDTO error(String title, String message) {

        return NotificationDTO.builder()
                .title(title)
                .message(message)
                .type("error")
                .build();
    }

    public static NotificationDTO info(String title, String message, String url) {

        return NotificationDTO.builder()
                .title(title)
                .message(message)
                .type("info")
                .url(url)
                .build();
    }
}