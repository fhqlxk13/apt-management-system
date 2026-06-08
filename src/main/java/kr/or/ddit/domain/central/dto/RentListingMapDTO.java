package kr.or.ddit.domain.central.dto;

import lombok.Data;

import java.math.BigDecimal;
import java.util.Date;

/**
 * 임대 매물 지도 화면 전용 DTO
 * 작성자 : 이윤진
 *
 * 1. RENT_LISTING  : 임대 매물
 * 2. APT_DETAIL    : 아파트 호 상세정보
 * 3. APT_UNIT      : 동정보
 * 4. APT_COMPLEX   : 아파트 단지
 *
 * 지도 화면에서 좌측 매물 리스트, 중앙 상세 패널, 지도 마커에 함께 사용
 */
@Data
public class RentListingMapDTO {

    /* =========================
     * RENT_LISTING
     * 임대 매물 정보 테이블
     * ========================= */
    private String rentLstgNo;      // 임대 매물 번호
    private String rentTypeCd;      // 임대 유형 코드
    private String rentTypeNm;
    private Long dpstAmt;           // 보증금
    private Long mthlyRentAmt;      // 월 임대 금액
    private String rentLstgCn;      // 임대 매물 내용
    private String hoNo;            // 호 번호
    private String rcrtBgngDt;      // 모집 시작일
    private String rcrtEndDt;       // 모집 종료일
    private String rentTtl;         // 매물 제목

    /* ===========================
     * APT_DETAIL
     * 아파트 호 상세정보
     * =========================== */
    private Integer floor;          // 층
    private String ho;              // 호
    private String exclusiveSize;   // 전용면적
    private String empty;           // 공실 여부
    private String imageNo;         // 이미지 번호
    private String panoImageNo;     // 파라노마 이미지 번호

    /* ============================
     * APT_UNIT
     * 동정보
     * ============================ */
    private String dongNo;          // 동 번호
    private String dongNm;          // 동 이름
    private int dongMaxFloor;       // 동 최대 층수
    private int dongUnitCnt;        // 동 세대수

    /* =========================================================
     * APT_COMPLEX
     * 아파트 단지 정보
     * ========================================================= */
    private String aptCmplexNo;     // 아파트 단지 번호
    private String aptCmplexNm;     // 아파트 단지명
    private String bjdCd;           // 법정동 코드
    private String sidoNm;          // 시도명
    private String sigunguNm;       // 시군구명
    private String emdNm;           // 읍면동명
    private BigDecimal latVal;      // 위도
    private BigDecimal lonVal;      // 경도
    private int unitCnt;            // 단지 세대 수
    private String heatTyCd;        // 난방 방식 코드
    private String ccCnt;           // cctv
    private int pkgCnt;             // 주차 가능 대수
    private int freePkgCnt;         // 세대당 무료 주차 수
    private int dongCnt;            // 총 동수
    private int maxFloor;           // 단지 최대 층 수
    private String bldYr;           // 준공년도
    private String cnscoNm;         // 건설사명
    private String imgFileNo;       // 이미지 파일 번호
    private String rprsntImgFileNo; // 대표 이미지 파일 번호
    private String dorojuso;        // 도로명 주소
    private String rprsntImgGoogleIds;
    private String rprsntImgCats;   // 구분을 위해 cat 추가함(도선호)

    // 공고 관련
    private String annNo;
    private String annTtl;

    // 검색 조건용
    private String searchRentTypeCd;      // ALL, JS, PE
    private String searchRegion;          // 서울특별시 마포구
    private String searchAmountRange;     // UNDER_5000, 5000_10000, 10000_20000, OVER_20000
    private String searchStatus;          // ALL, OPEN, CLOSE
    private String searchKeyword;         // 단지명/주소/매물명

    private Integer rentCount;          // 단지 내 공급 매물 수
    private Long minMonthlyRentAmt;     // 월세 최저가
    private Long maxDpstAmt;            // 전세/보증금 최대값
    private Integer jsCount;             // 전세 매물 수
    private Integer peCount;             // 월세 매물 수
    private Long minJsDpstAmt;           // 전세 최저 보증금
    private Long minPeMonthlyRentAmt;    // 월세 최저 월 임대료

}
