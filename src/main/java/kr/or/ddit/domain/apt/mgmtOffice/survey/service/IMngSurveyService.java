package kr.or.ddit.domain.apt.mgmtOffice.survey.service;

import kr.or.ddit.domain.apt.mgmtOffice.survey.dto.MngSurveyDTO;
import org.jspecify.annotations.Nullable;

import java.util.List;
import java.util.Map;

public interface IMngSurveyService {

    void registerSurvey(MngSurveyDTO dto);

    List<MngSurveyDTO> selectSurveyList(String mgmtOfcNo);

    MngSurveyDTO selectSurveyDetail(String surveyNo);

    void updateSurvey(MngSurveyDTO dto);

    void deleteSurvey(String surveyNo);


    Map<String, Object> selectSurveyResult(String surveyNo);

    String selectMySurveyResponse(
            String surveyNo,
            String userNo
    );

    void insertSurveyResponse(
            String surveyNo,
            String response,
            String userNo,
            String hoNo
    );


    boolean existsSurveyResponse(String surveyNo, String userNo);

    List<MngSurveyDTO> selectSurveyTypeList(
            String type,
            String aptCd
    );

    List<Map<String, Object>> selectSurveyStatistics(String surveyNo);

    Object selectShortAnswerList(String surveyNo);
}
