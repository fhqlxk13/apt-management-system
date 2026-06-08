package kr.or.ddit.common.api.react.controller;

import kr.or.ddit.common.api.react.vo.AptManageDetailDTO;
import kr.or.ddit.domain.apt.apiApartment.service.IAptApiService;
import kr.or.ddit.domain.apt.apiApartment.service.IAptMemberApiService;
import kr.or.ddit.domain.apt.apiApartment.vo.AptBass;
import kr.or.ddit.domain.apt.apiApartment.vo.AptComplexEntity;
import kr.or.ddit.domain.apt.main.vo.AptComplexVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@Controller
@Slf4j
@RequestMapping("/api/react/adm/aptCmplex")
public class ReactAptComplexController {

    @Autowired
    private IAptApiService aptService;

    @Autowired
    private IAptMemberApiService aptMemberService;

    /**
     * 아파트 등록
     */
    @PostMapping("/apt/register")
    @ResponseBody
    public String registerApt(
            @RequestBody Map<String, Object> param
    ) {

        List<String> kaptCodeList =
                (List<String>) param.get("kaptCodeList");

        log.info("등록 요청 단지 수 : {}", kaptCodeList.size());

        aptService.registerAptList(kaptCodeList);

        return "등록 완료";
    }

    /**
     * 시도 목록
     */
    @GetMapping("/sido")
    @ResponseBody
    public List<String> getSido() {
        return aptMemberService.getSidoList();
    }

    /**
     * 시군구 목록
     */
    @GetMapping("/sigungu")
    @ResponseBody
    public List<String> getSigungu(
            @RequestParam String sido
    ) {

        return aptMemberService.getSigunguList(sido);
    }

    /**
     * 법정동 목록
     */
    @GetMapping("/emd")
    @ResponseBody
    public List<String> getEmd(
            @RequestParam String sido,
            @RequestParam String sigungu
    ) {

        return aptMemberService.getEmdList(
                sido,
                sigungu
        );
    }

    /**
     * 아파트 목록 조회
     */
    @GetMapping("/aptList")
    @ResponseBody
    public List<AptComplexEntity> getAptList(

            @RequestParam(required = false)
            String sido,

            @RequestParam(required = false)
            String sigungu,

            @RequestParam(required = false)
            String emd

    ) {

        return aptMemberService.getAptList(
                sido,
                sigungu,
                emd
        );
    }

    /**
     * 기본정보 조회
     */
    @PostMapping("/apt/checkBaseInfo")
    @ResponseBody
    public List<AptBass> checkBaseInfo(
            @RequestBody Map<String, String> param
    ) {

        String sido = param.get("sido");
        String sigungu = param.get("sigungu");
        String emd = param.get("emd");

        log.info(
                "checkBaseInfo : {} {} {}",
                sido,
                sigungu,
                emd
        );

        return aptService.checkBaseInfo(
                sido,
                sigungu,
                emd
        );
    }

    /**
     * 좌표 업데이트
     */
    @PostMapping("/updateLatLng.do")
    @ResponseBody
    public String updateLatLng() {

        aptService.updateLatLng();

        return "좌표 업데이트 완료";
    }

    @GetMapping("/apt/detail/{kaptCode}")
    @ResponseBody
    public AptManageDetailDTO getDetail(
            @PathVariable String kaptCode
    ) {
        return aptService.getDetail(kaptCode);
    }

    @PostMapping("/apt/save")
    @ResponseBody
    public String saveApartment(
            @RequestBody AptManageDetailDTO dto
    ) {

        log.info(
                "saveApartment : {}",
                dto.getComplex()
                        .getAptCmplexNo()
        );

        aptService.saveApartment(dto);

        log.info(
                "aptCmplexNo={}",
                dto.getComplex()
                        .getAptCmplexNo()
        );

        log.info(
                "ccCnt={}",
                dto.getComplex()
                        .getCcCnt()
        );

        log.info(
                "freePkgCnt={}",
                dto.getComplex()
                        .getFreePkgCnt()
        );

        return "저장 완료";
    }
}
