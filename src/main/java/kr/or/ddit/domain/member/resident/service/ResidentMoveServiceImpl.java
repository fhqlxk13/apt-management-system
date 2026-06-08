package kr.or.ddit.domain.member.resident.service;

import kr.or.ddit.domain.member.resident.mapper.IResidentMoveMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Service
@RequiredArgsConstructor
public class ResidentMoveServiceImpl implements IResidentMoveService {

    private final IResidentMoveMapper mapper;

    @Override
    public List<Map<String, Object>> selectHoList(String userNo, String aptCmplexNo) {
        Map<String, Object> params = new HashMap<>();
        params.put("userNo", userNo);
        params.put("aptCmplexNo", aptCmplexNo);
        return mapper.selectHoList(params);
    }

    @Transactional
    @Override
    public void insertMoveIn(Map<String, Object> params) {
        String mngNo = mapper.selectMngNo((String) params.get("aptCmplexNo"));
        log.info("mngNo: {}", mngNo);
        params.put("mngNo", mngNo);
        log.info("params: {}", params);
        mapper.insertMoveIn(params);
    }

    @Transactional
    @Override
    public void insertMoveOut(Map<String, Object> params) {
        String mngNo = mapper.selectMngNo((String) params.get("aptCmplexNo"));
        params.put("mngNo", mngNo);
        mapper.insertMoveOut(params);
        //mapper.updateInoutCd(params);
    }
}
