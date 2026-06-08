package kr.or.ddit.domain.apt.apiApartment.service;

import kr.or.ddit.domain.apt.apiApartment.mapper.IAptApiMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

@Service
public class SeqServiceImpl implements ISeqService{

    @Autowired
    private IAptApiMapper aptMapper;

    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public String getMgmtSeq() {
        return String.valueOf(aptMapper.getMgmtOfcNoSeq());
    }

    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public String getMemberSeq() {
        return String.valueOf(aptMapper.getMemberSeq());
    }
}
