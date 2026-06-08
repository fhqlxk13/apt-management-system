package kr.or.ddit.domain.apt.board.ann.mapper;

import kr.or.ddit.domain.apt.board.ann.vo.AptAnnBoardPostVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface IAptAnnBoardPostMapper {

    /**
     * 최신글을 limit만큼 가져오기
     * @author 이용로
     * @param aptCmplexNo
     * @param limit
     * @return AptAnnBoardPostVO List
     */
    List<AptAnnBoardPostVO> selectLatest(@Param("aptCmplexNo") String aptCmplexNo, @Param("limit") int limit);
}
