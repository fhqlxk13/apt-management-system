<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!doctype html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1.0" />
  <title>우리집맵핑 · 중앙관리 대시보드</title>
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
  <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet" />
  <link rel="stylesheet" href="${ctx}/css/centralAside.css" />
  <link rel="stylesheet" href="${ctx}/css/centralHeader.css" />
  <link rel="stylesheet" href="${ctx}/css/centralCommon.css" />
  <script defer src="${ctx}/js/central/admin/toggleSidebar.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.4/dist/chart.umd.min.js"></script>
  <style>
    /* ── 한 화면 고정 레이아웃 (이 파일 전용) ──────────────────── */
    body { overflow: hidden; }

    /* centralHeader.css .main-content 덮어씀 */
    #centralDash {
      flex: 1;
      min-height: 0;
      overflow: hidden;
      padding: 13px 22px 11px;
      display: flex;
      flex-direction: column;
      gap: 10px;
    }

    /* page-header 컴팩트 */
    #centralDash .page-header   { margin-bottom: 0; }
    #centralDash .page-title    { font-size: 17px; }
    #centralDash .page-subtitle { font-size: 12px; margin-top: 1px; }

    /* KPI 컴팩트 */
    #centralDash .c-kpi-grid        { margin-bottom: 0; gap: 10px; }
    #centralDash .c-kpi-card        { padding: 11px 16px; gap: 3px; cursor: default; }
    #centralDash .c-kpi-card__value { font-size: 22px; letter-spacing: -0.3px; }
    #centralDash .c-kpi-card__label .material-symbols-rounded,
    #centralDash .c-kpi-card__delta .material-symbols-rounded { font-size: 13px; }

    /* ── 컨텐츠 2행 그리드 ─────────────────────────────────────── */
    .dash-rows {
      flex: 1;
      min-height: 0;
      display: flex;
      flex-direction: column;
      gap: 10px;
    }
    .dash-row-charts {          /* Row 1: 차트 영역 */
      flex: 55;
      min-height: 0;
      display: grid;
      grid-template-columns: 2fr 1fr;
      gap: 10px;
    }
    .dash-row-tables {          /* Row 2: 테이블 영역 */
      flex: 45;
      min-height: 0;
      display: grid;
      grid-template-columns: 1fr 1fr 1fr;
      gap: 10px;
    }

    /* dash-rows 안 카드: 셀을 꽉 채움 */
    .dash-rows .c-card {
      display: flex;
      flex-direction: column;
      min-height: 0;
      overflow: hidden;
    }
    .dash-rows .c-card .c-card__header {
      padding: 11px 16px 0;
      margin-bottom: 0;
      flex-shrink: 0;
    }
    .dash-rows .c-card.c-card--divide .c-card__header { padding-bottom: 10px; }
    .dash-rows .c-card .c-card__body {
      flex: 1;
      min-height: 0;
      padding: 12px 16px 12px;
      display: flex;
      flex-direction: column;
    }
    .dash-rows .c-card.c-card--divide .c-card__body { padding-top: 12px; }

    /* 차트 캔버스 래퍼 */
    .chart-wrap {
      flex: 1;
      min-height: 0;
      position: relative;
    }

    /* 테이블 래퍼: 넘치면 내부 스크롤 */
    .dash-rows .c-table-wrap {
      flex: 1;
      min-height: 0;
      overflow-y: auto;
      scrollbar-width: thin;
      scrollbar-color: var(--border) transparent;
    }
    .dash-rows .c-table-wrap::-webkit-scrollbar       { width: 4px; }
    .dash-rows .c-table-wrap::-webkit-scrollbar-thumb { background: var(--border); border-radius: 2px; }

    /* 테이블 셀 밀도 */
    #centralDash .c-table th { font-size: 10px; padding: 6px 10px; }
    #centralDash .c-table td { font-size: 12px; padding: 6px 10px; }
  </style>
</head>
<body>

<!-- ========== SIDEBAR ========== -->
<aside class="sidebar" id="sidebar">
  <div class="sidebar-logo">
    <div class="logo-mark">
      <div class="logo-icon" id="logoIcon"><span class="material-symbols-rounded">home_work</span></div>
      <div class="logo-text">
        <h1>우리집맵핑</h1>
        <p>중앙관리 시스템</p>
      </div>
    </div>
    <button type="button" class="collapse-btn" id="btnCollapseSidebar" data-tooltip="사이드바 접기">
      <span class="material-symbols-rounded">left_panel_close</span>
    </button>
  </div>
  <nav class="sidebar-nav">
    <div class="nav-group">
      <span class="nav-item active" role="presentation" aria-current="page">
        <span class="material-symbols-rounded nav-icon">grid_view</span>
        <span class="nav-text">대시보드</span>
      </span>
    </div>
    <div class="section-divider"></div>
    <div class="nav-group">
      <span class="section-label">건물 · 입주민</span>
      <a href="${ctx}/central/aptSearch" class="nav-item">
        <span class="material-symbols-rounded nav-icon">manage_search</span>
        <span class="nav-text">매물 통합 검색</span>
      </a>
      <a href="${ctx}/central/buildRegister" class="nav-item">
        <span class="material-symbols-rounded nav-icon">apartment</span>
        <span class="nav-text">건물 등록 및 열람</span>
      </a>
      <a href="${ctx}/central/residentList" class="nav-item">
        <span class="material-symbols-rounded nav-icon">groups</span>
        <span class="nav-text">입주민 관리</span>
        <span class="nav-badge">3</span>
      </a>
    </div>
    <div class="section-divider"></div>
    <div class="nav-group">
      <span class="section-label">계약 · 재무</span>
      <a href="${ctx}/central/contractList" class="nav-item">
        <span class="material-symbols-rounded nav-icon">contract</span>
        <span class="nav-text">계약 관리</span>
        <span class="nav-badge yellow">5</span>
      </a>
      <a href="${ctx}/central/contractDoc" class="nav-item">
        <span class="material-symbols-rounded nav-icon">description</span>
        <span class="nav-text">서류 관리</span>
      </a>
      <a href="${ctx}/central/contractForm" class="nav-item">
        <span class="material-symbols-rounded nav-icon">edit_document</span>
        <span class="nav-text">서식 관리</span>
      </a>
      <a href="${ctx}/central/statistics" class="nav-item">
        <span class="material-symbols-rounded nav-icon">bar_chart_4_bars</span>
        <span class="nav-text">통계</span>
      </a>
    </div>
    <div class="section-divider"></div>
    <div class="nav-group">
      <span class="section-label">민원 · 소통</span>
      <a href="${ctx}/central/civilCom" class="nav-item">
        <span class="material-symbols-rounded nav-icon">support_agent</span>
        <span class="nav-text">민원 관리</span>
        <span class="nav-badge">8</span>
      </a>
      <a href="#" class="nav-item">
        <span class="material-symbols-rounded nav-icon">forum</span>
        <span class="nav-text">문의 관리</span>
      </a>
      <a href="${ctx}/central/notice" class="nav-item">
        <span class="material-symbols-rounded nav-icon">campaign</span>
        <span class="nav-text">공고 관리</span>
      </a>
      <a href="${ctx}/central/announcement" class="nav-item">
        <span class="material-symbols-rounded nav-icon">article</span>
        <span class="nav-text">통합 게시판 관리</span>
      </a>
    </div>
    <div class="section-divider"></div>
    <div class="nav-group">
      <span class="section-label">시설 · 시스템</span>
      <a href="${ctx}/central/facility" class="nav-item">
        <span class="material-symbols-rounded nav-icon">handyman</span>
        <span class="nav-text">시설 관리</span>
      </a>
      <a href="${ctx}/central/proHistory" class="nav-item">
        <span class="material-symbols-rounded nav-icon">warning</span>
        <span class="nav-text">비정상 세대 관리</span>
        <span class="nav-badge">2</span>
      </a>
      <a href="${ctx}/central/mngrRqstAprv" class="nav-item">
        <span class="material-symbols-rounded nav-icon">manage_accounts</span>
        <span class="nav-text">단지관리자 계정</span>
        <span class="nav-badge">5</span>
      </a>
    </div>
  </nav>
  <div class="admin-card">
    <div class="admin-avatar"><span class="material-symbols-rounded" style="color:#fff;font-size:18px">person</span></div>
    <div class="admin-info"><p>중앙관리자</p><span>운영 계정</span></div>
    <button type="button" class="icon-btn" data-tooltip="로그아웃" style="flex-shrink:0;margin-left:auto">
      <span class="material-symbols-rounded">logout</span>
    </button>
  </div>
</aside>

<!-- ========== MAIN ========== -->
<div class="main-wrap">
  <div class="topbar">
    <div class="breadcrumb">
      <span class="material-symbols-rounded" style="font-size:14px">home</span>
      <span style="margin:0 4px">/</span>
      <span>중앙관리</span>
      <span style="margin:0 4px">/</span>
      <span class="bc-current">대시보드</span>
    </div>
    <div class="topbar-actions">
      <button type="button" class="topbar-icon-btn" data-tooltip="알림">
        <span class="material-symbols-rounded">notifications</span>
        <span class="dot"></span>
      </button>
      <button type="button" class="topbar-icon-btn" data-tooltip="설정">
        <span class="material-symbols-rounded">settings</span>
      </button>
    </div>
  </div>

  <div class="main-content" id="centralDash">

    <!-- PAGE HEADER -->
    <div class="page-header">
      <div>
        <div class="page-title">중앙관리 대시보드</div>
        <div class="page-subtitle">전사 단지·계약·민원 처리 현황 요약 &middot; 상세는 각 업무 메뉴에서 조회합니다.</div>
      </div>
      <div class="page-header__right">
        <span class="page-meta">
          <span class="material-symbols-rounded">schedule</span>
          갱신 <span id="dashTs"></span>
        </span>
        <button type="button" class="c-btn c-btn--sm" onclick="location.reload()">
          <span class="material-symbols-rounded">refresh</span>새로고침
        </button>
      </div>
    </div>

    <!-- KPI CARDS -->
    <div class="c-kpi-grid">
      <div class="c-kpi-card">
        <div class="c-kpi-card__label"><span class="material-symbols-rounded">apartment</span>등록 단지</div>
        <div class="c-kpi-card__value">47<span class="unit">개</span></div>
        <div class="c-kpi-card__delta up">
          <span class="material-symbols-rounded">arrow_upward</span>이번 달 +2 신규
        </div>
      </div>
      <div class="c-kpi-card">
        <div class="c-kpi-card__label"><span class="material-symbols-rounded">contract</span>진행 계약·신청</div>
        <div class="c-kpi-card__value">23<span class="unit">건</span></div>
        <div class="c-kpi-card__delta" style="color:var(--yellow)">
          <span class="material-symbols-rounded">schedule</span>만료 임박 5건 포함
        </div>
      </div>
      <div class="c-kpi-card">
        <div class="c-kpi-card__label"><span class="material-symbols-rounded">support_agent</span>민원·문의 대기</div>
        <div class="c-kpi-card__value">8<span class="unit">건</span></div>
        <div class="c-kpi-card__delta down">
          <span class="material-symbols-rounded">arrow_downward</span>전일 대비 -3건
        </div>
      </div>
      <div class="c-kpi-card">
        <div class="c-kpi-card__label"><span class="material-symbols-rounded">manage_accounts</span>관리자 승인 대기</div>
        <div class="c-kpi-card__value">5<span class="unit">건</span></div>
        <div class="c-kpi-card__delta" style="color:var(--text-tertiary);font-weight:500">
          단지관리자 계정 메뉴
        </div>
      </div>
    </div>

    <!-- CONTENT ROWS -->
    <div class="dash-rows">

      <!-- Row 1: 차트 2개 -->
      <div class="dash-row-charts">

        <!-- Bar Chart: 최근 6개월 계약 체결 현황 -->
        <div class="c-card c-card--divide">
          <div class="c-card__header">
            <div>
              <div class="c-card__title">최근 6개월 계약 체결 현황</div>
              <div class="c-card__sub">전세·월세 월별 신규 계약 건수</div>
            </div>
            <div class="c-card__actions">
              <a href="${ctx}/central/contractList" class="c-btn c-btn--sm">계약 관리</a>
            </div>
          </div>
          <div class="c-card__body">
            <div class="chart-wrap">
              <canvas id="chartBar"></canvas>
            </div>
          </div>
        </div>

        <!-- Doughnut: 민원 처리 현황 -->
        <div class="c-card c-card--divide">
          <div class="c-card__header">
            <div>
              <div class="c-card__title">민원 처리 현황</div>
              <div class="c-card__sub">전체 59건 기준</div>
            </div>
            <div class="c-card__actions">
              <a href="${ctx}/central/civilCom" class="c-btn c-btn--sm">민원 관리</a>
            </div>
          </div>
          <div class="c-card__body">
            <div class="chart-wrap">
              <canvas id="chartDoughnut"></canvas>
            </div>
          </div>
        </div>

      </div><!-- /dash-row-charts -->

      <!-- Row 2: 테이블 3개 -->
      <div class="dash-row-tables">

        <!-- 계약 만료 알림 -->
        <div class="c-card c-card--divide">
          <div class="c-card__header">
            <div>
              <div class="c-card__title">계약·만료 알림</div>
              <div class="c-card__sub">D-30 이내 · 해지 요청</div>
            </div>
            <div class="c-card__actions">
              <a href="${ctx}/central/contractList" class="c-btn c-btn--sm">전체</a>
            </div>
          </div>
          <div class="c-card__body">
            <div class="c-table-wrap">
              <table class="c-table">
                <thead>
                  <tr>
                    <th>계약번호</th><th>단지 · 세대</th><th>구분</th><th>이벤트</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td class="td-num">CT-2024-1103</td>
                    <td>강남 하이빌 101-302</td>
                    <td><span class="c-badge c-badge--jeonse">전세</span></td>
                    <td><span class="c-status c-status--danger"><span class="c-status__dot"></span>만료 D-14</span></td>
                  </tr>
                  <tr>
                    <td class="td-num">CT-2025-0188</td>
                    <td>인천 해오름 301-1104</td>
                    <td><span class="c-badge c-badge--wolse">월세</span></td>
                    <td><span class="c-status c-status--danger"><span class="c-status__dot"></span>만료 D-7</span></td>
                  </tr>
                  <tr>
                    <td class="td-num">CT-2024-0892</td>
                    <td>마포 그린파크 202-105</td>
                    <td><span class="c-badge c-badge--wolse">월세</span></td>
                    <td><span class="c-status c-status--pending"><span class="c-status__dot"></span>중도해지 요청</span></td>
                  </tr>
                  <tr>
                    <td class="td-num">CT-2025-0041</td>
                    <td>판교 스카이뷰 101-801</td>
                    <td><span class="c-badge c-badge--jeonse">전세</span></td>
                    <td><span class="c-status c-status--pending"><span class="c-status__dot"></span>만료 D-30</span></td>
                  </tr>
                  <tr>
                    <td class="td-num">CT-2025-0223</td>
                    <td>강남 하이빌 201-504</td>
                    <td><span class="c-badge c-badge--jeonse">전세</span></td>
                    <td><span class="c-status c-status--neutral"><span class="c-status__dot"></span>갱신 협의중</span></td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>

        <!-- 민원·문의 큐 -->
        <div class="c-card c-card--divide">
          <div class="c-card__header">
            <div>
              <div class="c-card__title">민원·문의 큐</div>
              <div class="c-card__sub">미처리 우선 · 최신 순</div>
            </div>
            <a href="${ctx}/central/civilCom" class="c-btn c-btn--sm">전체</a>
          </div>
          <div class="c-card__body">
            <div class="c-table-wrap">
              <table class="c-table">
                <thead>
                  <tr>
                    <th>접수번호</th><th>유형</th><th>단지·동호</th><th>요지</th><th>상태</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td class="td-num">CM-2026-0091</td>
                    <td><span class="c-badge c-badge--danger">긴급</span></td>
                    <td>강남 하이빌 101-302</td>
                    <td>엘리베이터 갇힘</td>
                    <td><span class="c-status c-status--danger"><span class="c-status__dot"></span>접수</span></td>
                  </tr>
                  <tr>
                    <td class="td-num">CM-2026-0090</td>
                    <td><span class="c-badge c-badge--neutral">시설</span></td>
                    <td>마포 그린파크 202-105</td>
                    <td>주차장 천장 누수</td>
                    <td><span class="c-status c-status--pending"><span class="c-status__dot"></span>처리중</span></td>
                  </tr>
                  <tr>
                    <td class="td-num">CM-2026-0089</td>
                    <td><span class="c-badge c-badge--neutral">문의</span></td>
                    <td>판교 스카이뷰 101-801</td>
                    <td>관리비 산정 이의</td>
                    <td><span class="c-status c-status--pending"><span class="c-status__dot"></span>처리중</span></td>
                  </tr>
                  <tr>
                    <td class="td-num">CM-2026-0088</td>
                    <td><span class="c-badge c-badge--neutral">민원</span></td>
                    <td>인천 해오름 301-1104</td>
                    <td>층간소음 지속</td>
                    <td><span class="c-status c-status--pending"><span class="c-status__dot"></span>접수</span></td>
                  </tr>
                  <tr>
                    <td class="td-num">CM-2026-0087</td>
                    <td><span class="c-badge c-badge--neutral">시설</span></td>
                    <td>강남 하이빌 201-504</td>
                    <td>복도 조명 불량</td>
                    <td><span class="c-status c-status--active"><span class="c-status__dot"></span>완료</span></td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>

        <!-- 시설·비정상 세대 -->
        <div class="c-card c-card--divide">
          <div class="c-card__header">
            <div>
              <div class="c-card__title">시설·비정상 세대</div>
              <div class="c-card__sub">검침 이상 · 장기부재 · 미납</div>
            </div>
            <div class="c-card__actions">
              <a href="${ctx}/central/facility" class="c-btn c-btn--sm">시설</a>
              <a href="${ctx}/central/proHistory" class="c-btn c-btn--sm">비정상</a>
            </div>
          </div>
          <div class="c-card__body">
            <div class="c-table-wrap">
              <table class="c-table">
                <thead>
                  <tr>
                    <th>이슈번호</th><th>단지 · 동호</th><th>코드</th><th>발생일</th><th>비고</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td class="td-num">IS-2026-0018</td>
                    <td>강남 하이빌 101-302</td>
                    <td><span class="c-badge c-badge--danger">EV-ERR</span></td>
                    <td class="td-num">05-08</td>
                    <td>수리 업체 출동 중</td>
                  </tr>
                  <tr>
                    <td class="td-num">IS-2026-0017</td>
                    <td>마포 그린파크 B1</td>
                    <td><span class="c-badge c-badge--pending">WTR-101</span></td>
                    <td class="td-num">05-07</td>
                    <td>배관 점검 예정 (5/9)</td>
                  </tr>
                  <tr>
                    <td class="td-num">IS-2026-0016</td>
                    <td>인천 해오름 201-708</td>
                    <td><span class="c-badge c-badge--pending">PWR-03</span></td>
                    <td class="td-num">05-06</td>
                    <td>전기 차단기 불량</td>
                  </tr>
                  <tr>
                    <td class="td-num">IS-2026-0015</td>
                    <td>판교 스카이뷰 101-203</td>
                    <td><span class="c-badge c-badge--neutral">ABN-LONG</span></td>
                    <td class="td-num">05-04</td>
                    <td>장기 부재 60일 초과</td>
                  </tr>
                  <tr>
                    <td class="td-num">IS-2026-0014</td>
                    <td>강남 하이빌 302-1002</td>
                    <td><span class="c-badge c-badge--neutral">ABN-UNPD</span></td>
                    <td class="td-num">05-02</td>
                    <td>관리비 3개월 미납</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>

      </div><!-- /dash-row-tables -->

    </div><!-- /dash-rows -->

  </div><!-- /main-content #centralDash -->
</div><!-- /main-wrap -->

<script>
document.addEventListener("DOMContentLoaded", function () {

  /* ── 갱신 시각 ── */
  var el = document.getElementById("dashTs");
  if (el) el.textContent = new Date().toLocaleString("ko-KR");

  /* ── 공통 폰트 설정 ── */
  Chart.defaults.font.family = "'Noto Sans KR', sans-serif";
  Chart.defaults.font.size   = 11;
  Chart.defaults.color       = "#6b7280";

  /* ── Doughnut 중앙 텍스트 플러그인 ── */
  var centerLabelPlugin = {
    id: "centerLabel",
    afterDraw: function (chart) {
      if (chart.config.type !== "doughnut") return;
      var ctx    = chart.ctx;
      var cx     = chart.chartArea.left + (chart.chartArea.right  - chart.chartArea.left) / 2;
      var cy     = chart.chartArea.top  + (chart.chartArea.bottom - chart.chartArea.top)  / 2;
      var total  = chart.data.datasets[0].data.reduce(function (a, b) { return a + b; }, 0);
      ctx.save();
      ctx.textAlign    = "center";
      ctx.textBaseline = "middle";
      ctx.font         = "700 20px 'Noto Sans KR', sans-serif";
      ctx.fillStyle    = "#111827";
      ctx.fillText(total + "건", cx, cy - 7);
      ctx.font         = "500 11px 'Noto Sans KR', sans-serif";
      ctx.fillStyle    = "#9ca3af";
      ctx.fillText("전체 민원", cx, cy + 11);
      ctx.restore();
    }
  };
  Chart.register(centerLabelPlugin);

  /* ── Bar Chart: 최근 6개월 계약 체결 현황 ── */
  new Chart(document.getElementById("chartBar"), {
    type: "bar",
    data: {
      labels: ["2025-12", "2026-01", "2026-02", "2026-03", "2026-04", "2026-05"],
      datasets: [
        {
          label: "전세",
          data: [3, 5, 4, 6, 3, 2],
          backgroundColor: "rgba(59,130,246,0.72)",
          borderRadius: 3,
          borderSkipped: false
        },
        {
          label: "월세",
          data: [4, 3, 5, 4, 5, 2],
          backgroundColor: "rgba(249,115,22,0.72)",
          borderRadius: 3,
          borderSkipped: false
        }
      ]
    },
    options: {
      animation: false,
      responsive: true,
      maintainAspectRatio: false,
      plugins: {
        legend: {
          position: "bottom",
          labels: { padding: 14, boxWidth: 11, boxHeight: 11 }
        },
        tooltip: {
          callbacks: {
            label: function (ctx) { return " " + ctx.dataset.label + ": " + ctx.parsed.y + "건"; }
          }
        }
      },
      scales: {
        x: {
          stacked: true,
          grid: { display: false },
          border: { color: "#e8eaed" },
          ticks: { maxRotation: 0 }
        },
        y: {
          stacked: true,
          beginAtZero: true,
          grid: { color: "#f3f4f6", drawBorder: false },
          border: { display: false },
          ticks: { stepSize: 2, callback: function (v) { return v + "건"; } }
        }
      }
    }
  });

  /* ── Doughnut Chart: 민원 처리 현황 ── */
  new Chart(document.getElementById("chartDoughnut"), {
    type: "doughnut",
    data: {
      labels: ["접수 대기", "처리중", "처리 완료"],
      datasets: [{
        data: [8, 14, 37],
        backgroundColor: ["#dc2626", "#f59e0b", "#16a34a"],
        hoverBackgroundColor: ["#b91c1c", "#d97706", "#15803d"],
        borderWidth: 0,
        hoverOffset: 0
      }]
    },
    options: {
      animation: false,
      responsive: true,
      maintainAspectRatio: false,
      cutout: "64%",
      plugins: {
        legend: {
          position: "bottom",
          labels: {
            padding: 14,
            boxWidth: 11,
            boxHeight: 11,
            generateLabels: function (chart) {
              var data = chart.data;
              return data.labels.map(function (label, i) {
                var val = data.datasets[0].data[i];
                return {
                  text: label + "  " + val + "건",
                  fillStyle: data.datasets[0].backgroundColor[i],
                  strokeStyle: "transparent",
                  index: i
                };
              });
            }
          }
        },
        tooltip: {
          callbacks: {
            label: function (ctx) { return " " + ctx.label + ": " + ctx.parsed + "건"; }
          }
        }
      }
    }
  });

});
</script>
</body>
</html>
