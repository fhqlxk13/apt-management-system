package kr.or.ddit.domain.apt.mgmtOffice.facility.publicFacility.mapper;

import kr.or.ddit.domain.apt.mgmtOffice.facility.publicFacility.dto.PublicFacilityFormDTO;
import kr.or.ddit.domain.apt.mgmtOffice.facility.publicFacility.vo.PublicFacilityVO;
import kr.or.ddit.domain.apt.mgmtOffice.facility.vo.FacilityVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

/**
 * 공용시설 Mapper 인터페이스
 * - FACILITY / PUBLIC_FACILITY 조회 및 저장 SQL 연결
 * - ATTACH_FILE 직접 처리는 기존 IAttachFileMapper에 위임
 * - SQL 본문은 publicFacility_Mapper.xml에 작성
 */
@Mapper
public interface IPublicFacilityMapper {

    /**
     * 관리사무소번호로 아파트단지번호 조회
     * - FACILITY, PUBLIC_FACILITY 등록 시 APT_CMPLEX_NO 세팅용
     *
     * @param mgmtOfcNo 관리사무소번호
     * @return 아파트단지번호
     */
    String selectAptCmplexNoByMgmtOfcNo(@Param("mgmtOfcNo") String mgmtOfcNo);

    /**
     * 신규 시설번호 생성
     * - NEW 등록 모드에서 FACILITY insert 전 사용
     *
     * @return 신규 시설번호
     */
    String selectNextFacilityNo();

    /**
     * 신규 공용시설번호 생성
     * - PUBLIC_FACILITY insert 전 사용
     *
     * @return 신규 공용시설번호
     */
    String selectNextCmnFacilityNo();

    /**
     * 운영관리 미등록 시설자산 후보 목록 조회
     * - FACILITY에는 있고 PUBLIC_FACILITY에는 없는 편의시설 조회
     *
     * @param mgmtOfcNo 관리사무소번호
     * @return 후보 시설 목록
     */
    List<FacilityVO> selectFacilityCandidateList(@Param("mgmtOfcNo") String mgmtOfcNo);

    /**
     * 공용시설 목록 조회
     * - FACILITY 기준 목록 조회
     * - PUBLIC_FACILITY는 운영관리 등록 여부 확인용으로 LEFT JOIN 처리
     *
     * @param paramMap 검색 조건 Map
     * @return 공용시설 목록
     */
    List<PublicFacilityVO> selectPublicFacilityList(Map<String, Object> paramMap);

    /**
     * 공용시설 상세 조회
     * - PUBLIC_FACILITY + FACILITY 조인 단건 조회
     *
     * @param paramMap 조회 조건 Map
     * @return 공용시설 상세 정보
     */
    PublicFacilityVO selectPublicFacilityDetail(Map<String, Object> paramMap);

    /**
     * FACILITY 신규 등록
     * - 공용시설 등록 화면의 NEW 모드에서 사용
     *
     * @param paramMap FACILITY 등록 파라미터
     * @return 처리 건수
     */
    int insertFacility(Map<String, Object> paramMap);

    /**
     * 선택된 시설이 이미 PUBLIC_FACILITY에 등록되어 있는지 확인
     * - 중복 운영관리 등록 방지용
     *
     * @param facilityNo 시설번호
     * @return 등록 건수
     */
    int selectPublicFacilityExistsByFacilityNo(@Param("facilityNo") String facilityNo);

    /**
     * PUBLIC_FACILITY 신규 등록
     * - EXISTING / NEW 모드 공통 처리
     *
     * @param paramMap PUBLIC_FACILITY 등록 파라미터
     * @return 처리 건수
     */
    int insertPublicFacility(Map<String, Object> paramMap);



    /**
     * PUBLIC_FACILITY 운영정보 수정
     * - 공용시설 수정 화면 저장 처리
     *
     * @param formDTO 수정 요청 DTO
     * @return 처리 건수
     */
    int updatePublicFacility(PublicFacilityFormDTO formDTO);

    /**
     * PUBLIC_FACILITY 삭제
     * - 운영관리 연결 데이터 삭제 기준
     *
     * @param paramMap 삭제 조건 Map
     * @return 처리 건수
     */
    int deletePublicFacility(Map<String, Object> paramMap);

    /**
     * 시설 사진 저장용 FACILITY 단건 조회
     * - Google Drive 폴더 경로와 FILE_GROUP_NO 확인에 사용
     *
     * @param facilityNo 시설번호
     * @return 시설 정보
     */
    FacilityVO selectFacilityForFile(@Param("facilityNo") String facilityNo);

    /**
     * 시설 파일그룹번호 조회
     * - 사진 저장/삭제 시 기존 FILE_GROUP_NO 확인용
     *
     * @param facilityNo 시설번호
     * @return 파일그룹번호
     */
    Long selectFacilityFileGroupNo(@Param("facilityNo") String facilityNo);

    /**
     * 시설 파일그룹번호 수정
     * - FILE_GROUP_NO가 없는 기존 시설에 최초 1회 연결
     *
     * @param facilityNo 시설번호
     * @param fileGroupNo 파일그룹번호
     * @return 처리 건수
     */
    int updateFacilityFileGroupNo(@Param("facilityNo") String facilityNo,
                                  @Param("fileGroupNo") Long fileGroupNo);

    /**
     * 공용시설 동 옵션 조회
     *
     * @param mgmtOfcNo 관리사무소 번호
     * @return 동 옵션 목록
     */
    List<PublicFacilityVO> selectPublicFacilityDongOptionList(String mgmtOfcNo);

    /**
     * 공용시설 위치 옵션 조회
     *
     * @param paramMap 검색 조건
     * @return 위치 옵션 목록
     */
    List<String> selectPublicFacilityLocationOptionList(Map<String, Object> paramMap);

    /**
     * 공용시설명 자동완성 조회
     *
     * @param paramMap 검색 조건
     * @return 공용시설명 후보 목록
     */
    List<String> selectPublicFacilityNameSuggestList(Map<String, Object> paramMap);
}
