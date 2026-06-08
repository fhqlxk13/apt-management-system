package kr.or.ddit.domain.member.resident.dto;

import kr.or.ddit.domain.central.dto.FacilityInfoDTO;
import lombok.Data;

import java.util.List;

/**
 * 입주민 시설관리이력 DTO
 *
 * DTO란?
 * → DB 조회 결과와 검색조건을 담아서
 *   Controller, Service, Mapper, JSP 사이에서 전달하는 객체.
 */
@Data
public class ResidentFacilityHistoryDTO {

    /* =========================================
       단지 정보
       ========================================= */

    private String aptCmplexNo;        // 단지번호
    private String aptCmplexNm;        // 단지명


    /* =========================================
       시설 정보
       ========================================= */

    private String facilityNo;         // 시설번호
    private String facilityNm;         // 시설명
    private String facilityTyCd;       // 시설유형코드
    private String facilityTyNm;       // 시설유형명


    /* =========================================
       시설 점검 이력
       ========================================= */

    private String facChkHstryNo;      // 시설점검이력번호
    private String chkDt;              // 점검일
    private String chkSttsCd;          // 점검상태코드
    private String chkSttsNm;          // 점검상태명
    private String chkCn;              // 점검내용
    private String chkTyCd;            // 점검유형코드
    private String chkTyNm;            // 점검유형명


    /* =========================================
       협력업체 / 담당자
       ========================================= */

    private String partnerNm;          // 협력업체명
    private String picNm;              // 담당자명


    /* =========================================
       검색 / 정렬 / 페이징 조건
       ========================================= */

    private String keyword;     // 점검일, 시설명, 점검내용, 상태, 담당자 통합 검색어
    private String sortColumn;  // 정렬 컬럼
    private String sortOrder;   // ASC / DESC 정렬 방향

    private int startRow;              // 페이징 시작 행
    private int endRow;                // 페이징 끝 행

    private String historyChkStartDt; // 점검 시작일
    private String historyChkEndDt;   // 점검 종료일
    private String historyFacilityNm;  // 시설명 검색어
    private String historyChkCn;       // 점검내용 검색어
    private String historyChkStts;     // 상태 검색어
    private String historyPicNm;       // 담당자 검색어


    /* =========================================
       화면 공통 정보
       ========================================= */

    private FacilityInfoDTO aptComplexInfo;              // 단지 기본정보
    private String mgmtOfficeInfo;                       // 관리사무소 정보
    private List<FacilityInfoDTO> annBoardPostInfoList;  // 공고 목록


}