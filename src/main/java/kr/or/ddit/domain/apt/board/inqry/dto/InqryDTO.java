package kr.or.ddit.domain.apt.board.inqry.dto;

import lombok.Data;

import java.util.Date;

/**
 * 입주민 문의게시판 DTO
 *
 */
@Data
public class InqryDTO {

    private String postNo;       // 게시글번호
    private String boardNo;      // 게시판번호
    private String ttl;          // 제목
    private String cn;           // 내용
    private String wrtrId;       // 작성자아이디
    private String prrtCd;       // 문의유형코드
    private Date regDttm;        // 등록일시
    private Date mdfDttm;        // 수정일시
    private int inqCnt;          // 조회수
    private String delYn;        // 삭제여부
    private String atchFileId;   // 첨부파일아이디
    private String opnYn;        // 공개여부

    private String aptCmplexNo;  // 아파트단지번호
    private String boardTyCd;    // 게시판유형코드
    private String boardNm;      // 게시판명

    private String userNo;       // 사용자번호
    private String hoNo;         // 세대번호
    private String wrtrNm;       // 작성자명

    private String ansCmtNo;     // 답변댓글번호
    private String ansCn;        // 답변내용
    private Date ansRegDttm;     // 답변등록일시
    private Date ansMdfDttm;     // 답변수정일시
    private String ansUserNo;    // 답변작성자번호
    private String ansUserNm;    // 답변작성자명
    private String ansYn;        // 답변여부
}
