package kr.or.ddit.domain.apt.mgmtOffice.contract.controller;

import com.google.api.services.drive.Drive;
import kr.or.ddit.common.api.google.service.GoogleDriveService;
import kr.or.ddit.common.file.mapper.IAttachFileMapper;
import kr.or.ddit.common.file.vo.AttachFileVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.InputStreamResource;
import org.springframework.core.io.Resource;
import org.springframework.http.ContentDisposition;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.io.InputStream;
import java.nio.charset.StandardCharsets;

/**
 * 계약 첨부파일 Controller
 *
 * 역할
 * - 계약서 첨부파일 미리보기
 * - 계약서 첨부파일 다운로드
 *
 * 기준
 * - ATTACH_FILE.FILE_GROUP_NO + FILE_SAVE_UUID로 파일 조회
 * - ATTACH_FILE.GOOGLE_ID로 Google Drive 파일 스트림 조회
 */
@Slf4j
@Controller
@PreAuthorize("hasRole('MNGR')")
@RequestMapping("/manager/facility/contract/file")
public class FacilityContractFileController {

    @Autowired
    private IAttachFileMapper attachFileMapper;

    @Autowired
    private GoogleDriveService googleDriveService;

    /**
     * 계약 첨부파일 미리보기
     *
     * 사용처
     * - 계약 상세 모달의 [보기] 버튼
     *
     * 처리
     * - 이미지/PDF를 iframe에서 열 수 있도록 inline 응답
     */
    @GetMapping("/view")
    public ResponseEntity<Resource> viewContractFile(
            @RequestParam String fileGroupNo,
            @RequestParam String fileSaveUuid
    ) {
        // inline 응답으로 브라우저/iframe 미리보기 처리
        return makeContractFileResponse(fileGroupNo, fileSaveUuid, "inline");
    }

    /**
     * 계약 첨부파일 다운로드
     *
     * 사용처
     * - 계약 상세 모달의 [다운로드] 버튼
     *
     * 처리
     * - 브라우저에서 바로 열지 않고 다운로드되도록 attachment 응답
     */
    @GetMapping("/download")
    public ResponseEntity<Resource> downloadContractFile(
            @RequestParam String fileGroupNo,
            @RequestParam String fileSaveUuid
    ) {
        // attachment 응답으로 다운로드 처리
        return makeContractFileResponse(fileGroupNo, fileSaveUuid, "attachment");
    }

    /**
     * 계약 첨부파일 응답 공통 처리
     *
     * 처리 순서
     * 1. 필수 파라미터 확인
     * 2. ATTACH_FILE 메타데이터 조회
     * 3. Google Drive 파일 스트림 조회
     * 4. inline 또는 attachment 헤더 세팅
     * 5. 파일 응답 반환
     */
    private ResponseEntity<Resource> makeContractFileResponse(
            String fileGroupNo,
            String fileSaveUuid,
            String disposition
    ) {
        try {
            // 필수 파라미터 검증
            if (fileGroupNo == null || fileGroupNo.isBlank()
                    || fileSaveUuid == null || fileSaveUuid.isBlank()) {
                return ResponseEntity.badRequest().build();
            }

            // 파일 메타데이터 조회
            AttachFileVO attachFile = attachFileMapper.getAttachFile(fileGroupNo, fileSaveUuid);

            // DB에 파일 정보가 없으면 404
            if (attachFile == null) {
                return ResponseEntity.notFound().build();
            }

            // Google Drive 파일 ID가 없으면 404
            if (attachFile.getGoogleId() == null || attachFile.getGoogleId().isBlank()) {
                return ResponseEntity.notFound().build();
            }

            // Google Drive 서비스 객체 생성
            Drive drive = googleDriveService.getDriveService();

            // Google Drive에서 실제 파일 스트림 조회
            InputStream inputStream = drive.files()
                    .get(attachFile.getGoogleId())
                    .setSupportsAllDrives(true)
                    .executeMediaAsInputStream();

            // Spring 응답 Resource 생성
            InputStreamResource resource = new InputStreamResource(inputStream);

            // 원본 파일명 세팅
            String fileName = attachFile.getFileOgName();

            if (fileName == null || fileName.isBlank()) {
                fileName = attachFile.getFileSaveUuid();
            }

            // MIME 타입 세팅
            MediaType mediaType = MediaType.APPLICATION_OCTET_STREAM;

            if (attachFile.getMimeType() != null && !attachFile.getMimeType().isBlank()) {
                mediaType = MediaType.parseMediaType(attachFile.getMimeType());
            }

            // inline / attachment 헤더 세팅
            ContentDisposition contentDisposition = ContentDisposition
                    .builder(disposition)
                    .filename(fileName, StandardCharsets.UTF_8)
                    .build();

            HttpHeaders headers = new HttpHeaders();
            headers.setContentDisposition(contentDisposition);

            // 파일 크기 세팅
            if (attachFile.getFileSize() > 0) {
                headers.setContentLength(attachFile.getFileSize());
            }

            return ResponseEntity.ok()
                    .headers(headers)
                    .contentType(mediaType)
                    .body(resource);

        } catch (Exception e) {
            // 파일 응답 처리 실패 로그
            log.error("계약 첨부파일 응답 처리 오류 fileGroupNo={}, fileSaveUuid={}",
                    fileGroupNo, fileSaveUuid, e);

            return ResponseEntity.internalServerError().build();
        }
    }
}