package kr.or.ddit.common.api.google.service;

import com.google.api.client.extensions.java6.auth.oauth2.AuthorizationCodeInstalledApp;
import com.google.api.client.extensions.jetty.auth.oauth2.LocalServerReceiver;
import com.google.api.client.auth.oauth2.Credential;
import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeFlow;
import com.google.api.client.googleapis.auth.oauth2.GoogleClientSecrets;
import com.google.api.client.googleapis.javanet.GoogleNetHttpTransport;
import com.google.api.client.http.InputStreamContent;
import com.google.api.client.json.gson.GsonFactory;
import com.google.api.client.util.store.FileDataStoreFactory;
import com.google.api.services.drive.Drive;
import com.google.api.services.drive.DriveScopes;
import com.google.api.services.drive.model.File;
import com.google.api.services.drive.model.FileList;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.security.GeneralSecurityException;
import java.util.Collections;

/*
    @author 이용로
 */

/*
    google drive 파일 메서드 참고문서
    https://developers.google.com/workspace/drive/api/guides/search-files?hl=ko
*/
@Service
public class GoogleDriveService {

    @Value("${google.drive.folder-id}")
    private String folderId;

    // credentials.json 파일 경로 (resources 폴더)
    private static final String CREDENTIALS_FILE_PATH = "/credentials.json";
    // 토큰이 저장될 디렉토리 (프로젝트 루트의 tokens/ 폴더)
    private static final String TOKENS_DIRECTORY_PATH = "tokens";

    /**
     * google drive service 객체 생성 및 반환 메서드
     * @return Drive 객체
     * @throws IOException
     * @throws GeneralSecurityException
     * @author 이용로
     */
    public Drive getDriveService() throws IOException, GeneralSecurityException {
        // 1. OAuth 2.0 사용자 인증을 위한 credentials.json 읽기 (기존 방식)
        ClassPathResource resource = new ClassPathResource("credentials.json");
        try (InputStream in = resource.getInputStream()) {
            if (in == null) {
                throw new IOException("credentials.json 파일을 찾을 수 없습니다.");
            }
            GoogleClientSecrets clientSecrets = GoogleClientSecrets.load(
                    GsonFactory.getDefaultInstance(), new InputStreamReader(in));

            // 2. 토큰 저장소 설정 (로컬 tokens/ 폴더에 StoredCredential 생성)
            FileDataStoreFactory dataStoreFactory = new FileDataStoreFactory(new java.io.File(TOKENS_DIRECTORY_PATH));

            // 3. OAuth 2.0 인증 흐름 설정 (offline으로 설정해야 리프레시 토큰이 발급됨)
            GoogleAuthorizationCodeFlow flow = new GoogleAuthorizationCodeFlow.Builder(
                    GoogleNetHttpTransport.newTrustedTransport(),
                    GsonFactory.getDefaultInstance(),
                    clientSecrets,
                    Collections.singleton(DriveScopes.DRIVE))
                    .setDataStoreFactory(dataStoreFactory)
                    .setAccessType("offline")
                    .build();

            // 4. 로컬 서버 리시버를 통해 브라우저 인증 수행 (사용자 인증 방식)
            LocalServerReceiver receiver = new LocalServerReceiver.Builder().setPort(-1).build();   // -1 포트 : 자동으로 빈포트사용
            Credential credential = new AuthorizationCodeInstalledApp(flow, receiver).authorize("user");

            // 5. Drive 서비스 객체 반환
            return new Drive.Builder(
                    GoogleNetHttpTransport.newTrustedTransport(),
                    GsonFactory.getDefaultInstance(),
                    credential)
                    .setApplicationName("StevenZips")
                    .build();
        }
    }

    /**
     * 파일 업로드 메서드
     *
     * @param file          저장할 파일vo 객체
     * @param path          파일을 저장할 *폴더*의 전체 경로 (ex. member/prof_img/파일.txt면 member/prof_img까지 마자막 '/'와 파일명은 제거한다)
     * @param savedFileName uuid_name 형식의 저장 될 파일명 (*주의 uuid는 '-'를 제거)
     * @return googleId 구글 드라이브에서 업로드 한 파일에 발급한 식별코드
     * @throws IOException
     * @author 이용로
     */
    public String uploadFile(MultipartFile file, String path, String savedFileName) throws IOException {
        try {
            Drive service = this.getDriveService();

            // 1. mkdirs() 로직 메서드인 getOrCreateFolders 실행 (하위 폴더 생성 및 최종 폴더 ID 추출)
            String targetFolderId = getOrCreateFolders(service, folderId, path);

            // 2. 파일 메타데이터 설정 (부모 폴더를 targetFolderId로 지정)
            File fileMetadata = new File();
            fileMetadata.setName(savedFileName);
            fileMetadata.setParents(Collections.singletonList(targetFolderId));

            InputStreamContent mediaContent = new InputStreamContent(
                    file.getContentType(),
                    file.getInputStream()
            );

            // 3. 파일 업로드 및 ID 가져오기
            File uploadedFile = service.files().create(fileMetadata, mediaContent)
                    .setSupportsAllDrives(true)
                    .setFields("id") // webViewLink 대신 id(googleId)만 받아도 충분
                    .execute();

            return uploadedFile.getId();

        } catch (Exception e) {
            e.printStackTrace();
            throw new IOException("구글 업로드 에러: " + e.getMessage());
        }
    }

    /**
     * mkdirs() 처럼 동작하는 폴더(경로) 탐색 메서드
     *
     * @param service 사용할 google drive 서비스 객체
     * @param rootId  탐색을 시작할 최초(최상위) 폴더 이름
     * @param path    파일을 저장할 경로
     * @return currentParentId 최종 생성된 폴더명
     * @throws IOException
     * @author 이용로
     * @query name 찾고자 하는 콘텐츠 명
     * @query mimeType 데이터 타입 'application/vnd.google-apps.folder', 'image/jpeg'
     * @query 'folder' in parents 'folder'컬렉션(폴더) 내 파일 (ex. myFolder 내 파일 => 'myFolder' in parents)
     */
    private synchronized String getOrCreateFolders(Drive service, String rootId, String path) throws IOException {
        String[] folderNames = path.split("/"); // '/'로 구분된 각 경로 분리
        String currentParentId = rootId;
        String targetType = "application/vnd.google-apps.folder";

        // 구분된 각 경로에 대해서 검사
        for (String name : folderNames) {
            if (name.trim().isEmpty()) continue;

            String query = String.format(
                    "name = '%s' and " +    // 찾을 폴더명
                            "mimeType = '%s' and " +   // targetType
                            "'%s' in parents and " +    // currentParentId
                            "trashed = false ",    // 휴지통에 있는 폴더 제외
                    name, targetType, currentParentId);

            FileList result = service.files().list().   // 파일 목록 조회 메서드
                    setQ(query)   // 쿼리로 조건 필터링
                    .setSupportsAllDrives(true)
                    .setIncludeItemsFromAllDrives(true)
                    .setFields("files(id)")
                    .execute();   // 찾은 파일들 중에서 파일 아이디만 가져오기(속도 및 효율성)

            if (!result.getFiles().isEmpty()) {
                // 찾은게 있으면 해당 ID로 이동
                currentParentId = result.getFiles().get(0).getId();
            } else {
                // 없으면 생성 후 그 ID로 이동
                File folderMetadata = new File();
                folderMetadata.setName(name);
                folderMetadata.setMimeType("application/vnd.google-apps.folder");   // 폴더 타입으로 생성
                folderMetadata.setParents(Collections.singletonList(currentParentId));  // 현재 생성하는 폴더의 부모(상위)폴더 설정

                File folder = service.files().create(folderMetadata)
                        .setSupportsAllDrives(true)
                        .setFields("id")
                        .execute();

                currentParentId = folder.getId();
            }
        }
        return currentParentId; // 매개변수 path로 받은 경로의 최종목적지 폴더 위치 값
    }

    /**
     * 전체 경로를 통해 타겟 파일 찾기 (googleId를 모를때)
     *
     * @param service  사용할 google drive 서비스 객체
     * @param rootId   탐색을 시작할 최초(최상위) 폴더 이름
     * @param fullPath 파일명까지 포함한 전체 경로(attach_file테이블의 file_path)
     * @return googleId 구글 파일 아이디 값
     * @throws IOException
     * @author 이용로
     */
    public String getFileIdByPath(Drive service, String rootId, String fullPath) throws IOException {
        int lastSlash = fullPath.lastIndexOf("/");

        String pathParts = "";
        String targetName = fullPath;
        if (lastSlash != -1) {
            pathParts = fullPath.substring(0, lastSlash);
            targetName = fullPath.substring(lastSlash + 1);   // file.img
        }

        String currentParentId = rootId;
        String targetType = "application/vnd.google-apps.folder";
        FileList result = null;

        if (!pathParts.isEmpty()) {
            String[] folderNames = pathParts.split("/");
            for (String name : folderNames) {
                if (name.trim().isEmpty()) continue;

                String query = String.format(
                        "name = '%s' and " +    // 찾을 폴더명
                                "mimeType = '%s' and " +   // targetType
                                "'%s' in parents and " +    // currentParentId
                                "trashed = false ",    // 휴지통에 있는 폴더 제외
                        name, targetType, currentParentId);
                result = service.files().list().
                        setQ(query).
                        setSupportsAllDrives(true).
                        setIncludeItemsFromAllDrives(true).
                        setFields(("files(id)")).
                        execute();

                if (result.getFiles().isEmpty()) return null; // 부모 폴더가 없으면 중단

                // 탐색된 게 있으면 부모폴더로 갱신
                currentParentId = result.getFiles().get(0).getId();
            }
        }
        // 최종 폴더 경로에서 파일 찾을 쿼리 세팅
        String fileQuery = String.format(
                "name = '%s' and " +
                        "mimeType != 'application/vnd.google-apps.folder' and " +
                        "'%s' in parents and " +
                        "trashed = false",
                targetName, currentParentId);

        result = service.files().list()
                .setQ(fileQuery)
                .setSupportsAllDrives(true)
                .setIncludeItemsFromAllDrives(true)
                .setFields("files(id)")
                .execute();

        if (result.getFiles() != null && !result.getFiles().isEmpty()) {
            return result.getFiles().get(0).getId();    // 파일 찾으면 구글id 문자열 반환
        }

        return null;    // 최종적으로 파일이 없으면 null 반환
    }

    /**
     * 파일 구글아이디로 업로드 파일 삭제 (휴지통 이동)
     * @param service
     * @param googleId
     * @author 이용로
     */
    public void moveToTrash(Drive service, String googleId) throws IOException {
//        File target = new File();
//        target.setTrashed(true);
//        service.files().update(googleId, target).setSupportsAllDrives(true).execute();   // 영구삭제 update()=>delete(googleId)
    }

}