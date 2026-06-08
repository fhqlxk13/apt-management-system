package kr.or.ddit.domain.apt.main.dto;

import lombok.Data;

import java.util.Date;
import java.util.List;

/**
 * @Author 이용로
 */
public class AptMainPageDTO {

    // 메인페이지 전체 DTO
    @Data
    public static class ResponseDto {
        private AptComplexInfo aptComplexInfo;
        private MgmtOfficeInfo mgmtOfficeInfo;
        private List<AnnBoardPostInfo> annBoardPostInfoList;
    }

    // 아파트 정보 부분
    @Data
    public static class AptComplexInfo {
        private String aptCmplexNo;     // 아파트 코드
        private String aptCmplexNm;     // 아파트 명
        private String sidoNm;          // 시도 명
        private String sigunguNm;       // 시군구 명
        private String emdNm;           // 읍면동 명
        private String dorojuso;        // 도로주소
        private Integer unitCnt;        // 세대수
        private Integer dongCnt;        // 동수
        private String bldYr;           // 준공일 또는 준공년도
    }

    // 아파트 관리사무소 정보
    @Data
    public static class MgmtOfficeInfo {
        private String mgmtOfcNo;        // 관리사무소 번호
        private String mgmtOfcNm;        // 관리사무소 이름
        private String mgmtOfcTelno;     // 관리사무소 전화번호
        private String mgmtOfcEml;       // 관리사무소 메일

        // MGMT_OPR_TM 테이블
        private String oprStTm;     // 관리사무소 운영 시작 시간
        private String oprEdTm;     // 관리사무소 운영 종료 시간
    }

    // 입주민 게시판 정보
    @Data
    public static class AnnBoardPostInfo {
        private String annNo;   // 게시글 번호
        private String ttl;     // 제목
        private String cn;      // 내용
        private Date regDttm;   // 등록일시
    }
}
