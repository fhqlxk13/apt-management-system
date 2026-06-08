<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>편의시설 등록</title>
    <sec:csrfMetaTags/>

    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/office-layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/manager-common.css">

    <style>
        /* ===================== 색상 변수 ===================== */
        #publicFacilityPage {
            --accent:       #2e5c38;
            --accent-hover: #1f4027;
            --accent-light: #e8f0ea;
            --accent-dim:   rgba(46,92,56,.08);
            --surface:      #ffffff;
            --surface-sub:  #f8f9fb;
            --line:         #d7dce2;
            --text-pri:     #1a1f1b;
            --text-sec:     #4a5c4e;
            --text-ter:     #8a9a8e;
        }

        /* ===================== 공통 패널 ===================== */
        #publicFacilityPage .page-title-block h2 { color:var(--text-pri); font-size:19px; letter-spacing:-.5px; }
        #publicFacilityPage .page-title-block p  { color:var(--text-sec); font-size:12px; }
        #publicFacilityPage .panel                { border-radius:6px; border:1px solid var(--line); box-shadow:none; margin:0; }
        #publicFacilityPage .panel-header         { display:flex; align-items:center; justify-content:space-between; padding:13px 16px; border-bottom:1px solid var(--line); background:var(--surface); border-radius:6px 6px 0 0; }
        #publicFacilityPage .panel-title          { display:flex; align-items:center; gap:6px; margin:0; font-size:13px; font-weight:800; color:var(--text-pri); }
        #publicFacilityPage .panel-title .material-symbols-rounded { font-size:17px; color:var(--accent); }
        #publicFacilityPage .panel-body           { padding:14px 16px 16px; background:var(--surface); }

        /* ===================== 폼 기본 요소 ===================== */
        #publicFacilityPage .panel-body .form-input,
        #publicFacilityPage .panel-body .form-select {
            height:32px;
            font-size:12px;
            border-color:var(--line);
            background:var(--surface);
            border-radius:4px;
        }
        #publicFacilityPage .panel-body .form-input:focus,
        #publicFacilityPage .panel-body .form-select:focus {
            border-color:var(--accent);
            box-shadow:0 0 0 2px var(--accent-dim);
        }
        #publicFacilityPage .panel-body .form-input[readonly]  { background:var(--surface-sub); color:var(--text-pri); opacity:1; cursor:default; }
        #publicFacilityPage .panel-body .form-input:disabled,
        #publicFacilityPage .panel-body .form-select:disabled  { background:#f4f5f6; color:#9ca3af; cursor:not-allowed; }
        #publicFacilityPage .panel-body .form-textarea         { font-size:12px; border-color:var(--line); border-radius:4px; resize:vertical; }
        #publicFacilityPage .panel-body .form-textarea:focus   { border-color:var(--accent); box-shadow:0 0 0 2px var(--accent-dim); }

        /* ===================== 버튼 ===================== */
        #publicFacilityPage .btn                { border-radius:4px; }
        #publicFacilityPage .btn-primary        { background:var(--accent); border-color:var(--accent); }
        #publicFacilityPage .btn-primary:hover  { background:var(--accent-hover); border-color:var(--accent-hover); }

        /* ===================== 안내 박스 ===================== */
        #publicFacilityPage .form-guide-line {
            display:flex;
            align-items:center;
            justify-content:space-between;
            gap:12px;
            margin-bottom:14px;
            padding:9px 11px;
            border:1px solid var(--line);
            border-left:3px solid var(--accent);
            border-radius:0 4px 4px 0;
            background:#f8f9fb;
            color:var(--text-sec);
            font-size:12px;
            line-height:1.5;
        }
        #publicFacilityPage .form-guide-text { min-width:0; }
        #publicFacilityPage .form-guide-line .btn { flex-shrink:0; height:28px; min-height:28px; padding:0 10px; font-size:11px; }
        #publicFacilityPage .field-help {
            margin-top:5px;
            font-size:11px;
            color:var(--text-ter);
            line-height:1.5;
        }

        /* ===================== 섹션 타이틀 ===================== */
        .form-section-title {
            display:flex;
            align-items:center;
            gap:4px;
            font-size:11px;
            font-weight:800;
            color:var(--text-sec,#4a5c4e);
            margin-bottom:10px;
        }
        .form-section-title .material-symbols-rounded { font-size:15px; color:var(--accent,#2e5c38); }
        /* ===================== 2컬럼 레이아웃 ===================== */
        .facility-cols {
            display:grid;
            grid-template-columns:calc(50% - 10px) calc(50% - 10px);
            gap:0 20px;
            align-items:stretch;
        }
        .facility-col-left {
            border-right:1px solid var(--line,#d7dce2);
            display:flex;
            flex-direction:column;
            padding-right:20px;
            min-width:0;
        }
        .facility-col-right {
            display:flex;
            flex-direction:column;
            min-width:0;
        }
        /* ===================== 시설자산 연결 영역 ===================== */
        #publicFacilityPage .asset-link-box {
            padding:12px;
            border:1px solid var(--line);
            border-radius:4px;
            background:#f8f9fb;
            margin-bottom:14px;
        }
        #publicFacilityPage .asset-link-box .form-input,
        #publicFacilityPage .asset-link-box .form-select { background:#fff; }

        /* 시설자산 미선택 상태 */
        #publicFacilityPage .asset-empty-state {
            display:flex;
            align-items:center;
            justify-content:center;
            flex-direction:column;
            gap:5px;
            min-height:92px;
            color:var(--text-ter);
            font-size:12px;
            text-align:center;
        }
        #publicFacilityPage .asset-empty-state .material-symbols-rounded { font-size:24px; color:#a7b2aa; }

        /* 시설자산 선택 완료 상태 */
        #publicFacilityPage .asset-selected-state { display:none; }
        #publicFacilityPage .asset-selected-state.is-active { display:block; }
        #publicFacilityPage .asset-selected-row {
            display:flex;
            align-items:center;
            justify-content:space-between;
            gap:10px;
            min-height:34px;
        }
        #publicFacilityPage .asset-selected-info {
            min-width:0;
            display:flex;
            align-items:center;
            gap:7px;
            color:var(--text-sec);
            font-size:12px;
            font-weight:500;
            overflow:hidden;
        }
        #publicFacilityPage .asset-selected-info .material-symbols-rounded { flex-shrink:0; font-size:16px; color:#9aa5a0; }
        #publicFacilityPage .asset-selected-text {
            display:block;
            overflow:hidden;
            text-overflow:ellipsis;
            white-space:nowrap;
        }
        #publicFacilityPage .asset-selected-row .btn { flex-shrink:0; height:28px; min-height:28px; padding:0 10px; font-size:11px; }
        #publicFacilityPage .asset-hidden-data { display:none; }

        /* 시설자산이 선택되면 박스에 배경/보더 추가 */
        #publicFacilityPage .asset-link-box.is-selected { background:#fff; }
        /* ===================== 사진 업로드 ===================== */
        #publicFacilityPage .photo-upload-box {
            border:1px dashed var(--line);
            border-radius:4px;
            padding:12px;
            background:#fafcfb;
        }
        #publicFacilityPage .photo-upload-title {
            display:flex;
            align-items:center;
            gap:5px;
            font-size:12px;
            font-weight:800;
            color:var(--text-sec);
        }
        #publicFacilityPage .photo-upload-title .material-symbols-rounded { font-size:16px; color:var(--accent); }
        #publicFacilityPage .photo-upload-desc { font-size:11px; color:var(--text-ter); line-height:1.5; }

        /* 사진 미리보기 그리드 */
        #publicFacilityPage .photo-preview-grid {
            display:grid;
            grid-template-columns:repeat(4,minmax(0,1fr));
            gap:8px;
            margin-top:10px;
        }
        #publicFacilityPage .photo-preview-item {
            position:relative;
            min-height:92px;
            border:1px solid var(--line);
            border-radius:4px;
            background:#fff;
            overflow:hidden;
        }
        #publicFacilityPage .photo-preview-item img {
            width:100%;
            height:92px;
            object-fit:cover;
            display:block;
            cursor:zoom-in;
        }
        #publicFacilityPage .photo-preview-item-name {
            padding:6px 7px;
            font-size:11px;
            color:var(--text-sec);
            white-space:nowrap;
            overflow:hidden;
            text-overflow:ellipsis;
            border-top:1px solid var(--line);
        }
        #publicFacilityPage .photo-empty-msg {
            padding:13px;
            border:1px solid var(--line);
            border-radius:4px;
            background:#fff;
            font-size:12px;
            color:var(--text-ter);
        }

        /* 기존 사진 목록 */
        #publicFacilityPage .existing-photo-list { display:flex; flex-direction:column; gap:7px; margin-top:8px; }
        #publicFacilityPage .existing-photo-row  { display:flex; align-items:center; gap:10px; padding:8px 10px; border:1px solid var(--line); border-radius:4px; background:#fff; }
        #publicFacilityPage .photo-thumb         { width:48px; height:48px; border-radius:4px; border:1px solid var(--line); object-fit:cover; background:#f4f7f4; flex-shrink:0; cursor:zoom-in; }
        #publicFacilityPage .photo-file-info     { min-width:0; flex:1; }
        #publicFacilityPage .photo-file-name     { font-size:12px; font-weight:700; color:#111827; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
        #publicFacilityPage .photo-file-ext      { margin-top:2px; font-size:11px; color:var(--text-ter); }
        #publicFacilityPage .photo-delete-label  { display:inline-flex; align-items:center; gap:4px; font-size:11px; color:#7f1d1d; font-weight:700; }
        #publicFacilityPage .photo-delete-label input { width:14px; height:14px; }

        /* ===================== 운영시간 ===================== */
        #publicFacilityPage .opr-time-box {
            display:flex;
            flex-direction:column;
            gap:8px;
            padding:10px;
            border:1px solid var(--line);
            border-radius:4px;
            background:#fafcfb;
        }
        #publicFacilityPage .opr-time-row {
            display:grid;
            grid-template-columns:64px minmax(0,1fr) 64px minmax(0,.7fr) 16px minmax(0,.7fr);
            gap:7px;
            align-items:center;
        }
        #publicFacilityPage .opr-day-range {
            display:grid;
            grid-template-columns:minmax(0,1fr) 16px minmax(0,1fr);
            gap:7px;
            align-items:center;
            min-width:0;
        }
        #publicFacilityPage .opr-label     { font-size:11px; font-weight:600; color:var(--text-sec); white-space:nowrap; }
        #publicFacilityPage .opr-separator { text-align:center; font-size:12px; font-weight:500; color:var(--text-ter); }
        #publicFacilityPage .opr-preview-row { display:grid; grid-template-columns:64px 1fr; gap:7px; align-items:center; }
        #publicFacilityPage .opr-preview {
            min-height:30px;
            padding:6px 9px;
            display:flex;
            align-items:center;
            border:1px solid var(--line);
            border-radius:4px;
            background:#fff;
            font-size:12px;
            font-weight:700;
            color:var(--text-pri);
        }
        #publicFacilityPage .opr-preview.is-empty { color:var(--text-ter); font-weight:500; }
        #publicFacilityPage .opr-notice {
            min-height:17px;
            padding-left:71px;
            font-size:11px;
            line-height:1.5;
            color:#b45309;
        }
        #publicFacilityPage .opr-notice:empty { display:none; }
        /* ===================== 자원 안내 ===================== */
        #publicFacilityPage .resource-guide-list { display:flex; flex-direction:column; gap:10px; margin-top:8px; }
        #publicFacilityPage .resource-guide-row  { display:flex; align-items:center; justify-content:space-between; gap:14px; padding:11px 12px; border:1px solid var(--line); border-radius:4px; background:#fff; }
        #publicFacilityPage .resource-guide-main { font-size:12px; font-weight:600; color:var(--text-pri); }
        #publicFacilityPage .resource-guide-sub  { margin-top:5px; font-size:11px; color:var(--text-ter); line-height:1.55; }
        #publicFacilityPage .resource-badge      { display:inline-flex; align-items:center; height:24px; padding:0 9px; border-radius:4px; background:var(--accent-light); color:var(--accent); font-size:11px; font-weight:600; white-space:nowrap; }

        /* ===================== 시설자산 선택 모달 ===================== */
        .asset-select-modal {
            display:none !important;
            position:fixed !important;
            inset:0 !important;
            z-index:9500 !important;
            background:rgba(16,24,20,.48);
            align-items:center;
            justify-content:center;
            padding:28px;
            box-sizing:border-box;
        }
        .asset-select-modal.is-open { display:flex !important; }
        #publicFacilityPage .asset-modal-box {
            width:min(920px, 94vw);
            max-height:86vh;
            display:flex;
            flex-direction:column;
            border-radius:3px;
            background:#fff;
            border:1px solid rgba(215,220,226,.95);
            box-shadow:0 22px 52px rgba(0,0,0,.22);
            overflow:hidden;
        }
        #publicFacilityPage .asset-modal-head {
            display:flex;
            align-items:center;
            justify-content:space-between;
            gap:12px;
            padding:15px 18px;
            border-bottom:1px solid var(--line);
            background:var(--surface);
        }
        #publicFacilityPage .asset-modal-title {
            display:flex;
            align-items:center;
            gap:7px;
            margin:0;
            font-size:14px;
            font-weight:800;
            color:var(--text-pri);
        }
        #publicFacilityPage .asset-modal-title .material-symbols-rounded { color:var(--accent); font-size:18px; }
        #publicFacilityPage .asset-modal-close {
            width:30px;
            height:30px;
            border:0;
            border-radius:4px;
            background:transparent;
            color:#4b5563;
            cursor:pointer;
        }
        #publicFacilityPage .asset-modal-close:hover { background:#edf2ee; color:var(--accent); }
        #publicFacilityPage .asset-modal-body { padding:14px 16px 16px; overflow:auto; }

        /* 모달 검색 필터 */
        #publicFacilityPage .asset-filter-row {
            display:grid;
            grid-template-columns:1.4fr .9fr .9fr auto;
            gap:7px;
            margin-bottom:10px;
            padding:10px;
            border:1px solid var(--line);
            border-radius:6px;
            background:var(--surface-sub);
        }

        /* 모달 테이블 */
        #publicFacilityPage .asset-table-wrap { border:1px solid var(--line); border-radius:6px; overflow:hidden; background:#fff; }
        #publicFacilityPage .asset-table      { width:100%; border-collapse:collapse; table-layout:fixed; }
        #publicFacilityPage .asset-table th   { height:34px; padding:0 10px; border-bottom:1px solid var(--line); background:#f3f5f3; color:var(--text-sec); font-size:11px; font-weight:600; text-align:left; }
        #publicFacilityPage .asset-table td   { height:42px; padding:7px 10px; border-bottom:1px solid var(--line); color:var(--text-pri); font-size:12px; vertical-align:middle; }
        #publicFacilityPage .asset-table tbody tr:last-child td { border-bottom:0; }
        #publicFacilityPage .asset-table tbody tr:hover         { background:var(--accent-dim); }
        #publicFacilityPage .asset-table .is-hidden            { display:none; }
        #publicFacilityPage .asset-table .cell-center          { text-align:center; }
        #publicFacilityPage .asset-name-main { display:block; font-size:12px; font-weight:600; color:var(--text-pri); overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }
        #publicFacilityPage .asset-name-sub  { display:block; margin-top:2px; font-size:11px; color:var(--text-ter); overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }
        #publicFacilityPage .asset-empty-row td { height:68px; text-align:center; color:var(--text-ter); }

        /* 검색 결과 건수 */
        #publicFacilityPage .asset-count-row { display:flex; align-items:center; gap:6px; margin-bottom:10px; }
        #publicFacilityPage .asset-count-badge {
            display:inline-flex;
            align-items:center;
            gap:5px;
            height:28px;
            padding:0 10px;
            border:1px solid var(--line);
            border-radius:4px;
            background:var(--surface-sub);
            font-size:12px;
            color:var(--text-sec);
        }
        #publicFacilityPage .asset-count-badge strong { color:var(--accent); font-weight:800; }

        /* 활성/비활성 뱃지 */
        #publicFacilityPage .badge-active   { display:inline-flex; align-items:center; height:22px; padding:0 8px; border-radius:4px; font-size:11px; font-weight:600; background:#dceee0; color:#1f7a3f; }
        #publicFacilityPage .badge-inactive { display:inline-flex; align-items:center; height:22px; padding:0 8px; border-radius:4px; font-size:11px; font-weight:600; background:#fee2e2; color:#b42318; }

        /* ===================== 반응형 ===================== */
        @media (max-width:1100px) {
            #publicFacilityPage .opr-time-row    { grid-template-columns:64px minmax(0,1fr); }
            #publicFacilityPage .opr-preview-row { grid-template-columns:64px minmax(0,1fr); }
            #publicFacilityPage .opr-notice      { padding-left:71px; }
        }
        @media (max-width:760px) {
            .facility-cols        { grid-template-columns:1fr; }
            .facility-col-left    { padding-right:0; border-right:none; border-bottom:1px solid var(--line,#d7dce2); padding-bottom:16px; margin-bottom:16px; }
            #publicFacilityPage .asset-filter-row { grid-template-columns:1fr; }
        }
    </style>

    <script>
        window.publicFacilityPageConfig = {
            contextPath: "${pageContext.request.contextPath}",
            mgmtOfcNo: "${mgmtOfcNo}",
            preselectFacilityNo: "${param.facilityNo}"
        };
    </script>
</head>
<body>
<c:set var="activeSidebarHref" value="${pageContext.request.contextPath}/manager/publicFacility/page/${mgmtOfcNo}" />
<c:set var="activeSidebarParent" value="시설·공사 관리" />
<c:set var="activeSidebarCurrent" value="편의시설 관리" />
<div class="app-wrapper">
    <%@ include file="/WEB-INF/views/include/office_sidebar.jsp" %>

    <div class="main-wrap">
        <%@ include file="/WEB-INF/views/include/office_header.jsp" %>
        <%@ include file="/WEB-INF/views/include/office_active_sidebar.jspf" %>
        <main class="main-content">
            <div class="office-page" id="publicFacilityPage">
                <div class="page-header">
                    <div class="page-title-block">
                        <h2>편의시설 등록</h2>
                        <p>등록된 시설자산을 선택해 편의시설 운영정보를 등록합니다.</p>
                    </div>
                </div>

                <div class="panel">
                    <div class="panel-header">
                        <h3 class="panel-title">
                            <span class="material-symbols-rounded">edit_square</span>편의시설 정보 입력
                        </h3>
                    </div>

                    <form id="registerForm"
                          method="post"
                          action="${pageContext.request.contextPath}/manager/publicFacility/insert/${mgmtOfcNo}"
                          enctype="multipart/form-data">
                        <sec:csrfInput/>

                        <%-- 히든 필드 --%>
                        <input type="hidden" id="registerMode"    name="registerMode"    value="EXISTING">
                        <input type="hidden" id="selectedFacilityNo" name="facilityNo"  value="${param.facilityNo}">
                        <input type="hidden" id="deleteFileUuids" name="deleteFileUuids">

                        <div class="panel-body">

                            <%-- ===== 안내문구: 2컬럼 바깥에 위치 ===== --%>
                            <div class="form-guide-line">
                                <div class="form-guide-text">
                                    편의시설로 등록하려면 먼저 시설자산으로 등록해주세요. 등록된 시설자산을 선택해 편의시설 운영정보를 입력할 수 있습니다.
                                </div>
                                <button type="button" class="btn btn-secondary" id="goFacilityRegisterBtn">
                                    시설자산 등록하러 가기
                                </button>
                            </div>

                            <%-- ===== 2컬럼 시작 ===== --%>
                            <div class="facility-cols">

                                <%-- ========== 좌측 컬럼 ========== --%>
                                <div class="facility-col-left">

                                    <%-- 기존 시설자산 연결 --%>
                                    <div id="existingFacilityPanel">
                                        <div class="asset-link-box" id="assetLinkBox">
                                            <div class="form-section-title">
                                                <span class="material-symbols-rounded">fact_check</span>기존 시설자산 연결
                                            </div>

                                            <%-- 미선택 상태 --%>
                                            <div class="asset-empty-state" id="assetEmptyState">
                                                <span class="material-symbols-rounded">domain_add</span>
                                                <div>편의시설 운영정보를 연결할 시설자산을 선택하세요.</div>
                                                <button type="button" class="btn btn-secondary" id="openAssetModalBtn">
                                                    연결할 시설자산 선택
                                                </button>
                                            </div>

                                            <%-- 선택 완료 상태 --%>
                                            <div class="asset-selected-state" id="assetSelectedState">
                                                <div class="asset-selected-row">
                                                    <div class="asset-selected-info">
                                                        <span class="material-symbols-rounded">link</span>
                                                        <span class="asset-selected-text" id="assetSelectedText" title="-">-</span>
                                                    </div>
                                                    <button type="button" class="btn btn-secondary" id="changeAssetBtn">
                                                        다시 선택
                                                    </button>
                                                </div>

                                                <%-- 선택된 시설자산 데이터 (화면에는 안 보임) --%>
                                                <div class="asset-hidden-data" aria-hidden="true">
                                                    <span id="assetName">-</span>
                                                    <span id="assetNo">-</span>
                                                    <span id="assetType">-</span>
                                                    <span id="assetLocation">-</span>
                                                    <span id="assetUseYn">-</span>
                                                </div>

                                                <div class="field-help">
                                                    등록한 사진은 연결된 시설자산의 사진으로 함께 관리됩니다.
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <%-- 편의시설 기본/운영정보 (탭 공통) --%>
                                    <div class="form-section">
                                        <div class="form-section-title">
                                            <span class="material-symbols-rounded">meeting_room</span>편의시설 기본/운영정보
                                        </div>

                                        <div class="form-row cols-2">
                                            <div class="form-field">
                                                <label class="field-label">편의시설명 <span class="req">*</span></label>
                                                <input type="text" class="form-input" id="regCmnNm" name="cmnFacilityNm" placeholder="예) 헬스장" required>
                                            </div>
                                            <div class="form-field">
                                                <label class="field-label">예약 가능 여부</label>
                                                <select class="form-select" id="regRsvYn" name="cmnFacilityRsvYn">
                                                    <option value="Y">예약제</option>
                                                    <option value="N">자유이용</option>
                                                </select>
                                            </div>
                                        </div>

                                        <div class="form-row cols-2">
                                            <div class="form-field">
                                                <label class="field-label">이용요금 (원)</label>
                                                <input type="number" class="form-input" id="regAmt" name="cmnFacilityAmt" placeholder="0 (무료)" min="0">
                                            </div>
                                        </div>

                                        <div class="form-row cols-1">
                                            <div class="form-field">
                                                <label class="field-label">운영요일/운영시간</label>
                                                <div class="opr-time-box">
                                                    <div class="opr-time-row">
                                                        <span class="opr-label">운영요일</span>
                                                        <div class="opr-day-range">
                                                            <select class="form-select" id="oprStartDay">
                                                                <option value="월" selected>월요일</option>
                                                                <option value="화">화요일</option>
                                                                <option value="수">수요일</option>
                                                                <option value="목">목요일</option>
                                                                <option value="금">금요일</option>
                                                                <option value="토">토요일</option>
                                                                <option value="일">일요일</option>
                                                            </select>
                                                            <span class="opr-separator">~</span>
                                                            <select class="form-select" id="oprEndDay">
                                                                <option value="월">월요일</option>
                                                                <option value="화">화요일</option>
                                                                <option value="수">수요일</option>
                                                                <option value="목">목요일</option>
                                                                <option value="금" selected>금요일</option>
                                                                <option value="토">토요일</option>
                                                                <option value="일">일요일</option>
                                                            </select>
                                                        </div>
                                                        <span class="opr-label">운영시간</span>
                                                        <input type="time" class="form-input" id="oprStartTime" step="60">
                                                        <span class="opr-separator">~</span>
                                                        <input type="time" class="form-input" id="oprEndTime" step="60">
                                                    </div>

                                                    <div class="opr-preview-row">
                                                        <span class="opr-label">저장값</span>
                                                        <div class="opr-preview is-empty" id="oprPreview">
                                                            운영시간을 입력하면 자동으로 저장값이 생성됩니다.
                                                        </div>
                                                    </div>
                                                    <div class="opr-notice" id="oprNotice"></div>

                                                    <input type="hidden" id="regOprHr" name="cmnFacilityOprHr">
                                                </div>
                                            </div>
                                        </div>

                                        <div class="form-row cols-1">
                                            <div class="form-field">
                                                <label class="field-label">시설 안내</label>
                                                <textarea class="form-textarea" id="regCn" name="cmnFacilityCn" rows="3" placeholder="시설 이용 안내사항을 입력하세요."></textarea>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <%-- ========== 우측 컬럼 ========== --%>
                                <div class="facility-col-right">

                                    <%-- 사진 영역 --%>
                                    <div class="form-section">
                                        <div class="form-section-title">
                                            <span class="material-symbols-rounded">image</span>시설 및 편의시설 사진
                                        </div>
                                        <div class="existing-photo-list" id="existingPhotoList" style="display:none;margin-bottom:8px;"></div>
                                        <div class="photo-upload-box">
                                            <div class="photo-upload-title">
                                                <span class="material-symbols-rounded">upload_file</span>사진 추가
                                            </div>
                                            <div class="photo-upload-desc" style="margin-top:3px;margin-bottom:8px;">
                                                이미지 파일을 여러 장 선택할 수 있습니다.
                                            </div>
                                            <input type="file" class="form-input" id="regImgInput" name="facilityFiles" accept="image/*" multiple>
                                            <div class="photo-preview-grid" id="photoPreviewGrid" style="margin-top:8px;">
                                                <div class="photo-empty-msg">선택된 사진이 없습니다.</div>
                                            </div>
                                        </div>
                                    </div>

                                    <%-- 자원 안내 --%>
                                    <div class="form-section" style="margin-top:auto;padding-top:14px;">
                                        <div class="form-section-title">
                                            <span class="material-symbols-rounded">inventory_2</span>편의시설 자원
                                        </div>
                                        <div class="resource-guide-list">
                                            <div class="resource-guide-row">
                                                <div>
                                                    <div class="resource-guide-main">자원 등록</div>
                                                    <div class="resource-guide-sub">편의시설 저장 후 수정 화면에서 등록할 수 있습니다.</div>
                                                </div>
                                                <span class="resource-badge">저장 후 가능</span>
                                            </div>
                                            <div class="resource-guide-row">
                                                <div>
                                                    <div class="resource-guide-main">자원 목록</div>
                                                    <div class="resource-guide-sub">수정 화면에서 이 편의시설에 연결된 자원을 확인할 수 있습니다.</div>
                                                </div>
                                                <span class="resource-badge">수정 화면 확인</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <%-- ===== 2컬럼 끝 ===== --%>

                            <div class="page-actions" style="justify-content:flex-end;margin-top:14px;">
                                <button type="button" class="btn btn-secondary" id="backToListBtn">취소</button>
                                <button type="submit" class="btn btn-primary">저장</button>
                            </div>
                        </div>
                    </form>
                </div>

                <%-- ===== 시설자산 선택 모달 ===== --%>
                <div class="asset-select-modal" id="assetSelectModal" aria-hidden="true">
                    <div class="asset-modal-box" role="dialog" aria-modal="true" aria-label="시설자산 선택">
                        <div class="asset-modal-head">
                            <h3 class="asset-modal-title">
                                <span class="material-symbols-rounded">domain_search</span>편의시설에 연결할 시설자산 선택
                            </h3>
                            <button type="button" class="asset-modal-close" id="closeAssetModalBtn" aria-label="닫기">
                                <span class="material-symbols-rounded">close</span>
                            </button>
                        </div>
                        <div class="asset-modal-body">

                            <div class="asset-count-row">
                                <div class="asset-count-badge" id="assetTotalCount">
                                    전체 <strong><c:choose><c:when test="${not empty facilityCandidateList}">${fn:length(facilityCandidateList)}</c:when><c:otherwise>0</c:otherwise></c:choose></strong>건
                                </div>
                                <div class="asset-count-badge" id="assetSearchCount">검색 결과 <strong>0</strong>건</div>
                            </div>

                            <div class="asset-filter-row">
                                <input type="text" class="form-input" id="assetKeyword" placeholder="시설명, 시설번호, 위치 검색">
                                <select class="form-select" id="assetTypeFilter">
                                    <option value="">시설유형 전체</option>
                                    <c:forEach var="type" items="${publicFacilityTypeList}">
                                        <option value="${type.code}">${type.codeNm}</option>
                                    </c:forEach>
                                </select>
                                <select class="form-select" id="assetDongFilter">
                                    <option value="">동 전체</option>
                                    <c:forEach var="dong" items="${dongList}">
                                        <option value="${dong.dongNo}">
                                            <c:choose>
                                                <c:when test="${fn:contains(dong.dongNo, '_')}">${fn:substringAfter(dong.dongNo, '_')}동</c:when>
                                                <c:when test="${not empty dong.dongNm}">${dong.dongNm}</c:when>
                                                <c:otherwise>${dong.dongNo}동</c:otherwise>
                                            </c:choose>
                                        </option>
                                    </c:forEach>
                                </select>
                                <button type="button" class="btn btn-secondary" id="assetFilterResetBtn">초기화</button>
                            </div>

                            <div class="asset-table-wrap">
                                <table class="asset-table">
                                    <colgroup>
                                        <col style="width:18%;">
                                        <col style="width:24%;">
                                        <col style="width:14%;">
                                        <col style="width:28%;">
                                        <col style="width:8%;">
                                        <col style="width:8%;">
                                    </colgroup>
                                    <thead>
                                    <tr>
                                        <th>시설번호</th>
                                        <th>시설명</th>
                                        <th>시설유형</th>
                                        <th>위치</th>
                                        <th>사용</th>
                                        <th class="cell-center">선택</th>
                                    </tr>
                                    </thead>
                                    <tbody id="assetTableBody">
                                    <c:forEach var="facility" items="${facilityCandidateList}">
                                        <tr class="asset-row"
                                            data-facility-no="${facility.facilityNo}"
                                            data-facility-nm="${facility.facilityNm}"
                                            data-facility-ty-cd="${facility.facilityTyCd}"
                                            data-facility-ty-nm="${empty facility.facilityTyNm ? facility.facilityTyCd : facility.facilityTyNm}"
                                            data-dong-no="${facility.dongNo}"
                                            data-loc-cn="${facility.locCn}"
                                            data-use-yn="${facility.useYn}">
                                            <td>${facility.facilityNo}</td>
                                            <td>
                                                <span class="asset-name-main">${facility.facilityNm}</span>
                                                <span class="asset-name-sub">운영관리 미등록</span>
                                            </td>
                                            <td>${empty facility.facilityTyNm ? facility.facilityTyCd : facility.facilityTyNm}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${empty facility.dongNo}">공용 위치</c:when>
                                                    <c:when test="${fn:contains(facility.dongNo, '_')}">${fn:substringAfter(facility.dongNo, '_')}동</c:when>
                                                    <c:otherwise>${facility.dongNo}동</c:otherwise>
                                                </c:choose>
                                                <c:if test="${not empty facility.locCn}"> · ${facility.locCn}</c:if>
                                            </td>
                                            <td>
                                                    ${facility.useYn eq 'N'
                                                            ? '<span class="badge-inactive">비활성</span>'
                                                            : '<span class="badge-active">활성</span>'}
                                            </td>
                                            <td class="cell-center">
                                                <button type="button" class="btn btn-xs btn-detail" data-action="selectAsset">선택</button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <tr class="asset-empty-row" id="assetEmptyRow" style="display:none;">
                                        <td colspan="6">검색 조건에 맞는 운영관리 미등록 시설자산이 없습니다.</td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/manager/manager-common.js"></script>
<script src="${pageContext.request.contextPath}/js/manager/common-image-viewer.js"></script>

<script>
    (function () {

        /* =====================================================
           설정값 및 공통 유틸
        ===================================================== */
        var config      = window.publicFacilityPageConfig || {};
        var contextPath = config.contextPath || "";
        var mgmtOfcNo   = config.mgmtOfcNo  || "";
        var preselectFacilityNo = config.preselectFacilityNo || "";

        function getEl(id) {
            return document.getElementById(id);
        }

        function listPageUrl() {
            return contextPath + "/manager/publicFacility/page/" + encodeURIComponent(mgmtOfcNo);
        }

        function facilityRegisterUrl() {
            // 편의시설 화면에서는 시설자산을 직접 만들지 않고 시설자산 등록 화면으로 이동합니다.
            return contextPath + "/manager/facility/register/" + encodeURIComponent(mgmtOfcNo) + "?from=public";
        }

        function showAlertMsg(msg, icon) {
            if (typeof window.showAlert === "function") return window.showAlert(msg, icon);
            alert(msg);
            return Promise.resolve();
        }

        function getCsrfHeaders() {
            var tokenMeta  = document.querySelector('meta[name="_csrf"]');
            var headerMeta = document.querySelector('meta[name="_csrf_header"]');
            var headers = {};
            if (tokenMeta && headerMeta) {
                headers[headerMeta.content] = tokenMeta.content;
            }
            return headers;
        }

        /* =====================================================
           API 요청 공통 함수
        ===================================================== */
        async function fetchJson(url, options) {
            var response    = await fetch(url, options || {});
            var contentType = response.headers.get("content-type") || "";

            // 로그인 만료 감지
            if (response.redirected || response.url.indexOf("/login.do") !== -1) {
                showAlertMsg("로그인이 필요합니다. 다시 로그인해주세요.");
                location.href = contextPath + "/login.do";
                throw new Error("login required");
            }

            if (contentType.indexOf("application/json") === -1) {
                throw new Error("JSON 응답이 아닙니다.");
            }

            var data = await response.json();
            if (!response.ok || data.success === false) {
                throw new Error(data.message || "요청 처리 중 오류가 발생했습니다.");
            }
            return data;
        }

        function postForm(url, formData) {
            return fetchJson(url, { method: "POST", headers: getCsrfHeaders(), body: formData });
        }

        /* =====================================================
           운영시간 미리보기
        ===================================================== */
        function getTimeValue(elementId) {
            return String(getEl(elementId).value || "").substring(0, 5);
        }

        function buildOperationDayText() {
            var startDay = getEl("oprStartDay").value;
            var endDay   = getEl("oprEndDay").value;
            if (!startDay || !endDay) return "";
            if (startDay === "월" && endDay === "일") return "매일";
            if (startDay === "월" && endDay === "금") return "평일";
            if (startDay === "토" && endDay === "일") return "주말";
            if (startDay === endDay) return startDay;
            return startDay + "~" + endDay;
        }

        function updateOperationPreview() {
            var startTime  = getTimeValue("oprStartTime");
            var endTime    = getTimeValue("oprEndTime");
            var hiddenEl   = getEl("regOprHr");
            var previewEl  = getEl("oprPreview");
            var noticeEl   = getEl("oprNotice");

            // 시간 미입력 시
            if (!startTime && !endTime) {
                hiddenEl.value  = "";
                previewEl.innerText = "운영시간을 입력하면 자동으로 저장값이 생성됩니다.";
                previewEl.classList.add("is-empty");
                noticeEl.innerText  = "";
                return;
            }

            // 시작/종료 중 하나만 입력 시
            if (!startTime || !endTime) {
                hiddenEl.value  = "";
                previewEl.innerText = "시작시간과 종료시간을 모두 입력해야 저장됩니다.";
                previewEl.classList.add("is-empty");
                noticeEl.innerText  = "";
                return;
            }

            // 정상 입력
            var dayText       = buildOperationDayText();
            var operationText = dayText + " " + startTime + "~" + endTime;
            hiddenEl.value    = operationText;
            previewEl.innerText = operationText;
            previewEl.classList.remove("is-empty");

            // 시간 순서 안내
            if (startTime > endTime) {
                noticeEl.innerText = "종료시간이 시작시간보다 빠르므로 다음날 종료되는 야간 운영으로 저장됩니다.";
            } else if (startTime === endTime) {
                noticeEl.innerText = "시작시간과 종료시간이 같아 24시간 운영 또는 별도 운영 기준으로 저장됩니다.";
            } else {
                noticeEl.innerText = "";
            }
        }

        function validateOperationTime() {
            var startTime = getTimeValue("oprStartTime");
            var endTime   = getTimeValue("oprEndTime");
            if (!startTime && !endTime) return true;
            if (!startTime || !endTime) {
                showAlertMsg("운영시간은 시작시간과 종료시간을 모두 입력하세요.");
                return false;
            }
            return true;
        }
        function syncReserveAmountState() {
            var reserveYn = getEl("regRsvYn");
            var amount    = getEl("regAmt");
            if (!reserveYn || !amount) return;

            // 자유이용 선택 시 이용요금 안내 문구 표시
            if (reserveYn.value === "N") {
                amount.value = "";
                amount.placeholder = "자유이용 금액설정 없음";
                amount.readOnly = true;
                return;
            }

            amount.placeholder = "0 (무료)";
            amount.readOnly = false;
        }
        /* =====================================================
           시설자산 선택 모달
        ===================================================== */
        function openAssetModal() {
            getEl("assetSelectModal").classList.add("is-open");
            getEl("assetSelectModal").setAttribute("aria-hidden", "false");
            document.body.style.overflow = "hidden";
            updateAssetSearchCount();
        }

        function closeAssetModal() {
            var modal    = getEl("assetSelectModal");
            var activeEl = document.activeElement;
            if (activeEl && modal.contains(activeEl)) activeEl.blur();

            modal.classList.remove("is-open");
            modal.setAttribute("aria-hidden", "true");
            document.body.style.overflow = "";

            // 모달 닫힌 후 포커스 복귀
            var returnBtn = getEl("changeAssetBtn") || getEl("openAssetModalBtn");
            if (returnBtn && returnBtn.offsetParent !== null) returnBtn.focus();
        }

        function formatDongText(dongNo) {
            var value = String(dongNo || "").trim();
            if (!value) return "공용 위치";
            if (value.indexOf("_") > -1) value = value.substring(value.lastIndexOf("_") + 1);
            if (value.indexOf("동") > -1) return value;
            return value + "동";
        }

        // 시설자산 행 선택
        function selectAsset(row) {
            if (!row) return;

            var facilityNo   = row.dataset.facilityNo   || "";
            var facilityNm   = row.dataset.facilityNm   || "";
            var facilityTyNm = row.dataset.facilityTyNm || row.dataset.facilityTyCd || "-";
            var dongNo       = row.dataset.dongNo       || "";
            var locCn        = row.dataset.locCn        || "";
            var useYn        = row.dataset.useYn        || "Y";
            var locationText = formatDongText(dongNo) + (locCn ? " · " + locCn : "");
            var summaryText  = [facilityNo || "-", facilityNm || "-", locationText || "-"].join(" · ");

            // 히든 필드에 선택한 시설번호 저장
            getEl("selectedFacilityNo").value = facilityNo;

            // 숨겨진 데이터 span 업데이트
            getEl("assetName").innerText     = facilityNm  || "-";
            getEl("assetNo").innerText       = facilityNo  || "-";
            getEl("assetType").innerText     = facilityTyNm;
            getEl("assetLocation").innerText = locationText || "-";
            getEl("assetUseYn").innerText    = (useYn === "N") ? "비활성" : "활성";

            // 선택 완료 UI 표시
            getEl("assetSelectedText").innerText = summaryText;
            getEl("assetSelectedText").title     = summaryText;
            getEl("assetEmptyState").style.display  = "none";
            getEl("assetSelectedState").classList.add("is-active");
            getEl("assetLinkBox").classList.add("is-selected");

            loadExistingPhotos(facilityNo);
            closeAssetModal();
        }

        // URL 파라미터로 사전 선택된 시설자산 적용
        function applyPreselectFacility(facilityNo) {
            if (!facilityNo) return;

            // 테이블에서 해당 행 찾기
            var rows = Array.from(document.querySelectorAll("#assetTableBody .asset-row"));
            var matchRow = rows.find(function (row) {
                return row.dataset.facilityNo === facilityNo;
            });

            if (matchRow) {
                selectAsset(matchRow);
                return;
            }

            // 테이블에 없으면 최소한 번호만 표시
            getEl("selectedFacilityNo").value    = facilityNo;
            getEl("assetNo").innerText           = facilityNo;
            getEl("assetName").innerText         = "선택된 시설자산";
            getEl("assetType").innerText         = "-";
            getEl("assetLocation").innerText     = "-";
            getEl("assetUseYn").innerText        = "-";
            getEl("assetSelectedText").innerText = facilityNo + " · 선택된 시설자산 · -";
            getEl("assetSelectedText").title     = facilityNo + " · 선택된 시설자산 · -";
            getEl("assetEmptyState").style.display = "none";
            getEl("assetSelectedState").classList.add("is-active");
            getEl("assetLinkBox").classList.add("is-selected");
            loadExistingPhotos(facilityNo);
        }

        // 외부에서 진입한 경우 시설자산 변경 불가 처리
        function lockAssetSelection() {
            var changeBtn = getEl("changeAssetBtn");
            if (changeBtn) {
                changeBtn.disabled  = true;
                changeBtn.innerText = "연결 시설자산 고정";
                changeBtn.title     = "시설자산 목록에서 선택되어 들어온 시설은 변경할 수 없습니다.";
            }
        }

        /* =====================================================
           모달 검색/필터
        ===================================================== */
        function filterAssetList() {
            var keyword    = (getEl("assetKeyword").value || "").toLowerCase().trim();
            var typeFilter = getEl("assetTypeFilter").value  || "";
            var dongFilter = getEl("assetDongFilter").value  || "";

            document.querySelectorAll("#assetTableBody .asset-row").forEach(function (row) {
                var rowText      = (row.innerText || "").toLowerCase();
                var matchKeyword = !keyword    || rowText.indexOf(keyword) > -1;
                var matchType    = !typeFilter || row.dataset.facilityTyCd === typeFilter;
                var matchDong    = !dongFilter || row.dataset.dongNo       === dongFilter;
                row.classList.toggle("is-hidden", !(matchKeyword && matchType && matchDong));
            });

            updateAssetSearchCount();
        }

        function updateAssetSearchCount() {
            var visibleCount = 0;
            document.querySelectorAll("#assetTableBody .asset-row").forEach(function (row) {
                if (!row.classList.contains("is-hidden")) visibleCount++;
            });
            getEl("assetSearchCount").innerHTML = "검색 결과 <strong>" + visibleCount + "</strong>건";
            getEl("assetEmptyRow").style.display = (visibleCount === 0) ? "table-row" : "none";
        }

        function resetAssetFilter() {
            getEl("assetKeyword").value    = "";
            getEl("assetTypeFilter").value = "";
            getEl("assetDongFilter").value = "";
            filterAssetList();
        }

        /* =====================================================
           기존 사진 불러오기
        ===================================================== */
        function getPhotoUrl(file) {
            if (file.viewUrl)  return file.viewUrl;
            if (file.fileUrl)  return file.fileUrl;
            if (file.googleId) return contextPath + "/file/display/" + encodeURIComponent(file.googleId);
            return "";
        }

        async function loadExistingPhotos(facilityNo) {
            var listEl = getEl("existingPhotoList");
            listEl.style.display = "";
            listEl.innerHTML     = '<div class="photo-empty-msg">기존 사진을 불러오는 중입니다.</div>';
            getEl("deleteFileUuids").value = "";

            try {
                var result = await fetchJson(
                    contextPath + "/manager/facility/detail/"
                    + encodeURIComponent(mgmtOfcNo) + "/" + encodeURIComponent(facilityNo)
                );
                var fileList = result.fileList
                    || result.attachFileList
                    || (result.facility && result.facility.fileList)
                    || [];
                renderExistingPhotos(fileList);
            } catch (err) {
                listEl.innerHTML = '<div class="photo-empty-msg">기존 사진을 불러오지 못했습니다.</div>';
            }
        }

        function renderExistingPhotos(files) {
            var listEl = getEl("existingPhotoList");

            if (!files || files.length === 0) {
                listEl.innerHTML = '<div class="photo-empty-msg">기존 등록 사진이 없습니다.</div>';
                return;
            }

            listEl.innerHTML = files.map(function (file) {
                var imgUrl   = getPhotoUrl(file);
                var fileName = file.fileOgName || file.fileSaveUuid || "시설사진";
                var uuid     = file.fileSaveUuid || "";
                var thumbHtml = imgUrl
                    ? '<img class="photo-thumb js-image-preview" src="' + imgUrl + '" alt="' + fileName + '">'
                    : '<div class="photo-thumb"></div>';

                return '<div class="existing-photo-row">'
                    + thumbHtml
                    + '<div class="photo-file-info">'
                    +   '<div class="photo-file-name">' + fileName + '</div>'
                    +   '<div class="photo-file-ext">'  + (file.fileExt || "image") + '</div>'
                    + '</div>'
                    + '<label class="photo-delete-label">'
                    +   '<input type="checkbox" class="js-delete-file-check" value="' + uuid + '">삭제'
                    + '</label>'
                    + '</div>';
            }).join("");
        }

        function updateDeleteFileUuids() {
            var checkedUuids = Array.from(document.querySelectorAll(".js-delete-file-check:checked"))
                .map(function (checkbox) { return checkbox.value; })
                .filter(Boolean);
            getEl("deleteFileUuids").value = checkedUuids.join(",");
        }

        /* =====================================================
           사진 미리보기
        ===================================================== */
        function previewNewPhotos() {
            var fileInput   = getEl("regImgInput");
            var previewGrid = getEl("photoPreviewGrid");
            previewGrid.innerHTML = "";

            if (!fileInput.files || fileInput.files.length === 0) {
                previewGrid.innerHTML = '<div class="photo-empty-msg">선택된 사진이 없습니다.</div>';
                return;
            }

            Array.from(fileInput.files).forEach(function (file) {
                var item = document.createElement("div");
                item.className = "photo-preview-item";

                if (file.type && file.type.indexOf("image/") === 0) {
                    var img       = document.createElement("img");
                    img.alt       = file.name;
                    img.src       = URL.createObjectURL(file);
                    img.className = "js-image-preview";
                    item.appendChild(img);
                }

                var nameEl       = document.createElement("div");
                nameEl.className = "photo-preview-item-name";
                nameEl.textContent = file.name;
                item.appendChild(nameEl);
                previewGrid.appendChild(item);
            });

            // 이미지 확대 보기 이벤트 재연결
            if (window.CommonImageViewer && typeof window.CommonImageViewer.bind === "function") {
                window.CommonImageViewer.bind("#photoPreviewGrid");
            }
        }

        /* =====================================================
           폼 저장
        ===================================================== */
        async function saveRegister(event) {
            event.preventDefault();

            var selectedFacilityNo = getEl("selectedFacilityNo").value;

            // 기존 시설자산 연결 필수 확인
            if (!selectedFacilityNo) {
                showAlertMsg("연결할 기존 시설자산을 선택하세요.");
                return;
            }
            if (!getEl("regCmnNm").value.trim()) {
                showAlertMsg("편의시설명을 입력하세요.");
                return;
            }

            // 운영시간 및 삭제 파일값 최종 조합
            updateOperationPreview();
            if (!validateOperationTime()) return;
            syncReserveAmountState();
            updateDeleteFileUuids();

            // 서버 전송
            try {
                await postForm(
                    contextPath + "/manager/publicFacility/insert/" + encodeURIComponent(mgmtOfcNo),
                    new FormData(getEl("registerForm"))
                );
                await showAlertThen("편의시설이 등록되었습니다.", listPageUrl(), "success");
            } catch (err) {
                console.error(err);
                await showAlertMsg(err.message || "편의시설 등록 중 오류가 발생했습니다.", "error");
            }
        }

        /* =====================================================
           이벤트 바인딩
        ===================================================== */
        /* ===== DEMO ONLY START =====
           Public facility demo autofill. Remove this whole block after the presentation.
           Shortcut: Ctrl + Alt + C
        */
        document.addEventListener("keydown", function (event) {
            if (!(event.ctrlKey && event.altKey && String(event.key || "").toLowerCase() === "c")) {
                return;
            }

            if (!document.getElementById("publicFacilityPage")) {
                return;
            }

            event.preventDefault();
            fillPublicFacilityDemoData();
        });

        function setDemoValue(selector, value) {
            var element = document.querySelector(selector);

            if (!element) {
                return;
            }

            element.value = value;
            element.dispatchEvent(new Event("input", { bubbles: true }));
            element.dispatchEvent(new Event("change", { bubbles: true }));
        }

        function fillPublicFacilityDemoData() {
            setDemoValue("#regCmnNm", "미륭테니스장");
            setDemoValue("#regAmt", "1000");
            setDemoValue("#oprStartTime", "09:30");
            setDemoValue("#oprEndTime", "17:00");
            setDemoValue("#regCn", "입주민 전용 테니스장입니다. 예약 시간 10분 전부터 입장 가능하며, 이용 후 코트 정리와 개인 장비 회수를 부탁드립니다.");
            updateOperationPreview();
        }
        /* ===== DEMO ONLY END ===== */

        document.addEventListener("DOMContentLoaded", function () {

            // 시설자산 등록 화면 이동
            getEl("goFacilityRegisterBtn").addEventListener("click", function () {
                location.href = facilityRegisterUrl();
            });

            // 시설자산 선택 모달
            getEl("openAssetModalBtn").addEventListener("click", openAssetModal);
            getEl("changeAssetBtn").addEventListener("click", openAssetModal);
            getEl("closeAssetModalBtn").addEventListener("click", closeAssetModal);
            getEl("assetSelectModal").addEventListener("click", function (e) {
                if (e.target === getEl("assetSelectModal")) closeAssetModal();
            });
            document.addEventListener("keydown", function (e) {
                if (e.key === "Escape") closeAssetModal();
            });

            // 모달 테이블 행 선택
            getEl("assetTableBody").addEventListener("click", function (e) {
                var selectBtn = e.target.closest('[data-action="selectAsset"]');
                var row       = e.target.closest(".asset-row");
                if (selectBtn && row) selectAsset(row);
            });

            // 모달 검색 필터
            getEl("assetKeyword").addEventListener("keyup", filterAssetList);
            getEl("assetTypeFilter").addEventListener("change", filterAssetList);
            getEl("assetDongFilter").addEventListener("change", filterAssetList);
            getEl("assetFilterResetBtn").addEventListener("click", resetAssetFilter);

            // 운영시간 미리보기
            ["oprStartDay", "oprEndDay", "oprStartTime", "oprEndTime"].forEach(function (id) {
                getEl(id).addEventListener("change", updateOperationPreview);
                getEl(id).addEventListener("input",  updateOperationPreview);
            });

            // 사진 선택
            getEl("regImgInput").addEventListener("change", previewNewPhotos);
            getEl("regRsvYn").addEventListener("change", syncReserveAmountState);
            document.addEventListener("change", function (e) {
                if (e.target.classList.contains("js-delete-file-check")) updateDeleteFileUuids();
            });

            // 폼 저장 / 취소
            getEl("registerForm").addEventListener("submit", saveRegister);
            getEl("backToListBtn").addEventListener("click", function () { history.back(); });

            // 초기화
            updateAssetSearchCount();
            updateOperationPreview();
            syncReserveAmountState();

            // 이미지 확대 뷰어 초기 연결
            if (window.CommonImageViewer && typeof window.CommonImageViewer.bind === "function") {
                CommonImageViewer.bind("#existingPhotoList");
            }

            // URL 파라미터로 사전 선택된 시설자산 처리
            if (preselectFacilityNo) {
                applyPreselectFacility(preselectFacilityNo);
                lockAssetSelection();
            }
        });

    })();
</script>
</body>
</html>
