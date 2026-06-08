package kr.or.ddit.domain.apt.mgmtOffice.board.mapper;

import kr.or.ddit.domain.apt.mgmtOffice.board.dto.MngrRegidentNoticeDTO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;

@Mapper
public interface ImngrRegidentNoticeMapper {

    int selectNoticeCount(MngrRegidentNoticeDTO dto);

    List<MngrRegidentNoticeDTO> selectNoticeList(MngrRegidentNoticeDTO dto);

    MngrRegidentNoticeDTO selectNoticeDetail(MngrRegidentNoticeDTO dto);

    int insertNotice(MngrRegidentNoticeDTO dto);

    int selectAttachFileGroupNo();

    int insertAttachFile(MngrRegidentNoticeDTO fileDTO);

    int updateNotice(MngrRegidentNoticeDTO dto);

    int deleteNotice(MngrRegidentNoticeDTO dto);

    String selectAptCmplexNoByMgmtOfcNo(String mgmtOfcNo);

    String selectNoticeBoardNoByAptCmplexNo(String aptCmplexNo);

    String selectNoticeWriterName(Map<String, Object> paramMap);

    int updateNoticeAttachFileId(MngrRegidentNoticeDTO dto);

    /*
     * 공지사항 첨부파일 목록 조회
     */
    List<MngrRegidentNoticeDTO> selectNoticeAttachFileList(MngrRegidentNoticeDTO dto);

    /*
     * GOOGLE_ID 기준 첨부파일 1건 삭제
     */
    int deleteAttachFileByGoogleId(String googleId);

    /*
     * 첨부파일 그룹에 남아있는 파일 개수 조회
     */
    int selectAttachFileCount(String atchFileId);

    /*
     * 공지사항의 첨부파일 그룹 연결 해제
     */
    int clearNoticeAttachFileId(MngrRegidentNoticeDTO dto);


    MngrRegidentNoticeDTO selectManagerOfficeInfo(String mgmtOfcNo);

    /*
     * 공지게시판 기본 데이터가 없을 때 자동 생성
     *
     * 왜 필요?
     * → APT_BOARD_INSTANCE에 게시판이 없으면 공지글을 등록할 BOARD_NO가 없기 때문.
     */
    int mergeNoticeBoardInstance(String aptCmplexNo);



}