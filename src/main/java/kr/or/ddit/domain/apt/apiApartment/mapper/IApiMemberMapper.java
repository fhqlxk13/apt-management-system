package kr.or.ddit.domain.apt.apiApartment.mapper;

import kr.or.ddit.domain.apt.apiApartment.vo.HshldHeadEntity;
import kr.or.ddit.domain.apt.apiApartment.vo.HshldMemberEntity;
import kr.or.ddit.domain.member.vo.AuthVO;
import kr.or.ddit.domain.member.vo.MemberVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface IApiMemberMapper {
    void insertMember(MemberVO member);

    int selectNotAssignedUserCount();

    void insertMemberAuth(AuthVO auth);

    List<MemberVO> selectNotAssignedTestUsers();

    void insertMemberAssign(HshldHeadEntity hshldHeadEntity);

    void updateMemberAuth(String userNo);

    void insertHshldMember(HshldMemberEntity hshldMember);

    int countUserId(String userId);
}
