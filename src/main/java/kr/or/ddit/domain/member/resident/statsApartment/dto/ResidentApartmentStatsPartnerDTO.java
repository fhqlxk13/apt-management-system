package kr.or.ddit.domain.member.resident.statsApartment.dto;

import lombok.Data;

import java.util.List;

@Data
public class ResidentApartmentStatsPartnerDTO {

    /* 전체 업체 수 */
    private Integer totalCnt;

    /* 활성 업체 수 */
    private Integer activeCnt;

    /* 비활성 업체 수 */
    private Integer inactiveCnt;

    /* 업종별 분포 */
    private List<ResidentApartmentStatsItemDTO> bizTypeList;
}
