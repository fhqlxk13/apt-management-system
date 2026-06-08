package kr.or.ddit.domain.apt.main.controller;

import kr.or.ddit.common.file.vo.AttachFileVO;
import kr.or.ddit.domain.apt.apiApartment.vo.AptHoTyDTO;
import kr.or.ddit.domain.apt.main.dto.AptMainPageDTO;
import kr.or.ddit.domain.apt.main.service.IAptComplexService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Slf4j
@Controller
@RequestMapping("/apt")
public class AptController {

    @Autowired
    IAptComplexService aptComplexService;

    /**
     * 단지별 메인 페이지 컨트롤러
     *
     * @param aptCmplexNo 단지코드
     * @param model
     * @return apt-main.jsp
     * @author 이용로
     */
    @GetMapping("/main/{aptCmplexNo}")
    public String aptMain(@PathVariable String aptCmplexNo, Model model) {
        log.info("aptMain() 실행 \n아파트 코드 : {}", aptCmplexNo);

        // 아파트 메인페이지 DTO정보 가져오기
        AptMainPageDTO.ResponseDto aptMainPageDTO = aptComplexService.selectAptMainDTO(aptCmplexNo);
        model.addAttribute("aptInfo", aptMainPageDTO);

        return "apt-main";
    }

    /**
     * @param aptCmplexNo
     * @param model
     * @return 우리아파트 페이지
     * @author 이윤진
     */
    @GetMapping("/main/aptInfo/{aptCmplexNo}")
    public String aptInfo(
            @PathVariable String aptCmplexNo,
            Model model
    ) {

        // 아파트 메인페이지 DTO정보
        AptMainPageDTO.ResponseDto aptMainPageDTO = aptComplexService.selectAptMainDTO(aptCmplexNo);
        // 배치도 리스트
        List<AttachFileVO> layoutFiles = aptComplexService.getLayoutFiles(aptCmplexNo);

        model.addAttribute("aptInfo",aptMainPageDTO);

        model.addAttribute("layoutFiles",layoutFiles);

        return "apt/aptInfo";
    }

    /**
     * @param authentication 로그인 한 사용자 정보를 가져오기 위한 객체
     * @param model
     * @return 관리사무소 소개 페이지
     * @author 이윤진
     */
    @GetMapping("/main/mgmtInfo/{aptCmplexNo}")
    public String mgmtOfficeIntro(@PathVariable String aptCmplexNo, Authentication authentication, Model model) {

        // 1. 로그인 여부 체크
        if (authentication == null || !authentication.isAuthenticated()) {
            model.addAttribute("message", "로그인이 필요합니다.");
            model.addAttribute("redirectUrl", "/login");
            return "member/resident/resident_auth_error";
        }

        // 2. 아파트 메인페이지 DTO정보 가져오기
        AptMainPageDTO.ResponseDto aptMainPageDTO = aptComplexService.selectAptMainDTO(aptCmplexNo);

        model.addAttribute("aptInfo", aptMainPageDTO);
        return "apt/mgmtOffice_intro";
    }


    @ResponseBody
    @GetMapping("/hoTyList/{aptCmplexNo}")
    public List<AptHoTyDTO> getHoTypeList(
            @PathVariable String aptCmplexNo) {
        return aptComplexService.getHoTypeList(aptCmplexNo);
    }

}
