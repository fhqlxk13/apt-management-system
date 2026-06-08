package kr.or.ddit.domain.member.resident.vo;

import lombok.Data;

@Data
public class PaymentCancelRequestVO {

    // 결제번호
    private String pymtNo;

    // 주문번호
    private String ordId;

    // 취소 또는 실패 사유
    private String failRsnCn;
}
