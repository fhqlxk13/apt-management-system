package kr.or.ddit.common.file.mapper;

import kr.or.ddit.common.file.vo.AttachFileVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface IAttachFileMapper {

    int insertAttachFile(AttachFileVO attachFile);

    long getSeqFileGroupNo();

    AttachFileVO getAttachFile(@Param("fileGroupNo") String fileGroupNo, @Param("fileSaveUuid") String fileSaveUuid);

    void deleteByFileGroupNo(String fileGroupNo);

    void deleteOne(String googleId);

    List<AttachFileVO> selecAttachFileList(String fileId);
}