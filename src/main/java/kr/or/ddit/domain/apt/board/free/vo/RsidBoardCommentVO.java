package kr.or.ddit.domain.apt.board.free.vo;

import lombok.Data;

import java.util.Date;

@Data
public class RsidBoardCommentVO {

    private String cmtNo;       // 댓글 번호
    private String postNo;      // 게시글 번호
    private long cmtGroup;      // 댓글 그룹
    private String cmtCn;       // 댓글 내용
    private long cmtSortOrd;    // 댓글 정렬 순서
    private Date regDttm;       // 등록일시
    private String delYn;       // 삭제여부
    private Date mdfDttm;       // 수정일시
    private String userNo;      // 사용자번호
    private String userId;      // 사용자 아이디 (권한 확인용)
    private String userNm;      // 사용자 이름 (화면 표시용)
}
