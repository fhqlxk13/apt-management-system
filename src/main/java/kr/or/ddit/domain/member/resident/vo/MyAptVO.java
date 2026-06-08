package kr.or.ddit.domain.member.resident.vo;

import lombok.Data;

/**
 * @author 이용로
 */
@Data
public class MyAptVO {
    private String aptCmplexNo;    // 아파트 코드
    private String aptCmplexNm;    // 아파트 명
    private String dongNm;         // 동
    private String floor;          // 층수
    private String ho;             // 호수
    private String hoNo;           // 호번호
    private String sidoNm;         // 시,도 명
    private String sigunguNm;      // 시,군,구 명
    private String emdNm;          // 읍,면,동 명
    private String dorojuso;       // 도로명 주소
}
