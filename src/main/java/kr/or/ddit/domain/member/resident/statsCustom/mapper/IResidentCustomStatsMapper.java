package kr.or.ddit.domain.member.resident.statsCustom.mapper;

import kr.or.ddit.domain.member.resident.statsCustom.dto.ResidentCustomStatsComplaintDTO;
import kr.or.ddit.domain.member.resident.statsCustom.dto.ResidentCustomStatsFacilityDTO;
import kr.or.ddit.domain.member.resident.statsCustom.dto.ResidentCustomStatsHouseDTO;
import kr.or.ddit.domain.member.resident.statsCustom.dto.ResidentCustomStatsMeterDTO;
import kr.or.ddit.domain.member.resident.statsCustom.dto.ResidentCustomStatsMonthlyDTO;
import kr.or.ddit.domain.member.resident.statsCustom.dto.ResidentCustomStatsSummaryDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface IResidentCustomStatsMapper {

    /* 내 세대 조회 */
    ResidentCustomStatsHouseDTO selectMyHouse(
            @Param("userNo") String userNo,
            @Param("aptCmplexNo") String aptCmplexNo
    );

    /* 내 첫 세대 조회 */
    ResidentCustomStatsHouseDTO selectMyFirstHouse(@Param("userNo") String userNo);

    /* 최근 관리년월 조회 */
    String selectLatestBillYm(@Param("hoNo") String hoNo);

    /* 요약 통계 조회 */
    ResidentCustomStatsSummaryDTO selectSummary(
            @Param("hoNo") String hoNo,
            @Param("aptCmplexNo") String aptCmplexNo,
            @Param("billYm") String billYm
    );

    /* 월별 관리비 비교 조회 */
    List<ResidentCustomStatsMonthlyDTO> selectMonthlyList(
            @Param("hoNo") String hoNo,
            @Param("aptCmplexNo") String aptCmplexNo
    );

    /* 검침 사용량 비교 조회 */
    List<ResidentCustomStatsMeterDTO> selectMeterList(
            @Param("hoNo") String hoNo,
            @Param("aptCmplexNo") String aptCmplexNo,
            @Param("billYm") String billYm
    );

    /* 이번 달 시설 이용 현황 조회 */
    List<ResidentCustomStatsFacilityDTO> selectFacilityList(
            @Param("userNo") String userNo,
            @Param("aptCmplexNo") String aptCmplexNo
    );

    /* 내 민원 처리 현황 조회 */
    ResidentCustomStatsComplaintDTO selectComplaint(
            @Param("userNo") String userNo,
            @Param("aptCmplexNo") String aptCmplexNo
    );
}
