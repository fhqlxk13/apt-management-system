package kr.or.ddit.common.webSocket.chat.vo;

import lombok.Data;

import java.util.Date;

@Data
public class ChatMessageVO {
    private String chatMsgNo;
    private String chatRoomNo;
    private String msgTyCd;
    private String msgCn;
    private String chatMemberId;
    private Date regDttm;

    private String senderUserNo;
    private String senderUserNm;

    private String senderTy;
    private String atchFileId;
}