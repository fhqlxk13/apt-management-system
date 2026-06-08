package kr.or.ddit.domain.member.resident.vo;

import lombok.Data;

@Data
public class VisitRegisterDTO {
    private String vstVhclTyCd;
    private String vstVhclNo;
    private String vstrNm;

    private String visitDate;
    private String visitHour;

    private Integer stayHr;

    private String vstPrpsCn;
}
