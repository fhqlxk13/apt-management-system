package kr.or.ddit.domain.apt.mgmtOffice.bill.service;

import kr.or.ddit.domain.apt.mgmtOffice.bill.vo.MeterChargeVO;

import java.util.List;
import java.util.Map;

public interface IMeterChargeService {

    // 검침요금 계산 목록 조회
    Map<String, Object> selectMeterChargeList(String aptCmplexNo, String billYm);

    // 관리비 부과 로직에서 재사용할 원본 계산 목록
    List<MeterChargeVO> selectCalculatedMeterChargeList(String aptCmplexNo, String billYm);

    // 세대 검침 입력 및 저장
    Map<String, Object> saveMeterCharge(String aptCmplexNo, String billYm, List<Map<String, Object>> meterList);

    Map<String, Object> selectMeterChargePagingList(String aptCmplexNo, String billYm, String billItemCd, String keyword, int currentPage);
}
