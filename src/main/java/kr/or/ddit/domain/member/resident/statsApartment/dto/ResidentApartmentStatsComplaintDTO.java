package kr.or.ddit.domain.member.resident.statsApartment.dto;

import lombok.Data;

import java.math.BigDecimal;
import java.util.List;

@Data
public class ResidentApartmentStatsComplaintDTO {

    /* 전체 민원 수 */
    private Integer totalCnt;

    /* 접수 건수 */
    private Integer appliedCnt;

    /* 처리중 건수 */
    private Integer processingCnt;

    /* 완료 건수 */
    private Integer doneCnt;

    /* 취소 건수 */
    private Integer cancelCnt;

    /* 평균 처리 소요일 */
    private BigDecimal avgProcessDays;

    /* 카테고리별 분포 */
    private List<ResidentApartmentStatsItemDTO> categoryList;
}
