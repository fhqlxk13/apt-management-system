package kr.or.ddit.domain.apt.mgmtOffice.main.vo;

import lombok.Data;

@Data
public class MgmtOfficeVO {

    private String mgmtOfcNo;           // 관리사무소 번호
    private String aptCmplexNo;         // 아파트 코드
    private String mgmtOfcNm;           // 관리사무소 이름
    private String mgmtOfcTelno;        // 관리사무소 전화번호
    private String mgmtOfcEml;          // 관리사무소 메일
    private String mgmtOfcBankCd;       // 관리사무소 계좌
    private String mgmtOfcAcntHldrNm;
    private String mgmtOfcAcntNo;
    private String useYn;

    // MGMT_OPR_TM 테이블
    private String oprStTm;     // 관리사무소 운영 시작 시간
    private String oprEdTm;     // 관리사무소 운영 종료 시간

    // APT_COMPLEX
    private String aptCmplexNm;
    private String sidoNm;
    private String sigunguNm;
    private String emdNm;
    private String dorojuso;
    private Integer unitCnt;
    private Integer dongCnt;
    private String bldYr;
}
