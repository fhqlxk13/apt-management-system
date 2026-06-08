package kr.or.ddit.domain.apt.mgmtOffice.common.service;

import kr.or.ddit.domain.member.vo.CustomUser;
import org.springframework.ui.Model;

public interface IManagerModelService {

    /*
     * 로그인 사용자가 ADMIN인지 확인
     * - ADMIN이면 true
     * - ADMIN이 아니거나 로그인 정보가 없으면 false
     */
    boolean isAdmin(CustomUser customUser);

    /*
     * 관리사무소 화면 공통 model 값 세팅
     * - isAdmin : ADMIN 여부
     * - mgmtOfcNo : 현재 화면의 관리사무소 번호
     * - loginUserNm : 로그인 사용자명
     * - selectedMgmtOfcNo : ADMIN이 선택한 관리사무소 번호
     * - mgmtOfcNm, aptCmplexNm : 화면 표시용 관리사무소/단지명
     */
    void addManagerViewModel(Model model, CustomUser customUser, String mgmtOfcNo);

    String getAptComplexNo(String mgmtOfcNo);
}