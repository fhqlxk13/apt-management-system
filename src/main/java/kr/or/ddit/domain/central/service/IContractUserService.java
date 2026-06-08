package kr.or.ddit.domain.central.service;

import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;
import java.util.Map;

public interface IContractUserService {

    void insertContractDoc(List<MultipartFile> files, List<String> cat, String aplctNo, String userNo) throws IOException;

    void updateInqCnt(String annNo);


    List<Map<String, Object>> selectExcluseAreaDetail(String annNo, String aptCmplexNo);

    void insertAplct(Map<String, Object> params);

    List<Map<String, Object>> selectAplctList(String userNo);

    void cancelContract(String aplctNo);

    Map<String, Object> selectOneContractHistoryDetail(String aplctNo);

    List<Map<String, Object>> selectSbmsnDocList(String aplctNo);

    List<Map<String, Object>> selectAplctDocList(String aplctNo);
}



