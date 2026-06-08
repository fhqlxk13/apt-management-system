package kr.or.ddit.common.api.react.mapper;

import kr.or.ddit.domain.apt.main.vo.AptComplexVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;

@Mapper
public interface IReactAptMapper {
    List<AptComplexVO> searchApartment(String keyword, int startRow, int size);

    int countApartment(String keyword);

    List<Map<String, Object>> getDongList(String aptCmplexNo);

    List<Map<String, Object>> getHoList(String aptCmplexNo, String dongNo);

    Map<String, Object> getRentListingDetail(String hoNo);

    List<Map<String, Object>> getRequiredDocs(String rentLstgNo);

    String getSeqSbmsnDoc();

    void insertSbmsnDoc(Map<String, String> param);

    void insertRentCtrt(Map<String, String> param);

    void updateRentListingStatus(String rentListingNo);

    void insertCtrtMgr(Map<String, String> param);
}
