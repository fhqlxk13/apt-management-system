package kr.or.ddit.domain.apt.mgmtOffice.employee.vo;

import lombok.Data;

@Data
public class MngrRqstVO {

    // MNGR_RQST
    private String rqstNo;        // 요청 번호
    private String rqstLoginId;   // 요청 대상 회원 로그인 아이디
    private String rqstMngrNm;    // 요청 대상 직원명
    private String rqstDutyCd;    // 요청 직무 코드
    //Date → JSON → JS → 화면(데이터를 비동기로 받아오면서)
    //Date가 timestamp로 내려옴 ->JS에서 다시 변환해야함 ->timezone 영향 받을 수 있음
    //SQL: to_char -> VO: String -> JS: 그대로 출력 (ajax + js화면에 좋음)
    //VO: Date -> JSP: fmt:formatDate (서버 렌더링에 좋음)
    private String rqstDt;        // 요청 일자
    private String aprvDt;        // 처리 일자
    //<fmt:formatDate value="${rqst.rqstDt}" pattern="yyyy.MM.dd"/>
    private String rqstSttsCd;    // 요청 상태 코드
    private String aprvId;        // 처리자 ID
    private String rjctRsnCn;     // 반려 사유
    private String rmrkCn;        // 비고
    private String userNo;        // 요청을 올린 관리자 userNo

    // JOIN - 요청을 올린 관리자(manager-heade)의 소속 관리사무소 정보
    private String mgmtOfcNo;     // 관리사무소 번호
    private String mgmtOfcNm;     // 관리사무소명
    private String aptCmplexNm;   // 아파트 단지명



    // 직원 요청 '승인자'의 정보(ID, 이름)
    private String aprvUserId;    // 처리자 로그인 아이디
    private String aprvUserNm;    // 처리자 이름
}