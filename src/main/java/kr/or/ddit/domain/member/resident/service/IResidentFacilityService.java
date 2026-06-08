package kr.or.ddit.domain.member.resident.service;

import kr.or.ddit.domain.central.dto.FacilityInfoDTO;
import kr.or.ddit.domain.member.resident.dto.ResidentFacilityHistoryDTO;

import java.util.List;

public interface IResidentFacilityService {

    String getResidentAptCmplexNo(String userNo);

    FacilityInfoDTO getAptInfo(String aptCmplexNo);

    List<ResidentFacilityHistoryDTO> getFacilityStatusCardList(String aptCmplexNo);

    List<FacilityInfoDTO> getResidentFacilityInfoList(
            String aptCmplexNo,
            String facilityTyCd,
            String facilityNm,
            String dongNo,
            String locCn,
            String sortColumn,
            String sortOrder,
            int startRow,
            int endRow
    );

    /*
     * 시설정보 총 건수 조회
     * → 우리 단지 시설정보 페이징 계산에 필요.
     */
    int getResidentFacilityInfoCount(
            String aptCmplexNo,
            String facilityTyCd,
            String facilityNm,
            String dongNo,
            String locCn
    );

    List<FacilityInfoDTO> getFacilityDongList(String aptCmplexNo);

    /*
     * 시설 점검 상세 이력 총 건수 조회
     */
    int getFacilityHistoryCount(ResidentFacilityHistoryDTO dto);

    /*
     * 시설 점검 상세 이력 목록 조회
     */
    List<ResidentFacilityHistoryDTO> getFacilityHistoryList(ResidentFacilityHistoryDTO dto);

    // 예약제 편의시설 목록 조회
    List<FacilityInfoDTO> getReservablePublicFacilityCardList(String aptCmplexNo);
}