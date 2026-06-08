package kr.or.ddit.domain.member.resident.mapper;


import kr.or.ddit.domain.central.dto.FacilityInfoDTO;
import kr.or.ddit.domain.member.resident.dto.ResidentFacilityHistoryDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 입주민 시설관리이력 Mapper
 *
 * Mapper란?
 * → Java 메서드와 MyBatis XML SQL을 연결하는 인터페이스.
 */
@Mapper
public interface IResidentFacilityMapper {

    String selectResidentAptCmplexNo(@Param("userNo") String userNo);

    FacilityInfoDTO selectAptInfo(@Param("aptCmplexNo") String aptCmplexNo);

    List<ResidentFacilityHistoryDTO> selectFacilityStatusCardList(@Param("aptCmplexNo") String aptCmplexNo);

    int selectFacilityHistoryCount(ResidentFacilityHistoryDTO dto);


    List<FacilityInfoDTO> selectResidentFacilityInfoList(
            @Param("aptCmplexNo") String aptCmplexNo,
            @Param("facilityTyCd") String facilityTyCd,
            @Param("facilityNm") String facilityNm,
            @Param("dongNo") String dongNo,
            @Param("locCn") String locCn,
            @Param("sortColumn") String sortColumn,
            @Param("sortOrder") String sortOrder,
            @Param("startRow") int startRow,
            @Param("endRow") int endRow
    );

    int selectResidentFacilityInfoCount(
            @Param("aptCmplexNo") String aptCmplexNo,
            @Param("facilityTyCd") String facilityTyCd,
            @Param("facilityNm") String facilityNm,
            @Param("dongNo") String dongNo,
            @Param("locCn") String locCn
    );


    List<ResidentFacilityHistoryDTO> selectFacilityHistoryList(ResidentFacilityHistoryDTO dto);


    List<FacilityInfoDTO> selectFacilityDongList(String aptCmplexNo);

    // 예약 가능한 편의시설 카드 목록 조회
    List<FacilityInfoDTO> selectReservablePublicFacilityCardList(@Param("aptCmplexNo") String aptCmplexNo);
}