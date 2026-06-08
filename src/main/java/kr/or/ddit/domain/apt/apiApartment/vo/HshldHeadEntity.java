package kr.or.ddit.domain.apt.apiApartment.vo;

import lombok.Data;

import java.util.Date;

@Data
public class HshldHeadEntity {
    private String userNo;
    private String hoNo;
    private String inoutCd;
    private Date moveInDt;
    private Date moveOutDt;
    private String headYn;
}
