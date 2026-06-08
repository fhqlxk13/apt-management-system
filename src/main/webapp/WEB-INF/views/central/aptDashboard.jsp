<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html class="light" lang="ko">
<head>
  <meta charset="utf-8"/>
  <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
  <title>단지별 통계 조회 - 공공주택정보</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.4/dist/chart.umd.min.js"></script>
  <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&amp;display=swap" rel="stylesheet"/>
  <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/centralSidebarStyle.css">
  <script>
    tailwind.config = {
      theme: {
        extend: {
          colors: {
            surface: "#fbf9f5",
            primary: "#56642b",
            "primary-container": "#8a9a5b",
            "surface-container-low": "#f5f3ef",
            "on-surface": "#1b1c1a",
            "on-surface-variant": "#46483c",
            "outline-variant": "#c6c8b8"
          },
          fontFamily: {
            body: ["Manrope", "sans-serif"]
          }
        }
      }
    }
  </script>
  <style>
    body { font-family: 'Manrope', sans-serif; }
    .material-symbols-outlined {
      font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
    }
    .tonal-surface {
      background: rgba(255, 255, 255, 0.72);
      border: 1px solid rgba(198, 200, 184, 0.55);
      box-shadow: 0 12px 28px rgba(27, 28, 26, 0.06);
    }
  </style>
</head>
<body class="bg-surface text-on-surface flex flex-col min-h-screen">

<%@ include file="/WEB-INF/views/include/main_headerLayout.jsp" %>
<%@ include file="/WEB-INF/views/include/central_sidebar.jsp" %>

<main class="ml-80 p-8 pt-28 max-w-8xl">
  <header class="flex flex-col gap-2 mb-8">
    <h1 class="text-3xl font-bold text-gray-900 mb-2">단지별 통계 조회</h1>
    <p class="text-gray-500 text-sm">
      공공임대 단지의 공고, 임대매물, 계약 완료 현황을 단지별로 비교합니다.
    </p>
  </header>

  <section class="tonal-surface p-6 rounded-lg flex flex-wrap items-end gap-6 mb-8">
    <div class="flex-1 min-w-[200px] space-y-2">
      <label for="aptDashboardSido" class="text-sm font-semibold text-on-surface-variant flex items-center gap-2">
        <span class="material-symbols-outlined text-sm">location_on</span>지역
      </label>
      <select id="aptDashboardSido" class="w-full bg-surface-container-low rounded-full px-5 py-3 focus:ring-2 focus:ring-primary-container text-sm">
        <option value="">전체 지역</option>
      </select>
    </div>
    <div class="flex-1 min-w-[240px] space-y-2">
      <label for="aptDashboardAptSearch" class="text-sm font-semibold text-on-surface-variant flex items-center gap-2">
        <span class="material-symbols-outlined text-sm">domain</span>단지
      </label>
      <input id="aptDashboardAptSearch" type="text" list="aptDashboardAptOptions" placeholder="전체 단지"
             class="w-full bg-surface-container-low rounded-full px-5 py-3 focus:ring-2 focus:ring-primary-container text-sm"/>
      <datalist id="aptDashboardAptOptions"></datalist>
      <input id="aptDashboardApt" type="hidden"/>
    </div>
    <div class="w-40 space-y-2">
      <label for="aptDashboardYear" class="text-sm font-semibold text-on-surface-variant flex items-center gap-2">
        <span class="material-symbols-outlined text-sm">calendar_today</span>연도
      </label>
      <input id="aptDashboardYear" type="number" min="2000" max="2100" class="w-full bg-surface-container-low rounded-full px-5 py-3 focus:ring-2 focus:ring-primary-container text-sm"/>
    </div>
    <button id="aptDashboardSearchBtn" type="button" class="bg-primary-container text-white px-8 py-3 rounded-full text-sm font-semibold hover:bg-primary transition-all flex items-center gap-2">
      <span class="material-symbols-outlined">search</span>조회
    </button>
  </section>

  <section class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-5 mb-8">
    <div class="tonal-surface p-6 rounded-lg border-l-4 border-primary-container">
      <p class="text-on-surface-variant text-sm mb-2">총 세대 수</p>
      <h3 id="totalUnitCnt" class="text-3xl font-bold">0</h3>
    </div>
    <div class="tonal-surface p-6 rounded-lg border-l-4 border-primary-container">
      <p class="text-on-surface-variant text-sm mb-2">공고 수</p>
      <h3 id="announcementCnt" class="text-3xl font-bold">0</h3>
    </div>
    <div class="tonal-surface p-6 rounded-lg border-l-4 border-primary-container">
      <p class="text-on-surface-variant text-sm mb-2">임대 매물 수</p>
      <h3 id="rentListingCnt" class="text-3xl font-bold">0</h3>
    </div>
    <div class="tonal-surface p-6 rounded-lg border-l-4 border-primary-container">
      <p class="text-on-surface-variant text-sm mb-2">임대계약률</p>
      <h3 id="rentContractRate" class="text-3xl font-bold">0%</h3>
    </div>
  </section>

  <section class="grid grid-cols-1 lg:grid-cols-3 gap-5 mb-8">
    <div class="lg:col-span-2 tonal-surface p-6 rounded-lg">
      <div class="flex justify-between items-center mb-5">
        <h4 class="text-xl font-bold">월별 공고/계약 현황</h4>
      </div>
      <div class="h-72">
        <canvas id="monthlyChart"></canvas>
      </div>
    </div>
    <div class="tonal-surface p-6 rounded-lg">
      <h4 class="text-xl font-bold mb-5">임대 매물 상태별 비율</h4>
      <div class="h-72">
        <canvas id="listingStatusChart"></canvas>
      </div>
    </div>
  </section>

  <section class="tonal-surface rounded-lg overflow-hidden">
    <div class="px-6 py-5 border-b border-outline-variant/40 flex justify-between items-center">
      <h4 class="text-xl font-bold">단지별 상세 통계</h4>
      <p id="aptDashboardCountText" class="text-sm text-on-surface-variant">전체 0개</p>
    </div>
    <div class="overflow-x-auto">
      <table class="w-full text-left">
        <thead>
        <tr class="bg-surface-container-low/70">
          <th class="px-6 py-4 text-sm font-semibold text-on-surface-variant">번호</th>
          <th class="px-6 py-4 text-sm font-semibold text-on-surface-variant">단지명</th>
          <th class="px-6 py-4 text-sm font-semibold text-on-surface-variant">지역</th>
          <th class="px-6 py-4 text-sm font-semibold text-on-surface-variant text-right">세대 수</th>
          <th class="px-6 py-4 text-sm font-semibold text-on-surface-variant text-right">공고 수</th>
          <th class="px-6 py-4 text-sm font-semibold text-on-surface-variant text-right">임대 매물</th>
          <th class="px-6 py-4 text-sm font-semibold text-on-surface-variant">임대계약률</th>
          <th class="px-6 py-4 text-sm font-semibold text-on-surface-variant text-right">단지 상세</th>
        </tr>
        </thead>
        <tbody id="aptDashboardRows" class="divide-y divide-outline-variant/20">
        <tr>
          <td colspan="8" class="px-8 py-8 text-center text-gray-500">통계 데이터를 불러오는 중입니다.</td>
        </tr>
        </tbody>
      </table>
    </div>
    <div id="aptDashboardPagination" class="px-6 py-4 border-t border-outline-variant/40 flex justify-center gap-2"></div>
  </section>
</main>

<script>
  window.aptDashboardContextPath = '${pageContext.request.contextPath}';
</script>
<script src="${pageContext.request.contextPath}/js/central/aptDashboard.js"></script>
</body>
</html>
