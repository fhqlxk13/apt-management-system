package kr.or.ddit.domain.central.mapper;

import kr.or.ddit.domain.central.vo.ContractUserVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface IContractUserMapper {

    String selectRentCtrtNo(String userNo);

    void insertContractDoc(ContractUserVO contractUserVO);
    

    void updateInqCnt(String annNo);

    // 경고임 무시해도됨
    List<Map<String, Object>> selectExcluseAreaDetail(@Param("annNo") String annNo,
                                                      @Param("aptCmplexNo") String aptCmplexNo);

    void insertAplct(Map<String, Object> params);

    String selectHoTyNo(Map<String, Object> params);

    // 경고임 무시해도됨
    List<Map<String, Object>> selectAplctList(String userNo);

    void cancelContract(String aplctNo);

    // 경고임 무시해도됨
    Map<String, Object> selectOneContractHistoryDetail(String aplctNo);

    // 경고임 무시해도됨
    List<Map<String, Object>> selectSbmsnDocList(String aplctNo);

    int selectAplctcount(Map<String, Object> params);

    // 경고임 무시해도됨
    List<Map<String, Object>> selectRentListingByAptCmplexNo(String aptCmplexNo);

    // 경고임 무시해도됨
    List<Map<String, Object>> selectAplctDocList(String aplctNo);

    void deleteContractDoc(@Param("aplctNo") String aplctNo,
                           @Param("sbmsnDocTyCd") String sbmsnDocTyCd);

    int selectSubmittedDocCount(@Param("aplctNo") String aplctNo);

    int selectRequiredDocCount(@Param("aplctNo") String aplctNo);

    void isAllSubmitted(@Param("aplctNo") String aplctNo);
}
