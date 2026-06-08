package kr.or.ddit.domain.member.manager.vo;

import lombok.Data;

@Data
public class ManagerVO {
    // MANAGER
    private String userNo;       // 직원 사용자 번호
    private String mgmtOfcNo;    // 소속 관리사무소 번호
    private String mngrDutyCd;   // 직무 코드

    // MEMBER
    private String userId;       // 로그인 아이디
    private String userNm;       // 이름
    private String telno;        // 연락처
    private String userEml;      // 이메일
    private String userYn;       // 사용 여부
    private String birthDate;    // 주민번호 앞 6자리 또는 생년월일 표시용

    // MGMT_OFFICE / APT_COMPLEX
    private String mgmtOfcNm;    // 관리사무소명
    private String aptCmplexNm;  // 아파트 단지명
}

/*
3. 팀원의 저항(리팩토링 부담)을 줄여주는 팁
팀원이 "이미 여기저기 다 써서 못 바꾼다"고 한다면, 아래의 MyBatis 설정 비법을 알려주세요.

MyBatis의 extends 활용: resultMap에서 부모의 설정을 그대로 상속받을 수 있습니다.

XML
<!-- MemberMapper.xml의 공통 맵 -->
<resultMap id="memberMap" type="MemberVO"> ... </resultMap>

<!-- ManagerMapper.xml에서 상속 활용 -->
<resultMap id="managerMap" type="ManagerVO" extends="kr.or.ddit.mapper.MemberMapper.memberMap">
    <result property="mgmtOfcNo" column="MGMT_OFC_NO"/>
    <result property="mngrDutyCd" column="MNGR_DUTY_CD"/>
</resultMap>
 */
