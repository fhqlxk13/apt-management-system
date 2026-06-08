<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>관리사무소</title>

  <!-- Spring Security CSRF 토큰 -->
  <sec:csrfMetaTags/>

  <!-- 공통 한글 폰트 -->
  <link rel="preconnect" href="https://fonts.googleapis.com" />

  <!-- 공통 한글 폰트 보조 연결 -->
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />

  <!-- Noto Sans KR 폰트 -->
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet" />

  <!-- 공통 아이콘 폰트 -->
  <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet" />

  <!-- 관리사무소 전체 레이아웃 CSS -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/office-layout.css">

  <!-- 관리사무소 공통 화면 CSS -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/manager-common.css">

  <style>
    #meterHistoryPage .meter-stat-row{grid-template-columns:repeat(3,minmax(0,1fr))} #meterHistoryPage .meter-main-card{background:#2e5c38;border-color:#264e30} #meterHistoryPage .meter-stat-inner{width:100%}
    #meterHistoryPage .meter-stat-label{font-size:12px;color:var(--text-tertiary);margin-bottom:4px} #meterHistoryPage .meter-main-card .meter-stat-label{color:rgba(255,255,255,.7)} #meterHistoryPage .meter-stat-value{font-size:26px;font-weight:800;color:var(--text-primary)} #meterHistoryPage .meter-main-card .meter-stat-value{color:#fff} #meterHistoryPage .meter-stat-unit{font-size:14px;font-weight:400} #meterHistoryPage .meter-stat-sub{font-size:11px;color:var(--text-tertiary);margin-top:4px} #meterHistoryPage .meter-main-card .meter-stat-sub{color:rgba(255,255,255,.6)}
    #meterHistoryPage .meter-chip{display:inline-flex;align-items:center;padding:2px 8px;border-radius:99px;font-size:11px;font-weight:600} #meterHistoryPage .meter-chip-light{background:rgba(255,255,255,.15);color:rgba(255,255,255,.9)} #meterHistoryPage .meter-chip-warning{background:#fde68a;color:#6b3d0a}
    #meterHistoryPage .meter-filter-bar{gap:12px} #meterHistoryPage .meter-tab-wrap{display:flex;gap:4px;background:#f0f1f3;border-radius:99px;padding:3px} #meterHistoryPage .meter-tab-btn{padding:5px 16px;border:none;border-radius:99px;font-size:12px;font-weight:600;cursor:pointer;transition:.15s;background:transparent;color:var(--text-secondary);font-family:inherit} #meterHistoryPage .meter-tab-btn.active{background:#2e5c38;color:#fff}
    #meterHistoryPage .meter-filter-period{width:130px} #meterHistoryPage .meter-search{width:240px} #meterHistoryPage .meter-list-info{font-size:11px;color:var(--text-tertiary)}
    #meterHistoryPage .tbl-fixed{width:100%;table-layout:auto;border-collapse:collapse} #meterHistoryPage .tbl-fixed th,#meterHistoryPage .tbl-fixed td{box-sizing:border-box;vertical-align:middle;white-space:nowrap;text-align:center!important}
    #meterHistoryPage .meter-actions{text-align:center!important} #meterHistoryPage .meter-actions .btn{justify-content:center} #meterHistoryPage .meter-mono{font-family:monospace;color:var(--text-tertiary);text-align:center!important} #meterHistoryPage .meter-mono-strong{font-family:monospace;font-weight:700;color:var(--text-primary);text-align:center!important}
    #meterHistoryPage .meter-calc-box{display:flex;align-items:center;gap:10px;padding:12px 16px;background:#f0f7f2;border:1px solid #a8ccb0;border-radius:8px;margin-bottom:14px} #meterHistoryPage .meter-calc-box .material-symbols-rounded{color:#2e5c38;font-size:18px} #meterHistoryPage .meter-calc-label{font-size:11px;color:#2e5c38;font-weight:700} #meterHistoryPage .meter-calc-value{font-size:18px;font-weight:800;color:#1a5c30}
    #meterHistoryPage .meter-empty{text-align:center!important;color:var(--text-tertiary)} #meterHistoryPage .meter-text-small{font-size:11px;color:var(--text-tertiary)} #meterHistoryPage .calc-error{color:#991b1b}
  </style>
</head>

<body>
<div class="app-wrapper">

  <!-- 관리사무소 좌측 사이드바 include -->
  <%@ include file="/WEB-INF/views/include/office_sidebar.jsp" %>

  <div class="main-wrap">

    <!-- 관리사무소 상단 헤더 include -->
    <%@ include file="/WEB-INF/views/include/office_header.jsp" %>

    <main class="main-content">
      <div class="office-page" id="meterHistoryPage">

        <div class="page-header">
          <div class="page-title-block">
            <h2>검침 기록 관리</h2>
            <p>전기 및 수도 사용량 검침 기록을 등록·수정·조회합니다.</p>
          </div>

          <div class="page-actions">
            <button type="button" class="btn btn-primary" data-action="openRegister">
              <span class="material-symbols-rounded">add</span>
              신규 검침 등록
            </button>
          </div>
        </div>

        <div class="stat-row meter-stat-row">
          <div class="stat-card meter-main-card">
            <div class="meter-stat-inner">
              <div class="meter-stat-label">이번 달 총 전기 사용량</div>
              <div class="meter-stat-value" id="statElec">842.5 <span class="meter-stat-unit">kWh</span></div>
              <div class="meter-stat-sub">
                <span class="meter-chip meter-chip-light">전월 대비 4.2% 감소</span>
              </div>
            </div>
          </div>

          <div class="stat-card">
            <div class="meter-stat-inner">
              <div class="meter-stat-label">이번 달 총 수도 사용량</div>
              <div class="meter-stat-value" id="statWater">32.8 <span class="meter-stat-unit">㎥</span></div>
              <div class="meter-stat-sub">
                <span class="meter-chip meter-chip-warning">전월 대비 12% 증가</span>
              </div>
            </div>
          </div>

          <div class="stat-card">
            <div class="meter-stat-inner">
              <div class="meter-stat-label">최근 입력 건수</div>
              <div class="meter-stat-value" id="statCount">0</div>
              <div class="meter-stat-sub" id="statCountSub">전기 0건 · 수도 0건</div>
            </div>
          </div>
        </div>

        <div class="panel">
          <div class="filter-bar meter-filter-bar">
            <div class="meter-tab-wrap">
              <button type="button" class="meter-tab-btn active" data-meter-tab="ALL">전체</button>
              <button type="button" class="meter-tab-btn" data-meter-tab="ELEC">전기</button>
              <button type="button" class="meter-tab-btn" data-meter-tab="WATER">수도</button>
            </div>

            <select class="form-select meter-filter-period" id="filterPeriod">
              <option value="7">최근 7일</option>
              <option value="30">최근 30일</option>
              <option value="90">최근 3개월</option>
              <option value="0">전체</option>
            </select>

            <div class="search-wrap meter-search">
              <span class="material-symbols-rounded">search</span>
              <input type="text" class="form-input" id="filterKeyword" placeholder="동·호수, 시설명 검색">
            </div>

            <button type="button" class="btn btn-primary" data-action="search">검색</button>
            <button type="button" class="btn btn-secondary" data-action="resetFilter">초기화</button>
          </div>

          <div class="panel-header">
            <h3 class="panel-title">
              <span class="material-symbols-rounded">speed</span>
              검침 기록 리스트
            </h3>
            <span class="meter-list-info">총 <span id="meterListCount">0</span>건</span>
          </div>

          <div class="table-wrap">
            <table class="tbl tbl-fixed">
              <thead>
              <tr>
                <th>시설명</th>
                <th>동·호</th>
                <th>항목</th>
                <th>이전 지침</th>
                <th>현재 지침</th>
                <th>사용량</th>
                <th>결과</th>
                <th>검침일</th>
                <th>관리</th>
              </tr>
              </thead>
              <tbody id="meterTableBody"></tbody>
            </table>
          </div>
        </div>

        <div class="modal-overlay" id="meterModal">
          <div class="modal modal-md">
            <div class="modal-header">
              <h3 class="modal-title" id="meterModalTitle">신규 검침 등록</h3>
              <button type="button" class="modal-close" data-action="closeModal">
                <span class="material-symbols-rounded">close</span>
              </button>
            </div>

            <form id="meterForm">
              <input type="hidden" id="meterHstryNo">

              <div class="modal-body">
                <div class="form-section">
                  <div class="form-section-title">
                    <span class="material-symbols-rounded">speed</span>
                    검침 정보
                  </div>

                  <div class="form-row cols-2">
                    <div class="form-field">
                      <label class="field-label">시설명 <span class="req">*</span></label>
                      <input type="text" class="form-input" id="mFacilityNm" placeholder="예: 커뮤니티센터">
                    </div>

                    <div class="form-field">
                      <label class="field-label">동·호</label>
                      <input type="text" class="form-input" id="mHoNo" placeholder="예: 102동 201호">
                    </div>
                  </div>

                  <div class="form-row cols-2">
                    <div class="form-field">
                      <label class="field-label">검침일 <span class="req">*</span></label>
                      <input type="date" class="form-input" id="mMeterDt">
                    </div>

                    <div class="form-field">
                      <label class="field-label">검침 항목</label>
                      <select class="form-select" id="mMeterTyCd">
                        <option value="ELEC">전기</option>
                        <option value="WATER">수도</option>
                        <option value="GAS">가스</option>
                        <option value="HEAT">난방</option>
                      </select>
                    </div>
                  </div>

                  <div class="form-row cols-2">
                    <div class="form-field">
                      <label class="field-label">이전 지침</label>
                      <input type="number" class="form-input" id="mPreVal" placeholder="0.00" step="0.01">
                    </div>

                    <div class="form-field">
                      <label class="field-label">현재 지침 <span class="req">*</span></label>
                      <input type="number" class="form-input" id="mCurrVal" placeholder="0.00" step="0.01">
                    </div>
                  </div>

                  <div class="meter-calc-box">
                    <span class="material-symbols-rounded">calculate</span>
                    <div>
                      <div class="meter-calc-label">사용량 자동 계산</div>
                      <div class="meter-calc-value" id="calcUsageDisplay">-</div>
                    </div>
                  </div>

                  <div class="form-row cols-2">
                    <div class="form-field">
                      <label class="field-label">검침 결과</label>
                      <select class="form-select" id="mMeterRsltCd">
                        <option value="NORMAL">정상</option>
                        <option value="ERROR">오류</option>
                        <option value="MISS">누락</option>
                        <option value="CHECK">확인필요</option>
                      </select>
                    </div>
                  </div>

                  <div class="form-row cols-1">
                    <div class="form-field">
                      <label class="field-label">검침 메모</label>
                      <textarea class="form-textarea" id="mMeterCn" placeholder="특이사항을 입력하세요."></textarea>
                    </div>
                  </div>
                </div>
              </div>

              <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-action="closeModal">닫기</button>
                <button type="submit" class="btn btn-primary" id="meterSaveBtn">저장</button>
              </div>
            </form>
          </div>
        </div>

      </div>
    </main>
  </div>
</div>

<script>
  document.addEventListener("DOMContentLoaded", function () {
    initMeterHistoryPage();
  });

  function initMeterHistoryPage() {
    var page = document.getElementById("meterHistoryPage");
    if (!page || page.dataset.bound === "true") return;
    page.dataset.bound = "true";

    var modal = document.getElementById("meterModal");
    var form = document.getElementById("meterForm");
    var modalTitle = document.getElementById("meterModalTitle");
    var tbody = document.getElementById("meterTableBody");
    var currentTab = "ALL";

    var rowData = [
      { meterHstryNo:"MH001", facilityNm:"커뮤니티센터", hoNo:"-", meterTyCd:"WATER", preVal:2105, currVal:2118, meterDt:"2026-04-14", meterRsltCd:"NORMAL", meterCn:"" },
      { meterHstryNo:"MH002", facilityNm:"102동 지하주차장", hoNo:"-", meterTyCd:"ELEC", preVal:158420, currVal:158950, meterDt:"2026-04-14", meterRsltCd:"NORMAL", meterCn:"" },
      { meterHstryNo:"MH003", facilityNm:"101동", hoNo:"102호", meterTyCd:"ELEC", preVal:42150, currVal:42284, meterDt:"2026-04-13", meterRsltCd:"ERROR", meterCn:"계량기 이상 의심" },
      { meterHstryNo:"MH004", facilityNm:"101동", hoNo:"201호", meterTyCd:"WATER", preVal:830, currVal:844, meterDt:"2026-04-13", meterRsltCd:"NORMAL", meterCn:"" },
      { meterHstryNo:"MH005", facilityNm:"103동", hoNo:"501호", meterTyCd:"ELEC", preVal:91200, currVal:91200, meterDt:"2026-04-12", meterRsltCd:"MISS", meterCn:"검침 누락" }
    ];

    var METER_TY = { ELEC:"전기", WATER:"수도", GAS:"가스", HEAT:"난방" };
    var METER_TY_BADGE = { ELEC:"badge-yellow", WATER:"badge-blue", GAS:"badge-orange", HEAT:"badge-red" };
    var RSLT_TEXT = { NORMAL:"정상", ERROR:"오류", MISS:"누락", CHECK:"확인필요" };
    var RSLT_BADGE = { NORMAL:"badge-green", ERROR:"badge-red", MISS:"badge-orange", CHECK:"badge-yellow" };
    var UNIT = { ELEC:"kWh", WATER:"㎥", GAS:"㎥", HEAT:"Mcal" };

    function meterBadge(code) {
      return '<span class="badge ' + (METER_TY_BADGE[code] || "badge-gray") + '">' + (METER_TY[code] || code) + '</span>';
    }

    function rsltBadge(code) {
      return '<span class="badge ' + (RSLT_BADGE[code] || "badge-gray") + '">' + (RSLT_TEXT[code] || code) + '</span>';
    }

    function updateStats(data) {
      var elecCnt = data.filter(function (row) { return row.meterTyCd === "ELEC"; }).length;
      var waterCnt = data.filter(function (row) { return row.meterTyCd === "WATER"; }).length;

      document.getElementById("statCount").textContent = data.length;
      document.getElementById("statCountSub").textContent = "전기 " + elecCnt + "건 · 수도 " + waterCnt + "건";
    }

    function renderTable(data) {
      document.getElementById("meterListCount").textContent = data.length;
      updateStats(data);

      if (data.length === 0) {
        tbody.innerHTML = '<tr><td colspan="9" class="meter-empty">검침 기록이 없습니다.</td></tr>';
        return;
      }

      tbody.innerHTML = data.map(function (row, idx) {
        var usage = row.currVal - row.preVal;
        var unit = UNIT[row.meterTyCd] || "";

        var usageTxt = usage > 0
                ? '<strong>' + usage.toLocaleString() + '</strong> <span class="meter-text-small">' + unit + '</span>'
                : '<span class="meter-text-small">0</span>';

        return '<tr>'
                + '<td class="td-bold">' + row.facilityNm + '</td>'
                + '<td>' + (row.hoNo || "-") + '</td>'
                + '<td>' + meterBadge(row.meterTyCd) + '</td>'
                + '<td class="meter-mono">' + row.preVal.toLocaleString() + '</td>'
                + '<td class="meter-mono-strong">' + row.currVal.toLocaleString() + '</td>'
                + '<td>' + usageTxt + '</td>'
                + '<td>' + rsltBadge(row.meterRsltCd) + '</td>'
                + '<td>' + row.meterDt + '</td>'
                + '<td class="meter-actions">'
                + '<button type="button" class="btn btn-xs btn-edit" data-action="edit" data-idx="' + idx + '">수정</button>'
                + '</td>'
                + '</tr>';
      }).join("");
    }

    function getFiltered() {
      var keyword = document.getElementById("filterKeyword").value.trim();

      return rowData.filter(function (row) {
        var tabMatch = currentTab === "ALL" || row.meterTyCd === currentTab;
        var kwMatch = !keyword || row.facilityNm.indexOf(keyword) > -1 || row.hoNo.indexOf(keyword) > -1;

        return tabMatch && kwMatch;
      });
    }

    function resetFilter() {
      document.getElementById("filterKeyword").value = "";
      document.getElementById("filterPeriod").value = "7";
      setTab("ALL");
      renderTable(rowData);
    }

    function setTab(tab) {
      currentTab = tab;

      page.querySelectorAll(".meter-tab-btn").forEach(function (btn) {
        btn.classList.toggle("active", btn.dataset.meterTab === tab);
      });
    }

    function calcUsage() {
      var pre = parseFloat(document.getElementById("mPreVal").value) || 0;
      var curr = parseFloat(document.getElementById("mCurrVal").value) || 0;
      var ty = document.getElementById("mMeterTyCd").value;
      var usage = curr - pre;
      var unit = UNIT[ty] || "";
      var display = document.getElementById("calcUsageDisplay");

      if (!document.getElementById("mCurrVal").value) {
        display.textContent = "-";
        return;
      }

      if (usage < 0) {
        display.innerHTML = '<span class="calc-error">지침값 확인 필요</span>';
        return;
      }

      display.textContent = usage.toFixed(2) + " " + unit;
    }

    function openModal(mode, idx) {
      form.reset();
      document.getElementById("calcUsageDisplay").textContent = "-";

      if (mode === "register") {
        modalTitle.textContent = "신규 검침 등록";
        document.getElementById("mMeterDt").value = new Date().toISOString().slice(0, 10);
      }

      if (mode === "edit" && idx !== undefined) {
        modalTitle.textContent = "검침 수정";
        fillForm(rowData[idx]);
      }

      modal.classList.add("open");
    }

    function fillForm(row) {
      document.getElementById("meterHstryNo").value = row.meterHstryNo || "";
      document.getElementById("mFacilityNm").value = row.facilityNm || "";
      document.getElementById("mHoNo").value = row.hoNo || "";
      document.getElementById("mMeterDt").value = row.meterDt || "";
      document.getElementById("mMeterTyCd").value = row.meterTyCd || "ELEC";
      document.getElementById("mPreVal").value = row.preVal || "";
      document.getElementById("mCurrVal").value = row.currVal || "";
      document.getElementById("mMeterRsltCd").value = row.meterRsltCd || "NORMAL";
      document.getElementById("mMeterCn").value = row.meterCn || "";

      calcUsage();
    }

    function closeModal() {
      modal.classList.remove("open");
    }

    document.getElementById("mPreVal").addEventListener("input", calcUsage);
    document.getElementById("mCurrVal").addEventListener("input", calcUsage);
    document.getElementById("mMeterTyCd").addEventListener("change", calcUsage);

    page.addEventListener("click", function (event) {
      var tabBtn = event.target.closest(".meter-tab-btn");

      if (tabBtn) {
        setTab(tabBtn.dataset.meterTab);
        renderTable(getFiltered());
        return;
      }

      var btn = event.target.closest("[data-action]");
      if (!btn) return;

      var action = btn.dataset.action;
      var idx = btn.dataset.idx !== undefined ? Number(btn.dataset.idx) : undefined;

      if (action === "openRegister") openModal("register");
      if (action === "edit") openModal("edit", idx);
      if (action === "closeModal") closeModal();
      if (action === "search") renderTable(getFiltered());
      if (action === "resetFilter") resetFilter();
    });

    modal.addEventListener("click", function (event) {
      if (event.target === modal) {
        closeModal();
      }
    });

    form.addEventListener("submit", function (event) {
      event.preventDefault();

      if (!document.getElementById("mFacilityNm").value.trim()) {
        alert("시설명을 입력하세요.");
        return;
      }

      if (!document.getElementById("mMeterDt").value) {
        alert("검침일을 선택하세요.");
        return;
      }

      if (!document.getElementById("mCurrVal").value) {
        alert("현재 지침을 입력하세요.");
        return;
      }

      alert("저장 처리 예정입니다.");
      closeModal();
    });

    renderTable(rowData);
  }
</script>
</body>
</html>