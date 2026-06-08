package kr.or.ddit.domain.apt.mgmtOffice.employee.vo;

import lombok.Data;

import java.util.Date;

@Data
public class VstVhclRsvtVO {

    private String vstVhclRsvtNo;
    private String vstVhclTyCd;
    private String vstVhclNo;

    private String vstrNm;

    private Date vstYmd;

    private Integer stayHr;

    private String vstSttsCd;

    private Date regDt;
    private Date mdfDt;

    private String vstPrpsCn;

    private String userNo;
    private String hoNo;

    // JOIN
    private String userNm;
    private String dong;
    private String ho;


}



