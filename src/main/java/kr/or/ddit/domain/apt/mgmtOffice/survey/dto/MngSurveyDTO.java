package kr.or.ddit.domain.apt.mgmtOffice.survey.dto;

import lombok.Data;

@Data
public class MngSurveyDTO {

    private String surveyNm;
    private String surveyCn;

    private String surveyTypeCd;
    private String surveySttsCd;

    private String surveyBgngDt;
    private String surveyEndDt;

    private String surveyQitemCn;

    private String rgtrId;
    private String surveyNo;

    private String aptCd;
    private int participantCount;
    private int residentCount;


    private double answerRate;
}