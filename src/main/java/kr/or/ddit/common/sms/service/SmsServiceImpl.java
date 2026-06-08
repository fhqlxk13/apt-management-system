package kr.or.ddit.common.sms.service;

import kr.or.ddit.common.sms.dto.SmsReceiver;
import kr.or.ddit.common.sms.dto.SmsSendRequest;
import kr.or.ddit.common.sms.mapper.ISmsMapper;
import kr.or.ddit.common.sms.sender.SmsSender;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collections;

/**
 * SMS 공통 서비스 구현체
 *
 * 실제 문자 발송과 DB 발송 이력 저장을 함께 처리합니다.
 */
@Service
@RequiredArgsConstructor
public class SmsServiceImpl implements ISmsService {

    /** SMS 발송 이력 저장 및 수신자 조회 Mapper */
    private final ISmsMapper smsMapper;

    /** SMS 발송 처리 객체(Mock 또는 실제 발송) */
    private final SmsSender smsSender;

    /**
     * SMS 발송 공통 처리
     *
     * 발송 마스터 이력을 저장한 뒤,
     * 수신자별로 문자를 발송하고 상세 이력을 저장합니다.
     */
    @Override
    @Transactional
    public void sendSms(SmsSendRequest request) {

        /** SMS 발송번호 생성 */
        String smsNo = smsMapper.selectNextSmsNo();
        request.setSmsNo(smsNo);
        /*
         * 발송건수 세팅
         */
        request.setSndCnt(request.getReceivers().size());

        /** SMS 발송 마스터 이력 저장 */
        smsMapper.insertSmsSnd(request);

        /** 수신자 목록만큼 문자 발송 처리 */
        for (SmsReceiver receiver : request.getReceivers()) {

            /** SMS 발송상세번호 생성 */
            String smsDtlNo = smsMapper.selectNextSmsDtlNo();

            try {
                /** 문자 발송 */
                smsSender.send(receiver, request.getSmsCn());

                /** 발송 성공 상세 이력 저장 */
                smsMapper.insertSmsSndDtl(
                        smsDtlNo,
                        smsNo,
                        receiver,
                        "SUCCESS",
                        null
                );

            } catch (Exception e) {

                /** 발송 실패 상세 이력 저장 */
                smsMapper.insertSmsSndDtl(
                        smsDtlNo,
                        smsNo,
                        receiver,
                        "FAIL",
                        e.getMessage()
                );

                // 문자 실패 시 상위 로직 중단
                throw new RuntimeException("SMS 발송에 실패했습니다.", e);
            }
        }
    }

    /**
     * 입주 승인 완료 문자 발송
     */
    @Override
    public void sendResidentApproved(String userNo, String rgtrId) {

        /** 문자 수신 동의 회원 조회 */
        SmsReceiver receiver = smsMapper.selectReceiverByUserNo(userNo);

        /** 수신자가 없으면 문자 발송하지 않음 */
        if (receiver == null) {
            return;
        }

        /** SMS 발송 요청 정보 생성 */
        SmsSendRequest request = new SmsSendRequest();
        request.setSndTyCd("RESIDENT_APPROVED");
        request.setSmsTtl("입주 승인 완료");
        request.setSmsCn("[우리집맵핑] 입주승인완료.");
        request.setRcptTrgtGrpCd("RESIDENT");
        request.setRcptTrgtCd("SINGLE");
        request.setRcptUserNo(userNo);
        request.setRgtrId(rgtrId);

        /** 단일 수신자를 List 형태로 변환 */
        request.setReceivers(Collections.singletonList(receiver));

        /** SMS 발송 공통 메서드 호출 */
        sendSms(request);
    }

    /**
     * 예약 승인 완료 문자 발송
     */
    @Override
    public void sendReservationApproved(
            String userNo,
            String facilityNm,
            String rsvtDttm,
            String rgtrId
    ) {

        /** 문자 수신 동의 회원 조회 */
        SmsReceiver receiver = smsMapper.selectReceiverByUserNo(userNo);

        /** 수신자가 없으면 문자 발송하지 않음 */
        if (receiver == null) {
            return;
        }

        /** SMS 발송 요청 정보 생성 */
        SmsSendRequest request = new SmsSendRequest();
        request.setSndTyCd("RSVT_APPROVED");
        request.setSmsTtl("예약 승인 완료");
        /*
         * SMS 내용 형식
         *
         * [서비스명] 시설명 상태
         * 예약일시
         *
         * 예)
         * [우리집맵핑] 주민회의실 예약승인
         * 2026-06-01 10:00~11:00
         */
        request.setSmsCn(
                "[우리집맵핑] " + facilityNm + " 예약승인\n" +
                        rsvtDttm
        );
        request.setRcptTrgtGrpCd("RESIDENT");
        request.setRcptTrgtCd("SINGLE");
        request.setRcptUserNo(userNo);
        request.setRgtrId(rgtrId);

        /** 단일 수신자를 List 형태로 변환 */
        request.setReceivers(Collections.singletonList(receiver));

        /** SMS 발송 공통 메서드 호출 */
        sendSms(request);
    }

    /**
     * 예약 거절 문자 발송
     */
    public void sendReservationRejected(
            String userNo,
            String facilityNm,
            String rsvtDttm,
            String reason,
            String rgtrId
    ) {

        /** 문자 수신 동의 회원 조회 */
        SmsReceiver receiver = smsMapper.selectReceiverByUserNo(userNo);

        /** 수신자가 없으면 문자 발송하지 않음 */
        if (receiver == null) {
            return;
        }

        /** SMS 발송 요청 정보 생성 */
        SmsSendRequest request = new SmsSendRequest();
        request.setSndTyCd("RSVT_REJECTED");
        request.setSmsTtl("예약 거절 안내");
        /*
         * 거절 사유는 SMS에 넣지 않습니다.
         * 자세한 사유는 카카오 알림 모달 또는 예약내역 상세에서 확인하게 합니다.
         */
        request.setSmsCn(
                "[우리집맵핑] " + facilityNm + " 예약거절\n" +
                        rsvtDttm
        );
        request.setRcptTrgtGrpCd("RESIDENT");
        request.setRcptTrgtCd("SINGLE");
        request.setRcptUserNo(userNo);
        request.setRgtrId(rgtrId);

        /** 단일 수신자를 List 형태로 변환 */
        request.setReceivers(Collections.singletonList(receiver));

        /** SMS 발송 공통 메서드 호출 */
        sendSms(request);
    }

    /**
     * 예약 승인만료 문자 발송
     *
     * 승인만료란?
     * 관리자가 예약 시작시간 전까지 승인/거절하지 않아
     * 시스템이 자동취소한 상태입니다.
     */
    public void sendReservationExpired(
            String userNo,
            String facilityNm,
            String rsvtDttm,
            String rgtrId
    ) {
        SmsReceiver receiver = smsMapper.selectReceiverByUserNo(userNo);

        if (receiver == null) {
            return;
        }

        SmsSendRequest request = new SmsSendRequest();
        request.setSndTyCd("RSVT_EXPIRED");
        request.setSmsTtl("예약 자동취소");

        /*
         * 승인만료란?
         * 관리자가 예약 시작시간 전까지 승인/거절하지 않아
         * 시스템이 자동취소한 상태입니다.
         */
        request.setSmsCn(
                "[우리집맵핑] " + facilityNm + " 승인만료\n" +
                        rsvtDttm
        );

        request.setRcptTrgtGrpCd("RESIDENT");
        request.setRcptTrgtCd("SINGLE");
        request.setRcptUserNo(userNo);
        request.setRgtrId(rgtrId);
        request.setReceivers(Collections.singletonList(receiver));

        sendSms(request);
    }

    /**
     * 예약 취소 완료 문자 발송
     *
     * 사용자가 예약을 직접 취소했을 때
     * 입주민에게 짧은 SMS를 발송합니다.
     */
    @Override
    public void sendReservationCancelled(
            String userNo,
            String facilityNm,
            String rsvtDttm,
            String rgtrId
    ) {
        SmsReceiver receiver = smsMapper.selectReceiverByUserNo(userNo);

        if (receiver == null) {
            return;
        }

        SmsSendRequest request = new SmsSendRequest();
        request.setSndTyCd("RSVT_CANCELLED");
        request.setSmsTtl("예약 취소 안내");

        request.setSmsCn(
                "[우리집맵핑] " + facilityNm + " 예약취소\n" +
                        rsvtDttm
        );

        request.setRcptTrgtGrpCd("RESIDENT");
        request.setRcptTrgtCd("SINGLE");
        request.setRcptUserNo(userNo);
        request.setRgtrId(rgtrId);
        request.setReceivers(Collections.singletonList(receiver));

        sendSms(request);
    }


}