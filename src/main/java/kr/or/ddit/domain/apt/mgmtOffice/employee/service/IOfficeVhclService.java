package kr.or.ddit.domain.apt.mgmtOffice.employee.service;

import kr.or.ddit.domain.member.resident.vo.RsidVhclVO;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.Map;

public interface IOfficeVhclService {


    int registerVehicle(RsidVhclVO vo, MultipartFile uploadFile);

    List<RsidVhclVO> getVehicleList(String mgmtOfcNo);

    RsidVhclVO getVehicle(String rsidVhclNo);

    int updateVehicle(RsidVhclVO vo, MultipartFile uploadFile);

    int deleteVehicle(String rsidVhclNo);

    Map<String, Object> searchResident(Map<String, Object> param);

    void updateVehicleStatus(String rsidVhclNo, String status);
}
