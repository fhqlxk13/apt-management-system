package kr.or.ddit.domain.apt.complaint.service;

import kr.or.ddit.common.enums.ServiceResult;
import kr.or.ddit.common.model.PaginationInfoVO;
import kr.or.ddit.domain.apt.complaint.vo.CvplHstryVO;
import kr.or.ddit.domain.apt.complaint.vo.CvplVO;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.security.GeneralSecurityException;
import java.util.List;

public interface ICvplService {
    ServiceResult applyCvpl(CvplVO cvplVO, MultipartFile[] attachFiles) throws GeneralSecurityException, IOException;

    // 아파트의 해당 회원번호의 입주민 민원 목록 조회
    List<CvplVO> selectCvplListByAptCmplexNo(String aptCmplexNo, String userNo);

    // cvplVO에 세팅된 입주민 민원 전체 갯수 조회
    int selectCvplCount(CvplVO cvpl);

    // 페이징 처리할 민원리스트 조회
    List<CvplVO> selectMyCvplList(PaginationInfoVO<CvplVO> page);

    List<CvplVO> selectCvplListAllByAptCmplexNo(String aptCmplexNo);

    CvplVO selectCvplDetailByCvplNo(String cvplNo);

    // 민원 취하
    int cancelCvpl(String cvplNo);

    int selectCvplCountByAptCmplexNo(PaginationInfoVO<CvplVO> searchVO);

    List<CvplVO> selectCvplListAllByAptCmplexNoPaged(PaginationInfoVO<CvplVO> page);
}
