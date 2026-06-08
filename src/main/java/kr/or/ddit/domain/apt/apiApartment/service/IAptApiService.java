package kr.or.ddit.domain.apt.apiApartment.service;

import kr.or.ddit.common.api.react.vo.AptManageDetailDTO;
import kr.or.ddit.domain.apt.apiApartment.vo.AptBass;
import kr.or.ddit.domain.apt.main.vo.AptComplexVO;

import java.util.List;

public interface IAptApiService {

    void updateLatLng();

    List<AptBass> checkBaseInfo(String sido, String sigungu, String emd);

    void registerAptList(List<String> kaptCodeList);

    AptManageDetailDTO getDetail(String kaptCode);

    void saveApartment(AptManageDetailDTO dto);
}
