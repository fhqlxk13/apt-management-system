package kr.or.ddit.domain.central.admin.service;

import kr.or.ddit.common.notification.dto.NotificationDTO;
import kr.or.ddit.common.notification.service.NotificationService;
import kr.or.ddit.common.util.BusinessException;
import kr.or.ddit.domain.central.admin.dto.AplctDTO;
import kr.or.ddit.domain.central.admin.mapper.IAplctMapper;
import kr.or.ddit.domain.central.rentCtrt.mapper.IRentCtrtMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;
import java.util.concurrent.ThreadLocalRandom;
import java.util.stream.Collectors;

@Slf4j
@Transactional(rollbackFor = Exception.class)
@Service
public class AplctServiceImpl implements IAplctService {

    @Autowired
    private IAplctMapper aplctMapper;

    @Autowired
    private IRentCtrtMapper rentCtrtMapper;

    @Autowired
    private NotificationService notificationService;

    @Override
    public List<AplctDTO> selectAplctList() {
        return aplctMapper.selectAplctList();
    }

    /**
     * 신청 승인, 거절
     *
     * @param updateList
     * @param manager
     * @return
     * @author 이용로
     */
    @Override
    public int approveAplct(List<Map<String, Object>> updateList, String manager) {

        int cnt = aplctMapper.updateAplctStatus(updateList);

        if (cnt == 0) {
            throw new RuntimeException("청약 상태 업데이트 실패");
        }

        /* 알림 발송 */
        for (Map<String, Object> map : updateList) {
            String aplctNo = (String) map.get("aplctNo");
            String stts = String.valueOf(map.get("aplctSttsCd"));

            String userNo = rentCtrtMapper.getUserNo(aplctNo);

            if ("WINNER".equals(stts)) {
                notificationService.send(
                        userNo,
                        NotificationDTO.success(
                                "청약 신청 승인",
                                "청약 신청이 접수되었습니다. 제출 서류를 확인해주세요.",
                                "/contract/historyDetail.do?aplctNo=" + aplctNo
                        )
                );
            }

            if("QUALIFIED".equals(stts)){
                notificationService.send(
                        userNo,
                        NotificationDTO.success(
                                "서류검토완료",
                                "서류검토가 끝났습니다. 담당자와 계약을 진행해주세요"
                        )
                );
            }
        }

        List<Map<String, Object>> qualifiedList = updateList.stream()
                .filter(map -> "QUALIFIED".equals(map.get("aplctSttsCd")))
                .collect(Collectors.toList());


        if (!qualifiedList.isEmpty()) {
            // 각 리스트에 대해 업데이트할 데이터 생성 및 매핑
            for (Map<String, Object> map : qualifiedList) {
                // 시퀀스 가져오기
                String seq = rentCtrtMapper.getNextRentCtrtSeq();
                // 신청 번호 추가
                String aplctNo = (String) map.get("aplctNo");
                String rentCtrtNo = aplctNo + "_" + seq;
                map.put("rentCtrtNo", rentCtrtNo);

                // 신청한 공고의 매물 리스트 조회
                List<String> rentLstgNo = aplctMapper.getRentLstgNoByAplctNo(aplctNo);

                // 무작위 배정
                if (rentLstgNo == null || rentLstgNo.isEmpty()) {
                    throw new BusinessException("선택 가능한 매물이 없습니다."); // 커스텀exception처리
                }
                int randomIndex = ThreadLocalRandom.current().nextInt(rentLstgNo.size());
                String selected = rentLstgNo.get(randomIndex);
                map.put("rentLstgNo", selected);

                // 매물 상태 거래중(ing)으로 업데이트
                int res = aplctMapper.updateDealSttsCdByRentLstgNo(selected);
                if (res < 1) throw new RuntimeException("매물 상태 변경에 실패했습니다.");
            }
            log.info("### qualifiedList {}", qualifiedList);

            int res1 = rentCtrtMapper.insertRentCtrt(qualifiedList);

            log.info("### insert result = {}", res1);

            if (res1 == 0) throw new RuntimeException("가계약 생성 실패");

            int res2 = rentCtrtMapper.insertCtrtMgr(qualifiedList, manager);
            if (res2 == 0) throw new RuntimeException("담당자 배정 실패");
        }
        return cnt;
    }
}
