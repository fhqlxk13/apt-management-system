package kr.or.ddit.domain.central.rentCtrt.mapper;

import kr.or.ddit.common.file.vo.AttachFileVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface IRentCtrtMapper {

    int insertRentCtrt(@Param("param") List<Map<String, Object>> param);

    int insertCtrtMgr(@Param("param") List<Map<String, Object>> qualifiedList, @Param("manager") String manager);

    String getNextRentCtrtSeq();

    List<Map<String, Object>> selectCtrt(@Param("startRow") int startRow,@Param("endRow") int endRow);

    int selectCtrtCount(@Param("userNo") String userNo);

    @SuppressWarnings("MyBatisMapperMethod") // 인텔리제이 마이바티스 검사 무시
    Map<String, Object> selectCtrtDashboard();

    String getUserNo(String aplctNo);

    Map<String, Object> selectOneCtrtDetail(String rentCtrtNo);

    int updateCtrt(@Param("rentCtrtNo") String rentCtrtNo, @Param("detail") Map<String, Object> detail);

    int selectContractsCount(Map<String, Object> params);

    List<Map<String, Object>> selectContracts(Map<String, Object> params);

    void insertHshldHead(Map<String, Object> detail);

    String selectAptCmplexNo(String rentLstgNo);

    List<Map<String, Object>> selectCtrtXls(Map<String, Object> params);
}
