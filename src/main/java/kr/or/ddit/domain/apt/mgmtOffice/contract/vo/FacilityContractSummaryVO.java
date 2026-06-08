package kr.or.ddit.domain.apt.mgmtOffice.contract.vo;

import lombok.Data;

/**
 * 계약 현황 카드 VO
 *
 * 화면 카드
 * - 전체 계약
 * - 진행중 계약
 * - 만료 예정
 * - 만료 계약
 */
@Data
public class FacilityContractSummaryVO {

    private int totalCnt;
    private int activeCnt;
    private int expireSoonCnt;
    private int expiredCnt;
}
