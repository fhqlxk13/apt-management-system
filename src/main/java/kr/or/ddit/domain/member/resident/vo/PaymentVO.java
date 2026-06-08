package kr.or.ddit.domain.member.resident.vo;

import lombok.Data;

import java.util.Date;

@Data
public class PaymentVO {

    private String pymtNo;          // 결제 번호 PAYMENT.PYMT_NO
    private String billNo;          // 관리비 고지서 번호 PAYMENT.BILL_NO

    // 결제수단 코드
    // COMMON_CODE.GROUP_CODE_NO = 'PAY_MET'
    // CRD: 신용카드, TRN: 계좌이체, VRT: 가상계좌
    private String payMthdCd;       // PAYMENT.PAY_MTHD_CD

    // PortOne V1 결제 고유번호
    // 결제 성공 후 PortOne 응답에서 받아 저장
    private String impUid;          // PAYMENT.IMP_UID

    // 주문번호
    // PortOne merchant_uid로 전달할 값
    private String ordId;           // PAYMENT.ORD_ID
    private int payAmt;             // 결제 금액 PAYMENT.PAY_AMT

    // 결제 처리상태 코드
    // COMMON_CODE.GROUP_CODE_NO = 'PAY_STTS'
    // UNPAID: 미납/결제대기, PAID: 납부완료, CANCEL: 취소, REFUND: 환불
    private String paySttsCd;       // PAYMENT.PAY_STTS_CD

    private Date payReqDt;          // 결제 요청일시 PAYMENT.PAY_REQ_DT
    private Date payCmplDt;         // 결제 완료 일시 PAYMENT.PAY_CMPL_DT
    private String failRsnCn;       // 결제 실패 또는 취소 사유 PAYMENT.FAIL_RSN_CN
    private String userNo;          // PAYMENT.USER_NO
    private String payMthdNm;       // 결제수단 코드명 ex) 신용카드, 계좌이체
    private String paySttsNm;       // 결제상태 코드명 ex) 미납, 납부완료, 취소, 환불
    private String billYm;          // 고지월
    private int billTotAmt;         // 고지서 청구금액
    private String hoNo;            // 세대번호
    private String displayDongHo;   // 화면 표시용 세대 정보
    private String userNm;          // 납부자명
    private String portOnePayMethod;// PortOne 결제 요청용 결제수단
    private boolean paymentSuccess; // PortOne 결제 완료 응답 상태
    private String paymentMessage;  // PortOne 결제 응답 메시지
}
