package kr.or.ddit.domain.central.admin.service;

import java.util.List;

import kr.or.ddit.domain.central.admin.dto.AnnouncementDTO;
import org.springframework.web.multipart.MultipartFile;

/**
 * 공고 관리 Service 인터페이스
 *
 * Interface란?
 * → Service가 반드시 구현해야 할 메소드 목록을 정해두는 설계도.
 */
public interface IAnnouncementService {

    List<AnnouncementDTO> selectAnnouncementList(AnnouncementDTO searchVO);

    AnnouncementDTO selectAnnouncement(String annNo);

    int insertAnnouncement(
            AnnouncementDTO announcementDTO,
            MultipartFile file
    );

    int updateAnnouncement(
            AnnouncementDTO announcementDTO,
            MultipartFile file
    );

    int deleteAnnouncement(String annNo);

    List<AnnouncementDTO> selectAptComplexList();

    AnnouncementDTO selectAptDetail(String aptCmplexNo);

}