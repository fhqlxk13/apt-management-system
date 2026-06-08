package kr.or.ddit.domain.central.vo;

import lombok.Data;

import java.util.Date;

@Data
public class FacilityHistoryVO {

    // 🔹 기본 테이블 (FACILITY_CHECK_HSTRY)
    private String facChkHstryNo; // 점검이력번호 (PK)
    private String facilityNo;    // 시설번호
    private String partnerNo;     // 업체번호

    private Date  chkDt;           // 점검일자
    private String chkCn;         // 점검내용
    private String chkSttsCd;     // 상태코드 (완료, 보완필요, 처리중)
    private String chkTyCd;       // 점검유형 (유지보수, 하자보수)

    private String rmk;           // 비고
    private Date regDt;           // 등록일
    private Date mdfDt;           // 수정일

    // 🔥 화면 출력용 (JOIN으로 채움)
    private String facilityName;  // 시설명
    private String managerName;   // 담당자명
}
