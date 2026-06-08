package kr.or.ddit.domain.apt.mgmtOffice.facility.publicFacility.service;

import kr.or.ddit.domain.apt.mgmtOffice.facility.publicFacility.mapper.IPublicItemMapper;
import kr.or.ddit.domain.apt.mgmtOffice.facility.publicFacility.vo.PublicItemVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * 공용시설 아이템 Service 구현체
 * - PUBLIC_ITEM 테이블 기준 공용시설 하위 자원 CRUD 처리
 * - 사진 첨부는 PUBLIC_ITEM 테이블에 FILE_GROUP_NO가 없으므로 제외
 */
@Service
@RequiredArgsConstructor
public class PublicItemServiceImpl implements IPublicItemService {

    /** 공용시설 아이템 Mapper */
    private final IPublicItemMapper publicItemMapper;

    /**
     * 공용아이템 목록 조회
     * - 공용시설 번호 기준으로 하위 자원 목록 조회
     *
     * @param cmnFacilityNo 공용시설 번호
     * @return 공용아이템 목록
     */
    @Override
    public List<PublicItemVO> selectPublicItemList(String cmnFacilityNo) {
        // 공용시설 번호 기준 아이템 목록 조회
        return publicItemMapper.selectPublicItemList(cmnFacilityNo);
    }

    /**
     * 공용아이템 상세 조회
     * - 공용시설 아이템 번호 기준 단건 조회
     *
     * @param cmnFacilityItemNo 공용시설 아이템 번호
     * @return 공용아이템 상세 정보
     */
    @Override
    public PublicItemVO selectPublicItemDetail(String cmnFacilityItemNo) {
        // 공용시설 아이템 번호 기준 상세 조회
        return publicItemMapper.selectPublicItemDetail(cmnFacilityItemNo);
    }

    /**
     * 공용아이템 등록
     * - 공용시설 하위 자원 신규 등록
     *
     * @param publicItemVO 등록할 공용아이템 정보
     * @return 등록 처리 건수
     */
    @Override
    public int insertPublicItem(PublicItemVO publicItemVO) {
        // 공용아이템 등록 처리
        return publicItemMapper.insertPublicItem(publicItemVO);
    }

    /**
     * 공용아이템 수정
     * - 공용시설 하위 자원명, 상태, 비고 수정
     *
     * @param publicItemVO 수정할 공용아이템 정보
     * @return 수정 처리 건수
     */
    @Override
    public int updatePublicItem(PublicItemVO publicItemVO) {
        // 공용아이템 수정 처리
        return publicItemMapper.updatePublicItem(publicItemVO);
    }

    @Override
    public int deletePublicItem(String cmnFacilityItemNo) {
        return publicItemMapper.deletePublicItem(cmnFacilityItemNo);
    }

    @Override
    public List<PublicItemVO> selectPublicItemListAll(String mgmtOfcNo) {
        return publicItemMapper.selectPublicItemListAll(mgmtOfcNo);
    }

    /** 자원 목록 페이징 검색 조회 */
    @Override
    public List<PublicItemVO> selectPublicItemListPaging(Map<String, Object> paramMap) {
        return publicItemMapper.selectPublicItemListPaging(paramMap);
    }

    /** 자원 목록 전체 건수 조회 */
    @Override
    public int selectPublicItemListCount(Map<String, Object> paramMap) {
        return publicItemMapper.selectPublicItemListCount(paramMap);
    }

    /** 자동완성 후보 조회 */
    @Override
    public List<PublicItemVO> selectPublicItemSuggest(Map<String, Object> paramMap) {
        return publicItemMapper.selectPublicItemSuggest(paramMap);
    }
}
