package kr.or.ddit.domain.apt.complaint.vo;

import lombok.Data;

import java.util.Date;

@Data
public class CvplVO {

    private String cvplNo;        // PK
    private String cvplTyCd;      // 문의 유형
    private String cvplLoc;       // 위치
    private String cvplCn;        // 내용
    private String cvplSttsCd;    // 상태
    private Date cvplRegDt;       // 등록일
    private Date cvplMdfDt;       // 수정일
    private Date cvplRcptDt;      // 접수일
    private Date cvplEndDt;       // 처리완료일
    private String cvplPrrt;      // 우선순위
    private String cvplFileNo;    // 첨부파일
    private String cvplTtl;       // 제목
    private String userNo;        // 작성자 유저 번호
    private String userId;
    private String userNm;
    private String hoNo;          // 세대번호
    private String aptCmplexNo;   // 아파트 코드
}
