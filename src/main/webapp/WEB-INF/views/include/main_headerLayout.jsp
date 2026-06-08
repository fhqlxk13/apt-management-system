<%--
  Created by IntelliJ IDEA.
  User: 이용로
  Date: 2026-04-29
  Time: 오전 1:21
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<style>
    /*
    ═══════════════════════════════════════════════════════
    정렬 전략:
      header 안에 두 레이어를 쌓는다.

      [레이어1] 흰 바 — 로고 | 메뉴6칸 | 버튼
      [레이어2] 메가메뉴 — header 바로 아래 absolute

      핵심: 메가메뉴 내부 그리드를 별도 컨테이너로 두는 게 아니라
      레이어1의 nav-grid 바로 아래에 mega-grid를 놓고,
      두 그리드 모두 동일한 부모(.nav-wrap) 안에 있게 한다.
      → 별도 spacer/offset 계산 없이 자동으로 칼럼이 일치.
    ═══════════════════════════════════════════════════════
    */

    :root {
        --hdr-px: 2rem; /* header 좌우 패딩 */
        --hdr-gap: 2rem; /* 로고·메뉴·버튼 사이 gap */
        --logo-w: 170px;
        --btn-w: 330px;
        --primary: #226046;
    }

    /* ── header 컨테이너 ── */
    #site-header {
        position: fixed;
        inset: 0 0 auto 0;
        z-index: 50;
        overflow: visible; /* 메가메뉴가 header 밖으로 흘러나옴 */
    }

    /* ── 흰 바 ── */
    #hdr-bar {
        position: relative; /* 메가메뉴 absolute 기준 */
        background: rgba(255, 255, 255, 0.93);
        backdrop-filter: blur(20px);
        -webkit-backdrop-filter: blur(20px);
        box-shadow: 0 2px 24px rgba(0, 0, 0, 0.07);
    }

    /* ── 1500px 중앙 정렬 wrapper ── */
    .hdr-inner {
        max-width: 1500px;
        margin: 0 auto;
        padding: 0 var(--hdr-px);
        display: flex;
        align-items: stretch; /* 세로 전체 채움 */
        gap: var(--hdr-gap);
    }

    /* ── 로고 ── */
    #hdr-logo {
        width: var(--logo-w);
        flex-shrink: 0;
        display: flex;
        align-items: center;
        font-size: 1.2rem;
        font-weight: 700;
        color: var(--primary);
    }

    #hdr-logo a {
        color: inherit;
        text-decoration: none;
    }

    /* ── 메뉴 영역 (flex:1) — 상단탭 + 메가메뉴 공통 컨테이너 ── */
    #nav-wrap {
        flex: 1;
        min-width: 0;
        position: relative;
    }

    /* ── 5칸 공통 그리드 ── */
    .nav-grid {
        display: grid;
        grid-template-columns: repeat(5, 1fr);
        width: 100%;
    }

    /* ── 상단 탭 셀 ── */
    .nav-top-cell {
        display: flex;
        align-items: center;
        justify-content: center;
        padding: 1.3rem 0.25rem;
        font-size: 0.9375rem;
        font-weight: 500;
        color: #475569;
        cursor: pointer;
        white-space: nowrap;
        user-select: none;
        transition: color 0.14s, box-shadow 0.14s, font-weight 0.14s;
    }

    .nav-top-cell:hover,
    .nav-top-cell.active {
        color: var(--primary);
        font-weight: 700;
        box-shadow: inset 0 -2px 0 var(--primary);
    }

    /* ── 우측 버튼 영역 ── */
    #hdr-actions {
        width: var(--btn-w);
        flex-shrink: 0;
        display: flex;
        align-items: center;
        justify-content: flex-end;
        gap: 0.4rem;
        white-space: nowrap;
    }

    /* ── 메가메뉴 래퍼:
         #hdr-bar relative 기준, top:100% → 흰 바 바로 아래
         width:100% → 뷰포트 가득 (hdr-bar는 w-full fixed이므로)
    ── */
    #mega-wrap {
        position: absolute;
        top: 100%;
        left: calc(-1 * var(--hdr-px)); /* hdr-inner padding 보정 */
        right: calc(-1 * var(--hdr-px));
        background: rgba(34, 96, 70, 0.94);
        backdrop-filter: blur(14px);
        -webkit-backdrop-filter: blur(14px);
        border-top: 1px solid rgba(255, 255, 255, 0.13);
        box-shadow: 0 10px 36px rgba(0, 0, 0, 0.18);

        opacity: 0;
        visibility: hidden;
        pointer-events: none;
        transition: opacity 0.17s ease, visibility 0.17s ease;
    }

    /* ── 메가메뉴: hdr-bar 전체에 호버하면 표시 ── */
    #hdr-bar:hover #mega-wrap {
        opacity: 1;
        visibility: visible;
        pointer-events: auto;
    }

    /* ── 메가메뉴 내부: hdr-inner와 동일한 구조 ── */
    #mega-inner {
        max-width: 1500px;
        margin: 0 auto;
        padding: 0 var(--hdr-px);
        display: flex;
        gap: var(--hdr-gap);
    }

    /* 로고 너비 + gap 만큼 띄우기 */
    #mega-logo-space {
        width: var(--logo-w);
        flex-shrink: 0;
    }

    /* 메가메뉴 그리드: nav-wrap 과 동일하게 flex:1 */
    #mega-grid {
        flex: 1;
        min-width: 0;
    }

    /* ── 메가메뉴 셀: 상단 탭과 동일하게 center 정렬 ── */
    .mega-cell {
        display: flex;
        flex-direction: column;
        align-items: center; /* ← 상단 탭 justify-content:center 와 축 일치 */
        justify-content: flex-start;
        padding: 1.4rem 0.25rem;
        gap: 0.55rem;
    }

    .mega-cell span {
        font-size: 0.8125rem;
        color: rgba(255, 255, 255, 0.8);
        cursor: pointer;
        white-space: nowrap;
        transition: color 0.14s;
        text-align: center;
    }

    .mega-cell span:hover {
        color: #fff;
        text-decoration: underline;
    }

    /* 우측 여백 (버튼 영역과 폭 맞춤) */
    #mega-btn-space {
        width: var(--btn-w);
        flex-shrink: 0;
    }

    /* ── 버튼 공통 ── */
    .btn-ghost {
        background: none;
        border: none;
        color: #475569;
        cursor: pointer;
        padding: 0.5rem 0.75rem;
        font-size: 0.875rem;
        font-weight: 500;
        transition: color 0.14s;
    }

    .btn-ghost:hover {
        color: var(--primary);
    }

    /*추가: 권한 전용 이동 버튼은 일반 헤더 메뉴와 구분되도록 작은 outline 버튼으로 표시 */
    .btn-role {
        background: #fff;
        border: 1px solid rgba(34, 96, 70, 0.45);
        color: var(--primary);
        padding: 0.42rem 0.62rem;
        border-radius: 9999px;
        font-size: 0.78rem;
        font-weight: 700;
        cursor: pointer;
        transition: background 0.14s, border-color 0.14s, color 0.14s;
    }

    .btn-role:hover {
        background: #f4f9f6;
        border-color: var(--primary);
    }

    .btn-pill {
        background: var(--primary);
        color: #fff;
        border: none;
        padding: 0.6rem 1.25rem;
        border-radius: 9999px;
        font-size: 0.875rem;
        font-weight: 600;
        cursor: pointer;
        transition: opacity 0.14s;
    }

    .btn-pill:hover {
        opacity: 0.87;
    }
</style>

<header id="site-header">
    <div id="hdr-bar">

        <!-- ── 1행: 흰 바 ── -->
        <div class="hdr-inner">

            <div id="hdr-logo">
                <a href="${pageContext.request.contextPath}/">우리집맵핑</a>
            </div>

            <div id="nav-wrap">
                <div class="nav-grid">
                    <div class="nav-top-cell">서비스 소개</div>
                    <div class="nav-top-cell">계약공고</div>
                    <div class="nav-top-cell">매물정보</div>
                    <div class="nav-top-cell">공공주택 정보</div>
                    <div class="nav-top-cell">공지사항</div>
                </div>
            </div>

            <div id="hdr-actions">
                <sec:authorize access="isAnonymous()">
                    <button type="button" id="loginFormBtn" class="btn-ghost">로그인</button>
                    <button type="button" id="joinFormBtn" class="btn-pill">회원가입</button>
                </sec:authorize>
                <sec:authorize access="isAuthenticated()">
                    <%-- 관리소장/admin은 관리사무소 버튼으로 대체하기 위해 주석 처리 --%>
                    <%-- <button type="button" id="myAptBtn" class="btn-ghost">🏢 나의 아파트</button> --%>

                    <%--  추가: 관리소장(ROLE_MNGR) / 중앙관리자(ROLE_ADMIN)는 헤더에서 관리사무소 페이지로 바로 이동 --%>
                    <sec:authorize access="hasAnyRole('ADMIN', 'MNGR')">
                        <button type="button" id="managerMainBtn" class="btn-role">관리사무소</button>
                    </sec:authorize>

                    <%-- 추가: 중앙관리자(ROLE_ADMIN)는 중앙관리자 화면으로 바로 이동 --%>
                    <sec:authorize access="hasRole('ADMIN')">
                        <button type="button" id="centralAdminBtn" class="btn-role">중앙관리</button>
                    </sec:authorize>

                    <%--추가: 일반 회원/입주민은 기존 나의 아파트 버튼 유지 --%>
                    <sec:authorize access="!hasAnyRole('ADMIN', 'MNGR')">
                        <button type="button" id="myAptBtn" class="btn-ghost">🏢 나의 아파트</button>
                    </sec:authorize>
                    <button type="button" id="myPageBtn" class="btn-pill">마이페이지</button>
                    <button type="button" id="logoutBtn" class="btn-ghost">로그아웃</button>
                    <form id="logoutForm" action="${pageContext.request.contextPath}/logout" method="post"
                          style="display:none;">
                        <sec:csrfInput/>
                    </form>
                </sec:authorize>
            </div>
        </div>

        <!-- ── 2행: 메가메뉴 (hdr-bar 기준 absolute) ── -->
        <div id="mega-wrap">
            <div id="mega-inner">

                <div id="mega-logo-space"></div>

                <div id="mega-grid">
                    <div class="nav-grid">

                        <div class="mega-cell">
                            <span><a href="${pageContext.request.contextPath}/main/intro.do">서비스 소개</a></span>
                        </div>

                        <div class="mega-cell">
                            <span><a href="${pageContext.request.contextPath}/contract/notice.do">계약 공고</a></span>
                            <span><a href="${pageContext.request.contextPath}/contract/history.do">청약 조회</a></span>
                        </div>

                        <div class="mega-cell">
                            <span><a href="${pageContext.request.contextPath}/rent/map">매물 지도</a></span>
                            <span><a href="${pageContext.request.contextPath}/rent/list">매물 목록</a></span>
                        </div>

                        <div class="mega-cell">
                            <span><a href="${pageContext.request.contextPath}/main/apt/list.do">단지 목록</a></span>
                            <%--<span><a href="${pageContext.request.contextPath}/main/apt/search.do">단지 검색</a></span>--%>
                            <span><a href="${pageContext.request.contextPath}/main/apt/map.do">지도 검색</a></span>
                            <span><a href="${pageContext.request.contextPath}/facility/history.do">단지 시설정보</a></span>
                            <span><a
                                    href="${pageContext.request.contextPath}/main/apt/dashboard.do">단지별 통계 조회</a></span>
                        </div>

                        <div class="mega-cell">
                            <span><a href="${pageContext.request.contextPath}/board/notice/list.do">공지사항</a></span>
                            <span><a href="${pageContext.request.contextPath}/apt/board/inqry/list.do">문의게시판</a></span>
                        </div>

                    </div>
                </div>

                <div id="mega-btn-space"></div>

            </div>
        </div>

    </div><!-- /hdr-bar -->

    <script src="${pageContext.request.contextPath}/js/common/conn.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</header>

<script>
    /* ── 로그아웃 / 나의 아파트 ── */
    document.addEventListener("DOMContentLoaded", () => {
        const myAptBtn = document.getElementById("myAptBtn");
        // 추가: 관리소장/admin 전용 관리사무소 페이지 이동 버튼
        const managerMainBtn = document.getElementById("managerMainBtn");
        //추가: admin 전용 중앙관리자 대시보드 이동 버튼
        const centralAdminBtn = document.getElementById("centralAdminBtn");
        const logoutBtn = document.getElementById("logoutBtn");

        if (myAptBtn) myAptBtn.addEventListener("click", openAptSelection);
        // 추가: /manager/main 진입 시 MNGR은 본인 사무소, ADMIN은 사무소 선택 화면으로 이동
        if (managerMainBtn) managerMainBtn.addEventListener("click", () => {
            location.href = "${pageContext.request.contextPath}/manager/main";
        });

        // 2026.05.11 수정: 중앙관리자 대시보드 리액트 페이지로 연결
        if (centralAdminBtn) centralAdminBtn.addEventListener("click", () => {
            location.href = "/adm/home";
        });

    });

    // 팝업창을 중앙에 띄우는 함수
    function openAptSelection() {
        const width = 600;
        const height = 400;
        const left = (window.screen.width / 2) + 100;
        const top = (window.screen.height / 2) - height;

        const url = "${pageContext.request.contextPath}/resident/myApt";
        const features = "width=" + width +
            ",height=" + height +
            ",left=" + left +
            ",top=" + top +
            ",resizable=yes,scrollbars=yes";

        // 'aptSelectionPopup'이라는 이름의 팝업창을 엽니다.
        window.open(url, "aptSelectionPopup", features);
    }

    function selectApt(aptCmplexNo) {
        // 1. 나를 열어준 부모창(opener)의 주소를 이동시킴
        // 팁: 부모창이 이미 메인이라면 이동하고, 아니면 메인으로 보냅니다.
        if (window.opener && !window.opener.closed) {
            window.opener.location.href = "${pageContext.request.contextPath}/apt/main/" + aptCmplexNo;
            // 2. 팝업은 임무 완료 후 퇴장
            window.close();
        } else {
            alert("부모 창을 찾을 수 없습니다. 메인 페이지를 새로고침 해주세요.");
        }
    }
</script>
<jsp:include page="/WEB-INF/views/include/websocket.jsp"/>
