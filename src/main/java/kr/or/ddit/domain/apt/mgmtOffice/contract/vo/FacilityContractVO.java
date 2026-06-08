package kr.or.ddit.domain.apt.mgmtOffice.contract.vo;

import lombok.Data;
import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;

/**
 * FACILITY_CONTRACT 테이블 기준 VO
 *
 * DB 기준 컬럼
 * - CONT_NO
 * - FACILITY_NO
 * - PARTNER_NO
 * - CONT_NM
 * - BID_TY_CD
 * - CONT_DT
 * - CONT_STTS_CD
 * - CONT_AMT
 * - PYMT_DT
 * - CONT_BGNG_DT
 * - CONT_END_DT
 * - CONT_TY_CD
 * - CONT_TARGET_CD
 * - CONT_CN
 * - RMRK_CN
 * - REG_DT
 * - MDF_DT
 * - FILE_GROUP_NO : 사용자가 FACILITY_CONTRACT에 추가한 계약서 파일그룹번호
 */
@Data
public class FacilityContractVO {

    private String contNo;
    private String facilityNo;
    private String partnerNo;
    private String contNm;
    private String bidTyCd;

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date contDt;

    private String contSttsCd;
    private Long contAmt;

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date pymtDt;

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date contBgngDt;

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date contEndDt;

    private String contTyCd;
    private String contTargetCd;
    private String contCn;
    private String rmrkCn;

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date regDt;

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date mdfDt;

    private Long fileGroupNo;
}
