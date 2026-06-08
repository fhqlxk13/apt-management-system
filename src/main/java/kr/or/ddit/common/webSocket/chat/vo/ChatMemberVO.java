package kr.or.ddit.common.webSocket.chat.vo;

import lombok.Data;

import java.util.Date;

@Data
public class ChatMemberVO {
    private String chatMemberId;
    private String chatRoomNo;
    private String chatroleCd;
    private String userNo;
    private Date joinDttm;
    private Date leftDttm;
}