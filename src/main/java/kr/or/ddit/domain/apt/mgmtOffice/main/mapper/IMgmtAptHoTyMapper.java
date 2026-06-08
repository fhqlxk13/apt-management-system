package kr.or.ddit.domain.apt.mgmtOffice.main.mapper;

import kr.or.ddit.domain.apt.apiApartment.vo.AptHoTyDTO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface IMgmtAptHoTyMapper {
    List<AptHoTyDTO> selectHoTypeList(String aptCmplexNo);

    void insertHoType(AptHoTyDTO aptHoTyDTO);

    String selectNextHoTySeq(String aptCmplexNo);

    void updateHoType(AptHoTyDTO aptHoTyDTO);

    AptHoTyDTO selectHoTypeDetail(String hoTyNo);

    List<String> selectUsingHoList(String hoTyNo);

    void deleteHoType(String hoTyNo);
}
