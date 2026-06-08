package kr.or.ddit.domain.member.resident.service;

import kr.or.ddit.common.model.PaginationInfoVO;
import kr.or.ddit.domain.member.resident.vo.VisitRegisterDTO;
import kr.or.ddit.domain.member.resident.vo.VstVhclRsvtVO;
import kr.or.ddit.domain.member.vo.CustomUser;

import java.util.List;

public interface IResidentVstVhclService {
    void registerVisit(VisitRegisterDTO dto, CustomUser principal, String aptCmplexNo);

    int deleteVisit(String rsvtNo, String userNo);

    void selectVisitList(PaginationInfoVO<VstVhclRsvtVO> pagingVO, String userNo, String aptCmplexNo);
}
