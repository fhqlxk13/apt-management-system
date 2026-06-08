package kr.or.ddit.domain.apt.mgmtOffice.employee.service;

import kr.or.ddit.domain.apt.mgmtOffice.employee.mapper.VisitVhclMapper;
import kr.or.ddit.domain.apt.mgmtOffice.employee.vo.VstVhclRsvtVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class VisitVhclServiceImpl
        implements IVisitVhclService {

    private final VisitVhclMapper visitVhclMapper;

    /**
     * 방문차량 목록 조회
     */
    @Override
    public List<VstVhclRsvtVO> getVisitVehicleList(
            String aptCmplexNo
    ) {

        return visitVhclMapper
                .selectVisitVehicleList(aptCmplexNo);
    }

    /**
     * 방문차량 등록
     */
    @Override
    public void registerVisitVehicle(
            VstVhclRsvtVO vo
    ) {

        visitVhclMapper
                .insertVisitVehicle(vo);
    }

    /**
     * 방문차량 상세 조회
     */
    @Override
    public VstVhclRsvtVO getVisitVehicle(
            String vstVhclRsvtNo
    ) {

        return visitVhclMapper
                .selectVisitVehicle(vstVhclRsvtNo);
    }

    /**
     * 방문차량 수정
     */
    @Override
    public void modifyVisitVehicle(
            VstVhclRsvtVO vo
    ) {

        visitVhclMapper
                .updateVisitVehicle(vo);
    }

    /**
     * 방문차량 삭제
     */
    @Override
    public void removeVisitVehicle(
            String vstVhclRsvtNo
    ) {

        visitVhclMapper
                .deleteVisitVehicle(vstVhclRsvtNo);
    }
}