<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:url var="meterResetUrl" value="/manager/meter/hstry/${mgmtOfcNo}" />

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>검침 이력 관리</title>

    <sec:csrfMetaTags/>

    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet" />

    <link rel="stylesheet" href="${ctx}/css/office-layout.css">
    <link rel="stylesheet" href="${ctx}/css/manager/manager-common.css">

    <style>
        /* 페이지 토큰 */
        #meterPage { --accent:#2e5c38; --accent-hover:#1f4027; --accent-light:#e8f0ea; --surface:#fff; --surface-sub:#f8f9fb; --line:#d7dce2; --th-bg:#f0f2ef; --text-head:#1a2e1e; --text-sec:#4a5c4e; --text-ter:#8a9a8e; font-family:'Noto Sans KR',sans-serif; }

        /* 페이지 헤더 */
        #meterPage .page-title-block h2 { color:var(--text-head); font-size:19px; letter-spacing:-.5px; }
        #meterPage .page-title-block p { color:#6b7a6e; font-size:12px; }

        /* 공통 버튼 */
        #meterPage .btn { display:inline-flex; align-items:center; justify-content:center; gap:4px; min-height:32px; height:32px; padding:0 11px; border-radius:4px; border:1px solid var(--line); background:#fff; color:#39443d; font-size:12px; font-weight:700; cursor:pointer; text-decoration:none; box-sizing:border-box; }
        #meterPage .btn:hover { background:#f4f7f4; }
        #meterPage .btn-primary { background:var(--accent); border-color:var(--accent); color:#fff; }
        #meterPage .btn-primary:hover { background:var(--accent-hover); border-color:var(--accent-hover); }
        #meterPage .btn-primary:disabled { opacity:.72; cursor:not-allowed; }
        #meterPage .btn-ghost { background:#fff; color:#374151; }
        #meterPage .btn .material-symbols-rounded { font-size:15px; }
        #meterPage .btn-sm { height:28px; min-height:28px; padding:0 9px; font-size:11px; }
        #meterPage .btn-edit { background:var(--accent); border-color:var(--accent); color:#fff; }
        #meterPage .btn-edit:hover { background:var(--accent-hover); border-color:var(--accent-hover); color:#fff; }
        #meterPage .upload-spinner { width:14px; height:14px; border:2px solid rgba(255,255,255,.45); border-top-color:#fff; border-radius:50%; animation:meterUploadSpin .8s linear infinite; box-sizing:border-box; }
        @keyframes meterUploadSpin { to { transform:rotate(360deg); } }

        /* 검침 탭 */
        #meterPage .meter-tab-wrap { margin-top:12px; }
        #meterPage .meter-tab-input { position:absolute; width:1px; height:1px; overflow:hidden; clip:rect(0,0,0,0); white-space:nowrap; border:0; }
        #meterPage .meter-tab-labels { display:flex; gap:24px; width:100%; padding:0; margin-bottom:18px; background:transparent; border:none; border-bottom:1px solid var(--line); border-radius:0; }
        #meterPage .meter-tab-label { position:relative; display:flex; align-items:center; gap:6px; min-height:42px; padding:0 2px; border:none; border-radius:0; background:transparent; color:#6b7280; font-size:13px; font-weight:700; font-family:inherit; cursor:pointer; transition:.15s; box-sizing:border-box; }
        #meterPage .meter-tab-label:hover { color:#111827; }
        #meterPage .meter-tab-label .material-symbols-rounded { font-size:16px; color:#9ca3af; }
        #meterPage .meter-tab-content { display:block; }
        #meterPage .meter-tab-panel { display:none; margin-bottom:0; }
        #meterPage #meterTabComplex:checked ~ .meter-tab-labels label[for="meterTabComplex"],
        #meterPage #meterTabFacility:checked ~ .meter-tab-labels label[for="meterTabFacility"] { background:transparent; color:#111827; box-shadow:none; }
        #meterPage #meterTabComplex:checked ~ .meter-tab-labels label[for="meterTabComplex"]::after,
        #meterPage #meterTabFacility:checked ~ .meter-tab-labels label[for="meterTabFacility"]::after { content:""; position:absolute; left:0; right:0; bottom:-1px; height:2px; background:var(--accent); }
        #meterPage #meterTabComplex:checked ~ .meter-tab-labels label[for="meterTabComplex"] .material-symbols-rounded,
        #meterPage #meterTabFacility:checked ~ .meter-tab-labels label[for="meterTabFacility"] .material-symbols-rounded { color:var(--accent); }
        #meterPage #meterTabComplex:checked ~ .meter-tab-content #complexMeterPanel,
        #meterPage #meterTabFacility:checked ~ .meter-tab-content #facilityMeterPanel { display:block; }

        /* 섹션 패널 */
        #meterPage .meter-section { margin-bottom:18px; }
        #meterPage .meter-section:last-child { margin-bottom:0; }
        #meterPage .section-heading { display:flex; align-items:flex-end; justify-content:space-between; gap:12px; margin:0 0 8px; }
        #meterPage .section-title-wrap { display:flex; flex-direction:column; gap:3px; }
        #meterPage .section-title { display:flex; align-items:center; gap:6px; margin:0; color:var(--text-head); font-size:15px; font-weight:800; }
        #meterPage .section-title .material-symbols-rounded { font-size:18px; color:var(--accent); }
        #meterPage .section-desc { margin:0; color:#718075; font-size:11px; }
        #meterPage .section-actions { display:flex; align-items:center; justify-content:flex-end; gap:7px; }

        /* 공통 패널 */
        #meterPage .panel { border-radius:6px; border:1px solid var(--line); background:#fff; margin:0 0 10px; }
        #meterPage .panel:last-child { margin-bottom:0; }
        #meterPage .panel-list { overflow:hidden; }
        #meterPage .panel-header { display:flex; align-items:center; justify-content:space-between; padding:13px 16px; border-bottom:1px solid var(--line); background:#fff; }
        #meterPage .panel-title { display:flex; align-items:center; gap:6px; margin:0; font-size:13px; font-weight:800; color:var(--text-head); }
        #meterPage .panel-title .material-symbols-rounded { font-size:17px; color:var(--accent); }
        #meterPage .panel-body { padding:14px 16px 16px; }

        /* 필터 */
        #meterPage .filter-grid { display:grid; grid-template-columns:1.2fr .8fr .75fr 1.45fr minmax(220px,2fr) auto; gap:8px 12px; align-items:end; }
        #meterPage .complex-filter-grid { grid-template-columns:1.2fr .8fr .75fr 1.45fr minmax(220px,2fr) auto; }
        /* 다운로드 모달 검침유형 체크박스 그룹 */
        #meterPage .meter-ty-checkbox-group { display:flex; align-items:center; gap:12px; height:32px; }
        #meterPage .meter-ty-check { display:inline-flex; align-items:center; gap:4px; font-size:12px; color:var(--text-head); cursor:pointer; user-select:none; }
        #meterPage .meter-ty-check input[type="checkbox"] { width:14px; height:14px; accent-color:var(--accent); cursor:pointer; }
        #meterPage .field-label { display:block; margin-bottom:5px; font-size:11px; font-weight:800; color:var(--text-sec); }
        #meterPage .form-select, #meterPage .form-input, #meterPage .form-textarea { width:100%; box-sizing:border-box; border:1px solid var(--line); background:#fff; border-radius:4px; font-family:'Noto Sans KR',sans-serif; color:#1f2d23; }
        #meterPage .form-select, #meterPage .form-input { height:32px; padding:0 9px; font-size:12px; }
        #meterPage .form-textarea { min-height:78px; padding:8px 9px; font-size:12px; resize:vertical; }
        #meterPage .form-select:focus, #meterPage .form-input:focus, #meterPage .form-textarea:focus { border-color:var(--accent); box-shadow:0 0 0 2px rgba(46,92,56,.08); outline:none; }
        #meterPage .date-range-inputs { display:grid; grid-template-columns:minmax(0,1fr) auto minmax(0,1fr); align-items:center; gap:5px; }
        #meterPage .date-filter-sep { color:#9ca3af; font-size:12px; text-align:center; }
        #meterPage .search-wrap { position:relative; }
        #meterPage .search-wrap .material-symbols-rounded { position:absolute; left:9px; top:50%; transform:translateY(-50%); font-size:15px; color:#9caa9e; pointer-events:none; }
        #meterPage .search-wrap input { padding-left:30px; }
        #meterPage .filter-actions { display:flex; justify-content:flex-end; gap:7px; white-space:nowrap; }

        /* 목록 */
        #meterPage .list-head-left { display:flex; align-items:center; gap:8px; }
        #meterPage .list-head-right { display:flex; align-items:center; justify-content:flex-end; gap:7px; margin-left:auto; }
        #meterPage .list-count { font-size:12px; font-weight:800; color:var(--accent); background:var(--accent-light); border-radius:4px; padding:3px 9px; white-space:nowrap; }
        #meterPage .table-wrap { overflow-x:visible; margin:0 -1px; }
        #meterPage .tbl { width:100%; min-width:0; border-collapse:collapse; table-layout:fixed; }
        #meterPage .tbl th { height:38px; padding:0 8px; background:var(--th-bg); border-bottom:1px solid var(--line); color:var(--text-sec); font-size:12px; font-weight:800; text-align:center; box-sizing:border-box; }
        #meterPage .tbl td { height:43px; padding:6px 8px; border-bottom:1px solid #eef1f3; color:#243027; font-size:12px; text-align:center; vertical-align:middle; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; box-sizing:border-box; }
        #meterPage .tbl tr:last-child td { border-bottom:none; }
        #meterPage .tbl tr:hover td { background:#f8fbf8; }
        #meterPage .sort-btn { display:inline-flex; align-items:center; justify-content:center; gap:3px; width:100%; height:100%; border:0; background:transparent; color:inherit; font:inherit; font-weight:800; cursor:pointer; }
        #meterPage .sort-btn:hover, #meterPage .sort-btn.active { color:var(--accent); }
        #meterPage .sort-icon { min-width:10px; color:var(--text-ter); font-size:10px; line-height:1; }
        #meterPage .sort-btn.active .sort-icon { color:var(--accent); }
        #meterPage .tbl .td-left { text-align:left; }
        #meterPage .tbl .td-right { text-align:right; }
        #meterPage .tbl .mono { font-family:'Consolas','SF Mono',monospace; font-size:11px; color:#66736a; }
        #meterPage .meter-main { color:#1f2d23; }
        #meterPage .meter-sub { margin-top:2px; font-family:'Consolas','SF Mono',monospace; font-size:11px; color:#66736a; }
        #meterPage .meter-no { font-family:'Consolas','SF Mono',monospace; font-size:11px; color:#66736a; }
        #meterPage .td-unit { text-align:center !important; }
        #meterPage .unit-value { display:inline-flex; align-items:baseline; justify-content:center; gap:3px; min-width:76px; }
        #meterPage .unit-label { color:#8a9a8e; font-size:10px; font-weight:700; }
        #meterPage .partner-cell { padding-left:10px !important; }
        #meterPage .facility-cell { padding-right:4px !important; }
        #meterPage .ho-cell { padding-left:4px !important; }
        #meterPage .row-actions { display:flex; align-items:center; justify-content:center; gap:5px; }
        #meterPage .empty-row { height:86px; color:var(--text-ter); font-size:13px; text-align:center !important; }

        /* 페이지네이션 */
        #meterPage .pagination-wrap { display:flex; align-items:center; justify-content:space-between; gap:10px; padding:11px 16px; border-top:1px solid var(--line); background:var(--surface-sub); }
        #meterPage .pagination-info { font-size:11px; color:var(--text-ter); white-space:nowrap; }
        #meterPage .pagination { display:flex; align-items:center; justify-content:flex-end; gap:4px; }
        #meterPage .page-btn { min-width:34px; height:32px; padding:0 10px; border:1px solid var(--line); border-radius:4px; background:#fff; color:#4b5563; font-size:12px; font-weight:700; cursor:pointer; }
        #meterPage .page-btn-nav { min-width:46px; }
        #meterPage .page-btn:hover:not(:disabled) { background:#f4f7f4; color:var(--accent); }
        #meterPage .page-btn.active { background:var(--accent); border-color:var(--accent); color:#fff; }
        #meterPage .page-btn:disabled { opacity:.45; cursor:not-allowed; }

        /* 컬럼 너비 */
        #meterPage .col-no { width:4%; }
        #meterPage .col-meter-no { width:10%; }
        #meterPage .col-meter-date { width:8%; }
        #meterPage .col-meter-ty { width:8%; }
        #meterPage .col-complex-unit { width:14%; }
        #meterPage .col-facility { width:18%; }
        #meterPage .col-ho { width:10%; }
        #meterPage .col-complex-value { width:9%; }
        #meterPage .col-facility-value { width:8%; }
        #meterPage .col-complex-usage { width:9%; }
        #meterPage .col-facility-usage { width:8%; }
        #meterPage .col-result { width:7%; }
        #meterPage .col-complex-partner { width:12%; }
        #meterPage .col-facility-partner { width:11%; }
        #meterPage .col-action { width:10%; }

        /* 상태 배지 */
        #meterPage .badge { display:inline-flex; align-items:center; justify-content:center; min-height:20px; padding:0 7px; border-radius:4px; font-size:11px; font-weight:700; border:1px solid transparent; white-space:nowrap; }
        #meterPage .badge-normal { background:#e8f1eb; color:#1f5a35; border-color:#bdd7c5; }
        #meterPage .badge-error { background:#fee2e2; color:#7f1d1d; border-color:#fecaca; }
        #meterPage .badge-miss { background:#fef3c7; color:#713f12; border-color:#fde68a; }
        #meterPage .badge-check { background:#ffedd5; color:#9a3412; border-color:#fed7aa; }
        #meterPage .badge-gray { background:#f3f4f6; color:#4b5563; border-color:#d1d5db; }
        #meterPage .need-check { display:block; margin-top:3px; font-size:10px; color:#b45309; font-weight:800; }

        /* 모달 */
        #meterPage .modal-overlay { display:none; position:fixed; inset:0; z-index:1000; align-items:center; justify-content:center; padding:24px; background:rgba(15,23,42,.35); box-sizing:border-box; }
        #meterPage .modal-overlay.open, #meterPage .modal-overlay.is-open { display:flex; }
        #meterPage .modal { width:min(720px,96vw); max-height:88vh; display:flex; flex-direction:column; background:#fff; border:1px solid var(--line); border-radius:8px; box-shadow:0 18px 45px rgba(15,23,42,.22); overflow:hidden; }
        #meterPage .modal.modal-sm { width:min(600px,96vw); }
        #meterPage .modal-header { display:flex; align-items:center; justify-content:space-between; min-height:48px; padding:0 18px; border-bottom:1px solid var(--line); background:var(--text-head); }
        #meterPage .modal-title { margin:0; color:#fff; font-size:14px; font-weight:700; }
        #meterPage .modal-close { border:0; background:rgba(255,255,255,.12); cursor:pointer; color:rgba(255,255,255,.75); width:28px; height:28px; border-radius:4px; display:flex; align-items:center; justify-content:center; }
        #meterPage .modal-close:hover { background:rgba(255,255,255,.2); }
        #meterPage .modal-body { padding:18px; overflow-y:auto; flex:1; }
        #meterPage .field-help { margin-top:6px; color:#64748b; font-size:12px; line-height:1.35; }
        #meterPage .lookup-row { display:flex; gap:8px; align-items:center; }
        #meterPage .lookup-row .form-input { flex:1; }
        #meterPage .modal-footer { display:flex; justify-content:flex-end; gap:8px; padding:12px 18px; border-top:1px solid var(--line); background:var(--surface-sub); }
        #meterPage .unit-suffix { margin-left:6px; color:#6b7280; font-size:12px; font-weight:600; }
        #meterPage .readonly-box.is-hidden-section, #meterPage .is-hidden-section { display:none !important; }

        /* 모달 폼 */
        #meterPage .form-section { margin-bottom:18px; }
        #meterPage .form-section:last-child { margin-bottom:0; }
        #meterPage .form-section-title { display:flex; align-items:center; gap:5px; margin-bottom:10px; padding-bottom:8px; border-bottom:1px solid var(--line); color:var(--text-head); font-size:12px; font-weight:800; }
        #meterPage .form-section-title .material-symbols-rounded { font-size:15px; color:var(--accent); }
        #meterPage .form-row { display:grid; gap:10px 12px; margin-bottom:10px; }
        #meterPage .form-row.cols-2 { grid-template-columns:1fr 1fr; }
        #meterPage .form-row.cols-3 { grid-template-columns:1fr 1fr 1fr; }
        #meterPage .form-field { display:flex; flex-direction:column; gap:4px; }
        #meterPage .field-help { font-size:11px; color:var(--text-ter); line-height:1.45; margin-top:2px; }
        #meterPage .readonly-box { min-height:32px; display:flex; align-items:center; padding:0 9px; border:1px solid #e5e7eb; border-radius:4px; background:#f8fafc; color:#374151; font-size:12px; box-sizing:border-box; }
        #meterPage .readonly-box.multiline { min-height:60px; align-items:flex-start; padding:8px 9px; white-space:pre-wrap; word-break:break-all; }
        #meterPage .column-box { border:1px solid #e5e7eb; border-radius:4px; background:#f8fafc; padding:10px; color:#4b5563; font-size:11px; line-height:1.6; }
        #meterPage .column-box code { font-family:'Consolas','SF Mono',monospace; color:#1f2d23; }

        /* CSV 확인 결과 */
        #meterPage .csv-preview-box { display:none; margin-top:10px; border:1px solid #c9d9cc; border-radius:6px; background:#f8fbf8; overflow:hidden; }
        #meterPage .csv-preview-box.visible { display:block; }
        #meterPage .csv-preview-head { padding:10px 12px; border-bottom:1px solid #d9e5dc; background:#f0f4f1; font-size:12px; font-weight:800; color:var(--text-head); }
        #meterPage .csv-preview-body { padding:10px 12px; }
        #meterPage .csv-preview-grid { display:grid; grid-template-columns:90px minmax(0,1fr); gap:6px 10px; margin-bottom:10px; font-size:11px; line-height:1.45; }
        #meterPage .csv-preview-label { color:#5f6f64; font-weight:800; }
        #meterPage .csv-preview-value { color:#1f2d23; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }
        #meterPage .preview-table-wrap { overflow-x:auto; border:1px solid #e5e7eb; border-radius:4px; background:#fff; }
        #meterPage .preview-table { width:100%; border-collapse:collapse; min-width:640px; table-layout:fixed; }
        #meterPage .preview-table th, #meterPage .preview-table td { height:30px; padding:5px 7px; border-bottom:1px solid #eef1f3; font-size:11px; text-align:center; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
        #meterPage .preview-table th { background:#f3f5f4; color:#4b5b50; font-weight:800; }
        #meterPage .preview-msg { margin-top:8px; font-size:11px; line-height:1.45; color:#166534; font-weight:700; }
        #meterPage .preview-msg.error { color:#991b1b; }
        #meterPage .preview-msg.warn { color:#92400e; }

        /* 반응형 */
        @media(max-width:1200px) { #meterPage .filter-grid { grid-template-columns:repeat(3,minmax(0,1fr)); } }
        @media(max-width:760px) {
            #meterPage .filter-grid { grid-template-columns:1fr; }
            #meterPage .form-row.cols-2, #meterPage .form-row.cols-3 { grid-template-columns:1fr; }
            #meterPage .panel-header, #meterPage .section-heading { flex-direction:column; align-items:flex-start; gap:8px; }
            #meterPage .section-actions { width:100%; justify-content:flex-start; }
        }
    </style>
</head>
<body>
<div class="app-wrapper">
    <%@ include file="/WEB-INF/views/include/office_sidebar.jsp" %>

    <div class="main-wrap">
        <%@ include file="/WEB-INF/views/include/office_header.jsp" %>

        <main class="main-content">
            <div class="office-page" id="meterPage">

                <div class="page-header">
                    <div class="page-title-block">
                        <h2>검침 이력 관리</h2>
                        <p>단지별 검침과 시설 검침 이력을 탭으로 구분하여 조회합니다.</p>
                    </div>
                </div>

                <%-- 검침 탭 영역 --%>
                <div class="meter-tab-wrap">
                    <input type="radio" class="meter-tab-input" name="meterTab" id="meterTabComplex" <c:if test="${activeMeterScope ne 'FACILITY'}">checked</c:if>>
                    <input type="radio" class="meter-tab-input" name="meterTab" id="meterTabFacility" <c:if test="${activeMeterScope eq 'FACILITY'}">checked</c:if>>

                    <div class="meter-tab-labels" role="tablist" aria-label="검침 구분">
                        <label class="meter-tab-label" for="meterTabComplex" role="tab">
                            <span class="material-symbols-rounded">apartment</span>단지별 검침
                        </label>
                        <label class="meter-tab-label" for="meterTabFacility" role="tab">
                            <span class="material-symbols-rounded">electric_meter</span>시설 검침
                        </label>
                    </div>

                    <div class="meter-tab-content">

                        <%-- ===== 단지별 검침 패널 ===== --%>
                        <section class="meter-section complex-meter-section meter-tab-panel" id="complexMeterPanel">
                            <div class="section-heading">
                                <div class="section-title-wrap">
                                    <h3 class="section-title"><span class="material-symbols-rounded">apartment</span>단지별 검침</h3>
                                    <p class="section-desc">동·호 기준 검침 이력을 조회합니다.</p>
                                </div>
                            </div>

                            <div class="panel">
                                <div class="panel-header">
                                    <h3 class="panel-title"><span class="material-symbols-rounded">manage_search</span>단지별 검침 검색 조건</h3>
                                </div>
                                <div class="panel-body">
                                    <form method="get" action="${ctx}/manager/meter/hstry/${mgmtOfcNo}" id="complexSearchForm">
                                        <%-- 협력업체 상세에서 넘어온 partnerNo 필터를 검색 후에도 유지함 --%>
                                        <input type="hidden" name="partnerNo" value="${complexSearch.partnerNo}">
                                        <%-- 검색 후에도 단지별 검침 탭을 유지함 --%>
                                        <input type="hidden" name="meterScope" value="COMPLEX">
                                        <div class="filter-grid complex-filter-grid">
                                            <div class="form-field">
                                                <label class="field-label" for="complexUtilityProviderNo">공급/검침 업체</label>
                                                <select class="form-select" id="complexUtilityProviderNo" name="complexUtilityProviderNo">
                                                    <option value="">전체</option>
                                                    <%-- 단지별 검침 이력이 있는 업체만 노출 (다운로드 모달과 동일 규칙) --%>
                                                    <c:forEach var="provider" items="${complexProviderList}">
                                                        <c:choose>
                                                            <c:when test="${empty provider.utilityProviderNo}">
                                                                <option value="" disabled>[설정 필요] ${provider.partnerNm}<c:if test="${not empty provider.contNm}"> / ${provider.contNm}</c:if></option>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <option value="${provider.utilityProviderNo}" <c:if test="${complexSearch.utilityProviderNo eq provider.utilityProviderNo}">selected</c:if>>
                                                                    <c:if test="${not empty provider.meterTyNm}">[${provider.meterTyNm}] </c:if>${provider.partnerNm}<c:if test="${not empty provider.contNm}"> / ${provider.contNm}</c:if>
                                                                </option>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                            <div class="form-field">
                                                <label class="field-label" for="complexMeterTyCd">검침유형</label>
                                                <select class="form-select" id="complexMeterTyCd" name="complexMeterTyCd">
                                                    <option value="">전체</option>
                                                    <c:forEach var="code" items="${meterTyCodeList}">
                                                        <c:if test="${code.codeNoCd ne 'HEAT'}">
                                                            <option value="${code.codeNoCd}" <c:if test="${complexSearch.meterTyCd eq code.codeNoCd}">selected</c:if>>${code.codeName}</option>
                                                        </c:if>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                            <div class="form-field">
                                                <label class="field-label" for="complexMeterRsltCd">결과</label>
                                                <select class="form-select" id="complexMeterRsltCd" name="complexMeterRsltCd">
                                                    <option value="">전체</option>
                                                    <c:forEach var="code" items="${rsltCodeList}">
                                                        <option value="${code.codeNoCd}" <c:if test="${complexSearch.meterRsltCd eq code.codeNoCd}">selected</c:if>>${code.codeName}</option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                            <div class="form-field">
                                                <label class="field-label">검침일자</label>
                                                <div class="date-range-inputs">
                                                    <input type="date" class="form-input" id="complexStartDt" name="complexStartDt" value="${complexSearch.startDt}">
                                                    <span class="date-filter-sep">~</span>
                                                    <input type="date" class="form-input" id="complexEndDt" name="complexEndDt" value="${complexSearch.endDt}">
                                                </div>
                                            </div>
                                            <div class="form-field">
                                                <label class="field-label" for="complexKeyword">동/호 검색</label>
                                                <div class="search-wrap">
                                                    <span class="material-symbols-rounded">search</span>
                                                    <input type="text" class="form-input" id="complexKeyword" name="complexKeyword" value="${complexSearch.keyword}" placeholder="동, 호번호 또는 MH로 시작하는 검침번호">
                                                </div>
                                            </div>
                                            <div class="form-field">
                                                <label class="field-label">&nbsp;</label>
                                                <div class="filter-actions">
                                                    <button type="submit" class="btn btn-primary">검색</button>
                                                    <a href="${meterResetUrl}" class="btn">초기화</a>
                                                </div>
                                            </div>
                                        </div>
                                    </form>
                                </div>
                            </div>

                            <div class="panel panel-list">
                                <div class="panel-header">
                                    <div class="list-head-left">
                                        <h3 class="panel-title"><span class="material-symbols-rounded">format_list_bulleted</span>단지별 검침 목록</h3>
                                        <span class="list-count">총 ${complexTotalCount}건</span>
                                    </div>
                                    <div class="list-head-right">
                                        <%-- CSV 다운로드 모달 진입 --%>
                                        <button type="button" class="btn js-download-btn" data-default-scope="COMPLEX">
                                            <span class="material-symbols-rounded">download</span>CSV 다운로드
                                        </button>
                                        <button type="button" class="btn btn-primary" id="openComplexUploadModalBtn">
                                            <span class="material-symbols-rounded">upload_file</span>단지별 검침 CSV 업로드
                                        </button>
                                    </div>
                                </div>
                                <div class="table-wrap">
                                    <table class="tbl">
                                        <colgroup>
                                            <col class="col-no"><col class="col-meter-no"><col class="col-meter-ty"><col class="col-meter-date">
                                            <col class="col-complex-unit"><col class="col-complex-value"><col class="col-complex-value">
                                            <col class="col-complex-usage"><col class="col-result"><col class="col-complex-partner"><col class="col-action">
                                        </colgroup>
                                        <thead>
                                        <tr>
                                            <th>번호</th><th><button type="button" class="sort-btn js-sort-btn" data-sort-field="METER_HSTRY_NO">검침번호<span class="sort-icon"></span></button></th><th>검침유형</th>
                                            <th><button type="button" class="sort-btn js-sort-btn" data-sort-field="METER_DT">검침일자<span class="sort-icon"></span></button></th>
                                            <th><button type="button" class="sort-btn js-sort-btn" data-sort-field="HO_NO">동/호<span class="sort-icon"></span></button></th>
                                            <th><button type="button" class="sort-btn js-sort-btn" data-sort-field="PRE_VAL">이전값<span class="sort-icon"></span></button></th>
                                            <th><button type="button" class="sort-btn js-sort-btn" data-sort-field="CURR_VAL">현재값<span class="sort-icon"></span></button></th>
                                            <th><button type="button" class="sort-btn js-sort-btn" data-sort-field="USAGE_VAL">사용량<span class="sort-icon"></span></button></th>
                                            <th>결과</th><th>업체</th><th>관리</th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        <c:choose>
                                            <c:when test="${empty complexMeterList}">
                                                <tr><td colspan="11" class="empty-row">조회된 단지별 검침 이력이 없습니다.</td></tr>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach var="row" items="${complexMeterList}" varStatus="status">
                                                    <tr class="js-page-row" data-page-target="complex">
                                                        <c:set var="meterUnit" value="" />
                                                        <c:if test="${row.meterTyCd eq 'ELEC'}"><c:set var="meterUnit" value="kWh" /></c:if>
                                                        <c:if test="${row.meterTyCd eq 'GAS' or row.meterTyCd eq 'WATER'}"><c:set var="meterUnit" value="㎥" /></c:if>
                                                        <c:if test="${row.meterTyCd eq 'HEAT'}"><c:set var="meterUnit" value="Gcal" /></c:if>
                                                        <c:set var="hoParts" value="${fn:split(row.hoNo, '_')}" />
                                                        <td class="mono">${complexStartNo - status.index}</td>
                                                        <td class="meter-no">${row.meterHstryNo}</td>
                                                        <td><span class="badge badge-gray">${empty row.meterTyNm ? '-' : row.meterTyNm}</span></td>
                                                        <td><fmt:formatDate value="${row.meterDt}" pattern="yyyy.MM.dd"/></td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${fn:length(hoParts) ge 3}">
                                                                    <div class="meter-main">${hoParts[1]}동 ${hoParts[2]}호</div>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <div class="meter-main">${empty row.hoNo ? '-' : row.hoNo}</div>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td class="td-unit"><span class="unit-value"><fmt:formatNumber value="${row.preVal}" groupingUsed="false" maxFractionDigits="2"/><span class="unit-label">${meterUnit}</span></span></td>
                                                        <td class="td-unit"><span class="unit-value"><fmt:formatNumber value="${row.currVal}" groupingUsed="false" maxFractionDigits="2"/><span class="unit-label">${meterUnit}</span></span></td>
                                                        <td class="td-unit"><span class="unit-value"><fmt:formatNumber value="${row.currVal - row.preVal}" groupingUsed="false" maxFractionDigits="2"/><span class="unit-label">${meterUnit}</span></span></td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${row.meterRsltCd eq 'NORMAL'}"><span class="badge badge-normal">${row.meterRsltNm}</span></c:when>
                                                                <c:when test="${row.meterRsltCd eq 'ERROR'}"><span class="badge badge-error">${row.meterRsltNm}</span><span class="need-check">확인 필요</span></c:when>
                                                                <c:when test="${row.meterRsltCd eq 'MISS'}"><span class="badge badge-miss">${row.meterRsltNm}</span><span class="need-check">확인 필요</span></c:when>
                                                                <c:when test="${row.meterRsltCd eq 'CHECK'}"><span class="badge badge-check">${row.meterRsltNm}</span><span class="need-check">확인 필요</span></c:when>
                                                                <c:otherwise><span class="badge badge-gray">${empty row.meterRsltCd ? '-' : row.meterRsltCd}</span></c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td><div>${row.partnerNm}</div></td>
                                                        <td>
                                                            <div class="row-actions">
                                                                <button type="button" class="btn btn-sm btn-ghost js-detail-btn" data-meter-hstry-no="${row.meterHstryNo}">상세</button>
                                                                <button type="button" class="btn btn-sm btn-edit js-edit-btn" data-meter-hstry-no="${row.meterHstryNo}">수정</button>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:otherwise>
                                        </c:choose>
                                        </tbody>
                                    </table>
                                </div>
                                <div class="pagination-wrap" data-pagination-target="complex" data-scope="COMPLEX" data-total-count="${complexTotalCount}" data-current-page="${meterPage}" data-page-size="${meterPageSize}">
                                    <div class="pagination-info" id="complexPaginationInfo">총 0건</div>
                                    <div class="pagination" id="complexPagination"></div>
                                </div>
                            </div>
                        </section>

                        <%-- ===== 시설 검침 패널 ===== --%>
                        <section class="meter-section facility-meter-section meter-tab-panel" id="facilityMeterPanel">
                            <div class="section-heading">
                                <div class="section-title-wrap">
                                    <h3 class="section-title"><span class="material-symbols-rounded">electric_meter</span>시설 검침</h3>
                                    <p class="section-desc">시설자산 기준 검침 이력을 조회합니다.</p>
                                </div>
                            </div>

                            <div class="panel">
                                <div class="panel-header">
                                    <h3 class="panel-title"><span class="material-symbols-rounded">manage_search</span>시설 검침 검색 조건</h3>
                                </div>
                                <div class="panel-body">
                                    <form method="get" action="${ctx}/manager/meter/hstry/${mgmtOfcNo}" id="facilitySearchForm">
                                        <%-- 협력업체 상세에서 넘어온 partnerNo 필터를 검색 후에도 유지함 --%>
                                        <input type="hidden" name="partnerNo" value="${search.partnerNo}">
                                        <%-- 검색 후에도 시설 검침 탭을 유지함 --%>
                                        <input type="hidden" name="meterScope" value="FACILITY">
                                        <div class="filter-grid">
                                            <div class="form-field">
                                                <label class="field-label" for="filterUtilityProviderNo">공급/검침 업체</label>
                                                <select class="form-select" id="filterUtilityProviderNo" name="utilityProviderNo">
                                                    <option value="">전체</option>
                                                    <%-- 시설 검침 이력이 있는 업체만 노출 (다운로드 모달과 동일 규칙) --%>
                                                    <c:forEach var="provider" items="${facilityProviderList}">
                                                        <c:choose>
                                                            <c:when test="${empty provider.utilityProviderNo}">
                                                                <option value="" disabled>[설정 필요] ${provider.partnerNm}<c:if test="${not empty provider.contNm}"> / ${provider.contNm}</c:if></option>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <option value="${provider.utilityProviderNo}" <c:if test="${search.utilityProviderNo eq provider.utilityProviderNo}">selected</c:if>>
                                                                    <c:if test="${not empty provider.meterTyNm}">[${provider.meterTyNm}] </c:if>${provider.partnerNm}<c:if test="${not empty provider.contNm}"> / ${provider.contNm}</c:if>
                                                                </option>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                            <div class="form-field">
                                                <label class="field-label" for="filterMeterTyCd">검침유형</label>
                                                <select class="form-select" id="filterMeterTyCd" name="meterTyCd">
                                                    <option value="">전체</option>
                                                    <c:forEach var="code" items="${meterTyCodeList}">
                                                        <c:if test="${code.codeNoCd ne 'HEAT'}">
                                                            <option value="${code.codeNoCd}" <c:if test="${search.meterTyCd eq code.codeNoCd}">selected</c:if>>${code.codeName}</option>
                                                        </c:if>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                            <div class="form-field">
                                                <label class="field-label" for="filterMeterRsltCd">결과</label>
                                                <select class="form-select" id="filterMeterRsltCd" name="meterRsltCd">
                                                    <option value="">전체</option>
                                                    <c:forEach var="code" items="${rsltCodeList}">
                                                        <option value="${code.codeNoCd}" <c:if test="${search.meterRsltCd eq code.codeNoCd}">selected</c:if>>${code.codeName}</option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                            <div class="form-field">
                                                <label class="field-label">검침일자</label>
                                                <div class="date-range-inputs">
                                                    <input type="date" class="form-input" id="filterStartDt" name="startDt" value="${search.startDt}">
                                                    <span class="date-filter-sep">~</span>
                                                    <input type="date" class="form-input" id="filterEndDt" name="endDt" value="${search.endDt}">
                                                </div>
                                            </div>
                                            <div class="form-field">
                                                <label class="field-label" for="filterKeyword">시설 검색</label>
                                                <div class="search-wrap">
                                                    <span class="material-symbols-rounded">search</span>
                                                    <input type="text" class="form-input" id="filterKeyword" name="keyword" value="${search.keyword}" placeholder="시설명, 시설번호, 검침번호">
                                                </div>
                                            </div>
                                            <div class="form-field">
                                                <label class="field-label">&nbsp;</label>
                                                <div class="filter-actions">
                                                    <button type="submit" class="btn btn-primary">검색</button>
                                                    <a href="${meterResetUrl}" class="btn">초기화</a>
                                                </div>
                                            </div>
                                        </div>
                                    </form>
                                </div>
                            </div>

                            <div class="panel panel-list">
                                <div class="panel-header">
                                    <div class="list-head-left">
                                        <h3 class="panel-title"><span class="material-symbols-rounded">format_list_bulleted</span>시설 검침 목록</h3>
                                        <span class="list-count">총 ${facilityTotalCount}건</span>
                                    </div>
                                    <div class="list-head-right">
                                        <%-- CSV 다운로드 모달 진입 --%>
                                        <button type="button" class="btn js-download-btn" data-default-scope="FACILITY">
                                            <span class="material-symbols-rounded">download</span>CSV 다운로드
                                        </button>
                                        <button type="button" class="btn btn-primary" id="openFacilityUploadModalBtn">
                                            <span class="material-symbols-rounded">upload_file</span>시설 검침 CSV 업로드
                                        </button>
                                    </div>
                                </div>
                                <div class="table-wrap">
                                    <table class="tbl">
                                        <colgroup>
                                            <col class="col-no"><col class="col-meter-no"><col class="col-meter-ty"><col class="col-meter-date">
                                            <col class="col-facility"><col class="col-facility-value"><col class="col-facility-value">
                                            <col class="col-facility-usage"><col class="col-result"><col class="col-facility-partner"><col class="col-action">
                                        </colgroup>
                                        <thead>
                                        <tr>
                                            <th>번호</th><th><button type="button" class="sort-btn js-sort-btn" data-sort-field="METER_HSTRY_NO">검침번호<span class="sort-icon"></span></button></th><th>검침유형</th>
                                            <th><button type="button" class="sort-btn js-sort-btn" data-sort-field="METER_DT">검침일자<span class="sort-icon"></span></button></th>
                                            <th class="td-left">시설</th>
                                            <th><button type="button" class="sort-btn js-sort-btn" data-sort-field="PRE_VAL">이전값<span class="sort-icon"></span></button></th>
                                            <th><button type="button" class="sort-btn js-sort-btn" data-sort-field="CURR_VAL">현재값<span class="sort-icon"></span></button></th>
                                            <th><button type="button" class="sort-btn js-sort-btn" data-sort-field="USAGE_VAL">사용량<span class="sort-icon"></span></button></th>
                                            <th>결과</th><th>업체</th><th>관리</th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        <c:choose>
                                            <c:when test="${empty facilityMeterList}">
                                                <tr><td colspan="11" class="empty-row">조회된 시설 검침 이력이 없습니다.</td></tr>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach var="row" items="${facilityMeterList}" varStatus="status">
                                                    <tr class="js-page-row" data-page-target="facility">
                                                        <c:set var="meterUnit" value="" />
                                                        <c:if test="${row.meterTyCd eq 'ELEC'}"><c:set var="meterUnit" value="kWh" /></c:if>
                                                        <c:if test="${row.meterTyCd eq 'GAS' or row.meterTyCd eq 'WATER'}"><c:set var="meterUnit" value="㎥" /></c:if>
                                                        <c:if test="${row.meterTyCd eq 'HEAT'}"><c:set var="meterUnit" value="Gcal" /></c:if>
                                                        <td class="mono">${facilityStartNo - status.index}</td>
                                                        <td class="meter-no">${row.meterHstryNo}</td>
                                                        <td><span class="badge badge-gray">${empty row.meterTyNm ? '-' : row.meterTyNm}</span></td>
                                                        <td><fmt:formatDate value="${row.meterDt}" pattern="yyyy.MM.dd"/></td>
                                                        <td class="td-left facility-cell">
                                                            <div class="meter-main">${row.facilityNm}</div>
                                                            <div class="meter-sub">${row.facilityNo} · ${row.facilityTyNm}</div>
                                                        </td>
                                                        <td class="td-unit"><span class="unit-value"><fmt:formatNumber value="${row.preVal}" groupingUsed="false" maxFractionDigits="2"/><span class="unit-label">${meterUnit}</span></span></td>
                                                        <td class="td-unit"><span class="unit-value"><fmt:formatNumber value="${row.currVal}" groupingUsed="false" maxFractionDigits="2"/><span class="unit-label">${meterUnit}</span></span></td>
                                                        <td class="td-unit"><span class="unit-value"><fmt:formatNumber value="${row.currVal - row.preVal}" groupingUsed="false" maxFractionDigits="2"/><span class="unit-label">${meterUnit}</span></span></td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${row.meterRsltCd eq 'NORMAL'}"><span class="badge badge-normal">${row.meterRsltNm}</span></c:when>
                                                                <c:when test="${row.meterRsltCd eq 'ERROR'}"><span class="badge badge-error">${row.meterRsltNm}</span><span class="need-check">확인 필요</span></c:when>
                                                                <c:when test="${row.meterRsltCd eq 'MISS'}"><span class="badge badge-miss">${row.meterRsltNm}</span><span class="need-check">확인 필요</span></c:when>
                                                                <c:when test="${row.meterRsltCd eq 'CHECK'}"><span class="badge badge-check">${row.meterRsltNm}</span><span class="need-check">확인 필요</span></c:when>
                                                                <c:otherwise><span class="badge badge-gray">${empty row.meterRsltCd ? '-' : row.meterRsltCd}</span></c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td><div>${row.partnerNm}</div></td>
                                                        <td>
                                                            <div class="row-actions">
                                                                <button type="button" class="btn btn-sm btn-ghost js-detail-btn" data-meter-hstry-no="${row.meterHstryNo}">상세</button>
                                                                <button type="button" class="btn btn-sm btn-edit js-edit-btn" data-meter-hstry-no="${row.meterHstryNo}">수정</button>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:otherwise>
                                        </c:choose>
                                        </tbody>
                                    </table>
                                </div>
                                <div class="pagination-wrap" data-pagination-target="facility" data-scope="FACILITY" data-total-count="${facilityTotalCount}" data-current-page="${meterPage}" data-page-size="${meterPageSize}">
                                    <div class="pagination-info" id="facilityPaginationInfo">총 0건</div>
                                    <div class="pagination" id="facilityPagination"></div>
                                </div>
                            </div>
                        </section>

                    </div>
                </div>

                <%-- ===== 단지별 CSV 업로드 모달 ===== --%>
                <div class="modal-overlay" id="complexUploadModal">
                    <div class="modal">
                        <div class="modal-header">
                            <h3 class="modal-title">단지별 검침 CSV 업로드</h3>
                            <button type="button" class="modal-close js-modal-close" data-modal-id="complexUploadModal">
                                <span class="material-symbols-rounded">close</span>
                            </button>
                        </div>
                        <form method="post" action="${ctx}/manager/meter/hstry/upload/${mgmtOfcNo}" enctype="multipart/form-data" id="complexMeterCsvUploadForm">
                            <sec:csrfInput/>
                            <input type="hidden" name="meterScope" value="COMPLEX">
                            <input type="hidden" name="utilityProviderNo" id="complexMatchedUtilityProviderNo">
                            <div class="modal-body">
                                <div class="form-section">
                                    <div class="form-section-title"><span class="material-symbols-rounded">upload_file</span>CSV 파일 선택 및 자동 확인</div>
                                    <div class="form-row cols-2">
                                        <div class="form-field">
                                            <label class="field-label" for="complexCsvFile">CSV 파일</label>
                                            <input type="file" class="form-input" id="complexCsvFile" name="csvFile" accept=".csv,text/csv" required>
                                            <div class="field-help">파일을 선택한 뒤 CSV 확인을 누르면 식별키 기준으로 검침 설정과 계약 정보를 자동으로 찾습니다.</div>
                                        </div>
                                        <div class="form-field">
                                            <label class="field-label">파일 확인</label>
                                            <button type="button" class="btn btn-primary" id="complexPreviewBtn">
                                                <span class="material-symbols-rounded">fact_check</span>CSV 확인
                                            </button>
                                            <div class="field-help">단지별 CSV는 동/호 식별값이 포함되어야 합니다.</div>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-section">
                                    <div class="form-section-title"><span class="material-symbols-rounded">description</span>CSV 안내</div>
                                    <div class="column-box">
                                        <strong>필수 값</strong><br>
                                        검침일자, 이전값, 현재값, 검침결과, 검침내용, 동/호 식별값<br><br>
                                        <strong>시스템 확인 값</strong><br>
                                        CSV 식별키와 외부 고객번호는 검침 업체가 제공한 파일이 어떤 검침 설정에 해당하는지 확인하는 값입니다.
                                    </div>
                                </div>
                                <div class="csv-preview-box" id="complexPreviewBox">
                                    <div class="csv-preview-head">CSV 확인 결과</div>
                                    <div class="csv-preview-body">
                                        <div class="csv-preview-grid" id="complexPreviewSummary"></div>
                                        <div class="preview-table-wrap">
                                            <table class="preview-table">
                                                <thead>
                                                <tr>
                                                    <th>행</th><th>검침유형</th><th>동/호</th><th>검침일자</th><th>이전값</th><th>현재값</th><th>결과</th>
                                                </tr>
                                                </thead>
                                                <tbody id="complexPreviewRows"></tbody>
                                            </table>
                                        </div>
                                        <div class="preview-msg" id="complexPreviewMessage">CSV를 확인해주세요.</div>
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn js-modal-close" data-modal-id="complexUploadModal">취소</button>
                                <button type="submit" class="btn btn-primary" id="complexUploadSubmitBtn" disabled>업로드</button>
                            </div>
                        </form>
                    </div>
                </div>

                <%-- ===== 시설 CSV 업로드 모달 ===== --%>
                <div class="modal-overlay" id="facilityUploadModal">
                    <div class="modal">
                        <div class="modal-header">
                            <h3 class="modal-title">시설 검침 CSV 업로드</h3>
                            <button type="button" class="modal-close js-modal-close" data-modal-id="facilityUploadModal">
                                <span class="material-symbols-rounded">close</span>
                            </button>
                        </div>
                        <form method="post" action="${ctx}/manager/meter/hstry/upload/${mgmtOfcNo}" enctype="multipart/form-data" id="facilityMeterCsvUploadForm">
                            <sec:csrfInput/>
                            <input type="hidden" name="meterScope" value="FACILITY">
                            <input type="hidden" name="utilityProviderNo" id="facilityMatchedUtilityProviderNo">
                            <div class="modal-body">
                                <div class="form-section">
                                    <div class="form-section-title"><span class="material-symbols-rounded">upload_file</span>CSV 파일 선택 및 자동 확인</div>
                                    <div class="form-row cols-2">
                                        <div class="form-field">
                                            <label class="field-label" for="facilityCsvFile">CSV 파일</label>
                                            <input type="file" class="form-input" id="facilityCsvFile" name="csvFile" accept=".csv,text/csv" required>
                                            <div class="field-help">파일을 선택한 뒤 CSV 확인을 누르면 식별키 기준으로 검침 설정과 계약 정보를 자동으로 찾습니다.</div>
                                        </div>
                                        <div class="form-field">
                                            <label class="field-label">파일 확인</label>
                                            <button type="button" class="btn btn-primary" id="facilityPreviewBtn">
                                                <span class="material-symbols-rounded">fact_check</span>CSV 확인
                                            </button>
                                            <div class="field-help">시설 CSV는 시설번호가 포함되어야 합니다.</div>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-section">
                                    <div class="form-section-title"><span class="material-symbols-rounded">description</span>CSV 안내</div>
                                    <div class="column-box">
                                        <strong>필수 값</strong><br>
                                        검침일자, 이전값, 현재값, 검침결과, 검침내용, 시설번호<br><br>
                                        <strong>시스템 확인 값</strong><br>
                                        CSV 식별키와 외부 고객번호는 검침 업체가 제공한 파일이 어떤 검침 설정에 해당하는지 확인하는 값입니다.
                                    </div>
                                </div>
                                <div class="csv-preview-box" id="facilityPreviewBox">
                                    <div class="csv-preview-head">CSV 확인 결과</div>
                                    <div class="csv-preview-body">
                                        <div class="csv-preview-grid" id="facilityPreviewSummary"></div>
                                        <div class="preview-table-wrap">
                                            <table class="preview-table">
                                                <thead>
                                                <tr>
                                                    <th>행</th><th>검침유형</th><th>시설번호</th><th>검침일자</th><th>이전값</th><th>현재값</th><th>결과</th>
                                                </tr>
                                                </thead>
                                                <tbody id="facilityPreviewRows"></tbody>
                                            </table>
                                        </div>
                                        <div class="preview-msg" id="facilityPreviewMessage">CSV를 확인해주세요.</div>
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn js-modal-close" data-modal-id="facilityUploadModal">취소</button>
                                <button type="submit" class="btn btn-primary" id="facilityUploadSubmitBtn" disabled>업로드</button>
                            </div>
                        </form>
                    </div>
                </div>

                <%-- ===== 상세 모달 ===== --%>
                <%-- CSV 다운로드 조건 모달 --%>
                <div class="modal-overlay" id="meterDownloadModal">
                    <div class="modal modal-sm">
                        <div class="modal-header">
                            <h3 class="modal-title">검침 CSV 다운로드</h3>
                            <button type="button" class="modal-close js-modal-close" data-modal-id="meterDownloadModal">
                                <span class="material-symbols-rounded">close</span>
                            </button>
                        </div>
                        <form method="get" action="${ctx}/manager/meter/hstry/download/${mgmtOfcNo}" id="meterDownloadForm">
                            <div class="modal-body">
                                <div class="form-section">
                                    <div class="form-section-title"><span class="material-symbols-rounded">filter_alt</span>다운로드 조건</div>
                                    <div class="form-row cols-2">
                                        <div class="form-field">
                                            <%-- 검침 구분은 어느 탭에서 모달을 열었는지에 따라 자동 결정되므로 사용자 수정은 막음 --%>
                                            <label class="field-label" for="downloadMeterScope">검침 구분</label>
                                            <select class="form-select" id="downloadMeterScope" disabled>
                                                <option value="ALL">전체</option>
                                                <option value="COMPLEX">단지별</option>
                                                <option value="FACILITY">시설별</option>
                                            </select>
                                            <%-- 비활성 select는 form 제출에서 제외되므로 hidden으로 실제 값을 전송함 --%>
                                            <input type="hidden" name="meterScope" id="downloadMeterScopeHidden">
                                        </div>
                                        <div class="form-field">
                                            <label class="field-label" for="downloadMeterRsltCd">결과</label>
                                            <select class="form-select" name="meterRsltCd" id="downloadMeterRsltCd">
                                                <option value="">전체</option>
                                                <c:forEach var="code" items="${rsltCodeList}">
                                                    <option value="${code.codeNoCd}">${code.codeName}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>
                                    <%-- 업체는 옵션 라벨이 길어 한 줄을 통째로 차지하게 둠 --%>
                                    <%-- 업체 목록은 검침 스코프별로 분리해서 렌더링하고 JS에서 보이기/숨김 처리함 --%>
                                    <div class="form-row">
                                        <div class="form-field">
                                            <label class="field-label" for="downloadUtilityProviderNo">업체</label>
                                            <select class="form-select" name="utilityProviderNo" id="downloadUtilityProviderNo">
                                                <option value="" data-scope="ANY">전체</option>
                                                <%-- 단지별 검침에 실제 사용 이력이 있는 업체 --%>
                                                <c:forEach var="provider" items="${complexProviderList}">
                                                    <c:if test="${not empty provider.utilityProviderNo}">
                                                        <option value="${provider.utilityProviderNo}" data-meter-ty-cd="${provider.meterTyCd}" data-scope="COMPLEX">
                                                            <c:if test="${not empty provider.meterTyNm}">[${provider.meterTyNm}] </c:if>${provider.partnerNm}<c:if test="${not empty provider.contNm}"> / ${provider.contNm}</c:if>
                                                        </option>
                                                    </c:if>
                                                </c:forEach>
                                                <%-- 시설 검침에 실제 사용 이력이 있는 업체 --%>
                                                <c:forEach var="provider" items="${facilityProviderList}">
                                                    <c:if test="${not empty provider.utilityProviderNo}">
                                                        <option value="${provider.utilityProviderNo}" data-meter-ty-cd="${provider.meterTyCd}" data-scope="FACILITY">
                                                            <c:if test="${not empty provider.meterTyNm}">[${provider.meterTyNm}] </c:if>${provider.partnerNm}<c:if test="${not empty provider.contNm}"> / ${provider.contNm}</c:if>
                                                        </option>
                                                    </c:if>
                                                </c:forEach>
                                            </select>
                                            <input type="hidden" name="meterTyCd" id="downloadMeterTyCd">
                                        </div>
                                    </div>
                                    <%-- 기간 방식 선택 --%>
                                    <div class="form-row cols-2">
                                        <div class="form-field">
                                            <label class="field-label" for="downloadPeriodType">기간 방식</label>
                                            <select class="form-select" id="downloadPeriodType">
                                                <option value="MONTH">월별</option>
                                                <option value="RANGE">날짜범위</option>
                                            </select>
                                        </div>
                                        <div class="form-field" id="downloadMonthField">
                                            <label class="field-label" for="downloadMonth">관리년월</label>
                                            <input type="month" class="form-input" id="downloadMonth">
                                        </div>
                                    </div>
                                    <div class="form-row" id="downloadDateRangeField">
                                        <div class="form-field">
                                            <label class="field-label">검침일자</label>
                                            <div class="date-range-inputs">
                                                <input type="date" class="form-input" name="startDt" id="downloadStartDt">
                                                <span class="date-filter-sep">~</span>
                                                <input type="date" class="form-input" name="endDt" id="downloadEndDt">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <%-- 추가 필터: 검침유형 다중선택 + 동/호 범위(단지) + 검침값 범위 --%>
                                <div class="form-section">
                                    <div class="form-section-title">
                                        <span class="material-symbols-rounded">tune</span>추가 필터 (선택)
                                    </div>
                                    <div class="form-row">
                                        <div class="form-field">
                                            <label class="field-label">검침유형</label>
                                            <div class="meter-ty-checkbox-group">
                                                <label class="meter-ty-check"><input type="checkbox" name="meterTyCdList" value="ELEC">전기</label>
                                                <label class="meter-ty-check"><input type="checkbox" name="meterTyCdList" value="GAS">가스</label>
                                                <label class="meter-ty-check"><input type="checkbox" name="meterTyCdList" value="WATER">수도</label>
                                            </div>
                                        </div>
                                    </div>
                                    <%-- 동/호 범위: 단지별 검침일 때만 표시. 시설 검침은 동/호가 없음 --%>
                                    <div class="form-row cols-2" id="downloadDongHoRow">
                                        <div class="form-field">
                                            <label class="field-label">동 범위</label>
                                            <div class="date-range-inputs">
                                                <input type="number" class="form-input" name="dongStart" id="downloadDongStart" placeholder="시작">
                                                <span class="date-filter-sep">~</span>
                                                <input type="number" class="form-input" name="dongEnd" id="downloadDongEnd" placeholder="끝">
                                            </div>
                                        </div>
                                        <div class="form-field">
                                            <label class="field-label">호 범위</label>
                                            <div class="date-range-inputs">
                                                <input type="number" class="form-input" name="hoStart" id="downloadHoStart" placeholder="시작">
                                                <span class="date-filter-sep">~</span>
                                                <input type="number" class="form-input" name="hoEnd" id="downloadHoEnd" placeholder="끝">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-row cols-2">
                                        <div class="form-field">
                                            <label class="field-label">이전값 범위</label>
                                            <div class="date-range-inputs">
                                                <input type="number" step="any" class="form-input" name="preValStart" id="downloadPreValStart" placeholder="시작">
                                                <span class="date-filter-sep">~</span>
                                                <input type="number" step="any" class="form-input" name="preValEnd" id="downloadPreValEnd" placeholder="끝">
                                            </div>
                                        </div>
                                        <div class="form-field">
                                            <label class="field-label">현재값 범위</label>
                                            <div class="date-range-inputs">
                                                <input type="number" step="any" class="form-input" name="currValStart" id="downloadCurrValStart" placeholder="시작">
                                                <span class="date-filter-sep">~</span>
                                                <input type="number" step="any" class="form-input" name="currValEnd" id="downloadCurrValEnd" placeholder="끝">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-row">
                                        <div class="form-field">
                                            <label class="field-label">사용량 범위 (현재값 - 이전값)</label>
                                            <div class="date-range-inputs">
                                                <input type="number" step="any" class="form-input" name="usageValStart" id="downloadUsageValStart" placeholder="시작">
                                                <span class="date-filter-sep">~</span>
                                                <input type="number" step="any" class="form-input" name="usageValEnd" id="downloadUsageValEnd" placeholder="끝">
                                            </div>
                                        </div>
                                    </div>
                                    <%-- 모든 필터 입력 끝 → 검색어 + 조건 확인 (이 줄을 누르면 위의 모든 조건이 반영된 미리보기가 아래에 표시됨) --%>
                                    <div class="form-row cols-2">
                                        <div class="form-field">
                                            <label class="field-label" for="downloadKeyword">검색어</label>
                                            <input type="text" class="form-input" name="keyword" id="downloadKeyword" placeholder="검침번호, 동/호, 시설명, 시설번호, 업체명">
                                        </div>
                                        <div class="form-field">
                                            <label class="field-label">&nbsp;</label>
                                            <button type="button" class="btn btn-primary" id="downloadCheckBtn">
                                                <span class="material-symbols-rounded">search_check</span>조건 확인
                                            </button>
                                        </div>
                                    </div>
                                </div>
                                <%-- 다운로드 조건 확인 결과: 건수 + 상위 3행 샘플 미리보기 --%>
                                <input type="hidden" id="downloadCheckPassed" value="">
                                <div class="csv-preview-box visible" id="downloadCheckBox">
                                    <div class="csv-preview-head">
                                        <span class="material-symbols-rounded">preview</span>다운로드 미리보기
                                    </div>
                                    <div class="csv-preview-body">
                                        <div class="csv-preview-grid" id="downloadPreviewSummary"></div>
                                        <div class="preview-table-wrap" id="downloadPreviewTableWrap" style="display:none;">
                                            <table class="preview-table">
                                                <thead>
                                                <tr>
                                                    <th>구분</th>
                                                    <th>검침유형</th>
                                                    <th>검침일자</th>
                                                    <th>동/호</th>
                                                    <th>시설명</th>
                                                    <th>사용량</th>
                                                    <th>결과</th>
                                                </tr>
                                                </thead>
                                                <tbody id="downloadPreviewRows"></tbody>
                                            </table>
                                        </div>
                                        <div class="preview-msg" id="downloadCheckMessage">조건 확인을 누르면 상위 3건의 샘플과 총 다운로드 건수를 보여드립니다.</div>
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn js-modal-close" data-modal-id="meterDownloadModal">취소</button>
                                <button type="submit" class="btn btn-primary">
                                    <span class="material-symbols-rounded">download</span>다운로드
                                </button>
                            </div>
                        </form>
                    </div>
                </div>

                <div class="modal-overlay" id="meterDetailModal">
                    <div class="modal modal-sm">
                        <div class="modal-header">
                            <h3 class="modal-title">검침 이력 상세</h3>
                            <button type="button" class="modal-close js-modal-close" data-modal-id="meterDetailModal">
                                <span class="material-symbols-rounded">close</span>
                            </button>
                        </div>
                        <div class="modal-body">
                            <%-- 검침 정보 --%>
                            <div class="form-section">
                                <div class="form-section-title"><span class="material-symbols-rounded">electric_meter</span>검침 정보</div>
                                <div class="form-row cols-2">
                                    <div class="form-field"><label class="field-label">검침이력번호</label><div class="readonly-box" id="detailMeterHstryNo">-</div></div>
                                    <div class="form-field"><label class="field-label">검침유형</label><div class="readonly-box" id="detailMeterTyNm">-</div></div>
                                </div>
                                <div class="form-row cols-2">
                                    <div class="form-field"><label class="field-label">검침일자</label><div class="readonly-box" id="detailMeterDt">-</div></div>
                                    <div class="form-field"><label class="field-label">결과</label><div class="readonly-box" id="detailMeterRsltNm">-</div></div>
                                </div>
                                <div class="form-row cols-2">
                                    <div class="form-field"><label class="field-label">이전값</label><div class="readonly-box" id="detailPreVal">-</div></div>
                                    <div class="form-field"><label class="field-label">현재값</label><div class="readonly-box" id="detailCurrVal">-</div></div>
                                </div>
                                <div class="form-row">
                                    <div class="form-field"><label class="field-label">검침내용</label><div class="readonly-box multiline" id="detailMeterCn">-</div></div>
                                </div>
                            </div>
                            <%-- 단지 검침 대상 정보 --%>
                            <div class="form-section" id="detailComplexTargetSection">
                                <div class="form-section-title"><span class="material-symbols-rounded">apartment</span>단지 검침 대상</div>
                                <div class="form-row cols-2">
                                    <div class="form-field"><label class="field-label">동</label><div class="readonly-box" id="detailDongNo">-</div></div>
                                    <div class="form-field"><label class="field-label">호</label><div class="readonly-box" id="detailHoNo">-</div></div>
                                </div>
                            </div>
                            <%-- 시설 검침 대상 정보 --%>
                            <div class="form-section" id="detailFacilityTargetSection">
                                <div class="form-section-title"><span class="material-symbols-rounded">domain</span>시설 검침 대상</div>
                                <div class="form-row cols-2">
                                    <div class="form-field"><label class="field-label">시설명</label><div class="readonly-box" id="detailFacilityNm">-</div></div>
                                    <div class="form-field"><label class="field-label">시설유형</label><div class="readonly-box" id="detailFacilityTyNm">-</div></div>
                                </div>
                                <div class="form-row">
                                    <div class="form-field"><label class="field-label">상세위치</label><div class="readonly-box" id="detailLocCn">-</div></div>
                                </div>
                            </div>
                            <%-- 업체 정보 : 상세 모달에서는 업체명/담당자/연락처만 한 줄로 간단히 표시 --%>
                            <div class="form-section">
                                <div class="form-section-title"><span class="material-symbols-rounded">handshake</span>업체 정보</div>
                                <div class="form-row">
                                    <div class="form-field"><label class="field-label">업체</label><div class="readonly-box" id="detailPartnerSummary">-</div></div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn js-modal-close" data-modal-id="meterDetailModal">닫기</button>
                        </div>
                    </div>
                </div>

                <%-- ===== 수정 모달 ===== --%>
                <div class="modal-overlay" id="meterEditModal">
                    <div class="modal modal-sm">
                        <div class="modal-header">
                            <h3 class="modal-title">검침 이력 수정</h3>
                            <button type="button" class="modal-close js-modal-close" data-modal-id="meterEditModal">
                                <span class="material-symbols-rounded">close</span>
                            </button>
                        </div>
                                        <form method="post" action="${ctx}/manager/meter/hstry/update/${mgmtOfcNo}" id="meterEditForm">
                                            <sec:csrfInput/>
                                            <input type="hidden" name="meterHstryNo" id="editMeterHstryNo">
                                            <input type="hidden" name="returnQueryString" id="editReturnQueryString">
                            <div class="modal-body">
                                <div class="form-section">
                                    <div class="form-section-title"><span class="material-symbols-rounded">lock</span>변경 불가 정보</div>
                                    <div class="form-row cols-2">
                                        <div class="form-field"><label class="field-label">검침번호</label><div class="readonly-box" id="editReadonlyMeterHstryNo">-</div></div>
                                        <div class="form-field"><label class="field-label">검침유형</label><div class="readonly-box" id="editReadonlyMeterTyNm">-</div></div>
                                        <div class="form-field" id="editFacilityTargetRow"><label class="field-label">시설</label><div class="readonly-box" id="editReadonlyFacilityNm">-</div></div>
                                        <div class="form-field" id="editComplexTargetRow"><label class="field-label">동/호</label><div class="readonly-box" id="editReadonlyHoNo">-</div></div>
                                        <div class="form-field"><label class="field-label">업체</label><div class="readonly-box" id="editReadonlyPartnerNm">-</div></div>
                                    </div>
                                </div>
                                <div class="form-section">
                                    <div class="form-section-title"><span class="material-symbols-rounded">edit</span>수정 정보</div>
                                    <div class="form-row cols-2">
                                        <div class="form-field"><label class="field-label" for="editMeterDt">검침일자</label><input type="date" class="form-input" name="meterDt" id="editMeterDt" required></div>
                                        <div class="form-field">
                                            <label class="field-label" for="editMeterRsltCd">결과</label>
                                            <select class="form-select" name="meterRsltCd" id="editMeterRsltCd" required>
                                                <option value="">선택</option>
                                                <c:forEach var="code" items="${rsltCodeList}">
                                                    <option value="${code.codeNoCd}">${code.codeName}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-row cols-2">
                                        <div class="form-field"><label class="field-label" for="editPreVal">이전값 <span class="unit-suffix" id="editUnitLabel1">-</span></label><input type="number" step="0.01" class="form-input" name="preVal" id="editPreVal" required></div>
                                        <div class="form-field"><label class="field-label" for="editCurrVal">현재값 <span class="unit-suffix" id="editUnitLabel2">-</span></label><input type="number" step="0.01" class="form-input" name="currVal" id="editCurrVal" required></div>
                                    </div>
                                    <div class="form-row">
                                        <div class="form-field"><label class="field-label" for="editMeterCn">검침내용</label><textarea class="form-textarea" name="meterCn" id="editMeterCn"></textarea></div>
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn js-modal-close" data-modal-id="meterEditModal">취소</button>
                                <button type="submit" class="btn btn-primary">저장</button>
                            </div>
                        </form>
                    </div>
                </div>

            </div><%-- /meterPage --%>
        </main>
    </div>
</div>


<%-- 처리 결과 메시지 보관 영역
     - JSP 값을 JavaScript 문자열에 직접 넣으면 줄바꿈/따옴표 때문에 SyntaxError가 날 수 있으므로 textarea에 보관한다. --%>
<div id="meterFlashMessage" style="display:none;">
    <textarea id="meterSuccessMessage"><c:out value="${successMessage}" /></textarea>
    <textarea id="meterErrorMessage"><c:out value="${errorMessage}" /></textarea>
</div>

<script src="${ctx}/js/manager/manager-common.js"></script>
<script>
    (function () {
        'use strict';

        var ctx = '${ctx}';
        var mgmtOfcNo = '${mgmtOfcNo}';

        /* ============================================================
           처리 결과 알림
           - redirect 메시지는 hidden textarea에서 읽어 JS 문자열 깨짐을 방지한다.
        ============================================================ */
        function readFlashMessage(messageId) {
            var messageEl = document.getElementById(messageId);
            return messageEl ? messageEl.value.trim() : '';
        }

        var successMessage = readFlashMessage('meterSuccessMessage');
        var errorMessage = readFlashMessage('meterErrorMessage');

        if (successMessage) {
            alert(successMessage);
        }

        if (errorMessage) {
            alert(errorMessage);
        }

        /* ============================================================
           모달 열기/닫기
        ============================================================ */
        function openMeterModal(modalId) {
            if (window.openModal) { window.openModal(modalId); return; }
            var modal = document.getElementById(modalId);
            if (modal) modal.classList.add('open');
        }

        function closeMeterModal(modalId) {
            if (window.closeModal) { window.closeModal(modalId); }
            else {
                var modal = document.getElementById(modalId);
                if (modal) modal.classList.remove('open');
            }
            var modalForm = document.querySelector('#' + modalId + ' form');
            if (modalForm) modalForm.reset();
            // 업로드 모달은 닫을 때 CSV 확인 결과와 hidden 설정값도 초기화함
            if (modalId === 'complexUploadModal') resetPreview('complex');
            if (modalId === 'facilityUploadModal') resetPreview('facility');
            if (modalId === 'meterDownloadModal') resetDownloadCheck();
        }

        /* 공통 닫기 이벤트 */
        document.querySelectorAll('.js-modal-close').forEach(function (btn) {
            btn.addEventListener('click', function () { closeMeterModal(btn.getAttribute('data-modal-id')); });
        });
        document.querySelectorAll('.modal-overlay').forEach(function (overlay) {
            overlay.addEventListener('click', function (e) { if (e.target === overlay) closeMeterModal(overlay.id); });
        });

        /* ============================================================
           업로드 모달 열기 버튼
        ============================================================ */
        var complexUploadBtn = document.getElementById('openComplexUploadModalBtn');
        var facilityUploadBtn = document.getElementById('openFacilityUploadModalBtn');
        if (complexUploadBtn) complexUploadBtn.addEventListener('click', function () { openMeterModal('complexUploadModal'); });
        if (facilityUploadBtn) facilityUploadBtn.addEventListener('click', function () { openMeterModal('facilityUploadModal'); });

        /* 다운로드 모달 기본 조건 세팅 */
        function setDownloadValue(id, value) {
            var el = document.getElementById(id);
            if (el) el.value = value || '';
            // 검침 구분은 select가 disabled라 form 제출에서 제외되므로 hidden mirror도 같이 업데이트함
            var mirror = document.getElementById(id + 'Hidden');
            if (mirror) mirror.value = value || '';
        }

        /* 다운로드 조건 확인 상태 초기화 */
        function resetDownloadCheck() {
            var passed = document.getElementById('downloadCheckPassed');
            var msg = document.getElementById('downloadCheckMessage');
            var summary = document.getElementById('downloadPreviewSummary');
            var tableWrap = document.getElementById('downloadPreviewTableWrap');
            var rows = document.getElementById('downloadPreviewRows');

            if (passed) passed.value = '';
            if (summary) summary.innerHTML = '';
            if (rows) rows.innerHTML = '';
            if (tableWrap) tableWrap.style.display = 'none';
            if (msg) {
                msg.className = 'preview-msg';
                msg.textContent = '조건 확인을 누르면 상위 3건의 샘플과 총 다운로드 건수를 보여드립니다.';
            }
        }

        /* 검침 구분 코드 표시명 */
        function scopeLabel(code) {
            if (code === 'COMPLEX') return '단지별';
            if (code === 'FACILITY') return '시설별';
            return '전체';
        }

        /* 범위 [시작~끝] 문자열, 둘 다 비어있으면 빈 문자열 반환 */
        function rangeText(startId, endId, suffix) {
            var s = readVal(startId);
            var e = readVal(endId);
            if (!s && !e) return '';
            return (s || '-') + ' ~ ' + (e || '-') + (suffix || '');
        }

        /* 다운로드 조건 요약 그리드 렌더링 */
        function renderDownloadSummary(result) {
            var summary = document.getElementById('downloadPreviewSummary');
            if (!summary) return;

            var scope = scopeLabel(document.getElementById('downloadMeterScope').value);
            var providerSel = document.getElementById('downloadUtilityProviderNo');
            var providerText = providerSel.options[providerSel.selectedIndex].textContent.trim() || '전체';
            var periodType = document.getElementById('downloadPeriodType').value;
            var periodText;
            if (periodType === 'MONTH') {
                periodText = document.getElementById('downloadMonth').value || '-';
            } else {
                periodText = (document.getElementById('downloadStartDt').value || '-') + ' ~ ' + (document.getElementById('downloadEndDt').value || '-');
            }
            var keyword = document.getElementById('downloadKeyword').value || '-';

            // 모달의 검침유형 체크박스에서 선택된 유형명 추출
            var meterTyCdNames = { ELEC: '전기', GAS: '가스', WATER: '수도' };
            var checkedTypes = [];
            document.querySelectorAll('#meterDownloadForm input[type="checkbox"][name="meterTyCdList"]:checked').forEach(function (cb) {
                if (meterTyCdNames[cb.value]) checkedTypes.push(meterTyCdNames[cb.value]);
            });
            var meterTyText = checkedTypes.length > 0 ? checkedTypes.join(', ') : '전체';

            // 적용된 추가 필터 모음 (비어 있으면 행 자체를 표시 안 함)
            var extraFilters = [];
            var dongText = rangeText('downloadDongStart', 'downloadDongEnd', '동');
            if (dongText) extraFilters.push('동: ' + dongText);
            var hoText = rangeText('downloadHoStart', 'downloadHoEnd', '호');
            if (hoText) extraFilters.push('호: ' + hoText);
            var preText = rangeText('downloadPreValStart', 'downloadPreValEnd');
            if (preText) extraFilters.push('이전값: ' + preText);
            var currText = rangeText('downloadCurrValStart', 'downloadCurrValEnd');
            if (currText) extraFilters.push('현재값: ' + currText);
            var usageText = rangeText('downloadUsageValStart', 'downloadUsageValEnd');
            if (usageText) extraFilters.push('사용량: ' + usageText);

            var html = ''
                + '<div class="csv-preview-label">파일명</div><div class="csv-preview-value">' + escapeHtml(result.filename || '-') + '</div>'
                + '<div class="csv-preview-label">대상 건수</div><div class="csv-preview-value"><strong>' + escapeHtml(String(result.count || 0)) + '</strong>건</div>'
                + '<div class="csv-preview-label">검침 구분</div><div class="csv-preview-value">' + escapeHtml(scope) + '</div>'
                + '<div class="csv-preview-label">업체</div><div class="csv-preview-value">' + escapeHtml(providerText) + '</div>'
                + '<div class="csv-preview-label">검침유형</div><div class="csv-preview-value">' + escapeHtml(meterTyText) + '</div>'
                + '<div class="csv-preview-label">기간</div><div class="csv-preview-value">' + escapeHtml(periodText) + '</div>'
                + '<div class="csv-preview-label">검색어</div><div class="csv-preview-value">' + escapeHtml(keyword) + '</div>';
            if (extraFilters.length > 0) {
                html += '<div class="csv-preview-label">추가 필터</div><div class="csv-preview-value">' + escapeHtml(extraFilters.join(' / ')) + '</div>';
            }
            summary.innerHTML = html;
        }

        /* 다운로드 샘플 3행 렌더링 */
        function renderDownloadSampleRows(sampleRows) {
            var tableWrap = document.getElementById('downloadPreviewTableWrap');
            var rows = document.getElementById('downloadPreviewRows');
            if (!rows || !tableWrap) return;

            rows.innerHTML = '';
            if (!sampleRows || sampleRows.length === 0) {
                tableWrap.style.display = 'none';
                return;
            }

            sampleRows.forEach(function (r) {
                var scopeText = scopeLabel(r.meterScope);
                // 동/호 표시값이 없으면 시설 검침이므로 '-' 처리
                var hoText = r.hoDisp ? r.hoDisp : '-';
                var tr = document.createElement('tr');
                tr.innerHTML = ''
                    + '<td>' + escapeHtml(scopeText) + '</td>'
                    + '<td>' + escapeHtml(r.meterTyNm || '-') + '</td>'
                    + '<td>' + escapeHtml(r.meterDt || '-') + '</td>'
                    + '<td>' + escapeHtml(hoText) + '</td>'
                    + '<td>' + escapeHtml(r.facilityNm || '-') + '</td>'
                    + '<td>' + escapeHtml(r.usageVal || '-') + '</td>'
                    + '<td>' + escapeHtml(r.meterRsltNm || '-') + '</td>';
                rows.appendChild(tr);
            });
            tableWrap.style.display = '';
        }

        /* 선택 업체 기준 검침유형 동기화 */
        function syncDownloadProviderMeterType() {
            var provider = document.getElementById('downloadUtilityProviderNo');
            var meterTy = document.getElementById('downloadMeterTyCd');
            if (!provider || !meterTy) return;
            var selected = provider.options[provider.selectedIndex];
            meterTy.value = selected ? (selected.getAttribute('data-meter-ty-cd') || '') : '';
        }

        /* 검침 스코프에 맞춰 업체 옵션 보이기/숨기기 (다운로드 모달 전용) */
        function filterProviderOptionsByScope(scope) {
            var select = document.getElementById('downloadUtilityProviderNo');
            if (!select) return;
            var hasCurrent = false;
            for (var i = 0; i < select.options.length; i++) {
                var opt = select.options[i];
                var optScope = opt.getAttribute('data-scope') || '';
                // ANY('전체') 또는 현재 스코프와 일치하는 옵션만 노출함
                var visible = (optScope === 'ANY' || optScope === scope);
                opt.hidden = !visible;
                opt.disabled = !visible;
                if (visible && opt.value === select.value) hasCurrent = true;
            }
            // 현재 선택값이 숨겨졌다면 '전체'로 되돌림
            if (!hasCurrent) select.value = '';
        }

        /* id 도우미: 인풋 값을 안전하게 읽음 */
        function readVal(id) {
            var el = document.getElementById(id);
            return el ? el.value : '';
        }

        /* 모달 안의 추가 필터(검침유형 체크박스 + 동/호/검침값 범위)를 초기화 */
        function resetDownloadExtraFilters() {
            // 검침유형 체크박스 전부 해제
            document.querySelectorAll('#meterDownloadForm input[type="checkbox"][name="meterTyCdList"]').forEach(function (cb) { cb.checked = false; });
            // 범위 인풋 전부 비움
            ['downloadDongStart','downloadDongEnd','downloadHoStart','downloadHoEnd',
             'downloadPreValStart','downloadPreValEnd','downloadCurrValStart','downloadCurrValEnd',
             'downloadUsageValStart','downloadUsageValEnd'].forEach(function (id) {
                var el = document.getElementById(id);
                if (el) el.value = '';
            });
        }

        /* 동/호 범위 줄은 단지별 검침일 때만 보임. 시설 검침은 동/호 의미 없음 */
        function toggleDongHoRow(scope) {
            var row = document.getElementById('downloadDongHoRow');
            if (!row) return;
            row.style.display = (scope === 'COMPLEX') ? '' : 'none';
        }

        /* 현재 탭 검색조건 기반 다운로드 조건 복사 (기본 필터만, 추가 필터는 모달에서 직접 입력) */
        function applyDownloadDefaults(defaultScope) {
            var scope = defaultScope || 'ALL';
            setDownloadValue('downloadMeterScope', scope);
            setDownloadValue('downloadPeriodType', 'MONTH');
            resetDownloadCheck();
            resetDownloadExtraFilters();
            toggleDongHoRow(scope);

            if (defaultScope === 'COMPLEX') {
                setDownloadValue('downloadUtilityProviderNo', readVal('complexUtilityProviderNo'));
                setDownloadValue('downloadMeterRsltCd', readVal('complexMeterRsltCd'));
                setDownloadValue('downloadStartDt', readVal('complexStartDt'));
                setDownloadValue('downloadEndDt', readVal('complexEndDt'));
                setDownloadValue('downloadKeyword', readVal('complexKeyword'));
            } else {
                setDownloadValue('downloadUtilityProviderNo', readVal('filterUtilityProviderNo'));
                setDownloadValue('downloadMeterRsltCd', readVal('filterMeterRsltCd'));
                setDownloadValue('downloadStartDt', readVal('filterStartDt'));
                setDownloadValue('downloadEndDt', readVal('filterEndDt'));
                setDownloadValue('downloadKeyword', readVal('filterKeyword'));
            }

            // 값 세팅이 끝난 뒤 스코프 필터링을 돌려야 숨겨진 옵션이 선택된 상태가 남지 않음
            filterProviderOptionsByScope(scope);
            syncDownloadProviderMeterType();
            setDownloadMonthFromRange();
            toggleDownloadPeriodFields();
        }

        /* 월별 다운로드 기본값 산정 */
        function setDownloadMonthFromRange() {
            var startDt = document.getElementById('downloadStartDt');
            var month = document.getElementById('downloadMonth');
            if (!month) return;
            if (startDt && startDt.value) {
                month.value = startDt.value.substring(0, 7);
                return;
            }

            var now = new Date();
            month.value = now.getFullYear() + '-' + String(now.getMonth() + 1).padStart(2, '0');
        }

        /* 기간 방식별 입력 영역 표시 */
        function toggleDownloadPeriodFields() {
            var periodType = document.getElementById('downloadPeriodType');
            var monthField = document.getElementById('downloadMonthField');
            var rangeField = document.getElementById('downloadDateRangeField');
            var isMonth = !periodType || periodType.value === 'MONTH';
            if (monthField) monthField.style.display = isMonth ? '' : 'none';
            if (rangeField) rangeField.style.display = isMonth ? 'none' : '';
        }

        /* 월별 다운로드 날짜 조건 변환 */
        function applyMonthDownloadRange() {
            var periodType = document.getElementById('downloadPeriodType');
            var month = document.getElementById('downloadMonth');
            if (!periodType || periodType.value !== 'MONTH' || !month || !month.value) {
                return;
            }

            var parts = month.value.split('-');
            var year = Number(parts[0]);
            var monthNo = Number(parts[1]);
            var lastDay = new Date(year, monthNo, 0).getDate();
            setDownloadValue('downloadStartDt', month.value + '-01');
            setDownloadValue('downloadEndDt', month.value + '-' + String(lastDay).padStart(2, '0'));
        }

        /* 다운로드 조건 기준 검침 건수 확인 + 상위 3행 미리보기 */
        function checkDownloadCondition() {
            var form = document.getElementById('meterDownloadForm');
            var passed = document.getElementById('downloadCheckPassed');
            var msg = document.getElementById('downloadCheckMessage');
            var summary = document.getElementById('downloadPreviewSummary');
            var tableWrap = document.getElementById('downloadPreviewTableWrap');
            var rows = document.getElementById('downloadPreviewRows');
            if (!form || !msg) return;

            applyMonthDownloadRange();
            syncDownloadProviderMeterType();
            if (passed) passed.value = '';
            // 이전 응답 잔여 표시 정리
            if (summary) summary.innerHTML = '';
            if (rows) rows.innerHTML = '';
            if (tableWrap) tableWrap.style.display = 'none';
            msg.className = 'preview-msg';
            msg.textContent = '조건 확인 중입니다.';

            var params = new URLSearchParams(new FormData(form));
            fetch('${ctx}/manager/meter/hstry/download/check/${mgmtOfcNo}?' + params.toString(), {
                method: 'GET',
                credentials: 'same-origin'
            })
                .then(function (response) { return response.json(); })
                .then(function (result) {
                    var count = Number(result.count || 0);
                    if (result.success && count > 0) {
                        if (passed) passed.value = 'Y';
                        renderDownloadSummary(result);
                        renderDownloadSampleRows(result.sampleRows);
                        msg.className = 'preview-msg success';
                        msg.textContent = '총 ' + count + '건이 다운로드됩니다. 위 3건은 실제 CSV 내용 샘플입니다.';
                        return;
                    }
                    msg.className = 'preview-msg error';
                    msg.textContent = '해당 조건의 검침 이력이 없습니다.';
                })
                .catch(function () {
                    msg.className = 'preview-msg error';
                    msg.textContent = '조건 확인 중 오류가 발생했습니다.';
                });
        }

        document.querySelectorAll('.js-download-btn').forEach(function (btn) {
            btn.addEventListener('click', function () {
                applyDownloadDefaults(btn.getAttribute('data-default-scope'));
                openMeterModal('meterDownloadModal');
            });
        });

        var downloadPeriodType = document.getElementById('downloadPeriodType');
        if (downloadPeriodType) downloadPeriodType.addEventListener('change', function () {
            toggleDownloadPeriodFields();
            resetDownloadCheck();
        });

        var downloadProvider = document.getElementById('downloadUtilityProviderNo');
        if (downloadProvider) downloadProvider.addEventListener('change', function () {
            syncDownloadProviderMeterType();
            resetDownloadCheck();
        });

        document.querySelectorAll('#meterDownloadForm input, #meterDownloadForm select').forEach(function (el) {
            if (el.id !== 'downloadCheckPassed') {
                el.addEventListener('change', resetDownloadCheck);
                el.addEventListener('input', resetDownloadCheck);
            }
        });

        var downloadCheckBtn = document.getElementById('downloadCheckBtn');
        if (downloadCheckBtn) downloadCheckBtn.addEventListener('click', checkDownloadCondition);

        var downloadForm = document.getElementById('meterDownloadForm');
        if (downloadForm) {
            downloadForm.addEventListener('submit', function (e) {
                applyMonthDownloadRange();
                syncDownloadProviderMeterType();
                var passed = document.getElementById('downloadCheckPassed');
                if (!passed || passed.value !== 'Y') {
                    e.preventDefault();
                    var msg = document.getElementById('downloadCheckMessage');
                    if (msg) {
                        msg.className = 'preview-msg error';
                        msg.textContent = '조건 확인을 먼저 완료해주세요.';
                    }
                }
            });
        }

        /* ============================================================
           업로드 모달 - CSV 확인/자동 매칭
        ============================================================ */
        function getCsrfHeader() {
            var header = document.querySelector('meta[name="_csrf_header"]');
            return header ? header.getAttribute('content') : '';
        }

        function getCsrfToken() {
            var token = document.querySelector('meta[name="_csrf"]');
            return token ? token.getAttribute('content') : '';
        }

        function resetPreview(prefix) {
            var box = document.getElementById(prefix + 'PreviewBox');
            var summary = document.getElementById(prefix + 'PreviewSummary');
            var rows = document.getElementById(prefix + 'PreviewRows');
            var msg = document.getElementById(prefix + 'PreviewMessage');
            var hidden = document.getElementById(prefix + 'MatchedUtilityProviderNo');
            var submit = document.getElementById(prefix + 'UploadSubmitBtn');

            if (box) box.classList.remove('visible');
            if (summary) summary.innerHTML = '';
            if (rows) rows.innerHTML = '';
            if (msg) {
                msg.className = 'preview-msg';
                msg.textContent = 'CSV를 확인해주세요.';
            }
            if (hidden) hidden.value = '';
            if (submit) submit.disabled = true;
        }

        function renderPreview(prefix, result) {
            var box = document.getElementById(prefix + 'PreviewBox');
            var summary = document.getElementById(prefix + 'PreviewSummary');
            var rows = document.getElementById(prefix + 'PreviewRows');
            var msg = document.getElementById(prefix + 'PreviewMessage');
            var hidden = document.getElementById(prefix + 'MatchedUtilityProviderNo');
            var submit = document.getElementById(prefix + 'UploadSubmitBtn');

            if (hidden) hidden.value = result.utilityProviderNo || '';
            if (box) box.classList.add('visible');

            if (summary) {
                var typeText = result.meterTyNm || '-';
                var periodText = (result.contBgngDt || '-') + ' ~ ' + (result.contEndDt || '진행중');
                summary.innerHTML = ''
                    + '<div class="csv-preview-label">업체</div><div class="csv-preview-value">' + escapeHtml(result.partnerNm || '-') + '</div>'
                    + '<div class="csv-preview-label">계약</div><div class="csv-preview-value">' + escapeHtml(result.contNm || '-') + '</div>'
                    + '<div class="csv-preview-label">계약기간</div><div class="csv-preview-value">' + escapeHtml(periodText) + '</div>'
                    + '<div class="csv-preview-label">CSV 식별키</div><div class="csv-preview-value">' + escapeHtml(result.csvIdntfKey || '-') + '</div>'
                    + '<div class="csv-preview-label">외부 고객번호</div><div class="csv-preview-value">' + escapeHtml(result.extCustNo || '-') + '</div>'
                    + '<div class="csv-preview-label">검침유형</div><div class="csv-preview-value">' + escapeHtml(typeText) + '</div>'
                    + '<div class="csv-preview-label">총 행수</div><div class="csv-preview-value">' + escapeHtml(String(result.totalCnt || 0)) + '건</div>'
                    + '<div class="csv-preview-label">계약내용</div><div class="csv-preview-value">' + escapeHtml(result.contCn || '-') + '</div>';
            }

            if (rows) {
                rows.innerHTML = '';
                (result.previewRows || []).forEach(function (r) {
                    var target = prefix === 'complex' ? (r.hoNo || '-') : (r.facilityNo || '-');
                    var tr = document.createElement('tr');
                    tr.innerHTML = ''
                        + '<td>' + escapeHtml(r.lineNo || '-') + '</td>'
                        + '<td>' + escapeHtml(r.meterTyNm || '-') + '</td>'
                        + '<td>' + escapeHtml(target) + '</td>'
                        + '<td>' + escapeHtml(r.meterDt || '-') + '</td>'
                        + '<td>' + escapeHtml((r.preVal || '-') + (r.meterUnit && r.meterUnit !== '-' ? ' ' + r.meterUnit : '')) + '</td>'
                        + '<td>' + escapeHtml((r.currVal || '-') + (r.meterUnit && r.meterUnit !== '-' ? ' ' + r.meterUnit : '')) + '</td>'
                        + '<td>' + escapeHtml(r.meterRsltCd || '-') + '</td>';
                    rows.appendChild(tr);
                });
            }

            if (msg) {
                var warnings = result.warnings || [];
                if (warnings.length > 0) {
                    msg.className = 'preview-msg warn';
                    msg.textContent = warnings.slice(0, 3).join(' / ') + (warnings.length > 3 ? ' 외 ' + (warnings.length - 3) + '건' : '');
                } else {
                    msg.className = 'preview-msg';
                    msg.textContent = result.message || 'CSV 확인이 완료되었습니다. 업로드할 수 있습니다.';
                }
            }

            if (submit) submit.disabled = !result.uploadable;
        }

        function showPreviewError(prefix, message) {
            var box = document.getElementById(prefix + 'PreviewBox');
            var msg = document.getElementById(prefix + 'PreviewMessage');
            var submit = document.getElementById(prefix + 'UploadSubmitBtn');
            var hidden = document.getElementById(prefix + 'MatchedUtilityProviderNo');

            if (box) box.classList.add('visible');
            if (msg) {
                msg.className = 'preview-msg error';
                msg.textContent = message || 'CSV 확인 중 오류가 발생했습니다.';
            }
            if (submit) submit.disabled = true;
            if (hidden) hidden.value = '';
        }

        function escapeHtml(value) {
            return String(value == null ? '' : value)
                .replace(/&/g, '&amp;')
                .replace(/</g, '&lt;')
                .replace(/>/g, '&gt;')
                .replace(/"/g, '&quot;')
                .replace(/'/g, '&#39;');
        }

        function bindCsvPreview(prefix, formId, fileId, scope) {
            var form = document.getElementById(formId);
            var fileInput = document.getElementById(fileId);
            var previewBtn = document.getElementById(prefix + 'PreviewBtn');
            var submitBtn = document.getElementById(prefix + 'UploadSubmitBtn');
            var uploading = false;

            if (!form || !fileInput || !previewBtn) return;

            fileInput.addEventListener('change', function () {
                uploading = false;
                resetPreview(prefix);
            });

            previewBtn.addEventListener('click', function () {
                resetPreview(prefix);

                if (!fileInput.files || fileInput.files.length === 0) {
                    showPreviewError(prefix, 'CSV 파일을 먼저 선택해주세요.');
                    return;
                }

                var formData = new FormData();
                formData.append('meterScope', scope);
                formData.append('csvFile', fileInput.files[0]);

                var headers = { 'Accept': 'application/json' };
                var csrfHeader = getCsrfHeader();
                var csrfToken = getCsrfToken();
                if (csrfHeader && csrfToken) headers[csrfHeader] = csrfToken;

                previewBtn.disabled = true;
                previewBtn.textContent = '확인 중...';

                fetch(ctx + '/manager/meter/hstry/preview/' + mgmtOfcNo, {
                    method: 'POST',
                    headers: headers,
                    body: formData
                })
                    .then(function (res) { return res.json(); })
                    .then(function (result) {
                        if (!result.success) throw new Error(result.message || 'CSV 확인 실패');
                        renderPreview(prefix, result);
                    })
                    .catch(function (err) { showPreviewError(prefix, err.message); })
                    .finally(function () {
                        previewBtn.disabled = false;
                        previewBtn.innerHTML = '<span class="material-symbols-rounded">fact_check</span>CSV 확인';
                    });
            });

            form.addEventListener('submit', function (e) {
                var hidden = document.getElementById(prefix + 'MatchedUtilityProviderNo');
                if (uploading) {
                    e.preventDefault();
                    return;
                }
                if (!hidden || !hidden.value) {
                    e.preventDefault();
                    showPreviewError(prefix, 'CSV 확인을 먼저 완료해주세요.');
                    return;
                }

                uploading = true;
                if (submitBtn) {
                    submitBtn.disabled = true;
                    submitBtn.innerHTML = '<span class="upload-spinner"></span>업로드중입니다...';
                }
                previewBtn.disabled = true;
                fileInput.readOnly = true;
            });
        }

        bindCsvPreview('complex', 'complexMeterCsvUploadForm', 'complexCsvFile', 'COMPLEX');
        bindCsvPreview('facility', 'facilityMeterCsvUploadForm', 'facilityCsvFile', 'FACILITY');

        /* ============================================================
           목록 정렬
        ============================================================ */
        function initMeterSortHeaders() {
            var currentField = '${meterSortField}';
            var currentDir = '${meterSortDir}';
            var activeScope = '${activeMeterScope}';

            document.querySelectorAll('.js-sort-btn').forEach(function (btn) {
                var field = btn.getAttribute('data-sort-field');
                var icon = btn.querySelector('.sort-icon');

                if (field === currentField) {
                    btn.classList.add('active');
                    if (icon) icon.textContent = currentDir === 'ASC' ? '▲' : '▼';
                } else if (icon) {
                    icon.textContent = '↕';
                }

                btn.addEventListener('click', function () {
                    var nextDir = field === currentField && currentDir === 'ASC' ? 'DESC' : 'ASC';
                    var params = new URLSearchParams(location.search);
                    params.set('meterScope', activeScope);
                    params.set('sortField', field);
                    params.set('sortDir', nextDir);
                    params.set('page', '1');
                    location.href = ctx + '/manager/meter/hstry/' + mgmtOfcNo + '?' + params.toString();
                });
            });
        }

        initMeterSortHeaders();

        /* ============================================================
           날짜/값 표시 유틸
        ============================================================ */
        function toDateInputValue(value) {
            if (!value) return '';
            if (typeof value === 'string' && value.length >= 10) return value.substring(0, 10);
            return '';
        }

        function toDisplayValue(value) {
            return (value == null || value === '') ? '-' : String(value);
        }

        /* ho_no 표시 변환
           - DB 값 예: A12127003_4_1502
           - 화면 표시: 4동 / 1502호 또는 4동 1502호 */
        function parseHoNo(hoNo) {
            if (!hoNo) return { dong: '', ho: '', text: '' };

            var raw = String(hoNo);
            var parts = raw.split('_');

            // 단지코드_동_호 형태이면 사람이 읽기 좋은 동/호로 변환
            if (parts.length >= 3) {
                var dong = parts[1];
                var ho = parts[2];
                return {
                    dong: dong + '동',
                    ho: ho + '호',
                    text: dong + '동 ' + ho + '호'
                };
            }

            // 이미 사람이 읽는 형태로 들어온 값이면 그대로 사용
            return { dong: '', ho: raw, text: raw };
        }

        /* 검침유형 표시
           - METER_HSTRY.METER_TY_CD와 공통코드명을 기준으로만 표시한다. */
        function getMeterTypeText(row) {
            if (row.meterTyNm) return row.meterTyNm;
            if (row.meterTyCd) return row.meterTyCd;
            return '-';
        }


        function getMeterUnitByCd(meterTyCd) {
            if (meterTyCd === 'ELEC') return 'kWh';
            if (meterTyCd === 'WATER' || meterTyCd === 'GAS') return '㎥';
            if (meterTyCd === 'HEAT') return 'Gcal';
            return '';
        }

        function getMeterUnit(row) {
            return getMeterUnitByCd(row.meterTyCd);
        }

        function getMeterScope(row) {
            var meterCn = row && row.meterCn ? String(row.meterCn) : '';

            // 신규 기준: METER_HSTRY.METER_SCOPE 컬럼값을 최우선으로 사용함
            if (row && row.meterScope) return row.meterScope;

            // 기존 더미 보정: scope 보정 전 데이터가 상세로 들어오는 경우만 예외적으로 판단함
            if (meterCn.indexOf('[단지검침]') === 0) return 'COMPLEX';
            if (meterCn.indexOf('[시설검침]') === 0) return 'FACILITY';

            // 세대 검침도 계량기 시설번호를 가지므로 facilityNo보다 hoNo를 먼저 확인해야 함
            if (row && row.hoNo) return 'COMPLEX';
            if (row && row.facilityNo) return 'FACILITY';

            return 'FACILITY';
        }

        function cleanMeterCn(value) {
            if (!value) return value;
            return String(value).replace(/^\[단지검침\]\s*/, '').replace(/^\[시설검침\]\s*/, '');
        }

        function setDisplay(elId, value) {
            var el = document.getElementById(elId);
            if (el) el.textContent = toDisplayValue(value);
        }

        function showElement(elId, show) {
            var el = document.getElementById(elId);
            if (el) el.style.display = show ? '' : 'none';
        }

        /* 업체 요약 표시
           - 상세 모달에서는 계약번호/계약명까지 늘리지 않고 업체명, 담당자, 연락처만 한 줄로 표시 */
        function getPartnerSummary(row) {
            var values = [];
            if (row.partnerNm) values.push(row.partnerNm);
            if (row.picNm) values.push('담당자 ' + row.picNm);
            if (row.picTelno) values.push(row.picTelno);
            return values.length ? values.join(' / ') : '-';
        }

        /* ============================================================
           상세 모달 값 세팅
        ============================================================ */
        function fillDetailModal(row) {
            /* 검침 정보 */
            var unit = getMeterUnit(row);
            setDisplay('detailMeterHstryNo', row.meterHstryNo);
            setDisplay('detailMeterTyNm', getMeterTypeText(row));
            setDisplay('detailMeterDt', toDateInputValue(row.meterDt));
            setDisplay('detailPreVal', (row.preVal == null ? '-' : row.preVal) + (unit ? ' ' + unit : ''));
            setDisplay('detailCurrVal', (row.currVal == null ? '-' : row.currVal) + (unit ? ' ' + unit : ''));
            setDisplay('detailMeterRsltNm', row.meterRsltNm || row.meterRsltCd);
            setDisplay('detailMeterCn', cleanMeterCn(row.meterCn));

            /* 시설 검침 / 단지 검침 대상 정보 분리 */
            if (getMeterScope(row) === 'COMPLEX') {
                var hoInfo = parseHoNo(row.hoNo);
                showElement('detailComplexTargetSection', true);
                showElement('detailFacilityTargetSection', false);
                setDisplay('detailDongNo', hoInfo.dong || row.dongNo);
                setDisplay('detailHoNo', hoInfo.ho || row.hoNo);
            } else {
                showElement('detailComplexTargetSection', false);
                showElement('detailFacilityTargetSection', true);
                setDisplay('detailFacilityNm', row.facilityNm);
                setDisplay('detailFacilityTyNm', row.facilityTyNm);
                setDisplay('detailLocCn', row.locCn);
            }

            /* 업체 정보 */
            setDisplay('detailPartnerSummary', getPartnerSummary(row));
        }

        /* ============================================================
           수정 모달 값 세팅
        ============================================================ */
        function fillEditModal(row) {
            /* 읽기전용 표시 */
            var unit = getMeterUnit(row);
            setDisplay('editReadonlyMeterHstryNo', row.meterHstryNo);
            setDisplay('editReadonlyMeterTyNm', getMeterTypeText(row));
            setDisplay('editReadonlyFacilityNm', row.facilityNm);
            setDisplay('editReadonlyHoNo', row.hoNo ? parseHoNo(row.hoNo).text : '-');
            setDisplay('editReadonlyPartnerNm', row.partnerNm);
            var scope = getMeterScope(row);
            showElement('editComplexTargetRow', scope === 'COMPLEX');
            showElement('editFacilityTargetRow', scope === 'FACILITY');
            setDisplay('editUnitLabel1', unit || '-');
            setDisplay('editUnitLabel2', unit || '-');
            /* 수정 가능 필드 */
            document.getElementById('editMeterHstryNo').value  = row.meterHstryNo || '';
            document.getElementById('editReturnQueryString').value = location.search || '';
            document.getElementById('editMeterDt').value       = toDateInputValue(row.meterDt);
            document.getElementById('editPreVal').value        = row.preVal == null ? '' : row.preVal;
            document.getElementById('editCurrVal').value       = row.currVal == null ? '' : row.currVal;
            document.getElementById('editMeterRsltCd').value   = row.meterRsltCd || '';
            document.getElementById('editMeterCn').value       = cleanMeterCn(row.meterCn) || '';
        }

        /* ============================================================
           검침 이력 상세 API 조회
        ============================================================ */
        function fetchMeterDetail(meterHstryNo, callback) {
            fetch(ctx + '/manager/meter/hstry/detail/' + mgmtOfcNo + '/' + encodeURIComponent(meterHstryNo), {
                method: 'GET',
                headers: { 'Accept': 'application/json' }
            })
                .then(function (res) {
                    if (!res.ok) throw new Error('검침 이력 조회 실패');
                    return res.json();
                })
                .then(function (result) {
                    if (!result.success) throw new Error(result.message || '검침 이력 조회 실패');
                    callback(result.meterHstry || result.meter || result.data);
                })
                .catch(function (err) { alert(err.message); });
        }

        /* ============================================================
           상세/수정 버튼 이벤트
        ============================================================ */
        document.querySelectorAll('.js-detail-btn').forEach(function (btn) {
            btn.addEventListener('click', function () {
                fetchMeterDetail(btn.getAttribute('data-meter-hstry-no'), function (row) {
                    fillDetailModal(row || {});
                    openMeterModal('meterDetailModal');
                });
            });
        });

        document.querySelectorAll('.js-edit-btn').forEach(function (btn) {
            btn.addEventListener('click', function () {
                fetchMeterDetail(btn.getAttribute('data-meter-hstry-no'), function (row) {
                    fillEditModal(row || {});
                    openMeterModal('meterEditModal');
                });
            });
        });
        /* ============================================================
           페이지네이션
        ============================================================ */
        function initMeterPagination(targetName) {
            var pagination = document.getElementById(targetName + 'Pagination');
            var paginationInfo = document.getElementById(targetName + 'PaginationInfo');
            var paginationWrap = document.querySelector('[data-pagination-target="' + targetName + '"]');
            var pageSize = Number(paginationWrap && paginationWrap.getAttribute('data-page-size')) || 10;
            var currentPage = Number(paginationWrap && paginationWrap.getAttribute('data-current-page')) || 1;
            var totalCount = Number(paginationWrap && paginationWrap.getAttribute('data-total-count')) || 0;
            var totalPage = Math.ceil(totalCount / pageSize);
            var scope = paginationWrap ? paginationWrap.getAttribute('data-scope') : '';

            if (!pagination || !paginationInfo || !paginationWrap) return;

            if (totalCount === 0) { paginationWrap.style.display = 'none'; return; }
            paginationWrap.style.display = 'flex';

            function renderInfo() {
                paginationInfo.textContent = '총 ' + totalCount + '건 · ' + currentPage + ' / ' + totalPage + '페이지';
            }

            function movePage(pageNo) {
                var params = new URLSearchParams(location.search);
                params.set('meterScope', scope);
                params.set('page', String(pageNo));
                params.set('pageSize', String(pageSize));
                location.href = ctx + '/manager/meter/hstry/' + mgmtOfcNo + '?' + params.toString();
            }

            function createBtn(label, pageNo, disabled, active) {
                var b = document.createElement('button');
                b.type = 'button';
                b.className = 'page-btn' + ((label === '이전' || label === '다음') ? ' page-btn-nav' : '') + (active ? ' active' : '');
                b.textContent = label;
                b.disabled = disabled;
                b.addEventListener('click', function () { movePage(pageNo); });
                return b;
            }

            function render() {
                renderInfo();
                pagination.innerHTML = '';
                pagination.appendChild(createBtn('이전', Math.max(1, currentPage - 1), currentPage === 1, false));
                var sp = Math.max(1, currentPage - 2);
                var ep = Math.min(totalPage, sp + 4);
                sp = Math.max(1, ep - 4);
                for (var p = sp; p <= ep; p++) pagination.appendChild(createBtn(String(p), p, false, p === currentPage));
                pagination.appendChild(createBtn('다음', Math.min(totalPage, currentPage + 1), currentPage === totalPage, false));
            }

            render();
        }


        /* ============================================================
           탭 직접 전환
           - 협력업체 상세에서 넘어온 partnerNo 조건은 다른 탭 클릭 시 제거
           - 선택한 탭만 유지하고 기본 목록으로 다시 조회
        ============================================================ */
        function moveMeterTab(scope) {
            var current = new URLSearchParams(location.search);
            var params = new URLSearchParams();
            params.set('meterScope', scope);
            params.set('page', '1');
            if (current.get('partnerNo')) params.set('partnerNo', current.get('partnerNo'));
            location.href = ctx + '/manager/meter/hstry/' + mgmtOfcNo + '?' + params.toString();
        }

        var complexTabLabel = document.querySelector('label[for="meterTabComplex"]');
        var facilityTabLabel = document.querySelector('label[for="meterTabFacility"]');

        if (complexTabLabel) {
            complexTabLabel.addEventListener('click', function (e) {
                if ('${activeMeterScope}' !== 'COMPLEX') {
                    e.preventDefault();
                    moveMeterTab('COMPLEX');
                }
            });
        }

        if (facilityTabLabel) {
            facilityTabLabel.addEventListener('click', function (e) {
                if ('${activeMeterScope}' !== 'FACILITY') {
                    e.preventDefault();
                    moveMeterTab('FACILITY');
                }
            });
        }

        initMeterPagination('complex');
        initMeterPagination('facility');

    })();
</script>
</body>
</html>
