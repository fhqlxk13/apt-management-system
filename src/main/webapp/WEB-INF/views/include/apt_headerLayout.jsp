<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<meta name="_csrf_header" content="${_csrf.headerName}"/>
<%-- 서버가 정해준 이름(편지봉투) --%>
<meta name="_csrf" content="${_csrf.token}"/>
<%-- 실제 1회용 암호 값(편지) --%>


<style>
    /*
       FOUC 방지용 즉시 적용 CSS
       FOUC란?
       CSS가 늦게 적용되면서 화면이 잠깐 깨져 보이는 현상.
       지금 알림톡 버튼이 크게 보였다 사라지는 현상이 여기에 해당함.
    */
    /* 페이지 로딩 중 카카오 모달이 순간 보이는 현상 방지 */
    #kakaoModal {
        display: none !important;
    }

    #kakaoModal.kakao-open {
        display: flex !important;
    }

    /* 로딩 중 카카오 버튼 깨짐 방지 */
    #kakaoAlimBtn.kakao-ready {
        visibility: hidden !important;
    }
    #kakaoAlimBtn,
    .kakao-alim-img-btn {
        width: 88px !important;
        height: 34px !important;
        padding: 0 !important;
        border: none !important;
        background: transparent !important;
        display: inline-flex !important;
        align-items: center !important;
        justify-content: center !important;
        position: relative !important;
        overflow: visible !important;
        vertical-align: middle !important;
        margin-right: 12px !important;
    }

    #kakaoAlimBtn img,
    .kakao-bell-img {
        width: 88px !important;
        height: auto !important;
        max-width: 88px !important;
        max-height: none !important;
        object-fit: contain !important;
        display: block !important;
    }

    .kakao-ready {
        visibility: hidden;
    }

    .kakao-badge {
        position: absolute !important;
        top: -6px !important;
        right: -6px !important;
        min-width: 16px !important;
        height: 16px !important;
        line-height: 16px !important;
        font-size: 10px !important;
        border-radius: 50% !important;
    }
</style>


<header class="site-header">
    <!-- 헤더 부터 푸터까지 사용할 수 있도록 스코프 지정 -->
    <c:set var="apt" value="${aptInfo.aptComplexInfo}" scope="request"/>
    <c:set var="mgmtOffice" value="${aptInfo.mgmtOfficeInfo}" scope="request"/>
    <c:set var="board" value="${aptInfo.annBoardPostInfoList}" scope="request"/>

    <div class="header-top">
        <a href="${pageContext.request.contextPath}/apt/main/${apt.aptCmplexNo}" class="logo">
            <%-- 로고 아이콘 --%>
            <svg class="logo-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"
                 stroke-linecap="round" stroke-linejoin="round">
                <path d="M3 9.5L12 3l9 6.5V20a1 1 0 01-1 1H4a1 1 0 01-1-1V9.5z"/>
                <path d="M9 21V12h6v9"/>
            </svg>
            <div class="logo-text">
                <span class="ko">${apt.aptCmplexNm}</span>
                <span class="en">MY HOME MAPPING</span>
            </div>
        </a>

        <div class="header-actions">

            <%-- 카카오 알림 --%>
                <%-- 카카오 알림 이미지 버튼 --%>
<%--                <button type="button"--%>
<%--                        id="kakaoAlimBtn"--%>
<%--                        class="kakao-alim-img-btn kakao-ready">--%>
<%--                    <img class="kakao-bell-img"--%>
<%--                         src="${pageContext.request.contextPath}/img/kakaoAlim.png"--%>
<%--                         alt="카카오알림"--%>
<%--                         width="88">--%>
<%--                    <span class="kakao-badge">--%>
<%--                        <c:out value="${empty unreadCount ? 0 : unreadCount}"/>--%>
<%--                    </span>--%>

<%--                </button>--%>
                <!-- 카카오톡 모달 -->
                <div id="kakaoModal" class="kakao-modal">
                    <div class="kakao-talk-window">

                        <div class="kakao-window-top">

                            <button type="button"
                                    id="kakaoMinBtn"
                                    class="kakao-window-btn">
                                <svg viewBox="0 0 24 24" class="kakao-window-svg">
                                    <path d="M5 12H19"/>
                                </svg>
                            </button>

                            <button type="button" class="kakao-window-btn">
                                <svg viewBox="0 0 24 24" class="kakao-window-svg">
                                    <rect x="7" y="7" width="10" height="10"/>
                                </svg>
                            </button>

                            <button type="button"
                                    id="kakaoCloseBtn"
                                    class="kakao-window-btn">
                                <svg viewBox="0 0 24 24" class="kakao-window-svg">
                                    <path d="M6 6L18 18"/>
                                    <path d="M18 6L6 18"/>
                                </svg>
                            </button>

                        </div>

                        <div class="kakao-talk-header">
                            <div class="kakao-profile">
                                <div class="kakao-profile-img">
                                    <img class="kakao-profile-photo"
                                         src="${pageContext.request.contextPath}/img/kakaoManager.png"
                                         alt="관리사무소">
                                </div>
                                <div class="kakao-profile-name">아파트 관리사무소</div>
                            </div>

                            <div class="kakao-header-icons">

                                <!-- 돋보기 아이콘 -->
                                <svg class="kakao-search-svg"
                                     viewBox="0 0 24 24"
                                     aria-hidden="true">
                                    <circle cx="10" cy="10" r="6"/>
                                    <path d="M14.5 14.5L20 20"/>
                                </svg>

                                <!-- 메뉴 아이콘 -->
                                <svg class="kakao-menu-svg"
                                     viewBox="0 0 24 24"
                                     aria-hidden="true">
                                    <path d="M4 6H20"/>
                                    <path d="M4 12H20"/>
                                    <path d="M4 18H20"/>
                                </svg>

                            </div>
                        </div>

                        <div class="kakao-date-pill" id="kakaoDatePill">
                            <svg width="12"
                                 height="12"
                                 viewBox="0 0 24 24"
                                 fill="none"
                                 stroke="#666"
                                 stroke-width="2">
                                <rect x="3" y="4" width="18" height="18" rx="2"/>
                                <line x1="16" y1="2" x2="16" y2="6"/>
                                <line x1="8" y1="2" x2="8" y2="6"/>
                                <line x1="3" y1="10" x2="21" y2="10"/>
                            </svg>
                            <span id="kakaoDateText"></span>
                        </div>

                        <div id="kakaoAlimList" class="kakao-chat-body">
                            <!-- JS로 알림 출력 -->
                        </div>

                        <div class="kakao-input-area">
                            <div class="kakao-input-placeholder">메시지 입력</div>

                            <div class="kakao-input-bottom">
                                <div class="kakao-input-icons">

                                    <!-- 실제 카카오톡 파일 아이콘 느낌 -->
                                    <svg class="kakao-file-svg"
                                         viewBox="0 0 24 24">

                                        <path d="M4 3H15L20 8V20H4Z"/>
                                        <path d="M15 3V8H20"/>

                                    </svg>

                                    <!-- 플러스 아이콘 -->
                                    <svg class="kakao-plus-svg"
                                         viewBox="0 0 24 24"
                                         aria-hidden="true">
                                        <path d="M7 4V17H20"/>
                                        <path d="M4 7H17V20"/>
                                    </svg>

                                </div>

                                <div class="kakao-send-box">
                                    <span class="kakao-slider"></span>
                                    <button type="button">전송</button>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>

            <sec:authorize access="isAuthenticated()">
                <span class="header-user-name">
                    <sec:authentication property="principal.member.userNm"/>
                </span>
                <span class="header-user-suffix">님</span>
                <a href="/member/myPageAuth.do" class="btn-filled">마이페이지</a>
                <button type="button" id="logoutBtn" class="btn-outline">로그아웃</button>
                <%-- 로그아웃을 위한 히든 폼 --%>
                <form id="logoutForm" action="/logout" method="post" style="display: none;">
                    <sec:csrfInput/>
                </form>
            </sec:authorize>

            <sec:authorize access="isAnonymous()">
                <a href="/login.do" class="btn-outline">로그인</a>
                <button type="button" class="btn-filled" id="joinFormBtn">회원가입</button>
            </sec:authorize>
        </div>
    </div>

    <nav class="header-nav">
        <div class="nav-item ${fn:contains(pageContext.request.requestURI, '/resident/manage') ? 'active' : ''}">
            <span>우리아파트
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
            <path d="M6 9l6 6 6-6"/>
            </svg>
            </span>
            <div class="slim-drop">
                <a href="${pageContext.request.contextPath}/apt/main/aptInfo/${apt.aptCmplexNo}">아파트정보</a>
                <a href="${pageContext.request.contextPath}/resident/calendar/${apt.aptCmplexNo}">아파트일정</a>
                <a href="${pageContext.request.contextPath}/apt/main/mgmtInfo/${apt.aptCmplexNo}">관리사무소정보</a>
                <%--<a href="${pageContext.request.contextPath}/resident/manage/operation">운영정보공개</a>--%>
                <a href="${pageContext.request.contextPath}/resident/manage/facility/${apt.aptCmplexNo}">시설관리이력</a>
            </div>
        </div>

        <div class="nav-item ${fn:contains(pageContext.request.requestURI, '/resident/bill') ? 'active' : ''}">
            <span>아파트관리비<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path
                    d="M6 9l6 6 6-6"/></svg></span>
            <div class="slim-drop">
                <a href="${pageContext.request.contextPath}/resident/bill/inquiry/${apt.aptCmplexNo}">관리비조회</a>
                <a href="${pageContext.request.contextPath}/resident/bill/guide/${aptCmplexNo}">납부안내</a>
                <%--<a href="${pageContext.request.contextPath}/resident/bill/auto">자동이체신청</a>--%>
                <a href="${pageContext.request.contextPath}/resident/bill/receipt/${aptCmplexNo}">납부영수증</a>
            </div>
        </div>

        <div class="nav-item ${fn:contains(pageContext.request.requestURI, '/resident/service') ? 'active' : ''}">
            <span>생활지원서비스<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path
                    d="M6 9l6 6 6-6"/></svg></span>
            <div class="slim-drop">
                <a href="${pageContext.request.contextPath}/resident/service/moving/${aptCmplexNo}">전입/전출신고</a>
                <a href="/resident/service/car/${aptCmplexNo}">차량등록</a>
                <a href="${pageContext.request.contextPath}/resident/service/visitor/${aptCmplexNo}">방문차량등록</a>
<%--                <a href="${pageContext.request.contextPath}/resident/service/facility">편의시설예약</a>--%>
                <a href="${pageContext.request.contextPath}/resident/publicFacility/reservation/${apt.aptCmplexNo}">편의시설예약</a>
                <a href="${pageContext.request.contextPath}/resident/publicFacility/myReservation/${apt.aptCmplexNo}">예약내역</a>
            </div>
        </div>

        <div class="nav-item ${fn:contains(pageContext.request.requestURI, '/resident/complaint') ? 'active' : ''}">
            <span>민원접수<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path
                    d="M6 9l6 6 6-6"/></svg></span>
            <div class="slim-drop">
                <a href="/apt/complaint/apply.do/${apt.aptCmplexNo}">내 민원 및 신청</a>
                <a href="/apt/complaint/list/${apt.aptCmplexNo}">단지 민원 내역</a>
                <a href="${pageContext.request.contextPath}/resident/complaint/live">실시간문의</a>
            </div>
        </div>

        <div class="nav-item ${fn:contains(pageContext.request.requestURI, '/resident/vote') ? 'active' : ''}">
            <span>전자투표및설문<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path
                    d="M6 9l6 6 6-6"/></svg></span>
            <div class="slim-drop">
                <a href="${pageContext.request.contextPath}/resident/survey/list/${aptCmplexNo}">투표 및 설문조사</a>
            </div>
        </div>

        <div class="nav-item ${fn:contains(pageContext.request.requestURI, '/resident/board') ? 'active' : ''}">
            <span>입주민게시판<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path
                    d="M6 9l6 6 6-6"/></svg></span>
            <div class="slim-drop">
                <a href="${pageContext.request.contextPath}/resident/board/notice/${aptCmplexNo}">공지사항</a>
                <a href="${pageContext.request.contextPath}/resident/board/free/list/${aptCmplexNo}">자유게시판</a>
                <a href="${pageContext.request.contextPath}/resident/board/chat/${aptCmplexNo}">그룹채팅방</a>
            </div>
        </div>

        <div class="nav-item ${fn:contains(pageContext.request.requestURI, '/resident/stats') ? 'active' : ''}">
            <span>우리아파트통계<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path
                    d="M6 9l6 6 6-6"/></svg></span>
            <div class="slim-drop">
                <%-- 단지번호 포함 URL (URL 유실 시 404 방지) --%>
                <a href="${pageContext.request.contextPath}/resident/stats/custom/${aptCmplexNo}">우리집맞춤통계</a>
                <a href="${pageContext.request.contextPath}/resident/stats/apartment/${aptCmplexNo}">아파트통계</a>
            </div>
        </div>

        <button class="nav-all-btn" id="allMenuBtn" type="button" aria-label="전체메뉴">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round">
                <line x1="3" y1="6" x2="21" y2="6"/>
                <line x1="3" y1="12" x2="21" y2="12"/>
                <line x1="3" y1="18" x2="21" y2="18"/>
            </svg>
        </button>
    </nav>
    <script src="${pageContext.request.contextPath}/js/common/conn.js"></script>
</header>

<div class="all-menu-overlay" id="allMenuOverlay" role="dialog" aria-modal="true">
    <div class="all-menu-panel">
        <div class="all-menu-header">
            <div class="all-menu-title">${apt.aptCmplexNm} 전체메뉴</div>
            <button class="all-menu-close" id="allMenuClose" type="button">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round">
                    <line x1="18" y1="6" x2="6" y2="18"/>
                    <line x1="6" y1="6" x2="18" y2="18"/>
                </svg>
            </button>
        </div>

        <div class="all-menu-grid">
            <div class="all-menu-section">
                <div class="all-menu-section-title">관리사무소</div>
                <ul>
                    <li><a href="${pageContext.request.contextPath}/apt/main/aptInfo/${apt.aptCmplexNo}">우리아파트</a></li>
                    <li><a href="${pageContext.request.contextPath}/resident/calendar/${apt.aptCmplexNo}">우리단지일정</a></li>
                    <li><a href="${pageContext.request.contextPath}/apt/main/mgmtInfo/${apt.aptCmplexNo}">관리사무소 소개</a></li>
                    <li><a href="${pageContext.request.contextPath}/resident/manage/operation">운영정보공개</a></li>
                    <li><a href="${pageContext.request.contextPath}/resident/manage/facility/${apt.aptCmplexNo}">시설관리이력</a></li>
                    <li><a href="${pageContext.request.contextPath}/resident/manage/favorite">즐겨찾기</a></li>
                </ul>
            </div>

            <div class="all-menu-section">
                <div class="all-menu-section-title">아파트관리비</div>
                <ul>
                    <li><a href="${pageContext.request.contextPath}/resident/bill/inquiry/${apt.aptCmplexNo}">관리비조회</a></li>
                    <li><a href="${pageContext.request.contextPath}/resident/bill/guide">납부안내</a></li>
                    <li><a href="${pageContext.request.contextPath}/resident/bill/auto">자동이체신청</a></li>
                    <li><a href="${pageContext.request.contextPath}/resident/bill/receipt">납부영수증</a></li>
                </ul>
            </div>

            <div class="all-menu-section">
                <div class="all-menu-section-title">생활지원서비스</div>
                <ul>
                    <li><a href="${pageContext.request.contextPath}/resident/service/moving">전입/전출신고</a></li>
                    <li><a href="${pageContext.request.contextPath}/resident/service/car/${aptCmplexNo}">차량등록</a></li>
                    <li><a href="${pageContext.request.contextPath}/resident/service/visitor/${aptCmplexNo}">방문차량등록</a></li>
                    <li><a href="${pageContext.request.contextPath}/resident/publicFacility/reservation/${apt.aptCmplexNo}">편의시설예약</a>
                    </li>
                </ul>
            </div>

            <div class="all-menu-section">
                <div class="all-menu-section-title">민원접수</div>
                <ul>
                    <li><a href="/apt/complaint/apply.do/${apt.aptCmplexNo}">민원신청</a></li>
                    <li><a href="${pageContext.request.contextPath}/resident/complaint/live">실시간문의</a></li>
                    <li><a href="${pageContext.request.contextPath}/resident/complaint/chatbot">챗봇민원접수</a></li>
                    <li><a href="${pageContext.request.contextPath}/resident/complaint/status">민원접수현황</a></li>
                </ul>
            </div>

            <div class="all-menu-section">
                <div class="all-menu-section-title">전자투표및설문</div>
                <ul>
                    <li><a href="${pageContext.request.contextPath}/resident/vote">입주민 투표</a></li>
                    <li><a href="${pageContext.request.contextPath}/resident/survey">설문조사</a></li>
                </ul>
            </div>

            <div class="all-menu-section">
                <div class="all-menu-section-title">입주민게시판</div>
                <ul>
                    <li><a href="${pageContext.request.contextPath}/resident/board/notice/${aptCmplexNo}">공지사항</a></li>
                    <li><a href="${pageContext.request.contextPath}/resident/board/free/list/${aptCmplexNo}">자유게시판</a></li>
                    <li><a href="${pageContext.request.contextPath}/resident/board/chat">그룹채팅방</a></li>
                </ul>
            </div>

            <div class="all-menu-section">
                <div class="all-menu-section-title">우리아파트통계</div>
                <ul>
                    <%-- 단지번호 포함 URL (URL 유실 시 404 방지) --%>
                    <li><a href="${pageContext.request.contextPath}/resident/stats/custom/${aptCmplexNo}">우리집맞춤통계</a></li>
                    <li><a href="${pageContext.request.contextPath}/resident/stats/apartment/${aptCmplexNo}">아파트통계</a></li>
                </ul>
            </div>
        </div>
    </div>
</div>

<style>
    /* =========================
       카카오 알림 버튼
       ========================= */
    .kakao-alim-img-btn{
        position:relative;
        border:none;
        background:transparent;
        cursor:pointer;

        padding:0;
        margin-right:12px;

        width:88px;
        height:30px;

        display:flex;
        align-items:center;
        justify-content:center;
    }

    .kakao-bell-img{
        width:88px;
        height:auto;
        display:block;
    }

    .kakao-badge{
        position:absolute;
        top:-7px;
        right:-4px;

        min-width:14px;
        height:14px;
        padding:0 4px;

        display:flex;
        align-items:center;
        justify-content:center;

        border-radius:999px;
        background:#ff3b30;
        color:#fff;

        font-size:9px;
        font-weight:700;
        line-height:1;
    }


    /* =========================
       카카오톡 모달 배경
       ========================= */
    .kakao-modal{
        position:fixed;
        inset:0;
        display:none;
        justify-content:center;
        align-items:center;
        background:rgba(0,0,0,.38);
        z-index:5000;
    }

    /* =========================
       카카오톡 PC 창
       ========================= */
    .kakao-talk-window{
        width:385px;
        height:535px;
        background:#b9d0e3;
        border-radius:8px;
        overflow:hidden;
        display:flex;
        flex-direction:column;
        box-shadow:0 15px 40px rgba(0,0,0,.25);
        font-family:"Malgun Gothic","맑은 고딕",sans-serif;
        position:relative; /* JS로 left/top 이동시키기 위한 기준 */
    }

    /* =========================
       상단 윈도우 버튼 영역
       왼쪽 실제 카톡처럼 얇고 낮게
       ========================= */
    /* =========================
   상단 윈도우 버튼 영역
   ========================= */
    .kakao-window-top{
        height:26px;

        display:flex;
        justify-content:flex-end;
        align-items:center;

        gap:2px;          /* 기존 4px → 2px */

        padding:0 8px;

        flex-shrink:0;
        cursor:move;
        user-select:none;
    }

    .kakao-window-btn{
        border:none;
        background:none;
        cursor:pointer;

        width:24px;       /* 기존 20px → 24px */
        height:24px;      /* 기존 20px → 24px */

        padding:0;

        display:flex;
        align-items:center;
        justify-content:center;
    }

    .kakao-window-svg{
        width:18px;       /* 기존 15px → 18px */
        height:18px;

        fill:none;
        stroke:#4f5b61;
        stroke-width:2;

        stroke-linecap:round;
        stroke-linejoin:round;
    }

    /* =========================
       상단 프로필 영역
       ========================= */
    .kakao-talk-header{
        height:61px;
        display:flex;
        justify-content:space-between;
        align-items:center;
        padding:0 18px;
        flex-shrink:0;
    }

    .kakao-profile{
        display:flex;
        align-items:center;
        gap:10px;
    }

    .kakao-profile-img,
    .kakao-chat-profile-img{
        width:36px;
        height:36px;
        border-radius:50%;
        background:#fff;
        display:flex;
        align-items:center;
        justify-content:center;
        overflow:hidden;
        flex-shrink:0;
    }

    .kakao-profile-photo{
        width:28px;
        height:28px;
        border-radius:50%;
        object-fit:cover;
        display:block;
    }

    .kakao-profile-name{
        font-size:14px;
        font-weight:400;
        letter-spacing:-0.5px;
    }

    /* =========================
       검색 / 메뉴 아이콘
       ========================= */
    .kakao-header-icons{
        display:flex;
        align-items:center;
        gap:14px; /* 돋보기와 메뉴 사이 간격 */
    }

    .kakao-search-svg{
        width:20px;
        height:20px;

        fill:none;
        stroke:#111;
        stroke-width:1.8;
        stroke-linecap:round;
        stroke-linejoin:round;
    }

    .kakao-menu-svg{
        width:22px;
        height:22px;

        fill:none;
        stroke:#111;
        stroke-width:1.8;
        stroke-linecap:round;
    }

    /* =========================
       날짜 pill
       기존 이모지 달력 제거 → 회색 CSS 아이콘
       ========================= */
    .kakao-date-pill{
        align-self:center;
        display:flex;
        align-items:center;
        gap:6px;
        background:rgba(135,160,180,.45);
        border-radius:999px;
        padding:5px 12px;
        font-size:11px;
        color:#202020;
        margin:4px 0 13px;
        flex-shrink:0;
        letter-spacing:-0.4px;
    }

    .kakao-date-icon{
        width:13px;
        height:13px;
        border:1.5px solid #555;
        border-radius:2px;
        display:none;
        position:relative;
        box-sizing:border-box;
    }

    .kakao-date-icon::before{
        content:"";
        position:absolute;
        left:-1.5px;
        top:3px;
        width:13px;
        height:1.5px;
        background:#555;
    }

    .kakao-date-icon::after{
        content:"";
        position:absolute;
        left:3px;
        top:-3px;
        width:6px;
        height:3px;
        border-left:1.5px solid #555;
        border-right:1.5px solid #555;
    }

    /* =========================
       채팅 영역
       ========================= */
    .kakao-chat-body{
        flex:1;
        overflow-y:auto;
        padding:0 18px 10px;
        box-sizing:border-box;
    }

    .kakao-chat-body::-webkit-scrollbar{
        width:7px;
    }

    .kakao-chat-body::-webkit-scrollbar-thumb{
        background:rgba(0,0,0,.25);
        border-radius:10px;
    }

    .kakao-chat-body::-webkit-scrollbar-track{
        background:rgba(255,255,255,.18);
    }

    .kakao-chat-row{
        display:flex;
        align-items:flex-start;
        gap:9px;
        margin-bottom:14px;
    }

    .kakao-chat-profile-img{
        width:32px;
        height:32px;
    }

    .kakao-chat-profile-img .kakao-profile-photo{
        width:32px;
        height:32px;
    }

    .kakao-chat-main{
        max-width:245px;
    }

    .kakao-chat-sender{
        font-size:11px;
        margin-bottom:4px;
        color:#222;
        letter-spacing:-0.3px;
    }

    .kakao-chat-bubble-wrap{
        display:flex;
        align-items:flex-end;
        gap:6px;
    }

    .kakao-chat-bubble{
        background:#fff;
        padding:9px 11px;
        border-radius:3px;
        font-size:11px;
        line-height:1.4;
        color:#111;
        letter-spacing:-0.3px;
        word-break:keep-all;
    }

    /* 링크가 있는 말풍선만 클릭 가능 */
    .kakao-chat-row.is-link .kakao-chat-bubble {
        cursor: pointer;
    }

    .kakao-chat-row.is-link:not(.is-read) .kakao-chat-bubble:hover {
         background: #f7f7f7;
         text-decoration: underline;
         text-decoration-color: #c8c8c8;
     }

    /* 읽은 알림 */
    .kakao-chat-row.is-read .kakao-chat-bubble {
        opacity: 0.78;
    }

    /* 읽은 알림은 밑줄 효과 제거 */
    .kakao-chat-row.is-read .kakao-chat-bubble:hover {
        text-decoration: none;
        box-shadow: none;
        background: #fff;
    }

    /* 확인 표시 */
    .kakao-chat-row.is-read .kakao-chat-bubble::after {
        content: "✓ 확인";
        display: block;
        text-align: right;
        margin-top: 6px;

        font-size: 10px;
        color: #999;
        font-weight: 500;
    }

    /* 오른쪽 아래에 '예약내역 보기' 표시 */
    .kakao-chat-row.is-link .kakao-chat-bubble::after {
        content: "예약내역 보기 >";
        display: block;
        margin-top: 8px;
        font-size: 10px;
        color: #2b5c44;
        font-weight: 700;
    }

    .kakao-chat-time{
        font-size:10px;
        color:#555;
        white-space:nowrap;
        margin-bottom:2px;
    }

    /* =========================
       입력창
       왼쪽 실제 카톡처럼 낮게 정렬
       ========================= */
    .kakao-input-area{
        height:115px;

        background:#fff;

        padding:14px 14px 12px;

        box-sizing:border-box;
        flex-shrink:0;
    }

    .kakao-input-placeholder{
        color:#8d8d8d;
        font-size:13px;
        font-weight:400;
        margin-bottom:36px; /* 입력창 높이 증가에 맞춤 */
        letter-spacing:-0.3px;
    }

    .kakao-input-bottom{
        display:flex;
        justify-content:space-between;
        align-items:center;
    }

    .kakao-input-icons{
        display:flex;
        align-items:center;
        gap:16px;
    }

    /* =========================
   실제 카카오톡 느낌 SVG 아이콘
   ========================= */

    .kakao-file-svg,
    .kakao-plus-svg{
        stroke:#707070;
    }

    .kakao-file-svg{
        width:18px;
        height:18px;

        fill:none;
        stroke:#707070;
        stroke-width:1.45;
    }

    .kakao-plus-svg{
        width:21px;
        height:21px;

        fill:none;
        stroke:#707070;
        stroke-width:1.45;
    }

    .kakao-input-icons{
        display:flex;
        align-items:center;
        gap:12px;

        margin-top:6px;
    }

    .kakao-send-box{
        display:flex;
        align-items:center;
        gap:14px;
    }

    .kakao-slider{
        width:56px;
        height:1px;
        background:#bbb;
        position:relative;
    }

    .kakao-slider::after{
        content:"";
        position:absolute;
        right:0;
        top:-5px;
        width:11px;
        height:11px;
        border:1px solid #bbb;
        border-radius:50%;
        background:#fff;
    }

    .kakao-send-box button{
        border:none;
        background:#f1f1f1;
        color:#aaa;
        border-radius:5px;
        padding:7px 14px;
        font-size:13px;
        letter-spacing:-0.3px;
    }

    .header-actions {
        display: flex;
        align-items: center;
        gap: 12px;
    }

    .header-user-name {
        display: inline-flex;
        align-items: center;
        font-size: 1.2em;
        color: blue;
        font-weight: bold;
        line-height: 1;
    }

    .header-user-suffix {
        display: inline-flex;
        align-items: center;
        font-size: 16px;
        line-height: 1;
        margin-left: -8px;
    }

</style>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="${pageContext.request.contextPath}/js/common/resident-swal.js"></script>
<script type="module">

    const allBtn = document.getElementById('allMenuBtn');
    const overlay = document.getElementById('allMenuOverlay');
    const closeBtn = document.getElementById('allMenuClose');

    function openMenu() {
        overlay.classList.add('open');
        document.body.style.overflow = 'hidden';
    }

    function closeMenu() {
        overlay.classList.remove('open');
        document.body.style.overflow = '';
    }

    if (allBtn) allBtn.addEventListener('click', openMenu);
    if (closeBtn) closeBtn.addEventListener('click', closeMenu);

    if (overlay) {
        overlay.addEventListener('click', function (e) {
            if (e.target === overlay) closeMenu();
        });
    }

    document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape') closeMenu();
    });

    /* 카카오 알림 */
    const kakaoAlimBtn = document.getElementById("kakaoAlimBtn");
    const kakaoModal = document.getElementById("kakaoModal");
    const kakaoCloseBtn = document.getElementById("kakaoCloseBtn");
    const kakaoMinBtn = document.getElementById("kakaoMinBtn");
    const kakaoAlimList = document.getElementById("kakaoAlimList");
    const kakaoBadge = document.querySelector(".kakao-badge");

    const csrfHeader = document.querySelector("meta[name='_csrf_header']")?.content;
    const csrfToken = document.querySelector("meta[name='_csrf']")?.content;

    const kakaoTalkWindow = document.querySelector(".kakao-talk-window");
    const kakaoWindowTop = document.querySelector(".kakao-window-top");

    let isDragging = false;
    let startX = 0;
    let startY = 0;
    let currentLeft = 0;
    let currentTop = 0;

    /*
 * 최소화 버튼
 * 화면에서 카카오 모달창을 숨김
 */
    if (kakaoMinBtn) {
        kakaoMinBtn.addEventListener("click", async () => {
            kakaoModal.style.display = "none";
            // 닫은 뒤 알림 개수 다시 조회
            await loadKakaoUnreadCount();
        });
    }

    /*
     * 드래그 기능
     * 드래그란?
     * 마우스로 클릭한 상태에서 움직이는 동작입니다.
     * 왜 사용?
     * 사용자가 모달창 위치를 직접 옮길 수 있게 하기 위해 사용합니다.
     */
    if (kakaoTalkWindow && kakaoWindowTop) {

        kakaoWindowTop.addEventListener("mousedown", function (e) {

            // 닫기/최소화/최대화 버튼을 누를 때는 드래그하지 않음
            if (e.target.closest(".kakao-window-btn")) {
                return;
            }

            isDragging = true;

            const rect = kakaoTalkWindow.getBoundingClientRect();

            startX = e.clientX;
            startY = e.clientY;
            currentLeft = rect.left;
            currentTop = rect.top;

            kakaoModal.style.justifyContent = "flex-start";
            kakaoModal.style.alignItems = "flex-start";

            kakaoTalkWindow.style.position = "fixed";
            kakaoTalkWindow.style.left = currentLeft + "px";
            kakaoTalkWindow.style.top = currentTop + "px";
        });

        document.addEventListener("mousemove", function (e) {
            if (!isDragging) return;

            const moveX = e.clientX - startX;
            const moveY = e.clientY - startY;

            kakaoTalkWindow.style.left = (currentLeft + moveX) + "px";
            kakaoTalkWindow.style.top = (currentTop + moveY) + "px";
        });

        document.addEventListener("mouseup", function () {
            isDragging = false;
        });
    }

    /*
     * 알림 개수 조회
     * 왜 사용?
     * DB의 READ_YN = 'N'인 알림 개수를 헤더 뱃지에 보여주기 위해 사용합니다.
     */
    async function loadKakaoUnreadCount() {
        const response = await fetch("${pageContext.request.contextPath}/resident/kakaoAlim/count");
        const count = await response.json();

        kakaoBadge.textContent = count;
    }

    /*
     * 카카오톡 시간 표시 형식으로 변환
     * 예: 2026-06-01 15:44:00 -> 오후 3:44
     */
    function formatKakaoTime(sndDttm) {
        if (!sndDttm) return "";

        const date = new Date(sndDttm.replace(" ", "T"));

        let hour = date.getHours();
        const minute = String(date.getMinutes()).padStart(2, "0");
        const ampm = hour < 12 ? "오전" : "오후";

        hour = hour % 12;
        if (hour === 0) hour = 12;

        return ampm + " " + hour + ":" + minute;
    }

    /*
     * 오늘 날짜를
     * 2026년 6월 1일 월요일
     * 형식으로 반환
     */
    function getTodayLabel() {

        const now = new Date();

        const weekNames = [
            "일요일",
            "월요일",
            "화요일",
            "수요일",
            "목요일",
            "금요일",
            "토요일"
        ];

        return now.getFullYear() + "년 "
            + (now.getMonth() + 1) + "월 "
            + now.getDate() + "일 "
            + weekNames[now.getDay()];
    }

    /*
     * 알림 목록 조회
     * 왜 사용?
     * 사용자가 알림 버튼을 클릭했을 때 DB에 저장된 알림 내용을 카카오톡 화면처럼 보여주기 위해 사용합니다.
     */
    async function loadKakaoAlimList() {
        const response = await fetch("${pageContext.request.contextPath}/resident/kakaoAlim/list");
        const list = await response.json();

        kakaoAlimList.innerHTML = "";

        if (!list || list.length === 0) {
            kakaoAlimList.innerHTML = `
            <div style="padding:20px; text-align:center; color:#777;">

            </div>
        `;
            return;
        }

        const welcomeItem = document.createElement("div");
        welcomeItem.className = "kakao-chat-row";
        welcomeItem.innerHTML = `
                <div class="kakao-chat-profile-img">
                    <img class="kakao-profile-photo"
                         src="${pageContext.request.contextPath}/img/kakaoManager.png"
                         alt="관리사무소">
                </div>

                <div class="kakao-chat-main">
                    <div class="kakao-chat-sender">아파트 관리사무소</div>

                    <div class="kakao-chat-bubble-wrap">
                        <div class="kakao-chat-bubble">
                            '아파트 관리사무소' 채널을 추가해<br>
                            주셔서 감사합니다.<br>
                            앞으로 다양한 소식과 혜택/정보를<br>
                            메시지로 받으실 수 있습니다.<br><br>
                            채널 추가 일시(한국시간 기준): 2026년 06월 01일 03:26<br>
                            수신거부: 홈&gt;채널 차단
                        </div>
                        <div class="kakao-chat-time">오전 3:26</div>
                    </div>
                </div>
            `;
        kakaoAlimList.appendChild(welcomeItem);

        list.forEach(alim => {
            const item = document.createElement("div");
            item.className = "kakao-chat-row";

            if (alim.linkUrl) {
                item.classList.add("is-link");
                item.title = "클릭하면 예약내역으로 이동합니다";
            }

            item.innerHTML = `
                                <div class="kakao-chat-profile-img">
                                    <img class="kakao-profile-photo"
                                         src="${pageContext.request.contextPath}/img/kakaoManager.png"
                                         alt="관리사무소">
                                </div>

                                <div class="kakao-chat-main">
                                    <div class="kakao-chat-sender">아파트 관리사무소</div>

                                    <div class="kakao-chat-bubble-wrap">
                                        <div class="kakao-chat-bubble"></div>
                                        <div class="kakao-chat-time">` + formatKakaoTime(alim.sndDttm) + `</div>
                                    </div>
                                </div>
                            `;


            const bubble = item.querySelector(".kakao-chat-bubble");

            bubble.innerHTML = alim.alimCn.replace(/\n/g, "<br>");

            if (alim.readYn === "Y") {
                item.classList.add("is-read");
            }

            if (alim.linkUrl) {
                item.classList.add("is-link");
                bubble.title = "클릭하면 예약내역으로 이동합니다";

                bubble.addEventListener("click", async () => {
                    await fetch("${pageContext.request.contextPath}/resident/kakaoAlim/" + alim.alimNo + "/read", {
                        method: "POST",
                        headers: {
                            [csrfHeader]: csrfToken
                        }
                    });

                    item.classList.add("is-read");

                    location.href = "${pageContext.request.contextPath}" + alim.linkUrl;
                });
            }

            kakaoAlimList.appendChild(item);
        });
    }

    if (kakaoAlimBtn) {
        kakaoAlimBtn.addEventListener("click", async () => {
            await loadKakaoAlimList();
            const datePill = document.getElementById("kakaoDatePill");

            if (datePill) {
                datePill.innerHTML = `
                    <svg width="12"
                         height="12"
                         viewBox="0 0 24 24"
                         fill="none"
                         stroke="#666"
                         stroke-width="2">
                        <rect x="3" y="4" width="18" height="18" rx="2"/>
                        <line x1="16" y1="2" x2="16" y2="6"/>
                        <line x1="8" y1="2" x2="8" y2="6"/>
                        <line x1="3" y1="10" x2="21" y2="10"/>
                    </svg>
                    ` + getTodayLabel() + `
                `;
            }
            kakaoModal.style.display = "flex";
            /* 새로 켤 때 위치 중앙으로 초기화 열리게 */
            kakaoModal.style.justifyContent = "center";
            kakaoModal.style.alignItems = "center";

            kakaoTalkWindow.style.position = "relative";
            kakaoTalkWindow.style.left = "";
            kakaoTalkWindow.style.top = "";
            kakaoTalkWindow.classList.remove("minimized");
        });
    }

    if (kakaoCloseBtn) {
        kakaoCloseBtn.addEventListener("click", async () => {
            kakaoModal.style.display = "none";
            await loadKakaoUnreadCount();
        });
    }

    loadKakaoUnreadCount();

    window.addEventListener("load", function () {
        const kakaoBtn = document.getElementById("kakaoAlimBtn");

        if (kakaoBtn) {
            kakaoBtn.classList.remove("kakao-ready");
        }
    });

</script>
<jsp:include page="/WEB-INF/views/include/websocket.jsp"/>
