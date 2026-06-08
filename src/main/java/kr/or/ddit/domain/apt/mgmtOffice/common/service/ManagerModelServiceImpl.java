package kr.or.ddit.domain.apt.mgmtOffice.common.service;

import kr.or.ddit.domain.apt.mgmtOffice.main.mapper.IMgmtOfficeMapper;
import kr.or.ddit.domain.apt.mgmtOffice.main.vo.MgmtOfficeVO;
import kr.or.ddit.domain.member.vo.CustomUser;
import kr.or.ddit.domain.member.vo.MemberVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

@Service
public class ManagerModelServiceImpl implements IManagerModelService {

    /*
     * 관리사무소 정보 조회용 Mapper
     * - 화면 상단/사이드바 등에 표시할 관리사무소명, 단지명을 조회
     */
    @Autowired
    private IMgmtOfficeMapper mgmtOfficeMapper;

    /*
     * 로그인 사용자가 ADMIN인지 확인
     */
    @Override
    public boolean isAdmin(CustomUser customUser) {

        // 로그인 정보가 없으면 ADMIN이 아님
        if (customUser == null) {
            return false;
        }

        // 로그인 사용자의 권한 목록 중 ROLE_ADMIN 존재 여부 확인
        return customUser.getAuthorities().stream()
                .anyMatch(auth -> "ROLE_ADMIN".equals(auth.getAuthority()));
    }

    /*
     * 관리사무소 화면 공통 model 값 세팅
     * - JSP/JS에서 공통으로 사용할 로그인 사용자명, 관리자 여부, 관리사무소 번호 세팅
     * - mgmtOfcNo가 있으면 관리사무소명, 단지명도 함께 세팅
     */
    @Override
    public void addManagerViewModel(Model model, CustomUser customUser, String mgmtOfcNo) {

        // 현재 로그인 사용자가 ADMIN인지 확인
        boolean admin = isAdmin(customUser);

        // 로그인 사용자 이름 표시를 위해 CustomUser 안의 MemberVO 꺼내기
        MemberVO member = customUser == null ? null : customUser.getMember();

        // JSP/JS 공통 사용 값 세팅
        model.addAttribute("isAdmin", admin);
        model.addAttribute("mgmtOfcNo", mgmtOfcNo);
        model.addAttribute("loginUserNm", member == null ? "" : member.getUserNm());

        // ADMIN이 관리사무소를 선택한 뒤 들어온 화면이면 선택된 관리사무소 번호 세팅
        if (admin && mgmtOfcNo != null && !mgmtOfcNo.isBlank()) {
            model.addAttribute("selectedMgmtOfcNo", mgmtOfcNo);
        }

        // 관리사무소 번호가 있으면 화면 표시용 관리사무소 정보 조회
        if (mgmtOfcNo != null && !mgmtOfcNo.isBlank()) {
            MgmtOfficeVO office = mgmtOfficeMapper.selectMgmtOfficeByMgmtOfcNo(mgmtOfcNo);
            // 조회된 관리사무소 정보가 있으면 화면 표시용 이름 세팅
            if (office != null) {
                // 사이드바/헤더 JSP는 ${office.*}를 기준으로 현재 조회 중인 관리사무소명을 표시한다.
                model.addAttribute("office", office);
                model.addAttribute("mgmtOfcNm", office.getMgmtOfcNm());
                model.addAttribute("aptCmplexNm", office.getAptCmplexNm());
            }
        }
    }

    @Override
    public String getAptComplexNo(String mgmtOfcNo) {

        return mgmtOfficeMapper.selectAptComplexNo(mgmtOfcNo);
    }
}
