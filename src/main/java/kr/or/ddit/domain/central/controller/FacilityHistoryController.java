package kr.or.ddit.domain.central.controller;


import kr.or.ddit.common.file.service.IAttachFileService;
import kr.or.ddit.common.file.vo.AttachFileVO;
import kr.or.ddit.common.model.PaginationInfoVO;
import kr.or.ddit.domain.central.dto.FacilityInfoDTO;
import kr.or.ddit.domain.central.service.IFacilityHistoryService;
import kr.or.ddit.domain.central.service.IFacilityInfoService;
import kr.or.ddit.domain.central.vo.FacilityHistoryVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;


@Slf4j
@Controller
@RequestMapping("/facility")
public class FacilityHistoryController {

    @Autowired
    private IFacilityHistoryService facilityHistoryService;

    @Autowired
    private IFacilityInfoService facilityInfoService;

    @Autowired
    private IAttachFileService attachFileService;


    @GetMapping("/history.do")
    public String facilityHistory(
            FacilityInfoDTO dto,
            @RequestParam(value = "searchYn", required = false) String searchYn,
            @RequestParam(value = "facilityPage", defaultValue = "1") int facilityPage,
            @RequestParam(value = "currentPage", required = false, defaultValue = "1") int currentPage,
            Model model
    ) {

        boolean searched = "Y".equals(searchYn);

        List<FacilityHistoryVO> list = facilityHistoryService.getFacilityHistoryList();

        List<FacilityInfoDTO> facilityInfoList = null;
        List<FacilityInfoDTO> facilityPageList = null; // 시설사항 표에 실제로 보여줄 5개 목록
        FacilityInfoDTO aptInfo = null;
        List<FacilityInfoDTO> aptCardList = null;

        String detailMessage = null;
        String detailErrorMessage = null;

        /*
         * PaginationInfoVO란?
         * → 페이징 계산을 대신 해주는 공통 객체.
         *
         * 왜 사용?
         * → startRow, endRow, totalPage, Prev/Next HTML을 직접 계산하지 않아도 된다.
         *
         * screenSize = 8
         * → 카드 4개 x 2줄 = 한 페이지에 8개 출력.
         */
        PaginationInfoVO<FacilityInfoDTO> pagingVO = new PaginationInfoVO<>(8, 5);
        pagingVO.setCurrentPage(currentPage);
        pagingVO.setSearchVO(dto);

        if (searched) {

            /*
             * 검색 조건 + 페이징 row 값을 DTO에 세팅
             * Mapper XML에서 #{startRow}, #{endRow}로 사용한다.
             */
            dto.setStartRow(pagingVO.getStartRow());
            dto.setEndRow(pagingVO.getEndRow());

            int totalRecord = facilityInfoService.getAptCardTotalCount(dto);

            pagingVO.setTotalRecord(totalRecord);
            pagingVO.setCurrentPage(currentPage);

            dto.setStartRow(pagingVO.getStartRow());
            dto.setEndRow(pagingVO.getEndRow());

            aptCardList = facilityInfoService.getAptCardList(dto);

            /*
             * 단지 카드 이미지 세팅
             *
             * imgFileNo란?
             * → APT_COMPLEX 테이블의 이미지 파일 그룹 번호.
             *
             * setFileMetaData란?
             * → 파일 그룹 번호로 ATTACH_FILE 정보를 조회해서
             *   AttachFileVO 목록으로 만들어주는 공통 파일 서비스.
             *
             * 왜 사용?
             * → JSP 카드에서 구글드라이브 이미지 ID를 꺼내서
             *   실제 사진을 보여주기 위해.
             */
            if (aptCardList != null) {
                for (FacilityInfoDTO apt : aptCardList) {

                    if (apt.getImgFileNo() != null && !apt.getImgFileNo().isBlank()) {

                        List<AttachFileVO> fileList =
                                attachFileService.setFileMetaData(apt.getImgFileNo());

                        apt.setFileList(fileList);
                    }
                }
            }

            pagingVO.setDataList(aptCardList);
        } // ✅ if (searched) 종료

        if (dto.getAptCmplexNo() != null && !dto.getAptCmplexNo().isEmpty()) {

            try {
                facilityInfoList = facilityInfoService.getFacilityInfoList(dto);

                /*
                 * 시설사항 전용 페이징
                 *
                 * screenSize = 5
                 * → 시설사항 표에 한 페이지당 5개만 보여준다.
                 *
                 * blockSize = 5
                 * → 페이지 번호를 1 2 3 4 5 형태로 5개씩 보여준다.
                 */
                PaginationInfoVO<FacilityInfoDTO> facilityPagingVO = new PaginationInfoVO<>(5, 5);
                facilityPagingVO.setCurrentPage(facilityPage);

                if (facilityInfoList != null && !facilityInfoList.isEmpty()) {

                    /*
                     * totalRecord
                     * → 전체 시설 개수.
                     */
                    facilityPagingVO.setTotalRecord(facilityInfoList.size());

                    /*
                     * subList용 index 계산
                     *
                     * subList는 0부터 시작한다.
                     * 예) 1페이지: 0 ~ 5 전
                     * 예) 2페이지: 5 ~ 10 전
                     */
                    int startIndex = (facilityPage - 1) * 5;
                    int endIndex = Math.min(startIndex + 5, facilityInfoList.size());

                    facilityPageList = facilityInfoList.subList(startIndex, endIndex);

                    aptInfo = facilityInfoList.get(0);

                } else {
                    detailMessage = "조회된 데이터가 없습니다.";
                }

                model.addAttribute("facilityPagingVO", facilityPagingVO);
                model.addAttribute("facilityPageList", facilityPageList);
                model.addAttribute("facilityPage", facilityPage);

                if (facilityInfoList != null && !facilityInfoList.isEmpty()) {
                    aptInfo = facilityInfoList.get(0);
                } else {
                    detailMessage = "조회된 데이터가 없습니다.";
                }

            } catch (Exception e) {
                log.error("단지 시설 상세정보 조회 중 오류 발생", e);
                detailErrorMessage = "단지 시설정보를 불러오는 중 에러가 발생했습니다.";
            }
        }

        List<String> sidoList = facilityInfoService.getSidoList();

        /*
         * 시설유형 select box용 공통코드 조회
         */
        List<String> facilityTypeList = facilityInfoService.getFacilityTypeList();
        model.addAttribute("facilityTypeList", facilityTypeList);

        List<String> sigunguList = null;

        if (dto.getSidoNm() != null && !dto.getSidoNm().isEmpty()) {
            sigunguList = facilityInfoService.getSigunguList(dto.getSidoNm());
        }

        model.addAttribute("list", list);
        model.addAttribute("dto", dto);
        model.addAttribute("searched", searched);
        model.addAttribute("aptInfo", aptInfo);
        model.addAttribute("facilityInfoList", facilityInfoList);
        model.addAttribute("aptCardList", aptCardList);
        model.addAttribute("pagingVO", pagingVO);
        model.addAttribute("sidoList", sidoList);
        model.addAttribute("sigunguList", sigunguList);
        model.addAttribute("detailMessage", detailMessage);
        model.addAttribute("detailErrorMessage", detailErrorMessage);

        return "central/facility/fac-mnt-history";
    }

    @GetMapping("/checkHistory.do")
    public String facilityCheckHistory() {
        return "central/facility/fac-chk-history";
    }

    @GetMapping("/historyDetail.do")
    public String detail(@RequestParam String id, Model model) {

        FacilityHistoryVO data = facilityHistoryService.getFacilityHistoryDetail(id);

        model.addAttribute("data", data);

        return "central/facility/fac-mnt-historyDetail";
    }


}
