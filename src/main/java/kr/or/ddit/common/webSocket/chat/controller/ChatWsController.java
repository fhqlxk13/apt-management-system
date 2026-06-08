package kr.or.ddit.common.webSocket.chat.controller;

import kr.or.ddit.common.webSocket.chat.service.IChatService;
import kr.or.ddit.common.webSocket.chat.vo.ChatMessageVO;
import kr.or.ddit.domain.member.vo.CustomUser;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;

import java.security.Principal;

@Controller
@RequiredArgsConstructor
public class ChatWsController {

    @Autowired
    IChatService chatService;

    private final SimpMessagingTemplate messagingTemplate;

    @MessageMapping("/chat/send")
    public void sendMessage(ChatMessageVO message, Principal principal) {

        System.out.println("principal = " + principal);

        CustomUser user = (CustomUser) ((Authentication) principal).getPrincipal();

        String userNo = user.getMember().getUserNo();

        if(!chatService.isRoomMember(
                message.getChatRoomNo(),
                userNo
        )){
            return;
        }


        message.setSenderUserNo(userNo);
        message.setSenderUserNm(
                user.getMember().getUserNm()
        );
        message.setSenderTy("USER");
        message.setMsgTyCd("TEXT");

        chatService.sendMessage(message, userNo);

        messagingTemplate.convertAndSend(
                "/sub/chat/room/" + message.getChatRoomNo(),
                message
        );
    }
}