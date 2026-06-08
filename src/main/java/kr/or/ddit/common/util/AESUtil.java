package kr.or.ddit.common.util;

import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.security.Principal;
import java.sql.Time;
import java.util.Base64;

import kr.or.ddit.domain.member.vo.CustomUser;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Component;

/**
 주민등록 번호 암호화 유틸 클래스
@author  이용로
Date: 2026-04-24
*/
@Component
public class AESUtil {
    private final String alg = "AES/CBC/PKCS5Padding";
    private final String key = "v9Z2kR8nL4mP7qX1wY5bC3jA6sT0uD4f"; // 32글자 키
    private final String iv = "aafec1c3aafec1c3"; // 16글자 IV

    // 암호화
    public String encrypt(String text) throws Exception {
        Cipher cipher = Cipher.getInstance(alg);
        SecretKeySpec keySpec = new SecretKeySpec(key.getBytes(), "AES");
        IvParameterSpec ivParamSpec = new IvParameterSpec(iv.getBytes());
        cipher.init(Cipher.ENCRYPT_MODE, keySpec, ivParamSpec);

        byte[] encrypted = cipher.doFinal(text.getBytes(StandardCharsets.UTF_8));
        return Base64.getEncoder().encodeToString(encrypted);
    }

    // 복호화
    public String decrypt(String cipherText) throws Exception {
        Cipher cipher = Cipher.getInstance(alg);
        SecretKeySpec keySpec = new SecretKeySpec(key.getBytes(), "AES");
        IvParameterSpec ivParamSpec = new IvParameterSpec(iv.getBytes());
        cipher.init(Cipher.DECRYPT_MODE, keySpec, ivParamSpec);

        byte[] decodedBytes = Base64.getDecoder().decode(cipherText);
        byte[] decrypted = cipher.doFinal(decodedBytes);
        return new String(decrypted, StandardCharsets.UTF_8);
    }
}