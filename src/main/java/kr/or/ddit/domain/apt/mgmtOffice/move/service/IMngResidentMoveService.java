package kr.or.ddit.domain.apt.mgmtOffice.move.service;

import kr.or.ddit.domain.apt.mgmtOffice.move.dto.MngResidentMoveSearchDTO;
import kr.or.ddit.domain.apt.mgmtOffice.move.vo.MngResidentMoveVO;

import java.util.List;
import java.util.Map;

public interface IMngResidentMoveService {

    List<MngResidentMoveVO> selectResidentMoveList(MngResidentMoveSearchDTO searchDTO);

    MngResidentMoveVO selectResidentMoveDetail(
            String mgmtOfcNo,
            String userNo,
            String hoNo
    );

    Map<String, Object> saveResidentMove(MngResidentMoveVO vo);

    Map<String, Object> updateResidentMove(MngResidentMoveVO vo);

    MngResidentMoveVO selectMemberInfo(String userNo);

    int selectResidentMoveCount(MngResidentMoveSearchDTO searchDTO);
}
