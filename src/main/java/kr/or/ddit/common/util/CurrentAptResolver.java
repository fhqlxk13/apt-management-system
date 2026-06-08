package kr.or.ddit.common.util;

import kr.or.ddit.domain.apt.mgmtOffice.main.service.IMgmtOfficeService;
import kr.or.ddit.domain.apt.mgmtOffice.main.vo.MgmtOfficeVO;
import kr.or.ddit.domain.member.resident.vo.ResidentVO;
import kr.or.ddit.domain.member.vo.CustomUser;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Component;

/**
 * 현재 로그인 사용자가 속한 아파트 단지번호(aptCmplexNo)를 구하는 공통 컴포넌트.
 *
 * 왜 따로 분리했는가?
 * - 관리소장과 입주민은 aptCmplexNo를 구하는 방식이 다름.
 * - 이 로직을 HeaderModelAdvice, 각 Controller마다 중복해서 쓰면
 *   나중에 수정할 때 또 같은 문제가 반복될 수 있음.
 *
 * 현재 기준
 * 1. 관리소장(ROLE_MNGR)
 *    userNo -> 관리사무소 -> aptCmplexNo
 * 2. 입주민
 *    CustomUser -> ResidentVO -> myAptList 첫 번째 단지 -> aptCmplexNo
 *
 * 참고
 * - 입주민이 여러 단지에 속할 수 있다면, 장기적으로는
 *   '현재 선택된 단지번호'를 세션이나 URL 기준으로 관리하는 것이 더 정확함.
 */
@Slf4j
@Component
public class CurrentAptResolver {

    @Autowired
    private IMgmtOfficeService mgmtOfficeService;

    public String resolveAptCmplexNo(Authentication authentication) {

        // 1. 비로그인 / 익명 사용자 방어
        if (authentication == null || authentication instanceof AnonymousAuthenticationToken) {
            return null;
        }

        if (!authentication.isAuthenticated() || "anonymousUser".equals(authentication.getName())) {
            return null;
        }

        String userId = authentication.getName();

        // 2. 관리소장이라면 기존 방식대로 userNo로 관리사무소를 찾은 뒤 단지번호 반환
        boolean isManager = authentication.getAuthorities().stream()
                .anyMatch(auth -> "ROLE_MNGR".equals(auth.getAuthority()));

        if (isManager) {
            MgmtOfficeVO office = mgmtOfficeService.selectMgmtOfficeByManagerUserNo(userId);

            if (office != null) {
                return office.getAptCmplexNo();
            }
        }

        // 3. 관리소장이 아니면 principal 안의 회원정보를 보고 입주민 여부 판단
        Object principal = authentication.getPrincipal();

        if (principal instanceof CustomUser customUser) {
            Object member = customUser.getMember();

            if (member instanceof ResidentVO resident) {
                if (resident.getMyAptList() != null && !resident.getMyAptList().isEmpty()) {
                    return resident.getMyAptList().get(0).getAptCmplexNo();
                }
            }
        }

        log.debug("현재 사용자에게 연결된 aptCmplexNo를 찾지 못함 userId = {}", userId);
        return null;
    }
}
