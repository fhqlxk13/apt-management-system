package kr.or.ddit.domain.apt.apiApartment.vo;

import lombok.Data;

@Data
public class AptHoTyDTO {

    // 호 타입 번호
    private String hoTyNo;
    // 아파트 단지 번호
    private String aptCmplexNo;
    // 타입명
    private String tyNm;
    // 전용면적
    private String exclusiveSize;
    // 방 개수
    private Integer roomCnt;
    // 욕실 개수
    private Integer bathroomCnt;

    // 사진정보
    private Long imageFileNo;

    // 화면에 띄워줄 사진을 위한 googleId
    private String googleId;

    // 사진 지우는지 체크해주는녀석
    private boolean imageChanged;

    // 몇 세대를 제공하는지 체크
    private int householdCnt;

}