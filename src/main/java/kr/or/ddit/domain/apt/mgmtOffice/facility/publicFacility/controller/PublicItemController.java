package kr.or.ddit.domain.apt.mgmtOffice.facility.publicFacility.controller;

import kr.or.ddit.domain.apt.mgmtOffice.common.service.IManagerModelService;
import kr.or.ddit.domain.apt.mgmtOffice.facility.publicFacility.service.IPublicFacilityService;
import kr.or.ddit.domain.apt.mgmtOffice.facility.publicFacility.service.IPublicItemService;
import kr.or.ddit.domain.apt.mgmtOffice.facility.publicFacility.vo.PublicItemVO;
import kr.or.ddit.domain.member.vo.CustomUser;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 공용시설 아이템 Controller
 * - 아이템 CRUD는 publicFacilityDetail.jsp 모달에서 처리
 * - 화면 전환 없이 JSON 응답으로만 동작
 * - ADMIN은 조회만 가능, 등록/수정/삭제 차단
 */
@Slf4j
@Controller
@RequiredArgsConstructor
@RequestMapping("/manager/publicFacility/item")
public class PublicItemController {

    private final IPublicFacilityService publicFacilityService;
    private final IPublicItemService publicItemService;
    private final IManagerModelService managerModelService;

    /**
     * 전체 자원 목록 조회 (JSON) - publicFacilityItemList.jsp용
     * - 관리사무소 기준 전체 PUBLIC_ITEM 조회
     * - 편의시설명 JOIN 포함
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @ResponseBody
    @GetMapping("/list-all/{mgmtOfcNo}")
    public Map<String, Object> getPublicItemListAll(@PathVariable String mgmtOfcNo) {
        Map<String, Object> result = new HashMap<>();
        try {
            List<PublicItemVO> itemList = publicItemService.selectPublicItemListAll(mgmtOfcNo);
            result.put("success", true);
            result.put("itemList", itemList);
        } catch (Exception e) {
            log.error("전체 자원 목록 조회 중 오류 발생", e);
            result.put("success", false);
            result.put("message", "조회 중 오류가 발생했습니다.");
        }
        return result;
    }

    /**
     * 공용아이템 상세 조회 (JSON)
     * - 모달 열릴 때 detail/update 모드에서 호출
     * - 자원 정보 + 상위 편의시설 정보 + 동일 시설 자원 목록 반환
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @ResponseBody
    @GetMapping("/detail/{mgmtOfcNo}/{cmnFacilityItemNo}")
    public Map<String, Object> getPublicItemDetail(
            @PathVariable String mgmtOfcNo,
            @PathVariable String cmnFacilityItemNo
    ) {
        Map<String, Object> result = new HashMap<>();
        try {
            /* 자원 상세 조회 */
            PublicItemVO item = publicItemService.selectPublicItemDetail(cmnFacilityItemNo);
            if (item == null) {
                result.put("success", false);
                result.put("message", "자원 정보를 찾을 수 없습니다.");
                return result;
            }

            /* 상위 편의시설 정보 조회 */
            Map<String, Object> paramMap = new HashMap<>();
            paramMap.put("mgmtOfcNo", mgmtOfcNo);
            paramMap.put("cmnFacilityNo", item.getCmnFacilityNo());
            var facility = publicFacilityService.selectPublicFacilityDetail(paramMap);

            /* 동일 시설 자원 목록 조회 (현재 자원 제외) */
            List<PublicItemVO> siblingList = publicItemService.selectPublicItemList(item.getCmnFacilityNo());

            result.put("success",     true);
            result.put("item",        item);
            result.put("facility",    facility);
            result.put("siblingList", siblingList);
        } catch (Exception e) {
            log.error("공용아이템 상세 조회 중 오류 발생", e);
            result.put("success", false);
            result.put("message", "조회 중 오류가 발생했습니다.");
        }
        return result;
    }

    /**
     * 공용아이템 등록 처리 (JSON)
     * - ADMIN 차단
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @ResponseBody
    @PostMapping("/insert/{mgmtOfcNo}")
    public Map<String, Object> insertPublicItem(
            @PathVariable String mgmtOfcNo,
            @RequestBody PublicItemVO publicItemVO,
            @AuthenticationPrincipal CustomUser customUser
    ) {
        Map<String, Object> result = new HashMap<>();

        if (managerModelService.isAdmin(customUser)) {
            result.put("success", false);
            result.put("message", "권한이 없습니다.");
            return result;
        }

        if (publicItemVO.getCmnFacilityNo() == null || publicItemVO.getCmnFacilityNo().isBlank()) {
            result.put("success", false);
            result.put("message", "공용시설 번호가 없습니다.");
            return result;
        }

        try {
            int row = publicItemService.insertPublicItem(publicItemVO);
            result.put("success", row > 0);
            result.put("message", row > 0 ? "자원이 등록되었습니다." : "등록에 실패했습니다.");
        } catch (Exception e) {
            log.error("공용아이템 등록 중 오류 발생", e);
            result.put("success", false);
            result.put("message", "등록 중 오류가 발생했습니다.");
        }
        return result;
    }

    /**
     * 공용아이템 수정 처리 (JSON)
     * - ADMIN 차단
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @ResponseBody
    @PostMapping("/update/{mgmtOfcNo}")
    public Map<String, Object> updatePublicItem(
            @PathVariable String mgmtOfcNo,
            @RequestBody PublicItemVO publicItemVO,
            @AuthenticationPrincipal CustomUser customUser
    ) {
        Map<String, Object> result = new HashMap<>();

        if (managerModelService.isAdmin(customUser)) {
            result.put("success", false);
            result.put("message", "권한이 없습니다.");
            return result;
        }

        if (publicItemVO.getCmnFacilityItemNo() == null || publicItemVO.getCmnFacilityItemNo().isBlank()) {
            result.put("success", false);
            result.put("message", "아이템 번호가 없습니다.");
            return result;
        }

        try {
            int row = publicItemService.updatePublicItem(publicItemVO);
            result.put("success", row > 0);
            result.put("message", row > 0 ? "자원이 수정되었습니다." : "수정에 실패했습니다.");
        } catch (Exception e) {
            log.error("공용아이템 수정 중 오류 발생", e);
            result.put("success", false);
            result.put("message", "수정 중 오류가 발생했습니다.");
        }
        return result;
    }

    /**
     * 공용아이템 삭제 처리 (JSON)
     * - ADMIN 차단
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @ResponseBody
    @PostMapping("/delete/{mgmtOfcNo}")
    public Map<String, Object> deletePublicItem(
            @PathVariable String mgmtOfcNo,
            @RequestBody Map<String, String> body,
            @AuthenticationPrincipal CustomUser customUser
    ) {
        Map<String, Object> result = new HashMap<>();

        if (managerModelService.isAdmin(customUser)) {
            result.put("success", false);
            result.put("message", "권한이 없습니다.");
            return result;
        }

        String cmnFacilityItemNo = body == null ? null : body.get("cmnFacilityItemNo");
        if (cmnFacilityItemNo == null || cmnFacilityItemNo.isBlank()) {
            result.put("success", false);
            result.put("message", "아이템 번호가 없습니다.");
            return result;
        }

        try {
            int row = publicItemService.deletePublicItem(cmnFacilityItemNo);
            result.put("success", row > 0);
            result.put("message", row > 0 ? "자원이 삭제되었습니다." : "삭제에 실패했습니다.");
        } catch (Exception e) {
            log.error("공용아이템 삭제 중 오류 발생", e);
            result.put("success", false);
            result.put("message", "삭제 중 오류가 발생했습니다.");
        }
        return result;


    }

    /**
     * 편의시설 자원 자동완성 조회
     * - PUBLIC_FACILITY : 자원 등록 모달에서 상위 편의시설 검색
     * - ITEM_NO         : 자원 탭 필터의 자원번호 검색
     * - FACILITY_NO     : 자원 탭 필터의 편의시설번호 검색
     * - ITEM_NM         : 자원 탭 필터의 자원명 검색
     *
     * ※ 현재는 publicItemService.selectPublicItemSuggest() 하나로 통합 처리
     * ※ 실제 분기는 publicItem_Mapper.xml의 selectPublicItemSuggest에서 처리
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @ResponseBody
    @GetMapping("/suggest/{mgmtOfcNo}")
    public Map<String, Object> suggestPublicFacility(
            @PathVariable String mgmtOfcNo,
            @RequestParam(required = false, defaultValue = "") String suggestType,
            @RequestParam(required = false, defaultValue = "") String keyword
    ) {
        Map<String, Object> result = new HashMap<>();

        try {
            Map<String, Object> paramMap = new HashMap<>();
            paramMap.put("mgmtOfcNo", mgmtOfcNo);
            paramMap.put("suggestType", suggestType);
            paramMap.put("keyword", keyword);

            result.put("success", true);
            result.put("list", publicItemService.selectPublicItemSuggest(paramMap));
        } catch (Exception e) {
            log.error("편의시설 자원 자동완성 조회 중 오류 발생", e);
            result.put("success", false);
            result.put("message", "자동완성 조회 중 오류가 발생했습니다.");
            result.put("list", List.of());
        }

        return result;
    }
    /**
     * 편의시설 자원 목록 조회
     * - 요청 주소: /manager/publicFacility/item/paging/{mgmtOfcNo}
     * - 등록 모달에서 상위 편의시설 선택 후 같은 시설의 기존 자원 목록 표시용
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @ResponseBody
    @GetMapping("/paging/{mgmtOfcNo}")
    public Map<String, Object> getPublicItemPagingList(
            @PathVariable String mgmtOfcNo,
            @RequestParam(required = false) String facilityNo,
            @RequestParam(required = false, defaultValue = "1") int page,
            @RequestParam(required = false, defaultValue = "50") int pageSize
    ) {
        Map<String, Object> result = new HashMap<>();

        try {
            // JS에서 CMN을 떼고 넘길 수도 있어서 CMN 보정
            String cmnFacilityNo = facilityNo;
            if (cmnFacilityNo != null && !cmnFacilityNo.isBlank() && !cmnFacilityNo.startsWith("CMN")) {
                cmnFacilityNo = "CMN" + cmnFacilityNo;
            }

            // 같은 편의시설에 등록된 자원 목록 조회
            List<PublicItemVO> itemList = publicItemService.selectPublicItemList(cmnFacilityNo);

            result.put("success", true);
            result.put("list", itemList);
            result.put("totalCount", itemList == null ? 0 : itemList.size());
        } catch (Exception e) {
            log.error("편의시설 자원 목록 조회 중 오류 발생", e);
            result.put("success", false);
            result.put("message", "자원 목록 조회 중 오류가 발생했습니다.");
            result.put("list", List.of());
            result.put("totalCount", 0);
        }

        return result;
    }
}