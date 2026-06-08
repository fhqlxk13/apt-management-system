package kr.or.ddit.common.config;

import kr.or.ddit.domain.apt.complaint.mapper.ICvplMapper;
import kr.or.ddit.domain.apt.complaint.vo.CvplVO;
import kr.or.ddit.domain.member.admin.vo.AdmVO;
import kr.or.ddit.domain.member.manager.vo.MngrVO;
import kr.or.ddit.domain.member.resident.vo.ResidentVO;
import kr.or.ddit.domain.member.vo.CustomUser;
import kr.or.ddit.domain.member.vo.MemberVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Slf4j
@Service
public class AuthService {

    @Autowired
    private ICvplMapper cvplMapper;

    /**
     * 해당 단지 입주민 접근 권한 소속 확인
     *
     * @param principal
     * @param target
     * @return boolean 접근 허용 여부 true : 허용, false : 불허
     * @author 이용로
     */
    public boolean hasAccess(Object principal, String target) {   // 캐스팅 안정성 때문에 customUser가 아닌 principal사용

        if (!(principal instanceof CustomUser user))
            return false;   // principal이 CustomUser타입이면 user변수 생성후 초기화하고 아니면 false반환

        MemberVO member = user.getMember();

        if (member instanceof ResidentVO resident) {

            boolean isOwner = resident.getMyAptList().stream()
                    .anyMatch(apt -> apt.getAptCmplexNo().equals(target));

            if (!isOwner) log.info("권한 없는 단지 접근 시도 유저 : {}", resident.getUserId());

            return isOwner;
        } else if (member instanceof MngrVO mngr) {

            boolean isManager = mngr.getMgmtOfcNo().equals(target) || mngr.getAptCmplexNo().equals(target);

            if (!isManager) log.info("권한 없는 단지 접근 시도 유저 : {}", mngr.getUserId());

            return isManager;
        } else return member instanceof AdmVO;

    }

    /**
     * only 입주민만 허용해주는 서비스 (ex.민원 신청)
     *
     * @param principal
     * @param aptCmplexNo
     * @return boolean
     * @author 이용로
     */
    public boolean isResidentOnly(Object principal, String aptCmplexNo) {
        if (!(principal instanceof CustomUser user)) return false;

        MemberVO member = user.getMember();
        return (member instanceof ResidentVO) ? hasAccess(user, aptCmplexNo) : false;
    }

    /**
     * only 사용자만 허용
     * @author 이용로
     * @param principal
     * @return
     */
    public boolean isUserOnly(Object principal){
        if (!(principal instanceof CustomUser user)) return false;

        MemberVO member = user.getMember();
        if(member instanceof AdmVO || member instanceof MngrVO) return false;
        else return true;
    }

    /**
     * 작성자 또는 관리자만 접근
     *
     * @param principal
     * @param writerNo
     * @param aptCmplexNo
     * @return
     * @author 이용로
     */
    public boolean isWriter(Object principal, String writerNo, String aptCmplexNo) {
        if (writerNo == null || !(principal instanceof CustomUser user)) return false;

        MemberVO member = user.getMember();
        if (member == null) return false;

        // 1. 최고 관리자(ADMIN)는 시스템 관리를 위해 모든 소유권 검증을 프리패스
        if (member instanceof AdmVO) return true;

        if (!hasAccess(principal, aptCmplexNo)) {
            return false;
        }

        if (member instanceof MngrVO) {
            return true;
        }

        return member.getUserNo() != null && member.getUserNo().equals(writerNo);
    }

    /**
     * 민원 상세 조회/수정/삭제 권한 확인
     *
     * @param cvplNo 민원 고유 번호 (PK)
     */
    public boolean canAccessCvpl(Object principal, String cvplNo) {
        // 1. DB에서 cvplNo로 해당 민원 정보(단지번호, 작성자유저번호)를 조회해옵니다.
        CvplVO cvpl = cvplMapper.selectOneCvplBrief(cvplNo);

        if(cvpl == null) return false;
        String writerNo = cvpl.getUserNo();
        // 2. 조회된 결과로 기존에 만든 canAccessPost를 재활용합니다.
        return isWriter(principal, writerNo, cvpl.getAptCmplexNo());
    }

    /**
     * 관리사무소 계정 여부 확인
     * <p>
     * ADMIN은 RoleHierarchy 때문에 hasRole('MNGR')를 통과할 수 있으므로,
     * 실제 처리성 기능(등록/수정/삭제/취소)은 Member 타입이 MngrVO인 경우만 허용한다.
     *
     * @param principal 로그인 사용자 principal
     * @return true: 관리사무소 계정, false: 그 외 사용자
     */
    public boolean isManagerOnly(Object principal) {
        if (!(principal instanceof CustomUser)) return false;

        CustomUser user = (CustomUser) principal;
        MemberVO member = user.getMember();

        // canMgmtCrud() 내부에서 ADMIN을 제외하기 위한 보조 검사.
        // RoleHierarchy 때문에 ADMIN도 hasRole('MNGR')를 통과할 수 있으므로,
        // 실제 Member 타입이 MngrVO인 관리사무소 계정만 처리성 기능을 허용한다.
        return member instanceof MngrVO;
    }

    /**
     * 관리사무소 CUD 처리 권한 확인
     * <p>
     * 관리사무소 등록/수정/삭제/취소 같은 CUD성 API에서 사용한다.
     * ADMIN은 조회만 가능하므로 제외하고,
     * 실제 MngrVO이면서 본인 소속 관리사무소인 경우만 허용한다.
     *
     * @param principal 로그인 사용자 principal
     * @param mgmtOfcNo 요청 URL의 관리사무소 번호
     * @return true: 처리 허용, false: 처리 불허
     */
    public boolean canMgmtCrud(Object principal, String mgmtOfcNo) {
        return isManagerOnly(principal) && hasAccess(principal, mgmtOfcNo);
    }
}
