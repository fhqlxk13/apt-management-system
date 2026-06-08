package kr.or.ddit.domain.apt.mgmtOffice.contract.controller;

import kr.or.ddit.common.model.PaginationInfoVO;
import kr.or.ddit.domain.apt.mgmtOffice.common.service.IManagerModelService;
import kr.or.ddit.domain.apt.mgmtOffice.contract.service.IFacilityContractService;
import kr.or.ddit.domain.apt.mgmtOffice.contract.vo.FacilityContractDTO;
import kr.or.ddit.domain.apt.mgmtOffice.contract.vo.FacilityContractSearchVO;
import kr.or.ddit.domain.member.vo.CustomUser;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 시설 계약 관리 Controller
 *
 * 기준
 * - EmployeeController 패턴을 따른다.
 * - 클래스 권한: ROLE_MNGR
 * - 조회 권한: authService.hasAccess
 * - 등록/수정 권한: authService.canMgmtCrud
 * - 화면 반환 메서드: IManagerModelService.addManagerViewModel(...) 호출
 */
@Slf4j
@Controller
@PreAuthorize("hasRole('MNGR')")
@RequestMapping("/manager/facility/contract")
public class FacilityContractController {

    @Autowired
    private IFacilityContractService facilityContractService;

    @Autowired
    private IManagerModelService managerModelService;

    /**
     * 계약 목록 화면
     *
     * JSP
     * - /WEB-INF/views/apt/mgmtOffice/contract/mngr_contract_list.jsp
     *
     * 필요한 model
     * - mgmtOfcNo
     * - search
     * - contractList
     * - contractSummary
     * - manager 공통 model 값
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/list/{mgmtOfcNo}")
    public String contractList(
            @PathVariable String mgmtOfcNo,
            @ModelAttribute("search") FacilityContractSearchVO search,
            @RequestParam(value = "page", required = false, defaultValue = "1") int currentPage,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {
        // 관리사무소 화면 공통 model 값 세팅
        managerModelService.addManagerViewModel(model, customUser, mgmtOfcNo);

        // 검색 조건에 관리사무소 번호 세팅
        search.setMgmtOfcNo(mgmtOfcNo);

        // 페이지 번호 보정
        // - 잘못된 페이지 값이 들어오면 1페이지로 조회한다.
        if (currentPage < 1) {
            currentPage = 1;
        }

        // 계약 목록 페이징 정보 생성
        // - PaginationInfoVO 기본값: 한 페이지 10건, 페이지 블록 5개
        PaginationInfoVO<FacilityContractDTO> pagingVO = new PaginationInfoVO<>();

        // 검색조건 전체 기준 계약 건수 조회
        int totalRecord = facilityContractService.selectContractTotalCount(search);

        // 전체 건수 세팅
        // - totalPage 계산에 사용된다.
        pagingVO.setTotalRecord(totalRecord);

        // 현재 페이지 세팅
        // - startRow/endRow/startPage/endPage가 자동 계산된다.
        pagingVO.setCurrentPage(currentPage);

        // 현재 페이지 계약 목록 조회
        pagingVO.setDataList(facilityContractService.selectContractList(search, pagingVO));

        // 계약 현황 카드 조회
        // - 페이지 기준이 아니라 검색조건 전체 기준으로 유지한다.
        model.addAttribute("contractSummary", facilityContractService.selectContractSummary(search));

        // JSP 출력용 model
        // - contractList는 기존 JSP 구조를 최대한 유지하기 위해 함께 내려준다.
        model.addAttribute("pagingVO", pagingVO);
        model.addAttribute("contractList", pagingVO.getDataList());
        model.addAttribute("contractTypeList", facilityContractService.selectContractTypeList());
        model.addAttribute("mgmtOfcNo", mgmtOfcNo);

        return "apt/mgmtOffice/contract/mngr_contract_list";
    }

    /**
     * 계약 등록 폼 화면
     *
     * JSP
     * - /WEB-INF/views/apt/mgmtOffice/contract/mngr_contract_form.jsp
     *
     * 필요한 model
     * - mode = insert
     * - contract
     * - partnerList
     * - facilityList
     */
    @PreAuthorize("@authService.canMgmtCrud(principal, #mgmtOfcNo)")
    @GetMapping("/form/{mgmtOfcNo}")
    public String contractInsertForm(
            @PathVariable String mgmtOfcNo,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {
        // 관리사무소 화면 공통 model 값 세팅
        managerModelService.addManagerViewModel(model, customUser, mgmtOfcNo);

        // 등록 화면 기본값
        FacilityContractDTO contract = new FacilityContractDTO();
        // 계약대상 기본값
        contract.setContTargetCd("FACILITY");

        // CONTRACT_STTS 공통코드 기준 기본값
        // ACTIVE = 유효
        contract.setContSttsCd("ACTIVE");

        // 폼 공통 model
        model.addAttribute("mode", "insert");
        model.addAttribute("mgmtOfcNo", mgmtOfcNo);
        model.addAttribute("contract", contract);
        model.addAttribute("partnerList", facilityContractService.selectContractPartnerList(mgmtOfcNo));
        model.addAttribute("facilityList", facilityContractService.selectContractFacilityList(mgmtOfcNo));
        model.addAttribute("contractTypeList", facilityContractService.selectContractTypeList());

        return "apt/mgmtOffice/contract/mngr_contract_form";
    }

    /**
     * 계약 수정 폼 화면
     *
     * JSP
     * - /WEB-INF/views/apt/mgmtOffice/contract/mngr_contract_form.jsp
     */
    @PreAuthorize("@authService.canMgmtCrud(principal, #mgmtOfcNo)")
    @GetMapping("/form/{mgmtOfcNo}/{contNo}")
    public String contractUpdateForm(
            @PathVariable String mgmtOfcNo,
            @PathVariable String contNo,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {
        // 관리사무소 화면 공통 model 값 세팅
        managerModelService.addManagerViewModel(model, customUser, mgmtOfcNo);

        // 계약 상세 조회
        FacilityContractDTO contract = facilityContractService.selectContractDetail(mgmtOfcNo, contNo);

        // 폼 공통 model
        model.addAttribute("mode", "update");
        model.addAttribute("mgmtOfcNo", mgmtOfcNo);
        model.addAttribute("contract", contract);
        model.addAttribute("partnerList", facilityContractService.selectContractPartnerList(mgmtOfcNo));
        model.addAttribute("facilityList", facilityContractService.selectContractFacilityList(mgmtOfcNo));
        model.addAttribute("contractTypeList", facilityContractService.selectContractTypeList());

        return "apt/mgmtOffice/contract/mngr_contract_form";
    }

    /**
     * 계약 상세 조회
     *
     * 사용처
     * - 목록 JSP 상세 모달
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/detail/{mgmtOfcNo}/{contNo}")
    @ResponseBody
    public Map<String, Object> contractDetail(
            @PathVariable String mgmtOfcNo,
            @PathVariable String contNo
    ) {
        Map<String, Object> result = new HashMap<>();

        try {
            // 계약 상세 조회
            FacilityContractDTO contract = facilityContractService.selectContractDetail(mgmtOfcNo, contNo);

            result.put("success", true);
            result.put("contract", contract);
        } catch (Exception e) {
            log.error("계약 상세 조회 오류", e);
            result.put("success", false);
            result.put("message", "계약 상세 조회 중 오류가 발생했습니다.");
        }

        return result;
    }

    /**
     * 계약 등록 처리
     *
     * 처리 내용
     * - 계약 기본정보 저장
     * - 대상 시설 연결
     * - 계약서 첨부파일 업로드
     *
     * form enctype
     * - multipart/form-data
     */
    @PreAuthorize("@authService.canMgmtCrud(principal, #mgmtOfcNo)")
    @PostMapping("/insert/{mgmtOfcNo}")
    public String contractInsert(
            @PathVariable String mgmtOfcNo,
            @ModelAttribute FacilityContractDTO contract,
            @RequestParam(value = "contractFiles", required = false) List<MultipartFile> contractFiles,
            @AuthenticationPrincipal CustomUser customUser
    ) {
        // 관리사무소 번호 세팅
        contract.setMgmtOfcNo(mgmtOfcNo);

        // 로그인 사용자번호
        // - 계약서 파일 업로드 시 업로드 사용자/폴더 구분에 사용
        String userNo = customUser.getMember().getUserNo();

        // 계약 등록 처리
        // - 계약 기본정보 저장
        // - 대상 시설 연결
        // - 계약서 첨부파일 업로드
        facilityContractService.insertContract(contract, contractFiles, userNo);

        return "redirect:/manager/facility/contract/list/" + mgmtOfcNo + "?msg=insert";
    }

    /**
     * 계약 수정 처리
     *
     * 처리 내용
     * - 계약 기본정보 수정
     * - 대상 시설 재연결
     * - 계약서 첨부파일 추가 업로드
     * - 선택한 기존 첨부파일 삭제
     *
     * 주의
     * - ATTACH_FILE에는 FILE_NO가 없고 FILE_SAVE_UUID가 식별값이다.
     * - JSP 삭제 체크박스 name도 deleteFileSaveUuidList로 맞춘다.
     */
    @PreAuthorize("@authService.canMgmtCrud(principal, #mgmtOfcNo)")
    @PostMapping("/update/{mgmtOfcNo}")
    public String contractUpdate(
            @PathVariable String mgmtOfcNo,
            @ModelAttribute FacilityContractDTO contract,
            @RequestParam(value = "contractFiles", required = false) List<MultipartFile> contractFiles,
            @RequestParam(value = "deleteFileSaveUuidList", required = false) List<String> deleteFileSaveUuidList,
            @AuthenticationPrincipal CustomUser customUser
    ) {
        // 관리사무소 번호 세팅
        contract.setMgmtOfcNo(mgmtOfcNo);

        // 로그인 사용자번호
        // - 계약서 파일 업로드 시 업로드 사용자/폴더 구분에 사용
        String userNo = customUser.getMember().getUserNo();

        // 계약 수정 처리
        // - 계약 기본정보 수정
        // - 대상 시설 재연결
        // - 계약서 파일 추가/삭제
        facilityContractService.updateContract(contract, contractFiles, deleteFileSaveUuidList, userNo);

        return "redirect:/manager/facility/contract/list/" + mgmtOfcNo + "?msg=update";
    }
}
