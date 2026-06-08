package kr.or.ddit;

import org.junit.jupiter.api.Test;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.encrypt.Encryptors;
import org.springframework.security.crypto.encrypt.TextEncryptor;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotEquals;

public class PasswordTest {

    @Test
    void generatePassword() {
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
        String rawPassword = "java"; // 내가 사용할 실제 비밀번호
        String encodedPassword = encoder.encode(rawPassword);
        
        System.out.println("암호화된 비밀번호: " + encodedPassword);
    }

    @Test
    void generatedRRNO(){
        // 아래 둘은 한 번 정해지면 바뀌면 안됨
        String password = "java";   // 암호화 알고리즘 해결 키
        // 매번 달라지게 하는 변수
        String salt = "aafec1c3";   // 16진수의 문자열 사용 권장

        // 암호화 AES 알고리즘 생성
        TextEncryptor encryptor = Encryptors.text(password, salt);

        // 원본 주민번호
        String rawRrn = "010101-4401111";

        // 암호화 수행
        String encryptedRrn = encryptor.encrypt(rawRrn);
        System.out.println("암호화된 주민번호 : " + encryptedRrn);

        // 복호화 수행
        String decryptedRrn = encryptor.decrypt(encryptedRrn);
        System.out.println("복호화된 주민번호 : " + decryptedRrn);

        // 검증
        assertNotEquals(rawRrn, encryptedRrn);   // 원본과 암호문은 달라야 정상
        assertEquals(rawRrn, decryptedRrn);     // 복호화하면 같음
    }
}