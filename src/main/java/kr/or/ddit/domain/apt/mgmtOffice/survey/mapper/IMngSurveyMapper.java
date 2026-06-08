package kr.or.ddit.domain.apt.mgmtOffice.survey.mapper;

import kr.or.ddit.domain.apt.mgmtOffice.survey.dto.MngSurveyDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface IMngSurveyMapper {


    void insertSurvey(MngSurveyDTO dto);

    List<MngSurveyDTO> selectSurveyList(String mgmtOfcNo);

    MngSurveyDTO selectSurveyDetail(String surveyNo);

    void updateSurvey(MngSurveyDTO dto);

    void deleteSurvey(String surveyNo);

    Map<String, Object> selectSurveyResult(String surveyNo);

    String selectMySurveyResponse(
            @Param("surveyNo") String surveyNo,
            @Param("userNo") String userNo
    );


    void insertSurveyResponse(
            @Param("surveyNo") String surveyNo,
            @Param("response") String response,
            @Param("userNo") String userNo,
            @Param("hoNo") String hoNo
    );

    int existsSurveyResponse(

            @Param("surveyNo") String surveyNo,
            @Param("userNo") String userNo

    );

    List<MngSurveyDTO> selectSurveyTypeList(
            Map<String, Object> param
    );

    List<Map<String, Object>> selectSurveyStatistics(String surveyNo);

    List<String> selectAllSurveyResponses(String surveyNo);




    int existsSurveyResult(
            @Param("surveyNo") String surveyNo,
            @Param("qitemNm") String qitemNm,
            @Param("ansrCn") String ansrCn
    );

    void updateSurveyResultCount(
            @Param("surveyNo") String surveyNo,
            @Param("qitemNm") String qitemNm,
            @Param("ansrCn") String ansrCn
    );

    void insertSurveyResult(
            @Param("surveyNo") String surveyNo,
            @Param("qitemNm") String qitemNm,
            @Param("ansrCn") String ansrCn
    );


    List<Map<String, Object>> selectSurveyResultList(String surveyNo);

    void deleteSurveyResponses(String surveyNo);

    void deleteSurveyResults(String surveyNo);


    List<Map<String, Object>> selectShortAnswerList(String surveyNo);
}
