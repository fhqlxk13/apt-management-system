package kr.or.ddit.domain.apt.board.free.vo;

import lombok.Data;

import java.util.Date;

@Data
public class RsidBoardVO {

    private String postNo;      // 게시글 번호 (PK)
    private String boardNo;     // 게시판 번호 (FK)
    private String ttl;         // 제목
    private String cn;          // 내용
    private String wrtrId;      // 작성자 ID (저장·권한 확인용)
    private String wrtrNm;      // 작성자 이름 (화면 표시용)
    private String prrtCd;      // 우선순위 코드
    private Date regDttm;       // 등록일시
    private Date mdfDttm;       // 수정일시
    private int inqCnt;         // 조회수
    private String delYn;       // 삭제여부
    private String atchFileId;  // 첨부파일
    private String opnYn;       // 공개여부
    private String aptCmplexNo; // 아파트 단지 번호 (검색용)
}
