package kr.or.ddit.domain.apt.mgmtOffice.reservation.service;

import kr.or.ddit.common.model.PaginationInfoVO;
import kr.or.ddit.domain.apt.mgmtOffice.reservation.vo.PublicFacilityReservationVO;

import java.util.List;

public interface IPublicFacilityReservationService {
    String getManagerAptCmplexNo(String mgmtOfcNo);
    String getResidentAptCmplexNo(String userNo);

    PaginationInfoVO<PublicFacilityReservationVO> getFacilityPaging(PublicFacilityReservationVO searchVO, int currentPage);
    PaginationInfoVO<PublicFacilityReservationVO> getApprovalPaging(PublicFacilityReservationVO searchVO, int currentPage);
    PaginationInfoVO<PublicFacilityReservationVO> getUseHistoryPaging(PublicFacilityReservationVO searchVO, int currentPage);
    PaginationInfoVO<PublicFacilityReservationVO> getResidentFacilityPaging(PublicFacilityReservationVO searchVO, int currentPage);
    PaginationInfoVO<PublicFacilityReservationVO> getMyReservationPaging(PublicFacilityReservationVO searchVO, int currentPage);

    PublicFacilityReservationVO getMyReservationDetail(PublicFacilityReservationVO searchVO);
    String reserve(PublicFacilityReservationVO vo);
    void approve(PublicFacilityReservationVO vo);
    void reject(PublicFacilityReservationVO vo);
    void cancel(PublicFacilityReservationVO vo);

    /*
     * 입주민 - 공용시설 선택 카드 목록 조회
     */
    List<PublicFacilityReservationVO> getResidentFacilityGroupList(PublicFacilityReservationVO searchVO);

    /*
     * 입주민 - 선택한 공용시설의 좌석/항목 목록 조회
     */
    List<PublicFacilityReservationVO> getResidentFacilityItemList(PublicFacilityReservationVO searchVO);

    /*
     * 입주민 - 선택한 시간에 이미 예약된 좌석/항목 번호 조회
     */
    List<String> getReservedItemNoList(PublicFacilityReservationVO searchVO);

    /*
     * 입주민 - 시간대별 예약현황 조회
     */
    List<PublicFacilityReservationVO> getReservationTimeSlotList(PublicFacilityReservationVO searchVO);

    List<PublicFacilityReservationVO> getHistoryFacilityFilterList(
            PublicFacilityReservationVO searchVO
    );

    List<PublicFacilityReservationVO> getHistoryItemFilterList(
            PublicFacilityReservationVO searchVO
    );

}


