package kr.or.ddit.common.webSocket.chat.vo;

import lombok.Data;

import java.util.Date;

@Data
public class ChatRoomReadVO {
    private String chatRoomNo;
    private String chatMemberId;
    private String lastReadMsgNo;
}