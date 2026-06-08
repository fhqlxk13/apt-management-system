package kr.or.ddit.domain.apt.complaint.service;

import com.google.api.services.drive.Drive;
import kr.or.ddit.common.api.google.service.GoogleDriveService;
import kr.or.ddit.common.enums.ServiceResult;
import kr.or.ddit.common.file.mapper.IAttachFileMapper;
import kr.or.ddit.common.file.vo.AttachFileVO;
import kr.or.ddit.common.model.PaginationInfoVO;
import kr.or.ddit.domain.apt.complaint.mapper.ICvplMapper;
import kr.or.ddit.domain.apt.complaint.vo.CvplHstryVO;
import kr.or.ddit.domain.apt.complaint.vo.CvplVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.security.GeneralSecurityException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Slf4j
@Transactional(rollbackFor = Exception.class)
@Service
public class CvplServiceImpl implements ICvplService {



    @Autowired
    private ICvplMapper cvplMapper;

    @Autowired
    private IAttachFileMapper attachFileMapper;

    @Autowired
    private GoogleDriveService googleDriveService;

    /**
     * 민원 신청 서비스 로직
     * @author 이용로
     * @param cvplVO
     * @param attachFiles
     * @return ServiceResult
     * @throws GeneralSecurityException 구글 API 자체 시큐리티 예외
     * @throws IOException
     */
    @Override
    public ServiceResult applyCvpl(CvplVO cvplVO, MultipartFile[] attachFiles){
        List<String> uploadedGids = new ArrayList<>();  // 업로드한 파일들의 구글아이디 모음
        Drive drive = null; // catch phrase에서도 쓰려고 try바깥에 선언

        try {
            drive = googleDriveService.getDriveService();

            // 2. 첨부 파일 처리 (null 체크 및 length 체크 순서 중요)
            if (attachFiles != null && attachFiles.length > 0) {
                int size = attachFiles.length;
                long fileGroupNo = attachFileMapper.getSeqFileGroupNo();    // 파일 묶음일 경우 fileFroupNo 하나로 묶는다
                AttachFileVO[] files = new AttachFileVO[size];

                for (int i = 0; i < size; i++) {
                    String originalFilename = attachFiles[i].getOriginalFilename();
                    String uuid = UUID.randomUUID().toString().replace("-", "");

                    //----------------- 필수 커스텀 부분 ---------------------
                    String savedFileName = uuid + "_" + originalFilename;
                    String folderPath = "apt/cvpl/" + cvplVO.getAptCmplexNo() + "/" + cvplVO.getUserNo();
                    String fullPath = folderPath + "/" + savedFileName;
                    //--------------- 필수 커스텀 부분 end -------------------

                    // 실제 업로드
                    String googleId = googleDriveService.uploadFile(attachFiles[i], folderPath, savedFileName);
                    uploadedGids.add(googleId);

                    // 업로드한 파일 메타데이터 저장
                    files[i] = AttachFileVO.fileSettings(attachFiles[i], fileGroupNo, "민원", savedFileName, googleId, fullPath, i);
                }

                // DB 인서트
                for (AttachFileVO f : files) {
                    attachFileMapper.insertAttachFile(f);
                }
                cvplVO.setCvplFileNo(String.valueOf(fileGroupNo));
            }

            // 3. 민원 본문 저장
            cvplVO.setCvplSttsCd("APLY");
            int insertCheck = cvplMapper.insertCvplApply(cvplVO);
            if (insertCheck < 1) throw new RuntimeException("민원 본문 DB 저장 실패");

            // 4. 민원 이력도 동시 저장
            CvplHstryVO cvplHstryVO = new CvplHstryVO();
            BeanUtils.copyProperties(cvplVO, cvplHstryVO);
            insertCheck = cvplMapper.insertCvplHstry(cvplHstryVO);
            if (insertCheck < 1) throw new RuntimeException("민원 이력 DB 저장 실패");

            return ServiceResult.OK;

        } catch (Exception e) {
            log.error("#### 에러 발생 원인: {}", e.getMessage());
            e.printStackTrace(); // 상세 스택트레이스 출력

            // 롤백: 이미 업로드된 파일들 삭제
            if (drive != null && !uploadedGids.isEmpty()) {
                for (String gId : uploadedGids) {
                    try {
                        googleDriveService.moveToTrash(drive, gId);
                    } catch (Exception ex) {
                        log.error("롤백 중 삭제 실패(gId: {}): {}", gId, ex.getMessage());
                    }
                }
            }
            throw new RuntimeException(e.getMessage(), e);
        }
    }

    @Override
    public List<CvplVO> selectCvplListByAptCmplexNo(String aptCmplexNo, String userNo) {
        return cvplMapper.selectCvplListByAptCmplexNo(aptCmplexNo, userNo);
    }

    @Override
    public int selectCvplCount(CvplVO cvpl) {
        return cvplMapper.selectCvplCount(cvpl);
    }

    @Override
    public List<CvplVO> selectMyCvplList(PaginationInfoVO<CvplVO> page) {
        return cvplMapper.selectMyCvplList(page);
    }

    @Override
    public List<CvplVO> selectCvplListAllByAptCmplexNo(String aptCmplexNo) {
        return cvplMapper.selectCvplListAllByAptCmplexNo(aptCmplexNo);
    }

    @Override
    public CvplVO selectCvplDetailByCvplNo(String cvplNo) {
        return cvplMapper.selectOneCvplDetailByCvplNo(cvplNo);
    }

    @Override
    public int cancelCvpl(String cvplNo) {
        return cvplMapper.updateCvplSttsToCancel(cvplNo);
    }

    @Override
    public int selectCvplCountByAptCmplexNo(PaginationInfoVO<CvplVO> searchVO) {
        return cvplMapper.selectCvplCountByAptCmplexNo(searchVO);
    }

    @Override
    public List<CvplVO> selectCvplListAllByAptCmplexNoPaged(PaginationInfoVO<CvplVO> page) {
        return cvplMapper.selectCvplListAllByAptCmplexNoPaged(page);
    }
}
