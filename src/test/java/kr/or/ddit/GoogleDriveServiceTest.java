package kr.or.ddit;

import kr.or.ddit.common.api.google.service.GoogleDriveService;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.mock.web.MockMultipartFile;

import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

@SpringBootTest
class GoogleDriveServiceTest {

    @Autowired
    private GoogleDriveService googleDriveService;

    @Test
    @DisplayName("구글 드라이브 파일 업로드 테스트")
    void uploadTest() throws Exception {
        // 1. 가짜 파일(MockFile) 생성 (파일명, 콘텐츠타입, 내용)
        MockMultipartFile mockFile = new MockMultipartFile(
                "file",
                "test_junit.txt",
                "text/plain",
                "JUnit Test Content".getBytes()
        );

        // 2. 서비스 호출
        String resultLink = googleDriveService.uploadFile(mockFile, "test/junit", "test_content");

        // 3. 검증
        System.out.println("업로드된 결과 링크: " + resultLink);

        assertNotNull(resultLink, "결과 링크가 null이면 안 됩니다.");
        assertTrue(!resultLink.isBlank());
    }
}