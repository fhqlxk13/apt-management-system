package kr.or.ddit.domain.apt.board.free.service;

import kr.or.ddit.common.file.vo.AttachFileVO;
import kr.or.ddit.domain.apt.board.free.vo.PaginationInfoVO;
import kr.or.ddit.domain.apt.board.free.vo.RsidBoardCommentVO;
import kr.or.ddit.domain.apt.board.free.vo.RsidBoardVO;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;

public interface IResidentBoardService {

    void insertBoardFree(RsidBoardVO rsidBoardVO, MultipartFile attachFile) throws IOException;

    int selectBoardFreeCount(PaginationInfoVO<RsidBoardVO> pagingVO);

    List<RsidBoardVO> boardFreeList(PaginationInfoVO<RsidBoardVO> pagingVO);

    RsidBoardVO selectOneBoardFree(RsidBoardVO rsidBoardVO);

    int deleteBoardFree(String postNo);

    int updateBoardFree(RsidBoardVO rsidBoardVO);

    void updateInqCnt(String postNo);

    int insertBoardComment(RsidBoardCommentVO rsidBoardCommentVO);

    List<RsidBoardCommentVO> boardFreeComment(String postNo);

    int updateBoardComment(RsidBoardCommentVO rsidBoardCommentVO);

    int deleteBoardComment(String cmtNo);

    int insertSubComment(RsidBoardCommentVO rsidBoardCommentVO);


    AttachFileVO selectAttachFile(String fileGroupNo);
}
