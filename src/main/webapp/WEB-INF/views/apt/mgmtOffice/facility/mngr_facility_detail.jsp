<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>시설 상세</title>

    <sec:csrfMetaTags/>

    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet" />

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/office-layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/manager-common.css">

    <style>
        #facilityPage { --accent:#2e5c38; --accent-light:#e8f0ea; --accent-dim:rgba(38,92,48,.08); --surface:#fff; --line:#d7dce2; --th-bg:#f4f6f4; --text-head:#1a2e1e; --text-sub:#6b7a6e; }
        #facilityPage .page-title-block h2 { color:var(--text-head); font-size:20px; letter-spacing:-.5px; margin:0; }
        #facilityPage .page-title-block p { color:var(--text-sub); font-size:12px; margin-top:6px; }
        #facilityPage .detail-card { border:1px solid var(--line); border-radius:8px; background:var(--surface); overflow:hidden; }
        #facilityPage .detail-card-body { padding:24px 28px 28px; }
        #facilityPage .btn { border-radius:4px; min-height:34px; font-size:12px; padding:0 14px; }
        #facilityPage .btn-primary { background:var(--accent); border-color:var(--accent); }
        #facilityPage .btn-primary:hover { background:#1a3d1f; border-color:#1a3d1f; }
        #facilityPage .detail-section-title { display:flex; align-items:center; gap:6px; margin:0 0 12px; padding-bottom:10px; border-bottom:1px solid var(--line); font-size:13px; font-weight:700; color:var(--text-head); }
        #facilityPage .detail-section-title .material-symbols-rounded { font-size:17px; color:var(--accent); }
        #facilityPage .detail-section { margin-bottom:24px; }
        #facilityPage .detail-section:last-child { margin-bottom:0; }
        #facilityPage #detailFileSection { margin-bottom:0; }
        #facilityPage .connection-guide-section { margin-top:auto; padding-top:42px; }
        #facilityPage .connection-guide-section .notice-box { margin-top:0; }
        #facilityPage .detail-cols { display:grid; grid-template-columns:1fr 1fr; gap:0; }
        #facilityPage .detail-col-left { padding-right:28px; border-right:1px solid var(--line); }
        #facilityPage .detail-col-right { padding-left:28px; display:flex; flex-direction:column; min-height:100%; }
        #facilityPage .detail-table { width:100%; border-top:1px solid var(--line); border-collapse:collapse; table-layout:fixed; }
        #facilityPage .detail-table th { width:90px; padding:11px 12px; border-bottom:1px solid var(--line); background:var(--th-bg); color:#27382b; font-size:12px; font-weight:600; text-align:left; vertical-align:middle; }
        #facilityPage .detail-table td { padding:11px 14px; border-bottom:1px solid var(--line); color:#111827; font-size:12px; font-weight:500; vertical-align:middle; word-break:break-all; }
        #facilityPage .detail-empty { color:#9ca3af; font-weight:400; }
        #facilityPage .badge { display:inline-flex; align-items:center; justify-content:center; min-height:22px; padding:0 8px; border-radius:4px; font-size:11px; font-weight:600; line-height:1; border:1px solid transparent; }
        #facilityPage .badge-blue { background:#dbeafe; color:#1e3a5f; border-color:#bfdbfe; }
        #facilityPage .badge-contract-active { background:#dceee0; color:#1f7a3f; border-color:#c7e4cf; }
        #facilityPage .badge-contract-end { background:#f3f4f6; color:#4b5563; border-color:#d1d5db; }
        #facilityPage .badge-use-y { background:#dceee0; color:#1f7a3f; border-color:#c7e4cf; }
        #facilityPage .badge-use-y::before { content:""; width:7px; height:7px; margin-right:6px; border-radius:50%; background:#22c55e; }
        #facilityPage .badge-use-n { background:#fee2e2; color:#b42318; border-color:#fecaca; }
        #facilityPage .badge-use-n::before { content:""; width:7px; height:7px; margin-right:6px; border-radius:50%; background:#ef4444; }
        #facilityPage .badge-restrict { background:#fff7ed; color:#c2410c; border-color:#fed7aa; }
        #facilityPage .badge-restrict::before { content:""; width:7px; height:7px; margin-right:6px; border-radius:50%; background:#f97316; }
        #facilityPage .file-preview-list { display:grid; grid-template-columns:repeat(2,minmax(0,1fr)); gap:10px; }
        #facilityPage .file-preview-item { border:1px solid var(--line); border-radius:6px; background:#fafcfb; overflow:hidden; }
        #facilityPage .file-preview-item img { display:block; width:100%; height:110px; object-fit:cover; border-bottom:1px solid var(--line); }
        #facilityPage .file-preview-name { padding:8px 10px; font-size:11px; color:#4a5c4e; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
        #facilityPage .file-preview-empty { grid-column:1 / -1; padding:14px 16px; border:1px solid var(--line); border-radius:6px; background:#fff; font-size:12px; color:#9caa9e; }
        #facilityPage .disabled-notice { display:none; align-items:flex-start; gap:10px; margin-bottom:20px; padding:13px 15px; border:1px solid #fed7aa; border-left:3px solid #f59e0b; border-radius:0 4px 4px 0; background:#fff7ed; color:#7c2d12; font-size:12px; line-height:1.6; }
        #facilityPage .disabled-notice .material-symbols-rounded { color:#f59e0b; font-size:18px; flex-shrink:0; margin-top:1px; }
        #facilityPage .detail-info-row { display:grid; grid-template-columns:1fr 1fr; gap:20px; margin-bottom:20px; }
        #facilityPage .check-status-section { margin-bottom:24px; }
        #facilityPage .check-status-box { display:flex; align-items:flex-start; gap:12px; min-height:48px; padding:13px 15px; border:1px solid var(--line); border-left:3px solid var(--accent); border-radius:0 6px 6px 0; background:#f7faf7; }
        #facilityPage .check-status-icon { display:inline-flex; align-items:center; justify-content:center; width:24px; height:24px; border-radius:50%; background:var(--accent-light); color:var(--accent); flex-shrink:0; }
        #facilityPage .check-status-icon .material-symbols-rounded { font-size:16px; }
        #facilityPage .check-status-main { min-width:0; flex:1; }
        #facilityPage .check-status-head { display:flex; align-items:center; gap:8px; flex-wrap:wrap; min-height:22px; }
        #facilityPage .check-status-period { color:#4b5563; font-size:12px; font-weight:600; }
        #facilityPage .check-status-desc { margin-top:6px; color:#6b7280; font-size:12px; font-weight:400; line-height:1.45; }
        #facilityPage .check-status-box.is-restricted { border-color:#fed7aa; border-left-color:#f97316; background:#fff7ed; }
        #facilityPage .check-status-box.is-restricted .check-status-icon { background:#ffedd5; color:#c2410c; }
        #facilityPage .install-section { margin-bottom:16px; }
        #facilityPage .install-line { display:flex; align-items:center; gap:10px; min-height:38px; padding:9px 12px; border:1px solid var(--line); border-radius:6px; background:#fbfcfb; }
        #facilityPage .install-line-label { flex:0 0 auto; color:#27382b; font-size:12px; font-weight:600; }
        #facilityPage .install-line-text { min-width:0; color:#111827; font-size:12px; font-weight:400; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
        #facilityPage .install-tag { color:#6b7280; font-weight:500; }
        #facilityPage .install-line-empty { color:#9ca3af; font-weight:400; }
        #facilityPage .detail-link-row { display:flex; flex-direction:column; gap:20px; }
        #facilityPage .detail-link-row .detail-section { margin-bottom:0; }
        #facilityPage .notice-box { display:flex; gap:10px; padding:13px 15px; background:#f7faf7; border:1px solid var(--line); border-left:3px solid var(--accent); border-radius:0 4px 4px 0; font-size:12px; color:#4a5c4e; line-height:1.7; }
        #facilityPage .notice-box .material-symbols-rounded { color:var(--accent); font-size:17px; flex-shrink:0; margin-top:2px; }
        #facilityPage .cmn-ref-box { display:flex; align-items:center; justify-content:space-between; gap:12px; min-height:42px; padding:10px 12px; border:1px solid var(--line); border-radius:4px; background:#f6f7f8; margin-top:10px; }
        #facilityPage .cmn-ref-main { min-width:0; display:flex; align-items:center; gap:7px; color:#4a5c4e; font-size:12px; font-weight:400; line-height:1.45; white-space:nowrap; overflow:hidden; }
        #facilityPage .cmn-ref-main .material-symbols-rounded { font-size:16px; color:#9aa5a0; flex-shrink:0; }
        #facilityPage .cmn-ref-text { display:block; min-width:0; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }
        #facilityPage .cmn-ref-link { display:inline-flex; align-items:center; gap:3px; color:var(--accent); font-size:11px; font-weight:500; text-decoration:none; white-space:nowrap; flex-shrink:0; }
        #facilityPage .cmn-ref-link:hover { color:#1a3d1f; }
        #facilityPage .cmn-ref-link .material-symbols-rounded { font-size:13px; }
        #facilityPage .cmn-ref-empty { display:flex; align-items:center; min-height:42px; padding:10px 12px; border:1px solid var(--line); border-radius:4px; background:#f6f7f8; margin-top:10px; font-size:12px; color:#9caa9e; }

        /* 최근 점검·보수 이력 */
        #facilityPage .detail-summary { border:1px solid var(--line); border-radius:6px; background:#fff; overflow:hidden; }
        #facilityPage .ds-row { display:block; min-height:auto; padding:11px 13px; border-bottom:1px solid var(--line); font-size:12px; }
        #facilityPage .ds-row:last-child { border-bottom:none; }
        #facilityPage .ds-head { display:flex; align-items:center; gap:7px; min-width:0; margin-bottom:6px; }
        #facilityPage .ds-no { color:#6b7280; font-family:'SF Mono','Consolas',monospace; font-size:11px; white-space:nowrap; }
        #facilityPage .ds-type { display:inline-flex; align-items:center; min-height:20px; padding:0 7px; border-radius:4px; background:#f3f4f6; color:#374151; font-size:11px; font-weight:700; white-space:nowrap; }
        #facilityPage .ds-status { display:inline-flex; align-items:center; min-height:20px; padding:0 7px; border-radius:4px; background:#eef7f0; color:#2e5c38; font-size:11px; font-weight:700; white-space:nowrap; }
        #facilityPage .ds-dt { margin-left:auto; color:#9ca3af; font-family:'SF Mono','Consolas',monospace; font-size:11px; white-space:nowrap; }
        #facilityPage .ds-nm { display:block; color:#111827; font-size:12px; font-weight:600; line-height:1.45; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
        #facilityPage .ds-restrict { display:flex; align-items:center; gap:6px; margin-top:7px; color:#c2410c; font-size:11px; font-weight:600; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
        #facilityPage .ds-restrict .material-symbols-rounded { font-size:14px; color:#f97316; }
        #facilityPage .ds-empty { display:flex; align-items:center; min-height:48px; padding:0 14px; color:#9ca3af; font-size:12px; }

        #facilityPage .detail-actions { display:flex; justify-content:flex-end; gap:8px; margin-top:16px; }
        #facilityPage .js-image-preview { cursor:zoom-in; }
        .image-preview-modal { display:none; position:fixed; inset:0; z-index:9999; align-items:center; justify-content:center; padding:24px; background:rgba(0,0,0,.76); }
        .image-preview-modal.is-open { display:flex; }
        .image-preview-modal img { max-width:92vw; max-height:88vh; object-fit:contain; border-radius:6px; background:#fff; }
        .image-preview-close { position:absolute; top:22px; right:28px; border:0; background:transparent; color:#fff; font-size:38px; line-height:1; cursor:pointer; }
        @media (max-width:900px) { #facilityPage .detail-cols { grid-template-columns:1fr; } #facilityPage .detail-col-left { padding-right:0; border-right:none; border-bottom:1px solid var(--line); padding-bottom:24px; margin-bottom:24px; } #facilityPage .detail-col-right { padding-left:0; display:flex; flex-direction:column; min-height:auto; } }
        @media (max-width:600px) { #facilityPage .detail-info-row { grid-template-columns:1fr; } #facilityPage .install-line { align-items:flex-start; } #facilityPage .install-line-text { white-space:normal; } #facilityPage .file-preview-list { grid-template-columns:1fr; } }
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
<div class="app-wrapper">
    <%@ include file="/WEB-INF/views/include/office_sidebar.jsp" %>
    <div class="main-wrap">
        <%@ include file="/WEB-INF/views/include/office_header.jsp" %>
        <main class="main-content">
            <div class="office-page" id="facilityPage">
                <div class="page-header">
                    <div class="page-title-block">
                        <h2 id="detailModalTitle">시설 상세</h2>
                        <p>시설 기본정보와 사진, 연결 정보를 확인합니다.</p>
                    </div>
                </div>

                <div class="detail-card">
                    <div class="detail-card-body">
                        <div class="disabled-notice" id="detailDisabledSection">
                            <span class="material-symbols-rounded">warning</span>
                            <div id="detailDisabledReason"></div>
                        </div>

                        <div class="detail-cols">
                            <div class="detail-col-left">
                                <div class="detail-section install-section" id="detailInstallContractSummary">
                                    <h3 class="detail-section-title"><span class="material-symbols-rounded">construction</span>설치 정보</h3>
                                    <div class="install-line">
                                        <span class="install-line-label">설치계약</span>
                                        <span class="install-line-text install-line-empty" id="installSummaryText">연결된 설치계약이 없습니다.</span>
                                    </div>
                                </div>

                                <div class="detail-info-row">
                                    <div class="detail-section">
                                        <h3 class="detail-section-title"><span class="material-symbols-rounded">apartment</span>시설 정보</h3>
                                        <table class="detail-table">
                                            <tbody>
                                            <tr><th>시설번호</th><td id="detailFacilityNo">-</td></tr>
                                            <tr><th>시설명</th><td id="detailFacilityNm">-</td></tr>
                                            <tr><th>시설유형</th><td id="detailFacilityTyNm">-</td></tr>
                                            <tr><th>활성여부</th><td id="detailUseYn">-</td></tr>
                                            </tbody>
                                        </table>
                                    </div>
                                    <div class="detail-section">
                                        <h3 class="detail-section-title"><span class="material-symbols-rounded">location_on</span>위치 정보</h3>
                                        <table class="detail-table">
                                            <tbody>
                                            <tr><th>위치구분</th><td id="detailLocationType">-</td></tr>
                                            <tr><th>동</th><td id="detailDongNo">-</td></tr>
                                            <tr><th>상세위치</th><td id="detailLocCn">-</td></tr>
                                            <tr><th>설치일자</th><td id="detailInstlDt">-</td></tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>

                                <%--
                                    시설 사진 영역
                                    - 상세 화면 전용 배치 변경 영역
                                    - 등록/수정 화면과 다르게 시설 기본정보 흐름 아래에 배치
                                    - 기존 렌더링 id(detailFileList, detailPhotoSectionTitle) 유지로 JS 수정 최소화
                                --%>
                                <div class="detail-section" id="detailFileSection">
                                    <h3 class="detail-section-title"><span class="material-symbols-rounded">image</span><span id="detailPhotoSectionTitle">시설 사진</span></h3>
                                    <div class="file-preview-list" id="detailFileList">
                                        <div class="file-preview-empty">등록된 사진이 없습니다.</div>
                                    </div>
                                </div>
                            </div>

                            <div class="detail-col-right">
                                <%--
                                    현재 점검상태 영역
                                    - FACILITY.USE_YN과 분리된 점검 이용제한 표시 영역
                                    - 현재 진행 중인 FACILITY_CHECK_HSTRY 이용제한 여부 표시
                                    - 기존 렌더링 id(detailCurrentCheckBox, detailCurrentCheckStatus) 유지
                                --%>
                                <div class="detail-section check-status-section" id="detailCurrentCheckSection">
                                    <h3 class="detail-section-title"><span class="material-symbols-rounded">fact_check</span>현재 점검상태</h3>
                                    <div class="check-status-box" id="detailCurrentCheckBox">
                                        <span class="check-status-icon"><span class="material-symbols-rounded">check_circle</span></span>
                                        <div class="check-status-main" id="detailCurrentCheckStatus">
                                            <div class="check-status-head"><span class="badge badge-use-y">제한 없음</span></div>
                                            <div class="check-status-desc">현재 진행 중인 이용제한 점검이 없습니다.</div>
                                        </div>
                                    </div>
                                </div>

                                <div class="detail-link-row">
                                    <div class="detail-section" id="detailHistorySection">
                                        <h3 class="detail-section-title">
                                            <span class="material-symbols-rounded">history</span>최근 점검·보수 이력
                                            <%-- ***# 시설상세점검전체보기: 실제 점검 이력 목록 매핑(/manager/checkHistory/{mgmtOfcNo}) 기준 링크 --%>
                                            <a href="${pageContext.request.contextPath}/manager/checkHistory/${mgmtOfcNo}" id="historyMoreLink" style="margin-left:auto; font-size:11px; font-weight:600; color:var(--accent); text-decoration:none;">전체보기 →</a>
                                        </h3>
                                        <div class="detail-summary">
                                            <div id="detailHistoryBody"></div>
                                        </div>
                                    </div>
                                </div>

                                <div class="detail-section connection-guide-section">
                                    <h3 class="detail-section-title"><span class="material-symbols-rounded">info</span>연결 정보 안내</h3>
                                    <div class="notice-box">
                                        <span class="material-symbols-rounded">info</span>
                                        <div>
                                            계약·점검·검침의 상세 내역은 각 전용 페이지에서 확인하세요.<br>
                                            <%-- ***# 시설상세연계바로가기: 계약/점검/검침의 실제 컨트롤러 매핑 기준 링크 묶음 --%>
                                            · 계약 상세 → <a href="${pageContext.request.contextPath}/manager/facility/contract/list/${mgmtOfcNo}" style="color:var(--accent);font-weight:600;">계약 관리</a><br>
                                            · 점검이력 → <a href="${pageContext.request.contextPath}/manager/checkHistory/${mgmtOfcNo}" style="color:var(--accent);font-weight:600;">유지보수·점검 이력</a><br>
                                            · 검침기록 → <a href="${pageContext.request.contextPath}/manager/meter/hstry/${mgmtOfcNo}" style="color:var(--accent);font-weight:600;">검침 이력</a>
                                        </div>
                                    </div>

                                    <%-- 편의시설 운영정보 연결 상태: 편의시설일 때만 JS에서 표시 --%>
                                    <div id="publicFacilitySection" style="display:none;margin-top:10px;">
                                        <div class="detail-section-title" style="margin-top:14px;"><span class="material-symbols-rounded">meeting_room</span>편의시설 운영정보</div>
                                        <%-- 등록된 경우: 상세 링크만 --%>
                                        <div class="cmn-ref-box" id="cmnRefBox" style="display:none;">
                                            <div class="cmn-ref-main"><span class="material-symbols-rounded">link</span><span class="cmn-ref-text" id="cmnRefText">-</span></div>
                                            <a href="#" class="cmn-ref-link" id="cmnDetailLink">상세<span class="material-symbols-rounded">arrow_forward</span></a>
                                        </div>
                                        <%-- 미등록인 경우 --%>
                                        <div class="cmn-ref-empty" id="cmnRefEmpty" style="display:none;"><span>편의시설 운영정보가 아직 등록되지 않았습니다.</span></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="detail-actions">
                    <button type="button" class="btn btn-secondary" id="backToListBtnTop">목록</button>
                    <sec:authorize access="!hasRole('ADMIN')">
                        <button type="button" class="btn btn-primary" id="detailEditBtnTop">수정</button>
                    </sec:authorize>
                </div>
            </div>
        </main>
    </div>
</div>

<div id="imagePreviewModal" class="image-preview-modal">
    <button type="button" id="imagePreviewCloseBtn" class="image-preview-close" aria-label="이미지 확대 닫기">×</button>
    <img id="imagePreviewLargeImg" src="" alt="확대 이미지">
</div>

<script src="${pageContext.request.contextPath}/js/manager/manager-common.js"></script>
<script>
    (function () {
        var config = window.facilityPageConfig || {};
        var contextPath = config.contextPath || "";
        var mgmtOfcNo = config.mgmtOfcNo || "";
        var facilityNo = config.facilityNo || "";
        var isAdmin = config.isAdmin === true || config.isAdmin === "true";

        function apiUrl(path) { return contextPath + "/manager/facility/" + path; }
        function listUrl() { return contextPath + "/manager/facility/page/" + encodeURIComponent(mgmtOfcNo); }
        function alertMessage(message) { if (typeof showAlert === "function") showAlert(message); else alert(message); }
        function escapeHtml(value) { if (value == null) return ""; return String(value).replace(/&/g,"&amp;").replace(/</g,"&lt;").replace(/>/g,"&gt;").replace(/\"/g,"&quot;").replace(/'/g,"&#39;"); }
        function formatDate(value) { return value ? String(value).slice(0, 10) : ""; }
        function formatDateTime(value) {
            if (!value) return "";
            return String(value).replace("T", " ").slice(0, 16);
        }
        function formatDongNo(value) { if (value == null || value === "") return "공용"; var text = String(value); var idx = text.lastIndexOf("_"); return idx > -1 ? text.slice(idx + 1) : text; }
        function badge(cls, text) { return '<span class="badge ' + cls + '">' + escapeHtml(text) + '</span>'; }
        function useYnBadge(useYn) { return useYn === "N" ? badge("badge-use-n","비활성") : badge("badge-use-y","활성"); }
        function currentStatusBadge(facility) {
            if (!facility || facility.useYn === "N") return badge("badge-use-n", "비활성");
            if (facility.currentRestrictYn === "Y" || facility.facilityDisplayStatus === "이용제한중") return badge("badge-restrict", "이용제한중");
            return badge("badge-use-y", "활성");
        }
        function formatRestrictPeriod(bgngDt, endDt) {
            var bgng = formatDateTime(bgngDt);
            var end = formatDateTime(endDt);
            if (bgng && end) return bgng + " ~ " + end;
            if (bgng) return bgng + " ~";
            if (end) return "~ " + end;
            return "";
        }
        function contractStatusBadge(contract) {
            var statusCd = contract && (contract.contSttsCd || contract.CONT_STTS_CD);
            var statusNm = contract && (contract.contSttsNm || contract.CONT_STTS_NM);
            if (statusCd === "ACTIVE") return badge("badge-contract-active", statusNm || "유효");
            if (statusCd === "END") return badge("badge-contract-end", statusNm || "종료");
            return statusNm ? badge("badge-blue", statusNm) : "";
        }
        function getResultFacility(result) { var d = result || {}; return d.detail || d.facility || d; }
        function getFileImageUrl(file) { var f = file || {}; if (f.viewUrl) return f.viewUrl; if (f.fileUrl) return f.fileUrl; if (f.googleId) return contextPath + "/file/display/" + encodeURIComponent(f.googleId); return ""; }
        function getCsrfHeaders() { var tokenMeta = document.querySelector('meta[name="_csrf"]'); var headerMeta = document.querySelector('meta[name="_csrf_header"]'); var headers = {}; if (tokenMeta && headerMeta) headers[headerMeta.content] = tokenMeta.content; return headers; }
        async function getJson(url) { var response = await fetch(url, { method:"GET", headers:getCsrfHeaders() }); var data = await response.json(); if (!response.ok || data.success === false) throw new Error(data.message || "요청 처리 중 오류가 발생했습니다."); return data; }

        window.openFacilityImagePreview = function (imgSrc) { var modal = document.getElementById("imagePreviewModal"); var largeImg = document.getElementById("imagePreviewLargeImg"); if (!modal || !largeImg || !imgSrc) return; largeImg.src = imgSrc; modal.classList.add("is-open"); };
        window.closeFacilityImagePreview = function () { var modal = document.getElementById("imagePreviewModal"); var largeImg = document.getElementById("imagePreviewLargeImg"); if (!modal || !largeImg) return; modal.classList.remove("is-open"); largeImg.src = ""; };
        function bindImagePreviewModal() { var modal = document.getElementById("imagePreviewModal"); var closeBtn = document.getElementById("imagePreviewCloseBtn"); if (!modal || !closeBtn) return; closeBtn.addEventListener("click", window.closeFacilityImagePreview); modal.addEventListener("click", function (e) { if (e.target === modal) window.closeFacilityImagePreview(); }); document.addEventListener("keydown", function (e) { if (e.key === "Escape") window.closeFacilityImagePreview(); }); }

        function renderDetailFiles(files) {
            var area = document.getElementById("detailFileList");
            if (!files || files.length === 0) { area.innerHTML = '<div class="file-preview-empty">등록된 사진이 없습니다.</div>'; return; }
            area.innerHTML = files.map(function (file) {
                var imgUrl = getFileImageUrl(file);
                var name = file.fileOgName || file.fileSaveUuid || "시설사진";
                var safeImgUrl = escapeHtml(imgUrl);
                var safeName = escapeHtml(name);
                var imgHtml = imgUrl ? '<img class="js-image-preview" src="' + safeImgUrl + '" alt="' + safeName + '" onclick="window.openFacilityImagePreview(this.src)">' : '';
                return '<div class="file-preview-item">' + imgHtml + '<div class="file-preview-name">' + safeName + '</div></div>';
            }).join("");
        }

        function formatContractPeriod(contract) {
            // 설치계약 요약 표시용 계약기간 문자열 생성
            var start = formatDate(contract && (contract.contBgngDt || contract.CONT_BGNG_DT));
            var end = formatDate(contract && (contract.contEndDt || contract.CONT_END_DT));
            if (start && end) return start + " ~ " + end;
            if (start) return start + " ~";
            if (end) return "~ " + end;
            return "";
        }

        function setText(id, value) { var el = document.getElementById(id); if (!el) return; el.textContent = value || "-"; }
        function setHtml(id, value) { var el = document.getElementById(id); if (!el) return; el.innerHTML = value || '<span class="detail-empty">-</span>'; }

        function renderInstallContract(contract) {
            // 설치 정보 영역에는 설치계약을 한 줄 요약으로만 표시
            // - 업체는 제외하고 계약번호·계약명·기간만 표시
            // - 라벨칩 대신 [계약번호] 같은 텍스트형 구분자를 사용
            var target = document.getElementById("installSummaryText");
            if (!target) return;

            var data = contract || {};
            var contractNo = data.contNo || data.CONT_NO || "";
            var contractNm = data.contNm || data.CONT_NM || "";
            var period = formatContractPeriod(data);
            var html = [];

            var statusBadge = contractStatusBadge(data);
            if (statusBadge) {
                html.push(statusBadge);
            }

            if (contractNo) {
                html.push('<span class="install-tag">[계약번호]</span> ' + escapeHtml(contractNo));
            }

            if (contractNm) {
                html.push('<span class="install-tag">[계약명]</span> ' + escapeHtml(contractNm));
            }

            if (period) {
                html.push('<span class="install-tag">[기간]</span> ' + escapeHtml(period));
            }

            if (html.length === 0) {
                target.textContent = "연결된 설치계약이 없습니다.";
                target.classList.add("install-line-empty");
                return;
            }

            target.innerHTML = html.join(' <span class="install-separator">·</span> ');
            target.classList.remove("install-line-empty");
        }

        function renderRelatedHistory(historyList) {
            var area = document.getElementById("detailHistoryBody");
            if (!historyList || historyList.length === 0) { area.innerHTML = '<div class="ds-empty">최근 점검·보수 이력이 없습니다.</div>'; return; }
            area.innerHTML = historyList.slice(0, 3).map(function (history) {
                /* 작업명은 별도 컬럼이 없으므로 점검유형명(chkTyNm)을 사용 */
                var historyNo = escapeHtml(history.facChkHstryNo || history.facChkHistNo || "-");
                var type = escapeHtml(history.chkTyNm || history.chkTyCd || "점검");
                var status = escapeHtml(history.chkSttsNm || history.chkSttsCd || "-");
                var content = escapeHtml(history.chkCn || "-");
                var date = escapeHtml(formatDate(history.chkDt) || "-");
                var restrictYn = history.useRestrictYn === "Y";
                var restrictPeriod = formatRestrictPeriod(history.useRestrictBgngDt, history.useRestrictEndDt);
                var restrictHtml = restrictYn
                    ? '<div class="ds-restrict"><span class="material-symbols-rounded">block</span><span>이용제한 ' + escapeHtml(restrictPeriod || "시간 미지정") + '</span></div>'
                    : '';

                return ''
                    + '<div class="ds-row">'
                    + '    <div class="ds-head">'
                    + '        <span class="ds-no">' + historyNo + '</span>'
                    + '        <span class="ds-type">' + type + '</span>'
                    + '        <span class="ds-status">' + status + '</span>'
                    +          (restrictYn ? badge("badge-restrict", "이용제한") : '')
                    + '        <span class="ds-dt">' + date + '</span>'
                    + '    </div>'
                    + '    <div class="ds-nm">' + content + '</div>'
                    +      restrictHtml
                    + '</div>';
            }).join("");
        }

        function renderFacilityInfo(facility) {
            /* 시설유형 표시값 */
            var facilityTypeText = facility.facilityTyNm || facility.facilityTyCd || "-";

            /* 시설 기본정보 값 주입 */
            setText("detailFacilityNo", facility.facilityNo);
            setText("detailFacilityNm", facility.facilityNm);
            setHtml("detailFacilityTyNm", badge("badge-blue", facilityTypeText));
            setHtml("detailUseYn", useYnBadge(facility.useYn));

            /* 현재 점검상태 영역 렌더링 */
            renderCurrentCheckStatus(facility);
        }

        /**
         * 현재 점검상태 렌더링
         * - 활성여부와 점검 이용제한을 분리하여 표시
         * - 현재 시간이 이용제한 시작~종료 사이이면 이용제한중으로 표시
         */
        function renderCurrentCheckStatus(facility) {
            /* 현재 점검상태 박스 */
            var box = document.getElementById("detailCurrentCheckBox");

            /* 현재 점검상태 본문 */
            var target = document.getElementById("detailCurrentCheckStatus");

            /* 현재 점검상태 아이콘 */
            var icon = box ? box.querySelector(".check-status-icon .material-symbols-rounded") : null;

            /* 현재 이용제한 여부 */
            var isRestricted = facility.currentRestrictYn === "Y" || facility.facilityDisplayStatus === "이용제한중";

            /* 제한일시 표시값 */
            var restrictPeriod = formatRestrictPeriod(facility.currentRestrictBgngDt, facility.currentRestrictEndDt);

            /* 대상 요소 없음 방어 */
            if (!box || !target) {
                return;
            }

            /* 이용제한중 표시 */
            if (isRestricted) {
                box.classList.add("is-restricted");
                if (icon) icon.textContent = "block";

                target.innerHTML = ''
                    + '<div class="check-status-head">'
                    +      badge("badge-restrict", "이용제한중")
                    +      (restrictPeriod ? '<span class="check-status-period">' + escapeHtml(restrictPeriod) + '</span>' : '')
                    + '</div>'
                    + '<div class="check-status-desc">' + escapeHtml(facility.currentRestrictReason || "점검으로 인한 이용제한이 진행 중입니다.") + '</div>';
                return;
            }

            /* 제한없음 표시 */
            box.classList.remove("is-restricted");
            if (icon) icon.textContent = "check_circle";
            target.innerHTML = ''
                + '<div class="check-status-head">' + badge("badge-use-y", "제한 없음") + '</div>'
                + '<div class="check-status-desc">현재 진행 중인 이용제한 점검이 없습니다.</div>';
        }

        function renderLocationInfo(facility) {
            // 고정 항목은 JSP에 작성된 td id에 값만 주입
            setText("detailLocationType", facility.dongNo ? "동 위치" : "공용 위치");
            setText("detailDongNo", formatDongNo(facility.dongNo));
            setText("detailLocCn", facility.locCn);
            setText("detailInstlDt", formatDate(facility.instlDt));
        }

        function renderDisabledNotice(facility) {
            var section = document.getElementById("detailDisabledSection");
            var reason = document.getElementById("detailDisabledReason");
            if (facility.useYn !== "N") { section.style.display = "none"; reason.innerHTML = ""; return; }
            section.style.display = "flex";
            reason.innerHTML = "이 시설은 현재 <strong>비활성</strong> 상태입니다. 기존 점검·계약·검침 연결 정보는 유지됩니다.";
        }

        /* 편의시설 운영정보 연결 상태 표시 — facilityEdit의 cmn-ref-box와 동일한 방식 */
        function renderPublicFacilityNotice(facility) {
            var section = document.getElementById("publicFacilitySection");
            var photoTitle = document.getElementById("detailPhotoSectionTitle");
            if (!section) return;
            var isPublicFacility = facility.facilityKind === "PUBLIC";
            section.style.display = isPublicFacility ? "" : "none";
            if (photoTitle) photoTitle.textContent = isPublicFacility ? "편의시설 사진" : "시설 사진";
            if (!isPublicFacility) return;

            var cmnNo = facility.cmnFacilityNo || "";
            var cmnNm = facility.cmnFacilityNm || "";
            var refBox = document.getElementById("cmnRefBox");
            var refEmpty = document.getElementById("cmnRefEmpty");
            if (cmnNo) {
                document.getElementById("cmnRefText").textContent = cmnNo + (cmnNm ? " · " + cmnNm : "");
                document.getElementById("cmnDetailLink").href = contextPath + "/manager/publicFacility/detail-page/" + encodeURIComponent(mgmtOfcNo) + "/" + encodeURIComponent(cmnNo);
                refBox.style.display = "";
                refEmpty.style.display = "none";
            } else {
                refBox.style.display = "none";
                refEmpty.style.display = "";
            }
        }

        function bindEditButton(facility) {
            var editBtn = document.getElementById("detailEditBtnTop");
            if (!editBtn || isAdmin) return;
            editBtn.textContent = "수정";
            editBtn.onclick = function () { location.href = contextPath + "/manager/facility/update-page/" + encodeURIComponent(mgmtOfcNo) + "/" + encodeURIComponent(facility.facilityNo); };
        }


        function bindHistoryMoreLink() {
            // 최근 점검·보수 이력 전체보기 링크에 현재 시설번호를 검색 파라미터로 붙임
            var link = document.getElementById("historyMoreLink");
            if (!link) return;

            link.href = contextPath
                + "/manager/checkHistory/"
                + encodeURIComponent(mgmtOfcNo)
                + "?facilityNo="
                + encodeURIComponent(facilityNo);
        }

        function renderDetail(result) {
            var facility = getResultFacility(result);
            document.getElementById("detailModalTitle").textContent = "시설 상세";
            renderDisabledNotice(facility);
            renderFacilityInfo(facility);
            renderLocationInfo(facility);
            renderDetailFiles(result.fileList || result.attachFileList || facility.fileList || []);
            renderInstallContract(result.installContract || result.latestContract || null);
            renderRelatedHistory(result.recentHistoryList || result.recentCheckList || []);
            renderPublicFacilityNotice(facility);
            bindEditButton(facility);
        }

        document.addEventListener("DOMContentLoaded", function () {
            bindImagePreviewModal();
            bindHistoryMoreLink();
            document.getElementById("backToListBtnTop").addEventListener("click", function () { location.href = listUrl(); });
            getJson(apiUrl("detail/" + encodeURIComponent(mgmtOfcNo) + "/" + encodeURIComponent(facilityNo)))
                .then(renderDetail)
                .catch(function (err) { console.error(err); alertMessage(err.message || "상세 정보를 불러오지 못했습니다."); });
        });
    })();
</script>

<%-- 사이드바/헤더 현재 위치 설정 --%>
<c:set var="activeSidebarHref" value="${pageContext.request.contextPath}/manager/facility/page/${mgmtOfcNo}" />
<c:set var="activeSidebarParent" value="시설·공사 관리" />
<c:set var="activeSidebarCurrent" value="시설 상세" />
<%@ include file="/WEB-INF/views/include/office_active_sidebar.jspf" %>
</body>
</html>
