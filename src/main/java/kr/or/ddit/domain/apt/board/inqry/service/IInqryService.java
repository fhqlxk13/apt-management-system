package kr.or.ddit.domain.apt.board.inqry.service;

import kr.or.ddit.domain.apt.board.inqry.dto.InqryDTO;

import java.util.List;

public interface IInqryService {

    List<InqryDTO> getList(String userNo, String wrtrId, int startRow, int endRow);

    void insertInqry(InqryDTO dto, String userNo);

    void deleteInqry(String postNo, String userNo, String wrtrId);

    int getTotalCount(String userNo, String wrtrId);

    InqryDTO detail(String postNo, String userNo, String userId);

    void updateInqry(InqryDTO dto, String userNo, String userId);

    InqryDTO detailForAdmin(String postNo);

    void replyInqry(String postNo, String cmtCn, String userNo);
}

