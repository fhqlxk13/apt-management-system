package kr.or.ddit.common.webSocket.chat.controller;

import kr.or.ddit.common.webSocket.chat.service.IChatService;
import kr.or.ddit.common.webSocket.chat.vo.ChatMessageVO;
import kr.or.ddit.common.webSocket.chat.vo.ChatRoomVO;
import kr.or.ddit.domain.member.vo.CustomUser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@Controller
@RequestMapping("/residentChat")
@PreAuthorize("hasRole('RESIDENT')")
public class ChatController {

    @Autowired
    private IChatService service;

    @Autowired
    private SimpMessagingTemplate messagingTemplate;

    // 내 채팅방 목록 가져오기
    @PreAuthorize("@authService.hasAccess(principal, #aptCmplexNo)")
    @GetMapping("/myRooms/{aptCmplexNo}")
    @ResponseBody
    public List<ChatRoomVO> myRooms(
            @PathVariable String aptCmplexNo
            ,@AuthenticationPrincipal CustomUser user
    ) {

        String userNo = user.getMember().getUserNo();
        return service.selectMyRoomList(userNo,aptCmplexNo);
    }

    // 메시지 조회
    @PreAuthorize("@authService.hasAccess(principal, #aptCmplexNo)")
    @GetMapping("/messages/{aptCmplexNo}")
    @ResponseBody
    public List<ChatMessageVO> messages(
            @PathVariable String aptCmplexNo
            ,@RequestParam String chatRoomNo
            ,@AuthenticationPrincipal CustomUser user
    ) {

        String userNo = user.getMember().getUserNo();

        if (!service.isRoomMember(chatRoomNo, userNo)) {

            throw new ResponseStatusException(
                    HttpStatus.FORBIDDEN,
                    "채팅방 접근 권한 없음"
            );
        }

        service.readRoom(chatRoomNo, userNo);

        return service.getMessages(chatRoomNo, userNo);
    }

    // 입장
    @PreAuthorize("@authService.hasAccess(principal, #aptCmplexNo)")
    @PostMapping("/enter/{aptCmplexNo}")
    @ResponseBody
    public ChatRoomVO enter(
                        @PathVariable String aptCmplexNo
                        ,@RequestParam String chatRoomNo
                        ,@AuthenticationPrincipal CustomUser user) {

        String userNo = user.getMember().getUserNo();

        service.enterRoom(chatRoomNo, userNo);

        ChatMessageVO message = new ChatMessageVO();

        message.setChatRoomNo(chatRoomNo);
        message.setMsgCn(
                user.getMember().getUserNm() + "님이 입장했습니다."
        );

        message.setMsgTyCd("ENTER");
        message.setSenderTy("SYSTEM");

        service.sendSystemMessage(message);

        messagingTemplate.convertAndSend(
                "/sub/chat/room/" + chatRoomNo,
                message
        );

        return service.selectRoom(chatRoomNo);
    }

    @PreAuthorize("@authService.hasAccess(principal, #aptCmplexNo)")
    @PostMapping("/createRoom/{aptCmplexNo}")
    @ResponseBody
    public ChatRoomVO createRoom(
            @PathVariable String aptCmplexNo
            ,@RequestBody ChatRoomVO roomVO
            ,@AuthenticationPrincipal CustomUser user
    ) {

        String userNo = user.getMember().getUserNo();
        roomVO.setAptCmplexNo(aptCmplexNo);
        return service.createRoom(roomVO, userNo);
    }

    @GetMapping("/openRooms/{aptCmplexNo}")
    @ResponseBody
    public List<ChatRoomVO> openRooms(
            @PathVariable String aptCmplexNo,
            @AuthenticationPrincipal CustomUser user
    ) {


        System.out.println("user = " + user);

        String userNo = user.getMember().getUserNo();

        return service.selectOpenRooms(aptCmplexNo,userNo);
    }

    @PreAuthorize("@authService.hasAccess(principal, #aptCmplexNo)")
    @PostMapping("/leave/{aptCmplexNo}")
    @ResponseBody
    public String leaveRoom(
            @PathVariable String aptCmplexNo,
            @RequestParam String chatRoomNo,
            @AuthenticationPrincipal CustomUser user
    ) {

        String userNo = user.getMember().getUserNo();

        ChatMessageVO message = new ChatMessageVO();

        message.setChatRoomNo(chatRoomNo);
        message.setSenderTy("SYSTEM");
        message.setMsgTyCd("LEAVE");
        message.setMsgCn(user.getMember().getUserNm() + "님이 퇴장했습니다.");

        service.sendSystemMessage(message);

        service.leaveRoom(chatRoomNo, userNo);

        return "OK";
    }

    @PostMapping("/read/{aptCmplexNo}")
    @ResponseBody
    public void readRoom(
            @RequestParam String chatRoomNo,
            Authentication authentication
    ) {

        CustomUser user =
                (CustomUser) authentication.getPrincipal();

        service.readRoom(
                chatRoomNo,
                user.getMember().getUserNo()
        );
    }


    @PostMapping("/joinByCode/{aptCmplexNo}")
    @ResponseBody
    public ChatRoomVO joinByCode(
            @PathVariable String aptCmplexNo,
            @RequestParam String joinKey,
            Authentication authentication
    ){

        CustomUser user =
                (CustomUser) authentication.getPrincipal();

        return service.joinByCode(
                aptCmplexNo,
                joinKey,
                user.getMember().getUserNo()
        );
    }
}