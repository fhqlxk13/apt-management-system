package kr.or.ddit.common.kakao.controller;

import kr.or.ddit.common.kakao.service.IKakaoAlimService;
import kr.or.ddit.common.kakao.vo.KakaoAlimVO;
import kr.or.ddit.domain.member.vo.CustomUser;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 카카오 알림 Controller
 *
 * Controller란?
 * 화면의 요청을 받아 Service를 호출하고 결과를 반환하는 계층입니다.
 *
 * 왜 사용?
 * 화면(JSP, JavaScript)과 비즈니스 로직(Service)을 분리하기 위해 사용합니다.
 */
@RestController
@RequiredArgsConstructor
@RequestMapping("/resident/kakaoAlim")
public class KakaoAlimController {

    /**
     * 카카오 알림 서비스
     */
    private final IKakaoAlimService kakaoAlimService;

    /**
     * 내 알림 목록 조회
     *
     * 알림센터 모달 오픈 시 호출
     */
    @GetMapping("/list")
    public List<KakaoAlimVO> list(@AuthenticationPrincipal CustomUser customUser) {
        String userNo = customUser.getMember().getUserNo();
        return kakaoAlimService.getMyAlimList(userNo);
    }

    /**
     * 알림 읽음 처리
     *
     * 알림 클릭 시 READ_YN 값을
     * N → Y 로 변경
     */
    @PostMapping("/{alimNo}/read")
    public void read(
            @PathVariable String alimNo,
            @AuthenticationPrincipal CustomUser customUser
    ) {
        String userNo = customUser.getMember().getUserNo();
        kakaoAlimService.readAlim(alimNo, userNo);
    }

    /**
     * 읽지 않은 알림 개수 조회
     *
     * 상단 종모양(🔔) 배지 숫자 표시용
     */
    @GetMapping("/count")
    public int count(@AuthenticationPrincipal CustomUser customUser) {
        String userNo = customUser.getMember().getUserNo();
        return kakaoAlimService.getUnreadCount(userNo);
    }

}