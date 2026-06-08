package kr.or.ddit.domain.member.resident.mapper;

import kr.or.ddit.common.webSocket.chat.vo.ChatRoomVO;
import kr.or.ddit.domain.member.resident.vo.RsidVhclVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface IVhclMapper {


    int existsVhclNo(String vhclNo);

    void insertVhcl(RsidVhclVO vhcl);

    List<String> selectMyHoList(@Param("userNo") String userNo, @Param("aptCmplexNo") String aptCmplexNo);

    int countVhclByHoList(List<String> hoList);

    int countMyVhcl(String hoNo);

    int selectFreePkgCnt(String aptCmplexNo);

    void deleteVhcl(String rsidVhclNo,String userNo);

    RsidVhclVO selectVhcl(String rsidVhclNo);

    List<RsidVhclVO> selectMyVhclList(List<String> list);
}
