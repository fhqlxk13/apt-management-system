package kr.or.ddit.domain.apt.mgmtOffice.facility.mapper;

import kr.or.ddit.common.file.vo.AttachFileVO;
import kr.or.ddit.domain.apt.mgmtOffice.facility.check.vo.FacilityCheckHstryVO;
import kr.or.ddit.domain.apt.mgmtOffice.facility.dto.FacilityDTO;
import kr.or.ddit.domain.apt.mgmtOffice.facility.vo.FacilityVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

/**
 * 시설 Mapper 인터페이스
 * FACILITY 테이블 기준 CRUD 및 시설 화면 조회
 */
@Mapper
public interface IFacilityMapper {

    /**
     * 시설 목록 조회
     *
     * paramMap 검색 조건 키
     * - mgmtOfcNo    : 관리사무소 번호
     * - keyword      : 시설명·위치 통합 검색어
     * - facilityTyCd : 시설유형코드
     * - useYn        : 사용여부
     * - dongNo       : 동번호 (_COMMON_ 이면 편의 위치 시설만)
     */
    List<FacilityVO> selectFacilityList(Map<String, Object> paramMap);

    /**
     * 시설 화면 목록 조회
     *
     * 조회 기준
     * - FACILITY 기준 전체 시설 조회
     * - PUBLIC_FACILITY 연결 여부로 일반시설/편의시설 구분
     *
     * paramMap 검색 조건 키
     * - mgmtOfcNo     : 관리사무소 번호
     * - facilityKind  : 시설종류, ALL/FACILITY/PUBLIC
     * - keyword       : 시설명·상세위치 검색어
     * - facilityTyCd  : 시설유형코드
     * - useYn         : 사용여부
     * - dongNo        : 동번호
     *
     * 반환값
     * - FacilityDTO 목록
     * - 시설 목록/상세 화면 표시용
     */
    List<FacilityDTO> selectFacilityViewList(Map<String, Object> paramMap);

    int selectFacilityViewCount(Map<String, Object> paramMap);

    /**
     * 시설 화면 상세 조회
     *
     * 조회 기준
     * - FACILITY.FACILITY_NO 기준 단건 조회
     * - PUBLIC_FACILITY 연결 시 편의시설 전용 정보 함께 조회
     *
     * 사용 위치
     * - 일반시설 기본 상세 조회
     * - 편의시설 기본 정보 조회
     * - 유지보수/점검/협력업체 정보는 추후 별도 조회로 확장
     */
    FacilityDTO selectFacilityViewDetail(
            @Param("mgmtOfcNo") String mgmtOfcNo,    // 관리사무소 번호
            @Param("facilityNo") String facilityNo   // 시설번호
    );

    /**
     * 시설 설치계약 요약 조회
     *
     * 사용 위치
     * - 시설 상세 화면
     * - 시설 수정 화면
     *
     * 조회 기준
     * - FACILITY_CONTRACT 기준
     * - 설치/공사 계약 유형만 조회
     * - 시설번호와 관리사무소 번호로 접근 범위 제한
     *
     * paramMap 사용 키
     * - mgmtOfcNo  : 관리사무소 번호
     * - facilityNo : 시설번호
     *
     * 반환 키 예시
     * - CONTRACT_NO       : 계약번호
     * - CONTRACT_NM       : 계약명
     * - PARTNER_NM        : 업체명
     * - CONTRACT_START_DT : 계약시작일
     * - CONTRACT_END_DT   : 계약종료일
     * - CONTRACT_STTS_CD  : 계약상태코드
     * - CONTRACT_STTS_NM  : 계약상태명
     */
    Map<String, Object> selectFacilityInstallContract(Map<String, Object> paramMap);


    /**
     * 시설 상세 조회
     * 관리사무소 기준 단지번호로 접근 권한 확인
     */
    FacilityVO selectFacilityDetail(
            @Param("mgmtOfcNo") String mgmtOfcNo,   // 관리사무소 번호
            @Param("facilityNo") String facilityNo  // 시설번호
    );

    /**
     * 시설유형 필터 목록 조회
     * - FACILITY_TY 공통코드 기준
     * - 편의시설 탭은 실제 PUBLIC_FACILITY 연결 유형만 조회
     */
    List<Map<String, Object>> selectFacilityTypeList(
            Map<String, Object> paramMap
    );

    /**
     * 등록 화면 편의시설 유형 목록 조회
     * - FACILITY_TY 공통코드에서 일반시설 코드를 제외한 목록
     */
    List<Map<String, Object>> selectPublicFacilityTypeList();

    /**
     * 시설번호 생성
     * 시퀀스 기반 FAC0001 형태
     */
    String getFacilityNo();

    /**
     * 관리사무소 기준 단지번호 조회
     * 등록 시 화면 위변조 방지용 서버 기준값
     */
    String selectAptCmplexNoByMgmtOfcNo(String mgmtOfcNo); // 관리사무소 번호

    /**
     * 시설 등록
     */
    int insertFacility(FacilityVO facilityVO);

    /**
     * 새 시설유형 코드 생성
     *
     * 처리 기준
     * - COMMON_CODE의 FACILITY_TY 그룹에 추가할 신규 코드값 생성
     * - 실제 생성 규칙은 facility_Mapper.xml에서 처리
     * - 예: CUS001, CUS002 ...
     */
    String getNewFacilityTypeCode();

    /**
     * 시설유형명 중복 건수 조회
     *
     * 사용 위치
     * - 시설 등록 화면에서 새 시설유형 추가 시
     * - 같은 이름의 시설유형이 이미 있으면 COMMON_CODE 중복 등록 방지
     */
    int selectFacilityTypeNameCount(String codeName);

    /**
     * 새 시설유형 공통코드 등록
     *
     * paramMap 사용 키
     * - codeNoCd    : 새 시설유형 코드
     * - codeName    : 새 시설유형명
     * - codeContent : 새 시설유형 설명
     */
    int insertFacilityTypeCode(Map<String, Object> paramMap);

    /**
     * 시설 기본정보 수정
     *
     * 수정 가능 항목: 시설명 · 설치일자 · 상세위치 · 사용여부 · 첨부파일그룹번호
     * 수정 제외 항목: 시설유형 · 단지번호 · 동번호
     */
    int updateFacility(FacilityVO facilityVO);

    //int updateFacilityFileGroupNo(FacilityVO facilityVO);

    /**
     * 시설유형 정정
     * 일반 수정과 분리된 전용 UPDATE
     * Service에서 연결 데이터 검증 후 호출
     */
    int correctFacilityType(FacilityVO facilityVO);

    /**
     * 시설 사용여부 변경
     * 삭제 대신 USE_YN 변경으로 처리
     * FAULT 판정 시 트리거 자동 N / 복구는 수동 Y
     */
    int updateFacilityUseYn(FacilityVO facilityVO);

    /**
     * 시설 분류 정정 가능 여부 확인용 통합 조회
     *
     * 계약·점검이력·검침기록 연결 건수 합산
     * 0이면 정정 가능 / 1 이상이면 정정 불가
     * 기존 3번 개별 쿼리를 단일 쿼리로 통합
     */
    int selectFacilityLinkedCount(String facilityNo); // 시설번호

    /**
     * 이용불가 시설 통계 조회
     * 현황 카드 표시용
     *
     * 반환 키
     * - DISABLED_TOTAL : 전체 이용불가 시설 수 (USE_YN = 'N')
     * - DISABLED_TODAY : 오늘 FAULT 판정 건수 (FACILITY_CHECK_HSTRY.MDF_DT 기준)
     */
    Map<String, Object> selectDisabledStats(String mgmtOfcNo); // 관리사무소 번호

    /**
     * 시설 첨부파일 단건 조회
     * 삭제 전 Google Drive ID 확인용
     * 복합 PK: FILE_GROUP_NO + FILE_SAVE_UUID
     */
    AttachFileVO selectFacilityFile(
            @Param("fileGroupNo") Long fileGroupNo,     // 파일그룹번호
            @Param("fileSaveUuid") String fileSaveUuid  // 저장 UUID
    );

    /**
     * 시설 첨부파일 목록 조회
     * 상세/수정 화면 기존 사진 출력용
     */
    List<AttachFileVO> selectFacilityFileList(
            @Param("fileGroupNo") Long fileGroupNo  // 파일그룹번호
    );

    /**
     * 시설 첨부파일 삭제
     * Google Drive 휴지통 이동 후 호출
     * 복합 PK: FILE_GROUP_NO + FILE_SAVE_UUID
     */
    int deleteFacilityFile(
            @Param("fileGroupNo") Long fileGroupNo,     // 파일그룹번호
            @Param("fileSaveUuid") String fileSaveUuid  // 저장 UUID
    );

    /**
     * 동 목록 조회
     * APT_UNIT 기준 단지 내 동 목록, DISTINCT 중복 제거
     * 시설 등록 화면 동 선택 드롭다운용
     */
    List<FacilityVO> selectDongList(String mgmtOfcNo); // 관리사무소 번호




    /**
     * 시설 위치 동 목록 조회
     * APT_UNIT 기준 단지 내 동 목록 조회
     */
    List<kr.or.ddit.domain.apt.mgmtOffice.facility.dto.FacilityLocationDTO> selectFacilityUnitList(@Param("aptCmplexNo") String aptCmplexNo);

    /**
     * 시설 위치 층 목록 조회
     * APT_DETAIL 기준 선택 동의 층 목록 조회
     */
    List<kr.or.ddit.domain.apt.mgmtOffice.facility.dto.FacilityLocationDTO> selectFacilityFloorList(@Param("dongNo") String dongNo);

    /**
     * 시설 위치 호 목록 조회
     * APT_DETAIL 기준 선택 동/층의 호 목록 조회
     */
    List<kr.or.ddit.domain.apt.mgmtOffice.facility.dto.FacilityLocationDTO> selectFacilityRoomList(@Param("dongNo") String dongNo,
                                                                                                   @Param("floor") String floor);


    /**
     * 시설 상세 화면 최근 점검·보수 이력 조회
     *
     * 처리 범위
     * - 시설 상세 왼쪽 하단에 표시할 최근 점검·보수 이력 조회
     * - FACILITY_CHECK_HSTRY 기준 최근 3건 조회
     *
     * @param paramMap 조회 조건
     *                 - mgmtOfcNo  : 관리사무소 번호
     *                 - facilityNo : 시설 번호
     * @return 최근 점검·보수 이력 목록
     */
    List<FacilityCheckHstryVO> selectRecentCheckHistoryList(Map<String, Object> paramMap);
}
