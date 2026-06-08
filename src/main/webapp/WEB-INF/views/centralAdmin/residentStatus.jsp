
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true"%>
<!doctype html>
<html lang="ko">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1.0" />
    <title>우리집맵핑 · 입주 현황</title>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet" />
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/centralAside.css" />
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/centralHeader.css" />
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/centralCommon.css" />
    <%--<script defer src="<%= request.getContextPath() %>/js/centralAside.js"></script>
    <script defer src="<%= request.getContextPath() %>/js/centralHeader.js"></script>--%>
    <style id="page-style">
      /* residentStatus.jsp 전용 — 입주 현황 시각화 */
      /* progress-bar-*, legend-dot, grid-legend → centralCommon.css 제공 */

      .building-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
        gap: 12px;
      }
      .bldg-card {
        border: 1.5px solid var(--border);
        border-radius: 10px;
        padding: 14px;
        cursor: pointer;
        background: #fff;
        transition: border-color 0.15s, background 0.15s, box-shadow 0.15s;
      }
      .bldg-card:hover {
        border-color: var(--accent);
        background: #eff6ff;
      }
      .bldg-card.is-selected {
        border-color: var(--accent);
        background: #eff6ff;
        box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.15);
      }
      .bldg-card .bname {
        font-size: 14px;
        font-weight: 800;
        margin-bottom: 6px;
        color: var(--text-primary);
      }
      .bldg-card .bstat {
        font-size: 12px;
        color: var(--text-secondary);
        margin-bottom: 8px;
      }
      .bldg-card .mini-bar-bg {
        height: 5px;
        background: var(--gray-soft);
        border-radius: 99px;
        overflow: hidden;
      }
      .bldg-card .mini-bar-fill {
        height: 100%;
        background: var(--accent);
        border-radius: 99px;
      }

      .floor-row {
        display: flex;
        align-items: center;
        gap: 6px;
        margin-bottom: 6px;
      }
      .floor-label {
        width: 40px;
        font-size: 11px;
        font-weight: 800;
        color: var(--text-tertiary);
        text-align: right;
        flex-shrink: 0;
      }
      .unit-cell {
        width: 56px;
        height: 38px;
        border-radius: 6px;
        font-size: 11px;
        font-weight: 700;
        display: flex;
        align-items: center;
        justify-content: center;
        cursor: default;
        position: relative;
        border: 1px solid transparent;
      }
      .unit-cell.occupied { background: #dbeafe; color: #1d4ed8; }
      .unit-cell.vacant   { background: #f3f4f6; color: #6b7280; border-color: #e5e7eb; }
      .unit-cell.abnormal { background: #fef9c3; color: #a16207; }
      .unit-cell[data-tip] { cursor: pointer; }
      .unit-cell[data-tip]::after {
        content: attr(data-tip);
        position: absolute;
        bottom: calc(100% + 6px);
        left: 50%;
        transform: translateX(-50%);
        background: #1a2332;
        color: #fff;
        font-size: 11px;
        padding: 5px 9px;
        border-radius: 6px;
        white-space: nowrap;
        opacity: 0;
        pointer-events: none;
        transition: opacity 0.15s;
        z-index: 200;
        font-weight: 500;
      }
      .unit-cell[data-tip]:hover::after { opacity: 1; }
    </style>
  </head>
  <body>
    <aside class="sidebar" id="sidebar">
      <div class="sidebar-logo">
        <div class="logo-mark">
          <div class="logo-icon" id="logoIcon"><span class="material-symbols-rounded">home_work</span></div>
          <div class="logo-text">
            <h1>우리집맵핑</h1>
            <p>중앙관리 시스템</p>
          </div>
        </div>
        <button class="collapse-btn" onclick="toggleSidebar()" data-tooltip="사이드바 접기">
          <span class="material-symbols-rounded">left_panel_close</span>
        </button>
      </div>
      <nav class="sidebar-nav">
        <div class="nav-group">
          <a class="nav-item active" data-page="대시보드" data-parent="대시보드"> <span class="material-symbols-rounded nav-icon">grid_view</span><span class="nav-text">대시보드</span> </a>
        </div>
        <div class="section-divider"></div>
        <div class="nav-group">
          <span class="section-label">건물 · 입주민</span>
          <a href="<%= request.getContextPath() %>/centralAdmin/buildSearch" class="nav-item" data-page="매물 통합 검색" data-parent="건물·입주민"> <span class="material-symbols-rounded nav-icon">manage_search</span><span class="nav-text">매물 통합 검색</span> </a>
          <a href="<%= request.getContextPath() %>/centralAdmin/buildRegister" class="nav-item" data-page="건물 등록 및 열람" data-parent="건물·입주민"> <span class="material-symbols-rounded nav-icon">apartment</span><span class="nav-text">건물 등록 및 열람</span> </a>
          <a href="<%= request.getContextPath() %>/centralAdmin/residentList" class="nav-item" data-page="입주민 관리" data-parent="건물·입주민"> <span class="material-symbols-rounded nav-icon">groups</span><span class="nav-text">입주민 관리</span> </a>
        </div>
        <div class="section-divider"></div>
        <div class="nav-group">
          <span class="section-label">계약 · 재무</span>
          <a href="<%= request.getContextPath() %>/centralAdmin/contractList.do" class="nav-item" data-page="계약 관리" data-parent="계약·재무"> <span class="material-symbols-rounded nav-icon">contract</span><span class="nav-text">계약 관리</span> </a>
          <a href="<%= request.getContextPath() %>/centralAdmin/statistics" class="nav-item" data-page="통계" data-parent="계약·재무"> <span class="material-symbols-rounded nav-icon">bar_chart_4_bars</span><span class="nav-text">통계</span> </a>
        </div>
        <div class="section-divider"></div>
        <div class="nav-group">
          <span class="section-label">민원 · 소통</span>
          <a href="<%= request.getContextPath() %>/centralAdmin/civilCom" class="nav-item" data-page="민원 관리" data-parent="민원·소통">
            <span class="material-symbols-rounded nav-icon">support_agent</span><span class="nav-text">민원 관리</span>
            <span class="nav-badge">3</span>
          </a>
          <a href="<%= request.getContextPath() %>/centralAdmin/ai" class="nav-item" data-page="문의 관리" data-parent="민원·소통">
            <span class="material-symbols-rounded nav-icon">forum</span><span class="nav-text">문의 관리</span>
            <span class="nav-badge yellow">4</span>
          </a>
          <a href="<%= request.getContextPath() %>/centralAdmin/announcement" class="nav-item" data-page="공고 관리" data-parent="민원·소통"> <span class="material-symbols-rounded nav-icon">campaign</span><span class="nav-text">공고 관리</span> </a>
          <a href="<%= request.getContextPath() %>/centralAdmin/notice" class="nav-item" data-page="통합 게시판 관리" data-parent="민원·소통"> <span class="material-symbols-rounded nav-icon">article</span><span class="nav-text">통합 게시판 관리</span> </a>
        </div>
        <div class="section-divider"></div>
        <div class="nav-group">
          <span class="section-label">시설 · 시스템</span>
          <a href="<%= request.getContextPath() %>/centralAdmin/facility" class="nav-item" data-page="시설 관리" data-parent="시설·시스템"> <span class="material-symbols-rounded nav-icon">handyman</span><span class="nav-text">시설 관리</span> </a>
          <a href="<%= request.getContextPath() %>/centralAdmin/proHistory" class="nav-item" data-page="비정상 세대 관리" data-parent="시설·시스템"> <span class="material-symbols-rounded nav-icon">warning</span><span class="nav-text">비정상 세대 관리</span> </a>
          <a href="<%= request.getContextPath() %>/centralAdmin/mngrRqstAprv" class="nav-item" data-page="단지관리자 계정" data-parent="시설·시스템"> <span class="material-symbols-rounded nav-icon">manage_accounts</span><span class="nav-text">단지관리자 계정</span> </a>
        </div>
      </nav>
      <div class="admin-card">
        <div class="admin-avatar"><span class="material-symbols-rounded" style="color: #fff; font-size: 18px">person</span></div>
        <div class="admin-info">
          <p>중앙관리자</p>
          <span>클로드 최고</span>
        </div>
        <button class="icon-btn" data-tooltip="로그아웃" style="flex-shrink: 0; margin-left: auto">
          <span class="material-symbols-rounded">logout</span>
        </button>
      </div>
    </aside>

    <div class="main-wrap">
      <div class="topbar">
        <div class="breadcrumb">
          <span class="material-symbols-rounded" style="font-size: 14px">home</span>
          <span style="margin: 0 4px">/</span>
          <span id="bc-parent">대시보드</span>
          <span style="margin: 0 4px">/</span>
          <span class="bc-current" id="bc-current">입주 현황</span>
        </div>
        <div class="topbar-actions">
          <button class="topbar-icon-btn" data-tooltip="알림">
            <span class="material-symbols-rounded">notifications</span>
            <div class="dot"></div>
          </button>
          <button class="topbar-icon-btn" data-tooltip="설정">
            <span class="material-symbols-rounded">settings</span>
          </button>
        </div>
      </div>

      <div class="main-content">
        <div class="page-header">
          <div>
            <div class="page-title">입주 현황 대시보드</div>
            <div class="page-subtitle">단지 → 동 → 호수 순으로 드릴다운하며 입주율과 공실, 미등록 세대를 한눈에 확인하세요.</div>
          </div>
          <div class="page-header__right">
          </div>
        </div>

        <!-- 단지 탭 + 동별 카드 -->
        <div class="c-card c-card--divide">
          <div class="c-card__header">
            <div>
              <div class="c-card__title">단지 · 동별 현황</div>
              <div class="c-card__sub">단지를 선택하면 해당 단지의 동별 입주율이 표시됩니다.</div>
            </div>
            <div class="c-tab-bar" id="complex-tabs"></div>
          </div>
          <div class="c-card__body">
            <div class="building-grid" id="building-grid"></div>
          </div>
        </div>

        <!-- 층/호수 그리드 -->
        <div class="c-card c-card--divide">
          <div class="c-card__header">
            <div>
              <div class="c-card__title" id="grid-title">층/호수 현황</div>
              <div class="c-card__sub">호수에 마우스를 올리면 입주민 정보를 확인할 수 있습니다.</div>
            </div>
            <div class="c-legend">
              <span class="c-legend__item"><span class="c-legend__dot" style="background: #dbeafe"></span>입주</span>
              <span class="c-legend__item"><span class="c-legend__dot" style="background: #f3f4f6; border: 1px solid #e5e7eb"></span>공실</span>
              <span class="c-legend__item"><span class="c-legend__dot" style="background: #fef9c3"></span>비정상·미등록</span>
            </div>
          </div>
          <div class="c-card__body">
            <div id="unit-grid">
              <div class="c-empty">
                <div class="c-empty__title">동을 선택해주세요</div>
                <div class="c-empty__sub">위 카드에서 동을 선택하면 층/호수 현황이 표시됩니다.</div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <script>
      /* ─── 샘플 데이터 생성 ─── */
      const NAMES = ["김민준", "이서연", "박지후", "최수아", "정도윤", "한채원", "윤준서", "임나은", "오지훈", "신아름", "류현우", "강다연"];
      const PHONES = ["010-1234-****", "010-2345-****", "010-3456-****", "010-4567-****", "010-5678-****", "010-6789-****"];

      function rng(seed) {
        let x = Math.sin(seed + 1) * 10000;
        return x - Math.floor(x);
      }

      // 단지 구성: 2개 단지, 각 3개 동, 각 동 10층 × 4호
      const COMPLEXES = {
        "우리집아파트 1단지": ["101동", "102동", "103동"],
        "우리집아파트 2단지": ["201동", "202동", "203동"],
      };
      const FLOORS = 10,
        UNITS_PER_FLOOR = 4;

      // 각 호수 상태 생성 (0=공실, 1=입주, 2=비정상)
      const unitData = {}; // unitData[동][층][호] = {status, name, phone}
      let seed = 0;
      for (const [cx, bldgs] of Object.entries(COMPLEXES)) {
        for (const b of bldgs) {
          unitData[b] = {};
          for (let f = FLOORS; f >= 1; f--) {
            unitData[b][f] = {};
            for (let u = 1; u <= UNITS_PER_FLOOR; u++) {
              seed++;
              const r = rng(seed);
              const status = r < 0.7 ? 1 : r < 0.9 ? 0 : 2;
              const ni = Math.floor(rng(seed + 100) * NAMES.length);
              const pi = Math.floor(rng(seed + 200) * PHONES.length);
              unitData[b][f][u] = { status, name: NAMES[ni], phone: PHONES[pi] };
            }
          }
        }
      }

      // 동 통계
      function bldgStats(b) {
        let total = 0,
          occ = 0,
          abn = 0;
        for (let f = FLOORS; f >= 1; f--)
          for (let u = 1; u <= UNITS_PER_FLOOR; u++) {
            const d = unitData[b][f][u];
            total++;
            if (d.status === 1) occ++;
            else if (d.status === 2) abn++;
          }
        return { total, occ, vac: total - occ - abn, abn };
      }

      // 전체 통계
      function allStats(complex) {
        const bldgs = COMPLEXES[complex];
        let total = 0,
          occ = 0,
          vac = 0;
        for (const b of bldgs) {
          const s = bldgStats(b);
          total += s.total;
          occ += s.occ;
          vac += s.vac;
        }
        return { total, occ, vac };
      }

      /* ─── 렌더 ─── */
      let curComplex = Object.keys(COMPLEXES)[0];
      let curBldg = null;

      function renderSummary() {
        const { total, occ, vac } = allStats(curComplex);
        const pct = Math.round((occ / total) * 100);
        // KPI 카드 제거됨: 상단 요약 렌더링은 생략
      }

      function renderComplexTabs() {
        const cont = document.getElementById("complex-tabs");
        cont.innerHTML = "";
        for (const cx of Object.keys(COMPLEXES)) {
          const btn = document.createElement("button");
          btn.className = "c-tab-btn" + (cx === curComplex ? " is-active" : "");
          btn.textContent = cx;
          btn.onclick = () => {
            curComplex = cx;
            curBldg = null;
            renderSummary();
            renderComplexTabs();
            renderBuildings();
            renderGrid();
          };
          cont.appendChild(btn);
        }
      }

      function renderBuildings() {
        const grid = document.getElementById("building-grid");
        grid.innerHTML = "";
        for (const b of COMPLEXES[curComplex]) {
          const { total, occ } = bldgStats(b);
          const pct = Math.round((occ / total) * 100);
          const card = document.createElement("div");
          card.className = "bldg-card" + (b === curBldg ? " is-selected" : "");
          card.innerHTML = `<div class="bname">${b}</div>
            <div class="bstat">${occ} / ${total} 세대 · ${pct}%</div>
            <div class="mini-bar-bg"><div class="mini-bar-fill" style="width:${pct}%"></div></div>`;
          card.onclick = () => {
            curBldg = b;
            renderBuildings();
            renderGrid();
          };
          grid.appendChild(card);
        }
      }

      function renderGrid() {
        const cont = document.getElementById("unit-grid");
        const title = document.getElementById("grid-title");
        if (!curBldg) {
          title.textContent = "층/호수 현황";
          cont.innerHTML = '<div class="c-empty"><div class="c-empty__title">동을 선택해주세요</div><div class="c-empty__sub">위 카드에서 동을 선택하면 층/호수 현황이 표시됩니다.</div></div>';
          return;
        }
        title.textContent = curBldg + " 층/호수 현황";
        let html = "";
        for (let f = FLOORS; f >= 1; f--) {
          html += `<div class="floor-row"><div class="floor-label">${f}F</div>`;
          for (let u = 1; u <= UNITS_PER_FLOOR; u++) {
            const d = unitData[curBldg][f][u];
            const cls = d.status === 1 ? "occupied" : d.status === 2 ? "abnormal" : "vacant";
            const tip = d.status === 1 ? `${d.name} · ${d.phone}` : d.status === 2 ? "미등록" : "공실";
            html += `<div class="unit-cell ${cls}" data-tip="${tip}">${u}호</div>`;
          }
          html += "</div>";
        }
        cont.innerHTML = html;
      }

      /* 초기 렌더 */
      renderSummary();
      renderComplexTabs();
      renderBuildings();
      renderGrid();
    </script>
    <script>
      function toggleSidebar(){var s=document.getElementById("sidebar");if(s)s.classList.toggle("collapsed");}
      var logoIcon=document.getElementById("logoIcon");
      if(logoIcon){logoIcon.onclick=function(){var s=document.getElementById("sidebar");if(s&&s.classList.contains("collapsed"))toggleSidebar();};}
    </script>
  </body>
</html>
