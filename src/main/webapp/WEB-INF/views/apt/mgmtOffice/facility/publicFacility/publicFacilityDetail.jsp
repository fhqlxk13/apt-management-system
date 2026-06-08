<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>편의시설 상세</title>
    <sec:csrfMetaTags/>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/office-layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/manager-common.css">
    <style>
        #publicFacilityDetailPage { --accent:#2e5c38; --accent-hover:#1f4027; --accent-light:#e8f0ea; --accent-dim:rgba(46,92,56,.08); --surface:#ffffff; --surface-sub:#f8f9fb; --line:#d7dce2; --th-bg:#f3f5f3; --text-pri:#1a1f1b; --text-sec:#4a5c4e; --text-ter:#8a9a8e; }
        #publicFacilityDetailPage .page-title-block h2 { margin:0; color:var(--text-pri); font-size:19px; font-weight:700; letter-spacing:-.5px; }
        #publicFacilityDetailPage .page-title-block p { margin-top:6px; color:var(--text-sec); font-size:12px; font-weight:400; }
        #publicFacilityDetailPage .panel { border-radius:6px; border:1px solid var(--line); box-shadow:none; margin:0; }
        #publicFacilityDetailPage .panel-header { display:flex; align-items:center; justify-content:space-between; padding:13px 16px; border-bottom:1px solid var(--line); background:var(--surface); border-radius:6px 6px 0 0; }
        #publicFacilityDetailPage .panel-title { display:flex; align-items:center; gap:6px; margin:0; font-size:13px; font-weight:600; color:var(--text-pri); }
        #publicFacilityDetailPage .panel-title .material-symbols-rounded { font-size:17px; color:var(--accent); }
        #publicFacilityDetailPage .panel-body { padding:14px 16px 16px; background:var(--surface); }
        #publicFacilityDetailPage .btn { border-radius:4px; font-size:12px; font-weight:500; }
        #publicFacilityDetailPage .btn-primary { background:var(--accent); border-color:var(--accent); }
        #publicFacilityDetailPage .btn-primary:hover { background:var(--accent-hover); border-color:var(--accent-hover); }
        #publicFacilityDetailPage .facility-modal-cols { display:grid; grid-template-columns:1fr 1fr; gap:0; }
        #publicFacilityDetailPage .facility-modal-col-left { padding-right:20px; border-right:1px solid var(--line); }
        #publicFacilityDetailPage .facility-modal-col-right { padding-left:20px; }
        #publicFacilityDetailPage .detail-section { margin-bottom:14px; }
        #publicFacilityDetailPage .detail-section:last-child { margin-bottom:0; }
        #publicFacilityDetailPage .detail-section-title { display:flex; align-items:center; gap:5px; margin:0 0 10px; padding-bottom:8px; border-bottom:1px solid var(--line); color:var(--text-sec); font-size:12px; font-weight:600; }
        #publicFacilityDetailPage .detail-section-title .material-symbols-rounded { font-size:16px; color:var(--accent); }
        #publicFacilityDetailPage .asset-ref-box { display:flex; align-items:center; justify-content:space-between; gap:12px; min-height:42px; padding:10px 12px; border:1px solid var(--line); border-radius:4px; background:#f6f7f8; }
        #publicFacilityDetailPage .asset-ref-main { min-width:0; display:flex; align-items:center; gap:7px; color:var(--text-sec); font-size:12px; font-weight:400; line-height:1.45; white-space:nowrap; overflow:hidden; }
        #publicFacilityDetailPage .asset-ref-main .material-symbols-rounded { font-size:16px; color:#9aa5a0; flex-shrink:0; }
        #publicFacilityDetailPage .asset-ref-text { display:block; min-width:0; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }
        #publicFacilityDetailPage .asset-ref-link { flex-shrink:0; display:inline-flex; align-items:center; gap:3px; color:var(--accent); font-size:11px; font-weight:500; text-decoration:none; }
        #publicFacilityDetailPage .asset-ref-link:hover { color:var(--accent-hover); }
        #publicFacilityDetailPage .asset-ref-link .material-symbols-rounded { font-size:13px; }
        #publicFacilityDetailPage .detail-table { width:100%; border-top:1px solid var(--line); border-collapse:collapse; table-layout:fixed; }
        #publicFacilityDetailPage .detail-table th { width:96px; padding:10px 11px; border-bottom:1px solid var(--line); background:var(--th-bg); color:var(--text-sec); font-size:12px; font-weight:500; text-align:left; vertical-align:middle; }
        #publicFacilityDetailPage .detail-table td { padding:10px 12px; border-bottom:1px solid var(--line); color:var(--text-pri); font-size:12px; font-weight:400; vertical-align:middle; word-break:break-all; }
        #publicFacilityDetailPage .detail-table td.td-strong { font-weight:500; }
        #publicFacilityDetailPage .detail-empty { color:var(--text-ter); font-weight:400; }
        #publicFacilityDetailPage .form-textarea[readonly] { width:100%; box-sizing:border-box; padding:10px 12px; border:1px solid var(--line); border-radius:4px; background:var(--surface-sub); color:var(--text-pri); font-size:12px; font-weight:400; line-height:1.6; resize:none; opacity:1; cursor:default; }
        #publicFacilityDetailPage .badge { display:inline-flex; align-items:center; justify-content:center; min-height:21px; padding:0 8px; border-radius:4px; font-size:11px; font-weight:500; line-height:1; border:1px solid transparent; }
        #publicFacilityDetailPage .badge-use-y { background:#dceee0; color:#1f7a3f; border-color:#c7e4cf; }
        #publicFacilityDetailPage .badge-use-y::before { content:""; width:6px; height:6px; margin-right:5px; border-radius:50%; background:#22c55e; }
        #publicFacilityDetailPage .badge-use-n { background:#fee2e2; color:#b42318; border-color:#fecaca; }
        #publicFacilityDetailPage .badge-use-n::before { content:""; width:6px; height:6px; margin-right:5px; border-radius:50%; background:#ef4444; }
        #publicFacilityDetailPage .badge-soft { background:#eef3f0; color:var(--text-sec); border-color:#dce4df; }
        #publicFacilityDetailPage .disabled-notice { display:flex; align-items:flex-start; gap:10px; margin-bottom:14px; padding:11px 13px; border:1px solid #fed7aa; border-left:3px solid #f59e0b; border-radius:0 4px 4px 0; background:#fff7ed; color:#7c2d12; font-size:12px; font-weight:400; line-height:1.6; }
        #publicFacilityDetailPage .disabled-notice .material-symbols-rounded { color:#f59e0b; font-size:18px; flex-shrink:0; margin-top:1px; }
        #publicFacilityDetailPage .img-grid { display:grid; grid-template-columns:1fr 1fr; gap:8px; }
        #publicFacilityDetailPage .img-cell { aspect-ratio:4/3; border-radius:6px; overflow:hidden; border:1px solid var(--line); background:var(--surface-sub); display:flex; align-items:center; justify-content:center; }
        #publicFacilityDetailPage .img-cell img { width:100%; height:100%; object-fit:cover; cursor:zoom-in; }
        #publicFacilityDetailPage .img-empty { grid-column:1/-1; padding:20px 0; font-size:12px; font-weight:400; color:var(--text-ter); text-align:center; }
        #publicFacilityDetailPage .item-count { text-align:right; font-size:11px; font-weight:400; color:var(--text-ter); margin-bottom:6px; }
        #publicFacilityDetailPage .item-count strong { color:var(--text-sec); font-weight:500; }
        #publicFacilityDetailPage .item-table-wrap { border:1px solid var(--line); border-radius:4px; overflow:hidden; }
        #publicFacilityDetailPage .item-table { width:100%; border-collapse:collapse; table-layout:fixed; }
        #publicFacilityDetailPage .item-table th { padding:8px 10px; border-bottom:1px solid var(--line); font-size:11px; font-weight:500; color:var(--text-sec); text-align:left; background:var(--surface-sub); }
        #publicFacilityDetailPage .item-table td { padding:9px 10px; border-bottom:1px solid var(--line); font-size:12px; font-weight:400; color:var(--text-pri); vertical-align:middle; }
        #publicFacilityDetailPage .item-table tbody tr:last-child td { border-bottom:none; }
        #publicFacilityDetailPage .item-empty { text-align:center; color:var(--text-ter); padding:16px 0; }
        #publicFacilityDetailPage .th-name { text-align:left; }
        #publicFacilityDetailPage .td-center { text-align:center; white-space:nowrap; }
        #publicFacilityDetailPage .td-name { overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }
        #publicFacilityDetailPage .col-div { width:1px; min-width:1px; max-width:1px; padding:0 !important; background:var(--line) !important; border-left:1px solid var(--line); border-right:none; }
        #publicFacilityDetailPage .col-div-spacer { width:10px; min-width:10px; max-width:10px; padding:0 !important; background:#fff; border-left:none; border-right:none; }
        #publicFacilityDetailPage .item-table thead .col-div { background:var(--line) !important; border-bottom:1px solid var(--line); }
        #publicFacilityDetailPage .item-table thead .col-div-spacer { background:var(--surface-sub); border-bottom:1px solid var(--line); }
        #publicFacilityDetailPage .item-scroll-wrap { max-height:200px; overflow-y:auto; }
        #publicFacilityDetailPage .item-scroll-wrap::-webkit-scrollbar { width:4px; }
        #publicFacilityDetailPage .item-scroll-wrap::-webkit-scrollbar-track { background:transparent; }
        #publicFacilityDetailPage .item-scroll-wrap::-webkit-scrollbar-thumb { background:var(--line); border-radius:2px; }
        #publicFacilityDetailPage .stts { display:inline-flex; align-items:center; gap:5px; font-size:12px; font-weight:400; }
        #publicFacilityDetailPage .stts-dot { width:6px; height:6px; border-radius:50%; flex-shrink:0; }
        #publicFacilityDetailPage .stts-open .stts-dot { background:#22c55e; }
        #publicFacilityDetailPage .stts-open .stts-txt { color:#1f7a3f; }
        #publicFacilityDetailPage .stts-use .stts-dot { background:#3b82f6; }
        #publicFacilityDetailPage .stts-use .stts-txt { color:#1e3a5f; }
        #publicFacilityDetailPage .stts-repair .stts-dot { background:#eab308; }
        #publicFacilityDetailPage .stts-repair .stts-txt { color:#854d0e; }
        #publicFacilityDetailPage .stts-close .stts-dot { background:#ef4444; }
        #publicFacilityDetailPage .stts-close .stts-txt { color:#b42318; }
        @media (max-width:760px) {
            #publicFacilityDetailPage .facility-modal-cols { grid-template-columns:1fr; }
            #publicFacilityDetailPage .facility-modal-col-left { padding-right:0; border-right:none; border-bottom:1px solid var(--line); padding-bottom:16px; margin-bottom:16px; }
            #publicFacilityDetailPage .facility-modal-col-right { padding-left:0; }
            #publicFacilityDetailPage .asset-ref-box { align-items:flex-start; flex-direction:column; }
        }
    </style>
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
            <div class="office-page" id="publicFacilityDetailPage">

                <div class="page-header">
                    <div class="page-title-block">
                        <h2>편의시설 상세</h2>
                        <p>시설자산과 편의시설 운영정보를 확인합니다.</p>
                    </div>
                </div>

                <div class="panel">
                    <div class="panel-header">
                        <h3 class="panel-title">
                            <span class="material-symbols-rounded">info</span>
                            편의시설 정보
                        </h3>
                    </div>

                    <div class="panel-body">

                        <c:if test="${detail.useYn eq 'N'}">
                            <div class="disabled-notice">
                                <span class="material-symbols-rounded">warning</span>
                                <div>이 시설은 현재 <strong>비활성</strong> 상태입니다.</div>
                            </div>
                        </c:if>

                        <div class="facility-modal-cols">

                            <div class="facility-modal-col-left">

                                <div class="detail-section">
                                    <h3 class="detail-section-title">
                                        <span class="material-symbols-rounded">apartment</span>
                                        연결된 시설자산
                                    </h3>
                                    <div class="asset-ref-box">
                                        <div class="asset-ref-main">
                                            <span class="material-symbols-rounded">link</span>
                                            <span class="asset-ref-text"
                                                  title="${empty detail.facilityNo ? '-' : detail.facilityNo} · ${empty detail.facilityNm ? (empty detail.cmnFacilityNm ? '-' : detail.cmnFacilityNm) : detail.facilityNm} · ${empty detail.dongNo ? '공용 위치' : (fn:contains(detail.dongNo, '_') ? fn:substringAfter(detail.dongNo, '_') : detail.dongNo)}${empty detail.dongNo ? '' : '동'} · ${empty detail.locCn ? '-' : detail.locCn}">
                                                ${empty detail.facilityNo ? '-' : detail.facilityNo}
                                                · ${empty detail.facilityNm ? (empty detail.cmnFacilityNm ? '-' : detail.cmnFacilityNm) : detail.facilityNm}
                                                · ${empty detail.dongNo ? '공용 위치' : (fn:contains(detail.dongNo, '_') ? fn:substringAfter(detail.dongNo, '_') : detail.dongNo)}${empty detail.dongNo ? '' : '동'}
                                                · ${empty detail.locCn ? '-' : detail.locCn}
                                            </span>
                                        </div>
                                        <c:if test="${not empty detail.facilityNo}">
                                            <a href="${pageContext.request.contextPath}/manager/facility/detail-page/${mgmtOfcNo}/${detail.facilityNo}"
                                               class="asset-ref-link">
                                                시설 상세
                                                <span class="material-symbols-rounded">arrow_forward</span>
                                            </a>
                                        </c:if>
                                    </div>
                                </div>

                                <div class="detail-section">
                                    <h3 class="detail-section-title">
                                        <span class="material-symbols-rounded">meeting_room</span>
                                        편의시설 운영정보
                                    </h3>
                                    <table class="detail-table">
                                        <tbody>
                                        <tr>
                                            <th>편의시설번호</th>
                                            <td>${empty detail.cmnFacilityNo ? '<span class="detail-empty">-</span>' : detail.cmnFacilityNo}</td>
                                            <th>편의시설명</th>
                                            <td class="td-strong">${empty detail.cmnFacilityNm ? '<span class="detail-empty">-</span>' : detail.cmnFacilityNm}</td>
                                        </tr>
                                        <tr>
                                            <th>예약여부</th>
                                            <td>
                                                <span class="badge badge-soft">
                                                    ${detail.cmnFacilityRsvYn eq 'Y' ? '예약제' : detail.cmnFacilityRsvYn eq 'N' ? '자유이용' : '-'}
                                                </span>
                                            </td>
                                            <th>이용요금</th>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${empty detail.cmnFacilityAmt or detail.cmnFacilityAmt == 0}">무료</c:when>
                                                    <c:otherwise><fmt:formatNumber value="${detail.cmnFacilityAmt}" pattern="#,###" />원</c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th>운영시간</th>
                                            <td colspan="3">${empty detail.cmnFacilityOprHr ? '<span class="detail-empty">-</span>' : detail.cmnFacilityOprHr}</td>
                                        </tr>
                                        <tr>
                                            <th>등록일자</th>
                                            <td>${empty detail.regDt ? '<span class="detail-empty">-</span>' : fn:substring(detail.regDt, 0, 10)}</td>
                                            <th>수정일자</th>
                                            <td>${empty detail.mdfDt ? '<span class="detail-empty">-</span>' : fn:substring(detail.mdfDt, 0, 10)}</td>
                                        </tr>
                                        <tr>
                                            <th>활성여부</th>
                                            <td colspan="3">
                                                <c:choose>
                                                    <c:when test="${detail.useYn eq 'N'}"><span class="badge badge-use-n">비활성</span></c:when>
                                                    <c:otherwise><span class="badge badge-use-y">활성</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                        </tbody>
                                    </table>
                                </div>

                                <div class="detail-section">
                                    <h3 class="detail-section-title">
                                        <span class="material-symbols-rounded">description</span>
                                        시설 안내/비고
                                    </h3>
                                    <textarea class="form-textarea" rows="4" readonly>${empty detail.cmnFacilityCn ? '-' : detail.cmnFacilityCn}</textarea>
                                </div>
                            </div>

                            <div class="facility-modal-col-right">

                                <div class="detail-section">
                                    <h3 class="detail-section-title">
                                        <span class="material-symbols-rounded">photo_library</span>
                                        편의시설 사진
                                    </h3>
                                    <div class="img-grid" id="dtlImgGrid">
                                        <c:choose>
                                            <c:when test="${not empty fileList}">
                                                <c:forEach var="file" items="${fileList}">
                                                    <div class="img-cell">
                                                        <c:choose>
                                                            <c:when test="${not empty file.googleId}">
                                                                <%-- js-image-preview 클래스 추가: CommonImageViewer.bind가 이 클래스를 기준으로 클릭 이벤트를 연결 --%>
                                                                <img class="js-image-preview"
                                                                     src="${pageContext.request.contextPath}/file/display/${file.googleId}"
                                                                     alt="${file.fileOgName}">
                                                            </c:when>
                                                            <c:otherwise>
                                                                <div class="img-empty">이미지를 표시할 수 없습니다.</div>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="img-empty">등록된 사진이 없습니다.</div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>

                                <div class="detail-section">
                                    <h3 class="detail-section-title">
                                        <span class="material-symbols-rounded">inventory_2</span>
                                        편의시설 자원 목록
                                    </h3>
                                    <div class="item-count">
                                        전체 <strong>${fn:length(itemList)}</strong>개
                                    </div>
                                    <div class="item-table-wrap">
                                        <table class="item-table">
                                            <colgroup>
                                                <col style="width:100px"><col><col style="width:90px">
                                                <col class="col-div"><col class="col-div-spacer">
                                                <col style="width:100px"><col><col style="width:90px">
                                            </colgroup>
                                            <thead>
                                            <tr>
                                                <th>자원번호</th>
                                                <th class="th-name">자원명</th>
                                                <th class="td-center">상태</th>
                                                <th class="col-div"></th>
                                                <th class="col-div-spacer"></th>
                                                <th>자원번호</th>
                                                <th class="th-name">자원명</th>
                                                <th class="td-center">상태</th>
                                            </tr>
                                            </thead>
                                        </table>
                                        <div class="item-scroll-wrap">
                                            <table class="item-table">
                                                <colgroup>
                                                    <col style="width:100px"><col><col style="width:90px">
                                                    <col class="col-div"><col class="col-div-spacer">
                                                    <col style="width:100px"><col><col style="width:90px">
                                                </colgroup>
                                                <tbody id="dtlItemBody">
                                                <c:choose>
                                                    <c:when test="${not empty itemList}">
                                                        <c:forEach var="item" items="${itemList}" varStatus="vs">
                                                            <c:if test="${vs.index % 2 == 0}"><tr></c:if>
                                                            <c:if test="${vs.index % 2 == 1}">
                                                                <td class="col-div"></td>
                                                                <td class="col-div-spacer"></td>
                                                            </c:if>
                                                            <td class="td-center" style="color:var(--text-sec);">${item.cmnFacilityItemNo}</td>
                                                            <td class="td-name">${item.itemNm}</td>
                                                            <td class="td-center">
                                                                <c:choose>
                                                                    <c:when test="${item.cmnFacilitySttsCd eq 'OPEN'}"><span class="stts stts-open"><span class="stts-dot"></span><span class="stts-txt">사용가능</span></span></c:when>
                                                                    <c:when test="${item.cmnFacilitySttsCd eq 'USE'}"><span class="stts stts-use"><span class="stts-dot"></span><span class="stts-txt">사용중</span></span></c:when>
                                                                    <c:when test="${item.cmnFacilitySttsCd eq 'REPAIR'}"><span class="stts stts-repair"><span class="stts-dot"></span><span class="stts-txt">점검중</span></span></c:when>
                                                                    <c:when test="${item.cmnFacilitySttsCd eq 'CLOSE'}"><span class="stts stts-close"><span class="stts-dot"></span><span class="stts-txt">사용중지</span></span></c:when>
                                                                    <c:otherwise><span class="stts"><span class="stts-dot" style="background:var(--text-ter);"></span><span class="stts-txt" style="color:var(--text-ter);">${item.cmnFacilitySttsCd}</span></span></c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <c:if test="${vs.index % 2 == 0 && vs.last}">
                                                                <td class="col-div"></td>
                                                                <td class="col-div-spacer"></td>
                                                                <td></td><td></td><td></td>
                                                            </c:if>
                                                            <c:if test="${vs.index % 2 == 1 || vs.last}"></tr></c:if>
                                                        </c:forEach>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <tr id="emptyRow">
                                                            <td class="item-empty" colspan="8">등록된 자원이 없습니다.</td>
                                                        </tr>
                                                    </c:otherwise>
                                                </c:choose>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>

                            </div>
                        </div>
                    </div>
                </div>

                <div class="page-actions" style="justify-content:flex-end; margin-top:14px;">
                    <button type="button" class="btn btn-secondary" id="backToListBtn">목록</button>
                    <sec:authorize access="!hasRole('ADMIN')">
                        <button type="button" class="btn btn-primary" id="detailEditBtn">수정</button>
                    </sec:authorize>
                </div>

            </div>
        </main>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/manager/manager-common.js"></script>
<script src="${pageContext.request.contextPath}/js/manager/common-image-viewer.js"></script>
<script>
    (function () {
        var contextPath   = "${pageContext.request.contextPath}";
        var mgmtOfcNo     = "${mgmtOfcNo}";
        var cmnFacilityNo = "${detail.cmnFacilityNo}";

        document.addEventListener("DOMContentLoaded", function () {

            var backBtn = document.getElementById("backToListBtn");
            if (backBtn) {
                backBtn.addEventListener("click", function () {
                    location.href = contextPath + "/manager/publicFacility/page/" + encodeURIComponent(mgmtOfcNo);
                });
            }

            var editBtn = document.getElementById("detailEditBtn");
            if (editBtn) {
                editBtn.addEventListener("click", function () {
                    location.href = contextPath + "/manager/publicFacility/update-page/"
                        + encodeURIComponent(mgmtOfcNo) + "/" + encodeURIComponent(cmnFacilityNo);
                });
            }

            /* 공통 이미지 확대 모듈  */
            if (window.CommonImageViewer && typeof window.CommonImageViewer.bind === "function") {
                window.CommonImageViewer.bind("#dtlImgGrid");
            }
        });
    })();
</script>
</body>
</html>
