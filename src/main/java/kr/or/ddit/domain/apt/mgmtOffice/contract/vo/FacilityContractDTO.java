package kr.or.ddit.domain.apt.mgmtOffice.contract.vo;

import lombok.Data;
import lombok.EqualsAndHashCode;

import java.util.List;
import java.util.Map;

/**
 * 계약 화면용 DTO
 *
 * 주의
 * - vo 패키지 안에 둔다.
 * - FacilityContractVO를 상속해서 테이블 컬럼을 명시적으로 유지한다.
 * - 화면 표시/조인/폼 전송용 필드만 추가한다.
 */
@Data
@EqualsAndHashCode(callSuper = true)
public class FacilityContractDTO extends FacilityContractVO {

    /** 현재 화면 관리사무소 번호 */
    private String mgmtOfcNo;

    /** 관리사무소 기준 단지번호 */
    private String aptCmplexNo;

    /** 협력업체 표시용 */
    private String partnerNm;
    private String bizTyNm;
    private String picNm;
    private String picTelno;

    /** 계약유형/대상구분 표시용 */
    private String contTyNm;
    private String contTargetNm;

    /** 대상 시설 요약 표시용 */
    private Integer targetCount;
    private String targetSummary;

    /** 첨부파일 개수 표시용 */
    private Integer fileCount;

    /** 등록/수정 폼에서 선택한 대상 시설번호 목록 */
    private List<String> targetFacilityNoList;

    /** 상세/수정 화면 대상 시설 목록 */
    private List<FacilityContractTargetVO> targetFacilityList;

    /** 검침 설정 UTILITY_PROVIDER : 기존 단건 화면 호환용 */
    private String utilityProviderNo;
    private String csvIdntfKey;
    private String extCustNo;
    private String utilityRmrkCn;

    /** 검침 설정용 검침종류 : 기존 단건 화면 호환용 */
    private String meterTyCd;

    /** 검침 계약 세부 범위 : NORMAL_FACILITY / EQUIPMENT / COMPLEX */
    private String meterScope;

    /** 검침 계약 등록/수정 화면에서 선택한 검침종류 목록 */
    private List<String> meterTyCdList;

    /** 검침 설정용 검침종류명 */
    private String meterTyNm;

    /** 계약 상세/수정 화면 검침 설정 목록 */
    private List<FacilityContractDTO> utilityProviderList;

    /** 첨부파일 목록. ATTACH_FILE 조회 결과 Map 목록 */
    private List<Map<String, Object>> fileList;

    private String bidTyNm;
    private String contSttsNm;
}
