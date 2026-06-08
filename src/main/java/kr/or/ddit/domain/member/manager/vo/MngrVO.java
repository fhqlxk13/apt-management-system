package kr.or.ddit.domain.member.manager.vo;

import kr.or.ddit.domain.member.resident.vo.ResidentVO;
import kr.or.ddit.domain.member.vo.MemberVO;
import lombok.Data;
/**
 * 로그인한 관리사무소 직원의 최소 정보(소속, 개인정보 등) VO
 *
 * - MEMBER 공통 정보는 MemberVO에서 상속받는다.
 * - MANAGER 테이블의 관리사무소 번호와 직무코드를 추가로 가진다.
 * - 로그인 후 CustomUser 안에 담겨 Controller에서 현재 관리자의 소속 관리사무소를 꺼낼 때 사용한다.
 */
@Data
public class MngrVO extends MemberVO {

    private String mgmtOfcNo;   // 관리사무소 번호
    private String mngrDutyCd;  // 직무

    // 관리사무소(MGMT_OFFICE) 테이블 조인
    private String mgmtOfcNm;   // 관리사무소 명


    // APT_COMPLEX 조인 표시용
    private String aptCmplexNo;   // 아파트 단지 번호
    private String aptCmplexNm;   // 아파트 단지명
}
