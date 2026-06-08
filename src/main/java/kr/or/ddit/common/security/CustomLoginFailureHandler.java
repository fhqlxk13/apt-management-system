package kr.or.ddit.common.security;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;

import java.io.IOException;

@Slf4j
public class CustomLoginFailureHandler implements AuthenticationFailureHandler {
	
	@Override
	public void onAuthenticationFailure(HttpServletRequest request, HttpServletResponse response,
                                        AuthenticationException exception) throws IOException, ServletException {
		log.info("## CustomLoginFailureHandler::onAuthenticationFailure_ : " + exception.getMessage());
		request.getSession().setAttribute("errorMessage", "아이디 또는 비밀번호가 틀렸습니다.");
		response.sendRedirect("/login.do?error=true");
	}

}
