package kr.or.ddit.domain.apt.mgmtOffice.meter.mapper;

import kr.or.ddit.domain.apt.mgmtOffice.meter.vo.MeterHstryVO;
import kr.or.ddit.domain.apt.mgmtOffice.meter.vo.MeterUploadHstryVO;
import kr.or.ddit.domain.apt.mgmtOffice.meter.vo.UtilityProviderVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;

/**
 * 검침 이력 Mapper 인터페이스
 * - METER_HSTRY 조회/등록
 * - METER_UPLOAD_HSTRY 등록
 * - ATTACH_FILE CSV 원본 파일 메타정보 등록
 */
@Mapper
public interface IMeterHstryMapper {

    /** 관리사무소 번호로 아파트단지번호 조회 */
    String selectAptCmplexNoByMgmtOfcNo(String mgmtOfcNo);

    /** 아파트단지번호로 단지명 조회 */
    String selectAptCmplexNmByAptCmplexNo(String aptCmplexNo);

    /** 검침 이력 목록 조회 */
    List<MeterHstryVO> selectMeterHstryList(Map<String, Object> paramMap);

    /** 검침 이력 조건 건수 조회 */
    int selectMeterHstryCount(Map<String, Object> paramMap);

    /** 공급/검침 설정 목록 조회 */
    List<UtilityProviderVO> selectUtilityProviderList(String aptCmplexNo);

    /** 검침 스코프(COMPLEX/FACILITY)별 공급/검침 설정 목록 조회 (다운로드 모달 전용) */
    List<UtilityProviderVO> selectUtilityProviderListByScope(Map<String, Object> paramMap);

    /** 공급/검침 설정 상세 조회 */
    UtilityProviderVO selectUtilityProviderDetail(Map<String, Object> paramMap);

    /** CSV 식별키/외부 고객번호로 공급/검침 설정 조회 */
    UtilityProviderVO selectUtilityProviderByCsvKey(Map<String, Object> paramMap);



    /** 검침결과 공통코드 목록 조회 */
    List<Map<String, Object>> selectMeterRsltCodeList();

    /** 검침유형 공통코드 목록 조회 */
    List<Map<String, Object>> selectMeterTyCodeList();

    /** 검침결과 공통코드 존재 건수 조회 */
    int selectMeterRsltCodeCnt(String meterRsltCd);

    /** 시설 존재 건수 조회 */
    int selectFacilityCnt(Map<String, Object> paramMap);

    /** 검침 업로드 이력 등록 */
    int insertMeterUploadHstry(MeterUploadHstryVO meterUploadHstryVO);

    /** 검침 이력 등록 */
    int insertMeterHstry(MeterHstryVO meterHstryVO);


    /** 검침 이력 단건 상세 조회 */
    MeterHstryVO selectMeterHstryDetail(String meterHstryNo);

    /** 검침 이력 수정 */
    int updateMeterHstry(MeterHstryVO meterHstryVO);
}
