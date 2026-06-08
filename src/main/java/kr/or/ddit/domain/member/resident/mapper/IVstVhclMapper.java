package kr.or.ddit.domain.member.resident.mapper;

import kr.or.ddit.common.model.PaginationInfoVO;
import kr.or.ddit.domain.member.resident.vo.VstVhclRsvtVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface IVstVhclMapper {
    void insertVisitReservation(VstVhclRsvtVO vo);


    int deleteVisit(String rsvtNo, String userNo);

    int selectVisitCount(String userNo, String aptCmplexNo);

    List<VstVhclRsvtVO> selectVisitList(PaginationInfoVO<VstVhclRsvtVO> pagingVO, String userNo, String aptCmplexNo);
}
