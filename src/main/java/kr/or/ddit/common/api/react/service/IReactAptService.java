package kr.or.ddit.common.api.react.service;

import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.Map;

public interface IReactAptService {
    Map<String, Object> searchApartment(String keyword, int page, int size);

    List<Map<String, Object>> getDongList(String aptCmplexNo);

    List<Map<String, Object>> getHoList(String aptCmplexNo, String dongNo);

    Map<String, Object> getRentListingDetail(String hoNo);

    List<Map<String, Object>> getRequiredDocs(String rentLstgNo);

    void assignResident(Map<String, String> param, List<MultipartFile> files, List<String> fileTypes);
}
