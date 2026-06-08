package kr.or.ddit.domain.central.admin.dto;

import java.util.Date;

import lombok.Data;

/**
 * 단지 관리자 계정 화면 전용 VO
 *
 * 왜 화면 전용 VO를 쓰나?
 * → MNGR_RQST, MEMBER, MANAGER, MGMT_OFFICE, APT_COMPLEX 데이터를 한 화면에서 같이 보여주기 위해 사용한다.
 */
@Data
public class MngrRqstAprvDTO {

    /* MNGR_RQST: 단지 관리자 신청 정보 */
    private String rqstNo;
    private String rqstLoginId;
    private String rqstMngrNm;
    private String rqstDutyCd;
    private Date rqstDt;
    private Date aprvDt;
    private String rqstSttsCd;
    private String aprvId;
    private String rjctRsnCn;
    private String rmrkCn;
    private String userNo;

    /* 단지/관리사무소 정보 */
    private String aptCmplexNo;
    private String aptCmplexNm;
    private String mgmtOfcNo;

    /* MEMBER + MANAGER: 승인 후 실제 계정 목록 */
    private String userId;
    private String userNm;
    private String userTelno;
    private String userEml;
    private String userYn;
    private String mngrDutyCd;
    private Date regDt;
    private Date mdfDt;

    /* 화면 표시용 */
    private String dutyNm;
    private String sttsNm;
    private String lastLoginDt;
    private String lastLoginTm;
    private String acntDsplyYn;

    /* 단지관리자 직원계정 요청 */
    private String keyword; // 이름, 아이디, 단지명 통합 검색어
    private String status;  // WAIT	승인대기 / OK	승인완료 / RJCT 반려 / CNL 신청취소
    private String role;    // HEAD	관리소장 / ACNT 회계담당 / ADM 행정담당 / FAC 시설담당

    /* 단지 상세주소 표시용 */
    private String sidoNm;      // 시도명
    private String sigunguNm;   // 시군구명
    private String emdNm;       // 읍면동명
    private String detailAddr;  // 화면 표시용 상세주소

}
