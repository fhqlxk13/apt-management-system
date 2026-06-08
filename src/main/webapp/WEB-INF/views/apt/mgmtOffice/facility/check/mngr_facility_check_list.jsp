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
    <title>시설 점검 이력</title>

    <sec:csrfMetaTags/>

    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet" />

    <link rel="stylesheet" href="${ctx}/css/office-layout.css">
    <link rel="stylesheet" href="${ctx}/css/manager/manager-common.css">

    <style>
        #facilityCheckPage { --accent:#2e5c38; --accent-hover:#1f4027; --accent-light:#e8f0ea; --surface:#fff; --surface-sub:#f8f9fb; --line:#d7dce2; --th-bg:#f0f2ef; --text-head:#1a2e1e; --text-sec:#4a5c4e; --text-ter:#8a9a8e; }
        #facilityCheckPage .page-title-block h2 { color:var(--text-head); font-size:19px; letter-spacing:-.5px; }
        #facilityCheckPage .page-title-block p { color:#6b7a6e; font-size:12px; }
        #facilityCheckPage .panel { border-radius:6px; border:1px solid var(--line); box-shadow:none; margin:0; background:#fff; }
        #facilityCheckPage .panel + .panel { margin-top:14px; }
        #facilityCheckPage .panel-header { display:flex; align-items:center; justify-content:space-between; padding:13px 16px; border-bottom:1px solid var(--line); background:#fff; border-radius:6px 6px 0 0; }
        #facilityCheckPage .panel-title { display:flex; align-items:center; gap:6px; margin:0; font-size:13px; font-weight:800; color:var(--text-head); }
        #facilityCheckPage .panel-title .material-symbols-rounded { font-size:17px; color:var(--accent); }
        #facilityCheckPage .panel-body { padding:14px 16px 16px; background:#fff; }
        #facilityCheckPage .filter-grid { display:grid; grid-template-columns:.8fr .8fr .8fr .8fr .9fr .9fr minmax(220px,1fr) auto; gap:8px 10px; align-items:end; }
        #facilityCheckPage .form-input, #facilityCheckPage .form-select { height:32px; font-size:12px; border:1px solid var(--line); background:#fff; border-radius:4px; padding:0 9px; width:100%; box-sizing:border-box; }
        #facilityCheckPage .form-input:focus, #facilityCheckPage .form-select:focus { border-color:var(--accent); box-shadow:0 0 0 2px rgba(46,92,56,.08); outline:none; }
        #facilityCheckPage .field-label { display:block; margin-bottom:5px; font-size:11px; font-weight:800; color:var(--text-sec); }

        #facilityCheckPage .status-card-row { display:grid; grid-template-columns:repeat(4, minmax(0, 1fr)); gap:10px; margin-bottom:14px; }
        #facilityCheckPage .status-card { display:flex; align-items:center; justify-content:space-between; min-height:72px; padding:13px 15px; border:1px solid var(--line); border-radius:6px; background:#fff; text-align:left; box-sizing:border-box; }
        #facilityCheckPage .status-card.danger { border-color:#f1c7c7; background:#fffafa; }
        #facilityCheckPage .status-card .card-label { display:flex; align-items:center; gap:6px; color:var(--text-sec); font-size:12px; font-weight:800; }
        #facilityCheckPage .status-card .card-label .material-symbols-rounded { font-size:18px; color:var(--accent); }
        #facilityCheckPage .status-card.danger .card-label .material-symbols-rounded { color:#dc2626; }
        #facilityCheckPage .status-card strong { color:var(--text-head); font-size:23px; font-weight:800; line-height:1; }
        #facilityCheckPage .search-wrap { position:relative; width:100%; }
        #facilityCheckPage .search-wrap .material-symbols-rounded { position:absolute; left:9px; top:50%; transform:translateY(-50%); font-size:15px; color:#9caa9e; pointer-events:none; }
        #facilityCheckPage .search-wrap input { padding-left:30px; }
        #facilityCheckPage .filter-actions { display:flex; justify-content:flex-end; gap:7px; white-space:nowrap; }
        #facilityCheckPage .btn { display:inline-flex; align-items:center; justify-content:center; gap:4px; min-height:32px; height:32px; padding:0 11px; border-radius:4px; border:1px solid var(--line); background:#fff; color:#39443d; font-size:12px; font-weight:700; cursor:pointer; text-decoration:none; box-sizing:border-box; }
        #facilityCheckPage .btn:hover { background:#f4f7f4; }
        #facilityCheckPage .btn-primary { background:var(--accent); border-color:var(--accent); color:#fff; }
        #facilityCheckPage .btn-primary:hover { background:var(--accent-hover); border-color:var(--accent-hover); }
        #facilityCheckPage .btn-secondary { background:#fff; color:#39443d; }
        #facilityCheckPage .list-count { font-size:12px; font-weight:800; color:var(--accent); background:var(--accent-light); border-radius:4px; padding:3px 9px; white-space:nowrap; }
        #facilityCheckPage .table-wrap { overflow:hidden; border-radius:0 0 6px 6px; }
        #facilityCheckPage .tbl { width:100%; border-collapse:collapse; table-layout:fixed; }
        #facilityCheckPage .tbl th { height:38px; padding:0 8px; background:var(--th-bg); border-bottom:1px solid var(--line); color:var(--text-sec); font-size:12px; font-weight:800; text-align:center; }
        #facilityCheckPage .tbl td { height:43px; padding:6px 8px; border-bottom:1px solid #eef1f3; color:#243027; font-size:12px; text-align:center; vertical-align:middle; }
        #facilityCheckPage .tbl tr:hover td { background:#f8fbf8; }
        #facilityCheckPage .tbl .td-left { text-align:left; }
        #facilityCheckPage .tbl .mono { font-family:'Consolas','SF Mono',monospace; font-size:11px; color:#66736a; }
        #facilityCheckPage .empty-row { height:90px; color:#8a9a8e; }
        #facilityCheckPage .badge { display:inline-flex; align-items:center; justify-content:center; min-height:20px; padding:0 7px; border-radius:4px; font-size:11px; font-weight:700; border:1px solid transparent; white-space:nowrap; }
        #facilityCheckPage .badge-wait { background:#f3f4f6; color:#4b5563; border-color:#d1d5db; }
        #facilityCheckPage .badge-ing { background:#dbeafe; color:#1e3a5f; border-color:#93c5fd; }
        #facilityCheckPage .badge-done { background:#e8f1eb; color:#1f5a35; border-color:#bdd7c5; }
        #facilityCheckPage .badge-fault { background:#fee2e2; color:#7f1d1d; border-color:#fca5a5; }
        #facilityCheckPage .row-actions { display:inline-flex; gap:5px; align-items:center; justify-content:center; }
        #facilityCheckPage .row-actions .btn { min-width:48px; height:28px; min-height:28px; padding:0 9px; font-size:11px; }
        #facilityCheckPage .status-card-restrict .card-value { display:inline-flex; flex-direction:column; align-items:flex-end; gap:4px; }
        #facilityCheckPage .status-card-restrict .card-sub { font-size:11px; font-weight:700; line-height:1; white-space:nowrap; }
        #facilityCheckPage .status-card-restrict.danger .card-sub { color:#7f1d1d; }
        #facilityCheckPage .status-card-restrict:not(.danger) .card-sub { color:var(--text-ter); }
        /* [추가] 카드 항상 클릭 가능(0건이어도 모달 오픈). 0건은 연한 회색 hover, 1건 이상은 연한 빨간 hover */
        #facilityCheckPage .status-card-restrict { cursor:pointer; transition:background .15s; }
        #facilityCheckPage .status-card-restrict.danger:hover { background:#fff5f5; }
        #facilityCheckPage .status-card-restrict:not(.danger):hover { background:#f4f7f4; }
        #facilityCheckPage .badge-restrict { background:#fee2e2; color:#7f1d1d; border-color:#fca5a5; }
        #facilityCheckPage .badge-restrict-wait { background:#fff7ed; color:#9a3412; border-color:#fed7aa; }
        #facilityCheckPage .badge-restrict-done { background:#f3f4f6; color:#4b5563; border-color:#d1d5db; }
        #todayRestrictModal { display:none; position:fixed; inset:0; z-index:1000; align-items:center; justify-content:center; padding:24px; background:rgba(15,23,42,.38); box-sizing:border-box; }
        #todayRestrictModal.open, #todayRestrictModal.is-open { display:flex; }
        #todayRestrictModal .modal { width:min(860px, calc(100vw - 64px)); max-height:82vh; overflow:hidden; background:#fff; border:1px solid #d7dce2; border-radius:8px; box-shadow:0 18px 45px rgba(15,23,42,.22); }
        #todayRestrictModal .modal-header { display:flex; align-items:center; justify-content:space-between; padding:16px 18px; border-bottom:1px solid #d7dce2; background:#fff; }
        #todayRestrictModal .modal-title { display:flex; align-items:center; gap:6px; margin:0; font-size:15px; font-weight:800; color:#1a2e1e; }
        #todayRestrictModal .modal-title .material-symbols-rounded { font-size:18px; color:#2e5c38; }
        #todayRestrictModal .modal-close { display:inline-flex; align-items:center; justify-content:center; width:30px; height:30px; border:0; border-radius:4px; background:#fff; cursor:pointer; color:#66736a; }
        #todayRestrictModal .modal-close:hover { background:#f3f5f4; }
        #todayRestrictModal .modal-body { max-height:calc(82vh - 64px); overflow:auto; padding:16px 18px 18px; background:#fff; }
        /* [추가] 모달 섹션 구조 - 오늘의 일정 현황 / 예정 일정 두 섹션 구분 */
        #todayRestrictModal .restrict-section + .restrict-section { margin-top:18px; }
        #todayRestrictModal .restrict-section-title { display:flex; align-items:center; gap:6px; margin:0 0 8px; font-size:13px; font-weight:800; color:#1a2e1e; }
        #todayRestrictModal .restrict-section-title .material-symbols-rounded { font-size:17px; color:#2e5c38; }
        #todayRestrictModal .restrict-section-count { color:#6b7a6e; font-size:11px; font-weight:700; margin-left:auto; }
        #todayRestrictModal .today-restrict-empty { padding:22px 10px; border:1px dashed #d7dce2; border-radius:5px; color:#8a9a8e; font-size:12px; text-align:center; }
        #todayRestrictModal .today-restrict-modal-list { display:grid; gap:8px; }
        #todayRestrictModal .today-restrict-modal-item { display:grid; grid-template-columns:76px minmax(0, 1fr) 58px; gap:12px; align-items:center; padding:12px 14px; border:1px solid #d7dce2; border-radius:6px; background:#fff; font-size:12px; }
        #todayRestrictModal .today-restrict-modal-item:hover { background:#f8fbf8; }
        #todayRestrictModal .today-restrict-modal-main { display:grid; grid-template-columns:150px 1fr; gap:4px 12px; min-width:0; align-items:center; }
        #todayRestrictModal .today-restrict-modal-main strong { color:#111827; font-size:13px; font-weight:800; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
        #todayRestrictModal .today-restrict-time { color:#243027; font-weight:700; white-space:nowrap; }
        #todayRestrictModal .today-restrict-content { grid-column:1 / -1; color:#4b5563; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
        #todayRestrictModal .badge { display:inline-flex; align-items:center; justify-content:center; min-height:20px; padding:0 7px; border-radius:4px; font-size:11px; font-weight:700; border:1px solid transparent; white-space:nowrap; }
        #todayRestrictModal .badge-restrict { background:#fee2e2; color:#7f1d1d; border-color:#fca5a5; }
        #todayRestrictModal .badge-restrict-wait { background:#fff7ed; color:#9a3412; border-color:#fed7aa; }
        #todayRestrictModal .badge-restrict-done { background:#f3f4f6; color:#4b5563; border-color:#d1d5db; }
        #todayRestrictModal .btn { display:inline-flex; align-items:center; justify-content:center; min-height:28px; height:28px; padding:0 9px; border-radius:4px; border:1px solid #d7dce2; background:#fff; color:#39443d; font-size:11px; font-weight:700; cursor:pointer; text-decoration:none; box-sizing:border-box; }
        #todayRestrictModal .btn:hover { background:#f4f7f4; }
        #facilityCheckPage .pagination-wrap { display:flex; justify-content:center; padding:14px 16px; }
        #facilityCheckPage .pagination { display:flex; gap:4px; list-style:none; margin:0; padding:0; }
        #facilityCheckPage .page-item .page-link { display:inline-flex; align-items:center; justify-content:center; min-width:30px; height:30px; padding:0 8px; border:1px solid var(--line); border-radius:4px; color:#4a5c4e; background:#fff; font-size:12px; font-weight:700; text-decoration:none; }
        #facilityCheckPage .page-item.active .page-link { background:var(--accent); border-color:var(--accent); color:#fff; }
        #facilityCheckPage .page-item.disabled .page-link { color:#b6c0b9; }
        @media (max-width:1100px) { #facilityCheckPage .filter-grid { grid-template-columns:1fr 1fr 1fr; } #facilityCheckPage .status-card-row { grid-template-columns:repeat(2, minmax(0, 1fr)); } }
        @media (max-width:760px) { #facilityCheckPage .filter-grid { grid-template-columns:1fr; } #facilityCheckPage .status-card-row { grid-template-columns:1fr; } #facilityCheckPage .panel-header { flex-direction:column; align-items:flex-start; gap:8px; } }
    </style>
</head>
<body>
<div class="app-wrapper">
    <%@ include file="/WEB-INF/views/include/office_sidebar.jsp" %>

    <div class="main-wrap">
        <%@ include file="/WEB-INF/views/include/office_header.jsp" %>
        <c:set var="activeSidebarHref" value="${ctx}/manager/checkHistory/${mgmtOfcNo}" />
        <c:set var="activeSidebarParent" value="시설·공사 관리" />
        <c:set var="activeSidebarCurrent" value="시설 점검 이력" />
        <%@ include file="/WEB-INF/views/include/office_active_sidebar.jspf" %>

        <main class="main-content">
            <div class="office-page" id="facilityCheckPage">
                <div class="page-header">
                    <div class="page-title-block">
                        <h2>시설 점검 이력</h2>
                        <p>시설별 점검일자, 점검유형, 점검상태, 협력업체 정보를 관리합니다.</p>
                    </div>
                    <div class="page-actions"></div>
                </div>

                <c:set var="restrictOngoingCnt" value="0" />
                <c:set var="restrictUpcomingCnt" value="0" />
                <c:forEach var="restrict" items="${todayUseRestrictList}">
                    <c:if test="${restrict.useRestrictStatusCd eq 'ONGOING'}"><c:set var="restrictOngoingCnt" value="${restrictOngoingCnt + 1}" /></c:if>
                    <c:if test="${restrict.useRestrictStatusCd eq 'UPCOMING'}"><c:set var="restrictUpcomingCnt" value="${restrictUpcomingCnt + 1}" /></c:if>
                </c:forEach>

                <%-- 현황 카드 - 오늘 이용제한 카드는 1건 이상일 때 클릭하면 상세 모달이 열립니다 --%>
                <div class="status-card-row" aria-label="시설 점검 이력 현황">
                    <div class="status-card">
                        <span class="card-label"><span class="material-symbols-rounded">list_alt</span>전체 이력</span>
                        <strong><c:out value="${summary.totalCnt}" default="0"/></strong>
                    </div>
                    <div class="status-card">
                        <span class="card-label"><span class="material-symbols-rounded">schedule</span>점검대기</span>
                        <strong><c:out value="${summary.waitCnt}" default="0"/></strong>
                    </div>
                    <div class="status-card">
                        <span class="card-label"><span class="material-symbols-rounded">engineering</span>점검중</span>
                        <strong><c:out value="${summary.ingCnt}" default="0"/></strong>
                    </div>
                    <%-- 카드는 항상 클릭 가능(0건이어도 모달 오픈해서 '예정 일정' 섹션 확인). 경고 톤(.danger)은 오늘 1건 이상일 때만 --%>
                    <div class="status-card ${empty todayUseRestrictList ? '' : 'danger'} status-card-restrict" id="openTodayRestrictModalBtn">
                        <span class="card-label"><span class="material-symbols-rounded">block</span>오늘 이용제한</span>
                        <span class="card-value">
                            <strong>${fn:length(todayUseRestrictList)}</strong>
                            <c:choose>
                                <c:when test="${empty todayUseRestrictList}">
                                    <span class="card-sub">제한 일정 없음</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="card-sub">제한중 ${restrictOngoingCnt} · 예정 ${restrictUpcomingCnt}</span>
                                </c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                </div>

                <div class="panel">
                    <div class="panel-header">
                        <h3 class="panel-title"><span class="material-symbols-rounded">manage_search</span>검색 조건</h3>
                    </div>
                    <div class="panel-body">
                        <form id="searchForm" method="get" action="${ctx}/manager/checkHistory/${mgmtOfcNo}">
                            <input type="hidden" name="page" id="page" value="${pagingVO.currentPage}">
                            <%-- 시설 상세 화면에서 넘어온 시설번호 필터 유지 --%>
                            <input type="hidden" name="facilityNo" value="${fn:escapeXml(searchVO.facilityNo)}">
                            <%-- 협력업체 상세 화면에서 넘어온 협력업체번호 필터 유지 --%>
                            <input type="hidden" name="partnerNo" value="${fn:escapeXml(searchVO.partnerNo)}">
                            <div class="filter-grid">
                                <div class="form-field">
                                    <label class="field-label">점검분류</label>
                                    <select class="form-select" name="chkCtgryCd">
                                        <option value="">전체</option>
                                        <c:forEach var="code" items="${checkCategoryList}">
                                            <option value="${code.codeNoCd}" ${searchVO.chkCtgryCd eq code.codeNoCd ? 'selected' : ''}>${code.codeName}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="form-field">
                                    <label class="field-label">작업유형</label>
                                    <select class="form-select" name="chkTyCd">
                                        <option value="">전체</option>
                                        <c:forEach var="code" items="${checkTypeList}">
                                            <option value="${code.codeNoCd}" ${searchVO.chkTyCd eq code.codeNoCd ? 'selected' : ''}>${code.codeName}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="form-field">
                                    <label class="field-label">점검상태</label>
                                    <select class="form-select" name="chkSttsCd" id="searchChkSttsCd">
                                        <option value="">전체</option>
                                        <c:forEach var="code" items="${checkStatusList}">
                                            <option value="${code.codeNoCd}" ${searchVO.chkSttsCd eq code.codeNoCd ? 'selected' : ''}>${code.codeName}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="form-field">
                                    <label class="field-label">이용제한</label>
                                    <select class="form-select" name="useRestrictStatusCd">
                                        <option value="" ${empty searchVO.useRestrictStatusCd ? 'selected' : ''}>전체</option>
                                        <option value="ONGOING" ${searchVO.useRestrictStatusCd eq 'ONGOING' ? 'selected' : ''}>제한중</option>
                                        <option value="UPCOMING" ${searchVO.useRestrictStatusCd eq 'UPCOMING' ? 'selected' : ''}>제한예정</option>
                                        <option value="ENDED" ${searchVO.useRestrictStatusCd eq 'ENDED' ? 'selected' : ''}>제한종료</option>
                                        <option value="NONE" ${searchVO.useRestrictStatusCd eq 'NONE' ? 'selected' : ''}>제한없음</option>
                                    </select>
                                </div>
                                <div class="form-field">
                                    <label class="field-label">점검일자 시작</label>
                                    <input type="date" class="form-input" name="chkStartDt" value="${searchVO.chkStartDt}">
                                </div>
                                <div class="form-field">
                                    <label class="field-label">점검일자 종료</label>
                                    <input type="date" class="form-input" name="chkEndDt" value="${searchVO.chkEndDt}">
                                </div>
                                <div class="form-field">
                                    <label class="field-label">통합검색</label>
                                    <div class="search-wrap">
                                        <span class="material-symbols-rounded">search</span>
                                        <input type="text" class="form-input" name="searchWord" value="${fn:escapeXml(pagingVO.searchWord)}" placeholder="이력번호, 처리과정번호, 시설번호, 시설명, 협력업체명 검색">
                                    </div>
                                </div>
                                <div class="form-field">
                                    <label class="field-label">&nbsp;</label>
                                    <div class="filter-actions">
                                        <a href="${ctx}/manager/checkHistory/${mgmtOfcNo}" class="btn btn-secondary">초기화</a>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>

                <div class="panel">
                    <div class="panel-header">
                        <div style="display:flex;align-items:center;gap:8px;">
                            <h3 class="panel-title"><span class="material-symbols-rounded">fact_check</span>시설 점검 이력 목록</h3>
                            <span class="list-count">
                                ${pagingVO.totalRecord}건
                                <c:if test="${pagingVO.totalRecord ne summary.totalCnt}">
                                    / 전체 ${summary.totalCnt}건
                                </c:if>
                            </span>
                        </div>
                        <sec:authorize access="!hasRole('ADMIN')">
                            <a href="${ctx}/manager/checkHistory/register/${mgmtOfcNo}" class="btn btn-primary">
                                <span class="material-symbols-rounded">add</span>점검 이력 등록
                            </a>
                        </sec:authorize>
                    </div>
                    <div class="table-wrap">
                        <table class="tbl">
                            <colgroup>
                                <col style="width:6%;">
                                <col style="width:12%;">
                                <col style="width:11%;">
                                <col style="width:15%;">
                                <col style="width:10%;">
                                <col style="width:12%;">
                                <col style="width:8%;">
                                <col style="width:9%;">
                                <col style="width:8%;">
                                <col style="width:8%;">
                                <col style="width:8%;">
                                <col style="width:10%;">
                            </colgroup>
                            <thead>
                            <tr>
                                <th>번호</th>
                                <th>처리과정번호</th>
                                <th>점검이력번호</th>
                                <th>시설명</th>
                                <th>시설유형</th>
                                <th>협력업체</th>
                                <th>점검분류</th>
                                <th>작업유형</th>
                                <th>점검상태</th>
                                <th>작업일자</th>
                                <th>이용제한</th>
                                <th>관리</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:choose>
                                <c:when test="${empty pagingVO.dataList}">
                                    <tr>
                                        <td colspan="12" class="empty-row">조회된 시설 점검 이력이 없습니다.</td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="check" items="${pagingVO.dataList}" varStatus="status">
                                        <tr>
                                            <td>${pagingVO.totalRecord - ((pagingVO.currentPage - 1) * pagingVO.screenSize) - status.index}</td>
                                            <td class="mono">${empty check.chkFlowNo ? '-' : check.chkFlowNo}</td>
                                            <td class="mono">${check.facChkHstryNo}</td>
                                            <td class="td-left">${check.facilityNm}</td>
                                            <td>${check.facilityTyNm}</td>
                                            <td class="td-left">
                                                <c:choose>
                                                    <c:when test="${empty check.partnerNo}">자체점검</c:when>
                                                    <c:otherwise>${check.partnerNm}</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>${empty check.chkCtgryNm ? '-' : check.chkCtgryNm}</td>
                                            <td>${check.chkTyNm}</td>
                                            <td>
                                                <span class="badge ${check.chkSttsCd eq 'WAIT' ? 'badge-wait' : check.chkSttsCd eq 'ING' ? 'badge-ing' : check.chkSttsCd eq 'DONE' ? 'badge-done' : check.chkSttsCd eq 'FAULT' ? 'badge-fault' : 'badge-wait'}">
                                                        ${check.chkSttsNm}
                                                </span>
                                            </td>
                                            <td>${check.chkDt}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${check.useRestrictStatusCd eq 'ONGOING'}"><span class="badge badge-restrict">제한중</span></c:when>
                                                    <c:when test="${check.useRestrictStatusCd eq 'UPCOMING'}"><span class="badge badge-restrict-wait">예정</span></c:when>
                                                    <c:when test="${check.useRestrictStatusCd eq 'ENDED'}"><span class="badge badge-wait">종료</span></c:when>
                                                    <c:otherwise><span class="badge badge-done">없음</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <div class="row-actions">
                                                    <a class="btn" href="${ctx}/manager/checkHistory/detail/${mgmtOfcNo}/${check.facChkHstryNo}">상세</a>

                                                        <%-- ADMIN은 조회 전용이므로 수정 버튼 숨김 --%>
                                                    <sec:authorize access="!hasRole('ADMIN')">
                                                        <a class="btn btn-primary" href="${ctx}/manager/checkHistory/update/${mgmtOfcNo}/${check.facChkHstryNo}">수정</a>
                                                    </sec:authorize>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                            </tbody>
                        </table>
                    </div>
                    <div class="pagination-wrap">
                        ${pagingVO.pagingHTML}
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<div class="modal-overlay" id="todayRestrictModal">
    <div class="modal">
        <div class="modal-header">
            <h3 class="modal-title"><span class="material-symbols-rounded">block</span>오늘의 이용제한</h3>
            <button type="button" class="modal-close" data-modal-close>
                <span class="material-symbols-rounded">close</span>
            </button>
        </div>
        <div class="modal-body">
            <%-- [추가] 섹션1: 오늘의 일정 현황 (오늘 안에 시작/진행 중인 이용제한) --%>
            <section class="restrict-section">
                <h4 class="restrict-section-title">
                    <span class="material-symbols-rounded">today</span>오늘의 일정 현황
                    <span class="restrict-section-count">${fn:length(todayUseRestrictList)}건</span>
                </h4>
                <c:choose>
                    <c:when test="${empty todayUseRestrictList}">
                        <div class="today-restrict-empty">오늘 일정 없음</div>
                    </c:when>
                    <c:otherwise>
                        <div class="today-restrict-modal-list">
                            <c:forEach var="restrict" items="${todayUseRestrictList}">
                                <div class="today-restrict-modal-item">
                                    <c:choose>
                                        <c:when test="${restrict.useRestrictStatusCd eq 'ONGOING'}"><span class="badge badge-restrict">제한중</span></c:when>
                                        <c:when test="${restrict.useRestrictStatusCd eq 'UPCOMING'}"><span class="badge badge-restrict-wait">예정</span></c:when>
                                        <c:otherwise><span class="badge badge-restrict-done">종료</span></c:otherwise>
                                    </c:choose>
                                    <div class="today-restrict-modal-main">
                                        <strong>${restrict.facilityNm}</strong>
                                        <span class="today-restrict-time">${fn:replace(restrict.useRestrictBgngDt, 'T', ' ')} ~ ${fn:replace(restrict.useRestrictEndDt, 'T', ' ')}</span>
                                        <span class="today-restrict-content">${empty restrict.chkCn ? '-' : restrict.chkCn}</span>
                                    </div>
                                    <a class="btn" href="${ctx}/manager/checkHistory/detail/${mgmtOfcNo}/${restrict.facChkHstryNo}">상세</a>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </section>

            <%-- [추가] 섹션2: 예정 일정 (내일 이후 시작 예정인 이용제한) --%>
            <section class="restrict-section">
                <h4 class="restrict-section-title">
                    <span class="material-symbols-rounded">event_upcoming</span>예정 일정
                    <span class="restrict-section-count">${fn:length(futureUseRestrictList)}건</span>
                </h4>
                <c:choose>
                    <c:when test="${empty futureUseRestrictList}">
                        <div class="today-restrict-empty">예정 일정 없음</div>
                    </c:when>
                    <c:otherwise>
                        <div class="today-restrict-modal-list">
                            <c:forEach var="restrict" items="${futureUseRestrictList}">
                                <div class="today-restrict-modal-item">
                                    <span class="badge badge-restrict-wait">예정</span>
                                    <div class="today-restrict-modal-main">
                                        <strong>${restrict.facilityNm}</strong>
                                        <span class="today-restrict-time">${fn:replace(restrict.useRestrictBgngDt, 'T', ' ')} ~ ${fn:replace(restrict.useRestrictEndDt, 'T', ' ')}</span>
                                        <span class="today-restrict-content">${empty restrict.chkCn ? '-' : restrict.chkCn}</span>
                                    </div>
                                    <a class="btn" href="${ctx}/manager/checkHistory/detail/${mgmtOfcNo}/${restrict.facChkHstryNo}">상세</a>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </section>
        </div>
    </div>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        var searchForm = document.getElementById("searchForm");
        var pageInput = document.getElementById("page");
        var todayRestrictModal = document.getElementById("todayRestrictModal");
        var openTodayRestrictModalBtn = document.getElementById("openTodayRestrictModalBtn");

        /* 오늘의 이용제한 모달 열기 */
        if (openTodayRestrictModalBtn && todayRestrictModal) {
            openTodayRestrictModalBtn.addEventListener("click", function () {
                todayRestrictModal.classList.add("open");
            });
        }

        /* 모달 닫기 */
        document.querySelectorAll("[data-modal-close]").forEach(function (button) {
            button.addEventListener("click", function () {
                this.closest(".modal-overlay").classList.remove("open");
            });
        });

        /* 배경 클릭 시 모달 닫기 */
        if (todayRestrictModal) {
            todayRestrictModal.addEventListener("click", function (event) {
                if (event.target === todayRestrictModal) {
                    todayRestrictModal.classList.remove("open");
                }
            });
        }


        /* 검색 버튼 없이 조건 변경 또는 통합검색 Enter 시 조회 */
        if (searchForm) {
            searchForm.querySelectorAll("select, input[type='date']").forEach(function (field) {
                field.addEventListener("change", function () {
                    pageInput.value = "1";
                    searchForm.submit();
                });
            });
            var keywordInput = searchForm.querySelector("input[name='searchWord']");
            if (keywordInput) {
                keywordInput.addEventListener("keydown", function (event) {
                    if (event.key === "Enter") {
                        pageInput.value = "1";
                    }
                });
            }
        }

        /* 페이지 링크 클릭 시 검색 조건 유지 submit */
        document.querySelectorAll(".pagination .page-link[data-page]").forEach(function (link) {
            link.addEventListener("click", function (event) {
                event.preventDefault();
                pageInput.value = this.getAttribute("data-page");
                searchForm.submit();
            });
        });
    });
</script>
</body>
</html>
