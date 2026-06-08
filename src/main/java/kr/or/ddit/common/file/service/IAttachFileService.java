package kr.or.ddit.common.file.service;

import kr.or.ddit.common.file.vo.AttachFileVO;

import java.util.List;

public interface IAttachFileService {

    // 단일 파일 메타데이터 세팅
    AttachFileVO setOnlyOneFileMetaData(String fileNo);

    // 묶음 파일 메타데이터 세팅
    List<AttachFileVO> setFileMetaData(String groupNo);

    // 첨부파일 테이블에서 데이터 삭제(구글도 같이 삭제시킴, 구글에 없으면 에러!) by도선호
    void deleteAllByGroupNo(String fileGroupNo);

    // 첨부파일 테이블에서 묶음 파일 중 선택 삭제 by도선호
    void deleteOne(String googleId);

    // 첨부파일 seq 얻는 메서드 by도선호
    long getSeqFileGroupNo();

    // 첨부파일 insert 하는 메서드 by도선호
    int insertAttachFile(AttachFileVO fileVO);
}
