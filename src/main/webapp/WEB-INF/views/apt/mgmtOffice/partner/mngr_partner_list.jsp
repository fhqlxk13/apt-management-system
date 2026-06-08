<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>협력업체 관리</title>
    <sec:csrfMetaTags/>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet" />
    <link rel="stylesheet" href="${ctx}/css/office-layout.css">
    <link rel="stylesheet" href="${ctx}/css/manager/manager-common.css">
    <style>
        /* ── 토큰 ── */
        #partnerPage {
            --accent:#2e5c38; --accent-hover:#1f4027; --accent-light:#e8f0ea;
            --surface:#fff; --surface-sub:#f8f9fb; --line:#d7dce2;
            --th-bg:#f0f2ef;
            --text-head:#1a2e1e; --text-sec:#4a5c4e; --text-ter:#8a9a8e;
            font-family:'Noto Sans KR',sans-serif;
        }

        /* ── 페이지 헤더 ── */
        #partnerPage .page-title-block h2 { color:var(--text-head); font-size:19px; letter-spacing:-.5px; }
        #partnerPage .page-title-block p  { color:#6b7a6e; font-size:12px; }

        /* ── 공통 버튼 ── */
        #partnerPage .btn {
            display:inline-flex; align-items:center; justify-content:center; gap:4px;
            min-height:32px; height:32px; padding:0 11px;
            border-radius:4px; border:1px solid var(--line);
            background:#fff; color:#39443d;
            font-size:12px; font-weight:700;
            cursor:pointer; text-decoration:none; box-sizing:border-box;
        }
        #partnerPage .btn:hover { background:#f4f7f4; }
        #partnerPage .btn-primary { background:var(--accent); border-color:var(--accent); color:#fff; }
        #partnerPage .btn-primary:hover { background:var(--accent-hover); border-color:var(--accent-hover); }
        #partnerPage .btn-danger  { background:#b91c1c; border-color:#b91c1c; color:#fff; }
        #partnerPage .btn-danger:hover { background:#991b1b; }
        #partnerPage .btn .material-symbols-rounded { font-size:15px; }

        /* ── 현황 카드 ── */
        #partnerPage .status-card-row {
            display:grid; grid-template-columns:repeat(4, minmax(0,1fr));
            gap:10px; margin-bottom:14px;
        }
        #partnerPage .status-card {
            display:flex; align-items:center; justify-content:space-between;
            min-height:72px; padding:13px 15px;
            border:1px solid var(--line); border-radius:6px; background:#fff;
            box-sizing:border-box;
        }
        #partnerPage .status-card .card-label {
            display:flex; align-items:center; gap:6px;
            color:var(--text-sec); font-size:12px; font-weight:800;
        }
        #partnerPage .status-card .card-label .material-symbols-rounded { font-size:18px; color:var(--accent); }
        #partnerPage .status-card strong { color:var(--text-head); font-size:23px; font-weight:800; line-height:1; }

        /* ── 패널 ── */
        #partnerPage .panel {
            border-radius:6px; border:1px solid var(--line);
            background:#fff; margin:0;
        }
        #partnerPage .panel-list { overflow:hidden; }

        #partnerPage .panel-header {
            display:flex; align-items:center; justify-content:space-between;
            padding:13px 16px; border-bottom:1px solid var(--line);
            background:#fff;
        }
        #partnerPage .panel-title {
            display:flex; align-items:center; gap:6px;
            margin:0; font-size:13px; font-weight:800; color:var(--text-head);
        }
        #partnerPage .panel-title .material-symbols-rounded { font-size:17px; color:var(--accent); }
        #partnerPage .panel-body { padding:14px 16px 16px; }

        /* ── 필터 ── */
        #partnerPage .filter-grid {
            display:grid;
            grid-template-columns:1fr .7fr .7fr 1.8fr 1.8fr minmax(220px,2.2fr) auto;
            gap:8px 12px; align-items:end;
        }
        #partnerPage .field-label {
            display:block; margin-bottom:5px;
            font-size:11px; font-weight:800; color:var(--text-sec);
        }
        #partnerPage .form-select,
        #partnerPage .form-input {
            height:32px; font-size:12px;
            border:1px solid var(--line); background:#fff;
            border-radius:4px; padding:0 9px;
            width:100%; box-sizing:border-box;
            font-family:'Noto Sans KR',sans-serif; color:#1f2d23;
        }
        #partnerPage .form-select:focus,
        #partnerPage .form-input:focus {
            border-color:var(--accent);
            box-shadow:0 0 0 2px rgba(46,92,56,.08);
            outline:none;
        }
        #partnerPage .form-input[readonly] { background:var(--surface-sub); color:var(--text-ter); cursor:default; }

        #partnerPage .date-range-inputs {
            display:grid; grid-template-columns:minmax(0,1fr) auto minmax(0,1fr);
            align-items:center; gap:5px;
        }
        #partnerPage .date-filter-sep { color:#9ca3af; font-size:12px; text-align:center; }

        #partnerPage .search-wrap { position:relative; }
        #partnerPage .search-wrap .material-symbols-rounded {
            position:absolute; left:9px; top:50%; transform:translateY(-50%);
            font-size:15px; color:#9caa9e; pointer-events:none;
        }
        #partnerPage .search-wrap input { padding-left:30px; }

        #partnerPage .filter-actions { display:flex; justify-content:flex-end; gap:7px; white-space:nowrap; }

        /* ── 목록 ── */
        #partnerPage .list-count {
            font-size:12px; font-weight:800; color:var(--accent);
            background:var(--accent-light); border-radius:4px; padding:3px 9px; white-space:nowrap;
        }
        #partnerPage .table-wrap { overflow-x:auto; margin:0 -1px; }
        #partnerPage .tbl { width:100%; border-collapse:collapse; table-layout:fixed; }
        #partnerPage .tbl th {
            height:38px; padding:0 8px;
            background:var(--th-bg); border-bottom:1px solid var(--line);
            color:var(--text-sec); font-size:12px; font-weight:800; text-align:center;
        }
        #partnerPage .tbl td {
            height:43px; padding:6px 8px;
            border-bottom:1px solid #eef1f3;
            color:#243027; font-size:12px;
            text-align:center; vertical-align:middle;
            white-space:nowrap; overflow:hidden; text-overflow:ellipsis;
        }
        #partnerPage .tbl tr:last-child td { border-bottom:none; }
        #partnerPage .tbl tr:hover td { background:#f8fbf8; }
        #partnerPage .tbl .td-left { text-align:left; }
        #partnerPage .tbl .mono { font-family:'Consolas','SF Mono',monospace; font-size:11px; color:#66736a; }

        #partnerPage .partner-no { font-family:'Consolas','SF Mono',monospace !important; font-size:11px !important; color:#66736a; }

        #partnerPage .pic-line { display:inline-flex; align-items:center; gap:5px; overflow:hidden; text-overflow:ellipsis; }
        #partnerPage .pic-sep  { color:#c4c9cf; font-size:10px; }

        #partnerPage .td-num.zero { color:var(--text-ter); }
        #partnerPage .recent-date.empty { color:var(--text-ter); }

        /* 상태 배지 */
        #partnerPage .badge {
            display:inline-flex; align-items:center; justify-content:center;
            min-height:20px; padding:0 7px; border-radius:4px;
            font-size:11px; font-weight:700; border:1px solid transparent; white-space:nowrap;
        }
        #partnerPage .badge-active   { background:#e8f1eb; color:#1f5a35; border-color:#bdd7c5; }
        #partnerPage .badge-inactive { background:#f3f4f6; color:#4b5563; border-color:#d1d5db; }

        /* 행 액션 */
        #partnerPage .row-actions { display:inline-flex; gap:5px; align-items:center; justify-content:center; }
        #partnerPage .row-actions .btn { min-width:44px; height:28px; min-height:28px; padding:0 9px; font-size:11px; }

        /* 빈 행 */
        #partnerPage .empty-row { height:90px; color:var(--text-ter); font-size:13px; }

        /* ── 페이지네이션 ── */
        #partnerPage .pagination-wrap { display:flex; justify-content:flex-end; padding:12px 16px; }
        #partnerPage .pagination { display:flex; gap:4px; list-style:none !important; margin:0; padding:0; }
        #partnerPage .page-item .page-link {
            display:inline-flex; align-items:center; justify-content:center;
            min-width:30px; height:30px; padding:0 8px;
            border:1px solid var(--line); border-radius:4px;
            color:var(--text-sec); background:#fff;
            font-size:12px; font-weight:700; text-decoration:none;
        }
        #partnerPage .page-item.active   .page-link { background:var(--accent); border-color:var(--accent); color:#fff; }
        #partnerPage .page-item.disabled .page-link { color:#b6c0b9; pointer-events:none; }

        /* ── 모달 ── */
        #partnerPage .modal-overlay {
            display:none; position:fixed; inset:0; z-index:1000;
            align-items:center; justify-content:center; padding:24px;
            background:rgba(15,23,42,.35); box-sizing:border-box;
        }
        #partnerPage .modal-overlay.open,
        #partnerPage .modal-overlay.is-open { display:flex; }
        #partnerPage .modal {
            width:min(640px,96vw); max-height:88vh;
            display:flex; flex-direction:column;
            background:#fff; border:1px solid var(--line);
            border-radius:8px; box-shadow:0 18px 45px rgba(15,23,42,.22);
            overflow:hidden;
        }
        #partnerPage .modal-lg { width:min(780px,96vw); }
        #partnerPage .modal-sm { width:min(460px,96vw); }
        #partnerPage .modal-header {
            display:flex; align-items:center; justify-content:space-between;
            min-height:48px; padding:0 18px;
            border-bottom:1px solid var(--line); background:var(--text-head);
        }
        #partnerPage .modal-title { margin:0; color:#fff; font-size:14px; font-weight:700; }
        #partnerPage .modal-close {
            border:0; background:rgba(255,255,255,.12); cursor:pointer;
            color:rgba(255,255,255,.75); width:28px; height:28px;
            border-radius:4px; display:flex; align-items:center; justify-content:center;
        }
        #partnerPage .modal-close:hover { background:rgba(255,255,255,.2); }
        #partnerPage .modal-body { padding:18px; overflow-y:auto; flex:1; }
        #partnerPage .modal-footer {
            display:flex; justify-content:flex-end; gap:8px;
            padding:12px 18px; border-top:1px solid var(--line); background:var(--surface-sub);
        }

        /* 모달 폼 */
        #partnerPage .form-section { margin-bottom:18px; }
        #partnerPage .form-section:last-child { margin-bottom:0; }
        #partnerPage .form-section-title {
            display:flex; align-items:center; gap:5px;
            margin-bottom:10px; padding-bottom:8px; border-bottom:1px solid var(--line);
            color:var(--text-head); font-size:12px; font-weight:800;
        }
        #partnerPage .form-section-title .material-symbols-rounded { font-size:15px; color:var(--accent); }
        #partnerPage .form-row { display:grid; gap:10px 12px; margin-bottom:10px; }
        #partnerPage .form-row:last-child { margin-bottom:0; }
        #partnerPage .form-row.cols-2 { grid-template-columns:1fr 1fr; }
        #partnerPage .form-row.cols-3 { grid-template-columns:1fr 1fr 1fr; }
        #partnerPage .form-field { display:flex; flex-direction:column; gap:4px; }
        #partnerPage .field-label .req { color:#b91c1c; }
        #partnerPage .field-help { font-size:11px; color:var(--text-ter); line-height:1.4; margin-top:2px; }

        /* 모달 상세 info-grid */
        #partnerPage .info-grid { border:1px solid var(--line); border-radius:5px; overflow:hidden; }
        #partnerPage .info-row {
            display:grid; grid-template-columns:90px 1fr 90px 1fr;
            border-bottom:1px solid var(--line);
        }
        #partnerPage .info-row:last-child { border-bottom:none; }
        #partnerPage .info-row.single { grid-template-columns:90px 1fr; }
        #partnerPage .info-label {
            display:flex; align-items:center; padding:0 10px;
            background:var(--th-bg); color:#27382b;
            font-size:11px; font-weight:800; border-right:1px solid var(--line);
            white-space:nowrap; min-height:36px;
        }
        #partnerPage .info-value {
            display:flex; align-items:center; padding:0 10px;
            color:#374151; font-size:12px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap;
        }
        #partnerPage .info-value.has-border { border-right:1px solid var(--line); }

        /* 연결 카드 - 4개를 한 줄에 보여주기 위해 카드 높이/간격을 압축함 */
        #partnerPage .link-card-row {
            display:grid !important;
            grid-template-columns:repeat(4, minmax(0, 1fr)) !important;
            gap:10px !important;
            align-items:stretch !important;
            width:100% !important;
        }
        #partnerPage .link-card {
            display:flex !important;
            flex-direction:column !important;
            gap:5px !important;
            min-height:96px !important;
            padding:12px 13px !important;
            border:1px solid #d4ddd7 !important;
            border-radius:8px !important;
            background:#f9fbfa !important;
            text-decoration:none !important;
            box-shadow:0 1px 0 rgba(17, 24, 39, .03) !important;
            transition:border-color .15s, background .15s, transform .15s, box-shadow .15s !important;
            box-sizing:border-box !important;
        }
        #partnerPage .link-card:not(.disabled):hover {
            border-color:#a9c5b2 !important;
            background:#f1f7f3 !important;
            transform:translateY(-1px) !important;
            box-shadow:0 4px 10px rgba(17, 24, 39, .06) !important;
        }
        #partnerPage .link-card.disabled {
            cursor:default !important;
            pointer-events:none !important;
            border-color:#d9dee3 !important;
            background:#f3f4f6 !important;
            box-shadow:none !important;
        }
        #partnerPage .link-card-title { display:flex; align-items:center; gap:5px; color:var(--text-sec); font-size:11px; font-weight:800; }
        #partnerPage .link-card-title .material-symbols-rounded { font-size:15px; color:var(--accent); }
        #partnerPage .link-card-cnt  { font-size:17px; font-weight:800; color:var(--text-head); line-height:1.2; }
        #partnerPage .link-card-sub,
        #partnerPage .link-card-meta { font-size:11px; color:var(--text-sec); line-height:1.35; }
        #partnerPage .link-card-arrow {
            display:flex; align-items:center; gap:3px;
            font-size:11px; font-weight:800; color:var(--accent); margin-top:auto;
        }
        #partnerPage .link-card-arrow .material-symbols-rounded { font-size:14px; }
        #partnerPage .link-card.disabled .link-card-title,
        #partnerPage .link-card.disabled .link-card-title .material-symbols-rounded,
        #partnerPage .link-card.disabled .link-card-cnt,
        #partnerPage .link-card.disabled .link-card-sub,
        #partnerPage .link-card.disabled .link-card-meta,
        #partnerPage .link-card.disabled .link-card-arrow { color:#9ca3af !important; }

        /* 경고 박스 */
        #partnerPage .warn-box {
            display:flex; gap:10px; padding:11px 13px;
            background:#fff7ed; border:1px solid #fed7aa;
            border-left:3px solid #f97316; border-radius:0 4px 4px 0;
            margin-bottom:14px; font-size:12px; color:#7c2d12; line-height:1.6;
        }
        #partnerPage .warn-box .material-symbols-rounded { color:#ea580c; font-size:16px; flex-shrink:0; margin-top:2px; }

        #partnerPage .is-hidden { display:none !important; }

        /* ── 반응형 ── */
        @media(max-width:1200px) {
            #partnerPage .status-card-row { grid-template-columns:repeat(2,1fr); }
            #partnerPage .filter-grid { grid-template-columns:repeat(3,minmax(0,1fr)); }
        }
        @media(max-width:920px) { #partnerPage .link-card-row { grid-template-columns:repeat(2, minmax(0, 1fr)) !important; } }
        @media(max-width:760px) {
            #partnerPage .status-card-row,
            #partnerPage .link-card-row,
            #partnerPage .filter-grid { grid-template-columns:1fr; }
            #partnerPage .form-row.cols-2,
            #partnerPage .form-row.cols-3 { grid-template-columns:1fr; }
            #partnerPage .info-row { grid-template-columns:80px 1fr; }
            #partnerPage .info-row .info-label:nth-child(3),
            #partnerPage .info-row .info-value:nth-child(4) { display:none; }
            #partnerPage .panel-header { flex-direction:column; align-items:flex-start; gap:8px; }
        }
    </style>
</head>
<body>
<div class="app-wrapper">
    <%@ include file="/WEB-INF/views/include/office_sidebar.jsp" %>
    <div class="main-wrap">
        <%@ include file="/WEB-INF/views/include/office_header.jsp" %>
        <main class="main-content">
            <div class="office-page" id="partnerPage">

                <div class="page-header">
                    <div class="page-title-block">
                        <h2>협력업체 관리</h2>
                        <p>협력업체 기본정보와 업무 연결 현황을 확인합니다.</p>
                    </div>
                </div>

                <%-- 현황 카드 --%>
                <div class="status-card-row" aria-label="협력업체 현황">
                    <div class="status-card">
                        <span class="card-label"><span class="material-symbols-rounded">groups</span>전체 업체</span>
                        <strong>${empty partnerStat.totalCnt ? 0 : partnerStat.totalCnt}</strong>
                    </div>
                    <div class="status-card">
                        <span class="card-label"><span class="material-symbols-rounded">check_circle</span>활성 업체</span>
                        <strong>${empty partnerStat.activeCnt ? 0 : partnerStat.activeCnt}</strong>
                    </div>
                    <div class="status-card">
                        <span class="card-label"><span class="material-symbols-rounded">contract</span>계약 연결</span>
                        <strong>${empty partnerStat.contractLinkedCnt ? 0 : partnerStat.contractLinkedCnt}</strong>
                    </div>
                    <div class="status-card">
                        <span class="card-label"><span class="material-symbols-rounded">electric_meter</span>검침 연결</span>
                        <strong>${empty partnerStat.meterLinkedCnt ? 0 : partnerStat.meterLinkedCnt}</strong>
                    </div>
                </div>

                <%-- 검색 조건 패널 --%>
                <div class="panel">
                    <div class="panel-header">
                        <h3 class="panel-title"><span class="material-symbols-rounded">manage_search</span>검색 조건</h3>
                    </div>
                    <div class="panel-body">
                        <form method="get" action="${ctx}/manager/facility/partner/list/${mgmtOfcNo}" id="searchForm">
                            <input type="hidden" name="page" id="page" value="${empty pageInfo.currentPage ? 1 : pageInfo.currentPage}">
                            <div class="filter-grid">
                                <div class="form-field">
                                    <label class="field-label" for="filterBizTy">업종</label>
                                    <select class="form-select" id="filterBizTy" name="bizTyNm">
                                        <option value="">전체</option>
                                        <c:forEach var="biz" items="${bizTypeList}">
                                            <option value="${biz}" <c:if test="${searchVO.bizTyNm eq biz}">selected</c:if>>${biz}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="form-field">
                                    <label class="field-label" for="filterUseYn">사용여부</label>
                                    <select class="form-select" id="filterUseYn" name="useYn">
                                        <option value="">전체</option>
                                        <option value="Y" <c:if test="${searchVO.useYn eq 'Y'}">selected</c:if>>활성</option>
                                        <option value="N" <c:if test="${searchVO.useYn eq 'N'}">selected</c:if>>비활성</option>
                                    </select>
                                </div>
                                <div class="form-field">
                                    <label class="field-label" for="filterContractYn">계약</label>
                                    <select class="form-select" id="filterContractYn" name="contractYn">
                                        <option value="">전체</option>
                                        <option value="Y" <c:if test="${searchVO.contractYn eq 'Y'}">selected</c:if>>계약 있음</option>
                                        <option value="N" <c:if test="${searchVO.contractYn eq 'N'}">selected</c:if>>계약 없음</option>
                                    </select>
                                </div>

                                <div class="form-field">
                                    <label class="field-label">최근점검일</label>
                                    <div class="date-range-inputs">
                                        <input type="date" class="form-input" id="filterCheckStartDt" name="checkStartDt" value="${searchVO.checkStartDt}">
                                        <span class="date-filter-sep">~</span>
                                        <input type="date" class="form-input" id="filterCheckEndDt"   name="checkEndDt"   value="${searchVO.checkEndDt}">
                                    </div>
                                </div>
                                <div class="form-field">
                                    <label class="field-label">최근검침일</label>
                                    <div class="date-range-inputs">
                                        <input type="date" class="form-input" id="filterMeterStartDt" name="meterStartDt" value="${searchVO.meterStartDt}">
                                        <span class="date-filter-sep">~</span>
                                        <input type="date" class="form-input" id="filterMeterEndDt"   name="meterEndDt"   value="${searchVO.meterEndDt}">
                                    </div>
                                </div>
                                <div class="form-field">
                                    <label class="field-label" for="filterKeyword">통합검색</label>
                                    <div class="search-wrap">
                                        <span class="material-symbols-rounded">search</span>
                                        <input type="text" class="form-input" id="filterKeyword" name="searchWord"
                                               value="${searchWord}" placeholder="업체번호, 업체명, 담당자, 연락처, 사업자번호">
                                    </div>
                                </div>
                                <div class="form-field">
                                    <label class="field-label">&nbsp;</label>
                                    <div class="filter-actions">
                                        <button type="submit" class="btn btn-primary">검색</button>
                                        <a class="btn" href="${ctx}/manager/facility/partner/list/${mgmtOfcNo}">초기화</a>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>

                <%-- 목록 패널 --%>
                <div class="panel panel-list">
                    <div class="panel-header">
                        <div style="display:flex;align-items:center;gap:8px;">
                            <h3 class="panel-title"><span class="material-symbols-rounded">handshake</span>협력업체 목록</h3>
                            <%-- 전체 건수 (페이지네이션과 무관, 서버에서 내려준 totalRecord 사용) --%>
                            <span class="list-count" id="partnerCount">${pageInfo.totalRecord}건</span>
                        </div>

                        <%-- ADMIN은 조회만 가능하므로 등록 버튼 숨김 --%>
                        <c:if test="${not isAdmin}">
                            <button type="button" class="btn btn-primary" data-action="openRegister">
                                <span class="material-symbols-rounded">add</span>업체 등록
                            </button>
                        </c:if>
                    </div>
                    <%-- 역순 번호 계산용 현재 페이지 기본값 --%>
                    <c:set var="currentPage" value="${empty pageInfo.currentPage ? 1 : pageInfo.currentPage}" />

                    <div class="table-wrap">
                        <table class="tbl">
                            <colgroup>
                                <%-- 번호 컬럼 추가로 관리 버튼이 밀리지 않도록 관리 컬럼 폭은 기존 수준으로 유지 --%>
                                <col style="width:4%">
                                <col style="width:7%">
                                <col style="width:9%">
                                <col style="width:12%">
                                <col style="width:9%">
                                <col style="width:13%">
                                <col style="width:6%">
                                <col style="width:8%">
                                <col style="width:8%">
                                <col style="width:6%">
                                <col style="width:18%">
                            </colgroup>
                            <thead>
                            <tr>
                                <th>번호</th>
                                <th>업체번호</th>
                                <th class="td-left">업체명</th>
                                <th class="td-left">업종</th>
                                <th>사업자번호</th>
                                <th class="td-left">담당자 / 연락처</th>
                                <th>계약건수</th>
                                <th>최근점검</th>
                                <th>최근검침</th>
                                <th>사용여부</th>
                                <th>관리</th>
                            </tr>
                            </thead>
                            <tbody id="partnerTbody">
                            <c:choose>
                                <c:when test="${empty partnerList}">
                                    <tr>
                                        <td colspan="11" class="empty-row">조회된 협력업체가 없습니다.</td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="partner" items="${partnerList}" varStatus="st">
                                        <tr class="partner-row"
                                            data-partner-no="${partner.partnerNo}"
                                            data-apt-cmplex-no="${partner.aptCmplexNo}"
                                            data-apt-cmplex-nm="${partner.aptCmplexNm}"
                                            data-partner-nm="${partner.partnerNm}"
                                            data-biz-ty-nm="${partner.bizTyNm}"
                                            data-bizrno="${partner.bizrno}"
                                            data-use-yn="${partner.useYn}"
                                            data-pic-nm="${partner.picNm}"
                                            data-pic-telno="${partner.picTelno}"
                                            data-pic-email="${partner.picEmail}"
                                            data-reg-dt="${partner.regDt}"
                                            data-utility-provider-no="${partner.utilityProviderNo}"
                                            data-meter-linked-yn="${empty partner.meterLinkedYn ? (empty partner.utilityProviderNo ? 'N' : 'Y') : partner.meterLinkedYn}"
                                            data-contract-cnt="${empty partner.contractCnt ? 0 : partner.contractCnt}"
                                            data-active-contract-cnt="${empty partner.activeContractCnt ? 0 : partner.activeContractCnt}"
                                            data-check-cnt="${empty partner.checkCnt ? 0 : partner.checkCnt}"
                                            data-meter-cnt="${empty partner.meterCnt ? 0 : partner.meterCnt}"
                                            data-complex-meter-cnt="${empty partner.complexMeterCnt ? 0 : partner.complexMeterCnt}"
                                            data-facility-meter-cnt="${empty partner.facilityMeterCnt ? 0 : partner.facilityMeterCnt}"
                                            data-recent-check-dt="${partner.recentCheckDt}"
                                            data-recent-meter-dt="${partner.recentMeterDt}"
                                            data-recent-complex-meter-dt="${partner.recentComplexMeterDt}"
                                            data-recent-facility-meter-dt="${partner.recentFacilityMeterDt}">
                                                <%-- 화면 표시용 역순 번호. 페이지네이션이 있으면 전체 건수 기준, 없으면 현재 목록 기준으로 계산 --%>
                                            <td class="mono">
                                                <c:choose>
                                                    <c:when test="${not empty pageInfo and not empty pageInfo.totalRecord}">
                                                        ${pageInfo.totalRecord - ((currentPage - 1) * pageInfo.screenSize + st.index)}
                                                    </c:when>
                                                    <c:otherwise>
                                                        ${fn:length(partnerList) - st.index}
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="partner-no">${partner.partnerNo}</td>
                                            <td class="td-left">${partner.partnerNm}</td>
                                            <td class="td-left">${partner.bizTyNm}</td>
                                            <td>${partner.bizrno}</td>
                                            <td class="td-left">
                                                <span class="pic-line">
                                                    <span class="pic-name">${empty partner.picNm ? '-' : partner.picNm}</span>
                                                    <c:if test="${not empty partner.picTelno}">
                                                        <span class="pic-sep">|</span>
                                                        <span class="pic-tel">${partner.picTelno}</span>
                                                    </c:if>
                                                </span>
                                            </td>
                                            <td>
                                                <span class="td-num <c:if test='${partner.contractCnt eq 0}'>zero</c:if>">
                                                        ${empty partner.contractCnt ? 0 : partner.contractCnt}
                                                </span>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty partner.recentCheckDt}">
                                                        ${partner.recentCheckDt}
                                                    </c:when>
                                                    <c:otherwise><span class="recent-date empty">없음</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty partner.recentMeterDt}">
                                                        ${partner.recentMeterDt}
                                                    </c:when>
                                                    <c:otherwise><span class="recent-date empty">없음</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <span class="badge ${partner.useYn eq 'Y' ? 'badge-active' : 'badge-inactive'}">
                                                        ${partner.useYn eq 'Y' ? '활성' : '비활성'}
                                                </span>
                                            </td>
                                            <td>
                                                <div class="row-actions">
                                                        <%-- 상세는 ADMIN도 가능 --%>
                                                    <button type="button" class="btn" data-action="detail">상세</button>

                                                        <%-- ADMIN은 등록/수정/상태변경 불가 --%>
                                                    <c:if test="${not isAdmin}">
                                                        <button type="button" class="btn btn-primary" data-action="edit">수정</button>

                                                        <%-- 사용중이면 비활성 버튼 --%>
                                                        <c:if test="${partner.useYn eq 'Y'}">
                                                            <button type="button" class="btn" data-action="deactivate">비활성</button>
                                                        </c:if>

                                                        <%-- 비활성이면 활성 버튼 --%>
                                                        <c:if test="${partner.useYn eq 'N'}">
                                                            <button type="button" class="btn btn-primary" data-action="activate">활성</button>
                                                        </c:if>
                                                    </c:if>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                            </tbody>
                        </table>
                    </div>

                    <%-- 페이지네이션 --%>
                    <c:set var="currentPage" value="${empty pageInfo.currentPage ? 1 : pageInfo.currentPage}" />
                    <c:set var="startPage"   value="${empty pageInfo.startPage   ? 1 : pageInfo.startPage}" />
                    <c:set var="endPage"     value="${empty pageInfo.endPage     ? 1 : pageInfo.endPage}" />
                    <c:set var="totalPage"   value="${empty pageInfo.totalPage   ? 1 : pageInfo.totalPage}" />
                    <c:set var="qs" value="bizTyNm=${searchVO.bizTyNm}&useYn=${searchVO.useYn}&contractYn=${searchVO.contractYn}&checkStartDt=${searchVO.checkStartDt}&checkEndDt=${searchVO.checkEndDt}&meterStartDt=${searchVO.meterStartDt}&meterEndDt=${searchVO.meterEndDt}&searchWord=${searchWord}" />
                    <div class="pagination-wrap">
                        <ul class="pagination">
                            <li class="page-item ${currentPage le 1 ? 'disabled' : ''}">
                                <a class="page-link" href="${ctx}/manager/facility/partner/list/${mgmtOfcNo}?page=${currentPage - 1}&${qs}">이전</a>
                            </li>
                            <c:forEach var="pageNo" begin="${startPage}" end="${endPage}">
                                <li class="page-item ${pageNo eq currentPage ? 'active' : ''}">
                                    <a class="page-link" href="${ctx}/manager/facility/partner/list/${mgmtOfcNo}?page=${pageNo}&${qs}">${pageNo}</a>
                                </li>
                            </c:forEach>
                            <li class="page-item ${currentPage ge totalPage ? 'disabled' : ''}">
                                <a class="page-link" href="${ctx}/manager/facility/partner/list/${mgmtOfcNo}?page=${currentPage + 1}&${qs}">다음</a>
                            </li>
                        </ul>
                    </div>
                </div>

                <%-- 등록/수정 모달 --%>
                <div class="modal-overlay" id="partnerFormModal">
                    <div class="modal modal-lg">
                        <div class="modal-header">
                            <h3 class="modal-title" id="partnerFormTitle">협력업체 등록</h3>
                            <button type="button" class="modal-close" data-action="closePartnerFormModal">
                                <span class="material-symbols-rounded">close</span>
                            </button>
                        </div>
                        <form id="partnerForm" method="post" action="${ctx}/manager/facility/partner/insert/${mgmtOfcNo}">
                            <sec:csrfInput/>
                            <div class="modal-body">
                                <input type="hidden" id="partnerNo" name="partnerNo">
                                <div class="form-section">
                                    <div class="form-section-title"><span class="material-symbols-rounded">store</span>업체 기본 정보</div>
                                    <div class="form-row cols-2">
                                        <div class="form-field">
                                            <label class="field-label">업체명 <span class="req">*</span></label>
                                            <input type="text" class="form-input" id="fPartnerNm" name="partnerNm" placeholder="예) 크로시티엘리베이터관리" required>
                                        </div>
                                        <div class="form-field">
                                            <label class="field-label">업종 <span class="req">*</span></label>
                                            <input type="text" class="form-input" id="fBizTyNm" name="bizTyNm" list="bizTypeDatalist" autocomplete="off" placeholder="예) 승강기 유지보수" required>
                                            <datalist id="bizTypeDatalist">
                                                <c:forEach var="biz" items="${bizTypeList}">
                                                    <option value="${biz}"></option>
                                                </c:forEach>
                                            </datalist>
                                            <div class="field-help">기존 업종명을 선택하거나 새 업종명을 직접 입력할 수 있습니다.</div>
                                        </div>
                                    </div>
                                    <div class="form-row cols-3">
                                        <div class="form-field">
                                            <label class="field-label">사업자등록번호 <span class="req">*</span></label>
                                            <input type="text" class="form-input" id="fBizrno" name="bizrno" maxlength="12" placeholder="예) 101-81-10001" required>
                                        </div>
                                        <div class="form-field">
                                            <label class="field-label">사용여부</label>
                                            <select class="form-select" id="fUseYn" name="useYn">
                                                <option value="Y">사용</option>
                                                <option value="N">비활성</option>
                                            </select>
                                        </div>
                                        <div class="form-field">
                                            <label class="field-label">단지</label>
                                            <input type="hidden" id="fAptCmplexNo" name="aptCmplexNo" value="${aptCmplexNo}">
                                            <input type="text" class="form-input" id="fAptCmplexDisplay" value="${aptCmplexNm}${not empty aptCmplexNm ? ' (' : ''}${aptCmplexNo}${not empty aptCmplexNm ? ')' : ''}" readonly>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-section">
                                    <div class="form-section-title"><span class="material-symbols-rounded">badge</span>담당자 정보</div>
                                    <div class="form-row cols-3">
                                        <div class="form-field">
                                            <label class="field-label">담당자명</label>
                                            <input type="text" class="form-input" id="fPicNm" name="picNm" placeholder="예) 김민수">
                                        </div>
                                        <div class="form-field">
                                            <label class="field-label">연락처</label>
                                            <input type="text" class="form-input" id="fPicTelno" name="picTelno" placeholder="예) 02-1111-1001 또는 010-1234-5678">
                                        </div>
                                        <div class="form-field">
                                            <label class="field-label">이메일</label>
                                            <input type="email" class="form-input" id="fPicEmail" name="picEmail" placeholder="예) partner@example.com">
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn" data-action="closePartnerFormModal">취소</button>
                                <button type="submit" class="btn btn-primary" id="partnerSaveBtn">저장</button>
                            </div>
                        </form>
                    </div>
                </div>

                <%-- 상세 모달 --%>
                <div class="modal-overlay" id="partnerDetailModal">
                    <div class="modal modal-lg">
                        <div class="modal-header">
                            <h3 class="modal-title">협력업체 상세</h3>
                            <button type="button" class="modal-close" data-action="closePartnerDetailModal">
                                <span class="material-symbols-rounded">close</span>
                            </button>
                        </div>
                        <div class="modal-body">
                            <div class="form-section">
                                <div class="form-section-title"><span class="material-symbols-rounded">store</span>업체 기본 정보</div>
                                <div class="info-grid">
                                    <div class="info-row">
                                        <div class="info-label">업체번호</div>
                                        <div class="info-value has-border partner-no" id="dPartnerNo">-</div>
                                        <div class="info-label">업체명</div>
                                        <div class="info-value" id="dPartnerNm">-</div>
                                    </div>
                                    <div class="info-row">
                                        <div class="info-label">업종</div>
                                        <div class="info-value has-border" id="dBizTyNm">-</div>
                                        <div class="info-label">사용여부</div>
                                        <div class="info-value" id="dUseYn">-</div>
                                    </div>
                                    <div class="info-row">
                                        <div class="info-label">사업자번호</div>
                                        <div class="info-value has-border" id="dBizrno">-</div>
                                        <div class="info-label">단지</div>
                                        <div class="info-value" id="dAptCmplexDisplay">-</div>
                                    </div>
                                </div>
                            </div>
                            <div class="form-section">
                                <div class="form-section-title"><span class="material-symbols-rounded">badge</span>담당자 정보</div>
                                <div class="info-grid">
                                    <div class="info-row">
                                        <div class="info-label">담당자</div>
                                        <div class="info-value has-border" id="dPicNm">-</div>
                                        <div class="info-label">연락처</div>
                                        <div class="info-value" id="dPicTelno">-</div>
                                    </div>
                                    <div class="info-row single">
                                        <div class="info-label">이메일</div>
                                        <div class="info-value" id="dPicEmail">-</div>
                                    </div>
                                </div>
                            </div>
                            <div class="form-section">
                                <div class="form-section-title"><span class="material-symbols-rounded">dashboard</span>연결 현황</div>
                                <div class="link-card-row">
                                    <a class="link-card" id="scContract" href="#">
                                        <div class="link-card-title"><span class="material-symbols-rounded">contract</span>계약</div>
                                        <div class="link-card-cnt" id="dContractCnt">-</div>
                                        <div class="link-card-sub" id="dActiveContractCnt">유효 계약 -</div>
                                        <div class="link-card-arrow" id="dContractAction">바로가기<span class="material-symbols-rounded">arrow_forward</span></div>
                                    </a>
                                    <a class="link-card" id="scCheck" href="#">
                                        <div class="link-card-title"><span class="material-symbols-rounded">fact_check</span>점검 이력</div>
                                        <div class="link-card-cnt" id="dCheckCnt">-</div>
                                        <div class="link-card-meta" id="dRecentCheckDt">최근점검 -</div>
                                        <div class="link-card-arrow" id="dCheckAction">바로가기<span class="material-symbols-rounded">arrow_forward</span></div>
                                    </a>
                                    <a class="link-card" id="scComplexMeter" href="#">
                                        <div class="link-card-title"><span class="material-symbols-rounded">apartment</span>단지검침</div>
                                        <div class="link-card-cnt" id="dComplexMeterCnt">-</div>
                                        <div class="link-card-meta" id="dRecentComplexMeterDt">최근검침 -</div>
                                        <div class="link-card-arrow" id="dComplexMeterAction">바로가기<span class="material-symbols-rounded">arrow_forward</span></div>
                                    </a>
                                    <a class="link-card" id="scFacilityMeter" href="#">
                                        <div class="link-card-title"><span class="material-symbols-rounded">electric_meter</span>시설검침</div>
                                        <div class="link-card-cnt" id="dFacilityMeterCnt">-</div>
                                        <div class="link-card-meta" id="dRecentFacilityMeterDt">최근검침 -</div>
                                        <div class="link-card-arrow" id="dFacilityMeterAction">바로가기<span class="material-symbols-rounded">arrow_forward</span></div>
                                    </a>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn" data-action="closePartnerDetailModal">닫기</button>

                            <%-- ADMIN은 상세 모달에서도 수정 진입 불가 --%>
                            <c:if test="${not isAdmin}">
                                <button type="button" class="btn btn-primary" id="detailEditBtn">수정</button>
                            </c:if>
                        </div>
                    </div>
                </div>

                <%-- 비활성화 확인 모달 --%>
                <div class="modal-overlay" id="deactivateModal">
                    <div class="modal modal-sm">
                        <div class="modal-header">
                            <h3 class="modal-title">협력업체 비활성화</h3>
                            <button type="button" class="modal-close" data-action="closeDeactivateModal">
                                <span class="material-symbols-rounded">close</span>
                            </button>
                        </div>
                        <div class="modal-body">
                            <div class="warn-box">
                                <span class="material-symbols-rounded">warning</span>
                                <div>
                                    <strong id="deactivateName">선택한 업체</strong>를 비활성화합니다.<br>
                                    기존 계약·점검·검침 기록은 삭제되지 않으며, 신규 선택 목록에서만 제외됩니다.
                                </div>
                            </div>
                            <input type="hidden" id="deactivatePartnerNo">

                            <%-- 비활성화 POST 전송 폼 --%>
                            <form id="deactivateForm" method="post" action="">
                                <sec:csrfInput/>
                                <input type="hidden" id="deactivateFormPartnerNo" name="partnerNo">
                            </form>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn" data-action="closeDeactivateModal">취소</button>
                            <button type="button" class="btn btn-danger" id="deactivateConfirmBtn">비활성화</button>
                        </div>
                    </div>
                </div>

            </div><!-- /partnerPage -->
        </main>
    </div>
</div>

<script src="${ctx}/js/manager/manager-common.js"></script>
<script>
    (function () {
        'use strict';
        var ctx       = '${ctx}';
        var mgmtOfcNo = '${mgmtOfcNo}';
        var selectedRow = null;
        var defaultAptDisplay = '${aptCmplexNm}${not empty aptCmplexNm ? " (" : ""}${aptCmplexNo}${not empty aptCmplexNm ? ")" : ""}';

        function el(id)     { return document.getElementById(id); }
        function safe(v)    { return (v === null || v === undefined || String(v).trim() === '') ? '-' : String(v).trim(); }
        function fill(id,v) { if (el(id)) el(id).textContent = safe(v); }
        function d(row)     { return row ? row.dataset : {}; }
        function openModal(id)  { if (window.openModal)  window.openModal(id);  else el(id).classList.add('open'); }
        function closeModal(id) { if (window.closeModal) window.closeModal(id); else el(id).classList.remove('open'); }
        function makeUrl(base, params) {
            var q = new URLSearchParams();
            Object.keys(params).forEach(function(k){ if(params[k]) q.append(k,params[k]); });
            return base + (q.toString() ? '?' + q.toString() : '');
        }

        // 전체 건수는 서버 렌더링값(${pageInfo.totalRecord})을 그대로 사용하므로 DOM 카운팅 미사용

        function openRegister() {
            selectedRow = null;
            el('partnerForm').reset();
            el('partnerNo').value = '';
            el('partnerForm').action = ctx + '/manager/facility/partner/insert/' + mgmtOfcNo;
            el('partnerFormTitle').textContent = '협력업체 등록';
            el('partnerSaveBtn').textContent   = '등록';
            el('fBizrno').readOnly = false;
            el('fAptCmplexNo').value = '${aptCmplexNo}';
            el('fAptCmplexDisplay').value = defaultAptDisplay;
            openModal('partnerFormModal');
        }

        function openEdit(row) {
            selectedRow = row;
            var data = d(row);
            el('partnerForm').action        = ctx + '/manager/facility/partner/update/' + mgmtOfcNo + '/' + encodeURIComponent(data.partnerNo || '');
            el('partnerFormTitle').textContent = '협력업체 수정';
            el('partnerSaveBtn').textContent   = '수정 저장';
            el('partnerNo').value    = data.partnerNo   || '';
            el('fPartnerNm').value   = data.partnerNm   || '';
            el('fBizTyNm').value     = data.bizTyNm     || '';
            el('fBizrno').value      = data.bizrno      || '';
            el('fBizrno').readOnly   = true;
            el('fUseYn').value       = data.useYn       || 'Y';
            el('fAptCmplexNo').value = data.aptCmplexNo || '';
            el('fAptCmplexDisplay').value = data.aptCmplexNm
                ? (data.aptCmplexNm + ' (' + (data.aptCmplexNo || '') + ')')
                : (data.aptCmplexNo || '');
            el('fPicNm').value       = data.picNm       || '';
            el('fPicTelno').value    = data.picTelno    || '';
            el('fPicEmail').value    = data.picEmail    || '';
            openModal('partnerFormModal');
        }

        function setLinkCard(cardId, actionId, enabled, href) {
            var card = el(cardId);
            var action = el(actionId);

            // 카드 상태 초기화
            card.classList.toggle('disabled', !enabled);
            card.href = enabled ? href : '#';
            card.setAttribute('aria-disabled', enabled ? 'false' : 'true');

            // 미등록 카드에서는 바로가기 문구 대신 상태 문구 표시
            if (action) {
                action.innerHTML = enabled
                    ? '바로가기<span class="material-symbols-rounded">arrow_forward</span>'
                    : '미등록';
            }
        }

        function openDetail(row) {
            selectedRow = row;
            var data = d(row);
            fill('dPartnerNo',   data.partnerNo);
            fill('dPartnerNm',   data.partnerNm);
            fill('dBizTyNm',     data.bizTyNm);
            fill('dUseYn',       data.useYn === 'Y' ? '활성' : '비활성');
            fill('dBizrno',      data.bizrno);
            var aptDisplay = data.aptCmplexNm
                ? data.aptCmplexNm + ' (' + (data.aptCmplexNo || '-') + ')'
                : data.aptCmplexNo;
            fill('dAptCmplexDisplay', aptDisplay);
            fill('dPicNm',       data.picNm);
            fill('dPicTelno',    data.picTelno);
            fill('dPicEmail',    data.picEmail);
            var contractCnt = Number(data.contractCnt || 0);
            var activeContractCnt = Number(data.activeContractCnt || 0);
            var checkCnt = Number(data.checkCnt || 0);
            var complexMeterCnt = Number(data.complexMeterCnt || 0);
            var facilityMeterCnt = Number(data.facilityMeterCnt || 0);

            // ***# 연결현황카드: 이력이 없으면 숨기지 않고 회색 미등록 카드로 표시함
            fill('dContractCnt', contractCnt > 0 ? '전체 ' + contractCnt + '건' : '미등록');
            fill('dActiveContractCnt', contractCnt > 0 ? '유효 계약 ' + activeContractCnt + '건' : '계약 이력 없음');
            fill('dCheckCnt', checkCnt > 0 ? '전체 ' + checkCnt + '건' : '미등록');
            fill('dRecentCheckDt', checkCnt > 0 && data.recentCheckDt ? '최근점검 ' + data.recentCheckDt : '점검 이력 없음');
            fill('dComplexMeterCnt', complexMeterCnt > 0 ? '전체 ' + complexMeterCnt + '건' : '미등록');
            fill('dRecentComplexMeterDt', complexMeterCnt > 0 && data.recentComplexMeterDt ? '최근검침 ' + data.recentComplexMeterDt : '단지검침 이력 없음');
            fill('dFacilityMeterCnt', facilityMeterCnt > 0 ? '전체 ' + facilityMeterCnt + '건' : '미등록');
            fill('dRecentFacilityMeterDt', facilityMeterCnt > 0 && data.recentFacilityMeterDt ? '최근검침 ' + data.recentFacilityMeterDt : '시설검침 이력 없음');

            setLinkCard('scContract', 'dContractAction', contractCnt > 0, makeUrl(ctx + '/manager/facility/contract/list/' + mgmtOfcNo, { partnerNo: data.partnerNo }));
            setLinkCard('scCheck', 'dCheckAction', checkCnt > 0, makeUrl(ctx + '/manager/checkHistory/' + mgmtOfcNo, { partnerNo: data.partnerNo }));
            // ***# 협력업체검침바로가기: 단지검침/시설검침 카드별로 검침 화면 탭을 분리함
            setLinkCard('scComplexMeter', 'dComplexMeterAction', complexMeterCnt > 0, makeUrl(ctx + '/manager/meter/hstry/' + mgmtOfcNo, { partnerNo: data.partnerNo, meterScope: 'COMPLEX' }));
            setLinkCard('scFacilityMeter', 'dFacilityMeterAction', facilityMeterCnt > 0, makeUrl(ctx + '/manager/meter/hstry/' + mgmtOfcNo, { partnerNo: data.partnerNo, meterScope: 'FACILITY' }));
            openModal('partnerDetailModal');
        }

        function openDeactivate(row) {
            selectedRow = row;
            var data = d(row);
            fill('deactivateName', data.partnerNm);
            el('deactivatePartnerNo').value = data.partnerNo || '';
            openModal('deactivateModal');
        }

        /* 협력업체 활성화 확인 */
        async function openActivate(row) {
            selectedRow = row;

            var data = d(row);

            if (!data.partnerNo) {
                return;
            }

            var activateConfirm = await showConfirm({
                title: '협력업체를 다시 활성화하시겠습니까?',
                confirmText: '활성화'
            });
            if (activateConfirm.isConfirmed) {
                var form = document.createElement('form');

                /* POST 전송 설정 */
                form.method = 'post';
                form.action = ctx + '/manager/facility/partner/activate/' + mgmtOfcNo;

                /* CSRF 값 세팅 */
                var csrfToken = document.querySelector('meta[name="_csrf"]');
                var csrfParam = document.querySelector('meta[name="_csrf_parameter"]');

                if (csrfToken && csrfParam) {
                    var csrfInput = document.createElement('input');
                    csrfInput.type = 'hidden';
                    csrfInput.name = csrfParam.content;
                    csrfInput.value = csrfToken.content;
                    form.appendChild(csrfInput);
                }

                /* 업체번호 세팅 */
                var partnerInput = document.createElement('input');
                partnerInput.type = 'hidden';
                partnerInput.name = 'partnerNo';
                partnerInput.value = data.partnerNo;
                form.appendChild(partnerInput);

                /* form 전송 */
                document.body.appendChild(form);
                form.submit();
            }
        }

        document.addEventListener('click', function(e) {
            var btn    = e.target.closest('[data-action]');
            if (!btn) return;
            var action = btn.getAttribute('data-action');
            var row    = btn.closest('.partner-row');
            if (action === 'openRegister')            openRegister();
            if (action === 'detail'     && row)       openDetail(row);
            if (action === 'edit'       && row)       openEdit(row);
            if (action === 'deactivate' && row)       openDeactivate(row);
            if (action === 'activate'   && row)       openActivate(row);
            if (action === 'closePartnerFormModal')   closeModal('partnerFormModal');
            if (action === 'closePartnerDetailModal') closeModal('partnerDetailModal');
            if (action === 'closeDeactivateModal')    closeModal('deactivateModal');
        });

        /* 상세 모달 수정 버튼 이벤트
         * - ADMIN 화면에서는 버튼이 렌더링되지 않으므로 null 확인 필요
         */
        if (el('detailEditBtn')) {
            el('detailEditBtn').addEventListener('click', function() {
                closeModal('partnerDetailModal');

                if (selectedRow) {
                    openEdit(selectedRow);
                }
            });
        }

        /* 협력업체 비활성화 확인 버튼 이벤트
         * - 버튼이 없을 수 있으므로 null 확인
         */
        if (el('deactivateConfirmBtn')) {
            el('deactivateConfirmBtn').addEventListener('click', async function() {
                /* 선택 업체번호 확인 */
                var partnerNo = el('deactivatePartnerNo').value;
                if (!partnerNo) return;

                /* 사용자 최종 확인 */
                var deactivateConfirm = await showConfirm({
                    title: '협력업체를 비활성화하시겠습니까?',
                    confirmText: '비활성화',
                    confirmColor: '#c0392b'
                });
                if (deactivateConfirm.isConfirmed) {
                    /* 비활성화 POST 전송 */
                    el('deactivateFormPartnerNo').value = partnerNo;
                    el('deactivateForm').action = ctx + '/manager/facility/partner/deactivate/' + encodeURIComponent(mgmtOfcNo);
                    el('deactivateForm').submit();
                }
            });
        }

    }());
</script>
</body>
</html>
