package kr.or.ddit.domain.apt.main.vo;

import lombok.Data;

import java.util.Date;

@Data
public class AptDetailVO {

    private String hoNo;
    private int floor;
    private String hoTyNo;
    private String hoSttsCd;
    private String imageNo;
    private String panoImageNo;
    private String dongNo;
    private String ho;
    private RentInfo rentInfo = new RentInfo();

    @Data
    public static class RentInfo {

        private String rentTypeCd;
        private String rcrtLstgSttsCd;
        private String dealSttsCd;
        private Date mvinPsblDt;
        private Long dpstAmt;
        private Long mthlyRentAmt;
    }
}