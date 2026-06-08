package kr.or.ddit.domain.apt.mgmtOffice.survey.service;

import kr.or.ddit.domain.apt.mgmtOffice.survey.dto.MngSurveyDTO;
import kr.or.ddit.domain.apt.mgmtOffice.survey.mapper.IMngSurveyMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Service
@RequiredArgsConstructor
public class MngSurveyServiceImpl implements IMngSurveyService {


    private final IMngSurveyMapper iMngSurveyMapper;


    @Override
    public void registerSurvey(MngSurveyDTO dto) {

        log.info("dto : {}", dto);

        iMngSurveyMapper.insertSurvey(dto);
    }

    @Override
    public List<MngSurveyDTO> selectSurveyList(String mgmtOfcNo) {
        return iMngSurveyMapper.selectSurveyList(mgmtOfcNo);
    }

    @Override
    public MngSurveyDTO selectSurveyDetail(String surveyNo) {

        return iMngSurveyMapper
                .selectSurveyDetail(surveyNo);
    }

    @Override
    public void updateSurvey(
            MngSurveyDTO dto
    ) {

        iMngSurveyMapper.updateSurvey(dto);
    }

    @Override
    @Transactional
    public void deleteSurvey(
            String surveyNo
    ) {

        iMngSurveyMapper.deleteSurveyResponses(surveyNo);

        iMngSurveyMapper.deleteSurveyResults(surveyNo);

        iMngSurveyMapper.deleteSurvey(surveyNo);
    }




    @Override
    public Map<String, Object> selectSurveyResult(
            String surveyNo
    ) {

        Map<String, Object> survey =
                iMngSurveyMapper.selectSurveyResult(surveyNo);

        List<Map<String, Object>> resultList =
                iMngSurveyMapper.selectSurveyResultList(surveyNo);

        if(resultList == null || resultList.isEmpty()){
            resultList = buildResultListFromResponses(surveyNo);
        }

        survey.put("resultList", resultList);

        System.out.println("survey = " + survey);
        System.out.println("resultList = " + resultList);

        return survey;
    }

    private List<Map<String, Object>> buildResultListFromResponses(
            String surveyNo
    ) {

        List<String> responses =
                iMngSurveyMapper.selectAllSurveyResponses(surveyNo);

        Map<String, Map<String, Object>> resultMap =
                new LinkedHashMap<>();

        ObjectMapper objectMapper =
                new ObjectMapper();

        for(String response : responses){

            try {

                List<Map<String, Object>> answerList =
                        objectMapper.readValue(
                                response,
                                new TypeReference<List<Map<String, Object>>>() {}
                        );

                for(Map<String, Object> answer : answerList){

                    String qitemNm =
                            "Q" + answer.get("questionNo");

                    String ansrCn =
                            String.valueOf(answer.get("answer"));

                    String type =
                            String.valueOf(answer.get("type"));


                    if(!"MULTI".equals(type)
                            && !"YN".equals(type)){

                        continue;
                    }

                    String key =
                            qitemNm + "\u0000" + ansrCn;

                    Map<String, Object> result =
                            resultMap.computeIfAbsent(
                                    key,
                                    ignored -> {
                                        Map<String, Object> row =
                                                new LinkedHashMap<>();

                                        row.put("qitemNm", qitemNm);
                                        row.put("ansrCn", ansrCn);
                                        row.put("ansrCnt", 0);

                                        return row;
                                    }
                            );

                    result.put(
                            "ansrCnt",
                            ((Number) result.get("ansrCnt")).intValue() + 1
                    );
                }

            } catch (Exception e){

                log.warn(
                        "Failed to parse survey response. surveyNo={}",
                        surveyNo,
                        e
                );
            }
        }

        return new ArrayList<>(resultMap.values());
    }



    @Override
    public String selectMySurveyResponse(
            String surveyNo,
            String userNo
    ) {

        return iMngSurveyMapper
                .selectMySurveyResponse(
                        surveyNo,
                        userNo
                );
    }


    @Override
    @Transactional
    public void insertSurveyResponse(
            String surveyNo,
            String response,
            String userNo,
            String hoNo
    ) {
        iMngSurveyMapper.insertSurveyResponse(
                surveyNo,
                response,
                userNo,
                hoNo
        );
        try {

            ObjectMapper objectMapper =
                    new ObjectMapper();

            List<Map<String, Object>> answerList =
                    objectMapper.readValue(
                            response,
                            new TypeReference<List<Map<String, Object>>>() {}
                    );

            System.out.println("answerList = " + answerList);

            for(Map<String, Object> answer : answerList){



                String type =
                        String.valueOf(answer.get("type"));

                if(!"MULTI".equals(type)
                        && !"YN".equals(type)){

                    continue;
                }


                String qitemNm =
                        "Q" + answer.get("questionNo");

                String ansrCn =
                        String.valueOf(answer.get("answer"));

                System.out.println("qitemNm = " + qitemNm);
                System.out.println("ansrCn = " + ansrCn);

                int exists =
                        iMngSurveyMapper.existsSurveyResult(
                                surveyNo,
                                qitemNm,
                                ansrCn
                        );

                if(exists > 0){

                    iMngSurveyMapper.updateSurveyResultCount(
                            surveyNo,
                            qitemNm,
                            ansrCn
                    );

                } else {

                    iMngSurveyMapper.insertSurveyResult(
                            surveyNo,
                            qitemNm,
                            ansrCn
                    );
                }
            }

        } catch (Exception e){

            throw new IllegalArgumentException(
                    "설문 응답 저장 중 집계 처리에 실패했습니다.",
                    e
            );
        }
    }

    @Override
    public boolean existsSurveyResponse(
            String surveyNo,
            String userNo
    ) {

        return iMngSurveyMapper.existsSurveyResponse(
                surveyNo,
                userNo
        ) > 0;
    }

    @Override
    public List<MngSurveyDTO> selectSurveyTypeList(
            String type,
            String aptCd
    ) {

        Map<String, Object> param =
                new LinkedHashMap<>();

        param.put("type", type);
        param.put("aptCd", aptCd);

        return iMngSurveyMapper
                .selectSurveyTypeList(param);
    }

    @Override
    public List<Map<String, Object>> selectSurveyStatistics(
            String surveyNo
    ) {

        return iMngSurveyMapper
                .selectSurveyStatistics(surveyNo);
    }

    @Override
    public List<Map<String, Object>>
    selectShortAnswerList(String surveyNo) {

        return iMngSurveyMapper
                .selectShortAnswerList(surveyNo);
    }
}
