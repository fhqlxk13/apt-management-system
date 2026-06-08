package kr.or.ddit.common.webSocket.chat.service;

import kr.or.ddit.common.webSocket.chat.mapper.IChatMapper;
import kr.or.ddit.common.webSocket.chat.vo.ChatMemberVO;
import kr.or.ddit.common.webSocket.chat.vo.ChatMessageVO;
import kr.or.ddit.common.webSocket.chat.vo.ChatRoomVO;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.RandomStringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;
import java.util.UUID;

@Service
@Slf4j
public class ChatServiceImpl implements IChatService {

    @Autowired
    private IChatMapper mapper;

    @Override
    public List<ChatRoomVO> selectMyRoomList(String userNo, String aptCmplexNo) {
        return mapper.selectMyRoomList(userNo, aptCmplexNo);
    }

    @Override
    public List<ChatMessageVO> getMessages(String chatRoomNo,String userNo) {
        return mapper.selectMessages(chatRoomNo, userNo);
    }

    public String selectMemberId(String chatRoomNo, String userNo){
        return mapper.selectMemberId(chatRoomNo,userNo);
    }

    @Override
    @Transactional
    public ChatRoomVO joinByCode(
            String aptCmplexNo,
            String joinKey,
            String userNo
    ) {

        ChatRoomVO room =
                mapper.selectRoomByJoinKey(
                        aptCmplexNo,
                        joinKey
                );

        if(room == null){

            throw new RuntimeException(
                    "유효하지 않은 초대코드"
            );
        }

        if(!isRoomMember(room.getChatRoomNo(), userNo)){

            ChatMemberVO memberVO =
                    new ChatMemberVO();

            memberVO.setChatRoomNo(
                    room.getChatRoomNo()
            );

            memberVO.setUserNo(userNo);

            memberVO.setChatroleCd("MEMBER");

            insertRoomMember(memberVO);
        }

        return room;
    }

    @Override
    @Transactional
    public void sendMessage(ChatMessageVO vo, String userNo) {

        // memberId 찾기
        String memberId = selectMemberId(vo.getChatRoomNo(), userNo);

        vo.setChatMemberId(memberId);

        // 메시지 저장
        mapper.insertMessage(vo);

        vo.setRegDttm(new Date());

        // 읽음 처리
        mapper.updateLastRead(vo);
    }

    @Override
    @Transactional
    public void enterRoom(String chatRoomNo, String userNo) {

        String memberId = mapper.selectMemberId(chatRoomNo, userNo);

        if (memberId == null) {
            ChatMemberVO memberVO = new ChatMemberVO();

            memberVO.setChatRoomNo(chatRoomNo);
            memberVO.setUserNo(userNo);
            memberVO.setChatroleCd("MEMBER");

            insertRoomMember(memberVO);
        }
    }

    @Override
    @Transactional
    public int insertRoomMember(ChatMemberVO memberVO) {

        String chatMemberId = mapper.getRoomMemberSeq();
        String chatRoomNo = memberVO.getChatRoomNo();

        memberVO.setChatMemberId(chatMemberId);
        int res = mapper.insertRoomMember(memberVO);

        mapper.insertChatRoomRead(chatRoomNo,chatMemberId);

        return res;
    }


    /**
     * 방생성 매서드
     * @param roomVO jsp form 에서 보내준 정보로 어느정도 완성된 roomVO를 컨트롤러에서 받음
     * @param userNo 시큐리티에서 꺼낸 userNo 를 컨트롤러에서 넣어줌
     * @return 룸객체 반환
     */
    @Override
    @Transactional
    public ChatRoomVO createRoom(ChatRoomVO roomVO, String userNo) {

        String roomNo = mapper.getRoomNoSeq();

        String joinKey =
                UUID.randomUUID()
                        .toString()
                        .replace("-", "")
                        .substring(0, 20);

        roomVO.setChatRoomNo(roomNo);
        roomVO.setChatJoinKey(joinKey);
        roomVO.setRgtrId(userNo);

        mapper.insertChatRoom(roomVO);

        ChatMemberVO memberVO = new ChatMemberVO();

        memberVO.setChatRoomNo(roomNo);
        memberVO.setUserNo(userNo);
        memberVO.setChatroleCd("OWNER");

        insertRoomMember(memberVO);

        return roomVO;
    }

    @Override
    public ChatRoomVO selectRoom(String chatRoomNo) {
        return mapper.selectRoom(chatRoomNo);
    }

    @Override
    public List<ChatRoomVO> selectOpenRooms(String aptCmplexNo, String userNo) {
        return mapper.selectOpenRooms(aptCmplexNo,userNo);
    }

    @Override
    @Transactional
    public int leaveRoom(String chatRoomNo, String userNo) {

        int reslut = mapper.leaveRoom(chatRoomNo, userNo);

        int memberCnt = countActiveMembers(chatRoomNo);

        if(memberCnt == 0){
            disableRoom(chatRoomNo);
        }

        return reslut;
    }

    private void disableRoom(String chatRoomNo) {
        mapper.disableRoom(chatRoomNo);
    }

    private int countActiveMembers(String chatRoomNo) {
        return mapper.countActiveMembers(chatRoomNo);
    }

    @Override
    public void sendSystemMessage(ChatMessageVO message) {
        mapper.insertSystemMessage(message);
    }

    @Override
    @Transactional
    public void readRoom(String chatRoomNo, String userNo) {

        String memberId = mapper.selectMemberId(chatRoomNo, userNo);

        mapper.readAllMessages(chatRoomNo, memberId);
    }

    @Override
    public boolean isRoomMember(
            String chatRoomNo,
            String userNo
    ) {
    return mapper.isRoomMember(chatRoomNo,userNo) > 0;
    }
}