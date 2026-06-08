package kr.or.ddit.domain.apt.mgmtOffice.move.vo;

import lombok.Data;

@Data
public class MngResidentMoveVO {

    private String userNo;
    private String userId;
    private String userNm;
    private String userTelno;
    private String userEml;

    private String mgmtOfcNo;
    private String aptCmplexNo;
    private String complexName;

    private String hoNo;
    private String dong;
    private String ho;

    private String inoutCd;
    private String inoutNm;
    private String moveStatus;
    private String headYn;
    private String headYnNm;
    private String moveInDt;
    private String moveOutDt;
}
