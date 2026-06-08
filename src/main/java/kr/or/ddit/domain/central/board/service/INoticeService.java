package kr.or.ddit.domain.central.board.service;

import kr.or.ddit.common.model.PaginationInfoVO;
import kr.or.ddit.domain.central.board.vo.NoticeVO;

import java.util.List;

public interface INoticeService {


    NoticeVO getNoticeDetail(String annNo);

    int getTotalCount();

    List<NoticeVO> getNoticeList(PaginationInfoVO<NoticeVO> pagingVO);

    void incrementInqCnt(String annNo);
}
