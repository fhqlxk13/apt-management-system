package kr.or.ddit.domain.apt.mgmtOffice.facility.publicFacility.dto;

import lombok.Data;

/**
 * 편의시설 등록/수정 Form DTO
 * - publicFacilityRegister.jsp form name 기준 요청값 수신
 * - DB 테이블 1개와 1:1 매칭되는 VO가 아니라 화면 요청 전용 DTO
 * - registerMode 값으로 기존 시설자산 선택 / 새 시설자산 등록 분기
 */
@Data
public class PublicFacilityFormDTO {

    /*
     * ============================================================
     * 화면 제어값
     * ============================================================
     */

    /** 관리사무소번호 */
    private String mgmtOfcNo;

    /** 등록 방식: EXISTING 또는 NEW */
    private String registerMode;

    /** 삭제할 기존 파일 UUID 문자열 */
    private String deleteFileUuids;


    /*
     * ============================================================
     * 기존 시설자산 선택 모드
     * - registerMode = EXISTING일 때 사용
     * - 기존 FACILITY를 PUBLIC_FACILITY 운영관리 대상으로 연결
     * ============================================================
     */

    /** 선택된 기존 시설번호 */
    private String facilityNo;


    /*
     * ============================================================
     * 새 시설자산 등록 모드
     * - registerMode = NEW일 때 사용
     * - FACILITY 먼저 insert 후 PUBLIC_FACILITY insert
     * ============================================================
     */

    /** 시설명 */
    private String facilityNm;

    /** 시설유형코드 */
    private String facilityTyCd;

    /**
     * 위치구분
     * - COMMON: 편의 위치
     * - DONG: 동 기준 위치
     * - DB 컬럼 아님
     * - ServiceImpl에서 dongNo 저장 여부 판단용으로만 사용
     */
    private String locationType;

    /** 동번호 */
    private String dongNo;

    /** 상세위치 */
    private String locCn;

    /** 사용여부 */
    private String useYn;

    /** 설치계약 연결 여부 */
    private String installContractYn;

    /** 설치계약번호 */
    private String installContractNo;


    /*
     * ============================================================
     * PUBLIC_FACILITY 공통 운영정보
     * - EXISTING / NEW 모드 둘 다 사용
     * ============================================================
     */

    /** 편의시설번호 */
    private String cmnFacilityNo;

    /** 편의시설명 */
    private String cmnFacilityNm;

    /** 편의시설 예약 여부 */
    private String cmnFacilityRsvYn;

    /** 편의시설 비용 */
    private Integer cmnFacilityAmt;

    /** 편의시설 운영 시간 */
    private String cmnFacilityOprHr;

    /** 편의시설 내용 / 안내문 */
    private String cmnFacilityCn;
}
