package kr.or.ddit.domain.apt.mgmtOffice.partner.service;

import kr.or.ddit.domain.apt.mgmtOffice.partner.vo.PartnerSearchVO;
import kr.or.ddit.domain.apt.mgmtOffice.partner.vo.PartnerStatVO;
import kr.or.ddit.domain.apt.mgmtOffice.partner.vo.PartnerVO;

import java.util.List;

/**
 * 협력업체 Service 인터페이스
 * - Controller에서 사용할 협력업체 기능 목록
 */
public interface IPartnerService {

    /** 관리사무소 기준 아파트단지번호 조회 */
    String selectAptCmplexNoByMgmtOfcNo(String mgmtOfcNo);

    /** 관리사무소 기준 아파트단지명 조회 */
    String selectAptCmplexNmByMgmtOfcNo(String mgmtOfcNo);

    /** 협력업체 목록 건수 조회 */
    int selectPartnerCount(PartnerSearchVO searchVO);

    /** 협력업체 목록 조회 */
    List<PartnerVO> selectPartnerList(PartnerSearchVO searchVO);

    /** 협력업체 현황 조회 */
    PartnerStatVO selectPartnerStat(PartnerSearchVO searchVO);

    /** 업종명 목록 조회 */
    List<String> selectBizTypeList(String aptCmplexNo);

    /** 협력업체 등록 */
    int insertPartner(PartnerVO partnerVO);

    /** 협력업체 수정 */
    int updatePartner(PartnerVO partnerVO);

    /** 협력업체 비활성화 */
    int deactivatePartner(String partnerNo, String aptCmplexNo);

    /** 협력업체 활성화 - PARTNER.USE_YN 값을 Y로 변경*/
    int activatePartner(String partnerNo, String aptCmplexNo);
}
