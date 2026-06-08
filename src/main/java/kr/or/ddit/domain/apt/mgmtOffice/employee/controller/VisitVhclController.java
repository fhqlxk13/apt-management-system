package kr.or.ddit.domain.apt.mgmtOffice.employee.controller;

import kr.or.ddit.common.config.AuthService;
import kr.or.ddit.domain.apt.main.service.IAptComplexService;
import kr.or.ddit.domain.apt.mgmtOffice.employee.service.IVisitVhclService;
import kr.or.ddit.domain.apt.mgmtOffice.employee.vo.VstVhclRsvtVO;
import kr.or.ddit.domain.member.vo.CustomUser;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Slf4j
@Controller
@RequestMapping("/manager/visit-vehicle")
@RequiredArgsConstructor
public class VisitVhclController {

    private final IVisitVhclService visitVhclService;
    private final AuthService authService;
    private final IAptComplexService aptComplexService;

    /**
     * 방문차량 목록
     */
    @PreAuthorize("hasRole('MNGR') and @authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping({"/management/{mgmtOfcNo}", "/list/{mgmtOfcNo}"})

    public String vehicleList(

            @PathVariable("mgmtOfcNo") String mgmtOfcNo,
            @AuthenticationPrincipal CustomUser user,
            Model model

    ){

        log.info("mgmtOfcNo = {}", mgmtOfcNo);

        String aptCmplexNo =
                aptComplexService
                        .selectOneAptCmplexByMgmtOfcNo(mgmtOfcNo);

        log.info("aptCmplexNo = {}", aptCmplexNo);

        List<VstVhclRsvtVO> vehicleList =
                visitVhclService
                        .getVisitVehicleList(aptCmplexNo);

        log.info("vehicleList size = {}", vehicleList.size());





        model.addAttribute("mgmtOfcNo", mgmtOfcNo);
        model.addAttribute("vehicleList", vehicleList);

        return "apt/mgmtOffice/resident/mngr_visit_auto";
    }

    /**
     * 등록 페이지
     */
    @PreAuthorize("hasRole('MNGR')")
    @GetMapping("/register/{mgmtOfcNo}")
    public String registerPage(

            @PathVariable("mgmtOfcNo") String mgmtOfcNo,
            Model model

    ){

        model.addAttribute("mgmtOfcNo", mgmtOfcNo);

        return "apt/mgmtOffice/resident/mngr_visit_auto_register";
    }

    /**
     * 방문차량 등록
     */
    @PreAuthorize("hasRole('MNGR')")
    @PostMapping("/register")
    public String registerVehicle(

            VstVhclRsvtVO vo,

            @RequestParam("mgmtOfcNo")
            String mgmtOfcNo

    ){

        try {

            vo.setVstSttsCd("WAIT");

            visitVhclService
                    .registerVisitVehicle(vo);

            return "redirect:/manager/visit/auto/"
                    + mgmtOfcNo;

        } catch (Exception e){

            log.error("방문차량 등록 실패", e);

            return "redirect:/manager/visit-vehicle/register/"
                    + mgmtOfcNo;
        }
    }

    /**
     * 상세
     */
    @PreAuthorize("hasRole('MNGR')")
    @GetMapping("/detail/{mgmtOfcNo}/{vstVhclRsvtNo}")
    public String detailPage(

            @PathVariable("mgmtOfcNo") String mgmtOfcNo,
            @PathVariable("vstVhclRsvtNo") String vstVhclRsvtNo,
            Model model

    ){

        VstVhclRsvtVO vehicle =
                visitVhclService
                        .getVisitVehicle(vstVhclRsvtNo);

        if(vehicle == null){

            return "redirect:/manager/visit-vehicle/list/"
                    + mgmtOfcNo;
        }

        model.addAttribute("mgmtOfcNo", mgmtOfcNo);
        model.addAttribute("vehicle", vehicle);

        return "apt/mgmtOffice/resident/mngr_visit_auto_detail";
    }

    /**
     * 수정 페이지
     */
    @PreAuthorize("hasRole('MNGR')")
    @GetMapping("/update/{mgmtOfcNo}/{vstVhclRsvtNo}")
    public String updatePage(

            @PathVariable("mgmtOfcNo") String mgmtOfcNo,
            @PathVariable("vstVhclRsvtNo") String vstVhclRsvtNo,
            Model model

    ){

        VstVhclRsvtVO vehicle =
                visitVhclService
                        .getVisitVehicle(vstVhclRsvtNo);

        if(vehicle == null){

            return "redirect:/manager/visit-vehicle/list/"
                    + mgmtOfcNo;
        }

        model.addAttribute("mgmtOfcNo", mgmtOfcNo);
        model.addAttribute("vehicle", vehicle);

        return "apt/mgmtOffice/resident/mngr_visit_auto_update";
    }

    /**
     * 수정
     */
    @PreAuthorize("hasRole('MNGR')")
    @PostMapping("/update")
    public String updateVehicle(

            VstVhclRsvtVO vo,

            @RequestParam("mgmtOfcNo")
            String mgmtOfcNo

    ){

        try {

            visitVhclService
                    .modifyVisitVehicle(vo);

            return "redirect:/manager/visit-vehicle/list/"
                    + mgmtOfcNo;

        } catch (Exception e){

            log.error("방문차량 수정 실패", e);

            return "redirect:/manager/visit-vehicle/update/"
                    + mgmtOfcNo + "/"
                    + vo.getVstVhclRsvtNo();
        }
    }

    /**
     * 삭제
     */
    @PreAuthorize("hasRole('MNGR')")
    @GetMapping("/delete")
    public String deleteVehicle(

            @RequestParam("vstVhclRsvtNo")
            String vstVhclRsvtNo,

            @RequestParam("mgmtOfcNo")
            String mgmtOfcNo

    ){

        try {

            visitVhclService
                    .removeVisitVehicle(vstVhclRsvtNo);

        } catch (Exception e){

            log.error("방문차량 삭제 실패", e);
        }

        return "redirect:/manager/visit/auto/"
                + mgmtOfcNo;
    }

}