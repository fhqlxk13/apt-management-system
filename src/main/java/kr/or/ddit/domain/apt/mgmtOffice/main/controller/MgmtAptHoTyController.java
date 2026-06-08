package kr.or.ddit.domain.apt.mgmtOffice.main.controller;

import kr.or.ddit.domain.apt.apiApartment.vo.AptHoTyDTO;
import kr.or.ddit.domain.apt.mgmtOffice.main.service.IMgmtAptHoTyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/manager/ho-type")
@PreAuthorize("hasRole('MNGR')")
public class MgmtAptHoTyController {

    @Autowired
    private IMgmtAptHoTyService hoTyService;

    @GetMapping("/hoTyList/{mgmtOfcNo}")
    @ResponseBody
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    public List<AptHoTyDTO> selectHoTypeList(@PathVariable String mgmtOfcNo) {

        /*mgmtOfcNo 로 hotyList 가져오기*/
        return hoTyService.selectHoTypeList(mgmtOfcNo);
    }

    /**
     * 평형 타입 insert 하는 메서드
     * @param mgmtOfcNo 관리사무소번호
     * @param aptHoTyDTO form 에서 작성된 평형 타입 정보
     * @param imageFile 첨부파일
     */
    @PostMapping("/insert/{mgmtOfcNo}")
    @ResponseBody
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    public ResponseEntity<Map<String, Object>> insertHoType(
            @PathVariable String mgmtOfcNo,
            AptHoTyDTO aptHoTyDTO,
            @RequestParam(required = false)
            MultipartFile imageFile
    ) {

        Map<String, Object> result = new HashMap<>();
        try{
            hoTyService.insertHoType(mgmtOfcNo, aptHoTyDTO,imageFile);
            result.put("success", true);
        }catch(Exception e){
            e.printStackTrace();
            result.put("success", false);
        }
        return ResponseEntity.ok(result);
    }


    @PostMapping("/update/{mgmtOfcNo}")
    @ResponseBody
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    public ResponseEntity<Map<String, Object>> updateHoType(
            @PathVariable String mgmtOfcNo,
            AptHoTyDTO aptHoTyDTO,
            @RequestParam(required = false)
            MultipartFile imageFile
    ) {
        Map<String, Object> result = new HashMap<>();
        try{
            hoTyService.updateHoType(
                    mgmtOfcNo,
                    aptHoTyDTO,
                    imageFile
            );
            result.put("success", true);
        }catch(Exception e){
            e.printStackTrace();
            result.put("success", false);
        }
        return ResponseEntity.ok(result);
    }


    @PostMapping("/delete/{mgmtOfcNo}")
    @ResponseBody
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    public ResponseEntity<Map<String, Object>> deleteHoType(

            @PathVariable String mgmtOfcNo,

            @RequestParam String hoTyNo

    ) {

        Map<String, Object> result =
                new HashMap<>();

        try{

            hoTyService.deleteHoType(
                    mgmtOfcNo,
                    hoTyNo
            );

            result.put("success", true);

        }catch(Exception e){

            e.printStackTrace();

            result.put("success", false);

            result.put(
                    "message",
                    e.getMessage()
            );
        }

        return ResponseEntity.ok(result);
    }

}
