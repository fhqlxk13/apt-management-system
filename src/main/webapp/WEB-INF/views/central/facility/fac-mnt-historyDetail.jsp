<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>

<html class="light" lang="ko"><head>
  <meta charset="utf-8"/>
  <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
  <title>시설 관리 이력 조회 - 우리집맵핑</title>
  <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
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
<%@ include file="/WEB-INF/views/include/main_headerLayout.jsp" %>
<%@ include file="/WEB-INF/views/include/central_sidebar.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/centralSidebarStyle.css">

<body class="bg-surface text-on-surface flex flex-col min-h-screen">
<main class="flex-grow pt-12 pb-20 px-8">
  <div class="mb-8 flex items-center gap-4">
    <a href="#" class="p-2 hover:bg-surface-container-high rounded-full transition-colors">
      <span class="material-symbols-outlined">arrow_back</span>
    </a>
    <h1 class="text-4xl font-bold tracking-tight text-on-surface">시설 유지보수 상세 내역</h1>
  </div>

  <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
    <!-- Main Content Area -->
    <div class="lg:col-span-2 space-y-8">
      <!-- Facility Basic Info Card -->
      <section class="bg-surface-container-lowest p-8 rounded-2xl border border-outline-variant/10 shadow-sm">
        <div class="flex justify-between items-start mb-6">
          <div>
            <span class="bg-blue-100 text-blue-700 px-3 py-1 rounded-full text-xs font-bold mb-2 inline-block">유지보수</span>
            <h2 class="text-3xl font-bold text-primary">제1지하주차장 환풍기</h2>
          </div>
          <span class="bg-green-100 text-green-700 px-4 py-1.5 rounded-full text-sm font-bold">점검 완료</span>
        </div>

        <div class="grid grid-cols-2 gap-y-6 gap-x-12 border-t border-outline-variant/10 pt-6">
          <div>
            <p class="text-xs font-bold text-on-surface-variant/60 uppercase tracking-wider mb-1">시설 ID</p>
            <p class="text-on-surface font-semibold">FAC-PRK-001-VNT</p>
          </div>
          <div>
            <p class="text-xs font-bold text-on-surface-variant/60 uppercase tracking-wider mb-1">점검 일자</p>
            <p class="text-on-surface font-semibold">2024.03.15 14:00</p>
          </div>
          <div>
            <p class="text-xs font-bold text-on-surface-variant/60 uppercase tracking-wider mb-1">점검 위치</p>
            <p class="text-on-surface font-semibold">지하 1층 주차장 C구역</p>
          </div>
          <div>
            <p class="text-xs font-bold text-on-surface-variant/60 uppercase tracking-wider mb-1">담당자</p>
            <p class="text-on-surface font-semibold">김철수 팀장 (시설관리팀)</p>
          </div>
        </div>
      </section>

      <!-- Inspection & Action Details -->
      <section class="bg-surface-container-lowest p-8 rounded-2xl border border-outline-variant/10 shadow-sm">
        <h3 class="text-xl font-bold text-on-surface mb-6 flex items-center gap-2">
          <span class="material-symbols-outlined text-primary">description</span>
          점검 및 조치 상세 내역
        </h3>

        <div class="space-y-6">
          <div class="bg-surface-container-low p-6 rounded-xl">
            <p class="text-sm font-bold text-primary mb-2">점검 내용</p>
            <p class="text-on-surface leading-relaxed">
              정기 점검 중 제1지하주차장 C구역 환풍기에서 비정상적인 소음 및 진동 발생 확인.
              베어링 마모로 인한 소음으로 판단되어 부품 교체 결정.
            </p>
          </div>

          <div class="bg-primary/5 p-6 rounded-xl border border-primary/10">
            <p class="text-sm font-bold text-primary mb-2">조치 사항</p>
            <ul class="list-disc list-inside text-on-surface space-y-2 leading-relaxed">
              <li>노후 베어링(SKF-6204) 정품 교체 완료</li>
              <li>모터 축 정렬 및 고정 볼트 재체결</li>
              <li>고온 내열 윤활유 주입 및 클리닝 작업</li>
              <li>시운전 결과 소음 및 진동 수치 정상 확인</li>
            </ul>
          </div>
        </div>
      </section>

      <!-- Photos -->
      <section class="bg-surface-container-lowest p-8 rounded-2xl border border-outline-variant/10 shadow-sm">
        <h3 class="text-xl font-bold text-on-surface mb-6 flex items-center gap-2">
          <span class="material-symbols-outlined text-primary">photo_library</span>
          현장 사진
        </h3>
        <div class="grid grid-cols-2 gap-4">
          <div class="space-y-2">
            <div class="aspect-video bg-surface-container-high rounded-xl overflow-hidden">
              <img src="https://images.unsplash.com/photo-1581092160562-40aa08e78837?auto=format&fit=crop&q=80&w=800" alt="점검 전" class="w-full h-full object-cover">
            </div>
            <p class="text-center text-xs font-bold text-on-surface-variant/60 uppercase">조치 전</p>
          </div>
          <div class="space-y-2">
            <div class="aspect-video bg-surface-container-high rounded-xl overflow-hidden">
              <img src="https://images.unsplash.com/photo-1581092918056-0c4c3acd3789?auto=format&fit=crop&q=80&w=800" alt="점검 후" class="w-full h-full object-cover">
            </div>
            <p class="text-center text-xs font-bold text-on-surface-variant/60 uppercase">조치 후</p>
          </div>
        </div>
      </section>
    </div>

    <!-- Sidebar / Attachment Area -->
    <div class="space-y-8">
      <!-- Download Documents -->
      <section class="bg-surface-container-lowest p-6 rounded-2xl border border-outline-variant/10 shadow-sm">
        <h3 class="text-lg font-bold text-on-surface mb-4">관련 문서</h3>
        <div class="space-y-3">
          <button class="w-full flex items-center justify-between p-3 bg-surface-container-low hover:bg-surface-container-high rounded-xl transition-colors group">
            <div class="flex items-center gap-3 text-left">
              <span class="material-symbols-outlined text-red-500">picture_as_pdf</span>
              <div>
                <p class="text-sm font-bold text-on-surface">점검 결과 보고서.pdf</p>
                <p class="text-[10px] text-on-surface-variant/60">1.2 MB</p>
              </div>
            </div>
            <span class="material-symbols-outlined text-stone-400 group-hover:text-primary transition-colors">download</span>
          </button>
          <button class="w-full flex items-center justify-between p-3 bg-surface-container-low hover:bg-surface-container-high rounded-xl transition-colors group">
            <div class="flex items-center gap-3 text-left">
              <span class="material-symbols-outlined text-blue-500">description</span>
              <div>
                <p class="text-sm font-bold text-on-surface">부품 구입 영수증.jpg</p>
                <p class="text-[10px] text-on-surface-variant/60">450 KB</p>
              </div>
            </div>
            <span class="material-symbols-outlined text-stone-400 group-hover:text-primary transition-colors">download</span>
          </button>
        </div>
      </section>

      <!-- History Timeline -->
      <section class="bg-surface-container-lowest p-6 rounded-2xl border border-outline-variant/10 shadow-sm">
        <h3 class="text-lg font-bold text-on-surface mb-4">최근 이력</h3>
        <div class="space-y-6 relative before:absolute before:left-[11px] before:top-2 before:bottom-2 before:w-px before:bg-outline-variant/30">
          <div class="relative pl-8">
            <div class="absolute left-0 top-1.5 w-6 h-6 bg-primary rounded-full border-4 border-surface-container-lowest z-10"></div>
            <p class="text-xs font-bold text-primary mb-1">2024.03.15</p>
            <p class="text-sm font-semibold text-on-surface">베어링 교체 및 조치 완료</p>
          </div>
          <div class="relative pl-8">
            <div class="absolute left-0 top-1.5 w-6 h-6 bg-surface-container-high rounded-full border-4 border-surface-container-lowest z-10"></div>
            <p class="text-xs font-bold text-on-surface-variant/60 mb-1">2024.03.14</p>
            <p class="text-sm font-semibold text-on-surface">이상 소음 접수 및 현장 확인</p>
          </div>
          <div class="relative pl-8">
            <div class="absolute left-0 top-1.5 w-6 h-6 bg-surface-container-high rounded-full border-4 border-surface-container-lowest z-10"></div>
            <p class="text-xs font-bold text-on-surface-variant/60 mb-1">2023.12.10</p>
            <p class="text-sm font-semibold text-on-surface">동절기 정기 점검 (양호)</p>
          </div>
        </div>
        <button class="w-full mt-6 py-3 text-sm font-bold text-primary hover:bg-primary/5 rounded-xl transition-colors border border-primary/20">
          전체 이력 보기
        </button>
      </section>
    </div>
  </div>
</main>
</body></html>