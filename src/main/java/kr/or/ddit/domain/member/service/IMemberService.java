package kr.or.ddit.domain.member.service;

import kr.or.ddit.common.enums.ServiceResult;
import kr.or.ddit.domain.member.vo.MemberVO;
import org.springframework.web.multipart.MultipartFile;

import java.util.Map;

public interface IMemberService {

    ServiceResult joinMember(MemberVO member, MultipartFile profFile);

    ServiceResult idCheck(String userId);

    ServiceResult updateMember(MemberVO member);

    MemberVO getMemberByUserNo(String userNo);

    void updateAlarm(Map<String, Object> param);

}
