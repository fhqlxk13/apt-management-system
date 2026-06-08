package kr.or.ddit.domain.member.resident.statsApartment.service;

import kr.or.ddit.domain.member.resident.statsApartment.dto.ResidentApartmentStatsCheckDTO;
import kr.or.ddit.domain.member.resident.statsApartment.dto.ResidentApartmentStatsComplaintDTO;
import kr.or.ddit.domain.member.resident.statsApartment.dto.ResidentApartmentStatsHouseDTO;
import kr.or.ddit.domain.member.resident.statsApartment.dto.ResidentApartmentStatsPartnerDTO;
import kr.or.ddit.domain.member.resident.statsApartment.dto.ResidentApartmentStatsResponseDTO;
import kr.or.ddit.domain.member.resident.statsApartment.mapper.IResidentApartmentStatsMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ResidentApartmentStatsServiceImpl implements IResidentApartmentStatsService {

    private final IResidentApartmentStatsMapper mapper;

    @Override
    public ResidentApartmentStatsResponseDTO selectApartmentStats(String aptCmplexNo) {
        ResidentApartmentStatsResponseDTO response = new ResidentApartmentStatsResponseDTO();

        /* 세대 현황 */
        ResidentApartmentStatsHouseDTO house = mapper.selectHouseStats(aptCmplexNo);
        response.setHouse(house);

        /* 검침 유형별 통계 */
        response.setMeterList(nvlList(mapper.selectMeterStatsList(aptCmplexNo)));

        /* 민원 요약 + 카테고리 분포 결합 */
        ResidentApartmentStatsComplaintDTO complaint = mapper.selectComplaintSummary(aptCmplexNo);
        if (complaint == null) {
            complaint = new ResidentApartmentStatsComplaintDTO();
        }
        complaint.setCategoryList(nvlList(mapper.selectComplaintCategoryList(aptCmplexNo)));
        response.setComplaint(complaint);

        /* 시설 이용 랭킹 */
        response.setFacilityList(nvlList(mapper.selectFacilityRankList(aptCmplexNo)));

        /* 시설 점검 현황 */
        ResidentApartmentStatsCheckDTO check = mapper.selectCheckSummary(aptCmplexNo);
        response.setCheck(check == null ? new ResidentApartmentStatsCheckDTO() : check);

        /* 협력업체 요약 + 업종 분포 결합 */
        ResidentApartmentStatsPartnerDTO partner = mapper.selectPartnerSummary(aptCmplexNo);
        if (partner == null) {
            partner = new ResidentApartmentStatsPartnerDTO();
        }
        partner.setBizTypeList(nvlList(mapper.selectPartnerBizTypeList(aptCmplexNo)));
        response.setPartner(partner);

        return response;
    }

    /* 빈 리스트 보정 */
    private <T> List<T> nvlList(List<T> list) {
        return list == null ? List.of() : list;
    }
}
