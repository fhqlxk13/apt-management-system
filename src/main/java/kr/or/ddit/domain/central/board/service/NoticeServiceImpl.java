package kr.or.ddit.domain.central.board.service;

import kr.or.ddit.common.model.PaginationInfoVO;
import kr.or.ddit.domain.central.board.mapper.INoticeMapper;
import kr.or.ddit.domain.central.board.vo.NoticeVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Slf4j
@Service
public class NoticeServiceImpl  implements INoticeService {

    @Autowired
    private INoticeMapper noticeMapper;



    @Override
    public NoticeVO getNoticeDetail(String annNo) {
        return noticeMapper.selectNoticeDetail(annNo);
    }

    @Override
    public int getTotalCount() {
        return noticeMapper.getTotalCount();
    }

    @Override
    public List<NoticeVO> getNoticeList(PaginationInfoVO<NoticeVO> pagingVO) {
        return noticeMapper.selectNoticeListPaging(pagingVO);
    }

    @Override
    public void incrementInqCnt(String annNo) {
        noticeMapper.incrementInqCnt(annNo);
    }
}
