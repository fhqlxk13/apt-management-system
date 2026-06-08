package kr.or.ddit.domain.member.mapper;

import kr.or.ddit.domain.member.resident.vo.RsidVhclVO;
import kr.or.ddit.domain.member.vo.MemberVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface IMemberMapper {

    // 로그인 시큐리티 인증시 유저정보 가져오기
    MemberVO readByUserInfo(String username);

    int joinMember(MemberVO member);

    int idCheck(@Param("userId") String userId);

    int updateMember(MemberVO member);

    void addAuth(String userNo);

    MemberVO getMemberByUserNo(String userNo);

    void updateAlarm(Map<String, Object> param);

    List<RsidVhclVO> getVhclList(String userNo);
}
