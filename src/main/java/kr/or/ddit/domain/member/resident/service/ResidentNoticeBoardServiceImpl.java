package kr.or.ddit.domain.member.resident.service;

import kr.or.ddit.domain.member.resident.dto.ResidentNoticeBoardDTO;
import kr.or.ddit.domain.member.resident.mapper.IResidentNoticeBoardMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ResidentNoticeBoardServiceImpl implements IResidentNoticeBoardService {

    private final IResidentNoticeBoardMapper residentBoardNoticeMapper;

    @Override
    public int selectResidentBoardNoticeCount(ResidentNoticeBoardDTO searchDTO) {
        return residentBoardNoticeMapper.selectResidentBoardNoticeCount(searchDTO);
    }

    @Override
    public List<ResidentNoticeBoardDTO> selectResidentBoardNoticeList(ResidentNoticeBoardDTO searchDTO) {
        return residentBoardNoticeMapper.selectResidentBoardNoticeList(searchDTO);
    }

    @Override
    @Transactional
    public ResidentNoticeBoardDTO selectResidentBoardNoticeDetail(
            ResidentNoticeBoardDTO searchDTO
    ) {

        /*
         * 조회수 증가
         *
         * 왜 먼저 증가?
         * → 상세페이지에 들어왔을 때 조회수를 1 올리기 위해.
         */
        residentBoardNoticeMapper.updateResidentBoardNoticeInqCnt(searchDTO);

        /*
         * 공지사항 기본정보 조회
         *
         * 중요:
         * 이 SQL은 첨부파일 JOIN 없이 공지글 1건만 조회해야 함.
         */
        ResidentNoticeBoardDTO notice =
                residentBoardNoticeMapper.selectResidentBoardNoticeDetail(searchDTO);

        /*
         * 첨부파일 목록 별도 조회
         *
         * 왜 따로 조회?
         * → 공지글 1개에 첨부파일이 여러 개일 수 있기 때문.
         * → JOIN하면 공지글이 첨부파일 개수만큼 중복 조회됨.
         */
        if (notice != null
                && notice.getAtchFileId() != null
                && !notice.getAtchFileId().isBlank()) {

            notice.setAttachFileList(
                    residentBoardNoticeMapper.selectResidentNoticeAttachFileList(notice)
            );
        }

        return notice;
    }

    @Override
    public ResidentNoticeBoardDTO selectPrevResidentNotice(ResidentNoticeBoardDTO searchDTO) {
        return residentBoardNoticeMapper.selectPrevResidentNotice(searchDTO);
    }

    @Override
    public ResidentNoticeBoardDTO selectNextResidentNotice(ResidentNoticeBoardDTO searchDTO) {
        return residentBoardNoticeMapper.selectNextResidentNotice(searchDTO);
    }

}