package kr.or.ddit.domain.apt.mgmtOffice.board.service;

import kr.or.ddit.domain.apt.mgmtOffice.board.dto.MngrRegidentNoticeDTO;
import kr.or.ddit.domain.member.vo.CustomUser;
import org.springframework.ui.Model;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

public interface IMngrRegidentNoticeService {

    int selectNoticeCount(MngrRegidentNoticeDTO dto);

    List<MngrRegidentNoticeDTO> selectNoticeList(MngrRegidentNoticeDTO dto);

    MngrRegidentNoticeDTO selectNoticeDetail(MngrRegidentNoticeDTO dto);

    int insertNotice(
            MngrRegidentNoticeDTO dto,
            MultipartFile[] uploadFiles
    ) throws Exception;

    /*
     * 공지사항 수정
     *
     * deleteFileNos
     * → 수정 모달에서 삭제 버튼을 누른 기존 첨부파일 번호 목록
     */
    int updateNotice(
            MngrRegidentNoticeDTO dto,
            MultipartFile[] uploadFiles,
            List<String> deleteGoogleIds
    ) throws Exception;

    int deleteNotice(MngrRegidentNoticeDTO dto);

    void addManagerViewModel(
            Model model,
            CustomUser customUser,
            String mgmtOfcNo
    );

    void setManagerNoticeBaseInfo(
            MngrRegidentNoticeDTO dto,
            CustomUser customUser,
            String mgmtOfcNo
    );
    MngrRegidentNoticeDTO selectManagerOfficeInfo(String mgmtOfcNo);

}