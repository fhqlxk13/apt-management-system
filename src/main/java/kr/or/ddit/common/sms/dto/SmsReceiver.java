package kr.or.ddit.common.sms.dto;

import lombok.Data;

/**
 * SMS 문자 수신자 정보
 * 문자 발송 대상자의 회원번호와 연락처를 저장
 */
@Data
public class SmsReceiver {
    private String userNo;    /* 회원번호 */
    private String userTel;   /* 휴대폰 번호 */
}