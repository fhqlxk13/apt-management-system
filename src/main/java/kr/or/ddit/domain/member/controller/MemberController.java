package kr.or.ddit.domain.member.controller;

import kr.or.ddit.common.enums.ServiceResult;
import kr.or.ddit.common.file.service.IAttachFileService;
import kr.or.ddit.common.file.vo.AttachFileVO;
import kr.or.ddit.domain.member.service.IMemberService;
import kr.or.ddit.domain.member.vo.CustomUser;
import kr.or.ddit.domain.member.vo.MemberVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

@Slf4j
@Controller
@RequestMapping("/member")
public class MemberController {

    @Autowired
    private IMemberService service;

    @Autowired
    private IAttachFileService attachFileService;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @GetMapping("/join.do")
    public String joinPage() {
        return "member/join";
    }

    @ResponseBody
    @PostMapping("/join")
    public ResponseEntity<Map<String, String>> joinMember(
            MemberVO member,
            @RequestParam(value = "profFile", required = false) MultipartFile profFile) {

        log.info("joinMember() executed");
        Map<String, String> resp = new HashMap<>();

        try {
            ServiceResult result = service.joinMember(member, profFile);

            if (ServiceResult.OK.equals(result)) {
                resp.put("message", "회원가입 완료!");
                return new ResponseEntity<>(resp, HttpStatus.OK);
            }

            resp.put("message", "가입 실패!");
            return new ResponseEntity<>(resp, HttpStatus.BAD_REQUEST);
        } catch (Exception e) {
            resp.put("message", "서버에러");
            return new ResponseEntity<>(resp, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @ResponseBody
    @GetMapping("/idCheck")
    public ResponseEntity<Map<String, String>> idCheck(@RequestParam String userId) {
        log.info("idCheck() executed");
        Map<String, String> resp = new HashMap<>();

        try {
            ServiceResult result = service.idCheck(userId);

            if (ServiceResult.EXIST.equals(result)) {
                resp.put("res", "EXIST");
                resp.put("message", "이미 사용 중인 아이디입니다!");
            } else {
                resp.put("res", "NOTEXIST");
                resp.put("message", "사용 가능한 아이디입니다!");
            }

            return new ResponseEntity<>(resp, HttpStatus.OK);
        } catch (Exception e) {
            resp.put("message", "서버 에러로 인해 중복확인에 실패하였습니다.");
            return new ResponseEntity<>(resp, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @PreAuthorize("hasRole('MEMBER')")
    @GetMapping("/myPage.do")
    public String myPage(@AuthenticationPrincipal CustomUser customUser,
                         Model model,
                         HttpSession session) {
        log.info("myPage() executed");

        Boolean myPageAuth = (Boolean) session.getAttribute("MY_PAGE_AUTH");
        if (myPageAuth == null || !myPageAuth) {
            return "redirect:/member/myPageAuth.do";
        }
        session.removeAttribute("MY_PAGE_AUTH");

        MemberVO member = customUser.getMember();
        String profFileId = member.getProfFileId();

        if (profFileId != null && !profFileId.isBlank()) {
            AttachFileVO file = attachFileService.setOnlyOneFileMetaData(profFileId);
            if (file != null) {
                model.addAttribute("file", file);
            }
        }

        model.addAttribute("member", member);
        return "member/mypage";
    }

    @PreAuthorize("hasRole('MEMBER')")
    @GetMapping("/myPageAuth.do")
    public String myPageAuthPage() {
        return "member/mypageAuth";
    }

    @PreAuthorize("hasRole('MEMBER')")
    @PostMapping("/myPageAuth.do")
    public String myPageAuth(@RequestParam String userPw,
                             @AuthenticationPrincipal CustomUser customUser,
                             RedirectAttributes ra,
                             HttpSession session) {
        if (customUser == null) {
            return "redirect:/login.do";
        }

        String rawPw = userPw == null ? "" : userPw.trim();
        MemberVO currentMember = service.getMemberByUserNo(customUser.getMember().getUserNo());
        String encodedPw = currentMember != null ? currentMember.getUserPw() : customUser.getPassword();

        log.info("myPageAuth() userNo={}, rawLen={}, encodedExists={}",
                customUser.getMember().getUserNo(), rawPw.length(), encodedPw != null);

        if (encodedPw != null && passwordEncoder.matches(rawPw, encodedPw)) {
            session.setAttribute("MY_PAGE_AUTH", Boolean.TRUE);
            return "redirect:/member/myPage.do";
        }

        ra.addFlashAttribute("error", "비밀번호가 일치하지 않습니다.");
        return "redirect:/member/myPageAuth.do";
    }

    @PreAuthorize("hasAnyRole('MEMBER', 'RESIDENT')")
    @PostMapping("/updateSimple")
    public String updateMember(MemberVO member,
                               @RequestParam(value = "profileImage", required = false) MultipartFile profileImage,
                               @AuthenticationPrincipal CustomUser customUser,
                               RedirectAttributes ra) {

        if (customUser != null && customUser.getMember() != null) {
            String userNo = customUser.getMember().getUserNo();
            member.setUserNo(userNo.trim());
        }

        if (member.getUserPw() == null || member.getUserPw().isEmpty()) {
            member.setUserPw(null);
        }

        ServiceResult result = service.updateMember(member);

        if (result == ServiceResult.OK) {
            MemberVO updated = service.getMemberByUserNo(member.getUserNo());
            customUser.setMember(updated);
            ra.addFlashAttribute("msg", "success");
        } else {
            log.error("회원 수정 실패");
        }

        return "redirect:/member/myPage.do";
    }

    @PreAuthorize("hasRole('MEMBER')")
    @PostMapping("/alarm/update")
    @ResponseBody
    public String updateAlarm(@RequestBody Map<String, Object> param,
                              @AuthenticationPrincipal CustomUser customUser) {

        if (customUser != null && customUser.getMember() != null) {
            String userNo = customUser.getMember().getUserNo();
            param.put("userNo", userNo);
        }

        if ("N".equals(param.get("emlRcvYn"))) {
            param.put("emlNtcRcvYn", "N");
            param.put("emlCtrtRcvYn", "N");
        }

        if ("N".equals(param.get("smsRcvYn"))) {
            param.put("smsNtcRcvYn", "N");
            param.put("smsCtrtRcvYn", "N");
        }

        service.updateAlarm(param);
        return "OK";
    }
}
