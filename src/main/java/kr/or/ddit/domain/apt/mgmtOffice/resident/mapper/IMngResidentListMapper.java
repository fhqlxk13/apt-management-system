package kr.or.ddit.domain.apt.mgmtOffice.resident.mapper;

import kr.or.ddit.domain.apt.mgmtOffice.resident.dto.MngResidentListSearchDTO;
import kr.or.ddit.domain.apt.mgmtOffice.resident.vo.MngResidentListVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface IMngResidentListMapper {

    List<MngResidentListVO> selectResidentList(MngResidentListSearchDTO searchDTO);

    MngResidentListVO selectResidentDetail(
            @Param("mgmtOfcNo") String mgmtOfcNo,
            @Param("userNo") String userNo
    );
}
