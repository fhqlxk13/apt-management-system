package kr.or.ddit.domain.apt.mgmtOffice.resident.controller;

import kr.or.ddit.domain.apt.mgmtOffice.resident.service.IMngResidentAuthService;
import kr.or.ddit.domain.apt.mgmtOffice.resident.vo.MngResidentAuthVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/office/resident/auth")
@RequiredArgsConstructor
public class MngResidentAuthController {

    private final IMngResidentAuthService residentAuthService;



    @GetMapping("/list.do")
    public String residentAuthPage(Model model) {

        List<MngResidentAuthVO> residentAuthList
                = residentAuthService.selectResidentAuthList();

        System.out.println("residentAuthList = " + residentAuthList);

        model.addAttribute("residentAuthList", residentAuthList);

        return "apt/mgmtOffice/resident/mngr_resident_auth";
    }
    @PostMapping("/reject")
    @ResponseBody
    public Map<String, Object> rejectResidentAuth(
            @RequestBody MngResidentAuthVO vo
    ) {

        Map<String, Object> result = new HashMap<>();

        int res = residentAuthService.rejectResidentAuth(vo);

        result.put("success", res > 0);

        return result;
    }
    @PostMapping("/approve")
    @ResponseBody
    public Map<String, Object> approveResidentAuth(
            @RequestBody MngResidentAuthVO vo
    ) {

        Map<String, Object> result = new HashMap<>();

        int res = residentAuthService.approveResidentAuth(vo);

        result.put("success", res > 0);

        return result;
    }

}