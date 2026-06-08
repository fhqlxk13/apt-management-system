package kr.or.ddit.domain.central.admin.vo;

import lombok.Data;

import java.sql.Date;

@Data
public class RentCtrtVO {
    private String rentCtrtNo;
    private String rentLstgNo;
    private String userNo;
    private String ctrtId;
    private char mvinYn;
    private Date mvinDt;
    private Date mvoutDt;
    private Date mvoutCmplDt;
    private Date regDt;
    private Date mdfDt;
    private String ctrtSttsCd;
    private int ctrtAmt;
    private int midPayAmt;
    private int balAmt;
    private int dpstAmt;
    private int mthlyRentAmt;
    private String rentorNm;
    private String rentorTelno;
    private String agntNm;
    private String agntTelno;
    private String spclStpltnCn;
}
