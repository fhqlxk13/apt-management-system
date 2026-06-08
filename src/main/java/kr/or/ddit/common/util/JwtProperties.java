package kr.or.ddit.common.util;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

@Data
@Component
@ConfigurationProperties("kr.or.ddit.jwt")
public class JwtProperties {
    private String issuer;      // 토큰 발행자
    private String secretKey;   // 서명을 위한 비밀키
}
