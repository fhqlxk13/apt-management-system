package kr.or.ddit.domain.central.controller;

import kr.or.ddit.common.file.mapper.IAttachFileMapper;
import kr.or.ddit.common.file.service.IAttachFileService;
import kr.or.ddit.common.file.vo.AttachFileVO;
import kr.or.ddit.common.model.PaginationInfoVO;
import kr.or.ddit.domain.apt.main.vo.AptComplexVO;
import kr.or.ddit.domain.central.service.ICentralAptComplexService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.ArrayList;
import java.util.List;

@Slf4j
@Controller
@RequestMapping("/main/apt")
public class AptRetrieveController {

    @Autowired
    private IAttachFileService attachFileService;

    @Autowired
    private ICentralAptComplexService aptComplexService;


    @GetMapping("/list.do")
    public String list(
            AptComplexVO searchVO,
            @RequestParam(value = "initial", required = false) String initial,
            @RequestParam(value = "keyword", required = false) String keyword,
            @RequestParam(value = "page", required = false, defaultValue = "1") int currentPage,
            Model model
    ) {

        /*
         * searchVO에는 JSP name과 같은 필드가 자동으로 들어온다.
         *
         * 예)
         * name="sidoNm"    -> searchVO.setSidoNm(...)
         * name="sigunguNm" -> searchVO.setSigunguNm(...)
         * name="unitCnt"   -> searchVO.setUnitCnt(...)
         */

        log.info("검색 시도 = {}", searchVO.getSidoNm());
        log.info("검색 시군구 = {}", searchVO.getSigunguNm());
        log.info("세대수 조건 코드 = {}", searchVO.getUnitCnt());

        PaginationInfoVO<AptComplexVO> pagingVO = new PaginationInfoVO<>();
        pagingVO.setScreenSize(12);
        pagingVO.setCurrentPage(currentPage);

        /*
         * 기존 검색 조건
         */
        pagingVO.setSearchWord(initial);   // ㄱ~ㅎ 초성
        pagingVO.setSearchType(keyword);   // 단지명 검색어

        /*
         * AptComplexVO 검색조건을 pagingVO에 담아야
         * 기존 service / mapper 구조를 유지할 수 있음
         */
        pagingVO.setSearchVO(searchVO);

        // 총 개수 조회
        int totalRecord = aptComplexService.selectAptComplexCount(pagingVO);
        pagingVO.setTotalRecord(totalRecord);

        // 목록 조회
        pagingVO.setDataList(
                aptComplexService.selectAptComplexList(pagingVO)
        );

        // 시/도 목록 조회
        List<String> sidoList = aptComplexService.selectSidoList();

        model.addAttribute("pagingVO", pagingVO);
        model.addAttribute("searchVO", searchVO);
        model.addAttribute("sidoList", sidoList);

        model.addAttribute("selectedInitial", initial);
        model.addAttribute("keyword", keyword);

        return "central/aptList";
    }

    /*
    * 시, 도 만 조회용, react 검색필터에서 사용중
    * */
    @ResponseBody
    @GetMapping("/sido.do")
    public List<String> sidoList(){
        return aptComplexService.selectSidoList();
    }


    /*
     * 시/도 선택 시 시/군/구 목록 조회 Ajax
     */
    @ResponseBody
    @GetMapping("/sigungu.do")
    public List<String> sigunguList(@RequestParam("sidoNm") String sidoNm) {
        return aptComplexService.selectSigunguList(sidoNm);
    }

    /*
    * 시도/시군구 선택시 읍면동 목록 조회
    */
    @ResponseBody
    @GetMapping("/dong.do")
    public List<String> selectDongList(
            @RequestParam("sidoNm") String sidoNm
            ,@RequestParam("sigunguNm") String sigunguNm){
        return aptComplexService.selectDongList(sidoNm,sigunguNm);
    }


    @GetMapping("/search.do")
    public String search(
            @RequestParam(required = false) String keyword,
            Model model
    ) {

        List<AptComplexVO> aptList = aptComplexService.searchApt(keyword);

        model.addAttribute("aptList", aptList);

        return "central/aptSearch";
    }

    @GetMapping("/dashboard.do")
    public String dashboard() {
        return "central/aptDashboard";
    }

    @GetMapping("/detail.do")
    public String aptDetail(
            @RequestParam("aptCmplexNo") String aptCmplexNo,
            Model model
    ) {

        AptComplexVO aptInfo =
                aptComplexService.selectAptComplexDetail(aptCmplexNo);

        if (aptInfo == null) {
            model.addAttribute(
                    "message",
                    "해당 단지 정보를 찾을 수 없습니다."
            );

            model.addAttribute(
                    "redirectUrl",
                    "/apt/list.do"
            );
            return "common/errorAlert";
        }

        List<AttachFileVO> fileList = new ArrayList<>();
        List<String> layoutGoogleIdList = new ArrayList<>();
        List<String> complexGoogleIdList = new ArrayList<>();

        if(aptInfo.getImgFileNo() != null && !aptInfo.getImgFileNo().isBlank()) {
            fileList = attachFileService.setFileMetaData(aptInfo.getImgFileNo());
            if(fileList != null) {
                for(AttachFileVO file : fileList){
                    if(file == null){
                        continue;
                    }
                    if("layoutImage".equals(file.getCat())){
                        if(file.getGoogleId() != null) {
                            layoutGoogleIdList.add(
                                    file.getGoogleId()
                            );
                        }
                    }
                    if("complexImage".equals(file.getCat())){
                        if(file.getGoogleId() != null) {
                            complexGoogleIdList.add(
                                    file.getGoogleId()
                            );
                        }
                    }
                }
            }
        }
        model.addAttribute("layoutGoogleIdList", layoutGoogleIdList);
        model.addAttribute("complexGoogleIdList", complexGoogleIdList);
        model.addAttribute("aptInfo", aptInfo);

        return "central/aptDetail";
    }

    @GetMapping("/map.do")
    public String aptMap(Model model) {
        List<AptComplexVO> aptList = aptComplexService.selectAptMapList();
        model.addAttribute("aptList", aptList);
        return "central/aptMap";
    }
}
