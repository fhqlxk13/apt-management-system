package kr.or.ddit.domain.apt.board.free.controller;

import kr.or.ddit.common.file.vo.AttachFileVO;
import kr.or.ddit.domain.apt.board.free.vo.PaginationInfoVO;
import kr.or.ddit.domain.apt.board.free.service.IResidentBoardService;
import kr.or.ddit.domain.apt.board.free.vo.RsidBoardCommentVO;
import kr.or.ddit.domain.apt.board.free.vo.RsidBoardVO;
import kr.or.ddit.domain.member.vo.CustomUser;
import lombok.RequiredArgsConstructor;
import org.apache.commons.lang3.StringUtils;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/resident")
@RequiredArgsConstructor
public class ResidentBoardController {

    private final IResidentBoardService service;

    /**
     * [게시글 작성]
     * 사용자가 글쓰기 폼을 제출하면 실행됩니다.
     * 1. 로그인한 사용자 ID를 작성자로 세팅
     * 2. 어떤 게시판인지 번호 세팅 (예: apt001_free)
     * 3. 첨부파일이 있으면 구글 드라이브에 업로드
     * 4. 게시글을 DB에 저장
     * 5. 저장 완료 후 목록 페이지로 이동
     */
    //@PreAuthorize("@authService.hasAccess(principal, #aptCmplexNo)")
    @PostMapping("/boardFreeWrite.do")
    public String boardFreeWrite(
            RsidBoardVO rsidBoardVO,
            @RequestParam String aptCmplexNo,
            @RequestParam(required = false) MultipartFile attachFile,
            @AuthenticationPrincipal CustomUser principal) throws IOException {

        rsidBoardVO.setWrtrId(principal.getMember().getUserId());
        rsidBoardVO.setBoardNo(aptCmplexNo + "_free");
        service.insertBoardFree(rsidBoardVO, attachFile);
        System.out.println("aptCmplexNo: " + aptCmplexNo);
        System.out.println("boardNo: " + rsidBoardVO.getBoardNo());
        return "redirect:/resident/boardFreeList/" + aptCmplexNo;
    }

    /**
     * [게시글 목록 조회]
     * 자유게시판 목록 화면을 보여줍니다.
     * 1. 검색어/검색타입이 있으면 조건에 맞는 게시글만 조회
     * 2. 페이징 처리 (한 페이지에 N개씩 나눠서 보여줌)
     * 3. 목록 화면(board_free_list.jsp)으로 데이터 전달
     *
     * URL 예시: /resident/boardFreeList/apt001?searchType=ttl&searchWord=안녕&page=1
     */

    @PreAuthorize("@authService.hasAccess(principal, #aptCmplexNo)")
    @GetMapping("/boardFreeList/{aptCmplexNo}")
    public String boardFreeList(
            @PathVariable String aptCmplexNo,
            @AuthenticationPrincipal CustomUser principal,
            @RequestParam(name = "page", required = false, defaultValue = "1") int currentPage,
            @RequestParam(name = "searchWord", required = false) String searchWord,
            @RequestParam(name = "searchType", required = false) String searchType,
            Model model) {

        PaginationInfoVO<RsidBoardVO> pagingVO = new PaginationInfoVO<>();

        pagingVO.setAptCmplexNo(aptCmplexNo + "_free");
        pagingVO.setCurrentPage(currentPage);

        // 검색어/타입은 한 곳에서만 처리
        if (StringUtils.isNotBlank(searchWord)) {
            pagingVO.setSearchWord(searchWord);
            model.addAttribute("searchWord", searchWord);
        }
        if (StringUtils.isNotBlank(searchType)) {
            pagingVO.setSearchType(searchType);
            model.addAttribute("searchType", searchType);
        }

        int totalRecord = service.selectBoardFreeCount(pagingVO);
        pagingVO.setTotalRecord(totalRecord);

        List<RsidBoardVO> dataList = service.boardFreeList(pagingVO);
        pagingVO.setDataList(dataList);

        model.addAttribute("pagingVO", pagingVO);
        model.addAttribute("aptCmplexNo", aptCmplexNo);

        return "member/resident/board/board_free_list";
    }

    /**
     * [게시글 상세 조회]
     * 목록에서 게시글을 클릭하면 실행됩니다.
     * 1. 조회수 1 증가
     * 2. 해당 게시글의 상세 내용을 DB에서 조회
     * 3. 상세 화면(board_free_detail.jsp)으로 데이터 전달
     *
     * URL 예시: /resident/boardFreeDetail/POST_001/apt001
     */
    @PreAuthorize("@authService.hasAccess(principal, #aptCmplexNo)")
    @GetMapping("/boardFreeDetail/{postNo}/{aptCmplexNo}")
    public String boardFreeDetail(@PathVariable String postNo,
                                  @PathVariable String aptCmplexNo,
                                  @AuthenticationPrincipal CustomUser principal,
                                  RsidBoardVO rsidBoardVO,
                                  Model model){
        System.out.println("=== 상세보기 디버그 ===");
        System.out.println("postNo: " + postNo);
        rsidBoardVO.setPostNo(postNo);
        System.out.println("rsidBoardVO.postNo: " + rsidBoardVO.getPostNo());
        service.updateInqCnt(postNo);
        RsidBoardVO board = service.selectOneBoardFree(rsidBoardVO);
        model.addAttribute("freeBoard", board);
        System.out.println("board.ttl: " + (board != null ? board.getTtl() : "NULL"));
        System.out.println("====================");

        model.addAttribute("freeBoard", board);

        if (board.getAtchFileId() != null) {
            AttachFileVO attachFile = service.selectAttachFile(board.getAtchFileId());
            model.addAttribute("attachFile", attachFile);
        }

        model.addAttribute("aptCmplexNo", aptCmplexNo);
        model.addAttribute("postNo", postNo);
        return "member/resident/board/board_free_detail";
    }

    /**
     * [게시글 수정]
     * 게시글 수정 버튼을 누르면 실행됩니다.
     * 수정된 내용을 DB에 반영하고 성공 여부를 반환합니다.
     *
     * 반환값: {"success": true} 또는 {"success": false}
     */

    @PutMapping("/boardFreeUpdate")
    @ResponseBody
    public Map<String, Object> boardFreeUpdate(@RequestBody RsidBoardVO rsidBoardVO){
        Map<String, Object> result =  new HashMap<>();
        int cnt = service.updateBoardFree(rsidBoardVO);
        result.put("success", cnt > 0);
        return result;
    }

    /**
     * [게시글 삭제]
     * 게시글 삭제 버튼을 누르면 실행됩니다.
     * 실제로 DB에서 지우는 것이 아니라 삭제 상태로 변경합니다. (소프트 삭제)
     *
     * 반환값: {"success": true} 또는 {"success": false}
     */
    @PutMapping("/boardFreeDelete/{postNo}")
    @ResponseBody
    public Map<String, Object> boardFreeDelete(@PathVariable String postNo){
        Map<String, Object> result = new HashMap<>();
        int cnt = service.deleteBoardFree(postNo);
        System.out.println("updateResult: " + cnt);
        result.put("success", cnt > 0);
        return result;
    }

    /**
     * [댓글 작성]
     * 게시글 상세 화면에서 댓글 등록 버튼을 누르면 실행됩니다.
     * 1. 로그인한 사용자 번호를 작성자로 세팅
     * 2. 어떤 게시글의 댓글인지 게시글 번호 세팅
     * 3. DB에 댓글 저장
     *
     * 반환값: {"success": true} 또는 {"success": false}
     */
    @PostMapping("/insertBoardComment/{aptCmplexNo}/{postNo}")
    @ResponseBody
    public Map<String, Object> insertBoardComment(@RequestBody RsidBoardCommentVO rsidBoardCommentVO,
                                                  @PathVariable String aptCmplexNo,
                                                  @PathVariable String postNo,
                                                  @AuthenticationPrincipal CustomUser principal
    ){
        System.out.println("aptCmplexNo: " + aptCmplexNo);
        System.out.println("postNo: " + postNo);
        System.out.println("userNo: " + principal.getMember().getUserNo());
        System.out.println("cmtCn: " + rsidBoardCommentVO.getCmtCn());

        Map<String, Object> result = new HashMap<>();
        rsidBoardCommentVO.setPostNo(postNo);
        rsidBoardCommentVO.setUserNo(principal.getMember().getUserNo());
        int cnt = service.insertBoardComment(rsidBoardCommentVO);
        result.put("success", cnt > 0);
        return result;

    }

    /**
     * [댓글 목록 조회]
     * 게시글 상세 화면에 진입하거나 댓글 작성 후 목록을 새로 불러올 때 실행됩니다.
     * 해당 게시글에 달린 댓글 전체를 JSON 형태로 반환합니다.
     *
     * 반환값: 댓글 목록 리스트 (JSON 배열)
     */
    @GetMapping("/boardFreeComment/{postNo}")
    @ResponseBody
    public List<RsidBoardCommentVO> boardFreeComment(@PathVariable String postNo) {
        return service.boardFreeComment(postNo);
    }

    /**
     * [댓글 수정]
     * 댓글 수정 버튼을 누르면 실행됩니다.
     * 수정된 댓글 내용을 DB에 반영합니다.
     *
     * 반환값: {"success": true} 또는 {"success": false}
     */
    @PutMapping("/updateBoardComment")
    @ResponseBody
    public Map<String, Object> updateBoardComment(@RequestBody RsidBoardCommentVO rsidBoardCommentVO){
        Map<String, Object> result = new HashMap<>();
        int cnt = service.updateBoardComment(rsidBoardCommentVO);
        result.put("success", cnt > 0);
        return result;
    }

    /**
     * [댓글 삭제]
     * 댓글 삭제 버튼을 누르면 실행됩니다.
     * 해당 댓글을 삭제 상태로 변경합니다. (소프트 삭제)
     *
     * 반환값: {"success": true} 또는 {"success": false}
     */
    @PutMapping("/deleteBoardComment/{cmtNo}")
    @ResponseBody
    public Map<String, Object> deleteBoardComment(@PathVariable String cmtNo){
        Map<String, Object> result = new HashMap<>();
        int cnt = service.deleteBoardComment(cmtNo);
        result.put("success", cnt > 0);
        return result;
    }

    /**
     * [대댓글 작성]
     * 댓글에 달린 답글 등록 버튼을 누르면 실행됩니다.
     * 1. 어떤 댓글의 답글인지 부모 댓글 번호 세팅
     * 2. 로그인한 사용자 번호를 작성자로 세팅
     * 3. DB에 대댓글 저장
     *
     * 반환값: {"success": true} 또는 {"success": false}
     */
    @PostMapping("/insertSubComment/{cmtNo}")
    @ResponseBody
    public Map<String, Object> insertSubComment(@RequestBody RsidBoardCommentVO rsidBoardCommentVO,
                                                @PathVariable String cmtNo,
                                                @AuthenticationPrincipal CustomUser principal){
        Map<String, Object> result = new HashMap<>();
        rsidBoardCommentVO.setCmtNo(cmtNo);
        rsidBoardCommentVO.setUserNo(principal.getMember().getUserNo());
        int cnt = service.insertSubComment(rsidBoardCommentVO);
        result.put("success", cnt > 0);
        return result;

    }






}
