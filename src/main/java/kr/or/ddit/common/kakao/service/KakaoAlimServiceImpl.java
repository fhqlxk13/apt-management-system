package kr.or.ddit.common.kakao.service;

import kr.or.ddit.common.kakao.mapper.IKakaoAlimMapper;
import kr.or.ddit.common.kakao.vo.KakaoAlimVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 카카오 스타일 알림 서비스
 *
 * Service란?
 * 실제 업무 로직을 처리하는 계층입니다.
 *
 * 왜 사용?
 * Controller가 DB 저장 방법을 직접 알지 않게 분리하기 위해 사용합니다.
 */
@Service
@RequiredArgsConstructor
public class KakaoAlimServiceImpl implements IKakaoAlimService {

    /**
     * Mapper 호출 객체
     *
     * DB 조회 및 저장 담당
     */
    private final IKakaoAlimMapper mapper;

    /**
     * 예약 승인 알림 생성
     *
     * 승인 완료 시 알림 테이블에 저장
     */
    @Override
    @Transactional
    public void sendReservationApproved(String userNo, String facilityNm, String rsvtDttm, String linkUrl) {
        KakaoAlimVO vo = new KakaoAlimVO();

        vo.setAlimNo(mapper.selectNextAlimNo());
        vo.setUserNo(userNo);
        vo.setAlimTyCd("RSVT_APPROVED");
        vo.setAlimTtl("편의시설 예약 승인");
        vo.setAlimCn("[STEVEN_ZIPS]\n" + facilityNm + " 예약이 승인되었습니다.\n예약일시: " + rsvtDttm);
        vo.setLinkUrl(linkUrl);
        vo.setRgtrId("SYSTEM");

        mapper.insertKakaoAlim(vo);
    }

    /**
     * 예약 승인만료 알림 생성
     *
     * 승인만료란?
     * 관리자가 예약 시작시간 전까지 승인/거절을 하지 않아서
     * 시스템이 자동으로 예약을 취소한 상태입니다.
     */
    @Override
    @Transactional
    public void sendReservationExpired(String userNo, String facilityNm, String rsvtDttm, String linkUrl) {
        KakaoAlimVO vo = new KakaoAlimVO();

        vo.setAlimNo(mapper.selectNextAlimNo());
        vo.setUserNo(userNo);
        vo.setAlimTyCd("RSVT_EXPIRED");
        vo.setAlimTtl("예약 자동취소");

        // LMS 방지용 짧은 문구
        vo.setAlimCn(
                facilityNm + " 예약이 자동취소되었습니다.\n" +
                        "사유: 승인 가능 시간 초과"
        );

        vo.setLinkUrl(linkUrl);
        vo.setRgtrId("SYSTEM");

        mapper.insertKakaoAlim(vo);
    }

    /**
     * 예약 거절 알림 생성
     *
     * 거절 사유와 함께 알림 저장
     */
    @Override
    @Transactional
    public void sendReservationRejected(String userNo, String facilityNm, String reason, String linkUrl) {
        KakaoAlimVO vo = new KakaoAlimVO();

        vo.setAlimNo(mapper.selectNextAlimNo());
        vo.setUserNo(userNo);
        vo.setAlimTyCd("RSVT_REJECTED");
        vo.setAlimTtl("편의시설 예약 거절");
        vo.setAlimCn("[STEVEN_ZIPS]\n" + facilityNm + " 예약이 거절되었습니다.\n사유: " + reason);
        vo.setLinkUrl(linkUrl);
        vo.setRgtrId("SYSTEM");

        mapper.insertKakaoAlim(vo);
    }

    /**
     * 입주 승인 알림 생성
     *
     * 입주 승인 완료 시 알림 저장
     */
    @Override
    @Transactional
    public void sendResidentApproved(String userNo, String linkUrl) {
        KakaoAlimVO vo = new KakaoAlimVO();

        vo.setAlimNo(mapper.selectNextAlimNo());
        vo.setUserNo(userNo);
        vo.setAlimTyCd("RESIDENT_APPROVED");
        vo.setAlimTtl("입주 승인 완료");
        vo.setAlimCn("[STEVEN_ZIPS]\n입주 신청이 승인되었습니다.\n입주민 서비스를 이용하실 수 있습니다.");
        vo.setLinkUrl(linkUrl);
        vo.setRgtrId("SYSTEM");

        mapper.insertKakaoAlim(vo);
    }

    /**
     * 내 알림 목록 조회
     *
     * 알림센터 목록 조회용
     */
    @Override
    public List<KakaoAlimVO> getMyAlimList(String userNo) {
        return mapper.selectMyKakaoAlimList(userNo);
    }

    /**
     * 알림 읽음 처리
     *
     * READ_YN 값을 N → Y로 변경
     */
    @Override
    @Transactional
    public void readAlim(String alimNo, String userNo) {
        mapper.updateReadYn(alimNo, userNo);
    }

    /**
     * 예약 신청 완료 알림 생성
     *
     * 예약 등록 직후 알림 저장
     */
    @Override
    @Transactional
    public void sendReservationRequested(String userNo, String facilityNm, String rsvtDttm, String linkUrl) {
        KakaoAlimVO vo = new KakaoAlimVO();

        vo.setAlimNo(mapper.selectNextAlimNo());
        vo.setUserNo(userNo);
        vo.setAlimTyCd("RSVT_REQUESTED");
        vo.setAlimTtl("편의시설 예약 신청");
        vo.setAlimCn(facilityNm + " 예약신청이 완료되었습니다.\n예약일시: " + rsvtDttm);
        vo.setLinkUrl(linkUrl);
        vo.setRgtrId("SYSTEM");

        mapper.insertKakaoAlim(vo);
    }

    /**
     * 예약 취소 완료 알림 생성
     *
     * 예약 취소 시 알림 저장
     */
    @Override
    @Transactional
    public void sendReservationCancelled(String userNo, String facilityNm, String rsvtDttm, String linkUrl) {
        KakaoAlimVO vo = new KakaoAlimVO();

        vo.setAlimNo(mapper.selectNextAlimNo());
        vo.setUserNo(userNo);
        vo.setAlimTyCd("RSVT_CANCELLED");
        vo.setAlimTtl("편의시설 예약 취소");
        vo.setAlimCn(facilityNm + " 예약신청이 취소되었습니다.\n예약일시: " + rsvtDttm);
        vo.setLinkUrl(linkUrl);
        vo.setRgtrId("SYSTEM");

        mapper.insertKakaoAlim(vo);
    }

    /**
     * 읽지 않은 알림 개수 조회
     *
     * 상단 알림 배지(🔔) 숫자 표시용
     */
    @Override
    public int getUnreadCount(String userNo) {
        return mapper.selectUnreadCount(userNo);
    }

}