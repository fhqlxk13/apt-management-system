package kr.or.ddit.domain.central.service;

import kr.or.ddit.domain.central.dto.FacilityInfoDTO;
import kr.or.ddit.domain.central.mapper.IFacilityInfoMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class FacilityInfoServiceImpl implements IFacilityInfoService {

    private final IFacilityInfoMapper mapper;

    /**
     * 검색 조건에 맞는 단지 카드 목록 조회
     *
     */
    @Override
    public List<FacilityInfoDTO> getAptCardList(FacilityInfoDTO dto) {
        return mapper.selectAptCardList(dto);
    }

    /**
     * 선택한 단지의 상세 시설정보 조회
     *
     * aptCmplexNo란?
     * → 아파트 단지를 구분하는 고유번호.
     *   카드를 클릭했을 때 어떤 단지를 눌렀는지 구분하기 위해 사용.
     */
    @Override
    public List<FacilityInfoDTO> getFacilityInfoList(FacilityInfoDTO dto) {
        return mapper.selectFacilityInfoList(dto);
    }

    /**
     * 시/도 목록 조회
     */
    @Override
    public List<String> getSidoList() {
        return mapper.selectSidoList();
    }

    /**
     * 시/군/구 목록 조회
     */
    @Override
    public List<String> getSigunguList(String sidoNm) {
        return mapper.selectSigunguList(sidoNm);
    }

    @Override
    public int getAptCardTotalCount(FacilityInfoDTO dto) {
        return mapper.selectAptCardTotalCount(dto);
    }

    @Override
    public List<String> getFacilityTypeList() {
        return mapper.selectFacilityTypeList();
    }

}
