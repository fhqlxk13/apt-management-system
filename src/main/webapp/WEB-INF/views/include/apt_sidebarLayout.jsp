<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=Manrope:wght@400;500;600;700&family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet" />

<style>

  .notice-search-wrap{
    display:flex;
    align-items:center;
    gap:12px;
    flex-wrap:wrap;
    margin-bottom:24px;
  }

  .notice-search-input{
    height:42px;
    padding:0 18px;
    border:none;
    border-radius:999px;
    background:#eef1ed;
    color:#2f312f;
    font-size:14px;
    outline:none;
    min-width:180px;
    box-sizing:border-box;
  }

  .notice-search-input::placeholder{
    color:#7d847d;
  }

  .notice-search-date{
    width:180px;
  }

  .notice-search-btn{
    height:42px;
    min-width:92px;
    border:none;
    border-radius:999px;
    background:#006b50;
    color:#fff;
    font-size:14px;
    font-weight:700;
    cursor:pointer;
  }

  .notice-reset-btn{
    height:42px;
    min-width:92px;
    border:none;
    border-radius:999px;
    background:#667594;
    color:#fff;
    font-size:14px;
    font-weight:700;
    cursor:pointer;
    text-decoration:none;

    display:flex;
    align-items:center;
    justify-content:center;
    box-sizing:border-box;
  }

  .notice-search-tilde{
    font-size:18px;
    font-weight:700;
    color:#4d5450;
  }

</style>

<script>
  tailwind.config = {
    darkMode: "class",
    theme: {
      extend: {
        colors: {
          "outline-variant": "#bfc9c1",
          "inverse-primary": "#95d4b3",
          "tertiary-fixed-dim": "#ffb3b2",
          "inverse-surface": "#2e312f",
          "on-error": "#ffffff",
          "surface-container-highest": "#e1e3df",
          "on-secondary-fixed-variant": "#0d503f",
          "surface-container": "#eceeea",
          "secondary-container": "#aeedd5",
          "secondary-fixed": "#b1efd8",
          "on-secondary-fixed": "#002118",
          "background": "#f8faf6",
          "secondary-fixed-dim": "#96d3bd",
          "on-tertiary-container": "#ffb8b8",
          "on-primary": "#ffffff",
          "on-background": "#191c1a",
          "primary-fixed": "#b1f0ce",
          "tertiary-fixed": "#ffdad9",
          "surface-container-high": "#e7e9e5",
          "surface-tint": "#2c694f",
          "tertiary": "#652d2e",
          "on-error-container": "#93000a",
          "on-surface": "#191c1a",
          "surface-container-low": "#f2f4f0",
          "on-secondary-container": "#316d5b",
          "surface-bright": "#f8faf6",
          "secondary": "#2c6956",
          "inverse-on-surface": "#eff1ed",
          "tertiary-container": "#814344",
          "on-tertiary-fixed-variant": "#703536",
          "outline": "#707973",
          "on-primary-fixed-variant": "#0e5138",
          "surface-container-lowest": "#ffffff",
          "primary": "#004830",
          "on-primary-fixed": "#002114",
          "on-surface-variant": "#404943",
          "primary-container": "#226046",
          "error-container": "#ffdad6",
          "primary-fixed-dim": "#95d4b3",
          "surface": "#f8faf6",
          "on-tertiary-fixed": "#390b0e",
          "on-primary-container": "#99d8b7",
          "error": "#ba1a1a",
          "on-secondary": "#ffffff",
          "surface-dim": "#d8dbd7",
          "surface-variant": "#e1e3df",
          "on-tertiary": "#ffffff"
        },
        borderRadius: {
          DEFAULT: "1rem",
          lg: "2rem",
          xl: "3rem",
          full: "9999px"
        },
        fontFamily: {
          headline: ["Plus Jakarta Sans"],
          body: ["Manrope"],
          label: ["Manrope"]
        }
      }
    }
  }
</script>

<aside class="w-80 shrink-0 bg-surface-container-lowest border-r border-outline-variant/20 flex flex-col py-8 overflow-y-auto">

  <nav class="flex flex-col gap-1 px-4">

    <details class="side-nav-item group"
    ${fn:contains(pageContext.request.requestURI, '/resident/manage')
            or fn:contains(pageContext.request.requestURI, '/apt/main')
            or fn:contains(pageContext.request.requestURI, '/resident/calendar')
            ? 'open="open"' : ''}>
      <summary class="flex items-center justify-between px-4 py-3 rounded-full cursor-pointer hover:bg-primary/5 transition-colors text-on-surface">
        <div class="flex items-center gap-3">
          <span class="material-symbols-outlined text-primary">home</span>
          <span class="font-label font-bold text-sm">우리아파트</span>
        </div>
        <span class="material-symbols-outlined text-sm expand-icon transition-transform">expand_more</span>
      </summary>
      <div class="block w-full flex flex-col gap-1 mt-1 ml-9 pr-4 mb-2">
        <a class="px-4 py-2 text-sm rounded-full transition-all hover:text-primary hover:bg-primary/5 ${fn:contains(pageContext.request.requestURI, '/resident/manage/intro') ? 'text-primary font-bold' : 'text-on-surface-variant/80'}" href="${pageContext.request.contextPath}/apt/main/aptInfo/${apt.aptCmplexNo}">아파트정보</a>
        <a class="px-4 py-2 text-sm rounded-full transition-all hover:text-primary hover:bg-primary/5 ${fn:contains(pageContext.request.requestURI, '/resident/calendar') ? 'text-primary font-bold bg-primary/5' : 'text-on-surface-variant/80'}" href="${pageContext.request.contextPath}/resident/calendar/${apt.aptCmplexNo}">아파트일정</a>
        <a class="px-4 py-2 text-sm rounded-full transition-all hover:text-primary hover:bg-primary/5 ${fn:contains(pageContext.request.requestURI, '/resident/manage/intro') ? 'text-primary font-bold' : 'text-on-surface-variant/80'}" href="${pageContext.request.contextPath}/apt/main/mgmtInfo/${apt.aptCmplexNo}">관리사무소정보</a>
        <%--<a class="px-4 py-2 text-sm rounded-full transition-all hover:text-primary hover:bg-primary/5 ${fn:contains(pageContext.request.requestURI, '/resident/manage/operation') ? 'text-primary font-bold' : 'text-on-surface-variant/80'}" href="${pageContext.request.contextPath}/resident/manage/operation">운영정보공개</a>--%>
        <a class="px-4 py-2 text-sm rounded-full transition-all hover:text-primary hover:bg-primary/5 ${fn:contains(pageContext.request.requestURI, '/resident/manage/facility') ? 'text-primary font-bold' : 'text-on-surface-variant/80'}" href="${pageContext.request.contextPath}/resident/manage/facility/${apt.aptCmplexNo}">시설관리이력</a>
      </div>
    </details>

    <details class="side-nav-item group" ${fn:contains(pageContext.request.requestURI, '/resident/bill') ? 'open="open"' : ''}>
      <summary class="flex items-center justify-between px-4 py-3 rounded-full cursor-pointer hover:bg-primary/5 transition-colors text-on-surface">
        <div class="flex items-center gap-3">
          <span class="material-symbols-outlined text-primary">receipt_long</span>
          <span class="font-label font-bold text-sm">아파트관리비</span>
        </div>
        <span class="material-symbols-outlined text-sm expand-icon transition-transform">expand_more</span>
      </summary>
      <div class="block w-full flex flex-col gap-1 mt-1 ml-9 pr-4 mb-2">
        <a class="px-4 py-2 text-sm rounded-full transition-all hover:text-primary hover:bg-primary/5 ${fn:contains(pageContext.request.requestURI, '/resident/bill/inquiry') ? 'text-primary font-bold' : 'text-on-surface-variant/80'}" href="${pageContext.request.contextPath}/resident/bill/inquiry/${apt.aptCmplexNo}">관리비조회</a>
        <a class="px-4 py-2 text-sm rounded-full transition-all hover:text-primary hover:bg-primary/5 ${fn:contains(pageContext.request.requestURI, '/resident/bill/guide') ? 'text-primary font-bold' : 'text-on-surface-variant/80'}" href="${pageContext.request.contextPath}/resident/bill/guide/${aptCmplexNo}">납부안내</a>
        <%--<a class="px-4 py-2 text-sm rounded-full transition-all hover:text-primary hover:bg-primary/5 ${fn:contains(pageContext.request.requestURI, '/resident/bill/auto') ? 'text-primary font-bold' : 'text-on-surface-variant/80'}" href="${pageContext.request.contextPath}/resident/bill/auto">자동이체신청</a>--%>
        <a class="px-4 py-2 text-sm rounded-full transition-all hover:text-primary hover:bg-primary/5 ${fn:contains(pageContext.request.requestURI, '/resident/bill/receipt') ? 'text-primary font-bold' : 'text-on-surface-variant/80'}" href="${pageContext.request.contextPath}/resident/bill/receipt/${aptCmplexNo}">납부영수증</a>
      </div>
    </details>

    <details class="side-nav-item group"
    ${fn:contains(pageContext.request.requestURI, '/resident/service')
            or fn:contains(pageContext.request.requestURI, '/resident/publicFacility') ? 'open="open"' : ''}>
      <summary class="flex items-center justify-between px-4 py-3 rounded-full cursor-pointer hover:bg-primary/5 transition-colors text-on-surface">
        <div class="flex items-center gap-3">
          <span class="material-symbols-outlined text-primary">groups</span>
          <span class="font-label font-bold text-sm">생활지원서비스</span>
        </div>
        <span class="material-symbols-outlined text-sm expand-icon transition-transform">expand_more</span>
      </summary>
      <div class="block w-full flex flex-col gap-1 mt-1 ml-9 pr-4 mb-2">
        <a class="px-4 py-2 text-sm rounded-full transition-all hover:text-primary hover:bg-primary/5 ${fn:contains(pageContext.request.requestURI, '/resident/service/moving') ? 'text-primary font-bold' : 'text-on-surface-variant/80'}" href="${pageContext.request.contextPath}/resident/service/moving/${aptCmplexNo}">전입/전출신고</a>
        <a class="px-4 py-2 text-sm rounded-full transition-all hover:text-primary hover:bg-primary/5 ${fn:contains(pageContext.request.requestURI, '/resident/service/car') ? 'text-primary font-bold' : 'text-on-surface-variant/80'}" href="${pageContext.request.contextPath}/resident/service/car/${aptCmplexNo}">차량등록</a>
        <a class="px-4 py-2 text-sm rounded-full transition-all hover:text-primary hover:bg-primary/5 ${fn:contains(pageContext.request.requestURI, '/resident/service/visitor') ? 'text-primary font-bold' : 'text-on-surface-variant/80'}" href="${pageContext.request.contextPath}/resident/service/visitor/${aptCmplexNo}">방문차량등록</a>
        <a class="px-4 py-2 text-sm rounded-full transition-all hover:text-primary hover:bg-primary/5
                 ${fn:contains(pageContext.request.requestURI, '/resident/publicFacility/reservation') ? 'text-primary font-bold' : 'text-on-surface-variant/80'}"
           href="${pageContext.request.contextPath}/resident/publicFacility/reservation/${apt.aptCmplexNo}">
          편의시설예약
        </a>
        <a class="px-4 py-2 text-sm rounded-full transition-all hover:text-primary hover:bg-primary/5
                 ${fn:contains(pageContext.request.requestURI,'/resident/publicFacility/myReservation') ? 'text-primary font-bold' : 'text-on-surface-variant/80'}"
           href="${pageContext.request.contextPath}/resident/publicFacility/myReservation/${apt.aptCmplexNo}">
          예약내역
        </a>
      </div>
    </details>

    <details class="side-nav-item group" ${fn:contains(pageContext.request.requestURI, '/apt/complaint') ? 'open="open"' : ''}>
      <summary class="flex items-center justify-between px-4 py-3 rounded-full cursor-pointer hover:bg-primary/5 transition-colors text-on-surface">
        <div class="flex items-center gap-3">
          <span class="material-symbols-outlined text-primary">support_agent</span>
          <span class="font-label font-bold text-sm">민원접수</span>
        </div>
        <span class="material-symbols-outlined text-sm expand-icon transition-transform">expand_more</span>
      </summary>
      <div class="block w-full flex flex-col gap-1 mt-1 ml-9 pr-4 mb-2">
        <a class="px-4 py-2 text-sm rounded-full transition-all hover:text-primary hover:bg-primary/5 ${fn:contains(pageContext.request.requestURI, '/resident/complaint/apply') ? 'text-primary font-bold' : 'text-on-surface-variant/80'}" href="/apt/complaint/apply.do/${apt.aptCmplexNo}">내 민원 및 신청</a>
        <a class="px-4 py-2 text-sm rounded-full transition-all hover:text-primary hover:bg-primary/5 ${fn:contains(pageContext.request.requestURI, '/resident/complaint/status') ? 'text-primary font-bold' : 'text-on-surface-variant/80'}" href="/apt/complaint/list/${apt.aptCmplexNo}">단지 민원 내역</a>
<%--        <a class="px-4 py-2 text-sm rounded-full transition-all hover:text-primary hover:bg-primary/5 ${fn:contains(pageContext.request.requestURI, '/resident/complaint/live') ? 'text-primary font-bold' : 'text-on-surface-variant/80'}" href="${pageContext.request.contextPath}/resident/complaint/live">실시간문의</a>--%>
      </div>
    </details>

    <%-- 설문 목록은 실제 주민 설문 경로로 연결한다. --%>
    <details class="side-nav-item group" ${fn:contains(pageContext.request.requestURI, '/resident/survey') or fn:contains(pageContext.request.requestURI, '/resident/vote') ? 'open="open"' : ''}>
      <summary class="flex items-center justify-between px-4 py-3 rounded-full cursor-pointer hover:bg-primary/5 transition-colors text-on-surface">
        <div class="flex items-center gap-3">
          <span class="material-symbols-outlined text-primary">how_to_vote</span>
          <span class="font-label font-bold text-sm">전자투표 및 설문</span>
        </div>
        <span class="material-symbols-outlined text-sm expand-icon transition-transform">expand_more</span>
      </summary>
      <div class="block w-full flex flex-col gap-1 mt-1 ml-9 pr-4 mb-2">
        <a class="px-4 py-2 text-sm rounded-full transition-all hover:text-primary hover:bg-primary/5 ${fn:contains(pageContext.request.requestURI, '/resident/survey/list') or fn:contains(pageContext.request.requestURI, '/resident/survey/result') ? 'text-primary font-bold' : 'text-on-surface-variant/80'}" href="${pageContext.request.contextPath}/resident/survey/list/${apt.aptCmplexNo}">투표 및 설문조사</a>
      </div>
    </details>

        <%-- 왼쪽 사이드바에 현재페이지 활성화 --%>
        <details class="side-nav-item group">
        <summary class="flex items-center justify-between px-4 py-3 rounded-full cursor-pointer hover:bg-primary/5 transition-colors text-on-surface">
          <div class="flex items-center gap-3">
            <span class="material-symbols-outlined text-primary">forum</span>
            <span class="font-label font-bold text-sm">입주민 게시판</span>
          </div>
          <span class="material-symbols-outlined text-sm expand-icon transition-transform">expand_more</span>
        </summary>
      <div class="block w-full flex flex-col gap-1 mt-1 ml-9 pr-4 mb-2">
        <a class="px-4 py-2 text-sm rounded-full transition-all hover:text-primary hover:bg-primary/5 ${fn:contains(pageContext.request.requestURI, '/resident/apt/ann') ? 'text-primary font-bold' : 'text-on-surface-variant/80'}" href="${pageContext.request.contextPath}/resident/board/notice/${aptCmplexNo}">공지사항</a>
        <a class="px-4 py-2 text-sm rounded-full transition-all hover:text-primary hover:bg-primary/5 ${fn:contains(pageContext.request.requestURI, '/resident/apt/apt') ? 'text-primary font-bold' : 'text-on-surface-variant/80'}" href="${pageContext.request.contextPath}/resident/board/free/${aptCmplexNo}">자유게시판</a>
        <a class="px-4 py-2 text-sm rounded-full transition-all hover:text-primary hover:bg-primary/5 ${fn:contains(pageContext.request.requestURI, '/resident/apt/chat') ? 'text-primary font-bold' : 'text-on-surface-variant/80'}" href="${pageContext.request.contextPath}/resident/board/chat/${aptCmplexNo}">그룹채팅방</a>
      </div>
    </details>

    <details class="side-nav-item group" ${fn:contains(pageContext.request.requestURI, '/resident/stats') ? 'open="open"' : ''}>
      <summary class="flex items-center justify-between px-4 py-3 rounded-full cursor-pointer hover:bg-primary/5 transition-colors text-on-surface">
        <div class="flex items-center gap-3">
          <span class="material-symbols-outlined text-primary">bar_chart</span>
          <span class="font-label font-bold text-sm">우리아파트통계</span>
        </div>
        <span class="material-symbols-outlined text-sm expand-icon transition-transform">expand_more</span>
      </summary>
      <div class="block w-full flex flex-col gap-1 mt-1 ml-9 pr-4 mb-2">
        <a class="px-4 py-2 text-sm rounded-full transition-all hover:text-primary hover:bg-primary/5 ${fn:contains(pageContext.request.requestURI, '/resident/stats/custom') ? 'text-primary font-bold' : 'text-on-surface-variant/80'}" href="${pageContext.request.contextPath}/resident/stats/custom/${apt.aptCmplexNo}">우리집맞춤통계</a>
        <a class="px-4 py-2 text-sm rounded-full transition-all hover:text-primary hover:bg-primary/5 ${fn:contains(pageContext.request.requestURI, '/resident/stats/apartment') ? 'text-primary font-bold' : 'text-on-surface-variant/80'}" href="${pageContext.request.contextPath}/resident/stats/apartment/${apt.aptCmplexNo}">아파트통계</a>
      </div>
    </details>
  </nav>

</aside>

<script>
  const details = document.querySelectorAll('.side-nav-item');

  /*
   * 현재 URL 기준으로 사이드바 메뉴 자동 활성화
   *
   * currentPath란?
   * → 현재 접속한 주소의 경로.
   * 예: /resident/board/notice/A10023118
   */
  const currentPath = window.location.pathname;

  document.querySelectorAll('aside nav a').forEach(function(link) {
    const linkPath = new URL(link.href).pathname;

    /*
     * startsWith란?
     * → 현재 URL이 메뉴 URL로 시작하는지 확인.
     */
    if (currentPath === linkPath || currentPath.startsWith(linkPath + "/")) {
      link.classList.add('bg-primary/5', 'text-primary', 'font-bold');
      link.classList.remove('text-on-surface-variant/80');

      const parentDetail = link.closest('details');

      if (parentDetail) {
        parentDetail.open = true;
      }
    }
  });

  /*
   * 사용자가 한 메뉴를 열면 다른 메뉴는 닫기
   */
  details.forEach((targetDetail) => {
    targetDetail.addEventListener('click', () => {
      details.forEach((detail) => {
        if (detail !== targetDetail) {
          detail.removeAttribute('open');
        }
      });
    });
  });
</script>
