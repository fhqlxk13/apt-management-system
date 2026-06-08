package kr.or.ddit.domain.member.resident.mapper;

import kr.or.ddit.domain.member.resident.dto.ResidentNoticeBoardDTO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface IResidentNoticeBoardMapper {

    int selectResidentBoardNoticeCount(ResidentNoticeBoardDTO searchDTO);

    List<ResidentNoticeBoardDTO> selectResidentBoardNoticeList(ResidentNoticeBoardDTO searchDTO);

    ResidentNoticeBoardDTO selectResidentBoardNoticeDetail(ResidentNoticeBoardDTO searchDTO);

    int updateResidentBoardNoticeInqCnt(ResidentNoticeBoardDTO searchDTO);

    ResidentNoticeBoardDTO selectPrevResidentNotice(ResidentNoticeBoardDTO searchDTO);

    ResidentNoticeBoardDTO selectNextResidentNotice(ResidentNoticeBoardDTO searchDTO);

    /*
     * 입주민 공지사항 첨부파일 목록 조회
     *
     * 왜 List?
     * → 공지사항 1개에 첨부파일이 여러 개일 수 있기 때문.
     */
    List<ResidentNoticeBoardDTO> selectResidentNoticeAttachFileList(ResidentNoticeBoardDTO dto);
}