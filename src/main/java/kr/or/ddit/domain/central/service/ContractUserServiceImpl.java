package kr.or.ddit.domain.central.service;

import kr.or.ddit.common.api.google.service.GoogleDriveService;
import kr.or.ddit.common.file.mapper.IAttachFileMapper;
import kr.or.ddit.common.file.vo.AttachFileVO;
import kr.or.ddit.domain.central.mapper.IContractUserMapper;
import kr.or.ddit.domain.central.vo.ContractUserVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Slf4j
@Service
public class ContractUserServiceImpl implements IContractUserService {

    @Autowired
    private IContractUserMapper contractUserMapper;

    // 구글드라이브 파일업로드에 쓸 서비스 googleDriveService 의존성 주입
    @Autowired
    private GoogleDriveService googleDriveService;

    // 이것도 위와 마찬가지인 매퍼
    @Autowired
    private IAttachFileMapper iAttachFileMapper;

    /**
     * 특정 사용자의 계약 신청 목록을 조회하는 메소드
     *
     * userNo 조회할 사용자 번호
     * 해당 사용자의 계약 신청 목록 (신청번호, 공고명, 상태 등)
     */
    @Override
    public List<Map<String, Object>> selectAplctList(String userNo) {
        return contractUserMapper.selectAplctList(userNo);
    }

    /**
     * 계약 신청을 취소하는 메소드
     * 트랜잭션 처리: 취소 중 오류 발생 시 롤백
     *
     * aplctNo 취소할 신청 번호
     */
    @Transactional
    @Override
    public void cancelContract(String aplctNo) {
        contractUserMapper.cancelContract(aplctNo);
    }

    /**
     * 특정 신청 번호에 해당하는 계약 신청 상세 정보를 조회하는 메소드
     * (주의: @Override 누락 - 인터페이스 구현 메소드임에도 명시되지 않음)
     *
     * aplctNo 조회할 신청 번호
     * 계약 신청 상세 정보 Map (신청자, 공고, 단지, 상태 등)
     */
    @Override
    public Map<String, Object> selectOneContractHistoryDetail(String aplctNo) {
        return contractUserMapper.selectOneContractHistoryDetail(aplctNo);
    }

    /**
     * 특정 신청 번호에 해당하는 제출 서류 목록을 조회하는 메소드(현재 미사용)
     *
     * aplctNo 조회할 신청 번호
     */
    @Override
    public List<Map<String, Object>> selectSbmsnDocList(String aplctNo) {
        return contractUserMapper.selectSbmsnDocList(aplctNo);
    }

    /**
     * 특정 신청 번호에 해당하는 신청 서류 목록을 조회하는 메소드
     * selectSbmsnDocList와 유사하나 다른 쿼리를 사용
     *
     * aplctNo 조회할 신청 번호
     * 신청 서류 목록 (파일명, 서류 종류, 업로드 일시 등)
     */
    @Override
    public List<Map<String, Object>> selectAplctDocList(String aplctNo) {
        return contractUserMapper.selectAplctDocList(aplctNo);
    }

    /**
     * 계약 서류 파일을 업로드하고 관련 정보를 DB에 저장하는 메소드
     * 트랜잭션 처리: 업로드 또는 DB 저장 중 오류 발생 시 전체 롤백
     *
     * 처리 순서:
     *   1. UUID 기반 고유 파일명 생성 (중복 방지)
     *   2. 구글 드라이브 저장 경로 설정 (contract/doc/{userNo})
     *   3. 구글 드라이브에 파일 업로드 → 구글 파일 ID 반환
     *   4. 파일 그룹 시퀀스 번호 채번 후 첨부파일 정보 DB 저장
     *   5. 계약 서류 정보(서류 종류, 파일 그룹 번호, 신청 번호)를 DB에 저장
     *
     * file          업로드할 MultipartFile 객체
     * sbmsnDocTyCd  제출 서류 종류 코드 (예: 주민등록등본, 재직증명서 등)
     * aplctNo       서류를 제출할 계약 신청 번호
     * userNo        업로드하는 사용자 번호 (드라이브 경로에 사용)
     */
    /*@Transactional
    @Override
    public void insertContractDoc(MultipartFile file, String sbmsnDocTyCd, String aplctNo, String userNo) throws IOException {
        if (file != null && !file.isEmpty()) {

            log.info("deleteContractDoc 실행: aplctNo={}, sbmsnDocTyCd={}", aplctNo, sbmsnDocTyCd);
            // 동일 서류 종류 기존 데이터 삭제 (덮어쓰기)
            contractUserMapper.deleteContractDoc(aplctNo, sbmsnDocTyCd);
            log.info("insertContractDoc 실행 시작");

            // 1. UUID로 고유한 저장 파일명 생성 (원본 파일명 앞에 UUID 접두사 추가)
            String uuid = UUID.randomUUID().toString().replace("-", "");
            String savedFileName = uuid + "_" + file.getOriginalFilename();

            // 2. 구글 드라이브 저장 경로 설정 (사용자별 폴더 분리)
            String folderPath = "contract/doc/" + aplctNo;
            String fullPath = folderPath + "/" + savedFileName;

            // 3. 구글 드라이브에 파일 업로드, 업로드된 파일의 구글 고유 ID 반환
            String googleId = googleDriveService.uploadFile(file, folderPath, savedFileName);

            // 4. 첨부파일 그룹 번호(시퀀스) 채번
            long seq = iAttachFileMapper.getSeqFileGroupNo();

            // 5. 첨부파일 VO 생성 (파일 정보, 시퀀스, 구글 ID, 경로 등 세팅)
            AttachFileVO attachFileVO = AttachFileVO.fileSettings(
                    file, seq, "contract_doc", savedFileName, googleId, fullPath, 1
            );
            // 6. 파일 정보 DB 저장
            iAttachFileMapper.insertAttachFile(attachFileVO);

            // 7. 계약 서류 정보 VO 생성 및 DB 저장
            ContractUserVO contractUserVO = new ContractUserVO();
            contractUserVO.setSbmsnDocTyCd(sbmsnDocTyCd);
            contractUserVO.setAtchFileId(String.valueOf(attachFileVO.getFileGroupNo()));
            contractUserVO.setAplctNo(aplctNo);
            contractUserMapper.insertContractDoc(contractUserVO);

            int submitted = contractUserMapper.selectSubmittedDocCount(aplctNo);
            int required  = contractUserMapper.selectRequiredDocCount(aplctNo);

            if (submitted >= required){
                contractUserMapper.isAllSubmitted(aplctNo);
            }

        }
    }*/

    @Transactional
    @Override
    public void insertContractDoc(List<MultipartFile> files, List<String> cat, String aplctNo, String userNo) throws IOException {

        if (files == null || cat == null || files.size() != cat.size()) {
            throw new IllegalArgumentException("파일과 서류 종류 정보가 일치하지 않습니다.");
        }

        String folderPath = "contract/doc/" + aplctNo;

        // files[i] 와 cat[i] 는 1:1 (contractADetail.jsp 와 동일)
        for (int i = 0; i < files.size(); i++) {
            MultipartFile file = files.get(i);
            String sbmsnDocTyCd = cat.get(i);

            if (file == null || file.isEmpty()) {
                continue;
            }
            if (sbmsnDocTyCd == null || sbmsnDocTyCd.trim().isEmpty()) {
                continue;
            }
            sbmsnDocTyCd = sbmsnDocTyCd.trim();

            // 동일 서류 종류 기존 데이터 삭제 (덮어쓰기)
            contractUserMapper.deleteContractDoc(aplctNo, sbmsnDocTyCd);

            String uuid = UUID.randomUUID().toString().replace("-", "");
            String savedFileName = uuid + "_" + file.getOriginalFilename();
            String fullPath = folderPath + "/" + savedFileName;

            log.info("파일 업로드 시도: {}, MIME: {}", savedFileName, file.getContentType());

            String googleId = googleDriveService.uploadFile(file, folderPath, savedFileName);

            log.info("구글 드라이브 업로드 성공: googleId={}", googleId);

            long fileGroupNo = iAttachFileMapper.getSeqFileGroupNo();

            AttachFileVO attachFileVO = AttachFileVO.fileSettings(
                    file, fileGroupNo, sbmsnDocTyCd,
                    savedFileName, googleId, fullPath, 1
            );
            int cnt = iAttachFileMapper.insertAttachFile(attachFileVO);
            log.info("####파일 인서트 결과 {}", cnt);

            ContractUserVO contractUserVO = new ContractUserVO();
            contractUserVO.setSbmsnDocTyCd(sbmsnDocTyCd);
            contractUserVO.setAtchFileId(String.valueOf(fileGroupNo));
            contractUserVO.setAplctNo(aplctNo);
            contractUserMapper.insertContractDoc(contractUserVO);
        }
        int submitted = contractUserMapper.selectSubmittedDocCount(aplctNo);
        int required = contractUserMapper.selectRequiredDocCount(aplctNo);
        log.info("[서류제출 상태체크] aplctNo={}, submitted={}, required={}", aplctNo, submitted, required);

        if (submitted > 0 && (required <= 0 || submitted >= required)) {
            log.info("[서류제출 상태변경] aplctNo={} → INSPECTION", aplctNo);
            contractUserMapper.isAllSubmitted(aplctNo);
        } else {
            log.warn("[서류제출 상태미변경] 아직 미제출 서류 있음: submitted={}, required={}", submitted, required);
        }
    }

    // 계약공고 조회수 증가 메소드
    @Transactional
    @Override
    public void updateInqCnt(String annNo) {
        contractUserMapper.updateInqCnt(annNo);
    }

    /**
     * 특정 아파트 단지의 전용면적 상세 정보 목록을 조회하는 메소드
     * 공고 상세 페이지에서 면적별 세대 정보를 표시할 때 사용
     *
     * annNo 조회할 공고 번호
     * aptCmplexNo 조회할 아파트 단지 번호
     * 전용면적 상세 정보 목록 (면적, 세대수 등)
     */
    @Override
    public List<Map<String, Object>> selectExcluseAreaDetail(String annNo, String aptCmplexNo) {
        return contractUserMapper.selectExcluseAreaDetail(annNo, aptCmplexNo);
    }

    /**
     *   1. 동일 공고에 이미 신청한 이력이 있는지 중복 검사
     *   2. 중복이면 RuntimeException 발생 (트랜잭션 롤백)
     *   3. 신청 조건에 맞는 호 타입 번호(hoTyNo) 조회
     *   4. 호 타입 번호를 params에 추가 후 신청 정보 DB 저장
     *
     * params 신청에 필요한 파라미터 Map
     *               (annNo: 공고번호, userNo: 사용자번호, aptCmplexNo: 단지번호 등 포함)
     */
    @Transactional
    @Override
    public void insertAplct(Map<String, Object> params) {
        log.info("params: {}", params);

        // 1. 동일 사용자가 동일 공고에 이미 신청했는지 건수 조회
        int count = contractUserMapper.selectAplctcount(params);

        // 2. 이미 신청 이력이 있으면 예외 발생 (중복 신청 방지)
        if(count > 0){
            throw new RuntimeException("이미 신청한 공고입니다.");
        }

        // 3. 신청 조건에 맞는 호 타입 번호(hoTyNo) 조회
        String hoTyNo = contractUserMapper.selectHoTyNo(params);
        log.info("hoTyNo: {}", hoTyNo);

        // 4. 조회한 호 타입 번호를 파라미터에 추가 후 신청 정보 DB 저장
        params.put("hoTyNo", hoTyNo);

        contractUserMapper.insertAplct(params);
    }



}