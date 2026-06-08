package kr.or.ddit.common.enums.member.mngr;

/**
 * 직원 계정 요청 상태 코드
 */
public enum MngrRqstStatusCd {
    WAIT,  // 승인대기
    OK,    // 승인완료
    RJCT,  // 반려
    CNL    // 신청취소
}