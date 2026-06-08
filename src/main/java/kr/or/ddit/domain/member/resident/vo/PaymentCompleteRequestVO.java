package kr.or.ddit.domain.member.resident.vo;

import lombok.Data;

// PortOne 결제 완료 검증 요청 VO
@Data
public class PaymentCompleteRequestVO {

    // PortOne 결제 고유번호
    private String impUid;

    // PortOne 요청 시 merchant_uid로 전달했던 값
    private String ordId;
}
