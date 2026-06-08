package kr.or.ddit.domain.central.rentCtrt.service;

import kr.or.ddit.common.file.service.IAttachFileService;
import kr.or.ddit.common.file.vo.AttachFileVO;
import kr.or.ddit.common.notification.dto.NotificationDTO;
import kr.or.ddit.common.notification.service.NotificationService;
import kr.or.ddit.domain.central.board.service.INoticeService;
import kr.or.ddit.domain.central.rentCtrt.mapper.IRentCtrtMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

@Slf4j
@Transactional(rollbackFor = Exception.class)
@Service
public class RentCtrtServiceImpl implements IRentCtrtService {

    @Autowired
    private IRentCtrtMapper rentCtrtMapper;

    @Autowired
    private IAttachFileService attachFileService;

    @Autowired
    private NotificationService notificationService;

    @Override
    public List<Map<String, Object>> selectCtrt(int startRow, int endRow) {
        return rentCtrtMapper.selectCtrt(startRow, endRow);
    }

    @Override
    public List<Map<String, Object>> selectCtrt(Map<String, Object> params) {
        return rentCtrtMapper.selectContracts(params);
    }

    @Override
    public int selectCtrtCount(String userNo) {
        return rentCtrtMapper.selectCtrtCount(userNo);
    }

    @Override
    public int selectCtrtCount(Map<String, Object> params) {
        return rentCtrtMapper.selectContractsCount(params);
    }

    @Override
    public Map<String, Object> selectCtrtDashboard() {
        return rentCtrtMapper.selectCtrtDashboard();
    }

    @Override
    public Map<String, Object> selectOneCtrtDetail(String rentCtrtNo) {
        Map<String, Object> map = rentCtrtMapper.selectOneCtrtDetail(rentCtrtNo);
        String sbmsnDocNo = (String)map.get("SBMSN_DOC_NO");

        if(sbmsnDocNo != null) {
            String fileNo = (String) map.get("ATCH_FILE_ID");

            if (fileNo != null) {
                List<AttachFileVO> docList = attachFileService.setFileMetaData(fileNo);
                map.put("docList", docList);
            }
        }

        return map;
    }

    @Override
    @Transactional
    public int updateCtrt(String rentCtrtNo, Map<String, Object> detail) {
        Map<String, Object> before = rentCtrtMapper.selectOneCtrtDetail(rentCtrtNo);

        String beforeStatus = (String) before.get("CTRT_STTS_CD");
        String rentLstgNo = (String) before.get("RENT_LSTG_NO");
        String afterStatus = (String) detail.get("CTRT_STTS_CD");


        // 실제 업데이트
        int res = rentCtrtMapper.updateCtrt(rentCtrtNo, detail);

        // 최초 승인 시만 insert
        if (res > 0
                && !"APPROVED".equals(beforeStatus)
                && "APPROVED".equals(afterStatus)) {

            String userNo = (String)before.get("USER_NO");
            String aptCmplexNo = rentCtrtMapper.selectAptCmplexNo(rentLstgNo);

            notificationService.send(
                    userNo,
                    NotificationDTO.success(
                            "계약 완료",
                            "계약이 완료되었습니다 클릭시 해당 아파트 페이지로 이동합니다",
                            "/apt/main/" + aptCmplexNo
                    )
            );


            rentCtrtMapper.insertHshldHead(detail);
        }

        return res;
    }

    @Override
    public List<Map<String, Object>> selectCtrtXls(Map<String, Object> params) {
        return rentCtrtMapper.selectCtrtXls(params);
    }

}
