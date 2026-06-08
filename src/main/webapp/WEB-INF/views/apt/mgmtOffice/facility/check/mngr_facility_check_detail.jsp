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
    <title>시설 점검 이력 상세</title>

    <sec:csrfMetaTags/>

    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet" />

    <link rel="stylesheet" href="${ctx}/css/office-layout.css">
    <link rel="stylesheet" href="${ctx}/css/manager/manager-common.css">

    <style>
        #chkDetailPage { --accent:#2e5c38; --accent-hover:#1f4027; --accent-light:#e8f0ea; --surface:#fff; --line:#d7dce2; --th-bg:#f4f6f4; --soft:#f8faf8; --text-head:#1a2e1e; --text-sub:#6b7a6e; --text-ter:#9ca3af; }
        #chkDetailPage .page-title-block h2 { color:var(--text-head); font-size:20px; letter-spacing:-.5px; margin:0; }
        #chkDetailPage .page-title-block p { color:var(--text-sub); font-size:12px; margin-top:6px; }

        /* 공통 패널 */
        #chkDetailPage .panel { border:1px solid var(--line); border-radius:8px; background:var(--surface); overflow:hidden; margin:0; }
        #chkDetailPage .panel + .panel { margin-top:14px; }
        #chkDetailPage .panel-body { padding:18px 22px; }

        /* 섹션 제목 */
        #chkDetailPage .section-title { display:flex; align-items:center; gap:6px; margin:0 0 12px; padding-bottom:10px; border-bottom:1px solid var(--line); font-size:13px; font-weight:800; color:var(--text-head); }
        #chkDetailPage .section-title .material-symbols-rounded { font-size:17px; color:var(--accent); }
        #chkDetailPage .section-title .title-sub { margin-left:auto; color:var(--text-ter); font-size:11px; font-weight:400; }

        /* 대상 정보: 시설/협력업체 분리 + 각 카드 내부 2열 압축 */
        #chkDetailPage .target-grid { display:grid; grid-template-columns:1fr 1fr; gap:14px; }
        #chkDetailPage .target-card { border:1px solid var(--line); border-radius:6px; overflow:hidden; background:#fff; }
        #chkDetailPage .target-head { display:flex; align-items:center; justify-content:space-between; gap:10px; min-height:38px; padding:0 12px; border-bottom:1px solid var(--line); background:var(--soft); }
        #chkDetailPage .target-title { display:flex; align-items:center; gap:6px; color:var(--text-head); font-size:12px; font-weight:800; }
        #chkDetailPage .target-title .material-symbols-rounded { color:var(--accent); font-size:16px; }
        #chkDetailPage .target-link { display:inline-flex; align-items:center; gap:2px; color:var(--accent); font-size:11px; font-weight:700; text-decoration:none; white-space:nowrap; }
        #chkDetailPage .target-link:hover { color:var(--accent-hover); text-decoration:underline; }
        #chkDetailPage .target-link .material-symbols-rounded { font-size:14px; }

        #chkDetailPage .info-compact { width:100%; border-collapse:collapse; table-layout:fixed; }
        #chkDetailPage .info-compact th { width:74px; height:39px; padding:0 10px; border-right:1px solid var(--line); border-bottom:1px solid var(--line); background:var(--th-bg); color:#27382b; font-size:11px; font-weight:800; text-align:left; vertical-align:middle; white-space:nowrap; }
        #chkDetailPage .info-compact td { height:39px; padding:0 12px; border-right:1px solid var(--line); border-bottom:1px solid var(--line); color:#111827; font-size:12px; font-weight:600; vertical-align:middle; word-break:break-word; }
        #chkDetailPage .info-compact th:nth-child(3) { border-left:1px solid var(--line); }
        #chkDetailPage .info-compact td:last-child { border-right:none; }
        #chkDetailPage .info-compact tr:last-child th,
        #chkDetailPage .info-compact tr:last-child td { border-bottom:none; }
        #chkDetailPage .info-compact .mono { font-family:'Consolas','SF Mono',monospace; color:#6b7280; font-size:11px; font-weight:500; }
        #chkDetailPage .info-compact .ellipsis { display:block; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }
        #chkDetailPage .detail-empty { color:var(--text-ter); font-weight:400; }

        /* 본문: 왼쪽 이력 / 오른쪽 현재 점검 결과 */
        #chkDetailPage .detail-split { display:grid; grid-template-columns:42% minmax(0,1fr); gap:14px; }
        #chkDetailPage .split-panel { border:1px solid var(--line); border-radius:8px; background:#fff; overflow:hidden; }
        #chkDetailPage .split-head { display:flex; align-items:center; justify-content:space-between; min-height:42px; padding:0 14px; border-bottom:1px solid var(--line); background:var(--soft); }
        #chkDetailPage .split-title { display:flex; align-items:center; gap:6px; color:var(--text-head); font-size:13px; font-weight:800; }
        #chkDetailPage .split-title .material-symbols-rounded { color:var(--accent); font-size:17px; }
        #chkDetailPage .split-desc { color:var(--text-ter); font-size:11px; }

        /* 같은 시설 이력 */
        #chkDetailPage .history-list { padding:12px 14px; display:flex; flex-direction:column; gap:9px; }
        #chkDetailPage .history-item { display:grid; grid-template-columns:90px minmax(0,1fr); gap:10px; align-items:start; padding:10px 10px; border:1px solid var(--line); border-radius:6px; background:#fff; text-decoration:none; color:inherit; }
        #chkDetailPage .history-item.is-current { border-color:#bdd7c5; background:#f4fbf5; }
        #chkDetailPage .history-date { color:#111827; font-size:12px; font-weight:800; line-height:1.3; }
        #chkDetailPage .history-main { min-width:0; }
        #chkDetailPage .history-meta { display:flex; align-items:center; gap:6px; margin-bottom:5px; }
        #chkDetailPage .history-type { color:#39443d; font-size:12px; font-weight:800; }
        #chkDetailPage .history-partner { display:block; margin-bottom:4px; color:#6b7280; font-size:11px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }
        #chkDetailPage .history-content { display:block; color:#111827; font-size:12px; line-height:1.45; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }
        #chkDetailPage .sample-note { padding:0 14px 12px; color:var(--text-ter); font-size:11px; }

        /* 현재 점검 결과 */
        #chkDetailPage .result-body { padding:14px; }
        #chkDetailPage .result-summary { width:100%; border:1px solid var(--line); border-collapse:collapse; table-layout:fixed; border-radius:6px; overflow:hidden; margin-bottom:12px; }
        #chkDetailPage .result-summary th { height:34px; padding:0 11px; background:var(--th-bg); border-right:1px solid var(--line); border-bottom:1px solid var(--line); color:#27382b; font-size:11px; font-weight:800; text-align:left; }
        #chkDetailPage .result-summary td { height:39px; padding:0 11px; border-right:1px solid var(--line); color:#111827; font-size:12px; font-weight:700; }
        #chkDetailPage .result-summary th:last-child,
        #chkDetailPage .result-summary td:last-child { border-right:none; }
        #chkDetailPage .result-summary .mono { font-family:'Consolas','SF Mono',monospace; color:#6b7280; font-size:11px; font-weight:500; }

        #chkDetailPage .result-content { border:1px solid var(--line); border-radius:6px; overflow:hidden; }
        #chkDetailPage .result-content + .result-content { margin-top:10px; }
        #chkDetailPage .result-label { padding:8px 12px; background:var(--th-bg); border-bottom:1px solid var(--line); color:#27382b; font-size:11px; font-weight:800; }
        #chkDetailPage .result-text { min-height:92px; padding:12px; color:#111827; font-size:12px; line-height:1.65; white-space:pre-wrap; word-break:break-word; }
        #chkDetailPage .result-text.short { min-height:46px; }
        #chkDetailPage .audit-row { display:grid; grid-template-columns:1fr 1fr; gap:10px; margin-top:10px; }
        #chkDetailPage .audit-box { border:1px solid var(--line); border-radius:6px; overflow:hidden; }
        #chkDetailPage .audit-value { padding:10px 12px; color:#111827; font-size:12px; font-weight:700; }

        /* 배지 */
        #chkDetailPage .badge { display:inline-flex; align-items:center; justify-content:center; min-height:22px; padding:0 8px; border-radius:4px; font-size:11px; font-weight:800; border:1px solid transparent; white-space:nowrap; }
        #chkDetailPage .badge-wait { background:#f3f4f6; color:#4b5563; border-color:#d1d5db; }
        #chkDetailPage .badge-ing { background:#dbeafe; color:#1e3a5f; border-color:#bfdbfe; }
        #chkDetailPage .badge-done { background:#dceee0; color:#1f7a3f; border-color:#c7e4cf; }
        #chkDetailPage .badge-fault { background:#fee2e2; color:#b42318; border-color:#fecaca; }


        /* 상세 화면 좌측 이력: 간략 표 + 모달 상세보기 */
        #chkDetailPage .history-table-wrap { max-height:402px; overflow-y:auto; border:1px solid var(--line); border-radius:6px; background:#fff; }
        #chkDetailPage .history-table { width:100%; border-collapse:collapse; table-layout:fixed; }
        #chkDetailPage .history-table th { height:34px; padding:0 7px; border-bottom:1px solid var(--line); background:var(--th-bg); color:#4a5c4e; font-size:11px; font-weight:800; text-align:center; white-space:nowrap; }
        #chkDetailPage .history-table td { height:38px; padding:6px 7px; border-bottom:1px solid #eef1f3; color:#243027; font-size:11px; text-align:center; vertical-align:middle; }
        #chkDetailPage .history-table tr:last-child td { border-bottom:none; }
        #chkDetailPage .history-table .is-current td { font-weight:800; background:#f4fbf5; }
        #chkDetailPage .history-table .btn { min-height:26px; height:26px; padding:0 9px; font-size:11px; }

        /* 상세 모달 */
        #chkDetailPage .modal-overlay { display:none; position:fixed; inset:0; z-index:1000; align-items:center; justify-content:center; padding:24px; background:rgba(15,23,42,.35); box-sizing:border-box; }
        #chkDetailPage .modal-overlay.open,
        #chkDetailPage .modal-overlay.is-open { display:flex; }
        #chkDetailPage .modal { width:min(760px, 96vw); max-height:84vh; display:flex; flex-direction:column; background:#fff; border:1px solid var(--line); border-radius:8px; box-shadow:0 18px 45px rgba(15,23,42,.25); overflow:hidden; }
        #chkDetailPage .modal-header { display:flex; align-items:center; justify-content:space-between; padding:14px 16px; border-bottom:1px solid var(--line); }
        #chkDetailPage .modal-title { margin:0; color:var(--text-head); font-size:14px; font-weight:900; }
        #chkDetailPage .modal-close { border:0; background:transparent; cursor:pointer; color:#66736a; }
        #chkDetailPage .modal-body { padding:14px 16px; overflow:auto; }
        #chkDetailPage .modal-section { margin-bottom:16px; }
        #chkDetailPage .modal-section:last-child { margin-bottom:0; }
        #chkDetailPage .modal-section-title { display:flex; align-items:center; gap:6px; margin:0 0 8px; padding-bottom:7px; border-bottom:1px solid var(--line); color:var(--text-head); font-size:13px; font-weight:900; }
        #chkDetailPage .modal-section-title .material-symbols-rounded { color:var(--accent); font-size:16px; }
        #chkDetailPage .modal-section .info-compact { border:1px solid var(--line); border-radius:6px; overflow:hidden; }

        /* 버튼 */
        #chkDetailPage .btn { display:inline-flex; align-items:center; justify-content:center; gap:4px; min-height:34px; height:34px; padding:0 14px; border-radius:4px; border:1px solid var(--line); background:var(--surface); color:#39443d; font-size:12px; font-weight:700; cursor:pointer; text-decoration:none; box-sizing:border-box; }
        #chkDetailPage .btn:hover { background:#f4f7f4; }
        #chkDetailPage .btn-primary { background:var(--accent); border-color:var(--accent); color:#fff; }
        #chkDetailPage .btn-primary:hover { background:var(--accent-hover); border-color:var(--accent-hover); }
        #chkDetailPage .detail-actions { display:flex; justify-content:flex-end; gap:8px; margin-top:14px; }

        @media (max-width:1100px) {
            #chkDetailPage .target-grid,
            #chkDetailPage .detail-split,
            #chkDetailPage .audit-row { grid-template-columns:1fr; }
        }
        @media (max-width:760px) {
            #chkDetailPage .info-compact th,
            #chkDetailPage .info-compact td,
            #chkDetailPage .result-summary th,
            #chkDetailPage .result-summary td { display:block; width:100%; border-right:none; }
            #chkDetailPage .info-compact th:nth-child(3) { border-left:none; }
        }
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
            <div class="office-page" id="chkDetailPage">

                <div class="page-header">
                    <div class="page-title-block">
                        <h2>시설 점검 이력 상세</h2>
                        <p>대상 시설과 협력업체, 선택한 점검 결과와 누적 이력을 함께 확인합니다.</p>
                    </div>
                </div>

                <%-- 등록/수정 완료 알림 (flash 메시지) --%>
                <c:if test="${not empty message}">
                    <span id="facilityCheckFlashMessage" data-message="<c:out value='${message}'/>" hidden></span>
                </c:if>

                <%-- 대상 정보 --%>
                <div class="panel">
                    <div class="panel-body">
                        <div class="section-title">
                            <span class="material-symbols-rounded">apartment</span>대상 정보
                            <span class="title-sub">시설과 협력업체를 분리해 확인합니다.</span>
                        </div>

                        <div class="target-grid">
                            <%-- 시설 정보 --%>
                            <div class="target-card">
                                <div class="target-head">
                                    <div class="target-title">
                                        <span class="material-symbols-rounded">domain</span>시설 정보
                                    </div>
                                    <a class="target-link" href="${ctx}/manager/facility/detail-page/${mgmtOfcNo}/${check.facilityNo}">
                                        시설 상세 보기 <span class="material-symbols-rounded">arrow_forward</span>
                                    </a>
                                </div>
                                <table class="info-compact">
                                    <tr>
                                        <th>시설명</th>
                                        <td>${empty check.facilityNm ? '<span class="detail-empty">-</span>' : check.facilityNm}</td>
                                        <th>시설번호</th>
                                        <td><span class="mono">${empty check.facilityNo ? '-' : check.facilityNo}</span></td>
                                    </tr>
                                    <tr>
                                        <th>시설유형</th>
                                        <td>${empty check.facilityTyNm ? '<span class="detail-empty">-</span>' : check.facilityTyNm}</td>
                                        <th>사용여부</th>
                                        <td>${check.useYn eq 'Y' ? '사용' : '미사용'}</td>
                                    </tr>
                                    <tr>
                                        <th>위치</th>
                                        <td><span class="ellipsis">${empty check.locCn ? '-' : check.locCn}</span></td>
                                        <th>설치일자</th>
                                        <td>${empty check.instlDt ? '<span class="detail-empty">-</span>' : check.instlDt}</td>
                                    </tr>
                                </table>
                            </div>

                            <%-- 협력업체 정보 --%>
                            <div class="target-card">
                                <div class="target-head">
                                    <div class="target-title">
                                        <span class="material-symbols-rounded">handshake</span>협력업체 정보
                                    </div>
                                    <a class="target-link" href="${ctx}/manager/facility/partner/list/${mgmtOfcNo}<c:if test="${not empty check.partnerNo}">?searchWord=${check.partnerNo}</c:if>">
                                        협력업체 상세 보기 <span class="material-symbols-rounded">arrow_forward</span>
                                    </a>
                                </div>
                                <table class="info-compact">
                                    <tr>
                                        <th>업체명</th>
                                        <td>${empty check.partnerNm ? '<span class="detail-empty">-</span>' : check.partnerNm}</td>
                                        <th>업체번호</th>
                                        <td><span class="mono">${empty check.partnerNo ? '-' : check.partnerNo}</span></td>
                                    </tr>
                                    <tr>
                                        <th>업종</th>
                                        <td><span class="ellipsis">${empty check.bizTyNm ? '-' : check.bizTyNm}</span></td>
                                        <th>담당자</th>
                                        <td>${empty check.picNm ? '<span class="detail-empty">-</span>' : check.picNm}</td>
                                    </tr>
                                    <tr>
                                        <th>연락처</th>
                                        <td>${empty check.picTelno ? '<span class="detail-empty">-</span>' : check.picTelno}</td>
                                        <th>이메일</th>
                                        <td><span class="ellipsis">${empty check.picEmail ? '-' : check.picEmail}</span></td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <%-- 이력/결과 본문 --%>
                <div class="panel">
                    <div class="panel-body">
                        <div class="section-title">
                            <span class="material-symbols-rounded">fact_check</span>점검 이력 및 결과
                            <span class="title-sub">같은 시설의 점검 흐름과 현재 점검 결과입니다.</span>
                        </div>

                        <div class="detail-split">
                            <%-- 같은 시설 점검 이력 --%>
                            <div class="split-panel">
                                <div class="split-head">
                                    <div class="split-title">
                                        <span class="material-symbols-rounded">history</span>같은 시설의 점검 이력
                                    </div>
                                    <div class="split-desc">간략 이력</div>
                                </div>

                                <div class="history-table-wrap">
                                    <table class="history-table">
                                        <colgroup>
                                            <col style="width:24%;">
                                            <col style="width:20%;">
                                            <col style="width:22%;">
                                            <col style="width:18%;">
                                            <col style="width:16%;">
                                        </colgroup>
                                        <thead>
                                        <tr>
                                            <th>작업일자</th>
                                            <th>점검분류</th>
                                            <th>작업유형</th>
                                            <th>상태</th>
                                            <th>상세</th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        <c:choose>
                                            <c:when test="${not empty sameFacilityCheckList}">
                                                <c:forEach var="history" items="${sameFacilityCheckList}">
                                                    <tr class="${history.facChkHstryNo eq check.facChkHstryNo ? 'is-current' : ''}">
                                                        <td>${empty history.chkDt ? '-' : history.chkDt}</td>
                                                        <td>${empty history.chkCtgryNm ? '-' : history.chkCtgryNm}</td>
                                                        <td>${empty history.chkTyNm ? '-' : history.chkTyNm}</td>
                                                        <td>
                                                            <span class="badge ${history.chkSttsCd eq 'WAIT' ? 'badge-wait' : history.chkSttsCd eq 'ING' ? 'badge-ing' : history.chkSttsCd eq 'DONE' ? 'badge-done' : history.chkSttsCd eq 'FAULT' ? 'badge-fault' : 'badge-wait'}">
                                                                    ${empty history.chkSttsNm ? '-' : history.chkSttsNm}
                                                            </span>
                                                        </td>
                                                        <td>
                                                            <button type="button"
                                                                    class="btn history-detail-btn"
                                                                    data-history-no="${fn:escapeXml(history.facChkHstryNo)}"
                                                                    data-check-flow="${fn:escapeXml(history.chkFlowNo)}"
                                                                    data-check-date="${fn:escapeXml(history.chkDt)}"
                                                                    data-check-category="${fn:escapeXml(history.chkCtgryNm)}"
                                                                    data-check-type="${fn:escapeXml(history.chkTyNm)}"
                                                                    data-check-status="${fn:escapeXml(history.chkSttsNm)}"
                                                                    data-partner-no="${fn:escapeXml(history.partnerNo)}"
                                                                    data-partner-name="${fn:escapeXml(history.partnerNm)}"
                                                                    data-cont-no="${fn:escapeXml(history.contNo)}"
                                                                    data-cont-name="${fn:escapeXml(history.contNm)}"
                                                                    data-cont-start="${fn:escapeXml(history.contBgngDt)}"
                                                                    data-cont-end="${fn:escapeXml(history.contEndDt)}"
                                                                    data-check-content="${fn:escapeXml(history.chkCn)}"
                                                                    data-check-remark="${fn:escapeXml(history.rmk)}"
                                                                    data-use-restrict-yn="${fn:escapeXml(history.useRestrictYn)}"
                                                                    data-use-restrict-bgng="${fn:escapeXml(history.useRestrictBgngDt)}"
                                                                    data-use-restrict-end="${fn:escapeXml(history.useRestrictEndDt)}">
                                                                보기
                                                            </button>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <tr>
                                                    <td colspan="5">같은 시설의 점검 이력이 없습니다.</td>
                                                </tr>
                                            </c:otherwise>
                                        </c:choose>
                                        </tbody>
                                    </table>
                                </div>
                            </div>

                            <%-- 현재 점검 결과 --%>
                            <div class="split-panel">
                                <div class="split-head">
                                    <div class="split-title">
                                        <span class="material-symbols-rounded">fact_check</span>현재 점검 결과
                                    </div>
                                    <div class="split-desc">${empty check.facChkHstryNo ? '-' : check.facChkHstryNo}</div>
                                </div>

                                <div class="result-body">
                                    <table class="result-summary">
                                        <thead>
                                        <tr>
                                            <th>점검이력번호</th>
                                            <th>점검분류</th>
                                            <th>작업유형</th>
                                            <th>점검상태</th>
                                            <th>작업일자</th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        <tr>
                                            <td class="mono">${empty check.facChkHstryNo ? '-' : check.facChkHstryNo}</td>
                                            <td>${empty check.chkCtgryNm ? '-' : check.chkCtgryNm}</td>
                                            <td>${empty check.chkTyNm ? '-' : check.chkTyNm}</td>
                                            <td>
                                                <span class="badge ${check.chkSttsCd eq 'WAIT' ? 'badge-wait' : check.chkSttsCd eq 'ING' ? 'badge-ing' : check.chkSttsCd eq 'DONE' ? 'badge-done' : check.chkSttsCd eq 'FAULT' ? 'badge-fault' : 'badge-wait'}">
                                                    ${empty check.chkSttsNm ? '-' : check.chkSttsNm}
                                                </span>
                                            </td>
                                            <td>${empty check.chkDt ? '-' : check.chkDt}</td>
                                        </tr>
                                        <tr>
                                            <th>이용제한</th>
                                            <td colspan="4">
                                                <c:choose>
                                                    <c:when test="${check.useRestrictYn eq 'Y'}">
                                                        <span class="badge badge-fault">제한 있음</span>
                                                        <span>${fn:replace(check.useRestrictBgngDt, 'T', ' ')} ~ ${fn:replace(check.useRestrictEndDt, 'T', ' ')}</span>
                                                    </c:when>
                                                    <c:otherwise>제한 없음</c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                        </tbody>
                                    </table>


                                    <div class="result-content">
                                        <div class="result-label">점검내용</div>
                                        <div class="result-text">${empty check.chkCn ? '<span class="detail-empty">-</span>' : check.chkCn}</div>
                                    </div>

                                    <div class="result-content">
                                        <div class="result-label">비고</div>
                                        <div class="result-text short">${empty check.rmk ? '<span class="detail-empty">-</span>' : check.rmk}</div>
                                    </div>

                                    <div class="audit-row">
                                        <div class="audit-box">
                                            <div class="result-label">이력 등록일자</div>
                                            <div class="audit-value">${empty check.regDt ? '-' : check.regDt}</div>
                                        </div>
                                        <div class="audit-box">
                                            <div class="result-label">이력 수정일자</div>
                                            <div class="audit-value">${empty check.mdfDt ? '-' : check.mdfDt}</div>
                                        </div>
                                    </div>
                                </div>
                            </div>


                        </div>
                    </div>
                </div>

                <div class="detail-actions">
                    <a class="btn" href="${ctx}/manager/checkHistory/${mgmtOfcNo}">목록</a>
                    <%-- ADMIN은 조회 전용이므로 수정 버튼 숨김 --%>
                    <sec:authorize access="!hasRole('ADMIN')">
                        <a class="btn btn-primary" href="${ctx}/manager/checkHistory/update/${mgmtOfcNo}/${check.facChkHstryNo}">수정</a>
                    </sec:authorize>
                </div>

                <%-- 같은 시설 이력 상세 모달 --%>
                <%@ include file="/WEB-INF/views/apt/mgmtOffice/facility/check/facility_check_history_modal.jspf" %>


            </div>
        </main>
    </div>
</div>

<script src="${ctx}/js/manager/manager-common.js"></script>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        var flashEl = document.getElementById("facilityCheckFlashMessage");
        if (flashEl && flashEl.dataset.message) {
            void showAlert(flashEl.dataset.message, "success");
        }

        /* 값이 없을 때 표시값 보정 */
        function safeText(value) {
            return value && String(value).trim() ? String(value) : "-";
        }

        /* 이력 보기 버튼 클릭 시 모달에 상세값 세팅 */
        document.addEventListener("click", function (event) {
            var button = event.target.closest(".history-detail-btn");
            if (!button) return;

            document.getElementById("modalHistoryNo").textContent = safeText(button.getAttribute("data-history-no"));
            document.getElementById("modalCheckFlowNo").textContent = safeText(button.getAttribute("data-check-flow"));
            document.getElementById("modalHistoryDt").textContent = safeText(button.getAttribute("data-check-date"));
            document.getElementById("modalHistoryCtgry").textContent = safeText(button.getAttribute("data-check-category"));
            document.getElementById("modalHistoryTy").textContent = safeText(button.getAttribute("data-check-type"));
            document.getElementById("modalHistoryStts").textContent = safeText(button.getAttribute("data-check-status"));

            var partnerNo = button.getAttribute("data-partner-no") || "";
            var contStart = button.getAttribute("data-cont-start") || "";
            var contEnd = button.getAttribute("data-cont-end") || "";
            var contPeriod = "-";

            if (contStart || contEnd) {
                contPeriod = safeText(contStart) + " ~ " + safeText(contEnd);
            }

            document.getElementById("modalOwnerType").textContent = partnerNo ? "협력업체점검" : "자체점검";
            document.getElementById("modalPartnerNm").textContent = partnerNo ? safeText(button.getAttribute("data-partner-name")) : "-";
            document.getElementById("modalContNo").textContent = safeText(button.getAttribute("data-cont-no"));
            document.getElementById("modalContNm").textContent = safeText(button.getAttribute("data-cont-name"));
            document.getElementById("modalContPeriod").textContent = contPeriod;
            document.getElementById("modalHistoryCn").textContent = safeText(button.getAttribute("data-check-content"));
            document.getElementById("modalHistoryRmk").textContent = safeText(button.getAttribute("data-check-remark"));

            var restrictYn = button.getAttribute("data-use-restrict-yn") || "N";
            var restrictBgng = button.getAttribute("data-use-restrict-bgng") || "";
            var restrictEnd = button.getAttribute("data-use-restrict-end") || "";
            document.getElementById("modalUseRestrictYn").textContent = restrictYn === "Y" ? "제한 있음" : "제한 없음";
            document.getElementById("modalUseRestrictPeriod").textContent = restrictYn === "Y" ? safeText(restrictBgng).replace("T", " ") + " ~ " + safeText(restrictEnd).replace("T", " ") : "-";

            if (typeof window.openModal === "function") {
                window.openModal("historyDetailModal");
            } else {
                document.getElementById("historyDetailModal").classList.add("open");
            }
        });
    });
</script>
</body>
</html>
