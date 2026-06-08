<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true"%>
<!doctype html>
<html lang="ko">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1.0" />
    <title>우리집맵핑 · 입주민 관리</title>
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
      /* residentList 전용 — 가족 테이블, 차량 칩 */
      /* c-so-overlay, c-slideover, c-so__head, c-so__body, c-so__section-title, c-so__footer → centralCommon.css 제공 */
      /* c-info-grid, c-info-block → centralCommon.css 제공 */
      .member-table {
        width: 100%;
        font-size: 12px;
        border-collapse: collapse;
      }
      .member-table th {
        font-size: 10px;
        font-weight: 700;
        color: var(--text-tertiary);
        text-transform: uppercase;
        padding: 6px 8px;
        border-bottom: 1px solid var(--border);
        text-align: left;
      }
      .member-table td {
        padding: 8px;
        border-bottom: 1px solid var(--border);
        color: var(--text-secondary);
      }
      .member-table tr:last-child td { border-bottom: none; }
      .car-chip {
        display: inline-flex;
        align-items: center;
        gap: 5px;
        background: var(--gray-soft);
        border: 1px solid var(--border);
        border-radius: 6px;
        padding: 4px 10px;
        font-size: 12px;
        font-weight: 600;
        color: var(--text-primary);
        margin: 2px 4px 2px 0;
      }
      /* 미납 셀 정렬 */
      .unpaid-wrap { display: flex; gap: 4px; flex-wrap: wrap; }

      /* 행 클릭 가능 표시 */
      .c-table tbody tr { cursor: pointer; }
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
          <a href="<%= request.getContextPath() %>/centralAdmin/residentList" class="nav-item active" data-page="입주민 관리" data-parent="건물·입주민"><span class="material-symbols-rounded nav-icon">groups</span><span class="nav-text">입주민 관리</span></a>
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
          <a href="<%= request.getContextPath() %>/centralAdmin/facility" class="nav-item" data-page="시설 관리" data-parent="시설·시스템"><span class="material-symbols-rounded nav-icon">handyman</span><span class="nav-text">시설 관리</span></a>
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
          <span>건물·입주민</span>
          <span style="margin: 0 4px">/</span>
          <span class="bc-current">입주민 관리</span>
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
            <div class="page-title">입주민 관리</div>
            <div class="page-subtitle">전체 입주민 정보를 조회하고, 미납·만료 등 주의가 필요한 세대를 빠르게 식별합니다.</div>
          </div>
          <div class="page-header__right">
            <span class="page-meta"><span class="material-symbols-rounded">schedule</span>기준 2026.04.26</span>
            <button class="c-btn" data-tooltip="입주민 목록 엑셀로 내려받기">
              <span class="material-symbols-rounded">table_view</span>엑셀 출력하기
            </button>
          </div>
        </div>

        <!-- 검색 카드 -->
        <div class="c-card c-card--divide" style="margin-bottom: 16px">
          <div class="c-card__header">
            <div>
              <div class="c-card__title">검색 조건</div>
              <div class="c-card__sub">필요한 항목만 입력하면 됩니다. 빈 항목은 전체로 조회됩니다.</div>
            </div>
            <div class="c-card__actions">
              <button class="c-btn c-btn--ghost" onclick="resetFilter()">
                <span class="material-symbols-rounded">refresh</span>초기화
              </button>
              <button class="c-btn c-btn--primary" onclick="applyFilter()">
                <span class="material-symbols-rounded">search</span>검색
              </button>
            </div>
          </div>
          <div class="c-card__body">
            <div style="display:grid;grid-template-columns:repeat(4,1fr);gap:12px 14px">
              <div class="c-field">
                <label class="c-label">단지명</label>
                <select class="c-select" id="f-complex">
                  <option value="">전체</option>
                  <option>행복마을 1단지</option>
                  <option>행복마을 2단지</option>
                  <option>희망아파트</option>
                  <option>푸른하늘 단지</option>
                </select>
              </div>
              <div class="c-field">
                <label class="c-label">동</label>
                <div style="display:flex;gap:6px">
                  <input class="c-input" id="f-dong" type="text" placeholder="예) 101동" />
                </div>
              </div>
              <div class="c-field">
                <label class="c-label">호</label>
                <input class="c-input" id="f-ho" type="text" placeholder="예) 302호" />
              </div>
              <div class="c-field">
                <label class="c-label">이름 검색</label>
                <input class="c-input" id="f-name" type="search" placeholder="예) 김민준" />
              </div>
            </div>
          </div>
        </div>

        <!-- 입주민 목록 -->
        <div class="c-card c-card--divide">
          <div class="c-card__header">
            <div>
              <div class="c-card__title">입주민 목록</div>
              <div class="c-card__sub" id="resultCount">총 0건 / 1페이지</div>
            </div>
            <div class="c-card__actions">
              <select class="c-select" style="width: 130px" onchange="changeSort(this.value)">
                <option value="moveIn-desc">입주일 최신순</option>
                <option value="moveIn-asc">입주일 오래된순</option>
                <option value="name-asc">이름 가나다순</option>
              </select>
            </div>
          </div>
          <div class="c-card__body" style="padding: 0">
            <div class="c-table-wrap">
              <table class="c-table">
                <thead>
                  <tr>
                    <th style="width: 36px"><input type="checkbox" /></th>
                    <th style="width: 100px">이름</th>
                    <th style="width: 80px">세대구분</th>
                    <th>주소</th>
                    <th style="width: 110px">입주일</th>
                    <th style="width: 130px">계약 / 상태</th>
                    <th style="width: 80px">차량</th>
                    <th style="width: 130px">미납</th>
                  </tr>
                </thead>
                <tbody id="tableBody"></tbody>
              </table>
            </div>
            <div class="c-pagination" id="pagination"></div>
          </div>
        </div>
      </div>
    </div>

    <!-- 상세 모달 -->
    <div class="c-modal-overlay is-hidden" id="overlay" onclick="if(event.target===this)closeDetail()">
      <div class="c-modal c-modal--lg" role="dialog" aria-labelledby="so-name" aria-modal="true">
        <div class="c-modal__header">
          <h3 class="c-modal__title" id="so-name">입주민 상세</h3>
          <button class="c-modal__close" onclick="closeDetail()" aria-label="닫기"><span class="material-symbols-rounded">close</span></button>
        </div>
        <div class="c-modal__body" id="so-body"></div>
        <div class="c-modal__footer">
          <button class="c-btn c-btn--ghost"><span class="material-symbols-rounded">edit</span>정보 수정</button>
          <button class="c-btn c-btn--primary"><span class="material-symbols-rounded">contract</span>계약 조회</button>
        </div>
      </div>
    </div>

    <script>
      const PAGE_SIZE = 10;
      let currentPage = 1;
      let currentSort = "moveIn-desc";
      let filteredResidents = [];

      const residents = [
        { id: 1, name: "김민준", gender: "남", type: "세대주", complex: "행복마을 1단지", dong: "101동", ho: "302호", moveIn: "2022-03-15", contract: "월세", status: "거주중", cars: ["12가 3456"], unpaid: { mgmt: true, rent: false }, members: [{name:"김민준",rel:"본인",birth:"1985-07-20"},{name:"이수연",rel:"배우자",birth:"1987-11-05"},{name:"김지후",rel:"자녀",birth:"2015-03-12"}], renewals: 2, deposit: 3000, monthly: 45, note: "" },
        { id: 2, name: "박서연", gender: "여", type: "세대주", complex: "행복마을 1단지", dong: "102동", ho: "501호", moveIn: "2021-08-01", contract: "전세", status: "거주중", cars: [], unpaid: { mgmt: false, rent: false }, members: [{name:"박서연",rel:"본인",birth:"1990-02-14"}], renewals: 1, deposit: 15000, monthly: 0, note: "" },
        { id: 3, name: "이정호", gender: "남", type: "세대주", complex: "희망아파트", dong: "203동", ho: "104호", moveIn: "2023-01-10", contract: "월세", status: "거주중", cars: ["34나 7890","56다 1234"], unpaid: { mgmt: true, rent: true }, members: [{name:"이정호",rel:"본인",birth:"1978-09-30"},{name:"최미래",rel:"배우자",birth:"1980-04-22"},{name:"이도현",rel:"자녀",birth:"2008-06-01"},{name:"이예준",rel:"자녀",birth:"2011-12-25"}], renewals: 0, deposit: 2000, monthly: 38, note: "관리비 2개월 연체" },
        { id: 4, name: "최유진", gender: "여", type: "세대원", complex: "푸른하늘 단지", dong: "301동", ho: "201호", moveIn: "2020-05-20", contract: "전세", status: "거주중", cars: ["78라 5678"], unpaid: { mgmt: false, rent: false }, members: [{name:"최유진",rel:"본인",birth:"1995-01-08"},{name:"최강산",rel:"부모",birth:"1965-08-15"}], renewals: 3, deposit: 20000, monthly: 0, note: "" },
        { id: 5, name: "정현우", gender: "남", type: "세대주", complex: "행복마을 2단지", dong: "401동", ho: "703호", moveIn: "2022-11-01", contract: "월세", status: "거주중", cars: [], unpaid: { mgmt: false, rent: true }, members: [{name:"정현우",rel:"본인",birth:"1988-05-12"}], renewals: 1, deposit: 1000, monthly: 50, note: "임대료 미납" },
        { id: 6, name: "한소희", gender: "여", type: "세대주", complex: "행복마을 2단지", dong: "402동", ho: "105호", moveIn: "2019-07-15", contract: "전세", status: "거주중", cars: ["90마 4321"], unpaid: { mgmt: false, rent: false }, members: [{name:"한소희",rel:"본인",birth:"1992-12-03"},{name:"김태양",rel:"배우자",birth:"1990-07-18"},{name:"김별이",rel:"자녀",birth:"2020-04-05"}], renewals: 4, deposit: 18000, monthly: 0, note: "" },
        { id: 7, name: "윤재원", gender: "남", type: "세대주", complex: "희망아파트", dong: "201동", ho: "601호", moveIn: "2024-02-01", contract: "월세", status: "거주중", cars: ["11바 2222"], unpaid: { mgmt: true, rent: false }, members: [{name:"윤재원",rel:"본인",birth:"1983-03-27"}], renewals: 0, deposit: 500, monthly: 42, note: "" },
        { id: 8, name: "임지은", gender: "여", type: "세대주", complex: "행복마을 1단지", dong: "103동", ho: "402호", moveIn: "2021-04-10", contract: "월세", status: "퇴거예정", cars: ["33사 6666"], unpaid: { mgmt: false, rent: false }, members: [{name:"임지은",rel:"본인",birth:"1991-09-22"},{name:"임다온",rel:"자녀",birth:"2018-07-14"}], renewals: 2, deposit: 2000, monthly: 40, note: "2026-05-31 퇴거" },
        { id: 9, name: "강도윤", gender: "남", type: "세대주", complex: "푸른하늘 단지", dong: "302동", ho: "807호", moveIn: "2023-09-12", contract: "전세", status: "거주중", cars: ["55차 9012"], unpaid: { mgmt: false, rent: false }, members: [{name:"강도윤",rel:"본인",birth:"1987-04-18"}], renewals: 0, deposit: 16500, monthly: 0, note: "" },
        { id: 10, name: "오하늘", gender: "여", type: "세대주", complex: "희망아파트", dong: "204동", ho: "302호", moveIn: "2020-12-05", contract: "월세", status: "거주중", cars: [], unpaid: { mgmt: true, rent: true }, members: [{name:"오하늘",rel:"본인",birth:"1986-10-22"}], renewals: 2, deposit: 1500, monthly: 48, note: "장기 미납 — 통보 필요" },
        { id: 11, name: "신지호", gender: "남", type: "세대주", complex: "행복마을 1단지", dong: "104동", ho: "203호", moveIn: "2024-03-20", contract: "월세", status: "거주중", cars: ["77자 3344"], unpaid: { mgmt: false, rent: false }, members: [{name:"신지호",rel:"본인",birth:"1993-08-04"},{name:"신라온",rel:"자녀",birth:"2022-11-19"}], renewals: 0, deposit: 1000, monthly: 55, note: "" },
        { id: 12, name: "유서아", gender: "여", type: "세대주", complex: "행복마을 2단지", dong: "401동", ho: "1005호", moveIn: "2018-10-01", contract: "전세", status: "거주중", cars: ["22카 8765"], unpaid: { mgmt: false, rent: false }, members: [{name:"유서아",rel:"본인",birth:"1989-06-30"},{name:"문이안",rel:"배우자",birth:"1985-12-12"}], renewals: 5, deposit: 22000, monthly: 0, note: "" },
      ];

      function badge(variant, text) {
        return `<span class="c-badge c-badge--${variant}">${text}</span>`;
      }
      function escapeHTML(s){return String(s).replace(/[&<>"]/g,c=>({"&":"&amp;","<":"&lt;",">":"&gt;","\"":"&quot;"})[c]);}

      function getStatusBadge(status) {
        if (status === "거주중") return badge("active", "거주중");
        if (status === "퇴거예정") return badge("pending", "퇴거예정");
        return badge("neutral", status);
      }
      function getContractBadge(c) {
        return c === "전세" ? badge("jeonse", "전세") : badge("wolse", "월세");
      }

      function sortRows(rows) {
        const arr = [...rows];
        if (currentSort === "moveIn-desc") arr.sort((a,b)=>b.moveIn.localeCompare(a.moveIn));
        else if (currentSort === "moveIn-asc") arr.sort((a,b)=>a.moveIn.localeCompare(b.moveIn));
        else if (currentSort === "name-asc") arr.sort((a,b)=>a.name.localeCompare(b.name,"ko"));
        return arr;
      }

      function renderTable() {
        const sorted = sortRows(filteredResidents);
        const total = sorted.length;
        const last = Math.max(1, Math.ceil(total / PAGE_SIZE));
        if (currentPage > last) currentPage = last;
        const start = (currentPage - 1) * PAGE_SIZE;
        const slice = sorted.slice(start, start + PAGE_SIZE);

        const tbody = document.getElementById("tableBody");
        tbody.innerHTML = slice.length ? slice.map(r => `
          <tr onclick="openDetail(${r.id})">
            <td><input type="checkbox" onclick="event.stopPropagation()" /></td>
            <td><strong style="color:var(--text-primary)">${r.name}</strong> <span style="font-size:11px;color:var(--text-tertiary)">${r.gender}</span></td>
            <td>${r.type === "세대주" ? badge("active","세대주") : badge("neutral","세대원")}</td>
            <td>${r.complex} · ${r.dong} · ${r.ho}</td>
            <td class="muted">${r.moveIn}</td>
            <td>${getContractBadge(r.contract)} ${getStatusBadge(r.status)}</td>
            <td>${r.cars.length ? badge("jeonse", r.cars.length+"대") : `<span style="color:var(--text-tertiary);font-size:12px">없음</span>`}</td>
            <td><div class="unpaid-wrap">${r.unpaid.mgmt ? badge("danger","관리비") : ""}${r.unpaid.rent ? badge("danger","임대료") : ""}${!r.unpaid.mgmt && !r.unpaid.rent ? `<span style="color:var(--green);font-size:12px;font-weight:600">정상</span>` : ""}</div></td>
          </tr>`).join("") : `<tr class="c-table__empty"><td colspan="8">조회된 입주민이 없습니다.</td></tr>`;

        document.getElementById("resultCount").textContent = `총 ${total}건 / ${currentPage} 페이지 (전체 ${last}페이지)`;
        renderPagination(total, last);
      }

      function renderPagination(total, last) {
        const el = document.getElementById("pagination");
        if (last <= 1) { el.innerHTML = ""; return; }
        const btn = (label, page, opts={}) => {
          const cls = ["c-pagination__btn"];
          if (opts.active) cls.push("is-active");
          if (opts.disabled) cls.push("is-disabled");
          return `<button class="${cls.join(" ")}" data-page="${page}">${label}</button>`;
        };
        let html = btn(`<span class="material-symbols-rounded">chevron_left</span>`, currentPage-1, { disabled: currentPage===1 });
        for (let i = 1; i <= last; i++) html += btn(i, i, { active: i === currentPage });
        html += btn(`<span class="material-symbols-rounded">chevron_right</span>`, currentPage+1, { disabled: currentPage===last });
        el.innerHTML = html;
        el.querySelectorAll(".c-pagination__btn").forEach(b => {
          b.addEventListener("click", () => {
            if (b.classList.contains("is-disabled") || b.classList.contains("is-active")) return;
            currentPage = Number(b.dataset.page);
            renderTable();
          });
        });
      }

      function changeSort(v) { currentSort = v; currentPage = 1; renderTable(); }

      function normUnit(v) {
        return String(v || "").trim().replace(/\s+/g, "");
      }

      function applyFilter() {
        const complex = (document.getElementById("f-complex")?.value || "").trim();
        const dong = normUnit(document.getElementById("f-dong")?.value);
        const ho = normUnit(document.getElementById("f-ho")?.value);
        const name = (document.getElementById("f-name")?.value || "").trim().toLowerCase();

        filteredResidents = residents.filter((r) => {
          if (complex && r.complex !== complex) return false;
          if (dong && normUnit(r.dong) !== dong) return false;
          if (ho && normUnit(r.ho) !== ho) return false;
          if (name && !String(r.name || "").toLowerCase().includes(name)) return false;
          return true;
        });

        currentPage = 1;
        renderTable();
      }

      function openDetail(id) {
        const r = residents.find(x => x.id === id);
        if (!r) return;
        document.getElementById("so-name").textContent = r.name + " 상세정보";
        document.getElementById("so-body").innerHTML = `
          <div>
            <div class="c-so__section-title"><span class="material-symbols-rounded">person</span>기본 정보</div>
            <div class="c-info-grid">
              <div class="c-info-block"><div class="c-info-field__label">이름</div><div class="c-info-field__val">${r.name}</div></div>
              <div class="c-info-block"><div class="c-info-field__label">성별</div><div class="c-info-field__val">${r.gender === "남" ? "남성" : "여성"}</div></div>
              <div class="c-info-block"><div class="c-info-field__label">세대구분</div><div class="c-info-field__val">${r.type === "세대주" ? badge("active","세대주") : badge("neutral","세대원")}</div></div>
              <div class="c-info-block"><div class="c-info-field__label">계약유형</div><div class="c-info-field__val">${getContractBadge(r.contract)}</div></div>
              <div class="c-info-block c-info-field--full"><div class="c-info-field__label">주소</div><div class="c-info-field__val">${r.complex} ${r.dong} ${r.ho}</div></div>
              <div class="c-info-block"><div class="c-info-field__label">입주일</div><div class="c-info-field__val">${r.moveIn}</div></div>
              <div class="c-info-block"><div class="c-info-field__label">거주상태</div><div class="c-info-field__val">${getStatusBadge(r.status)}</div></div>
            </div>
          </div>
          <div>
            <div class="c-so__section-title"><span class="material-symbols-rounded">receipt_long</span>계약 정보</div>
            <div class="c-info-grid">
              <div class="c-info-block"><div class="c-info-field__label">보증금</div><div class="c-info-field__val">${r.deposit.toLocaleString()}만원</div></div>
              <div class="c-info-block"><div class="c-info-field__label">월세</div><div class="c-info-field__val">${r.monthly ? r.monthly.toLocaleString() + "만원" : "해당없음"}</div></div>
              <div class="c-info-block"><div class="c-info-field__label">계약 갱신</div><div class="c-info-field__val">${r.renewals}회</div></div>
              <div class="c-info-block"><div class="c-info-field__label">관리비 납부</div><div class="c-info-field__val">${r.unpaid.mgmt ? badge("danger","미납") : badge("active","정상")}</div></div>
              <div class="c-info-block"><div class="c-info-field__label">임대료 납부</div><div class="c-info-field__val">${r.unpaid.rent ? badge("danger","미납") : badge("active","정상")}</div></div>
              ${r.note ? `<div class="c-info-block c-info-field--full"><div class="c-info-field__label">비고</div><div class="c-info-field__val" style="color:var(--red)">${escapeHTML(r.note)}</div></div>` : ""}
            </div>
          </div>
          <div>
            <div class="c-so__section-title"><span class="material-symbols-rounded">family_restroom</span>가족 구성원 (${r.members.length}명)</div>
            <table class="member-table">
              <thead><tr><th>이름</th><th>관계</th><th>생년월일</th></tr></thead>
              <tbody>${r.members.map(m => `<tr><td>${m.name}</td><td>${m.rel}</td><td>${m.birth}</td></tr>`).join("")}</tbody>
            </table>
          </div>
          <div>
            <div class="c-so__section-title"><span class="material-symbols-rounded">directions_car</span>차량 정보</div>
            <div>${r.cars.length ? r.cars.map(c => `<span class="car-chip"><span class="material-symbols-rounded" style="font-size:14px">directions_car</span>${c}</span>`).join("") : '<span style="font-size:13px;color:var(--text-tertiary)">등록된 차량이 없습니다.</span>'}</div>
          </div>`;
        document.getElementById("overlay").classList.remove("is-hidden");
      }
      function closeDetail() {
        document.getElementById("overlay").classList.add("is-hidden");
      }
      function resetFilter() {
        ["f-complex", "f-dong", "f-ho", "f-name"].forEach((id) => {
          const el = document.getElementById(id);
          if (!el) return;
          if (el.tagName === "SELECT") el.selectedIndex = 0;
          else el.value = "";
        });
        applyFilter();
      }

      // Enter 키로 바로 검색
      ["f-dong", "f-ho", "f-name"].forEach((id) => {
        const el = document.getElementById(id);
        if (!el) return;
        el.addEventListener("keydown", (e) => {
          if (e.key === "Enter") applyFilter();
        });
      });

      filteredResidents = residents.slice();
      renderTable();
    </script>
    <script>
      function toggleSidebar(){var s=document.getElementById("sidebar");if(s)s.classList.toggle("collapsed");}
      var logoIcon=document.getElementById("logoIcon");
      if(logoIcon){logoIcon.onclick=function(){var s=document.getElementById("sidebar");if(s&&s.classList.contains("collapsed"))toggleSidebar();};}
    </script>
  </body>
</html>
