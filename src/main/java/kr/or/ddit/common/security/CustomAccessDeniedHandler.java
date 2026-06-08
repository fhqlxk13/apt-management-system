package kr.or.ddit.common.security;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.web.access.AccessDeniedHandler;
import org.springframework.web.util.UriUtils;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.Principal;

@Slf4j
public class CustomAccessDeniedHandler implements AccessDeniedHandler {

    // 사용자가 정의한 접근 거부 처리자
    @Override
    public void handle(HttpServletRequest request, HttpServletResponse response,
                       AccessDeniedException accessDeniedException) throws IOException, ServletException {
        log.info("## CustomAccessDeniedHandler.handle() 실행...!");
        log.info("## AccessDeniedException info -------------------");

        Principal principal = request.getUserPrincipal();

        if(principal != null){
            // 현재 로그인한 사용자의 ID
            String username = principal.getName();

            String userLevel = "UNKNOWN";   // 방어코드, 디버깅용
            if (request.isUserInRole("ROLE_ADMIN")) userLevel = "ADMIN";
            else if (request.isUserInRole("ROLE_MNGR")) userLevel = "MNGR";
            else if (request.isUserInRole("ROLE_RESIDENT")) userLevel = "RESIDENT";
            else if (request.isUserInRole("ROLE_MEMBER")) userLevel = "MEMBER";
            log.info("## 접속자 ID : [{}] / 권한 : [{}]", username, userLevel);
        }

        String prevPage = request.getHeader("Referer");  // HttpServletRequest의 헤더에 기본적으로 Referer가 담겨서 옴
        if(prevPage == null || prevPage.isEmpty()){
            prevPage = "/"; // 이전페이지가 없으면 메인페이지로
        }

        String msg = "잘못된 접근 권한 입니다.";
        String encodedMsg = UriUtils.encode(msg, StandardCharsets.UTF_8);
        String encodedPrevPage = UriUtils.encode(prevPage, StandardCharsets.UTF_8);

        log.info("## AccessDenied: {} -> /accessError", prevPage);
        log.info(accessDeniedException.getMessage());

        // "/accessError"로 감 msg 와 이전페이지 주소 달고
        response.sendRedirect("/accessError?msg=" + encodedMsg + "&prevPage=" + encodedPrevPage);
    }
}
