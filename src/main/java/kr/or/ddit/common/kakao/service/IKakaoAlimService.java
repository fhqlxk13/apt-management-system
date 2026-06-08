package kr.or.ddit.common.kakao.service;

import kr.or.ddit.common.kakao.vo.KakaoAlimVO;

import java.util.List;

/**
 * 카카오 알림 서비스
 *
 * Service란?
 * 화면(Controller)과 DB(Mapper) 사이에서
 * 실제 비즈니스 로직을 처리하는 계층입니다.
 *
 * 왜 사용?
 * Controller에 로직이 몰리는 것을 방지하고
 * 기능을 재사용하기 위해 사용합니다.
 */
public interface IKakaoAlimService {

    /**
     * 예약 승인 알림 발송
     */
    void sendReservationApproved(
            String userNo,
            String facilityNm,
            String rsvtDttm,
            String linkUrl
    );

    /**
     * 승인만료(자동취소) 알림
     */
    void sendReservationExpired(
            String userNo,
            String facilityNm,
            String rsvtDttm,
            String linkUrl
    );

    /**
     * 예약 거절 알림 발송
     */
    void sendReservationRejected(
            String userNo,
            String facilityNm,
            String reason,
            String linkUrl
    );

    /**
     * 예약 신청 완료 알림 발송
     */
    void sendReservationRequested(
            String userNo,
            String facilityNm,
            String rsvtDttm,
            String linkUrl
    );

    /**
     * 예약 취소 완료 알림 발송
     */
    void sendReservationCancelled(
            String userNo,
            String facilityNm,
            String rsvtDttm,
            String linkUrl
    );

    /**
     * 입주 승인 완료 알림 발송
     */
    void sendResidentApproved(
            String userNo,
            String linkUrl
    );

    /**
     * 내 알림 목록 조회
     *
     * 알림센터 화면에서 사용
     */
    List<KakaoAlimVO> getMyAlimList(String userNo);

    /**
     * 알림 읽음 처리
     *
     * READ_YN : N → Y 변경
     */
    void readAlim(
            String alimNo,
            String userNo
    );

    /**
     * 읽지 않은 알림 개수 조회
     *
     * 상단 종모양(🔔) 배지 숫자 표시용
     */
    int getUnreadCount(String userNo);

}