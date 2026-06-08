package kr.or.ddit.domain.central.admin.mapper;

import kr.or.ddit.domain.apt.main.vo.AptComplexVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface AnnRegisterMapper {

    /** GENERAL 상태 매물이 있는 시·도 */
    List<String> selectSidoList();

    /** GENERAL 상태 매물이 있는 시·군·구 */
    List<String> selectSigunguList(@Param("sidoNm") String sidoNm);

    /** GENERAL 상태 매물이 있는 읍·면·동 */
    List<String> selectEmdList(@Param("sidoNm") String sidoNm, @Param("sigunguNm") String sigunguNm);

    List<AptComplexVO> selectAptList(String sidoNm, String sigunguNm, String emdNm);

    String selectDorojuso(String aptCmplexNo);

    List<Map<String, Object>> selectHoTyNo(String aptCmplexNo);

    List<Map<String, Object>> selectSbmsnDocList(List<String> rentLstgNoList);

    void insertAnn(Map<String, Object> params);

    List<Map<String, Object>> selectRentList(String aptCmplexNo);

    void updateRentListStts(Map<String, Object> params);

    String selectBoardNo(@Param("aptCmplexNo") String aptCmplexNo);

    void insertBoardInstance(@Param("aptCmplexNo") String aptCmplexNo);
}
