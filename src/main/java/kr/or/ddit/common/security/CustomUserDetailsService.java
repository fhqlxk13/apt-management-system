package kr.or.ddit.common.security;

import kr.or.ddit.common.enums.member.resident.InoutCd;
import kr.or.ddit.domain.apt.mgmtOffice.main.mapper.IMngrMapper;
import kr.or.ddit.domain.member.admin.mapper.IAdmMapper;
import kr.or.ddit.domain.member.admin.vo.AdmVO;
import kr.or.ddit.domain.member.manager.vo.MngrVO;
import kr.or.ddit.domain.member.mapper.IMemberMapper;
import kr.or.ddit.domain.member.resident.mapper.IResidentMapper;
import kr.or.ddit.domain.member.resident.vo.ResidentVO;
import kr.or.ddit.domain.member.vo.CustomUser;
import kr.or.ddit.domain.member.vo.MemberVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

/**
 * @author 이용로
 */
@Slf4j
@Service
public class CustomUserDetailsService implements UserDetailsService{

	@Autowired
	private IMemberMapper memberMapper;

	@Autowired
	private IResidentMapper residentMapper;

	@Autowired
	private IMngrMapper mngrMapper;

	@Autowired
	private IAdmMapper admMapper;

	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
		log.info("## CustomUserDetailsService.loadUserByUsername() 실행...!");

		MemberVO member = memberMapper.readByUserInfo(username);
		log.info("## 확인된 회원정보 : " + member);

		String auth = member.getAuthList().get(0).getAuth();

		if("ROLE_RESIDENT".equals(auth)){
			ResidentVO resident = residentMapper.selectOneResidentInfo(member.getUserNo());
			log.info("### resident : {} ", resident);

			if(resident != null && InoutCd.LIVE == resident.getInoutCd()){	// LIVE(입주중) 상태이면 입주민으로 판단
				log.info("## 입주중인 회원으로 확인됨! : {}", resident);
				// copyProperties(source, target) source와 target의 공통된 필드를 매핑해서 target에 복사(같은 이름 필드끼리 자동맵핑)
				BeanUtils.copyProperties(member, resident);
				member = resident;	// 다형성 이용 (업캐스팅)
			}
		}else if("ROLE_MNGR".equals(auth)){
			MngrVO mngr = mngrMapper.selectOneMngrInfo(member.getUserNo());
			if(mngr != null){
				log.info("## 단지관리자로 확인됨 : {}", mngr);
				BeanUtils.copyProperties(member, mngr);
				member = mngr;
			}
		}else if("ROLE_ADMIN".equals(auth)){
			AdmVO adm = admMapper.selectOneAdmInfo(member.getUserNo()) ;
			if(adm != null){
				log.info("## 중앙관리자로 확인됨 : {}", adm);
				BeanUtils.copyProperties(member, adm);
				member = adm;
			}
		}

		// 넘겨받은 member가 null인 경우라면 UsernameNotFoundException 에러에 의해 회원정보가 존재하지 않는다는
		// 에러를 응답으로 출력한다.
		return member == null ? null : new CustomUser(member);
	}
}
