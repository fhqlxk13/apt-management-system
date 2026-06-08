<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>

<html class="light" lang="ko"><head>
  <meta charset="utf-8"/>
  <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
  <title>시설 관리 이력 조회 - 우리집맵핑</title>
  <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&amp;display=swap" rel="stylesheet"/>
  <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
  <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
  <script id="tailwind-config">
    tailwind.config = {
      darkMode: "class",
      theme: {
        extend: {
          "colors": {
            "surface": "#fbf9f5",
            "primary": "#56642b",
            "on-primary-container": "#253000",
            "surface-container": "#efeeea",
            "on-surface": "#1b1c1a",
            "on-error": "#ffffff",
            "inverse-surface": "#30312e",
            "surface-tint": "#56642b",
            "surface-container-low": "#f5f3ef",
            "inverse-primary": "#bdce89",
            "secondary-fixed-dim": "#b4cdb7",
            "background": "#fbf9f5",
            "secondary-fixed": "#d0e9d2",
            "on-primary-fixed-variant": "#3e4c16",
            "on-secondary": "#ffffff",
            "on-background": "#1b1c1a",
            "surface-container-high": "#eae8e4",
            "primary-fixed": "#d9eaa3",
            "on-tertiary-fixed-variant": "#155037",
            "tertiary": "#30694d",
            "on-primary": "#ffffff",
            "on-secondary-container": "#546a58",
            "on-tertiary-container": "#003320",
            "error": "#ba1a1a",
            "on-surface-variant": "#46483c",
            "outline": "#76786b",
            "surface-variant": "#e4e2de",
            "inverse-on-surface": "#f2f0ed",
            "surface-container-highest": "#e4e2de",
            "tertiary-fixed": "#b4f0cd",
            "primary-fixed-dim": "#bdce89",
            "surface-container-lowest": "#ffffff",
            "on-tertiary-fixed": "#002113",
            "tertiary-container": "#669f80",
            "surface-dim": "#dbdad6",
            "error-container": "#ffdad6",
            "outline-variant": "#c6c8b8",
            "on-primary-fixed": "#161f00",
            "secondary-container": "#d0e9d2",
            "tertiary-fixed-dim": "#98d3b2",
            "secondary": "#4e6452",
            "on-error-container": "#93000a",
            "on-tertiary": "#ffffff",
            "primary-container": "#8a9a5b",
            "on-secondary-fixed-variant": "#364c3b",
            "on-secondary-fixed": "#0b2012",
            "surface-bright": "#fbf9f5"
          },
          "borderRadius": {
            "DEFAULT": "0.25rem",
            "lg": "0.5rem",
            "xl": "0.75rem",
            "full": "9999px"
          },
          "fontFamily": {
            "headline": ["Manrope"],
            "body": ["Manrope"],
            "label": ["Manrope"]
          }
        },
      },
    }
  </script>
  <style>
    body { font-family: 'Manrope', sans-serif; }
    .material-symbols-outlined {
      font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
    }
  </style>
</head>
<body class="bg-surface text-on-surface flex flex-col min-h-screen">

<%@ include file="/WEB-INF/views/include/main_headerLayout.jsp" %>
<%@ include file="/WEB-INF/views/include/central_sidebar.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/centralSidebarStyle.css">

<main class="flex-grow pt-28 pb-20 px-6 max-w-7xl mx-auto w-full">
  <!-- Header Section -->
  <header class="mb-12 text-center">
    <h1 class="text-4xl font-bold tracking-tight text-on-surface mb-2">단지 찾기</h1>
    <p class="text-on-surface-variant max-w-lg mx-auto">거주하시는 아파트 단지를 검색하여 우리집의 다양한 시설 정보를 확인해보세요.</p>
  </header>
  <!-- Tab Menu -->

  <section class="space-y-16">
    <!-- Address Selection Title -->
    <div class="text-center">
      <h2 class="text-xl font-semibold text-primary mb-8">아파트 주소정보를 선택해주세요</h2>
      <!-- 3-Step Process Cards -->
      <div class="grid grid-cols-1 md:grid-cols-3 gap-6 max-w-4xl mx-auto">
        <!-- Step 1: Si/Do -->
        <div class="bg-white p-6 rounded-xl shadow-[0_4px_20px_rgba(45,66,50,0.04)] border border-outline-variant/10 group cursor-pointer hover:bg-surface-container-low transition-colors">
          <div class="w-10 h-10 bg-primary-container/20 rounded-full flex items-center justify-center text-primary mb-4 mx-auto group-hover:bg-primary-container group-hover:text-white transition-all">
            <span class="material-symbols-outlined">map</span>
          </div>
          <p class="text-xs font-bold text-primary mb-1 uppercase tracking-widest">Step 01</p>

          <h3 class="text-lg font-bold text-on-surface mb-2">시/도 선택</h3>
          <div class="flex items-center justify-center gap-2 text-on-surface-variant text-sm">
            <span>서울특별시</span>
            <span class="material-symbols-outlined text-sm">expand_more</span>
          </div>
        </div>
        <!-- Step 2: Si/Gun/Gu -->
        <div class="bg-white p-6 rounded-xl shadow-[0_4px_20px_rgba(45,66,50,0.04)] border border-outline-variant/10 group cursor-pointer hover:bg-surface-container-low transition-colors">
          <div class="w-10 h-10 bg-surface-container-high rounded-full flex items-center justify-center text-on-surface-variant mb-4 mx-auto group-hover:bg-primary-container group-hover:text-white transition-all">
            <span class="material-symbols-outlined">location_city</span>
          </div>
          <p class="text-xs font-bold text-on-surface-variant mb-1 uppercase tracking-widest">Step 02</p>
          <h3 class="text-lg font-bold text-on-surface mb-2">시/군/구 선택</h3>
          <div class="flex items-center justify-center gap-2 text-on-surface-variant text-sm">



            <span class="material-symbols-outlined text-sm">expand_more</span>
          </div>
        </div>
        <!-- Step 3: Dong/Myeon/Eup -->


        <div class="bg-white p-6 rounded-xl shadow-[0_4px_20px_rgba(45,66,50,0.04)] border border-outline-variant/10 group cursor-pointer hover:bg-surface-container-low transition-colors ">
          <div class="w-10 h-10 bg-surface-container-high rounded-full
flex items-center justify-center
text-on-surface-variant mb-4 mx-auto

group-hover:bg-primary-container
group-hover:text-white
transition-all">
            <span class="material-symbols-outlined">home_pin</span>
          </div>
          <p class="text-xs font-bold text-on-surface-variant mb-1 uppercase tracking-widest">Step 03</p>
          <h3 class="text-lg font-bold text-on-surface mb-2">읍/면/동 선택</h3>
          <div class="flex items-center justify-center gap-2 text-on-surface-variant text-sm">
            <span>- 선택 -</span>
          </div>
        </div>
      </div>
    </div>
    <!-- Regional Map Grid -->
    <div class="max-w-3xl mx-auto">
      <div class="flex items-center gap-3 mb-6 justify-center">
        <div class="h-[1px] w-12 bg-outline-variant"></div>
        <span class="text-sm font-bold text-on-surface-variant uppercase tracking-widest">빠른 지역 선택</span>
        <div class="h-[1px] w-12 bg-outline-variant"></div>
      </div>
      <div class="grid grid-cols-4 sm:grid-cols-6 md:grid-cols-8 gap-3">
        <!-- Regional Buttons -->
        <button class="aspect-square flex flex-col items-center justify-center gap-1 rounded-xl bg-surface-container-low hover:bg-primary hover:text-white transition-all text-sm font-medium border border-outline-variant/10 group">
          <span class="text-xs opacity-60 group-hover:opacity-100">SU</span>
          <span>서울</span>
        </button>
        <button class="aspect-square flex flex-col items-center justify-center gap-1 rounded-xl bg-white border-2 border-primary text-primary font-bold shadow-sm transition-all text-sm">
          <span class="text-xs opacity-60">GG</span>
          <span>경기</span>
        </button>
        <button class="aspect-square flex flex-col items-center justify-center gap-1 rounded-xl bg-surface-container-low hover:bg-primary hover:text-white transition-all text-sm font-medium border border-outline-variant/10 group">
          <span class="text-xs opacity-60 group-hover:opacity-100">IC</span>
          <span>인천</span>
        </button>
        <button class="aspect-square flex flex-col items-center justify-center gap-1 rounded-xl bg-surface-container-low hover:bg-primary hover:text-white transition-all text-sm font-medium border border-outline-variant/10 group">
          <span class="text-xs opacity-60 group-hover:opacity-100">GW</span>
          <span>강원</span>
        </button>
        <button class="aspect-square flex flex-col items-center justify-center gap-1 rounded-xl bg-surface-container-low hover:bg-primary hover:text-white transition-all text-sm font-medium border border-outline-variant/10 group">
          <span class="text-xs opacity-60 group-hover:opacity-100">CB</span>
          <span>충북</span>
        </button>
        <button class="aspect-square flex flex-col items-center justify-center gap-1 rounded-xl bg-surface-container-low hover:bg-primary hover:text-white transition-all text-sm font-medium border border-outline-variant/10 group">
          <span class="text-xs opacity-60 group-hover:opacity-100">CN</span>
          <span>충남</span>
        </button>
        <button class="aspect-square flex flex-col items-center justify-center gap-1 rounded-xl bg-surface-container-low hover:bg-primary hover:text-white transition-all text-sm font-medium border border-outline-variant/10 group">
          <span class="text-xs opacity-60 group-hover:opacity-100">DJ</span>
          <span>대전</span>
        </button>
        <button class="aspect-square flex flex-col items-center justify-center gap-1 rounded-xl bg-surface-container-low hover:bg-primary hover:text-white transition-all text-sm font-medium border border-outline-variant/10 group">
          <span class="text-xs opacity-60 group-hover:opacity-100">SJ</span>
          <span>세종</span>
        </button>
        <button class="aspect-square flex flex-col items-center justify-center gap-1 rounded-xl bg-surface-container-low hover:bg-primary hover:text-white transition-all text-sm font-medium border border-outline-variant/10 group">
          <span class="text-xs opacity-60 group-hover:opacity-100">GB</span>
          <span>경북</span>
        </button>
        <button class="aspect-square flex flex-col items-center justify-center gap-1 rounded-xl bg-surface-container-low hover:bg-primary hover:text-white transition-all text-sm font-medium border border-outline-variant/10 group">
          <span class="text-xs opacity-60 group-hover:opacity-100">GN</span>
          <span>경남</span>
        </button>
        <button class="aspect-square flex flex-col items-center justify-center gap-1 rounded-xl bg-surface-container-low hover:bg-primary hover:text-white transition-all text-sm font-medium border border-outline-variant/10 group">
          <span class="text-xs opacity-60 group-hover:opacity-100">DG</span>
          <span>대구</span>
        </button>
        <button class="aspect-square flex flex-col items-center justify-center gap-1 rounded-xl bg-surface-container-low hover:bg-primary hover:text-white transition-all text-sm font-medium border border-outline-variant/10 group">
          <span class="text-xs opacity-60 group-hover:opacity-100">US</span>
          <span>울산</span>
        </button>
        <button class="aspect-square flex flex-col items-center justify-center gap-1 rounded-xl bg-surface-container-low hover:bg-primary hover:text-white transition-all text-sm font-medium border border-outline-variant/10 group">
          <span class="text-xs opacity-60 group-hover:opacity-100">BS</span>
          <span>부산</span>
        </button>
        <button class="aspect-square flex flex-col items-center justify-center gap-1 rounded-xl bg-surface-container-low hover:bg-primary hover:text-white transition-all text-sm font-medium border border-outline-variant/10 group">
          <span class="text-xs opacity-60 group-hover:opacity-100">JB</span>
          <span>전북</span>
        </button>
        <button class="aspect-square flex flex-col items-center justify-center gap-1 rounded-xl bg-surface-container-low hover:bg-primary hover:text-white transition-all text-sm font-medium border border-outline-variant/10 group">
          <span class="text-xs opacity-60 group-hover:opacity-100">JN</span>
          <span>전남</span>
        </button>
        <button class="aspect-square flex flex-col items-center justify-center gap-1 rounded-xl bg-surface-container-low hover:bg-primary hover:text-white transition-all text-sm font-medium border border-outline-variant/10 group">
          <span class="text-xs opacity-60 group-hover:opacity-100">GJ</span>
          <span>광주</span>
        </button>
      </div>
    </div>
  </section>
  <!-- Search Bar Section -->
  <section class="mt-20 max-w-2xl mx-auto bg-primary-container/10 p-8 rounded-3xl text-center">
    <h3 class="text-lg font-bold text-on-primary-container mb-4">직접 아파트 이름으로 검색</h3>
    <form action="${pageContext.request.contextPath}/apt/search.do"
          method="get"
          class="max-w-md mx-auto">

      <div class="relative">

        <input
                name="keyword"
                value="${param.keyword}"
                class="w-full pl-12 pr-6 py-4 rounded-full border-none bg-white shadow-sm focus:ring-2 focus:ring-primary text-sm font-medium"
                placeholder="검색하실 아파트 명을 입력하세요"
                type="text"/>

        <span class="material-symbols-outlined absolute left-4 top-1/2 -translate-y-1/2 text-primary">
      search
    </span>

      </div>

      <div class="mt-6">
        <button type="submit"
                class="bg-primary text-on-primary px-10 py-4 rounded-full font-bold shadow-md hover:shadow-lg transition-all active:scale-95">

          단지 검색하기

        </button>
      </div>

    </form>
  </section>
  <c:if test="${not empty aptList}">

  <div class="mt-10 max-w-4xl mx-auto">

    <h3 class="text-2xl font-bold text-primary mb-6">
      검색 결과
    </h3>

    <div class="space-y-4">

      <c:forEach var="apt" items="${aptList}">

        <div class="bg-white border border-gray-100 rounded-2xl p-6 shadow-sm">

          <div class="text-lg font-bold text-gray-900">
            ${apt.aptCmplexNm}
          </div>

          <div class="text-sm text-gray-500 mt-2">
            ${apt.dorojuso}
          </div>

        </div>

      </c:forEach>

    </div>

  </div>

</c:if>
</main>


</body>
<script>
  document.querySelectorAll('.grid button').forEach(btn => {
    btn.addEventListener('click', () => {

      // 1. 기존 선택 제거
      document.querySelectorAll('.grid button').forEach(b => {
        b.classList.remove('bg-white', 'border-2', 'border-primary', 'text-primary', 'font-bold', 'shadow-sm');
        b.classList.add('bg-surface-container-low');
      });

      // 2. 클릭한 애 활성화
      btn.classList.remove('bg-surface-container-low');
      btn.classList.add('bg-white', 'border-2', 'border-primary', 'text-primary', 'font-bold', 'shadow-sm');
    });
  });
</script>

</html>