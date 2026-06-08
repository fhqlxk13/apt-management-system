package kr.or.ddit.domain.member.resident.service;

import kr.or.ddit.common.model.PaginationInfoVO;
import kr.or.ddit.domain.member.resident.mapper.IVstVhclMapper;
import kr.or.ddit.domain.member.resident.vo.MyAptVO;
import kr.or.ddit.domain.member.resident.vo.ResidentVO;
import kr.or.ddit.domain.member.resident.vo.VisitRegisterDTO;
import kr.or.ddit.domain.member.resident.vo.VstVhclRsvtVO;
import kr.or.ddit.domain.member.vo.CustomUser;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@Service
@Transactional
@Slf4j
public class ResidentVstVhclServiceImpl implements IResidentVstVhclService{

    @Autowired
    IVstVhclMapper vstVhclMapper;

    @Override
    public void registerVisit(
            VisitRegisterDTO dto
            , CustomUser principal, String aptCmplexNo) {

        try {

            String visitDateTime =
                    dto.getVisitDate()
                            + " "
                            + dto.getVisitHour()
                            + ":00";

            SimpleDateFormat sdf =
                    new SimpleDateFormat("yyyy-MM-dd HH:mm");

            Date vstYmd = sdf.parse(visitDateTime);

            ResidentVO resident =
                    (ResidentVO) principal.getMember();

            MyAptVO myApt = null;

            for (MyAptVO apt : resident.getMyAptList()) {

                if (aptCmplexNo.equals(apt.getAptCmplexNo())) {
                    myApt = apt;
                    break;
                }
            }

            if (myApt == null) {
                throw new RuntimeException("거주지 정보 없음");
            }


            String hoNo =
                    myApt.getHoNo();

            VstVhclRsvtVO vo =
                    new VstVhclRsvtVO();

            vo.setVstVhclTyCd(dto.getVstVhclTyCd());
            vo.setVstVhclNo(dto.getVstVhclNo());
            vo.setVstrNm(dto.getVstrNm());

            vo.setVstYmd(vstYmd);

            vo.setStayHr(dto.getStayHr());

            vo.setVstSttsCd("WAIT");

            vo.setVstPrpsCn(dto.getVstPrpsCn());

            vo.setUserNo(resident.getUserNo());

            vo.setHoNo(hoNo);

            vstVhclMapper.insertVisitReservation(vo);

        } catch (Exception e) {

            log.error("방문예약 등록 실패", e);

            throw new RuntimeException("방문예약 등록 실패");
        }
    }

    @Override
    public int deleteVisit(
            String rsvtNo,String userNo) {
        return vstVhclMapper.deleteVisit(rsvtNo,userNo);
    }

    @Override
    public void selectVisitList(

            PaginationInfoVO<VstVhclRsvtVO> pagingVO,

            String userNo,

            String aptCmplexNo
    ) {

        int totalRecord =
                vstVhclMapper.selectVisitCount(
                        userNo,
                        aptCmplexNo
                );

        pagingVO.setTotalRecord(totalRecord);

        List<VstVhclRsvtVO> dataList =
                vstVhclMapper.selectVisitList(
                        pagingVO,
                        userNo,
                        aptCmplexNo
                );

        pagingVO.setDataList(dataList);
    }
}
