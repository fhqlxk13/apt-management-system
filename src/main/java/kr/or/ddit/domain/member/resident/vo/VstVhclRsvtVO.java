package kr.or.ddit.domain.member.resident.vo;

import lombok.Data;

import java.util.Date;

@Data
public class VstVhclRsvtVO {

    private String vstVhclRsvtNo;/*방문차량 예약 번호*/
    private String vstVhclTyCd; /*차량 유형 코드*/
    private String vstVhclNo;   /*방문 차량 번호*/
    private String vstrNm;      /*방문자명*/
    private Date vstYmd;        /*방문 예정일시*/
    private Integer stayHr;     /*체류 시간*/
    private String vstSttsCd;   /*방문 상태 코드*/
    private Date regDt;         /*등록일*/
    private Date mdfDt;         /*수정일*/
    private String vstPrpsCn;   /*방문 목적*/
    private String userNo;      /*사용자 번호*/
    private String hoNo;        /*호번호 aptCmplexNo_dong_ho*/
}