package kr.or.ddit.domain.apt.mgmtOffice.resident.vo;

import lombok.Data;

@Data
public class MngResidentListVO {

    private String userNo;
    private String userId;
    private String userNm;
    private String telno;
    private String userEml;

    private String mgmtOfcNo;
    private String aptCmplexNo;
    private String complexName;

    private String dong;
    private String ho;
    private String householdType;
    private String moveStatus;
    private String moveInDate;
    private String moveOutDate;
    private String headYn;
    private String inoutCd;
}
