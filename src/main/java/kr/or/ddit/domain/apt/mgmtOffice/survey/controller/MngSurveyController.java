package kr.or.ddit.domain.apt.mgmtOffice.survey.controller;

import kr.or.ddit.domain.apt.mgmtOffice.common.service.IManagerModelService;
import kr.or.ddit.domain.apt.mgmtOffice.survey.dto.MngSurveyDTO;
import kr.or.ddit.domain.apt.mgmtOffice.survey.service.IMngSurveyService;
import kr.or.ddit.domain.member.vo.CustomUser;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@Controller
@RequestMapping("/manager/survey")
@RequiredArgsConstructor
@PreAuthorize("hasRole('MNGR')")
public class MngSurveyController {

    private final IMngSurveyService surveyService;
    private final IManagerModelService managerAccessService;

    /**
     * 설문 관리 페이지
     * GET /manager/survey/{mgmtOfcNo}
     */
 /*   @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")*/
    @GetMapping("/{mgmtOfcNo}")
    public String surveyManage(
            @PathVariable String mgmtOfcNo,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {

        managerAccessService.addManagerViewModel(
                model,
                customUser,
                mgmtOfcNo
        );

        model.addAttribute(
                "mgmtOfcNo",
                mgmtOfcNo
        );

        return "apt/mgmtOffice/survey/mngr_survey_manage";
    }

    /**
     * 설문 등록 API
     * POST /manager/survey/{mgmtOfcNo}/register
     */
  /*  @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")*/
    @PostMapping("/{mgmtOfcNo}/register")
    @ResponseBody
    public ResponseEntity<?> registerSurvey(
            @PathVariable String mgmtOfcNo,
            @AuthenticationPrincipal CustomUser customUser,
            @RequestBody MngSurveyDTO dto
    ) {

        System.out.println("설문 등록 호출");
        System.out.println("mgmtOfcNo = " + mgmtOfcNo);
        System.out.println(dto);

        dto.setRgtrId(
                customUser.getMember().getUserNo()
        );

        String aptComplexNo =
                managerAccessService.getAptComplexNo(mgmtOfcNo);

        dto.setAptCd(aptComplexNo);



        try {

            surveyService.registerSurvey(dto);

            return ResponseEntity.ok().build();

        } catch (Exception e) {

            e.printStackTrace();

            return ResponseEntity
                    .internalServerError()
                    .body(e.getMessage());
        }
    }

    /**
     * 설문 목록 조회 API
     * GET /manager/survey/{mgmtOfcNo}/list
     */
   /* @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")*/
    @GetMapping("/{mgmtOfcNo}/list")
    @ResponseBody
    public ResponseEntity<?> selectSurveyList(
            @PathVariable String mgmtOfcNo
    ) {

        System.out.println("설문 목록 조회");
        System.out.println("mgmtOfcNo = " + mgmtOfcNo);

        String aptComplexNo =
                managerAccessService.getAptComplexNo(mgmtOfcNo);

        return ResponseEntity.ok(
                surveyService.selectSurveyList(aptComplexNo)
        );
    }

    @GetMapping("/{mgmtOfcNo}/detail/{surveyNo}")
    public String surveyDetailPage(
            @PathVariable String mgmtOfcNo,
            @PathVariable String surveyNo,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {

        managerAccessService.addManagerViewModel(
                model,
                customUser,
                mgmtOfcNo
        );

        model.addAttribute(
                "mgmtOfcNo",
                mgmtOfcNo
        );

        model.addAttribute(
                "surveyNo",
                surveyNo
        );

        return "apt/mgmtOffice/survey/mngr_survey_detail";
    }

    @GetMapping({"/{mgmtOfcNo}/detail", "/{mgmtOfcNo}/detail/"})
    public String surveyDetailFallback(
            @PathVariable String mgmtOfcNo
    ) {

        return "redirect:/manager/survey/" + mgmtOfcNo;
    }

    @GetMapping("/{mgmtOfcNo}/detail/{surveyNo}/data")
    @ResponseBody
    public ResponseEntity<?> selectSurveyDetail(
            @PathVariable String mgmtOfcNo,
            @PathVariable String surveyNo
    ) {

        return ResponseEntity.ok(
                surveyService
                        .selectSurveyDetail(surveyNo)
        );
    }

    @PutMapping("/{mgmtOfcNo}/detail/{surveyNo}")
    @ResponseBody
    public ResponseEntity<?> updateSurvey(
            @PathVariable String mgmtOfcNo,
            @PathVariable String surveyNo,
            @RequestBody MngSurveyDTO dto
    ) {

        try {

            dto.setSurveyNo(surveyNo);

            String aptComplexNo =
                    managerAccessService.getAptComplexNo(mgmtOfcNo);

            dto.setAptCd(aptComplexNo);

            System.out.println("설문 수정");
            System.out.println(dto);

            surveyService.updateSurvey(dto);

            return ResponseEntity.ok().build();

        } catch (Exception e) {

            e.printStackTrace();

            return ResponseEntity
                    .internalServerError()
                    .body(e.getMessage());
        }
    }



    @DeleteMapping("/{mgmtOfcNo}/detail/{surveyNo}")
    @ResponseBody
    public ResponseEntity<?> deleteSurvey(
            @PathVariable String mgmtOfcNo,
            @PathVariable String surveyNo
    ) {

        surveyService.deleteSurvey(surveyNo);

        return ResponseEntity.ok().build();
    }
    @GetMapping("/{mgmtOfcNo}/result/{surveyNo}")
    public String resultPage(
            @PathVariable String mgmtOfcNo,
            @PathVariable String surveyNo,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {

        managerAccessService.addManagerViewModel(
                model,
                customUser,
                mgmtOfcNo
        );

        model.addAttribute(
                "mgmtOfcNo",
                mgmtOfcNo
        );

        model.addAttribute(
                "surveyNo",
                surveyNo
        );

        return "apt/mgmtOffice/survey/mngr_survey_result";
    }

    @GetMapping({"/{mgmtOfcNo}/result", "/{mgmtOfcNo}/result/"})
    public String resultFallback(
            @PathVariable String mgmtOfcNo
    ) {

        return "redirect:/manager/survey/" + mgmtOfcNo;
    }

    @GetMapping("/{mgmtOfcNo}/result/{surveyNo}/data")
    @ResponseBody
    public ResponseEntity<?> selectSurveyResult(
            @PathVariable String mgmtOfcNo,
            @PathVariable String surveyNo
    ) {

        Map<String, Object> result =
                surveyService.selectSurveyResult(surveyNo);

        result.put(
                "shortAnswerList",
                surveyService.selectShortAnswerList(surveyNo)
        );

        return ResponseEntity.ok(result);
    }
}
