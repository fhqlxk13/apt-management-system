package kr.or.ddit.domain.central.mapper;

import kr.or.ddit.domain.central.dto.FacilityInfoDTO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface IFacilityInfoMapper {

    /**
     * 단지 시설 정보 조회
     */
    List<FacilityInfoDTO> selectFacilityInfoList(FacilityInfoDTO dto);

    List<FacilityInfoDTO> selectAptCardList(FacilityInfoDTO dto);

    /**
     * 시/도 목록 조회
     */
    List<String> selectSidoList();

    /**
     * 선택한 시/도의 시/군/구 목록 조회
     */
    List<String> selectSigunguList(String sidoNm);

    /* 단지카드 페이징 처리 */
    int selectAptCardTotalCount(FacilityInfoDTO dto);

    /*
     * 시설유형 목록 조회
     * 시설유형코드 목록을 담는다.
     */
    List<String> selectFacilityTypeList();

}
