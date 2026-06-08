package kr.or.ddit.domain.apt.mgmtOffice.main.service;

import kr.or.ddit.domain.apt.main.mapper.IAptComplexMapper;
import kr.or.ddit.domain.apt.main.vo.AptDetailGridDTO;
import kr.or.ddit.domain.apt.mgmtOffice.main.mapper.IMgmtAptComplexEditMapper;
import kr.or.ddit.domain.apt.mgmtOffice.main.vo.UpdateBuildingStructureDTO;
import kr.or.ddit.domain.apt.mgmtOffice.main.vo.UpdateHoStatusDTO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

@Slf4j
@Service
public class MgmtAptComplexEditServiceImpl implements IMgmtAptComplexEditService{

    @Autowired
    IAptComplexMapper aptComplexMapper;

    @Autowired
    IMgmtAptComplexEditMapper aptComplexEditMapper;

    @Override
    @Transactional
    public void updateBuildingStructure(UpdateBuildingStructureDTO dto) {

        log.info("구조 변경 시작 : {}", dto);

        if(dto.getTotalFloor() <= 0){
            throw new RuntimeException(
                    "총 층수는 1 이상이어야 합니다."
            );
        }

        if(dto.getHoPerFloor() <= 0){
            throw new RuntimeException(
                    "층별 세대수는 1 이상이어야 합니다."
            );
        }

        Set<String> validHoSet = buildValidHoSet(
                                    dto.getTotalFloor(),
                                    dto.getHoPerFloor()
                                );

        List<AptDetailGridDTO> currentHoList = aptComplexMapper.selectAllHoByDong(dto.getDongNo());

        Set<String> currentHoSet = new HashSet<>();

        for(AptDetailGridDTO ho : currentHoList){
            currentHoSet.add(ho.getHo());
        }

        for(String validHo : validHoSet){
            if(!currentHoSet.contains(validHo)){

                AptDetailGridDTO newHo = new AptDetailGridDTO();

                newHo.setHoNo(buildHoNo(dto.getDongNo(),validHo));
                newHo.setDongNo(dto.getDongNo());

                newHo.setFloor(extractFloor(validHo));
                newHo.setHo(validHo);
                newHo.setHoSttsCd("EMPTY");

                aptComplexEditMapper.insertAptDetail(newHo);
            }
        }

        for(AptDetailGridDTO ho : currentHoList){

            String currentHo = ho.getHo();

            if(validHoSet.contains(currentHo)){
                if("STRUCT_REMOVED".equals(ho.getHoSttsCd())){
                    log.info("구조 복구 대상 : {}", currentHo);
                    aptComplexEditMapper.restoreStructureHo(ho.getHoNo());
                }
            }else{
                if("LIVE".equals(ho.getHoSttsCd())){
                    throw new RuntimeException(ho.getHo() + "호가 현재 입주중이라 구조 제거할 수 없습니다.");
                }

                log.info("구조 제거 대상 : {}", currentHo);

                aptComplexEditMapper.updateStructureRemoved(ho.getHoNo());

            }

        }

        aptComplexEditMapper.recalculateMaxFloor(dto.getAptCmplexNo());

        aptComplexEditMapper.recalculateTotalHousehold(dto.getAptCmplexNo());

        aptComplexEditMapper.updateDongName(dto);

    }

    @Transactional
    @Override
    public void updateHoStatus(UpdateHoStatusDTO dto) {

        if(dto.getHoNoList() == null
                || dto.getHoNoList().isEmpty()){

            throw new RuntimeException(
                    "선택된 호가 없습니다."
            );
        }

        aptComplexEditMapper.updateHoStatus(dto);

        aptComplexEditMapper.recalculateTotalHousehold(dto.getAptCmplexNo());
    }

    @Transactional
    @Override
    public void updateHoType(
            Map<String, Object> paramMap
    ) {

        List<String> hoNoList = (List<String>) paramMap.get("hoNoList");

        String hoTyNo = (String) paramMap.get("hoTyNo");

        if(hoNoList == null || hoNoList.isEmpty()){
            throw new RuntimeException(
                    "선택된 호가 없습니다."
            );
        }

        if(hoTyNo == null || hoTyNo.isBlank()){
            throw new RuntimeException(
                    "평형 타입을 선택해주세요."
            );
        }

        aptComplexEditMapper.updateHoType(paramMap);
    }

    private Set<String> buildValidHoSet(
            int totalFloor
            , int hoPerFloor){
        Set<String> validHoSet = new HashSet<>();

        for(int floor = 1; floor <= totalFloor; floor++){

            for(int hoSeq = 1; hoSeq <= hoPerFloor; hoSeq++){

                String ho = floor + String.format("%02d", hoSeq);

                validHoSet.add(ho);
            }
        }

        return validHoSet;

    }

    private String buildHoNo(String dongNo, String ho){
        return dongNo + "_" + ho;
    }

    private int extractFloor(String ho){

        return Integer.parseInt(
                ho.substring(
                        0,
                        ho.length() - 2
                )
        );

    }
}
