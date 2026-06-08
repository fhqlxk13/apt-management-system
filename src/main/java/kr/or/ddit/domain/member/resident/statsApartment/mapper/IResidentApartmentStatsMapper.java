package kr.or.ddit.domain.member.resident.statsApartment.mapper;

import kr.or.ddit.domain.member.resident.statsApartment.dto.ResidentApartmentStatsCheckDTO;
import kr.or.ddit.domain.member.resident.statsApartment.dto.ResidentApartmentStatsComplaintDTO;
import kr.or.ddit.domain.member.resident.statsApartment.dto.ResidentApartmentStatsFacilityDTO;
import kr.or.ddit.domain.member.resident.statsApartment.dto.ResidentApartmentStatsHouseDTO;
import kr.or.ddit.domain.member.resident.statsApartment.dto.ResidentApartmentStatsItemDTO;
import kr.or.ddit.domain.member.resident.statsApartment.dto.ResidentApartmentStatsMeterDTO;
import kr.or.ddit.domain.member.resident.statsApartment.dto.ResidentApartmentStatsPartnerDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface IResidentApartmentStatsMapper {

    /* 단지 세대 현황 조회 */
    ResidentApartmentStatsHouseDTO selectHouseStats(@Param("aptCmplexNo") String aptCmplexNo);

    /* 검침 유형별 통계 조회 */
    List<ResidentApartmentStatsMeterDTO> selectMeterStatsList(@Param("aptCmplexNo") String aptCmplexNo);

    /* 민원 요약 조회 */
    ResidentApartmentStatsComplaintDTO selectComplaintSummary(@Param("aptCmplexNo") String aptCmplexNo);

    /* 민원 카테고리별 분포 조회 */
    List<ResidentApartmentStatsItemDTO> selectComplaintCategoryList(@Param("aptCmplexNo") String aptCmplexNo);

    /* 시설 이용 랭킹 조회 */
    List<ResidentApartmentStatsFacilityDTO> selectFacilityRankList(@Param("aptCmplexNo") String aptCmplexNo);

    /* 시설 점검 현황 조회 */
    ResidentApartmentStatsCheckDTO selectCheckSummary(@Param("aptCmplexNo") String aptCmplexNo);

    /* 협력업체 요약 조회 */
    ResidentApartmentStatsPartnerDTO selectPartnerSummary(@Param("aptCmplexNo") String aptCmplexNo);

    /* 협력업체 업종별 분포 조회 */
    List<ResidentApartmentStatsItemDTO> selectPartnerBizTypeList(@Param("aptCmplexNo") String aptCmplexNo);
}
