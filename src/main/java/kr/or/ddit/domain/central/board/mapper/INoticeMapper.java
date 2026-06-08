package kr.or.ddit.domain.central.board.mapper;

import kr.or.ddit.common.model.PaginationInfoVO;
import kr.or.ddit.domain.central.board.vo.NoticeVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface INoticeMapper {



    NoticeVO selectNoticeDetail(String annNo);

    int getTotalCount();

    List<NoticeVO> selectNoticeListPaging(PaginationInfoVO<NoticeVO> pagingVO);

    void incrementInqCnt(String annNo);
}

