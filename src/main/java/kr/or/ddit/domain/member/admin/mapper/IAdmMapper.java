package kr.or.ddit.domain.member.admin.mapper;

import kr.or.ddit.domain.member.admin.vo.AdmVO;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface IAdmMapper {

    AdmVO selectOneAdmInfo(String userNo);
}
