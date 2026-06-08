package kr.or.ddit.domain.apt.mgmtOffice.facility.publicFacility.service;

import kr.or.ddit.domain.apt.mgmtOffice.facility.publicFacility.dto.PublicFacilityFormDTO;
import kr.or.ddit.domain.apt.mgmtOffice.facility.publicFacility.vo.PublicFacilityVO;
import kr.or.ddit.domain.apt.mgmtOffice.facility.vo.FacilityVO;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.Map;

/**
 * 공용시설 Service 인터페이스
 * - FACILITY + PUBLIC_FACILITY 기준 공용시설 관리 기능 정의
 * - 첨부파일 저장/삭제는 ServiceImpl에서 기존 IAttachFileMapper를 사용해 처리
 */
public interface IPublicFacilityService {

    /**
     * 운영관리 미등록 시설자산 후보 목록 조회
     * - FACILITY에는 존재하지만 PUBLIC_FACILITY에는 아직 연결되지 않은 편의시설 조회
     * - 공용시설 등록 화면의 시설자산 선택 모달에서 사용
     *
     * @param mgmtOfcNo 관리사무소번호
     * @return 운영관리 미등록 시설자산 목록
     */
    List<FacilityVO> selectFacilityCandidateList(String mgmtOfcNo);

    /**
     * 공용시설 목록 조회
     * - 목록 기준은 FACILITY
     * - PUBLIC_FACILITY는 운영관리 등록 여부 확인용으로 LEFT JOIN 처리
     *
     * @param paramMap 검색 조건 Map
     * @return 공용시설 목록
     */
    List<PublicFacilityVO> selectPublicFacilityList(Map<String, Object> paramMap);

    /**
     * 공용시설 상세 조회
     * - PUBLIC_FACILITY + FACILITY 조인 상세 정보 조회
     * - 상세/수정 화면에서 사용
     *
     * @param paramMap 조회 조건 Map
     * @return 공용시설 상세 정보
     */
    PublicFacilityVO selectPublicFacilityDetail(Map<String, Object> paramMap);

    /**
     * 공용시설 등록 처리
     * - registerMode=EXISTING: 기존 FACILITY에 PUBLIC_FACILITY 연결
     * - registerMode=NEW: FACILITY 신규 등록 후 PUBLIC_FACILITY 연결
     * - 사진은 연결된 FACILITY.FILE_GROUP_NO 기준으로 저장
     *
     * @param formDTO 등록 화면 요청 DTO
     * @param facilityFiles 시설 사진 파일 목록
     * @return 생성된 공용시설번호
     */
    String insertPublicFacility(
            PublicFacilityFormDTO formDTO,
            List<MultipartFile> facilityFiles,
            String userNo
    );

    /**
     * 공용시설 수정 처리
     * - PUBLIC_FACILITY 운영정보 수정
     * - 사진 추가/삭제는 연결된 FACILITY.FILE_GROUP_NO 기준으로 처리
     *
     * @param formDTO 수정 화면 요청 DTO
     * @param facilityFiles 추가 시설 사진 파일 목록
     */
    void updatePublicFacility(
            PublicFacilityFormDTO formDTO,
            List<MultipartFile> facilityFiles,
            String userNo
    );

    /**
     * 공용시설 삭제 처리
     * - 1차 구현은 PUBLIC_FACILITY 연결 데이터 삭제 기준
     * - 시설자산 FACILITY와 첨부파일은 삭제하지 않음
     *
     * @param paramMap 삭제 조건 Map
     */
    void deletePublicFacility(Map<String, Object> paramMap);

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
