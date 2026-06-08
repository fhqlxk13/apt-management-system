package kr.or.ddit.domain.apt.mgmtOffice.reservation.service;

import kr.or.ddit.common.kakao.service.IKakaoAlimService;
import kr.or.ddit.common.model.PaginationInfoVO;
import kr.or.ddit.common.notification.dto.NotificationDTO;
import kr.or.ddit.common.notification.service.NotificationService;
import kr.or.ddit.common.sms.service.ISmsService;
import kr.or.ddit.domain.apt.mgmtOffice.reservation.mapper.IPublicFacilityReservationMapper;
import kr.or.ddit.domain.apt.mgmtOffice.reservation.vo.PublicFacilityReservationVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.util.List;

/**
 * ServiceImpl란? 실제 업무 규칙을 처리하는 클래스입니다.
 * 왜 사용? Controller는 요청/응답만 담당하고, 중복예약검사·승인상태변경 같은 업무는 Service에 모읍니다.
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class PublicFacilityReservationServiceImpl implements IPublicFacilityReservationService {

    private final IPublicFacilityReservationMapper mapper;

    private final NotificationService notificationService;

    /* SMS 문자 발송 */
    private final ISmsService smsService;

    /* 카카오톡 스타일 알림 저장 서비스 */
    private final IKakaoAlimService kakaoAlimService;


    private PaginationInfoVO<PublicFacilityReservationVO> buildPaging(
            PublicFacilityReservationVO searchVO, int currentPage, int totalRecord, List<PublicFacilityReservationVO> dataList) {
        PaginationInfoVO<PublicFacilityReservationVO> pagingVO = new PaginationInfoVO<>(10, 5);
        pagingVO.setSearchVO(searchVO);
        pagingVO.setTotalRecord(totalRecord);
        pagingVO.setCurrentPage(currentPage);
        pagingVO.setDataList(dataList);
        return pagingVO;
    }

    private void applyPaging(PublicFacilityReservationVO searchVO, PaginationInfoVO<PublicFacilityReservationVO> pagingVO) {
        searchVO.setStartRow(pagingVO.getStartRow());
        searchVO.setEndRow(pagingVO.getEndRow());
    }

    @Override public String getManagerAptCmplexNo(String mgmtOfcNo) { return mapper.selectAptCmplexNoByMgmtOfcNo(mgmtOfcNo); }
    @Override public String getResidentAptCmplexNo(String userNo) { return mapper.selectAptCmplexNoByResidentUserNo(userNo); }

    @Override
    public PaginationInfoVO<PublicFacilityReservationVO> getFacilityPaging(PublicFacilityReservationVO searchVO, int currentPage) {
        int total = mapper.selectFacilityListCount(searchVO);
        PaginationInfoVO<PublicFacilityReservationVO> paging = new PaginationInfoVO<>(10, 5);
        paging.setTotalRecord(total); paging.setCurrentPage(currentPage); applyPaging(searchVO, paging);
        paging.setDataList(mapper.selectFacilityList(searchVO)); paging.setSearchVO(searchVO);
        return paging;
    }

    @Override
    public PaginationInfoVO<PublicFacilityReservationVO> getApprovalPaging(
            PublicFacilityReservationVO searchVO,
            int currentPage
    ) {
        mapper.expirePendingReservations(searchVO.getAptCmplexNo());

        int total = mapper.selectApprovalListCount(searchVO);
        PaginationInfoVO<PublicFacilityReservationVO> paging = new PaginationInfoVO<>(10, 5);
        paging.setTotalRecord(total); paging.setCurrentPage(currentPage); applyPaging(searchVO, paging);
        paging.setDataList(mapper.selectApprovalList(searchVO)); paging.setSearchVO(searchVO);
        return paging;
    }

    @Override
    public PaginationInfoVO<PublicFacilityReservationVO> getUseHistoryPaging(PublicFacilityReservationVO searchVO, int currentPage) {
        int total = mapper.selectUseHistoryCount(searchVO);
        PaginationInfoVO<PublicFacilityReservationVO> paging = new PaginationInfoVO<>(10, 5);
        paging.setTotalRecord(total); paging.setCurrentPage(currentPage); applyPaging(searchVO, paging);
        paging.setDataList(mapper.selectUseHistoryList(searchVO)); paging.setSearchVO(searchVO);
        return paging;
    }

    @Override
    public PaginationInfoVO<PublicFacilityReservationVO> getResidentFacilityPaging(PublicFacilityReservationVO searchVO, int currentPage) {
        int total = mapper.selectResidentFacilityListCount(searchVO);
        PaginationInfoVO<PublicFacilityReservationVO> paging = new PaginationInfoVO<>(10, 5);
        paging.setTotalRecord(total); paging.setCurrentPage(currentPage); applyPaging(searchVO, paging);
        paging.setDataList(mapper.selectResidentFacilityList(searchVO)); paging.setSearchVO(searchVO);
        return paging;
    }

    @Override
    public PaginationInfoVO<PublicFacilityReservationVO> getMyReservationPaging(
            PublicFacilityReservationVO searchVO, int currentPage
    ) {
        /*
         * 승인대기 만료 처리
         *
         * 예약 시작 시간이 지났는데도 관리자가 승인하지 않은 예약을
         * EXPIRED 상태로 자동 변경합니다.
         *
         * 왜 조회 전에 실행?
         * 목록을 조회하기 전에 DB 상태를 먼저 정리해야
         * 화면에 PENDING이 아니라 EXPIRED로 보이기 때문입니다.
         */
        mapper.expirePendingReservations(searchVO.getAptCmplexNo());

        int total = mapper.selectMyReservationCount(searchVO);

        PaginationInfoVO<PublicFacilityReservationVO> paging = new PaginationInfoVO<>(10, 5);
        paging.setTotalRecord(total);
        paging.setCurrentPage(currentPage);

        applyPaging(searchVO, paging);

        paging.setDataList(mapper.selectMyReservationList(searchVO));
        paging.setSearchVO(searchVO);

        return paging;
    }

    @Override
    public PublicFacilityReservationVO getMyReservationDetail(
            PublicFacilityReservationVO searchVO
    ) {
        /*
         * 승인대기 만료 처리
         *
         * 상세 모달을 열기 전에 예약 상태를 먼저 갱신합니다.
         * 그래야 상세 화면에서도 상태가 EXPIRED로 보입니다.
         */
        mapper.expirePendingReservations(searchVO.getAptCmplexNo());

        return mapper.selectMyReservationDetail(searchVO);
    }

    @Override
    @Transactional
    public String reserve(PublicFacilityReservationVO vo) {

        /*
         * DB 기준 시설정보 조회
         * 왜 사용? 사용자가 화면에서 시설명을 조작해도 서버가 DB 기준으로 판단하기 위해 사용합니다.
         */
        PublicFacilityReservationVO facilityInfo = mapper.selectFacilityInfoByItemNo(vo);

        if (facilityInfo == null) {
            throw new IllegalArgumentException("예약 가능한 시설 정보가 없습니다.");
        }

        /*
         * 이미 예약된 시간인지 검사합니다.
         */
        if (mapper.selectDuplicateReservationCount(vo) > 0) {
            throw new IllegalStateException("이미 예약된 시간입니다.");
        }

        /*
         * [추가] 시설 점검 이용제한 예약 차단
         * 왜 추가? 점검으로 이용 제한된 시간에는 입주민 예약을 막기 위해 사용합니다.
         *
         * 주의:
         * PUBLIC_ITEM 상태를 직접 바꾸지 않고, 예약하려는 시간과
         * FACILITY_CHECK_HSTRY의 이용제한 시간을 비교해서 저장 직전에만 차단합니다.
         */
        if (mapper.selectFacilityCheckRestrictCount(vo) > 0) {
            throw new IllegalStateException("시설 점검으로 예약할 수 없는 시간입니다.");
        }

        vo.setRsvtNo(mapper.selectNextRsvtNo());
        vo.setCmnFacilityNo(facilityInfo.getCmnFacilityNo());
        vo.setCmnFacilityNm(facilityInfo.getCmnFacilityNm());

        String facilityNm = facilityInfo.getCmnFacilityNm() == null ? "" : facilityInfo.getCmnFacilityNm();

        /*
         * 승인 정책
         * - 회의실/커뮤니티룸: 관리자 승인 필요 → PENDING
         * - 독서실/헬스장: 자동 승인 → APPROVED
         */
//        if (facilityNm.contains("회의실") || facilityNm.contains("커뮤니티룸")) {
//            vo.setRsvtSttsCd("PENDING");
//            vo.setAutoApproveYn("N");
//        } else {
//            vo.setRsvtSttsCd("APPROVED");
//            vo.setAutoApproveYn("Y");
//        }

        /*
         * 관리자 승인 대상 시설 판단
         *
         * PENDING이란?
         * 승인대기 상태입니다.
         * 입주민이 예약 요청만 한 상태이고, 관리자가 승인해야 최종 예약완료가 됩니다.
         *
         * 왜 사용?
         * 화면에 "관리자 승인" 뱃지가 붙은 시설은 자동승인되면 안 되기 때문입니다.
         */
        if (isManagerApprovalFacility(facilityNm)) {
            vo.setRsvtSttsCd("PENDING");     // 관리자 승인대기
            vo.setAutoApproveYn("N");
        } else {
            vo.setRsvtSttsCd("APPROVED");    // 자동승인
            vo.setAutoApproveYn("Y");
        }


        mapper.insertReservation(vo);

        /*
         * 카카오 알림 저장
         * PENDING 예약이면 "예약 신청 완료"
         * APPROVED 예약이면 "예약 승인 완료" 알림을 저장합니다.
         */
        String linkUrl = "/resident/publicFacility/myReservation/" + vo.getAptCmplexNo();
        String rsvtDttm = vo.getRsvtBgngDttm() + " ~ " + vo.getRsvtEndDttm();

        if ("PENDING".equals(vo.getRsvtSttsCd())) {
            kakaoAlimService.sendReservationRequested(
                    vo.getUserNo(),
                    vo.getCmnFacilityNm(),
                    rsvtDttm,
                    linkUrl
            );
        } else if ("APPROVED".equals(vo.getRsvtSttsCd())) {
            kakaoAlimService.sendReservationApproved(
                    vo.getUserNo(),
                    vo.getCmnFacilityNm(),
                    rsvtDttm,
                    linkUrl
            );
        }

        return vo.getRsvtNo();
    }

    @Override
    @Transactional
    public void approve(PublicFacilityReservationVO vo) {

        int result = mapper.approveReservation(vo);

        if (result == 0) {
            throw new IllegalStateException("승인할 수 없는 예약입니다.");
        }

        PublicFacilityReservationVO smsInfo =
                mapper.selectReservationSmsInfo(vo.getRsvtNo());

        if (smsInfo == null) {
            throw new IllegalStateException("예약 알림 발송 정보를 찾을 수 없습니다.");

        }

        /*
         * SMS에 표시할 예약일시 생성
         *
         * 예)
         * 2026-06-01 10:00 ~ 2026-06-01 11:00
         */
        String rsvtDttm =
                smsInfo.getRsvtBgngDttm()
                        + " ~ "
                        + smsInfo.getRsvtEndDttm();

        String userNo = smsInfo.getUserNo();
        String cmnFacilityNm = smsInfo.getCmnFacilityNm();
        String aptCmplexNo = smsInfo.getAptCmplexNo();

        log.info("####userNo = {}" , userNo);
        log.info("####cmnFacilityNm = {}" , cmnFacilityNm);
        log.info("####aptCmplexNo = {}" , aptCmplexNo);

        /*
         * 1. 실제 SMS 발송
         * 여기서 실패하면 예외가 발생해야 함.
         * 그래야 아래 카카오 알림 INSERT가 실행되지 않음.
         */
        smsService.sendReservationApproved(
                smsInfo.getUserNo(),
                smsInfo.getCmnFacilityNm(),
                rsvtDttm,
                "SYSTEM"
        );

        /*
         * 2. SMS 성공 후에만 카카오 알림 DB 저장
         * 이 데이터가 입주민 카카오 모달에 출력됨.
         */
        kakaoAlimService.sendReservationApproved(
                smsInfo.getUserNo(),
                smsInfo.getCmnFacilityNm(),
                rsvtDttm,
                "/resident/publicFacility/myReservation/" + smsInfo.getAptCmplexNo()
        );

        notificationService.send(
                userNo,
                NotificationDTO.success(
                        "시설 예약 승인",
                        cmnFacilityNm + " 예약이 승인되었습니다",
                        "/resident/publicFacility/myReservation/"+aptCmplexNo
                )
        );
    }

    @Override
    @Transactional
    public void reject(PublicFacilityReservationVO vo) {

        if (!StringUtils.hasText(vo.getRejectReason())) {
            throw new IllegalArgumentException("거절사유는 필수입니다.");
        }

        mapper.rejectReservation(vo);

        PublicFacilityReservationVO smsInfo =
                mapper.selectReservationSmsInfo(vo.getRsvtNo());

        if (smsInfo == null) {
            throw new IllegalStateException("예약 알림 발송 정보를 찾을 수 없습니다.");
        }

        /*
         * SMS에 표시할 예약일시 생성
         *
         * 예)
         * 2026-06-01 10:00 ~ 2026-06-01 11:00
         */
        String rsvtDttm =
                smsInfo.getRsvtBgngDttm()
                        + " ~ "
                        + smsInfo.getRsvtEndDttm();

        /*
         * 예약 거절 SMS 발송
         */
        smsService.sendReservationRejected(
                smsInfo.getUserNo(),
                smsInfo.getCmnFacilityNm(),
                rsvtDttm,
                vo.getRejectReason(),
                "SYSTEM"
        );

        /*
         * SMS 성공 후 카카오 알림 저장
         */
        kakaoAlimService.sendReservationRejected(
                smsInfo.getUserNo(),
                smsInfo.getCmnFacilityNm(),
                vo.getRejectReason(),
                "/resident/publicFacility/myReservation/" + smsInfo.getAptCmplexNo()
        );
    }

    @Override
    @Transactional
    public void cancel(PublicFacilityReservationVO vo) {

        /*
         * 취소 전 예약 정보를 먼저 조회합니다.
         * 왜 먼저 조회?
         * cancelReservation 실행 후에는 상태가 CANCELLED로 바뀌므로,
         * 알림에 넣을 시설명/예약시간/단지번호를 미리 가져오기 위해서입니다.
         */
        PublicFacilityReservationVO smsInfo =
                mapper.selectReservationSmsInfo(vo.getRsvtNo());

        int result = mapper.cancelReservation(vo);

        if (result == 0) {
            throw new IllegalStateException("예약 시작 시간이 지났거나 취소할 수 없는 예약입니다.");
        }

        if (smsInfo != null) {
            kakaoAlimService.sendReservationCancelled(
                    smsInfo.getUserNo(),
                    smsInfo.getCmnFacilityNm(),
                    smsInfo.getRsvtBgngDttm() + " ~ " + smsInfo.getRsvtEndDttm(),
                    "/resident/publicFacility/myReservation/" + smsInfo.getAptCmplexNo()
            );
        }
    }

    @Override
    public List<PublicFacilityReservationVO> getResidentFacilityGroupList(PublicFacilityReservationVO searchVO) {
        return mapper.selectResidentFacilityGroupList(searchVO);
    }

    @Override
    public List<PublicFacilityReservationVO> getResidentFacilityItemList(PublicFacilityReservationVO searchVO) {
        return mapper.selectResidentFacilityItemList(searchVO);
    }

    @Override
    public List<String> getReservedItemNoList(PublicFacilityReservationVO searchVO) {
        return mapper.selectReservedItemNoList(searchVO);
    }

    @Override
    public List<PublicFacilityReservationVO> getReservationTimeSlotList(
            PublicFacilityReservationVO searchVO
    ) {
        mapper.expirePendingReservations(searchVO.getAptCmplexNo());

        return mapper.selectReservationTimeSlotList(searchVO);
    }

    @Override
    public List<PublicFacilityReservationVO> getHistoryFacilityFilterList(
            PublicFacilityReservationVO searchVO
    ) {
        return mapper.selectHistoryFacilityFilterList(searchVO);
    }

    @Override
    public List<PublicFacilityReservationVO> getHistoryItemFilterList(
            PublicFacilityReservationVO searchVO
    ) {
        return mapper.selectHistoryItemFilterList(searchVO);
    }

    /**
     * 관리자 승인 대상 시설 여부
     *
     * private 메서드란?
     * 이 클래스 안에서만 사용하는 보조 메서드입니다.
     */
    private boolean isManagerApprovalFacility(String facilityNm) {
        if (facilityNm == null) {
            return false;
        }

        return facilityNm.contains("회의실")
                || facilityNm.contains("커뮤니티룸")
                || facilityNm.contains("라운지")
                || facilityNm.contains("테니스장");
    }



}



