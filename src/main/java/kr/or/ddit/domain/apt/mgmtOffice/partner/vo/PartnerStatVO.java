package kr.or.ddit.domain.apt.mgmtOffice.partner.vo;

import lombok.Data;

/**
 * 협력업체 현황 VO
 * - JSP 상단 현황 카드 표시값 보관
 */
@Data
public class PartnerStatVO {

    /** 전체 업체수 */
    private int totalCnt;

    /** 활성 업체수 */
    private int activeCnt;

    /** 계약 연결 업체수 */
    private int contractLinkedCnt;

    /** 검침 연결 업체수 */
    private int meterLinkedCnt;
}
