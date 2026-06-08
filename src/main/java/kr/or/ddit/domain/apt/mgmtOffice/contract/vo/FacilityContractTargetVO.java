package kr.or.ddit.domain.apt.mgmtOffice.contract.vo;

import lombok.Data;

import java.util.Date;

/**
 * FACILITY_CONTRACT_TARGET 테이블 기준 VO
 *
 * DB 기준 컬럼
 * - CONT_NO
 * - FACILITY_NO
 * - REG_DT
 *
 * 추가 표시 필드
 * - facilityNm
 * - facilityTyCd
 * - facilityTyNm
 * - locCn
 */
@Data
public class FacilityContractTargetVO {

    private String contNo;
    private String facilityNo;
    private Date regDt;

    private String facilityNm;
    private String facilityTyCd;
    private String facilityTyNm;
    private String locCn;
}
