package kr.or.ddit.domain.apt.mgmtOffice.main.service;

import kr.or.ddit.common.api.google.service.GoogleDriveService;
import kr.or.ddit.common.file.service.IAttachFileService;
import kr.or.ddit.common.file.vo.AttachFileVO;
import kr.or.ddit.domain.apt.apiApartment.vo.AptHoTyDTO;
import kr.or.ddit.domain.apt.main.service.IAptComplexService;
import kr.or.ddit.domain.apt.main.vo.AptComplexVO;
import kr.or.ddit.domain.apt.mgmtOffice.main.mapper.IMgmtAptHoTyMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;
import java.util.UUID;

@Service
public class MgmtAptHoTyServiceImpl implements IMgmtAptHoTyService {

    @Autowired
    IAttachFileService attachFileService;

    @Autowired
    IAptComplexService aptComplexService;

    @Autowired
    GoogleDriveService googleDriveService;

    @Autowired
    IMgmtAptHoTyMapper hoTyMapper;

    @Override
    public List<AptHoTyDTO> selectHoTypeList(String mgmtOfcNo) {

        AptComplexVO complex =
                aptComplexService.selectMgmtOfcNoAptComplex(mgmtOfcNo);

        if(complex == null){
            return List.of();
        }

        return hoTyMapper.selectHoTypeList(complex.getAptCmplexNo());
    }

    @Override
    public void insertHoType(
            String mgmtOfcNo,
            AptHoTyDTO aptHoTyDTO,
            MultipartFile imageFile
    ) {

        // 1. 단지 조회
        AptComplexVO complex =
                aptComplexService.selectMgmtOfcNoAptComplex(mgmtOfcNo);

        if(complex == null){
            throw new RuntimeException("단지 정보가 없습니다.");
        }

        // 2. 단지번호 세팅
        aptHoTyDTO.setAptCmplexNo(
                complex.getAptCmplexNo()
        );

        // 3. 이미지 업로드
        if(imageFile != null && !imageFile.isEmpty()){

            Long fileGroupNo = attachFileService.getSeqFileGroupNo();
            String cat = "hoTyImage";
            String uuid = UUID.randomUUID().toString().replace("-","");
            String saveUuid = uuid + "_" + imageFile.getOriginalFilename();
            String uploadPath = "apt/hoTy/"+complex.getAptCmplexNo();
            String savePath = uploadPath + "/" + saveUuid;
            String googleId;

            try {
                googleId = googleDriveService.uploadFile(imageFile,uploadPath,saveUuid);
            } catch (IOException e) {
                throw new RuntimeException(e);
            }

            AttachFileVO attachFileVO = AttachFileVO.fileSettings(
                    imageFile, fileGroupNo, cat, saveUuid, googleId, savePath, 0);

            aptHoTyDTO.setImageFileNo(fileGroupNo);

            attachFileService.insertAttachFile(attachFileVO);
        }

        String hoTyNo = complex.getAptCmplexNo() + "_" + hoTyMapper.selectNextHoTySeq(complex.getAptCmplexNo());

        aptHoTyDTO.setHoTyNo(hoTyNo);

        // 4. insert
        hoTyMapper.insertHoType(aptHoTyDTO);

    }

    @Override
    public void updateHoType(
            String mgmtOfcNo,
            AptHoTyDTO aptHoTyDTO,
            MultipartFile imageFile
    ) {
        // 1. 단지 조회
        AptComplexVO complex = aptComplexService.selectMgmtOfcNoAptComplex(mgmtOfcNo);
        if(complex == null){
            throw new RuntimeException("단지 정보가 없습니다.");
        }

        AptHoTyDTO oldData =
                hoTyMapper.selectHoTypeDetail(
                        aptHoTyDTO.getHoTyNo()
                );

        Long oldFileGroupNo = oldData.getImageFileNo();

        List<AttachFileVO> attachFileVOList = List.of();

        if(oldFileGroupNo != null){
            attachFileVOList = attachFileService.setFileMetaData(String.valueOf(oldFileGroupNo));
        }

        // 이미지 변경 발생
        if(aptHoTyDTO.isImageChanged()){

            // 기존 이미지 제거
            for(AttachFileVO file : attachFileVOList){
                attachFileService.deleteOne(file.getGoogleId());
            }

            aptHoTyDTO.setImageFileNo(null);


            // 새 이미지 존재 시
            if(imageFile != null && !imageFile.isEmpty()){

                Long fileGroupNo = oldFileGroupNo;

                if(fileGroupNo == null){
                    fileGroupNo = attachFileService.getSeqFileGroupNo();
                }

                String cat = "hoTyImage";
                String uuid = UUID.randomUUID().toString().replace("-", "");
                String saveUuid = uuid + "_" + imageFile.getOriginalFilename();
                String uploadPath = "apt/hoTy/" + complex.getAptCmplexNo();
                String savePath = uploadPath + "/" + saveUuid;
                String googleId;
                try {
                    googleId = googleDriveService.uploadFile(
                                    imageFile,
                                    uploadPath,
                                    saveUuid
                                );
                } catch (IOException e) {
                    throw new RuntimeException(e);
                }
                AttachFileVO attachFileVO =
                        AttachFileVO.fileSettings(
                                imageFile,
                                fileGroupNo,
                                cat,
                                saveUuid,
                                googleId,
                                savePath,
                                0
                        );
                attachFileService.insertAttachFile(attachFileVO);
                aptHoTyDTO.setImageFileNo(fileGroupNo);
            }
        }

        // 3. update
        hoTyMapper.updateHoType(aptHoTyDTO);

    }


    @Override
    public void deleteHoType(
            String mgmtOfcNo,
            String hoTyNo
    ) {

        // 사용중인 호 타입인지 조회
        List<String> usingHoList = hoTyMapper.selectUsingHoList(hoTyNo);

        if(!usingHoList.isEmpty()){
            throw new RuntimeException(
                    String.join(", ", usingHoList)
            );
        }

        AptHoTyDTO oldData = hoTyMapper.selectHoTypeDetail(hoTyNo);

        if(oldData == null){return;}

        // 첨부파일 삭제
        if(oldData.getImageFileNo() != null){

            List<AttachFileVO> fileList = attachFileService.setFileMetaData(String.valueOf(oldData.getImageFileNo()));

            if(fileList != null){
                for(AttachFileVO file : fileList){
                    attachFileService.deleteOne(
                            file.getGoogleId()
                    );
                }
            }
        }

        // 평형 삭제
        hoTyMapper.deleteHoType(hoTyNo);

    }

}
