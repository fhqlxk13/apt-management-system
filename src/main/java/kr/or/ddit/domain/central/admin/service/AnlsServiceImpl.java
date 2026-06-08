package kr.or.ddit.domain.central.admin.service;

import kr.or.ddit.domain.central.admin.mapper.IAnlsMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Service
public class AnlsServiceImpl implements IAnlsService {

    @Autowired
    IAnlsMapper anlsMapper;

    @Override
    public List<Map<String, Object>> getAnnList() {

        // 1. 진행중인 공고 리스트 가져오기
        List<Map<String, Object>> annList = anlsMapper.selectRecruitingAnnList();


        return List.of();
    }
}
