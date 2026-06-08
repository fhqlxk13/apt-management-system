package kr.or.ddit.common.sms.mapper;

import kr.or.ddit.common.sms.dto.SmsReceiver;
import kr.or.ddit.common.sms.dto.SmsSendRequest;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * SMS 발송 Mapper
 */
@Mapper
public interface ISmsMapper {

    /** SMS 발송번호 채번 */
    String selectNextSmsNo();

    /** SMS 발송상세번호 채번 */
    String selectNextSmsDtlNo();

    /** SMS 발송 이력 등록 */
    int insertSmsSnd(SmsSendRequest request);

    /**
     * SMS 발송 상세 이력 등록
     *
     * @param smsDtlNo 발송상세번호
     * @param smsNo 발송번호
     * @param receiver 수신자 정보
     * @param sndSttsCd 발송상태코드
     * @param failRsnCn 실패사유내용
     *
     * xml에서 #{smsNo} 이런식으로 사용할 수 있게 param 씀.
     */
    int insertSmsSndDtl(
            @Param("smsDtlNo") String smsDtlNo,
            @Param("smsNo") String smsNo,
            @Param("receiver") SmsReceiver receiver,
            @Param("sndSttsCd") String sndSttsCd,
            @Param("failRsnCn") String failRsnCn
    );

    /** 회원번호로 SMS 수신자 조회 */
    SmsReceiver selectReceiverByUserNo(String userNo);

    /** 단지 공지 발송 대상자 조회 */
    List<SmsReceiver> selectNoticeReceiversByAptCmplexNo(String aptCmplexNo);

    /** 계약 관련 SMS 발송 대상자 조회 */
    List<SmsReceiver> selectContractReceiversByAptCmplexNo(String aptCmplexNo);
}