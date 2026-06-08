package kr.or.ddit.domain.apt.mgmtOffice.bill.vo;

import lombok.Data;

import java.util.Date;

@Data
public class ExpenseVO {
    // EXPENSE 테이블 컬럼
    private String expenseNo;       // 지출번호
    private String aptCmplexNo;     // 아파트단지번호

    private int expenseYr;          // 지출연도
    private int expenseMm;          // 지출월
    private int expenseAmt;         // 지출금액

    private String expenseCd;       // 지출코드 : SAL, OFF, REP, UTL, SRV, INS, ETC
    private String expenseCn;       // 지출내용

    private Date regDt;             // 등록일자
    private Date mdfDt;             // 수정일자

    private String rmrkCn;          // 비고내용
    private String atchFileId;      // 첨부파일ID

    // 화면 표시용
    private String expenseCdNm;     // 지출코드명
    private String expenseCdContent;// 지출코드 설명
}
