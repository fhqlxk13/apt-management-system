package kr.or.ddit.domain.central.controller;

import kr.or.ddit.common.file.mapper.IAttachFileMapper;
import kr.or.ddit.common.file.vo.AttachFileVO;
import kr.or.ddit.domain.central.admin.dto.AnnouncementDTO;
import kr.or.ddit.domain.central.admin.service.IAnnouncementService;
import kr.or.ddit.domain.central.service.IContractUserService;
import kr.or.ddit.domain.member.vo.CustomUser;
import kr.or.ddit.domain.member.vo.MemberVO;
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

@Slf4j
@Controller
@RequestMapping("/contract")
public class ContractUserController {

    @Autowired
    private IContractUserService contractUserService;

    @Autowired
    private IAnnouncementService announcementService;

    @Autowired
    private IAttachFileMapper iAttachFileMapper;

    @GetMapping("/list.do")
    public String contractList() {
        return "central/contract/contractList";
    }

    @GetMapping("/apply.do")
    public String contractApply() {
        return "central/contract/contractApply";
    }

    /**
     * 공고 목록 페이지를 반환하는 컨트롤러 메소드
     * searchVO 검색 조건을 담은 DTO (페이지, 키워드)
     * 공고 목록 JSP 경로 (central/contract/contractNotice)
     */

    @GetMapping("/notice.do")
    public String contractNoticeList(AnnouncementDTO searchVO, Model model) {

        // 검색 조건에 맞는 공고 목록 조회
        List<AnnouncementDTO> list = announcementService.selectAnnouncementList(searchVO);

        // 목록이 비어있지 않을 경우 첫 번째 항목의 아파트 단지 번호를 로그 출력
        if (!list.isEmpty()) {
            log.info("첫번째 aptCmplexNo: {}", list.get(0).getAptCmplexNo());
        }

        model.addAttribute("list", list);
        return "central/contract/contractNotice";
    }

    /**
     * 공고 목록을 JSON 형태로 반환하는 메소드
     * MEMBER 권한을 가진 사용자만 접근 가능
     * Ajax 요청 비동기 처리에 사용
     *
     * searchVO 검색 조건을 담은 DTO
     * 공고 목록 (List<AnnouncementDTO>) - JSON 자동 직렬화
     */
    @PreAuthorize("hasRole('MEMBER')")
    @GetMapping("/notice.json")
    @ResponseBody
    public List<AnnouncementDTO> contractNoticeListJson(AnnouncementDTO searchVO) {
        return announcementService.selectAnnouncementList(searchVO);
    }

    /**
     * 청약 신청을 처리하는 메소드
     * MEMBER 권한을 가진 사용자만 접근 가능
     * 로그인된 사용자의 userNo를 params에 추가하여 신청 데이터 저장
     *
     * params 요청 바디 (계약 신청에 필요한 파라미터 Map)
     * principal 현재 로그인한 사용자 정보
     * 처리 결과 Map {"success": true} 또는 {"success": false, "message": "에러메시지"}
     */

    @PreAuthorize("hasRole('MEMBER')")
    @ResponseBody
    @PostMapping("/request.do")
    public Map<String, Object> contractRequest(@RequestBody Map<String, Object> params,
                                               @AuthenticationPrincipal CustomUser principal) {
        Map<String, Object> result = new HashMap<>();

        try {
            // 현재 로그인한 사용자의 userNo를 파라미터에 추가
            params.put("userNo", principal.getMember().getUserNo());

            // 청약 신청 DB 삽입 처리
            contractUserService.insertAplct(params);
            result.put("success", true);
        } catch (Exception e) {

            // 예외 발생 시 에러 로그 출력 및 실패 결과 반환
            log.error("계약 신청 오류: {}", e.getMessage());
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }

    /**
     * 공고 상세 페이지를 반환하는 메소드
     * MEMBER 권한을 가진 사용자만 접근 가능
     * 조회수 증가, 공고 상세 정보, 전용면적 정보, 첨부파일 목록을 JSP에 전달
     *
     * annNo 조회할 공고 번호
     * principal 현재 로그인한 사용자 정보
     * 공고 상세 JSP 경로 (central/contract/contractNoticeDetail)
     */
    @GetMapping("/detail.do")
    public String contractDetail(
            @RequestParam("annNo") String annNo,
            @AuthenticationPrincipal CustomUser principal,
            Model model) {

        // 해당 공고의 조회수 1증가
        contractUserService.updateInqCnt(annNo);

        // 공고번호로 공고 상세 조회
        AnnouncementDTO announcement = announcementService.selectAnnouncement(annNo);

        // 해당 공고에 포함된 매물 기준으로 전용면적 상세 조회
        List<Map<String, Object>> exclusiveSize = contractUserService.selectExcluseAreaDetail(
                annNo,
                announcement.getAptCmplexNo()
        );

        // 첨부파일 아이디가 존재할 경우 파일 목록 조회 후 모델에 담기
        if (announcement.getAtchFileId() != null) {
            List<AttachFileVO> fileList = iAttachFileMapper.selecAttachFileList(announcement.getAtchFileId());
            model.addAttribute("fileList", fileList);
        }

        log.info("aptCmplexNo: {}", announcement.getAptCmplexNo());
        log.info("exclusiveSize: {}", exclusiveSize);

        // JSP에 공고 상세, 전용면적, 사용자 정보 전달
        model.addAttribute("announcement", announcement);
        model.addAttribute("exclusiveSize", exclusiveSize);
        model.addAttribute("principal", principal);
        return "central/contract/contractNoticeDetail";
    }

    /**
     * 현재 로그인한 사용자의 청약 신청 내역 목록 페이지를 반환하는 메소드
     * MEMBER 권한을 가진 사용자만 접근 가능
     *
     * principal 현재 로그인한 사용자 정보
     * 신청 내역 목록 JSP 경로 (central/contract/contractAList)
     */
    @PreAuthorize("hasRole('MEMBER')")
    @GetMapping("/history.do")
    public String contractHistory(
            @AuthenticationPrincipal CustomUser principal,
            Model model) {

        // 현재 로그인 한 사용자의 userNo 추출
        String userNo = principal.getMember().getUserNo();

        // userNo를 기반으로 해당 사용자의 청약 신청 목록 조회
        List<Map<String, Object>> list = contractUserService.selectAplctList(userNo);
        log.info("aplctList: {}", list);
        model.addAttribute("list", list);
        return "central/contract/contractAList";
    }

    /**
     * 청약 신청을 취소하는 메소드
     * MEMBER 권한을 가진 사용자만 접근 가능
     *
     * params 요청 바디 (취소할 신청 번호 "aplctNo" 포함)
     * 처리 결과 Map {"success": true}
     */
    @PreAuthorize("hasRole('MEMBER')")
    @PutMapping("/cancel.do")
    @ResponseBody
    public Map<String, Object> cancelContract(@RequestBody Map<String, Object> params) {

        // 신청번호(aplctNo)로 해당 청약 신청 취소
        contractUserService.cancelContract((String) params.get("aplctNo"));
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        return result;
    }

    /**
     * 청약 신청 목록 상세 페이지를 반환하는 메소드
     * 신청 번호로 상세 정보 및 제출 서류 목록을 조회하여 JSP에 전달
     *
     * aplctNo 조회할 신청 번호
     * principal 현재 로그인한 사용자 정보
     * 신청 내역 상세 JSP 경로 (central/contract/contractADetail)
     */
    @GetMapping("/historyDetail.do")
    public String contractHistoryDetail(@RequestParam String aplctNo,
                                        @AuthenticationPrincipal CustomUser principal,
                                        Model model) {

        // 현재 로그인 한 사용자의 userNo 추출
        String userNo = principal.getMember().getUserNo();
        MemberVO memberVO = principal.getMember();

        // 현재 로그인 한 사용자의 userNo 추출
        Map<String, Object> detail = contractUserService.selectOneContractHistoryDetail(aplctNo);
        //List<Map<String, Object>> docList = contractUserService.selectSbmsnDocList(aplctNo);

        // 신청 번호로 제출 서류 목록 조회
        List<Map<String, Object>> docList = contractUserService.selectAplctDocList(aplctNo);

        log.info("detail: {}", detail);
        log.info("docList: {}", docList);

        // JSP에 회원 정보, 상세 정보, 서류 목록, 신청 번호, 사용자 번호 전달
        model.addAttribute("memberVO", memberVO);
        model.addAttribute("detail", detail);
        model.addAttribute("docList", docList);
        model.addAttribute("aplctNo", aplctNo);
        model.addAttribute("userNo", userNo);
        return "central/contract/contractADetail";
    }

    /**
    * 계약 서류를 업로드하는 메소드
    * MEMBER 권한을 가진 사용자만 접근 가능
    * 멀티파트 파일을 받아 서류 종류 공통 코드와 함께 저장
    * 현재 제출서류 업로드 로직 수정중
    */
    /*@PreAuthorize("hasRole('MEMBER')")
    @PostMapping("/insertContractDoc.do")
    @ResponseBody
    public Map<String, Object> insertContractDoc(
            @RequestParam List<MultipartFile> files,
            @RequestParam List<String> sbmsnDocTyCds,
            @RequestParam String aplctNo,
            @AuthenticationPrincipal CustomUser principal) {


        Map<String, Object> result = new HashMap<>();
        try {
            String userNo = principal.getMember().getUserNo();
            for (int i = 0; i < files.size(); i++) {
                contractUserService.insertContractDoc(files.get(i), sbmsnDocTyCds.get(i), aplctNo, userNo);
            }
            result.put("success", true);
        } catch (Exception e) {
            log.error("서류 업로드 오류: {}", e.getMessage());
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }*/


    /**
     * 계약 서류를 업로드하는 메소드
     *
     * 사용자가 선택한 파일 목록과 각 파일의 카테고리 정보를 받아
     * 해당 신청 건에 대한 계약 서류를 저장합니다.
     * 처리 결과는 success 여부와 함께 JSON 형태로 반환됩니다.
     *
     * files    업로드할 파일 목록 (MultipartFile 리스트)
     * cat      각 파일에 대응하는 서류 카테고리 목록
     * aplctNo  서류를 등록할 신청 번호
     * principal 현재 로그인한 사용자 정보 (사용자 번호 추출에 사용)
     * 처리 결과 Map ("success": true/false, 실패 시 "message": 오류 내용)
     * 바로 위에 있는 메소드 대신 이 메소드 사용할 것
     */
    @PostMapping("/insertContractDoc.do")
    @ResponseBody
    public Map<String, Object> insertContractDoc(
            @RequestParam List<MultipartFile> files,
            @RequestParam List<String> cat,
            @RequestParam String aplctNo,
            @AuthenticationPrincipal CustomUser principal) {

        Map<String, Object> result = new HashMap<>();
        try {
            String userNo = principal.getMember().getUserNo();
            contractUserService.insertContractDoc(files, cat, aplctNo, userNo);
            result.put("success", true);
        } catch (Exception e) {
            log.error("서류 업로드 오류: {}", e.getMessage());
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }
}