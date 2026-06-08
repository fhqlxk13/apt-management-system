package kr.or.ddit.domain.member.resident.service;

import kr.or.ddit.domain.member.resident.mapper.IResidentPaymentMapper;
import kr.or.ddit.domain.member.resident.vo.PaymentVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestClient;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 입주민 관리비 결제 서비스 구현
 *
 * 1차 구현 범위:
 * - 결제 요청 생성
 * - PAYMENT 테이블 UNPAID 상태 등록
 * - 카드/계좌이체 결제수단 변환값 반환
 *
 * PortOne 실제 결제 성공 검증은 다음 단계에서 추가한다.
 */
@Slf4j
@Service
public class ResidentPaymentServiceImpl implements IResidentPaymentService{

    @Autowired
    private IResidentPaymentMapper residentPaymentMapper;

    @Value("${portone.api-key}")
    private String portOneApiKey;

    @Value("${portone.api-secret}")
    private String portOneApiSecret;

    /**
     * PortOne V1 REST API 호출용 Client
     */
    private RestClient portOneRestClient =
            RestClient.create("https://api.iamport.kr");

    /* 결제 요청 생성 */
    @Transactional
    @Override
    public Map<String, Object> preparePayment(String billNo, String payMthdCd, String userNo) {

        validatePrepareParameter(billNo, payMthdCd, userNo);

        /*
         * 1. 로그인 사용자가 결제할 수 있는 고지서인지 확인
         *
         * - BILL
         * - HSHLD_HEAD
         * - 로그인 USER_NO 를 기준으로 본인 세대의 고지서만 결제 가능하게 한다.
         */
        PaymentVO targetBill =
                residentPaymentMapper.selectPaymentTargetBill(billNo, userNo);

        if (targetBill == null) {
            throw new IllegalArgumentException("결제 가능한 관리비 고지서를 찾을 수 없습니다.");
        }

        /*
         * 2. 이미 납부완료된 고지서인지 확인
         */
        int paidBillCount = residentPaymentMapper.selectPaidBillCount(billNo);

        if (paidBillCount > 0) {
            throw new IllegalStateException("이미 납부 완료된 관리비입니다.");
        }

        /*
         * 3. 결제번호 및 주문번호 생성
         *
         * PYMT_NO : 시퀀스
         * ORD_ID : PortOne merchant_uid로 전달할 고유 주문번호
         */
        String pymtNo = residentPaymentMapper.selectNextPymtNo();
        String ordId = createOrderId(billNo);

        /*
         * 4. PAYMENT 결제 요청 데이터 생성
         *
         * 현재 단계에서는 아직 PortOne 결제창 호출 전이므로:
         * - IMP_UID     = NULL
         * - PAY_CMPL_DT = NULL
         * - PAY_STTS_CD = UNPAID
         */
        PaymentVO paymentVO = new PaymentVO();
        paymentVO.setPymtNo(pymtNo);
        paymentVO.setBillNo(targetBill.getBillNo());
        paymentVO.setPayMthdCd(payMthdCd);
        paymentVO.setPayAmt(targetBill.getBillTotAmt());
        paymentVO.setPaySttsCd("UNPAID");
        paymentVO.setOrdId(ordId);
        paymentVO.setUserNo(userNo);

        int insertCount = residentPaymentMapper.insertPaymentRequest(paymentVO);

        if (insertCount != 1) {
            throw new IllegalStateException("결제 요청 정보 저장에 실패했습니다.");
        }

        /*
         * 5. 프론트 결제창 호출에 필요한 데이터 반환
         */
        Map<String, Object> result = new HashMap<>();

        result.put("pymtNo", pymtNo);
        result.put("billNo", targetBill.getBillNo());
        result.put("ordId", ordId);
        result.put("payMthdCd", payMthdCd);
        result.put("portOnePayMethod", convertPortOnePayMethod(payMthdCd));

        result.put("payAmt", targetBill.getBillTotAmt());
        result.put("billYm", targetBill.getBillYm());
        result.put("displayDongHo", targetBill.getDisplayDongHo());

        result.put("paySttsCd", "UNPAID");

        return result;
    }

    /* 고지서별 결제 이력 조회 */
    @Override
    public List<PaymentVO> selectPaymentListByBillNo(String billNo) {
        if (billNo == null || billNo.isBlank()) {
            throw new IllegalArgumentException("고지서 번호가 없습니다.");
        }

        return residentPaymentMapper.selectPaymentListByBillNo(billNo);
    }

    /**
     * PortOne 결제 완료 검증 및 관리비 납부완료 처리
     *
     * 처리 순서:
     * 1. 주문번호로 PAYMENT 결제요청 조회
     * 2. 로그인 사용자의 결제요청인지 확인
     * 3. PortOne access_token 발급
     * 4. imp_uid 기준 실제 결제내역 조회
     * 5. 주문번호, 결제금액, 결제상태 검증
     * 6. PAYMENT를 PAID로 변경
     * 7. BILL을 PAID로 변경
     */
    @Transactional
    @Override
    public Map<String, Object> completePayment(String impUid, String ordId, String userNo) {

        validateCompleteParameter(impUid, ordId, userNo);

        /*
         * 1. prepare 단계에서 생성한 PAYMENT 조회
         */
        PaymentVO paymentVO = residentPaymentMapper.selectPaymentByOrdId(ordId);

        if (paymentVO == null) {
            throw new IllegalArgumentException("결제 요청 정보를 찾을 수 없습니다.");
        }

        /*
         * 2. 현재 로그인 사용자가 요청한 결제인지 확인
         */
        if (!userNo.equals(paymentVO.getUserNo())) {
            throw new IllegalStateException("본인의 결제 요청만 처리할 수 있습니다.");
        }

        /*
         * 3. 이미 결제완료된 결제 요청이면 중복 결제로 처리하지 않고
         *    BILL 상태를 한 번 더 동기화한 뒤 성공 응답을 반환한다.
         *
         *    - 결제 성공 후 화면 재호출
         *    - 네트워크 재전송
         *    - PAYMENT만 PAID이고 BILL 갱신이 누락된 경우
         *      를 안전하게 처리하기 위한 로직이다.
         */
        if ("PAID".equals(paymentVO.getPaySttsCd())) {

            int paidAmount = paymentVO.getPayAmt();

            /*
             * XML의 UPDATE 조건이
             * AND PYMT_STTS_CD != 'PAID'
             * 이므로 BILL이 이미 PAID면 0건,
             * 아직 READY면 1건 수정된다.
             */
            int billUpdateCount = residentPaymentMapper.updateBillPaid(
                    paymentVO.getBillNo(),
                    paidAmount
            );

            Map<String, Object> result = new HashMap<>();
            result.put("pymtNo", paymentVO.getPymtNo());
            result.put("billNo", paymentVO.getBillNo());
            result.put("impUid", paymentVO.getImpUid());
            result.put("ordId", paymentVO.getOrdId());
            result.put("payAmt", paidAmount);
            result.put("paySttsCd", "PAID");
            result.put("billPymtSttsCd", "PAID");
            result.put("alreadyCompleted", true);
            result.put("billUpdatedCount", billUpdateCount);

            return result;
        }

        /*
         * 4. PortOne 서버에서 실제 결제정보 조회
         */
        Map<String, Object> portOnePayment = requestPortOnePayment(impUid);

        String portOneImpUid = String.valueOf(portOnePayment.get("imp_uid"));
        String merchantUid = String.valueOf(portOnePayment.get("merchant_uid"));
        String paymentStatus = String.valueOf(portOnePayment.get("status"));

        int paidAmount = toInt(portOnePayment.get("amount"));

        /*
         * 5. 결제 정보 검증
         *
         * 프론트에서 전달된 성공 결과만 믿지 않고,
         * PortOne 서버 조회 결과와 DB 요청 데이터를 반드시 비교한다.
         */
        if (!impUid.equals(portOneImpUid)) {
            throw new IllegalStateException("결제 고유번호 검증에 실패했습니다.");
        }

        if (!ordId.equals(merchantUid)) {
            throw new IllegalStateException("주문번호 검증에 실패했습니다.");
        }

        if (!"paid".equals(paymentStatus)) {
            throw new IllegalStateException("결제가 완료되지 않았습니다. 상태: " + paymentStatus);
        }

        if (paymentVO.getPayAmt() != paidAmount) {
            throw new IllegalStateException("결제금액 검증에 실패했습니다.");
        }

        /*
         * 6. PAYMENT 납부완료 처리
         */
        paymentVO.setImpUid(impUid);

        int paymentUpdateCount = residentPaymentMapper.updatePaymentPaid(paymentVO);

        if (paymentUpdateCount != 1) {
            throw new IllegalStateException("결제 상태 변경에 실패했습니다.");
        }

        /*
         * 7. BILL 납부완료 처리
         */
        int billUpdateCount = residentPaymentMapper.updateBillPaid(
                paymentVO.getBillNo(),
                paidAmount
        );

        if (billUpdateCount != 1) {
            throw new IllegalStateException("관리비 납부 상태 변경에 실패했습니다.");
        }

        /*
         * 8. 화면 반환값
         */
        Map<String, Object> result = new HashMap<>();
        result.put("pymtNo", paymentVO.getPymtNo());
        result.put("billNo", paymentVO.getBillNo());
        result.put("impUid", impUid);
        result.put("ordId", ordId);
        result.put("payAmt", paidAmount);
        result.put("paySttsCd", "PAID");
        result.put("billPymtSttsCd", "PAID");

        return result;
    }

    /**
     * 결제창 취소 또는 결제 실패 처리
     *
     * PortOne 결제 callback에서 rsp.success = false 인 경우에만 호출한다.
     * 결제가 이미 승인된 이후 complete 검증만 실패한 경우에는 호출하면 안 된다.
     */
    @Transactional
    @Override
    public Map<String, Object> cancelPayment(String pymtNo, String ordId, String failRsnCn, String userNo) {
        if (pymtNo == null || pymtNo.isBlank()) {
            throw new IllegalArgumentException("결제번호가 없습니다.");
        }

        if (ordId == null || ordId.isBlank()) {
            throw new IllegalArgumentException("주문번호가 없습니다.");
        }

        if (userNo == null || userNo.isBlank()) {
            throw new IllegalArgumentException("로그인 사용자 정보를 확인할 수 없습니다.");
        }

        PaymentVO paymentVO = residentPaymentMapper.selectPaymentByOrdId(ordId);

        if (paymentVO == null) {
            throw new IllegalArgumentException("결제 요청 정보를 찾을 수 없습니다.");
        }

        if (!pymtNo.equals(paymentVO.getPymtNo())) {
            throw new IllegalStateException("결제번호가 일치하지 않습니다.");
        }

        if (!userNo.equals(paymentVO.getUserNo())) {
            throw new IllegalStateException("본인의 결제 요청만 취소할 수 있습니다.");
        }

        if ("PAID".equals(paymentVO.getPaySttsCd())) {
            throw new IllegalStateException("이미 납부 완료된 결제입니다.");
        }

        paymentVO.setFailRsnCn(failRsnCn);

        int updateCount = residentPaymentMapper.updatePaymentCancel(paymentVO);

        if (updateCount != 1) {
            throw new IllegalStateException("결제 취소 상태 변경에 실패했습니다.");
        }

        Map<String, Object> result = new HashMap<>();
        result.put("pymtNo", paymentVO.getPymtNo());
        result.put("ordId", paymentVO.getOrdId());
        result.put("paySttsCd", "CANCEL");

        return result;
    }

    @Override
    public List<PaymentVO> selectReceiptList(String userNo, String billYear) {
        if (userNo == null || userNo.isBlank()) {
            throw new IllegalArgumentException("로그인 사용자 정보를 확인할 수 없습니다.");
        }

        if (billYear == null || !billYear.matches("\\d{4}")) {
            throw new IllegalArgumentException("조회연도는 YYYY 형식이어야 합니다.");
        }

        return residentPaymentMapper.selectReceiptList(userNo, billYear);
    }

    /* 결제 요청 파라미터 검증 */
    private void validatePrepareParameter(String billNo, String payMthdCd, String userNo) {

        if (billNo == null || billNo.isBlank()) {
            throw new IllegalArgumentException("고지서 번호가 없습니다.");
        }

        if (userNo == null || userNo.isBlank()) {
            throw new IllegalArgumentException("로그인 사용자 정보를 확인할 수 없습니다.");
        }

        if (!"CRD".equals(payMthdCd) && !"TRN".equals(payMthdCd)) {
            throw new IllegalArgumentException("지원하지 않는 결제수단입니다.");
        }
    }

    /**
     * PortOne merchant_uid로 사용할 주문번호 생성
     *
     * 예 : ORD_BL2605210001647_20260526154730125
     */
    private String createOrderId(String billNo) {
        String now = LocalDateTime.now()
                .format(DateTimeFormatter.ofPattern("yyyyMMddHHmmssSSS"));

        return "ORD_" + billNo + "_" + now;
    }

    /**
     * 내부 결제수단 코드를 PortOne 결제수단 값으로 변환
     *
     * PAY_MET.CRD -> card
     * PAY_MET.TRN -> trans
     */
    private Object convertPortOnePayMethod(String payMthdCd) {

        if ("CRD".equals(payMthdCd)) {
            return "card";
        }

        if ("TRN".equals(payMthdCd)) {
            return "trans";
        }

        throw new IllegalArgumentException("지원하지 않는 결제수단입니다.");
    }

    /**
     * PortOne 결제내역 단건 조회
     *
     * @param impUid PortOne 결제 고유번호
     * @return PortOne 결제 response 객체
     */
    @SuppressWarnings("unchecked")
    private Map<String, Object> requestPortOnePayment(String impUid) {

        String accessToken = requestPortOneAccessToken();

        Map<String, Object> paymentResponse = portOneRestClient.get()
                .uri(uriBuilder -> uriBuilder
                        .path("/payments/{impUid}")
                        .queryParam("include_sandbox", true)
                        .build(impUid))
                .header(HttpHeaders.AUTHORIZATION, accessToken)
                .retrieve()
                .body(Map.class);

        if (paymentResponse == null) {
            throw new IllegalStateException("PortOne 결제정보 응답이 없습니다.");
        }

        int code = toInt(paymentResponse.get("code"));

        if (code != 0) {
            throw new IllegalStateException(
                    "PortOne 결제정보 조회에 실패했습니다: "
                            + String.valueOf(paymentResponse.get("message"))
            );
        }

        Object responseObject = paymentResponse.get("response");

        if (!(responseObject instanceof Map)) {
            throw new IllegalStateException("PortOne 결제정보가 존재하지 않습니다.");
        }

        return (Map<String, Object>) responseObject;
    }


    /**
     * PortOne V1 access_token 발급
     *
     * PortOne API Key / Secret은 반드시 서버 설정에서만 사용한다.
     */
    @SuppressWarnings("unchecked")
    private String requestPortOneAccessToken() {

        Map<String, String> requestBody = new HashMap<>();
        requestBody.put("imp_key", portOneApiKey);
        requestBody.put("imp_secret", portOneApiSecret);

        Map<String, Object> tokenResponse = portOneRestClient.post()
                .uri("/users/getToken")
                .contentType(MediaType.APPLICATION_JSON)
                .body(requestBody)
                .retrieve()
                .body(Map.class);

        if (tokenResponse == null) {
            throw new IllegalStateException("PortOne 인증 응답이 없습니다.");
        }

        int code = toInt(tokenResponse.get("code"));

        if (code != 0) {
            throw new IllegalStateException(
                    "PortOne 인증에 실패했습니다: "
                            + String.valueOf(tokenResponse.get("message"))
            );
        }

        Object responseObject = tokenResponse.get("response");

        if (!(responseObject instanceof Map)) {
            throw new IllegalStateException("PortOne access_token을 확인할 수 없습니다.");
        }

        Map<String, Object> response = (Map<String, Object>) responseObject;
        Object accessToken = response.get("access_token");

        if (accessToken == null || String.valueOf(accessToken).isBlank()) {
            throw new IllegalStateException("PortOne access_token이 없습니다.");
        }

        return String.valueOf(accessToken);
    }


    /**
     * 결제 완료 요청값 검증
     */
    private void validateCompleteParameter(String impUid, String ordId, String userNo) {

        if (impUid == null || impUid.isBlank()) {
            throw new IllegalArgumentException("PortOne 결제번호가 없습니다.");
        }

        if (ordId == null || ordId.isBlank()) {
            throw new IllegalArgumentException("주문번호가 없습니다.");
        }

        if (userNo == null || userNo.isBlank()) {
            throw new IllegalArgumentException("로그인 사용자 정보를 확인할 수 없습니다.");
        }
    }


    /**
     * PortOne JSON 숫자값 안전 변환
     */
    private int toInt(Object value) {

        if (value == null) {
            return 0;
        }

        if (value instanceof Number) {
            return ((Number) value).intValue();
        }

        return Integer.parseInt(String.valueOf(value));
    }
}