package kr.or.ddit.domain.apt.main.service;

import kr.or.ddit.common.file.vo.AttachFileVO;
import kr.or.ddit.common.model.PaginationInfoVO;
import kr.or.ddit.domain.apt.apiApartment.vo.AptHoTyDTO;
import kr.or.ddit.domain.apt.main.dto.AptMainPageDTO;
import kr.or.ddit.domain.apt.main.vo.AptComplexVO;
import kr.or.ddit.domain.apt.main.vo.AptDetailGridDTO;

import java.util.List;

public interface IAptComplexService {

   /* public AptComplexVO selectAptDetailList(String aptCmplexNo);*/


   // 헤더, 푸터 용 DTO 셀렉트
   AptMainPageDTO.ResponseDto selectAptCommonDTO(String aptCmplexNo);

   // 아파트 메인페이지 DTO 셀렉트
   AptMainPageDTO.ResponseDto selectAptMainDTO(String aptCmplexNo);

   List<String> selectSidoList();

   int selectMainAptCount(String sidoNm, String keyword);

   List<AptComplexVO> selectMainAptList(PaginationInfoVO<AptComplexVO> pagingVO,
                                        String sidoNm,
                                        String keyword);

   AptComplexVO selectMgmtOfcNoAptComplex(String mgmtOfcNo);


   // mgmtOfc 번호로 일치하는 아파트의 AptDetailGridDTO List 가져오는 메서드
   List<AptDetailGridDTO> selectComplexList(String mgmtOfcNo);

   String selectOneAptCmplexByMgmtOfcNo(String mgmtOfcNo);

   List<AptHoTyDTO> getHoTypeList(String aptCmplexNo);

   List<AttachFileVO> getLayoutFiles(String aptCmplexNo);
}
