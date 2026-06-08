package kr.or.ddit.domain.member.resident.mapper;

import kr.or.ddit.domain.member.resident.vo.PaymentVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface IResidentPaymentMapper {

    // 결제 요청 전에 고지서 정보 조회
    PaymentVO selectPaymentTargetBill(@Param("billNo") String billNo,
                                      @Param("userNo") String userNo);

    // 이미 납부된 고지서인지 확인
    int selectPaidBillCount(@Param("billNo") String billNo);

    // 결제번호 생성
    String selectNextPymtNo();

    // 결제 요청 정보 등록
    int insertPaymentRequest(PaymentVO paymentVO);

    // 고지서별 결제 이력 조회
    List<PaymentVO> selectPaymentListByBillNo(@Param("billNo") String billNo);

    // 주문번호로 결제 요청 정보 조회
    PaymentVO selectPaymentByOrdId(@Param("ordId") String ordId);

    // 결제 성공 처리
    int updatePaymentPaid(PaymentVO paymentVO);

    // 고지서 납부완료 처리
    int updateBillPaid(String billNo, int payAmt);

    int updatePaymentCancel(PaymentVO paymentVO);

    // 로그인 입주민의 연도별 납부완료 영수증 목록 조회
    List<PaymentVO> selectReceiptList( @Param("userNo") String userNo,
                                       @Param("billYear") String billYear);
}
