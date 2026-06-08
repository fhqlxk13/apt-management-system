package kr.or.ddit.domain.central.service;

import kr.or.ddit.domain.central.dto.FacilityInfoDTO;

import java.util.List;

/**
 * 단지 시설정보 Service
 */
public interface IFacilityInfoService {

    List<FacilityInfoDTO> getFacilityInfoList(FacilityInfoDTO dto);

    List<FacilityInfoDTO> getAptCardList(FacilityInfoDTO dto);

    List<String> getSidoList();

    List<String> getSigunguList(String sidoNm);

    int getAptCardTotalCount(FacilityInfoDTO dto);

    List<String> getFacilityTypeList();

}