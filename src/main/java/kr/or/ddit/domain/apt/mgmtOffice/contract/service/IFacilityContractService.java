package kr.or.ddit.domain.apt.mgmtOffice.contract.service;

import kr.or.ddit.common.model.PaginationInfoVO;
import kr.or.ddit.domain.apt.mgmtOffice.contract.vo.FacilityContractDTO;
import kr.or.ddit.domain.apt.mgmtOffice.contract.vo.FacilityContractSearchVO;
import kr.or.ddit.domain.apt.mgmtOffice.contract.vo.FacilityContractSummaryVO;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.Map;

/**
 * 시설 계약 관리 Service 인터페이스
 */
public interface IFacilityContractService {

    /** 계약 목록 전체 건수 조회 */
    int selectContractTotalCount(FacilityContractSearchVO search);

    /** 계약 목록 조회 */
    List<FacilityContractDTO> selectContractList(
            FacilityContractSearchVO search,
            PaginationInfoVO<FacilityContractDTO> pagingVO
    );

    /** 계약 현황 카드 조회 */
    FacilityContractSummaryVO selectContractSummary(FacilityContractSearchVO search);

    /** 계약 상세 조회 */
    FacilityContractDTO selectContractDetail(String mgmtOfcNo, String contNo);

    /** 계약유형 공통코드 목록 조회 */
    List<Map<String, Object>> selectContractTypeList();

    /** 시설 등록 화면용 연결 가능한 설치계약 목록 조회 */
    List<Map<String, Object>> selectAvailableInstallContractList(String mgmtOfcNo);

    /** 계약 등록/수정 폼용 협력업체 목록 조회 */
    List<Map<String, Object>> selectContractPartnerList(String mgmtOfcNo);

    /** 계약 등록/수정 폼용 시설 목록 조회 */
    List<Map<String, Object>> selectContractFacilityList(String mgmtOfcNo);

    /** 계약 등록 */
    void insertContract(FacilityContractDTO contract,List<MultipartFile> contractFiles,String userNo);

    /** 설치계약을 신규 시설자산에 연결 */
    void connectInstallContractToFacility(String contNo, String facilityNo);

    /** 계약 수정 */
    void updateContract(
            FacilityContractDTO contract,
            List<MultipartFile> contractFiles,
            List<String> deleteFileSaveUuidList,
            String userNo
    );
}
