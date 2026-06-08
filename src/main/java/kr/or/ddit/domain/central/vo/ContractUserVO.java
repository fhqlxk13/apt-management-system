package kr.or.ddit.domain.central.vo;

import lombok.Data;

import java.util.Date;

@Data
public class ContractUserVO {

    private String sbmsnDocNo;      // 청약 서류번호
    private String sbmsnDocTyCd;    // 청약 서류 공통코드
    private String sbmsnDocSttsCd;  // 청약 서류 제출 상태
    private String rjctRsnCn;       // 반려 사유
    private Date regDt;             // 등록일시
    private Date mdfcnDt;           // 수정일시
    private String atchFileId;      // 파일 아이디
    private String rentCtrtNo;      // 계약 번호
    private String ctrtSttsCd;      // 계약상태코드
    private String tyNm;            // 타입명
    private String aplctNo;         // 청약 신청번호

}
