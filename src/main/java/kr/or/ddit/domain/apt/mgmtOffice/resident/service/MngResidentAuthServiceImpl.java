package kr.or.ddit.domain.apt.mgmtOffice.resident.service;

import kr.or.ddit.common.notification.dto.NotificationDTO;
import kr.or.ddit.common.notification.service.NotificationService;
import kr.or.ddit.domain.apt.mgmtOffice.resident.mapper.IMngResidentAuthMapper;
import kr.or.ddit.domain.apt.mgmtOffice.resident.vo.MngResidentAuthVO;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class MngResidentAuthServiceImpl implements IMngResidentAuthService {

    private final IMngResidentAuthMapper mapper;

    @Autowired
    private NotificationService notificationService;

    @Override
    public List<MngResidentAuthVO> selectResidentAuthList() {
        return mapper.selectResidentAuthList();
    }

    @Override
    public int rejectResidentAuth(MngResidentAuthVO vo) {
        return mapper.rejectResidentAuth(vo);
    }

    @Override
    @Transactional
    public int approveResidentAuth(MngResidentAuthVO vo) {

        MngResidentAuthVO rqst = mapper.selectResidentAuthByRqstNo(Integer.parseInt(vo.getRqstNo()));



        Map<String, Object> param = new HashMap<>();

        String userNo = rqst.getUserNo();

        param.put("userNo", rqst.getUserNo());
        param.put("hoNo", rqst.getHoNo());

        mapper.updateResidentLive(param);
        mapper.updateAuth(rqst.getUserNo());

        notificationService.send(
                userNo,
                NotificationDTO.success(
                        "입주신청 승인",
                        "입주 신청서가 승인되었습니다. 새로 로그인 해주세요",
                        "/forceLogout"
                )
        );

        return mapper.approveResidentAuth(vo);
    }



}
