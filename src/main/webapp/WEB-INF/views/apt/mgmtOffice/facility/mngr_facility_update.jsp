<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>시설 수정</title>
    <sec:csrfMetaTags/>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/office-layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/manager-common.css">
    <style>
        #facilityPage { --accent:#2e5c38; --accent-light:#e8f0ea; --accent-dim:rgba(38,92,48,.08); --surface:#fff; --line:#d7dce2; --th-bg:#f0f2ef; --text-head:#1a2e1e; }
        #facilityPage .page-title-block h2 { color:var(--text-head); font-size:19px; letter-spacing:-.5px; }
        #facilityPage .page-title-block p { color:#6b7a6e; font-size:12px; }
        #facilityPage .panel { border-radius:6px; border:1px solid var(--line); box-shadow:none; margin:0; }
        #facilityPage .panel-header { display:flex; align-items:center; justify-content:space-between; padding:13px 16px; border-bottom:1px solid var(--line); background:var(--surface); border-radius:6px 6px 0 0; }
        #facilityPage .panel-title { display:flex; align-items:center; gap:6px; margin:0; font-size:13px; font-weight:800; color:var(--text-head); }
        #facilityPage .panel-title .material-symbols-rounded { font-size:17px; color:var(--accent); }
        #facilityPage .panel-body { padding:14px 16px 16px; background:var(--surface); }
        #facilityPage .panel-body .form-input, #facilityPage .panel-body .form-select { height:32px; font-size:12px; border-color:var(--line); background:var(--surface); border-radius:4px; }
        #facilityPage .panel-body .form-input:focus, #facilityPage .panel-body .form-select:focus { border-color:var(--accent); box-shadow:0 0 0 2px var(--accent-dim); }
        #facilityPage .panel-body .form-input:disabled, #facilityPage .panel-body .form-select:disabled { background:#f5f6f5; color:#aab4ac; cursor:not-allowed; }
        #facilityPage .btn { border-radius:4px; }
        #facilityPage .btn-primary { background:var(--accent); }
        #facilityPage .btn-primary:hover { background:#1a3d1f; }
        #facilityPage .notice-box { display:flex; gap:10px; padding:11px 13px; background:#f7faf7; border:1px solid var(--line); border-left:3px solid var(--accent); border-radius:0 4px 4px 0; font-size:12px; color:#4a5c4e; line-height:1.6; }
        #facilityPage .notice-box .material-symbols-rounded { color:var(--accent); font-size:17px; flex-shrink:0; margin-top:2px; }
        #facilityPage .notice-box strong { color:#1a2e1e; }
        #facilityPage .field-help { margin-top:5px; font-size:11px; color:#9caa9e; line-height:1.5; }
        #facilityPage .field-help.lock { color:#7c2d12; }
        .form-section-title { letter-spacing:0; text-transform:none; font-size:11px; font-weight:600; color:#4a5c4e; display:flex; align-items:center; gap:4px; margin-bottom:10px; }
        .form-section-title .material-symbols-rounded { font-size:15px; color:var(--accent,#2e5c38); }
        .facility-modal-cols { display:grid; grid-template-columns:1fr 1fr; gap:0; }
        .facility-modal-col-left { padding-right:20px; border-right:1px solid var(--line,#d7dce2); }
        .facility-modal-col-right { padding-left:20px; }
        .facility-col-label { font-size:11px; font-weight:600; color:#8a9a8e; letter-spacing:.5px; text-transform:uppercase; padding-bottom:8px; border-bottom:1px solid var(--line,#d7dce2); margin-bottom:14px; }
        #facilityPage .facility-type-control { display:grid; grid-template-columns:minmax(0,1fr) auto; align-items:center; gap:8px; }
        #facilityPage .facility-use-control { display:flex; align-items:center; gap:10px; min-width:0; min-height:32px; }
        #facilityPage .facility-use-status { font-size:12px; font-weight:600; color:#1f5a35; white-space:nowrap; }
        #facilityPage .facility-use-status.is-off { color:#7f1d1d; }
        #facilityPage .use-toggle { position:relative; display:inline-flex; width:46px; height:24px; flex-shrink:0; }
        #facilityPage .use-toggle input { position:absolute; opacity:0; pointer-events:none; }
        #facilityPage .use-toggle-slider { position:absolute; inset:0; border-radius:999px; background:#d1d5db; border:1px solid #c5cad3; cursor:pointer; transition:background .16s ease,border-color .16s ease; }
        #facilityPage .use-toggle-slider::after { content:""; position:absolute; width:18px; height:18px; left:2px; top:2px; border-radius:50%; background:#fff; box-shadow:0 1px 3px rgba(15,23,42,.2); transition:transform .16s ease; }
        #facilityPage .use-toggle input:checked + .use-toggle-slider { background:#2e5c38; border-color:#2e5c38; }
        #facilityPage .use-toggle input:checked + .use-toggle-slider::after { transform:translateX(22px); }
        #facilityPage .file-upload-box { border:1px dashed var(--line); border-radius:4px; padding:12px; background:#fafcfb; }
        #facilityPage .file-upload-title { display:flex; align-items:center; gap:5px; font-size:12px; font-weight:600; color:#4a5c4e; }
        #facilityPage .file-upload-title .material-symbols-rounded { font-size:16px; color:var(--accent); }
        #facilityPage .file-upload-desc { font-size:11px; color:#7a8a7d; line-height:1.5; }
        #facilityPage .file-preview-list { display:grid; grid-template-columns:repeat(4,minmax(0,1fr)); gap:8px; margin-top:10px; }
        #facilityPage .file-preview-item { position:relative; min-height:92px; border:1px solid var(--line); border-radius:4px; background:#fff; overflow:hidden; }
        #facilityPage .file-preview-item img { width:100%; height:92px; object-fit:cover; display:block; }
        #facilityPage .file-preview-name { padding:6px 7px; font-size:11px; color:#4a5c4e; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; border-top:1px solid var(--line); }
        #facilityPage .file-preview-remove { position:absolute; top:5px; right:5px; width:22px; height:22px; border:0; border-radius:50%; background:rgba(17,24,39,.78); color:#fff; font-size:14px; line-height:22px; cursor:pointer; }
        #facilityPage .file-preview-empty { padding:13px; border:1px solid var(--line); border-radius:4px; background:#fff; font-size:12px; color:#9caa9e; }
        #facilityPage .file-manage-list { display:flex; flex-direction:column; gap:7px; margin-top:8px; }
        #facilityPage .file-manage-row { display:flex; align-items:center; gap:10px; padding:8px 10px; border:1px solid var(--line); border-radius:4px; background:#fff; }
        #facilityPage .file-thumb { width:48px; height:48px; border-radius:4px; border:1px solid var(--line); object-fit:cover; background:#f4f7f4; flex-shrink:0; }
        #facilityPage .file-info { min-width:0; flex:1; }
        #facilityPage .file-name { font-size:12px; font-weight:600; color:#111827; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
        #facilityPage .file-meta { margin-top:2px; font-size:11px; color:#9caa9e; }
        #facilityPage .file-delete-check { display:inline-flex; align-items:center; gap:4px; font-size:11px; color:#7f1d1d; font-weight:600; }
        #facilityPage .file-delete-check input { width:14px; height:14px; }

        /* 위치 선택 행 */
        #facilityPage .location-select-row { display:grid; grid-template-columns:1.1fr .75fr .75fr .75fr; gap:8px; align-items:end; }
        #facilityPage .location-select-row .field-help { display:none; }
        #facilityPage .location-help-row { margin-top:5px; font-size:11px; color:#9caa9e; line-height:1.5; }
        #facilityPage .location-detail-row { margin-top:10px; }
        @media (max-width:900px) { #facilityPage .location-select-row { grid-template-columns:1fr 1fr; } }

        /* 편의시설 운영정보 참고 박스 — 상세화면 asset-ref-box와 동일한 구조 */
        #facilityPage .cmn-ref-box { display:flex; align-items:center; justify-content:space-between; gap:12px; min-height:42px; padding:10px 12px; border:1px solid var(--line); border-radius:4px; background:#f6f7f8; }
        #facilityPage .cmn-ref-main { min-width:0; display:flex; align-items:center; gap:7px; color:#4a5c4e; font-size:12px; font-weight:400; line-height:1.45; white-space:nowrap; overflow:hidden; }
        #facilityPage .cmn-ref-main .material-symbols-rounded { font-size:16px; color:#9aa5a0; flex-shrink:0; }
        #facilityPage .cmn-ref-text { display:block; min-width:0; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }
        #facilityPage .cmn-ref-actions { display:flex; align-items:center; gap:6px; flex-shrink:0; }
        #facilityPage .cmn-ref-link { display:inline-flex; align-items:center; gap:3px; color:var(--accent); font-size:11px; font-weight:500; text-decoration:none; white-space:nowrap; }
        #facilityPage .cmn-ref-link:hover { color:#1a3d1f; }
        #facilityPage .cmn-ref-link .material-symbols-rounded { font-size:13px; }
        #facilityPage .cmn-ref-empty { display:flex; align-items:center; justify-content:space-between; gap:12px; min-height:42px; padding:10px 12px; border:1px solid var(--line); border-radius:4px; background:#f6f7f8; font-size:12px; color:#9caa9e; }

        #facilityPage .js-image-preview { cursor:zoom-in; }
        .image-preview-modal { display:none; position:fixed; inset:0; z-index:2147483647; align-items:center; justify-content:center; padding:24px; background:rgba(0,0,0,.76); }
        .image-preview-modal.is-open { display:flex !important; }
        .image-preview-modal img { max-width:92vw; max-height:88vh; object-fit:contain; border-radius:6px; background:#fff; }
        .image-preview-close { position:absolute; top:22px; right:28px; border:0; background:transparent; color:#fff; font-size:38px; line-height:1; cursor:pointer; }
        @media (max-width:760px) {
            .facility-modal-cols { grid-template-columns:1fr; }
            .facility-modal-col-left { padding-right:0; border-right:none; border-bottom:1px solid var(--line,#d7dce2); padding-bottom:16px; margin-bottom:16px; }
            .facility-modal-col-right { padding-left:0; }
            #facilityPage .facility-type-control { grid-template-columns:1fr; }
        }
    </style>
    <script>
        <sec:authorize access="hasRole('ADMIN')" var="facilityAdmin" />
        window.facilityPageConfig = {
            contextPath: "${pageContext.request.contextPath}",
            mgmtOfcNo: "${mgmtOfcNo}",
            facilityNo: "${facilityNo}",
            isAdmin: ${facilityAdmin}
        };
    </script>
</head>
<body>
<c:set var="activeSidebarHref" value="${pageContext.request.contextPath}/manager/facility/page/${mgmtOfcNo}" />
<c:set var="activeSidebarParent" value="시설·공사 관리" />
<c:set var="activeSidebarCurrent" value="시설 수정" />
<div id="imagePreviewModal" class="image-preview-modal">
    <button type="button" id="imagePreviewCloseBtn" class="image-preview-close" aria-label="이미지 확대 닫기">×</button>
    <img id="imagePreviewLargeImg" src="" alt="확대 이미지">
</div>

<script src="${pageContext.request.contextPath}/js/manager/manager-common.js"></script>

<div class="app-wrapper">
    <%@ include file="/WEB-INF/views/include/office_sidebar.jsp" %>
    <div class="main-wrap">
        <%@ include file="/WEB-INF/views/include/office_header.jsp" %>
        <%@ include file="/WEB-INF/views/include/office_active_sidebar.jspf" %>
        <main class="main-content">
            <div class="office-page" id="facilityPage">
                <div class="page-header">
                    <div class="page-title-block">
                        <h2>시설 수정</h2>
                        <p>등록된 시설자산 기본정보를 수정합니다.</p>
                    </div>
                </div>
                <div class="panel">
                    <div class="panel-header">
                        <h3 class="panel-title"><span class="material-symbols-rounded">edit_square</span><span id="facilityPanelTitleText">시설 정보 수정</span></h3>
                    </div>
                    <form id="facilityForm" enctype="multipart/form-data">
                        <input type="hidden" id="facilityNo" name="facilityNo">
                        <input type="hidden" id="fileGroupNo" name="fileGroupNo">
                        <input type="hidden" id="useYn" name="useYn" value="Y">
                        <input type="hidden" id="deleteFileUuids" name="deleteFileUuids">
                        <div class="panel-body">
                            <div class="form-section" style="margin-bottom:14px;">
                                <div class="notice-box">
                                    <span class="material-symbols-rounded">lock</span>
                                    <div><strong>오등록 보정 목적의 수정입니다.</strong><br>
                                        시설명·설치일자·동·상세위치는 오등록 보정 목적으로만 수정합니다.<br>
                                        시설유형 변경이 필요한 경우 시설유형 정정 버튼으로 가능 여부를 확인하세요.</div>
                                </div>
                            </div>
                            <div class="facility-modal-cols">
                                <div class="facility-modal-col-left">
                                    <div class="form-section" style="margin-bottom:14px;">
                                        <div class="form-section-title">
                                            <span class="material-symbols-rounded">apartment</span>시설 정보
                                        </div>
                                        <div class="form-row cols-2">
                                            <div class="form-field">
                                                <label class="field-label">시설명 <span class="req">*</span></label>
                                                <input type="text" class="form-input" id="facilityNm" name="facilityNm" required>
                                            </div>
                                            <div class="form-field">
                                                <label class="field-label">시설유형 <span class="req">*</span></label>
                                                <div class="facility-type-control">
                                                    <select class="form-select" id="facilityTyCd" name="facilityTyCd" disabled>
                                                        <option value="">선택</option>
                                                        <optgroup label="일반시설">
                                                            <option value="ELV">승강기</option>
                                                            <option value="WTR">급수시설</option>
                                                            <option value="ELC">전기시설</option>
                                                            <option value="GAS">가스시설</option>
                                                            <option value="FIRE">소방시설</option>
                                                            <option value="SEC">보안시설</option>
                                                            <option value="ETC">기타시설</option>
                                                        </optgroup>
                                                        <optgroup label="편의시설">
                                                            <option value="MEET">회의실</option>
                                                            <option value="PARK">입주민주차장</option>
                                                            <option value="PLAY">놀이시설</option>
                                                            <option value="COMM">커뮤니티시설</option>
                                                            <option value="GYM">피트니스센터</option>
                                                            <option value="STUDY">독서실</option>
                                                            <option value="PARKING">방문차량주차구역</option>
                                                        </optgroup>
                                                    </select>
                                                    <button type="button" class="btn btn-secondary btn-sm" id="facilityCorrectionBtn">
                                                        <span class="material-symbols-rounded">edit_note</span>정정
                                                    </button>
                                                </div>
                                                <div class="field-help lock" id="correctionLockText">시설유형 정정이 필요하면 정정 버튼을 눌러 변경 가능 여부를 확인하세요.</div>
                                                <div class="field-help" id="correctionGuide" style="display:none;color:#1f5a35;font-weight:700;">정정 가능 · 변경할 시설유형을 선택하고 저장하세요.</div>
                                            </div>
                                        </div>
                                        <div class="form-row cols-2" style="margin-top:2px;">
                                            <div class="form-field">
                                                <label class="field-label">설치일자</label>
                                                <input type="date" class="form-input" id="instlDt" name="instlDt">
                                            </div>
                                            <div class="form-field">
                                                <label class="field-label">활성여부</label>
                                                <div class="facility-use-control">
                                                    <label class="use-toggle" for="useYnToggle">
                                                        <input type="checkbox" id="useYnToggle" checked>
                                                        <span class="use-toggle-slider"></span>
                                                    </label>
                                                    <span class="facility-use-status" id="useYnStatusText">활성</span>
                                                </div>
                                                <div class="field-help">관리 대상에서 제외할 때 비활성으로 변경하세요.</div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-section">
                                        <div class="form-section-title">
                                            <span class="material-symbols-rounded">location_on</span>위치 정보
                                        </div>
                                        <div class="location-select-row">
                                            <div class="form-field">
                                                <label class="field-label">위치구분 <span class="req">*</span></label>
                                                <select class="form-select" id="locationType">
                                                    <option value="COMMON">공용 위치</option>
                                                    <option value="DONG">동 위치</option>
                                                    <option value="HOUSEHOLD">세대 위치</option>
                                                </select>
                                            </div>
                                            <div class="form-field">
                                                <label class="field-label">동</label>
                                                <select class="form-select" id="dongNo" name="dongNo" disabled>
                                                    <option value="">선택</option>
                                                    <c:forEach var="dong" items="${dongList}">
                                                        <option value="${dong.dongNo}">
                                                                ${fn:contains(dong.dongNo, '_') ? fn:substringAfter(dong.dongNo, '_') : (empty dong.dongNm ? dong.dongNo : dong.dongNm)}
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                            <div class="form-field">
                                                <label class="field-label">층</label>
                                                <select class="form-select" id="facilityFloor" disabled>
                                                    <option value="">선택</option>
                                                </select>
                                            </div>
                                            <div class="form-field">
                                                <label class="field-label">호</label>
                                                <select class="form-select" id="facilityHo" disabled>
                                                    <option value="">선택</option>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="location-help-row">구분에 따라 동·층·호가 활성화됩니다.</div>
                                        <div class="form-field location-detail-row">
                                            <label class="field-label">상세위치</label>
                                            <input type="text" class="form-input" id="locCn" name="locCn">
                                        </div>
                                    </div>
                                </div>
                                <div class="facility-modal-col-right">
                                    <div class="form-section" id="facilityFileEditSection">
                                        <div class="form-section-title"><span class="material-symbols-rounded">image</span><span id="facilityPhotoTitleText">시설 사진</span></div>
                                        <div class="file-upload-box">
                                            <div class="file-upload-title"><span class="material-symbols-rounded">upload_file</span>사진 추가</div>
                                            <div class="file-upload-desc" id="facilityPhotoDescText" style="margin-top:3px;margin-bottom:8px;">이미지 파일을 여러 장 선택할 수 있습니다.</div>
                                            <input type="file" class="form-input" id="facilityFiles" name="facilityFiles" accept="image/*" multiple>
                                            <div class="file-preview-list" id="facilityFilePreview" style="margin-top:8px;">
                                                <div class="file-preview-empty">선택된 사진이 없습니다.</div>
                                            </div>
                                        </div>
                                        <div class="file-manage-list" id="facilityFileManageList" style="margin-top:8px;">
                                            <div class="file-preview-empty">기존 등록 사진을 불러오는 중입니다.</div>
                                        </div>
                                    </div>

                                    <%-- 편의시설 운영정보 연결 상태: 편의시설인 경우에만 JS에서 표시 --%>
                                    <div class="form-section" id="publicFacilityStatusSection" style="display:none;margin-top:14px;">
                                        <div class="form-section-title">
                                            <span class="material-symbols-rounded">meeting_room</span>편의시설 운영정보
                                        </div>
                                        <%-- 등록된 경우: cmn-ref-box (JS에서 채움) --%>
                                        <div class="cmn-ref-box" id="cmnRefBox" style="display:none;">
                                            <div class="cmn-ref-main">
                                                <span class="material-symbols-rounded">link</span>
                                                <span class="cmn-ref-text" id="cmnRefText">-</span>
                                            </div>
                                            <div class="cmn-ref-actions">
                                                <a href="#" class="cmn-ref-link" id="cmnDetailLink">
                                                    상세<span class="material-symbols-rounded">arrow_forward</span>
                                                </a>
                                                <a href="#" class="cmn-ref-link" id="cmnEditLink">
                                                    수정<span class="material-symbols-rounded">edit</span>
                                                </a>
                                            </div>
                                        </div>
                                        <%-- 미등록인 경우 --%>
                                        <div class="cmn-ref-empty" id="cmnRefEmpty" style="display:none;">
                                            <span>편의시설 운영정보가 아직 등록되지 않았습니다.</span>
                                            <a href="#" class="cmn-ref-link" id="cmnRegisterLink">
                                                등록<span class="material-symbols-rounded">add</span>
                                            </a>
                                        </div>
                                    </div>

                                    <div class="form-section" style="margin-top:14px;">
                                        <div class="form-section-title"><span class="material-symbols-rounded">link</span>연결 안내</div>
                                        <div class="notice-box">
                                            <span class="material-symbols-rounded">info</span>
                                            <div>시설 기본정보만 수정합니다.<br>
                                                <%-- ***# 시설수정연계바로가기: 계약/점검/검침의 실제 컨트롤러 매핑 기준 링크 묶음 --%>
                                                · 계약 체결 → <a href="${pageContext.request.contextPath}/manager/facility/contract/list/${mgmtOfcNo}" style="color:#2e5c38;font-weight:600;">계약 관리</a><br>
                                                · 점검이력 → <a href="${pageContext.request.contextPath}/manager/checkHistory/${mgmtOfcNo}" style="color:#2e5c38;font-weight:600;">유지보수·점검 이력</a><br>
                                                · 검침 연결 → <a href="${pageContext.request.contextPath}/manager/meter/hstry/${mgmtOfcNo}" style="color:#2e5c38;font-weight:600;">검침 이력</a></div>
                                        </div>
                                    </div>
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
<script>
    (function () {
        var config = window.facilityPageConfig || {};
        var contextPath = config.contextPath || "";
        var mgmtOfcNo = config.mgmtOfcNo || "";
        var facilityNo = config.facilityNo || "";
        var isAdmin = config.isAdmin === true || config.isAdmin === "true";

        var currentFacility = null;
        var isPublicFacility = false;
        var correctionUnlocked = false;
        var selectedFacilityFiles = [];

        function getEl(id) { return document.getElementById(id); }
        function apiUrl(path) { return contextPath + "/manager/facility/" + path; }
        function listUrl() { return contextPath + "/manager/facility/page/" + encodeURIComponent(mgmtOfcNo); }
        function alertMessage(message, icon) {
            if (typeof showAlert === "function") return showAlert(message, icon);
            alert(message);
            return Promise.resolve();
        }

        function getCsrfHeaders() {
            var tokenMeta = document.querySelector('meta[name="_csrf"]');
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
            if (contentType.indexOf("application/json") === -1) throw new Error("JSON 응답이 아닙니다.");
            var data = await response.json();
            if (!response.ok || data.success === false) throw new Error(data.message || "요청 처리 중 오류가 발생했습니다.");
            return data;
        }

        function getJson(url) { return requestJson(url, { method:"GET", headers:getCsrfHeaders() }); }
        function postForm(url, formData) { return requestJson(url, { method:"POST", headers:getCsrfHeaders(), body:formData }); }
        function postJson(url, body) {
            var headers = getCsrfHeaders();
            headers["Content-Type"] = "application/json";
            return requestJson(url, { method:"POST", headers:headers, body:JSON.stringify(body || {}) });
        }

        function formatDate(value) { return value ? String(value).slice(0, 10) : ""; }
        function getResultFacility(result) { return result.detail || result.facility || result || {}; }
        function resetSelect(select, placeholder) { if (select) select.innerHTML = '<option value="">' + placeholder + '</option>'; }
        function removeHouseholdPrefix(text) { return String(text || "").replace(/^\s*\d+\s*층\s*/g, "").replace(/^\s*\d+\s*호\s*/g, "").trim(); }

        function setUseYnValue(value) {
            var useYn = value === "N" ? "N" : "Y";
            var toggle = getEl("useYnToggle");
            var text = getEl("useYnStatusText");
            getEl("useYn").value = useYn;
            toggle.checked = useYn === "Y";
            text.textContent = useYn === "Y" ? "활성" : "비활성";
            text.classList.toggle("is-off", useYn === "N");
        }

        function updateHouseholdLocationText() {
            var locationType = getEl("locationType");
            var floorSelect = getEl("facilityFloor");
            var hoSelect = getEl("facilityHo");
            var locCn = getEl("locCn");
            if (!locationType || locationType.value !== "HOUSEHOLD") return;
            var floorText = floorSelect.value ? floorSelect.value + "층" : "";
            var hoText = hoSelect.value ? hoSelect.value + "호" : "";
            var detailText = removeHouseholdPrefix(locCn.value);
            locCn.value = [floorText, hoText, detailText].filter(Boolean).join(" ");
        }

        function changeLocationTypeView() {
            var type = getEl("locationType").value;
            var dongNo = getEl("dongNo");
            var floorSelect = getEl("facilityFloor");
            var hoSelect = getEl("facilityHo");
            var locCn = getEl("locCn");
            if (type === "COMMON") {
                dongNo.disabled = true; dongNo.value = "";
                floorSelect.disabled = true; resetSelect(floorSelect, "층 선택");
                hoSelect.disabled = true; resetSelect(hoSelect, "호 선택");
                locCn.placeholder = "예) 중앙광장, 지하1층 전기실, 관리동 옥상";
                locCn.value = removeHouseholdPrefix(locCn.value); return;
            }
            if (type === "DONG") {
                dongNo.disabled = false;
                floorSelect.disabled = true; resetSelect(floorSelect, "층 선택");
                hoSelect.disabled = true; resetSelect(hoSelect, "호 선택");
                locCn.placeholder = "예) 1층 로비, 옥상, EPS실";
                locCn.value = removeHouseholdPrefix(locCn.value); return;
            }
            dongNo.disabled = false; floorSelect.disabled = false; hoSelect.disabled = false;
            locCn.placeholder = "예) 세대 분전반, 수도계량기";
            updateHouseholdLocationText();
        }

        async function loadFloorList() {
            var dongNo = getEl("dongNo"); var floorSelect = getEl("facilityFloor"); var hoSelect = getEl("facilityHo");
            resetSelect(floorSelect, "층 선택"); resetSelect(hoSelect, "호 선택"); updateHouseholdLocationText();
            if (!dongNo.value) return;
            var result = await getJson(apiUrl("location/floors/" + encodeURIComponent(mgmtOfcNo) + "?dongNo=" + encodeURIComponent(dongNo.value)));
            var floorList = result.list || result.floorList || result || [];
            floorList.forEach(function (row) {
                var floor = row.floor || row.FLOOR; if (!floor) return;
                var option = document.createElement("option"); option.value = floor; option.textContent = floor + "층"; floorSelect.appendChild(option);
            });
        }

        async function loadHoList() {
            var dongNo = getEl("dongNo"); var floorSelect = getEl("facilityFloor"); var hoSelect = getEl("facilityHo");
            resetSelect(hoSelect, "호 선택"); updateHouseholdLocationText();
            if (!dongNo.value || !floorSelect.value) return;
            var result = await getJson(apiUrl("location/rooms/" + encodeURIComponent(mgmtOfcNo) + "?dongNo=" + encodeURIComponent(dongNo.value) + "&floor=" + encodeURIComponent(floorSelect.value)));
            var hoList = result.list || result.roomList || result || [];
            hoList.forEach(function (row) {
                var ho = row.ho || row.HO; if (!ho) return;
                var option = document.createElement("option"); option.value = ho; option.textContent = ho + "호"; hoSelect.appendChild(option);
            });
        }

        function buildLocationText() {
            var type = getEl("locationType").value;
            var locCn = getEl("locCn");
            var dongNo = getEl("dongNo");
            if (type === "COMMON") { dongNo.value = ""; return locCn.value; }
            if (type === "DONG") { return removeHouseholdPrefix(locCn.value); }
            updateHouseholdLocationText();
            return locCn.value;
        }

        function applyFacilityDisplayText() {
            var panelTitleText = getEl("facilityPanelTitleText");
            var photoTitleText = getEl("facilityPhotoTitleText");
            var photoDescText = getEl("facilityPhotoDescText");
            if (panelTitleText) panelTitleText.textContent = isPublicFacility ? "편의시설 정보 수정" : "시설 정보 수정";
            if (photoTitleText) photoTitleText.textContent = isPublicFacility ? "편의시설 사진" : "시설 사진";
            if (photoDescText) photoDescText.textContent = isPublicFacility
                ? "시설자산과 편의시설 화면에 함께 노출될 사진을 선택할 수 있습니다."
                : "시설자산 사진을 여러 장 선택할 수 있습니다.";
        }

        /* 편의시설 운영정보 연결 상태 표시 — 상세화면 asset-ref-box와 동일한 방식 */
        function applyPublicFacilityStatusText(facility) {
            var section = getEl("publicFacilityStatusSection");
            if (!section) return;

            if (!isPublicFacility) { section.style.display = "none"; return; }
            section.style.display = "";

            var cmnNo = facility.cmnFacilityNo || facility.cmnFacilityNO || "";
            var cmnNm = facility.cmnFacilityNm || "";

            var refBox   = getEl("cmnRefBox");
            var refEmpty = getEl("cmnRefEmpty");

            if (cmnNo) {
                /* 등록된 경우: 번호 · 이름 표시 + 상세/수정 링크 */
                var refText = getEl("cmnRefText");
                var detailLink = getEl("cmnDetailLink");
                var editLink   = getEl("cmnEditLink");

                refText.textContent = cmnNo + (cmnNm ? " · " + cmnNm : "");
                detailLink.href = contextPath + "/manager/publicFacility/detail-page/" + encodeURIComponent(mgmtOfcNo) + "/" + encodeURIComponent(cmnNo);
                editLink.href   = contextPath + "/manager/publicFacility/update-page/" + encodeURIComponent(mgmtOfcNo) + "/" + encodeURIComponent(cmnNo);

                refBox.style.display   = "";
                refEmpty.style.display = "none";
            } else {
                /* 미등록인 경우: 등록 링크 */
                var registerLink = getEl("cmnRegisterLink");
                registerLink.href = contextPath + "/manager/publicFacility/register/" + encodeURIComponent(mgmtOfcNo) + "?facilityNo=" + encodeURIComponent(facilityNo);

                refBox.style.display   = "none";
                refEmpty.style.display = "";
            }
        }

        function fillFacilityForm(facility) {
            currentFacility = facility;
            isPublicFacility = facility.facilityKind === "PUBLIC";
            applyFacilityDisplayText();
            applyPublicFacilityStatusText(facility);
            getEl("facilityNo").value = facility.facilityNo || "";
            getEl("facilityNm").value = facility.facilityNm || "";
            getEl("facilityTyCd").value = facility.facilityTyCd || "";
            getEl("instlDt").value = formatDate(facility.instlDt);
            getEl("dongNo").value = facility.dongNo || "";
            getEl("locCn").value = facility.locCn || "";
            getEl("fileGroupNo").value = facility.fileGroupNo || "";
            getEl("locationType").value = facility.dongNo ? "DONG" : "COMMON";
            setUseYnValue(facility.useYn || "Y");
            changeLocationTypeView();
        }

        function getFileImageUrl(file) {
            if (file.viewUrl) return file.viewUrl;
            if (file.fileUrl) return file.fileUrl;
            if (file.googleId) return contextPath + "/file/display/" + encodeURIComponent(file.googleId);
            return "";
        }

        window.openFacilityImagePreview = function (imgSrc) {
            var modal = document.getElementById("imagePreviewModal");
            var largeImg = document.getElementById("imagePreviewLargeImg");
            if (!modal || !largeImg || !imgSrc) return;
            largeImg.src = imgSrc;
            modal.classList.add("is-open");
        };

        window.closeFacilityImagePreview = function () {
            var modal = document.getElementById("imagePreviewModal");
            var largeImg = document.getElementById("imagePreviewLargeImg");
            if (!modal || !largeImg) return;
            modal.classList.remove("is-open");
            largeImg.src = "";
        };

        function bindImagePreviewModal() {
            var modal = document.getElementById("imagePreviewModal");
            var closeBtn = document.getElementById("imagePreviewCloseBtn");
            if (!modal || !closeBtn) return;
            closeBtn.addEventListener("click", window.closeFacilityImagePreview);
            modal.addEventListener("click", function (e) { if (e.target === modal) window.closeFacilityImagePreview(); });
            document.addEventListener("keydown", function (e) { if (e.key === "Escape") window.closeFacilityImagePreview(); });
        }

        function renderExistingFiles(files) {
            var area = getEl("facilityFileManageList");
            if (!area) return;
            if (!files || files.length === 0) { area.innerHTML = '<div class="file-preview-empty">기존 등록 사진이 없습니다.</div>'; return; }
            area.innerHTML = files.map(function (file) {
                var imgUrl = getFileImageUrl(file);
                var name = file.fileOgName || file.fileSaveUuid || "시설사진";
                var uuid = file.fileSaveUuid || "";
                var imageHtml = imgUrl
                    ? '<img class="file-thumb js-image-preview" src="' + imgUrl + '" alt="' + name + '" onclick="window.openFacilityImagePreview(this.src)">'
                    : '<div class="file-thumb"></div>';
                return '<div class="file-manage-row">' + imageHtml
                    + '<div class="file-info"><div class="file-name">' + name + '</div><div class="file-meta">' + (file.fileExt || "image") + '</div></div>'
                    + '<label class="file-delete-check"><input type="checkbox" class="js-delete-file-check" value="' + uuid + '">삭제</label>'
                    + '</div>';
            }).join("");
        }

        function makeUpdateFormData() {
            var formData = new FormData(getEl("facilityForm"));
            formData.set("facilityNo", facilityNo);
            formData.set("locCn", buildLocationText());
            formData.set("useYn", getEl("useYn").value || "Y");
            if (currentFacility && currentFacility.fileGroupNo) formData.set("fileGroupNo", currentFacility.fileGroupNo);
            else formData.delete("fileGroupNo");
            if (!formData.get("instlDt")) formData.delete("instlDt");
            formData.set("deleteFileUuids", getEl("deleteFileUuids").value || "");
            formData.delete("facilityFiles");
            selectedFacilityFiles.forEach(function (file) { formData.append("facilityFiles", file); });
            return formData;
        }

        async function saveFacility(event) {
            event.preventDefault();
            if (isAdmin) { alertMessage("관리자는 조회만 가능합니다."); return; }
            if (!getEl("facilityNm").value.trim()) { alertMessage("시설명을 입력하세요."); return; }
            try {
                if (correctionUnlocked) {
                    await postJson(apiUrl("type/correct/" + encodeURIComponent(mgmtOfcNo)), { facilityNo: facilityNo, facilityTyCd: getEl("facilityTyCd").value });
                }
                await postForm(apiUrl("update/" + encodeURIComponent(mgmtOfcNo)), makeUpdateFormData());
                await showAlertThen("시설 정보가 수정되었습니다.", listUrl(), "success");
            } catch (err) { console.error(err); await alertMessage(err.message || "시설 수정 중 오류가 발생했습니다.", "error"); }
        }

        async function openCorrection() {
            if (correctionUnlocked) { alertMessage("시설유형 드롭다운에서 변경할 유형을 선택하고 저장하세요."); return; }
            try {
                var result = await getJson(apiUrl("type/correct/check/" + encodeURIComponent(mgmtOfcNo) + "/" + encodeURIComponent(facilityNo)));
                correctionUnlocked = true;
                getEl("facilityTyCd").disabled = false;
                getEl("correctionLockText").style.display = "none";
                getEl("correctionGuide").style.display = "";
                alertMessage(result.message || "정정 가능한 시설입니다. 변경할 시설유형을 선택하고 저장하세요.");
            } catch (err) { console.error(err); alertMessage(err.message || "시설유형 정정 가능 여부 확인 중 오류가 발생했습니다."); }
        }

        async function loadFacilityDetail() {
            var result = await getJson(apiUrl("detail/" + encodeURIComponent(mgmtOfcNo) + "/" + encodeURIComponent(facilityNo)));
            var facility = getResultFacility(result);
            var fileList = result.fileList || result.attachFileList || facility.fileList || [];
            fillFacilityForm(facility);
            renderExistingFiles(fileList);
        }

        function renderSelectedFilePreview() {
            var previewArea = getEl("facilityFilePreview");
            previewArea.innerHTML = "";
            if (selectedFacilityFiles.length === 0) { previewArea.innerHTML = '<div class="file-preview-empty">선택된 사진이 없습니다.</div>'; return; }
            selectedFacilityFiles.forEach(function (file, index) {
                var item = document.createElement("div"); item.className = "file-preview-item";
                if (file.type && file.type.indexOf("image/") === 0) {
                    var img = document.createElement("img"); img.className = "js-image-preview"; img.alt = file.name; img.src = URL.createObjectURL(file);
                    img.addEventListener("click", function () { window.openFacilityImagePreview(this.src); });
                    item.appendChild(img);
                }
                var removeButton = document.createElement("button"); removeButton.type = "button"; removeButton.className = "file-preview-remove"; removeButton.textContent = "x";
                removeButton.addEventListener("click", function () { selectedFacilityFiles.splice(index, 1); renderSelectedFilePreview(); });
                item.appendChild(removeButton);
                var name = document.createElement("div"); name.className = "file-preview-name"; name.textContent = file.name; item.appendChild(name);
                previewArea.appendChild(item);
            });
        }

        function previewSelectedFiles() {
            var fileInput = getEl("facilityFiles");
            if (!fileInput.files || fileInput.files.length === 0) { renderSelectedFilePreview(); return; }
            Array.from(fileInput.files).forEach(function (file) { selectedFacilityFiles.push(file); });
            fileInput.value = "";
            renderSelectedFilePreview();
        }

        function updateDeleteFileUuids() {
            var checked = Array.from(document.querySelectorAll(".js-delete-file-check:checked")).map(function (box) { return box.value; }).filter(Boolean);
            getEl("deleteFileUuids").value = checked.join(",");
        }

        function bindEvents() {
            getEl("facilityForm").addEventListener("submit", saveFacility);
            getEl("backToListBtn").addEventListener("click", function () { location.href = listUrl(); });
            getEl("facilityCorrectionBtn").addEventListener("click", openCorrection);
            getEl("useYnToggle").addEventListener("change", function () { setUseYnValue(this.checked ? "Y" : "N"); });
            getEl("facilityFiles").addEventListener("change", previewSelectedFiles);
            getEl("locationType").addEventListener("change", function () {
                changeLocationTypeView();
                if (this.value === "HOUSEHOLD" || this.value === "DONG") loadFloorList();
            });
            getEl("dongNo").addEventListener("change", function () { if (getEl("locationType").value === "HOUSEHOLD") loadFloorList(); });
            getEl("facilityFloor").addEventListener("change", loadHoList);
            getEl("facilityHo").addEventListener("change", updateHouseholdLocationText);
            document.addEventListener("change", function (event) { if (event.target.classList.contains("js-delete-file-check")) updateDeleteFileUuids(); });
        }

        document.addEventListener("DOMContentLoaded", function () {
            bindImagePreviewModal();
            bindEvents();
            loadFacilityDetail().catch(function (err) {
                console.error(err);
                alertMessage(err.message || "시설 수정 정보를 불러오지 못했습니다.");
            });
        });
    })();
</script>
</body>
</html>
