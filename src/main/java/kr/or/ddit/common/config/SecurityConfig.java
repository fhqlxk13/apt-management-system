package kr.or.ddit.common.config;

import jakarta.servlet.DispatcherType;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.common.filter.TokenAuthenticationFilter;
import kr.or.ddit.common.security.CustomAccessDeniedHandler;
import kr.or.ddit.common.security.CustomLoginFailureHandler;
import kr.or.ddit.common.security.CustomLoginSuccessHandler;
import kr.or.ddit.common.security.CustomUserDetailsService;
import kr.or.ddit.common.util.TokenProvider;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.security.autoconfigure.web.servlet.PathRequest;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.annotation.Order;
import org.springframework.http.HttpMethod;
import org.springframework.security.access.hierarchicalroles.RoleHierarchy;
import org.springframework.security.access.hierarchicalroles.RoleHierarchyImpl;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.ProviderManager;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityCustomizer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

/**
 * 스프링 시큐리티 설정
 *
 * @author 이용로
 */
@Slf4j
@Configuration
@EnableWebSecurity
@EnableMethodSecurity
public class SecurityConfig {

    @Autowired
    private CustomUserDetailsService customUserDetailsService;

    @Autowired
    private TokenProvider tokenProvider;

    // 인증객체 없어도(모두가) 접근할 수 있는 URL => JSP페이지
    private static final String[] PASS_URL = {
            "/index.html"
            , "/"
            , "/apt/main"
            , "/login"
            , "/error"
            , "/accessError"
            , "/login.do"
            , "/logout.do"
            , "/member/join.do"
            , "/member/join"
            , "/member/update"
            , "/member/idCheck"
            , "/WEB-INF/views/**"
            , "/main/**"
            , "/resident/board/notice"
            , "/rent/**"
            , "/facility/history.do"
            , "/board/notice/list.do"
            , "/file/display/**"
            , "/file/download/**"
            , "/.well-known/**"
    };

    private static final String[] REACT_PASS_URL = {
            "/react/test"
            ,
    };

    // 테스트용 URL 모음
    private static final String[] TEST_URL = {
            "/ztest/**"
    };

    @Bean
    public CustomLoginSuccessHandler customLoginSuccessHandler(){
        return new CustomLoginSuccessHandler(tokenProvider);
    }

    // 권한 계층 구조 설정 (ex. 최상위 ADMIN은 하위의 모든 권한을 포함(통과)한다)
    @Bean
    public RoleHierarchy roleHierarchy() {
        return RoleHierarchyImpl.withDefaultRolePrefix()    // withDefaultRolePrefix() :: 권한명 앞에 "ROLE_"을 붙여주는 메서드
                .role("ADMIN").implies("MNGR")
                .role("MNGR").implies("RESIDENT")
                .role("RESIDENT").implies("MEMBER")
                .build();
    }

    // WebSecurityCustomizer :: 정적자원 무시 설정 클래스
    @Bean
    public WebSecurityCustomizer configurer() {
        return (web -> web.ignoring()
                .requestMatchers(PathRequest.toStaticResources().atCommonLocations())
                                                        // requestMatchers() :: 괄호 안의 조건을 만족하는 요청을 찾아라
                                                        // toStaticResources() :: 정적 리소스 범주
                                                        // atCommonsLocations() :: 스프링이 정한(약속된) 공통(정적) 자원 위치
                .requestMatchers("/resources/**")     // 중에서 /resources/ 경로에 있는 파일과 모든 깊이의 하위파일들까지 선정
                                                        //.requestMatchers("/ws/**") // 웹소켓 관련 요청 시큐리티 패스
        );
    }

    @Order(value = 1)
    @Bean
    protected SecurityFilterChain jwtFilterChain(HttpSecurity http) throws Exception {
        http.cors(cors -> cors.configurationSource(corsConfigurationSource())); // security config에 등록한 cors정책

        http.csrf(csrf -> csrf.disable());

        http.formLogin(login -> login.disable());

        http.httpBasic(basic -> basic.disable());

        http.headers(config -> config.frameOptions(fOpt -> fOpt.sameOrigin())); // 동일 출처 사이트 내에서만 프레임으로 로딩 가능

        // 세션 사용 비활성화
        http.sessionManagement(
                management -> management.sessionCreationPolicy(SessionCreationPolicy.STATELESS)
        );

        http.securityMatcher("/api/react/**")
                .authorizeHttpRequests(
                        authorize -> authorize
                                .requestMatchers(HttpMethod.OPTIONS, "/**").permitAll()
                                .requestMatchers("/api/react/adm/**").hasRole("ADMIN")  // 중앙관리자만 접근 가능한 URL
                                .requestMatchers("/api/react/public/**").permitAll() // 권한 상관없이 접근 가능
                                .anyRequest().authenticated()
                )
                .exceptionHandling(handler -> handler
                        .authenticationEntryPoint((request, response, authException) ->
                                response.sendError(HttpServletResponse.SC_UNAUTHORIZED)) // 401
                        .accessDeniedHandler((request, response, accessDeniedException) ->
                                response.sendError(HttpServletResponse.SC_FORBIDDEN))    // 403
                );

        http.addFilterBefore(new TokenAuthenticationFilter(tokenProvider)
                                , UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }

    // 스프링 진영의 세션 기반으로 동작할 모든 요청에 대해서 처리할 필터 체인
    @Order(value = 2)
    @Bean
    protected SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http.cors(cors -> cors.configurationSource(corsConfigurationSource())); // security config에 등록한 cors정책
        http.securityMatcher("/**")
                .authorizeHttpRequests(authorize -> authorize
                        .dispatcherTypeMatchers(DispatcherType.FORWARD, DispatcherType.ASYNC).permitAll()
                        /*
                         보통 사용자가 주소창에 직접 치고 들어오는 건 REQUEST 타입인데, 이건 당연히 보안 검사를 함.
                         하지만 FORWARD나 ASYNC는 이미 서버 안에서 일어나는 일이라 굳이 두 번 일 시키지 않으려고 쓰는 설정.
                         */
                        .requestMatchers(PASS_URL).permitAll()
                        .requestMatchers("/ws/**").permitAll()  // websocket 용입니다 by도선호
                        .requestMatchers(TEST_URL).permitAll()  // ⚠️⚠️테스트용 임시 허용 배포시 삭제할 것
                        .anyRequest().authenticated()   // 위의 것들(PASS_URL)을 제외한 모든 리퀘스트는 인증을 거쳐야한다는 설정
                );
        // 권한이 없는 사용자가 접근했을때, 커스텀 규칙으로 처리
        http.exceptionHandling(
                exception -> exception.accessDeniedHandler(new CustomAccessDeniedHandler())
        );
        // 브라우저의 기본로그인 창 비활성화
        http.httpBasic(basic -> basic.disable());

        http.formLogin(login -> login
                .loginPage("/login.do") // 사용자에게 보여줄 '로그인 페이지' 주소 (GET방식)
                .loginProcessingUrl("/login")
                // 실제 로그인을 검증할 폼데이터 수신 (컨트롤러)주소 (POST방식)
                // 시큐리티가 이 주소로 들어오는 데이터를 가로채서 인증을 진행함
                // 따라서 로그인 폼의 <form action="/login"> 과 반드시 일치해야함
                .successHandler(customLoginSuccessHandler())    // 로그인 성공시 후속처리 담당 핸들러
                .failureHandler(new CustomLoginFailureHandler())    // 로그인 실패시 후속처리 담당 핸들러
        );

        http.logout(
                logout -> logout
                        .logoutUrl("/logout")   // 로그아웃을 수행할 컨트롤러 주소
                        .invalidateHttpSession(true)    // 현재 서버에 저장된 사용자의 세션정보 파기
                        .logoutSuccessUrl("/logout.do")    // 로그인 작업이 끝난후 보낼 페이지
                        .deleteCookies("JSESSIONID")    // JSESSIONID 쿠키도 제거
        );

        // JSP구역은 csrf정책 유지
        http.csrf(csrf -> csrf.ignoringRequestMatchers("/api/**"));

        return http.build();
    }

    // cors(크로스오리진) 정책 설정
    @Bean
    public org.springframework.web.cors.CorsConfigurationSource corsConfigurationSource() {
        org.springframework.web.cors.CorsConfiguration config = new org.springframework.web.cors.CorsConfiguration();

        // 1. 리액트 서버의 로컬 및 외부 IP 주소를 모두 허용
        config.setAllowedOriginPatterns(java.util.List.of(
                "http://localhost:7777",
                "http://183.107.218.47:7777",
                "http://192.168.*:7777"
        ));

        // 2. 허용할 HTTP 메서드 설정
        config.setAllowedMethods(java.util.List.of("GET", "POST", "PUT", "DELETE", "OPTIONS"));

        // 3. 모든 헤더 허용 (Authorization 헤더 등을 받기 위해 필요)
        config.setAllowedHeaders(java.util.List.of("*"));

        // 4. 내보낼 헤더 설정 (클라이언트가 토큰을 읽을 수 있게 하려면 필요할 수 있음)
        config.setExposedHeaders(java.util.List.of("Authorization"));

        // 5. 자격 증명 허용 (쿠키 등을 주고받을 때 필수)
        config.setAllowCredentials(true);

        org.springframework.web.cors.UrlBasedCorsConfigurationSource source = new org.springframework.web.cors.UrlBasedCorsConfigurationSource();
            source.registerCorsConfiguration("/**", config); // 모든 경로에 대해 위 설정 적용
        return source;
    }


    // Jwt 시큐리티 인증 시스템 구축의 최종 단계
    @Bean
    protected AuthenticationManager authenticationManager(
        BCryptPasswordEncoder bCryptPasswordEncoder, AuthenticationConfiguration authenticationConfiguration){
        DaoAuthenticationProvider authProvider = new DaoAuthenticationProvider(customUserDetailsService);   // DB에서 정보를가져와서 인증 처리
        authProvider.setPasswordEncoder(bCryptPasswordEncoder); // 암호 해독기 설정(DB의 비밀번호는 암호화 되어있기 때문에 필요)
        return new ProviderManager(authProvider);   // 위 설정을 마친 객체(authProvider)를 authenticationManager로 사용
    }

    @Bean
    protected PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}
