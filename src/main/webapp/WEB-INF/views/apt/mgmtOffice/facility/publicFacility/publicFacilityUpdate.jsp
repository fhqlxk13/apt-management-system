<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>편의시설 수정</title>
    <sec:csrfMetaTags/>

    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/office-layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/manager-common.css">

    <style>
        #publicFacilityPage { --accent:#2e5c38; --accent-hover:#1f4027; --accent-light:#e8f0ea; --accent-dim:rgba(46,92,56,.08); --surface:#ffffff; --surface-sub:#f8f9fb; --line:#d7dce2; --th-bg:#f3f5f3; --text-pri:#1a1f1b; --text-sec:#4a5c4e; --text-ter:#8a9a8e; }
        #publicFacilityPage .page-title-block h2 { color:var(--text-pri); font-size:19px; letter-spacing:-.5px; }
        #publicFacilityPage .page-title-block p  { color:var(--text-sec); font-size:12px; }
        #publicFacilityPage .panel { border-radius:6px; border:1px solid var(--line); box-shadow:none; margin:0; }
        #publicFacilityPage .panel-header { display:flex; align-items:center; justify-content:space-between; padding:13px 16px; border-bottom:1px solid var(--line); background:var(--surface); border-radius:6px 6px 0 0; }
        #publicFacilityPage .panel-title { display:flex; align-items:center; gap:6px; margin:0; font-size:13px; font-weight:800; color:var(--text-pri); }
        #publicFacilityPage .panel-title .material-symbols-rounded { font-size:17px; color:var(--accent); }
        #publicFacilityPage .panel-body { padding:14px 16px 16px; background:var(--surface); }
        #publicFacilityPage .panel-body .form-input, #publicFacilityPage .panel-body .form-select { height:32px; font-size:12px; border-color:var(--line); background:var(--surface); border-radius:4px; }
        #publicFacilityPage .panel-body .form-input:focus, #publicFacilityPage .panel-body .form-select:focus { border-color:var(--accent); box-shadow:0 0 0 2px var(--accent-dim); }
        #publicFacilityPage .panel-body .form-input[readonly] { background:var(--surface-sub); color:var(--text-pri); opacity:1; cursor:default; }
        #publicFacilityPage .panel-body .form-input:disabled, #publicFacilityPage .panel-body .form-select:disabled { background:#f4f5f6; color:#9ca3af; cursor:not-allowed; }
        #publicFacilityPage .panel-body .form-textarea { font-size:12px; border-color:var(--line); border-radius:4px; resize:vertical; }
        #publicFacilityPage .panel-body .form-textarea:focus { border-color:var(--accent); box-shadow:0 0 0 2px var(--accent-dim); }
        #publicFacilityPage .btn { border-radius:4px; }
        #publicFacilityPage .btn-primary { background:var(--accent); border-color:var(--accent); }
        #publicFacilityPage .btn-primary:hover { background:var(--accent-hover); border-color:var(--accent-hover); }
        #publicFacilityPage .notice-box { display:flex; gap:10px; padding:11px 13px; background:#f7faf7; border:1px solid var(--line); border-left:3px solid var(--accent); border-radius:0 4px 4px 0; font-size:12px; color:var(--text-sec); line-height:1.6; }
        #publicFacilityPage .notice-box .material-symbols-rounded { color:var(--accent); font-size:17px; flex-shrink:0; margin-top:2px; }
        #publicFacilityPage .field-help { margin-top:5px; font-size:11px; color:var(--text-ter); line-height:1.5; }
        .form-section-title { display:flex; align-items:center; gap:4px; font-size:11px; font-weight:600; color:var(--text-sec,#4a5c4e); letter-spacing:0; text-transform:none; margin-bottom:10px; }
        .form-section-title .material-symbols-rounded { font-size:15px; color:var(--accent,#2e5c38); }

        /* 2컬럼 레이아웃 */
        .facility-modal-cols { display:grid; grid-template-columns:1fr 1fr; gap:0; }
        .facility-modal-col-left { padding-right:20px; border-right:1px solid var(--line,#d7dce2); }
        .facility-modal-col-right { padding-left:20px; }
        .facility-col-label { font-size:11px; font-weight:600; color:#8a9a8e; letter-spacing:.5px; text-transform:uppercase; padding-bottom:8px; border-bottom:1px solid var(--line,#d7dce2); margin-bottom:14px; }

        /* 선택된 시설자산 요약 */
        #publicFacilityPage .selected-facility-box { border:none; border-radius:0; background:none; padding:0; }
        #publicFacilityPage .selected-facility-box.is-selected { border:none; border-radius:0; padding:0; background:none; }
        #publicFacilityPage .selected-empty { display:flex; align-items:center; justify-content:center; flex-direction:column; gap:5px; min-height:92px; color:var(--text-ter); font-size:12px; text-align:center; }
        #publicFacilityPage .selected-empty .material-symbols-rounded { font-size:24px; color:#a7b2aa; }
        #publicFacilityPage .selected-summary { display:none; }
        #publicFacilityPage .selected-summary.is-active { display:block; }
        #publicFacilityPage .selected-line-box { display:flex; align-items:center; justify-content:space-between; gap:12px; min-height:42px; padding:10px 12px; border:1px solid var(--line); border-radius:4px; background:#f6f7f8; }
        #publicFacilityPage .selected-line-main { min-width:0; display:flex; align-items:center; gap:7px; color:var(--text-sec); font-size:12px; font-weight:400; line-height:1.45; white-space:nowrap; overflow:hidden; }
        #publicFacilityPage .selected-line-main .material-symbols-rounded { flex-shrink:0; font-size:16px; color:#9aa5a0; }
        #publicFacilityPage .selected-line-text { display:block; min-width:0; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }
        #publicFacilityPage .selected-line-lock { flex-shrink:0; display:inline-flex; align-items:center; gap:3px; min-height:24px; padding:0 7px; border:1px solid #dce4df; border-radius:4px; background:#fff; color:var(--text-sec); font-size:11px; font-weight:500; cursor:not-allowed; }
        #publicFacilityPage .selected-line-lock .material-symbols-rounded { font-size:13px; color:#9aa5a0; }
        #publicFacilityPage .selected-hidden-values { display:none; }

        /* 사진 업로드 */
        #publicFacilityPage .file-upload-box { border:1px dashed var(--line); border-radius:4px; padding:12px; background:#fafcfb; }
        #publicFacilityPage .file-upload-title { display:flex; align-items:center; gap:5px; font-size:12px; font-weight:800; color:var(--text-sec); }
        #publicFacilityPage .file-upload-title .material-symbols-rounded { font-size:16px; color:var(--accent); }
        #publicFacilityPage .file-upload-desc { font-size:11px; color:var(--text-ter); line-height:1.5; }
        #publicFacilityPage .file-preview-list { display:grid; grid-template-columns:repeat(4,minmax(0,1fr)); gap:8px; margin-top:10px; }
        #publicFacilityPage .file-preview-item { position:relative; min-height:92px; border:1px solid var(--line); border-radius:4px; background:#fff; overflow:hidden; }
        #publicFacilityPage .file-preview-item img { width:100%; height:92px; object-fit:cover; display:block; cursor:zoom-in; }
        #publicFacilityPage .file-preview-name { padding:6px 7px; font-size:11px; color:var(--text-sec); white-space:nowrap; overflow:hidden; text-overflow:ellipsis; border-top:1px solid var(--line); }
        #publicFacilityPage .file-preview-empty { padding:13px; border:1px solid var(--line); border-radius:4px; background:#fff; font-size:12px; color:var(--text-ter); }
        #publicFacilityPage .file-manage-list { display:flex; flex-direction:column; gap:7px; margin-top:8px; }
        #publicFacilityPage .file-manage-row { display:flex; align-items:center; gap:10px; padding:8px 10px; border:1px solid var(--line); border-radius:4px; background:#fff; }
        #publicFacilityPage .file-thumb { width:48px; height:48px; border-radius:4px; border:1px solid var(--line); object-fit:cover; background:#f4f7f4; flex-shrink:0; cursor:zoom-in; }
        #publicFacilityPage .file-info { min-width:0; flex:1; }
        #publicFacilityPage .file-name { font-size:12px; font-weight:700; color:#111827; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
        #publicFacilityPage .file-meta { margin-top:2px; font-size:11px; color:var(--text-ter); }
        #publicFacilityPage .file-delete-check { display:inline-flex; align-items:center; gap:4px; font-size:11px; color:#7f1d1d; font-weight:700; }
        #publicFacilityPage .file-delete-check input { width:14px; height:14px; }
        #publicFacilityPage .photo-guide { align-items:flex-start; padding:12px; }
        #publicFacilityPage .photo-guide-title { margin-bottom:9px; font-size:12px; font-weight:800; color:var(--text-pri); }
        #publicFacilityPage .photo-guide-row { display:flex; align-items:center; justify-content:space-between; gap:10px; padding:8px 0; border-top:1px solid rgba(46,92,56,.13); }
        #publicFacilityPage .photo-guide-row span { flex:0 0 auto; font-size:11px; color:var(--text-sec); font-weight:700; }
        #publicFacilityPage .photo-guide-row strong { min-width:0; text-align:right; font-size:11px; color:var(--text-pri); font-weight:800; line-height:1.35; }

        /* 운영시간 입력 */
        #publicFacilityPage .opr-time-box { display:flex; flex-direction:column; gap:8px; padding:10px; border:1px solid var(--line); border-radius:4px; background:#fafcfb; }
        #publicFacilityPage .opr-time-row { display:grid; grid-template-columns:64px minmax(120px,1fr) 64px minmax(112px,1fr) 16px minmax(112px,1fr); gap:7px; align-items:center; }
        #publicFacilityPage .opr-custom-day-row { display:none; grid-template-columns:64px minmax(112px,1fr) 16px minmax(112px,1fr); gap:7px; align-items:center; }
        #publicFacilityPage .opr-custom-day-row.is-active { display:grid; }
        #publicFacilityPage .opr-time-label { font-size:11px; font-weight:800; color:var(--text-sec); white-space:nowrap; }
        #publicFacilityPage .opr-time-separator { text-align:center; font-size:12px; font-weight:800; color:var(--text-ter); }
        #publicFacilityPage .opr-preview-row { display:grid; grid-template-columns:64px 1fr; gap:7px; align-items:center; }
        #publicFacilityPage .opr-preview { min-height:30px; padding:6px 9px; display:flex; align-items:center; border:1px solid var(--line); border-radius:4px; background:#fff; font-size:12px; font-weight:700; color:var(--text-pri); }
        #publicFacilityPage .opr-preview.is-empty { color:var(--text-ter); font-weight:500; }
        #publicFacilityPage .opr-time-notice { min-height:17px; padding-left:71px; font-size:11px; line-height:1.5; color:#b45309; }
        #publicFacilityPage .opr-time-notice:empty { display:none; }

        /* 자원 상태 — 점+텍스트 */
        #publicFacilityPage .item-stts { display:inline-flex; align-items:center; gap:5px; font-size:12px; white-space:nowrap; }
        #publicFacilityPage .item-stts-dot { width:6px; height:6px; border-radius:50%; flex-shrink:0; }
        #publicFacilityPage .item-stts-open   .item-stts-dot { background:#22c55e; }
        #publicFacilityPage .item-stts-open   .item-stts-txt { color:#1f7a3f; }
        #publicFacilityPage .item-stts-use    .item-stts-dot { background:#3b82f6; }
        #publicFacilityPage .item-stts-use    .item-stts-txt { color:#1e3a5f; }
        #publicFacilityPage .item-stts-repair .item-stts-dot { background:#eab308; }
        #publicFacilityPage .item-stts-repair .item-stts-txt { color:#854d0e; }
        #publicFacilityPage .item-stts-close  .item-stts-dot { background:#ef4444; }
        #publicFacilityPage .item-stts-close  .item-stts-txt { color:#b42318; }

        /* 자원 목록 2컬럼 테이블 */
        #publicFacilityPage .item-2col-wrap { border:1px solid var(--line); border-radius:4px; overflow:hidden; max-height:220px; overflow-y:auto; }
        #publicFacilityPage .item-2col-wrap::-webkit-scrollbar { width:4px; }
        #publicFacilityPage .item-2col-wrap::-webkit-scrollbar-thumb { background:var(--line); border-radius:2px; }
        #publicFacilityPage .item-2col-table { width:100%; border-collapse:collapse; table-layout:fixed; font-size:12px; }
        #publicFacilityPage .item-2col-table th { height:32px; padding:0 8px; background:var(--surface-sub); color:var(--text-sec); font-size:11px; font-weight:800; text-align:left; border-bottom:1px solid var(--line); }
        #publicFacilityPage .item-2col-table td { height:38px; padding:6px 8px; border-bottom:1px solid var(--line); vertical-align:middle; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }
        #publicFacilityPage .item-2col-table tbody tr:last-child td { border-bottom:none; }
        #publicFacilityPage .item-2col-table tbody tr { cursor:pointer; transition:background .1s; }
        #publicFacilityPage .item-2col-table tbody tr:hover { background:var(--accent-dim); }
        #publicFacilityPage .item-2col-table tbody tr:hover .item-edit-icon { color:var(--accent); }
        #publicFacilityPage .item-col-div { width:1px; min-width:1px; max-width:1px; padding:0 !important; background:var(--line) !important; border-left:1px solid var(--line); border-right:none; }
        #publicFacilityPage .item-col-spc { width:8px; min-width:8px; max-width:8px; padding:0 !important; background:#fff; border-left:none; border-right:none; }
        #publicFacilityPage .item-2col-table thead .item-col-div { background:var(--line) !important; border-bottom:1px solid var(--line); }
        #publicFacilityPage .item-2col-table thead .item-col-spc { background:var(--surface-sub); border-bottom:1px solid var(--line); }
        #publicFacilityPage .item-action-col { width:32px; }
        #publicFacilityPage .item-action-cell { width:32px; padding:6px 4px !important; text-align:center; overflow:visible !important; }
        #publicFacilityPage .item-edit-icon { display:inline-flex; align-items:center; justify-content:center; width:18px; height:18px; margin-left:-3px; font-size:15px; color:var(--text-ter); vertical-align:middle; transition:color .1s; }

        @media (max-width:760px) {
            .facility-modal-cols { grid-template-columns:1fr; }
            .facility-modal-col-left { padding-right:0; border-right:none; border-bottom:1px solid var(--line,#d7dce2); padding-bottom:16px; margin-bottom:16px; }
            .facility-modal-col-right { padding-left:0; }
            #publicFacilityPage .selected-grid { grid-template-columns:1fr; }
        }
    </style>

    <script>
        window.publicFacilityPageConfig = {
            contextPath: "${pageContext.request.contextPath}",
            mgmtOfcNo: "${mgmtOfcNo}",
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
                        <h2>편의시설 수정</h2>
                        <p>편의시설 운영정보를 수정합니다.</p>
                    </div>
                </div>

                <div class="panel">
                    <div class="panel-header">
                        <h3 class="panel-title"><span class="material-symbols-rounded">edit_square</span>편의시설 운영정보 수정</h3>
                    </div>

                    <form id="registerForm" method="post" action="${pageContext.request.contextPath}/manager/publicFacility/update/${mgmtOfcNo}" enctype="multipart/form-data">
                        <sec:csrfInput/>
                        <input type="hidden" id="registerMode" name="registerMode" value="EXISTING">
                        <input type="hidden" id="cmnFacilityNo" name="cmnFacilityNo" value="${detail.cmnFacilityNo}">
                        <input type="hidden" id="selectedFacilityNo" name="facilityNo" value="${detail.facilityNo}">
                        <input type="hidden" id="deleteFileUuids" name="deleteFileUuids">

                        <div class="panel-body">
                            <div class="facility-modal-cols">
                                <div class="facility-modal-col-left">

                                    <div class="mode-panel is-active" id="existingFacilityPanel" data-mode-panel="EXISTING">
                                        <div class="form-section" style="margin-bottom:14px;">
                                            <div class="form-section-title">
                                                <span class="material-symbols-rounded">apartment</span>연결된 시설자산
                                            </div>

                                            <div class="selected-facility-box">
                                                <div class="selected-empty" id="selectedEmptyBox" style="display:none;">
                                                    <span class="material-symbols-rounded">domain_add</span>
                                                    <div>운영관리 정보를 입력할 시설자산을 선택하세요.</div>
                                                    <button type="button" class="btn btn-secondary" id="openFacilityModalBtn">시설자산 선택</button>
                                                </div>

                                                <div class="selected-summary is-active" id="selectedSummaryBox">
                                                    <%-- 연결된 시설자산은 수정 화면에서 변경하지 않고 1줄 참고 정보로 표시 --%>
                                                    <c:set var="detailDongText" value="${empty detail.dongNo ? '공용 위치' : (fn:contains(detail.dongNo, '_') ? fn:substringAfter(detail.dongNo, '_') : detail.dongNo)}" />
                                                    <c:if test="${not empty detail.dongNo and not fn:endsWith(detailDongText, '동')}">
                                                        <c:set var="detailDongText" value="${detailDongText}동" />
                                                    </c:if>

                                                    <div class="selected-line-box">
                                                        <div class="selected-line-main">
                                                            <span class="material-symbols-rounded">link</span>
                                                            <span class="selected-line-text"
                                                                  title="${empty detail.facilityNo ? '-' : detail.facilityNo} · ${empty detail.facilityNm ? '-' : detail.facilityNm} · ${detailDongText} · ${empty detail.locCn ? '-' : detail.locCn}">
                                                                ${empty detail.facilityNo ? '-' : detail.facilityNo}
                                                                · ${empty detail.facilityNm ? '-' : detail.facilityNm}
                                                                · ${detailDongText}
                                                                · ${empty detail.locCn ? '-' : detail.locCn}
                                                            </span>
                                                        </div>
                                                        <button type="button" class="selected-line-lock" id="changeFacilityBtn" disabled
                                                                title="수정 화면에서는 연결된 시설자산을 변경하지 않습니다.">
                                                            <span class="material-symbols-rounded">lock</span>
                                                            시설자산 고정
                                                        </button>
                                                    </div>

                                                    <%-- 기존 스크립트/확장 작업을 위한 값 보관 영역 --%>
                                                    <div class="selected-hidden-values">
                                                        <span id="selectedFacilityNmText">${empty detail.facilityNm ? '-' : detail.facilityNm}</span>
                                                        <span id="selectedFacilityNoText">${empty detail.facilityNo ? '-' : detail.facilityNo}</span>
                                                        <span id="selectedFacilityTyText">${empty detail.facilityTyNm ? detail.facilityTyCd : detail.facilityTyNm}</span>
                                                        <span id="selectedLocationText">${detailDongText}${empty detail.locCn ? '' : ' · '}${empty detail.locCn ? '' : detail.locCn}</span>
                                                        <span id="selectedUseYnText">${detail.useYn eq 'N' ? '비활성' : '활성'}</span>
                                                    </div>

                                                    <div class="field-help">운영관리 등록 후 시설자산 연결은 변경하지 않습니다.</div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="form-section">
                                        <div class="form-section-title">
                                            <span class="material-symbols-rounded">meeting_room</span>편의시설 운영정보
                                        </div>

                                        <div class="form-row cols-2">
                                            <div class="form-field">
                                                <label class="field-label">편의시설명 <span class="req">*</span></label>
                                                <input type="text" class="form-input" id="regCmnNm" name="cmnFacilityNm" value="${detail.cmnFacilityNm}" placeholder="예) 헬스장" required>
                                            </div>
                                            <div class="form-field">
                                                <label class="field-label">예약 가능 여부</label>
                                                <select class="form-select" id="regRsvYn" name="cmnFacilityRsvYn">
                                                    <option value="Y" ${detail.cmnFacilityRsvYn eq 'Y' ? 'selected' : ''}>예약제</option>
                                                    <option value="N" ${detail.cmnFacilityRsvYn eq 'N' ? 'selected' : ''}>자유이용</option>
                                                </select>
                                            </div>
                                        </div>

                                        <div class="form-row cols-2">
                                            <div class="form-field">
                                                <label class="field-label">이용요금 (원)</label>
                                                <input type="number" class="form-input" id="regAmt" name="cmnFacilityAmt" value="${detail.cmnFacilityAmt}" placeholder="0 (무료)" min="0">
                                            </div>
                                        </div>

                                        <div class="form-row cols-1">
                                            <div class="form-field">
                                                <label class="field-label">운영요일/운영시간</label>
                                                <div class="opr-time-box">
                                                    <div class="opr-time-row">
                                                        <span class="opr-time-label">운영요일</span>
                                                        <select class="form-select" id="oprDayType">
                                                            <option value="DAILY" selected>매일</option>
                                                            <option value="WEEKDAY">평일</option>
                                                            <option value="WEEKEND">주말</option>
                                                            <option value="CUSTOM">직접 지정</option>
                                                        </select>
                                                        <span class="opr-time-label">운영시간</span>
                                                        <input type="time" class="form-input" id="oprStartTime" step="60">
                                                        <span class="opr-time-separator">~</span>
                                                        <input type="time" class="form-input" id="oprEndTime" step="60">
                                                    </div>

                                                    <div class="opr-custom-day-row" id="oprCustomDayRow">
                                                        <span class="opr-time-label">요일범위</span>
                                                        <select class="form-select" id="oprStartDay">
                                                            <option value="월" selected>월요일</option>
                                                            <option value="화">화요일</option>
                                                            <option value="수">수요일</option>
                                                            <option value="목">목요일</option>
                                                            <option value="금">금요일</option>
                                                            <option value="토">토요일</option>
                                                            <option value="일">일요일</option>
                                                        </select>
                                                        <span class="opr-time-separator">~</span>
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

                                                    <div class="opr-preview-row">
                                                        <span class="opr-time-label">저장값</span>
                                                        <div class="opr-preview is-empty" id="oprHrPreview">운영시간을 입력하면 자동으로 저장값이 생성됩니다.</div>
                                                    </div>
                                                    <div class="opr-time-notice" id="oprTimeNotice"></div>
                                                    <input type="hidden" id="regOprHr" name="cmnFacilityOprHr" value="${detail.cmnFacilityOprHr}">
                                                </div>
                                            </div>
                                        </div>

                                        <div class="form-row cols-1">
                                            <div class="form-field">
                                                <label class="field-label">시설 안내</label>
                                                <textarea class="form-textarea" id="regCn" name="cmnFacilityCn" rows="3" placeholder="시설 이용 안내사항을 입력하세요.">${detail.cmnFacilityCn}</textarea>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <%-- 우측: 사진 등록 --%>
                                <div class="facility-modal-col-right">
                                    <div class="form-section">
                                        <div class="form-section-title">
                                            <span class="material-symbols-rounded">image</span>편의시설 사진
                                        </div>
                                        <div class="file-upload-box">
                                            <div class="file-upload-title"><span class="material-symbols-rounded">upload_file</span>사진 추가</div>
                                            <div class="file-upload-desc" style="margin-top:3px;margin-bottom:8px;">이미지 파일을 여러 장 선택할 수 있습니다.</div>
                                            <input type="file" class="form-input" id="regImgInput" name="facilityFiles" accept="image/*" multiple>
                                            <div class="file-preview-list" id="regImgGrid" style="margin-top:8px;">
                                                <div class="file-preview-empty">선택된 사진이 없습니다.</div>
                                            </div>
                                        </div>
                                        <%-- 기존 등록 사진은 사진 추가 영역 아래에 표시 --%>
                                        <div class="file-manage-list" id="regFileManageList" style="display:none;margin-top:10px;"></div>
                                    </div>

                                    <%-- 자원 아이템 목록 --%>
                                    <c:if test="${not empty detail.cmnFacilityNo}">
                                        <div class="form-section" style="margin-top:14px;">
                                            <div class="form-section-title" style="justify-content:space-between;">
                                            <span style="display:flex;align-items:center;gap:4px;">
                                                <span class="material-symbols-rounded">inventory_2</span>편의시설 자원
                                            </span>
                                                <button type="button" class="btn btn-secondary btn-sm" id="itemInsertBtn" style="height:26px;padding:0 10px;font-size:11px;">
                                                    <span class="material-symbols-rounded" style="font-size:13px;vertical-align:middle;">add</span> 자원 등록
                                                </button>
                                            </div>
                                            <div id="itemTotalBox" style="text-align:right;font-size:11px;color:var(--text-ter);margin-bottom:6px;">
                                                전체 <strong id="itemTotalCount" style="color:var(--text-sec);">0</strong>개
                                            </div>
                                            <div class="item-2col-wrap">
                                                <table class="item-2col-table">
                                                    <colgroup>
                                                        <col style="width:88px">
                                                        <col>
                                                        <col style="width:76px">
                                                        <col class="item-action-col">
                                                        <col class="item-col-div">
                                                        <col class="item-col-spc">
                                                        <col style="width:88px">
                                                        <col>
                                                        <col style="width:76px">
                                                        <col class="item-action-col">
                                                    </colgroup>
                                                    <thead>
                                                    <tr>
                                                        <th>자원번호</th>
                                                        <th>자원명</th>
                                                        <th style="text-align:center;">상태</th>
                                                        <th></th>
                                                        <th class="item-col-div"></th>
                                                        <th class="item-col-spc"></th>
                                                        <th>자원번호</th>
                                                        <th>자원명</th>
                                                        <th style="text-align:center;">상태</th>
                                                        <th></th>
                                                    </tr>
                                                    </thead>
                                                    <tbody id="itemListBody">
                                                    <tr><td colspan="10" style="padding:18px;text-align:center;font-size:12px;color:var(--text-ter);">자원 목록을 불러오는 중...</td></tr>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </div>

                        <div class="page-actions" style="justify-content:flex-end;margin-top:14px;">
                            <button type="button" class="btn btn-secondary" id="backToListBtn">취소</button>
                            <button type="submit" class="btn btn-primary">저장</button>
                        </div>
                    </form>
                </div>

            </div>
        </main>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/manager/manager-common.js"></script>
<script src="${pageContext.request.contextPath}/js/manager/common-image-viewer.js"></script>

<script>
    (function () {
        var config = window.publicFacilityPageConfig || {};
        var contextPath = config.contextPath || "";
        var mgmtOfcNo  = config.mgmtOfcNo  || "";

        function getEl(id) { return document.getElementById(id); }

        function syncReserveAmountState() {
            var reserveYn = getEl("regRsvYn");
            var amount = getEl("regAmt");
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

        function listUrl() { return contextPath + "/manager/publicFacility/page/" + encodeURIComponent(mgmtOfcNo); }
        function alertMessage(msg, icon) {
            if (typeof showAlert === "function") return showAlert(msg, icon);
            alert(msg);
            return Promise.resolve();
        }

        function getCsrfHeaders() {
            var tokenMeta  = document.querySelector('meta[name="_csrf"]');
            var headerMeta = document.querySelector('meta[name="_csrf_header"]');
            var headers = {};
            if (tokenMeta && headerMeta) headers[headerMeta.content] = tokenMeta.content;
            return headers;
        }

        async function requestJson(url, options) {
            var response = await fetch(url, options || {});
            var contentType = response.headers.get("content-type") || "";
            if (response.redirected || response.url.indexOf("/login.do") !== -1) {
                alertMessage("로그인이 필요합니다. 다시 로그인해주세요.");
                location.href = contextPath + "/login.do";
                throw new Error("login required");
            }
            if (contentType.indexOf("application/json") === -1) {
                throw new Error("JSON 응답이 아닙니다.");
            }
            var data = await response.json();
            if (!response.ok || data.success === false) throw new Error(data.message || "요청 처리 중 오류가 발생했습니다.");
            return data;
        }

        function postForm(url, formData) {
            return requestJson(url, { method:"POST", headers:getCsrfHeaders(), body:formData });
        }

        function getJson(url) {
            return requestJson(url, { method:"GET", headers:getCsrfHeaders() });
        }

        function buildOperationDayText() {
            var dayType = getEl("oprDayType").value;
            var startDay = getEl("oprStartDay").value;
            var endDay = getEl("oprEndDay").value;
            if (dayType === "DAILY") return "매일";
            if (dayType === "WEEKDAY") return "평일";
            if (dayType === "WEEKEND") return "주말";
            if (!startDay || !endDay) return "";
            if (startDay === startDay && startDay === endDay) return startDay;
            return startDay + "~" + endDay;
        }

        function updateOperationDayTypeView() {
            var customDayRow = getEl("oprCustomDayRow");
            if (!customDayRow) return;
            customDayRow.classList.toggle("is-active", getEl("oprDayType").value === "CUSTOM");
        }

        function updateOperationHourText() {
            updateOperationDayTypeView();
            var startTime = getEl("oprStartTime").value;
            var endTime = getEl("oprEndTime").value;
            var hiddenInput = getEl("regOprHr");
            var preview = getEl("oprHrPreview");
            var notice = getEl("oprTimeNotice");

            if (!startTime && !endTime) {
                hiddenInput.value = "";
                preview.innerText = "운영시간을 입력하면 자동으로 저장값이 생성됩니다.";
                preview.classList.add("is-empty");
                notice.innerText = "";
                return;
            }
            if (!startTime || !endTime) {
                hiddenInput.value = "";
                preview.innerText = "시작시간과 종료시간을 모두 입력해야 저장됩니다.";
                preview.classList.add("is-empty");
                notice.innerText = "";
                return;
            }

            var dayText = buildOperationDayText();
            var operationText = dayText + " " + startTime + "~" + endTime;
            hiddenInput.value = operationText;
            preview.innerText = operationText;
            preview.classList.remove("is-empty");

            if (startTime > endTime) {
                notice.innerText = "종료시간이 시작시간보다 빠르므로 다음날 종료되는 야간 운영으로 저장됩니다.";
                return;
            }
            if (startTime === endTime) {
                notice.innerText = "시작시간과 종료시간이 같아 24시간 운영 또는 별도 운영 기준으로 저장됩니다.";
                return;
            }
            notice.innerText = "";
        }

        function validateOperationHourInput() {
            var startTime = getEl("oprStartTime").value;
            var endTime = getEl("oprEndTime").value;
            if (!startTime && !endTime) return true;
            if (!startTime || !endTime) {
                alertMessage("운영시간은 시작시간과 종료시간을 모두 입력하세요.");
                return false;
            }
            return true;
        }

        function setSelectValueByValueOrText(select, value) {
            if (!select || !value) return;
            select.value = value;
            if (select.value === value) return;
            Array.from(select.options).some(function (option) {
                if (option.value === value || option.textContent.indexOf(value) > -1) {
                    option.selected = true;
                    return true;
                }
                return false;
            });
        }

        function applyExistingOperationHour() {
            var raw = (getEl("regOprHr").value || "").trim();
            var preview = getEl("oprHrPreview");
            if (!raw) { updateOperationHourText(); return; }

            var match = raw.match(/^(.*?)\s+(\d{2}:\d{2})\s*~\s*(\d{2}:\d{2})$/);
            if (!match) {
                preview.innerText = raw;
                preview.classList.remove("is-empty");
                return;
            }

            var dayText = match[1].trim();
            getEl("oprStartTime").value = match[2];
            getEl("oprEndTime").value = match[3];

            if (dayText === "매일")      getEl("oprDayType").value = "DAILY";
            else if (dayText === "평일") getEl("oprDayType").value = "WEEKDAY";
            else if (dayText === "주말") getEl("oprDayType").value = "WEEKEND";
            else {
                getEl("oprDayType").value = "CUSTOM";
                var dayParts = dayText.split("~");
                setSelectValueByValueOrText(getEl("oprStartDay"), dayParts[0]);
                setSelectValueByValueOrText(getEl("oprEndDay"), dayParts[1] || dayParts[0]);
            }
            updateOperationHourText();
        }

        function getFileImageUrl(file) {
            if (file.viewUrl) return file.viewUrl;
            if (file.fileUrl) return file.fileUrl;
            if (file.googleId) return contextPath + "/file/display/" + encodeURIComponent(file.googleId);
            return "";
        }

        async function loadExistingFiles(facilityNo) {
            var area = getEl("regFileManageList");
            area.style.display = "";
            area.innerHTML = '<div class="file-preview-empty">기존 사진을 불러오는 중입니다.</div>';
            getEl("deleteFileUuids").value = "";
            try {
                var result = await requestJson(contextPath + "/manager/facility/detail/" + encodeURIComponent(mgmtOfcNo) + "/" + encodeURIComponent(facilityNo));
                var fileList = result.fileList || result.attachFileList || (result.facility && result.facility.fileList) || [];
                renderExistingFiles(fileList);
            } catch (err) {
                area.innerHTML = '<div class="file-preview-empty">기존 사진을 불러오지 못했습니다.</div>';
            }
        }

        function renderExistingFiles(files) {
            var area = getEl("regFileManageList");
            if (!files || files.length === 0) {
                area.innerHTML = '<div class="file-preview-empty">기존 등록 사진이 없습니다.</div>';
                return;
            }
            area.innerHTML = files.map(function (file) {
                var imgUrl = getFileImageUrl(file);
                var name = file.fileOgName || file.fileSaveUuid || "시설사진";
                var uuid = file.fileSaveUuid || "";
                var thumbHtml = imgUrl
                    ? '<img class="file-thumb js-image-preview" src="' + imgUrl + '" alt="' + name + '">'
                    : '<div class="file-thumb"></div>';
                return '<div class="file-manage-row">'
                    + thumbHtml
                    + '<div class="file-info"><div class="file-name">' + name + '</div><div class="file-meta">' + (file.fileExt || "image") + '</div></div>'
                    + '<label class="file-delete-check"><input type="checkbox" class="js-delete-file-check" value="' + uuid + '">삭제</label>'
                    + '</div>';
            }).join("");
        }

        function updateDeleteFileUuids() {
            var checked = Array.from(document.querySelectorAll(".js-delete-file-check:checked"))
                .map(function (box) { return box.value; }).filter(Boolean);
            getEl("deleteFileUuids").value = checked.join(",");
        }

        function previewSelectedFiles() {
            var fileInput = getEl("regImgInput");
            var previewArea = getEl("regImgGrid");
            previewArea.innerHTML = "";
            if (!fileInput.files || fileInput.files.length === 0) {
                previewArea.innerHTML = '<div class="file-preview-empty">선택된 사진이 없습니다.</div>';
                return;
            }
            Array.from(fileInput.files).forEach(function (file) {
                var item = document.createElement("div");
                item.className = "file-preview-item";
                if (file.type && file.type.indexOf("image/") === 0) {
                    var img = document.createElement("img");
                    img.alt = file.name;
                    img.src = URL.createObjectURL(file);

                    /*
                     * 공통 이미지 확대 모듈 연결
                     * - 이미지 클릭은 공통 bind 방식으로만 연결함
                     * - DOM 생성 후 CommonImageViewer.bind("#regImgGrid")로 클릭 이벤트를 연결함
                     */
                    img.className = "js-image-preview";

                    item.appendChild(img);
                }
                var name = document.createElement("div");
                name.className = "file-preview-name";
                name.textContent = file.name;
                item.appendChild(name);
                previewArea.appendChild(item);
            });

            /*
             * 새로 생성된 선택 사진 미리보기에 확대 보기 이벤트 재연결
             */
            if (window.CommonImageViewer && typeof window.CommonImageViewer.bind === "function") {
                window.CommonImageViewer.bind("#regImgGrid");
            }
        }

        async function saveRegister(event) {
            event.preventDefault();
            var selectedFacilityNo = getEl("selectedFacilityNo").value;
            if (!selectedFacilityNo) { alertMessage("시설자산이 선택되지 않았습니다."); return; }
            updateOperationHourText();
            if (!validateOperationHourInput()) return;
            syncReserveAmountState();
            updateDeleteFileUuids();
            try {
                await postForm(contextPath + "/manager/publicFacility/update/" + encodeURIComponent(mgmtOfcNo), new FormData(getEl("registerForm")));
                await showAlertThen("편의시설 운영정보가 저장되었습니다.", listUrl(), "success");
            } catch (err) {
                console.error(err);
                await alertMessage(err.message || "편의시설 운영정보 저장 중 오류가 발생했습니다.", "error");
            }
        }

        document.addEventListener("DOMContentLoaded", function () {
            ["oprDayType", "oprStartDay", "oprEndDay", "oprStartTime", "oprEndTime"].forEach(function (id) {
                getEl(id).addEventListener("change", updateOperationHourText);
                getEl(id).addEventListener("input", updateOperationHourText);
            });
            getEl("regImgInput").addEventListener("change", previewSelectedFiles);
            getEl("regRsvYn").addEventListener("change", syncReserveAmountState);
            document.addEventListener("change", function (e) {
                if (e.target.classList.contains("js-delete-file-check")) updateDeleteFileUuids();
            });
            getEl("registerForm").addEventListener("submit", saveRegister);
            getEl("backToListBtn").addEventListener("click", function () { history.back(); });
            syncReserveAmountState();
            applyExistingOperationHour();
            if (window.CommonImageViewer && typeof window.CommonImageViewer.bind === "function") CommonImageViewer.bind("#regFileManageList");
            if (getEl("selectedFacilityNo").value) loadExistingFiles(getEl("selectedFacilityNo").value);
        });
    })();
</script>

<c:if test="${not empty detail.cmnFacilityNo}">
    <script>
        (function () {
            var config        = window.publicFacilityPageConfig || {};
            var contextPath   = config.contextPath || "";
            var mgmtOfcNo     = config.mgmtOfcNo  || "";
            var cmnFacilityNo = "${detail.cmnFacilityNo}";

            /*
             * 자원 상태 표시 HTML 생성
             * - 상태 코드별 점 색상 + 한글 상태명 표시
             */
            function sttsBadge(cd) {
                var map    = { OPEN:"open", USE:"use", REPAIR:"repair", CLOSE:"close" };
                var labels = { OPEN:"사용가능", USE:"사용중", REPAIR:"점검중", CLOSE:"사용중지" };
                var cls    = map[cd] ? "item-stts item-stts-" + map[cd] : "item-stts";
                var label  = labels[cd] || cd || "-";

                return '<span class="' + cls + '">'
                    + '<span class="item-stts-dot"></span>'
                    + '<span class="item-stts-txt">' + label + '</span>'
                    + '</span>';
            }

            /*
             * 자원 목록 렌더링
             * - 한 줄에 왼쪽 자원 1개, 오른쪽 자원 1개 표시
             * - 각 td에 data-item-no를 직접 넣어서 클릭 위치 기준으로 수정 대상 판단
             */
            function renderItemList(list) {
                var tbody = document.getElementById("itemListBody");
                if (!tbody) return;

                // 자원 전체 건수 표시
                var totalCount = document.getElementById("itemTotalCount");
                if (totalCount) totalCount.textContent = list ? list.length : 0;

                if (!list || list.length === 0) {
                    tbody.innerHTML =
                        '<tr>'
                        + '<td colspan="10" style="padding:18px;text-align:center;font-size:12px;color:#8a9a8e;">등록된 자원이 없습니다.</td>'
                        + '</tr>';
                    return;
                }

                var rows = [];

                for (var i = 0; i < list.length; i += 2) {
                    var left  = list[i];
                    var right = list[i + 1] || null;

                    var leftNo = left.cmnFacilityItemNo || "";
                    var leftNm = left.itemNm || "-";
                    var leftCd = left.cmnFacilitySttsCd || left.sttsCd || "";

                    var rightNo = right ? (right.cmnFacilityItemNo || "") : "";
                    var rightNm = right ? (right.itemNm || "-") : "";
                    var rightCd = right ? (right.cmnFacilitySttsCd || right.sttsCd || "") : "";

                    var rightHtml = right
                        ? '<td style="font-size:11px;color:#6b7a6e;" data-item-no="' + rightNo + '">' + rightNo + '</td>'
                        + '<td style="font-size:12px;" data-item-no="' + rightNo + '">' + rightNm + '</td>'
                        + '<td style="text-align:center;" data-item-no="' + rightNo + '">' + sttsBadge(rightCd) + '</td>'
                        + '<td class="item-action-cell" data-item-no="' + rightNo + '">'
                        + '<span class="material-symbols-rounded item-edit-icon">edit</span>'
                        + '</td>'
                        : '<td></td><td></td><td></td><td class="item-action-cell"></td>';

                    rows.push(
                        '<tr>'
                        + '<td style="font-size:11px;color:#6b7a6e;" data-item-no="' + leftNo + '">' + leftNo + '</td>'
                        + '<td style="font-size:12px;" data-item-no="' + leftNo + '">' + leftNm + '</td>'
                        + '<td style="text-align:center;" data-item-no="' + leftNo + '">' + sttsBadge(leftCd) + '</td>'
                        + '<td class="item-action-cell" data-item-no="' + leftNo + '">'
                        + '<span class="material-symbols-rounded item-edit-icon">edit</span>'
                        + '</td>'
                        + '<td class="item-col-div"></td>'
                        + '<td class="item-col-spc"></td>'
                        + rightHtml
                        + '</tr>'
                    );
                }

                tbody.innerHTML = rows.join("");
            }

            /*
             * 자원 목록 조회
             * - 현재 편의시설 번호(cmnFacilityNo)에 연결된 자원만 필터링
             */
            async function loadItemList() {
                try {
                    var res  = await fetch(
                        contextPath
                        + "/manager/publicFacility/grid-list/"
                        + encodeURIComponent(mgmtOfcNo)
                        + "?viewType=PUBLIC_ITEM"
                    );

                    var data = await res.json();

                    var list = (data.list || []).filter(function (item) {
                        return item.cmnFacilityNo === cmnFacilityNo;
                    });

                    renderItemList(list);
                } catch (e) {
                    var tbody = document.getElementById("itemListBody");

                    if (tbody) {
                        tbody.innerHTML =
                            '<tr>'
                            + '<td colspan="10" style="padding:18px;text-align:center;font-size:12px;color:#8a9a8e;">자원 목록을 불러오지 못했습니다.</td>'
                            + '</tr>';
                    }
                }
            }

            /*
             * 자원 등록/수정 모달 초기화
             * - publicFacilityItemModal.js의 공용 모달 사용
             */
            function initModal() {
                if (!window.PublicFacilityItemModal || !cmnFacilityNo) return false;

                PublicFacilityItemModal.init({
                    contextPath: contextPath,
                    mgmtOfcNo: mgmtOfcNo,
                    cmnFacilityNo: cmnFacilityNo,
                    isAdmin: false
                });

                return true;
            }

            document.addEventListener("DOMContentLoaded", function () {
                loadItemList();

                /*
                 * 자원 등록 버튼
                 * - 현재 편의시설에 자원 추가
                 */
                var insertBtn = document.getElementById("itemInsertBtn");
                if (insertBtn) {
                    insertBtn.addEventListener("click", function () {
                        if (!initModal()) return;

                        PublicFacilityItemModal.open("insert");

                        var infoNm  = document.getElementById("pfInfoCmnFacilityNm");
                        var infoNo  = document.getElementById("pfInfoFacilityNo");
                        var infoCmn = document.getElementById("pfInfoCmnFacilityNo");

                        if (infoNm)  infoNm.textContent  = "${detail.cmnFacilityNm}";
                        if (infoNo)  infoNo.textContent  = "${detail.facilityNo}";
                        if (infoCmn) infoCmn.textContent = cmnFacilityNo;

                        var searchSec = document.getElementById("pfFacilitySearchSection");
                        if (searchSec) searchSec.style.display = "none";

                        var infoSec = document.getElementById("pfFacilityInfoSection");
                        if (infoSec) infoSec.style.display = "";
                    });
                }

                /*
                 * 자원 행 클릭
                 * - tr 기준이 아니라 실제 클릭한 td[data-item-no] 기준으로 자원번호 추출
                 * - 왼쪽 자원을 누르면 왼쪽 자원번호, 오른쪽 자원을 누르면 오른쪽 자원번호 사용
                 */
                var tbody = document.getElementById("itemListBody");
                if (tbody) {
                    tbody.addEventListener("click", function (e) {
                        var td = e.target.closest("td[data-item-no]");
                        if (!td) return;

                        var itemNo = td.getAttribute("data-item-no");
                        if (!itemNo || !initModal()) return;

                        PublicFacilityItemModal.open("update", itemNo);
                    });
                }

                /*
                 * 자원 저장 후 목록 재조회
                 * - 등록/수정 모달 저장 완료 이벤트 수신
                 */
                document.addEventListener("pfItemSaved", loadItemList);
            });
        })();
    </script>

    <%@ include file="/WEB-INF/views/include/publicFacilityItemModal.jspf" %>
    <script src="${pageContext.request.contextPath}/js/manager/facility/publicFacility/publicFacilityItemModal.js"></script>
</c:if>
</body>
</html>
