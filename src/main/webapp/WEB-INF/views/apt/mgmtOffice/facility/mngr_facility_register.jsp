<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>시설 등록</title>

    <sec:csrfMetaTags/>

    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet" />

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/office-layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/manager-common.css">

    <style>
        /* 시설 등록 화면 전용 색상 */
        #facilityPage { --accent:#2e5c38; --accent-dim:rgba(38,92,48,.08); --surface:#fff; --line:#d7dce2; --text-head:#1a2e1e; }

        /* 상단 제목 */
        #facilityPage .page-title-block h2 { color:var(--text-head); font-size:19px; letter-spacing:-.5px; }
        #facilityPage .page-title-block p { color:#6b7a6e; font-size:12px; }

        /* 패널 */
        #facilityPage .panel { margin:0; border:1px solid var(--line); border-radius:6px; box-shadow:none; }
        #facilityPage .panel-header { display:flex; align-items:center; justify-content:space-between; padding:13px 16px; border-bottom:1px solid var(--line); background:var(--surface); border-radius:6px 6px 0 0; }
        #facilityPage .panel-title { display:flex; align-items:center; gap:6px; margin:0; font-size:13px; font-weight:800; color:var(--text-head); }
        #facilityPage .panel-title .material-symbols-rounded { font-size:17px; color:var(--accent); }
        #facilityPage .panel-body { padding:14px 16px 16px; background:var(--surface); }

        /* 폼 요소 */
        #facilityPage .panel-body .form-input,
        #facilityPage .panel-body .form-select { height:32px; font-size:12px; border-color:var(--line); background:var(--surface); border-radius:4px; }
        #facilityPage .panel-body .form-input:focus,
        #facilityPage .panel-body .form-select:focus { border-color:var(--accent); box-shadow:0 0 0 2px var(--accent-dim); }
        #facilityPage .panel-body .form-input:disabled,
        #facilityPage .panel-body .form-select:disabled { background:#f5f6f5; color:#aab4ac; cursor:not-allowed; }

        /* 버튼 */
        #facilityPage .btn { border-radius:4px; }
        #facilityPage .btn-primary { background:var(--accent); }
        #facilityPage .btn-primary:hover { background:#1a3d1f; }
        #facilityPage .btn-mini { height:32px; padding:0 10px; border:1px solid var(--line); background:#fff; color:#4a5c4e; font-size:12px; font-weight:700; white-space:nowrap; }
        #facilityPage .btn-mini:hover { border-color:var(--accent); color:var(--accent); }

        /* 안내/경고 박스 */
        #facilityPage .notice-box { display:flex; gap:10px; padding:11px 13px; background:#f7faf7; border:1px solid var(--line); border-left:3px solid var(--accent); border-radius:0 4px 4px 0; font-size:12px; color:#4a5c4e; line-height:1.6; }
        #facilityPage .notice-box .material-symbols-rounded { color:var(--accent); font-size:17px; flex-shrink:0; margin-top:2px; }
        #facilityPage .warn-inline { display:flex; align-items:flex-start; gap:7px; padding:8px 11px; margin-top:6px; margin-bottom:2px; background:#fffbf0; border:1px solid #e8c84a; border-left:3px solid #c9900a; border-radius:0 4px 4px 0; font-size:11px; color:#7a5c00; line-height:1.6; }
        #facilityPage .warn-inline .material-symbols-rounded { font-size:15px; color:#c9900a; flex-shrink:0; margin-top:1px; }
        #facilityPage .warn-inline strong { color:#5a3d00; }
        #facilityPage .page-slim-notice { display:flex; align-items:center; gap:8px; margin:-2px 0 12px; padding:9px 12px; border:1px solid #dbe4dc; border-left:3px solid var(--accent); border-radius:0 4px 4px 0; background:#f8fbf8; color:#526258; font-size:12px; line-height:1.5; }
        #facilityPage .page-slim-notice .material-symbols-rounded { font-size:17px; color:var(--accent); flex-shrink:0; }
        #facilityPage .soft-guide-box { margin-top:38px; padding:10px 12px; border:1px solid #e0e5e1; border-radius:4px; background:#fbfcfb; color:#657368; font-size:11px; line-height:1.7; }
        #facilityPage .soft-guide-title { display:flex; align-items:center; gap:5px; margin-bottom:4px; font-size:12px; font-weight:800; color:#3f6047; }
        #facilityPage .soft-guide-title .material-symbols-rounded { font-size:15px; color:var(--accent); }
        #facilityPage .soft-guide-list { margin:0; padding-left:14px; }
        #facilityPage .soft-guide-list li { margin:1px 0; }
        #facilityPage .soft-guide-box strong { color:#3f6047; font-weight:800; }

        /* 좌우 컬럼 */
        #facilityPage .facility-modal-cols { display:grid; grid-template-columns:1fr 1fr; gap:0; }
        #facilityPage .facility-modal-col-left { padding-right:20px; border-right:1px solid var(--line); }
        #facilityPage .facility-modal-col-right { padding-left:20px; }
        #facilityPage .facility-col-label { margin-bottom:14px; padding-bottom:8px; border-bottom:1px solid var(--line); font-size:11px; font-weight:800; color:#8a9a8e; letter-spacing:.5px; text-transform:uppercase; }
        #facilityPage .form-section { margin-bottom:16px; padding:14px 14px 16px; border:1px solid #e0e5e1; border-radius:6px; background:#fcfdfc; }
        #facilityPage .form-section:last-child { margin-bottom:0; }
        #facilityPage .form-section-title { display:flex; align-items:center; gap:5px; margin:-14px -14px 14px; padding:10px 13px; border-bottom:1px solid #e0e5e1; background:#f7faf7; border-radius:6px 6px 0 0; font-size:11px; font-weight:800; color:#3f6047; }
        #facilityPage .form-section-title .material-symbols-rounded { font-size:15px; color:var(--accent); }

        /* 시설유형 검색/추가 */
        #facilityPage .type-search-wrap { position:relative; }
        #facilityPage .type-suggest-list { display:none; position:absolute; z-index:30; left:0; right:0; top:36px; max-height:230px; overflow-y:auto; border:1px solid var(--line); border-radius:4px; background:#fff; box-shadow:0 10px 18px rgba(15,23,42,.08); }
        #facilityPage .type-suggest-list.is-active { display:block; }
        #facilityPage .type-suggest-group { border-bottom:1px solid #eef1ef; }
        #facilityPage .type-suggest-group:last-child { border-bottom:0; }
        #facilityPage .type-suggest-group-title { padding:7px 10px 6px; background:#f7faf7; border-bottom:1px solid #eef1ef; font-size:10px; font-weight:800; color:#6d7c70; letter-spacing:.3px; }
        #facilityPage .type-suggest-item { display:flex; align-items:center; justify-content:space-between; gap:8px; width:100%; padding:8px 10px 8px 14px; border:0; border-bottom:1px solid #f0f3f1; background:#fff; text-align:left; font-size:12px; color:#3f4d43; cursor:pointer; }
        #facilityPage .type-suggest-item:last-child { border-bottom:0; }
        #facilityPage .type-suggest-item:hover { background:#f7faf7; }
        #facilityPage .type-suggest-item.is-new { color:#2e5c38; font-weight:800; background:#fbfdfb; }
        #facilityPage .type-suggest-label { min-width:0; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }
        #facilityPage .type-suggest-meta { flex-shrink:0; font-size:10px; color:#8a9a8e; }
        #facilityPage .facility-basic-row { display:grid; grid-template-columns:1.1fr 1.1fr .78fr; gap:14px; align-items:start; }
        #facilityPage .type-status { margin-top:5px; font-size:11px; color:#7a8a7d; line-height:1.5; }
        #facilityPage .type-status strong { color:#2e5c38; font-weight:800; }
        #facilityPage .type-status.is-new { color:#7a5c00; }
        #facilityPage .type-status.is-new strong { color:#5a3d00; }
        #facilityPage .basic-help-text { margin-top:8px; padding-top:8px; border-top:1px dashed #e0e5e1; font-size:11px; color:#7a8a7d; line-height:1.6; }
        #facilityPage .basic-help-text strong { color:#2e5c38; font-weight:800; }
        #facilityPage .type-choice-note { display:flex; align-items:flex-start; gap:7px; margin-bottom:10px; padding:8px 10px; border:1px solid #e6e0c5; border-left:3px solid #bf9a2b; border-radius:0 4px 4px 0; background:#fffdf5; color:#6f5a1c; font-size:11px; line-height:1.6; }
        #facilityPage .type-choice-note .material-symbols-rounded { flex-shrink:0; margin-top:1px; font-size:15px; color:#a07b13; }
        #facilityPage .type-choice-note strong { color:#4f3c08; font-weight:800; }
        #facilityPage .help-inline { margin-top:6px; font-size:11px; color:#8a9a8e; line-height:1.5; }
        #facilityPage .help-inline strong { color:#4a5c4e; }

        /* 설치계약 연결 */
        #facilityPage .install-radio-row { display:flex; align-items:center; gap:10px; flex-wrap:wrap; }
        #facilityPage .install-radio-item { display:flex; align-items:center; gap:5px; height:32px; padding:0 10px; border:1px solid var(--line); border-radius:4px; background:#fff; font-size:12px; color:#4a5c4e; cursor:pointer; }
        #facilityPage .install-radio-item input { margin:0; }
        #facilityPage .install-contract-box { display:none; margin-top:8px; padding:10px; border:1px solid var(--line); border-radius:4px; background:#fbfcfb; }
        #facilityPage .install-contract-box.is-active { display:block; }

        /* 파일 업로드 */
        #facilityPage .file-upload-box { padding:12px; border:1px dashed var(--line); border-radius:4px; background:#fafcfb; }
        #facilityPage .file-upload-title { display:flex; align-items:center; gap:5px; font-size:12px; font-weight:800; color:#4a5c4e; }
        #facilityPage .file-upload-title .material-symbols-rounded { font-size:16px; color:var(--accent); }
        #facilityPage .file-upload-desc { font-size:11px; color:#7a8a7d; line-height:1.5; }
        #facilityPage .file-preview-list { display:grid; grid-template-columns:repeat(4,minmax(0,1fr)); gap:8px; margin-top:10px; }
        #facilityPage .file-preview-item { min-height:92px; border:1px solid var(--line); border-radius:4px; background:#fff; overflow:hidden; }
        #facilityPage .file-preview-item img { width:100%; height:92px; object-fit:contain; display:block; background:#f8fafc; }
        #facilityPage .file-preview-name { padding:6px 7px; border-top:1px solid var(--line); font-size:11px; color:#4a5c4e; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
        #facilityPage .file-preview-empty { padding:13px; border:1px solid var(--line); border-radius:4px; background:#fff; font-size:12px; color:#9caa9e; }

        /* 위치 선택 */
        #facilityPage .location-select-row { display:grid; grid-template-columns:1.1fr .75fr .75fr 1.1fr; gap:10px; align-items:end; }
        #facilityPage .location-detail-row { margin-top:10px; }
        #facilityPage .location-help-row { margin-top:5px; font-size:11px; color:#9caa9e; line-height:1.5; }

        /* 반응형 */
        @media (max-width:900px) {
            #facilityPage .facility-basic-row { grid-template-columns:1fr 1fr; }
            #facilityPage .location-select-row { grid-template-columns:1fr 1fr; }
        }
        @media (max-width:760px) {
            #facilityPage .facility-basic-row { grid-template-columns:1fr; }
            #facilityPage .facility-modal-cols { grid-template-columns:1fr; }
            #facilityPage .facility-modal-col-left { padding-right:0; padding-bottom:16px; margin-bottom:16px; border-right:none; border-bottom:1px solid var(--line); }
            #facilityPage .facility-modal-col-right { padding-left:0; }
        }
    </style>

    <script>
        window.facilityPageConfig = {
            contextPath: "${pageContext.request.contextPath}",
            mgmtOfcNo: "${mgmtOfcNo}"
        };
    </script>
</head>
<body>

<c:set var="activeSidebarHref" value="${pageContext.request.contextPath}/manager/facility/page/${mgmtOfcNo}" />
<c:set var="activeSidebarParent" value="시설·공사 관리" />
<c:set var="activeSidebarCurrent" value="시설 등록" />

<div class="app-wrapper">
    <%@ include file="/WEB-INF/views/include/office_sidebar.jsp" %>

    <div class="main-wrap">
        <%@ include file="/WEB-INF/views/include/office_header.jsp" %>
        <%@ include file="/WEB-INF/views/include/office_active_sidebar.jspf" %>

        <main class="main-content">
            <div class="office-page" id="facilityPage">
                <div class="page-header">
                    <div class="page-title-block">
                        <h2>시설 등록</h2>
                        <p>신규 시설자산의 기본정보와 사진을 등록합니다.</p>
                    </div>
                </div>

                <div class="panel">
                    <div class="panel-header">
                        <h3 class="panel-title"><span class="material-symbols-rounded">edit_square</span>시설 정보 입력</h3>
                    </div>

                    <form id="facilityForm" enctype="multipart/form-data">
                        <input type="hidden" id="useYn" name="useYn" value="Y">
                        <input type="hidden" id="facilityTyCd" name="facilityTyCd" value="">
                        <input type="hidden" id="facilityTyMode" name="facilityTyMode" value="EXISTING">
                        <input type="hidden" id="newFacilityTyNm" name="newFacilityTyNm" value="">
                        <input type="hidden" id="newFacilityTyCn" name="newFacilityTyCn" value="">

                        <div class="panel-body">
                            <div class="facility-modal-cols">
                                <div class="facility-modal-col-left">
                                    <div class="facility-col-label">기본 정보</div>

                                    <div class="form-section">
                                        <div class="form-section-title">
                                            <span class="material-symbols-rounded">apartment</span>시설 기본정보
                                        </div>

                                        <div class="type-choice-note">
                                            <span class="material-symbols-rounded">warning</span>
                                            <div>시설유형은 <strong>계약·점검·검침 분류 기준</strong>입니다. 실제 관리 기준에 맞게 선택하고, 목록에 없을 때만 새 시설유형으로 추가하세요.</div>
                                        </div>

                                        <div class="facility-basic-row">
                                            <div class="form-field">
                                                <label class="field-label">시설유형 <span class="req">*</span></label>
                                                <div class="type-search-wrap">
                                                    <input type="text" class="form-input" id="facilityTyKeyword" autocomplete="off" placeholder="시설유형을 검색하거나 새로 입력하세요">
                                                    <div class="type-suggest-list" id="facilityTySuggestList"></div>
                                                </div>
                                                <div class="type-status" id="selectedTypeText">시설유형을 선택하세요.</div>
                                            </div>

                                            <div class="form-field">
                                                <label class="field-label">시설명 <span class="req">*</span></label>
                                                <input type="text" class="form-input" id="facilityNm" name="facilityNm" placeholder="예) 소화전, 독서실, 수영장" required>
                                            </div>

                                            <div class="form-field">
                                                <label class="field-label">설치일자</label>
                                                <input type="date" class="form-input" id="instlDt" name="instlDt">
                                            </div>
                                        </div>

                                        <div class="basic-help-text">
                                            시설명은 <strong>내부 관리용 자산명</strong>입니다. 예) 소방시설-소화전, 전기시설-분전반, 독서실-독서실<br>
                                            편의시설 운영명은 편의시설 관리에서 별도로 설정합니다.
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
                                        <div class="help-inline">공용 위치·동 위치·세대 위치 중 실제 관리 위치에 맞게 선택하세요.</div>
                                        <div class="form-field location-detail-row">
                                            <label class="field-label">상세위치</label>
                                            <input type="text" class="form-input" id="locCn" name="locCn" placeholder="예) 1층 로비, 옥상, 지하주차장 B2 A구역">
                                        </div>
                                    </div>
                                </div>

                                <div class="facility-modal-col-right">
                                    <div class="facility-col-label">연결·첨부 정보</div>

                                    <div class="form-section">
                                        <div class="form-section-title"><span class="material-symbols-rounded">contract</span>설치계약</div>

                                        <div class="form-field">
                                            <label class="field-label">설치계약 연결 여부 <span class="req">*</span></label>
                                            <div class="install-radio-row">
                                                <label class="install-radio-item">
                                                    <input type="radio" name="installContractYn" value="Y">
                                                    <span>설치계약 있음</span>
                                                </label>
                                                <label class="install-radio-item">
                                                    <input type="radio" name="installContractYn" value="N" checked>
                                                    <span>설치계약 없음</span>
                                                </label>
                                            </div>
                                            <div class="help-inline">계약자료가 있는 신규 설치 시설만 연결하세요.</div>
                                        </div>

                                        <div class="install-contract-box" id="installContractBox">
                                            <div class="form-field">
                                                <label class="field-label">설치계약 선택 <span class="req">*</span></label>
                                                <select class="form-select" id="installContractNo" name="installContractNo">
                                                    <option value="">설치계약 선택</option>
                                                    <c:forEach var="contract" items="${installContractList}">
                                                        <%-- ***# 설치계약 조회 결과 alias 매핑 --%>
                                                        <option value="${contract.contNo}">
                                                                ${contract.contNm} / ${contract.partnerNm} / ${contract.contBgngDt} ~ ${contract.contEndDt}
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                            <div class="warn-inline">
                                                <span class="material-symbols-rounded">warning</span>
                                                <div>설치계약 있음 선택 시 계약 선택은 필수입니다.</div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="form-section">
                                        <div class="form-section-title"><span class="material-symbols-rounded">image</span>사진 첨부</div>
                                        <div class="file-upload-box">
                                            <div class="file-upload-title"><span class="material-symbols-rounded">upload_file</span>사진 등록</div>
                                            <div class="file-upload-desc" style="margin-top:3px;margin-bottom:8px;">이미지 파일을 여러 장 선택할 수 있습니다.</div>
                                            <input type="file" class="form-input" id="facilityFiles" name="facilityFiles" accept="image/*" multiple>
                                            <div class="file-preview-list" id="facilityFilePreview" style="margin-top:8px;">
                                                <div class="file-preview-empty">선택된 사진이 없습니다.</div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="soft-guide-box">
                                        <div class="soft-guide-title"><span class="material-symbols-rounded">link</span>등록 후 안내</div>
                                        <div>저장 후 시설 상세에서 기본정보와 첨부 사진을 확인할 수 있습니다.</div>
                                        <div>편의시설 운영정보, 설치계약, 점검·보수 이력은 각 관리 화면에서 이어서 연결합니다.</div>
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

<script src="${pageContext.request.contextPath}/js/manager/manager-common.js"></script>
<script>
    (function () {
        var config = window.facilityPageConfig || {};
        var contextPath = config.contextPath || "";
        var mgmtOfcNo = config.mgmtOfcNo || "";

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
            if (contentType.indexOf("application/json") === -1) {
                throw new Error("JSON 응답이 아닙니다. 요청 URL 또는 로그인 상태를 확인해주세요.");
            }
            var data = await response.json();
            if (!response.ok || data.success === false) throw new Error(data.message || "요청 처리 중 오류가 발생했습니다.");
            return data;
        }

        function getJson(url) { return requestJson(url, { method:"GET", headers:getCsrfHeaders() }); }
        function postForm(url, formData) { return requestJson(url, { method:"POST", headers:getCsrfHeaders(), body:formData }); }

        function resetSelect(select, placeholder) {
            if (select) select.innerHTML = '<option value="">' + placeholder + '</option>';
        }

        function removeHouseholdPrefix(text) {
            return String(text || "").replace(/^\s*\d+\s*층\s*/g, "").replace(/^\s*\d+\s*호\s*/g, "").trim();
        }

        var facilityTypeList = [
            { code:"ELV", name:"승강기", group:"일반시설" },
            { code:"WTR", name:"급수시설", group:"일반시설" },
            { code:"ELC", name:"전기시설", group:"일반시설" },
            { code:"GAS", name:"가스시설", group:"일반시설" },
            { code:"FIRE", name:"소방시설", group:"일반시설" },
            { code:"SEC", name:"보안시설", group:"일반시설" },
            { code:"ETC", name:"기타시설", group:"일반시설" }
            <c:forEach var="type" items="${publicFacilityTypeList}">
            , { code:"${fn:escapeXml(type.code)}", name:"${fn:escapeXml(type.codeNm)}", group:"${fn:startsWith(type.code, 'CUS') ? '추가 시설유형' : '편의시설'}" }
            </c:forEach>
        ];

        var lastAutoFacilityNm = "";

        function escapeHtml(text) {
            return String(text || "")
                .replace(/&/g, "&amp;")
                .replace(/</g, "&lt;")
                .replace(/>/g, "&gt;")
                .replace(/"/g, "&quot;")
                .replace(/'/g, "&#039;");
        }

        function closeTypeSuggestList() {
            var list = getEl("facilityTySuggestList");
            if (list) list.classList.remove("is-active");
        }

        function shouldAutoFillFacilityNm() {
            var facilityNm = getEl("facilityNm");
            var currentValue = facilityNm.value.trim();
            return !currentValue || currentValue === lastAutoFacilityNm;
        }

        function setFacilityNameByType(typeName) {
            // 시설명이 비어 있거나 이전 자동입력값 그대로인 경우에만 유형명을 기본 시설명으로 반영
            if (shouldAutoFillFacilityNm()) {
                getEl("facilityNm").value = typeName;
                lastAutoFacilityNm = typeName;
            }
        }

        function selectExistingFacilityType(type) {
            // 기존 공통코드 시설유형 선택
            getEl("facilityTyMode").value = "EXISTING";
            getEl("facilityTyCd").value = type.code;
            getEl("newFacilityTyNm").value = "";
            getEl("newFacilityTyCn").value = "";
            getEl("facilityTyKeyword").value = type.name;
            getEl("selectedTypeText").className = "type-status";
            getEl("selectedTypeText").innerHTML = "선택된 시설유형: <strong>" + escapeHtml(type.name) + "</strong> <span style='color:#8a9a8e;'>/ " + escapeHtml(type.group) + "</span>";
            setFacilityNameByType(type.name);
            closeTypeSuggestList();
        }

        function selectNewFacilityType(typeName) {
            // 새 시설유형 추가 선택
            getEl("facilityTyMode").value = "NEW";
            getEl("facilityTyCd").value = "";
            getEl("newFacilityTyNm").value = typeName;
            getEl("newFacilityTyCn").value = "시설 등록 화면에서 추가";
            getEl("facilityTyKeyword").value = typeName;
            getEl("selectedTypeText").className = "type-status is-new";
            getEl("selectedTypeText").innerHTML = "새 시설유형: <strong>" + escapeHtml(typeName) + "</strong> · 저장 시 공통코드에 추가됩니다.";
            setFacilityNameByType(typeName);
            closeTypeSuggestList();
        }

        function renderTypeSuggestList(keyword) {
            var list = getEl("facilityTySuggestList");
            var rawKeyword = String(keyword || "").trim();
            var query = rawKeyword.toLowerCase();
            list.innerHTML = "";

            // 입력창을 클릭한 경우에는 검색어가 없어도 전체 시설유형을 보여준다.
            var matchedList = query
                ? facilityTypeList.filter(function (type) {
                    return type.name.toLowerCase().indexOf(query) !== -1 || type.code.toLowerCase().indexOf(query) !== -1;
                })
                : facilityTypeList.slice();

            // 원본 select의 optgroup처럼 일반시설 / 편의시설을 나눠서 보여준다.
            var groupOrder = ["일반시설", "편의시설", "추가 시설유형"];
            var groupedTypeMap = {};
            matchedList.forEach(function (type) {
                var groupName = type.group || "기타";
                if (!groupedTypeMap[groupName]) groupedTypeMap[groupName] = [];
                groupedTypeMap[groupName].push(type);
            });

            groupOrder.concat(Object.keys(groupedTypeMap).filter(function (groupName) {
                return groupOrder.indexOf(groupName) === -1;
            })).forEach(function (groupName) {
                var groupList = groupedTypeMap[groupName] || [];
                if (groupList.length === 0) return;

                var groupBox = document.createElement("div");
                groupBox.className = "type-suggest-group";

                var groupTitle = document.createElement("div");
                groupTitle.className = "type-suggest-group-title";
                groupTitle.textContent = groupName;
                groupBox.appendChild(groupTitle);

                groupList.slice(0, query ? 8 : 30).forEach(function (type) {
                    var button = document.createElement("button");
                    button.type = "button";
                    button.className = "type-suggest-item";
                    button.innerHTML = "<span class='type-suggest-label'>" + escapeHtml(type.name) + "</span><span class='type-suggest-meta'>" + escapeHtml(type.code) + "</span>";
                    button.addEventListener("mousedown", function (event) {
                        event.preventDefault();
                        selectExistingFacilityType(type);
                    });
                    groupBox.appendChild(button);
                });

                list.appendChild(groupBox);
            });

            var exactMatch = query && facilityTypeList.some(function (type) {
                return type.name.toLowerCase() === query;
            });

            // 새 유형 추가는 실제 검색어가 있을 때만 표시한다.
            if (query && !exactMatch) {
                var newGroupBox = document.createElement("div");
                newGroupBox.className = "type-suggest-group";

                var newGroupTitle = document.createElement("div");
                newGroupTitle.className = "type-suggest-group-title";
                newGroupTitle.textContent = "새 시설유형";
                newGroupBox.appendChild(newGroupTitle);

                var newButton = document.createElement("button");
                newButton.type = "button";
                newButton.className = "type-suggest-item is-new";
                newButton.innerHTML = "<span class='type-suggest-label'>+ &quot;" + escapeHtml(rawKeyword) + "&quot; 새 시설유형으로 추가</span><span class='type-suggest-meta'>공통코드</span>";
                newButton.addEventListener("mousedown", function (event) {
                    event.preventDefault();
                    selectNewFacilityType(rawKeyword);
                });
                newGroupBox.appendChild(newButton);
                list.appendChild(newGroupBox);
            }

            if (!list.children.length) {
                var emptyBox = document.createElement("div");
                emptyBox.className = "type-suggest-group";
                emptyBox.innerHTML = "<div class='type-suggest-group-title'>검색 결과</div><button type='button' class='type-suggest-item' disabled><span class='type-suggest-label'>일치하는 시설유형이 없습니다.</span></button>";
                list.appendChild(emptyBox);
            }

            list.classList.add("is-active");
        }

        function handleTypeKeywordInput() {
            // 직접 입력 중에는 아직 선택 확정 전이므로 저장용 값을 초기화
            getEl("facilityTyMode").value = "EXISTING";
            getEl("facilityTyCd").value = "";
            getEl("newFacilityTyNm").value = "";
            getEl("newFacilityTyCn").value = "";
            getEl("selectedTypeText").className = "type-status";
            getEl("selectedTypeText").textContent = "시설유형을 선택하세요.";
            renderTypeSuggestList(getEl("facilityTyKeyword").value);
        }

        function confirmTypedFacilityTypeIfNeeded() {
            // 검색 결과에서 선택하지 않고 저장/포커스아웃한 경우, 기존명과 정확히 같으면 기존 유형으로 확정하고 아니면 새 유형으로 확정
            var keyword = getEl("facilityTyKeyword").value.trim();
            if (!keyword || getEl("facilityTyCd").value || getEl("facilityTyMode").value === "NEW") return;

            var exactType = facilityTypeList.find(function (type) {
                return type.name.toLowerCase() === keyword.toLowerCase();
            });

            if (exactType) selectExistingFacilityType(exactType);
            else selectNewFacilityType(keyword);
        }

        function toggleInstallContractBox() {
            var checked = document.querySelector('input[name="installContractYn"]:checked');
            var box = getEl("installContractBox");
            var contractSelect = getEl("installContractNo");

            if (checked && checked.value === "Y") {
                box.classList.add("is-active");
                contractSelect.disabled = false;
                return;
            }

            box.classList.remove("is-active");
            contractSelect.value = "";
            contractSelect.disabled = true;
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
                locCn.value = removeHouseholdPrefix(locCn.value);
                return;
            }

            if (type === "DONG") {
                dongNo.disabled = false;
                floorSelect.disabled = true; resetSelect(floorSelect, "층 선택");
                hoSelect.disabled = true; resetSelect(hoSelect, "호 선택");
                locCn.placeholder = "예) 1층 로비, 옥상, EPS실";
                locCn.value = removeHouseholdPrefix(locCn.value);
                return;
            }

            dongNo.disabled = false;
            floorSelect.disabled = false;
            hoSelect.disabled = false;
            locCn.placeholder = "예) 세대 분전반, 수도계량기";
            updateHouseholdLocationText();
        }

        async function loadFloorList() {
            var dongNo = getEl("dongNo");
            var floorSelect = getEl("facilityFloor");
            var hoSelect = getEl("facilityHo");

            resetSelect(floorSelect, "층 선택");
            resetSelect(hoSelect, "호 선택");
            updateHouseholdLocationText();

            if (!dongNo.value) return;

            var result = await getJson(apiUrl("location/floors/" + encodeURIComponent(mgmtOfcNo) + "?dongNo=" + encodeURIComponent(dongNo.value)));
            var floorList = result.list || result.floorList || result || [];

            floorList.forEach(function (row) {
                var floor = row.floor || row.FLOOR;
                if (!floor) return;
                var option = document.createElement("option");
                option.value = floor;
                option.textContent = floor;
                floorSelect.appendChild(option);
            });
        }

        async function loadHoList() {
            var dongNo = getEl("dongNo");
            var floorSelect = getEl("facilityFloor");
            var hoSelect = getEl("facilityHo");

            resetSelect(hoSelect, "호 선택");
            updateHouseholdLocationText();

            if (!dongNo.value || !floorSelect.value) return;

            var result = await getJson(apiUrl("location/rooms/" + encodeURIComponent(mgmtOfcNo) + "?dongNo=" + encodeURIComponent(dongNo.value) + "&floor=" + encodeURIComponent(floorSelect.value)));
            var hoList = result.list || result.roomList || result || [];

            hoList.forEach(function (row) {
                var ho = row.ho || row.HO;
                if (!ho) return;
                var option = document.createElement("option");
                option.value = ho;
                option.textContent = ho;
                hoSelect.appendChild(option);
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

        function validateFacilityType() {
            // 사용자가 검색어만 입력하고 목록을 클릭하지 않은 경우 저장 직전에 선택 상태를 확정
            confirmTypedFacilityTypeIfNeeded();

            var mode = getEl("facilityTyMode").value;
            var newTypeName = getEl("newFacilityTyNm").value.trim();

            if (mode === "NEW") {
                if (!newTypeName) {
                    alertMessage("새 시설유형명을 입력하세요.");
                    getEl("facilityTyKeyword").focus();
                    return false;
                }
                return true;
            }

            if (!getEl("facilityTyCd").value) {
                alertMessage("시설유형을 선택하세요.");
                getEl("facilityTyKeyword").focus();
                return false;
            }

            return true;
        }

        function validateInstallContract() {
            var checked = document.querySelector('input[name="installContractYn"]:checked');

            if (!checked) {
                alertMessage("설치계약 연결 여부를 선택하세요.");
                return false;
            }

            if (checked.value === "Y" && !getEl("installContractNo").value) {
                alertMessage("설치계약이 있는 경우 설치계약을 선택하세요.");
                getEl("installContractNo").focus();
                return false;
            }

            return true;
        }

        function makeRegisterFormData() {
            // 기본 form 기준 FormData 생성
            // - input type="file"에 선택된 파일도 자동 포함
            var formData = new FormData(getEl("facilityForm"));

            // 위치구분에 따라 가공된 상세위치 반영
            formData.set("locCn", buildLocationText());

            // 등록 시 기본 사용여부 고정
            formData.set("useYn", "Y");

            // 새 시설유형 모드면 서버에서 공통코드 등록 후 생성된 code_no_cd를 facility_ty_cd로 사용해야 함
            if (getEl("facilityTyMode").value === "NEW") {
                formData.delete("facilityTyCd");
                formData.set("facilityTyMode", "NEW");
                formData.set("newFacilityTyNm", getEl("newFacilityTyNm").value.trim());
                formData.set("newFacilityTyCn", getEl("newFacilityTyCn").value.trim());
            } else {
                formData.set("facilityTyMode", "EXISTING");
                formData.set("facilityTyCd", getEl("facilityTyCd").value);
                formData.delete("newFacilityTyNm");
                formData.delete("newFacilityTyCn");
            }

            // 설치계약 없음이면 계약번호 전송 제거
            if (formData.get("installContractYn") !== "Y") {
                formData.delete("installContractNo");
            }

            // 설치일자가 비어 있으면 서버로 빈 문자열 전송 방지
            if (!formData.get("instlDt")) {
                formData.delete("instlDt");
            }

            return formData;
        }

        async function saveFacility(event) {
            event.preventDefault();

            if (!validateFacilityType()) return;
            if (!getEl("facilityNm").value.trim()) { alertMessage("시설명을 입력하세요."); return; }
            if (!validateInstallContract()) return;

            try {
                await postForm(apiUrl("insert/" + encodeURIComponent(mgmtOfcNo)), makeRegisterFormData());
                await showAlertThen("시설이 등록되었습니다.", listUrl(), "success");
            } catch (err) {
                console.error(err);
                await alertMessage(err.message || "시설 등록 중 오류가 발생했습니다.", "error");
            }
        }

        /* ============================================================
           파일 미리보기
           - 기본 파일 input의 FileList 기준으로 현재 선택된 파일만 표시
           - 파일을 다시 선택하면 브라우저 기본 동작에 따라 기존 선택은 교체
        ============================================================ */
        function renderSelectedFilePreview() {
            // 파일 input
            var fileInput = getEl("facilityFiles");

            // 미리보기 영역
            var previewArea = getEl("facilityFilePreview");

            // 필수 요소가 없으면 중단
            if (!fileInput || !previewArea) return;

            // 기존 미리보기 초기화
            previewArea.innerHTML = "";

            // 선택된 파일이 없으면 안내문구 표시
            if (!fileInput.files || fileInput.files.length === 0) {
                previewArea.innerHTML = '<div class="file-preview-empty">선택된 사진이 없습니다.</div>';
                return;
            }

            // 현재 input에 선택된 파일 기준으로 미리보기 생성
            Array.from(fileInput.files).forEach(function (file) {
                // 미리보기 카드
                var wrapper = document.createElement("div");
                wrapper.className = "file-preview-item";

                // 이미지 파일이면 썸네일 표시
                if (file.type && file.type.indexOf("image/") === 0) {
                    var img = document.createElement("img");
                    img.alt = file.name;
                    img.src = URL.createObjectURL(file);

                    // 이미지 로드 후 임시 objectUrl 해제
                    img.onload = function () {
                        URL.revokeObjectURL(img.src);
                    };

                    wrapper.appendChild(img);
                }

                // 파일명 표시
                var nameEl = document.createElement("div");
                nameEl.className = "file-preview-name";
                nameEl.textContent = file.name;
                wrapper.appendChild(nameEl);

                // 미리보기 영역에 카드 추가
                previewArea.appendChild(wrapper);
            });
        }

        function previewSelectedFiles() {
            // 파일 선택 변경 시 input.files 기준으로 미리보기만 다시 그림
            renderSelectedFilePreview();
        }

        function bindEvents() {
            getEl("facilityForm").addEventListener("submit", saveFacility);
            getEl("backToListBtn").addEventListener("click", function () { location.href = listUrl(); });
            getEl("facilityFiles").addEventListener("change", previewSelectedFiles);

            getEl("facilityTyKeyword").addEventListener("input", handleTypeKeywordInput);
            getEl("facilityTyKeyword").addEventListener("focus", function () { renderTypeSuggestList(this.value); });
            getEl("facilityTyKeyword").addEventListener("blur", function () { setTimeout(closeTypeSuggestList, 120); });
            getEl("facilityNm").addEventListener("input", function () { if (this.value.trim() !== lastAutoFacilityNm) lastAutoFacilityNm = ""; });

            document.querySelectorAll('input[name="installContractYn"]').forEach(function (radio) {
                radio.addEventListener("change", toggleInstallContractBox);
            });

            getEl("locationType").addEventListener("change", function () {
                changeLocationTypeView();
                if (this.value === "HOUSEHOLD" || this.value === "DONG") loadFloorList();
            });

            getEl("dongNo").addEventListener("change", function () {
                if (getEl("locationType").value === "HOUSEHOLD") loadFloorList();
            });

            getEl("facilityFloor").addEventListener("change", loadHoList);
            getEl("facilityHo").addEventListener("change", updateHouseholdLocationText);
        }

        document.addEventListener("DOMContentLoaded", function () {
            bindEvents();
            changeLocationTypeView();
            toggleInstallContractBox();
        });
    })();
</script>
</body>
</html>
