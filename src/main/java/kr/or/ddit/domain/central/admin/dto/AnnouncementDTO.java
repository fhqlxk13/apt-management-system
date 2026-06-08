package kr.or.ddit.domain.central.admin.dto;

import lombok.Data;

/**
 * 중앙관리자 공고 관리 DTO
 *
 */
@Data
public class AnnouncementDTO {

    /* CENTER_ANN_BOARD_POST 기본 컬럼 */
    private String annNo;          // 공고번호
    private String boardNo;        // 게시판번호
    private String ttl;            // 제목
    private String cn;             // 내용
    private String wrtrId;         // 작성자아이디
    private String topFixYn;       // 상단고정여부

    private String pblancBgngDt;   // 공고게시시작일
    private String pblancEndDt;    // 공고게시종료일
    private String rcrtBgngDt;     // 모집시작일
    private String rcrtEndDt;      // 모집종료일

    private String regDttm;        // 등록일시
    private String mdfDttm;        // 수정일시
    private Integer inqCnt;        // 조회수
    private String delYn;          // 삭제여부
    private String opnYn;          // 공개여부
    private String atchFileId;     // 첨부파일ID

    /* CENTER_BOARD_INSTANCE 조인 컬럼 */
    private String boardNm;        // 게시판명
    private String boardTyCd;      // 게시판유형코드

    /* APT_COMPLEX 조인 컬럼 */
    private String aptCmplexNo;    // 아파트단지번호
    private String aptCmplexNm;    // 아파트단지명
    private String dorojuso;       // 상세주소

    /* 세대수 관련 */
    private Integer totalUnitCnt;  // 전체 세대수
    private Integer supplyCnt;     // 공급 세대수
    private Integer unitCnt;       // 단지 셀렉트박스 data-unit-cnt용
    private String supplyDisplay;  // 화면 표시용: 50 / 192세대

    /* 제출서류 관련 */
    private String sbmsnDoc;       // 제출서류 (DB 원문: 코드 또는 JSP 한글)
    private String sbmsnDocNm;     // 화면 표시용 한글명 (LISTAGG)

    /* 첨부파일 관련 */
    private String hasFileYn;      // 첨부파일 존재 여부

    /* 화면 표시용 */
    private String statusNm;       // 진행상태명

    /* 검색 조건 */
    private String searchTtl;          // 검색 제목
    private String searchAptCmplexNo;  // 검색 단지번호
    private String searchFrom;         // 검색 시작일
    private String searchTo;           // 검색 종료일
    private String searchStatus;       // 검색 상태



}