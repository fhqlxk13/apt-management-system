package kr.or.ddit.domain.member.resident.mapper;

import kr.or.ddit.common.webSocket.chat.vo.ChatRoomVO;
import kr.or.ddit.domain.member.resident.vo.ResidentVO;
import kr.or.ddit.domain.member.resident.vo.RsidVhclVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface IResidentMapper {

    ResidentVO selectOneResidentInfo(String userNo);

}
