package kr.or.ddit.domain.apt.mgmtOffice.resident.controller;

import kr.or.ddit.domain.apt.mgmtOffice.resident.dto.MngResidentListSearchDTO;
import kr.or.ddit.domain.apt.mgmtOffice.resident.service.IMngResidentListService;
import kr.or.ddit.domain.apt.mgmtOffice.resident.vo.MngResidentListVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import kr.or.ddit.domain.member.vo.CustomUser;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@RestController
@RequestMapping("/manager/resident/list/api")
@RequiredArgsConstructor
public class MngResidentListController {

    private final IMngResidentListService residentListService;

    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/{mgmtOfcNo}")
    public ResponseEntity<Map<String, Object>> selectResidentList(
            @PathVariable String mgmtOfcNo,
            @RequestParam(required = false, defaultValue = "") String complexName,
            @RequestParam(required = false, defaultValue = "") String dong,
            @RequestParam(required = false, defaultValue = "") String ho,
            @RequestParam(required = false, defaultValue = "") String householdType,
            @RequestParam(required = false, defaultValue = "") String moveStatus,
            @RequestParam(required = false, defaultValue = "") String keyword,
            @RequestParam(required = false, defaultValue = "") String moveInStart,
            @RequestParam(required = false, defaultValue = "") String moveInEnd,
            @AuthenticationPrincipal CustomUser user
    ) {
        MngResidentListSearchDTO searchDTO = new MngResidentListSearchDTO();
        searchDTO.setMgmtOfcNo(mgmtOfcNo);
        searchDTO.setComplexName(complexName);
        searchDTO.setDong(dong);
        searchDTO.setHo(ho);
        searchDTO.setHouseholdType(householdType);
        searchDTO.setMoveStatus(moveStatus);
        searchDTO.setKeyword(keyword);
        searchDTO.setMoveInStart(moveInStart);
        searchDTO.setMoveInEnd(moveInEnd);

        List<MngResidentListVO> list = residentListService.selectResidentList(searchDTO);

        Map<String, Object> result = new HashMap<>();
        result.put("list", list);
        result.put("count", list.size());
        result.put("liveCnt", list.stream().filter(row -> "LIVE".equals(row.getMoveStatus())).count());
        result.put("outCnt", list.stream().filter(row -> "OUT".equals(row.getMoveStatus())).count());
        result.put("headCnt", list.stream().filter(row -> "HEAD".equals(row.getHouseholdType())).count());
        result.put("memberCnt", list.stream().filter(row -> "MEMBER".equals(row.getHouseholdType())).count());

        return ResponseEntity.ok(result);
    }

    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/{mgmtOfcNo}/{userNo}")
    public ResponseEntity<MngResidentListVO> selectResidentDetail(
            @PathVariable String mgmtOfcNo,
            @PathVariable String userNo,
            @AuthenticationPrincipal CustomUser user
    ) {
        return ResponseEntity.ok(residentListService.selectResidentDetail(mgmtOfcNo, userNo));
    }
}
