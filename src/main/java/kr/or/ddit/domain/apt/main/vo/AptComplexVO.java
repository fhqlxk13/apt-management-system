package kr.or.ddit.domain.apt.main.vo;

import kr.or.ddit.common.file.vo.AttachFileVO;
import lombok.Data;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

/*db 테이블과 1:1 매칭되는 vo 입니다*/
@Data
public class AptComplexVO {
    private String aptCmplexNo;     // kAptCode
    private String aptCmplexNm;     // 아파트 단지명
    private String bjdCd;           // 법정동 코드
    private String sidoNm;          // 시도 명
    private String sigunguNm;       // 시군구 명
    private String emdNm;           // 읍면동 명
    private BigDecimal latVal;      // 위도
    private BigDecimal lonVal;      // 경도
    private int unitCnt;            // 세대 수
    private String bldYr;           // 준공년도
    private String cnscoNm;         // 건설사 명
    private String imgFileNo;       // 이미지 파일 번호
    private String rprsntImgFileNo; // 대표이미지 파일 번호
    private String heatTy;          // 난방 방식 코드
    private int pkgCnt;             // 주차가능대수
    private int maxFloor;           // 최대 층수
    private int freePkgCnt;         // 세대당 무료주차대수
    private int dongCnt;            // 동 수
    private String dorojuso;        // 도로명주소
    private String ccCnt;           // cctv 수

    private List<AttachFileVO> fileList;    // 화면에 보여줄 fileVOList
}
