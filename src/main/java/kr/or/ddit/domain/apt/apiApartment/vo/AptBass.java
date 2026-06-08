package kr.or.ddit.domain.apt.apiApartment.vo;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;

@JsonIgnoreProperties(ignoreUnknown = true)
@Data
public class AptBass {

    private String kaptCode;    // 아파트코드
    private String kaptName;    // 아파트이름
    private String kaptAddr;    // 아파트 주소
    private String codeHeatNm;  // 난방형식

    private double kaptTarea;   // 연면적?

    private String kaptDongCnt; // 동 숫자
    private int hoCnt;          // 호 수

    private String kaptBcompany;// 시공사
    private String kaptAcompany;// 시행사
    private String kaptTel;     // 관리사무소연락처
    private String kaptUrl;     // 홈페이지 주소
    private String codeAptNm;   // 단지분류
    private String doroJuso;    // 도로주소
    private String kaptdaCnt;   // 세대 수

    private String kaptUsedate; // 사용일

    private double kaptMarea;   // 관리비 부과면적

    private String kaptMparea60;   // 전용면적별 세대현황
    private String kaptMparea85;   // 전용면적별 세대현황
    private String kaptMparea135;  // 전용면적별 세대현황
    private String kaptMparea136;  // 전용면적별 세대현황

    private int ktownFlrNo;
    private int kaptTopFloor;   // 최고층
    private int kaptBaseFloor;  // 지하층
}
