package kr.or.ddit.domain.apt.mgmtOffice.bill.vo;

import lombok.Data;

@Data
public class BillDetailVO {

    // BILL_DETAIL 테이블
    private String billDetailNo;    // 관리비상세번호
    private String billNo;          // 관리비번호
    private String billItemCd;      // 관리비항목코드
    private Long billItemAmt;       // 관리비항목금액
    private String atchFileId;      // 첨부파일ID

    // 화면 표시용
    private String billItemNm;
    private String billItemContent;
}
