package kr.or.ddit.domain.member.resident.vo;

import kr.or.ddit.common.enums.member.resident.InoutCd;
import kr.or.ddit.domain.member.vo.MemberVO;
import lombok.Data;

import java.util.Date;
import java.util.List;

/**
 * @author 이용로.
 */
@Data
public class ResidentVO extends MemberVO {

    // resident table 기본 컬럼 필드
    private InoutCd inoutCd;         // 입퇴거 코드(여부)
    private Date moveInDt;          // 입주일
    private Date moveOutDt;         // 퇴거일
    private char headYn;      // 세대주 여부

    // 아파트 단지(APT_COMPLEX) 테이블과 조인 필요
    private List<MyAptVO> myAptList;    // 거주지 리스트(등록된 거주지 다수인 상황 대비 리스트)

}