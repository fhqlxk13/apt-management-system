package kr.or.ddit.domain.central.admin.controller;

import kr.or.ddit.common.util.BusinessException;
import kr.or.ddit.domain.central.admin.dto.AplctDTO;
import kr.or.ddit.domain.central.admin.service.IAnlsService;
import kr.or.ddit.domain.central.admin.service.IAplctService;
import kr.or.ddit.domain.central.rentCtrt.service.IRentCtrtService;
import kr.or.ddit.domain.member.admin.vo.AdmVO;
import kr.or.ddit.domain.member.vo.CustomUser;
import kr.or.ddit.domain.member.vo.MemberVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@RestController
@PreAuthorize("hasRole('ADMIN')")
@RequestMapping("/api/react/adm")
public class AdmDashBoardRestController {

    @Autowired
    private IAplctService aplctService;

    @Autowired
    private IRentCtrtService rentCtrtService;

    @Autowired
    private IAnlsService anlsService;

    // 리액트 페이지로 로그인한 관리자 정보를 넘김
    @GetMapping("/info")
    public ResponseEntity<?> getAdminInfo(@AuthenticationPrincipal CustomUser customUser) {
        if (customUser == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("인증 정보가 없습니다.");
        }
        AdmVO adm = (AdmVO) customUser.getMember();

        log.info("## 리액트 레이아웃에서 관리자 정보 요청함: {}", adm.getUserNm());

        return ResponseEntity.ok(adm);
    }

    // 청약 신청 목록 조회
    @GetMapping("/aplct")
    public ResponseEntity<List<AplctDTO>> getAplctList() {
        try {
            List<AplctDTO> list = aplctService.selectAplctList();

            if (list.isEmpty()) {
                return ResponseEntity.noContent().build();
            }
            return ResponseEntity.ok(list);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }

    // 청약 신청 처리(업데이트)
    @PutMapping("/aplct/upd")
    public ResponseEntity<?> updAplct(@RequestBody Map<String, Object> params,
                                        @AuthenticationPrincipal CustomUser customUser) {
        log.info("#### 상태 변경 진입 :" + params);
        MemberVO member = customUser.getMember();
        AdmVO adm = (AdmVO) member;

        List<Map<String, Object>> updateList = (List<Map<String, Object>>) params.get("aplctMapList");

        if (updateList == null || updateList.isEmpty()) {
            return ResponseEntity.badRequest().body(0);
        }

        // 최종 승인시 가계약 인서트 및 담당자 인서트
        try {
            int cnt = aplctService.approveAplct(updateList, adm.getUserNo());
            // 서비스에 트랜잭셔널 어노테이션을 써서 어떠한 값이 오더라도 성공으로 간주
            // (쿼리에 익명블록 사용으로 성공해도 -1의 값이 올 수 있음)
            return cnt != 0 ? ResponseEntity.ok(cnt)
                    : ResponseEntity.badRequest().body(0);
        }catch (BusinessException e) {
            // 임대 매물이 없을시 서비스에서 받은 에러 메시지 프론트에 보냄
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @GetMapping("/ctrt/dashboard")
    public ResponseEntity<Map<String, Object>> getCtrtDashboard(){
        log.info("계약 대시보드 컨트롤러 진입");

        Map<String, Object> dashboard = rentCtrtService.selectCtrtDashboard();

        Map<String, Object> response = new HashMap<>();
        response.put("dashboard", dashboard);
        log.info("## dashboard : {}", response.get("dashboard"));

        return ResponseEntity.ok(response);
    }

    @GetMapping("ctrt/detail/{RENT_CTRT_NO}")
    public ResponseEntity<?> getCtrtDetail(@PathVariable("RENT_CTRT_NO") String rentCtrtNo){
        log.info("계약 상세 컨트롤러 진입, rentCtrtNo : {}", rentCtrtNo);
        Map<String, Object> response = new HashMap<>();

        Map<String, Object> ctrtDetail = rentCtrtService.selectOneCtrtDetail(rentCtrtNo);
        if (ctrtDetail == null) {
            return ResponseEntity.badRequest().body(null);
        }
        log.info("## ctrtDetail : {}", ctrtDetail);
        response.put("ctrtDetail", ctrtDetail);

        return ResponseEntity.ok(response);
    }

    @PutMapping("/ctrt/update/{RENT_CTRT_NO}")
    public ResponseEntity<?> updateCtrt(
            @PathVariable("RENT_CTRT_NO") String rentCtrtNo, @RequestBody Map<String, Object> detail) {
        log.info("계약 업데이트 컨트롤러 진입");
        int res = rentCtrtService.updateCtrt(rentCtrtNo, detail);
        if(res == 0){
            return ResponseEntity.badRequest().body("계약 정보 수정 실패");
        }
        return ResponseEntity.ok().build();
    }

    /**
     * 계약 목록 필터 조회
     * @param customUser
     * @param curPage
     * @param params
     * @return
     */
    @GetMapping("/ctrt")
    public ResponseEntity<Map<String, Object>> getCtrtList(
            @AuthenticationPrincipal CustomUser customUser,
            @RequestParam(value = "page", defaultValue = "1") int curPage,
            @RequestParam Map<String, Object> params // 필터 검색어 포함
    ) {
        log.info("getCtrtList() 실행 - 페이지: {}, 검색조건: {}", curPage, params);
        String userNo = customUser.getMember().getUserNo();

        // 1. 페이징 계산
        int screenSize = 12;
        int startRow = (curPage - 1) * screenSize + 1;
        int endRow = curPage * screenSize;

        // 2. 검색 조건과 페이징 정보를 하나의 맵으로 통합
        params.put("startRow", startRow);
        params.put("endRow", endRow);
        params.put("userNo", userNo); // 권한 체크용

        // 3. 서비스 호출 (검색과 페이징을 통합한 서비스 메서드)
        List<Map<String, Object>> ctrtList = rentCtrtService.selectCtrt(params);
        int totalRecord = rentCtrtService.selectCtrtCount(params);
        int totalPage = (int) Math.ceil((double) totalRecord / (double) screenSize);

        // 4. 응답 구성
        Map<String, Object> response = new HashMap<>();
        response.put("ctrtList", ctrtList);
        response.put("curPage", curPage);
        response.put("totalPage", totalPage);
        response.put("totalRecord", totalRecord);

        log.info("결과 : {}", response.get("ctrtList") );
        return ResponseEntity.ok(response);
    }

    @GetMapping("/anls/aplct-rate")
    public ResponseEntity<Map<String, Object>> getAnnRecruiting(){
        Map<String, Object> response = new HashMap<>();

        List<Map<String, Object>> data = anlsService.getAnnList();
        response.put("data", data);

        return ResponseEntity.ok(response);
    }

    @GetMapping("/ctrtXls")
    public ResponseEntity<Map<String, Object>> getCtrtXls(@RequestParam Map<String, Object> params){
        log.info("#### 엑셀다운로드 메서드, params : {}", params);

        Map<String, Object> response = new HashMap<>();
        List<Map<String, Object>> ctrtList = rentCtrtService.selectCtrtXls(params);
        response.put("ctrtList", ctrtList);

        log.info("##### ctrtList : {}", ctrtList);

        return ResponseEntity.ok(response);
    }

}
