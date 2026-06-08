package kr.or.ddit.domain.member.resident.controller;

import kr.or.ddit.common.notification.dto.NotificationDTO;
import kr.or.ddit.common.notification.service.NotificationService;
import kr.or.ddit.domain.member.resident.service.IResidentVhclService;
import kr.or.ddit.domain.member.resident.vo.RsidVhclVO;
import kr.or.ddit.domain.member.vo.CustomUser;
import kr.or.ddit.domain.member.vo.MemberVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;

@Slf4j
@Controller
@RequestMapping("/vhcl")
@PreAuthorize("hasRole('RESIDENT')")
public class ResidentVhclController {

    @Autowired
    private IResidentVhclService residentVhclService;

    @Autowired
    private NotificationService notificationService;

    /**
     * 차량 목록 조회
     * - 입주민 / 관리사무소 / 관리자 모두 접근 가능
     */
    @GetMapping("/myVhcl/{aptCmplexNo}")
    @PreAuthorize("@authService.hasAccess(principal, #aptCmplexNo)")
    @ResponseBody
    public List<RsidVhclVO> selectMyVhclList(
            @PathVariable String aptCmplexNo,
            @AuthenticationPrincipal CustomUser principal
    ) {

        MemberVO member = principal.getMember();

        return residentVhclService.selectMyVhclList(
                member.getUserNo(),
                aptCmplexNo
        );
    }


    /**
     * 추가 차량 여부 체크
     * - 입주민만 가능
     */
    @PostMapping("/check/{aptCmplexNo}")
    @ResponseBody
    @PreAuthorize("@authService.isResidentOnly(principal, #aptCmplexNo)")
    public String checkVhcl(
            @AuthenticationPrincipal CustomUser principal,
            @PathVariable String aptCmplexNo,
            @RequestParam String hoNo
    ) {

        MemberVO member = principal.getMember();

        boolean isExtra =
                residentVhclService.isExtraRequired(
                        member.getUserNo(),
                        aptCmplexNo,
                        hoNo
                );


        return isExtra ? "EXTRA_REQUIRED" : "OK";
    }


    /**
     * 차량 등록
     * - 입주민만 가능
     */
    @PostMapping("/register/{aptCmplexNo}")
    @ResponseBody
    @PreAuthorize("@authService.isResidentOnly(principal, #aptCmplexNo)")
    public String registerVhcl(
            @AuthenticationPrincipal CustomUser principal,
            @PathVariable String aptCmplexNo,
            @RequestParam String vhclNm,
            @RequestParam String vhclNo,
            @RequestParam String hoNo,
            @RequestParam boolean isExtra,
            @RequestPart(required = false) MultipartFile file
    ) throws IOException {

        MemberVO member = principal.getMember();

        residentVhclService.registerVhcl(
                member.getUserNo(),
                aptCmplexNo,
                vhclNm,
                vhclNo,
                hoNo,
                file
        );

        return "OK";
    }


    /**
     * 차량 삭제
     * - 입주민만 가능
     */
    @DeleteMapping("/delete/{rsidVhclNo}")
    @ResponseBody
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<String> deleteVhcl(
            @PathVariable String rsidVhclNo,
            @AuthenticationPrincipal CustomUser customUser
    ) {

        MemberVO member = customUser.getMember();

        residentVhclService.deleteVhcl(
                rsidVhclNo,
                member.getUserNo()
        );

        return ResponseEntity.ok("SUCCESS");
    }
}