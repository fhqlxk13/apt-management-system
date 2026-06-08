package kr.or.ddit.domain.apt.apiApartment.vo;

import lombok.Data;

import java.util.Date;

@Data
public class MgmtOfficeEntity {
    private String mgmtOfcNo;
    private String aptCmplexNo;
    private String mgmtOfcNm;
    private String mgmtOfcTelno;
    private String mgmtOfcEmail;
    private String mgmtOfcBankCd;
    private String mgmtOfcAcntHldrNm;
    private String mgmtOfcAcntNo;
    private Date regDt;
    private Date mdfDt;
    private String useYn;
}
