package kr.or.ddit.domain.apt.main.vo;

import kr.or.ddit.common.file.vo.AttachFileVO;
import lombok.Data;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

/**
 * 단지 기본정보 관리에서 사용하는 DTO 모음
 */
@Data
public class ComplexEditDTO {

        @Data
        public static class DetailResponse {

                /* 단지 기본 정보 */
                private AptComplexVO complex;

                /* 배치도 */
                private List<AttachFileVO> layoutFiles;

                /* 단지 사진 */
                private List<AttachFileVO> complexFiles;
        }

        @Data
        public static class SaveRequest extends AptComplexVO {

                private List<MultipartFile> layoutFiles;

                private List<MultipartFile> complexImgFiles;

                private String layoutSortOrder;

                private String complexSortOrder;

                /* 이미지 수정이 되었나 확인하는 부분*/
                private String isImageChanged;
        }

        @Data
        public static class FileSortOrderDTO {

                private String fileKey;

                private String fileType;

                private String fileSaveUuid;

                private Integer fileSortOrder;
        }
}