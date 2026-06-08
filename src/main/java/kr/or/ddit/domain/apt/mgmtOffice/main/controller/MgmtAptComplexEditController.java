package kr.or.ddit.domain.apt.mgmtOffice.main.controller;

import kr.or.ddit.domain.apt.main.service.IAptComplexService;
import kr.or.ddit.domain.apt.main.vo.AptDetailGridDTO;
import kr.or.ddit.domain.apt.mgmtOffice.main.service.IMgmtAptComplexEditService;
import kr.or.ddit.domain.apt.mgmtOffice.main.vo.UpdateBuildingStructureDTO;
import kr.or.ddit.domain.apt.mgmtOffice.main.vo.UpdateHoStatusDTO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Controller
@RequestMapping("/manager/complexEdit")
@PreAuthorize("hasRole('MNGR')")
public class MgmtAptComplexEditController {

    @Autowired
    private IAptComplexService aptComplexService;

    @Autowired
    private IMgmtAptComplexEditService mgmtAptComplexEditService;

    @GetMapping("/hoList/{mgmtOfcNo}")
    @ResponseBody
    public List<AptDetailGridDTO> selectComplexList(
            @PathVariable String mgmtOfcNo
    ) {

        return aptComplexService.selectComplexList(mgmtOfcNo);
    }

    @PostMapping("/updateStructure/{mgmtOfcNo}")
    @ResponseBody
    public Map<String, Object> updateStructure(
            @PathVariable String mgmtOfcNo,
            @RequestBody UpdateBuildingStructureDTO dto
    ){

        Map<String, Object> resultMap = new HashMap<>();

        try{

            mgmtAptComplexEditService.updateBuildingStructure(dto);

            resultMap.put("success", true);

        }catch (Exception e){

            resultMap.put("success", false);
            resultMap.put("message", e.getMessage());

        }
        return resultMap;
    }


    @PostMapping("/updateHoStatus/{mgmtOfcNo}")
    @ResponseBody
    public Map<String, Object> updateHoStatus(
            @RequestBody UpdateHoStatusDTO dto,
            @PathVariable String mgmtOfcNo
    ){
        Map<String, Object> resultMap = new HashMap<>();

        dto.setMgmtOfcNo(mgmtOfcNo);

        try{

            mgmtAptComplexEditService.updateHoStatus(dto);

            resultMap.put("success", true);

        }catch(Exception e){

            resultMap.put("success", false);
            resultMap.put("message", e.getMessage());

        }

        return resultMap;
    }


    @PostMapping("/updateHoType/{mgmtOfcNo}")
    @ResponseBody
    public Map<String, Object> updateHoType(
            @PathVariable String mgmtOfcNo
            ,@RequestBody Map<String, Object> paramMap
    ){

        Map<String, Object> resultMap = new HashMap<>();

        try{
            mgmtAptComplexEditService.updateHoType(paramMap);
            resultMap.put("success", true);
        }catch(Exception e){

            log.error("평형 변경 실패", e);

            resultMap.put("success", false);
            resultMap.put("message", e.getMessage());

        }
        return resultMap;
    }

}
