package kr.or.ddit.domain.member.resident.statsApartment.controller;

import kr.or.ddit.domain.member.resident.statsApartment.dto.ResidentApartmentStatsResponseDTO;
import kr.or.ddit.domain.member.resident.statsApartment.service.IResidentApartmentStatsService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequiredArgsConstructor
@PreAuthorize("hasAnyRole('RESIDENT', 'MNGR', 'ADMIN')")
public class ResidentApartmentStatsController {

    private final IResidentApartmentStatsService apartmentStatsService;

    /* 단지 통계 데이터 조회 */
    @PreAuthorize("@authService.hasAccess(principal, #aptCmplexNo)")
    @GetMapping("/resident/stats/apartment/{aptCmplexNo}/data")
    @ResponseBody
    public ResidentApartmentStatsResponseDTO apartmentStatsData(@PathVariable String aptCmplexNo) {
        return apartmentStatsService.selectApartmentStats(aptCmplexNo);
    }
}
