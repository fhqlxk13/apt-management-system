package kr.or.ddit.domain.apt.main.controller;

import kr.or.ddit.domain.apt.apiApartment.vo.AptHoTyDTO;
import kr.or.ddit.domain.apt.main.service.IMgmtAptComplexService;
import kr.or.ddit.domain.apt.main.vo.ComplexEditDTO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Controller
@RequestMapping("/manager/complex")
@PreAuthorize("hasRole('MNGR')")
public class AptComplexController {

    @Autowired
    private IMgmtAptComplexService mgmtAptComplexService;

    /**
     * 단지 상세조회
     */
    @GetMapping("/detail/{mgmtOfcNo}")
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @ResponseBody
    public ResponseEntity<?> getComplexDetail(
            @PathVariable String mgmtOfcNo
    ) {

        ComplexEditDTO.DetailResponse response =
                mgmtAptComplexService.getComplexDetail(mgmtOfcNo);

        return ResponseEntity.ok(response);
    }

    /**
     * 단지 수정
     */
    @PostMapping("/update/{mgmtOfcNo}")
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> updateComplex(
            @PathVariable String mgmtOfcNo,
            @ModelAttribute ComplexEditDTO.SaveRequest request
    ) {

        Map<String, Object> result = new HashMap<>();

        try {
            log.info("단지 수정 요청 : {}", request);

            mgmtAptComplexService.updateComplex(
                    mgmtOfcNo,
                    request
            );

            result.put("success", true);
            result.put("message", "단지 정보가 수정되었습니다.");

            return ResponseEntity.ok(result);

        } catch (Exception e) {

            log.error("단지 수정 실패", e);

            result.put("success", false);
            result.put("message", "단지 수정 중 오류가 발생했습니다.");

            return ResponseEntity.internalServerError()
                    .body(result);
        }
    }


}