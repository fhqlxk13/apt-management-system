package kr.or.ddit.domain.apt.mgmtOffice.meter.service;

import kr.or.ddit.domain.apt.mgmtOffice.meter.vo.MeterHstryVO;
import kr.or.ddit.domain.apt.mgmtOffice.meter.vo.UtilityProviderVO;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.Map;

/**
 * 검침 이력 Service 인터페이스
 */
public interface IMeterHstryService {

    /** 검침 이력 목록 조회 */
    List<MeterHstryVO> selectMeterHstryList(Map<String, Object> paramMap);

    int selectMeterHstryCount(Map<String, Object> paramMap);

    /** 공급/검침 설정 목록 조회 */
    List<UtilityProviderVO> selectUtilityProviderList(String mgmtOfcNo);

    /** 검침 스코프별 공급/검침 설정 목록 조회 (다운로드 모달 전용) */
    List<UtilityProviderVO> selectUtilityProviderListByScope(String mgmtOfcNo, String meterScope);

    /** 검침결과 공통코드 목록 조회 */
    List<Map<String, Object>> selectMeterRsltCodeList();

    /** 검침유형 공통코드 목록 조회 */
    List<Map<String, Object>> selectMeterTyCodeList();

    /** CSV 업로드 전 미리보기/자동 매칭 */
    Map<String, Object> previewMeterCsv(String mgmtOfcNo, String meterScope, MultipartFile csvFile) throws Exception;

    /** 검침 CSV 업로드 처리 */
    Map<String, Object> uploadMeterCsv(String mgmtOfcNo, String utilityProviderNo, String meterScope, MultipartFile csvFile, String uploadUserNo) throws Exception;

    /** 검침 이력 단건 상세 조회 */
    MeterHstryVO selectMeterHstryDetail(String meterHstryNo);

    /** 검침 이력 수정 */
    int updateMeterHstry(MeterHstryVO meterHstryVO);

    /** 다운로드 조건 기준 CSV 생성 */
    byte[] downloadMeterCsv(String mgmtOfcNo, Map<String, Object> paramMap);

    /** 다운로드 조건 기준 검침 건수 조회 */
    int countDownloadMeter(String mgmtOfcNo, Map<String, Object> paramMap);

    /** 다운로드 조건 기준 미리보기 (건수 + 샘플 행) */
    Map<String, Object> previewDownloadMeter(String mgmtOfcNo, Map<String, Object> paramMap);

    /** CSV 파일명 생성 (단지명 포함) */
    String buildDownloadFilename(String mgmtOfcNo);
}
