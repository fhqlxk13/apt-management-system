package kr.or.ddit.domain.apt.mgmtOffice.reservation.scheduler;

import kr.or.ddit.domain.apt.mgmtOffice.reservation.mapper.IPublicFacilityReservationMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

/**
 * Scheduler란? 정해진 시간마다 자동으로 실행되는 작업입니다.
 * 왜 사용? 예약 시간이 지난 자원을 다시 OPEN 상태로 돌리기 위해 사용합니다.
 */
@Component
@RequiredArgsConstructor
public class PublicFacilityReservationScheduler {

    private final IPublicFacilityReservationMapper mapper;

    /*
     * 1분마다 종료된 예약 자원을 OPEN으로 복구합니다.
     */
    @Scheduled(cron = "0 * * * * *")
    @Transactional
    public void releaseExpiredFacilityItems() {
        mapper.updateItemStatusOpenForExpired();
    }
}