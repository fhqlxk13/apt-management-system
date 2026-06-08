package kr.or.ddit.domain.apt.complaint.mapper;

import kr.or.ddit.common.model.PaginationInfoVO;
import kr.or.ddit.domain.apt.complaint.vo.CvplHstryVO;
import kr.or.ddit.domain.apt.complaint.vo.CvplVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface ICvplMapper {
    int insertCvplApply(CvplVO cvplVO);

    int insertCvplHstry(CvplHstryVO cvplHstryVO);

    List<CvplVO> selectCvplListByAptCmplexNo(@Param("aptCmplexNo") String aptCmplexNo,@Param("userNo") String userNo);

    int selectCvplCount(CvplVO cvpl);

    List<CvplVO> selectMyCvplList(PaginationInfoVO<CvplVO> page);

    List<CvplVO> selectCvplListAllByAptCmplexNo(String aptCmplexNo);

    CvplVO selectOneCvplBrief(String cvplNo);

    CvplVO selectOneCvplDetailByCvplNo(String cvplNo);

    String selectLatestCvplAns(String cvplNo);

    int updateCvplSttsToCancel(String cvplNo);

    int selectCvplCountByAptCmplexNo(PaginationInfoVO<CvplVO> page);

    List<CvplVO> selectCvplListAllByAptCmplexNoPaged(PaginationInfoVO<CvplVO> page);
}
