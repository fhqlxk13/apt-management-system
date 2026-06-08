package kr.or.ddit.domain.apt.mgmtOffice.bill.vo;

import lombok.Data;

import java.math.BigDecimal;
import java.util.Date;

@Data
/**
 * 작성자 : 이윤진
 * 세대별 검침 요금 계산용 VO
 *
 * METER_HSTRY 테이블의 검침값을 기준으로 세대별 전기/수도/가스 요금을 계산해서
 * BILL_DETAIL에 넣기 위한 VO
 */
public class MeterChargeVO {

    /* 세대 정보 */
    private String hoNo;                // APT_DETAIL.HO_NO
    private String dongNo;              // APT_DETAIL.DONG_NO
    private String dongNm;              // APT_UNIT.DONG_NM
    private String ho;                  // APT_DETAIL.HO
    private String displayDongHo;       // 화면 표시용 ex) 101동 202호

    /* METER_HSTRY 테이블 기본 컬럼 */
    private String meterHstryNo;        // METER_HSTRY.METER_HSTRY_NO
    private String facilityNo;          // METER_HSTRY.FACILITY_NO
    private String utilityProviderNo;   // METER_HSTRY.UTILITY_PROVIDER_NO
    private Date meterDt;               // METER_HSTRY.METER_DT
    private Long preVal;                // METER_HSTRY.PRE_VAL 이전 검침값
    private Long currVal;               // METER_HSTRY.CURR_VAL 현재 검침값
    private String meterCn;             // METER_HSTRY.METER_CN 검침 메모/내용
    private String meterRsltCd;         // METER_HSTRY.METER_RSLT_CD 검침 결과 코드

    /* 사용량 계산 */
    private String billItemCd;          // BILL_DETAIL.BILL_ITEM_CD에 들어갈 코드, ELC, WTR, GAS
    private String billItemNm;          // 코드명 표시용: 세대전기료, 세대수도료, 세대가스료
    private Long usageVal;              // 사용량 = currVal - preVal
    private Long unitPrice;             // 단가
    private Long chargeAmt;             // 계산금액 = usageVal * unitPrice

    /* 조회 조건 / 페이징 요약용 */
    private String aptCmplexNo;          // 검색 대상 단지번호
    private String billYm;               // 검침년월 YYYYMM
    private String keyword;              // 동/호수 검색어
    private Integer rowCount;            // 요약 조회 건수
    private Integer enteredCount;        // 현재 검침값 입력 건수

}
