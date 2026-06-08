package kr.or.ddit.domain.apt.main.service;

import kr.or.ddit.common.file.mapper.IAttachFileMapper;
import kr.or.ddit.common.file.service.IAttachFileService;
import kr.or.ddit.common.file.vo.AttachFileVO;
import kr.or.ddit.common.model.PaginationInfoVO;
import kr.or.ddit.domain.apt.apiApartment.vo.AptHoTyDTO;
import kr.or.ddit.domain.apt.board.ann.mapper.IAptAnnBoardPostMapper;
import kr.or.ddit.domain.apt.board.ann.vo.AptAnnBoardPostVO;
import kr.or.ddit.domain.apt.main.dto.AptMainPageDTO;
import kr.or.ddit.domain.apt.main.mapper.IAptComplexMapper;
import kr.or.ddit.domain.apt.main.vo.AptComplexVO;
import kr.or.ddit.domain.apt.main.vo.AptDetailGridDTO;
import kr.or.ddit.domain.apt.main.vo.AptDetailVO;
import kr.or.ddit.domain.apt.main.vo.ComplexEditDTO;
import kr.or.ddit.domain.apt.mgmtOffice.main.mapper.IMgmtOfficeMapper;
import kr.or.ddit.domain.apt.mgmtOffice.main.vo.MgmtOfficeVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import tools.jackson.databind.ObjectMapper;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Service
@Slf4j
public class AptComplexServiceImpl implements IAptComplexService {

    @Autowired
    private IAptComplexMapper aptComplexMapper;

    @Autowired
    private IMgmtOfficeMapper imgmtOfficeMapper;

    @Autowired
    private IAttachFileService attachFileService;

    @Autowired
    private IAptAnnBoardPostMapper aptAnnBoardPostMapper;

   /* @Override
    public AptComplexVO selectAptDetailList(String aptCmplexNo) {
        return aptComplexMapper.selectAptDetailList(aptCmplexNo);
    }*/


    /* mgmtOfc 번호로 aptComplexVO 가져오는 메서드 입니다 도선호*/
    @Override
    public AptComplexVO selectMgmtOfcNoAptComplex(String mgmtOfcNo) {
        return aptComplexMapper.selectMgmtOfcNoAptComplex(mgmtOfcNo);
    }

    /* 단지구조관리 페이지에서 사용할 DTO를 뽑아오는 메서드입니다.*/
    @Override
    public List<AptDetailGridDTO> selectComplexList(String mgmtOfcNo) {

        // mgmt 번호로 아파트 vo 가져오기
        AptComplexVO aptComplexVO = selectMgmtOfcNoAptComplex(mgmtOfcNo);

        // 관리사무소에 연결된 단지가 없는 경우
        if (aptComplexVO == null) {
            return List.of();
        }

        String aptCmplexNo = aptComplexVO.getAptCmplexNo();


        return aptComplexMapper.selectComplexList(aptCmplexNo);
    }

    @Override
    public String selectOneAptCmplexByMgmtOfcNo(String mgmtOfcNo) {
        return aptComplexMapper.selectOneAptCmplexByMgmtOfcNo(mgmtOfcNo);
    }

    /**
     * 아파트 페이지 공통부분(헤더,푸터) DTO
     * @Author 이용로
     * @param aptCmplexNo
     * @return AptMainPageDTO.ResponseDTO (아파트, 관리사무소만 데이터 초기화)
     */
    @Override
    public AptMainPageDTO.ResponseDto selectAptCommonDTO(String aptCmplexNo) {
        AptMainPageDTO.ResponseDto resp = new AptMainPageDTO.ResponseDto();

        // 아파트 정보 세팅
        AptComplexVO aptComplexVO = aptComplexMapper.selectAptComplex(aptCmplexNo);
        if(aptComplexVO != null){
            AptMainPageDTO.AptComplexInfo aptComplexInfo = new AptMainPageDTO.AptComplexInfo();
            BeanUtils.copyProperties(aptComplexVO, aptComplexInfo);
            resp.setAptComplexInfo(aptComplexInfo);
        }

        // 관리사무소 정보 세팅
        MgmtOfficeVO mgmtOfficeVO = imgmtOfficeMapper.selectOneMgmtOffice(aptCmplexNo);
        if(mgmtOfficeVO != null){
            AptMainPageDTO.MgmtOfficeInfo mgmtOfficeInfo = new AptMainPageDTO.MgmtOfficeInfo();
            BeanUtils.copyProperties(mgmtOfficeVO, mgmtOfficeInfo);
            resp.setMgmtOfficeInfo(mgmtOfficeInfo);
        }
        return resp;
    }

    /**
     * 아파트 메인페이지 DTO 셀렉트
     * @author 이용로
     * @param aptCmplexNo 아파트 단지 코드
     * @return AptMainPageDTO.ResponseDto 아파트 메인페이지 DTO
     */
    @Override
    public AptMainPageDTO.ResponseDto selectAptMainDTO(String aptCmplexNo) {
        AptMainPageDTO.ResponseDto resp = this.selectAptCommonDTO(aptCmplexNo);

        // 공지 게시판 글 세팅
        List<AptAnnBoardPostVO> annBoardPostVOList =  aptAnnBoardPostMapper.selectLatest(aptCmplexNo, 3);
        List<AptMainPageDTO.AnnBoardPostInfo> annBoardPostInfoList = new ArrayList<>();
        if(annBoardPostVOList != null){
            for(AptAnnBoardPostVO board : annBoardPostVOList){
                AptMainPageDTO.AnnBoardPostInfo temp = new AptMainPageDTO.AnnBoardPostInfo();
                BeanUtils.copyProperties(board, temp);
                annBoardPostInfoList.add(temp);
            }
            resp.setAnnBoardPostInfoList(annBoardPostInfoList);
        }

        return resp;
    }

    @Override
    public List<String> selectSidoList() {
        return aptComplexMapper.selectSidoList();
    }

    @Override
    public int selectMainAptCount(String sidoNm, String keyword) {
        return aptComplexMapper.selectMainAptCount(sidoNm, keyword);
    }

    @Override
    public List<AptComplexVO> selectMainAptList(PaginationInfoVO<AptComplexVO> pagingVO,
                                                String sidoNm,
                                                String keyword) {
        return aptComplexMapper.selectMainAptList(pagingVO, sidoNm, keyword);
    }

    @Override
    public List<AptHoTyDTO> getHoTypeList(String aptCmplexNo) {

        List<AptHoTyDTO> list =
                aptComplexMapper.getHoTypeList(aptCmplexNo);

        for (AptHoTyDTO dto : list) {

            Long imageFileNo = dto.getImageFileNo();

            if(imageFileNo == null){
                continue;
            }

            List<AttachFileVO> fileList =
                    attachFileService.setFileMetaData(String.valueOf(imageFileNo));

            if(fileList == null || fileList.isEmpty()){
                continue;
            }

            AttachFileVO file = fileList.get(0);

            dto.setGoogleId(file.getGoogleId());
        }

        return list;
    }

    @Override
    public List<AttachFileVO> getLayoutFiles(String aptCmplexNo) {

        AptComplexVO complex = aptComplexMapper.selectAptComplex(aptCmplexNo);

        if (complex == null) {
            return new ArrayList<>();
        }

        if (
                complex.getImgFileNo() == null
                        || complex.getImgFileNo().isBlank()
        ) {
            return new ArrayList<>();
        }

        List<AttachFileVO> fileList =
                attachFileService.setFileMetaData(complex.getImgFileNo());

        if (fileList == null) {
            return new ArrayList<>();
        }

        return fileList.stream()
                .filter(file -> "layoutImage".equals(file.getCat()))
                .sorted(Comparator.comparingInt(AttachFileVO::getFileSortOrder))
                .toList();
    }


}
