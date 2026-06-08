package kr.or.ddit.domain.central.admin.controller;

import kr.or.ddit.domain.central.admin.dto.AnnouncementDTO;
import kr.or.ddit.domain.central.admin.service.IAnnouncementService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * React 공고 목록·상세·삭제 (Service/Mapper는 기존 Announcement 재사용)
 */
@RestController
@RequestMapping("/api/react/adm/annList")
@Slf4j
@RequiredArgsConstructor
public class AnnListController {

    private final IAnnouncementService announcementService;

    /**
     * React 중앙관리자 공고 전체조회
     */
    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/annList")
    public List<AnnouncementDTO> annList(AnnouncementDTO searchVO) {
        return announcementService.selectAnnouncementList(searchVO);
    }

    /**
     * React 중앙관리자 단지 조회
     */
    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/aptComplexList")
    public List<AnnouncementDTO> aptComplexList() {
        return announcementService.selectAptComplexList();
    }

    /**
     * React 중앙관리자 공고 상세조회
     */
    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/{annNo}")
    public AnnouncementDTO detail(@PathVariable String annNo) {
        return announcementService.selectAnnouncement(annNo);
    }

    /**
     * React 공고 삭제
     */
    @PreAuthorize("hasRole('ADMIN')")
    @DeleteMapping("/{annNo}")
    public Map<String, Object> delete(@PathVariable String annNo) {
        Map<String, Object> result = new HashMap<>();
        result.put("success", announcementService.deleteAnnouncement(annNo) > 0);
        return result;
    }

    /**
     * React 공고 수정
     */
    @PreAuthorize("hasRole('ADMIN')")
    @PutMapping("/{annNo}")
    public Map<String, Object> update(@PathVariable String annNo, @RequestBody AnnouncementDTO dto) {
        dto.setAnnNo(annNo);
        Map<String, Object> result = new HashMap<>();
        result.put("success", announcementService.updateAnnouncement(dto, null) > 0);
        return result;
    }
}
