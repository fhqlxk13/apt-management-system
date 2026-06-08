package kr.or.ddit.domain.apt.mgmtOffice.move.controller;

import kr.or.ddit.domain.apt.mgmtOffice.move.dto.MngResidentMoveSearchDTO;
import kr.or.ddit.domain.apt.mgmtOffice.move.service.IMngResidentMoveService;
import kr.or.ddit.domain.apt.mgmtOffice.move.vo.MngResidentMoveVO;
import kr.or.ddit.domain.member.vo.CustomUser;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/manager/resident/move/api")
@RequiredArgsConstructor
public class MngResidentMoveController {

    private final IMngResidentMoveService residentMoveService;

    @PreAuthorize("hasAnyRole('MNGR', 'ADMIN') and @authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/{mgmtOfcNo}")
    public ResponseEntity<Map<String, Object>> selectResidentMoveList(
            @PathVariable String mgmtOfcNo,
            @RequestParam(required = false, defaultValue = "") String dong,
            @RequestParam(required = false, defaultValue = "") String ho,
            @RequestParam(required = false, defaultValue = "") String moveStatus,
            @RequestParam(required = false, defaultValue = "") String headYn,
            @RequestParam(required = false, defaultValue = "") String keyword,
            @RequestParam(required = false, defaultValue = "") String moveInStart,
            @RequestParam(required = false, defaultValue = "") String moveInEnd,
            @RequestParam(required = false, defaultValue = "") String moveOutStart,
            @RequestParam(required = false, defaultValue = "") String moveOutEnd,
            @RequestParam(required = false, defaultValue = "1") int currentPage,
            @AuthenticationPrincipal CustomUser user
    ) {

        MngResidentMoveSearchDTO searchDTO = new MngResidentMoveSearchDTO();

        searchDTO.setMgmtOfcNo(mgmtOfcNo);
        searchDTO.setDong(dong);
        searchDTO.setHo(ho);
        searchDTO.setMoveStatus(moveStatus);
        searchDTO.setHeadYn(headYn);
        searchDTO.setKeyword(keyword);
        searchDTO.setMoveInStart(moveInStart);
        searchDTO.setMoveInEnd(moveInEnd);
        searchDTO.setMoveOutStart(moveOutStart);
        searchDTO.setMoveOutEnd(moveOutEnd);

        searchDTO.setCurrentPage(currentPage);

        int screenSize = 10;

        int endRow = currentPage * screenSize;
        int startRow = endRow - (screenSize - 1);

        searchDTO.setStartRow(startRow);
        searchDTO.setEndRow(endRow);



        List<MngResidentMoveVO> list =
                residentMoveService.selectResidentMoveList(searchDTO);

        int totalCount =
                residentMoveService.selectResidentMoveCount(searchDTO);

        Map<String, Object> result = new HashMap<>();

        result.put("list", list);
        result.put("totalCount", totalCount);
        result.put("waitCnt",
                list.stream().filter(row -> "WAIT".equals(row.getMoveStatus())).count());
        result.put("liveCnt",
                list.stream().filter(row -> "LIVE".equals(row.getMoveStatus())).count());
        result.put("outCnt",
                list.stream().filter(row -> "OUT".equals(row.getMoveStatus())).count());
        result.put("midCnt",
                list.stream().filter(row -> "MID".equals(row.getMoveStatus())).count());

        return ResponseEntity.ok(result);
    }

    @PreAuthorize("hasAnyRole('MNGR', 'ADMIN') and @authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/{mgmtOfcNo}/{userNo}/{hoNo}")
    public ResponseEntity<MngResidentMoveVO> selectResidentMoveDetail(
            @PathVariable String mgmtOfcNo,
            @PathVariable String userNo,
            @PathVariable String hoNo,
            @AuthenticationPrincipal CustomUser user
    ) {

        MngResidentMoveVO detail =
                residentMoveService.selectResidentMoveDetail(
                        mgmtOfcNo,
                        userNo,
                        hoNo
                );

        if (detail == null) {
            return ResponseEntity.notFound().build();
        }

        return ResponseEntity.ok(detail);
    }

    @PreAuthorize("hasAnyRole('MNGR', 'ADMIN') and @authService.hasAccess(principal, #mgmtOfcNo)")
    @PostMapping("/{mgmtOfcNo}")
    public ResponseEntity<Map<String, Object>> saveResidentMove(
            @PathVariable String mgmtOfcNo,
            @RequestBody MngResidentMoveVO vo,
            @AuthenticationPrincipal CustomUser user
    ) {

        vo.setMgmtOfcNo(mgmtOfcNo);

        Map<String, Object> result =
                residentMoveService.saveResidentMove(vo);

        return ResponseEntity.ok(result);
    }
    @PreAuthorize("hasAnyRole('MNGR', 'ADMIN') and @authService.hasAccess(principal, #mgmtOfcNo)")
    @PutMapping("/{mgmtOfcNo}/{userNo}/{hoNo}")
    public ResponseEntity<Map<String, Object>> updateResidentMove(
            @PathVariable String mgmtOfcNo,
            @PathVariable String userNo,
            @PathVariable String hoNo,
            @RequestBody MngResidentMoveVO vo,
            @AuthenticationPrincipal CustomUser user
    ) {

        vo.setMgmtOfcNo(mgmtOfcNo);
        vo.setUserNo(userNo);
        vo.setHoNo(hoNo);

        Map<String, Object> result =
                residentMoveService.updateResidentMove(vo);

        return ResponseEntity.ok(result);
    }

    @GetMapping("/member/{userNo}")
    public ResponseEntity<Map<String, Object>> getMemberInfo(
            @PathVariable String userNo
    ) {

        MngResidentMoveVO member =
                residentMoveService.selectMemberInfo(userNo);

        Map<String, Object> result = new HashMap<>();

        if (member == null) {

            result.put("success", false);
            result.put("message", "존재하지 않는 사용자입니다.");

            return ResponseEntity.ok(result);
        }

        result.put("success", true);
        result.put("userNm", member.getUserNm());
        result.put("userTelno", member.getUserTelno());

        return ResponseEntity.ok(result);
    }
}