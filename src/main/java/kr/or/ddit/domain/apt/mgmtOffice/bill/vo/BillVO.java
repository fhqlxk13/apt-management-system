package kr.or.ddit.domain.apt.mgmtOffice.bill.vo;

import lombok.Data;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

@Data
public class BillVO {
    // BILL 테이블
    private String billNo;          // 관리비번호
    private String hoNo;            // 호번호
    private String billYm;          // 관리년월 ex) 202605
    private String billPblancDt;    // 고지일자
    private Long billTotAmt;        // 관리비 총액
    private Date dueDt;             // 납부기한
    private String pymtSttsCd;      // 납부상태코드 READY, PAID, UNPAID, OVERDUE
    private Date pymtDt;            // 납부일자
    private Long pymtAmt;           // 실제 납부 금액
    private BigDecimal lateFeeRt;   // 연체요율
    private Long lateFeeAmt;        // 연체료금액

    // 검색/권한 확인용
    private String aptCmplexNo;
    private String mgmtOfcNo;

    // 세대 표시용
    private String userNo;
    private String dongNo;
    private String dongNm;
    private String ho;
    private String displayDongHo;

    // 납부상태 표시용
    private String pymtSttsNm;
    private String pymtSttsContent;

    // 상세 목록
    private List<BillDetailVO> detailList;
}
