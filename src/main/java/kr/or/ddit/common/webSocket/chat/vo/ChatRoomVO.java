package kr.or.ddit.common.webSocket.chat.vo;

import lombok.Data;

import java.util.Date;

@Data
public class ChatRoomVO {
    private String chatRoomNo;
    private String chatRoomNm;
    private String chatRoomTyCd;
    private String chatJoinKey;
    private Date regDt;
    private String useYn;
    private String rgtrId;
    private String aptCmplexNo;
    private String chatRoomDesc;

    /*참여한 멤버 수, 안읽은 메시지 내용(작은화면에 보여줄거), 마지막시간, 안읽은 메시지 수 */
    private int memberCnt;
    private String lastMsg;
    private Date lastTime;
    private int unreadCnt;
}