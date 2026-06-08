package kr.or.ddit.common.api.react.service;

import kr.or.ddit.common.api.google.service.GoogleDriveService;
import kr.or.ddit.common.api.react.mapper.IReactAptMapper;
import kr.or.ddit.common.file.mapper.IAttachFileMapper;
import kr.or.ddit.common.file.vo.AttachFileVO;
import kr.or.ddit.domain.apt.main.vo.AptComplexVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Service
public class ReactAptServiceImpl implements IReactAptService {

    @Autowired
    private IReactAptMapper reactAptMapper;

    @Autowired
    private GoogleDriveService googleDriveService;

    @Autowired
    private IAttachFileMapper attachFileMapper;

    @Override
    public Map<String, Object> searchApartment(
            String keyword
            , int page
            , int size
    ) {
        int startRow = (page - 1) * size;
        List<AptComplexVO> content = reactAptMapper.searchApartment(
                keyword,
                startRow,
                size
        );

        int totalCount = reactAptMapper.countApartment(
                keyword
        );

        boolean hasNext = totalCount > (page * size);

        Map<String, Object> result = new HashMap<>();

        result.put(
                "content",
                content
        );

        result.put(
                "page",
                page
        );

        result.put(
                "size",
                size
        );

        result.put(
                "totalCount",
                totalCount
        );

        result.put(
                "hasNext",
                hasNext
        );

        return result;
    }

    @Override
    public List<Map<String, Object>> getDongList(String aptCmplexNo) {
        return reactAptMapper.getDongList(aptCmplexNo);
    }

    @Override
    public List<Map<String, Object>> getHoList(String aptCmplexNo, String dongNo) {
        return reactAptMapper.getHoList(aptCmplexNo, dongNo);
    }

    @Override
    public Map<String, Object>
    getRentListingDetail(String hoNo) {
        return reactAptMapper.getRentListingDetail(hoNo);
    }

    @Override
    public List<Map<String, Object>>
    getRequiredDocs(String rentLstgNo) {
        return reactAptMapper.getRequiredDocs(rentLstgNo);
    }

    @Override
    @Transactional
    public void assignResident(
            Map<String, String> param,
            List<MultipartFile> files,
            List<String> fileTypes
    ) {

        String seq = reactAptMapper.getSeqSbmsnDoc();
        Long attachSeq = attachFileMapper.getSeqFileGroupNo();
        String uploadPath = "contract/doc/general/" + seq;

        if (files != null && !files.isEmpty()) {
            int sortOrder = 0;
            String cat;

            for (int i = 0; i < files.size(); i++) {
                MultipartFile file = files.get(i);
                cat = fileTypes.get(i);
                String fileSaveUuid = UUID.randomUUID().toString().replaceAll("-", "") + "_" + file.getOriginalFilename();
                String savePath = uploadPath + "/" + fileSaveUuid;

                try {
                    String googleId = googleDriveService.uploadFile(file, uploadPath, fileSaveUuid);

                    AttachFileVO attachFileVo = AttachFileVO.fileSettings(
                            file, attachSeq, cat, fileSaveUuid, googleId, savePath, sortOrder++);

                    attachFileMapper.insertAttachFile(attachFileVo);

                    param.put("sbmsnDocNo", seq);
                    param.put("sbmsnDocTyCd", "GENERAL");
                    param.put("atchFileId", String.valueOf(attachSeq));

                } catch (IOException e) {
                    throw new RuntimeException(e);
                }
            }

            reactAptMapper.insertSbmsnDoc(param);
            //
        }

        System.out.println(param);
        reactAptMapper.insertRentCtrt(param);
        reactAptMapper.insertCtrtMgr(param);

        // 매물 상태 변경
        reactAptMapper.updateRentListingStatus(param.get("rentLstgNo"));
    }
}