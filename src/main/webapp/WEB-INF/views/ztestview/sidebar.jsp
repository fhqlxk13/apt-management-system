<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script src="https://cdn.tailwindcss.com"></script>
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&amp;family=Manrope:wght@400;500;600;700&amp;family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<script id="tailwind-config">
  tailwind.config = {
    darkMode: "class",
    theme: {
      extend: {
        "colors": {
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
        "borderRadius": {
          "DEFAULT": "0.25rem",
          "lg": "0.5rem",
          "xl": "0.75rem",
          "full": "9999px"
        },
        "fontFamily": {
          "headline": ["Plus Jakarta Sans"],
          "body": ["Manrope"],
          "label": ["Manrope"]
        }
      },
    },
  }
</script>
<aside class="min-h-screen w-64 fixed left-0 top-0 bg-white border-r border-gray-200 flex flex-col z-40 overflow-y-auto">
  <div class="text-xl font-bold text-[#226046] px-6 h-20 flex items-center shrink-0">
    우리집맵핑🏠
  </div>



  <nav class="flex flex-col gap-1 px-3 mt-6 pb-10" id="sidebar-nav">

    <details class="nav-item group">
      <summary class="flex items-center justify-between px-3 py-3 rounded-full cursor-pointer hover:bg-white/50 transition-colors">
        <div class="flex items-center gap-2">
          <span class="material-symbols-outlined text-[#226046] text-xl">campaign</span>
          <span class="font-bold text-sm text-gray-700 whitespace-nowrap">서비스 소개</span>
        </div>
        <span class="material-symbols-outlined text-sm transition-transform group-open:rotate-180">expand_more</span>
      </summary>
      <div class="flex flex-col gap-1 mt-1 ml-8 pr-2 mb-2">
        <a class="px-3 py-2 text-sm text-gray-600 hover:text-[#226046] hover:bg-white/70 rounded-full transition-all whitespace-nowrap"   href="${pageContext.request.contextPath}/apt/intro.do">서비스 소개</a>
      </div>
    </details>

    <details class="nav-item group">
      <summary class="flex items-center justify-between px-3 py-3 rounded-full cursor-pointer hover:bg-white/50 transition-colors">
        <div class="flex items-center gap-2">
          <span class="material-symbols-outlined text-[#226046] text-xl">home_work</span>
          <span class="font-bold text-sm text-gray-700 whitespace-nowrap">계약 관리</span>
        </div>
        <span class="material-symbols-outlined text-sm transition-transform group-open:rotate-180">expand_more</span>
      </summary>
      <div class="flex flex-col gap-1 mt-1 ml-8 pr-2 mb-2">
        <a class="px-3 py-2 text-sm text-gray-600 hover:text-[#226046] hover:bg-white/70 rounded-full transition-all whitespace-nowrap"
           href="${pageContext.request.contextPath}/contract/notice.do">청약 공고</a>
        <a class="px-3 py-2 text-sm text-gray-600 hover:text-[#226046] hover:bg-white/70 rounded-full transition-all whitespace-nowrap"
           href="${pageContext.request.contextPath}/contract/apply.do">계약 신청</a>
        <a class="px-3 py-2 text-sm text-gray-600 hover:text-[#226046] hover:bg-white/70 rounded-full transition-all whitespace-nowrap"
           href="${pageContext.request.contextPath}/contract/history.do">
          계약 조회
        </a>
      </div>
    </details>

    <details class="nav-item group">
      <summary class="flex items-center justify-between px-3 py-3 rounded-full cursor-pointer hover:bg-white/50 transition-colors">
        <div class="flex items-center gap-2">
          <span class="material-symbols-outlined text-[#226046] text-xl">assignment_turned_in</span>
          <span class="font-bold text-sm text-gray-700 whitespace-nowrap">공공주택정보</span>
        </div>
        <span class="material-symbols-outlined text-sm transition-transform group-open:rotate-180">expand_more</span>
      </summary>
      <div class="flex flex-col gap-1 mt-1 ml-8 pr-2 mb-2">
        <a class="px-3 py-2 text-sm text-gray-600 hover:text-[#226046] hover:bg-white/70 rounded-full transition-all whitespace-nowrap"
           href="${pageContext.request.contextPath}/apt/list.do">단지 목록</a>

        <a class="px-3 py-2 text-sm text-gray-600 hover:text-[#226046] hover:bg-white/70 rounded-full transition-all whitespace-nowrap"
           href="${pageContext.request.contextPath}/apt/search.do">단지 검색</a>

        <a class="px-3 py-2 text-sm text-gray-600 hover:text-[#226046] hover:bg-white/70 rounded-full transition-all whitespace-nowrap"
           href="${pageContext.request.contextPath}/apt/dashboard.do">단지별 통계 조회</a>
      </div>
    </details>

    <details class="nav-item group">
      <summary class="flex items-center justify-between px-3 py-3 rounded-full cursor-pointer hover:bg-white/50 transition-colors">
        <div class="flex items-center gap-2">
          <span class="material-symbols-outlined text-[#226046] text-xl">forum</span>
          <span class="font-bold text-sm text-gray-700 whitespace-nowrap">시설이력조회</span>
        </div>
        <span class="material-symbols-outlined text-sm transition-transform group-open:rotate-180">expand_more</span>
      </summary>
      <div class="flex flex-col gap-1 mt-1 ml-8 pr-2 mb-2">
        <a class="px-3 py-2 text-sm text-gray-600 hover:text-[#226046] hover:bg-white/70 rounded-full transition-all whitespace-nowrap"href="/fac/facilityHistory.do">시설 유지보수 이력</a>
        <a class="px-3 py-2 text-sm text-gray-600 hover:text-[#226046] hover:bg-white/70 rounded-full transition-all whitespace-nowrap" href="/fac/facilityCheckHistory.do">시설 점검 기록 확인</a>
      </div>
    </details>

    <details class="nav-item group">
      <summary class="flex items-center justify-between px-3 py-3 rounded-full cursor-pointer hover:bg-white/50 transition-colors">
        <div class="flex items-center gap-2">
          <span class="material-symbols-outlined text-[#226046] text-xl">compare</span>
          <span class="font-bold text-sm text-gray-700 whitespace-nowrap">공지사항</span>
        </div>
        <span class="material-symbols-outlined text-sm transition-transform group-open:rotate-180">expand_more</span>
      </summary>
      <div class="flex flex-col gap-1 mt-1 ml-8 pr-2 mb-2">
        <a class="px-3 py-2 text-sm text-gray-600 hover:text-[#226046] hover:bg-white/70 rounded-full transition-all whitespace-nowrap"
           href="${pageContext.request.contextPath}/notice/list.do">공지사항</a>
        <a class="px-3 py-2 text-sm text-gray-600 hover:text-[#226046] hover:bg-white/70 rounded-full transition-all whitespace-nowrap"
           href="${pageContext.request.contextPath}/member/qna/list.do">문의게시판</a>
      </div>
    </details>
  </nav>

</aside>

<script>
  const detailsList = document.querySelectorAll('#sidebar-nav details');

  // 저장된 상태 불러오기
  detailsList.forEach((d, index) => {
    const isOpen = localStorage.getItem('sidebar_' + index);
    if (isOpen === 'true') {
      d.open = true;
    }
  });

  // 열고 닫을 때 저장
  detailsList.forEach((d, index) => {
    d.addEventListener('toggle', () => {
      localStorage.setItem('sidebar_' + index, d.open);
    });
  });
</script>