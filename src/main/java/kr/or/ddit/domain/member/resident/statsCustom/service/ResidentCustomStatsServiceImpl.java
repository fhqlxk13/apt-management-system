package kr.or.ddit.domain.member.resident.statsCustom.service;

import kr.or.ddit.domain.member.resident.statsCustom.dto.ResidentCustomStatsComplaintDTO;
import kr.or.ddit.domain.member.resident.statsCustom.dto.ResidentCustomStatsHouseDTO;
import kr.or.ddit.domain.member.resident.statsCustom.dto.ResidentCustomStatsMeterDTO;
import kr.or.ddit.domain.member.resident.statsCustom.dto.ResidentCustomStatsResponseDTO;
import kr.or.ddit.domain.member.resident.statsCustom.dto.ResidentCustomStatsSummaryDTO;
import kr.or.ddit.domain.member.resident.statsCustom.mapper.IResidentCustomStatsMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.List;

@Service
@RequiredArgsConstructor
public class ResidentCustomStatsServiceImpl implements IResidentCustomStatsService {

    private final IResidentCustomStatsMapper residentCustomStatsMapper;

    @Override
    public ResidentCustomStatsResponseDTO selectCustomStats(String userNo, String aptCmplexNo) {
        /* 내 세대 정보 */
        ResidentCustomStatsHouseDTO house = residentCustomStatsMapper.selectMyHouse(userNo, aptCmplexNo);
        return buildCustomStats(userNo, house);
    }

    @Override
    public ResidentCustomStatsResponseDTO selectCustomStats(String userNo) {
        /* 기본 세대 정보 */
        ResidentCustomStatsHouseDTO house = residentCustomStatsMapper.selectMyFirstHouse(userNo);
        return buildCustomStats(userNo, house);
    }

    private ResidentCustomStatsResponseDTO buildCustomStats(String userNo, ResidentCustomStatsHouseDTO house) {
        ResidentCustomStatsResponseDTO response = new ResidentCustomStatsResponseDTO();
        response.setHouse(house);
        response.setMonthlyList(List.of());
        response.setMeterList(List.of());
        response.setFacilityList(List.of());
        response.setComplaint(emptyComplaint());

        if (house == null || house.getHoNo() == null) {
            return response;
        }

        /* 시설 이용 현황 */
        response.setFacilityList(residentCustomStatsMapper.selectFacilityList(userNo, house.getAptCmplexNo()));

        /* 민원 처리 현황 */
        ResidentCustomStatsComplaintDTO complaint =
                residentCustomStatsMapper.selectComplaint(userNo, house.getAptCmplexNo());
        response.setComplaint(complaint == null ? emptyComplaint() : complaint);

        /* 최근 관리년월 */
        String billYm = residentCustomStatsMapper.selectLatestBillYm(house.getHoNo());
        if (billYm == null || billYm.isBlank()) {
            return response;
        }

        /* 요약 통계 */
        ResidentCustomStatsSummaryDTO summary =
                residentCustomStatsMapper.selectSummary(house.getHoNo(), house.getAptCmplexNo(), billYm);
        fillSummaryDiff(summary);
        response.setSummary(summary);

        /* 월별 통계 */
        response.setMonthlyList(residentCustomStatsMapper.selectMonthlyList(house.getHoNo(), house.getAptCmplexNo()));

        /* 검침 사용량 통계 */
        List<ResidentCustomStatsMeterDTO> meterList =
                residentCustomStatsMapper.selectMeterList(house.getHoNo(), house.getAptCmplexNo(), billYm);
        meterList.forEach(this::fillMeterDiff);
        response.setMeterList(meterList);

        return response;
    }

    private ResidentCustomStatsComplaintDTO emptyComplaint() {
        ResidentCustomStatsComplaintDTO complaint = new ResidentCustomStatsComplaintDTO();
        complaint.setAppliedCnt(0);
        complaint.setProcessingCnt(0);
        complaint.setDoneCnt(0);
        return complaint;
    }

    private void fillSummaryDiff(ResidentCustomStatsSummaryDTO summary) {
        if (summary == null) {
            return;
        }

        Long current = nvl(summary.getCurrentBillAmt());
        Long previous = nvl(summary.getPreviousBillAmt());
        Long average = nvl(summary.getSimilarAvgAmt());

        summary.setPreviousDiffAmt(current - previous);
        summary.setPreviousDiffRate(rate(current - previous, previous));
        summary.setAverageDiffAmt(current - average);
        summary.setAverageDiffRate(rate(current - average, average));
    }

    private void fillMeterDiff(ResidentCustomStatsMeterDTO meter) {
        Long myUsage = nvl(meter.getMyUsageVal());
        Long avgUsage = nvl(meter.getAvgUsageVal());

        meter.setDiffVal(myUsage - avgUsage);
        meter.setDiffRate(rate(myUsage - avgUsage, avgUsage));
    }

    private Long nvl(Long value) {
        return value == null ? 0L : value;
    }

    private BigDecimal rate(long diff, long base) {
        if (base == 0L) {
            return BigDecimal.ZERO;
        }
        return BigDecimal.valueOf(diff)
                .multiply(BigDecimal.valueOf(100))
                .divide(BigDecimal.valueOf(base), 1, RoundingMode.HALF_UP);
    }
}
