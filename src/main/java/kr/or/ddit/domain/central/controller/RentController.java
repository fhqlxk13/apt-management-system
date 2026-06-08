package kr.or.ddit.domain.central.controller;

import kr.or.ddit.common.model.PaginationInfoVO;
import kr.or.ddit.domain.central.dto.RentListingMapDTO;
import kr.or.ddit.domain.central.service.IRentService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Controller
@RequestMapping("/rent")
public class RentController {

    @Autowired
    private IRentService rentService;

    /**
     * 작성자 : 이윤진
     * 임대 매물 지도 화면
     */
    @GetMapping("/map")
    public String rentMap() {
        log.info("임대 매물 지도 화면 진입");
        return "central/rentMap";
    }

    // 임대 매물 목록 화면
    @GetMapping("/list")
    public String rentList( @RequestParam(name = "page", required = false, defaultValue = "1") int currentPage,
                            @RequestParam(name = "searchRentTypeCd", required = false, defaultValue = "ALL") String searchRentTypeCd,
                            @RequestParam(name = "searchRegion", required = false, defaultValue = "ALL") String searchRegion,
                            @RequestParam(name = "searchAmountRange", required = false, defaultValue = "ALL") String searchAmountRange,
                            @RequestParam(name = "searchStatus", required = false, defaultValue = "ALL") String searchStatus,
                            @RequestParam(name = "searchKeyword", required = false) String searchKeyword,
                            Model model) {
        PaginationInfoVO<RentListingMapDTO> pagingVO = new PaginationInfoVO<>();

        // 한 페이지 10개, 페이지 블록 5개를 쓰고 싶으면 기본값 그대로 사용 가능
        pagingVO.setScreenSize(10);
        pagingVO.setBlockSize(5);

        RentListingMapDTO searchVO = new RentListingMapDTO();
        searchVO.setSearchRentTypeCd(searchRentTypeCd);
        searchVO.setSearchRegion(searchRegion);
        searchVO.setSearchAmountRange(searchAmountRange);
        searchVO.setSearchStatus(searchStatus);
        searchVO.setSearchKeyword(searchKeyword);

        pagingVO.setSearchVO(searchVO);

        int totalRecord = rentService.selectRentListingCount(pagingVO);
        pagingVO.setTotalRecord(totalRecord);

        pagingVO.setCurrentPage(currentPage);

        List<RentListingMapDTO> rentList = rentService.selectRentListingPagingList(pagingVO);
        pagingVO.setDataList(rentList);

        model.addAttribute("rentList", rentList);
        model.addAttribute("pagingVO", pagingVO);
        model.addAttribute("searchVO", searchVO);
        return "central/rentList";
    }

    // 임대 매물 목록 JSON
    @GetMapping("/list-data")
    @ResponseBody
    public Map<String, Object> rentListData() {
        Map<String, Object> result = new HashMap<>();

        try {
            List<RentListingMapDTO> list = rentService.selectRentListingMapList();

            result.put("success", true);
            result.put("list", list);

        } catch (Exception e) {
            log.error("매물 목록 조회 중 오류 발생", e);

            result.put("success", false);
            result.put("message", "매물 목록 조회 중 오류가 발생했습니다.");
        }

        return result;
    }

    // 임대 매물 상세 화면
    @GetMapping("/detail/{rentLstgNo}")
    public String rentDetail(@PathVariable String rentLstgNo, Model model) {

        log.info("임대 매물 상세 화면 진입 rentLstgNo={}", rentLstgNo);

        RentListingMapDTO rentDetail = rentService.selectRentListingDetail(rentLstgNo);
        model.addAttribute("rentDetail", rentDetail);

        return "central/rentDetail";
    }

    // 임대 매물 상세 JSON
    @GetMapping("/detail-data/{rentLstgNo}")
    @ResponseBody
    public Map<String, Object> rentDetailData(@PathVariable String rentLstgNo) {
        Map<String, Object> result = new HashMap<>();

        try {
            RentListingMapDTO detail = rentService.selectRentListingDetail(rentLstgNo);

            result.put("success", true);
            result.put("detail", detail);

        } catch (Exception e) {
            log.error("매물 상세 조회 중 오류 발생 rentLstgNo={}", rentLstgNo, e);

            result.put("success", false);
            result.put("message", "매물 상세 조회 중 오류가 발생했습니다.");
        }

        return result;
    }

    @GetMapping("/map-data")
    @ResponseBody
    public Map<String, Object> rentMapData() {
        Map<String, Object> result = new HashMap<>();

        try {
            List<RentListingMapDTO> list = rentService.selectRentMapComplexList();

            result.put("success", true);
            result.put("list", list);

        } catch (Exception e) {
            log.error("지도 마커 목록 조회 중 오류 발생", e);

            result.put("success", false);
            result.put("message", "지도 마커 목록 조회 중 오류가 발생했습니다.");
        }

        return result;
    }

    @GetMapping("/complex-data/{aptCmplexNo}")
    @ResponseBody
    public Map<String, Object> rentComplexData(@PathVariable String aptCmplexNo) {
        Map<String, Object> result = new HashMap<>();

        try {
            List<RentListingMapDTO> list = rentService.selectRentListByComplexNo(aptCmplexNo);

            System.out.println(list.get(0).getRprsntImgGoogleIds());

            result.put("success", true);
            result.put("list", list);

        } catch (Exception e) {
            log.error("단지별 매물 목록 조회 중 오류 발생 aptCmplexNo={}", aptCmplexNo, e);

            result.put("success", false);
            result.put("message", "단지별 매물 목록 조회 중 오류가 발생했습니다.");
        }

        return result;
    }
}
