package kr.or.ddit.domain.apt.main.service;

import kr.or.ddit.common.api.google.service.GoogleDriveService;
import kr.or.ddit.common.file.mapper.IAttachFileMapper;
import kr.or.ddit.common.file.service.IAttachFileService;
import kr.or.ddit.common.file.vo.AttachFileVO;
import kr.or.ddit.domain.apt.apiApartment.vo.AptHoTyDTO;
import kr.or.ddit.domain.apt.main.mapper.IAptComplexMapper;
import kr.or.ddit.domain.apt.main.vo.AptComplexVO;
import kr.or.ddit.domain.apt.main.vo.ComplexEditDTO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import tools.jackson.databind.ObjectMapper;

import java.io.IOException;
import java.util.*;
import java.util.stream.Collectors;

@Service
@Slf4j
public class MgmtAptComplexServiceImpl implements IMgmtAptComplexService {

    @Autowired
    private GoogleDriveService googleDriveService;

    @Autowired
    private IAttachFileService attachFileService;

    @Autowired
    private IAptComplexMapper aptComplexMapper;

    @Autowired
    private IAttachFileMapper attachFileMapper;

    @Override
    public ComplexEditDTO.DetailResponse getComplexDetail(
            String mgmtOfcNo
    ) {

        AptComplexVO complex = aptComplexMapper.selectMgmtOfcNoAptComplex(mgmtOfcNo);

        ComplexEditDTO.DetailResponse response = new ComplexEditDTO.DetailResponse();

        response.setComplex(complex);

        if(complex.getImgFileNo() != null){

            List<AttachFileVO> allFiles =
                    attachFileService.setFileMetaData(
                            complex.getImgFileNo()
                    );

            if(allFiles == null){
                allFiles = new ArrayList<>();
            }

            response.setLayoutFiles(
                    allFiles.stream()
                            .filter(f ->
                                    "layoutImage".equals(f.getCat())
                            )
                            .toList()
            );

            response.setComplexFiles(
                    allFiles.stream()
                            .filter(f ->
                                    "complexImage".equals(f.getCat())
                            )
                            .toList()
            );
        }

        return response;
    }

    @Override
    @Transactional
    public void updateComplex(
            String mgmtOfcNo,
            ComplexEditDTO.SaveRequest request
    ) {

        AptComplexVO aptCmplexVO =
                aptComplexMapper.selectMgmtOfcNoAptComplex(mgmtOfcNo);

        if(aptCmplexVO == null){
            throw new RuntimeException(
                    "단지 정보가 존재하지 않습니다."
            );
        }

        request.setAptCmplexNo(aptCmplexVO.getAptCmplexNo());


    /* 이미지 수정 여부 확인 */
        if("Y".equals(request.getIsImageChanged())) {



            /* 정렬 JSON */
            String layoutSortOrder =
                    request.getLayoutSortOrder();

            String complexSortOrder =
                    request.getComplexSortOrder();

            log.info("layoutSortOrder : {}",
                    layoutSortOrder);

            log.info("complexSortOrder : {}",
                    complexSortOrder);

            List<MultipartFile> layoutFiles =
                    request.getLayoutFiles();

            List<MultipartFile> complexImgFiles =
                    request.getComplexImgFiles();


            ObjectMapper objectMapper =
                    new ObjectMapper();

            ComplexEditDTO.FileSortOrderDTO[] layoutArray =
                    objectMapper.readValue(
                            layoutSortOrder,
                            ComplexEditDTO.FileSortOrderDTO[].class
                    );

            List<ComplexEditDTO.FileSortOrderDTO> layoutOrderList =
                    Arrays.asList(layoutArray);

            ComplexEditDTO.FileSortOrderDTO[] complexArray =
                    objectMapper.readValue(
                            complexSortOrder,
                            ComplexEditDTO.FileSortOrderDTO[].class
                    );

            List<ComplexEditDTO.FileSortOrderDTO> complexOrderList =
                    Arrays.asList(complexArray);


            List<AttachFileVO> existLayoutFiles =
                    attachFileService.setFileMetaData(
                            request.getImgFileNo()
                    );

            List<AttachFileVO> existComplexFiles =
                    attachFileService.setFileMetaData(
                            request.getImgFileNo()
                    );
            if (existLayoutFiles == null) {
                existLayoutFiles = new ArrayList<>();
            }

            if (existComplexFiles == null) {
                existComplexFiles = new ArrayList<>();
            }

/* =========================
   category 분리
========================= */

            existLayoutFiles =
                    existLayoutFiles.stream()
                            .filter(file ->
                                    "layoutImage".equals(
                                            file.getCat()
                                    )
                            )
                            .toList();

            existComplexFiles =
                    existComplexFiles.stream()
                            .filter(file ->
                                    "complexImage".equals(
                                            file.getCat()
                                    )
                            )
                            .toList();

            Set<String> remainLayoutUuids =
                    layoutOrderList.stream()
                            .filter(item ->
                                    "old".equals(
                                            item.getFileType()
                                    )
                            )
                            .map(
                                    ComplexEditDTO.FileSortOrderDTO
                                            ::getFileSaveUuid
                            )
                            .collect(Collectors.toSet());

            Set<String> remainComplexUuids =
                    complexOrderList.stream()

                            .filter(item ->
                                    "old".equals(
                                            item.getFileType()
                                    )
                            )

                            .map(
                                    ComplexEditDTO.FileSortOrderDTO
                                            ::getFileSaveUuid
                            )

                            .collect(Collectors.toSet());

            List<AttachFileVO> deleteLayoutFiles =
                    existLayoutFiles.stream()

                            .filter(file ->
                                    !remainLayoutUuids.contains(
                                            file.getFileSaveUuid()
                                    )
                            )

                            .toList();

            List<AttachFileVO> deleteComplexFiles =
                    existComplexFiles.stream()

                            .filter(file ->
                                    !remainComplexUuids.contains(
                                            file.getFileSaveUuid()
                                    )
                            )

                            .toList();

            for (AttachFileVO file : deleteLayoutFiles) {

                if (file.getGoogleId() != null) {

                    attachFileService.deleteOne(
                            file.getGoogleId()
                    );
                }
            }

            for (AttachFileVO file : deleteComplexFiles) {

                if (file.getGoogleId() != null) {

                    attachFileService.deleteOne(
                            file.getGoogleId()
                    );
                }
            }

            Long fileGroupNo = null;

            if (aptCmplexVO.getImgFileNo() != null
                    && !aptCmplexVO.getImgFileNo().isBlank()) {

                fileGroupNo =
                        Long.parseLong(
                                aptCmplexVO.getImgFileNo()
                        );

            } else {
                fileGroupNo =
                        attachFileMapper.getSeqFileGroupNo();
            }

            request.setImgFileNo(
                    String.valueOf(fileGroupNo)
            );

/*            request.setRprsntImgFileNo(
                    String.valueOf(fileGroupNo)
            );*/

            /* 업로드 진행 */
            String layoutUploadPath = "aptcomplex/RPRSNT_IMG_FILE/" + aptCmplexVO.getAptCmplexNo();

            if (layoutFiles != null) {
                int sortOrder = 0;

                String cat = "layoutImage";

                for (MultipartFile file : layoutFiles) {

                    if (file == null || file.isEmpty()) {
                        continue;
                    }

                    String fileSaveUuid = UUID.randomUUID().toString().replaceAll("-", "") + "_" + file.getOriginalFilename();

                    String savePath = layoutUploadPath + "/" + fileSaveUuid;

                    try {
                        String googleId = googleDriveService.uploadFile(file, layoutUploadPath, fileSaveUuid);

                        AttachFileVO attachFileVO = AttachFileVO.fileSettings(
                                file, fileGroupNo, cat, fileSaveUuid, googleId, savePath, sortOrder++);

                        attachFileService.insertAttachFile(attachFileVO);

                    } catch (IOException e) {
                        throw new RuntimeException(e);
                    }
                }
            }

            /* 업로드 진행 RPRSNT_IMG_FILE_NO */
            String complexUploadPath = "aptcomplex/IMG_FILE/" + aptCmplexVO.getAptCmplexNo();

            if (complexImgFiles != null) {
                int sortOrder = 0;

                String cat = "complexImage";

                for (MultipartFile file : complexImgFiles) {

                    if (file == null || file.isEmpty()) {
                        continue;
                    }

                    String fileSaveUuid = UUID.randomUUID().toString().replaceAll("-", "") + "_" + file.getOriginalFilename();

                    String savePath = complexUploadPath + "/" + fileSaveUuid;

                    try {
                        String googleId = googleDriveService.uploadFile(file, complexUploadPath, fileSaveUuid);

                        AttachFileVO attachFileVO = AttachFileVO.fileSettings(
                                file, fileGroupNo, cat, fileSaveUuid, googleId, savePath, sortOrder++);

                        attachFileService.insertAttachFile(attachFileVO);

                    } catch (IOException e) {
                        throw new RuntimeException(e);
                    }
                }
            }
        }

        log.info("FINAL img = {}",
                request.getImgFileNo());

        aptComplexMapper.updateComplex(request);

    }


}
