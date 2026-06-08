package kr.or.ddit.domain.apt.mgmtOffice.facility.controller;

import kr.or.ddit.common.file.vo.AttachFileVO;
import kr.or.ddit.domain.apt.mgmtOffice.common.service.IManagerModelService;
import kr.or.ddit.domain.apt.mgmtOffice.contract.service.IFacilityContractService;
import kr.or.ddit.domain.apt.mgmtOffice.facility.check.vo.FacilityCheckHstryVO;
import kr.or.ddit.domain.apt.mgmtOffice.facility.dto.FacilityDTO;
import kr.or.ddit.domain.apt.mgmtOffice.facility.dto.FacilityLocationDTO;
import kr.or.ddit.domain.apt.mgmtOffice.facility.service.IFacilityService;
import kr.or.ddit.domain.apt.mgmtOffice.facility.vo.FacilityVO;
import kr.or.ddit.domain.member.vo.CustomUser;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 시설 Controller
 *
 * 역할
 * - 시설자산 화면 이동
 * - 시설자산 조회 API
 * - 시설자산 등록/수정 API
 * - 시설유형 정정 API
 * - 위치 조회 API
 *
 * 정리 기준
 * - 사진 업로드/삭제는 Service에서 동기 처리
 * - Controller는 요청 수신, Service 호출, 응답 구성만 담당
 */
@Slf4j
@Controller
@PreAuthorize("hasRole('MNGR')")
@RequestMapping("/manager/facility")
public class FacilityController {

    @Autowired
    private IFacilityService facilityService; // 시설 Service

    @Autowired
    private IManagerModelService managerModelService; // 관리사무소 공통 모델 Service

    @Autowired
    private IFacilityContractService facilityContractService; // ***# 설치계약 목록 조회 서비스



    /**
     * 시설 등록 화면 이동
     */
    @PreAuthorize("@authService.canMgmtCrud(principal, #mgmtOfcNo)")
    @GetMapping("/register/{mgmtOfcNo}")
    public String facilityRegisterPage(
            @PathVariable String mgmtOfcNo,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {
        /* 관리사무소 공통 화면 모델 */
        managerModelService.addManagerViewModel(model, customUser, mgmtOfcNo);

        /* 화면 API 기준 관리사무소 번호 */
        model.addAttribute("mgmtOfcNo", mgmtOfcNo);

        /* 시설 위치 선택용 동 목록 */
        model.addAttribute("dongList", facilityService.selectDongList(mgmtOfcNo));

        /* 등록 화면 편의시설 유형 목록 */
        model.addAttribute("publicFacilityTypeList", facilityService.selectPublicFacilityTypeList());

        /* ***# 연결 가능 설치계약 목록 모델 */
        model.addAttribute("installContractList", facilityContractService.selectAvailableInstallContractList(mgmtOfcNo));

        /* 시설자산 등록 JSP */
        return "apt/mgmtOffice/facility/mngr_facility_register";
    }

    /**
     * 시설 수정 화면 이동
     */
    @PreAuthorize("@authService.canMgmtCrud(principal, #mgmtOfcNo)")
    @GetMapping("/update-page/{mgmtOfcNo}/{facilityNo}")
    public String facilityUpdatePage(
            @PathVariable String mgmtOfcNo,
            @PathVariable String facilityNo,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {
        /* 관리사무소 공통 화면 모델 */
        managerModelService.addManagerViewModel(model, customUser, mgmtOfcNo);

        /* 화면 API 기준 관리사무소 번호 */
        model.addAttribute("mgmtOfcNo", mgmtOfcNo);

        /* 수정 대상 시설번호 */
        model.addAttribute("facilityNo", facilityNo);

        /* 시설 위치 선택용 동 목록 */
        model.addAttribute("dongList", facilityService.selectDongList(mgmtOfcNo));

        /* 시설자산 수정 JSP */
        return "apt/mgmtOffice/facility/mngr_facility_update";
    }

    /**
     * 시설 상세 화면 이동
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/detail-page/{mgmtOfcNo}/{facilityNo}")
    public String facilityDetailPage(
            @PathVariable String mgmtOfcNo,
            @PathVariable String facilityNo,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {
        /* 관리사무소 공통 화면 모델 */
        managerModelService.addManagerViewModel(model, customUser, mgmtOfcNo);

        /* 화면 API 기준 관리사무소 번호 */
        model.addAttribute("mgmtOfcNo", mgmtOfcNo);

        /* 상세 조회 대상 시설번호 */
        model.addAttribute("facilityNo", facilityNo);

        /* 시설자산 상세 JSP */
        return "apt/mgmtOffice/facility/mngr_facility_detail";
    }

    /**
     * 시설 목록 조회
     * - 시설자산 목록 그리드 데이터 조회
     * - publicFacilityYn : 운영관리 등록 여부 필터(Y/N)
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/list/{mgmtOfcNo}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> selectFacilityList(
            @PathVariable String mgmtOfcNo,
            @RequestParam(required = false, defaultValue = "ALL") String facilityKind,
            @RequestParam(required = false, defaultValue = "") String keyword,
            @RequestParam(required = false, defaultValue = "") String facilityTyCd,
            @RequestParam(required = false, defaultValue = "") String publicFacilityYn,
            @RequestParam(required = false, defaultValue = "") String useYn,
            @RequestParam(required = false, defaultValue = "") String restrictYn,
            @RequestParam(required = false, defaultValue = "") String dongNo,
            @RequestParam(required = false, defaultValue = "") String instlStartDt,
            @RequestParam(required = false, defaultValue = "") String instlEndDt
    ) {
        /* JSON 응답 Map */
        Map<String, Object> result = new HashMap<>();

        try {
            /* 검색 조건 Map */
            Map<String, Object> paramMap = new HashMap<>();
            paramMap.put("mgmtOfcNo", mgmtOfcNo);
            paramMap.put("facilityKind", facilityKind);
            paramMap.put("keyword", keyword);
            paramMap.put("facilityTyCd", facilityTyCd);
            paramMap.put("publicFacilityYn", publicFacilityYn); // 운영관리 등록 여부
            paramMap.put("useYn", useYn);                       // 시설 기본 활성여부
            paramMap.put("restrictYn", restrictYn);             // 현재 점검 이용제한 여부
            paramMap.put("dongNo", dongNo);
            paramMap.put("instlStartDt", instlStartDt);
            paramMap.put("instlEndDt", instlEndDt);

            /* 시설 목록 조회 */
            List<FacilityDTO> list = facilityService.selectFacilityViewList(paramMap);

            /* 성공 응답 구성 */
            result.put("success", true);
            result.put("list", list);
        } catch (Exception e) {
            /* 시설 목록 조회 오류 로그 */
            log.error("시설 목록 조회 오류", e);

            /* 실패 응답 구성 */
            result.put("success", false);
            result.put("message", "시설 목록 조회 중 오류가 발생했습니다.");
            result.put("list", new ArrayList<>());
        }

        /* JSON 응답 반환 */
        return ResponseEntity.ok(result);
    }

    /**
     * 시설 목록 건수 조회
     * - 시설자산 목록 검색 조건과 동일한 조건으로 건수 조회
     * - publicFacilityYn : 운영관리 등록 여부 필터(Y/N)
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/count/{mgmtOfcNo}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> selectFacilityCount(
            @PathVariable String mgmtOfcNo,
            @RequestParam(required = false, defaultValue = "ALL") String facilityKind,
            @RequestParam(required = false, defaultValue = "") String keyword,
            @RequestParam(required = false, defaultValue = "") String facilityTyCd,
            @RequestParam(required = false, defaultValue = "") String publicFacilityYn,
            @RequestParam(required = false, defaultValue = "") String useYn,
            @RequestParam(required = false, defaultValue = "") String restrictYn,
            @RequestParam(required = false, defaultValue = "") String dongNo,
            @RequestParam(required = false, defaultValue = "") String instlStartDt,
            @RequestParam(required = false, defaultValue = "") String instlEndDt
    ) {
        /* JSON 응답 Map */
        Map<String, Object> result = new HashMap<>();

        try {
            /* 검색 조건 Map */
            Map<String, Object> paramMap = new HashMap<>();
            paramMap.put("mgmtOfcNo", mgmtOfcNo);
            paramMap.put("facilityKind", facilityKind);
            paramMap.put("keyword", keyword);
            paramMap.put("facilityTyCd", facilityTyCd);
            paramMap.put("publicFacilityYn", publicFacilityYn); // 운영관리 등록 여부
            paramMap.put("useYn", useYn);                       // 시설 기본 활성여부
            paramMap.put("restrictYn", restrictYn);             // 현재 점검 이용제한 여부
            paramMap.put("dongNo", dongNo);
            paramMap.put("instlStartDt", instlStartDt);
            paramMap.put("instlEndDt", instlEndDt);

            /* 시설 목록 건수 조회 */
            int count = facilityService.selectFacilityViewCount(paramMap);

            /* 성공 응답 구성 */
            result.put("success", true);
            result.put("count", count);
        } catch (Exception e) {
            /* 시설 목록 건수 조회 오류 로그 */
            log.error("시설 목록 건수 조회 오류", e);

            /* 실패 응답 구성 */
            result.put("success", false);
            result.put("message", "시설 목록 건수 조회 중 오류가 발생했습니다.");
            result.put("count", 0);
        }

        /* JSON 응답 반환 */
        return ResponseEntity.ok(result);
    }

    /**
     * 시설 상세 조회
     *
     * 처리 범위
     * - 시설 기본 상세 조회
     * - 시설 사진 목록 조회
     * - 설치계약 요약 조회
     * - 최근 점검·보수 이력 조회
     * - 상세/수정 화면 공통 응답 구성
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/detail/{mgmtOfcNo}/{facilityNo}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> selectFacilityDetail(
            @PathVariable String mgmtOfcNo,
            @PathVariable String facilityNo
    ) {
        /* JSON 응답 Map */
        Map<String, Object> result = new HashMap<>();

        try {
            /*
             * 시설 상세 조회
             * - FACILITY 기준 기본정보
             * - PUBLIC_FACILITY 연결 정보가 있으면 함께 조회
             */
            FacilityDTO detail = facilityService.selectFacilityViewDetail(mgmtOfcNo, facilityNo);

            /*
             * 시설 사진 목록 조회
             * - 상세 정보가 없거나 fileGroupNo가 없으면 Service에서 빈 목록 반환
             */
            List<AttachFileVO> fileList = facilityService.selectFacilityFileList(
                    detail != null ? detail.getFileGroupNo() : null
            );

            /*
             * 설치계약 요약 조회
             * - 설치/공사 계약으로 연결된 계약이 있으면 Map으로 반환
             * - 없으면 null 반환
             * - 수정/상세 JSP에서 같은 값 사용
             */
            Map<String, Object> installContract = facilityService.selectFacilityInstallContract(
                    mgmtOfcNo,
                    facilityNo
            );

            /*
             * 최근 점검·보수 이력 조회
             * - 시설 상세 왼쪽 하단에 최근 3건 표시
             * - FACILITY_CHECK_HSTRY 기준 조회
             */
            List<FacilityCheckHstryVO> recentHistoryList = facilityService.selectRecentCheckHistoryList(
                    mgmtOfcNo,
                    facilityNo
            );

            /* 성공 응답 구성 */
            result.put("success", true);
            result.put("detail", detail);
            result.put("fileList", fileList);

            /*
             * 계약 연결 정보
             * - 기존 latestContract 키는 JSP 호환용으로 유지
             * - installContract 키는 설치계약 의미를 명확히 하기 위해 추가
             */
            result.put("latestContract", installContract);
            result.put("installContract", installContract);

            /*
             * 최근 점검·보수 이력
             * - recentHistoryList : 상세 JSP 왼쪽 하단 최근 이력 영역에서 사용
             * - recentCheckList   : 기존 JSP 호환용
             */
            result.put("recentHistoryList", recentHistoryList);
            result.put("recentCheckList", recentHistoryList);

            /*
             * 아직 별도 구현 전인 검침 연결 정보
             * - 기존 JSP 호환을 위해 null 유지
             */
            result.put("meterInfo", null);

        } catch (Exception e) {
            /* 시설 상세 조회 오류 로그 */
            log.error("시설 상세 조회 오류", e);

            /* 실패 응답 구성 */
            result.put("success", false);
            result.put("message", "시설 상세 조회 중 오류가 발생했습니다.");
            result.put("detail", null);
            result.put("fileList", new ArrayList<>());
            result.put("latestContract", null);
            result.put("installContract", null);
            result.put("recentHistoryList", new ArrayList<>());
            result.put("recentCheckList", new ArrayList<>());
            result.put("meterInfo", null);
        }

        /* JSON 응답 반환 */
        return ResponseEntity.ok(result);
    }

    /**
     * 시설 등록
     *
     * 처리 범위
     * - 기존 시설유형 선택 등록
     * - 새 시설유형 추가 등록 준비
     * - 설치계약 연결 여부 값 수신
     * - 시설 사진 업로드 요청 전달
     *
     * 주의
     * - 새 시설유형 COMMON_CODE insert 실제 처리는 ServiceImpl에서 수행
     * - 설치계약 연결 실제 처리는 ServiceImpl 또는 계약 Service에서 수행
     */
    @PreAuthorize("@authService.canMgmtCrud(principal, #mgmtOfcNo)")
    @PostMapping("/insert/{mgmtOfcNo}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> insertFacility(
            @PathVariable String mgmtOfcNo,

            // 시설 기본정보
            @ModelAttribute FacilityVO facilityVO,

            // 새 시설유형 처리용 값
            @RequestParam(required = false, defaultValue = "EXISTING") String facilityTyMode,
            @RequestParam(required = false, defaultValue = "") String newFacilityTyNm,
            @RequestParam(required = false, defaultValue = "") String newFacilityTyCn,

            // 설치계약 연결 처리용 값
            @RequestParam(required = false, defaultValue = "N") String installContractYn,
            @RequestParam(required = false, defaultValue = "") String installContractNo,

            // multipart/form-data의 동일 name 다중 파일
            @RequestParam(required = false) MultipartFile[] facilityFiles,

            // 로그인 사용자
            @AuthenticationPrincipal CustomUser customUser
    ) {
        /* JSON 응답 Map */
        Map<String, Object> result = new HashMap<>();

        try {
            /* 로그인 사용자 번호 */
            String userNo = customUser.getMember().getUserNo();

            /*
             * 새 시설유형 입력값 기본 정리
             * - 화면에서 공백이 넘어와도 Service에서 분기하기 쉽게 trim 처리
             */
            facilityTyMode = facilityTyMode == null ? "EXISTING" : facilityTyMode.trim();
            newFacilityTyNm = newFacilityTyNm == null ? "" : newFacilityTyNm.trim();
            newFacilityTyCn = newFacilityTyCn == null ? "" : newFacilityTyCn.trim();

            /*
             * 설치계약 입력값 기본 정리
             * - Y가 아니면 N으로 간주
             * - 계약번호는 공백 제거
             */
            installContractYn = "Y".equals(installContractYn) ? "Y" : "N";
            installContractNo = installContractNo == null ? "" : installContractNo.trim();

            /*
             * Controller 1차 검증
             * - 새 시설유형 모드인데 유형명이 없으면 저장 불가
             * - 상세 중복/코드 생성 검증은 Service에서 처리
             */
            if ("NEW".equals(facilityTyMode) && newFacilityTyNm.isBlank()) {
                result.put("success", false);
                result.put("message", "새 시설유형명을 입력하세요.");
                return ResponseEntity.ok(result);
            }

            /*
             * Controller 1차 검증
             * - 기존 시설유형 모드인데 facilityTyCd가 없으면 저장 불가
             */
            if (!"NEW".equals(facilityTyMode)
                    && (facilityVO.getFacilityTyCd() == null || facilityVO.getFacilityTyCd().isBlank())) {
                result.put("success", false);
                result.put("message", "시설유형을 선택하세요.");
                return ResponseEntity.ok(result);
            }

            /*
             * Controller 1차 검증
             * - 설치계약 있음 선택 시 계약번호가 없으면 저장 불가
             * - 실제 계약 존재 여부/연결 가능 여부는 Service 또는 계약 Mapper에서 검증
             */
            if ("Y".equals(installContractYn) && installContractNo.isBlank()) {
                result.put("success", false);
                result.put("message", "설치계약이 있는 경우 설치계약을 선택하세요.");
                return ResponseEntity.ok(result);
            }

            /*
             * 시설 등록 처리
             * - 기존 시설 등록 흐름에 새 시설유형/설치계약 값을 추가 전달
             * - ServiceImpl에서 facilityTyMode가 NEW이면 COMMON_CODE 등록 후 facilityTyCd 세팅
             */
            boolean success = facilityService.insertFacility(
                    mgmtOfcNo,
                    facilityVO,
                    facilityFiles,
                    userNo,
                    facilityTyMode,
                    newFacilityTyNm,
                    newFacilityTyCn,
                    installContractYn,
                    installContractNo
            );

            /* 성공 응답 구성 */
            result.put("success", success);
            result.put("facilityNo", facilityVO.getFacilityNo());
            result.put("message", success ? "시설이 등록되었습니다." : "시설 등록에 실패했습니다.");

        } catch (Exception e) {
            /* 시설 등록 오류 로그 */
            log.error("시설 등록 오류", e);

            /* 실패 응답 구성 */
            result.put("success", false);
            result.put("message", "시설 등록 중 오류가 발생했습니다.");
        }

        /* JSON 응답 반환 */
        return ResponseEntity.ok(result);
    }

    /**
     * 시설 수정
     */
    @PreAuthorize("@authService.canMgmtCrud(principal, #mgmtOfcNo)")
    @PostMapping("/update/{mgmtOfcNo}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> updateFacility(
            @PathVariable String mgmtOfcNo,
            @ModelAttribute FacilityVO facilityVO,
            //** 수정: multipart/form-data의 동일 name 다중 파일을 안정적으로 받기 위해 RequestParam 사용
            @RequestParam(required = false) MultipartFile[] facilityFiles,
            @RequestParam(required = false, defaultValue = "") String deleteFileUuids,
            @AuthenticationPrincipal CustomUser customUser
    ) {
        /* JSON 응답 Map */
        Map<String, Object> result = new HashMap<>();

        try {
            /* 로그인 사용자 번호 */
            String userNo = customUser.getMember().getUserNo();

            /* 시설 기본정보 수정 + 사진 추가/삭제 동기 처리 */
            boolean success = facilityService.updateFacility(
                    mgmtOfcNo,
                    facilityVO,
                    facilityFiles,
                    deleteFileUuids,
                    userNo
            );

            /* 성공 응답 구성 */
            result.put("success", success);
            result.put("facilityNo", facilityVO.getFacilityNo());
            result.put("message", success ? "시설이 수정되었습니다." : "시설 수정에 실패했습니다.");
        } catch (Exception e) {
            /* 시설 수정 오류 로그 */
            log.error("시설 수정 오류", e);

            /* 실패 응답 구성 */
            result.put("success", false);
            result.put("message", "시설 수정 중 오류가 발생했습니다.");
        }

        /* JSON 응답 반환 */
        return ResponseEntity.ok(result);
    }

    /**
     * 시설유형 정정 가능 여부 조회
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/type/correct/check/{mgmtOfcNo}/{facilityNo}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> checkFacilityTypeCorrection(
            @PathVariable String mgmtOfcNo,
            @PathVariable String facilityNo
    ) {
        /* JSON 응답 Map */
        Map<String, Object> result = new HashMap<>();

        try {
            /* 정정 가능 여부 조회용 VO */
            FacilityVO facilityVO = new FacilityVO();
            facilityVO.setFacilityNo(facilityNo);

            /* 시설유형 정정 가능 여부 */
            boolean correctable = facilityService.checkFacilityTypeCorrection(mgmtOfcNo, facilityVO);

            /* 성공 응답 구성 */
            result.put("success", correctable);
            result.put(
                    "message",
                    correctable
                            ? "정정 가능한 시설입니다. 변경할 시설유형을 선택하고 저장하세요."
                            : "계약·점검·검침 데이터가 연결된 시설은 시설유형을 변경할 수 없습니다."
            );
        } catch (Exception e) {
            /* 시설유형 정정 가능 여부 조회 오류 로그 */
            log.error("시설유형 정정 가능 여부 조회 오류", e);

            /* 실패 응답 구성 */
            result.put("success", false);
            result.put("message", "시설유형 정정 가능 여부 확인 중 오류가 발생했습니다.");
        }

        /* JSON 응답 반환 */
        return ResponseEntity.ok(result);
    }

    /**
     * 시설유형 정정
     */
    @PreAuthorize("@authService.canMgmtCrud(principal, #mgmtOfcNo)")
    @PostMapping("/type/correct/{mgmtOfcNo}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> correctFacilityType(
            @PathVariable String mgmtOfcNo,
            @RequestBody FacilityVO facilityVO
    ) {
        /* JSON 응답 Map */
        Map<String, Object> result = new HashMap<>();

        try {
            /* 시설유형 정정 처리 */
            boolean success = facilityService.correctFacilityType(mgmtOfcNo, facilityVO);

            /* 성공 응답 구성 */
            result.put("success", success);
            result.put(
                    "message",
                    success
                            ? "시설 분류가 정정되었습니다."
                            : "연결된 계약/검침/점검 정보가 있어 분류를 변경할 수 없습니다."
            );
        } catch (Exception e) {
            /* 시설유형 정정 오류 로그 */
            log.error("시설 분류 정정 오류", e);

            /* 실패 응답 구성 */
            result.put("success", false);
            result.put("message", "시설 분류 정정 중 오류가 발생했습니다.");
        }

        /* JSON 응답 반환 */
        return ResponseEntity.ok(result);
    }

    /**
     * 시설 사용여부 변경
     */
    @PreAuthorize("@authService.canMgmtCrud(principal, #mgmtOfcNo)")
    @PostMapping("/use/update/{mgmtOfcNo}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> updateFacilityUseYn(
            @PathVariable String mgmtOfcNo,
            @RequestBody FacilityVO facilityVO
    ) {
        /* JSON 응답 Map */
        Map<String, Object> result = new HashMap<>();

        try {
            /* 시설 사용여부 변경 처리 */
            boolean success = facilityService.updateFacilityUseYn(mgmtOfcNo, facilityVO);

            /* 성공 응답 구성 */
            result.put("success", success);
            result.put("message", success ? "시설 사용여부가 변경되었습니다." : "시설 사용여부 변경에 실패했습니다.");
        } catch (Exception e) {
            /* 시설 사용여부 변경 오류 로그 */
            log.error("시설 사용여부 변경 오류", e);

            /* 실패 응답 구성 */
            result.put("success", false);
            result.put("message", "시설 사용여부 변경 중 오류가 발생했습니다.");
        }

        /* JSON 응답 반환 */
        return ResponseEntity.ok(result);
    }

    /**
     * 시설 사진 삭제
     */
    @PreAuthorize("@authService.canMgmtCrud(principal, #mgmtOfcNo)")
    @PostMapping("/file/delete/{mgmtOfcNo}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> deleteFacilityFile(
            @PathVariable String mgmtOfcNo,
            @RequestBody Map<String, Object> param
    ) {
        /* JSON 응답 Map */
        Map<String, Object> result = new HashMap<>();

        try {
            /* 관리사무소 번호 추가 */
            param.put("mgmtOfcNo", mgmtOfcNo);

            /* 시설 사진 삭제 처리 */
            boolean success = facilityService.deleteFacilityFile(param);

            /* 성공 응답 구성 */
            result.put("success", success);
            result.put("message", success ? "시설 사진이 삭제되었습니다." : "시설 사진 삭제에 실패했습니다.");
        } catch (Exception e) {
            /* 시설 사진 삭제 오류 로그 */
            log.error("시설 사진 삭제 오류", e);

            /* 실패 응답 구성 */
            result.put("success", false);
            result.put("message", "시설 사진 삭제 중 오류가 발생했습니다.");
        }

        /* JSON 응답 반환 */
        return ResponseEntity.ok(result);
    }

    /**
     * 시설 동 목록 조회
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/dong/list/{mgmtOfcNo}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> selectDongList(
            @PathVariable String mgmtOfcNo
    ) {
        /* JSON 응답 Map */
        Map<String, Object> result = new HashMap<>();

        try {
            /* 동 목록 조회 */
            List<FacilityVO> list = facilityService.selectDongList(mgmtOfcNo);

            /* 성공 응답 구성 */
            result.put("success", true);
            result.put("list", list);
        } catch (Exception e) {
            /* 시설 동 목록 조회 오류 로그 */
            log.error("시설 동 목록 조회 오류", e);

            /* 실패 응답 구성 */
            result.put("success", false);
            result.put("message", "시설 동 목록 조회 중 오류가 발생했습니다.");
            result.put("list", new ArrayList<>());
        }

        /* JSON 응답 반환 */
        return ResponseEntity.ok(result);
    }

    /**
     * 위치 동 목록 조회
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/location/units/{mgmtOfcNo}")
    @ResponseBody
    public List<FacilityLocationDTO> selectFacilityUnitList(
            @PathVariable String mgmtOfcNo
    ) {
        /* 시설 위치 동 목록 반환 */
        return facilityService.selectFacilityUnitList(mgmtOfcNo);
    }

    /**
     * 위치 층 목록 조회
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/location/floors/{mgmtOfcNo}")
    @ResponseBody
    public List<FacilityLocationDTO> selectFacilityFloorList(
            @PathVariable String mgmtOfcNo,
            @RequestParam String dongNo
    ) {
        /* 시설 위치 층 목록 반환 */
        return facilityService.selectFacilityFloorList(dongNo);
    }

    /**
     * 위치 호 목록 조회
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/location/rooms/{mgmtOfcNo}")
    @ResponseBody
    public List<FacilityLocationDTO> selectFacilityRoomList(
            @PathVariable String mgmtOfcNo,
            @RequestParam String dongNo,
            @RequestParam String floor
    ) {
        /* 시설 위치 호 목록 반환 */
        return facilityService.selectFacilityRoomList(dongNo, floor);
    }

    /**
     * 시설유형 필터 목록 조회
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/type/list/{mgmtOfcNo}")
    @ResponseBody
    public Map<String, Object> selectFacilityTypeList(
            @PathVariable String mgmtOfcNo,
            @RequestParam(defaultValue = "ALL") String facilityKind
    ) {
        /* 시설유형 조회 조건 Map */
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("mgmtOfcNo", mgmtOfcNo);
        paramMap.put("facilityKind", facilityKind);

        /* 시설유형 목록 조회 */
        List<Map<String, Object>> typeList = facilityService.selectFacilityTypeList(paramMap);

        /* JSON 응답 Map */
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("typeList", typeList);

        /* JSON 응답 반환 */
        return result;
    }
}
