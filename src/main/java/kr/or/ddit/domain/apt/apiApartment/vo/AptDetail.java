package kr.or.ddit.domain.apt.apiApartment.vo;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;

@JsonIgnoreProperties(ignoreUnknown = true)
@Data
public class AptDetail {

    private int kaptdEcnt;  // 승강기

    private String kaptdPcnt;   //지상주차장
    private String kaptdPcntu;  //지하주차장

    private String kaptdCccnt;  // cctv갯수

    private String welfareFacility; // 공용시설 종류
    private String kaptdWtimebus;   // 버스걸리는시간
    private String subwayLine;   // 지하철역
    private String kaptdWtimesub;   // 지하철걸리는시간
    private String convenientFacility;  // 편의시설?
    private String educationFacility;   // 교육시설

    private String useYn;
}