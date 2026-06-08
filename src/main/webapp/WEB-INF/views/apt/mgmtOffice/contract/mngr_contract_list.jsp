<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>계약 관리</title>

    <sec:csrfMetaTags/>

    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet" />

    <link rel="stylesheet" href="${ctx}/css/office-layout.css">
    <link rel="stylesheet" href="${ctx}/css/manager/manager-common.css">

    <style>
        /* ── 토큰 : 검침 이력/시설 목록 계열 색감 기준 ── */
        #contractPage {
            --accent:#2e5c38; --accent-hover:#1f4027; --accent-light:#e8f0ea;
            --surface:#fff; --surface-sub:#f8f9fb; --line:#d7dce2;
            --th-bg:#f0f2ef;
            --text-head:#1a2e1e; --text-sec:#4a5c4e; --text-ter:#8a9a8e;
            font-family:'Noto Sans KR',sans-serif;
        }

        /* ── 페이지 헤더 ── */
        #contractPage .page-title-block h2 { color:var(--text-head); font-size:19px; letter-spacing:-.5px; }
        #contractPage .page-title-block p  { color:#6b7a6e; font-size:12px; }

        /* ── 공통 버튼 ── */
        #contractPage .btn {
            display:inline-flex; align-items:center; justify-content:center; gap:4px;
            min-height:32px; height:32px; padding:0 11px;
            border-radius:4px; border:1px solid var(--line);
            background:#fff; color:#39443d;
            font-size:12px; font-weight:700;
            cursor:pointer; text-decoration:none; box-sizing:border-box;
            font-family:'Noto Sans KR',sans-serif;
        }
        #contractPage .btn:hover { background:#f4f7f4; }
        #contractPage .btn-primary { background:var(--accent); border-color:var(--accent); color:#fff; }
        #contractPage .btn-primary:hover { background:var(--accent-hover); border-color:var(--accent-hover); }
        #contractPage .btn-xs { min-height:28px; height:28px; padding:0 10px; font-size:11px; }
        #contractPage .btn .material-symbols-rounded { font-size:15px; }

        /* ── 패널 ── */
        #contractPage .panel {
            border-radius:6px; border:1px solid var(--line);
            background:#fff; margin:0 0 12px;
        }
        #contractPage .panel:last-of-type { margin-bottom:0; }
        #contractPage .panel-list { overflow:hidden; }

        #contractPage .panel-header {
            display:flex; align-items:center; justify-content:space-between;
            padding:13px 16px; border-bottom:1px solid var(--line);
            background:#fff;
        }
        #contractPage .panel-title {
            display:flex; align-items:center; gap:6px;
            margin:0; font-size:13px; font-weight:800; color:var(--text-head);
        }
        #contractPage .panel-title .material-symbols-rounded { font-size:17px; color:var(--accent); }
        #contractPage .panel-body { padding:14px 16px 16px; }

        /* ── 필터 ── */
        #contractPage .filter-grid {
            display:grid;
            /* 검색/초기화가 잘리지 않도록 입력 최소 폭은 낮추고, 버튼 영역은 실제 버튼 2개 폭보다 넉넉하게 확보한다. */
            grid-template-columns:minmax(95px,.8fr) minmax(110px,.85fr) minmax(230px,1.35fr) minmax(240px,1.45fr) minmax(280px,1.8fr) 150px;
            gap:8px 8px; align-items:end;
        }
        #contractPage .filter-grid .form-field { min-width:0; overflow:visible; }
        #contractPage .field-label {
            display:block; margin-bottom:5px;
            font-size:11px; font-weight:800; color:var(--text-sec);
        }
        #contractPage .form-select,
        #contractPage .form-input {
            height:32px; font-size:12px;
            border:1px solid var(--line); background:#fff;
            border-radius:4px; padding:0 9px;
            width:100%; box-sizing:border-box;
            font-family:'Noto Sans KR',sans-serif; color:#1f2d23;
        }
        #contractPage .form-select:focus,
        #contractPage .form-input:focus {
            border-color:var(--accent);
            box-shadow:0 0 0 2px rgba(46,92,56,.08);
            outline:none;
        }
        #contractPage .date-range-inputs {
            display:grid; grid-template-columns:minmax(0,1fr) auto minmax(0,1fr);
            align-items:center; gap:5px;
        }
        #contractPage .date-filter-sep { color:#9ca3af; font-size:12px; text-align:center; }
        #contractPage .date-range-inputs .form-input { min-width:0; }
        #contractPage .search-wrap { position:relative; }
        #contractPage .search-wrap .material-symbols-rounded {
            position:absolute; left:9px; top:50%; transform:translateY(-50%);
            font-size:15px; color:#9caa9e; pointer-events:none;
        }
        #contractPage .search-wrap input { padding-left:30px; }
        #contractPage .filter-actions { display:flex; align-items:center; justify-content:flex-end; gap:6px; width:150px; height:32px; white-space:nowrap; overflow:visible; }
        #contractPage .filter-actions .btn { flex:0 0 68px; min-width:68px; padding:0 8px; box-sizing:border-box; }

        /* ── 현황 카드 ── */
        #contractPage .contract-summary-row {
            display:grid;
            grid-template-columns:repeat(4,minmax(0,1fr));
            gap:10px;
            margin-bottom:12px;
        }
        #contractPage .contract-summary-card {
            display:flex;
            align-items:center;
            gap:12px;
            min-height:74px;
            padding:14px 16px;
            border:1px solid var(--line);
            border-radius:6px;
            background:var(--surface);
            box-sizing:border-box;
        }
        #contractPage .contract-summary-card .summary-icon {
            display:inline-flex;
            align-items:center;
            justify-content:center;
            width:36px;
            height:36px;
            border-radius:6px;
            background:var(--accent-light);
            color:var(--accent);
            flex-shrink:0;
        }
        #contractPage .contract-summary-card .summary-icon .material-symbols-rounded { font-size:20px; }
        #contractPage .contract-summary-card > div:last-child {
            display:flex;
            align-items:center;
            justify-content:space-between;
            gap:12px;
            flex:1;
            min-width:0;
        }
        #contractPage .contract-summary-card .summary-label {
            margin-bottom:0;
            font-size:11px;
            font-weight:700;
            color:#6b7a6e;
            white-space:nowrap;
            overflow:hidden;
            text-overflow:ellipsis;
        }
        #contractPage .contract-summary-card .summary-value {
            flex-shrink:0;
            min-width:34px;
            font-size:22px;
            font-weight:800;
            color:var(--text-head);
            line-height:1;
            text-align:right;
        }
        #contractPage .contract-summary-card.primary {
            background:var(--accent);
            border-color:#1f4027;
        }
        #contractPage .contract-summary-card.primary .summary-icon {
            background:rgba(255,255,255,.14);
            color:#fff;
        }
        #contractPage .contract-summary-card.primary .summary-label { color:rgba(255,255,255,.72); }
        #contractPage .contract-summary-card.primary .summary-value { color:#fff; }

        /* 30일 이내 만료예정은 전체 배경을 빨갛게 채우지 않고, 아이콘/숫자만 차분한 경고색으로 표시한다. */
        #contractPage .contract-summary-card.warning { border-color:#f3c7c7; }
        #contractPage .contract-summary-card.warning .summary-icon { background:#fbeaea; color:#b42318; }
        #contractPage .contract-summary-card.warning .summary-label { color:#7f1d1d; font-weight:800; }
        #contractPage .contract-summary-card.warning .summary-value { color:#b42318; }

        /* ── 목록 헤더 ── */
        #contractPage .list-count {
            font-size:12px; font-weight:800; color:var(--accent);
            background:var(--accent-light); border-radius:4px; padding:3px 9px; white-space:nowrap;
        }
        #contractPage .list-head-left { display:flex; align-items:center; gap:8px; min-width:0; }
        #contractPage .list-head-right { display:flex; align-items:center; justify-content:flex-end; gap:7px; flex-shrink:0; }
        #contractPage .result-desc { font-size:11px; color:#7a8a7d; margin-left:8px; font-weight:500; }

        /* ── 페이지네이션 ── */
        #contractPage .pagination-wrap { display:flex; justify-content:center; padding:14px 0 2px; }
        #contractPage .pagination { display:flex; align-items:center; justify-content:center; gap:4px; margin:0; padding:0; list-style:none; }
        #contractPage .page-item { list-style:none; }
        #contractPage .page-link { display:inline-flex; align-items:center; justify-content:center; min-width:30px; height:30px; padding:0 9px; border:1px solid var(--line); border-radius:4px; background:#fff; color:#39443d; font-size:12px; font-weight:700; text-decoration:none; box-sizing:border-box; }
        #contractPage .page-link:hover { background:#f4f7f4; }
        #contractPage .page-item.active .page-link { background:var(--accent); border-color:var(--accent); color:#fff; }
        #contractPage .page-item.disabled .page-link { color:#a6b1aa; cursor:default; }

        /* ── 목록 테이블 ── */
        #contractPage .table-wrap {
            overflow-x:auto;
            margin:0 -1px;
            padding:0;              /* 공통 manager-common.css의 table-wrap padding 제거 */
            background:#fff;
        }
        #contractPage .tbl {
            width:100%; min-width:100%;
            border-collapse:collapse; table-layout:fixed;
        }
        #contractPage .tbl th {
            height:38px; padding:0 8px;
            background:var(--th-bg); border-bottom:1px solid var(--line);
            color:var(--text-sec); font-size:12px; font-weight:800; text-align:center;
            white-space:nowrap;
        }
        #contractPage .tbl td {
            height:43px; padding:6px 8px;
            border-bottom:1px solid #eef1f3;
            color:#243027; font-size:12px; font-weight:400;
            text-align:center; vertical-align:middle;
            white-space:nowrap; overflow:hidden; text-overflow:ellipsis;
        }
        #contractPage .tbl tr:last-child td { border-bottom:none; }
        #contractPage .tbl tr:hover td { background:#f8fbf8; }
        #contractPage .tbl .td-left { text-align:left; }
        #contractPage .tbl .td-right { text-align:right; }

        /* 계약금액은 우측 정렬을 유지하되, 관리 컬럼과 붙어 보이지 않도록 오른쪽 여백을 추가한다. */
        #contractPage .tbl th.col-cont-amt,
        #contractPage .tbl td.col-cont-amt { padding-right:20px; }

        /* 관리 버튼 셀은 버튼 2개가 잘리지 않도록 overflow를 풀어둔다. */
        #contractPage .tbl td.col-action {
            overflow:visible;
            text-overflow:clip;
            padding-left:6px;
            padding-right:6px;
        }

        /* 목록 그리드 본문은 굵기/글씨체를 통일한다. */
        #contractPage .tbl td,
        #contractPage .tbl td .mono,
        #contractPage .tbl td .contract-name,
        #contractPage .tbl td .contract-sub,
        #contractPage .tbl td .partner-name,
        #contractPage .tbl td .btn {
            font-family:'Noto Sans KR',sans-serif;
            font-weight:400;
        }
        #contractPage .mono { font-family:'Noto Sans KR',sans-serif; font-size:11px; font-weight:400; color:#66736a; }
        #contractPage .contract-name { font-weight:400; color:#1f2d23; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }
        #contractPage .contract-sub { margin-top:2px; font-family:'Noto Sans KR',sans-serif; font-size:11px; font-weight:400; color:#66736a; }
        #contractPage .partner-cell { padding-left:12px !important; }
        #contractPage .partner-name { font-weight:400; color:#243027; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }
        #contractPage .grid-actions {
            display:inline-flex;
            align-items:center;
            justify-content:center;
            gap:6px;
            width:100%;
            white-space:nowrap;
        }
        #contractPage .btn-detail {
            border-color:#d7dce2;
            background:#fff;
            color:#39443d;
        }
        #contractPage .btn-detail:hover {
            background:#f4f7f4;
        }
        #contractPage .btn-edit {
            border-color:var(--accent);
            background:var(--accent);
            color:#fff;
        }
        #contractPage .btn-edit:hover {
            border-color:var(--accent-hover);
            background:var(--accent-hover);
            color:#fff;
        }
        #contractPage .btn-term {
            border-color:#c2410c;
            background:#fff7ed;
            color:#9a3412;
        }
        #contractPage .btn-term:hover {
            border-color:#9a3412;
            background:#ffedd5;
            color:#7c2d12;
        }
        #contractPage .btn-term.is-disabled {
            opacity:.45;
            cursor:not-allowed;
            pointer-events:none;
        }
        /* 관리 버튼 글씨는 목록 본문 통일 규칙보다 우선 적용한다. */
        #contractPage .tbl td.col-action .grid-actions .btn,
        #contractPage .tbl td.col-action .grid-actions .btn-detail,
        #contractPage .tbl td.col-action .grid-actions .btn-edit,
        #contractPage .tbl td.col-action .grid-actions .btn-term {
            font-weight:800 !important;
        }

        /* 계약기간은 컬럼 폭을 줄이기 위해 두 줄로 표시하고, 계약명 영역을 더 확보한다. */
        #contractPage .contract-period {
            white-space:normal;
            line-height:1.55;
            font-size:12px;
            letter-spacing:0;
        }
        #contractPage .contract-period .period-sep {
            margin-right:3px;
            color:#9ca3af;
        }

        /* 상세 협력업체는 한 줄로 유지하고, 업체번호만 괄호형 보조 텍스트로 구분한다. */
        #contractPage .detail-partner-inline {
            display:inline-flex;
            align-items:baseline;
            gap:6px;
            max-width:100%;
            white-space:nowrap;
        }
        #contractPage .detail-partner-name {
            color:#1f2d23;
            font-size:12px;
            font-weight:400;
        }
        #contractPage .detail-partner-no {
            color:#9ca3af;
            font-size:11px;
            font-weight:400;
            line-height:1.3;
        }

        /* ── 배지 ── */
        #contractPage .badge {
            display:inline-flex; align-items:center; justify-content:center;
            min-height:20px; padding:0 7px; border-radius:4px;
            font-size:11px; font-weight:700; border:1px solid transparent; white-space:nowrap;
        }
        #contractPage .badge-green { background:#e8f1eb; color:#1f5a35; border-color:#bdd7c5; }
        #contractPage .badge-blue { background:#dbeafe; color:#1e3a5f; border-color:#bfdbfe; }
        #contractPage .badge-yellow { background:#fef3c7; color:#713f12; border-color:#fde68a; }
        #contractPage .badge-gray { background:#f3f4f6; color:#4b5563; border-color:#d1d5db; }
        #contractPage .badge-purple { background:#ede9fe; color:#4c1d95; border-color:#ddd6fe; }
        #contractPage .badge-orange { background:#ffedd5; color:#7c2d12; border-color:#fed7aa; }

        /* ── 빈 행 ── */
        #contractPage .empty-row { height:90px; color:var(--text-ter); font-size:13px; text-align:center !important; }

        /* ── 상세 모달 : 공통 openModal/closeModal 클래스 기준 ── */
        #contractPage .modal-overlay {
            display:none; position:fixed; inset:0; z-index:1000;
            align-items:center; justify-content:center; padding:24px;
            background:rgba(15,23,42,.35); box-sizing:border-box;
        }
        #contractPage .modal-overlay.open,
        #contractPage .modal-overlay.is-open { display:flex; }
        #contractPage .modal {
            width:min(900px,96vw); max-height:88vh;
            display:flex; flex-direction:column;
            background:#fff; border:1px solid var(--line);
            border-radius:8px; box-shadow:0 18px 45px rgba(15,23,42,.22);
            overflow:hidden;
        }
        #contractPage .modal.modal-wide { width:min(1100px,96vw); }
        #contractPage .modal-header {
            display:flex; align-items:center; justify-content:space-between;
            min-height:48px; padding:0 18px;
            border-bottom:1px solid var(--line); background:var(--text-head);
        }
        #contractPage .modal-title { margin:0; color:#fff; font-size:14px; font-weight:700; }
        #contractPage .modal-close {
            border:0; background:rgba(255,255,255,.12); cursor:pointer;
            color:rgba(255,255,255,.75); width:28px; height:28px;
            border-radius:4px; display:flex; align-items:center; justify-content:center;
        }
        #contractPage .modal-close:hover { background:rgba(255,255,255,.2); }
        #contractPage .modal-body { padding:18px; overflow-y:auto; flex:1; }
        #contractPage .modal-footer {
            display:flex; justify-content:flex-end; gap:8px;
            padding:12px 18px; border-top:1px solid var(--line); background:var(--surface-sub);
        }

        /* ── 상세 모달 내부 ── */
        #contractPage .form-section { margin-bottom:18px; }
        #contractPage .form-section:last-child { margin-bottom:0; }
        #contractPage .form-section-title {
            display:flex; align-items:center; gap:5px;
            margin-bottom:10px; padding-bottom:8px; border-bottom:1px solid var(--line);
            color:var(--text-head); font-size:12px; font-weight:800;
        }
        #contractPage .form-section-title .material-symbols-rounded { font-size:15px; color:var(--accent); }

        #contractPage .detail-grid {
            display:grid; grid-template-columns:140px 1fr 140px 1fr;
            border:1px solid var(--line); border-bottom:none;
            border-radius:4px; overflow:hidden;
        }
        #contractPage .detail-grid dt,
        #contractPage .detail-grid dd {
            min-height:36px; margin:0; padding:9px 11px;
            border-bottom:1px solid var(--line);
            font-size:12px; box-sizing:border-box;
        }
        #contractPage .detail-grid dt { background:var(--surface-sub); color:var(--text-sec); font-weight:800; }
        #contractPage .detail-grid dd { color:#1f2d23; }
        #contractPage .detail-grid .wide-label { grid-column:1; }
        #contractPage .detail-grid .wide-value { grid-column:2 / -1; white-space:pre-wrap; line-height:1.6; }

        #contractPage .target-table { width:100%; table-layout:fixed; border-collapse:collapse; font-size:12px; }
        #contractPage .target-table th {
            height:34px; padding:0 10px;
            background:var(--th-bg); border-bottom:1px solid var(--line);
            color:var(--text-sec); font-size:11px; font-weight:800; text-align:center;
        }
        #contractPage .target-table td {
            height:38px; padding:7px 10px; border-bottom:1px solid #eef1f3;
            color:#243027; text-align:center; white-space:nowrap; overflow:hidden; text-overflow:ellipsis;
        }
        #contractPage .target-table .td-left { text-align:left; }
        #contractPage .file-action-group { display:flex; justify-content:center; gap:6px; }
        #contractPage .file-action-group .btn[disabled] { opacity:.45; cursor:not-allowed; }

        @media(max-width:1350px) {
            #contractPage .filter-grid { grid-template-columns:repeat(3,minmax(0,1fr)); }
            #contractPage .filter-actions { width:auto; justify-content:flex-start; }
        }
        @media(max-width:760px) {
            #contractPage .contract-summary-row { grid-template-columns:1fr 1fr; }
            #contractPage .filter-grid { grid-template-columns:1fr; }
            #contractPage .panel-header { flex-direction:column; align-items:flex-start; gap:8px; }
            #contractPage .list-head-right { width:100%; justify-content:flex-start; }
            #contractPage .detail-grid { grid-template-columns:120px 1fr; }
            #contractPage .detail-grid .wide-label { grid-column:1; }
            #contractPage .detail-grid .wide-value { grid-column:2; }
        }
    </style>
</head>

<body>
<div class="app-wrapper">
    <%@ include file="/WEB-INF/views/include/office_sidebar.jsp" %>

    <div class="main-wrap">
        <%@ include file="/WEB-INF/views/include/office_header.jsp" %>

        <main class="main-content">
            <div class="office-page" id="contractPage">

                <div class="page-header">
                    <div class="page-title-block">
                        <h2>계약 관리</h2>
                        <p>협력업체와 연결된 시설 유지보수, 공사, 용역, 검침 계약을 관리합니다.</p>
                    </div>
                </div>

                <%-- 계약 현황 카드
                     - 최종값은 Controller에서 contractSummary로 내려주는 것을 기준으로 사용
                --%>
                <div class="contract-summary-row">
                    <div class="contract-summary-card primary">
                        <div class="summary-icon"><span class="material-symbols-rounded">contract</span></div>
                        <div>
                            <div class="summary-label">전체 계약</div>
                            <div class="summary-value">
                                <c:choose>
                                    <c:when test="${not empty contractSummary.totalCnt}">
                                        <c:out value="${contractSummary.totalCnt}"/>
                                    </c:when>
                                    <c:otherwise>
                                        <c:out value="${fn:length(contractList)}"/>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>

                    <div class="contract-summary-card">
                        <div class="summary-icon"><span class="material-symbols-rounded">play_circle</span></div>
                        <div>
                            <div class="summary-label">진행중 계약</div>
                            <div class="summary-value">
                                <c:choose>
                                    <c:when test="${not empty contractSummary.activeCnt}">
                                        <c:out value="${contractSummary.activeCnt}"/>
                                    </c:when>
                                    <c:otherwise>0</c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>

                    <div class="contract-summary-card warning">
                        <div class="summary-icon"><span class="material-symbols-rounded">event_upcoming</span></div>
                        <div>
                            <div class="summary-label">30일 이내 만료예정</div>
                            <div class="summary-value">
                                <c:choose>
                                    <c:when test="${not empty contractSummary.expireSoonCnt}">
                                        <c:out value="${contractSummary.expireSoonCnt}"/>
                                    </c:when>
                                    <c:when test="${empty contractList}">0</c:when>
                                    <c:otherwise>0</c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>

                    <div class="contract-summary-card">
                        <div class="summary-icon"><span class="material-symbols-rounded">event_busy</span></div>
                        <div>
                            <div class="summary-label">만료 계약</div>
                            <div class="summary-value">
                                <c:choose>
                                    <c:when test="${not empty contractSummary.expiredCnt}">
                                        <c:out value="${contractSummary.expiredCnt}"/>
                                    </c:when>
                                    <c:when test="${empty contractList}">0</c:when>
                                    <c:otherwise>0</c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>

                <%-- 검색 조건 패널 --%>
                <div class="panel">
                    <div class="panel-header">
                        <h3 class="panel-title"><span class="material-symbols-rounded">manage_search</span>검색 조건</h3>
                    </div>

                    <div class="panel-body">
                        <form method="get" action="${ctx}/manager/facility/contract/list/${mgmtOfcNo}" id="searchForm">
                            <%-- 협력업체 상세에서 넘어온 업체 필터 유지 --%>
                            <input type="hidden" name="partnerNo" value="${fn:escapeXml(search.partnerNo)}">
                            <%-- 페이지네이션 현재 페이지 유지용. 검색 버튼 클릭 시에는 JS에서 1페이지로 초기화한다. --%>
                            <input type="hidden" name="page" value="${empty pagingVO.currentPage ? 1 : pagingVO.currentPage}">
                            <div class="filter-grid">
                                <div class="form-field">
                                    <label class="field-label" for="filterContTyCd">계약유형</label>
                                    <select class="form-select" id="filterContTyCd" name="contTyCd">
                                        <option value="">전체</option>
                                        <c:forEach var="type" items="${contractTypeList}">
                                            <option value="${type.code}" <c:if test="${search.contTyCd eq type.code}">selected</c:if>><c:out value="${type.codeNm}"/></option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <div class="form-field">
                                    <label class="field-label">계약상태</label>
                                    <select class="form-select" id="filterContSttsCd" name="contSttsCd">
                                        <option value="">전체</option>
                                        <option value="DRAFT"  <c:if test="${search.contSttsCd eq 'DRAFT'}">selected</c:if>>작성중</option>
                                        <option value="ACTIVE" <c:if test="${search.contSttsCd eq 'ACTIVE'}">selected</c:if>>진행중</option>
                                        <option value="END"    <c:if test="${search.contSttsCd eq 'END'}">selected</c:if>>종료</option>
                                        <option value="TERM"   <c:if test="${search.contSttsCd eq 'TERM'}">selected</c:if>>해지</option>
                                    </select>
                                </div>

                                <div class="form-field">
                                    <label class="field-label">계약기간</label>
                                    <div class="date-range-inputs">
                                        <input type="date" class="form-input" id="filterPeriodStartDt" name="periodStartDt" value="${search.periodStartDt}">
                                        <span class="date-filter-sep">~</span>
                                        <input type="date" class="form-input" id="filterPeriodEndDt" name="periodEndDt" value="${search.periodEndDt}">
                                    </div>
                                </div>

                                <div class="form-field">
                                    <label class="field-label">계약금액</label>
                                    <div class="date-range-inputs">
                                        <input type="number" class="form-input" id="filterMinContAmt" name="minContAmt" value="${search.minContAmt}" min="0" placeholder="최소금액">
                                        <span class="date-filter-sep">~</span>
                                        <input type="number" class="form-input" id="filterMaxContAmt" name="maxContAmt" value="${search.maxContAmt}" min="0" placeholder="최대금액">
                                    </div>
                                </div>

                                <div class="form-field">
                                    <label class="field-label" for="filterKeyword">통합검색</label>
                                    <div class="search-wrap">
                                        <span class="material-symbols-rounded">search</span>
                                        <input type="text" class="form-input" id="filterKeyword" name="keyword"
                                               value="${fn:escapeXml(search.keyword)}" placeholder="계약명/번호, 업체명, 대상 검색">
                                    </div>
                                </div>

                                <div class="form-field">
                                    <label class="field-label">&nbsp;</label>
                                    <div class="filter-actions">
                                        <button type="submit" class="btn btn-primary">검색</button>
                                        <a href="${ctx}/manager/facility/contract/list/${mgmtOfcNo}" class="btn">초기화</a>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>

                <%-- 계약 목록 패널 --%>
                <div class="panel panel-list">
                    <div class="panel-header">
                        <div class="list-head-left">
                            <h3 class="panel-title"><span class="material-symbols-rounded">contract</span>계약 목록</h3>
                            <span class="list-count">총 <c:out value="${pagingVO.totalRecord}"/>건</span>
                            <span class="result-desc">시설 · 공사 · 용역 · 검침 계약</span>
                        </div>

                        <%-- ADMIN은 조회 전용이므로 계약 등록 버튼을 숨긴다. --%>
                        <sec:authorize access="!hasRole('ADMIN')">
                            <div class="list-head-right">
                                <a class="btn btn-primary" href="${ctx}/manager/facility/contract/form/${mgmtOfcNo}">
                                    <span class="material-symbols-rounded">add</span>계약 등록
                                </a>
                            </div>
                        </sec:authorize>
                    </div>

                    <div class="table-wrap">
                        <table class="tbl">
                            <colgroup>
                                <col style="width:5%">
                                <col style="width:10%">
                                <col style="width:16%">
                                <col style="width:8%">
                                <col style="width:13%">
                                <col style="width:11%">
                                <col style="width:8%">
                                <col style="width:7%">
                                <col style="width:10%">
                                <col style="width:12%">
                            </colgroup>

                            <thead>
                            <tr>
                                <th>번호</th>
                                <th>계약번호</th>
                                <th class="td-left">계약명</th>
                                <th>계약유형</th>
                                <th class="td-left">대상</th>
                                <th class="td-left">협력업체</th>
                                <th class="col-cont-amt">계약금액</th>
                                <th>계약상태</th>
                                <th>계약기간</th>
                                <th>관리</th>
                            </tr>
                            </thead>

                            <tbody>
                            <c:choose>
                                <c:when test="${not empty contractList}">
                                    <c:forEach var="contract" items="${contractList}" varStatus="st">

                                        <%-- 계약유형 표시값 --%>
                                        <c:set var="contTyText" value="${empty contract.contTyNm ? contract.contTyCd : contract.contTyNm}" />
                                        <c:set var="contTyBadge" value="badge-gray" />
                                        <c:choose>
                                            <c:when test="${contract.contTyCd eq 'MAINT'}"><c:set var="contTyText" value="유지보수"/><c:set var="contTyBadge" value="badge-green"/></c:when>
                                            <c:when test="${contract.contTyCd eq 'REPAIR'}"><c:set var="contTyText" value="보수공사"/><c:set var="contTyBadge" value="badge-orange"/></c:when>
                                            <c:when test="${contract.contTyCd eq 'INSTALL'}"><c:set var="contTyText" value="설치공사"/><c:set var="contTyBadge" value="badge-purple"/></c:when>
                                            <c:when test="${contract.contTyCd eq 'SERVICE'}"><c:set var="contTyText" value="용역"/><c:set var="contTyBadge" value="badge-blue"/></c:when>
                                            <c:when test="${contract.contTyCd eq 'METER'}"><c:set var="contTyText" value="검침"/><c:set var="contTyBadge" value="badge-yellow"/></c:when>
                                            <c:when test="${contract.contTyCd eq 'ETC'}"><c:set var="contTyText" value="기타"/><c:set var="contTyBadge" value="badge-gray"/></c:when>
                                        </c:choose>

                                        <%-- 계약상태 표시값 --%>
                                        <c:set var="contSttsText" value="${contract.contSttsCd}" />
                                        <c:set var="contSttsBadge" value="badge-gray" />
                                        <c:choose>
                                            <c:when test="${contract.contSttsCd eq 'DRAFT'}"><c:set var="contSttsText" value="작성중"/><c:set var="contSttsBadge" value="badge-gray"/></c:when>
                                            <c:when test="${contract.contSttsCd eq 'ACTIVE'}"><c:set var="contSttsText" value="진행중"/><c:set var="contSttsBadge" value="badge-green"/></c:when>
                                            <c:when test="${contract.contSttsCd eq 'END'}"><c:set var="contSttsText" value="종료"/><c:set var="contSttsBadge" value="badge-blue"/></c:when>
                                            <c:when test="${contract.contSttsCd eq 'TERM'}"><c:set var="contSttsText" value="해지"/><c:set var="contSttsBadge" value="badge-orange"/></c:when>
                                            <c:when test="${empty contract.contSttsCd}"><c:set var="contSttsText" value="-"/><c:set var="contSttsBadge" value="badge-gray"/></c:when>
                                        </c:choose>

                                        <tr>
                                            <td class="mono">${pagingVO.totalRecord - ((pagingVO.currentPage - 1) * pagingVO.screenSize + st.index)}</td>

                                            <td class="mono"><c:out value="${contract.contNo}"/></td>

                                            <td class="td-left">
                                                <div class="contract-name"><c:out value="${contract.contNm}"/></div>
                                            </td>

                                            <td><span class="badge ${contTyBadge}">${contTyText}</span></td>

                                            <td class="td-left">
                                                <c:choose>
                                                    <c:when test="${contract.targetCount gt 1}">
                                                        <c:out value="${contract.targetSummary}"/> 외 ${contract.targetCount - 1}건
                                                    </c:when>
                                                    <c:when test="${contract.targetCount eq 1}">
                                                        <c:out value="${contract.targetSummary}"/>
                                                    </c:when>
                                                    <c:when test="${contract.contTargetCd eq 'COMMON'}">
                                                        단지공통
                                                    </c:when>
                                                    <c:when test="${contract.contTargetCd eq 'METER'}">
                                                        검침 설정
                                                    </c:when>
                                                    <c:otherwise>
                                                        -
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                            <td class="td-left partner-cell">
                                                    <%-- 목록에서는 협력업체 번호를 숨기고 업체명만 표시한다. 업체번호는 상세 모달에서 보조 텍스트로 확인한다. --%>
                                                <div class="partner-name"><c:out value="${contract.partnerNm}"/></div>
                                            </td>

                                            <td class="td-right col-cont-amt">
                                                <fmt:formatNumber value="${contract.contAmt}" pattern="#,###"/>원
                                            </td>

                                            <td><span class="badge ${contSttsBadge}">${contSttsText}</span></td>

                                            <td class="mono contract-period">
                                                    <%-- Date 타입을 화면 표시용 날짜 형식으로 변환하고 두 줄로 표시한다. --%>
                                                <fmt:formatDate value="${contract.contBgngDt}" pattern="yyyy.MM.dd"/><br>
                                                <span class="period-sep">~</span>
                                                <c:choose>
                                                    <c:when test="${empty contract.contEndDt}">
                                                        미정
                                                    </c:when>
                                                    <c:otherwise>
                                                        <fmt:formatDate value="${contract.contEndDt}" pattern="yyyy.MM.dd"/>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>


                                            <td class="col-action">
                                                <div class="grid-actions">
                                                        <%-- 상세는 ADMIN/MNGR 모두 조회 가능하다. --%>
                                                    <button type="button" class="btn btn-xs btn-detail" data-detail-cont-no="${contract.contNo}">상세</button>

                                                        <%-- ADMIN은 조회 전용이므로 수정/해지 버튼을 숨긴다. --%>
                                                    <sec:authorize access="!hasRole('ADMIN')">
                                                        <a class="btn btn-xs btn-edit" href="${ctx}/manager/facility/contract/form/${mgmtOfcNo}/${contract.contNo}">수정</a>
                                                        <c:choose>
                                                            <c:when test="${contract.contSttsCd eq 'ACTIVE'}">
                                                                <%-- 해지는 목록에서 즉시 처리하지 않고 해지 모드 수정 화면으로 이동시킨다. --%>
                                                                <a class="btn btn-xs btn-term" href="${ctx}/manager/facility/contract/form/${mgmtOfcNo}/${contract.contNo}?mode=terminate">해지</a>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="btn btn-xs btn-term is-disabled" title="진행중 계약만 해지 처리할 수 있습니다.">해지</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </sec:authorize>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>

                                <c:otherwise>
                                    <tr>
                                        <td colspan="10" class="empty-cell">조회된 계약이 없습니다.</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                            </tbody>
                        </table>
                    </div>

                    <%-- 계약 목록 페이지네이션 --%>
                    <c:if test="${pagingVO.totalRecord gt 0}">
                        <div class="pagination-wrap">
                                ${pagingVO.pagingHTML}
                        </div>
                    </c:if>
                </div>

                <%-- 상세 모달 --%>
                <div class="modal-overlay" id="contractDetailModal">
                    <div class="modal">
                        <div class="modal-header">
                            <h3 class="modal-title">계약 상세</h3>
                            <button type="button" class="modal-close" data-modal-close>
                                <span class="material-symbols-rounded">close</span>
                            </button>
                        </div>

                        <div class="modal-body">
                            <div class="form-section">
                                <div class="form-section-title">
                                    <span class="material-symbols-rounded">description</span>계약 기본정보
                                </div>

                                <dl class="detail-grid">
                                    <dt>계약번호</dt><dd id="detailContNo"></dd>
                                    <dt>계약명</dt><dd id="detailContNm"></dd>
                                    <dt>계약유형</dt><dd id="detailContTyCd"></dd>
                                    <dt>대상구분</dt><dd id="detailContTargetCd"></dd>
                                    <dt>입찰유형</dt><dd id="detailBidTyCd"></dd>
                                    <dt>계약금액</dt><dd id="detailContAmt"></dd>
                                    <dt>계약일자</dt><dd id="detailContDt"></dd>
                                    <dt>지급예정일</dt><dd id="detailPymtDt"></dd>
                                    <dt>계약기간</dt><dd id="detailContPeriod"></dd>
                                    <dt>협력업체</dt><dd id="detailPartner"></dd>
                                    <dt class="wide-label">계약내용</dt><dd class="wide-value" id="detailContCn"></dd>
                                    <dt class="wide-label">비고</dt><dd class="wide-value" id="detailRmrkCn"></dd>
                                </dl>
                            </div>

                            <div class="form-section">
                                <div class="form-section-title">
                                    <span class="material-symbols-rounded">apartment</span>대상 정보
                                </div>
                                <div id="detailTargetList"></div>
                            </div>

                            <div class="form-section">
                                <div class="form-section-title">
                                    <span class="material-symbols-rounded">attach_file</span>첨부파일
                                </div>
                                <div id="detailFileList"></div>
                            </div>
                        </div>

                        <div class="modal-footer">
                            <button type="button" class="btn" data-modal-close>닫기</button>
                        </div>
                    </div>
                </div>


            </div><!-- /contractPage -->
        </main>
    </div>
</div>

<script src="${ctx}/js/manager/manager-common.js"></script>
<script>
    (function () {
        'use strict';

        /* ============================================================
           계약 목록 화면 설정
           - 목록 JSP에서는 상세 조회만 처리
           - 등록/수정은 form.jsp로 이동
        ============================================================ */
        var contractConfig = {
            contextPath: '${ctx}',
            mgmtOfcNo: '${mgmtOfcNo}',
            detailUrl: '${ctx}/manager/facility/contract/detail/${mgmtOfcNo}/'
        };

        <c:if test="${param.msg eq 'insert'}">
        void showAlert('계약 등록을 완료했습니다.', 'success');
        </c:if>

        <c:if test="${param.msg eq 'update'}">
        void showAlert('계약 수정을 완료했습니다.', 'success');
        </c:if>

        /* 계약유형 표시명 */
        var contTyMap = {
            MAINT: '유지보수',
            REPAIR: '보수공사',
            INSTALL: '설치공사',
            SERVICE: '용역',
            METER: '검침',
            ETC: '기타'
        };

        /* 대상구분 표시명 */
        var targetMap = {
            FACILITY: '시설',
            COMMON: '단지공통',
            METER: '검침',
            ETC: '기타'
        };

        /* 입찰유형 표시명 */
        var bidTyMap = {
            GEN: '일반경쟁입찰',
            LIM: '제한경쟁입찰',
            SEL: '지명경쟁입찰',
            PRT: '수의계약'
        };

        /* ============================================================
           초기 이벤트 연결
        ============================================================ */
        document.addEventListener('DOMContentLoaded', function () {
            var page = document.getElementById('contractPage');
            var searchForm = document.getElementById('searchForm');

            if (!page) return;

            /* 검색 실행 시에는 항상 1페이지부터 조회한다. */
            if (searchForm) {
                searchForm.addEventListener('submit', function () {
                    setSearchPage(1);
                });
            }

            page.addEventListener('click', function (event) {
                var pageLink = event.target.closest('.pagination a[data-page]');
                var detailBtn = event.target.closest('[data-detail-cont-no]');
                var fileViewBtn = event.target.closest('[data-file-view-no]');

                /* 페이지 번호 클릭 */
                if (pageLink) {
                    event.preventDefault();
                    setSearchPage(pageLink.dataset.page);

                    if (searchForm) {
                        searchForm.submit();
                    }

                    return;
                }

                /* 상세 버튼 */
                if (detailBtn) {
                    openDetailModal(detailBtn.dataset.detailContNo);
                    return;
                }

                /* 첨부파일 보기 버튼 */
                if (fileViewBtn) {
                    openContractFilePreview({
                        fileGroupNo: fileViewBtn.dataset.fileGroupNo,
                        fileSaveUuid: fileViewBtn.dataset.fileSaveUuid,
                        fileName: fileViewBtn.dataset.fileName,
                        fileExt: fileViewBtn.dataset.fileExt,
                        mimeType: fileViewBtn.dataset.mimeType
                    });
                }
            });
        });

        /* ============================================================
           페이지 번호 세팅
        ============================================================ */
        function setSearchPage(pageNo) {
            var searchForm = document.getElementById('searchForm');

            if (!searchForm) return;

            var pageInput = searchForm.querySelector('input[name="page"]');

            if (!pageInput) {
                pageInput = document.createElement('input');
                pageInput.type = 'hidden';
                pageInput.name = 'page';
                searchForm.appendChild(pageInput);
            }

            pageInput.value = pageNo || 1;
        }

        /* ============================================================
           상세 모달 열기
        ============================================================ */
        async function openDetailModal(contNo) {
            try {
                /* 실제 데이터는 상세 API에서만 조회한다. */
                var res = await requestJson(contractConfig.detailUrl + encodeURIComponent(contNo));

                if (!res.success) {
                    alertMessage(res.message || '계약 정보를 조회하지 못했습니다.');
                    return;
                }

                var contract = res.contract || {};

                /* 상세 기본정보 표시 */
                setText('detailContNo', contract.contNo);
                setText('detailContNm', contract.contNm);
                setText('detailContTyCd', contract.contTyNm || contTyMap[contract.contTyCd] || contract.contTyCd);
                setText('detailContTargetCd', targetMap[contract.contTargetCd] || contract.contTargetCd);
                setText('detailBidTyCd', contract.bidTyNm || bidTyMap[contract.bidTyCd] || contract.bidTyCd);
                setText('detailContAmt', formatMoney(contract.contAmt));
                /* 상세 날짜는 서버 Date/문자열 형식이 섞여도 yyyy.MM.dd로 통일한다. */
                setText('detailContDt', formatDateText(contract.contDt));
                setText('detailPymtDt', formatDateText(contract.pymtDt));
                setText('detailContPeriod', formatDateText(contract.contBgngDt) + ' ~ ' + (formatDateText(contract.contEndDt) || '미정'));
                /* 협력업체명과 업체번호를 분리 표시한다. 업체번호는 옅은 보조 텍스트로만 보여준다. */
                renderDetailPartner(contract.partnerNm, contract.partnerNo);
                setText('detailContCn', contract.contCn);
                setText('detailRmrkCn', contract.rmrkCn);

                /* 상세 하위 정보 표시 */
                renderDetailTargets(contract.targetFacilityList || [], contract.contTargetCd, contract);
                renderDetailFiles(contract.fileList || []);

                /* 공통 모달 열기 */
                if (typeof window.openModal === 'function') {
                    window.openModal('contractDetailModal');
                } else {
                    document.getElementById('contractDetailModal').classList.add('open');
                }
            } catch (e) {
                alertMessage(e.message || '계약 정보를 조회하지 못했습니다.');
            }
        }

        /* ============================================================
           상세 협력업체 렌더링
           - 업체명은 기본 텍스트
           - 업체번호는 상세 확인용 보조 텍스트로 옅게 표시
        ============================================================ */
        function renderDetailPartner(partnerNm, partnerNo) {
            var element = document.getElementById('detailPartner');

            if (!element) return;

            var html = '';

            /* 상세 행 높이가 늘어나지 않도록 업체명과 업체번호를 한 줄로 묶는다. */
            html += '<span class="detail-partner-inline">';
            html += '<span class="detail-partner-name">' + escapeHtml(partnerNm || '-') + '</span>';

            if (partnerNo) {
                html += '<span class="detail-partner-no">(업체번호 ' + escapeHtml(partnerNo) + ')</span>';
            }

            html += '</span>';

            element.innerHTML = html;
        }

        /* ============================================================
           상세 대상 정보 렌더링
        ============================================================ */
        /* ============================================================
           상세 대상 정보 렌더링
           - 일반 시설 계약은 대상 시설 목록 표시
           - 검침 계약은 계약에 연결된 CSV 업로드 설정 목록 표시
        ============================================================ */
        function renderDetailTargets(targetList, contTargetCd, contract) {
            var box = document.getElementById('detailTargetList');

            if (!box) return;

            /* 검침 계약은 시설 대상 목록이 아니라 CSV 업로드 설정을 표시한다. */
            if (contTargetCd === 'METER') {
                renderDetailMeterSettings(box, contract || {});
                return;
            }

            /* 단지공통/기타처럼 시설 목록이 없는 계약 표시 */
            if (!targetList || targetList.length === 0) {
                if (contTargetCd === 'COMMON') {
                    box.innerHTML = '<div class="empty-row">단지공통 계약입니다.</div>';
                    return;
                }

                box.innerHTML = '<div class="empty-row">등록된 대상 시설이 없습니다.</div>';
                return;
            }

            var html = '';
            html += '<table class="target-table">';
            html += '  <colgroup>';
            html += '      <col style="width:130px;">';
            html += '      <col style="width:180px;">';
            html += '      <col style="width:100px;">';
            html += '      <col>';
            html += '  </colgroup>';
            html += '  <thead>';
            html += '      <tr>';
            html += '          <th>시설번호</th>';
            html += '          <th>시설명</th>';
            html += '          <th>유형</th>';
            html += '          <th>위치</th>';
            html += '      </tr>';
            html += '  </thead>';
            html += '  <tbody>';

            targetList.forEach(function (facility) {
                html += '      <tr>';
                html += '          <td class="mono">' + escapeHtml(facility.facilityNo) + '</td>';
                html += '          <td>' + escapeHtml(facility.facilityNm) + '</td>';
                html += '          <td>' + escapeHtml(facility.facilityTyNm || facility.facilityTyCd) + '</td>';
                html += '          <td>' + escapeHtml(facility.locCn || '위치 미등록') + '</td>';
                html += '      </tr>';
            });

            html += '  </tbody>';
            html += '</table>';

            box.innerHTML = html;
        }

        /* ============================================================
           상세 검침 설정 렌더링
           - 상세 API에서 내려오는 검침 설정 배열명을 최대한 방어적으로 처리한다.
           - 배열이 없고 계약 객체에 단일 설정 필드가 있으면 1건으로 표시한다.
        ============================================================ */
        function renderDetailMeterSettings(box, contract) {
            var settingList = getMeterSettingList(contract);
            var html = '';

            if (!settingList || settingList.length === 0) {
                box.innerHTML = '<div class="empty-row">등록된 검침 설정 정보가 없습니다.</div>';
                return;
            }

            html += '<table class="target-table">';
            html += '  <colgroup>';
            html += '      <col style="width:90px;">';
            html += '      <col style="width:130px;">';
            html += '      <col style="width:360px;">';
            html += '      <col>';
            html += '  </colgroup>';
            html += '  <thead>';
            html += '      <tr>';
            html += '          <th>검침유형</th>';
            html += '          <th>설정번호</th>';
            html += '          <th>CSV 식별키</th>';
            html += '          <th>외부 고객번호</th>';
            html += '      </tr>';
            html += '  </thead>';
            html += '  <tbody>';

            settingList.forEach(function (setting) {
                html += '      <tr>';
                html += '          <td>' + escapeHtml(setting.meterTyNm || setting.meterTyCd || '-') + '</td>';
                html += '          <td class="mono">' + escapeHtml(setting.utilityProviderNo || setting.providerNo || '-') + '</td>';
                html += '          <td class="mono td-left">' + escapeHtml(setting.csvIdntfKey || '-') + '</td>';
                html += '          <td class="mono td-left">' + escapeHtml(setting.extCustNo || '-') + '</td>';
                html += '      </tr>';
            });

            html += '  </tbody>';
            html += '</table>';

            box.innerHTML = html;
        }

        /* ============================================================
           검침 설정 목록 추출
           - Controller/DTO 이름이 아직 확정되지 않았을 수 있어 가능한 이름을 모두 확인한다.
        ============================================================ */
        function getMeterSettingList(contract) {
            var list = contract.meterSettingList
                || contract.utilityProviderList
                || contract.providerList
                || contract.meterProviderList
                || contract.meterTargetList
                || contract.utilityList
                || [];

            if (Array.isArray(list) && list.length > 0) {
                return list;
            }

            /* 상세 응답에 단일 설정 필드만 내려오는 경우도 화면 확인 가능하도록 1건으로 보정한다. */
            if (contract.utilityProviderNo || contract.csvIdntfKey || contract.extCustNo || contract.meterTyCd || contract.meterTyNm) {
                return [{
                    meterTyCd: contract.meterTyCd,
                    meterTyNm: contract.meterTyNm,
                    utilityProviderNo: contract.utilityProviderNo,
                    csvIdntfKey: contract.csvIdntfKey,
                    extCustNo: contract.extCustNo,
                    rmrkCn: contract.rmrkCn || contract.rmkCn
                }];
            }

            return [];
        }

        /* ============================================================
           상세 첨부파일 렌더링
           - 상세에서는 썸네일 카드가 아니라 목록형으로 표시
           - 이미지/PDF는 iframe 보기 가능, 기타 파일은 다운로드만 제공
        ============================================================ */
        function renderDetailFiles(fileList) {
            var box = document.getElementById('detailFileList');

            if (!box) return;

            if (!fileList || fileList.length === 0) {
                box.innerHTML = '<div class="empty-row">첨부된 계약서 파일이 없습니다.</div>';
                return;
            }

            var html = '';
            html += '<table class="target-table">';
            html += '  <colgroup>';
            html += '      <col>';
            html += '      <col style="width:100px;">';
            html += '      <col style="width:110px;">';
            html += '      <col style="width:150px;">';
            html += '  </colgroup>';
            html += '  <thead>';
            html += '      <tr>';
            html += '          <th>파일명</th>';
            html += '          <th>유형</th>';
            html += '          <th>크기</th>';
            html += '          <th>관리</th>';
            html += '      </tr>';
            html += '  </thead>';
            html += '  <tbody>';

            fileList.forEach(function (file) {
                /* ATTACH_FILE 실제 식별값은 FILE_GROUP_NO + FILE_SAVE_UUID 이므로 fileNo에 의존하지 않는다. */
                var fileGroupNo = file.fileGroupNo || file.file_group_no || '';
                var fileSaveUuid = file.fileSaveUuid || file.file_save_uuid || file.fileUuid || '';
                var fileName = file.fileOgName || file.fileName || file.file_og_name || '';
                var fileExt = getFileExt(file);
                var mimeType = file.mimeType || file.mime_type || '';
                var hasFileKey = !!(fileGroupNo && fileSaveUuid);
                var canPreview = hasFileKey && (isImageFile(fileExt, mimeType) || isPdfFile(fileExt, mimeType));
                var downloadUrl = hasFileKey ? getFileDownloadUrl({
                    fileGroupNo: fileGroupNo,
                    fileSaveUuid: fileSaveUuid
                }) : '#';

                html += '      <tr>';
                html += '          <td class="td-left">' + escapeHtml(fileName) + '</td>';
                html += '          <td>' + escapeHtml((fileExt || '-').toUpperCase()) + '</td>';
                html += '          <td>' + formatFileSize(file.fileSize || file.file_size) + '</td>';
                html += '          <td>';
                html += '              <div class="file-action-group">';

                if (canPreview) {
                    html += '                  <button type="button" class="btn btn-xs"';
                    html += '                          data-file-view-no="Y"';
                    html += '                          data-file-group-no="' + escapeHtml(fileGroupNo) + '"';
                    html += '                          data-file-save-uuid="' + escapeHtml(fileSaveUuid) + '"';
                    html += '                          data-file-name="' + escapeHtml(fileName) + '"';
                    html += '                          data-file-ext="' + escapeHtml(fileExt) + '"';
                    html += '                          data-mime-type="' + escapeHtml(mimeType) + '">보기</button>';
                } else {
                    html += '                  <button type="button" class="btn btn-xs" disabled title="이미지/PDF만 새 창 보기를 지원합니다.">보기</button>';
                }

                if (hasFileKey) {
                    html += '                  <a class="btn btn-xs btn-primary" href="' + escapeHtml(downloadUrl) + '">다운로드</a>';
                } else {
                    html += '                  <button type="button" class="btn btn-xs btn-primary" disabled title="파일 식별값이 없습니다.">다운로드</button>';
                }

                html += '              </div>';
                html += '          </td>';
                html += '      </tr>';
            });

            html += '  </tbody>';
            html += '</table>';

            box.innerHTML = html;
        }

        /* ============================================================
           첨부파일 보기
           - 보안 설정에서 iframe이 막히므로 새 창/새 탭으로 연다.
           - 이미지/PDF만 보기 버튼을 활성화한다.
           - 기타 파일은 상세 목록의 다운로드 버튼으로만 확인한다.
        ============================================================ */
        function openContractFilePreview(file) {
            if (!file || !file.fileGroupNo || !file.fileSaveUuid) {
                alertMessage('파일 식별값이 없습니다. 상세 API에서 fileGroupNo, fileSaveUuid를 내려주는지 확인하세요.');
                return;
            }

            /* 이미지/PDF만 브라우저 새 창 보기를 지원한다. */
            if (!(isImageFile(file.fileExt, file.mimeType) || isPdfFile(file.fileExt, file.mimeType))) {
                alertMessage('이 파일 형식은 브라우저에서 바로 볼 수 없습니다. 다운로드 후 확인하세요.');
                return;
            }

            /* iframe 대신 새 창/새 탭으로 파일 보기 */
            window.open(getFileViewUrl(file), '_blank', 'noopener,noreferrer');
        }


        /* ============================================================
           첨부파일 URL 생성
        ============================================================ */
        function getFileViewUrl(file) {
            return buildFileUrl('/manager/facility/contract/file/view', file);
        }

        function getFileDownloadUrl(file) {
            return buildFileUrl('/manager/facility/contract/file/download', file);
        }

        function buildFileUrl(path, file) {
            var params = new URLSearchParams();

            /* ATTACH_FILE 식별값 : FILE_GROUP_NO + FILE_SAVE_UUID */
            if (file.fileGroupNo) {
                params.append('fileGroupNo', file.fileGroupNo);
            }

            if (file.fileSaveUuid) {
                params.append('fileSaveUuid', file.fileSaveUuid);
            }

            return contractConfig.contextPath + path + '?' + params.toString();
        }

        /* ============================================================
           첨부파일 유형 판별
        ============================================================ */
        function getFileExt(file) {
            var ext = file.fileExt || '';
            var fileName = file.fileOgName || file.fileName || '';

            if (!ext && fileName.indexOf('.') > -1) {
                ext = fileName.substring(fileName.lastIndexOf('.') + 1);
            }

            return String(ext || '').replace('.', '').toLowerCase();
        }

        function isImageFile(fileExt, mimeType) {
            var ext = String(fileExt || '').toLowerCase();
            var mime = String(mimeType || '').toLowerCase();

            return mime.indexOf('image/') === 0 || ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'].indexOf(ext) > -1;
        }

        function isPdfFile(fileExt, mimeType) {
            var ext = String(fileExt || '').toLowerCase();
            var mime = String(mimeType || '').toLowerCase();

            return mime === 'application/pdf' || ext === 'pdf';
        }

        /* ============================================================
           JSON 요청
        ============================================================ */
        async function requestJson(url) {
            if (typeof window.getJson === 'function') {
                return window.getJson(url);
            }

            var response = await fetch(url, { method:'GET' });
            var text = await response.text();
            var data = text ? JSON.parse(text) : {};

            if (!response.ok) {
                throw new Error(data.message || '요청 처리 중 오류가 발생했습니다.');
            }

            return data;
        }

        /* ============================================================
           공통 보조 함수
        ============================================================ */
        function setText(id, value) {
            var element = document.getElementById(id);
            if (element) {
                element.textContent = empty(value);
            }
        }

        function empty(value) {
            return value == null ? '' : value;
        }

        function alertMessage(message) {
            if (typeof window.showAlert === 'function') {
                window.showAlert(message);
                return;
            }
            alert(message);
        }

        function formatDateText(value) {
            if (value == null || value === '') return '';

            var text = String(value).trim();

            /* 이미 yyyy.MM.dd 형식이면 그대로 사용한다. */
            if (/^\d{4}\.\d{2}\.\d{2}$/.test(text)) {
                return text;
            }

            /* yyyy-MM-dd 또는 yyyy/MM/dd 앞 10자리를 화면 형식으로 변환한다. */
            var basicMatch = text.match(/^(\d{4})[-\/](\d{1,2})[-\/](\d{1,2})/);
            if (basicMatch) {
                return basicMatch[1] + '.' + pad2(basicMatch[2]) + '.' + pad2(basicMatch[3]);
            }

            /* 타임스탬프 숫자가 내려오는 경우도 yyyy.MM.dd로 변환한다. */
            if (/^\d+$/.test(text)) {
                var numberDate = new Date(Number(text));
                if (!isNaN(numberDate.getTime())) {
                    return toDateString(numberDate);
                }
            }

            /* 그 외 Date 문자열은 브라우저 Date 파싱 후 yyyy.MM.dd로 변환한다. */
            var parsedDate = new Date(text);
            if (!isNaN(parsedDate.getTime())) {
                return toDateString(parsedDate);
            }

            return text;
        }

        function toDateString(date) {
            return date.getFullYear() + '.' + pad2(date.getMonth() + 1) + '.' + pad2(date.getDate());
        }

        function pad2(value) {
            return String(value).padStart(2, '0');
        }

        function formatMoney(value) {
            if (value == null || value === '') return '';
            return Number(value).toLocaleString('ko-KR') + '원';
        }

        function formatFileSize(value) {
            if (value == null || value === '') return '-';

            var size = Number(value);

            if (size >= 1024 * 1024) {
                return (size / 1024 / 1024).toFixed(1) + 'MB';
            }

            if (size >= 1024) {
                return (size / 1024).toFixed(1) + 'KB';
            }

            return size + 'B';
        }

        function escapeHtml(value) {
            return String(value == null ? '' : value)
                .replace(/&/g, '&amp;')
                .replace(/</g, '&lt;')
                .replace(/>/g, '&gt;')
                .replace(/"/g, '&quot;')
                .replace(/'/g, '&#039;');
        }
    })();
</script>
</body>
</html>
