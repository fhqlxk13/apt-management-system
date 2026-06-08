package kr.or.ddit.domain.central.admin.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.domain.central.admin.dto.AnnouncementDTO;

/**
 * 공고 관리 Mapper
 *
 * Mapper란?
 * → Java 메소드와 MyBatis XML 쿼리를 연결하는 인터페이스.
 */
@Mapper
public interface AnnouncementMapper {

    List<AnnouncementDTO> selectAnnouncementList(AnnouncementDTO searchVO);

    AnnouncementDTO selectAnnouncement(String annNo);

    int insertAnnouncement(AnnouncementDTO announcementDTO);

    int updateAnnouncement(AnnouncementDTO announcementDTO);

    int deleteAnnouncement(String annNo);

    List<AnnouncementDTO> selectAptComplexList();

    AnnouncementDTO selectAptDetail(String aptCmplexNo);
}