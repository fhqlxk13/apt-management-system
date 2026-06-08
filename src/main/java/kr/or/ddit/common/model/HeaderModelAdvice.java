package kr.or.ddit.common.model;

import kr.or.ddit.common.util.CurrentAptResolver;
import kr.or.ddit.domain.apt.main.dto.AptMainPageDTO;
import kr.or.ddit.domain.apt.main.service.IAptComplexService;
import kr.or.ddit.domain.apt.mgmtOffice.main.service.IMgmtOfficeService;
import kr.or.ddit.domain.apt.mgmtOffice.main.vo.MgmtOfficeVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

/**
 * 모든 일반 Controller가 JSP 화면으로 이동하기 전에
 * 공통 헤더/푸터에서 사용할 데이터를 Model에 자동으로 넣어주는 클래스.
 *
 * 핵심 변경점
 * 1. office를 더 이상 '관리소장 권한' 기준으로 조회하지 않음.
 * 2. 현재 로그인 사용자가 속한 아파트 단지번호(aptCmplexNo)를 먼저 구한 뒤,
 *    그 단지번호 기준으로 office / aptInfo를 공통 조회함.
 * 3. 그래서 관리소장과 입주민 모두 같은 단지 공통정보를 받을 수 있음.
 */
@Slf4j
@ControllerAdvice(annotations = Controller.class)
public class HeaderModelAdvice {

    @Autowired
    private IMgmtOfficeService mgmtOfficeService;

    @Autowired
    private IAptComplexService aptComplexService;

    @Autowired
    private CurrentAptResolver currentAptResolver;

    /**
     * 공통 관리사무소 정보
     *
     * 기존 문제점
     * - 관리소장 권한이 아니면 무조건 null 반환
     * - 입주민 화면에서도 office가 필요한데 받을 수 없었음
     *
     * 변경 후
     * - 현재 사용자가 속한 aptCmplexNo를 먼저 구함
     * - 그 aptCmplexNo로 관리사무소 정보를 조회함
     * - 따라서 관리소장/입주민 모두 office 사용 가능
     */
    @ModelAttribute("office")
    public MgmtOfficeVO addOffice(Authentication authentication) {
        try {
            String aptCmplexNo = currentAptResolver.resolveAptCmplexNo(authentication);

            if (aptCmplexNo == null || aptCmplexNo.isBlank()) {
                log.debug("공통 office 조회 생략 - aptCmplexNo 없음");
                return null;
            }

            MgmtOfficeVO office = mgmtOfficeService.selectMgmtOfficeByAptCmplexNo(aptCmplexNo);

            log.info("공통 office 조회 aptCmplexNo = {}, office = {}", aptCmplexNo, office);
            return office;

        } catch (Exception e) {
            // 공통 헤더 데이터 조회 실패 때문에 화면 전체가 죽지 않도록 방어
            log.error("공통 office 정보 조회 중 오류", e);
            return null;
        }
    }

    /**
     * 공통 아파트 정보
     *
     * office와 마찬가지로 권한이 아니라 aptCmplexNo 기준으로 조회한다.
     * 이렇게 해야 관리소장/입주민 모두 같은 단지 소개 정보 사용 가능.
     */
    @ModelAttribute("aptInfo")
    public AptMainPageDTO.ResponseDto addAptInfo(Authentication authentication) {
        try {
            String aptCmplexNo = currentAptResolver.resolveAptCmplexNo(authentication);

            if (aptCmplexNo == null || aptCmplexNo.isBlank()) {
                log.debug("공통 aptInfo 조회 생략 - aptCmplexNo 없음");
                return null;
            }

            AptMainPageDTO.ResponseDto aptInfo = aptComplexService.selectAptMainDTO(aptCmplexNo);

            return aptInfo;

        } catch (Exception e) {
            // 공통 헤더 데이터 조회 실패 때문에 화면 전체가 죽지 않도록 방어
            log.error("공통 aptInfo 정보 조회 중 오류", e);
            return null;
        }
    }
}
