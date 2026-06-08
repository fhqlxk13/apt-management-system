package kr.or.ddit.domain.member.vo;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.Data;

import java.util.Date;
import java.util.List;

@Data
public class MemberVO {
    private String userNo;
    private String userId;
    @JsonIgnore
    private String userPw;
    private String userNm;
    @JsonIgnore
    private String userRrno;
    private String userTelno;
    private String userEml;
    private Date regDt;
    private Date mdfDt;
    private char userYn;
    private char smsRcvYn;
    private char smsNtcRcvYn;
    private char smsCtrtRcvYn;
    private char emlRcvYn;
    private char emlNtcRcvYn;
    private char emlCtrtRcvYn;

    @JsonInclude(JsonInclude.Include.NON_NULL)
    private String profFileId;

    private List<AuthVO> authList;
}

