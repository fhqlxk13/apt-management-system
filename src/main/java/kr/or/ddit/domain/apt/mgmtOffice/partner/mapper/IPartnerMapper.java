package kr.or.ddit.domain.apt.mgmtOffice.partner.mapper;

import kr.or.ddit.domain.apt.mgmtOffice.partner.vo.PartnerSearchVO;
import kr.or.ddit.domain.apt.mgmtOffice.partner.vo.PartnerStatVO;
import kr.or.ddit.domain.apt.mgmtOffice.partner.vo.PartnerVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 협력업체 Mapper 인터페이스
 * - 협력업체 목록, 등록, 수정, 비활성화 DB 처리
 */
@Mapper
public interface IPartnerMapper {

    /** 관리사무소 기준 아파트단지번호 조회 */
    String selectAptCmplexNoByMgmtOfcNo(@Param("mgmtOfcNo") String mgmtOfcNo);

    /** 관리사무소 기준 아파트단지명 조회 */
    String selectAptCmplexNmByMgmtOfcNo(@Param("mgmtOfcNo") String mgmtOfcNo);

    /** 협력업체 목록 건수 조회 */
    int selectPartnerCount(PartnerSearchVO searchVO);

    /** 협력업체 목록 조회 */
    List<PartnerVO> selectPartnerList(PartnerSearchVO searchVO);

    /** 협력업체 현황 조회 */
    PartnerStatVO selectPartnerStat(PartnerSearchVO searchVO);

    /** 업종명 목록 조회 */
    List<String> selectBizTypeList(@Param("aptCmplexNo") String aptCmplexNo);

    /** 협력업체 등록 */
    int insertPartner(PartnerVO partnerVO);

    /** 협력업체 수정 */
    int updatePartner(PartnerVO partnerVO);

    /** 협력업체 비활성화 */
    int deactivatePartner(@Param("partnerNo") String partnerNo, @Param("aptCmplexNo") String aptCmplexNo);

    /** 협력업체 활성화  */
    int activatePartner(@Param("partnerNo") String partnerNo, @Param("aptCmplexNo") String aptCmplexNo);
}
