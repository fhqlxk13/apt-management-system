package kr.or.ddit.domain.member.resident.service;

import kr.or.ddit.domain.central.dto.FacilityInfoDTO;
import kr.or.ddit.domain.member.resident.dto.ResidentFacilityHistoryDTO;
import kr.or.ddit.domain.member.resident.mapper.IResidentFacilityMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 입주민 시설관리이력 Service 구현체
 *
 * Service란?
 * → Controller와 Mapper 사이에서 업무 로직을 처리하는 클래스.
 */
@Service
@RequiredArgsConstructor
public class ResidentFacilityServiceImpl implements IResidentFacilityService {

    private final IResidentFacilityMapper residentFacilityMapper;

    @Override
    public String getResidentAptCmplexNo(String userNo) {
        return residentFacilityMapper.selectResidentAptCmplexNo(userNo);
    }

    @Override
    public FacilityInfoDTO getAptInfo(String aptCmplexNo) {
        return residentFacilityMapper.selectAptInfo(aptCmplexNo);
    }

    @Override
    public List<ResidentFacilityHistoryDTO> getFacilityStatusCardList(String aptCmplexNo) {
        return residentFacilityMapper.selectFacilityStatusCardList(aptCmplexNo);
    }

    @Override
    public List<FacilityInfoDTO> getResidentFacilityInfoList(
            String aptCmplexNo,
            String facilityTyCd,
            String facilityNm,
            String dongNo,
            String locCn,
            String sortColumn,
            String sortOrder,
            int startRow,
            int endRow
    ) {
        return residentFacilityMapper.selectResidentFacilityInfoList(
                aptCmplexNo,
                facilityTyCd,
                facilityNm,
                dongNo,
                locCn,
                sortColumn,
                sortOrder,
                startRow,
                endRow
        );
    }

    @Override
    public int getResidentFacilityInfoCount(
            String aptCmplexNo,
            String facilityTyCd,
            String facilityNm,
            String dongNo,
            String locCn
    ) {
        return residentFacilityMapper.selectResidentFacilityInfoCount(
                aptCmplexNo,
                facilityTyCd,
                facilityNm,
                dongNo,
                locCn
        );
    }

    @Override
    public List<FacilityInfoDTO> getFacilityDongList(String aptCmplexNo) {
        return residentFacilityMapper.selectFacilityDongList(aptCmplexNo);
    }

    @Override
    public int getFacilityHistoryCount(ResidentFacilityHistoryDTO dto) {
        return residentFacilityMapper.selectFacilityHistoryCount(dto);
    }

    @Override
    public List<ResidentFacilityHistoryDTO> getFacilityHistoryList(ResidentFacilityHistoryDTO dto) {
        return residentFacilityMapper.selectFacilityHistoryList(dto);
    }

    @Override
    public List<FacilityInfoDTO> getReservablePublicFacilityCardList(String aptCmplexNo) {
        /*
         * Service란?
         * Controller와 Mapper 사이에서 업무 로직을 담당하는 계층입니다.
         * 여기서는 Controller가 SQL을 직접 부르지 않도록 Mapper 호출을 감싸줍니다.
         */
        return residentFacilityMapper.selectReservablePublicFacilityCardList(aptCmplexNo);
    }

}