package kr.or.ddit.domain.apt.mgmtOffice.meter.service;

import kr.or.ddit.common.api.google.service.GoogleDriveService;
import kr.or.ddit.common.file.mapper.IAttachFileMapper;
import kr.or.ddit.common.file.vo.AttachFileVO;
import kr.or.ddit.domain.apt.mgmtOffice.meter.mapper.IMeterHstryMapper;
import kr.or.ddit.domain.apt.mgmtOffice.meter.vo.MeterHstryVO;
import kr.or.ddit.domain.apt.mgmtOffice.meter.vo.MeterUploadHstryVO;
import kr.or.ddit.domain.apt.mgmtOffice.meter.vo.UtilityProviderVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

/**
 * 검침 이력 Service 구현체
 * - 검침 이력 목록 조회
 * - CSV 원본 파일 Google Drive 업로드
 * - ATTACH_FILE 파일 메타정보 저장
 * - METER_UPLOAD_HSTRY 업로드 이력 저장
 * - METER_HSTRY 검침 이력 등록
 */
@Service
@RequiredArgsConstructor
public class MeterHstryServiceImpl implements IMeterHstryService {

    /** 검침 이력 Mapper */
    private final IMeterHstryMapper meterHstryMapper;

    /** Google Drive 파일 업로드 서비스 */
    private final GoogleDriveService googleDriveService;

    /** 공통 첨부파일 Mapper */
    private final IAttachFileMapper attachFileMapper;

    /** CSV 파일 분류값 */
    private static final String FILE_CAT_METER_CSV = "METER_CSV";

    /** 업로드 성공 상태값 */
    private static final String UPLOAD_DONE = "DONE";

    /** 업로드 실패 상태값 */
    private static final String UPLOAD_FAIL = "FAIL";

    /** CSV 다운로드 헤더 - ho_disp 는 "101동 1502호" 형태의 사람용 표시값 */
    private static final String CSV_HEADER =
            "meter_hstry_no,meter_scope,meter_ty_cd,meter_ty_nm,meter_dt,facility_no,facility_nm,ho_no,ho_disp,pre_val,curr_val,usage_val,meter_rslt_cd,meter_rslt_nm,partner_nm,meter_cn";

    /** 미리보기에 내려줄 샘플 행 수 */
    private static final int DOWNLOAD_PREVIEW_LIMIT = 3;

    /**
     * 검침 이력 목록 조회
     */
    @Override
    public List<MeterHstryVO> selectMeterHstryList(Map<String, Object> paramMap) {
        // 관리사무소 번호로 단지번호 조회
        String mgmtOfcNo = String.valueOf(paramMap.get("mgmtOfcNo"));
        String aptCmplexNo = meterHstryMapper.selectAptCmplexNoByMgmtOfcNo(mgmtOfcNo);

        // 조회 조건에 단지번호 추가
        paramMap.put("aptCmplexNo", aptCmplexNo);

        // 검침 이력 목록 조회
        return meterHstryMapper.selectMeterHstryList(paramMap);
    }

    @Override
    public int selectMeterHstryCount(Map<String, Object> paramMap) {
        String mgmtOfcNo = String.valueOf(paramMap.get("mgmtOfcNo"));
        String aptCmplexNo = meterHstryMapper.selectAptCmplexNoByMgmtOfcNo(mgmtOfcNo);
        paramMap.put("aptCmplexNo", aptCmplexNo);
        return meterHstryMapper.selectMeterHstryCount(paramMap);
    }

    /**
     * 다운로드 조건 기준 CSV 생성
     */
    @Override
    public byte[] downloadMeterCsv(String mgmtOfcNo, Map<String, Object> paramMap) {
        Map<String, Object> downloadParamMap = buildDownloadParamMap(mgmtOfcNo, paramMap);
        List<MeterHstryVO> meterList = meterHstryMapper.selectMeterHstryList(downloadParamMap);
        return buildMeterCsv(meterList);
    }

    /**
     * 다운로드 조건 기준 검침 건수 조회
     */
    @Override
    public int countDownloadMeter(String mgmtOfcNo, Map<String, Object> paramMap) {
        Map<String, Object> downloadParamMap = buildDownloadParamMap(mgmtOfcNo, paramMap);
        return meterHstryMapper.selectMeterHstryCount(downloadParamMap);
    }

    /**
     * 다운로드 조건 기준 미리보기
     * - 건수 + 상위 N건의 샘플 행을 모달에 그대로 그려줄 수 있게 포맷팅하여 반환
     * - ho_no는 "101동 1502호" 형태로 분리해서 사용자가 다운로드 결과를 짐작할 수 있게 함
     */
    @Override
    public Map<String, Object> previewDownloadMeter(String mgmtOfcNo, Map<String, Object> paramMap) {
        Map<String, Object> downloadParamMap = buildDownloadParamMap(mgmtOfcNo, paramMap);

        int count = meterHstryMapper.selectMeterHstryCount(downloadParamMap);

        // 건수가 0이면 굳이 목록을 조회하지 않음
        List<Map<String, Object>> sampleRows = new ArrayList<>();
        if (count > 0) {
            List<MeterHstryVO> meterList = meterHstryMapper.selectMeterHstryList(downloadParamMap);
            int limit = Math.min(meterList.size(), DOWNLOAD_PREVIEW_LIMIT);
            for (int i = 0; i < limit; i++) {
                sampleRows.add(toPreviewRow(meterList.get(i)));
            }
        }

        Map<String, Object> result = new HashMap<>();
        result.put("count", count);
        result.put("sampleRows", sampleRows);
        result.put("filename", buildDownloadFilename(mgmtOfcNo));
        return result;
    }

    /**
     * CSV 파일명 생성
     * - 단지명 + 시각으로 어느 단지 데이터인지 파일명만으로 식별 가능하게 함
     * - 파일시스템에서 문제되는 문자는 _ 로 치환함
     */
    @Override
    public String buildDownloadFilename(String mgmtOfcNo) {
        String aptCmplexNo = meterHstryMapper.selectAptCmplexNoByMgmtOfcNo(mgmtOfcNo);
        String aptCmplexNm = StringUtils.hasText(aptCmplexNo)
                ? meterHstryMapper.selectAptCmplexNmByAptCmplexNo(aptCmplexNo)
                : null;

        String timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
        if (!StringUtils.hasText(aptCmplexNm)) {
            return "검침이력_" + timestamp + ".csv";
        }

        // 파일명에 쓸 수 없는 문자 치환
        String safeName = aptCmplexNm.replaceAll("[\\\\/:*?\"<>|]", "_").trim();
        return "검침이력_" + safeName + "_" + timestamp + ".csv";
    }

    /**
     * 미리보기 한 행 구성
     * - 화면에서 그대로 표시할 수 있게 ho_disp, usage_val 등 가공된 값까지 같이 내림
     */
    private Map<String, Object> toPreviewRow(MeterHstryVO meter) {
        Map<String, Object> row = new HashMap<>();
        row.put("meterHstryNo", meter.getMeterHstryNo());
        row.put("meterScope", meter.getMeterScope());
        row.put("meterTyNm", meter.getMeterTyNm());
        row.put("meterDt", formatDate(meter.getMeterDt()));
        row.put("facilityNo", meter.getFacilityNo());
        row.put("facilityNm", meter.getFacilityNm());
        row.put("hoNo", meter.getHoNo());
        row.put("hoDisp", formatHoDisp(meter.getHoNo()));
        row.put("preVal", formatNumber(meter.getPreVal()));
        row.put("currVal", formatNumber(meter.getCurrVal()));
        row.put("usageVal", formatNumber(calcUsageVal(meter)));
        row.put("meterRsltNm", meter.getMeterRsltNm());
        row.put("partnerNm", meter.getPartnerNm());
        return row;
    }

    /**
     * ho_no를 "101동 1502호" 형태로 변환
     * - 저장 형식: APTCMPLX_DONG_HO (예: A10023118_101_1502)
     * - 시설 검침 등 ho_no가 비어 있는 행은 빈 문자열을 반환함
     */
    private String formatHoDisp(String hoNo) {
        if (!StringUtils.hasText(hoNo)) {
            return "";
        }

        String[] parts = hoNo.split("_");
        if (parts.length < 3) {
            // 형식이 어긋난 데이터는 원본을 그대로 노출함
            return hoNo;
        }
        return parts[1] + "동 " + parts[2] + "호";
    }

    /**
     * 공급/검침 설정 목록 조회
     */
    @Override
    public List<UtilityProviderVO> selectUtilityProviderList(String mgmtOfcNo) {
        // 관리사무소 번호로 단지번호 조회
        String aptCmplexNo = meterHstryMapper.selectAptCmplexNoByMgmtOfcNo(mgmtOfcNo);

        // 화면 선택용 공급/검침 설정 목록 조회
        return meterHstryMapper.selectUtilityProviderList(aptCmplexNo);
    }

    /**
     * 검침 스코프별 공급/검침 설정 목록 조회
     * - 다운로드 모달 전용. 해당 스코프 검침이력이 실제 있는 업체만 노출함
     * - meter_scope는 utility_provider가 아닌 meter_hstry에 저장되므로 사용 이력 기반 EXISTS로 필터링
     */
    @Override
    public List<UtilityProviderVO> selectUtilityProviderListByScope(String mgmtOfcNo, String meterScope) {
        String aptCmplexNo = meterHstryMapper.selectAptCmplexNoByMgmtOfcNo(mgmtOfcNo);

        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("aptCmplexNo", aptCmplexNo);
        paramMap.put("meterScope", meterScope);
        return meterHstryMapper.selectUtilityProviderListByScope(paramMap);
    }

    /**
     * 검침결과 공통코드 목록 조회
     */
    @Override
    public List<Map<String, Object>> selectMeterRsltCodeList() {
        // 검침결과 공통코드 목록 조회
        return meterHstryMapper.selectMeterRsltCodeList();
    }

    /**
     * 검침유형 공통코드 목록 조회
     */
    @Override
    public List<Map<String, Object>> selectMeterTyCodeList() {
        // 검침유형 공통코드 목록 조회
        return meterHstryMapper.selectMeterTyCodeList();
    }

    /**
     * CSV 업로드 전 미리보기/자동 매칭
     * - CSV 첫 데이터 행의 csv_idntf_key, ext_cust_no를 기준으로 UTILITY_PROVIDER를 자동 조회함
     * - 실제 DB 저장이나 Google Drive 업로드는 하지 않음
     * - 화면에서는 반환된 utilityProviderNo를 hidden 값으로 넣고 최종 업로드에 사용함
     */
    @Override
    public Map<String, Object> previewMeterCsv(String mgmtOfcNo, String meterScope, MultipartFile csvFile) throws Exception {
        // 업로드 구분과 CSV 파일 기본 형식만 먼저 확인함
        validatePreviewInput(meterScope, csvFile);

        // 관리사무소 번호 기준 단지번호 조회
        String aptCmplexNo = meterHstryMapper.selectAptCmplexNoByMgmtOfcNo(mgmtOfcNo);
        if (!StringUtils.hasText(aptCmplexNo)) {
            throw new IllegalArgumentException("관리사무소에 연결된 단지 정보를 찾을 수 없습니다.");
        }

        // CSV 전체를 파싱하되, 미리보기에서는 DB 저장하지 않음
        List<Map<String, String>> csvRows = parseCsv(csvFile);
        if (csvRows.isEmpty()) {
            throw new IllegalArgumentException("CSV 데이터 행이 없습니다.");
        }

        // 업로드 구분과 CSV 내용이 맞지 않으면 미리보기 단계에서 바로 차단함
        validateMeterScopeRows(meterScope, csvRows);

        // 첫 데이터 행의 식별값으로 공급/검침 설정을 자동 매칭함
        Map<String, String> firstRow = csvRows.get(0);

        // CSV 값의 BOM, 따옴표, 앞뒤 공백을 제거해 DB 값과 같은 기준으로 맞춤
        String csvIdntfKey = cleanCsvValue(firstRow.get("csv_idntf_key"));
        String extCustNo = cleanCsvValue(firstRow.get("ext_cust_no"));

        validateRequired(firstRow.get("_lineNo"), "csv_idntf_key", csvIdntfKey);
        validateRequired(firstRow.get("_lineNo"), "ext_cust_no", extCustNo);

        Map<String, Object> providerParam = new HashMap<>();
        providerParam.put("aptCmplexNo", aptCmplexNo);
        providerParam.put("csvIdntfKey", csvIdntfKey);
        providerParam.put("extCustNo", extCustNo);

        UtilityProviderVO provider = meterHstryMapper.selectUtilityProviderByCsvKey(providerParam);
        if (provider == null) {
            throw new IllegalArgumentException("CSV 식별키와 외부 고객번호에 맞는 검침 설정을 찾을 수 없습니다.");
        }

        // 검침 업로드는 진행중인 계약에 연결된 설정만 허용함
        if (!"ACTIVE".equals(provider.getContSttsCd())) {
            throw new IllegalArgumentException("진행중인 검침 계약이 아닙니다.");
        }

        // 미리보기 행과 검증 메시지를 구성함
        List<Map<String, Object>> previewRows = new ArrayList<>();
        List<String> warnings = new ArrayList<>();
        Map<String, Integer> typeCountMap = new HashMap<>();

        int previewLimit = Math.min(csvRows.size(), 5);
        for (int i = 0; i < csvRows.size(); i++) {
            Map<String, String> row = csvRows.get(i);
            String lineNo = row.get("_lineNo");
            String facilityNo = row.get("facility_no");
            String hoNo = row.get("ho_no");
            String meterCn = row.get("meter_cn");
            String meterTyCd = resolveMeterTyCd(row, provider, lineNo);
            String meterTyNm = toMeterTyNm(meterTyCd);
            String meterUnit = toMeterUnit(meterTyCd);

            // 업로드 구분별 최소 기준을 안내 메시지로 표시함. 실제 업로드 검증은 최종 업로드에서 다시 수행함
            if ("COMPLEX".equals(meterScope)) {
                // 단지별 검침도 관리비 집계 연계를 위해 계량기 시설번호가 반드시 필요함
                if (!StringUtils.hasText(facilityNo)) {
                    warnings.add(lineNo + "행: 단지별 검침 CSV는 facility_no가 필요합니다.");
                }
                // 단지별 검침은 세대/호 기준 검침이므로 ho_no가 반드시 필요함
                if (!StringUtils.hasText(hoNo)) {
                    warnings.add(lineNo + "행: 단지별 검침 CSV는 ho_no가 필요합니다.");
                }
            }
            if ("FACILITY".equals(meterScope) && !StringUtils.hasText(facilityNo)) {
                warnings.add(lineNo + "행: 시설 검침 CSV는 facility_no가 필요합니다.");
            }

            if (StringUtils.hasText(meterTyNm)) {
                typeCountMap.put(meterTyNm, typeCountMap.getOrDefault(meterTyNm, 0) + 1);
            }

            // 화면 미리보기는 최대 5행만 내려줌
            if (i < previewLimit) {
                Map<String, Object> previewRow = new HashMap<>();
                previewRow.put("lineNo", lineNo);
                previewRow.put("facilityNo", facilityNo);
                previewRow.put("hoNo", hoNo);
                previewRow.put("meterDt", row.get("meter_dt"));
                previewRow.put("preVal", row.get("pre_val"));
                previewRow.put("currVal", row.get("curr_val"));
                previewRow.put("meterCn", meterCn);
                previewRow.put("meterRsltCd", row.get("meter_rslt_cd"));
                previewRow.put("meterTyNm", StringUtils.hasText(meterTyNm) ? meterTyNm : "-");
                previewRow.put("meterUnit", StringUtils.hasText(meterUnit) ? meterUnit : "-");
                previewRows.add(previewRow);
            }
        }

        Map<String, Object> result = new HashMap<>();
        result.put("utilityProviderNo", provider.getUtilityProviderNo());
        result.put("csvIdntfKey", provider.getCsvIdntfKey());
        result.put("extCustNo", provider.getExtCustNo());
        result.put("partnerNm", provider.getPartnerNm());
        result.put("contNm", provider.getContNm());
        result.put("contCn", provider.getContCn());
        result.put("contBgngDt", provider.getContBgngDt());
        result.put("contEndDt", provider.getContEndDt());
        result.put("meterTyNm", provider.getMeterTyNm());
        result.put("meterScope", meterScope);
        result.put("totalCnt", csvRows.size());
        result.put("previewRows", previewRows);
        result.put("typeCountMap", typeCountMap);
        result.put("warnings", warnings);
        result.put("uploadable", warnings.isEmpty());
        result.put("message", warnings.isEmpty() ? "CSV 확인이 완료되었습니다." : "확인이 필요한 행이 있습니다.");

        return result;
    }

    /**
     * 검침 CSV 업로드 처리
     * - 부분 성공은 처리하지 않음
     * - CSV 전체 검증 후 이상 없을 때만 Google Drive 업로드 및 METER_HSTRY 등록을 진행함
     * - CSV 원본 파일은 Google Drive 업로드 후 ATTACH_FILE에 저장함
     * - 로그인 사용자 번호는 METER_UPLOAD_HSTRY.UPLOAD_USER_NO에 저장함
     */
    @Override
    @Transactional
    public Map<String, Object> uploadMeterCsv(
            String mgmtOfcNo,
            String utilityProviderNo,
            String meterScope,
            MultipartFile csvFile,
            String uploadUserNo
    ) throws Exception {
        // 기본 입력값 검증
        validateUploadInput(utilityProviderNo, meterScope, csvFile);

        // 관리사무소 번호 기준 단지번호 조회
        String aptCmplexNo = meterHstryMapper.selectAptCmplexNoByMgmtOfcNo(mgmtOfcNo);
        if (!StringUtils.hasText(aptCmplexNo)) {
            throw new IllegalArgumentException("관리사무소에 연결된 단지 정보를 찾을 수 없습니다.");
        }

        // 공급/검침 설정 조회 조건 구성
        Map<String, Object> providerParam = new HashMap<>();
        providerParam.put("aptCmplexNo", aptCmplexNo);
        providerParam.put("utilityProviderNo", utilityProviderNo);

        // 공급/검침 설정 조회
        UtilityProviderVO provider = meterHstryMapper.selectUtilityProviderDetail(providerParam);
        if (provider == null) {
            throw new IllegalArgumentException("선택한 공급/검침 설정을 찾을 수 없습니다.");
        }

        // 업로드 이력번호 생성
        String uploadNo = createUploadNo();

        /*
         * 1. CSV 파싱 먼저 수행
         * - 파일을 Google Drive에 올리기 전에 CSV 내용이 비어 있는지 확인함
         * - 여기서 실패하면 Google Drive에는 아무 파일도 올라가지 않음
         */
        List<Map<String, String>> csvRows = parseCsv(csvFile);
        if (csvRows.isEmpty()) {
            throw new IllegalArgumentException("CSV 데이터 행이 없습니다.");
        }

        // 단지별/시설 업로드 구분과 CSV 내용이 맞는지 최종 업로드 전에도 다시 검증함
        validateMeterScopeRows(meterScope, csvRows);

        /*
         * 2. CSV 전체 행 검증 및 VO 변환 먼저 수행
         * - facility_no, ho_no, meter_rslt_cd 등의 오류를 파일 업로드 전에 잡기 위한 순서
         * - 여기서 실패하면 Google Drive에는 아무 파일도 올라가지 않음
         */
        List<MeterHstryVO> meterRows = convertAndValidateRows(csvRows, provider, aptCmplexNo, meterScope);

        /*
         * 3. 검증이 모두 끝난 뒤에만 CSV 원본 파일 업로드
         * - Google Drive 업로드는 DB 트랜잭션처럼 자동 롤백되지 않으므로 최대한 뒤에서 실행함
         */
        Long fileGroupNo = saveCsvAttachFile(csvFile, aptCmplexNo, uploadNo);

        try {
            LocalDateTime uploadFilterFrom = LocalDateTime.now().minusSeconds(5);
            // 검증 완료된 검침 이력 등록
            for (MeterHstryVO meterHstryVO : meterRows) {
                meterHstryMapper.insertMeterHstry(meterHstryVO);
            }

            // 업로드 성공 이력 등록
            insertUploadHistory(uploadNo, provider, fileGroupNo, meterRows.size(), UPLOAD_DONE, null, uploadUserNo);

            // 등록 건수 반환
            LocalDateTime uploadFilterTo = LocalDateTime.now().plusSeconds(5);
            Map<String, Object> result = new HashMap<>();
            result.put("insertCnt", meterRows.size());
            result.put("meterScope", meterScope);
            result.put("utilityProviderNo", provider.getUtilityProviderNo());
            result.put("uploadedFrom", uploadFilterFrom.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
            result.put("uploadedTo", uploadFilterTo.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
            return result;

        } catch (Exception e) {
            /*
             * DB 저장 중 실패 이력 등록
             * - 이 시점은 이미 Google Drive 업로드가 끝난 뒤라 파일은 남을 수 있음
             * - 그래도 CSV 검증 오류는 위에서 먼저 막기 때문에 불필요한 Drive 파일은 줄어듦
             */
            insertUploadHistory(uploadNo, provider, fileGroupNo, 0, UPLOAD_FAIL, e.getMessage(), uploadUserNo);

            // Controller에서 메시지 처리할 수 있도록 예외 재전달
            throw e;
        }
    }

    /**
     * CSV 미리보기 기본 입력값 검증
     */
    private void validatePreviewInput(String meterScope, MultipartFile csvFile) {
        // 업로드 구분 확인
        if (!"COMPLEX".equals(meterScope) && !"FACILITY".equals(meterScope)) {
            throw new IllegalArgumentException("검침 업로드 구분이 올바르지 않습니다.");
        }

        // 파일 선택 여부 확인
        if (csvFile == null || csvFile.isEmpty()) {
            throw new IllegalArgumentException("확인할 CSV 파일을 선택해주세요.");
        }

        // 확장자 확인
        String originalFilename = csvFile.getOriginalFilename();
        if (!StringUtils.hasText(originalFilename) || !originalFilename.toLowerCase().endsWith(".csv")) {
            throw new IllegalArgumentException("CSV 파일만 확인할 수 있습니다.");
        }
    }

    /**
     * 업로드 기본 입력값 검증
     */
    private void validateUploadInput(String utilityProviderNo, String meterScope, MultipartFile csvFile) {
        // 공급/검침 설정 선택 여부 확인
        if (!StringUtils.hasText(utilityProviderNo)) {
            throw new IllegalArgumentException("공급/검침 업체를 선택해주세요.");
        }

        // 업로드 구분 확인
        if (!"COMPLEX".equals(meterScope) && !"FACILITY".equals(meterScope)) {
            throw new IllegalArgumentException("검침 업로드 구분이 올바르지 않습니다.");
        }

        // 파일 선택 여부 확인
        if (csvFile == null || csvFile.isEmpty()) {
            throw new IllegalArgumentException("업로드할 CSV 파일을 선택해주세요.");
        }

        // 확장자 확인
        String originalFilename = csvFile.getOriginalFilename();
        if (!StringUtils.hasText(originalFilename) || !originalFilename.toLowerCase().endsWith(".csv")) {
            throw new IllegalArgumentException("CSV 파일만 업로드할 수 있습니다.");
        }
    }

    /**
     * CSV 업로드 구분과 실제 CSV 행 내용 검증
     * - 단지별 검침은 ho_no 중심의 세대 검침 CSV만 허용함
     * - 시설 검침은 facility_no 중심의 시설 검침 CSV만 허용함
     * - 시설도 위치 보조값으로 ho_no를 가질 수는 있지만, 여러 동/호가 섞이면 세대 대량 검침으로 보고 차단함
     */
    private void validateMeterScopeRows(String meterScope, List<Map<String, String>> csvRows) {
        int hoNoCnt = 0;
        int facilityNoCnt = 0;
        Map<String, Boolean> uniqueHoNoMap = new HashMap<>();

        for (Map<String, String> row : csvRows) {
            String hoNo = row.get("ho_no");
            String facilityNo = row.get("facility_no");

            if (StringUtils.hasText(hoNo)) {
                hoNoCnt++;
                uniqueHoNoMap.put(hoNo.trim(), true);
            }

            if (StringUtils.hasText(facilityNo)) {
                facilityNoCnt++;
            }
        }

        if ("COMPLEX".equals(meterScope)) {
            // 단지별 검침도 관리비 집계 연계를 위해 계량기 시설번호가 반드시 필요함
            if (facilityNoCnt == 0) {
                throw new IllegalArgumentException("단지별 검침 CSV에는 facility_no 값이 필요합니다. 계량기 시설번호를 포함해주세요.");
            }

            // 일부 행만 facility_no가 비어 있는 경우도 DB 정합성을 위해 차단함
            if (facilityNoCnt < csvRows.size()) {
                throw new IllegalArgumentException("단지별 검침 CSV에는 모든 행에 facility_no 값이 필요합니다.");
            }

            // 단지별 검침은 세대/호 기준 대량 검침이므로 ho_no가 반드시 필요함
            if (hoNoCnt == 0) {
                throw new IllegalArgumentException("단지별 검침 CSV에는 ho_no 값이 필요합니다. 시설번호만 있는 CSV는 시설 검침 업로드를 사용해주세요.");
            }

            // 일부 행만 ho_no가 비어 있는 경우도 세대 검침으로 저장할 수 없으므로 차단함
            if (hoNoCnt < csvRows.size()) {
                throw new IllegalArgumentException("단지별 검침 CSV에는 모든 행에 ho_no 값이 필요합니다.");
            }
            return;
        }

        if ("FACILITY".equals(meterScope)) {
            // 시설 검침은 시설자산 기준이므로 facility_no가 반드시 필요함
            if (facilityNoCnt == 0) {
                throw new IllegalArgumentException("시설 검침 CSV에는 facility_no 값이 필요합니다. 동/호만 있는 CSV는 단지별 검침 업로드를 사용해주세요.");
            }

            /*
             * 시설도 위치상 ho_no를 가질 수는 있음.
             * 다만 서로 다른 ho_no가 여러 개 섞인 CSV는 세대별 대량 검침으로 보고 시설 업로드에서 차단함.
             */
            if (uniqueHoNoMap.size() >= 2) {
                throw new IllegalArgumentException("시설 검침 CSV에 여러 동/호 값이 포함되어 있습니다. 단지별 검침 업로드를 사용해주세요.");
            }
        }
    }

    /**
     * CSV 원본 파일 Google Drive 업로드 및 ATTACH_FILE 등록
     * - 기존 프로젝트의 GoogleDriveService.uploadFile() 흐름 사용
     * - ATTACH_FILE.GOOGLE_ID는 Google Drive 업로드 결과값으로 저장
     * - 반환값은 METER_UPLOAD_HSTRY.FILE_GROUP_NO에 연결할 파일그룹번호
     */
    private Long saveCsvAttachFile(MultipartFile csvFile, String aptCmplexNo, String uploadNo) throws Exception {
        // 원본 파일명 확인
        String originalFilename = csvFile.getOriginalFilename();

        // 원본 파일명이 비어 있을 때 기본 파일명 사용
        if (!StringUtils.hasText(originalFilename)) {
            originalFilename = "meter_upload.csv";
        }

        // 저장 파일명 생성
        String uuid = UUID.randomUUID().toString().replace("-", "");
        String savedFileName = uuid + "_" + originalFilename;

        // Google Drive 폴더 경로 생성
        LocalDate today = LocalDate.now();
        String folderPath = "apt/meter/"
                + aptCmplexNo + "/"
                + today.getYear() + "/"
                + String.format("%02d", today.getMonthValue()) + "/"
                + uploadNo;

        // 첨부파일 카테고리
        String cat = FILE_CAT_METER_CSV;

        // Google Drive 업로드 실행
        String googleId = googleDriveService.uploadFile(csvFile, folderPath, savedFileName);

        // 공통 첨부파일 그룹번호 채번
        long fileGroupNo = attachFileMapper.getSeqFileGroupNo();

        // 공통 AttachFileVO 생성
        AttachFileVO attachFile = AttachFileVO.fileSettings(
                csvFile,
                fileGroupNo,
                cat,
                savedFileName,
                googleId,
                folderPath,
                1
        );

        // ATTACH_FILE 저장
        attachFileMapper.insertAttachFile(attachFile);

        // 업로드 이력과 연결할 파일그룹번호 반환
        return fileGroupNo;
    }

    /**
     * CSV 파일 파싱
     * - 첫 줄은 헤더로 사용함
     * - 큰따옴표로 감싼 쉼표는 하나의 값으로 처리함
     */
    private List<Map<String, String>> parseCsv(MultipartFile csvFile) throws IOException {
        List<Map<String, String>> resultList = new ArrayList<>();

        try (BufferedReader reader = new BufferedReader(new InputStreamReader(csvFile.getInputStream(), StandardCharsets.UTF_8))) {
            String headerLine = reader.readLine();

            // 헤더가 없으면 빈 목록 반환
            if (!StringUtils.hasText(headerLine)) {
                return resultList;
            }

            // BOM 제거 및 헤더 분리
            headerLine = headerLine.replace("\uFEFF", "");
            List<String> headers = splitCsvLine(headerLine);

            String line;
            int lineNo = 1;

            while ((line = reader.readLine()) != null) {
                lineNo++;

                // 빈 줄은 무시
                if (!StringUtils.hasText(line)) {
                    continue;
                }

                // 행 데이터를 헤더 기준 Map으로 변환
                List<String> values = splitCsvLine(line);
                Map<String, String> rowMap = new HashMap<>();
                rowMap.put("_lineNo", String.valueOf(lineNo));

                for (int i = 0; i < headers.size(); i++) {
                    String key = headers.get(i).trim();
                    String value = i < values.size() ? values.get(i).trim() : "";
                    rowMap.put(key, value);
                }

                resultList.add(rowMap);
            }
        }

        return resultList;
    }

    /**
     * CSV 한 줄 분리
     * - 간단한 CSV 따옴표 처리를 포함함
     */
    private List<String> splitCsvLine(String line) {
        List<String> values = new ArrayList<>();
        StringBuilder current = new StringBuilder();
        boolean inQuotes = false;

        for (int i = 0; i < line.length(); i++) {
            char ch = line.charAt(i);

            // 따옴표 상태 전환
            if (ch == '"') {
                inQuotes = !inQuotes;
                continue;
            }

            // 따옴표 밖 쉼표는 컬럼 구분자
            if (ch == ',' && !inQuotes) {
                values.add(current.toString());
                current.setLength(0);
                continue;
            }

            // 일반 문자 추가
            current.append(ch);
        }

        // 마지막 컬럼 추가
        values.add(current.toString());

        return values;
    }

    /**
     * CSV 행 검증 및 검침 이력 VO 변환
     * - METER_HSTRY.METER_TY_CD 컬럼에 저장할 검침유형을 확정함
     * - CSV에 meter_ty_cd가 있으면 우선 사용하고, 없으면 매칭된 검침 설정(provider)의 유형을 사용함
     */
    private List<MeterHstryVO> convertAndValidateRows(List<Map<String, String>> csvRows, UtilityProviderVO provider, String aptCmplexNo, String meterScope) {
        List<MeterHstryVO> meterRows = new ArrayList<>();

        for (Map<String, String> row : csvRows) {
            String lineNo = row.get("_lineNo");

            // 필수 컬럼 값 추출
            String csvIdntfKey = cleanCsvValue(row.get("csv_idntf_key"));
            String extCustNo = cleanCsvValue(row.get("ext_cust_no"));
            String facilityNo = cleanCsvValue(row.get("facility_no"));
            String hoNo = cleanCsvValue(row.get("ho_no"));
            String meterDt = cleanCsvValue(row.get("meter_dt"));
            String preVal = cleanCsvValue(row.get("pre_val"));
            String currVal = cleanCsvValue(row.get("curr_val"));
            String meterCn = cleanCsvValue(row.get("meter_cn"));
            String meterRsltCd = cleanCsvValue(row.get("meter_rslt_cd"));

            // 공급/검침 설정 식별값 검증
            if (StringUtils.hasText(provider.getCsvIdntfKey()) && !provider.getCsvIdntfKey().equals(csvIdntfKey)) {
                throw new IllegalArgumentException(lineNo + "행: CSV 식별키가 선택한 검침 설정과 일치하지 않습니다.");
            }
            if (StringUtils.hasText(provider.getExtCustNo()) && !provider.getExtCustNo().equals(extCustNo)) {
                throw new IllegalArgumentException(lineNo + "행: 외부 고객번호가 선택한 검침 설정과 일치하지 않습니다.");
            }

            // 업로드 구분별 필수값 검증
            if ("COMPLEX".equals(meterScope)) {
                // 단지별 검침도 관리비 집계 연계를 위해 계량기 시설번호가 반드시 필요함
                validateRequired(lineNo, "facility_no", facilityNo);

                // 단지별 검침은 세대/호 식별값이 반드시 필요함
                validateRequired(lineNo, "ho_no", hoNo);
            } else {
                // 시설 검침은 시설번호가 필수임. 시설도 호 정보를 가질 수 있으므로 ho_no는 보조값으로만 둠
                validateRequired(lineNo, "facility_no", facilityNo);
            }

            // 공통 필수값 검증
            validateRequired(lineNo, "meter_dt", meterDt);
            validateRequired(lineNo, "pre_val", preVal);
            validateRequired(lineNo, "curr_val", currVal);
            validateRequired(lineNo, "meter_cn", meterCn);
            validateRequired(lineNo, "meter_rslt_cd", meterRsltCd);

            // 검침유형 확정
            String meterTyCd = resolveMeterTyCd(row, provider, lineNo);

            // 시설번호는 단지별/시설 검침 모두 필수값이므로 현재 단지의 실제 시설인지 검증함
            Map<String, Object> facilityParam = new HashMap<>();
            facilityParam.put("aptCmplexNo", aptCmplexNo);
            facilityParam.put("facilityNo", facilityNo);

            if (meterHstryMapper.selectFacilityCnt(facilityParam) == 0) {
                throw new IllegalArgumentException(lineNo + "행: 존재하지 않는 시설번호입니다. facility_no=" + facilityNo);
            }

            // 검침결과코드 유효성 검증
            if (meterHstryMapper.selectMeterRsltCodeCnt(meterRsltCd) == 0) {
                throw new IllegalArgumentException(lineNo + "행: 존재하지 않는 검침결과코드입니다. meter_rslt_cd=" + meterRsltCd);
            }

            // 검침 이력 VO 구성
            MeterHstryVO vo = new MeterHstryVO();
            // facility_no는 세대/시설 검침 모두 실제 FACILITY.FACILITY_NO로 저장함
            vo.setFacilityNo(facilityNo.trim());
            vo.setHoNo(StringUtils.hasText(hoNo) ? hoNo.trim() : null);
            vo.setMeterTyCd(meterTyCd);
            vo.setMeterDt(java.sql.Date.valueOf(LocalDate.parse(meterDt)));
            vo.setPreVal(new BigDecimal(preVal));
            vo.setCurrVal(new BigDecimal(currVal));
            // 검침구분은 METER_HSTRY.METER_SCOPE에 명확히 저장함
            vo.setMeterScope(meterScope);
            // 신규 데이터는 검침내용에 [단지검침]/[시설검침] prefix를 붙이지 않음
            vo.setMeterCn(removeScopePrefix(meterCn));
            vo.setMeterRsltCd(meterRsltCd);
            vo.setUtilityProviderNo(provider.getUtilityProviderNo());

            meterRows.add(vo);
        }

        return meterRows;
    }


    /**
     * CSV 값 정리
     * - UTF-8 BOM, 따옴표, 앞뒤 공백을 제거함
     * - CSV 자동 매칭과 행 검증에서 같은 기준으로 비교하기 위한 처리
     */
    private String cleanCsvValue(String value) {
        if (value == null) {
            return null;
        }

        return value
                .replace("\uFEFF", "")
                .replace("\"", "")
                .trim();
    }

    /**
     * 검침내용 prefix 제거
     * - METER_SCOPE 컬럼을 사용하므로 신규 저장 시 METER_CN에는 순수 검침내용만 남김
     * - 예전 CSV나 더미에 prefix가 포함되어 들어와도 중복 저장하지 않도록 정리함
     */
    private String removeScopePrefix(String meterCn) {
        String value = StringUtils.hasText(meterCn) ? meterCn.trim() : "";

        // 예전 prefix가 들어온 경우 검침내용에서 제거함
        if (value.startsWith("[단지검침]")) {
            return value.substring("[단지검침]".length()).trim();
        }
        if (value.startsWith("[시설검침]")) {
            return value.substring("[시설검침]".length()).trim();
        }
        return value;
    }

    /**
     * 검침유형 확정
     * - CSV에 meter_ty_cd가 들어온 경우 검침 설정의 유형과 다르면 차단함
     * - CSV에 meter_ty_cd가 없으면 UTILITY_PROVIDER.METER_TY_CD를 그대로 사용함
     * - 더 이상 검침내용/파일명 문자열로 전기·수도·가스를 추정하지 않음
     */
    private String resolveMeterTyCd(Map<String, String> row, UtilityProviderVO provider, String lineNo) {
        String rawCsvMeterTyCd = row.get("meter_ty_cd");
        String csvMeterTyCd = normalizeMeterTyCd(rawCsvMeterTyCd);
        String providerMeterTyCd = normalizeMeterTyCd(provider.getMeterTyCd());

        // CSV에 meter_ty_cd가 들어왔지만 공통코드 형태가 아니면 차단함
        if (StringUtils.hasText(rawCsvMeterTyCd) && !StringUtils.hasText(csvMeterTyCd)) {
            throw new IllegalArgumentException(lineNo + "행: 검침유형코드가 올바르지 않습니다. meter_ty_cd=" + rawCsvMeterTyCd);
        }

        // 검침 설정 자체에 유형이 없으면 업로드 대상 설정으로 보지 않음
        if (!StringUtils.hasText(providerMeterTyCd)) {
            throw new IllegalArgumentException("매칭된 검침 설정에 검침유형이 없습니다. UTILITY_PROVIDER.METER_TY_CD를 확인해주세요.");
        }

        // CSV 유형이 명시되어 있으면 설정 유형과 일치해야 함
        if (StringUtils.hasText(csvMeterTyCd) && !csvMeterTyCd.equals(providerMeterTyCd)) {
            throw new IllegalArgumentException(lineNo + "행: CSV 검침유형이 매칭된 검침 설정과 일치하지 않습니다. meter_ty_cd=" + csvMeterTyCd + ", provider=" + providerMeterTyCd);
        }

        return providerMeterTyCd;
    }

    /** 검침유형코드 정규화 */
    private String normalizeMeterTyCd(String value) {
        if (!StringUtils.hasText(value)) {
            return null;
        }

        String upper = value.trim().toUpperCase();
        if ("ELEC".equals(upper) || "ELC".equals(upper)) return "ELEC";
        if ("WATER".equals(upper) || "WTR".equals(upper)) return "WATER";
        if ("GAS".equals(upper)) return "GAS";
        if ("HEAT".equals(upper)) return "HEAT";
        return null;
    }


    /** 검침유형명 변환 */
    private String toMeterTyNm(String meterTyCd) {
        if ("ELEC".equals(meterTyCd)) return "전기계량";
        if ("WATER".equals(meterTyCd)) return "수도계량";
        if ("GAS".equals(meterTyCd)) return "가스계량";
        if ("HEAT".equals(meterTyCd)) return "난방계량";
        return null;
    }

    /** 검침 단위 변환 */
    private String toMeterUnit(String meterTyCd) {
        if ("ELEC".equals(meterTyCd)) return "kWh";
        if ("WATER".equals(meterTyCd) || "GAS".equals(meterTyCd)) return "㎥";
        if ("HEAT".equals(meterTyCd)) return "Gcal";
        return null;
    }

    /**
     * 필수값 검증
     */
    private void validateRequired(String lineNo, String columnName, String value) {
        if (!StringUtils.hasText(value)) {
            throw new IllegalArgumentException(lineNo + "행: " + columnName + " 값이 비어 있습니다.");
        }
    }

    /**
     * 업로드 이력 등록
     */
    private void insertUploadHistory(
            String uploadNo,
            UtilityProviderVO provider,
            Long fileGroupNo,
            int totalCnt,
            String statusCd,
            String errCn,
            String uploadUserNo
    ) {
        MeterUploadHstryVO uploadVO = new MeterUploadHstryVO();

        // 업로드 이력 기본값 세팅
        uploadVO.setMeterUploadHstryNo(uploadNo);
        uploadVO.setUtilityProviderNo(provider.getUtilityProviderNo());
        uploadVO.setAptCmplexNo(provider.getAptCmplexNo());
        uploadVO.setFileGroupNo(fileGroupNo);
        uploadVO.setUploadUserNo(uploadUserNo);
        uploadVO.setTotalCnt(totalCnt);
        uploadVO.setUploadSttsCd(statusCd);
        uploadVO.setErrCn(errCn);
        uploadVO.setRmrkCn("CSV 검침 이력 업로드");

        // 업로드 이력 등록
        meterHstryMapper.insertMeterUploadHstry(uploadVO);
    }

    /**
     * 업로드 이력번호 생성
     * - 시퀀스를 만들지 않는 방향이므로 시간 기반 문자열을 사용함
     */
    private String createUploadNo() {
        return "MUH" + LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyMMddHHmmss"));
    }

    /**
     * 검침 이력 단건 상세 조회
     */
    @Override
    public MeterHstryVO selectMeterHstryDetail(String meterHstryNo) {
        return meterHstryMapper.selectMeterHstryDetail(meterHstryNo);
    }

    /**
     * 검침 이력 수정
     */
    @Override
    public int updateMeterHstry(MeterHstryVO meterHstryVO) {
        return meterHstryMapper.updateMeterHstry(meterHstryVO);
    }

    /**
     * 다운로드 조건 파라미터 구성
     */
    private Map<String, Object> buildDownloadParamMap(String mgmtOfcNo, Map<String, Object> paramMap) {
        Map<String, Object> downloadParamMap = new HashMap<>();
        if (paramMap != null) {
            downloadParamMap.putAll(paramMap);
        }

        String aptCmplexNo = meterHstryMapper.selectAptCmplexNoByMgmtOfcNo(mgmtOfcNo);
        downloadParamMap.put("aptCmplexNo", aptCmplexNo);

        if ("ALL".equals(downloadParamMap.get("meterScope"))) {
            downloadParamMap.put("meterScope", "");
        }
        return downloadParamMap;
    }

    /** 한국 엑셀 호환용 CSV 출력 인코딩 */
    private static final java.nio.charset.Charset CSV_CHARSET = java.nio.charset.Charset.forName("MS949");

    /**
     * CSV 본문 생성
     * - UTF-8 BOM을 한국 엑셀이 가끔 무시해 한글이 깨지는 사례가 있어 MS949(CP949)로 직접 인코딩함
     * - MS949는 한국 엑셀 기본 인코딩이라 별도 처리 없이 더블클릭만으로 정상 표시됨
     * - 한글/숫자/영문만 다루는 검침 이력 CSV 특성상 MS949로 표현 불가한 문자가 들어올 일은 없음
     */
    private byte[] buildMeterCsv(List<MeterHstryVO> meterList) {
        StringBuilder csv = new StringBuilder();
        csv.append(CSV_HEADER).append("\r\n");

        if (meterList != null) {
            for (MeterHstryVO meter : meterList) {
                csv.append(csvValue(meter.getMeterHstryNo())).append(',');
                csv.append(csvValue(meter.getMeterScope())).append(',');
                csv.append(csvValue(meter.getMeterTyCd())).append(',');
                csv.append(csvValue(meter.getMeterTyNm())).append(',');
                csv.append(csvValue(formatDate(meter.getMeterDt()))).append(',');
                csv.append(csvValue(meter.getFacilityNo())).append(',');
                csv.append(csvValue(meter.getFacilityNm())).append(',');
                csv.append(csvValue(meter.getHoNo())).append(',');
                csv.append(csvValue(formatHoDisp(meter.getHoNo()))).append(',');
                csv.append(csvValue(formatNumber(meter.getPreVal()))).append(',');
                csv.append(csvValue(formatNumber(meter.getCurrVal()))).append(',');
                csv.append(csvValue(formatNumber(calcUsageVal(meter)))).append(',');
                csv.append(csvValue(meter.getMeterRsltCd())).append(',');
                csv.append(csvValue(meter.getMeterRsltNm())).append(',');
                csv.append(csvValue(meter.getPartnerNm())).append(',');
                csv.append(csvValue(meter.getMeterCn())).append("\r\n");
            }
        }

        return csv.toString().getBytes(CSV_CHARSET);
    }

    /**
     * CSV 날짜 값 변환
     */
    private String formatDate(java.util.Date date) {
        if (date == null) {
            return "";
        }
        return new SimpleDateFormat("yyyy-MM-dd").format(date);
    }

    /**
     * 검침 사용량 계산
     */
    private BigDecimal calcUsageVal(MeterHstryVO meter) {
        if (meter.getCurrVal() == null || meter.getPreVal() == null) {
            return null;
        }
        return meter.getCurrVal().subtract(meter.getPreVal());
    }

    /**
     * CSV 숫자 값 변환
     */
    private String formatNumber(BigDecimal value) {
        if (value == null) {
            return "";
        }
        return value.stripTrailingZeros().toPlainString();
    }

    /**
     * CSV 셀 값 이스케이프
     */
    private String csvValue(Object value) {
        if (value == null) {
            return "";
        }

        String text = String.valueOf(value);
        if (text.contains("\"") || text.contains(",") || text.contains("\n") || text.contains("\r")) {
            return "\"" + text.replace("\"", "\"\"") + "\"";
        }
        return text;
    }
}
