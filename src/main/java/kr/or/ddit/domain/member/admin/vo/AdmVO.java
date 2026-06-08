package kr.or.ddit.domain.member.admin.vo;

import kr.or.ddit.domain.member.vo.MemberVO;
import lombok.Data;

@Data
public class AdmVO extends MemberVO {
    private String deptNm;  // 부서
    private String pstnNm;  // 직위
}
