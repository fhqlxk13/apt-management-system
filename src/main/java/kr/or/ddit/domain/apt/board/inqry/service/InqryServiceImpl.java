package kr.or.ddit.domain.apt.board.inqry.service;

import kr.or.ddit.common.enums.board.BoardTyCd;
import kr.or.ddit.domain.apt.board.inqry.dto.InqryDTO;
import kr.or.ddit.domain.apt.board.inqry.mapper.IInqryMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 입주민 문의게시판 Service 구현체
 *
 * Service란?
 * → Controller와 Mapper 사이에서 업무 로직을 처리하는 클래스.
 */
@Service
@RequiredArgsConstructor
public class InqryServiceImpl implements IInqryService {

    private final IInqryMapper inqryMapper;

    /*
      문의게시판 게시판 유형 코드

      BoardTyCd.INQRY.name()
      → enum 값 INQRY를 문자열 "INQRY"로 가져온다.
    */
    private static final String BOARD_TY_CD_INQRY = BoardTyCd.INQRY.name();

    @Override
    public List<InqryDTO> getList(String userNo, String wrtrId, int startRow, int endRow) {

    /*
      ADMIN / MNGR
      → 모든 문의글 조회
      → 작성자, 단지 제한 없음
    */
        if (isAdminOrManager()) {
            return inqryMapper.getList(
                    null,
                    null,
                    BOARD_TY_CD_INQRY,
                    startRow,
                    endRow
            );
        }

    /*
      RESIDENT
      → 본인 단지 + 본인 글만 조회
    */
        InqryDTO residentInfo = inqryMapper.getResidentInfo(userNo);

        String aptCmplexNo = residentInfo != null ? residentInfo.getAptCmplexNo() : null;

        return inqryMapper.getList(
                wrtrId,
                aptCmplexNo,
                BOARD_TY_CD_INQRY,
                startRow,
                endRow
        );
    }

    @Override
    public void insertInqry(InqryDTO dto, String userNo) {

        if (dto.getTtl() == null || dto.getTtl().trim().isEmpty()) {
            throw new RuntimeException("제목 없음");
        }

        if (dto.getCn() == null || dto.getCn().trim().isEmpty()) {
            throw new RuntimeException("내용 없음");
        }

        /*

          세대정보를 사용하지 않음.
          → 공통 문의게시판 boardNo를 조회하거나,
            XML에서 INQRY 유형 게시판 1개를 조회하도록 처리.

          주의:
          → 아래 getCommonBoardNo()는 Mapper에 새로 추가할 메서드.
        */
        String boardNo = inqryMapper.getCommonBoardNo(BOARD_TY_CD_INQRY);

        if (boardNo == null || boardNo.trim().isEmpty()) {
            throw new RuntimeException("문의게시판이 생성되지 않았습니다.");
        }

        dto.setBoardNo(boardNo);
        dto.setUserNo(userNo);
        dto.setBoardTyCd(BOARD_TY_CD_INQRY);

        /*
          세대정보를 사용하지 않으므로 아래 값들은 세팅하지 않음.

          dto.setHoNo(...)
          dto.setAptCmplexNo(...)
        */

        if (dto.getOpnYn() == null || dto.getOpnYn().trim().isEmpty()) {
            dto.setOpnYn("Y");
        }

        inqryMapper.insertInqry(dto);
    }

    @Override
    public void deleteInqry(String postNo, String userNo, String wrtrId) {

        if (isAdminOrManager()) {
            inqryMapper.deleteInqry(
                    postNo,
                    null,
                    null,
                    BOARD_TY_CD_INQRY
            );
            return;
        }

        InqryDTO residentInfo = inqryMapper.getResidentInfo(userNo);

        String aptCmplexNo = residentInfo != null ? residentInfo.getAptCmplexNo() : null;

        inqryMapper.deleteInqry(
                postNo,
                wrtrId,
                aptCmplexNo,
                BOARD_TY_CD_INQRY
        );
    }

    @Override
    public int getTotalCount(String userNo, String wrtrId) {

    /*
      ADMIN / MNGR
      → 전체 문의글 개수
    */
        if (isAdminOrManager()) {
            return inqryMapper.getTotalCount(
                    null,
                    null,
                    BOARD_TY_CD_INQRY
            );
        }

    /*
      RESIDENT
      → 본인 단지 + 본인 글 개수
    */
        InqryDTO residentInfo = inqryMapper.getResidentInfo(userNo);

        String aptCmplexNo = residentInfo != null ? residentInfo.getAptCmplexNo() : null;

        return inqryMapper.getTotalCount(
                wrtrId,
                aptCmplexNo,
                BOARD_TY_CD_INQRY
        );
    }

    @Override
    public InqryDTO detail(String postNo, String userNo, String userId) {

        /*
          상세 조회는 기존처럼 postNo + userNo/userId 기준 유지.
          본인 문의글만 수정/조회 가능하게 하는 목적.
        */
        InqryDTO dto = inqryMapper.detail(
                postNo,
                userNo,
                userId
        );

        if (dto == null) {
            throw new RuntimeException("존재하지 않거나 접근 권한이 없습니다.");
        }

        return dto;
    }

    @Override
    public InqryDTO detailForAdmin(String postNo) {
        InqryDTO dto = inqryMapper.detailForAdmin(postNo);

        if (dto == null) {
            throw new RuntimeException("존재하지 않거나 접근 권한이 없습니다.");
        }

        return dto;
    }

    @Override
    public void updateInqry(InqryDTO dto, String userNo, String userId) {

        /*
          수정도 세대정보가 아니라 작성자 본인 여부 기준.
        */
        int result = inqryMapper.updateInqry(
                dto,
                userNo,
                userId
        );

        if (result <= 0) {
            throw new RuntimeException("수정에 실패했습니다.");
        }
    }

    @Override
    public void replyInqry(String postNo, String cmtCn, String userNo) {
        if (cmtCn == null || cmtCn.trim().isEmpty()) {
            throw new RuntimeException("답변 내용을 입력하세요.");
        }

        String answerCmtNo = inqryMapper.findAnswerCmtNo(postNo);

        if (answerCmtNo == null || answerCmtNo.isBlank()) {
            InqryDTO answer = new InqryDTO();
            answer.setPostNo(postNo);
            answer.setAnsCn(cmtCn.trim());
            answer.setAnsUserNo(userNo);
            inqryMapper.insertAnswer(answer);
            return;
        }

        int updated = inqryMapper.updateAnswer(answerCmtNo, cmtCn.trim(), userNo);
        if (updated <= 0) {
            throw new RuntimeException("답변 등록에 실패했습니다.");
        }
    }

    /*
  현재 로그인 사용자가 특정 권한을 가지고 있는지 확인

  role 예시:
  ROLE_RESIDENT
  ROLE_MNGR
  ROLE_ADMIN
*/
    private boolean hasRole(String role) {
        return org.springframework.security.core.context.SecurityContextHolder
                .getContext()
                .getAuthentication()
                .getAuthorities()
                .stream()
                .anyMatch(auth -> auth.getAuthority().equals(role));
    }

    /*
      관리자 권한 여부 확인

      왜 사용?
      → 관리자와 중앙관리자는 세대정보 없이 문의게시판 접근 가능하게 하기 위해.
    */
    private boolean isAdminOrManager() {
        return hasRole("ROLE_ADMIN") || hasRole("ROLE_MNGR");
    }

}

