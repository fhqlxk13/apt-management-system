package kr.or.ddit.common.webSocket.chat.service;

import kr.or.ddit.common.webSocket.chat.vo.ChatMemberVO;
import kr.or.ddit.common.webSocket.chat.vo.ChatMessageVO;
import kr.or.ddit.common.webSocket.chat.vo.ChatRoomVO;

import java.util.List;

public interface IChatService {
    List<ChatRoomVO> selectMyRoomList(String userNo, String aptCmplexNo);

    List<ChatMessageVO> getMessages(String roomId,String userNo);

    void sendMessage(ChatMessageVO vo, String userNo);

    void enterRoom(String roomId, String userNo);

    int insertRoomMember(ChatMemberVO memberVO);

    ChatRoomVO createRoom(ChatRoomVO roomVO, String userNo);

    ChatRoomVO selectRoom(String chatRoomNo);

    List<ChatRoomVO> selectOpenRooms(String aptCmplexNo, String userNo);

    int leaveRoom(String chatRoomNo, String userNo);

    void sendSystemMessage(ChatMessageVO message);

    void readRoom(String chatRoomNo, String userNo);

    boolean isRoomMember(String chatRoomNo, String userNo);

    String selectMemberId(String chatRoomNo, String userNo);

    ChatRoomVO joinByCode(String aptCmplexNo, String joinKey, String userNo);
}
