package kr.or.ddit.domain.apt.mgmtOffice.bill.service;

import kr.or.ddit.common.model.PaginationInfoVO;
import kr.or.ddit.domain.apt.mgmtOffice.bill.mapper.IMeterChargeMapper;
import kr.or.ddit.domain.apt.mgmtOffice.bill.vo.MeterChargeVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class MeterChargeServiceImpl implements IMeterChargeService{

    @Autowired
    private IMeterChargeMapper meterChargeMapper;

    // 단가 기준. 필요하면 나중에 DB화 가능
    private static final Long ELECTRIC_UNIT_PRICE = 130L;
    private static final Long WATER_UNIT_PRICE = 900L;
    private static final Long GAS_UNIT_PRICE = 1100L;

    @Override
    public Map<String, Object> selectMeterChargeList(String aptCmplexNo, String billYm) {
        List<MeterChargeVO> list = selectCalculatedMeterChargeList(aptCmplexNo, billYm);

        long electricTotal = 0L;
        long waterTotal = 0L;
        long gasTotal = 0L;
        long grandTotal = 0L;

        long electricUsageTotal = 0L;
        long waterUsageTotal = 0L;
        long gasUsageTotal = 0L;

        for (MeterChargeVO meter : list) {
            Long chargeAmt = meter.getChargeAmt() == null ? 0L : meter.getChargeAmt();
            Long usageVal = meter.getUsageVal() == null ? 0L : meter.getUsageVal();

            if ("ELC".equals(meter.getBillItemCd())) {
                electricTotal += chargeAmt;
                electricUsageTotal += usageVal;
            } else if ("WTR".equals(meter.getBillItemCd())) {
                waterTotal += chargeAmt;
                waterUsageTotal += usageVal;
            } else if ("GAS".equals(meter.getBillItemCd())) {
                gasTotal += chargeAmt;
                gasUsageTotal += usageVal;
            }

            grandTotal += chargeAmt;
        }

        Map<String, Object> result = new HashMap<>();
        result.put("list", list);

        result.put("electricTotal", electricTotal);
        result.put("waterTotal", waterTotal);
        result.put("gasTotal", gasTotal);
        result.put("grandTotal", grandTotal);

        result.put("electricUsageTotal", electricUsageTotal);
        result.put("waterUsageTotal", waterUsageTotal);
        result.put("gasUsageTotal", gasUsageTotal);

        result.put("electricUnitPrice", ELECTRIC_UNIT_PRICE);
        result.put("waterUnitPrice", WATER_UNIT_PRICE);
        result.put("gasUnitPrice", GAS_UNIT_PRICE);

        return result;
    }

    @Override
    public List<MeterChargeVO> selectCalculatedMeterChargeList(String aptCmplexNo, String billYm) {
        /*
         * meterCharge_Mapper.xml에서는 #{searchVO.aptCmplexNo},
         * #{searchVO.billYm} 형태로 조건을 읽는다.
         * 따라서 기존처럼 문자열 2개를 바로 넘기지 않고,
         * PaginationInfoVO.searchVO에 조회조건을 담아서 전달한다.
         */
        MeterChargeVO searchVO = new MeterChargeVO();
        searchVO.setAptCmplexNo(aptCmplexNo);
        searchVO.setBillYm(billYm);

        PaginationInfoVO<MeterChargeVO> pagingVO = new PaginationInfoVO<>();
        pagingVO.setSearchVO(searchVO);

        List<MeterChargeVO> list = meterChargeMapper.selectMeterChargeList(pagingVO);

        calculateChargeAmount(list);

        return list;
    }

    /**
     * 세대별 현재 검침값 저장
     *
     * 처리 순서
     * 1. 화면에서 전달받은 검침년월과 목록 검증
     * 2. DB 조회 결과를 기준으로 저장 대상 세대/항목 확인
     * 3. 서버에서 사용량과 금액 재계산
     * 4. METER_HSTRY 저장
     * 5. 저장 후 화면 재계산용 결과 반환
     */
    @Transactional
    @Override
    public Map<String, Object> saveMeterCharge(String aptCmplexNo, String billYm, List<Map<String, Object>> meterList) {
        // 1. 기본값 검증
        if (aptCmplexNo == null || aptCmplexNo.isBlank()) {
            throw new IllegalArgumentException("아파트 단지 정보가 없습니다.");
        }

        if (billYm == null || !billYm.matches("\\d{6}")) {
            throw new IllegalArgumentException("검침년월 형식이 올바르지 않습니다.");
        }

        if (meterList == null || meterList.isEmpty()) {
            throw new IllegalArgumentException("저장할 검침값이 없습니다.");
        }

        /*
         * 화면에서 받은 preVal, usageVal, chargeAmt는 신뢰하지 않습니다.
         * DB에서 다시 조회한 이전 검침값을 기준으로 실제 저장값을 계산합니다.
         */
        List<MeterChargeVO> dbMeterList =
                selectCalculatedMeterChargeList(aptCmplexNo, billYm);

        int savedCount = 0;

        for (Map<String, Object> requestItem : meterList) {

            String hoNo = stringValue(requestItem.get("hoNo"));
            String billItemCd = stringValue(requestItem.get("billItemCd"));
            Long currVal = longValue(requestItem.get("currVal"));

            if (hoNo == null || hoNo.isBlank()) {
                throw new IllegalArgumentException("세대번호가 없는 검침 데이터가 있습니다.");
            }

            if (!isMeterItemCode(billItemCd)) {
                throw new IllegalArgumentException("저장할 수 없는 검침 항목입니다.");
            }

            if (currVal == null) {
                throw new IllegalArgumentException("현재 검침값을 입력해 주세요.");
            }

            /*
             * 해당 단지의 DB 조회 결과 안에서 세대와 검침 항목을 찾습니다.
             */
            MeterChargeVO dbMeter = findMeterRow(dbMeterList, hoNo, billItemCd);

            if (dbMeter == null) {
                throw new IllegalArgumentException(
                        "저장 대상 세대 또는 검침 항목을 확인할 수 없습니다. 호번호: "
                                + hoNo + ", 항목: " + billItemCd
                );
            }

            /*
             * 단지별로 등록된 실제 FACILITY_NO를 사용해야 합니다.
             */
            if (dbMeter.getFacilityNo() == null || dbMeter.getFacilityNo().isBlank()) {
                throw new IllegalArgumentException(
                        "해당 단지의 검침 시설번호가 등록되어 있지 않습니다. 호번호: "
                                + hoNo + ", 항목: " + billItemCd
                );
            }

            Long preVal = dbMeter.getPreVal() == null ? 0L : dbMeter.getPreVal();

            if (currVal < preVal) {
                throw new IllegalArgumentException(
                        "현재 검침값은 이전 검침값보다 작을 수 없습니다. 호번호: "
                                + hoNo + ", 항목: " + billItemCd
                );
            }

            // 서버에서 사용량과 금액 재계산
            long usageVal = currVal - preVal;
            long unitPrice = getUnitPrice(billItemCd);
            long chargeAmt = usageVal * unitPrice;

            dbMeter.setCurrVal(currVal);
            dbMeter.setUsageVal(usageVal);
            dbMeter.setUnitPrice(unitPrice);
            dbMeter.setChargeAmt(chargeAmt);

            /*
             * dbMeter.getFacilityNo()에는
             * 조회 쿼리에서 가져온 해당 단지의 실제 시설번호가 들어 있어야 합니다.
             */
            dbMeter.setMeterRsltCd("NORMAL");

            meterChargeMapper.mergeMeterHistory(
                    aptCmplexNo,
                    billYm,
                    dbMeter
            );

            savedCount++;
        }

        // 3. 저장 후 최신 목록과 합계를 다시 계산해서 반환합니다.
        Map<String, Object> result = selectMeterChargeList(aptCmplexNo, billYm);
        result.put("savedCount", savedCount);

        return result;
    }

    @Override
    public Map<String, Object> selectMeterChargePagingList(String aptCmplexNo, String billYm, String billItemCd, String keyword, int currentPage) {
        /*
         * 1. 페이징 객체 생성
         *    - 한 페이지 10건
         *    - 페이지 번호 5개 단위 표시
         */
        PaginationInfoVO<MeterChargeVO> pagingVO =
                new PaginationInfoVO<>(20, 10);

        /*
         * 2. 검색조건 생성
         *    XML에서는 #{searchVO.aptCmplexNo}, #{searchVO.billYm} 형태로 사용
         */
        MeterChargeVO searchVO = new MeterChargeVO();
        searchVO.setAptCmplexNo(aptCmplexNo);
        searchVO.setBillYm(billYm);
        searchVO.setBillItemCd(billItemCd);
        searchVO.setKeyword(keyword);

        pagingVO.setSearchVO(searchVO);

        /*
         * 3. 전체 건수 조회 후 페이징 정보 계산
         */
        int totalRecord =
                meterChargeMapper.selectMeterChargeCount(pagingVO);

        pagingVO.setTotalRecord(totalRecord);

        /*
         * 잘못된 페이지 번호 방어 처리
         */
        int validPage = currentPage < 1 ? 1 : currentPage;

        if (pagingVO.getTotalPage() > 0
                && validPage > pagingVO.getTotalPage()) {
            validPage = pagingVO.getTotalPage();
        }

        pagingVO.setCurrentPage(validPage);

        /*
         * 4. 현재 페이지 목록 조회
         */
        List<MeterChargeVO> list =
                meterChargeMapper.selectMeterChargePagingList(pagingVO);

        /*
         * XML에서는 사용량까지만 계산하고,
         * 단가와 금액은 기존 Service 기준으로 계산
         */
        calculateChargeAmount(list);

        pagingVO.setDataList(list);

        /*
         * 5. 상단 요약 카드 조회
         *    현재 페이지 10건이 아니라 전체 검색 결과 기준 합계
         */
        List<MeterChargeVO> summaryList =
                meterChargeMapper.selectMeterChargeSummary(pagingVO);

        Map<String, Object> result =
                makeSummaryResultFromSummaryRows(summaryList);

        /*
         * 6. JSP로 반환할 데이터
         */
        result.put("list", list);
        result.put("pagingVO", pagingVO);
        result.put("pagingHTML", pagingVO.getPagingHTML());

        return result;
    }

    private Map<String, Object> makeSummaryResultFromSummaryRows(List<MeterChargeVO> summaryList) {
        long electricTotal = 0L;
        long waterTotal = 0L;
        long gasTotal = 0L;

        long electricUsageTotal = 0L;
        long waterUsageTotal = 0L;
        long gasUsageTotal = 0L;

        long enteredCount = 0L;
        long totalCount = 0L;

        for (MeterChargeVO summary : summaryList) {

            long usageVal =
                    summary.getUsageVal() == null ? 0L : summary.getUsageVal();

            long unitPrice =
                    getUnitPrice(summary.getBillItemCd());

            long chargeAmt =
                    usageVal * unitPrice;

            if ("ELC".equals(summary.getBillItemCd())) {

                electricUsageTotal = usageVal;
                electricTotal = chargeAmt;

            } else if ("WTR".equals(summary.getBillItemCd())) {

                waterUsageTotal = usageVal;
                waterTotal = chargeAmt;

            } else if ("GAS".equals(summary.getBillItemCd())) {

                gasUsageTotal = usageVal;
                gasTotal = chargeAmt;
            }

            enteredCount += summary.getEnteredCount() == null
                    ? 0
                    : summary.getEnteredCount();

            totalCount += summary.getRowCount() == null
                    ? 0
                    : summary.getRowCount();
        }

        Map<String, Object> result = new HashMap<>();

        result.put("electricTotal", electricTotal);
        result.put("waterTotal", waterTotal);
        result.put("gasTotal", gasTotal);
        result.put("grandTotal", electricTotal + waterTotal + gasTotal);

        result.put("electricUsageTotal", electricUsageTotal);
        result.put("waterUsageTotal", waterUsageTotal);
        result.put("gasUsageTotal", gasUsageTotal);

        result.put("electricUnitPrice", ELECTRIC_UNIT_PRICE);
        result.put("waterUnitPrice", WATER_UNIT_PRICE);
        result.put("gasUnitPrice", GAS_UNIT_PRICE);

        result.put("enteredCount", enteredCount);
        result.put("totalCount", totalCount);

        return result;
    }

    /**
     * 조회된 검침 목록의 단가와 계산금액을 설정합니다.
     *
     * 사용량 = 현재검침값 - 이전검침값
     * 계산금액 = 사용량 * 항목별 단가
     */
    private void calculateChargeAmount(List<MeterChargeVO> list) {

        for (MeterChargeVO meter : list) {

            long usageVal =
                    meter.getUsageVal() == null ? 0L : meter.getUsageVal();

            long unitPrice =
                    getUnitPrice(meter.getBillItemCd());

            long chargeAmt =
                    usageVal * unitPrice;

            meter.setUnitPrice(unitPrice);
            meter.setChargeAmt(chargeAmt);
        }
    }

    private long getUnitPrice(String billItemCd) {
        if ("ELC".equals(billItemCd)) {
            return ELECTRIC_UNIT_PRICE;
        }

        if ("WTR".equals(billItemCd)) {
            return WATER_UNIT_PRICE;
        }

        if ("GAS".equals(billItemCd)) {
            return GAS_UNIT_PRICE;
        }

        return 0L;
    }

    /**
     * 요청 JSON의 문자열 값을 안전하게 꺼냅니다.
     */
    private String stringValue(Object value) {
        if (value == null) {
            return null;
        }

        return String.valueOf(value);
    }

    /**
     * 요청 JSON의 숫자 값을 Long으로 변환합니다.
     * JSON 숫자는 Integer 또는 Long 등으로 들어올 수 있으므로 Number 기준으로 처리합니다.
     */
    private Long longValue(Object value) {
        if (value == null || "".equals(String.valueOf(value).trim())) {
            return null;
        }

        if (value instanceof Number) {
            return ((Number) value).longValue();
        }

        return Long.parseLong(String.valueOf(value));
    }

    /**
     * 저장 가능한 검침 항목인지 검사합니다.
     */
    private boolean isMeterItemCode(String billItemCd) {
        return "ELC".equals(billItemCd)
                || "WTR".equals(billItemCd)
                || "GAS".equals(billItemCd);
    }

    /**
     * DB 조회 목록에서 저장 대상 세대와 검침 항목을 찾습니다.
     */
    private MeterChargeVO findMeterRow(
            List<MeterChargeVO> meterList,
            String hoNo,
            String billItemCd
    ) {
        for (MeterChargeVO meter : meterList) {
            if (hoNo.equals(meter.getHoNo())
                    && billItemCd.equals(meter.getBillItemCd())) {
                return meter;
            }
        }

        return null;
    }

}
