package kr.or.ddit.common.util;

import io.jsonwebtoken.*;
import kr.or.ddit.common.security.CustomUserDetailsService;
import kr.or.ddit.domain.member.vo.CustomUser;
import kr.or.ddit.domain.member.vo.MemberVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;

import java.time.Duration;
import java.util.Date;
import java.util.stream.Collectors;

@Slf4j
@Component
public class TokenProvider {

    @Autowired
    private JwtProperties jwtProperties;

    @Autowired
    private CustomUserDetailsService customUserDetailsService;

    public String generateToken(MemberVO memberVO, Duration expiredAt){
        Date now = new Date();

        // 토큰 생성시, 현재시간 + 설정시간을 더한 기간으로 토큰을 생성한다.
        return makeToken(new Date(now.getTime() + expiredAt.toMillis()), memberVO);
    }

    /**
     *
     * @param expiry 만료시간
     * @param memberVO 유저 정보
     * @return
     */
    public String makeToken(Date expiry, MemberVO memberVO){
        Date now = new Date();
        return Jwts.builder()
                .setHeaderParam(Header.TYPE, Header.JWT_TYPE)   // 헤더
                // 공용설정
                .setIssuer(jwtProperties.getIssuer())
                .setIssuedAt(now)
                .setExpiration(expiry)
                .setSubject(memberVO.getUserNo())
                // 개인설정
                .claim("no", memberVO.getUserNo())
                .claim("id", memberVO.getUserId())
                .claim("auth", memberVO.getAuthList())
                // 서명 : 비밀키와 함께 해시값을 HS256방식으로 암호화한다.
                .signWith(SignatureAlgorithm.HS256, jwtProperties.getSecretKey().getBytes())
                .compact();
    }

    public boolean validToken(String token){
        Jws<Claims> parseToken = null;
        try{
            parseToken = Jwts.parser().setSigningKey(jwtProperties.getSecretKey().getBytes())
                    .parseClaimsJws(token);
        }catch (Exception e){
            return false;
        }

        log.info("# 토큰 만료기간 : " + parseToken.getBody().getExpiration());
        Date exp = parseToken.getBody().getExpiration();

        // 만료기한과 오늘 날짜를 비교한다.
        // 만료기한이 오늘 날짜를 기준으로 전인지를 비교
        // 만료기한이 현재 날짜보다 전이면 만료 (true -> false)
        // 만료기한이 현재 날짜보다 후이면 유효 (false -> true)
        return !exp.before(new Date());
    }
    /*
     * 3. 토큰 기반으로 인증 정보를 가져오는 메소드
     * - 토큰을 받아 인증 정보를 담은 객체 Authentication을 반환하는 메서드이다.
     * - 프로퍼티스 파일에 저장한 비밀값으로 토큰을 복호화한 뒤 클레임을 가져오는 private 메소드인 getClaims()를 호출해서 클레임 정보를 반환받아
     *   사용자 아이디가 들어있는 토큰 제목 sub와 토큰 기반으로 인증 정보를 생성한다.
     *   이때, UsernamePasswordAuthenticationToken의 첫 인자로 들어가는 UserDetails는 스프링 시큐리티에서 제공하는 객체인 User 클래스를 임포트한다.
     */
    public Authentication getAuthentication(String token) {
        String userId = getUserId(token);
        UserDetails userDetails = customUserDetailsService.loadUserByUsername(userId);
        MemberVO member = ((CustomUser)userDetails).getMember();
        return new UsernamePasswordAuthenticationToken(userDetails,"",
                member.getAuthList().stream().map(auth -> new SimpleGrantedAuthority(auth.getAuth())).collect(Collectors.toList()));
                // member의 AutLhist를 stream()통로로 받아서 auth를 하나씩 SimpleGrantedAuthority(시큐리티 전용 객체)로 변한해 모두 모으고  리스트로 재구성한다
    }

    public String getUserId(String token) {
        Claims claims = getClaims(token);
        return claims.get("id", String.class);
    }

    private Claims getClaims(String token) {
        return Jwts.parser()
                .setSigningKey(jwtProperties.getSecretKey().getBytes())
                .parseClaimsJws(token)
                .getBody();
    }
}
