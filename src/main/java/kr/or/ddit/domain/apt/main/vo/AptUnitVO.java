package kr.or.ddit.domain.apt.main.vo;

import lombok.Data;

/*db 테이블과 1:1 매칭되는 vo 입니다*/
@Data
public class AptUnitVO {
    private String dongNo;
    private String dongNm;
    private int floor;
    private int unitCnt;
    private String aptCmplexNo;
}
