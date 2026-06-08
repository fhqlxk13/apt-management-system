package kr.or.ddit.domain.member.resident.vo;

import lombok.Data;

import java.util.Date;

@Data
public class RsidVhclVO {

    private String rsidVhclNo;

    private String vhclSttsCd;
    private String vhclNm;
    private String vhclNo;
    private String userNm;
    private String userNo;
    private String hoNo;
    private String unitDisplay;
    private String vhclFileNo;
    private Date regDt;
    private Date mdfDt;
}
