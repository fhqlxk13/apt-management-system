package kr.or.ddit.domain.apt.mgmtOffice.common.advice;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

import java.util.HashMap;
import java.util.Map;

/**
 * 관리자 영역(Manager)에서 발생하는 예외를 전역적으로 처리하는 어드바이스 클래스
 * basePackages 설정을 통해 kr.or.ddit.domain.member.manager 패키지 하위의 컨트롤러에만 적용됨
 */
@ControllerAdvice(basePackages = "kr.or.ddit.domain.member.manager")
public class ManagerExceptionAdvice {

    /**
     * @ExceptionHandler: 특정 예외가 발생했을 때 실행될 메서드를 지정
     * AccessDeniedException.class: 스프링 시큐리티에서 '권한 거부'가 발생했을 때 호출됨
     */
    @ExceptionHandler(AccessDeniedException.class)
    public Object handleAccessDenied(
            AccessDeniedException e,       // 발생한 예외 객체
            HttpServletRequest request     // 요청 정보가 담긴 객체 (헤더 확인용)
    ) {
        /* [1] 클라이언트의 요청 방식 분석 (헤더 추출) */

        // 클라이언트가 선호하는 응답 타입 (예: text/html, application/json)
        String accept = request.getHeader("Accept");

        // 전송되는 데이터의 타입
        String contentType = request.getHeader("Content-Type");

        // AJAX 요청 여부를 식별하는 표준 헤더 (대부분의 라이브러리에서 XMLHttpRequest 설정)
        String requestedWith = request.getHeader("X-Requested-With");

        /* [2] AJAX 또는 JSON 요청인지 판별하는 로직 */

        // 1. 헤더에 XMLHttpRequest가 포함되어 있는가? (전통적인 AJAX 방식)
        boolean ajax = "XMLHttpRequest".equals(requestedWith);

        // 2. 응답받고자 하는 타입(Accept)에 json이 포함되어 있는가?
        boolean acceptJson = accept != null && accept.contains("application/json");

        // 3. 전송하는 데이터(Content-Type)가 json인가? (비동기 POST 요청 등)
        boolean contentJson = contentType != null && contentType.contains("application/json");

        /* [3] 판별 결과에 따른 분기 처리 */

        // 만약 비동기(AJAX) 요청이거나 JSON 응답을 원하는 요청이라면
        if (ajax || acceptJson || contentJson) {

            // 응답 결과를 담을 Map 객체 생성
            Map<String, Object> result = new HashMap<>();
            result.put("success", false);                                 // 성공 여부: 실패
            result.put("code", "MANAGER_ACCESS_DENIED");                 // 에러 식별 코드
            result.put("message", "관리사무소 권한이 없습니다.");             // 사용자 메시지

            // HTTP 상태 코드 403(FORBIDDEN)과 함께 JSON 형식으로 반환
            // ResponseEntity를 사용하여 HTTP 응답을 세밀하게 제어
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(result);
        }

        /* [4] 일반 브라우저 요청(페이지 이동)일 경우 처리 */

        // 사용자가 주소창에 직접 입력했거나 <a href> 링크 등으로 접근했을 경우
        // 접근 에러 페이지인 "/accessError"로 리다이렉트(재접속) 시킴
        return "redirect:/accessError";
    }
}