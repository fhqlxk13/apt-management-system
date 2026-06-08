package kr.or.ddit;

import kr.or.ddit.common.api.google.service.GoogleDriveService;
import kr.or.ddit.common.file.mapper.IAttachFileMapper;
import kr.or.ddit.common.file.vo.AttachFileVO;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.mock.web.MockMultipartFile;

import java.util.UUID;

@SpringBootTest
@Slf4j
class ProfileUploadSimpleTest {

    @Autowired
    private GoogleDriveService googleDriveService;

    @Autowired
    private IAttachFileMapper attachFileMapper;

    @Test
    @DisplayName("순수 프로필 업로드 및 DB 기록 시연")
    void uploadDemonstration() throws Exception {
        // 1. 테스트 데이터 준비
        String testUserId = "Lyr"; // 팀원들에게 보여줄 테스트 아이디
        MockMultipartFile testFile = new MockMultipartFile(
                "profFile",
                "test_image.jpg",
                "image/jpeg",
                "Hello Team!".getBytes()
        );

        // 2. 파일명 및 경로 생성 (로직 시연)
        String uuid = UUID.randomUUID().toString().replace("-", "");
        String savedFileName = uuid + "_" + testFile.getOriginalFilename();
        String folderPath = "test/junit/" + testUserId;     // 동적으로 폴더를 만들고 싶다면 ex.testUserId
        String cat = "upload_test";                         // 카테고리 (공통코드)

        // 3. 구글 업로드 실행
        String googleId = googleDriveService.uploadFile(testFile, folderPath, savedFileName);

        // 4. DB 시퀀스 채번 및 VO 생성
        long seq = attachFileMapper.getSeqFileGroupNo();
        AttachFileVO attachFile = AttachFileVO.fileSettings(
                testFile, seq, cat, savedFileName, googleId, folderPath, 1
        );

//        // 5. DB 저장
//         int result = attachFileMapper.insertAttachFile(attachFile);
//
//        // 6. 결과 확인
//        if(result > 0) {
//            log.info("✅ 시연 성공! 구글 드라이브와 ATTACH_FILE 테이블을 확인하세요.");
//            log.info("🔗 최종 연결 ID (Member에 들어갈 값): {}_{}", seq, savedFileName);
//        }
    }
}