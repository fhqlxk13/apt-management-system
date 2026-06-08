<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="isAdmin" value="false" />
<sec:authorize access="hasRole('ADMIN')"><c:set var="isAdmin" value="true" /></sec:authorize>
<c:set var="isUpdate" value="${formMode eq 'update'}" />
<c:set var="isFollow" value="${formMode eq 'follow'}" />
<c:set var="isLocked" value="${isAdmin or isUpdate or isFollow}" />
<c:set var="isOwnerLocked" value="${isAdmin or isUpdate}" />
<%-- update 모드 form action --%>
<c:set var="formAction" value="${ctx}/manager/checkHistory/register/${mgmtOfcNo}" />
<c:if test="${isUpdate}">
    <c:set var="formAction" value="${ctx}/manager/checkHistory/update/${mgmtOfcNo}/${check.facChkHstryNo}" />
</c:if>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${isUpdate ? '시설 이력 수정' : '시설 이력 새 등록'}</title>
    <sec:csrfMetaTags/>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet" />
    <link rel="stylesheet" href="${ctx}/css/office-layout.css">
    <link rel="stylesheet" href="${ctx}/css/manager/manager-common.css">
    <style>
        #fchPage {
            --acc:#2e5c38; --acc-h:#1f4027; --acc-l:#e8f0ea;
            --line:#d7dce2; --bg:#fff; --soft:#f8faf8;
            --th:#f4f6f4; --head:#1a2e1e; --sub:#6b7a6e; --muted:#9ca3af;
            font-family:'Noto Sans KR',sans-serif;
        }
        #fchPage .btn {
            display:inline-flex; align-items:center; justify-content:center;
            gap:4px; height:32px; padding:0 12px; border-radius:4px;
            border:1px solid var(--line); background:var(--bg); color:#39443d;
            font-size:12px; font-weight:700; cursor:pointer; text-decoration:none; box-sizing:border-box;
        }
        #fchPage .btn:hover { background:#f4f7f4; }
        #fchPage .btn-primary { background:var(--acc); border-color:var(--acc); color:#fff; }
        #fchPage .btn-primary:hover { background:var(--acc-h); border-color:var(--acc-h); }
        #fchPage .btn .material-symbols-rounded { font-size:15px; }
        #fchPage .panel { margin-bottom:14px; border:1px solid var(--line); border-radius:8px; background:var(--bg); overflow:hidden; }
        #fchPage .panel-body { padding:18px 22px; }
        #fchPage .section-title { display:flex; align-items:center; gap:6px; margin:0 0 14px; padding-bottom:10px; border-bottom:1px solid var(--line); color:var(--head); font-size:13px; font-weight:800; }
        #fchPage .section-title .material-symbols-rounded { font-size:17px; color:var(--acc); }
        #fchPage .title-sub { margin-left:auto; color:var(--muted); font-size:11px; font-weight:400; }

        /* 상단 대상 카드 */
        #fchPage .target-grid { display:grid; grid-template-columns:1fr 1fr; gap:14px; }
        #fchPage .target-card { border:1px solid var(--line); border-radius:6px; overflow:hidden; }
        #fchPage .target-head { display:flex; align-items:center; justify-content:space-between; min-height:38px; padding:0 12px; border-bottom:1px solid var(--line); background:var(--soft); }
        #fchPage .target-title { display:flex; align-items:center; gap:6px; color:var(--head); font-size:12px; font-weight:800; }
        #fchPage .target-title .material-symbols-rounded { font-size:16px; color:var(--acc); }
        #fchPage .target-fixed { color:#7a887d; font-size:11px; font-weight:700; }
        #fchPage .target-locked { display:flex; align-items:center; gap:3px; color:#9ca3af; font-size:11px; font-weight:700; }
        #fchPage .target-locked .material-symbols-rounded { font-size:13px; }
        #fchPage .target-body { padding:12px 14px; }
        #fchPage .empty-state { display:flex; flex-direction:column; align-items:center; justify-content:center; min-height:110px; padding:14px; border:1px dashed #cfd8d1; border-radius:5px; background:#fbfcfb; text-align:center; }
        #fchPage .empty-state .material-symbols-rounded { font-size:26px; color:#9aa8a0; margin-bottom:6px; }
        #fchPage .empty-state p { margin:0 0 10px; color:#6f7d72; font-size:12px; font-weight:700; }
        #fchPage .selected-state { min-height:110px; }
        #fchPage .selected-actions { display:flex; justify-content:flex-end; margin-top:10px; }
        #fchPage .owner-choice { display:flex; align-items:center; gap:8px; margin-bottom:10px; padding:8px 10px; border:1px solid var(--line); border-radius:5px; background:#fbfcfb; }
        #fchPage .owner-choice-label { color:#4a5c4e; font-size:11px; font-weight:800; white-space:nowrap; }
        #fchPage .owner-radio { display:inline-flex; align-items:center; gap:4px; color:#243027; font-size:12px; font-weight:700; cursor:pointer; }
        #fchPage .owner-radio input { margin:0; }
        #fchPage .self-check-box { display:flex; flex-direction:column; align-items:center; justify-content:center; min-height:110px; padding:14px; border:1px dashed #cfd8d1; border-radius:5px; background:#fbfcfb; text-align:center; }
        #fchPage .self-check-box .material-symbols-rounded { font-size:26px; color:#6f7d72; margin-bottom:6px; }
        #fchPage .self-check-box p { margin:0; color:#4a5c4e; font-size:12px; font-weight:800; }
        #fchPage .info-tbl { width:100%; border-collapse:collapse; table-layout:fixed; }
        #fchPage .info-tbl th { width:68px; height:34px; padding:0 8px; border-right:1px solid var(--line); border-bottom:1px solid var(--line); background:var(--th); color:#27382b; font-size:11px; font-weight:800; text-align:left; white-space:nowrap; }
        #fchPage .info-tbl td { height:34px; padding:0 10px; border-right:1px solid var(--line); border-bottom:1px solid var(--line); color:#111827; font-size:12px; font-weight:600; word-break:break-word; }
        #fchPage .info-tbl th:nth-child(3) { border-left:1px solid var(--line); }
        #fchPage .info-tbl td:last-child { border-right:none; }
        #fchPage .info-tbl tr:last-child th, #fchPage .info-tbl tr:last-child td { border-bottom:none; }

        /* 계약 선택 영역 */
        #fchPage .contract-select-wrap { margin-top:10px; padding:10px 12px; border:1px solid var(--line); border-radius:5px; background:#f8faf8; }
        #fchPage .contract-select-label { display:block; margin-bottom:5px; color:#4a5c4e; font-size:11px; font-weight:800; }
        #fchPage .contract-select-desc { color:#9ca3af; font-size:11px; font-weight:400; }
        #fchPage .contract-select { width:100%; height:34px; padding:0 9px; border:1px solid var(--line); border-radius:4px; background:#fff; color:#1f2d23; font-size:12px; box-sizing:border-box; }
        #fchPage .contract-select:focus { border-color:var(--acc); outline:none; box-shadow:0 0 0 2px rgba(46,92,56,.08); }
        #fchPage .contract-select:disabled { background:var(--soft); color:#6b7280; cursor:default; }

        /* 하단 2분할 */
        #fchPage .history-layout { display:grid; grid-template-columns:46% minmax(0,1fr); gap:16px; }
        #fchPage .list-area { border-right:1px solid var(--line); padding-right:16px; }
        #fchPage .area-title { display:flex; align-items:center; gap:5px; margin-bottom:8px; color:#4a5c4e; font-size:11px; font-weight:800; }
        #fchPage .area-title .material-symbols-rounded { font-size:15px; color:var(--acc); }

        /* 필터 한 줄 */
        #fchPage .history-filter { display:grid; grid-template-columns:.85fr 1fr .8fr .8fr .8fr minmax(140px,1fr) auto; gap:6px; align-items:end; margin-bottom:8px; padding:10px; border:1px solid var(--line); border-radius:6px; background:#fbfcfb; }
        #fchPage .history-filter>.f-field { min-width:0; }
        #fchPage .history-filter>.f-btns  { display:flex; gap:5px; }
        #fchPage .field-label { display:block; margin-bottom:4px; color:#4a5c4e; font-size:11px; font-weight:800; }
        #fchPage .form-select, #fchPage .form-input { width:100%; height:30px; padding:0 8px; border:1px solid var(--line); border-radius:4px; background:var(--bg); color:#1f2d23; font-size:12px; box-sizing:border-box; }
        #fchPage .form-select:focus, #fchPage .form-input:focus { border-color:var(--acc); outline:none; box-shadow:0 0 0 2px rgba(46,92,56,.08); }
        #fchPage .history-filter .btn { height:30px; }

        /* 이력 목록 */
        #fchPage .history-list { height:440px; overflow-y:auto; border:1px solid var(--line); border-radius:6px; background:var(--bg); padding:8px; box-sizing:border-box; }
        #fchPage .history-empty { display:flex; align-items:center; justify-content:center; min-height:100px; color:#7a887d; font-size:12px; font-weight:700; text-align:center; }
        #fchPage .history-item { display:grid; grid-template-columns:82px minmax(0,1fr); gap:8px; width:100%; margin-bottom:6px; padding:9px 10px; border:1px solid var(--line); border-radius:6px; background:var(--bg); color:inherit; text-align:left; font-family:inherit; cursor:pointer; box-sizing:border-box; }
        #fchPage .history-item:last-child { margin-bottom:0; }
        #fchPage .history-item:hover     { border-color:#bdd7c5; background:#f8fcf9; }
        #fchPage .history-item.is-active { border-color:var(--acc); background:var(--acc-l); }
        #fchPage .h-date    { color:#111827; font-size:12px; font-weight:800; line-height:1.4; }
        #fchPage .h-main    { min-width:0; }
        #fchPage .h-meta    { display:flex; align-items:center; gap:5px; margin-bottom:4px; }
        #fchPage .h-type    { color:#39443d; font-size:11px; font-weight:800; }
        #fchPage .h-partner { display:block; color:#6b7280; font-size:11px; margin-bottom:2px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }
        #fchPage .h-contract { display:block; color:#4b5563; font-size:11px; margin-bottom:2px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }
        #fchPage .h-flow    { display:block; color:#8a9a8e; font-size:10px; margin-bottom:2px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }
        #fchPage .h-cn      { display:block; color:#374151; font-size:11px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }
        #fchPage .badge { display:inline-flex; align-items:center; justify-content:center; min-height:18px; padding:0 6px; border-radius:3px; font-size:10px; font-weight:700; border:1px solid transparent; white-space:nowrap; }
        #fchPage .badge-wait  { background:#f3f4f6; color:#4b5563; border-color:#d1d5db; }
        #fchPage .badge-ing   { background:#dbeafe; color:#1e3a5f; border-color:#93c5fd; }
        #fchPage .badge-done  { background:#e8f1eb; color:#1f5a35; border-color:#bdd7c5; }
        #fchPage .badge-fault { background:#fee2e2; color:#7f1d1d; border-color:#fca5a5; }

        /* 오른쪽 공용 폼 */
        #fchPage .form-panel { border:1px solid var(--line); border-radius:6px; overflow:hidden; }
        #fchPage .form-panel-head { display:flex; align-items:center; min-height:40px; padding:0 14px; border-bottom:1px solid var(--line); background:var(--soft); }
        #fchPage .form-panel-title { display:flex; align-items:center; gap:6px; margin:0; color:var(--head); font-size:13px; font-weight:900; }
        #fchPage .form-panel-title .material-symbols-rounded { font-size:16px; color:var(--acc); }
        #fchPage .form-panel-body { padding:16px; }
        #fchPage .form-grid { display:grid; grid-template-columns:1fr 1fr; gap:10px 12px; }
        #fchPage .form-grid.form-grid-3 { grid-template-columns:repeat(3, minmax(0, 1fr)); }
        #fchPage .form-grid.form-grid-4 { grid-template-columns:1fr 1fr .8fr 1.3fr; }
        #fchPage .form-grid.restrict-grid { grid-template-columns:.65fr 1fr 1fr; }
        #fchPage .form-grid .full { grid-column:1 / -1; }
        #fchPage .form-label { display:block; margin-bottom:4px; color:#4a5c4e; font-size:11px; font-weight:800; }
        #fchPage .form-section-title { display:flex; align-items:center; gap:6px; margin:14px 0 8px; color:var(--head); font-size:12px; font-weight:900; }
        #fchPage .form-section-title:first-child { margin-top:0; }
        #fchPage .form-section-title:before { content:''; width:4px; height:12px; border-radius:4px; background:var(--acc); }
        #fchPage .required { color:#b91c1c; }
        #fchPage .form-field-input, #fchPage .form-field-select { width:100%; height:34px; padding:0 9px; border:1px solid var(--line); border-radius:4px; background:var(--bg); color:#1f2d23; font-size:12px; box-sizing:border-box; }
        #fchPage .form-field-input:focus, #fchPage .form-field-select:focus { border-color:var(--acc); outline:none; box-shadow:0 0 0 2px rgba(46,92,56,.08); }
        #fchPage .form-field-input[readonly], #fchPage .form-field-select[disabled], #fchPage .form-field-input[disabled] { background:var(--soft); color:#6b7280; cursor:default; }
        /* 작업유형 자동완성 */
        #fchPage .type-autocomplete { position:relative; }
        #fchPage .type-dropdown { position:absolute; left:0; right:0; top:calc(100% + 3px); z-index:20; max-height:170px; overflow-y:auto; border:1px solid var(--line); border-radius:4px; background:#fff; box-shadow:0 10px 24px rgba(15,23,42,.14); }
        #fchPage .type-option { width:100%; min-height:31px; padding:0 10px; border:0; border-bottom:1px solid #eef1f3; background:#fff; color:#1f2d23; font-size:12px; font-weight:700; text-align:left; cursor:pointer; font-family:'Noto Sans KR',sans-serif; }
        #fchPage .type-option { display:flex; align-items:center; justify-content:space-between; gap:8px; }
        #fchPage .type-option-ctgry { flex:0 0 auto; color:#7a887d; font-size:10px; font-weight:800; }
        #fchPage .type-option:last-child { border-bottom:none; }
        #fchPage .type-option:hover { background:#f8fcf9; color:var(--acc); }
        #fchPage .type-empty { padding:9px 10px; color:#8a9a8e; font-size:11px; text-align:center; }
        #fchPage .selected-history-summary { margin-bottom:10px; padding:10px 12px; border:1px solid var(--line); border-radius:5px; background:#fbfcfb; }
        #fchPage .form-textarea { width:100%; padding:9px; border:1px solid var(--line); border-radius:4px; background:var(--bg); color:#1f2d23; font-size:12px; line-height:1.55; resize:vertical; box-sizing:border-box; min-height:96px; }
        #fchPage .form-textarea.work-content { min-height:122px; }
        #fchPage .form-textarea.short { min-height:70px; }
        #fchPage .form-textarea:focus { border-color:var(--acc); outline:none; box-shadow:0 0 0 2px rgba(46,92,56,.08); }
        #fchPage .form-textarea[readonly], #fchPage .form-textarea[disabled] { background:var(--soft); color:#6b7280; cursor:default; }
        #fchPage .readonly-box { height:34px; display:flex; align-items:center; padding:0 9px; border:1px solid var(--line); border-radius:4px; background:var(--soft); color:#6b7280; font-size:12px; box-sizing:border-box; }
        #fchPage .mono { font-family:'Consolas','SF Mono',monospace; font-size:11px; }
        #fchPage .form-action-bar { display:flex; justify-content:flex-end; align-items:center; gap:8px; margin-top:14px; }

        /* split 카드 */
        #fchPage .split-panel { border:1px solid var(--line); border-radius:6px; overflow:hidden; background:var(--bg); }
        #fchPage .split-head  { display:flex; align-items:center; justify-content:space-between; min-height:42px; padding:0 14px; border-bottom:1px solid var(--line); background:var(--soft); }
        #fchPage .split-title { display:flex; align-items:center; gap:6px; color:var(--head); font-size:13px; font-weight:800; }
        #fchPage .split-title .material-symbols-rounded { color:var(--acc); font-size:17px; }
        #fchPage .split-desc  { color:var(--muted); font-size:11px; }
        #fchPage .split-body  { padding:10px; }

        /* 유틸 */
        #fchPage .is-hidden { display:none !important; }
        #fchPage .ellipsis  { display:block; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }

        /* 모달 */
        #fchPage .modal-overlay { display:none; position:fixed; inset:0; z-index:1000; align-items:center; justify-content:center; padding:24px; background:rgba(15,23,42,.35); box-sizing:border-box; }
        #fchPage .modal-overlay.open, #fchPage .modal-overlay.is-open { display:flex; }
        #fchPage .modal { width:min(920px,96vw); max-height:84vh; display:flex; flex-direction:column; background:var(--bg); border:1px solid var(--line); border-radius:8px; box-shadow:0 18px 45px rgba(15,23,42,.25); overflow:hidden; }
        #fchPage .modal-header { display:flex; align-items:center; justify-content:space-between; padding:14px 16px; border-bottom:1px solid var(--line); }
        #fchPage .modal-title { margin:0; color:var(--head); font-size:14px; font-weight:900; }
        #fchPage .modal-close { border:0; background:transparent; cursor:pointer; color:#66736a; }
        #fchPage .modal-body { padding:14px 16px; overflow:hidden; }
        #fchPage .modal-filter-grid { display:grid; grid-template-columns:repeat(3,minmax(0,1fr)); gap:8px 10px; margin-bottom:10px; }
        #fchPage .modal-filter-grid .form-field.full { grid-column:1 / -1; }
        #fchPage .modal-filter-actions { display:flex; justify-content:flex-end; gap:6px; margin-bottom:10px; }
        #fchPage .modal-table-wrap { max-height:400px; overflow-y:auto; border:1px solid var(--line); border-radius:5px; }
        #fchPage .modal-table { width:100%; border-collapse:collapse; table-layout:fixed; }
        #fchPage .modal-table th { position:sticky; top:0; z-index:1; height:34px; padding:0 8px; background:var(--th); border-bottom:1px solid var(--line); color:#4a5c4e; font-size:12px; font-weight:800; text-align:center; }
        #fchPage .modal-table td { height:36px; padding:4px 8px; border-bottom:1px solid #eef1f3; font-size:12px; text-align:center; }
        #fchPage .modal-table .td-left { text-align:left; }

        @media(max-width:1100px) {
            #fchPage .target-grid, #fchPage .history-layout { grid-template-columns:1fr; }
            #fchPage .list-area { border-right:none; padding-right:0; }
        }
        @media(max-width:760px) {
            #fchPage .form-grid, #fchPage .form-grid.form-grid-3, #fchPage .form-grid.form-grid-4, #fchPage .form-grid.restrict-grid { grid-template-columns:1fr; }
            #fchPage .history-filter { grid-template-columns:1fr; }
        }
    </style>
</head>
<body>
<div class="app-wrapper">
    <%@ include file="/WEB-INF/views/include/office_sidebar.jsp" %>
    <div class="main-wrap">
        <%@ include file="/WEB-INF/views/include/office_header.jsp" %>
        <c:set var="activeSidebarHref"    value="${ctx}/manager/checkHistory/${mgmtOfcNo}" />
        <c:set var="activeSidebarParent"  value="시설·공사 관리" />
        <c:set var="activeSidebarCurrent" value="시설 이력" />
        <%@ include file="/WEB-INF/views/include/office_active_sidebar.jspf" %>

        <main class="main-content">
            <div class="office-page" id="fchPage">

                <div class="page-header">
                    <div class="page-title-block">
                        <h2>${isUpdate ? '시설 이력 수정' : isFollow ? '시설 이력 후속 등록' : '시설 이력 등록'}</h2>
                        <p>
                            <c:choose>
                                <c:when test="${isUpdate}">오정보 정정 목적의 수정입니다. 시설과 협력업체는 변경할 수 없습니다.</c:when>
                                <c:when test="${isFollow}">기준 이력과 같은 처리과정으로 후속 시설 이력을 등록합니다.</c:when>
                                <c:otherwise>시설을 선택하고 기존 이력을 확인하면서 새 시설 이력을 등록합니다.</c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                </div>

                <c:if test="${isAdmin}">
                    <div style="margin-bottom:12px;padding:10px 14px;border:1px solid #fca5a5;border-radius:6px;background:#fff5f5;color:#7f1d1d;font-size:12px;font-weight:700;">
                        <span class="material-symbols-rounded" style="vertical-align:middle;font-size:15px;">lock</span>
                        ADMIN 계정은 조회만 가능하며 저장은 제한됩니다.
                    </div>
                </c:if>

                <form id="checkForm" method="post" action="${formAction}">
                    <sec:csrfInput/>

                    <%-- 폼 전송 시 필요한 hidden 값들 --%>
                    <input type="hidden" id="facilityNo"   name="facilityNo"   value="${check.facilityNo}">
                    <input type="hidden" id="partnerNo"    name="partnerNo"    value="${check.partnerNo}">
                    <input type="hidden" id="chkFlowNo"    name="chkFlowNo"    value="${check.chkFlowNo}">
                    <input type="hidden" id="chkOwnerType" name="chkOwnerType" value="${empty check.chkOwnerType ? 'SELF' : check.chkOwnerType}">
                    <%-- 계약번호 hidden - 협력업체 선택 후 계약 select에서 선택한 값이 여기 저장됨 --%>
                    <input type="hidden" id="contNo"       name="contNo"       value="${check.contNo}">
                    <c:if test="${isUpdate}">
                        <input type="hidden" name="facChkHstryNo" value="${check.facChkHstryNo}">
                    </c:if>

                    <%-- ── 상단: 시설 / 협력업체 ── --%>
                    <div class="panel">
                        <div class="panel-body">
                            <div class="section-title">
                                <span class="material-symbols-rounded">apartment</span>대상 정보
                                <span class="title-sub">
                                    <c:choose>
                                        <c:when test="${isUpdate}">수정 모드에서는 시설과 점검 주체를 변경할 수 없습니다.</c:when>
                                        <c:when test="${isFollow}">후속 등록은 기준 이력의 시설과 처리과정을 유지합니다.</c:when>
                                        <c:otherwise>시설을 선택하고 점검 주체를 정합니다.</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                            <div class="target-grid">

                                <%-- 시설 카드 --%>
                                <div class="target-card">
                                    <div class="target-head">
                                        <div class="target-title">
                                            <span class="material-symbols-rounded">domain</span>시설 정보
                                        </div>
                                        <c:choose>
                                            <c:when test="${isLocked}">
                                                <span class="target-locked">
                                                    <span class="material-symbols-rounded">lock</span>변경 불가
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="target-fixed">필수 선택</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="target-body">
                                        <%-- 시설 미선택 상태 (등록 모드이고 시설 없을 때만 표시) --%>
                                        <c:if test="${not isLocked}">
                                            <div id="facilityEmptyState" class="empty-state ${empty check.facilityNo ? '' : 'is-hidden'}">
                                                <span class="material-symbols-rounded">apartment</span>
                                                <p>시설 이력을 등록할 시설을 선택하세요.</p>
                                                <button type="button" class="btn btn-primary" id="openFacilityModalBtn">
                                                    <span class="material-symbols-rounded">link</span>시설 선택
                                                </button>
                                            </div>
                                        </c:if>
                                        <%-- 시설 선택 완료 상태 --%>
                                        <div id="facilitySelectedState" class="${(not isLocked and empty check.facilityNo) ? 'selected-state is-hidden' : 'selected-state'}">
                                            <table class="info-tbl">
                                                <tr>
                                                    <th>시설명</th>
                                                    <td><span id="facilityNmText">${empty check.facilityNm ? '-' : check.facilityNm}</span></td>
                                                    <th>시설번호</th>
                                                    <td><span id="facilityNoText" class="mono">${empty check.facilityNo ? '-' : check.facilityNo}</span></td>
                                                </tr>
                                                <tr>
                                                    <th>시설유형</th>
                                                    <td><span id="facilityTyText">${empty check.facilityTyNm ? '-' : check.facilityTyNm}</span></td>
                                                    <th>사용여부</th>
                                                    <td><span id="facilityUseYnText">${check.useYn eq 'Y' ? '사용' : empty check.useYn ? '-' : '미사용'}</span></td>
                                                </tr>
                                                <tr>
                                                    <th>위치</th>
                                                    <td><span id="facilityLocText" class="ellipsis">${empty check.locCn ? '-' : check.locCn}</span></td>
                                                    <th>설치일자</th>
                                                    <td><span id="facilityInstlDtText">${empty check.instlDt ? '-' : check.instlDt}</span></td>
                                                </tr>
                                            </table>
                                            <c:if test="${not isLocked}">
                                                <div class="selected-actions">
                                                    <button type="button" class="btn" id="reopenFacilityModalBtn">다시 선택</button>
                                                </div>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>

                                <%-- 점검 주체 / 협력업체 카드 --%>
                                <div class="target-card">
                                    <div class="target-head">
                                        <div class="target-title">
                                            <span class="material-symbols-rounded">handshake</span>점검 주체
                                        </div>
                                        <c:choose>
                                            <c:when test="${isOwnerLocked}">
                                                <span class="target-locked">
                                                    <span class="material-symbols-rounded">lock</span>변경 불가
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="target-fixed">자체점검 또는 협력업체 점검</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="target-body">
                                        <%-- 자체점검 / 협력업체점검 라디오 버튼 --%>
                                        <div class="owner-choice">
                                            <span class="owner-choice-label">점검 주체</span>
                                            <label class="owner-radio">
                                                <input type="radio" name="ownerTypeRadio" id="checkOwnerSelf" value="SELF" ${check.chkOwnerType ne 'PARTNER' ? 'checked' : ''} ${isLocked ? 'disabled' : ''}>
                                                자체점검
                                            </label>
                                            <label class="owner-radio">
                                                <input type="radio" name="ownerTypeRadio" id="checkOwnerPartner" value="PARTNER" ${check.chkOwnerType eq 'PARTNER' ? 'checked' : ''} ${isLocked ? 'disabled' : ''}>
                                                협력업체 점검
                                            </label>
                                        </div>

                                        <%-- 자체점검 선택 시 표시 --%>
                                        <div id="partnerSelfState" class="self-check-box ${check.chkOwnerType eq 'PARTNER' ? 'is-hidden' : ''}">
                                            <span class="material-symbols-rounded">engineering</span>
                                            <p>관리사무소 자체점검으로 등록됩니다.</p>
                                        </div>

                                        <%-- 협력업체 점검 선택 시 표시 --%>
                                        <div id="partnerChoiceState" class="${check.chkOwnerType eq 'PARTNER' ? '' : 'is-hidden'}">
                                            <%-- 협력업체 미선택 상태 --%>
                                            <c:if test="${not isOwnerLocked}">
                                                <div id="partnerEmptyState" class="empty-state ${empty check.partnerNo ? '' : 'is-hidden'}">
                                                    <span class="material-symbols-rounded">business_center</span>
                                                    <p>점검을 진행한 협력업체를 선택하세요.</p>
                                                    <button type="button" class="btn btn-primary" id="openPartnerModalBtn">
                                                        <span class="material-symbols-rounded">search</span>협력업체 선택
                                                    </button>
                                                </div>
                                            </c:if>

                                            <%-- 협력업체 선택 완료 상태 --%>
                                            <div id="partnerSelectedState" class="${(not isLocked and empty check.partnerNo) ? 'selected-state is-hidden' : 'selected-state'}">
                                                <table class="info-tbl">
                                                    <tr>
                                                        <th>업체명</th>
                                                        <td><span id="partnerNmText">${empty check.partnerNm ? '-' : check.partnerNm}</span></td>
                                                        <th>업체번호</th>
                                                        <td><span id="partnerNoText" class="mono">${empty check.partnerNo ? '-' : check.partnerNo}</span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>업종</th>
                                                        <td><span id="bizTyText" class="ellipsis">${empty check.bizTyNm ? '-' : check.bizTyNm}</span></td>
                                                        <th>담당자</th>
                                                        <td><span id="partnerPicNmText">${empty check.picNm ? '-' : check.picNm}</span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>연락처</th>
                                                        <td><span id="partnerPicTelText">${empty check.picTelno ? '-' : check.picTelno}</span></td>
                                                        <th>이메일</th>
                                                        <td><span id="partnerEmailText" class="ellipsis">${empty check.picEmail ? '-' : check.picEmail}</span></td>
                                                    </tr>
                                                </table>

                                                <%--
                                                    계약 선택 영역
                                                    - 협력업체 선택 후 해당 파트너의 진행중 계약 목록이 AJAX로 로드됨
                                                    - 선택한 계약번호는 hidden input(contNo)에 저장되어 폼과 함께 전송됨
                                                    - 계약 없이 점검하는 경우 "계약 없음" 선택 가능
                                                --%>
                                                <div class="contract-select-wrap" id="contractSelectWrap">
                                                    <label class="contract-select-label">
                                                        연결 계약
                                                        <span class="contract-select-desc">(해당 파트너의 진행중 계약 목록)</span>
                                                    </label>
                                                    <select class="contract-select" id="contNoSelect"
                                                            <c:if test="${isOwnerLocked}">disabled</c:if>>
                                                        <option value="">계약 없음 (계약 미연결 점검)</option>
                                                        <%--
                                                            수정 모드 진입 시 기존에 저장된 계약 표시
                                                            - check.contNo 가 있으면 해당 계약을 selected 상태로 표시
                                                        --%>
                                                        <c:if test="${not empty check.contNo}">
                                                            <option value="${check.contNo}" data-cont-ty-cd="" selected>
                                                                    ${empty check.contNm ? check.contNo : check.contNm}
                                                                <c:if test="${not empty check.contBgngDt}">
                                                                    (${check.contBgngDt} ~ ${empty check.contEndDt ? '진행중' : check.contEndDt})
                                                                </c:if>
                                                            </option>
                                                        </c:if>
                                                    </select>
                                                </div>

                                                <c:if test="${not isOwnerLocked}">
                                                    <div class="selected-actions">
                                                        <button type="button" class="btn" id="reopenPartnerModalBtn">다시 선택</button>
                                                    </div>
                                                </c:if>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                            </div><%-- /target-grid --%>
                        </div>
                    </div><%-- /상단 패널 --%>

                    <%-- ── 하단: 이력 목록 + 공용 폼 ── --%>
                    <div class="panel">
                        <div class="panel-body">
                            <div class="section-title">
                                <span class="material-symbols-rounded">fact_check</span>시설 이력
                                <span class="title-sub">
                                    <c:choose>
                                        <c:when test="${isUpdate}">수정할 이력을 선택하세요.</c:when>
                                        <c:otherwise>왼쪽 이력을 클릭하면 오른쪽에 상세가 표시됩니다.</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>

                            <div class="history-layout">

                                <%-- 왼쪽: 이력 목록 --%>
                                <div class="list-area">
                                    <div class="split-panel">
                                        <div class="split-head">
                                            <div class="split-title">
                                                <span class="material-symbols-rounded">history</span>같은 시설의 시설 이력
                                            </div>
                                            <span class="split-desc">간략 이력</span>
                                        </div>
                                        <div class="split-body">
                                            <div class="history-filter">
                                                <div class="f-field">
                                                    <label class="field-label" for="historyFilterChkCtgryCd">점검분류</label>
                                                    <select class="form-select" id="historyFilterChkCtgryCd">
                                                        <option value="">전체</option>
                                                        <c:forEach var="code" items="${checkCategoryList}">
                                                            <option value="${code.codeNoCd}">${code.codeName}</option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                                <div class="f-field">
                                                    <label class="field-label" for="historyFilterChkTyNmInput">작업유형</label>
                                                    <div class="type-autocomplete">
                                                        <input type="text" class="form-input" id="historyFilterChkTyNmInput" placeholder="전체 또는 작업유형 검색" autocomplete="off">
                                                        <input type="hidden" id="historyFilterChkTyCd" value="">
                                                        <div id="historyFilterChkTyDropdown" class="type-dropdown is-hidden"></div>
                                                    </div>
                                                </div>
                                                <div class="f-field">
                                                    <label class="field-label" for="historyFilterChkSttsCd">점검상태</label>
                                                    <select class="form-select" id="historyFilterChkSttsCd">
                                                        <option value="">전체</option>
                                                        <c:forEach var="code" items="${checkStatusList}">
                                                            <option value="${code.codeNoCd}">${code.codeName}</option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                                <div class="f-field">
                                                    <label class="field-label" for="historyFilterUseRestrictYn">이용제한</label>
                                                    <select class="form-select" id="historyFilterUseRestrictYn">
                                                        <option value="">전체</option>
                                                        <option value="Y">제한 있음</option>
                                                        <option value="N">제한 없음</option>
                                                    </select>
                                                </div>
                                                <div class="f-field">
                                                    <label class="field-label" for="historyFilterProcess">처리과정</label>
                                                    <select class="form-select" id="historyFilterProcess">
                                                        <option value="">전체</option>
                                                    </select>
                                                </div>
                                                <div class="f-field">
                                                    <label class="field-label" for="historyFilterKeyword">검색어</label>
                                                    <input type="text" class="form-input" id="historyFilterKeyword" placeholder="내용·업체명·처리과정번호">
                                                </div>
                                                <div class="f-btns">
                                                    <button type="button" class="btn" id="historyResetBtn">초기화</button>
                                                </div>
                                            </div>
                                            <div class="history-list" id="facilityHistoryList">
                                                <div class="history-empty">시설을 선택하면 기존 시설 이력이 표시됩니다.</div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <%-- 오른쪽: 등록/수정 폼 + 기존 이력 상세 --%>
                                <div class="form-panel">
                                    <div class="split-head">
                                        <div class="split-title">
                                            <span class="material-symbols-rounded">article</span>
                                            <span id="historyFormTitle">현재 점검 결과</span>
                                        </div>
                                    </div>
                                    <div class="form-panel-body">
                                        <%-- 기본 식별 정보 --%>
                                        <div class="form-section-title">기본 식별 정보</div>
                                        <div class="form-grid form-grid-3" style="margin-bottom:10px;">
                                            <div id="baseHistoryRow" class="is-hidden">
                                                <label class="form-label">기준이력번호</label>
                                                <div class="readonly-box mono" id="baseHistoryNoText">-</div>
                                            </div>
                                            <div>
                                                <label class="form-label">시설번호</label>
                                                <div class="readonly-box mono" id="formFacilityNoText">${empty check.facilityNo ? '-' : check.facilityNo}</div>
                                            </div>
                                            <div>
                                                <label class="form-label">처리과정번호</label>
                                                <div class="readonly-box mono" id="formChkFlowNoText">
                                                    <c:choose>
                                                        <c:when test="${empty check.chkFlowNo}">저장 시 자동 생성</c:when>
                                                        <c:otherwise>${check.chkFlowNo}</c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                            <div id="currentHistoryRow">
                                                <label class="form-label">이력번호</label>
                                                <div class="readonly-box mono" id="currentHistoryNoText">-</div>
                                            </div>
                                        </div>
                                        <%-- 선택한 기존 이력 요약 : 상세 확인 후 후속 등록할 기준 이력 표시 --%>
                                        <div id="selectedHistorySummary" class="selected-history-summary is-hidden">
                                            <div class="form-grid">
                                                <div>
                                                    <label class="form-label">선택 이력 주체</label>
                                                    <div class="readonly-box" id="historyOwnerText">-</div>
                                                </div>
                                                <div>
                                                    <label class="form-label">연결 계약</label>
                                                    <div class="readonly-box" id="historyContractText">-</div>
                                                </div>
                                            </div>
                                        </div>
                                        <%-- 점검 정보 --%>
                                        <div class="form-section-title">점검 정보</div>
                                        <div class="form-grid form-grid-4">
                                            <div>
                                                <label class="form-label" for="chkCtgryCd">점검분류 <span class="required">*</span></label>
                                                <select class="form-field-select" id="chkCtgryCd" name="chkCtgryCd" disabled>
                                                    <option value="">선택</option>
                                                    <c:forEach var="code" items="${checkCategoryList}">
                                                        <option value="${code.codeNoCd}" ${check.chkCtgryCd eq code.codeNoCd ? 'selected' : ''}>${code.codeName}</option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                            <div>
                                                <label class="form-label" for="chkTyNmInput">작업유형 <span class="required">*</span></label>
                                                <div class="type-autocomplete">
                                                    <input type="text" class="form-field-input" id="chkTyNmInput" value="" placeholder="작업유형 검색" autocomplete="off" readonly>
                                                    <input type="hidden" id="chkTyCd" name="chkTyCd" value="${check.chkTyCd}">
                                                    <div id="chkTyDropdown" class="type-dropdown is-hidden"></div>
                                                </div>
                                            </div>
                                            <div>
                                                <label class="form-label" for="chkSttsCd">점검상태 <span class="required">*</span></label>
                                                <select class="form-field-select" id="chkSttsCd" name="chkSttsCd" disabled>
                                                    <option value="">선택</option>
                                                    <c:forEach var="code" items="${checkStatusList}">
                                                        <option value="${code.codeNoCd}" ${check.chkSttsCd eq code.codeNoCd ? 'selected' : ''}>${code.codeName}</option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                            <div>
                                                <label class="form-label" for="chkDt">작업일자 <span class="required">*</span></label>
                                                <input type="date" class="form-field-input" id="chkDt" name="chkDt" value="${check.chkDt}" readonly>
                                            </div>
                                        </div>
                                        <%-- 이용제한 정보 --%>
                                        <div class="form-section-title">이용제한 정보</div>
                                        <div class="form-grid restrict-grid">
                                            <div>
                                                <label class="form-label" for="useRestrictYn">이용제한 여부</label>
                                                <select class="form-field-select" id="useRestrictYn" name="useRestrictYn" disabled>
                                                    <option value="N" ${empty check.useRestrictYn or check.useRestrictYn eq 'N' ? 'selected' : ''}>제한 없음</option>
                                                    <option value="Y" ${check.useRestrictYn eq 'Y' ? 'selected' : ''}>제한 있음</option>
                                                </select>
                                            </div>
                                            <div>
                                                <label class="form-label" for="useRestrictBgngDt">제한 시작일시</label>
                                                <input type="datetime-local" class="form-field-input" id="useRestrictBgngDt" name="useRestrictBgngDt" value="${check.useRestrictBgngDt}" readonly>
                                            </div>
                                            <div>
                                                <label class="form-label" for="useRestrictEndDt">제한 종료일시</label>
                                                <input type="datetime-local" class="form-field-input" id="useRestrictEndDt" name="useRestrictEndDt" value="${check.useRestrictEndDt}" readonly>
                                            </div>
                                        </div>
                                        <%-- 작업내용 및 비고 --%>
                                        <div class="form-section-title">상세 내용</div>
                                        <div class="form-grid">
                                            <div class="full">
                                                <label class="form-label" for="chkCn">작업내용 <span class="required">*</span></label>
                                                <textarea class="form-textarea work-content" id="chkCn" name="chkCn" readonly>${check.chkCn}</textarea>
                                            </div>
                                            <div class="full">
                                                <label class="form-label" for="rmk">비고</label>
                                                <textarea class="form-textarea short" id="rmk" name="rmk" readonly>${check.rmk}</textarea>
                                            </div>
                                        </div>
                                        <%-- 안내 메시지 --%>
                                        <div id="correctNotice" class="is-hidden" style="margin-top:10px;padding:9px 12px;border:1px solid #fca5a5;border-radius:5px;background:#fff5f5;color:#7f1d1d;font-size:11px;line-height:1.6;">
                                            <strong>오정보 정정 목적의 수정입니다.</strong><br>
                                            시설 이력은 수정하지 않는 것을 원칙으로 합니다.<br>
                                            잘못 입력된 정보를 정정하는 경우에만 사용하세요.
                                        </div>
                                        <div id="followNotice" class="is-hidden" style="margin-top:10px;padding:9px 12px;border:1px solid #bdd7c5;border-radius:5px;background:#f8fcf9;color:#2e5c38;font-size:11px;line-height:1.6;">
                                            <strong>후속 이력 등록 안내</strong><br>
                                            점검상태의 완료는 해당 이력 한 건의 완료를 의미합니다.<br>
                                            같은 처리과정에 대한 재점검, 보완 조치, 사후 확인은 후속 이력으로 계속 등록할 수 있습니다.
                                        </div>
                                        <%-- 버튼 바 --%>
                                        <div class="form-action-bar">
                                            <a class="btn" href="${ctx}/manager/checkHistory/${mgmtOfcNo}">목록</a>
                                            <button type="button" class="btn is-hidden" id="cancelFollowBtn">취소</button>
                                            <c:if test="${not isAdmin}">
                                                <button type="button" class="btn btn-primary is-hidden" id="openFollowBtn">
                                                    <span class="material-symbols-rounded">edit_note</span>후속 등록
                                                </button>
                                                <button type="button" class="btn is-hidden" id="openCorrectBtn">오정보 수정</button>
                                                <button type="submit" class="btn btn-primary is-hidden" id="saveHistoryBtn">저장</button>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>

                            </div><%-- /history-layout --%>
                        </div>
                    </div><%-- /하단 패널 --%>

                </form>

                <%-- 선택 모달 (등록 모드일 때만 포함) --%>
                <c:if test="${not isOwnerLocked}">
                    <%@ include file="/WEB-INF/views/apt/mgmtOffice/facility/check/facility_check_select_modal.jspf" %>
                </c:if>

            </div><%-- /fchPage --%>
        </main>
    </div>
</div>

<script src="${ctx}/js/manager/manager-common.js"></script>
<script>
    (function () {
        'use strict';

        /* ── 화면 기본 설정값 ── */
        var CTX       = '${ctx}';
        var OFC_NO    = '${mgmtOfcNo}';
        var IS_ADMIN  = ${isAdmin};
        var IS_UPDATE = ${isUpdate};
        var IS_FOLLOW = ${isFollow};
        var BASE_HISTORY_NO = '${empty baseCheck.facChkHstryNo ? '' : baseCheck.facChkHstryNo}';
        var BASE_FLOW_NO    = '${empty check.chkFlowNo ? '' : check.chkFlowNo}';
        var REGISTER_ACTION      = CTX + '/manager/checkHistory/register/' + OFC_NO;
        var UPDATE_ACTION_PREFIX = CTX + '/manager/checkHistory/update/'   + OFC_NO + '/';

        /* 현재 폼 모드 (register / detail / follow / update / empty) */
        var currentMode    = IS_UPDATE ? 'update' : (IS_FOLLOW ? 'follow' : 'register');
        var selectedHistory = null;
        var INITIAL_OWNER_TYPE = '${empty check.chkOwnerType ? 'SELF' : check.chkOwnerType}';

        /* 왼쪽 이력 목록 전체 원본 데이터 */
        var allList = [];
        /* 최신 이력 (allList[0]) */
        var latest  = null;

        /* CHECK_TY 공통코드 목록 - 작업유형 자동완성 후보 */
        var checkTypeList = [
            <c:forEach var="code" items="${checkTypeList}" varStatus="st">
            {
                codeNoCd: '${code.codeNoCd}',
                codeName: '${fn:escapeXml(code.codeName)}',
                codeContent: '${fn:escapeXml(code.codeContent)}'
            }<c:if test="${not st.last}">,</c:if>
            </c:forEach>
        ];

        var checkCategoryList = [
            <c:forEach var="code" items="${checkCategoryList}" varStatus="st">
            {
                codeNoCd: '${code.codeNoCd}',
                codeName: '${fn:escapeXml(code.codeName)}',
                codeContent: '${fn:escapeXml(code.codeContent)}'
            }<c:if test="${not st.last}">,</c:if>
            </c:forEach>
        ];

        /* 현재 선택된 계약유형 - 작업유형 후보 필터링에 사용 */
        var currentContTyCd = '';
        var followTypeLocked = false;

        /* ── DOM 조작 헬퍼 ── */

        /* ID로 요소 반환 */
        function el(id) { return document.getElementById(id); }

        /* 요소 텍스트 설정 (빈값이면 '-' 표시) */
        function setText(id, v) {
            var e = el(id);
            if (e) e.textContent = (v === null || v === undefined || String(v).trim() === '') ? '-' : String(v);
        }

        /* 입력 요소 값 설정 */
        function setVal(id, v) {
            var e = el(id);
            if (e) e.value = v || '';
        }

        /* 요소 표시 (is-hidden 제거) */
        function show(id) { var e = el(id); if (e) e.classList.remove('is-hidden'); }

        /* 요소 숨김 (is-hidden 추가) */
        function hide(id) { var e = el(id); if (e) e.classList.add('is-hidden'); }

        /* 입력 필드 전체 읽기 전용 / 편집 가능 전환 */
        function setReadonly(flag) {
            /* textarea, date, 작업유형 검색 input은 readonly 속성으로 제어 */
            ['chkDt', 'chkCn', 'rmk', 'chkTyNmInput', 'useRestrictBgngDt', 'useRestrictEndDt'].forEach(function (id) {
                var e = el(id);
                if (!e) return;
                flag ? e.setAttribute('readonly', '') : e.removeAttribute('readonly');
            });
            /* select 는 disabled 속성으로 제어 */
            ['chkCtgryCd', 'chkSttsCd', 'useRestrictYn'].forEach(function (id) {
                var e = el(id);
                if (e) e.disabled = flag;
            });
        }

        /* 폼 입력값 전체 초기화 */
        function clearForm() {
            ['chkCtgryCd', 'chkTyCd', 'chkTyNmInput', 'chkSttsCd', 'chkDt', 'chkCn', 'rmk', 'useRestrictBgngDt', 'useRestrictEndDt'].forEach(function (id) { setVal(id, ''); });
            hide('chkTyDropdown');
            setVal('useRestrictYn', 'N');
        }

        /* 이력 객체 값으로 폼 채우기 */
        function fillForm(h, syncOwner) {
            setVal('chkCtgryCd', h.chkCtgryCd || inferCheckCategory(h.chkTyCd, h.chkTyNm));
            setCheckType(h.chkTyCd || '', h.chkTyNm || getCheckTypeName(h.chkTyCd), true);
            setVal('chkSttsCd', h.chkSttsCd || '');
            setVal('chkDt',     h.chkDt     || '');
            setVal('chkCn',     h.chkCn     || '');
            setVal('rmk',       h.rmk       || '');
            setVal('useRestrictYn', h.useRestrictYn || 'N');
            setVal('useRestrictBgngDt', h.useRestrictBgngDt || '');
            setVal('useRestrictEndDt', h.useRestrictEndDt || '');
            setVal('chkFlowNo', h.chkFlowNo || h.facChkHstryNo || '');
            if (syncOwner !== false) applyOwnerFromHistory(h);
        }

        /* 코드값 기준 작업유형명 찾기 */
        function getCheckTypeName(code) {
            if (!code) return '';
            var found = checkTypeList.filter(function (item) { return item.codeNoCd === code; })[0];
            return found ? found.codeName : code;
        }

        function getCheckCategoryName(code) {
            if (!code) return '';
            var found = checkCategoryList.filter(function (item) { return item.codeNoCd === code; })[0];
            return found ? found.codeName : code;
        }

        function inferCheckCategory(code, name, content) {
            var text = [code, name, content].join(' ').toUpperCase();
            var servicePattern = /(청소|방역|소독|조경|용역|관리|CLEAN|DISINFECT|SANIT|LANDSCAPE|SERVICE|MGMT)/;
            return servicePattern.test(text) ? 'SERVICE' : 'REVIEW';
        }

        function getTypeCategory(item) {
            if (!item) return 'REVIEW';
            return inferCheckCategory(item.codeNoCd, item.codeName, item.codeContent);
        }

        function getHistoryCategory(h) {
            return (h && h.chkCtgryCd) ? h.chkCtgryCd : inferCheckCategory(h && h.chkTyCd, h && h.chkTyNm);
        }

        /* 작업유형 값 세팅 - 표시명 input과 hidden code를 함께 맞춤 */
        function setCheckType(code, name, keepDropdownHidden) {
            setVal('chkTyCd', code || '');
            setVal('chkTyNmInput', name || (code ? getCheckTypeName(code) : ''));
            if (code && el('chkCtgryCd') && !el('chkCtgryCd').value) {
                var found = checkTypeList.filter(function (item) { return item.codeNoCd === code; })[0];
                setVal('chkCtgryCd', getTypeCategory(found));
            }
            if (keepDropdownHidden !== false) hide('chkTyDropdown');
        }

        /* 선택한 기존 이력 요약 표시 */
        function fillSelectedHistorySummary(h) {
            if (!h) { hide('selectedHistorySummary'); return; }
            setText('historyOwnerText', getOwnerText(h));
            var contText = h.contNm || h.contNo || '-';
            if (h.contNo && h.contNm) contText = h.contNm + ' (' + h.contNo + ')';
            setText('historyContractText', contText);
            show('selectedHistorySummary');
        }

        /* 선택한 기존 이력 요약 숨김 */
        function clearSelectedHistorySummary() {
            hide('selectedHistorySummary');
            setText('historyOwnerText', '-');
            setText('historyContractText', '-');
        }

        /* ── 모달 열기 / 닫기 ── */
        function openModal(id)  {
            if (window.openModal)  window.openModal(id);
            else { var m = el(id); if (m) m.classList.add('open'); }
        }
        function closeModal(id) {
            if (window.closeModal) window.closeModal(id);
            else { var m = el(id); if (m) m.classList.remove('open'); }
        }

        /* ── AJAX JSON GET 공통 함수 ── */
        function fetchJson(url) {
            return fetch(url, { headers: { 'X-Requested-With': 'XMLHttpRequest' } })
                .then(function (r) { if (!r.ok) throw new Error(r.status); return r.json(); });
        }

        /* HTML 특수문자 이스케이프 */
        function esc(v) {
            return String(v === null || v === undefined ? '' : v)
                .replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;')
                .replace(/"/g,'&quot;').replace(/'/g,'&#039;');
        }

        /* 점검상태 코드 → 배지 CSS 클래스 반환 */
        function badgeCls(cd) {
            if (cd === 'ING')   return 'badge-ing';
            if (cd === 'DONE')  return 'badge-done';
            if (cd === 'FAULT') return 'badge-fault';
            return 'badge-wait';
        }

        /* 점검 주체 표시 텍스트 반환 */
        function getOwnerText(h) {
            if (!h || !h.partnerNo) return '자체점검';
            return h.partnerNm || '협력업체 점검';
        }

        /* 같은 처리과정 안에 완료 이력 존재 여부 확인 */
        function hasDoneInSameFlow(flowNo) {
            if (!flowNo) return false;
            return allList.some(function (h) {
                return h && h.chkFlowNo === flowNo && h.chkSttsCd === 'DONE';
            });
        }

        /* 처리과정 필터 옵션 렌더링 */
        function renderProcessOptions(list) {
            var select = el('historyFilterProcess');
            if (!select) return;
            var prevValue = select.value || '';
            var flowMap = {};
            var hasNoFlow = false;
            (list || []).forEach(function (h) {
                var flowNo = h && h.chkFlowNo ? String(h.chkFlowNo) : '';
                if (!flowNo) { hasNoFlow = true; return; }
                if (!flowMap[flowNo]) flowMap[flowNo] = h;
            });
            var html = '<option value="">전체</option>';
            Object.keys(flowMap).forEach(function (flowNo) {
                /* 처리과정 필터는 목록에서 다시 클릭해서 확인할 수 있으므로 번호만 표시한다. */
                html += '<option value="' + esc(flowNo) + '">' + esc(flowNo) + '</option>';
            });
            if (hasNoFlow) html += '<option value="__NO_FLOW__">처리과정 없음</option>';
            select.innerHTML = html;
            if (prevValue) select.value = prevValue;
        }

        /* 작업유형 후보 필터링 - 등록폼은 계약유형 기준, 이력 필터는 전체 기준 */
        function getTypeCandidates(keyword, useContractFilter, categoryCode) {
            var kw = String(keyword || '').trim().toLowerCase();
            return checkTypeList.filter(function (item) {
                var nameOk = !kw || String(item.codeName || '').toLowerCase().indexOf(kw) > -1 || String(item.codeNoCd || '').toLowerCase().indexOf(kw) > -1;
                if (!nameOk) return false;
                if (categoryCode && getTypeCategory(item) !== categoryCode) return false;
                if (!useContractFilter || !currentContTyCd) return true;
                var content = String(item.codeContent || 'ALL');
                if (content === 'ALL') return true;
                return content.split(',').map(function (v) { return v.trim(); }).indexOf(currentContTyCd) > -1;
            });
        }

        /* 자동완성 드롭다운 렌더링 */
        function renderTypeDropdown(inputId, hiddenId, dropdownId, useContractFilter) {
            var input = el(inputId);
            var hidden = el(hiddenId);
            var box = el(dropdownId);
            if (!input || !hidden || !box) return;
            if (input.hasAttribute('readonly') || input.disabled) { hide(dropdownId); return; }

            var categoryCode = hiddenId === 'historyFilterChkTyCd'
                ? (el('historyFilterChkCtgryCd') ? el('historyFilterChkCtgryCd').value : '')
                : (el('chkCtgryCd') ? el('chkCtgryCd').value : '');
            var list = getTypeCandidates(input.value, useContractFilter, categoryCode);
            if (list.length === 0) {
                box.innerHTML = '<div class="type-empty">선택 가능한 작업유형이 없습니다.</div>';
                show(dropdownId);
                return;
            }
            box.innerHTML = list.map(function (item) {
                var ctgryCd = getTypeCategory(item);
                return '<button type="button" class="type-option" data-input-id="' + esc(inputId) + '" data-hidden-id="' + esc(hiddenId) + '" data-dropdown-id="' + esc(dropdownId) + '" data-code="' + esc(item.codeNoCd) + '" data-name="' + esc(item.codeName) + '" data-category="' + esc(ctgryCd) + '"><span>' + esc(item.codeName) + '</span><span class="type-option-ctgry">' + esc(getCheckCategoryName(ctgryCd)) + '</span></button>';
            }).join('');
            show(dropdownId);
        }

        /* 작업유형 필드 초기화 */
        function clearCheckType() {
            setCheckType('', '', true);
        }

        /* 계약 select 기준 현재 계약유형 갱신 */
        function updateCurrentContractType() {
            var contSel = el('contNoSelect');
            if (!contSel) { currentContTyCd = ''; return; }
            var opt = contSel.options[contSel.selectedIndex];
            currentContTyCd = opt ? (opt.getAttribute('data-cont-ty-cd') || '') : '';
        }

        /* ── 점검 주체 UI 적용 ── */
        function applyOwnerType(ownerType) {
            var type = ownerType === 'PARTNER' ? 'PARTNER' : 'SELF';
            setVal('chkOwnerType', type);
            var selfRadio    = el('checkOwnerSelf');
            var partnerRadio = el('checkOwnerPartner');
            if (selfRadio)    selfRadio.checked    = type === 'SELF';
            if (partnerRadio) partnerRadio.checked = type === 'PARTNER';

            if (type === 'SELF') {
                /* 자체점검 선택 - 협력업체 정보 초기화, 계약 select 초기화 */
                setVal('partnerNo', '');
                setVal('contNo', '');
                hide('partnerChoiceState');
                show('partnerSelfState');
                setText('partnerNoText', '-');
                setText('partnerNmText', '-');
                setText('bizTyText', '-');
                setText('partnerPicNmText', '-');
                setText('partnerPicTelText', '-');
                setText('partnerEmailText', '-');
                /* 계약 select 초기화 */
                var contSel = el('contNoSelect');
                if (contSel) contSel.innerHTML = '<option value="">계약 없음 (계약 미연결 점검)</option>';
                currentContTyCd = '';
            } else {
                /* 협력업체 점검 선택 */
                hide('partnerSelfState');
                show('partnerChoiceState');
                if (!el('partnerNo').value) {
                    show('partnerEmptyState');
                    hide('partnerSelectedState');
                } else {
                    hide('partnerEmptyState');
                    show('partnerSelectedState');
                }
            }
        }

        /* 이력 객체 기준 점검 주체 UI 표시 */
        function applyOwnerFromHistory(h) {
            if (!h || !h.partnerNo) { applyOwnerType('SELF'); return; }
            setVal('chkOwnerType', 'PARTNER');
            setVal('partnerNo', h.partnerNo || '');
            setText('partnerNoText',     h.partnerNo);
            setText('partnerNmText',     h.partnerNm);
            setText('bizTyText',         h.bizTyNm);
            setText('partnerPicNmText',  h.picNm);
            setText('partnerPicTelText', h.picTelno);
            setText('partnerEmailText',  h.picEmail);
            hide('partnerSelfState');
            show('partnerChoiceState');
            hide('partnerEmptyState');
            show('partnerSelectedState');
            var partnerRadio = el('checkOwnerPartner');
            var selfRadio    = el('checkOwnerSelf');
            if (partnerRadio) partnerRadio.checked = true;
            if (selfRadio)    selfRadio.checked    = false;
        }

        /* URL 쿼리 문자열 생성 (빈값 제외) */
        function buildQuery(params) {
            var q = new URLSearchParams();
            Object.keys(params).forEach(function (k) { if (params[k]) q.append(k, params[k]); });
            return q.toString();
        }

        /* ── 왼쪽 이력 목록 렌더링 ──
           - 등록 화면에서는 참고용 간략 이력만 표시한다.
           - 상세 내용은 별도 상세 화면에서 확인하므로 카드에는 업체/계약/처리과정만 보여준다. */
        function renderList(list) {
            var box = el('facilityHistoryList');
            if (!list || list.length === 0) {
                box.innerHTML = '<div class="history-empty">이 시설의 시설 이력이 없습니다.</div>';
                return;
            }
            box.innerHTML = list.map(function (h) {
                var contText = h.contNm || h.contNo || '-';
                if (h.contNm && h.contNo) contText = h.contNm + ' (' + h.contNo + ')';

                return '<button type="button" class="history-item" data-no="' + esc(h.facChkHstryNo) + '">'
                    + '<div class="h-date">' + esc(h.chkDt) + '</div>'
                    + '<div class="h-main">'
                    +   '<div class="h-meta">'
                    +     '<span class="h-type">' + esc(h.chkCtgryNm || getCheckCategoryName(getHistoryCategory(h)) || '-') + ' · ' + esc(h.chkTyNm || '-') + '</span>'
                    +     '<span class="badge ' + badgeCls(h.chkSttsCd) + '">' + esc(h.chkSttsNm) + '</span>'
                    +   '</div>'
                    +   '<span class="h-partner">업체: ' + esc(getOwnerText(h)) + '</span>'
                    +   '<span class="h-contract">계약: ' + esc(contText) + '</span>'
                    +   '<span class="h-flow">처리과정 ' + esc(h.chkFlowNo || '-') + '</span>'
                    +   '<span class="h-cn">내용: ' + esc(h.chkCn || '-') + '</span>'
                    + '</div>'
                    + '</button>';
            }).join('');
        }

        /* 클릭된 이력 카드 활성 표시 */
        function markActive(no) {
            document.querySelectorAll('#facilityHistoryList .history-item').forEach(function (btn) {
                btn.classList.toggle('is-active', btn.dataset.no === no);
            });
        }

        /* ── 파트너 계약 목록 AJAX 로드 ──
           시설과 협력업체를 모두 선택하면 해당 시설에 연결된 진행중 계약 목록을 서버에서 가져와
           계약 select 옵션으로 채움 */
        function loadPartnerContracts(partnerNo) {
            var contSel = el('contNoSelect');
            if (!contSel) return;

            /* 현재 선택된 시설번호 확인 */
            var facilityNo = el('facilityNo') ? el('facilityNo').value : '';

            /* 파트너가 없으면 계약 select 초기화 */
            if (!partnerNo) {
                contSel.innerHTML = '<option value="">계약 없음 (계약 미연결 점검)</option>';
                setVal('contNo', '');
                return;
            }

            /* 시설이 없으면 계약 조회를 막음 */
            if (!facilityNo) {
                contSel.innerHTML = '<option value="">시설 선택 후 계약 조회 가능</option>';
                setVal('contNo', '');
                return;
            }

            /* 로딩 중 표시 */
            contSel.innerHTML = '<option value="">계약 목록 불러오는 중...</option>';

            fetchJson(CTX + '/manager/checkHistory/partner/contracts/'
                + encodeURIComponent(OFC_NO) + '/'
                + encodeURIComponent(facilityNo) + '/'
                + encodeURIComponent(partnerNo))
                .then(function (d) {
                    var list = (d && d.success ? d.contractList : []) || [];
                    // ***# 점검계약자동선택: 선택 시설과 협력업체로 조회된 계약이 1건이면 계약 없음 대신 해당 계약을 기본 선택하는 플래그
                    var autoSelectSingleContract = !el('contNo').value && list.length === 1;

                    /* 기본 옵션 (계약 없음) */
                    var html = '<option value="">계약 없음 (계약 미연결 점검)</option>';

                    list.forEach(function (c) {
                        /* 계약명 + 계약기간 표시 */
                        var label = (c.contNm || c.contNo)
                            + (c.contBgngDt ? ' (' + c.contBgngDt + ' ~ ' + (c.contEndDt || '진행중') + ')' : '');
                        html += '<option value="' + esc(c.contNo) + '"'
                            + ' data-cont-ty-cd="' + esc(c.contTyCd || '') + '"'
                            + ' data-partner-no="' + esc(partnerNo || '') + '">'
                            + esc(label) + '</option>';
                    });

                    contSel.innerHTML = html;

                    /* 기존에 저장된 contNo가 있으면 해당 계약 선택 복원 */
                    var savedContNo = el('contNo').value;
                    if (savedContNo) contSel.value = savedContNo;
                    if (autoSelectSingleContract && list[0]) contSel.value = list[0].contNo || '';

                    /* select 변경 시 hidden input / 계약유형 연동 */
                    syncContNo();
                    updateCurrentContractType();
                })
                .catch(function () {
                    contSel.innerHTML = '<option value="">계약 목록 조회 실패</option>';
                    setVal('contNo', '');
                    updateCurrentContractType();
                });
        }

        /* ***# 계약 목록 옵션 HTML 생성 */
        function buildContractOptions(list, includeEmptyOption) {
            var html = includeEmptyOption ? '<option value="">계약 없음 (계약 미연결 점검)</option>' : '';

            (list || []).forEach(function (c) {
                var label = (c.contNm || c.contNo)
                    + (c.contBgngDt ? ' (' + c.contBgngDt + ' ~ ' + (c.contEndDt || '진행중') + ')' : '');

                html += '<option value="' + esc(c.contNo || '') + '"'
                    + ' data-cont-ty-cd="' + esc(c.contTyCd || '') + '"'
                    + ' data-partner-no="' + esc(c.partnerNo || '') + '"'
                    + ' data-partner-nm="' + esc(c.partnerNm || '') + '"'
                    + ' data-biz-ty="' + esc(c.bizTyNm || '') + '"'
                    + ' data-pic-nm="' + esc(c.picNm || '') + '"'
                    + ' data-pic-telno="' + esc(c.picTelno || '') + '"'
                    + ' data-pic-email="' + esc(c.picEmail || '') + '">'
                    + esc(label) + '</option>';
            });

            return html;
        }

        /* ***# 계약 옵션 기준 협력업체 카드 세팅 */
        function applyPartnerFromContractOption(option) {
            if (!option || !option.value) return;

            applyOwnerType('PARTNER');
            var partnerNo = option.getAttribute('data-partner-no') || '';
            setVal('partnerNo', partnerNo);

            /* ***# 기존협력업체선택보존: 협력업체 직접 선택 후 계약 변경 시 카드 정보 유지 */
            if (!option.hasAttribute('data-partner-nm')) return;

            setText('partnerNoText', partnerNo || '-');
            setText('partnerNmText', option.getAttribute('data-partner-nm') || '-');
            setText('bizTyText', option.getAttribute('data-biz-ty') || '-');
            setText('partnerPicNmText', option.getAttribute('data-pic-nm') || '-');
            setText('partnerPicTelText', option.getAttribute('data-pic-telno') || '-');
            setText('partnerEmailText', option.getAttribute('data-pic-email') || '-');

            el('partnerEmptyState').classList.add('is-hidden');
            el('partnerSelectedState').classList.remove('is-hidden');
        }

        /* ***# 시설 선택 기준 최신 유지보수성 계약 자동 세팅 */
        function loadRecommendedFacilityContracts(facilityNo) {
            var contSel = el('contNoSelect');
            if (!contSel || !facilityNo) return;

            fetchJson(CTX + '/manager/checkHistory/facility/recommended-contracts/'
                + encodeURIComponent(OFC_NO) + '/'
                + encodeURIComponent(facilityNo))
                .then(function (d) {
                    var list = (d && d.success ? d.contractList : []) || [];
                    if (!list.length) return;

                    contSel.innerHTML = buildContractOptions(list, false);
                    contSel.value = list[0].contNo || '';
                    syncContNo();

                    applyPartnerFromContractOption(contSel.options[contSel.selectedIndex]);
                    updateCurrentContractType();
                })
                .catch(function () {
                    updateCurrentContractType();
                });
        }

        /* 계약 select 선택값을 hidden input(contNo)에 동기화 */
        function syncContNo() {
            var contSel = el('contNoSelect');
            var contHidden = el('contNo');
            if (contSel && contHidden) {
                contHidden.value = contSel.value;
            }
            updateCurrentContractType();
        }

        /* ── 시설 선택 후 이력 AJAX 로드 ── */
        function loadHistory(facilityNo) {
            el('facilityHistoryList').innerHTML = '<div class="history-empty">불러오는 중...</div>';
            setMode('empty');

            return fetchJson(CTX + '/manager/checkHistory/history/list/'
                + encodeURIComponent(OFC_NO) + '/' + encodeURIComponent(facilityNo))
                .then(function (data) {
                    allList = (data && data.success ? data.historyList : []) || [];
                    latest  = allList.length > 0 ? allList[0] : null;
                    renderProcessOptions(allList);
                    renderList(allList);

                    if (IS_UPDATE) {
                        var initNo = '${check.facChkHstryNo}';
                        var initH  = allList.filter(function (h) { return h.facChkHstryNo === initNo; })[0] || latest || null;
                        if (initH) { setMode('detail', initH); markActive(initH.facChkHstryNo); }
                        else        { setMode('detail'); }
                        return;
                    }
                    if (IS_FOLLOW) {
                        /* 후속 등록 진입 : URL 기준 이력을 목록에서 찾아 자동 반영하고 카드에 표시한다. */
                        var baseH = allList.filter(function (h) { return h.facChkHstryNo === BASE_HISTORY_NO; })[0]
                            || latest
                            || { facChkHstryNo: BASE_HISTORY_NO, chkFlowNo: BASE_FLOW_NO };
                        setMode('follow', baseH);
                        if (baseH && baseH.facChkHstryNo) markActive(baseH.facChkHstryNo);
                        return;
                    }
                    setMode('register');
                })
                .catch(function () {
                    el('facilityHistoryList').innerHTML = '<div class="history-empty">이력 조회 중 오류가 발생했습니다.</div>';
                    if (!IS_UPDATE) setMode('register');
                });
        }

        /* ── 오른쪽 폼 모드 전환 ──
           empty    : 시설 미선택 초기 상태
           register : 신규 시설 이력 등록 (INSERT)
           detail   : 기존 이력 클릭 후 읽기 전용 상세 표시
           follow   : 기존 이력 기준 후속 이력 등록 (INSERT)
           update   : 오정보 정정 수정 (UPDATE) */
        function setFormAction(actionUrl, historyNo) {
            var form = el('checkForm');
            if (form) form.setAttribute('action', actionUrl);
            var hiddenNo = document.querySelector('input[name="facChkHstryNo"]');
            if (hiddenNo) {
                hiddenNo.disabled = actionUrl === REGISTER_ACTION;
                if (historyNo) hiddenNo.value = historyNo;
            }
        }

        function setCancelButtonText(text) {
            var btn = el('cancelFollowBtn');
            if (btn) btn.textContent = text;
        }

        function setMode(mode, history) {
            currentMode     = mode;
            selectedHistory = history || selectedHistory || null;

            /* 버튼 / 안내 전체 숨김 후 모드별로 필요한 것만 표시 */
            hide('openFollowBtn');
            hide('cancelFollowBtn');
            hide('saveHistoryBtn');
            hide('openCorrectBtn');
            hide('correctNotice');
            hide('followNotice');
            hide('baseHistoryRow');
            clearSelectedHistorySummary();
            followTypeLocked = false;
            if (el('chkCtgryCd')) delete el('chkCtgryCd').dataset.locked;
            setReadonly(true);

            var fNo = el('facilityNo').value;

            if (mode === 'empty') {
                /* 시설 미선택 상태 */
                selectedHistory = null;
                setFormAction(IS_UPDATE ? UPDATE_ACTION_PREFIX + encodeURIComponent('${check.facChkHstryNo}') : REGISTER_ACTION);
                setText('historyFormTitle', '시설 선택 대기');
                setText('formFacilityNoText', '-');
                setText('formChkFlowNoText', '-');
                setText('currentHistoryNoText', '-');
                clearForm();
            }
            else if (mode === 'register') {
                /* 신규 등록 상태 */
                selectedHistory = null;
                setFormAction(REGISTER_ACTION);
                setText('historyFormTitle', '시설 이력 등록');
                setText('formFacilityNoText', fNo);
                setText('formChkFlowNoText', '저장 시 자동 생성');
                setText('currentHistoryNoText', '신규');
                clearForm();
                setVal('chkFlowNo', '');
                applyOwnerType(INITIAL_OWNER_TYPE || 'SELF');
                setReadonly(false);
                document.querySelectorAll('#facilityHistoryList .history-item').forEach(function (btn) { btn.classList.remove('is-active'); });
                if (!IS_ADMIN) { show('saveHistoryBtn'); el('saveHistoryBtn').textContent = '등록'; }
            }
            else if (mode === 'detail') {
                /* 기존 이력 상세 확인 상태 */
                var h = history || {};
                selectedHistory = h;
                setFormAction(IS_UPDATE && h.facChkHstryNo ? UPDATE_ACTION_PREFIX + encodeURIComponent(h.facChkHstryNo) : REGISTER_ACTION, h.facChkHstryNo);
                setText('historyFormTitle', '기존 시설 이력 상세');
                setText('formFacilityNoText', fNo);
                setText('formChkFlowNoText', h.chkFlowNo || '-');
                setText('currentHistoryNoText', h.facChkHstryNo || '-');
                setVal('chkFlowNo', h.chkFlowNo || '');
                fillForm(h, false);
                /* 상세 요약은 오른쪽 폼에 별도 표시하지 않는다. 간략 정보는 왼쪽 카드에서 확인한다. */
                if (!IS_ADMIN && !IS_UPDATE) {
                    /* 신규 등록 진입에서는 이력을 클릭해도 후속 등록은 열지 않음 */
                    setCancelButtonText('신규 등록으로 돌아가기');
                    show('cancelFollowBtn');
                    if (IS_FOLLOW) {
                        /* 후속 등록 진입 화면에서만 기준 이력 재선택 후 후속 등록 가능 */
                        show('openFollowBtn');
                    }
                }
                if (!IS_ADMIN && IS_UPDATE) {
                    /* 수정 진입 화면에서는 기존처럼 후속 등록/오정보 수정 진입 허용 */
                    show('openFollowBtn');
                    show('openCorrectBtn');
                }
            }
            else if (mode === 'follow') {
                /* 후속 이력 등록 상태 */
                var base       = selectedHistory || history || latest || {};
                var baseNo     = base.facChkHstryNo || '';
                var followFlowNo = base.chkFlowNo || base.facChkHstryNo || '';
                setFormAction(REGISTER_ACTION);
                setText('historyFormTitle', '후속이력 등록');
                setText('formFacilityNoText', fNo);
                setText('formChkFlowNoText', followFlowNo || '-');
                setText('currentHistoryNoText', '신규');
                setText('baseHistoryNoText', baseNo);
                show('baseHistoryRow');
                setVal('chkFlowNo', followFlowNo);
                clearForm();
                /* 기준 이력 정보는 왼쪽 active 카드와 상단 대상 정보로 확인한다. */
                /* 후속 등록은 기준 이력의 업체/계약/작업유형/처리과정을 이어받음 */
                if (base.partnerNo) {
                    setVal('contNo', base.contNo || '');
                    applyOwnerFromHistory(base);
                    loadPartnerContracts(base.partnerNo);
                } else {
                    applyOwnerType('SELF');
                    setVal('contNo', base.contNo || '');
                }
                setVal('chkCtgryCd', base.chkCtgryCd || getHistoryCategory(base));
                setCheckType(base.chkTyCd || '', base.chkTyNm || getCheckTypeName(base.chkTyCd), true);
                setVal('rmk', baseNo ? '기준이력 ' + baseNo + ' 후속 조치' : '');
                setReadonly(false);
                /* 같은 흐름의 후속 등록에서는 작업유형을 변경하지 않도록 잠금 */
                followTypeLocked = true;
                if (el('chkCtgryCd')) el('chkCtgryCd').dataset.locked = 'true';
                if (el('chkTyNmInput')) el('chkTyNmInput').setAttribute('readonly', '');
                if (base.chkSttsCd === 'DONE' || hasDoneInSameFlow(followFlowNo)) show('followNotice');
                if (!IS_ADMIN) { show('saveHistoryBtn'); el('saveHistoryBtn').textContent = '후속 등록'; }
                setCancelButtonText(IS_UPDATE ? '수정으로 돌아가기' : '취소');
                show('cancelFollowBtn');
            }
            else if (mode === 'update') {
                /* 오정보 수정 상태 */
                var uh = history || selectedHistory || {};
                selectedHistory = uh;
                setFormAction(UPDATE_ACTION_PREFIX + encodeURIComponent(uh.facChkHstryNo || '${check.facChkHstryNo}'), uh.facChkHstryNo || '${check.facChkHstryNo}');
                setText('historyFormTitle', '시설 이력 수정');
                setText('formFacilityNoText', fNo);
                setText('formChkFlowNoText', uh.chkFlowNo || '-');
                setText('currentHistoryNoText', uh.facChkHstryNo || '${check.facChkHstryNo}' || '-');
                setVal('chkFlowNo', uh.chkFlowNo || '');
                fillForm(uh);
                if (el('chkCtgryCd')) delete el('chkCtgryCd').dataset.locked;
                /* 수정 대상 정보는 폼 값으로만 표시한다. */
                setReadonly(false);
                show('correctNotice');
                setCancelButtonText('취소');
                show('cancelFollowBtn');
                if (!IS_ADMIN) { show('saveHistoryBtn'); el('saveHistoryBtn').textContent = '수정 저장'; }
            }
        }

        /* ── 이력 필터 (클라이언트 사이드) ── */
        function applyFilter() {
            var ctgry   = el('historyFilterChkCtgryCd') ? el('historyFilterChkCtgryCd').value : '';
            var ty      = el('historyFilterChkTyCd').value;
            var st      = el('historyFilterChkSttsCd').value;
            var restrict = el('historyFilterUseRestrictYn').value;
            var process = el('historyFilterProcess').value;
            var kw      = el('historyFilterKeyword').value.trim().toLowerCase();

            var filtered = allList.filter(function (h) {
                var ownerText = getOwnerText(h);
                var processNo = h.chkFlowNo || '';
                var kwOk      = !kw || [h.chkCn, h.rmk, h.partnerNm, ownerText, h.chkFlowNo, h.facChkHstryNo].join(' ').toLowerCase().indexOf(kw) > -1;
                var processOk = !process || processNo === process;
                var restrictOk = !restrict || (h.useRestrictYn || 'N') === restrict;
                if (process === '__NO_FLOW__') processOk = !processNo;
                return (!ctgry || getHistoryCategory(h) === ctgry) && (!ty || h.chkTyCd === ty) && (!st || h.chkSttsCd === st) && restrictOk && processOk && kwOk;
            });

            if (filtered.length === 0) {
                el('facilityHistoryList').innerHTML = '<div class="history-empty">검색 결과가 없습니다.</div>';
                if (!IS_UPDATE) setMode('register');
            } else {
                renderList(filtered);
                if (IS_UPDATE) {
                    setMode('detail', filtered[0]);
                    markActive(filtered[0].facChkHstryNo);
                } else if (IS_FOLLOW) {
                    var baseFiltered = filtered.filter(function (h) { return h.facChkHstryNo === (selectedHistory && selectedHistory.facChkHstryNo); })[0] || filtered[0];
                    setMode('follow', baseFiltered);
                    markActive(baseFiltered.facChkHstryNo);
                } else {
                    setMode('register');
                }
            }
        }

        /* 이력 필터 초기화 */
        function resetFilter() {
            setVal('historyFilterChkCtgryCd', '');
            setVal('historyFilterChkTyCd',   '');
            setVal('historyFilterChkTyNmInput', '');
            setVal('historyFilterChkSttsCd', '');
            setVal('historyFilterUseRestrictYn', '');
            setVal('historyFilterProcess',   '');
            setVal('historyFilterKeyword',   '');
            renderList(allList);
            if (IS_UPDATE && allList.length > 0) {
                var backNo = selectedHistory && selectedHistory.facChkHstryNo ? selectedHistory.facChkHstryNo : allList[0].facChkHstryNo;
                var backH  = allList.filter(function (h) { return h.facChkHstryNo === backNo; })[0] || allList[0];
                setMode('detail', backH);
                markActive(backH.facChkHstryNo);
            } else if (IS_FOLLOW && allList.length > 0) {
                var baseReset = selectedHistory || allList.filter(function (h) { return h.facChkHstryNo === BASE_HISTORY_NO; })[0] || allList[0];
                setMode('follow', baseReset);
                markActive(baseReset.facChkHstryNo);
            } else {
                setMode('register');
            }
        }

        /* ── 시설 모달 AJAX 검색 ── */
        function searchFacility() {
            var q = buildQuery({
                facilityTyCd:       el('facilityFilterType')  ? el('facilityFilterType').value  : '',
                dongNo:             el('facilityFilterDong')  ? el('facilityFilterDong').value  : '',
                facilityUseYn:      el('facilityFilterUseYn') ? el('facilityFilterUseYn').value : '',
                facilityLocCn:      el('facilityFilterLoc')   ? el('facilityFilterLoc').value   : '',
                facilitySearchWord: el('facilityModalSearch') ? el('facilityModalSearch').value : ''
            });
            fetchJson(CTX + '/manager/checkHistory/facility/search/' + encodeURIComponent(OFC_NO) + (q ? '?' + q : ''))
                .then(function (d) { renderFacilityTbody(d && d.success ? d.facilityList : []); })
                .catch(function ()  { renderFacilityTbody([]); });
        }

        /* ── 협력업체 모달 AJAX 검색 ── */
        function searchPartner() {
            var q = buildQuery({
                bizTyNm:           el('partnerFilterBizTy') ? el('partnerFilterBizTy').value : '',
                partnerUseYn:      el('partnerFilterUseYn') ? el('partnerFilterUseYn').value : '',
                picNm:             el('partnerFilterPicNm') ? el('partnerFilterPicNm').value : '',
                partnerSearchWord: el('partnerModalSearch') ? el('partnerModalSearch').value : ''
            });
            fetchJson(CTX + '/manager/checkHistory/partner/search/' + encodeURIComponent(OFC_NO) + (q ? '?' + q : ''))
                .then(function (d) { renderPartnerTbody(d && d.success ? d.partnerList : []); })
                .catch(function ()  { renderPartnerTbody([]); });
        }

        /* 시설 모달 목록 행 렌더링 */
        function renderFacilityTbody(list) {
            var tb = el('facilityModalTbody');
            if (!tb) return;
            if (!list || !list.length) { tb.innerHTML = '<tr><td colspan="6">검색된 시설이 없습니다.</td></tr>'; return; }
            tb.innerHTML = list.map(function (f) {
                return '<tr class="facility-modal-row"'
                    + ' data-facility-no="' + esc(f.facilityNo)   + '"'
                    + ' data-facility-nm="' + esc(f.facilityNm)   + '"'
                    + ' data-facility-ty="' + esc(f.facilityTyNm) + '"'
                    + ' data-loc-cn="'      + esc(f.locCn)        + '"'
                    + ' data-use-yn="'      + esc(f.useYn)        + '"'
                    + ' data-instl-dt="'    + esc(f.instlDt)      + '">'
                    + '<td>' + esc(f.facilityNo) + '</td>'
                    + '<td class="td-left">' + esc(f.facilityNm)   + '</td>'
                    + '<td>' + esc(f.facilityTyNm) + '</td>'
                    + '<td class="td-left">' + esc(f.locCn)        + '</td>'
                    + '<td>' + (f.useYn === 'Y' ? 'Y' : 'N')       + '</td>'
                    + '<td><button type="button" class="btn select-facility-btn">선택</button></td>'
                    + '</tr>';
            }).join('');
        }

        /* 협력업체 모달 목록 행 렌더링 */
        function renderPartnerTbody(list) {
            var tb = el('partnerModalTbody');
            if (!tb) return;
            if (!list || !list.length) { tb.innerHTML = '<tr><td colspan="6">검색된 협력업체가 없습니다.</td></tr>'; return; }
            tb.innerHTML = list.map(function (p) {
                return '<tr class="partner-modal-row"'
                    + ' data-partner-no="'  + esc(p.partnerNo) + '"'
                    + ' data-partner-nm="'  + esc(p.partnerNm) + '"'
                    + ' data-biz-ty="'      + esc(p.bizTyNm)   + '"'
                    + ' data-pic-nm="'      + esc(p.picNm)     + '"'
                    + ' data-pic-telno="'   + esc(p.picTelno)  + '"'
                    + ' data-pic-email="'   + esc(p.picEmail)  + '">'
                    + '<td>' + esc(p.partnerNo) + '</td>'
                    + '<td class="td-left">' + esc(p.partnerNm) + '</td>'
                    + '<td>' + esc(p.bizTyNm)  + '</td>'
                    + '<td>' + esc(p.picNm)    + '</td>'
                    + '<td>' + esc(p.picTelno) + '</td>'
                    + '<td><button type="button" class="btn select-partner-btn">선택</button></td>'
                    + '</tr>';
            }).join('');
        }

        /* ── 시설 선택 처리 ── */
        function selectFacility(btn) {
            var row = btn.closest('.facility-modal-row');
            if (!row) return;
            var useYn = row.dataset.useYn;

            /* 상단 시설 카드 갱신 */
            setVal('facilityNo', row.dataset.facilityNo);
            setText('facilityNoText',      row.dataset.facilityNo);
            setText('facilityNmText',      row.dataset.facilityNm);
            setText('facilityTyText',      row.dataset.facilityTy);
            setText('facilityLocText',     row.dataset.locCn);
            setText('facilityInstlDtText', row.dataset.instlDt);
            setText('facilityUseYnText',   useYn === 'Y' ? '사용' : useYn === 'N' ? '미사용' : '-');
            setText('formFacilityNoText',  row.dataset.facilityNo);

            el('facilityEmptyState').classList.add('is-hidden');
            el('facilitySelectedState').classList.remove('is-hidden');
            closeModal('facilityModal');

            /* 시설 변경 시 기존 계약 선택값 초기화 */
            setVal('contNo', '');
            if (el('contNoSelect')) {
                el('contNoSelect').innerHTML = '<option value="">계약 없음 (계약 미연결 점검)</option>';
            }
            updateCurrentContractType();

            /* 선택 시설 이력 AJAX 로드 후 계약 자동 세팅
               - loadHistory 내부 setMode('register')가 점검주체/계약값을 초기화하므로
               - 이력 목록 로드가 끝난 뒤 추천 계약을 조회해야 첫 선택에서도 협력업체/계약이 유지된다. */
            loadHistory(row.dataset.facilityNo).then(function () {
                loadRecommendedFacilityContracts(row.dataset.facilityNo);
            });
        }

        /* ── 협력업체 선택 처리 ── */
        function selectPartner(btn) {
            var row = btn.closest('.partner-modal-row');
            if (!row) return;

            /* 상단 협력업체 카드 갱신 */
            applyOwnerType('PARTNER');
            setVal('partnerNo', row.dataset.partnerNo);
            setText('partnerNoText',     row.dataset.partnerNo);
            setText('partnerNmText',     row.dataset.partnerNm);
            setText('bizTyText',         row.dataset.bizTy);
            setText('partnerPicNmText',  row.dataset.picNm);
            setText('partnerPicTelText', row.dataset.picTelno);
            setText('partnerEmailText',  row.dataset.picEmail);

            el('partnerEmptyState').classList.add('is-hidden');
            el('partnerSelectedState').classList.remove('is-hidden');
            closeModal('partnerModal');

            /* 선택한 파트너의 계약 목록 AJAX 로드 */
            loadPartnerContracts(row.dataset.partnerNo);
        }

        /* ── 클릭 이벤트 위임 ── */
        document.addEventListener('click', function (e) {
            var t = e.target;

            /* 작업유형 자동완성 항목 선택 */
            var typeOption = t.closest('.type-option');
            if (typeOption) {
                var inputId = typeOption.getAttribute('data-input-id');
                var hiddenId = typeOption.getAttribute('data-hidden-id');
                var dropdownId = typeOption.getAttribute('data-dropdown-id');
                setVal(inputId, typeOption.getAttribute('data-name') || '');
                setVal(hiddenId, typeOption.getAttribute('data-code') || '');
                if (hiddenId === 'chkTyCd') {
                    setVal('chkCtgryCd', typeOption.getAttribute('data-category') || '');
                }
                if (hiddenId === 'historyFilterChkTyCd' && el('historyFilterChkCtgryCd') && !el('historyFilterChkCtgryCd').value) {
                    setVal('historyFilterChkCtgryCd', typeOption.getAttribute('data-category') || '');
                }
                hide(dropdownId);
                if (hiddenId === 'historyFilterChkTyCd') applyFilter();
                return;
            }

            /* 점검 주체 라디오 변경 */
            if (t && t.name === 'ownerTypeRadio') { applyOwnerType(t.value); return; }

            /* 시설 모달 관련 버튼 */
            if (t.closest('#openFacilityModalBtn, #reopenFacilityModalBtn')) { openModal('facilityModal'); return; }
            if (t.closest('#facilitySearchBtn')) { searchFacility(); return; }
            if (t.closest('#facilitySearchResetBtn')) {
                ['facilityFilterType','facilityFilterDong','facilityFilterUseYn','facilityFilterLoc','facilityModalSearch']
                    .forEach(function (id) { setVal(id, ''); });
                searchFacility(); return;
            }
            var sfBtn = t.closest('.select-facility-btn');
            if (sfBtn) { selectFacility(sfBtn); return; }

            /* 협력업체 모달 관련 버튼 */
            if (t.closest('#openPartnerModalBtn, #reopenPartnerModalBtn')) { openModal('partnerModal'); return; }
            if (t.closest('#partnerSearchBtn')) { searchPartner(); return; }
            if (t.closest('#partnerSearchResetBtn')) {
                ['partnerFilterBizTy','partnerFilterUseYn','partnerFilterPicNm','partnerModalSearch']
                    .forEach(function (id) { setVal(id, ''); });
                searchPartner(); return;
            }
            var spBtn = t.closest('.select-partner-btn');
            if (spBtn) { selectPartner(spBtn); return; }

            /* 이력 카드 클릭
               - 신규 등록 진입에서는 참고용 목록이므로 클릭해도 아무 동작을 하지 않는다.
               - 후속 등록 진입에서는 클릭한 이력을 기준으로 후속 등록 기준을 바꾼다.
               - 수정 진입에서는 기존처럼 선택 이력을 오른쪽에서 확인/수정 대상으로 사용할 수 있다. */
            var hItem = t.closest('.history-item');
            if (hItem) {
                var no    = hItem.dataset.no;
                var found = allList.filter(function (h) { return h.facChkHstryNo === no; })[0];
                if (!found) return;

                if (!IS_UPDATE && !IS_FOLLOW) {
                    return;
                }

                if (IS_FOLLOW) {
                    setMode('follow', found);
                    markActive(no);
                    return;
                }

                setMode('detail', found);
                markActive(no);
                return;
            }

            /* 이력 필터 버튼 */
            if (t.closest('#historySearchBtn')) { applyFilter(); return; }
            if (t.closest('#historyResetBtn'))  { resetFilter(); return; }

            /* 후속 등록 버튼 */
            if (t.closest('#openFollowBtn')) {
                /* 신규 등록 진입에서는 버튼이 노출되지 않지만, 이벤트 차원에서도 차단 */
                if (!IS_UPDATE && !IS_FOLLOW) return;
                setMode('follow', selectedHistory || latest);
                return;
            }

            /* 오정보 수정 버튼 */
            if (t.closest('#openCorrectBtn')) {
                var activeCard = document.querySelector('#facilityHistoryList .history-item.is-active');
                var curH = activeCard
                    ? allList.filter(function (h) { return h.facChkHstryNo === activeCard.dataset.no; })[0]
                    : (selectedHistory || latest || null);
                if (curH) { setMode('update', curH); markActive(curH.facChkHstryNo); }
                return;
            }

            /* 취소 버튼 */
            if (t.closest('#cancelFollowBtn')) {
                if (!IS_UPDATE) { setMode('register'); return; }
                if (currentMode === 'follow' || currentMode === 'update') {
                    var backTarget = selectedHistory || latest;
                    if (backTarget) { setMode('detail', backTarget); markActive(backTarget.facChkHstryNo); }
                    return;
                }
                history.back();
                return;
            }
        });

        /* ── 계약 select 변경 시 hidden input 동기화 ──
           contNoSelect 에서 계약을 선택하면 contNo hidden input 에 값을 복사함
           이 값이 폼 전송 시 서버로 전달됨 */
        var contNoSelect = el('contNoSelect');
        if (contNoSelect) {
            contNoSelect.addEventListener('change', function () {
                setVal('contNo', this.value);
                /* ***# 계약변경협력업체동기화: 시설 기준 추천 계약 선택 시 협력업체 카드 갱신 */
                applyPartnerFromContractOption(this.options[this.selectedIndex]);
                updateCurrentContractType();
                if (!followTypeLocked && currentMode !== 'detail') clearCheckType();
            });
        }

        /* 작업유형 검색 input 이벤트 */
        var chkTyNmInput = el('chkTyNmInput');
        var chkCtgryCd = el('chkCtgryCd');
        if (chkCtgryCd) {
            chkCtgryCd.addEventListener('change', function () {
                if (this.dataset.locked === 'true') {
                    var base = selectedHistory || latest || {};
                    setVal('chkCtgryCd', base.chkCtgryCd || getHistoryCategory(base));
                    return;
                }
                if (!followTypeLocked && currentMode !== 'detail') clearCheckType();
            });
        }
        if (chkTyNmInput) {
            chkTyNmInput.addEventListener('input', function () {
                setVal('chkTyCd', '');
                renderTypeDropdown('chkTyNmInput', 'chkTyCd', 'chkTyDropdown', true);
            });
            chkTyNmInput.addEventListener('focus', function () {
                renderTypeDropdown('chkTyNmInput', 'chkTyCd', 'chkTyDropdown', true);
            });
        }

        var historyFilterTypeInput = el('historyFilterChkTyNmInput');
        var historyFilterCtgry = el('historyFilterChkCtgryCd');
        if (historyFilterCtgry) {
            historyFilterCtgry.addEventListener('change', function () {
                setVal('historyFilterChkTyCd', '');
                setVal('historyFilterChkTyNmInput', '');
                applyFilter();
            });
        }
        if (historyFilterTypeInput) {
            historyFilterTypeInput.addEventListener('input', function () {
                setVal('historyFilterChkTyCd', '');
                renderTypeDropdown('historyFilterChkTyNmInput', 'historyFilterChkTyCd', 'historyFilterChkTyDropdown', false);
            });
            historyFilterTypeInput.addEventListener('focus', function () {
                renderTypeDropdown('historyFilterChkTyNmInput', 'historyFilterChkTyCd', 'historyFilterChkTyDropdown', false);
            });
        }

        document.addEventListener('click', function (e) {
            if (!e.target.closest('.type-autocomplete')) {
                hide('chkTyDropdown');
                hide('historyFilterChkTyDropdown');
            }
        });


        /* 이력 필터는 검색 버튼 없이 변경 즉시 적용한다. */
        ['historyFilterChkSttsCd','historyFilterUseRestrictYn','historyFilterProcess'].forEach(function (id) {
            var target = el(id);
            if (target) target.addEventListener('change', applyFilter);
        });

        /* ── 키보드 Enter 처리 ── */
        document.addEventListener('keydown', function (e) {
            if (e.key !== 'Enter') return;
            var id = e.target && e.target.id;
            if (id === 'historyFilterKeyword') { e.preventDefault(); applyFilter();    return; }
            if (id === 'historyFilterChkTyNmInput') { e.preventDefault(); applyFilter(); return; }
            if (id === 'chkTyNmInput') { e.preventDefault(); return; }
            if (id === 'facilityModalSearch')  { e.preventDefault(); searchFacility(); return; }
            if (id === 'partnerModalSearch')   { e.preventDefault(); searchPartner();  return; }
        });

        /* ── 폼 submit 전 검증 ── */
        el('checkForm').addEventListener('submit', async function (e) {
            if (IS_ADMIN) {
                e.preventDefault();
                await showAlert('ADMIN 계정은 저장할 수 없습니다.', 'warning');
                return;
            }
            if (!el('facilityNo').value) {
                e.preventDefault();
                await showAlert('시설 이력 대상 시설을 선택해 주세요.', 'warning');
                return;
            }
            if (el('chkOwnerType').value === 'PARTNER' && !el('partnerNo').value) {
                e.preventDefault();
                await showAlert('협력업체 처리 이력은 협력업체를 선택해 주세요.', 'warning');
                return;
            }
            if (!el('chkCtgryCd').value) {
                e.preventDefault();
                await showAlert('점검분류를 선택해 주세요.', 'warning');
                return;
            }
            if (!el('chkTyCd').value) {
                e.preventDefault();
                await showAlert('작업유형을 선택해 주세요.', 'warning');
                return;
            }
            if (!el('chkSttsCd').value) {
                e.preventDefault();
                await showAlert('상태를 선택해 주세요.', 'warning');
                return;
            }
            if (!el('chkDt').value) {
                e.preventDefault();
                await showAlert('작업일자를 입력해 주세요.', 'warning');
                return;
            }
            if (!el('chkCn').value.trim()) {
                e.preventDefault();
                await showAlert('작업내용을 입력해 주세요.', 'warning');
                return;
            }
            if (el('useRestrictYn').value === 'Y') {
                if (!el('useRestrictBgngDt').value || !el('useRestrictEndDt').value) {
                    e.preventDefault();
                    await showAlert('이용제한 시작일시와 종료일시를 입력해 주세요.', 'warning');
                    return;
                }
                if (el('useRestrictBgngDt').value >= el('useRestrictEndDt').value) {
                    e.preventDefault();
                    await showAlert('이용제한 종료일시는 시작일시보다 뒤여야 합니다.', 'warning');
                    return;
                }
            }
        });

        var restrictSelect = el('useRestrictYn');
        if (restrictSelect) {
            restrictSelect.addEventListener('change', function () {
                if (this.value !== 'Y') { setVal('useRestrictBgngDt', ''); setVal('useRestrictEndDt', ''); }
            });
        }

        /* ── 초기 화면 상태 설정 ── */
        (function init() {
            /* 시설유형 / 동 select 중복 옵션 제거 */
            function dedupSelect(selectId) {
                var select = el(selectId);
                if (!select) return;
                var seen = {};
                Array.prototype.slice.call(select.options).forEach(function (opt) {
                    if (!opt.value) return;
                    if (seen[opt.value]) { opt.parentNode.removeChild(opt); return; }
                    seen[opt.value] = true;
                });
            }
            dedupSelect('facilityFilterType');
            dedupSelect('facilityFilterDong');

            applyOwnerType(el('chkOwnerType') ? el('chkOwnerType').value : 'SELF');
            /* 수정/후속 진입 시 hidden chkTyCd 값이 있으면 코드명 표시 */
            if (el('chkTyCd') && el('chkTyCd').value) {
                setCheckType(el('chkTyCd').value, getCheckTypeName(el('chkTyCd').value), true);
            }

            var initNo = el('facilityNo').value;
            if (initNo) {
                /* 시설번호가 있으면 (수정/후속 진입) 이력 바로 로드 */
                if (el('facilityEmptyState'))    el('facilityEmptyState').classList.add('is-hidden');
                if (el('facilitySelectedState')) el('facilitySelectedState').classList.remove('is-hidden');

                /* 수정 모드이고 파트너가 있으면 해당 파트너 계약 목록도 로드 */
                var initPartnerNo = el('partnerNo') ? el('partnerNo').value : '';
                if (initPartnerNo) loadPartnerContracts(initPartnerNo);

                loadHistory(initNo);
            } else {
                /* 신규 등록 진입 — 시설 선택 안내 상태 */
                setMode('empty');
            }
        }());

    }());
</script>
</body>
</html>
