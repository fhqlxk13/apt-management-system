package kr.or.ddit.domain.apt.mgmtOffice.meter.vo;

import lombok.Data;

import java.util.Date;

/**
 * 검침 CSV 업로드 이력 VO
 * - METER_UPLOAD_HSTRY 테이블 기준 등록/조회용 VO
 * - ATTACH_FILE과는 FILE_GROUP_NO로 논리 연결함
 */
@Data
public class MeterUploadHstryVO {

    /** 검침 업로드 이력번호 */
    private String meterUploadHstryNo;

    /** 공급/검침 설정번호 */
    private String utilityProviderNo;

    /** 아파트단지번호 */
    private String aptCmplexNo;

    /** 첨부파일 그룹번호 */
    private Long fileGroupNo;

    /** 업로드일자 */
    private Date uploadDt;

    /** 업로드 사용자번호 */
    private String uploadUserNo;

    /** CSV 전체 행 수 */
    private Integer totalCnt;

    /** 업로드 상태코드 */
    private String uploadSttsCd;

    /** 오류 내용 */
    private String errCn;

    /** 비고 */
    private String rmrkCn;
}
