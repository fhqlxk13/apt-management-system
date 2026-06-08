package kr.or.ddit.domain.apt.mgmtOffice.employee.service;

import kr.or.ddit.domain.apt.mgmtOffice.employee.mapper.OfficeVhclMapper;
import kr.or.ddit.domain.member.resident.vo.RsidVhclVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import kr.or.ddit.common.api.google.service.GoogleDriveService;
import kr.or.ddit.common.file.mapper.IAttachFileMapper;
import kr.or.ddit.common.file.vo.AttachFileVO;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Slf4j
@Service
@RequiredArgsConstructor
public class OfficeVhclServiceImpl implements IOfficeVhclService {

    private final OfficeVhclMapper officeVhclMapper;

    private final GoogleDriveService googleDriveService;
    private final IAttachFileMapper attachFileMapper;


    @Override
    public int registerVehicle(
            RsidVhclVO vo,
            MultipartFile uploadFile
    ) {

        System.out.println("uploadFile = " + uploadFile);

        if(uploadFile != null){
            System.out.println("파일명 = " + uploadFile.getOriginalFilename());
        }

        vo.setRsidVhclNo(
                UUID.randomUUID()
                        .toString()
                        .replace("-", "")
                        .substring(0, 20)
        );

        if(uploadFile != null && !uploadFile.isEmpty()){

            String originalFilename =
                    uploadFile.getOriginalFilename();

            String uuid =
                    UUID.randomUUID()
                            .toString()
                            .replace("-", "");

            String savedFileName =
                    uuid + "_" + originalFilename;

            String folderPath =
                    "vehicle/" + vo.getUserNo();

            String fullPath =
                    folderPath + "/" + savedFileName;

            String googleId;
            try {
                googleId = googleDriveService.uploadFile(
                        uploadFile,
                        folderPath,
                        savedFileName
                );
            } catch (Exception e) {
                throw new RuntimeException("차량등록증 Google Drive 업로드 실패", e);
            }
            long fileGroupNo =
                    attachFileMapper.getSeqFileGroupNo();

            AttachFileVO attachFile =
                    AttachFileVO.fileSettings(
                            uploadFile,
                            fileGroupNo,
                            "vehicle",
                            savedFileName,
                            googleId,
                            fullPath,
                            1
                    );

            attachFileMapper.insertAttachFile(attachFile);

            vo.setVhclFileNo(
                    fileGroupNo + "_" + savedFileName
            );
        }

        System.out.println("저장될 파일번호 = " + vo.getVhclFileNo());

        return officeVhclMapper.insertVehicle(vo);
    }
    @Override
    public List<RsidVhclVO> getVehicleList(String mgmtOfcNo) {
        return officeVhclMapper.getVehicleList(mgmtOfcNo);
    }

    @Override
    public RsidVhclVO getVehicle(String rsidVhclNo) {
        return officeVhclMapper.selectVehicleById(rsidVhclNo);
    }

    @Override
    public int updateVehicle(RsidVhclVO vo, MultipartFile uploadFile) {
        return officeVhclMapper.updateVehicle(vo);
    }

    @Override
    public int deleteVehicle(String rsidVhclNo) {
        return officeVhclMapper.deleteVehicle(rsidVhclNo);
    }

    @Override
    public Map<String, Object> searchResident(Map<String, Object> param) {
        return officeVhclMapper.searchResident(param);
    }

    @Override
    public void updateVehicleStatus(
            String rsidVhclNo,
            String status
    ){

        officeVhclMapper.updateVehicleStatus(
                rsidVhclNo,
                status
        );
    }
}
