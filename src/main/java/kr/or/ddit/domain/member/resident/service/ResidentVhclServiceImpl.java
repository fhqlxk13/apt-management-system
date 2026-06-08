package kr.or.ddit.domain.member.resident.service;

import kr.or.ddit.common.api.google.service.GoogleDriveService;
import kr.or.ddit.common.file.service.IAttachFileService;
import kr.or.ddit.common.file.vo.AttachFileVO;
import kr.or.ddit.domain.member.resident.mapper.IVhclMapper;
import kr.or.ddit.domain.member.resident.vo.RsidVhclVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.Collections;
import java.util.List;
import java.util.UUID;

@Service
@Transactional
@Slf4j
public class ResidentVhclServiceImpl implements IResidentVhclService {

    @Autowired
    IVhclMapper vhclMapper;

    @Autowired
    GoogleDriveService googleDriveService;

    @Autowired
    IAttachFileService attachFileService;


    public boolean isExtraRequired(String userNo, String aptCmplexNo, String hoNo) {

        int freeCnt = vhclMapper.selectFreePkgCnt(aptCmplexNo);

        int currentCnt = vhclMapper.countMyVhcl(hoNo);

        boolean result = currentCnt >= freeCnt;

        return result;
    }

    @Override
    @Transactional
    public void deleteVhcl(String rsidVhclNo, String userNo) {

        //차량 조회
        RsidVhclVO vhcl = vhclMapper.selectVhcl(rsidVhclNo);

        if (vhcl == null) {
            throw new RuntimeException("차량 없음");
        }

        if (vhcl.getUserNo() == null ||
                !vhcl.getUserNo().equals(userNo)) {

            throw new RuntimeException("삭제 권한 없음");
        }

        String fileId = vhcl.getVhclFileNo();

        //파일 존재하면 처리
        if (fileId != null && !fileId.isBlank()) {

            //groupNo 추출
            String fileGroupNo = fileId.split("_")[0];

            //attach_file 조회
            List<AttachFileVO> fileList =
                    attachFileService.setFileMetaData(fileGroupNo);

            try {
                var drive = googleDriveService.getDriveService();

                //구글 파일 삭제
                for (AttachFileVO file : fileList) {
                    if (file.getGoogleId() != null) {
                        googleDriveService.moveToTrash(drive, file.getGoogleId());
                    }
                }

            } catch (Exception e) {
                throw new RuntimeException("구글 파일 삭제 실패", e);
            }


            attachFileService.deleteAllByGroupNo(fileGroupNo);

        }

        //차량 삭제
        vhclMapper.deleteVhcl(rsidVhclNo, userNo);
    }

    @Transactional
    public void registerVhcl(
            String userNo,
            String aptCmplexNo,
            String vhclNm,
            String vhclNo,
            String hoNo,
            MultipartFile file
    ) throws IOException {

        //차량번호 중복 체크
        if (vhclMapper.existsVhclNo(vhclNo)>0) {
            throw new RuntimeException("이미 등록된 차량번호입니다.");
        }

        //상태 결정
        String status = "WAIT";

        //파일 처리
        Long fileGroupNo = null;
        String fileId = null;

        if (file != null && !file.isEmpty()) {

            fileGroupNo = attachFileService.getSeqFileGroupNo();

            String uuid = UUID.randomUUID().toString().replace("-","");
            String path = "resident/vhcl/"+userNo;
            String savedFileName = uuid + "_" + file.getOriginalFilename();

            fileId = fileGroupNo + "_"+ savedFileName;

            String googleId = googleDriveService.uploadFile(file,path,savedFileName);

            //AttachFileVO 생성
            AttachFileVO fileVO = AttachFileVO.fileSettings(
                    file
                    ,fileGroupNo
                    ,"vhcl"
                    ,savedFileName
                    ,googleId
                    ,path
                    ,1
            );

            attachFileService.insertAttachFile(fileVO);
        }

        // 차량 VO
        RsidVhclVO vhcl = new RsidVhclVO();
        vhcl.setUserNo(userNo);
        vhcl.setVhclNm(vhclNm);
        vhcl.setVhclNo(vhclNo);
        vhcl.setHoNo(hoNo);
        vhcl.setVhclSttsCd(status);
        if(fileId != null) {
            vhcl.setVhclFileNo(fileId);
        }
        //insert 진행!
        vhclMapper.insertVhcl(vhcl);
    }

    @Override
    public List<RsidVhclVO> selectMyVhclList(
            String userNo,
            String aptCmplexNo
    ) {

        List<String> hoList =
                vhclMapper.selectMyHoList(userNo, aptCmplexNo);

        if (hoList == null || hoList.isEmpty()) {
            return Collections.emptyList();
        }

        log.info("userNo={}", userNo);
        log.info("aptCmplexNo={}", aptCmplexNo);

        log.info("hoList={}", hoList);

        return vhclMapper.selectMyVhclList(hoList);
    }

}
