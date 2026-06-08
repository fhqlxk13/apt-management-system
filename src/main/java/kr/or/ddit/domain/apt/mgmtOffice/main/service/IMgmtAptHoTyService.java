package kr.or.ddit.domain.apt.mgmtOffice.main.service;

import kr.or.ddit.domain.apt.apiApartment.vo.AptHoTyDTO;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

public interface IMgmtAptHoTyService {
    List<AptHoTyDTO> selectHoTypeList(String mgmtOfcNo);

    void insertHoType(String mgmtOfcNo, AptHoTyDTO aptHoTyDTO, MultipartFile imageFile);

    void updateHoType(String mgmtOfcNo, AptHoTyDTO aptHoTyDTO, MultipartFile imageFile);

    void deleteHoType(String mgmtOfcNo, String hoTyNo);
}
