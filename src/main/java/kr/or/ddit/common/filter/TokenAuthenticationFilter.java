package kr.or.ddit.common.filter;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.common.util.TokenProvider;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;


@Slf4j
public class TokenAuthenticationFilter extends OncePerRequestFilter {	// OncePerRequestFilter를 상속받았기에 필터 기능을 하고 하나의 요청당 한번의 필터만 실행

	private final TokenProvider tokenProvider;
	
	private final static String HEADER_AUTHORIZATION = "Authorization";		// 요청 헤더에서 Authorization의 값을 꺼냄
	private final static String TOKEN_PREFIX = "Bearer ";		// 토큰 접두어의 Bearer를 제거하기 위한 변수

	public TokenAuthenticationFilter(TokenProvider tokenProvider) {
		this.tokenProvider = tokenProvider;
	}	// 파라미터로 받은 TokenProvider 객체 멤버필드로 연결
	
	@Override
	protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
			throws ServletException, IOException {
		log.info("# TokenAuthenticationFilter:doFilterInternal->Msg : Filter execution...!");
		String authorizationHeader = request.getHeader(HEADER_AUTHORIZATION);	// 요청헤더의 authorization값을 가져옴
		String token = getAccessToken(authorizationHeader);		// TokenAthenticationFilter의 내부메서드 getAccessToken으로 토큰 값 가져옴
		log.info("###### 추출된 토큰 {}", token);
		
		if(token != null && tokenProvider.validToken(token)) {	// 토큰 값이 유효한지 검사
			log.info("# TokenAuthenticationFilter:doFilterInternal->Msg :This is a valid token");
			log.info("# TokenAuthenticationFilter:doFilterInternal->Token : " + token);
			
			Authentication authentication = tokenProvider.getAuthentication(token);	// 유효하면 authentication에 유저정보와 권한 리스트 가져옴
			SecurityContextHolder.getContext().setAuthentication(authentication);	// 시큐리티컨텍스트 홀더에 저장
		}
		filterChain.doFilter(request, response);	// 다음 필터에 바통 터치
	}

	private String getAccessToken(String authorizationHeader) {
		if(authorizationHeader != null && authorizationHeader.startsWith(TOKEN_PREFIX)) {		// 토큰헤더가 있고 Bearer로 시작한다면
			return authorizationHeader.substring(TOKEN_PREFIX.length());	// "Bearer "를 를 제외한 값을 리턴
		}
		return null;
	}

}
