package kr.or.ddit.domain.apt.mgmtOffice.partner.service;

import kr.or.ddit.domain.apt.mgmtOffice.partner.mapper.IPartnerMapper;
import kr.or.ddit.domain.apt.mgmtOffice.partner.vo.PartnerSearchVO;
import kr.or.ddit.domain.apt.mgmtOffice.partner.vo.PartnerStatVO;
import kr.or.ddit.domain.apt.mgmtOffice.partner.vo.PartnerVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 협력업체 Service 구현체
 * - 복잡한 가공 없이 Mapper 호출 중심 구성
 */
@Service
@RequiredArgsConstructor
public class PartnerServiceImpl implements IPartnerService {

    /** 협력업체 Mapper */
    private final IPartnerMapper partnerMapper;

    /** 관리사무소 기준 아파트단지번호 조회 */
    @Override
    public String selectAptCmplexNoByMgmtOfcNo(String mgmtOfcNo) {
        return partnerMapper.selectAptCmplexNoByMgmtOfcNo(mgmtOfcNo);
    }

    /** 관리사무소 기준 아파트단지명 조회 */
    @Override
    public String selectAptCmplexNmByMgmtOfcNo(String mgmtOfcNo) {
        return partnerMapper.selectAptCmplexNmByMgmtOfcNo(mgmtOfcNo);
    }

    /** 협력업체 목록 건수 조회 */
    @Override
    public int selectPartnerCount(PartnerSearchVO searchVO) {
        return partnerMapper.selectPartnerCount(searchVO);
    }

    /** 협력업체 목록 조회 */
    @Override
    public List<PartnerVO> selectPartnerList(PartnerSearchVO searchVO) {
        return partnerMapper.selectPartnerList(searchVO);
    }

    /** 협력업체 현황 조회 */
    @Override
    public PartnerStatVO selectPartnerStat(PartnerSearchVO searchVO) {
        return partnerMapper.selectPartnerStat(searchVO);
    }

    /** 업종명 목록 조회 */
    @Override
    public List<String> selectBizTypeList(String aptCmplexNo) {
        return partnerMapper.selectBizTypeList(aptCmplexNo);
    }

    /** 협력업체 등록 */
    @Override
    @Transactional
    public int insertPartner(PartnerVO partnerVO) {
        return partnerMapper.insertPartner(partnerVO);
    }

    /** 협력업체 수정 */
    @Override
    @Transactional
    public int updatePartner(PartnerVO partnerVO) {
        return partnerMapper.updatePartner(partnerVO);
    }

    /** 협력업체 비활성화 */
    @Override
    @Transactional
    public int deactivatePartner(String partnerNo, String aptCmplexNo) {
        return partnerMapper.deactivatePartner(partnerNo, aptCmplexNo);
    }

    /**
     * 협력업체 활성화- Mapper의 활성화 쿼리 호출
     */
    @Override
    public int activatePartner(String partnerNo, String aptCmplexNo) {
        /* 협력업체 활성화 쿼리 실행 */
        return partnerMapper.activatePartner(partnerNo, aptCmplexNo);
    }
}
