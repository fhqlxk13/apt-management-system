package kr.or.ddit.domain.apt.apiApartment.vo;

import lombok.Data;

@Data
public class AptComplexEntity {

    private String aptCmplexNo; //  아파트 번호
    private String aptCmplexNm; //  아파트 이름
    private String bjdCd;   //  법정동 코드
    private String sidoNm;  //  시도이름
    private String sigunguNm;   //  시군구 이름
    private String emdNm;   // 동읍명 이름
    private double latVal;  // 위도
    private double lonVal;  // 경도
    private int unitCnt; // 세대 수
    private String bldYr;   // 준공년도
    private String cnscoNm; // 시공사

    private String imgFileNo;       // 아파트 이미지
    private String rprsntImgFileNo; // 아파트 대표이미지
    private String heatTy;  // 난방타입
    private int pkgCnt;     // 주차장 갯수(지하+지상으로 계산했음)
    private int maxFloor;   // 최대층
    private int freePkgCnt; // 한 세대당 기본 차량 수
    private int dongCnt;    // 동갯수
    private String dorojuso;// 도로주소
    private int ccCnt;   // cctv 갯수
}
