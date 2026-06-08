package kr.or.ddit.domain.central.dto;

import kr.or.ddit.common.file.vo.AttachFileVO;
import lombok.Data;


import java.util.List;

/**
 * 단지 시설정보 DTO
 *
 * DTO란?
 * → 여러 테이블의 조회 결과를 하나로 묶어서
 *   Controller → JSP 화면으로 전달하는 객체.
 *
 * 왜 사용?
 * → 단지 기본정보 + 시설정보 + 협력업체 + 공용시설 등을
 *   한 화면에서 같이 보여주기 위해 사용.
 */
@Data
public class FacilityInfoDTO {

    /* =========================================
       검색 조건
       ========================================= */

    private String searchType;     // 검색 종류 (단지명, 주소, 시공사 등)
    private String keyword;        // 검색어
    private String aptCmplexNo;    // 단지번호


    /* =========================================
       APT_COMPLEX
       아파트 단지 기본정보
       ========================================= */

    private String aptCmplexNm;    // 단지명
    private String sidoNm;         // 시도명
    private String sigunguNm;      // 시군구명
    private String emdNm;          // 읍면동명
    private String dorojuso;       // 도로명주소

    private String heatTy;         // 난방방식코드

    private String cnscoNm;        // 시공사명

    private String unitRange;      // 세대수 구간
    private Integer unitCnt;       // 세대수
    private Integer dongCnt;       // 동 수
    private Integer pkgCnt;        // 총 주차대수
    private Integer freePkgCnt;    // 무료 주차 가능 대수
    private Integer maxFloor;      // 최고 층수

    private String ccCnt;          // CCTV 수
    private String bldYr;          // 준공년도


    /* =========================================
       FACILITY
       단지 시설정보
       ========================================= */

    private String facilityNo;     // 시설번호
    private String facilityNm;     // 시설명
    private String facilityTyCd;   // 시설유형코드

    private String dongNo;         // 동 번호
    private String locCn;          // 시설 위치 설명
    private String useYn;          // 사용여부


    /* =========================================
       PARTNER
       협력업체 정보
       ========================================= */

    private String partnerNo;      // 협력업체 번호
    private String partnerNm;      // 협력업체명
    private String bizTyNm;        // 업종명


    /* =========================================
       APT_INFRA
       주변 인프라 정보
       ========================================= */

    private String infraNo;        // 인프라 번호
    private String infraNm;        // 인프라명
    private String categoryCd;     // 인프라 카테고리 코드


    /* =========================================
       PUBLIC_FACILITY
       공용시설 정보
       ========================================= */

    private String cmnFacilityNo;      // 공용시설 번호
    private String cmnFacilityNm;      // 공용시설명
    private String cmnFacilityCn;      // 공용시설 설명

    private Integer cmnFacilityAmt;    // 수량
    private String cmnFacilityRsvYn;   // 예약 가능 여부
    private String cmnFacilityOprHr;   // 운영시간


    /* =========================================
       PUBLIC_ITEM
       공용시설 물품 정보
       ========================================= */

    private String cmnFacilityItemNo;  // 공용시설 물품번호
    private String itemNm;             // 물품명
    private String cmnFacilitySttsCd;  // 시설 상태 코드


    /* =========================================
       화면 출력용 문자열 데이터
       =========================================
       LISTAGG 같은 Oracle 함수로
       여러 데이터를 한 줄로 묶어서 출력할 때 사용.
       ========================================= */

    private String partnerList;        // 협력업체 목록 문자열
    private String infraList;          // 주변 인프라 목록 문자열
    private String publicFacilityList; // 공용시설 목록 문자열
    private String publicItemList;     // 공용시설 물품 목록 문자열

    /* 단지카드 페이징 */
    private int startRow;    // 페이징 시작 row
    private int endRow;      // 페이징 끝 row
    private String sortColumn;   // 정렬 컬럼
    private String sortOrder;    // ASC 또는 DESC

    /* 시설정보 페이징 */
    private int facilityStartRow;   // 시설정보 페이징 시작 번호
    private int facilityEndRow;     // 시설정보 페이징 끝 번호
    private int facilityTotalCount; // 시설정보 전체 개수

    /* 주변 인프라 */
    private String educationInfra;      // 교육시설
    private String transitInfo;         // 교통정보 = 교통노선정보 + 교통접근성
    private String welfareInfra;        // 복지시설
    private String convenienceInfra;    // 생활편의시설

    /*
     * 단지 표시용 문자열
     * → apt_headerLayout.jsp 에서
     *   ${aptInfo.aptComplexInfo} 를 사용해서
     */
    private String aptComplexInfo;
    private String mgmtOfficeInfo; // 관리사무소 정보
    private List<?> annBoardPostInfoList;

    private String imgFileNo;
    /*
     * imgFileNo
     * → APT_COMPLEX.IMG_FILE_NO 값.
     * 왜 필요?
     * → 단지별 이미지 파일 그룹 번호를 가져오기 위해.
     */

    private List<AttachFileVO> fileList;
    /*
     * fileList
     * → 실제 파일 정보 목록.
     * 왜 필요?
     * → JSP에서 googleId를 꺼내 이미지로 보여주기 위해.
     */

    private String rprsntImgFileNo; // 대표 이미지 파일번호

}