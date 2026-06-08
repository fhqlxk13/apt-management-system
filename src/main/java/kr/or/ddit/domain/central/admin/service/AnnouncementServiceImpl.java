package kr.or.ddit.domain.central.admin.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.domain.central.admin.dto.AnnouncementDTO;
import kr.or.ddit.domain.central.admin.mapper.AnnouncementMapper;
import kr.or.ddit.domain.central.admin.service.IAnnouncementService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.multipart.MultipartFile;

/**
 * 공고 관리 Service 구현체
 *
 */
@Service
@RequiredArgsConstructor
public class AnnouncementServiceImpl implements IAnnouncementService {

    private final AnnouncementMapper announcementMapper;

    @Override
    public List<AnnouncementDTO> selectAnnouncementList(AnnouncementDTO searchVO) {
        return announcementMapper.selectAnnouncementList(searchVO);
    }

    @Override
    public AnnouncementDTO selectAnnouncement(String annNo) {
        return announcementMapper.selectAnnouncement(annNo);
    }

    @Override
    @Transactional
    public int insertAnnouncement(
            AnnouncementDTO announcementDTO,
            MultipartFile file
    ) {

    /*
      첨부파일 존재 여부 체크

      isEmpty()
      → 파일 선택 안 했는지 확인하는 메소드.
    */
        if (file != null && !file.isEmpty()) {

        /*
          TODO
          파일 저장 로직 추가 예정

          실무에서는 보통:
          1. 서버 폴더 저장
          2. UUID 파일명 생성
          3. ATTACH_FILE 테이블 저장
          4. FILE_GROUP_NO 생성
          5. announcementDTO.setAtchFileId(...)
        */

            System.out.println("업로드 파일명 : " + file.getOriginalFilename());
        }

        return announcementMapper.insertAnnouncement(announcementDTO);
    }

    @Override
    @Transactional
    public int updateAnnouncement(
            AnnouncementDTO announcementDTO,
            MultipartFile file
    ) {

    /*
      수정 시 새 파일 업로드 처리
    */
        if (file != null && !file.isEmpty()) {

        /*
          TODO
          기존 파일 삭제 후 새 파일 저장 예정
        */

            System.out.println("수정 파일명 : " + file.getOriginalFilename());
        }

        return announcementMapper.updateAnnouncement(announcementDTO);
    }

    @Override
    @Transactional
    public int deleteAnnouncement(String annNo) {
        return announcementMapper.deleteAnnouncement(annNo);
    }

    @Override
    public List<AnnouncementDTO> selectAptComplexList() {
        return announcementMapper.selectAptComplexList();
    }

    @Override
    public AnnouncementDTO selectAptDetail(String aptCmplexNo) {
        return announcementMapper.selectAptDetail(aptCmplexNo);
    }
}