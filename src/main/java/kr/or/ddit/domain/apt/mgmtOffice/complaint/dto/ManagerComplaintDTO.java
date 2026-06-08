package kr.or.ddit.domain.apt.mgmtOffice.complaint.dto;

import lombok.Data;

@Data
public class ManagerComplaintDTO {

    /**
     * 민원 필드(CVPL)
     */
    private String cvplNo;        // 민원번호
    private String cvplTyCd;      // 민원유형코드
    private String cvplLoc;       // 민원발생위치
    private String cvplCn;        // 민원내용
    private String cvplSttsCd;    // 민원상태코드
    private String cvplRegDt;     // 민원생성일자
    private String cvplMdfDt;     // 민원수정일자
    private String cvplRcptDt;    // 민원접수일자
    private String cvplEndDt;     // 민원종결일자
    private String cvplPrrt;      // 민원우선순위
    private String cvplFileNo;    // 민원파일번호
    private String cvplTtl;       // 민원제목
    private String userNo;        // 사용자번호
    private String hoNo;          // 호번호
    private String aptCmplexNo;   // 아파트단지번호

    /**
     * 민원 이력 필드(CVPL_HSTRY)
     */
    private String cvplHstryId;   // 민원이력번호
    private String cvplAns;       // 민원답변
    private String picId;         // 담당자아이디
    private String cvplSttscd;    // 민원상태코드 (이력)

    /**
     * 신고자 정보 필드(MEMBER)
     */
    private String userId;
    private String userNm;

    /**
     * 세대정보 필드(APT_DETAIL, APT_UNIT)
     */
    private String dongNm;        // 동이름
    private String ho;            // 호수

    /**
     * 검색조건 필드(접수기간)
     */
    private String searchDateFrom; // 접수기간 시작일
    private String searchDateTo;   // 접수기간 종료일

}
