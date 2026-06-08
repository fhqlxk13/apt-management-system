package kr.or.ddit.common.sms.dto;

import lombok.Data;

import java.util.List;

/**
 * 문자 발송 요청 정보
 * 공통으로 문자 발송을 요청할 때 사용.
 */
@Data
public class SmsSendRequest {
    private String sndTyCd;          // 발송유형: RESIDENT_APPROVED, RSVT_APPROVED 등
    private String smsTtl;           // 문자 제목
    private String smsCn;            // 문자 내용
    private String rcptTrgtGrpCd;    // 대상그룹: RESIDENT 입주민
    private String rcptTrgtCd;       // 대상구분: SINGLE, ALL, NOTICE, BILL 등
    private String rcptUserNo;       // 단일 수신자 번호
    private String rgtrId;           // 발송자 ID
    private List<SmsReceiver> receivers;  //SMS 문자 수신자 정보(회원번호+폰번호)

    private String smsNo;            // SMS 발송번호
    private int sndCnt;            // 발송건수

}