package kr.or.ddit.domain.apt.mgmtOffice.employee.DTO;

import lombok.Data;

@Data
public class MemberSearchDTO {
    // 직원 계정 생성 요청 시 기존 회원들(auth - role_member) 중 선택하기 위한 DTO
    // 선택된 회원의 userId가 MNGR_RQST.rqstLoginId로
    private String userNo;       // 회원 번호
    // - 회원번호는 화면에서 식별용으로 보여줄 수 있으나, 요청 등록시 db에 저장하는건 userId
    private String userId;       // 로그인 아이디 → rqstLoginId로 사용
    private String userNm;       // 회원 이름
    private String userTelno;    // 연락처
    private String userEml;      // 이메일
    private String birthDate;    // 주민번호 앞 6자리 표시용
    private String rqstSttsCd;   // 회원 검색 결과 표시용: 기존 직원 계정 요청 상태(RJCT 등)
}
