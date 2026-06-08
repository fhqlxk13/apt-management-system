<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true"%>
<!doctype html>
<html lang="ko">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1.0" />
    <title>우리집맵핑 · 비정상 세대 관리</title>
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
      .state-flow{display:inline-flex;align-items:center;gap:4px;font-size:12px}
      .state-flow .material-symbols-rounded{font-size:16px;color:var(--text-tertiary)}
      .hist-type-tag{display:inline-block;font-size:11px;font-weight:700;padding:2px 8px;border-radius:4px}
      .hist-입주민등록{background:var(--green-bg);color:var(--green)} .hist-계약갱신{background:var(--blue-bg);color:var(--accent)}
      .hist-공실전환{background:var(--red-bg);color:var(--red)} .hist-강제처리{background:var(--yellow-bg);color:var(--yellow)}
    </style>
  </head>
  <body>
    <%@ include file="centralAside.jsp" %>

    <div class="main-wrap">
      <div class="topbar">
        <div class="breadcrumb">
          <span class="material-symbols-rounded" style="font-size: 14px">home</span>
          <span style="margin: 0 4px">/</span>
          <span id="bc-parent">시설·시스템</span>
          <span style="margin: 0 4px">/</span>
          <span class="bc-current" id="bc-current">비정상 세대 관리</span>
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
            <div class="page-title">비정상 세대 관리</div>
            <div class="page-subtitle">미등록·계약 만료 임박·공실 후보 세대를 한눈에 확인하고 즉시 처리합니다.</div>
          </div>
          <div class="page-header__right">
            <span class="page-meta"><span class="material-symbols-rounded">schedule</span>기준 2026.04.26</span>
          </div>
        </div>

        <div id="view-units">
          <!-- 비정상 세대 목록 -->
          <div class="c-card c-card--divide" style="margin-bottom: 16px">
            <div class="c-card__header">
              <div>
                <div class="c-card__title">비정상 세대 목록</div>
                <div class="c-card__sub" id="unitSubtitle">전체 16건이 조회되었습니다.</div>
              </div>
              <div class="c-card__actions">
                <select class="c-select" id="unitTypeSelect" style="width: 140px" onchange="setUnitType(this.value)">
                  <option value="all">전체 비정상</option>
                  <option value="unregistered">미등록</option>
                  <option value="expiring">만료 임박</option>
                  <option value="vacant">공실 후보</option>
                </select>
                <input type="search" class="c-input" placeholder="동/호 검색" style="width: 160px" oninput="filterUnits(this.value)" />
              </div>
            </div>
            <div class="c-card__body" style="padding: 0">
              <div class="c-table-wrap">
                <table class="c-table">
                  <thead>
                    <tr>
                      <th style="width: 130px">동 / 호</th>
                      <th style="width: 110px">유형</th>
                      <th style="width: 120px">긴급도</th>
                      <th>세부 사항</th>
                      <th style="width: 110px">최초 감지</th>
                      <th style="width: 110px">처리</th>
                    </tr>
                  </thead>
                  <tbody id="unitTableBody"></tbody>
                </table>
              </div>
              <div class="c-pagination" id="unitPagination"></div>
            </div>
          </div>
        </div>

        <div id="view-history">
          <!-- 처리 이력 -->
          <div class="c-card c-card--divide">
            <div class="c-card__header">
              <div>
                <div class="c-card__title">처리 이력</div>
                <div class="c-card__sub" id="histCount">총 0건의 처리 기록</div>
              </div>
              <div class="c-card__actions">
                <select class="c-select" style="width: 130px" onchange="filterHistType(this.value)">
                  <option value="">전체 유형</option>
                  <option value="입주민등록">입주민 등록</option>
                  <option value="계약갱신">계약 갱신</option>
                  <option value="공실전환">공실 전환</option>
                  <option value="강제처리">강제 처리</option>
                </select>
              </div>
            </div>
            <div class="c-card__body" style="padding: 0">
              <div class="c-table-wrap">
                <table class="c-table">
                  <thead>
                    <tr>
                      <th style="width: 110px">처리 일자</th>
                      <th style="width: 130px">대상 (동/호)</th>
                      <th style="width: 110px">처리 유형</th>
                      <th style="width: 200px">상태 변경</th>
                      <th style="width: 110px">담당 관리자</th>
                      <th>사유 메모</th>
                    </tr>
                  </thead>
                  <tbody id="historyTableBody"></tbody>
                </table>
              </div>
              <div class="c-pagination" id="histPagination"></div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 상세 모달 (보기 전용) -->
    <div class="c-modal-overlay is-hidden" id="detailOverlay" onclick="if(event.target===this)closeDetail()">
      <div class="c-modal c-modal--lg" role="dialog" aria-labelledby="so-title" aria-modal="true">
        <div class="c-modal__header">
          <h3 class="c-modal__title" id="so-title">세대 상세</h3>
          <button class="c-modal__close" onclick="closeDetail()" aria-label="닫기"><span class="material-symbols-rounded">close</span></button>
        </div>
        <div class="c-modal__body" id="so-body"></div>
        <div class="c-modal__footer" id="so-footer"></div>
      </div>
    </div>

    <!-- 처리 모달 -->
    <div class="c-modal-overlay is-hidden" id="modalOverlay">
      <div class="c-modal">
        <div class="c-modal__header">
          <h4 class="c-modal__title" id="modalTitle">처리 진행</h4>
          <button class="c-modal__close" onclick="closeModal()" aria-label="닫기"><span class="material-symbols-rounded">close</span></button>
        </div>
        <div class="c-modal__body">
          <div style="background: var(--gray-soft); border-radius: var(--r-sm); padding: 12px 14px; margin-bottom: 16px; font-size: 13px; color: var(--text-secondary)" id="modalInfo"></div>
          <div class="c-field" style="margin-bottom: 14px">
            <label class="c-label">처리 유형</label>
            <select class="c-select" id="modalActionType">
              <option value="입주민등록">입주민 등록</option>
              <option value="계약갱신">계약 갱신</option>
              <option value="공실전환">공실 전환</option>
              <option value="강제처리">기타 강제 처리</option>
            </select>
          </div>
          <div class="c-field" style="margin-bottom: 14px">
            <label class="c-label">처리 후 상태</label>
            <select class="c-select" id="modalAfterStatus">
              <option value="정상">정상</option>
              <option value="공실">공실</option>
              <option value="계약중">계약 중</option>
              <option value="보류">보류</option>
            </select>
          </div>
          <div class="c-field">
            <label class="c-label">사유 메모 <span class="req">*</span></label>
            <textarea class="c-textarea" id="modalMemo" rows="3" placeholder="처리 사유를 명확히 입력하세요. 이력에 그대로 기록됩니다."></textarea>
          </div>
        </div>
        <div class="c-modal__footer">
          <button class="c-btn c-btn--ghost" onclick="closeModal()">취소</button>
          <button class="c-btn c-btn--primary" onclick="submitAction()">처리 완료</button>
        </div>
      </div>
    </div>

    <script>
      const PAGE_SIZE = 10;

      const UNITS=[];(function(){
        const raw=[
          ["101동","201호","unregistered","미등록","입주민 정보 없음 (세대 데이터 존재)","2026-04-10"],
          ["101동","305호","unregistered","미등록","입주민 정보 없음 (세대 데이터 존재)","2026-04-12"],
          ["102동","102호","unregistered","미등록","입주민 정보 없음","2026-04-14"],
          ["102동","401호","unregistered","미등록","세대 생성 후 30일 초과 미등록","2026-03-21"],
          ["103동","108호","unregistered","미등록","입주민 정보 없음","2026-04-18"],
          ["103동","210호","unregistered","미등록","입주민 정보 없음 (관리자 메모 없음)","2026-04-19"],
          ["104동","302호","unregistered","미등록","입주민 정보 없음","2026-04-20"],
          ["101동","503호","expiring","만료임박","계약 만료 D-7 (2026-04-29)","2026-04-15"],
          ["102동","201호","expiring","만료임박","계약 만료 D-14 (2026-05-06)","2026-04-15"],
          ["103동","405호","expiring","만료임박","계약 만료 D-20 (2026-05-12)","2026-04-15"],
          ["104동","101호","expiring","만료임박","계약 만료 D-28 (2026-05-20)","2026-04-15"],
          ["105동","304호","expiring","만료임박","계약 만료 D-30 (2026-05-22)","2026-04-15"],
          ["101동","601호","vacant","공실후보","3개월 이상 관리비 미납, 이동 의심","2026-04-01"],
          ["102동","502호","vacant","공실후보","2개월 미납, 연락 두절","2026-04-08"],
          ["103동","303호","vacant","공실후보","입주민 이사 통보 후 미처리","2026-04-11"],
          ["105동","201호","vacant","공실후보","현장 방문 시 공실 확인","2026-04-16"],
        ];
        raw.forEach((r,i)=>UNITS.push({id:i+1,dong:r[0],ho:r[1],type:r[2],status:r[3],detail:r[4],detected:r[5]}));
      })();

      const HISTORY = [
        { date: "2026-04-21", dong: "101동", ho: "101호", type: "입주민등록", from: "미등록", to: "정상", manager: "김철수", memo: "신규 입주민 홍길동 등록 완료" },
        { date: "2026-04-20", dong: "102동", ho: "302호", type: "공실전환", from: "공실후보", to: "공실", manager: "이영희", memo: "2개월 연락 두절 후 현장 확인" },
        { date: "2026-04-19", dong: "103동", ho: "204호", type: "계약갱신", from: "만료임박", to: "정상", manager: "박민준", memo: "임차인 요청으로 1년 갱신" },
        { date: "2026-04-18", dong: "104동", ho: "501호", type: "입주민등록", from: "미등록", to: "정상", manager: "김철수", memo: "전입신고 확인 후 등록" },
        { date: "2026-04-17", dong: "101동", ho: "403호", type: "공실전환", from: "정상", to: "공실", manager: "이영희", memo: "퇴거 완료 확인" },
        { date: "2026-04-15", dong: "102동", ho: "105호", type: "계약갱신", from: "만료임박", to: "정상", manager: "박민준", memo: "2년 갱신 계약 체결" },
        { date: "2026-04-12", dong: "103동", ho: "401호", type: "입주민등록", from: "미등록", to: "정상", manager: "김철수", memo: "세대주 직접 방문 등록" },
        { date: "2026-04-10", dong: "105동", ho: "302호", type: "강제처리", from: "공실후보", to: "보류", manager: "이영희", memo: "소송 진행 중 처리 보류" },
      ];

      let currentTab = "all";
      let unitPage = 1;
      let unitSearch = "";
      let histPage = 1;
      let histTypeFilter = "";
      let pendingUnit = null;

      const STATUS_BADGE = {
        미등록: "c-badge c-badge--danger",
        만료임박: "c-badge c-badge--pending",
        공실후보: "c-badge c-badge--jeonse",
        정상: "c-badge c-badge--active",
        공실: "c-badge c-badge--neutral",
        보류: "c-badge c-badge--pending",
        계약중: "c-badge c-badge--jeonse",
      };
      function statusSpan(s) { return `<span class="${STATUS_BADGE[s] || "c-badge c-badge--neutral"}">${s}</span>`; }

      function escapeHTML(s){return String(s).replace(/[&<>"]/g,c=>({"&":"&amp;","<":"&lt;",">":"&gt;","\"":"&quot;"})[c]);}

      const TYPE_LABEL = { unregistered: "미등록", expiring: "만료 임박", vacant: "공실 후보" };
      const TYPE_BADGE = { unregistered: "c-badge c-badge--danger", expiring: "c-badge c-badge--pending", vacant: "c-badge c-badge--jeonse" };
      function typeSpan(t) { return `<span class="${TYPE_BADGE[t] || "c-badge c-badge--neutral"}">${TYPE_LABEL[t] || t}</span>`; }

      function getExpiringDays(detail) {
        const m = String(detail || "").match(/D-(\d+)/);
        return m ? Number(m[1]) : null;
      }
      function urgencySpan(u) {
        if (u.type === "expiring") {
          const d = getExpiringDays(u.detail);
          if (d == null) return `<span class="c-badge c-badge--pending">만료임박</span>`;
          if (d <= 7) return `<span class="c-badge c-badge--danger">D-${d}</span>`;
          if (d <= 14) return `<span class="c-badge c-badge--pending">D-${d}</span>`;
          return `<span class="c-badge c-badge--neutral">D-${d}</span>`;
        }
        if (u.type === "vacant") return `<span class="c-badge c-badge--jeonse">점검 필요</span>`;
        if (u.type === "unregistered") return `<span class="c-badge c-badge--danger">즉시</span>`;
        return `<span class="c-badge c-badge--neutral">-</span>`;
      }

      function filteredUnits() {
        let arr = currentTab === "all" ? UNITS : UNITS.filter(u => u.type === currentTab);
        if (unitSearch) {
          const q = unitSearch.toLowerCase();
          arr = arr.filter(u => (u.dong + u.ho).toLowerCase().includes(q));
        }
        // 실무 우선순위: 만료임박 D-day 오름차순 → 미등록 → 공실후보 → 감지일 최신
        const priority = { expiring: 0, unregistered: 1, vacant: 2 };
        return arr.slice().sort((a, b) => {
          const pa = priority[a.type] ?? 9;
          const pb = priority[b.type] ?? 9;
          if (pa !== pb) return pa - pb;
          if (a.type === "expiring" && b.type === "expiring") {
            const da = getExpiringDays(a.detail) ?? 9999;
            const db = getExpiringDays(b.detail) ?? 9999;
            if (da !== db) return da - db;
          }
          return b.detected.localeCompare(a.detected);
        });
      }

      function renderUnits() {
        const all = filteredUnits();
        const last = Math.max(1, Math.ceil(all.length / PAGE_SIZE));
        if (unitPage > last) unitPage = last;
        const slice = all.slice((unitPage - 1) * PAGE_SIZE, unitPage * PAGE_SIZE);

        const ACTION_DEFAULT = { unregistered: "입주민등록", expiring: "계약갱신", vacant: "공실전환" };
        const tbody = document.getElementById("unitTableBody");
        tbody.innerHTML = slice.length ? slice.map(u => {
          const action = ACTION_DEFAULT[u.type] || "강제처리";
          return `<tr style="cursor:pointer" onclick="openDetail(${u.id})">
            <td><strong>${u.dong} ${u.ho}</strong></td>
            <td>${typeSpan(u.type)}</td>
            <td>${urgencySpan(u)}</td>
            <td class="muted">${escapeHTML(u.detail)}</td>
            <td class="muted">${u.detected}</td>
            <td onclick="event.stopPropagation()">
              <button class="c-btn c-btn--primary c-btn--sm" onclick="openModal(${u.id},'${action}')">처리</button>
            </td>
          </tr>`;
        }).join("") : `<tr class="c-table__empty"><td colspan="6">해당 조건의 비정상 세대가 없습니다.</td></tr>`;

        document.getElementById("unitSubtitle").textContent = `총 ${all.length}건 / ${unitPage} 페이지`;
        renderPagination("unitPagination", all.length, unitPage, last, p => { unitPage = p; renderUnits(); });
      }

      function filteredHistory() {
        return histTypeFilter ? HISTORY.filter(h => h.type === histTypeFilter) : HISTORY;
      }

      function renderHistory() {
        const all = filteredHistory();
        const last = Math.max(1, Math.ceil(all.length / PAGE_SIZE));
        if (histPage > last) histPage = last;
        const slice = all.slice((histPage - 1) * PAGE_SIZE, histPage * PAGE_SIZE);

        const tbody = document.getElementById("historyTableBody");
        tbody.innerHTML = slice.length ? slice.map(h => `
          <tr>
            <td class="muted">${h.date}</td>
            <td><strong>${h.dong} ${h.ho}</strong></td>
            <td><span class="hist-type-tag hist-${h.type}">${h.type}</span></td>
            <td>
              <div class="state-flow">
                ${statusSpan(h.from)}
                <span class="material-symbols-rounded">arrow_forward</span>
                ${statusSpan(h.to)}
              </div>
            </td>
            <td>${h.manager}</td>
            <td class="muted">${escapeHTML(h.memo)}</td>
          </tr>`).join("") : `<tr class="c-table__empty"><td colspan="6">처리 이력이 없습니다.</td></tr>`;

        document.getElementById("histCount").textContent = `총 ${all.length}건의 처리 기록`;
        renderPagination("histPagination", all.length, histPage, last, p => { histPage = p; renderHistory(); });
      }

      function renderPagination(targetId, total, current, last, onChange) {
        const el = document.getElementById(targetId);
        if (last <= 1) { el.innerHTML = ""; return; }
        const btn = (label, page, opts={}) => {
          const cls = ["c-pagination__btn"];
          if (opts.active) cls.push("is-active");
          if (opts.disabled) cls.push("is-disabled");
          return `<button class="${cls.join(" ")}" data-page="${page}">${label}</button>`;
        };
        let html = btn(`<span class="material-symbols-rounded">chevron_left</span>`, current-1, { disabled: current===1 });
        for (let i = 1; i <= last; i++) html += btn(i, i, { active: i === current });
        html += btn(`<span class="material-symbols-rounded">chevron_right</span>`, current+1, { disabled: current===last });
        el.innerHTML = html;
        el.querySelectorAll(".c-pagination__btn").forEach(b => {
          b.addEventListener("click", () => {
            if (b.classList.contains("is-disabled") || b.classList.contains("is-active")) return;
            onChange(Number(b.dataset.page));
          });
        });
      }

      function filterUnits(v) { unitSearch = v; unitPage = 1; renderUnits(); }
      function filterHistType(v) { histTypeFilter = v; histPage = 1; renderHistory(); }

      function setUnitType(v) { currentTab = v; unitPage = 1; renderUnits(); }

      function refreshCounts() {
        const u = ["unregistered","expiring","vacant"];
        const map = {};
        u.forEach(t => map[t] = UNITS.filter(x=>x.type===t).length);
        const sel = document.getElementById("unitTypeSelect");
        if (sel) sel.value = currentTab;
      }

      function openModal(unitId, actionType) {
        pendingUnit = UNITS.find(u => u.id === unitId);
        if (!pendingUnit) return;
        document.getElementById("modalTitle").textContent = actionType + " 처리";
        document.getElementById("modalInfo").innerHTML = `<strong style="color:var(--text-primary)">${pendingUnit.dong} ${pendingUnit.ho}</strong> · 현재 상태: ${statusSpan(pendingUnit.status)}<br><span style="margin-top:4px;display:block">${escapeHTML(pendingUnit.detail)}</span>`;
        document.getElementById("modalActionType").value = actionType;
        const afterMap = { 입주민등록: "정상", 계약갱신: "정상", 공실전환: "공실", 강제처리: "보류" };
        document.getElementById("modalAfterStatus").value = afterMap[actionType] || "정상";
        document.getElementById("modalMemo").value = "";
        document.getElementById("modalOverlay").classList.remove("is-hidden");
      }
      function closeModal() {
        document.getElementById("modalOverlay").classList.add("is-hidden");
        pendingUnit = null;
      }
      function submitAction() {
        const memo = document.getElementById("modalMemo").value.trim();
        if (!memo) { alert("사유 메모를 입력해주세요."); return; }
        const actionType = document.getElementById("modalActionType").value;
        const afterStatus = document.getElementById("modalAfterStatus").value;
        const today = new Date().toISOString().slice(0,10);
        HISTORY.unshift({ date: today, dong: pendingUnit.dong, ho: pendingUnit.ho, type: actionType, from: pendingUnit.status, to: afterStatus, manager: "중앙관리자", memo });
        const idx = UNITS.findIndex(u => u.id === pendingUnit.id);
        if (idx > -1) UNITS.splice(idx, 1);
        closeModal();
        refreshCounts();
        renderUnits();
        renderHistory();
      }
      document.getElementById("modalOverlay").addEventListener("click", function (e) {
        if (e.target === this) closeModal();
      });

      function openDetail(unitId) {
        const u = UNITS.find(x => x.id === unitId);
        if (!u) return;
        const ACTION_DEFAULT = { unregistered: "입주민등록", expiring: "계약갱신", vacant: "공실전환" };
        const action = ACTION_DEFAULT[u.type] || "강제처리";
        document.getElementById("so-title").textContent = `${u.dong} ${u.ho} · ${TYPE_LABEL[u.type] || u.type}`;
        document.getElementById("so-body").innerHTML = `
          <div>
            <div class="c-so__section-title"><span class="material-symbols-rounded">info</span>요약</div>
            <div class="c-info-grid">
              <div class="c-info-block"><div class="c-info-field__label">유형</div><div class="c-info-field__val">${typeSpan(u.type)}</div></div>
              <div class="c-info-block"><div class="c-info-field__label">긴급도</div><div class="c-info-field__val">${urgencySpan(u)}</div></div>
              <div class="c-info-block"><div class="c-info-field__label">최초 감지</div><div class="c-info-field__val">${u.detected}</div></div>
              <div class="c-info-block c-info-field--full"><div class="c-info-field__label">세부 사항</div><div class="c-info-field__val">${escapeHTML(u.detail)}</div></div>
            </div>
          </div>
          <div>
            <div class="c-so__section-title"><span class="material-symbols-rounded">history</span>최근 처리 이력</div>
            <div class="c-table-wrap" style="border:1px solid var(--border);border-radius:10px">
              <table class="c-table">
                <thead><tr><th style="width:110px">일자</th><th style="width:110px">유형</th><th>메모</th></tr></thead>
                <tbody>
                  ${
                    filteredHistory()
                      .filter(h => h.dong === u.dong && h.ho === u.ho)
                      .slice(0, 5)
                      .map(h => `<tr><td class="muted">${h.date}</td><td><span class="hist-type-tag hist-${h.type}">${h.type}</span></td><td class="muted">${escapeHTML(h.memo)}</td></tr>`)
                      .join("")
                    || `<tr class="c-table__empty"><td colspan="3">최근 처리 이력이 없습니다.</td></tr>`
                  }
                </tbody>
              </table>
            </div>
          </div>
        `;
        document.getElementById("so-footer").innerHTML = `
          <button class="c-btn c-btn--ghost" onclick="closeDetail()">닫기</button>
          <button class="c-btn c-btn--primary" onclick="openModal(${u.id}, '${action}')"><span class="material-symbols-rounded">check</span>${action} 처리</button>
        `;
        document.getElementById("detailOverlay").classList.remove("is-hidden");
      }
      function closeDetail() {
        document.getElementById("detailOverlay").classList.add("is-hidden");
      }

      refreshCounts();
      renderUnits();
      renderHistory();
    </script>
    <script>
      function toggleSidebar(){var s=document.getElementById("sidebar");if(s)s.classList.toggle("collapsed");}
      var logoIcon=document.getElementById("logoIcon");
      if(logoIcon){logoIcon.onclick=function(){var s=document.getElementById("sidebar");if(s&&s.classList.contains("collapsed"))toggleSidebar();};}
    </script>
  </body>
</html>
