package kr.or.ddit.domain.apt.mgmtOffice.facility.publicFacility.service;

import kr.or.ddit.domain.apt.mgmtOffice.facility.publicFacility.vo.PublicItemVO;

import java.util.List;
import java.util.Map;

/**
 * 공용시설 아이템 Service 인터페이스
 * - PUBLIC_ITEM 테이블 기준 공용시설 하위 자원 CRUD 기능 정의
 * - 사진 첨부는 PUBLIC_ITEM 테이블에 FILE_GROUP_NO가 없으므로 제외
 */
public interface IPublicItemService {

    /**
     * 공용아이템 목록 조회
     * - 특정 공용시설 번호에 연결된 하위 자원 목록 조회
     *
     * @param cmnFacilityNo 공용시설 번호
     * @return 공용아이템 목록
     */
    List<PublicItemVO> selectPublicItemList(String cmnFacilityNo);

    /**
     * 공용아이템 상세 조회
     * - 공용시설 아이템 번호 기준 단건 조회
     *
     * @param cmnFacilityItemNo 공용시설 아이템 번호
     * @return 공용아이템 상세 정보
     */
    PublicItemVO selectPublicItemDetail(String cmnFacilityItemNo);

    /**
     * 공용아이템 등록
     * - 공용시설 하위 자원 신규 등록
     *
     * @param publicItemVO 등록할 공용아이템 정보
     * @return 등록 처리 건수
     */
    int insertPublicItem(PublicItemVO publicItemVO);

    /**
     * 공용아이템 수정
     * - 공용시설 하위 자원명, 상태, 비고 수정
     *
     * @param publicItemVO 수정할 공용아이템 정보
     * @return 수정 처리 건수
     */
    int updatePublicItem(PublicItemVO publicItemVO);

    int deletePublicItem(String cmnFacilityItemNo);

    List<PublicItemVO> selectPublicItemListAll(String mgmtOfcNo);

    /** 자원 목록 페이징 검색 조회 */
    List<PublicItemVO> selectPublicItemListPaging(Map<String, Object> paramMap);

    /** 자원 목록 전체 건수 조회 */
    int selectPublicItemListCount(Map<String, Object> paramMap);

    /** 자동완성 후보 조회 */
    List<PublicItemVO> selectPublicItemSuggest(Map<String, Object> paramMap);



}