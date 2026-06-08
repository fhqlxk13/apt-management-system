package kr.or.ddit.domain.apt.mgmtOffice.board.service;

import kr.or.ddit.common.api.google.service.GoogleDriveService;
import kr.or.ddit.domain.apt.mgmtOffice.board.dto.MngrRegidentNoticeDTO;
import kr.or.ddit.domain.apt.mgmtOffice.board.mapper.ImngrRegidentNoticeMapper;
import kr.or.ddit.domain.member.vo.CustomUser;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.multipart.MultipartFile;
import com.google.api.services.drive.Drive;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class MngrRegidentNoticeServiceImpl implements IMngrRegidentNoticeService {

    private final ImngrRegidentNoticeMapper mapper;
    private final GoogleDriveService googleDriveService;

    @Value("${file.upload.path:C:/upload/notice}")
    private String uploadPath;

    @Override
    public int selectNoticeCount(MngrRegidentNoticeDTO dto) {
        return mapper.selectNoticeCount(dto);
    }

    @Override
    public List<MngrRegidentNoticeDTO> selectNoticeList(MngrRegidentNoticeDTO dto) {
        return mapper.selectNoticeList(dto);
    }

    @Override
    public MngrRegidentNoticeDTO selectNoticeDetail(MngrRegidentNoticeDTO dto) {

        /*
         * 1. 공지사항 기본 정보 조회
         */
        MngrRegidentNoticeDTO detail = mapper.selectNoticeDetail(dto);

        /*
         * 2. 첨부파일이 있으면 파일 목록 조회
         */
        if (detail != null
                && detail.getAtchFileId() != null
                && !detail.getAtchFileId().isBlank()) {

            detail.setAttachFileList(
                    mapper.selectNoticeAttachFileList(detail)
            );
        }

        return detail;
    }

    @Override
    @Transactional
    public int insertNotice(
            MngrRegidentNoticeDTO dto,
            MultipartFile[] uploadFiles
    ) throws Exception {

        /*
         * 긴급공지 체크 안 했을 때 기본값 N
         */
        if (dto.getTopFixYn() == null) {
            dto.setTopFixYn("N");
        }

        /*
         * 첨부파일이 있을 때만 파일 업로드 처리
         */
        if (uploadFiles != null
                && uploadFiles.length > 0
                && !uploadFiles[0].isEmpty()) {

            int fileGroupNo = mapper.selectAttachFileGroupNo();

            for (MultipartFile uploadFile : uploadFiles) {

                if (uploadFile == null || uploadFile.isEmpty()) {
                    continue;
                }

                String originalName = uploadFile.getOriginalFilename();
                String uuid = UUID.randomUUID().toString().replace("-", "");

                String ext = "";
                if (originalName != null && originalName.lastIndexOf(".") > -1) {
                    ext = originalName.substring(originalName.lastIndexOf(".") + 1);
                }

                String saveFileName = uuid + "_" + originalName;

                String dbFilePath =
                        "apt/notice/"
                                + dto.getMgmtOfcNo()
                                + "/"
                                + saveFileName;

                String googleId = googleDriveService.uploadFile(
                        uploadFile,
                        "apt/notice/" + dto.getMgmtOfcNo(),
                        saveFileName
                );

                MngrRegidentNoticeDTO fileDTO = new MngrRegidentNoticeDTO();

                fileDTO.setAtchFileId(String.valueOf(fileGroupNo));
                fileDTO.setFileOgName(originalName);
                fileDTO.setFileSaveUuid(uuid);
                fileDTO.setFilePath(dbFilePath);
                fileDTO.setFileExt(ext);
                fileDTO.setFileSize(uploadFile.getSize());
                fileDTO.setMimeType(uploadFile.getContentType());
                fileDTO.setGoogleId(googleId);

                mapper.insertAttachFile(fileDTO);
            }

            /*
             * 공지사항과 첨부파일 그룹 연결
             */
            dto.setAtchFileId(String.valueOf(fileGroupNo));
        }

        return mapper.insertNotice(dto);
    }

    /*
     * 공지사항 수정
     *
     * deleteGoogleIds
     * → 수정 화면에서 삭제 선택한 기존 첨부파일 번호 목록
     */
    @Override
    @Transactional
    public int updateNotice(
            MngrRegidentNoticeDTO dto,
            MultipartFile[] uploadFiles,
            List<String> deleteGoogleIds
    ) throws Exception {

        /*
         * 긴급공지 체크 안 했으면 N으로 저장
         */
        if (dto.getTopFixYn() == null) {
            dto.setTopFixYn("N");
        }

        /*
         * 1. 공지사항 제목/내용/긴급여부 수정
         */
        int result = mapper.updateNotice(dto);

        /*
         * 수정 대상이 없으면 종료
         */
        if (result <= 0) {
            return 0;
        }

        /*
         * 2. 기존 첨부파일 개별 삭제
         *
         * deleteGoogleIds란?
         * → 화면에서 삭제 버튼을 누른 기존 첨부파일의 GOOGLE_ID 목록.
         *
         * 왜 GOOGLE_ID로 삭제?
         * → ATTACH_FILE 테이블에는 파일 1건을 구분하는 FILE_NO 컬럼이 없고,
         *   GOOGLE_ID가 실제 파일 1건을 식별할 수 있는 값이기 때문.
         */
        if (deleteGoogleIds != null && !deleteGoogleIds.isEmpty()) {

            /*
             * Drive란?
             * → 구글 드라이브 API를 실행하는 객체.
             * 왜 여기서 한 번만 생성?
             * → 파일 여러 개 삭제할 때 매번 인증 객체를 만들면 느려지기 때문.
             */
            Drive driveService = googleDriveService.getDriveService();

            for (String googleId : deleteGoogleIds) {

                if (googleId == null || googleId.isBlank()) {
                    continue;
                }

                /*
                 * 구글 드라이브 실제 파일 삭제
                 * 현재 프로젝트에서는 영구삭제가 아니라 휴지통 이동 방식.
                 */
                googleDriveService.moveToTrash(driveService, googleId);

                /*
                 * DB 첨부파일 삭제
                 * 구글 삭제 후 DB를 삭제해야 추적이 쉬움.
                 */
                mapper.deleteAttachFileByGoogleId(googleId);
            }

            MngrRegidentNoticeDTO origin = mapper.selectNoticeDetail(dto);

            if (origin != null
                    && origin.getAtchFileId() != null
                    && !origin.getAtchFileId().isBlank()) {

                int remainFileCount = mapper.selectAttachFileCount(origin.getAtchFileId());

                if (remainFileCount == 0) {
                    mapper.clearNoticeAttachFileId(dto);
                }
            }
        }
//        if (deleteGoogleIds != null && !deleteGoogleIds.isEmpty()) {
//
//            for (String googleId : deleteGoogleIds) {
//
//                if (googleId == null || googleId.isBlank()) {
//                    continue;
//                }
//
//                /*
//                 * Google Drive 실제 파일 삭제
//                 *
//                 * 현재 GoogleDriveService에 deleteFile 메서드가 없어서 주석 처리.
//                 * DB에서 첨부파일 정보가 삭제되면 수정 모달에는 더 이상 보이지 않음.
//                 *
//                 * 나중에 GoogleDriveService에 삭제 메서드를 만들면 다시 연결하면 됨.
//                 */
//                // googleDriveService.deleteFile(googleId);
//
//                /*
//                 * DB 첨부파일 삭제
//                 *
//                 * 왜 필요?
//                 * → 수정 모달은 DB의 ATTACH_FILE 목록을 다시 조회해서 보여주기 때문에,
//                 *   DB에서 삭제되어야 다시 수정 버튼을 눌렀을 때 이미지가 안 보임.
//                 */
//                mapper.deleteAttachFileByGoogleId(googleId);
//
//                /*
//                 * DB 첨부파일 삭제
//                 */
//                mapper.deleteAttachFileByGoogleId(googleId);
//            }
//
//            /*
//             * 삭제 후 현재 공지사항의 첨부파일 그룹에 파일이 하나도 없으면
//             * APT_ANN_BOARD_POST.ATCH_FILE_ID를 NULL로 변경.
//             *
//             * 왜 필요?
//             * → ATCH_FILE_ID가 남아 있으면 목록에서 첨부파일 아이콘이 계속 보일 수 있음.
//             */
//            MngrRegidentNoticeDTO origin = mapper.selectNoticeDetail(dto);
//
//            if (origin != null
//                    && origin.getAtchFileId() != null
//                    && !origin.getAtchFileId().isBlank()) {
//
//                int remainFileCount = mapper.selectAttachFileCount(origin.getAtchFileId());
//
//                if (remainFileCount == 0) {
//                    mapper.clearNoticeAttachFileId(dto);
//                }
//            }
//        }

        /*
         * 3. 새 첨부파일이 있으면 기존 파일 그룹에 추가
         */
        if (uploadFiles != null
                && uploadFiles.length > 0
                && !uploadFiles[0].isEmpty()) {

            MngrRegidentNoticeDTO origin = mapper.selectNoticeDetail(dto);

            String fileGroupNo;

            if (origin == null
                    || origin.getAtchFileId() == null
                    || origin.getAtchFileId().isBlank()) {

                fileGroupNo = String.valueOf(mapper.selectAttachFileGroupNo());

                dto.setAtchFileId(fileGroupNo);
                mapper.updateNoticeAttachFileId(dto);

            } else {
                fileGroupNo = origin.getAtchFileId();
            }

            for (MultipartFile uploadFile : uploadFiles) {

                if (uploadFile == null || uploadFile.isEmpty()) {
                    continue;
                }

                String originalName = uploadFile.getOriginalFilename();
                String uuid = UUID.randomUUID().toString().replace("-", "");

                String ext = "";
                if (originalName != null && originalName.lastIndexOf(".") > -1) {
                    ext = originalName.substring(originalName.lastIndexOf(".") + 1);
                }

                String saveFileName = uuid + "_" + originalName;

                String dbFilePath =
                        "apt/notice/"
                                + dto.getMgmtOfcNo()
                                + "/"
                                + saveFileName;

                String googleId = googleDriveService.uploadFile(
                        uploadFile,
                        "apt/notice/" + dto.getMgmtOfcNo(),
                        saveFileName
                );

                MngrRegidentNoticeDTO fileDTO = new MngrRegidentNoticeDTO();

                fileDTO.setAtchFileId(fileGroupNo);
                fileDTO.setFileOgName(originalName);
                fileDTO.setFileSaveUuid(uuid);
                fileDTO.setFilePath(dbFilePath);
                fileDTO.setFileExt(ext);
                fileDTO.setFileSize(uploadFile.getSize());
                fileDTO.setMimeType(uploadFile.getContentType());
                fileDTO.setGoogleId(googleId);

                mapper.insertAttachFile(fileDTO);
            }
        }

        return result;
    }

//    @Override
//    public int deleteNotice(MngrRegidentNoticeDTO dto) {
//        return mapper.deleteNotice(dto);
//    }

    @Override
    @Transactional
    public int deleteNotice(MngrRegidentNoticeDTO dto) {

        /*
         * 1. 삭제 전 게시글 상세 조회
         * 게시글 삭제 후에는 DEL_YN='Y'가 되어 상세조회가 안 될 수 있음.
         */
        MngrRegidentNoticeDTO origin = mapper.selectNoticeDetail(dto);

        List<MngrRegidentNoticeDTO> attachFileList = null;

        if (origin != null
                && origin.getAtchFileId() != null
                && !origin.getAtchFileId().isBlank()) {

            /*
             * 기존 첨부파일 목록 조회
             */
            attachFileList = mapper.selectNoticeAttachFileList(origin);
        }

        /*
         * 2. 공지사항 삭제 처리
         * 실제 DELETE가 아니라 DEL_YN='Y'로 변경.
         */
        int result = mapper.deleteNotice(dto);

        if (result <= 0) {
            return 0;
        }

        /*
         * 3. 구글 드라이브 첨부파일 삭제 + DB 첨부파일 삭제
         */
        if (attachFileList != null && !attachFileList.isEmpty()) {

            try {
                Drive driveService = googleDriveService.getDriveService();

                for (MngrRegidentNoticeDTO fileDTO : attachFileList) {

                    String googleId = fileDTO.getGoogleId();

                    if (googleId == null || googleId.isBlank()) {
                        continue;
                    }

                    /*
                     * 구글 드라이브 파일 휴지통 이동
                     */
                    googleDriveService.moveToTrash(driveService, googleId);

                    /*
                     * ATTACH_FILE DB 삭제
                     */
                    mapper.deleteAttachFileByGoogleId(googleId);
                }

                /*
                 * 게시글의 첨부파일 그룹 연결 해제
                 */
                mapper.clearNoticeAttachFileId(dto);

            } catch (Exception e) {

                /*
                 * RuntimeException을 던지면 @Transactional 때문에
                 * 공지사항 삭제 DB 처리도 rollback 됨.
                 */
                throw new RuntimeException("구글 드라이브 첨부파일 삭제 중 오류가 발생했습니다.", e);
            }
        }

        return result;
    }

    @Override
    public void addManagerViewModel(
            Model model,
            CustomUser customUser,
            String mgmtOfcNo
    ) {

        String aptCmplexNo = mapper.selectAptCmplexNoByMgmtOfcNo(mgmtOfcNo);
        String boardNo = mapper.selectNoticeBoardNoByAptCmplexNo(aptCmplexNo);

        model.addAttribute("mgmtOfcNo", mgmtOfcNo);
        model.addAttribute("aptCmplexNo", aptCmplexNo);
        model.addAttribute("boardNo", boardNo);
        model.addAttribute("loginUserId", customUser.getMember().getUserId());
    }

    @Override
    @Transactional
    public void setManagerNoticeBaseInfo(
            MngrRegidentNoticeDTO dto,
            CustomUser customUser,
            String mgmtOfcNo
    ) {
        /*
         * 1. 관리사무소 번호로 단지번호 조회
         */
        String aptCmplexNo = mapper.selectAptCmplexNoByMgmtOfcNo(mgmtOfcNo);

        if (aptCmplexNo == null || aptCmplexNo.isBlank()) {
            dto.setAptCmplexNo("");
            dto.setBoardNo("");
            dto.setWrtrId("");
            return;
        }

        /*
         * 2. 공지게시판 기본 데이터 자동 생성
         *
         * APT_BOARD_INSTANCE에 아래 형태로 데이터가 없으면 자동 INSERT됨.
         * BOARD_NO       = {APT_CMPLEX_NO}_notice
         * APT_CMPLEX_NO  = {APT_CMPLEX_NO}
         * BOARD_TY_CD    = NOTICE
         * BOARD_NM       = 공지게시판
         * USE_YN         = Y
         */
        mapper.mergeNoticeBoardInstance(aptCmplexNo);

        /*
         * 3. 생성된 게시판 번호 다시 조회
         */
        String boardNo = mapper.selectNoticeBoardNoByAptCmplexNo(aptCmplexNo);

        /*
         * 4. 작성자명 조회
         */
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("aptCmplexNo", aptCmplexNo);
        paramMap.put("userNo", customUser.getMember().getUserNo());

        String writerName = mapper.selectNoticeWriterName(paramMap);

        /*
         * 5. 공지 등록/수정/삭제에 필요한 기본값 세팅
         */
        dto.setAptCmplexNo(aptCmplexNo);
        dto.setBoardNo(boardNo);
        dto.setWrtrId(writerName);
    }

    @Override
    public MngrRegidentNoticeDTO selectManagerOfficeInfo(String mgmtOfcNo) {

        return mapper.selectManagerOfficeInfo(mgmtOfcNo);
    }
}