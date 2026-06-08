package kr.or.ddit.domain.central.admin.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import kr.or.ddit.domain.central.admin.dto.AnnouncementDTO;
import kr.or.ddit.domain.central.admin.service.IAnnouncementService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.multipart.MultipartFile;

/**
 * 중앙관리자 공고 관리 Controller
 *
 * Controller란?
 * → 브라우저 요청을 받아서 JSP 화면 또는 JSON 데이터를 응답하는 클래스.
 */
@Controller
@RequiredArgsConstructor
@RequestMapping("/centralAdmin/announcement")
@PreAuthorize("hasRole('ADMIN')")  /* 중앙관리자만 허용 */
public class AnnouncementController {

    private final IAnnouncementService announcementService;

    /**
     * 공고 관리 JSP 화면 이동
     */
    @GetMapping
    public String announcementPage() {
        return "centralAdmin/announcement";
    }

    /**
     * 공고 목록 조회 API
     */
    @ResponseBody
    @GetMapping("/list")
    public ResponseEntity<?> list(AnnouncementDTO searchVO) {
        return ResponseEntity.ok(announcementService.selectAnnouncementList(searchVO));
    }

    /**
     * 공고 수정 API
     */
    @PutMapping("/{annNo}")
    @ResponseBody
    public ResponseEntity<?> update(
            @PathVariable String annNo,
            @RequestPart("data") AnnouncementDTO announcementDTO,
            @RequestPart(value = "file", required = false) MultipartFile file
    ) {
        announcementDTO.setAnnNo(annNo);

        int result = announcementService.updateAnnouncement(
                announcementDTO,
                file
        );

        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("success", result > 0);

        return ResponseEntity.ok(resultMap);
    }

    /**
     * 공고 상세 조회 API
     */
    @ResponseBody
    @GetMapping("/{annNo}")
    public ResponseEntity<?> detail(@PathVariable String annNo) {
        return ResponseEntity.ok(announcementService.selectAnnouncement(annNo));
    }

    /**
     * 공고 등록 API
     */
    @PostMapping
    @ResponseBody
    public ResponseEntity<?> insert(
            @RequestPart("data") AnnouncementDTO announcementDTO,
            @RequestPart(value = "file", required = false) MultipartFile file
    ) {
    /*
      MultipartFile이란?
      → 브라우저에서 업로드한 파일을 Java에서 받는 객체.
      왜 사용?
      → 첨부파일 업로드 기능을 만들 때 사용한다.
    */

        announcementDTO.setWrtrId("admin");
        announcementDTO.setTopFixYn("N");
        announcementDTO.setDelYn("N");
        announcementDTO.setOpnYn("Y");

        int result = announcementService.insertAnnouncement(announcementDTO, file);

        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("success", result > 0);
        resultMap.put("annNo", announcementDTO.getAnnNo());

        return ResponseEntity.ok(resultMap);
    }

    /**
     * 공고 삭제 API
     *
     * 실제 DELETE가 아니라 DEL_YN = 'Y'로 변경한다.
     */
    @ResponseBody
    @DeleteMapping("/{annNo}")
    public ResponseEntity<?> delete(@PathVariable String annNo) {

        int result = announcementService.deleteAnnouncement(annNo);

        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("success", result > 0);

        return ResponseEntity.ok(resultMap);
    }

    /**
     * 단지 목록 조회 API
     */
    @ResponseBody
    @GetMapping("/aptComplexList")
    public List<AnnouncementDTO> aptComplexList() {
        return announcementService.selectAptComplexList();
    }


    /*
  단지 상세정보 조회

  @PathVariable이란?
  → URL 경로에 있는 값을 가져오는 기능.

  예시:
  /aptDetail/A1001
             ↑
        이 값을 가져옴
*/
    @GetMapping("/aptDetail/{aptCmplexNo}")
    @ResponseBody
    public AnnouncementDTO getAptDetail(
            @PathVariable String aptCmplexNo
    ) {

        return announcementService.selectAptDetail(aptCmplexNo);
    }


}