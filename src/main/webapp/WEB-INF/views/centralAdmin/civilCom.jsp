<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true"%>
<!doctype html>
<html lang="ko">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1.0" />
    <title>우리집맵핑 · 민원 관리</title>
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
      /* civilCom 전용: 타임라인 */
      /* c-so-overlay, c-slideover, c-so__head, c-so__body, c-so__section-title → centralCommon.css 제공 */
      /* c-info-grid, c-info-block → centralCommon.css 제공 */
      .timeline { display: flex; flex-direction: column; }
      .tl-item { display: flex; gap: 12px; padding-bottom: 14px; position: relative; }
      .tl-item:not(:last-child)::before {
        content: "";
        position: absolute;
        left: 6px; top: 14px; bottom: 0;
        width: 1px; background: var(--border);
      }
      .tl-dot {
        width: 13px; height: 13px;
        border-radius: 50%;
        background: var(--accent);
        flex-shrink: 0; margin-top: 2px;
        border: 2px solid var(--card);
        box-shadow: 0 0 0 2px var(--accent);
      }
      .tl-text {
        font-size: 12px;
        color: var(--text-secondary);
        line-height: 1.5;
      }
      .tl-text strong {
        display: block;
        color: var(--text-primary);
        font-weight: 700;
        margin-bottom: 1px;
      }
      .delay-time {
        color: var(--red);
        font-weight: 700;
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
          <a href="<%= request.getContextPath() %>/centralAdmin/civilCom" class="nav-item active" data-page="민원 관리" data-parent="민원·소통">
            <span class="material-symbols-rounded nav-icon">support_agent</span><span class="nav-text">민원 관리</span>
            <span class="nav-badge">3</span>
          </a>
          <a href="<%= request.getContextPath() %>/centralAdmin/ai" class="nav-item" data-page="문의 관리" data-parent="민원·소통">
            <span class="material-symbols-rounded nav-icon">forum</span><span class="nav-text">문의 관리</span>
            <span class="nav-badge yellow">4</span>
          </a>
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
          <span id="bc-parent">민원·소통</span>
          <span style="margin: 0 4px">/</span>
          <span class="bc-current" id="bc-current">민원 관리</span>
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

      <div class="main-content" id="page-content">
        <!-- 페이지 헤더 -->
        <div class="page-header">
          <div>
            <div class="page-title">민원 관리</div>
            <div class="page-subtitle">접수된 민원의 처리 현황을 확인하고, 지연 민원을 빠르게 식별합니다.</div>
          </div>
          <div class="page-header__right">
            <span class="page-meta">
              <span class="material-symbols-rounded">schedule</span>
              기준 2026.04.26 18:00
            </span>
          </div>
        </div>

        <!-- 민원 목록 (단일 화면) -->
        <div class="tab-panel is-active" id="tab0">
          <!-- 전체 민원 목록 -->
          <div class="c-card c-card--divide">
            <div class="c-card__header">
              <div>
                <div class="c-card__title">민원 목록</div>
                <div class="c-card__sub">행을 클릭하면 처리 이력을 확인할 수 있습니다.</div>
              </div>
              <div class="c-card__actions">
                <input type="search" class="c-input" id="f0-q" placeholder="민원번호·제목 검색" style="width: 200px" />
                <select class="c-select" id="f0-status" style="width: 110px">
                  <option value="">전체 상태</option>
                  <option value="접수">접수</option>
                  <option value="처리중">처리중</option>
                  <option value="완료">완료</option>
                  <option value="반려">반려</option>
                </select>
                <button class="c-btn c-btn--ghost" type="button" onclick="resetTab0()"><span class="material-symbols-rounded">refresh</span>초기화</button>
                <button class="c-btn c-btn--primary" type="button" onclick="applyTab0()"><span class="material-symbols-rounded">search</span>검색</button>
              </div>
            </div>
            <div class="c-card__body" style="padding: 0">
              <div class="c-table-wrap">
                <table class="c-table">
                  <thead>
                    <tr>
                      <th style="width: 110px">민원번호</th>
                      <th>민원 제목</th>
                      <th style="width: 80px">유형</th>
                      <th style="width: 90px">작성자</th>
                      <th style="width: 110px">등록일</th>
                      <th style="width: 90px">상태</th>
                    </tr>
                  </thead>
                  <tbody id="tab0-tbody"></tbody>
                </table>
              </div>
              <div class="c-pagination" id="tab0-pagination"></div>
            </div>
          </div>
        </div>


        <!-- 모달: 민원 상세 -->
        <div class="c-modal-overlay is-hidden" id="detailOverlay" onclick="if(event.target===this)closeDetailModal()">
          <div class="c-modal c-modal--lg" role="dialog" aria-labelledby="so-title" aria-modal="true">
            <div class="c-modal__header">
              <h4 class="c-modal__title" id="so-title">민원 상세</h4>
              <button class="c-modal__close" onclick="closeDetailModal()" aria-label="닫기"><span class="material-symbols-rounded">close</span></button>
            </div>
            <div class="c-modal__body">
              <div class="c-info-grid" id="so-meta"></div>
              <div class="c-so__section-title" style="margin-top: 18px">처리 이력</div>
              <div class="timeline" id="so-timeline"></div>
            </div>
            <div class="c-modal__footer">
              <button class="c-btn c-btn--ghost" onclick="closeDetailModal()">닫기</button>
              <button class="c-btn c-btn--primary" type="button" onclick="alert('처리 완료 처리(더미)')">처리 완료</button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <script id="page-script">
      const PAGE_SIZE = 10;

      const BADGE_CLASS = {
        접수: "c-badge c-badge--jeonse",
        처리중: "c-badge c-badge--pending",
        완료: "c-badge c-badge--active",
        반려: "c-badge c-badge--danger",
      };

      // ----- 데이터 -----
      const TAB0_ROWS = [
        ["VOC-001", "엘리베이터 3층 버튼 작동 불가", "시설", "user01", "2026-04-14", "접수"],
        ["VOC-002", "방문객 주차 공간 부족", "생활", "user02", "2026-04-14", "처리중"],
        ["VOC-003", "이번 달 관리비 산정 문의", "관리비", "user03", "2026-04-13", "완료"],
        ["VOC-004", "화장실 천장 누수 발생", "시설", "user04", "2026-04-12", "반려"],
        ["VOC-005", "계약 갱신 관련 문의", "계약", "user05", "2026-04-11", "접수"],
        ["VOC-006", "공용현관 도어록 오작동", "시설", "user06", "2026-04-11", "처리중"],
        ["VOC-007", "층간소음 민원", "생활", "user07", "2026-04-10", "처리중"],
        ["VOC-008", "관리비 자동이체 신청 방법", "관리비", "user08", "2026-04-10", "완료"],
        ["VOC-009", "주차 차단기 미작동", "시설", "user09", "2026-04-09", "처리중"],
        ["VOC-010", "재활용품 분리수거 안내 문의", "기타", "user10", "2026-04-09", "완료"],
        ["VOC-011", "엘리베이터 점검 일정 안내 요청", "시설", "user11", "2026-04-08", "완료"],
        ["VOC-012", "월세 계약 연장 절차 문의", "계약", "user12", "2026-04-08", "접수"],
        ["VOC-013", "옥상 배수구 막힘 신고", "시설", "user13", "2026-04-07", "처리중"],
        ["VOC-014", "관리비 영수증 재발급 요청", "관리비", "user14", "2026-04-07", "완료"],
      ];

      const TAB1_ROWS = [
        ["C20260401", "강남 센트럴", "엘리베이터 고장", "시설 민원", "2026-04-01", "시설팀", "처리중", "-"],
        ["C20260328", "한강 리버뷰", "관리비 오류 문의", "관리비 민원", "2026-03-28", "회계팀", "완료", "2026-03-29"],
        ["C20260320", "강남 센트럴", "주차장 민원", "생활 민원", "2026-03-20", "관리팀", "반려", "2026-03-21"],
        ["C20260315", "자이 아파트", "공용현관 청결 문제", "생활 민원", "2026-03-15", "관리팀", "완료", "2026-03-16"],
        ["C20260312", "한강 리버뷰", "옥상 누수", "시설 민원", "2026-03-12", "시설팀", "처리중", "-"],
      ];

      const TAB2_ROWS = [
        ["C20260401", "강남 센트럴", "엘리베이터 고장", "시설 민원", "2026-04-01", "시설팀", "48시간 지연", "처리중"],
        ["C20260328", "한강 리버뷰", "주차장 누수", "시설 민원", "2026-03-28", "시설팀", "72시간 지연", "처리중"],
        ["C20260320", "강남 센트럴", "관리비 문의", "관리비 민원", "2026-03-20", "회계팀", "24시간 지연", "처리중"],
      ];

      // ----- 필터 상태(탭별) -----
      const f0 = { q: "", status: "" };
      const f1 = { complex: "", status: "", date: "" };
      const f2 = { complex: "", type: "", delay: "" };

      const VOC_DATA = {
        "VOC-001": { type: "시설", writer: "user01", date: "2026-04-14", complex: "강남 센트럴", status: "접수", title: "엘리베이터 3층 버튼 작동 불가",
          content: "엘리베이터 3층 버튼이 작동하지 않습니다. 빠른 처리 부탁드립니다.",
          timeline: [["2026-04-14 10:00", "접수 완료"], ["2026-04-14 14:00", "담당팀 배정 (시설팀)"]] },
        "VOC-002": { type: "생활", writer: "user02", date: "2026-04-14", complex: "한강 리버뷰", status: "처리중", title: "방문객 주차 공간 부족",
          content: "방문객 주차공간이 부족하여 민원을 제기합니다.",
          timeline: [["2026-04-14 09:00", "접수 완료"], ["2026-04-14 13:00", "관리팀 배정"]] },
        "VOC-003": { type: "관리비", writer: "user03", date: "2026-04-13", complex: "자이 아파트", status: "완료", title: "이번 달 관리비 산정 문의",
          content: "이번 달 관리비가 이전 달보다 많이 나왔습니다.",
          timeline: [["2026-04-13 11:00", "접수 완료"], ["2026-04-13 15:00", "회계팀 배정"], ["2026-04-14 10:00", "처리 완료"]] },
        "VOC-004": { type: "시설", writer: "user04", date: "2026-04-12", complex: "강남 센트럴", status: "반려", title: "화장실 천장 누수 발생",
          content: "화장실 천장에서 물이 새고 있습니다.",
          timeline: [["2026-04-12 09:00", "접수 완료"], ["2026-04-12 16:00", "현장 확인 후 반려 처리"]] },
        "VOC-005": { type: "계약", writer: "user05", date: "2026-04-11", complex: "한강 리버뷰", status: "접수", title: "계약 갱신 관련 문의",
          content: "계약 갱신 관련 문의사항이 있습니다.",
          timeline: [["2026-04-11 14:00", "접수 완료"]] },
      };

      // ----- 탭 전환 -----
      // 상단 탭 제거: tab0(전체 민원) 단일 뷰로 사용

      // ----- 페이징 + 렌더 -----
      const pageState = { 0: 1, 1: 1, 2: 1 };

      function escapeHTML(s) { return String(s).replace(/[&<>"]/g, c => ({"&":"&amp;","<":"&lt;",">":"&gt;","\"":"&quot;"})[c]); }

      function renderTab0() {
        const rows = TAB0_ROWS.filter((r) => {
          const id = r[0], title = r[1], status = r[5];
          if (f0.q) {
            const q = f0.q.toLowerCase();
            if (!(String(id).toLowerCase().includes(q) || String(title).toLowerCase().includes(q))) return false;
          }
          if (f0.status && status !== f0.status) return false;
          return true;
        });
        const page = pageState[0];
        const start = (page - 1) * PAGE_SIZE;
        const slice = rows.slice(start, start + PAGE_SIZE);
        document.getElementById("tab0-tbody").innerHTML = slice.length ? slice.map(r => `
          <tr style="cursor:pointer" onclick="openSlideOver('${r[0]}')">
            <td>${r[0]}</td>
            <td>${escapeHTML(r[1])}</td>
            <td>${r[2]}</td>
            <td>${r[3]}</td>
            <td class="muted">${r[4]}</td>
            <td><span class="${BADGE_CLASS[r[5]]}">${r[5]}</span></td>
          </tr>`).join("") : `<tr class="c-table__empty"><td colspan="6">조회 결과가 없습니다.</td></tr>`;
        renderPagination("tab0-pagination", rows.length, page, p => { pageState[0] = p; renderTab0(); });
      }

      function renderTab1() {
        const rows = TAB1_ROWS.filter((r) => {
          const complex = r[1];
          const status = r[6];
          const date = r[4];
          if (f1.complex && f1.complex !== "전체 단지" && complex !== f1.complex) return false;
          if (f1.status && status !== f1.status) return false;
          if (f1.date && date !== f1.date) return false;
          return true;
        });
        const page = pageState[1];
        const start = (page - 1) * PAGE_SIZE;
        const slice = rows.slice(start, start + PAGE_SIZE);
        document.getElementById("tab1-tbody").innerHTML = slice.length ? slice.map(r => `
          <tr style="cursor:pointer" onclick="openSlideOver('${r[0]}')">
            <td>${r[0]}</td>
            <td>${r[1]}</td>
            <td>${escapeHTML(r[2])}</td>
            <td>${r[3]}</td>
            <td class="muted">${r[4]}</td>
            <td>${r[5]}</td>
            <td><span class="${BADGE_CLASS[r[6]]}">${r[6]}</span></td>
            <td class="muted">${r[7]}</td>
          </tr>`).join("") : `<tr class="c-table__empty"><td colspan="8">조회 결과가 없습니다.</td></tr>`;
        renderPagination("tab1-pagination", rows.length, page, p => { pageState[1] = p; renderTab1(); });
      }

      function renderTab2() {
        const rows = TAB2_ROWS.filter((r) => {
          const complex = r[1];
          const type = r[3];
          const delayText = r[6];
          if (f2.complex && f2.complex !== "전체 단지" && complex !== f2.complex) return false;
          if (f2.type && !String(type).includes(f2.type)) return false;
          if (f2.delay) {
            const n = Number(f2.delay);
            if (!Number.isFinite(n)) return true;
            if (!String(delayText).includes(String(n))) return false;
          }
          return true;
        });
        const page = pageState[2];
        const start = (page - 1) * PAGE_SIZE;
        const slice = rows.slice(start, start + PAGE_SIZE);
        document.getElementById("tab2-tbody").innerHTML = slice.length ? slice.map(r => `
          <tr style="cursor:pointer" onclick="openSlideOver('${r[0]}')">
            <td>${r[0]}</td>
            <td>${r[1]}</td>
            <td>${escapeHTML(r[2])}</td>
            <td>${r[3]}</td>
            <td class="muted">${r[4]}</td>
            <td>${r[5]}</td>
            <td class="delay-time">${r[6]}</td>
            <td><span class="${BADGE_CLASS[r[7]]}">${r[7]}</span></td>
          </tr>`).join("") : `<tr class="c-table__empty"><td colspan="8">지연 민원이 없습니다.</td></tr>`;
        renderPagination("tab2-pagination", rows.length, page, p => { pageState[2] = p; renderTab2(); });
      }

      function applyTab0() {
        f0.q = (document.getElementById("f0-q")?.value || "").trim();
        f0.status = (document.getElementById("f0-status")?.value || "").trim();
        pageState[0] = 1;
        renderTab0();
      }
      function resetTab0() {
        document.getElementById("f0-q").value = "";
        document.getElementById("f0-status").value = "";
        applyTab0();
      }

      function applyTab1() {
        f1.complex = (document.getElementById("f1-complex")?.value || "").trim();
        f1.status = (document.getElementById("f1-status")?.value || "").trim();
        f1.date = (document.getElementById("f1-date")?.value || "").trim();
        pageState[1] = 1;
        renderTab1();
      }
      function resetTab1() {
        document.getElementById("f1-complex").selectedIndex = 0;
        document.getElementById("f1-status").value = "";
        document.getElementById("f1-date").value = "2026-04-22";
        applyTab1();
      }

      function applyTab2() {
        f2.complex = (document.getElementById("f2-complex")?.value || "").trim();
        f2.type = (document.getElementById("f2-type")?.value || "").trim();
        f2.delay = (document.getElementById("f2-delay")?.value || "").trim();
        pageState[2] = 1;
        renderTab2();
      }
      function resetTab2() {
        document.getElementById("f2-complex").selectedIndex = 0;
        document.getElementById("f2-type").value = "";
        document.getElementById("f2-delay").value = "";
        applyTab2();
      }

      function renderPagination(targetId, total, current, onChange) {
        const el = document.getElementById(targetId);
        const last = Math.max(1, Math.ceil(total / PAGE_SIZE));
        if (last <= 1) { el.innerHTML = ""; return; }
        const btn = (label, page, opts = {}) => {
          const cls = ["c-pagination__btn"];
          if (opts.active) cls.push("is-active");
          if (opts.disabled) cls.push("is-disabled");
          return `<button class="${cls.join(" ")}" data-page="${page}">${label}</button>`;
        };
        let html = "";
        html += btn(`<span class="material-symbols-rounded">chevron_left</span>`, current - 1, { disabled: current === 1 });
        for (let i = 1; i <= last; i++) html += btn(i, i, { active: i === current });
        html += btn(`<span class="material-symbols-rounded">chevron_right</span>`, current + 1, { disabled: current === last });
        el.innerHTML = html;
        el.querySelectorAll(".c-pagination__btn").forEach(b => {
          b.addEventListener("click", () => {
            if (b.classList.contains("is-disabled") || b.classList.contains("is-active")) return;
            onChange(Number(b.dataset.page));
          });
        });
      }

      // ----- 슬라이드오버 -----
      function openSlideOver(id) {
        const d = VOC_DATA[id];
        if (!d) {
          // 더미 데이터
          document.getElementById("so-title").textContent = "민원 상세";
          document.getElementById("so-meta").innerHTML = `<div class="c-info-block c-info-field--full"><div class="c-info-field__label">안내</div><div class="c-info-field__val">해당 민원의 상세 데이터가 등록되어 있지 않습니다.</div></div>`;
          document.getElementById("so-timeline").innerHTML = "";
        } else {
          document.getElementById("so-title").textContent = d.title;
          document.getElementById("so-meta").innerHTML = `
            <div class="c-info-block"><div class="c-info-field__label">민원번호</div><div class="c-info-field__val">${id}</div></div>
            <div class="c-info-block"><div class="c-info-field__label">유형</div><div class="c-info-field__val">${d.type}</div></div>
            <div class="c-info-block"><div class="c-info-field__label">작성자</div><div class="c-info-field__val">${d.writer}</div></div>
            <div class="c-info-block"><div class="c-info-field__label">등록일</div><div class="c-info-field__val">${d.date}</div></div>
            <div class="c-info-block"><div class="c-info-field__label">단지</div><div class="c-info-field__val">${d.complex}</div></div>
            <div class="c-info-block"><div class="c-info-field__label">상태</div><div class="c-info-field__val"><span class="${BADGE_CLASS[d.status]}">${d.status}</span></div></div>
            <div class="c-info-block c-info-field--full"><div class="c-info-field__label">민원 내용</div><div class="c-info-field__val">${escapeHTML(d.content)}</div></div>`;
          document.getElementById("so-timeline").innerHTML = d.timeline.map(([t, s]) => `<div class="tl-item"><div class="tl-dot"></div><div class="tl-text"><strong>${s}</strong>${t}</div></div>`).join("");
        }
        document.getElementById("detailOverlay").classList.remove("is-hidden");
      }
      function closeDetailModal() {
        document.getElementById("detailOverlay").classList.add("is-hidden");
      }

      // ----- 초기 -----
      applyTab0(); applyTab1(); applyTab2();
    </script>

    <script>
      function toggleSidebar() {
        var sidebar = document.getElementById("sidebar");
        if (sidebar) sidebar.classList.toggle("collapsed");
      }
      var logoIcon = document.getElementById("logoIcon");
      if (logoIcon) {
        logoIcon.onclick = function () {
          var sidebar = document.getElementById("sidebar");
          if (sidebar && sidebar.classList.contains("collapsed")) toggleSidebar();
        };
      }
    </script>
  </body>
</html>
