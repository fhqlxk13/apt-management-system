<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true"%>
<!doctype html>
<html lang="ko">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1.0" />
    <title>우리집맵핑 · 시설 관리</title>
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
      /* 시설 관리 페이지에서는 미답변 문의 플로팅 위젯을 사용하지 않음 */
      .floating-alert,
      #floating-alert {
        display: none !important;
      }
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
          <a class="nav-item" data-page="대시보드" data-parent="대시보드"><span class="material-symbols-rounded nav-icon">grid_view</span><span class="nav-text">대시보드</span></a>
        </div>
        <div class="section-divider"></div>
        <div class="nav-group">
          <span class="section-label">건물 · 입주민</span>
          <a href="<%= request.getContextPath() %>/centralAdmin/buildSearch" class="nav-item" data-page="매물 통합 검색" data-parent="건물·입주민"><span class="material-symbols-rounded nav-icon">manage_search</span><span class="nav-text">매물 통합 검색</span></a>
          <a href="<%= request.getContextPath() %>/centralAdmin/buildRegister" class="nav-item" data-page="건물 등록 및 열람" data-parent="건물·입주민"><span class="material-symbols-rounded nav-icon">apartment</span><span class="nav-text">건물 등록 및 열람</span></a>
          <a href="<%= request.getContextPath() %>/centralAdmin/residentList" class="nav-item" data-page="입주민 관리" data-parent="건물·입주민"><span class="material-symbols-rounded nav-icon">groups</span><span class="nav-text">입주민 관리</span></a>
        </div>
        <div class="section-divider"></div>
        <div class="nav-group">
          <span class="section-label">계약 · 재무</span>
          <a href="<%= request.getContextPath() %>/centralAdmin/contractList.do" class="nav-item" data-page="계약 관리" data-parent="계약·재무"><span class="material-symbols-rounded nav-icon">contract</span><span class="nav-text">계약 관리</span></a>
          <a href="<%= request.getContextPath() %>/centralAdmin/statistics" class="nav-item" data-page="통계" data-parent="계약·재무"><span class="material-symbols-rounded nav-icon">bar_chart_4_bars</span><span class="nav-text">통계</span></a>
        </div>
        <div class="section-divider"></div>
        <div class="nav-group">
          <span class="section-label">민원 · 소통</span>
          <a href="<%= request.getContextPath() %>/centralAdmin/civilCom" class="nav-item" data-page="민원 관리" data-parent="민원·소통"><span class="material-symbols-rounded nav-icon">support_agent</span><span class="nav-text">민원 관리</span><span class="nav-badge">3</span></a>
          <a href="<%= request.getContextPath() %>/centralAdmin/ai" class="nav-item" data-page="문의 관리" data-parent="민원·소통"><span class="material-symbols-rounded nav-icon">forum</span><span class="nav-text">문의 관리</span><span class="nav-badge yellow">4</span></a>
          <a href="<%= request.getContextPath() %>/centralAdmin/announcement" class="nav-item" data-page="공고 관리" data-parent="민원·소통"><span class="material-symbols-rounded nav-icon">campaign</span><span class="nav-text">공고 관리</span></a>
          <a href="<%= request.getContextPath() %>/centralAdmin/notice" class="nav-item" data-page="통합 게시판 관리" data-parent="민원·소통"><span class="material-symbols-rounded nav-icon">article</span><span class="nav-text">통합 게시판 관리</span></a>
        </div>
        <div class="section-divider"></div>
        <div class="nav-group">
          <span class="section-label">시설 · 시스템</span>
          <a href="<%= request.getContextPath() %>/centralAdmin/facility" class="nav-item active" data-page="시설 관리" data-parent="시설·시스템"><span class="material-symbols-rounded nav-icon">handyman</span><span class="nav-text">시설 관리</span></a>
          <a href="<%= request.getContextPath() %>/centralAdmin/proHistory" class="nav-item" data-page="비정상 세대 관리" data-parent="시설·시스템"><span class="material-symbols-rounded nav-icon">warning</span><span class="nav-text">비정상 세대 관리</span></a>
          <a href="<%= request.getContextPath() %>/centralAdmin/mngrRqstAprv" class="nav-item" data-page="단지관리자 계정" data-parent="시설·시스템"><span class="material-symbols-rounded nav-icon">manage_accounts</span><span class="nav-text">단지관리자 계정</span></a>
        </div>
      </nav>
      <div class="admin-card">
        <div class="admin-avatar"><span class="material-symbols-rounded" style="color: #fff; font-size: 18px">person</span></div>
        <div class="admin-info">
          <p>중앙관리자</p>
          <span>클로드 최고</span>
        </div>
        <button class="icon-btn" data-tooltip="로그아웃" style="flex-shrink: 0; margin-left: auto"><span class="material-symbols-rounded">logout</span></button>
      </div>
    </aside>

    <div class="main-wrap">
      <div class="topbar">
        <div class="breadcrumb">
          <span class="material-symbols-rounded" style="font-size: 14px">home</span>
          <span style="margin: 0 4px">/</span>
          <span>시설·시스템</span>
          <span style="margin: 0 4px">/</span>
          <span class="bc-current">시설 관리</span>
        </div>
        <div class="topbar-actions">
          <button class="topbar-icon-btn" data-tooltip="알림">
            <span class="material-symbols-rounded">notifications</span>
            <div class="dot"></div>
          </button>
          <button class="topbar-icon-btn" data-tooltip="설정"><span class="material-symbols-rounded">settings</span></button>
        </div>
      </div>

      <div class="main-content">
        <!-- 페이지 헤더 -->
        <div class="page-header">
          <div>
            <div class="page-title">시설 관리</div>
            <div class="page-subtitle">시설 점검 이력, 고장 통계, 업무 확인 상태를 통합 관리합니다.</div>
          </div>
          <div class="page-header__right">
            <span class="page-meta"><span class="material-symbols-rounded">schedule</span>기준 2026.04.26</span>
          </div>
        </div>

        <!-- 시설 점검 이력 -->
        <div class="tab-panel is-active" id="tab0">
          <div class="c-card c-card--divide">
            <div class="c-card__header">
              <div>
                <div class="c-card__title">시설 점검 이력</div>
                <div class="c-card__sub" id="tab0-subtitle">조회 결과를 표시합니다.</div>
              </div>
              <div class="c-card__actions">
                <input type="search" class="c-input" placeholder="시설명 검색" style="width: 160px" oninput="searchTab0(this.value)" />
                <input type="date" class="c-input" style="width: 138px" value="2026-04-01" />
                <span style="color: var(--text-tertiary); font-size: 13px">~</span>
                <input type="date" class="c-input" style="width: 138px" value="2026-04-22" />
                <select class="c-select" style="width: 120px" onchange="filterTab0Status(this.value)">
                  <option value="">전체 상태</option>
                  <option value="정상">정상</option>
                  <option value="점검중">점검중</option>
                  <option value="고장">고장</option>
                  <option value="미이행">미이행</option>
                </select>
              </div>
            </div>
            <div class="c-card__body" style="padding: 0">
              <div class="c-table-wrap">
                <table class="c-table">
                  <thead>
                    <tr>
                      <th>시설명</th>
                      <th style="width: 120px">위치</th>
                      <th style="width: 110px">점검 일자</th>
                      <th style="width: 100px">점검 결과</th>
                      <th style="width: 90px; text-align: right">고장 횟수</th>
                      <th style="width: 100px">고장 상태</th>
                      <th style="width: 100px">업무 상태</th>
                    </tr>
                  </thead>
                  <tbody id="tab0-tbody"></tbody>
                </table>
              </div>
              <div class="c-pagination" id="tab0-pagination"></div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 시설 상세 모달 -->
    <div class="c-modal-overlay is-hidden" id="detailOverlay" onclick="if (event.target === this) closeDetail();">
      <div class="c-modal" id="detailModal" role="dialog" aria-labelledby="detailTitle" aria-modal="true">
        <div class="c-modal__header">
          <span id="detailTitle">시설 상세</span>
          <button class="c-btn c-btn--ghost c-btn--sm" onclick="closeDetail()"><span class="material-symbols-rounded">close</span>닫기</button>
        </div>
        <div class="c-modal__body">
          <div class="c-info-grid" id="detailContent"></div>
        </div>
        <div class="c-modal__footer">
          <button class="c-btn c-btn--danger" onclick="closeDetail()">닫기</button>
          <button class="c-btn" onclick="closeDetail()">수정</button>
        </div>
      </div>
    </div>

    <script>
      const PAGE_SIZE = 10;

      const TAB0 = [
        { name: "엘리베이터 A", loc: "1동 1호기", date: "2026-04-10", result: "정상", failures: 0, fault: "정상", task: "완료" },
        { name: "주차 차단기", loc: "지하주차장", date: "2026-04-08", result: "고장", failures: 3, fault: "수리 필요", task: "처리중" },
        { name: "CCTV", loc: "공용현관", date: "2026-04-05", result: "정상", failures: 1, fault: "정상", task: "완료" },
        { name: "소방 설비", loc: "1~5동", date: "2026-04-03", result: "미이행", failures: 0, fault: "-", task: "대기" },
        { name: "엘리베이터 B", loc: "2동 1호기", date: "2026-03-28", result: "점검중", failures: 2, fault: "경미", task: "처리중" },
        { name: "급수펌프", loc: "지하 1층", date: "2026-03-25", result: "정상", failures: 0, fault: "정상", task: "완료" },
        { name: "공용 현관 도어", loc: "1동 입구", date: "2026-03-20", result: "고장", failures: 2, fault: "경미", task: "완료" },
        { name: "옥상 환풍기", loc: "5동 옥상", date: "2026-03-18", result: "정상", failures: 0, fault: "정상", task: "완료" },
        { name: "비상 발전기", loc: "관리동 지하", date: "2026-03-15", result: "점검중", failures: 1, fault: "경미", task: "처리중" },
        { name: "주차 차단기 B", loc: "지상주차장", date: "2026-03-10", result: "정상", failures: 0, fault: "정상", task: "완료" },
        { name: "엘리베이터 C", loc: "3동 1호기", date: "2026-03-05", result: "고장", failures: 4, fault: "수리 필요", task: "처리중" },
        { name: "조명 (공용)", loc: "복도 전체", date: "2026-03-01", result: "정상", failures: 0, fault: "정상", task: "완료" },
      ];

      const TAB1 = [
        { name: "엘리베이터 A", loc: "1동 1호기", inspect: "정상", failures: 0, last: "-", fault: "정상" },
        { name: "주차 차단기", loc: "지하주차장", inspect: "점검중", failures: 3, last: "2026-04-08", fault: "고장" },
        { name: "CCTV", loc: "공용현관", inspect: "미이행", failures: 5, last: "2026-04-05", fault: "고장" },
        { name: "소방 설비", loc: "1~5동", inspect: "정상", failures: 1, last: "2026-04-01", fault: "경미" },
        { name: "엘리베이터 B", loc: "2동 1호기", inspect: "점검중", failures: 2, last: "2026-03-28", fault: "경미" },
        { name: "엘리베이터 C", loc: "3동 1호기", inspect: "정상", failures: 4, last: "2026-03-05", fault: "고장" },
        { name: "공용 현관 도어", loc: "1동 입구", inspect: "정상", failures: 2, last: "2026-03-20", fault: "경미" },
      ];

      const TAB2 = [
        { name: "엘리베이터 A", date: "2026-04-10", result: "정상", task: "확인", manager: "시설팀", proc: "완료" },
        { name: "주차 차단기", date: "2026-04-08", result: "고장", task: "미확인", manager: "시설팀", proc: "처리중" },
        { name: "CCTV", date: "2026-04-05", result: "점검중", task: "미확인", manager: "관리팀", proc: "대기" },
        { name: "소방 설비", date: "2026-04-03", result: "미이행", task: "미확인", manager: "시설팀", proc: "대기" },
        { name: "엘리베이터 B", date: "2026-03-28", result: "점검중", task: "확인", manager: "시설팀", proc: "처리중" },
        { name: "급수펌프", date: "2026-03-25", result: "정상", task: "확인", manager: "시설팀", proc: "완료" },
      ];

      const RESULT_BADGE = {
        정상: "c-badge c-badge--active",
        점검중: "c-badge c-badge--pending",
        고장: "c-badge c-badge--danger",
        미이행: "c-badge c-badge--neutral",
        경미: "c-badge c-badge--pending",
        "수리 필요": "c-badge c-badge--danger",
        확인: "c-badge c-badge--active",
        미확인: "c-badge c-badge--danger",
      };
      function badge(text) {
        const cls = RESULT_BADGE[text] || "c-badge c-badge--neutral";
        return `<span class="${cls}">${text}</span>`;
      }

      const state = {
        tab0: { page: 1, q: "", status: "" },
        tab1: { page: 1, q: "", inspect: "" },
        tab2: { page: 1, q: "", task: "" },
      };

      function filteredTab0() {
        return TAB0.filter((r) => (!state.tab0.q || r.name.toLowerCase().includes(state.tab0.q.toLowerCase())) && (!state.tab0.status || r.result === state.tab0.status || r.fault === state.tab0.status));
      }
      function filteredTab1() {
        return TAB1.filter((r) => (!state.tab1.q || r.name.toLowerCase().includes(state.tab1.q.toLowerCase())) && (!state.tab1.inspect || r.inspect === state.tab1.inspect));
      }
      function filteredTab2() {
        return TAB2.filter((r) => (!state.tab2.q || r.name.toLowerCase().includes(state.tab2.q.toLowerCase())) && (!state.tab2.task || r.task === state.tab2.task));
      }

      let _detailData = null;

      function openDetail(title, fields) {
        document.getElementById("detailTitle").textContent = title;
        document.getElementById("detailContent").innerHTML = fields.map(([label, value]) => `<div class="c-info-block"><div class="c-label">${label}</div><div class="c-value">${value}</div></div>`).join("");
        document.getElementById("detailOverlay").classList.remove("is-hidden");
      }

      function closeDetail() {
        document.getElementById("detailOverlay").classList.add("is-hidden");
      }

      function renderTab0() {
        const all = filteredTab0();
        const last = Math.max(1, Math.ceil(all.length / PAGE_SIZE));
        if (state.tab0.page > last) state.tab0.page = last;
        const slice = all.slice((state.tab0.page - 1) * PAGE_SIZE, state.tab0.page * PAGE_SIZE);
        document.getElementById("tab0-tbody").innerHTML = slice.length
          ? slice
              .map(
                (r, i) => `
          <tr style="cursor:pointer" onclick="openDetail('${r.name} — 점검 이력', [['시설명','${r.name}'],['위치','${r.loc}'],['점검 일자','${r.date}'],['점검 결과','${r.result}'],['고장 횟수','${r.failures}회'],['고장 상태','${r.fault}'],['업무 상태','${r.task}']])">
            <td><strong>${r.name}</strong></td>
            <td class="muted">${r.loc}</td>
            <td class="muted">${r.date}</td>
            <td>${badge(r.result)}</td>
            <td style="text-align:right">${r.failures}</td>
            <td>${r.fault === "-" ? '<span style="color:var(--text-tertiary)">-</span>' : badge(r.fault)}</td>
            <td>${r.task}</td>
          </tr>`,
              )
              .join("")
          : `<tr class="c-table__empty"><td colspan="7">조회 결과가 없습니다.</td></tr>`;
        document.getElementById("tab0-subtitle").textContent = `총 ${all.length}건 / ${state.tab0.page} 페이지`;
        renderPagination("tab0-pagination", all.length, state.tab0.page, last, (p) => {
          state.tab0.page = p;
          renderTab0();
        });
      }

      function renderTab1() {
        const all = filteredTab1();
        const last = Math.max(1, Math.ceil(all.length / PAGE_SIZE));
        if (state.tab1.page > last) state.tab1.page = last;
        const slice = all.slice((state.tab1.page - 1) * PAGE_SIZE, state.tab1.page * PAGE_SIZE);
        document.getElementById("tab1-tbody").innerHTML = slice.length
          ? slice
              .map(
                (r, i) => `
          <tr style="cursor:pointer" onclick="openDetail('${r.name} — 고장 통계', [['시설명','${r.name}'],['위치','${r.loc}'],['점검 상태','${r.inspect}'],['고장 횟수','${r.failures}회'],['최근 고장일','${r.last}'],['고장 상태','${r.fault}'],['판정',${r.failures >= 3 ? "'반복 고장'" : "'-'"}]])">
            <td><strong>${r.name}</strong> <span class="muted" style="margin-left:4px">${r.loc}</span></td>
            <td>${badge(r.inspect)}</td>
            <td style="text-align:right">${r.failures}</td>
            <td class="muted">${r.last}</td>
            <td>${badge(r.fault)}</td>
            <td>${r.failures >= 3 ? '<span style="color:var(--red);font-weight:700">반복 고장</span>' : '<span style="color:var(--text-tertiary)">-</span>'}</td>
          </tr>`,
              )
              .join("")
          : `<tr class="c-table__empty"><td colspan="6">조회 결과가 없습니다.</td></tr>`;
        renderPagination("tab1-pagination", all.length, state.tab1.page, last, (p) => {
          state.tab1.page = p;
          renderTab1();
        });
      }

      function renderTab2() {
        const all = filteredTab2();
        const last = Math.max(1, Math.ceil(all.length / PAGE_SIZE));
        if (state.tab2.page > last) state.tab2.page = last;
        const slice = all.slice((state.tab2.page - 1) * PAGE_SIZE, state.tab2.page * PAGE_SIZE);
        document.getElementById("tab2-tbody").innerHTML = slice.length
          ? slice
              .map(
                (r, i) => `
          <tr style="cursor:pointer" onclick="openDetail('${r.name} — 업무 확인', [['시설명','${r.name}'],['점검 일자','${r.date}'],['점검 결과','${r.result}'],['업무 상태','${r.task}'],['담당자','${r.manager}'],['처리 상태','${r.proc}']])">
            <td><strong>${r.name}</strong></td>
            <td class="muted">${r.date}</td>
            <td>${badge(r.result)}</td>
            <td>${badge(r.task)}</td>
            <td>${r.manager}</td>
            <td>${r.proc}</td>
          </tr>`,
              )
              .join("")
          : `<tr class="c-table__empty"><td colspan="6">조회 결과가 없습니다.</td></tr>`;
        renderPagination("tab2-pagination", all.length, state.tab2.page, last, (p) => {
          state.tab2.page = p;
          renderTab2();
        });
      }

      function renderPagination(targetId, total, current, last, onChange) {
        const el = document.getElementById(targetId);
        if (last <= 1) {
          el.innerHTML = "";
          return;
        }
        const btn = (label, page, opts = {}) => {
          const cls = ["c-pagination__btn"];
          if (opts.active) cls.push("is-active");
          if (opts.disabled) cls.push("is-disabled");
          return `<button class="${cls.join(" ")}" data-page="${page}">${label}</button>`;
        };
        let html = btn(`<span class="material-symbols-rounded">chevron_left</span>`, current - 1, { disabled: current === 1 });
        for (let i = 1; i <= last; i++) html += btn(i, i, { active: i === current });
        html += btn(`<span class="material-symbols-rounded">chevron_right</span>`, current + 1, { disabled: current === last });
        el.innerHTML = html;
        el.querySelectorAll(".c-pagination__btn").forEach((b) => {
          b.addEventListener("click", () => {
            if (b.classList.contains("is-disabled") || b.classList.contains("is-active")) return;
            onChange(Number(b.dataset.page));
          });
        });
      }

      // 상단 탭 제거: tab0(점검 이력) 단일 뷰로 사용

      function searchTab0(v) {
        state.tab0.q = v;
        state.tab0.page = 1;
        renderTab0();
      }
      function filterTab0Status(v) {
        state.tab0.status = v;
        state.tab0.page = 1;
        renderTab0();
      }
      function searchTab1(v) {
        state.tab1.q = v;
        state.tab1.page = 1;
        renderTab1();
      }
      function filterTab1State(v) {
        state.tab1.inspect = v;
        state.tab1.page = 1;
        renderTab1();
      }
      function searchTab2(v) {
        state.tab2.q = v;
        state.tab2.page = 1;
        renderTab2();
      }
      function filterTab2State(v) {
        state.tab2.task = v;
        state.tab2.page = 1;
        renderTab2();
      }

      renderTab0();
      renderTab1();
      renderTab2();
    </script>
    <script>
      function toggleSidebar() {
        var s = document.getElementById("sidebar");
        if (s) s.classList.toggle("collapsed");
      }
      var logoIcon = document.getElementById("logoIcon");
      if (logoIcon) {
        logoIcon.onclick = function () {
          var s = document.getElementById("sidebar");
          if (s && s.classList.contains("collapsed")) toggleSidebar();
        };
      }
    </script>
  </body>
</html>
