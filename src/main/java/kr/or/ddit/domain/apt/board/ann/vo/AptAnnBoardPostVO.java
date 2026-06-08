package kr.or.ddit.domain.apt.board.ann.vo;

import lombok.Data;

import java.util.Date;

/**
 * @author 이용로
 */
@Data
public class AptAnnBoardPostVO {
    private String boardNo; // 게시판 번호
    private String annNo;   // 공지 번호
    private String ttl;     // 제목
    private String cn;      // 내용
    private char topFixYn = 'N';    // 상위고정 여부
    private Date pblancBgngDt;      // 게시 시작일
    private Date pblancEndDt;       // 게시 종료일
    private Date regDttm;           // 등록일시
    private Date mdfDttm;           // 수정일시
    private int inqCnt;     // 조회수
}
