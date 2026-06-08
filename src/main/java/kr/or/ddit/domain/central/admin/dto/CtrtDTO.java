package kr.or.ddit.domain.central.admin.dto;

import lombok.Data;

import java.util.Date;

@Data
public class CtrtDTO {
    private String rentCtrtNo;
    private String rentLstgNo;
    private String ctrtId;
    private String ctrtStts;
    private Date mvinDt;
    private Date mvoutDt;
    private Date mvoutCmplDt;
    private Date regDt;
    private Date mdfDt;
    private String ctrtSttsCd;
    private Long ctrtAmt;
    private Long midPayAmt;
    private Long balAmt;
    private Long dpstAmt;
    private Long mthlyRentAmt;
    private String userNo;
    private String rentorNm;
    private String rentorTelno;
    private String agntNm;
    private String agntTelno;
    private String spclStpltnCn;
    private String aptCmplexNo;

}
