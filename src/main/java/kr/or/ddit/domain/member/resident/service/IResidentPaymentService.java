package kr.or.ddit.domain.member.resident.service;

import kr.or.ddit.domain.member.resident.vo.PaymentVO;

import java.util.List;
import java.util.Map;

public interface IResidentPaymentService {

    /**
     * @Author 이윤진
     * 결제 요청 생성
     *
     * 처리 내용:
     * - 로그인 사용자가 결제 가능한 고지서인지 확인
     * - 이미 납부완료된 고지서인지 확인
     * - 결제수단 검증: CRD, TRN
     * - PAYMENT 테이블에 UNPAID 상태로 등록
     *
     * @param billNo    고지서 번호
     * @param payMthdCd 결제수단 코드: CRD, TRN
     * @param userNo    로그인 사용자 번호
     * @return 결제 요청 정보
     */
    Map<String, Object> preparePayment(String billNo, String payMthdCd, String userNo);

    /**
     * 고지서별 결제 이력 조회
     *
     * @param billNo 고지서 번호
     * @return 결제 이력 목록
     */
    List<PaymentVO> selectPaymentListByBillNo(String billNo);

    /**
     * PortOne 결제 완료 검증 및 관리비 납부완료 처리
     *
     * @param impUid PortOne 결제 고유번호
     * @param ordId  우리 시스템 주문번호
     * @param userNo 로그인 사용자번호
     * @return 결제 완료 결과
     */
    Map<String, Object> completePayment(String impUid, String ordId, String userNo);

    Map<String, Object> cancelPayment(String pymtNo, String ordId, String failRsnCn, String userNo);

    // 로그인 입주민의 연도별 납부완료 영수증 목록 조회
    List<PaymentVO> selectReceiptList(String userNo, String billYear);
}
