package kr.or.ddit.common.file.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.web.multipart.MultipartFile;

import java.util.Date;


@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AttachFileVO {
    private long fileGroupNo;
    private String cat;
    private String fileSaveUuid;
    private String fileOgName;
    private String filePath;
    private String fileExt;
    private long fileSize;
    private String mimeType;
    private Date regDt;
    private Date mdfDt;
    private int fileSortOrder;
    private int downCnt;
    private String googleId;

    /**
     * 파일객체 메타데이터 정보 세팅
     * @param file 파일 객체
     * @param fileGroupNo   attach_file 테이블의 file_group_no 컬럼에 해당하는 값
     * @param cat            attach_file 테이블의 cat 컬럼에 해당하는 값
     * @param fileSaveUuid  attach_file 테이블의 fileSaveUuid 컬럼에 해당하는 값
     * @param googleId      구글드라이브에서 발급한 파일 식별 번호
     * @param path          저장된 uuid파일명까지 포함한 전체경로  (ex.member/profile/img/pic.jpg)
     * @param fileSortOrder  파일 우선순위(노출순서)
     * @return
     */
    public static AttachFileVO fileSettings(MultipartFile file, long fileGroupNo, String cat, String fileSaveUuid,
                                    String googleId, String path, int fileSortOrder) {
        String originalFilename = file.getOriginalFilename();
        String ext = "";
        if (originalFilename != null && originalFilename.contains(".")) {
            ext = originalFilename.substring(originalFilename.lastIndexOf(".") + 1);
        }

        return AttachFileVO.builder()
                .fileGroupNo(fileGroupNo)
                .cat(cat)
                .fileOgName(originalFilename)
                .fileSaveUuid(fileSaveUuid)
                .fileExt(ext)
                .fileSize(file.getSize())
                .mimeType(file.getContentType())
                .googleId(googleId)
                .filePath(path)
                .fileSortOrder(fileSortOrder)
                .build();
    }
}
