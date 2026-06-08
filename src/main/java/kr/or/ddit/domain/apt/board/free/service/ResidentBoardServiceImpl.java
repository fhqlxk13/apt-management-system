package kr.or.ddit.domain.apt.board.free.service;

import kr.or.ddit.common.api.google.service.GoogleDriveService;
import kr.or.ddit.common.file.mapper.IAttachFileMapper;
import kr.or.ddit.common.file.vo.AttachFileVO;
import kr.or.ddit.domain.apt.board.free.vo.PaginationInfoVO;
import kr.or.ddit.domain.apt.board.free.mapper.IResidentBoardMapper;
import kr.or.ddit.domain.apt.board.free.vo.RsidBoardCommentVO;
import kr.or.ddit.domain.apt.board.free.vo.RsidBoardVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class ResidentBoardServiceImpl implements IResidentBoardService {

    private final IResidentBoardMapper mapper;
    private final GoogleDriveService googleDriveService;
    private final IAttachFileMapper iAttachFileMapper;


    // 댓글 목록 조회
    @Override
    public List<RsidBoardCommentVO> boardFreeComment(String postNo) {
        return mapper.boardFreeComment(postNo);
    }

    // 댓글 수정
    @Transactional
    @Override
    public int updateBoardComment(RsidBoardCommentVO rsidBoardCommentVO) {
        return mapper.updateBoardComment(rsidBoardCommentVO);
    }

    // 댓글 삭제
    @Transactional
    @Override
    public int deleteBoardComment(String cmtNo) {
        return mapper.deleteBoardComment(cmtNo);
    }

    // 대댓글(답글) insert
    @Transactional
    @Override
    public int insertSubComment(RsidBoardCommentVO rsidBoardCommentVO) {
        return mapper.insertSubComment(rsidBoardCommentVO);
    }

    // 첨부파일 그룹 번호(fileGroupNo)로 DB에서 첨부파일 단건을 조회
    @Override
    public AttachFileVO selectAttachFile(String fileGroupNo) {
        return mapper.selectAttachFile(fileGroupNo);
    }

    // 댓글 달기
    @Transactional
    @Override
    public int insertBoardComment(RsidBoardCommentVO rsidBoardCommentVO) {
        return mapper.insertBoardComment(rsidBoardCommentVO);
    }

    // 게시글 삭제(상태만 변경)
    @Transactional
    @Override
    public int deleteBoardFree(String postNo) {
        return mapper.deleteBoardFree(postNo);
    }

    // 게시글 수정
    @Transactional
    @Override
    public int updateBoardFree(RsidBoardVO rsidBoardVO) {
        return mapper.updateBoardFree(rsidBoardVO);
    }

    // 조회수 증가
    @Transactional
    @Override
    public void updateInqCnt(String postNo) {
        mapper.updateInqCnt(postNo);
    }

    // 게시글 목록 조회
    @Override
    public List<RsidBoardVO> boardFreeList(PaginationInfoVO<RsidBoardVO> pagingVO) {
        return mapper.boardFreeList(pagingVO);
    }

    // 게시글 단건 조회
    @Override
    public RsidBoardVO selectOneBoardFree(RsidBoardVO rsidBoardVO) {
        return mapper.selectOneBoardFree(rsidBoardVO);
    }


    /*  파일업로드 메서드
        글 작성 요청
            ↓
        첨부파일이 있으면? → 구글 드라이브에 업로드 → DB에 파일 정보 저장
            ↓
        게시글 DB에 저장
     */
    @Transactional
    @Override
    public void insertBoardFree(RsidBoardVO rsidBoardVO, MultipartFile attachFile) throws IOException {

        System.out.println("aptCmplexNo: " + rsidBoardVO.getAptCmplexNo());
        System.out.println("boardNo: " + rsidBoardVO.getBoardNo());

        // ① 게시판 인스턴스 없으면 자동 생성 (추가!)
        mapper.mergeFreeBoardInstance(rsidBoardVO.getAptCmplexNo());

        // ② board_no 세팅 (추가!)
        rsidBoardVO.setBoardNo(rsidBoardVO.getAptCmplexNo() + "_free");

        // ① 첨부파일 확인
        if (attachFile != null && !attachFile.isEmpty()) {
            String originalFilename = attachFile.getOriginalFilename();

            // ②파일명 만들기
            // 같은 이름의 파일이 충돌하지 않도록 앞에 랜덤 문자열을 붙입니다.
            String uuid = UUID.randomUUID().toString().replace("-", "");
            String savedFileName = uuid + "_" + originalFilename;

            // ③ 저장 경로 설정
            // 구글 드라이브 내 저장 위치를 지정합니다.
            String folderPath = "board/free/" + rsidBoardVO.getWrtrId();
            String fullPath = folderPath + "/" + savedFileName;

            // ④ 구글 드라이브에 업로드
            // 실제 파일을 구글 드라이브에 올리고, 업로드된 파일의 구글 파일 ID를 받아옵니다.
            String googleId = googleDriveService.uploadFile(attachFile, folderPath, savedFileName);

            long seq = iAttachFileMapper.getSeqFileGroupNo();
            AttachFileVO attachFileVO = AttachFileVO.fileSettings(
                    attachFile, seq, "board_free", savedFileName, googleId, fullPath, 1
            );

            // ⑤ 파일 정보를 DB에 저장
            // 파일명, 구글 ID, 경로 등을 DB의 첨부파일 테이블에 저장합니다.
            iAttachFileMapper.insertAttachFile(attachFileVO);

            rsidBoardVO.setAtchFileId(String.valueOf(attachFileVO.getFileGroupNo()));
        }

        // ⑥ 게시글 저장
        mapper.insertBoardFree(rsidBoardVO);
        System.out.println("atch_file_id 값: " + rsidBoardVO.getAtchFileId());
    }

    // 게시글 목록 페이징 처리
    @Override
    public int selectBoardFreeCount(PaginationInfoVO<RsidBoardVO> pagingVO) {
        return mapper.selectBoardFreeCount(pagingVO);
    }

    //

}
