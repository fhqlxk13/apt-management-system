package kr.or.ddit.common.file.service;

import com.google.api.services.drive.Drive;
import kr.or.ddit.common.api.google.service.GoogleDriveService;
import kr.or.ddit.common.file.mapper.IAttachFileMapper;
import kr.or.ddit.common.file.vo.AttachFileVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @author 이용로
 */
@Slf4j
@Service
public class AttachFileServiceImpl implements IAttachFileService {

    @Autowired
    private IAttachFileMapper attachFileMapper;

    @Autowired
    private GoogleDriveService googleDriveService;

    /**
     * 타겟 파일 메타데이터 세팅 구버전 setFileMetaData 쓸 것 권장
     *
     * @param fileId - target(FILE_GROUP_NO + "_" + SAVE_FILE_UUID)
     * @return (AttachFileVO)file
     * @author 이용로
     */
    @Override
    public AttachFileVO setOnlyOneFileMetaData(String fileId) {

        if (fileId == null || fileId.isBlank()) return null;

        try {
            String fileGroupNo = fileId.split("_")[0];
            String fileSaveUuid = fileId.split("_", 2)[1];   // limit 총 몇개로 나눌지
            log.info("** 파일그룹번호 : {}, 파일저장명 : {}", fileGroupNo, fileSaveUuid);
            AttachFileVO file = attachFileMapper.getAttachFile(fileGroupNo, fileSaveUuid);
            log.info("파일 있음? {}", file);
            return file;
        } catch (IndexOutOfBoundsException e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * 타겟 파일(or 파일리스트) 메타데이터 세팅
     * 단일 파일도 List(.of())로 넘김
     *
     * @param fileNo
     * @return List<AttachFileVO>
     * @author 이용로
     */
    @Override
    public List<AttachFileVO> setFileMetaData(String fileNo) {
        if (fileNo == null || fileNo.isBlank()) return null;

        if (fileNo.contains("_")) {
            // '_'가 맨앞에 있는 경우 방어
            String[] parts = fileNo.split("_", 2);
            if (parts.length < 2) return null;

            String fileGroupNo = parts[0];
            String fileSaveUuid = parts[1];   // limit 총 몇개로 나눌지
            log.info("** 찾을 파일그룹번호 : {}, 파일저장명 : {}", fileGroupNo, fileSaveUuid);

            AttachFileVO file = attachFileMapper.getAttachFile(fileGroupNo, fileSaveUuid);

            return (file != null) ? List.of(file) : null;
        } else {
            log.info("** 찾을 파일그룹번호 : {}", fileNo);
            List<AttachFileVO> fileList = attachFileMapper.selecAttachFileList(fileNo);
            log.info("찾은 파일 갯수 : {}", fileList.size());
            return (fileList == null || fileList.isEmpty()) ? null : fileList;
        }
    }

    /**
     * fileGroupNo 가 같은 첨부파일 테이블 데이터 전부 삭제!
     *
     * @param fileNo 각 테이블에 적혀있는 fileNo를 적을것!
     * @author 도선호
     */
    @Override
    public void deleteAllByGroupNo(String fileNo) {
        String fileGroupNo = fileNo;

        if (fileNo == null || fileNo.isBlank()) return;

        if (fileNo.contains("_")) {
            // '_'가 맨앞에 있는 경우 방어
            String[] parts = fileNo.split("_", 2);
            if (parts.length < 2) return;

            fileGroupNo = parts[0];
            String fileSaveUuid = parts[1];   // limit 총 몇개로 나눌지
            AttachFileVO file = attachFileMapper.getAttachFile(fileGroupNo, fileSaveUuid);

            try {
                Drive drive = googleDriveService.getDriveService();

                if (file.getGoogleId() != null) {
                    googleDriveService.moveToTrash(drive, file.getGoogleId());
                }
            } catch (Exception e) {
                throw new RuntimeException("구글 파일 삭제 실패", e);
            }

        } else {
            List<AttachFileVO> fileList = attachFileMapper.selecAttachFileList(fileNo);

            try {
                var drive = googleDriveService.getDriveService();

                for (AttachFileVO file : fileList) {
                    if (file.getGoogleId() != null) {
                        googleDriveService.moveToTrash(drive, file.getGoogleId());
                    }
                }
            } catch (Exception e) {
                throw new RuntimeException("구글 파일 삭제 실패", e);
            }
        }
        attachFileMapper.deleteByFileGroupNo(fileGroupNo);
    }

    /**
     * fileGroupNo 중에 여러 파일이 있을 경우 선택한 파일 삭제!
     * 테이블과 구글 같이 삭제되는 메서드입니다!
     *
     * @param googleId
     * @author 도선호
     */
    @Override
    public void deleteOne(String googleId) {

        try {
            Drive drive = googleDriveService.getDriveService();
//            googleDriveService.moveToTrash(drive, googleId);

        } catch (Exception e) {
            throw new RuntimeException("구글 파일 삭제 실패", e);
        }

        attachFileMapper.deleteOne(googleId);
    }

    /**
     * attachFileGroupNo 얻는 메서드
     *
     * @return
     * @author 도선호
     */
    @Override
    public long getSeqFileGroupNo() {
        return attachFileMapper.getSeqFileGroupNo();
    }

    /**
     * 첨부파일정보 db에 insert 하는 메서드
     *
     * @param fileVO
     * @author 도선호
     */
    @Override
    public int insertAttachFile(AttachFileVO fileVO) {
        return attachFileMapper.insertAttachFile(fileVO);
    }

}
