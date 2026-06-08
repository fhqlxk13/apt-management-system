package kr.or.ddit.domain.member.resident.controller;

import kr.or.ddit.common.model.PaginationInfoVO;
import kr.or.ddit.domain.member.resident.service.IResidentVstVhclService;
import kr.or.ddit.domain.member.resident.vo.VisitRegisterDTO;
import kr.or.ddit.domain.member.resident.vo.VstVhclRsvtVO;
import kr.or.ddit.domain.member.vo.CustomUser;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

@Slf4j
@Controller
@RequestMapping("/resident/vstVhcl")
@PreAuthorize("hasRole('RESIDENT')")
public class ResidentVstVhclController {

    @Autowired
    IResidentVstVhclService residentVstVhclService;

    @PreAuthorize("@authService.hasAccess(principal, #aptCmplexNo)")
    @PostMapping("/register/{aptCmplexNo}")
    @ResponseBody
    public ResponseEntity<String> registerVisit(
            @PathVariable String aptCmplexNo,
            @RequestBody VisitRegisterDTO dto,
            @AuthenticationPrincipal CustomUser principal
    ){

        residentVstVhclService.registerVisit(
                dto
                , principal
                , aptCmplexNo
        );

        return ResponseEntity.ok("SUCCESS");
    }


    @GetMapping("/list/{aptCmplexNo}")
    @ResponseBody
    @PreAuthorize("@authService.hasAccess(principal, #aptCmplexNo)")
    public PaginationInfoVO<VstVhclRsvtVO> selectVisitList(
            @PathVariable String aptCmplexNo,
            @RequestParam(defaultValue = "1")
            int currentPage,
            @AuthenticationPrincipal CustomUser principal
    ){

        PaginationInfoVO<VstVhclRsvtVO> pagingVO =
                new PaginationInfoVO<>(5, 5);

        pagingVO.setCurrentPage(currentPage);

        residentVstVhclService.selectVisitList(
                pagingVO,
                principal.getMember().getUserNo(),
                aptCmplexNo
        );

        return pagingVO;
    }

    @PreAuthorize("@authService.hasAccess(principal, #aptCmplexNo)")
    @DeleteMapping("/delete/{aptCmplexNo}/{rsvtNo}")
    @ResponseBody
    public ResponseEntity<String> deleteVisit(

            @PathVariable String aptCmplexNo,
            @PathVariable String rsvtNo,
            @AuthenticationPrincipal CustomUser principal
    ){

        int result =
                residentVstVhclService.deleteVisit(
                        rsvtNo,
                        principal.getMember().getUserNo()
                );

        if(result == 0){

            return ResponseEntity
                    .badRequest()
                    .body("삭제 실패");
        }

        return ResponseEntity.ok("SUCCESS");
    }
}
