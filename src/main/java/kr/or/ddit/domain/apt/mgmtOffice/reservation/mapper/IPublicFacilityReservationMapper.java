package kr.or.ddit.domain.apt.mgmtOffice.reservation.mapper;

import kr.or.ddit.domain.apt.mgmtOffice.reservation.vo.PublicFacilityReservationVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

/**
 * Mapper란? Java 메서드와 SQL XML을 연결하는 인터페이스입니다.
 * 왜 사용? Controller가 SQL을 직접 알지 않게 분리하기 위해 사용합니다.
 */
@Mapper
public interface IPublicFacilityReservationMapper {
    String selectAptCmplexNoByMgmtOfcNo(@Param("mgmtOfcNo") String mgmtOfcNo);
    String selectAptCmplexNoByResidentUserNo(@Param("userNo") String userNo);
    String selectNextRsvtNo();

    int selectFacilityListCount(PublicFacilityReservationVO searchVO);
    List<PublicFacilityReservationVO> selectFacilityList(PublicFacilityReservationVO searchVO);

    int selectApprovalListCount(PublicFacilityReservationVO searchVO);
    List<PublicFacilityReservationVO> selectApprovalList(PublicFacilityReservationVO searchVO);

    int selectUseHistoryCount(PublicFacilityReservationVO searchVO);
    List<PublicFacilityReservationVO> selectUseHistoryList(PublicFacilityReservationVO searchVO);

    int selectResidentFacilityListCount(PublicFacilityReservationVO searchVO);
    List<PublicFacilityReservationVO> selectResidentFacilityList(PublicFacilityReservationVO searchVO);

    int selectMyReservationCount(PublicFacilityReservationVO searchVO);
    List<PublicFacilityReservationVO> selectMyReservationList(PublicFacilityReservationVO searchVO);
    PublicFacilityReservationVO selectMyReservationDetail(PublicFacilityReservationVO searchVO);

    int insertReservation(PublicFacilityReservationVO vo);

    /*
     * [추가] 시설 점검 이용제한 시간과 예약 시간이 겹치는지 조회합니다.
     * 왜 추가? 점검으로 이용 제한된 시간에는 입주민 예약을 막기 위해 사용합니다.
     */
    int selectFacilityCheckRestrictCount(PublicFacilityReservationVO vo);

    int approveReservation(PublicFacilityReservationVO vo);
    int rejectReservation(PublicFacilityReservationVO vo);
    int cancelReservation(PublicFacilityReservationVO vo);
    int selectDuplicateReservationCount(PublicFacilityReservationVO vo);

    /*
     * 예약할 좌석번호로 시설 정보를 다시 조회합니다.
     * 왜 사용? 화면에서 넘어온 시설명이 아니라 DB 기준으로 자동승인 여부를 판단하기 위해 사용합니다.
     */
    PublicFacilityReservationVO selectFacilityInfoByItemNo(PublicFacilityReservationVO vo);

    /*
     * 입주민 - 예약 가능한 공용시설 종류 목록
     * 예: 단지독서실, 주민회의실, 피트니스센터
     */
    List<PublicFacilityReservationVO> selectResidentFacilityGroupList(PublicFacilityReservationVO searchVO);

    /*
     * 입주민 - 선택한 공용시설의 세부 항목 목록
     * 예: 독서실 좌석 101번, 102번
     */
    List<PublicFacilityReservationVO> selectResidentFacilityItemList(PublicFacilityReservationVO searchVO);

    /*
     * 입주민 - 선택한 시간에 이미 예약된 세부 항목 번호 목록
     * 예: 이미 예약된 독서실 좌석 번호
     */
    List<String> selectReservedItemNoList(PublicFacilityReservationVO searchVO);

    /*
     * 선택한 예약대상의 날짜별 시간표 조회
     * 예: 헬스장 러닝머신1번의 08:00~21:00 예약현황
     */
    List<PublicFacilityReservationVO> selectReservationTimeSlotList(PublicFacilityReservationVO searchVO);

    int updateItemStatusRepair(PublicFacilityReservationVO vo);
    int updateItemStatusUse(PublicFacilityReservationVO vo);
    int updateItemStatusOpenForExpired();

    /*
     * 이용이력 검색조건 - 시설명 셀렉트박스 목록
     */
    List<PublicFacilityReservationVO> selectHistoryFacilityFilterList(PublicFacilityReservationVO searchVO);

    /*
     * 이용이력 검색조건 - 예약대상 셀렉트박스 목록
     */
    List<PublicFacilityReservationVO> selectHistoryItemFilterList(PublicFacilityReservationVO searchVO);

    /*
     * 승인대기 예약 자동 만료 처리
     */
    int expirePendingReservations(String aptCmplexNo);

    /* SMS 발송용 예약 상세 조회 */
    PublicFacilityReservationVO selectReservationSmsInfo(String rsvtNo);

}

