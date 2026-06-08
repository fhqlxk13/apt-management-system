package kr.or.ddit.domain.central.admin.mapper;

import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;

@Mapper
public interface IAnlsMapper {

    List<Map<String, Object>> selectRecruitingAnnList();
}
