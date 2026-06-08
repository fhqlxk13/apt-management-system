package kr.or.ddit.domain.central.admin.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import kr.or.ddit.domain.central.admin.mapper.IMngrRqstAprvMapper;
import kr.or.ddit.domain.central.admin.dto.MngrRqstAprvDTO;
import lombok.RequiredArgsConstructor;

/**
 * @Service란?
 * → 스프링이 업무 처리 클래스로 인식해서 Bean으로 등록하게 하는 어노테이션.
 * Bean이란?
 * → 스프링이 직접 생성하고 관리하는 객체.
 */
@Service
@RequiredArgsConstructor
public class MngrRqstAprvServiceImpl implements IMngrRqstAprvService {

    private final IMngrRqstAprvMapper mapper;

    @Override
    public List<MngrRqstAprvDTO> getRequestList(MngrRqstAprvDTO aprvDTO) {
        return mapper.selectRequestList(aprvDTO);
    }

    @Override
    public List<MngrRqstAprvDTO> getAccountList(MngrRqstAprvDTO aprvDTO) {
        return mapper.selectAccountList(aprvDTO);
    }

    @Override
    public MngrRqstAprvDTO getAccount(String userNo) {
        return mapper.selectAccount(userNo);
    }

    @Override
    public int updateRequest(MngrRqstAprvDTO vo) {
        return mapper.updateRequest(vo);
    }

    @Override
    public int deleteRequest(String rqstNo) {
        return mapper.deleteRequest(rqstNo);
    }

    @Override
    @Transactional
    public int approveRequest(String rqstNo, String aprvId) {

        /*
         * 승인 처리 흐름
         *
         * 1. 신청 정보 조회
         * 2. 신청 로그인 아이디로 MEMBER.USER_NO 조회
         * 3. 관리사무소번호 없으면 단지번호로 MGMT_OFC_NO 조회
         * 4. MANAGER 테이블 INSERT 또는 UPDATE
         * 5. AUTH 권한 ROLE_MNGR로 변경
         * 6. MNGR_RQST 상태 WAIT → OK 변경
         */

        MngrRqstAprvDTO rqst = mapper.selectRequest(rqstNo);

        if (rqst == null) {
            throw new IllegalStateException("신청 정보를 찾을 수 없습니다.");
        }

        if (!"WAIT".equalsIgnoreCase(rqst.getRqstSttsCd())) {
            throw new IllegalStateException("승인대기 상태만 승인할 수 있습니다.");
        }

        /*
         * 신청 로그인 아이디로 실제 회원 USER_NO 조회
         */
        String userNo = mapper.selectUserNoByLoginId(rqst.getRqstLoginId());

        if (!StringUtils.hasText(userNo)) {
            throw new IllegalStateException("MEMBER 테이블에서 신청 로그인 아이디와 일치하는 회원을 찾을 수 없습니다.");
        }

        rqst.setUserNo(userNo);
        rqst.setAprvId(aprvId);

        /*
         * 관리사무소번호가 없으면 단지번호로 다시 조회
         *
         * 왜 필요?
         * → MANAGER.MGMT_OFC_NO는 NOT NULL이라서
         *   값이 없으면 INSERT 실패함.
         */
        if (!StringUtils.hasText(rqst.getMgmtOfcNo())) {

            if (!StringUtils.hasText(rqst.getAptCmplexNo())) {
                throw new IllegalStateException("단지번호(APT_CMPLEX_NO)가 없어 관리사무소를 찾을 수 없습니다.");
            }

            String mgmtOfcNo = mapper.selectMgmtOfcNoByApt(rqst.getAptCmplexNo());

            if (!StringUtils.hasText(mgmtOfcNo)) {
                throw new IllegalStateException("해당 단지의 사용 가능한 관리사무소 정보가 없습니다.");
            }

            rqst.setMgmtOfcNo(mgmtOfcNo);
        }

        /*
         * MANAGER 등록 또는 수정
         *
         * upsert란?
         * → 있으면 UPDATE, 없으면 INSERT.
         */
        mapper.upsertManager(rqst);

        /*
         * AUTH 권한 변경
         *
         * ROLE_MNGR이 되어야 아래 계정 목록 조회에 표시됨.
         */
        mapper.updateAuthToManager(userNo);

        /*
         * 신청 상태 승인완료 처리
         */
        return mapper.approveRequest(rqst);
    }

    @Override
    @Transactional
    public int addApprovedAccount(String rqstNo) {
     /*
        다운로드 아이콘 클릭 처리

        역할:
        → 승인완료된 신청 건만 실제 ROLE_MNGR 권한으로 변경한다.
        → 이때부터 아래 '단지 관리자 계정 목록 및 상태'에 표시된다.
    */
        MngrRqstAprvDTO rqst = mapper.selectRequest(rqstNo);

        if (rqst == null) {
            throw new IllegalStateException("신청 정보를 찾을 수 없습니다.");
        }

        if (!"OK".equalsIgnoreCase(rqst.getRqstSttsCd())) {
            throw new IllegalStateException("승인완료 상태인 신청만 계정 목록에 추가할 수 있습니다.");
        }

        if (!StringUtils.hasText(rqst.getUserNo())) {
            throw new IllegalStateException("USER_NO가 없습니다.");
        }
        /*
        AUTH란?
        → 사용자 권한 저장 테이블.
        여기서 ROLE_MNGR로 바뀌면 아래 계정 목록 조회 조건에 포함된다.
         */
        mapper.updateAuthToManager(rqst.getUserNo());

        return mapper.updateAccountDsplyYn(rqstNo);
    }


    @Override
    @Transactional
    public int rejectRequest(String rqstNo, String aprvId, String rjctRsnCn) {
        /*
         * 반려는 계정을 만들지 않는다.
         * MNGR_RQST 상태만 RJCT로 변경한다.
         */
        return mapper.rejectRequest(
                rqstNo,
                aprvId,
                rjctRsnCn,
                null
        );
    }

    @Override
    public int updateAccountUseYn(String userNo, String userYn) {
        return mapper.updateAccountUseYn(userNo, userYn);
    }

    @Override
    @Transactional
    public int deleteAccount(String userNo) {
        /*
         * 논리삭제란?
         * → DB 데이터를 실제 DELETE로 지우지 않고,
         *   사용 여부값만 N으로 바꿔 화면에서 숨기는 방식.
         *
         * 왜 사용?
         * → 계정 이력, 승인 이력, FK 관계 데이터를 보존하기 위해 사용한다.
         *
         * 여기서는 MEMBER 테이블의 USER_YN을 'N'으로 변경한다.
         */
        return mapper.updateAccountUseYn(userNo, "N");
    }
}
