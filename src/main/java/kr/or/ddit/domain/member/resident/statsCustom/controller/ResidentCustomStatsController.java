package kr.or.ddit.domain.member.resident.statsCustom.controller;

import kr.or.ddit.domain.apt.main.dto.AptMainPageDTO;
import kr.or.ddit.domain.apt.main.service.IAptComplexService;
import kr.or.ddit.domain.member.resident.statsCustom.dto.ResidentCustomStatsResponseDTO;
import kr.or.ddit.domain.member.resident.statsCustom.service.IResidentCustomStatsService;
import kr.or.ddit.domain.member.vo.CustomUser;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequiredArgsConstructor
@PreAuthorize("hasAnyRole('RESIDENT', 'MNGR', 'ADMIN')")
public class ResidentCustomStatsController {

    private final IResidentCustomStatsService residentCustomStatsService;
    private final IAptComplexService aptComplexService;

    /**
     * 아파트통계 화면
     * 단지번호 포함 URL 진입 시 단지 공통 정보·단지번호 모델 주입 후 JSP 반환
     */
    @PreAuthorize("@authService.hasAccess(principal, #aptCmplexNo)")
    @GetMapping("/resident/stats/apartment/{aptCmplexNo}")
    public String aptStatsPage(
            @PathVariable String aptCmplexNo,
            Model model
    ) {
        // 단지 공통 정보
        AptMainPageDTO.ResponseDto aptCommonDTO = aptComplexService.selectAptCommonDTO(aptCmplexNo);
        model.addAttribute("aptInfo", aptCommonDTO);
        model.addAttribute("aptCmplexNo", aptCmplexNo);
        return "member/resident/stats_apartment";
    }

    /**
     * 우리집맞춤통계 화면
     * 단지번호 포함 URL 진입 시 단지 공통 정보·단지번호 모델 주입 후 JSP 반환
     */
    @PreAuthorize("@authService.hasAccess(principal, #aptCmplexNo)")
    @GetMapping("/resident/stats/custom/{aptCmplexNo}")
    public String customStatsPage(
            @PathVariable String aptCmplexNo,
            Model model
    ) {
        // 단지 공통 정보
        AptMainPageDTO.ResponseDto aptCommonDTO = aptComplexService.selectAptCommonDTO(aptCmplexNo);
        model.addAttribute("aptInfo", aptCommonDTO);
        model.addAttribute("aptCmplexNo", aptCmplexNo);
        return "member/resident/stats_custom";
    }

    @PreAuthorize("@authService.hasAccess(principal, #aptCmplexNo)")
    @GetMapping("/resident/stats/custom/{aptCmplexNo}/data")
    @ResponseBody
    public ResidentCustomStatsResponseDTO customStatsData(
            @PathVariable String aptCmplexNo,
            @AuthenticationPrincipal CustomUser customUser
    ) {
        /* 로그인 사용자 기준 통계 조회 */
        String userNo = customUser.getMember().getUserNo();
        return residentCustomStatsService.selectCustomStats(userNo, aptCmplexNo);
    }

    @GetMapping("/resident/stats/custom/data")
    @ResponseBody
    public ResidentCustomStatsResponseDTO customStatsData(
            @AuthenticationPrincipal CustomUser customUser
    ) {
        /* 기본 진입 화면 통계 조회 */
        String userNo = customUser.getMember().getUserNo();
        return residentCustomStatsService.selectCustomStats(userNo);
    }
}
