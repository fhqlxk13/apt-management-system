package kr.or.ddit.domain.apt.mgmtOffice.contract.service;

import com.google.api.services.drive.Drive;
import kr.or.ddit.common.api.google.service.GoogleDriveService;
import kr.or.ddit.common.model.PaginationInfoVO;
import kr.or.ddit.common.file.mapper.IAttachFileMapper;
import kr.or.ddit.common.file.vo.AttachFileVO;
import kr.or.ddit.domain.apt.mgmtOffice.contract.mapper.IFacilityContractMapper;
import kr.or.ddit.domain.apt.mgmtOffice.contract.vo.FacilityContractDTO;
import kr.or.ddit.domain.apt.mgmtOffice.contract.vo.FacilityContractSearchVO;
import kr.or.ddit.domain.apt.mgmtOffice.contract.vo.FacilityContractSummaryVO;
import kr.or.ddit.domain.apt.mgmtOffice.contract.vo.FacilityContractTargetVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.UUID;

/**
 * 시설 계약 관리 Service 구현체
 *
 * 기준 테이블
 * - FACILITY_CONTRACT
 * - FACILITY_CONTRACT_TARGET
 * - UTILITY_PROVIDER
 * - ATTACH_FILE
 *
 * 파일 저장 기준
 * - Google Drive 폴더 : apt/FC_contract/{aptCmplexNo}/{contNo}
 * - ATTACH_FILE.CAT : FC_CONTRACT
 */
@Slf4j
@Service
public class FacilityContractServiceImpl implements IFacilityContractService {

    /** 검침 범위 : 일반 시설 검침 */
    private static final String METER_SCOPE_NORMAL_FACILITY = "NORMAL_FACILITY";

    /** 검침 범위 : 시설설비 검침 */
    private static final String METER_SCOPE_EQUIPMENT = "EQUIPMENT";

    /** 검침 범위 : 단지/세대 검침 */
    private static final String METER_SCOPE_COMPLEX = "COMPLEX";

    @Autowired
    private IFacilityContractMapper facilityContractMapper;

    @Autowired
    private IAttachFileMapper attachFileMapper;

    @Autowired
    private GoogleDriveService googleDriveService;

    /**
     * 계약 목록 전체 건수 조회
     */
    @Override
    public int selectContractTotalCount(FacilityContractSearchVO search) {
        // 검색조건 전체 기준 계약 건수를 조회한다.
        return facilityContractMapper.selectContractTotalCount(search);
    }

    /**
     * 계약 목록 조회
     */
    @Override
    public List<FacilityContractDTO> selectContractList(
            FacilityContractSearchVO search,
            PaginationInfoVO<FacilityContractDTO> pagingVO
    ) {
        // 검색조건과 페이징 정보를 함께 전달해 현재 페이지 목록만 조회한다.
        return facilityContractMapper.selectContractList(search, pagingVO);
    }

    /**
     * 계약 현황 카드 조회
     */
    @Override
    public FacilityContractSummaryVO selectContractSummary(FacilityContractSearchVO search) {
        return facilityContractMapper.selectContractSummary(search);
    }

    /**
     * 계약 상세 조회
     */
    @Override
    public FacilityContractDTO selectContractDetail(String mgmtOfcNo, String contNo) {
        // 계약 기본 상세 조회
        FacilityContractDTO contract = facilityContractMapper.selectContractDetail(mgmtOfcNo, contNo);

        // 계약이 없으면 그대로 반환
        if (contract == null) {
            return null;
        }

        // 계약 대상 시설 목록 조회
        contract.setTargetFacilityList(facilityContractMapper.selectContractTargetList(contNo));

        // 수정 폼 체크박스 선택값 복원용 시설번호 목록 조회
        contract.setTargetFacilityNoList(facilityContractMapper.selectContractTargetNoList(contNo));

        // 검침 범위 DB 컬럼은 아직 없으므로 기존 대상 시설번호로 단지/세대 검침 여부를 추정한다.
        inferMeterScopeForDisplay(contract);

        // 검침 설정 목록 조회
        // - 시설 검침 용역 계약 1건에 전기/가스/수도 CSV 설정이 여러 건 연결될 수 있다.
        List<FacilityContractDTO> utilityProviderList = facilityContractMapper.selectUtilityProviderListByContNo(contNo);
        contract.setUtilityProviderList(utilityProviderList);

        // 기존 JSP/단건 필드 호환용 대표값 세팅
        // - 실제 수정 저장은 UTILITY_PROVIDER를 일괄 갱신하지 않도록 updateContract에서 차단한다.
        if (utilityProviderList != null && !utilityProviderList.isEmpty()) {
            FacilityContractDTO utilityInfo = utilityProviderList.get(0);

            // 검침 설정번호 세팅
            contract.setUtilityProviderNo(utilityInfo.getUtilityProviderNo());

            // CSV 식별키 세팅
            contract.setCsvIdntfKey(utilityInfo.getCsvIdntfKey());

            // 외부 고객번호 세팅
            contract.setExtCustNo(utilityInfo.getExtCustNo());

            // 검침 설정 비고 세팅
            contract.setUtilityRmrkCn(utilityInfo.getUtilityRmrkCn());

            // 검침 종류 세팅
            contract.setMeterTyCd(utilityInfo.getMeterTyCd());
            contract.setMeterTyNm(utilityInfo.getMeterTyNm());
        }

        // 첨부파일 목록 조회
        if (contract.getFileGroupNo() != null) {
            contract.setFileList(facilityContractMapper.selectContractFileList(contract.getFileGroupNo()));
        }

        return contract;
    }

    /**
     * 계약유형 공통코드 목록 조회
     */
    @Override
    public List<Map<String, Object>> selectContractTypeList() {
        return facilityContractMapper.selectContractTypeList();
    }

    /**
     * 시설 등록 화면용 연결 가능한 설치계약 목록 조회
     */
    @Override
    public List<Map<String, Object>> selectAvailableInstallContractList(String mgmtOfcNo) {
        return facilityContractMapper.selectAvailableInstallContractList(mgmtOfcNo);
    }

    /**
     * 계약 등록/수정 폼용 협력업체 목록 조회
     */
    @Override
    public List<Map<String, Object>> selectContractPartnerList(String mgmtOfcNo) {
        return facilityContractMapper.selectContractPartnerList(mgmtOfcNo);
    }

    /**
     * 계약 등록/수정 폼용 시설 목록 조회
     */
    @Override
    public List<Map<String, Object>> selectContractFacilityList(String mgmtOfcNo) {
        return facilityContractMapper.selectContractFacilityList(mgmtOfcNo);
    }

    /**
     * 계약 등록
     *
     * 처리 순서
     * 1. 계약번호 생성
     * 2. 관리사무소 번호 기준 단지번호 세팅
     * 3. 대표 시설번호 보정
     * 4. 계약서 파일 업로드 및 FILE_GROUP_NO 세팅
     * 5. 계약 기본정보 등록
     * 6. 대상 시설 연결 등록
     * 7. 검침 계약이면 검침 설정 등록
     */
    @Override
    @Transactional
    public void insertContract(
            FacilityContractDTO contract,
            List<MultipartFile> contractFiles,
            String userNo
    ) {
        // 계약번호 생성
        contract.setContNo(facilityContractMapper.selectNextContNo());

        // 관리사무소 번호로 단지번호 조회
        contract.setAptCmplexNo(facilityContractMapper.selectAptCmplexNoByMgmtOfcNo(contract.getMgmtOfcNo()));

        // 검침 계약 대상 시설 보정
        // - 일반 시설/시설설비 검침은 화면에서 선택한 FAC 시설 1개를 사용한다.
        // - 단지/세대 검침은 선택한 검침유형별 MTR 대표 시설번호를 서버에서 연결한다.
        prepareMeterTargetFacility(contract, true);

        // 대표 시설번호 보정
        applyMainFacilityNo(contract);

        // 계약서 파일 업로드
        uploadContractFiles(contract, contractFiles, userNo);

        // 계약 기본정보 등록
        facilityContractMapper.insertContract(contract);

        // 대상 시설 연결 등록
        // - 시설 계약은 기존처럼 대상 시설을 등록한다.
        // - 검침 계약도 시설 검침 용역이면 대상 시설이 있을 수 있으므로 제출된 경우 등록한다.
        if ("FACILITY".equals(contract.getContTargetCd())
                || ("METER".equals(contract.getContTargetCd()) && hasTargetFacilityNoList(contract))) {
            insertContractTargets(contract);
        }

        // 검침 계약이면 선택된 검침 종류별로 UTILITY_PROVIDER를 여러 건 등록한다.
        if ("METER".equals(contract.getContTargetCd())) {
            insertUtilityProviderList(contract, true);
        }
    }

    /**
     * 계약 수정
     *
     * 처리 순서
     * 1. 관리사무소 번호 기준 단지번호 세팅
     * 2. 삭제 선택 파일 처리
     * 3. 대표 시설번호 보정
     * 4. 새 계약서 파일 업로드
     * 5. 계약 기본정보 수정
     * 6. 대상 시설 재연결
     * 7. 검침 계약이면 검침 설정 등록/수정
     */
    @Override
    @Transactional
    public void updateContract(
            FacilityContractDTO contract,
            List<MultipartFile> contractFiles,
            List<String> deleteFileSaveUuidList,
            String userNo
    ) {
        // 관리사무소 번호로 단지번호 조회
        contract.setAptCmplexNo(facilityContractMapper.selectAptCmplexNoByMgmtOfcNo(contract.getMgmtOfcNo()));

        // 기존 첨부파일 삭제
        deleteContractFiles(contract.getFileGroupNo(), deleteFileSaveUuidList);

        // 검침 계약 대상 시설 보정
        // - 단지/세대 검침으로 새 검침유형을 추가하는 경우 MTR 대표 시설번호를 자동 연결한다.
        // - 수정 화면에서 검침유형을 추가하지 않은 경우에는 기존 대상 시설을 보존한다.
        prepareMeterTargetFacility(contract, false);

        // 대상 시설 제출 여부 확인
        // - 일반 시설/시설설비 검침은 화면에서 선택한 대상 시설 1개가 넘어온다.
        // - 단지/세대 검침은 선택한 검침유형이 있으면 MTR 대표 시설번호가 서버에서 세팅된다.
        boolean hasSubmittedTargetFacility = hasTargetFacilityNoList(contract);

        // 대표 시설번호 보정
        if ("METER".equals(contract.getContTargetCd()) && !hasSubmittedTargetFacility) {
            // 검침 계약에서 대상시설이 제출되지 않았으면 기존 대표 시설번호를 보존한다.
            FacilityContractDTO currentContract = facilityContractMapper.selectContractDetail(contract.getMgmtOfcNo(), contract.getContNo());

            if (currentContract != null) {
                contract.setFacilityNo(currentContract.getFacilityNo());
            }
        } else {
            applyMainFacilityNo(contract);
        }

        // 새 계약서 파일 업로드
        uploadContractFiles(contract, contractFiles, userNo);

        // 계약 기본정보 수정
        facilityContractMapper.updateContract(contract);

        // 대상 시설 재구성
        // - 시설 계약은 기존처럼 삭제 후 재등록한다.
        // - 검침 계약은 대상시설이 실제로 제출된 경우에만 재구성한다.
        // - 검침 계약에서 대상시설이 제출되지 않았는데 삭제하면 기존 CONT3104 대상시설이 통째로 사라질 수 있다.
        if ("FACILITY".equals(contract.getContTargetCd())
                || ("METER".equals(contract.getContTargetCd()) && hasSubmittedTargetFacility)) {
            facilityContractMapper.deleteContractTargets(contract.getContNo());
            insertContractTargets(contract);
        }

        // 검침 계약이면 선택된 검침 종류만 추가 등록한다.
        // - 기존 UTILITY_PROVIDER는 수정/삭제하지 않는다.
        // - 이미 존재하는 검침 종류는 중복 insert하지 않는다.
        if ("METER".equals(contract.getContTargetCd())) {
            insertUtilityProviderList(contract, false);
        }
    }

    /**
     * 설치계약을 신규 시설자산에 연결
     */
    @Override
    @Transactional
    public void connectInstallContractToFacility(String contNo, String facilityNo) {
        // 필수값 없음
        if (contNo == null || contNo.isBlank() || facilityNo == null || facilityNo.isBlank()) {
            return;
        }

        // 계약 대상 시설 중복 확인
        int duplicateCount = facilityContractMapper.countContractTarget(contNo, facilityNo);

        // 중복이 아니면 대상 시설 연결 등록
        if (duplicateCount == 0) {
            FacilityContractTargetVO target = new FacilityContractTargetVO();
            target.setContNo(contNo);
            target.setFacilityNo(facilityNo);

            facilityContractMapper.insertContractTarget(target);
        }

        // 대표 시설번호도 보정
        facilityContractMapper.updateContractMainFacilityNo(contNo, facilityNo);
    }

    /**
     * 대표 시설번호 보정
     * - 시설 대상 계약에서 선택 시설이 있으면 첫 번째 시설을 FACILITY_CONTRACT.FACILITY_NO에도 보관한다.
     * - 설치공사처럼 아직 대상 시설이 없으면 null 상태로 둔다.
     */
    private void applyMainFacilityNo(FacilityContractDTO contract) {
        // 선택 시설이 있으면 첫 번째 시설을 대표 시설번호로 사용
        if (contract.getTargetFacilityNoList() != null && !contract.getTargetFacilityNoList().isEmpty()) {
            contract.setFacilityNo(contract.getTargetFacilityNoList().get(0));
            return;
        }

        // 선택 시설이 없으면 대표 시설번호 없음
        contract.setFacilityNo(null);
    }

    /**
     * 대상 시설 제출 여부 확인
     * - 빈 문자열만 넘어온 경우는 제출된 대상 시설이 없는 것으로 본다.
     */
    private boolean hasTargetFacilityNoList(FacilityContractDTO contract) {
        if (contract.getTargetFacilityNoList() == null || contract.getTargetFacilityNoList().isEmpty()) {
            return false;
        }

        for (String facilityNo : contract.getTargetFacilityNoList()) {
            if (facilityNo != null && !facilityNo.isBlank()) {
                return true;
            }
        }

        return false;
    }

    /**
     * 상세/수정 화면용 검침 범위 추정
     * - 현재 최소수정 버전에서는 FACILITY_CONTRACT에 검침 범위 컬럼을 추가하지 않는다.
     * - 대상 시설이 MTR 계열이면 단지/세대 검침으로 보고, 그 외에는 일반 시설 검침으로 표시한다.
     */
    private void inferMeterScopeForDisplay(FacilityContractDTO contract) {
        if (!"METER".equals(contract.getContTargetCd())) {
            return;
        }

        if (contract.getTargetFacilityNoList() == null || contract.getTargetFacilityNoList().isEmpty()) {
            contract.setMeterScope(METER_SCOPE_NORMAL_FACILITY);
            return;
        }

        boolean allRepresentativeMeterFacility = true;

        for (String facilityNo : contract.getTargetFacilityNoList()) {
            if (facilityNo == null || !facilityNo.toUpperCase().startsWith("MTR")) {
                allRepresentativeMeterFacility = false;
                break;
            }
        }

        contract.setMeterScope(allRepresentativeMeterFacility ? METER_SCOPE_COMPLEX : METER_SCOPE_NORMAL_FACILITY);
    }

    /**
     * 검침 계약 대상 시설 보정
     * - 일반 시설 검침/NORMAL_FACILITY : 화면에서 선택한 실제 시설 1개를 사용한다.
     * - 시설설비 검침/EQUIPMENT : 화면에서 선택한 실제 설비 1개를 사용한다.
     * - 단지/세대 검침/COMPLEX : 화면 시설 선택 없이 검침유형별 MTR 대표 시설번호를 자동 연결한다.
     */
    private void prepareMeterTargetFacility(FacilityContractDTO contract, boolean requiredMeterTyCd) {
        // 검침 계약이 아니면 기존 시설 계약 흐름을 그대로 사용한다.
        if (!"METER".equals(contract.getContTargetCd())) {
            return;
        }

        // 화면에서 넘어온 검침 범위를 표준값으로 보정한다.
        String meterScope = normalizeMeterScope(contract);
        contract.setMeterScope(meterScope);

        // 단지/세대 검침은 사용자가 시설을 고르지 않고, 검침유형별 MTR 대표 시설번호를 서버에서 연결한다.
        if (METER_SCOPE_COMPLEX.equals(meterScope)) {
            List<String> meterTyCdList = normalizeMeterTyCdList(contract);

            // 신규 등록에서는 검침유형이 반드시 필요하다. 수정 화면에서는 기존 설정만 조회하고 저장할 수 있으므로 비어 있으면 대상시설을 건드리지 않는다.
            if (meterTyCdList.isEmpty()) {
                if (requiredMeterTyCd) {
                    throw new RuntimeException("단지/세대 검침 계약은 검침 종류를 하나 이상 선택해야 합니다.");
                }
                contract.setTargetFacilityNoList(new ArrayList<>());
                return;
            }

            // 검침유형별 MTR 대표 시설번호를 대상 시설 목록으로 세팅한다.
            contract.setTargetFacilityNoList(makeComplexMeterTargetFacilityNoList(meterTyCdList));
            return;
        }

        // 일반 시설/시설설비 검침은 대상 시설 1개를 명확히 선택해야 한다.
        validateSingleMeterTargetFacility(contract);
    }

    /**
     * 검침 범위 표준값 보정
     */
    private String normalizeMeterScope(FacilityContractDTO contract) {
        String meterScope = contract.getMeterScope();

        if (meterScope == null || meterScope.isBlank()) {
            return METER_SCOPE_NORMAL_FACILITY;
        }

        meterScope = meterScope.trim().toUpperCase();

        if (METER_SCOPE_EQUIPMENT.equals(meterScope) || METER_SCOPE_COMPLEX.equals(meterScope)) {
            return meterScope;
        }

        return METER_SCOPE_NORMAL_FACILITY;
    }

    /**
     * 단지/세대 검침 대표 시설번호 목록 생성
     * - MTR 계열은 실제 시설자산이 아니라 단지/세대 검침 CSV 연결용 내부 대표 시설번호로 사용한다.
     */
    private List<String> makeComplexMeterTargetFacilityNoList(List<String> meterTyCdList) {
        List<String> targetFacilityNoList = new ArrayList<>();

        for (String meterTyCd : meterTyCdList) {
            String representativeFacilityNo = getComplexMeterRepresentativeFacilityNo(meterTyCd);

            if (!targetFacilityNoList.contains(representativeFacilityNo)) {
                targetFacilityNoList.add(representativeFacilityNo);
            }
        }

        return targetFacilityNoList;
    }

    /**
     * 단지/세대 검침 대표 시설번호 매핑
     */
    private String getComplexMeterRepresentativeFacilityNo(String meterTyCd) {
        if ("ELEC".equals(meterTyCd)) {
            return "MTRELC001";
        }

        if ("WATER".equals(meterTyCd)) {
            return "MTRWTR001";
        }

        if ("GAS".equals(meterTyCd)) {
            return "MTRGAS001";
        }

        throw new RuntimeException("지원하지 않는 단지/세대 검침 종류입니다. meterTyCd=" + meterTyCd);
    }

    /**
     * 일반 시설/시설설비 검침 대상 시설 검증
     * - 여러 시설에 여러 검침유형을 동시에 묶지 않기 위해 대상 시설은 1개만 허용한다.
     */
    private void validateSingleMeterTargetFacility(FacilityContractDTO contract) {
        int validTargetCount = countValidTargetFacilityNo(contract);

        if (validTargetCount != 1) {
            throw new RuntimeException("일반 시설/시설설비 검침 계약은 대상 시설을 1개만 선택해야 합니다.");
        }
    }

    /**
     * 대상 시설번호 유효 개수 계산
     */
    private int countValidTargetFacilityNo(FacilityContractDTO contract) {
        if (contract.getTargetFacilityNoList() == null || contract.getTargetFacilityNoList().isEmpty()) {
            return 0;
        }

        int count = 0;

        for (String facilityNo : contract.getTargetFacilityNoList()) {
            if (facilityNo != null && !facilityNo.isBlank()) {
                count++;
            }
        }

        return count;
    }

    /**
     * 계약 대상 시설 연결 등록
     */
    private void insertContractTargets(FacilityContractDTO contract) {
        // 대상 시설 없음
        if (contract.getTargetFacilityNoList() == null || contract.getTargetFacilityNoList().isEmpty()) {
            return;
        }

        for (String facilityNo : contract.getTargetFacilityNoList()) {
            // 빈 시설번호 제외
            if (facilityNo == null || facilityNo.isBlank()) {
                continue;
            }

            FacilityContractTargetVO target = new FacilityContractTargetVO();

            // 계약번호 + 시설번호 연결
            target.setContNo(contract.getContNo());
            target.setFacilityNo(facilityNo);

            facilityContractMapper.insertContractTarget(target);
        }
    }

    /**
     * 검침 설정 목록 등록
     * - 등록 화면에서는 선택한 검침 종류를 모두 등록한다.
     * - 수정 화면에서는 선택한 검침 종류 중 아직 없는 것만 추가한다.
     */
    private void insertUtilityProviderList(FacilityContractDTO contract, boolean required) {
        // 화면에서 넘어온 다중 검침 종류를 정리한다.
        List<String> meterTyCdList = normalizeMeterTyCdList(contract);

        // 신규 검침 계약은 검침 종류가 최소 1개 필요하다.
        if (meterTyCdList.isEmpty()) {
            if (required) {
                throw new RuntimeException("검침 계약은 검침 종류를 하나 이상 선택해야 합니다.");
            }
            return;
        }

        // 검침 설정 비고는 DB에서 NOT NULL이므로 비어 있으면 기본값을 사용한다.
        if (contract.getUtilityRmrkCn() == null || contract.getUtilityRmrkCn().isBlank()) {
            contract.setUtilityRmrkCn("-");
        }

        for (String meterTyCd : meterTyCdList) {
            // 수정 화면에서 이미 등록된 검침 종류는 중복 생성하지 않는다.
            int duplicateCount = facilityContractMapper.countUtilityProviderByContNoAndMeterTyCd(
                    contract.getContNo(),
                    meterTyCd
            );

            if (duplicateCount > 0) {
                continue;
            }

            // 반복 insert 중 DTO에 현재 검침 종류와 자동 생성값을 세팅한다.
            contract.setMeterTyCd(meterTyCd);
            contract.setUtilityProviderNo(facilityContractMapper.selectNextUtilityProviderNo());

            // 검침 설정번호까지 포함해 같은 계약/같은 검침유형에서도 키 중복 가능성을 낮춘다.
            contract.setCsvIdntfKey(makeCsvIdntfKey(
                    contract.getAptCmplexNo(),
                    contract.getContNo(),
                    contract.getUtilityProviderNo(),
                    meterTyCd
            ));
            contract.setExtCustNo(makeExtCustNo(
                    contract.getAptCmplexNo(),
                    contract.getContNo(),
                    contract.getUtilityProviderNo(),
                    meterTyCd
            ));

            // 검침 설정 등록
            facilityContractMapper.insertUtilityProvider(contract);
        }
    }

    /**
     * 검침 종류 목록 정리
     * - 신규 화면: meterTyCdList를 우선 사용한다.
     * - 기존 단건 화면 호환: meterTyCd만 넘어온 경우에도 1건 등록 가능하게 둔다.
     * - 중복/공백은 제거한다.
     */
    private List<String> normalizeMeterTyCdList(FacilityContractDTO contract) {
        List<String> meterTyCdList = new ArrayList<>();

        if (contract.getMeterTyCdList() != null) {
            for (String meterTyCd : contract.getMeterTyCdList()) {
                addMeterTyCdIfValid(meterTyCdList, meterTyCd);
            }
        }

        if (meterTyCdList.isEmpty()) {
            addMeterTyCdIfValid(meterTyCdList, contract.getMeterTyCd());
        }

        return meterTyCdList;
    }

    /**
     * 검침 종류 중복/공백 제거 후 추가
     */
    private void addMeterTyCdIfValid(List<String> meterTyCdList, String meterTyCd) {
        if (meterTyCd == null || meterTyCd.isBlank()) {
            return;
        }

        String normalizedMeterTyCd = meterTyCd.trim().toUpperCase();

        if (!meterTyCdList.contains(normalizedMeterTyCd)) {
            meterTyCdList.add(normalizedMeterTyCd);
        }
    }

    /**
     * CSV 식별키 자동 생성
     * - 계약번호, 검침 설정번호, 검침 종류를 함께 넣어 같은 단지 안에서도 값이 겹치지 않게 한다.
     */
    private String makeCsvIdntfKey(String aptCmplexNo, String contNo, String utilityProviderNo, String meterTyCd) {
        return "CSV_"
                + safeKeyPart(aptCmplexNo)
                + "_"
                + safeKeyPart(contNo)
                + "_"
                + safeKeyPart(utilityProviderNo)
                + "_"
                + safeKeyPart(meterTyCd);
    }

    /**
     * 외부 고객번호 자동 생성
     * - UTILITY_PROVIDER.EXT_CUST_NO 컬럼 길이는 20자이므로 반드시 20자 이하로 생성한다.
     * - 구분자(-)를 제거하고 단지/계약/설정/검침유형 일부만 조합한다.
     * - 예: C2700331043105ELC (17자)
     */
    private String makeExtCustNo(String aptCmplexNo, String contNo, String utilityProviderNo, String meterTyCd) {
        String extCustNo = "C"
                + rightKeyPart(aptCmplexNo, 5)
                + rightKeyPart(contNo, 4)
                + rightKeyPart(utilityProviderNo, 4)
                + meterTyAlias(meterTyCd);

        // DB 컬럼 길이 방어. 향후 규칙이 바뀌어도 20자를 넘기지 않도록 마지막에 한 번 더 자른다.
        return extCustNo.length() > 20 ? extCustNo.substring(0, 20) : extCustNo;
    }

    /**
     * 키 조합용 문자열 보정
     */
    private String safeKeyPart(String value) {
        if (value == null || value.isBlank()) {
            return "NA";
        }

        return value.trim().toUpperCase().replaceAll("[^A-Z0-9]", "");
    }

    /**
     * 오른쪽 일부 문자열 추출
     */
    private String rightKeyPart(String value, int length) {
        String safeValue = safeKeyPart(value);

        if (safeValue.length() <= length) {
            return safeValue;
        }

        return safeValue.substring(safeValue.length() - length);
    }

    /**
     * 검침 종류 외부 고객번호 축약값
     */
    private String meterTyAlias(String meterTyCd) {
        if ("ELEC".equals(meterTyCd)) {
            return "ELC";
        }

        if ("WATER".equals(meterTyCd)) {
            return "WTR";
        }

        if ("GAS".equals(meterTyCd)) {
            return "GAS";
        }

        if ("HEAT".equals(meterTyCd)) {
            return "HEAT";
        }

        return safeKeyPart(meterTyCd);
    }

    /**
     * 계약서 첨부파일 업로드
     *
     * 처리 순서
     * 1. 실제 업로드 파일 존재 확인
     * 2. FILE_GROUP_NO 확보
     * 3. Google Drive 업로드
     * 4. ATTACH_FILE 등록
     * 5. 업로드 실패 시 Google Drive 롤백
     */
    private void uploadContractFiles(
            FacilityContractDTO contract,
            List<MultipartFile> contractFiles,
            String userNo
    ) {
        // 업로드 파일 없음
        if (!hasFiles(contractFiles)) {
            return;
        }

        // Google Drive 롤백 대상 ID 목록
        List<String> uploadedGoogleIds = new ArrayList<>();

        // Google Drive 객체
        Drive drive = null;

        try {
            // Google Drive 객체 생성
            drive = googleDriveService.getDriveService();

            // 파일그룹번호 확보
            Long fileGroupNo = contract.getFileGroupNo();

            if (fileGroupNo == null) {
                fileGroupNo = attachFileMapper.getSeqFileGroupNo();
                contract.setFileGroupNo(fileGroupNo);
            }

            // 파일 정렬 순서
            int sortOrder = 0;

            for (MultipartFile contractFile : contractFiles) {
                // 빈 파일 제외
                if (contractFile == null || contractFile.isEmpty()) {
                    continue;
                }

                // 원본 파일명
                String originalFilename = contractFile.getOriginalFilename();

                // 저장 UUID
                String uuid = UUID.randomUUID().toString().replace("-", "");

                // 저장 파일명
                String savedFileName = uuid + "_" + originalFilename;

                // Google Drive 폴더 경로
                String folderPath = "apt/FC_contract/"
                        + contract.getAptCmplexNo() + "/"
                        + contract.getContNo();

                // DB 저장용 전체 경로
                String fullPath = folderPath + "/" + savedFileName;

                // Google Drive 업로드 시작 시간
                long uploadStartTime = System.currentTimeMillis();

                // Google Drive 업로드
                String googleId = googleDriveService.uploadFile(
                        contractFile,
                        folderPath,
                        savedFileName
                );

                // Google Drive 업로드 로그
                log.info("계약서 Google Drive 업로드 완료 userNo={}, elapsed={}ms, fileName={}",
                        userNo,
                        System.currentTimeMillis() - uploadStartTime,
                        originalFilename
                );

                // Google Drive 롤백 대상 추가
                uploadedGoogleIds.add(googleId);

                // 첨부파일 VO 생성
                AttachFileVO file = AttachFileVO.fileSettings(
                        contractFile,
                        fileGroupNo,
                        "FC_CONTRACT",
                        savedFileName,
                        googleId,
                        fullPath,
                        sortOrder
                );

                // ATTACH_FILE 등록
                attachFileMapper.insertAttachFile(file);

                // 정렬 순서 증가
                sortOrder++;
            }
        } catch (Exception e) {
            // 계약서 파일 업로드 오류 로그
            log.error("계약서 파일 업로드 오류", e);

            // Google Drive 업로드 롤백
            rollbackUploadedFiles(drive, uploadedGoogleIds);

            // 트랜잭션 롤백용 RuntimeException
            throw new RuntimeException(e.getMessage(), e);
        }
    }

    /**
     * 계약 첨부파일 삭제
     * - Google Drive 휴지통 이동 후 ATTACH_FILE 레코드를 삭제한다.
     * - Google Drive 권한이 꼬인 테스트 파일이면 여기서 403이 날 수 있다.
     */
    private void deleteContractFiles(Long fileGroupNo, List<String> deleteFileSaveUuidList) {
        // 삭제 대상 없음
        if (fileGroupNo == null || deleteFileSaveUuidList == null || deleteFileSaveUuidList.isEmpty()) {
            return;
        }

        // 기존 파일 목록 조회
        List<Map<String, Object>> fileList = facilityContractMapper.selectContractFileList(fileGroupNo);

        // Google Drive 객체
        Drive drive = null;

        try {
            // Google Drive 객체 생성
            drive = googleDriveService.getDriveService();

            for (String fileSaveUuid : deleteFileSaveUuidList) {
                // 빈 UUID 제외
                if (fileSaveUuid == null || fileSaveUuid.isBlank()) {
                    continue;
                }

                // 삭제 대상 파일의 Google ID 조회
                String googleId = findGoogleId(fileList, fileSaveUuid.trim());

                // Google ID가 있으면 Drive 휴지통 이동
                if (googleId != null && !googleId.isBlank()) {
                    googleDriveService.moveToTrash(drive, googleId);
                }

                // ATTACH_FILE DB 삭제
                facilityContractMapper.deleteAttachFileByUuid(fileSaveUuid.trim());
            }
        } catch (Exception e) {
            // 계약 첨부파일 삭제 오류 로그
            log.error("계약 첨부파일 삭제 오류", e);

            // 트랜잭션 롤백용 RuntimeException
            throw new RuntimeException(e.getMessage(), e);
        }
    }

    /**
     * 파일 목록에서 저장 UUID 기준 Google ID 찾기
     */
    private String findGoogleId(List<Map<String, Object>> fileList, String fileSaveUuid) {
        // 파일 목록 없음
        if (fileList == null || fileList.isEmpty()) {
            return null;
        }

        for (Map<String, Object> file : fileList) {
            // 파일 정보 없음
            if (file == null) {
                continue;
            }

            // Map key는 XML alias 기준
            Object savedUuid = file.get("fileSaveUuid");

            if (savedUuid != null && fileSaveUuid.equals(String.valueOf(savedUuid))) {
                Object googleId = file.get("googleId");
                return googleId == null ? null : String.valueOf(googleId);
            }
        }

        return null;
    }

    /**
     * Google Drive 업로드 롤백
     */
    private void rollbackUploadedFiles(Drive drive, List<String> uploadedGoogleIds) {
        // 롤백 대상 없음
        if (drive == null || uploadedGoogleIds == null || uploadedGoogleIds.isEmpty()) {
            return;
        }

        for (String googleId : uploadedGoogleIds) {
            try {
                // Google Drive 휴지통 이동
                googleDriveService.moveToTrash(drive, googleId);
            } catch (Exception e) {
                // Google Drive 롤백 실패 로그
                log.error("계약서 파일 롤백 실패 googleId={}", googleId, e);
            }
        }
    }

    /**
     * 실제 업로드 파일 존재 여부 확인
     */
    private boolean hasFiles(List<MultipartFile> files) {
        // 파일 목록 없음
        if (files == null || files.isEmpty()) {
            return false;
        }

        // 실제 파일이 하나라도 있으면 true
        return files.stream().anyMatch(file -> file != null && !file.isEmpty());
    }
}
