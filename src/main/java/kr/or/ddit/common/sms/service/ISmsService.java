package kr.or.ddit.common.sms.service;

import kr.or.ddit.common.sms.dto.SmsSendRequest;

/**
 * SMS 발송 서비스
 *
 * Service란?
 * 문자 발송과 발송 이력 저장 등의 비즈니스 로직을 처리하는 계층입니다.
 */
public interface ISmsService {

    /** SMS 발송 */
    void sendSms(SmsSendRequest request);

    /** 입주 승인 완료 문자 발송 */
    void sendResidentApproved(String userNo, String rgtrId);

    /** 예약 승인 완료 문자 발송 */
    void sendReservationApproved(
            String userNo,
            String facilityNm,
            String rsvtDttm,
            String rgtrId
    );

    /** 예약 거절 문자 발송 */
    void sendReservationRejected(
            String userNo,
            String facilityNm,
            String rsvtDttm,
            String reason,
            String rgtrId
    );

    /**
     * 예약 승인만료 문자 발송
     *
     * rsvtDttm이란?
     * 예약일시입니다.
     * 예) 2026-06-01 10:00~11:00
     */
    void sendReservationExpired(
            String userNo,
            String facilityNm,
            String rsvtDttm,
            String rgtrId
    );

    /**
     * 예약 취소 완료 문자 발송
     *
     * 사용자가 직접 예약을 취소했을 때 발송합니다.
     */
    void sendReservationCancelled(
            String userNo,
            String facilityNm,
            String rsvtDttm,
            String rgtrId
    );

//    /** 시설 점검 안내 문자 발송 */
//    void sendFacilityInspection(...);
//
//    /** 관리비 납부 안내 문자 발송 */
//    void sendMaintenanceFeeNotice(...);
//
//    /** 계약 만료 안내 문자 발송 */
//    void sendContractExpireNotice(...);

}