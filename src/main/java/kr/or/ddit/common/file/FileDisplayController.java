package kr.or.ddit.common.file;

import com.google.api.services.drive.Drive;
import com.google.api.services.drive.model.File;
import com.google.common.net.HttpHeaders;
import kr.or.ddit.common.api.google.service.GoogleDriveService;
import kr.or.ddit.common.file.service.IAttachFileService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.InputStreamResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.util.UriUtils;

import java.io.BufferedInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.security.GeneralSecurityException;

@Slf4j
@Controller
@RequestMapping("/file")
public class FileDisplayController {

    @Autowired
    private GoogleDriveService googleDriveService;

    @Autowired
    IAttachFileService attachFileService;

    /**
     * 구글드라이브 파일 화면 출력 컨트롤러
     * @author 이용로
     */
    @ResponseBody
    @GetMapping("/display/{googleId}")
    public ResponseEntity<Resource> displayFile(@PathVariable String googleId) {
        return serveFile("inline", googleId);
    }

    /**
     * 구글드라이브 파일 다운로드 컨트롤러
     * @author 이용로
     */
    @ResponseBody
    @GetMapping("/download/{googleId}")
    public ResponseEntity<Resource> downloadFile(@PathVariable String googleId) {
        return serveFile("attachment", googleId);
    }

    /**
     * 구글드라이브 파일 스트리밍 메서드
     * @author 이용로
     * @param googleId
     * @return 스트림 통로 객체
     */
    private ResponseEntity<Resource> serveFile(String disposition, @PathVariable String googleId) {
        log.info("serveFile() 실행");
        try {
            // 구글 드라이브 서비스 객체 가져오기
            Drive driveService = googleDriveService.getDriveService();

            File gFile = driveService.files().get(googleId)
                    .setFields("name, mimeType")
                    .execute();

            // 데이터를 InputStream으로 가져오기
            InputStream is = driveService.files().get(googleId).executeMediaAsInputStream();

            // 파일 읽는 통로 생성 : 한번에 가져오는게 아닌 8KB단위(표준 크기)로 가져옴
            BufferedInputStream bis = new BufferedInputStream(is, 65536);
            Resource resource = new InputStreamResource(bis);

            // 한글 파일명 인코딩 처리
            String encodedFileName = UriUtils.encode(gFile.getName(), StandardCharsets.UTF_8);

            return ResponseEntity.ok()
                    .contentType(MediaType.parseMediaType(gFile.getMimeType()))
                    .header(HttpHeaders.CONTENT_DISPOSITION, disposition +"; filename=\"" + encodedFileName + "\"")  // attachment; filename="encodedFileName"
                    .body(resource);

        }catch (IOException | GeneralSecurityException e){  // 파일을 못 찾거나 시큐리티 보안 에러
            e.printStackTrace();
            return ResponseEntity.notFound().build();
        }catch (Exception e){
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
}
