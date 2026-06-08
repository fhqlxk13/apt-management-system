package kr.or.ddit.domain.apt.mgmtOffice.board.controller;

import kr.or.ddit.domain.apt.board.free.vo.PaginationInfoVO;
import kr.or.ddit.domain.apt.mgmtOffice.board.dto.MngrRegidentNoticeDTO;
import kr.or.ddit.domain.apt.mgmtOffice.board.service.IMngrRegidentNoticeService;
import kr.or.ddit.domain.member.vo.CustomUser;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequiredArgsConstructor
@RequestMapping("/mgmtOffice")
public class MngrResidentNoticeController {

    /*
     * Service 호출 객체
     * → Controller는 DB 직접 접근하지 않고 Service를 통해 처리함.
     */
    private final IMngrRegidentNoticeService mngrRegidentNoticeService;



    /**
     * 관리사무소 공지사항 목록 조회
     * @author 김보라
     * @param mgmtOfcNo 관리사무소번호
     * @param currentPage 현재 페이지 번호
     * @param dto 공지사항 검색조건 DTO
     * @param customUser 로그인 사용자 정보
     * @param model 화면 전달 데이터
     * @return 공지사항 목록 화면 JSP
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/mngrResidentNotice/{mgmtOfcNo}")
    public String mngrResidentNotice(
            @PathVariable String mgmtOfcNo,
            @RequestParam(value = "currentPage", defaultValue = "1") int currentPage,
            @ModelAttribute MngrRegidentNoticeDTO dto,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {

        /*
         * 기본 정렬
         * 1순위: 긴급공지
         * 2순위: 작성일 DESC
         * 3순위: 공지번호 DESC
         */
        if (dto.getSortColumn() == null || dto.getSortColumn().isBlank()) {
            dto.setSortColumn("REG_DTTM");
        }

        if (dto.getSortOrder() == null || dto.getSortOrder().isBlank()) {
            dto.setSortOrder("DESC");
        }

        /*
         * 로그인 관리사무소 기준
         * aptCmplexNo, boardNo 자동 세팅.
         */
        mngrRegidentNoticeService.setManagerNoticeBaseInfo(
                dto,
                customUser,
                mgmtOfcNo
        );

        /*
         * PaginationInfoVO
         * → 페이징 계산 전용 객체.
         * screenSize = 한 페이지에 보여줄 글 개수.
         * blockSize = 화면 아래에 보여줄 페이지 번호 개수.
         *
         * new PaginationInfoVO<>(10, 5)
         * → 게시글은 10개씩, 페이지 번호는 5개씩 보여주겠다는 뜻.
         */
        PaginationInfoVO<MngrRegidentNoticeDTO> pagingVO =
                new PaginationInfoVO<>(10, 5);

        /*
         * 현재 페이지 세팅.
         * setCurrentPage()를 호출하면 startRow/endRow가 자동 계산됨.
         * 예)
         * currentPage = 1 → startRow 1, endRow 10
         * currentPage = 2 → startRow 11, endRow 20
         */
        pagingVO.setCurrentPage(currentPage);

        /*
         * 검색조건 + 페이징 row 범위를 DTO에 세팅.
         * MyBatis XML에서 ROW_NO BETWEEN #{startRow} AND #{endRow}로 사용 중.
         */
        dto.setStartRow(pagingVO.getStartRow());
        dto.setEndRow(pagingVO.getEndRow());

        /*
         * 전체 게시글 수 조회.
         * 검색조건이 있으면 검색 결과 개수만 계산됨.
         */
        int noticeCount = mngrRegidentNoticeService.selectNoticeCount(dto);

        /*
         * 총 게시글 수를 넣으면 totalPage가 자동 계산됨.
         */
        pagingVO.setTotalRecord(noticeCount);

        /*
         * 현재 페이지에 해당하는 공지 목록만 조회.
         */
        List<MngrRegidentNoticeDTO> noticeList =
                mngrRegidentNoticeService.selectNoticeList(dto);

        /*
         * 조회된 목록을 pagingVO 안에도 넣어둠.
         */
        pagingVO.setDataList(noticeList);

        /*
         * JSP 전달 데이터
         */
        model.addAttribute("noticeList", noticeList);
        model.addAttribute("noticeCount", noticeCount);
        model.addAttribute("pagingVO", pagingVO);
        model.addAttribute("searchDTO", dto);

        /*
         * 공통 화면 정보 세팅
         */
        mngrRegidentNoticeService.addManagerViewModel(
                model,
                customUser,
                mgmtOfcNo
        );

        /*
         * 공통 사이드바에서 사용하는 관리사무소 정보
         */
        MngrRegidentNoticeDTO office =
                mngrRegidentNoticeService.selectManagerOfficeInfo(mgmtOfcNo);

        model.addAttribute("office", office);
        model.addAttribute("mgmtOfcNo", mgmtOfcNo);

        return "apt/mgmtOffice/mngrResidentNotice";
    }

    /**
     * 관리사무소 공지사항 수정
     *
     * @author 김보라
     * @param mgmtOfcNo 관리사무소번호
     * @param dto 공지사항 수정 정보 DTO
     * @param uploadFiles 새로 추가할 첨부파일 목록
     * @param deleteAttachYn 기존 첨부파일 삭제 여부
     * @param customUser 로그인 사용자 정보
     * @param ra redirect 후 모달 메시지 전달 객체
     * @return 공지사항 목록 화면 redirect
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @PostMapping("/notice/update/{mgmtOfcNo}")
    public String updateNotice(
            @PathVariable("mgmtOfcNo") String mgmtOfcNo,
            @ModelAttribute MngrRegidentNoticeDTO dto,
            @RequestParam(value = "uploadFiles", required = false) MultipartFile[] uploadFiles,
            /*
             * deleteGoogleIds
             * → 수정 모달에서 삭제 버튼을 누른 기존 첨부파일의 Google Drive ID 목록
             *
             * 왜 Integer가 아니라 String?
             * → ATTACH_FILE 테이블에는 FILE_NO가 없고 GOOGLE_ID가 문자열이기 때문.
             */
            @RequestParam(value = "deleteGoogleIds", required = false)
            List<String> deleteGoogleIds,
            @AuthenticationPrincipal CustomUser customUser,
            RedirectAttributes ra
    ) {
        try {
            /*
             * boardNo, aptCmplexNo, wrtrId 세팅
             */
            mngrRegidentNoticeService.setManagerNoticeBaseInfo(dto, customUser, mgmtOfcNo);

            /*
             * 파일 저장 경로 만들 때 관리사무소번호 사용
             */
            dto.setMgmtOfcNo(mgmtOfcNo);

            /*
             * 공지사항 내용 수정 + 첨부파일 추가/삭제 처리
             */
            int result =
                    mngrRegidentNoticeService.updateNotice(
                            dto,
                            uploadFiles,
                            deleteGoogleIds
                    );
            if (result > 0) {
                ra.addFlashAttribute("modalType", "success");
                ra.addFlashAttribute("modalMsg", "공지사항이 수정되었습니다.");
            } else {
                ra.addFlashAttribute("modalType", "fail");
                ra.addFlashAttribute("modalMsg", "수정할 공지사항을 찾을 수 없습니다.");
            }

        } catch (Exception e) {
            e.printStackTrace();

            ra.addFlashAttribute("modalType", "fail");
            ra.addFlashAttribute("modalMsg", "공지사항 수정 중 오류가 발생했습니다.");
        }

        return "redirect:/mgmtOffice/mngrResidentNotice/" + mgmtOfcNo;
    }

    /**
     * 관리사무소 공지사항 등록
     *
     * @author 김보라
     * @param mgmtOfcNo 관리사무소 번호
     * @param dto 공지사항 등록 정보 DTO
     * @param uploadFiles 첨부파일 객체들
     * @param customUser 로그인 사용자 정보
     * @param rttr redirect 후 모달 메시지 전달 객체
     * @return 공지사항 목록 화면으로 redirect
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @PostMapping("/notice/insert/{mgmtOfcNo}")
    public String insertNotice(
            @PathVariable String mgmtOfcNo,
            @ModelAttribute MngrRegidentNoticeDTO dto,
            @RequestParam(value = "uploadFiles", required = false) MultipartFile[] uploadFiles,
            @AuthenticationPrincipal CustomUser customUser,
            RedirectAttributes rttr
    ) {
        try {
            /*
             * 1. 공지사항 기본 정보 세팅
             * → boardNo, aptCmplexNo, wrtrId 등을 DTO에 넣는다.
             */
            mngrRegidentNoticeService.setManagerNoticeBaseInfo(
                    dto,
                    customUser,
                    mgmtOfcNo
            );

            /*
             * 2. 관리사무소 번호 세팅
             * → ServiceImpl에서 파일 경로 만들 때 사용한다.
             * 예: apt/notice/4/uuid_파일명.jpg
             */
            dto.setMgmtOfcNo(mgmtOfcNo);

            /*
             * 3. 공지사항 + 첨부파일 등록
             * → 파일 저장, ATTACH_FILE insert, 공지사항 insert를 Service에서 처리한다.
             */
            mngrRegidentNoticeService.insertNotice(dto, uploadFiles);

            rttr.addFlashAttribute("modalType", "success");
            rttr.addFlashAttribute("modalMsg", "공지사항이 등록되었습니다.");

        } catch (Exception e) {
            e.printStackTrace();

            rttr.addFlashAttribute("modalType", "fail");
            rttr.addFlashAttribute("modalMsg", "공지사항 등록 중 오류가 발생했습니다.");
        }

        return "redirect:/mgmtOffice/mngrResidentNotice/" + mgmtOfcNo;
    }

    /**
     * 관리사무소 공지사항 상세조회
     * @author 김보라
     * @param mgmtOfcNo 관리사무소번호
     * @param annNo 공지번호
     * @param customUser 로그인 사용자 정보
     * @return 공지사항 상세정보 DTO
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/notice/detail/{mgmtOfcNo}/{annNo}")
    @ResponseBody
    public MngrRegidentNoticeDTO noticeDetail(
            @PathVariable String mgmtOfcNo,
            @PathVariable String annNo,
            @AuthenticationPrincipal CustomUser customUser
    ) {

        /*
         * 조회조건 DTO 생성
         */
        MngrRegidentNoticeDTO dto = new MngrRegidentNoticeDTO();

        /*
         * 공지번호 세팅
         */
        dto.setAnnNo(annNo);

        /*
         * 현재 로그인 관리사무소 기준 boardNo 세팅.
         */
        mngrRegidentNoticeService.setManagerNoticeBaseInfo(
                dto,
                customUser,
                mgmtOfcNo
        );

        /*
         * 상세조회 결과 반환(JSON)
         */
        return mngrRegidentNoticeService.selectNoticeDetail(dto);
    }

    /**
     * 관리사무소 공지사항 삭제
     * @author 김보라
     * @param mgmtOfcNo 관리사무소번호
     * @param annNo 공지번호
     * @param customUser 로그인 사용자 정보
     * @return 공지사항 목록 화면 redirect
     */
    @PostMapping("/notice/delete/{mgmtOfcNo}")
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    public String deleteNotice(
            @PathVariable("mgmtOfcNo") String mgmtOfcNo,
            @RequestParam("annNo") String annNo,
            @AuthenticationPrincipal CustomUser customUser,
            RedirectAttributes ra
    ) {
        try {
            MngrRegidentNoticeDTO dto = new MngrRegidentNoticeDTO();
            dto.setAnnNo(annNo);

            mngrRegidentNoticeService.setManagerNoticeBaseInfo(dto, customUser, mgmtOfcNo);
            int result = mngrRegidentNoticeService.deleteNotice(dto);

            if (result > 0) {
                ra.addFlashAttribute("modalMsg", "공지사항이 삭제되었습니다.");
                ra.addFlashAttribute("modalType", "success");
            } else {
                ra.addFlashAttribute("modalMsg", "삭제할 공지사항을 찾을 수 없습니다.");
                ra.addFlashAttribute("modalType", "fail");
            }

        } catch (Exception e) {
            ra.addFlashAttribute("modalMsg", "공지사항 삭제 중 오류가 발생했습니다.");
            ra.addFlashAttribute("modalType", "fail");
        }

        return "redirect:/mgmtOffice/mngrResidentNotice/" + mgmtOfcNo;
    }
}