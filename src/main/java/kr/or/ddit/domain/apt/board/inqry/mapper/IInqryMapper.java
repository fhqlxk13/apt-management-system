package kr.or.ddit.domain.apt.board.inqry.mapper;

import kr.or.ddit.domain.apt.board.inqry.dto.InqryDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface IInqryMapper {

    List<InqryDTO> getList(
            @Param("wrtrId") String wrtrId,
            @Param("aptCmplexNo") String aptCmplexNo,
            @Param("boardTyCd") String boardTyCd,
            @Param("startRow") int startRow,
            @Param("endRow") int endRow
    );

    int getTotalCount(
            @Param("wrtrId") String wrtrId,
            @Param("aptCmplexNo") String aptCmplexNo,
            @Param("boardTyCd") String boardTyCd
    );

    InqryDTO getResidentInfo(@Param("userNo") String userNo);

    String getBoardNo(
            @Param("aptCmplexNo") String aptCmplexNo,
            @Param("boardTyCd") String boardTyCd
    );

    String getCommonBoardNo(@Param("boardTyCd") String boardTyCd);

    void insertInqry(InqryDTO dto);

    InqryDTO detail(
            @Param("postNo") String postNo,
            @Param("userNo") String userNo,
            @Param("userId") String userId
    );

    InqryDTO detailForAdmin(
            @Param("postNo") String postNo
    );

    InqryDTO getLatestAnswer(
            @Param("postNo") String postNo
    );

    String findAnswerCmtNo(
            @Param("postNo") String postNo
    );

    int insertAnswer(InqryDTO dto);

    int updateAnswer(
            @Param("cmtNo") String cmtNo,
            @Param("cmtCn") String cmtCn,
            @Param("userNo") String userNo
    );

    int updateInqry(
            @Param("dto") InqryDTO dto,
            @Param("userNo") String userNo,
            @Param("userId") String userId
    );

    int deleteInqry(
            @Param("postNo") String postNo,
            @Param("wrtrId") String wrtrId,
            @Param("aptCmplexNo") String aptCmplexNo,
            @Param("boardTyCd") String boardTyCd
    );
}


//package kr.or.ddit.domain.apt.board.inqry.mapper;
//
//import kr.or.ddit.domain.apt.board.inqry.dto.InqryDTO;
//import org.apache.ibatis.annotations.Mapper;
//import org.apache.ibatis.annotations.Param;
//
//import java.util.List;
//
///**
// * 입주민 문의게시판 Mapper
// *
// * Mapper란?
// * → Java 메서드와 MyBatis XML SQL을 연결하는 인터페이스.
// */
//@Mapper
//public interface IInqryMapper {
//
//    List<InqryDTO> getList(
//            @Param("wrtrId") String wrtrId,
//            @Param("aptCmplexNo") String aptCmplexNo,
//            @Param("boardTyCd") String boardTyCd,
//            @Param("startRow") int startRow,
//            @Param("endRow") int endRow
//    );
//
//    void insertInqry(InqryDTO dto);
//
//    void deleteInqry(
//            @Param("postNo") String postNo,
//            @Param("wrtrId") String wrtrId,
//            @Param("aptCmplexNo") String aptCmplexNo,
//            @Param("boardTyCd") String boardTyCd
//    );
//
//    int getTotalCount(
//            @Param("wrtrId") String wrtrId,
//            @Param("aptCmplexNo") String aptCmplexNo,
//            @Param("boardTyCd") String boardTyCd
//    );
//
//    InqryDTO getResidentInfo(@Param("userNo") String userNo);
//
//    String getBoardNo(
//            @Param("aptCmplexNo") String aptCmplexNo,
//            @Param("boardTyCd") String boardTyCd
//    );
//
//    InqryDTO detail(
//            @Param("postNo") String postNo,
//            @Param("userNo") String userNo,
//            @Param("userId") String userId
//    );
//
//
//    int updateInqry(
//            @Param("dto") InqryDTO dto,
//            @Param("userNo") String userNo,
//            @Param("userId") String userId
//    );
//}
