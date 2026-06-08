package kr.or.ddit.domain.central.admin.service;

import kr.or.ddit.domain.apt.main.vo.AptComplexVO;
import kr.or.ddit.domain.central.admin.mapper.AnnRegisterMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class AnnRegisterServiceImpl implements IAnnRegisterService{


    private final AnnRegisterMapper annRegisterMapper;


    @Transactional
    @Override
    public void insertAnn(Map<String, Object> params) {

        String aptCmplexNo = (String) params.get("aptCmplexNo");

        // board_no 없으면 자동 생성 (insertAnn 전에 먼저 체크!)
        String boardNo = annRegisterMapper.selectBoardNo(aptCmplexNo);
        if (boardNo == null) {
            annRegisterMapper.insertBoardInstance(aptCmplexNo);
        }

        annRegisterMapper.insertAnn(params); // 그 다음에 실행

        List<String> rentLstgNoList = (List<String>) params.get("rentLstgNoList");
        if (rentLstgNoList != null && !rentLstgNoList.isEmpty()) {
            for (String rentLstgNo : rentLstgNoList) {
                Map<String, Object> updateParams = new HashMap<>();
                updateParams.put("rentLstgNo", rentLstgNo);
                updateParams.put("annNo", params.get("annNo"));
                annRegisterMapper.updateRentListStts(updateParams);
            }
        }
    }


    @Override
    public List<String> selectSidoList() {
        return annRegisterMapper.selectSidoList();
    }

    @Override
    public List<String> selectSigunguList(String sidoNm) {
        return annRegisterMapper.selectSigunguList(sidoNm);
    }

    @Override
    public List<String> selectEmdList(String sidoNm, String sigunguNm) {
        return annRegisterMapper.selectEmdList(sidoNm, sigunguNm);
    }

    @Override
    public List<AptComplexVO> selectAptList(String sidoNm, String sigunguNm, String emdNm) {
        return annRegisterMapper.selectAptList(sidoNm, sigunguNm, emdNm);
    }

    @Override
    public Map<String, Object> selectOneAptDetail(String aptCmplexNo) {
        Map<String, Object> result = new HashMap<>();
        result.put("dorojuso", annRegisterMapper.selectDorojuso(aptCmplexNo));
        result.put("hoTyNo", annRegisterMapper.selectHoTyNo(aptCmplexNo));
        return result;

    }


    @Override
    public List<Map<String, Object>> selectSbmsnDocList(List<String> rentLstgNoList) {
        return annRegisterMapper.selectSbmsnDocList(rentLstgNoList);
    }

    @Transactional
    @Override
    public List<Map<String, Object>> selectRentList(String aptCmplexNo) {
        return annRegisterMapper.selectRentList(aptCmplexNo);
    }
}
