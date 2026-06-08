package kr.or.ddit.domain.member.resident.service;

import kr.or.ddit.domain.member.resident.dto.ResidentNoticeBoardDTO;

import java.util.List;

public interface IResidentNoticeBoardService {

    int selectResidentBoardNoticeCount(ResidentNoticeBoardDTO searchDTO);

    List<ResidentNoticeBoardDTO> selectResidentBoardNoticeList(ResidentNoticeBoardDTO searchDTO);

    ResidentNoticeBoardDTO selectResidentBoardNoticeDetail(ResidentNoticeBoardDTO searchDTO);

    ResidentNoticeBoardDTO selectPrevResidentNotice(ResidentNoticeBoardDTO searchDTO);

    ResidentNoticeBoardDTO selectNextResidentNotice(ResidentNoticeBoardDTO searchDTO);
}