package kr.or.ddit.common.security;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.or.ddit.common.util.TokenProvider;
import kr.or.ddit.domain.member.vo.CustomUser;
import kr.or.ddit.domain.member.vo.MemberVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.annotation.Bean;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.web.WebAttributes;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.security.web.savedrequest.HttpSessionRequestCache;
import org.springframework.security.web.savedrequest.RequestCache;
import org.springframework.security.web.savedrequest.SavedRequest;

import java.io.IOException;
import java.util.Collection;
import java.util.Date;
import java.util.Iterator;

@Slf4j
public class CustomLoginSuccessHandler implements AuthenticationSuccessHandler {

	private final RequestCache requestCache = new HttpSessionRequestCache();

	private final TokenProvider tokenProvider;

	public CustomLoginSuccessHandler(TokenProvider tokenProvider) {
		this.tokenProvider = tokenProvider;
	}

	@Override
	public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
											Authentication authentication) throws IOException, ServletException {
		log.info("## CustomLoginSuccessHandler.onAuthenticationSuccess() 실행...!");

		CustomUser customUser = (CustomUser) authentication.getPrincipal();
		MemberVO member = customUser.getMember();

		// JWT 토큰 생성
		long expiredTime = 1000 * 60 * 60 * 1;	// 토큰 만료시간 설정 : 1시간
		Date expiry = new Date(System.currentTimeMillis() + expiredTime);	// 현재시간으로부터 +1시간 까지
		String accessToken = tokenProvider.makeToken(expiry, member);
		log.info("## 발급된 토큰 {}", accessToken);

		// 리액트 접근용 쿠키 생성
		Cookie jwtCookie = new Cookie("JWT", accessToken);
		jwtCookie.setPath("/");
		jwtCookie.setHttpOnly(false);
		jwtCookie.setMaxAge(60 * 60 * 1);
		response.addCookie(jwtCookie);

		// 시큐리티 활성화된 사용자인지 체크
		if(customUser.isEnabled()) {
			log.info("## username : {}", customUser.getUsername());	// 인증된 사용자 아이디
			log.info("## password : {}", customUser.getPassword());	// 인증된 사용자 비밀번호
			Collection<GrantedAuthority> grantedAuthority = customUser.getAuthorities();
		 	Iterator<GrantedAuthority> ite_authority = grantedAuthority.iterator();
		 	while(ite_authority.hasNext()) {
		 		GrantedAuthority authority = ite_authority.next();
		 		log.info("## auth : {}", authority.getAuthority());	// 인증된 사용자 권한
		 	}
		}
		
		SavedRequest savedRequest = requestCache.getRequest(request, response);
		String targetUrl = "/";	// 기본 default target은 root

		if(savedRequest != null) {
			String redirectUrl = savedRequest.getRedirectUrl();

			if(redirectUrl != null
					&& (redirectUrl.contains("accessError") || redirectUrl.contains("error"))) {
				targetUrl = "/";
			}
		}
		log.info("## Login Success target URL : " + targetUrl);

		// SPRING_SECURITY_EXCEPTION으로 등록된 에러 정보를 삭제
		clearAuthenticationAttribute(request);
		response.sendRedirect(targetUrl);
	}

	private void clearAuthenticationAttribute(HttpServletRequest request) {

		// session 정보가 존재한다면 현재 session을 반환하고 존재하지 않으면 null을 반환합니다.
		HttpSession session = request.getSession(false);
		if(session == null) {
			return;
		}
		
		// SPRING_SECURITY_LAST_EXCEPTION 값
		session.removeAttribute(WebAttributes.AUTHENTICATION_EXCEPTION);
	}

}