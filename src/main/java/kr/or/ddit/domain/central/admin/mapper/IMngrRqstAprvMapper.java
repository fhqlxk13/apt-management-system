package kr.or.ddit.domain.central.admin.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.or.ddit.domain.central.admin.dto.MngrRqstAprvDTO;

/**
 * Mapper란?
 * → Java 메서드와 MyBatis XML SQL을 연결하는 인터페이스.
 * 왜 사용?
 * → Service에서 SQL을 직접 작성하지 않고 DB 작업을 분리하기 위해 사용한다.
 */
@Mapper
public interface IMngrRqstAprvMapper {

    List<MngrRqstAprvDTO> selectRequestList(MngrRqstAprvDTO aprvDTO);
    List<MngrRqstAprvDTO> selectAccountList(MngrRqstAprvDTO aprvDTO);

    MngrRqstAprvDTO selectRequest(String rqstNo);
    MngrRqstAprvDTO selectAccount(String userNo);

    int countMemberByUserId(String userId);

    int insertRequest(MngrRqstAprvDTO vo);
    int updateRequest(MngrRqstAprvDTO vo);

    /* 승인, 반려 */
    int approveRequest(MngrRqstAprvDTO aprvDTO);
    int rejectRequest(
            @Param("rqstNo") String rqstNo,
            @Param("aprvId") String aprvId,
            @Param("rjctRsnCn") String rjctRsnCn,
            @Param("rmrkCn") String rmrkCn
    );

    int deleteRequest(String rqstNo);

    int insertMemberForManager(MngrRqstAprvDTO vo);
    int updateAuthToManager(String userNo);
    int insertManager(MngrRqstAprvDTO vo);

    int updateAccountUseYn(@Param("userNo") String userNo, @Param("userYn") String userYn);

    int deleteManager(String userNo);
    int deleteAuth(String userNo);
    int deleteMember(String userNo);

    // 중복 MANAGER 체크용
    int countManagerByUserNo(String userNo);
    String selectMgmtOfcNoByApt(String aptCmplexNo);

    /*
    신청 데이터를 아래 계정 목록으로 이동 처리

    ACNT_DSPLY_YN = 'N'으로 변경하여
    신청 목록에서 숨기기 위한 메서드
    */
    int updateAccountDsplyYn(@Param("rqstNo") String rqstNo);

    // RQST_LOGIN_ID로 MEMBER.USER_NO 찾기
    String selectUserNoByLoginId(String rqstLoginId);

    // MANAGER가 있으면 UPDATE, 없으면 INSERT
    int upsertManager(MngrRqstAprvDTO vo);


}
