package kr.or.ddit.domain.apt.main.vo;

import lombok.Data;

/* 단지 구조 관리 페이지에서 화면에 띄워줄 정보를 모은 DTO 입니다*/
@Data
public class AptDetailGridDTO {

    private String hoNo;

    private String dongNo;
    private String dongNm;

    private int floor;

    private String ho;

    private String hoTyNo;
    private String tyNm;

    private String hoSttsCd;

    private String imageNo;
    private String panoImageNo;

}
