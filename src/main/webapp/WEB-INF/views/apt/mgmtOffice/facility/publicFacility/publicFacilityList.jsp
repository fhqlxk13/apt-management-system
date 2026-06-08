<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>편의시설 운영관리</title>

    <sec:csrfMetaTags/>

    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet" />

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/office-layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/manager-common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/ag-grid.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/ag-theme-alpine.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/manager-agGrid.css">

    <style>
        #publicFacilityPage { --accent:#2e5c38; --accent-hover:#1f4027; --accent-light:#e8f0ea; --accent-dim:rgba(46,92,56,.08); --surface:#fff; --surface-sub:#f8f9fb; --line:#d7dce2; --th-bg:#f0f2ef; --text-head:#1a2e1e; --text-sec:#4a5c4e; --text-ter:#8a9a8e; }
        #publicFacilityPage .page-title-block h2 { color:var(--text-head); font-size:19px; letter-spacing:-.5px; }
        #publicFacilityPage .page-title-block p { color:#6b7a6e; font-size:12px; }
        #publicFacilityPage .panel { border-radius:6px; border:1px solid var(--line); box-shadow:none; margin:0; background:#fff; }
        #publicFacilityPage .panel + .panel { margin-top:14px; }
        #publicFacilityPage .panel-header { display:flex; align-items:center; justify-content:space-between; padding:13px 16px; border-bottom:1px solid var(--line); background:var(--surface); border-radius:6px 6px 0 0; }
        #publicFacilityPage .panel-title { display:flex; align-items:center; gap:6px; margin:0; font-size:13px; font-weight:800; color:var(--text-head); }
        #publicFacilityPage .panel-title .material-symbols-rounded { font-size:17px; color:var(--accent); }
        #publicFacilityPage .panel-body { padding:14px 16px 16px; background:var(--surface); }
        #publicFacilityPage .panel-body .form-input, #publicFacilityPage .panel-body .form-select { height:32px; font-size:12px; border-color:var(--line); background:var(--surface); border-radius:4px; }
        #publicFacilityPage .panel-body .form-input:focus, #publicFacilityPage .panel-body .form-select:focus { border-color:var(--accent); box-shadow:0 0 0 2px var(--accent-dim); }
        #publicFacilityPage .btn { border-radius:4px; }
        #publicFacilityPage .btn-primary { background:var(--accent); border-color:var(--accent); }
        #publicFacilityPage .btn-primary:hover { background:var(--accent-hover); border-color:var(--accent-hover); }
        #publicFacilityPage .list-count { font-size:12px; font-weight:800; color:var(--accent); background:var(--accent-light); border-radius:4px; padding:3px 9px; white-space:nowrap; }
        #publicFacilityPage .result-desc { font-size:11px; color:#7a8a7d; margin-left:8px; font-weight:500; }

        /* 탭 */
        #publicFacilityPage .public-tab-row { display:flex; gap:24px; width:100%; padding:0; margin-bottom:18px; background:transparent; border:none; border-bottom:1px solid var(--line); border-radius:0; }
        #publicFacilityPage .public-tab-btn { position:relative; display:flex; align-items:center; gap:6px; min-height:42px; padding:0 2px; border:none; border-radius:0; background:transparent; color:#6b7280; font-size:13px; font-weight:700; font-family:inherit; cursor:pointer; transition:.15s; }
        #publicFacilityPage .public-tab-btn:hover { color:#111827; }
        #publicFacilityPage .public-tab-btn .material-symbols-rounded { font-size:16px; color:#9ca3af; }
        #publicFacilityPage .public-tab-btn.active { background:transparent; color:#111827; box-shadow:none; }
        #publicFacilityPage .public-tab-btn.active::after { content:""; position:absolute; left:0; right:0; bottom:-1px; height:2px; background:var(--accent); }
        #publicFacilityPage .public-tab-btn.active .material-symbols-rounded { color:var(--accent); }

        /* 검색 조건 */
        #publicFacilityPage .public-filter-panel { overflow:visible; }
        #publicFacilityPage .public-filter-grid { display:grid; grid-template-columns:.75fr .7fr .85fr .75fr .85fr .9fr 1.55fr auto; gap:8px 10px; align-items:end; }
        #publicFacilityPage .filter-action-field { grid-column:auto; }
        #publicFacilityPage .public-filter-actions { display:flex; justify-content:flex-end; gap:7px; white-space:nowrap; }
        #publicFacilityPage.is-item-tab .public-filter-grid { grid-template-columns:1fr 1fr .75fr 1.2fr auto; }
        #publicFacilityPage.is-item-tab .filter-action-field { grid-column:5; }
        #publicFacilityPage .public-filter-grid .btn { min-height:32px; height:32px; padding:0 10px; font-size:12px; border-radius:4px; }
        #publicFacilityPage .search-wrap { position:relative; width:100%; }
        #publicFacilityPage .search-wrap .material-symbols-rounded { position:absolute; left:9px; top:50%; transform:translateY(-50%); font-size:15px; color:#9caa9e; pointer-events:none; }
        #publicFacilityPage .search-wrap input { padding-left:30px; width:100%; }
        #publicFacilityPage .search-auto-wrap { position:relative; width:100%; }
        #publicFacilityPage .facility-suggest-box { display:none; position:absolute; left:0; right:0; top:100%; z-index:30; max-height:210px; overflow-y:auto; background:#fff; border:1px solid var(--line); border-radius:4px; box-shadow:0 8px 18px rgba(15,23,42,.12); }
        #publicFacilityPage .facility-suggest-item { display:block; width:100%; padding:8px 10px; border:0; background:#fff; text-align:left; font-size:12px; cursor:pointer; }
        #publicFacilityPage .facility-suggest-item:hover { background:#f4f7f4; color:var(--accent); }
        #publicFacilityPage .filter-item-only { display:none; }
        #publicFacilityPage.is-item-tab .filter-facility-only { display:none; }
        #publicFacilityPage.is-item-tab .filter-item-only { display:block; }
        #publicFacilityPage .filter-opr-row { display:grid; grid-template-columns:1fr 1fr; gap:6px; }
        #publicFacilityPage .filter-opr-row.cols-3 { grid-template-columns:1fr auto 1fr; align-items:center; margin-top:5px; }
        #publicFacilityPage .filter-opr-sep { font-size:12px; color:var(--text-ter); text-align:center; }
        #publicFacilityPage .filter-custom-day-row { display:none; }
        #publicFacilityPage .filter-custom-day-row.is-active { display:grid; }

        /* 필터 그룹 구분선 */
        #publicFacilityPage .filter-group-divider { grid-column:auto; width:1px; background:var(--line); align-self:stretch; margin:0 2px; }

        /* 목록 헤더 */
        #publicFacilityPage .list-header-left { display:flex; align-items:center; gap:8px; min-width:0; }
        #publicFacilityPage .list-header-right { display:flex; align-items:center; justify-content:flex-end; gap:7px; flex-shrink:0; }
        #publicFacilityPage .list-header-right .btn { min-height:32px; height:32px; padding:0 12px; font-size:12px; border-radius:4px; }

        /* 요약 칩 */
        #publicFacilityPage .summary-strip { display:flex; align-items:center; justify-content:space-between; padding:10px 16px; background:var(--surface-sub); border-bottom:1px solid var(--line); }
        #publicFacilityPage .summary-chips { display:flex; gap:6px; flex-wrap:wrap; }
        #publicFacilityPage .summary-chip { padding:3px 10px; border-radius:20px; border:1px solid var(--line); font-size:12px; color:var(--text-sec); background:#fff; }
        #publicFacilityPage .summary-chip strong { color:var(--accent); font-weight:800; margin-left:4px; }
        #publicFacilityPage .summary-note { font-size:11px; color:var(--text-ter); }

        /* AG Grid */
        #publicFacilityPage .public-grid-wrap { padding:0; overflow:hidden; }
        #publicFacilityPage #publicFacilityGrid { width:100%; border:0; }
        #publicFacilityPage .ag-theme-alpine { --ag-font-family:'Noto Sans KR',sans-serif; --ag-font-size:12px; --ag-header-background-color:#f0f2ef; --ag-header-foreground-color:#4a5c4e; --ag-border-color:#d7dce2; --ag-row-hover-color:#f4f7f4; --ag-selected-row-background-color:#edf6ef; }
        #publicFacilityPage .ag-header-cell-label { justify-content:center; }
        #publicFacilityPage .ag-cell { display:flex; align-items:center; justify-content:center; }
        #publicFacilityPage .cell-center { justify-content:center; text-align:center; }
        #publicFacilityPage .cell-left { justify-content:flex-start; text-align:left; }
        #publicFacilityPage .cell-right { justify-content:flex-end; text-align:right; }
        #publicFacilityPage .cell-mono { font-family:'SF Mono','Consolas',monospace; font-size:11px; color:#6b7a6e; }
        #publicFacilityPage .grid-ellipsis { display:block; max-width:100%; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }
        #publicFacilityPage .grid-actions { display:inline-flex; gap:5px; align-items:center; justify-content:center; width:100%; }
        #publicFacilityPage .grid-actions .btn { min-height:28px; height:28px; padding:0 10px; font-size:11px; border-radius:4px; }
        #publicFacilityPage .ag-cell:focus,
        #publicFacilityPage .ag-cell.ag-cell-focus,
        #publicFacilityPage .grid-actions:focus,
        #publicFacilityPage .grid-actions .btn:focus,
        #publicFacilityPage .grid-actions .btn:focus-visible {
            outline:none !important;
            box-shadow:none !important;
        }

        /* 배지 */
        #publicFacilityPage .badge { display:inline-flex; align-items:center; justify-content:center; min-height:20px; height:20px; padding:0 7px; border-radius:4px; font-size:11px; font-weight:600; line-height:20px; border:1px solid transparent; white-space:nowrap; }
        #publicFacilityPage .badge-green { background:#e8f1eb; color:#1f5a35; border-color:#bdd7c5; }
        #publicFacilityPage .badge-blue { background:#dbeafe; color:#1e3a5f; border-color:#93c5fd; }
        #publicFacilityPage .badge-yellow { background:#fef3c7; color:#713f12; border-color:#fde68a; }
        #publicFacilityPage .badge-red { background:#fee2e2; color:#7f1d1d; border-color:#fca5a5; }
        #publicFacilityPage .badge-gray { background:#f3f4f6; color:#6b7280; border-color:#d1d5db; }

        /* 안내바 */
        #publicFacilityPage .info-line { display:flex; align-items:center; gap:8px; padding:10px 16px; border-top:1px solid var(--line); background:#f8f9fb; font-size:12px; color:#6b7a6e; }
        #publicFacilityPage .info-line .material-symbols-rounded { font-size:15px; color:var(--accent); flex-shrink:0; }

        @media (max-width:1100px) {
            #publicFacilityPage .public-filter-grid, #publicFacilityPage.is-item-tab .public-filter-grid { grid-template-columns:1fr 1fr 1fr; }
            #publicFacilityPage .filter-action-field, #publicFacilityPage.is-item-tab .filter-action-field { grid-column:auto; }
            #publicFacilityPage .filter-group-divider { display:none; }
        }
        @media (max-width:760px) {
            #publicFacilityPage .public-filter-grid, #publicFacilityPage.is-item-tab .public-filter-grid { grid-template-columns:1fr; }
            #publicFacilityPage .filter-action-field, #publicFacilityPage.is-item-tab .filter-action-field { grid-column:auto; }
            #publicFacilityPage .summary-strip, #publicFacilityPage .panel-header { align-items:flex-start; flex-direction:column; gap:8px; }
        }
    </style>

    <script>
        <sec:authorize access="hasRole('ADMIN')" var="publicFacilityAdmin" />
        window.publicFacilityPageConfig = {
            contextPath: "${pageContext.request.contextPath}",
            mgmtOfcNo: "${mgmtOfcNo}",
            isAdmin: ${publicFacilityAdmin}
        };
    </script>

    <script src="${pageContext.request.contextPath}/js/manager/ag-grid-community.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/manager/manager-common.js"></script>
    <script src="${pageContext.request.contextPath}/js/manager/facility/publicfacility/publicFacility-agGrid.js"></script>
</head>

<body>
<div class="app-wrapper">
    <%@ include file="/WEB-INF/views/include/office_sidebar.jsp" %>

    <div class="main-wrap">
        <%@ include file="/WEB-INF/views/include/office_header.jsp" %>
        <c:set var="activeSidebarHref" value="${pageContext.request.contextPath}/manager/publicFacility/page/${mgmtOfcNo}" />
        <c:set var="activeSidebarParent" value="시설·공사 관리" />
        <c:set var="activeSidebarCurrent" value="편의시설 관리" />
        <%@ include file="/WEB-INF/views/include/office_active_sidebar.jspf" %>

        <main class="main-content">
            <div class="office-page" id="publicFacilityPage">

                <div class="page-header">
                    <div class="page-title-block">
                        <h2>편의시설 운영관리</h2>
                        <p>단지 내 편의시설 정보·사진·자원·예약이력을 관리합니다.</p>
                    </div>
                    <div class="page-actions"></div>
                </div>

                <%-- 탭 --%>
                <div class="public-tab-row" role="tablist" aria-label="편의시설 관리 구분">
                    <button type="button" class="public-tab-btn active" id="tabPublicFacility" data-view-type="PUBLIC_FACILITY">
                        <span class="material-symbols-rounded">meeting_room</span>편의시설
                    </button>
                    <button type="button" class="public-tab-btn" id="tabPublicItem" data-view-type="PUBLIC_ITEM">
                        <span class="material-symbols-rounded">inventory_2</span>편의시설 자원
                    </button>
                </div>

                <%-- 검색 조건 --%>
                <div class="panel public-filter-panel">
                    <div class="panel-header">
                        <h3 class="panel-title"><span class="material-symbols-rounded">manage_search</span>검색 조건</h3>
                    </div>
                    <div class="panel-body">
                        <div class="public-filter-grid">

                            <%-- 편의시설 탭 필터: 분류 / 동 / 위치 / 예약여부 / 운영현황 / 수정일 / 편의시설 검색 --%>
                            <div class="form-field filter-facility-only">
                                <label class="field-label">분류</label>
                                <select class="form-select" id="filterFacilityTyCd">
                                    <option value="">전체</option>
                                </select>
                            </div>
                            <div class="form-field filter-facility-only">
                                <label class="field-label">동</label>
                                <select class="form-select" id="filterDongNo">
                                    <option value="">전체</option>
                                    <option value="_COMMON_">공용 위치</option>
                                </select>
                            </div>
                            <div class="form-field filter-facility-only">
                                <label class="field-label">위치</label>
                                <select class="form-select" id="filterLocCn" disabled>
                                    <option value="">전체</option>
                                </select>
                            </div>
                            <div class="form-field filter-facility-only">
                                <label class="field-label">예약여부</label>
                                <select class="form-select" id="filterRsvYn">
                                    <option value="">전체</option>
                                    <option value="Y">예약제</option>
                                    <option value="N">자유이용</option>
                                </select>
                            </div>
                            <div class="form-field filter-facility-only">
                                <label class="field-label">운영현황</label>
                                <select class="form-select" id="filterOperStatus">
                                    <option value="">전체</option>
                                    <option value="UNREGISTERED">운영미등록</option>
                                    <option value="NORMAL">정상</option>
                                    <option value="REPAIR_PART">일부 점검중</option>
                                    <option value="CLOSE_PART">일부 사용중지</option>
                                </select>
                            </div>
                            <div class="form-field filter-facility-only">
                                <label class="field-label">수정일</label>
                                <input type="date" class="form-input" id="filterMdfDt">
                            </div>
                            <div class="form-field filter-facility-only">
                                <label class="field-label">편의시설 검색</label>
                                <div class="search-auto-wrap">
                                    <div class="search-wrap">
                                        <span class="material-symbols-rounded">search</span>
                                        <input type="text" class="form-input" id="filterFacilityKeyword" placeholder="편의시설명 또는 편의시설번호 검색" autocomplete="off">
                                    </div>
                                    <div class="facility-suggest-box" id="facilitySuggestBox"></div>
                                </div>
                            </div>

                            <%-- 자원 탭 필터 --%>
                            <div class="form-field filter-item-only">
                                <label class="field-label">편의시설 번호</label>
                                <div class="search-auto-wrap" style="position:relative;">
                                    <div style="display:flex;align-items:center;border:1px solid var(--line);border-radius:4px;background:#fff;overflow:hidden;">
                                        <span style="display:flex;align-items:center;height:32px;padding:0 8px;font-size:12px;font-weight:700;color:var(--accent);background:var(--accent-light);border-right:1px solid var(--line);white-space:nowrap;flex-shrink:0;">CMN</span>
                                        <input type="text" class="form-input" id="filterItemCmnFacilityNo" placeholder="번호 입력" autocomplete="off"
                                               style="border:none;outline:none;box-shadow:none;flex:1;min-width:0;height:32px;padding:0 8px;">
                                    </div>
                                    <div class="facility-suggest-box" id="facilityNoSuggestBox"></div>
                                </div>
                            </div>
                            <div class="form-field filter-item-only">
                                <label class="field-label">자원번호</label>
                                <div class="search-auto-wrap" style="position:relative;">
                                    <div style="display:flex;align-items:center;border:1px solid var(--line);border-radius:4px;background:#fff;overflow:hidden;">
                                        <span style="display:flex;align-items:center;height:32px;padding:0 8px;font-size:12px;font-weight:700;color:var(--accent);background:var(--accent-light);border-right:1px solid var(--line);white-space:nowrap;flex-shrink:0;">ITEM</span>
                                        <input type="text" class="form-input" id="filterItemNo" placeholder="번호 입력" autocomplete="off"
                                               style="border:none;outline:none;box-shadow:none;flex:1;min-width:0;height:32px;padding:0 8px;">
                                    </div>
                                    <div class="facility-suggest-box" id="itemNoSuggestBox"></div>
                                </div>
                            </div>
                            <div class="form-field filter-item-only">
                                <label class="field-label">자원상태</label>
                                <select class="form-select" id="filterItemSttsCd">
                                    <option value="">전체</option>
                                    <option value="OPEN">사용가능</option>
                                    <option value="USE">사용중</option>
                                    <option value="REPAIR">점검중</option>
                                    <option value="CLOSE">사용중지</option>
                                </select>
                            </div>
                            <div class="form-field filter-item-only">
                                <label class="field-label">자원명</label>
                                <div class="search-auto-wrap" style="position:relative;">
                                    <div class="search-wrap">
                                        <span class="material-symbols-rounded">search</span>
                                        <input type="text" class="form-input" id="filterItemKeyword" placeholder="자원명 검색" autocomplete="off">
                                    </div>
                                    <div class="facility-suggest-box" id="itemNmSuggestBox"></div>
                                </div>
                            </div>

                            <div class="form-field filter-action-field">
                                <label class="field-label">&nbsp;</label>
                                <div class="page-actions public-filter-actions">
                                    <button type="button" class="btn btn-secondary btn-sm" id="resetBtn">초기화</button>
                                    <button type="button" class="btn btn-primary btn-sm" id="searchBtn">검색</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="panel">
                    <div class="panel-header">
                        <div class="list-header-left">
                            <h3 class="panel-title" id="listTitle"><span class="material-symbols-rounded">meeting_room</span>편의시설 목록</h3>
                            <span class="list-count" id="listCount">0건</span>
                            <span class="result-desc" id="resultDesc">전체 조건</span>
                        </div>
                        <div class="list-header-right">
                            <button type="button" class="btn btn-secondary btn-sm" id="excelDownloadBtn">
                                <span class="material-symbols-rounded">download</span>엑셀 다운로드
                            </button>
                            <sec:authorize access="!hasRole('ADMIN')">
                                <button type="button" class="btn btn-primary btn-sm" id="registerBtn">
                                    <span class="material-symbols-rounded">add</span><span id="registerBtnText">편의시설 등록</span>
                                </button>
                            </sec:authorize>
                        </div>
                    </div>

                    <div class="summary-strip">
                        <div class="summary-chips">
                            <span class="summary-chip">전체 <strong id="chipTotal">0</strong></span>
                            <span class="summary-chip" id="chipSecondWrap">예약가능 <strong id="chipSecond">0</strong></span>
                            <span class="summary-chip" id="chipThirdWrap">일부점검 <strong id="chipThird">0</strong></span>
                        </div>
                        <span class="summary-note" id="summaryNote">편의시설 기본정보를 조회합니다.</span>
                    </div>

                    <div class="public-grid-wrap">
                        <div id="publicFacilityGrid" class="ag-theme-alpine"></div>
                    </div>

                    <div class="info-line" id="infoLine">
                        <span class="material-symbols-rounded">info</span>
                        편의시설 시설자산과 연결되고, 편의시설 자원은 하위 자원으로 관리됩니다.
                    </div>
                </div>

            </div>

            <script>
                (function () {
                    var page = document.getElementById("publicFacilityPage");
                    if (!page || page.dataset.bound === "true") return;
                    page.dataset.bound = "true";

                    var config = window.publicFacilityPageConfig || {};
                    var contextPath = config.contextPath || "";
                    var mgmtOfcNo = config.mgmtOfcNo || "";
                    var currentViewType = "PUBLIC_FACILITY";
                    var rowDataAll = [];
                    var publicFacilityGrid = null;
                    var STORAGE_KEY = "publicFacilityListState:" + mgmtOfcNo;
                    var restoreState = null;


                    function el(id) { return document.getElementById(id); }
                    function text(value) { return value == null ? "" : String(value); }
                    function alertMessage(msg, icon) {
                        if (typeof showAlert === "function") return showAlert(msg, icon);
                        alert(msg);
                        return Promise.resolve();
                    }

                    function getCsrfHeaders() {
                        var tokenMeta = document.querySelector('meta[name="_csrf"]');
                        var headerMeta = document.querySelector('meta[name="_csrf_header"]');
                        var headers = {};
                        if (tokenMeta && headerMeta) headers[headerMeta.content] = tokenMeta.content;
                        return headers;
                    }

                    async function getJson(url) {
                        var response = await fetch(url, { method:"GET", headers:getCsrfHeaders() });
                        if (response.redirected || response.url.indexOf("/login.do") !== -1) {
                            alertMessage("로그인이 필요합니다.");
                            location.href = contextPath + "/login.do";
                            throw new Error("login required");
                        }
                        var textBody = await response.text();
                        var data = null;
                        try {
                            data = textBody ? JSON.parse(textBody) : {};
                        } catch (e) {
                            console.error("JSON이 아닌 응답:", textBody);
                            throw new Error("서버 응답 형식이 올바르지 않습니다.");
                        }
                        if (!response.ok || data.success === false) {
                            throw new Error(data.message || "조회 중 오류가 발생했습니다.");
                        }
                        return data;
                    }

                    async function postJson(url, body) {
                        var headers = getCsrfHeaders();
                        headers["Content-Type"] = "application/json";
                        var response = await fetch(url, {
                            method:"POST",
                            headers:headers,
                            body:JSON.stringify(body || {})
                        });
                        var textBody = await response.text();
                        var data = null;
                        try {
                            data = textBody ? JSON.parse(textBody) : {};
                        } catch (e) {
                            console.error("JSON이 아닌 응답:", textBody);
                            throw new Error("서버 처리 중 오류가 발생했습니다. 서버 로그를 확인하세요.");
                        }
                        if (!response.ok || data.success === false) {
                            throw new Error(data.message || "처리 중 오류가 발생했습니다.");
                        }
                        return data;
                    }

                    function pageUrl(path) { return contextPath + "/manager/publicFacility/" + path; }
                    function getOperationHour(row) { return text(row.cmnFacilityOprHr || row.oprHr); }
                    function getDongText(row) { return text(row.dongNm || row.dongName || row.dongNo || row.buildingNm || row.buildingNo); }
                    function getLocationText(row) { return text(row.locCn || row.locationCn || row.facilityLocCn); }


                    function normalizeOperationText(value) {
                        return text(value).replace(/\s+/g, "").replace(/-/g, "~");
                    }



                    function getOperationStatus(row) {
                        if (!row.cmnFacilityNo) return "UNREGISTERED";
                        var directStatus = row.operStatus || row.operationStatus || row.operStatusCd || row.operationStatusCd;
                        var repairCount = Number(row.repairCnt || row.repairItemCnt || row.itemRepairCnt || 0);
                        var closeCount = Number(row.closeCnt || row.closeItemCnt || row.itemCloseCnt || 0);
                        if (directStatus) return directStatus;
                        if (closeCount > 0) return "CLOSE_PART";
                        if (repairCount > 0) return "REPAIR_PART";
                        return "NORMAL";
                    }

                    /* 편의시설명 조회 함수 */
                    function getFacilityName(row) { return text((row || {}).cmnFacilityNm); }

                    /* 시설유형 표시값 조회 함수 */
                    function getFacilityTypeText(row) { return text((row || {}).facilityTyNm || (row || {}).facilityTyCd); }

                    function buildOperationDayText(dayType, startDay, endDay) {
                        if (!dayType) return "";
                        if (dayType === "DAILY") return "매일";
                        if (dayType === "WEEKDAY") return "평일";
                        if (dayType === "WEEKEND") return "주말";
                        if (!startDay || !endDay) return "";
                        if (startDay === "월" && endDay === "일") return "매일";
                        if (startDay === "월" && endDay === "금") return "평일";
                        if (startDay === "토" && endDay === "일") return "주말";
                        if (startDay === endDay) return startDay;
                        return startDay + "~" + endDay;
                    }

                    function updateFilterOperationDayTypeView() {
                        el("filterCustomDayRow").classList.toggle("is-active", el("filterOperDayType").value === "CUSTOM");
                    }

                    function contains(value, keyword) {
                        if (!keyword) return true;
                        return text(value).toLowerCase().indexOf(keyword.toLowerCase()) > -1;
                    }

                    function getUniqueOptionRows(list, valueGetter, labelGetter) {
                        var used = {};
                        var result = [];
                        (list || []).forEach(function (row) {
                            var value = text(valueGetter(row)).trim();
                            var label = text(labelGetter(row)).trim();
                            if (!value || used[value]) return;
                            used[value] = true;
                            result.push({ value:value, label:label || value });
                        });
                        return result.sort(function (a, b) { return a.label.localeCompare(b.label, "ko"); });
                    }

                    function setSelectOptions(selectId, options, firstLabel) {
                        var select = el(selectId);
                        select.innerHTML = '<option value="">' + (firstLabel || "전체") + '</option>';
                        options.forEach(function (option) {
                            var opt = document.createElement("option");
                            opt.value = option.value;
                            opt.textContent = option.label;
                            select.appendChild(opt);
                        });
                    }

                    function refreshDongOptions() {
                        var dongOptions = getUniqueOptionRows(rowDataAll, function (row) {
                            return row.dongNo;
                        }, function (row) {
                            return getDongText(row);
                        });
                        setSelectOptions("filterDongNo", dongOptions, "전체");
                        var commonOption = document.createElement("option");
                        commonOption.value = "_COMMON_";
                        commonOption.textContent = "공용 위치";
                        el("filterDongNo").appendChild(commonOption);
                    }

                    function refreshFacilityTypeOptions() {
                        var typeOptions = getUniqueOptionRows(rowDataAll, function (row) {
                            return row.facilityTyCd;
                        }, getFacilityTypeText);
                        setSelectOptions("filterFacilityTyCd", typeOptions, "전체");
                    }

                    function refreshLocationOptions() {
                        var dongNo = el("filterDongNo").value;
                        var locationRows = rowDataAll.filter(function (row) {
                            var rowDongNo = text(row.dongNo);
                            if (!dongNo) return true;
                            if (dongNo === "_COMMON_") return !rowDongNo;
                            return rowDongNo === dongNo;
                        });
                        var locationOptions = getUniqueOptionRows(locationRows, getLocationText, getLocationText);
                        setSelectOptions("filterLocCn", locationOptions, "전체");
                        el("filterLocCn").disabled = locationOptions.length === 0;
                    }

                    function refreshFacilityFilterOptions() {
                        refreshDongOptions();
                        refreshFacilityTypeOptions();
                        refreshLocationOptions();
                    }

                    function hideFacilitySuggest() {
                        el("facilitySuggestBox").innerHTML = "";
                        el("facilitySuggestBox").style.display = "none";
                    }

                    function escapeHtml(value) {
                        return text(value)
                            .replace(/&/g, "&amp;")
                            .replace(/</g, "&lt;")
                            .replace(/>/g, "&gt;")
                            .replace(/"/g, "&quot;");
                    }

                    function showFacilitySuggest() {
                        var keyword = text(el("filterFacilityKeyword").value).trim().toLowerCase();
                        var box = el("facilitySuggestBox");
                        var used = {};
                        var list = [];

                        if (!keyword) { hideFacilitySuggest(); return; }

                        /* 편의시설명 / 편의시설번호 자동완성 목록 구성 */
                        rowDataAll.forEach(function (row) {
                            var cmnFacilityNo = text(row.cmnFacilityNo).trim();
                            var cmnFacilityNm = text(row.cmnFacilityNm).trim();
                            var noMatched = cmnFacilityNo.toLowerCase().indexOf(keyword) > -1;
                            var nameMatched = cmnFacilityNm.toLowerCase().indexOf(keyword) > -1;
                            var key = cmnFacilityNo || cmnFacilityNm;

                            if (!key || used[key]) return;
                            if (!noMatched && !nameMatched) return;

                            used[key] = true;
                            list.push({ cmnFacilityNo:cmnFacilityNo, cmnFacilityNm:cmnFacilityNm });
                        });

                        list = list.slice(0, 10);

                        if (list.length === 0) { hideFacilitySuggest(); return; }

                        box.innerHTML = list.map(function (item) {
                            var main = item.cmnFacilityNm || "-";
                            var sub = item.cmnFacilityNo || "";
                            return '<button type="button" class="facility-suggest-item" data-name="' + escapeHtml(main) + '" data-no="' + escapeHtml(sub) + '">'
                                + '<span style="font-weight:700;">' + escapeHtml(main) + '</span>'
                                + (sub ? '<span style="font-size:11px;color:#8a9a8e;margin-left:8px;">' + escapeHtml(sub) + '</span>' : '')
                                + '</button>';
                        }).join("");
                        box.style.display = "block";
                    }

                    function selectFacilitySuggest(event) {
                        var item = event.target.closest(".facility-suggest-item");
                        if (!item) return;

                        /* 편의시설번호가 있으면 번호 기준으로 검색창 반영 */
                        el("filterFacilityKeyword").value = item.dataset.no || item.dataset.name || "";
                        hideFacilitySuggest();
                        searchList();
                    }

                    function isOperationDayMatched(operationHour, filterDay) {
                        var hourText = normalizeOperationText(operationHour);
                        var filterText = normalizeOperationText(filterDay);
                        var dayOrder = ["월", "화", "수", "목", "금", "토", "일"];
                        var dayIndex = dayOrder.indexOf(filterText);
                        if (!filterText) return true;
                        if (!hourText) return false;
                        if (hourText.indexOf(filterText) > -1) return true;
                        if (filterText === "매일") return hourText.indexOf("매일") > -1;
                        if (filterText === "평일") return hourText.indexOf("평일") > -1 || hourText.indexOf("월~금") > -1;
                        if (filterText === "주말") return hourText.indexOf("주말") > -1 || hourText.indexOf("토~일") > -1;
                        if (filterText === "휴무") return hourText.indexOf("휴무") > -1;
                        if (dayIndex >= 0) {
                            if (hourText.indexOf("매일") > -1) return true;
                            if (hourText.indexOf("평일") > -1 && dayIndex <= 4) return true;
                            if (hourText.indexOf("주말") > -1 && dayIndex >= 5) return true;
                        }
                        for (var i = 0; i < dayOrder.length; i++) {
                            for (var j = i; j < dayOrder.length; j++) {
                                var rangeText = dayOrder[i] + "~" + dayOrder[j];
                                var hasRange = hourText.indexOf(rangeText) > -1;
                                if (hasRange && dayIndex >= i && dayIndex <= j) return true;
                            }
                        }
                        return false;
                    }

                    /**
                     * 시간 필터값 정규화
                     * - input type=time 값: 00:00, 12:00
                     * - 기존 저장값 보정: 오전 12:00 -> 00:00
                     * - 기존 저장값 보정: 오후 12:00 -> 12:00
                     */
                    function normalizeTimeForFilter(value) {
                        var raw = text(value).trim();
                        var match;
                        var ampm;
                        var hour;
                        var minute;

                        if (!raw) return "";

                        match = raw.match(/(오전|오후)?\s*([0-2]?\d):([0-5]\d)/);
                        if (!match) return "";

                        ampm = match[1] || "";
                        hour = Number(match[2]);
                        minute = match[3];

                        if (ampm === "오전" && hour === 12) hour = 0;
                        if (ampm === "오후" && hour < 12) hour += 12;

                        return String(hour).padStart(2, "0") + ":" + minute;
                    }

                    /**
                     * 시간 분 단위 변환
                     * - 00:00 -> 0
                     * - 12:00 -> 720
                     * - 비교 기준 단일화
                     */
                    function timeToMinutes(value) {
                        var timeValue = normalizeTimeForFilter(value);
                        var parts;

                        if (!timeValue) return null;

                        parts = timeValue.split(":");
                        return Number(parts[0]) * 60 + Number(parts[1]);
                    }

                    /**
                     * 운영시간 범위 추출
                     * - 신규 저장값: 매일 00:00~18:00
                     * - 기존 저장값: 매일 오전 11:34~오후 12:00
                     */
                    function getOperationTimeRange(operationHour) {
                        var matches = text(operationHour).match(/(오전|오후)?\s*[0-2]?\d:[0-5]\d/g) || [];

                        return {
                            start:normalizeTimeForFilter(matches[0] || ""),
                            end:normalizeTimeForFilter(matches[1] || "")
                        };
                    }

                    /**
                     * 운영시간 필터 일치 여부
                     * - 시작시간 조건: 운영 시작시간이 필터 시작시간 이상
                     * - 종료시간 조건: 운영 종료시간이 필터 종료시간 이하
                     * - 오전 12시와 오후 12시 구분
                     */
                    function isOperationTimeMatched(operationHour, filterStartTime, filterEndTime) {
                        var range;
                        var rowStartMinute;
                        var rowEndMinute;
                        var filterStartMinute;
                        var filterEndMinute;

                        if (!filterStartTime && !filterEndTime) return true;

                        range = getOperationTimeRange(operationHour);
                        rowStartMinute = timeToMinutes(range.start);
                        rowEndMinute = timeToMinutes(range.end);
                        filterStartMinute = timeToMinutes(filterStartTime);
                        filterEndMinute = timeToMinutes(filterEndTime);

                        if (filterStartMinute != null && rowStartMinute == null) return false;
                        if (filterEndMinute != null && rowEndMinute == null) return false;
                        if (filterStartMinute != null && rowStartMinute < filterStartMinute) return false;
                        if (filterEndMinute != null && rowEndMinute > filterEndMinute) return false;

                        return true;
                    }

                    function normalizeDate(value) { return text(value).replace(/\./g, "-").substring(0, 10); }
                    function getItemCount(row) { return Number((row || {}).itemCnt || 0); }

                    function isItemCountMatched(itemCnt, itemCntType) {
                        if (!itemCntType) return true;
                        if (itemCntType === "ZERO") return itemCnt === 0;
                        if (itemCntType === "ONE_MORE") return itemCnt >= 1;
                        if (itemCntType === "FIVE_MORE") return itemCnt >= 5;
                        if (itemCntType === "TEN_MORE") return itemCnt >= 10;
                        return true;
                    }

                    function getFacilityFilterValue() {
                        return {
                            keyword:text(el("filterFacilityKeyword").value).trim(),
                            dongNo:el("filterDongNo").value,
                            facilityTyCd:el("filterFacilityTyCd").value,
                            locCn:el("filterLocCn").value,
                            rsvYn:el("filterRsvYn").value,
                            operStatus:el("filterOperStatus").value,
                            mdfDt:el("filterMdfDt").value
                        };
                    }

                    function getItemFilterValue() {
                        var itemNo = text(el("filterItemNo").value).trim();
                        var facilityNo = text(el("filterItemCmnFacilityNo").value).trim();
                        return {
                            cmnFacilityItemNo:itemNo ? "ITEM" + itemNo : "",
                            cmnFacilityNo:facilityNo ? "CMN" + facilityNo : "",
                            sttsCd:el("filterItemSttsCd").value,
                            keyword:text(el("filterItemKeyword").value).trim()
                        };
                    }

                    function getCurrentPageNo() {
                        if (!publicFacilityGrid || typeof publicFacilityGrid.getCurrentPage !== "function") return 0;
                        return publicFacilityGrid.getCurrentPage();
                    }

                    function saveListState() {
                        var state = {
                            viewType:currentViewType,
                            facilityFilter:getFacilityFilterValue(),
                            itemFilter:getItemFilterValue(),
                            pageNo:getCurrentPageNo()
                        };
                        sessionStorage.setItem(STORAGE_KEY, JSON.stringify(state));
                    }

                    /**
                     * 목록 상태 조회
                     * - 상세/수정/등록 화면 복귀 시 복원 대상 상태
                     * - 메뉴 재진입 시 canRestoreListState()에서 제거 대상 상태
                     */
                    function loadListState() {
                        var raw = sessionStorage.getItem(STORAGE_KEY);
                        if (!raw) return null;
                        try { return JSON.parse(raw); } catch (e) { sessionStorage.removeItem(STORAGE_KEY); return null; }
                    }

                    /**
                     * 목록 상태 복원 기준
                     * - 편의시설 상세 화면 복귀
                     * - 편의시설 수정 화면 복귀
                     * - 편의시설 등록 화면 복귀
                     * - 그 외 사이드바/상단메뉴/다른 화면 재진입은 첫 번째 탭 초기 진입
                     */
                    function canRestoreListState() {
                        var referrer = document.referrer || "";

                        /*
                         * 페이지 이동 복원 대상
                         * - 상세/수정/등록 화면에서 목록으로 돌아온 경우
                         */
                        var fromDetailPage = referrer.indexOf("/manager/publicFacility/detail-page/") > -1;
                        var fromUpdatePage = referrer.indexOf("/manager/publicFacility/update-page/") > -1;
                        var fromRegisterPage = referrer.indexOf("/manager/publicFacility/register/") > -1;

                        /*
                         * 모달 저장 후 새로고침 복원 대상
                         * - 자원 탭에서 상세/수정 모달 저장 후 location.reload() 된 경우
                         */
                        var fromModalRefresh = sessionStorage.getItem("publicFacilityModalRefresh") === "Y";

                        return fromDetailPage || fromUpdatePage || fromRegisterPage || fromModalRefresh;
                    }

                    function restoreFacilityFilters(filter) {
                        if (!filter) return;
                        el("filterFacilityKeyword").value = filter.keyword || "";
                        el("filterDongNo").value = filter.dongNo || "";
                        el("filterFacilityTyCd").value = filter.facilityTyCd || "";
                        refreshLocationOptions();
                        el("filterLocCn").value = filter.locCn || "";
                        el("filterRsvYn").value = filter.rsvYn || "";
                        el("filterOperStatus").value = filter.operStatus || "";
                        el("filterMdfDt").value = filter.mdfDt || "";
                    }

                    function restoreItemFilters(filter) {
                        if (!filter) return;
                        el("filterItemNo").value = filter.cmnFacilityItemNo ? filter.cmnFacilityItemNo.replace(/^ITEM/, "") : "";
                        el("filterItemCmnFacilityNo").value = filter.cmnFacilityNo ? filter.cmnFacilityNo.replace(/^CMN/, "") : "";
                        el("filterItemSttsCd").value = filter.sttsCd || "";
                        el("filterItemKeyword").value = filter.keyword || "";
                    }

                    function getFilteredFacilityRows() {
                        var f = getFacilityFilterValue();
                        return rowDataAll.filter(function (row) {
                            var locationText = getLocationText(row);
                            var operationStatus = getOperationStatus(row);
                            var mdfDate = normalizeDate(row.mdfDt);

                            /* 편의시설명 / 편의시설번호 검색 조건 */
                            var keywordOk = !f.keyword
                                || contains(row.cmnFacilityNm, f.keyword)
                                || contains(row.cmnFacilityNo, f.keyword);
                            var rowDongNo = text(row.dongNo);
                            var dongOk = !f.dongNo || (f.dongNo === "_COMMON_" && !rowDongNo) || rowDongNo === f.dongNo;
                            var facilityTyOk = !f.facilityTyCd || row.facilityTyCd === f.facilityTyCd;
                            var locationOk = !f.locCn || locationText === f.locCn;
                            var rsvOk = !f.rsvYn || row.cmnFacilityRsvYn === f.rsvYn || row.rsvYn === f.rsvYn;
                            var operStatusOk = !f.operStatus || operationStatus === f.operStatus;
                            var mdfDateOk = !f.mdfDt || mdfDate === f.mdfDt;

                            return keywordOk && dongOk && facilityTyOk && locationOk && rsvOk && operStatusOk && mdfDateOk;
                        });
                    }

                    function getFilteredItemRows() {
                        var f = getItemFilterValue();
                        return rowDataAll.filter(function (row) {
                            var itemNoOk = !f.cmnFacilityItemNo || contains(row.cmnFacilityItemNo, f.cmnFacilityItemNo);
                            var facilityNoOk = !f.cmnFacilityNo || contains(row.cmnFacilityNo, f.cmnFacilityNo);
                            var sttsOk = !f.sttsCd || row.cmnFacilitySttsCd === f.sttsCd;
                            var keywordOk = !f.keyword || contains(row.itemNm, f.keyword) || contains(row.cmnFacilityNm, f.keyword);
                            return itemNoOk && facilityNoOk && sttsOk && keywordOk;
                        });
                    }

                    function getFilteredRows() { return currentViewType === "PUBLIC_ITEM" ? getFilteredItemRows() : getFilteredFacilityRows(); }

                    function updateSummary(list) {
                        el("chipTotal").textContent = list.length;
                        el("listCount").textContent = list.length + "건";
                        el("resultDesc").textContent = list.length === rowDataAll.length ? "전체 조건" : "검색 조건 적용";
                        if (currentViewType === "PUBLIC_ITEM") {
                            var openCount = list.filter(function (row) { return row.cmnFacilitySttsCd === "OPEN"; }).length;
                            var repairCount = list.filter(function (row) { return row.cmnFacilitySttsCd === "REPAIR"; }).length;
                            el("chipSecondWrap").childNodes[0].nodeValue = "사용가능 ";
                            el("chipThirdWrap").childNodes[0].nodeValue = "점검중 ";
                            el("chipSecond").textContent = openCount;
                            el("chipThird").textContent = repairCount;
                            el("summaryNote").textContent = "편의시설별 등록된 자원 현황을 조회합니다";
                        } else {
                            var rsvCount = list.filter(function (row) { return row.cmnFacilityRsvYn === "Y" || row.rsvYn === "Y"; }).length;
                            var repairFacilityCount = list.filter(function (row) { return getOperationStatus(row) === "REPAIR_PART"; }).length;
                            el("chipSecondWrap").childNodes[0].nodeValue = "예약제 ";
                            el("chipThirdWrap").childNodes[0].nodeValue = "일부점검 ";
                            el("chipSecond").textContent = rsvCount;
                            el("chipThird").textContent = repairFacilityCount;
                            el("summaryNote").textContent = "단지 내 편의시설 운영 정보를 조회합니다.";
                        }
                    }

                    function setGridRows(list) { publicFacilityGrid.setRows(list); updateSummary(list); }
                    function searchList() { setGridRows(getFilteredRows()); saveListState(); }

                    function resetFacilityFilters() {
                        el("filterFacilityKeyword").value = "";
                        el("filterDongNo").value = "";
                        el("filterFacilityTyCd").value = "";
                        el("filterLocCn").value = "";
                        el("filterRsvYn").value = "";
                        el("filterOperStatus").value = "";
                        el("filterMdfDt").value = "";
                        hideFacilitySuggest();
                        refreshLocationOptions();
                    }

                    function resetItemFilters() {
                        el("filterItemNo").value = "";
                        el("filterItemCmnFacilityNo").value = "";
                        el("filterItemSttsCd").value = "";
                        el("filterItemKeyword").value = "";
                    }

                    function resetSearch() {
                        sessionStorage.removeItem(STORAGE_KEY);
                        if (currentViewType === "PUBLIC_ITEM") resetItemFilters();
                        else resetFacilityFilters();
                        setGridRows(rowDataAll);
                    }

                    function moveRegister() {
                        saveListState();
                        if (currentViewType === "PUBLIC_ITEM") {
                            if (!window.PublicFacilityItemModal) { alertMessage("자원 등록 모달을 불러오지 못했습니다."); return; }
                            PublicFacilityItemModal.init({ contextPath:contextPath, mgmtOfcNo:mgmtOfcNo, cmnFacilityNo:null, isAdmin:config.isAdmin });
                            PublicFacilityItemModal.open("insert");
                            return;
                        }
                        location.href = pageUrl("register/" + encodeURIComponent(mgmtOfcNo));
                    }

                    function moveFacilityDetail(no) { saveListState(); location.href = pageUrl("detail-page/" + encodeURIComponent(mgmtOfcNo) + "/" + encodeURIComponent(no)); }
                    function moveFacilityUpdate(no) { saveListState(); location.href = pageUrl("update-page/" + encodeURIComponent(mgmtOfcNo) + "/" + encodeURIComponent(no)); }
                    function moveFacilityRegister(row) {
                        saveListState();
                        var facilityNo = row && row.facilityNo ? row.facilityNo : "";
                        location.href = pageUrl("register/" + encodeURIComponent(mgmtOfcNo) + "?facilityNo=" + encodeURIComponent(facilityNo));
                    }

                    function moveItemDetail(no, row) {
                        saveListState();
                        var facilityNo = row && row.cmnFacilityNo ? row.cmnFacilityNo : "";
                        if (!facilityNo) { alertMessage("상위 편의시설 번호가 없습니다."); return; }
                        if (window.PublicFacilityItemModal) {
                            PublicFacilityItemModal.init({ contextPath:contextPath, mgmtOfcNo:mgmtOfcNo, cmnFacilityNo:facilityNo, isAdmin:config.isAdmin });
                            PublicFacilityItemModal.open("detail", no);
                        }
                    }

                    function moveItemUpdate(no, row) {
                        saveListState();
                        var facilityNo = row && row.cmnFacilityNo ? row.cmnFacilityNo : "";
                        if (!facilityNo) { alertMessage("상위 편의시설 번호가 없습니다."); return; }
                        if (window.PublicFacilityItemModal) {
                            PublicFacilityItemModal.init({ contextPath:contextPath, mgmtOfcNo:mgmtOfcNo, cmnFacilityNo:facilityNo, isAdmin:config.isAdmin });
                            PublicFacilityItemModal.open("update", no);
                        }
                    }

                    async function deleteFacility(cmnFacilityNo) {
                        var deleteConfirm = await showConfirm({
                            title: "해당 편의시설을 삭제하시겠습니까?",
                            text: "예약이력이 있는 경우 삭제되지 않습니다.",
                            confirmText: "삭제",
                            confirmColor: "#c0392b"
                        });
                        if (!deleteConfirm.isConfirmed) return;
                        try {
                            await postJson(contextPath + "/manager/publicFacility/delete/" + encodeURIComponent(mgmtOfcNo), { cmnFacilityNo:cmnFacilityNo });
                            await alertMessage("삭제되었습니다.", "success");
                            loadList();
                        } catch (e) { console.error(e); alertMessage(e.message || "삭제 중 오류가 발생했습니다."); }
                    }

                    async function deleteItem(cmnFacilityItemNo) {
                        var itemDeleteConfirm = await showConfirm({
                            title: "해당 편의시설 자원을 삭제하시겠습니까?",
                            confirmText: "삭제",
                            confirmColor: "#c0392b"
                        });
                        if (!itemDeleteConfirm.isConfirmed) return;
                        try {
                            await postJson(contextPath + "/manager/publicFacility/item/delete/" + encodeURIComponent(mgmtOfcNo), { cmnFacilityItemNo:cmnFacilityItemNo });
                            await alertMessage("삭제되었습니다.", "success");
                            loadList();
                        } catch (e) { console.error(e); alertMessage(e.message || "삭제 중 오류가 발생했습니다."); }
                    }

                    function exportExcel() {
                        var fileName = currentViewType === "PUBLIC_ITEM" ? "편의시설자원_목록.csv" : "편의시설공용_목록.csv";
                        publicFacilityGrid.exportCsv(fileName);
                    }

                    function updateTabUi() {
                        var isItem = currentViewType === "PUBLIC_ITEM";
                        page.classList.toggle("is-item-tab", isItem);
                        el("tabPublicFacility").classList.toggle("active", !isItem);
                        el("tabPublicItem").classList.toggle("active", isItem);
                        el("listTitle").innerHTML = isItem
                            ? '<span class="material-symbols-rounded">inventory_2</span>편의시설 자원 목록'
                            : '<span class="material-symbols-rounded">meeting_room</span>편의시설 목록';
                        if (el("registerBtnText")) {
                            el("registerBtnText").textContent = isItem ? "자원 등록" : "편의시설 등록";
                        }
                        el("infoLine").innerHTML = isItem
                            ? '<span class="material-symbols-rounded">info</span>편의시설 자원은 편의시설번호 기준으로 연결됩니다.'
                            : '<span class="material-symbols-rounded">info</span>편의시설은 운영관리 정보와 하위 자원을 함께 관리합니다.';
                    }

                    function switchTab(viewType) {
                        if (currentViewType === viewType) return;
                        currentViewType = viewType;
                        resetFacilityFilters();
                        resetItemFilters();
                        updateTabUi();
                        publicFacilityGrid.changeView(currentViewType);
                        saveListState();
                        loadList();
                    }

                    async function loadList() {
                        var url = contextPath + "/manager/publicFacility/grid-list/" + encodeURIComponent(mgmtOfcNo)
                            + "?viewType=" + encodeURIComponent(currentViewType);
                        try {
                            var result = await getJson(url);
                            rowDataAll = result.list || [];
                            if (currentViewType === "PUBLIC_FACILITY") { refreshFacilityFilterOptions(); }
                            if (restoreState) {
                                if (restoreState.viewType === "PUBLIC_ITEM") { restoreItemFilters(restoreState.itemFilter); }
                                else { restoreFacilityFilters(restoreState.facilityFilter); }
                                setGridRows(getFilteredRows());
                                if (publicFacilityGrid && typeof publicFacilityGrid.goToPage === "function" && restoreState.pageNo != null) {
                                    publicFacilityGrid.goToPage(restoreState.pageNo);
                                }
                                restoreState = null;
                                return;
                            }
                            setGridRows(rowDataAll);
                        } catch (e) {
                            console.error(e);
                            alertMessage(e.message || "목록 조회 중 오류가 발생했습니다.");
                            rowDataAll = [];
                            if (currentViewType === "PUBLIC_FACILITY") { refreshFacilityFilterOptions(); }
                            setGridRows(rowDataAll);
                        }
                    }

                    function bindEvents() {
                        el("tabPublicFacility").addEventListener("click", function () { switchTab("PUBLIC_FACILITY"); });
                        el("tabPublicItem").addEventListener("click", function () { switchTab("PUBLIC_ITEM"); });
                        if (el("registerBtn")) el("registerBtn").addEventListener("click", moveRegister);
                        el("excelDownloadBtn").addEventListener("click", exportExcel);
                        el("searchBtn").addEventListener("click", searchList);
                        el("resetBtn").addEventListener("click", resetSearch);
                        el("filterFacilityKeyword").addEventListener("input", showFacilitySuggest);
                        el("filterFacilityKeyword").addEventListener("keyup", function (e) { if (e.key === "Enter") searchList(); });
                        el("facilitySuggestBox").addEventListener("click", selectFacilitySuggest);
                        el("filterDongNo").addEventListener("change", function () { refreshLocationOptions(); searchList(); });
                        el("filterFacilityTyCd").addEventListener("change", searchList);
                        el("filterLocCn").addEventListener("change", searchList);
                        el("filterRsvYn").addEventListener("change", searchList);
                        el("filterOperStatus").addEventListener("change", searchList);
                        el("filterMdfDt").addEventListener("change", searchList);
                        el("filterItemKeyword").addEventListener("keyup", function (e) { if (e.key === "Enter") searchList(); });
                        el("filterItemNo").addEventListener("keyup", function (e) { if (e.key === "Enter") searchList(); });
                        el("filterItemCmnFacilityNo").addEventListener("keyup", function (e) { if (e.key === "Enter") searchList(); });
                        el("filterItemSttsCd").addEventListener("change", searchList);
                        bindItemSuggestEvents();
                        document.addEventListener("click", function (event) {
                            if (!event.target.closest(".search-auto-wrap")) hideFacilitySuggest();
                        });
                    }

                    function bindItemSuggestEvents() {
                        var itemSuggestTimers = {};
                        function closeItemSuggestBox(boxId) {
                            var box = el(boxId);
                            if (box) { box.innerHTML = ""; box.style.display = "none"; }
                        }
                        function renderItemSuggestBox(boxId, list, suggestType, onSelect) {
                            var box = el(boxId);
                            if (!box) return;
                            if (!list.length) {
                                box.innerHTML = '<div style="padding:10px 12px;font-size:12px;color:#8a9a8e;text-align:center;">검색 결과가 없습니다.</div>';
                                box.style.display = "block";
                                return;
                            }
                            box.innerHTML = list.map(function (item) {
                                var main; var sub;
                                if (suggestType === "ITEM_NO") { main = item.cmnFacilityItemNo || ""; sub = item.itemNm || ""; }
                                else if (suggestType === "FACILITY_NO") { main = item.cmnFacilityNo || ""; sub = item.cmnFacilityNm || ""; }
                                else { main = item.itemNm || ""; sub = item.cmnFacilityNm || ""; }
                                return '<button type="button" class="facility-suggest-item"'
                                    + ' data-main="' + main.replace(/"/g, "&quot;") + '">'
                                    + '<span style="font-weight:700;">' + main + '</span>'
                                    + (sub ? '<span style="font-size:11px;color:#8a9a8e;margin-left:8px;">' + sub + '</span>' : '')
                                    + '</button>';
                            }).join("");
                            box.style.display = "block";
                            box.querySelectorAll(".facility-suggest-item").forEach(function (btn) {
                                btn.addEventListener("click", function () { onSelect(btn.getAttribute("data-main")); closeItemSuggestBox(boxId); });
                            });
                        }
                        function fetchItemSuggestWithType(suggestType, keyword, boxId, onSelect) {
                            clearTimeout(itemSuggestTimers[boxId]);
                            if (!keyword) { closeItemSuggestBox(boxId); return; }
                            itemSuggestTimers[boxId] = setTimeout(function () {
                                fetch(contextPath + "/manager/publicFacility/item/suggest/" + encodeURIComponent(mgmtOfcNo)
                                    + "?suggestType=" + encodeURIComponent(suggestType)
                                    + "&keyword=" + encodeURIComponent(keyword))
                                    .then(function (res) { return res.json(); })
                                    .then(function (data) { renderItemSuggestBox(boxId, data.list || [], suggestType, onSelect); })
                                    .catch(function () { closeItemSuggestBox(boxId); });
                            }, 200);
                        }
                        el("filterItemNo").addEventListener("input", function () {
                            fetchItemSuggestWithType("ITEM_NO", this.value.trim(), "itemNoSuggestBox", function (val) {
                                el("filterItemNo").value = val.replace(/^ITEM/, ""); searchList();
                            });
                        });
                        el("filterItemCmnFacilityNo").addEventListener("input", function () {
                            fetchItemSuggestWithType("FACILITY_NO", this.value.trim(), "facilityNoSuggestBox", function (val) {
                                el("filterItemCmnFacilityNo").value = val.replace(/^CMN/, ""); searchList();
                            });
                        });
                        el("filterItemKeyword").addEventListener("input", function () {
                            fetchItemSuggestWithType("ITEM_NM", this.value.trim(), "itemNmSuggestBox", function (val) {
                                el("filterItemKeyword").value = val; searchList();
                            });
                        });
                        document.addEventListener("click", function (e) {
                            if (!e.target.closest(".filter-item-only")) {
                                closeItemSuggestBox("itemNoSuggestBox");
                                closeItemSuggestBox("facilityNoSuggestBox");
                                closeItemSuggestBox("itemNmSuggestBox");
                            }
                        });
                    }

                    document.addEventListener("DOMContentLoaded", function () {
                        /* 저장 목록 상태 조회 */
                        restoreState = loadListState();

                        /*
                         * 복원 대상 판정
                         * - 상세/수정/등록 화면에서 돌아온 경우만 저장 탭/필터 복원
                         * - 사이드바나 다른 메뉴에서 새로 들어온 경우 저장 상태 제거
                         */
                        if (restoreState && !canRestoreListState()) {
                            sessionStorage.removeItem(STORAGE_KEY);
                            restoreState = null;
                        }

                        /*
                         * 모달 새로고침 복원 플래그 제거
                         * - 이번 진입에서만 탭 복원에 사용하고 바로 삭제
                         */
                        sessionStorage.removeItem("publicFacilityModalRefresh");

                        /*
                         * 초기 탭 결정
                         * - 복원 대상이면 저장된 탭 유지
                         * - 복원 대상이 아니면 항상 첫 번째 탭인 편의시설 탭 표시
                         */
                        currentViewType = restoreState && restoreState.viewType ? restoreState.viewType : "PUBLIC_FACILITY";

                        publicFacilityGrid = window.PublicFacilityAgGrid.create({
                            gridId:"publicFacilityGrid",
                            viewType:currentViewType,
                            isAdmin:config.isAdmin,
                            onFacilityDetail:moveFacilityDetail,
                            onFacilityEdit:moveFacilityUpdate,
                            onFacilityDelete:deleteFacility,
                            onFacilityRegister:moveFacilityRegister,
                            onItemDetail:moveItemDetail,
                            onItemEdit:moveItemUpdate,
                            onItemDelete:deleteItem
                        });

                        /* 탭 화면 상태 반영 */
                        updateTabUi();

                        /* 화면 이벤트 연결 */
                        bindEvents();

                        /* 목록 조회 */
                        loadList();
                    });
                })();
            </script>
        </main>
    </div>
</div>
<%@ include file="/WEB-INF/views/include/publicFacilityItemModal.jspf" %>
<script src="${pageContext.request.contextPath}/js/manager/facility/publicFacility/publicFacilityItemModal.js"></script>
</body>
</html>
