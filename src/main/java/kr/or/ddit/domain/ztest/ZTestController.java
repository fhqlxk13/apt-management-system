package kr.or.ddit.domain.ztest;

import kr.or.ddit.common.file.service.IAttachFileService;
import kr.or.ddit.common.file.vo.AttachFileVO;
import kr.or.ddit.domain.member.vo.CustomUser;
import kr.or.ddit.domain.member.vo.MemberVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Slf4j
@Controller
@RequestMapping("/ztest")
public class ZTestController {

    @Autowired
    IAttachFileService attachFileService;

    @GetMapping("/aptapi")
    public String aptapi(){
        return "ztestview/aptapi";
    }

    @GetMapping("/center-main.do")
    public String centermain(){
        return "ztestview/center-main";
    }




    @PreAuthorize("hasRole('MEMBER')")
    @GetMapping("/ztestview.do")
    public String myPage(@AuthenticationPrincipal CustomUser customUser,
                         Model model) {

        // 인증 객체에서 멤버 정보 가져오기
        MemberVO member = customUser.getMember();
        String profFileId = member.getProfFileId();

        if(profFileId != null && !profFileId.isBlank()){
            // 파일 데이터 세팅
            AttachFileVO file = attachFileService.setOnlyOneFileMetaData(profFileId);

            if(file != null){
                model.addAttribute("file", file);   // 파일 정보 전체
            }
        }
        model.addAttribute("member", member);

        return "ztestview/profImgView";
    }

}
