<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>투표/설문 관리</title>
    <sec:csrfMetaTags/>
    <link rel="preconnect" href="https://fonts.googleapis.com"/>
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin/>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap"
          rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0"
          rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/office-layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/manager-common.css">
    <style>
        #surveyManagePage .survey-toolbar {
            display: flex;
            justify-content: space-between;
            gap: 12px;
            align-items: flex-end;
            flex-wrap: wrap;
        }

        #surveyManagePage .survey-actions {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }

        #surveyManagePage .survey-kpi-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 12px;
        }

        #surveyManagePage .survey-kpi {
            padding: 18px;
            border-radius: 8px;
            background: #fff;
            border: 1px solid var(--border);
        }

        #surveyManagePage .survey-kpi-label {
            font-size: 12px;
            color: var(--text-tertiary);
            margin-bottom: 6px;
        }

        #surveyManagePage .survey-kpi-value {
            font-size: 26px;
            font-weight: 800;
            color: var(--text-primary);
            line-height: 1.1;
        }

        #surveyManagePage .survey-kpi-sub {
            font-size: 12px;
            color: var(--text-tertiary);
            margin-top: 4px;
        }

        #surveyManagePage .survey-filters {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
            align-items: flex-end;
        }

        #surveyManagePage .survey-filter {
            min-width: 160px;
        }

        #surveyManagePage .survey-layout {
            display: grid;
            grid-template-columns: minmax(0, 1fr) 280px;
            gap: 16px;
        }

        #surveyManagePage .survey-side {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        #surveyManagePage .survey-card {
            padding: 0;
            overflow: hidden;
        }

        #surveyManagePage .survey-card-head {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
            padding: 12px 18px;
            border-bottom: 1px solid var(--border);
            background: #f7f8f9;
        }

        #surveyManagePage .survey-card-title {
            font-size: 13px;
            font-weight: 700;
        }

        #surveyManagePage .survey-card-body {
            padding: 16px 18px;
        }

        #surveyManagePage .survey-list-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 14px;
            padding: 12px 18px;
            border-bottom: 1px solid var(--border);
        }

        #surveyManagePage .survey-list-item:last-child {
            border-bottom: none;
        }

        #surveyManagePage .survey-list-main {
            min-width: 0;
        }

        #surveyManagePage .survey-list-title {
            font-size: 13px;
            font-weight: 700;
            color: var(--text-primary);
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        #surveyManagePage .survey-list-sub {
            font-size: 12px;
            color: var(--text-tertiary);
            margin-top: 3px;
        }

        #surveyManagePage .survey-status {
            display: inline-flex;
            align-items: center;
            padding: 3px 9px;
            border-radius: 4px;
            font-size: 11px;
            font-weight: 700;
        }

        #surveyManagePage .status-running {
            background: #dcfce7;
            color: #166534;
        }

        #surveyManagePage .status-waiting {
            background: #fff7d6;
            color: #8a5a00;
        }

        #surveyManagePage .status-closed {
            background: #e5e7eb;
            color: #4b5563;
        }

        #surveyManagePage .survey-side-stat {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px solid var(--border);
            font-size: 13px;
        }

        #surveyManagePage .survey-side-stat:last-child {
            border-bottom: none;
        }

        #surveyManagePage .survey-side-label {
            color: var(--text-tertiary);
        }

        #surveyManagePage .survey-side-value {
            font-weight: 700;
            color: var(--text-primary);
        }

        #surveyManagePage .survey-empty {
            padding: 32px 16px;
            text-align: center;
            color: var(--text-tertiary);
            font-size: 13px;
        }

        #surveyManagePage .survey-progress {
            height: 8px;
            border-radius: 999px;
            background: #edf0ef;
            overflow: hidden;
            margin-top: 8px;
        }

        #surveyManagePage .survey-progress > span {
            display: block;
            height: 100%;
            background: #2e5c38;
            border-radius: inherit;
        }

        @media (max-width: 1180px) {
            #surveyManagePage .survey-layout {
                grid-template-columns: 1fr;
            }

            #surveyManagePage .survey-kpi-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        @media (max-width: 720px) {
            #surveyManagePage .survey-kpi-grid {
                grid-template-columns: 1fr;
            }
        }

        .question-box {
            border: 1px solid #dfe5ec;
            border-radius: 12px;
            padding: 18px;
            background: #fafbfc;
        }

        .question-box + .question-box {
            margin-top: 14px;
        }

        .question-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 14px;
        }

        .question-badge {
            background: #2f6b3d;
            color: #fff;
            padding: 6px 12px;
            border-radius: 8px;
            font-size: 13px;
            font-weight: 700;
        }

        .option-row {
            display: grid;
            grid-template-columns:32px 1fr 72px;
            gap: 10px;
            align-items: center;
            margin-bottom: 10px;
        }

        .option-number {
            width: 24px;
            height: 24px;
            border-radius: 50%;
            background: #e7efe9;
            color: #2f6b3d;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
            font-weight: 700;
        }

        .remove-question-btn,
        .remove-option-btn {
            width: 72px !important;
            height: 36px !important;
            padding: 0 !important;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
            flex-shrink: 0;
        }

    </style>
</head>
<body>
<div class="app-wrapper">
    <%@ include file="/WEB-INF/views/include/office_sidebar.jsp" %>
    <div class="main-wrap">
        <%@ include file="/WEB-INF/views/include/office_header.jsp" %>
        <c:set var="activeSidebarHref" value="${pageContext.request.contextPath}/manager/survey/${mgmtOfcNo}" />
        <c:set var="activeSidebarParent" value="소통·행정 관리" />
        <c:set var="activeSidebarCurrent" value="투표·설문 관리" />
        <%@ include file="/WEB-INF/views/include/office_active_sidebar.jspf" %>
        <main class="main-content">
            <div class="office-page" id="surveyManagePage">
                <div class="page-header">
                    <div class="page-title-block">
                        <h2>투표/설문 관리</h2>
                        <p>단지 내 투표와 설문을 등록하고 진행 현황을 확인합니다.</p>
                    </div>
                    <div class="survey-actions">
                        <button type="button" class="btn btn-secondary" data-action="openVote">
                            <span class="material-symbols-rounded">how_to_vote</span>
                            투표 등록
                        </button>
                        <button type="button" class="btn btn-primary" data-action="openSurvey">
                            <span class="material-symbols-rounded">assignment</span>
                            설문 등록
                        </button>
                    </div>
                </div>
                <div class="survey-kpi-grid" style="margin-bottom:16px;">
                    <div class="survey-kpi">
                        <div class="survey-kpi-label">진행중</div>
                        <div class="survey-kpi-value" id="kpiRunning">0</div>
                        <div class="survey-kpi-sub">현재 응답을 받고 있는 항목</div>
                    </div>
                    <div class="survey-kpi">
                        <div class="survey-kpi-label">대기중</div>
                        <div class="survey-kpi-value" id="kpiWaiting">0</div>
                        <div class="survey-kpi-sub">등록은 되었지만 시작 전인 항목</div>
                    </div>
                    <div class="survey-kpi">
                        <div class="survey-kpi-label">종료</div>
                        <div class="survey-kpi-value" id="kpiClosed">0</div>
                        <div class="survey-kpi-sub">마감된 투표/설문</div>
                    </div>
                    <div class="survey-kpi">
                        <div class="survey-kpi-label">평균 응답률</div>
                        <div class="survey-kpi-value" id="kpiAnswers">0%</div>
                        <div class="survey-kpi-sub">전체 설문 평균 참여율</div>
                    </div>
                </div>
                <div class="panel" style="margin-bottom:16px;">
                    <div class="panel-header">
                        <h3 class="panel-title">
                            <span class="material-symbols-rounded">manage_search</span>
                            검색 조건
                        </h3>
                    </div>
                    <div class="panel-body">
                        <div class="survey-filters">
                            <div class="form-field survey-filter">
                                <label class="field-label">구분</label>
                                <select class="form-select" id="filterType">
                                    <option value="">전체</option>
                                    <option value="VOTE">투표</option>
                                    <option value="SURVEY">설문</option>
                                </select>
                            </div>
                            <div class="form-field survey-filter">
                                <label class="field-label">상태</label>
                                <select class="form-select" id="filterStatus">
                                    <option value="">전체</option>
                                    <option value="READY">대기중</option>
                                    <option value="OPEN">진행중</option>
                                    <option value="CLOSED">종료</option>
                                </select>
                            </div>
                            <div class="form-field survey-filter" style="min-width:260px;">
                                <label class="field-label">검색어</label>
                                <input type="text" class="form-input" id="filterKeyword" placeholder="제목, 작성자, 회차로 검색">
                            </div>
                            <button type="button" class="btn btn-primary" data-action="search">
                                <span class="material-symbols-rounded">search</span>
                                조회
                            </button>
                            <button type="button" class="btn btn-secondary" data-action="reset">
                                <span class="material-symbols-rounded">refresh</span>
                                초기화
                            </button>
                        </div>
                    </div>
                </div>

                <div class="survey-layout">
                    <div class="panel survey-card">
                        <div class="survey-card-head">
                            <div class="survey-card-title">투표/설문 목록</div>
                            <span class="list-count" id="surveyCount">0건</span>
                        </div>
                        <div id="surveyList"></div>
                    </div>
                    <div class="survey-side">
                        <div class="panel survey-card">
                            <div class="survey-card-head">
                                <div class="survey-card-title">운영 요약</div>
                            </div>
                            <div class="survey-card-body">
                                <div class="survey-side-stat">
                                    <span class="survey-side-label">전체 설문</span>
                                    <span class="survey-side-value" id="sideMonthly">0건</span>
                                </div>

                                <div class="survey-side-stat">
                                    <span class="survey-side-label">이미 마감된 설문</span>
                                    <span class="survey-side-value" id="sideWeekly">0건</span>
                                </div>

                                <div class="survey-side-stat">
                                    <span class="survey-side-label">평균 응답률</span>
                                    <span class="survey-side-value" id="sideRate">0%</span>
                                </div>
                            </div>
                        </div>
                        <div class="panel survey-card">
                            <div class="survey-card-head">
                                <div class="survey-card-title">빠른 안내</div>
                            </div>
                            <div class="survey-card-body">
                                <div style="font-size:13px; color:var(--text-secondary); line-height:1.7;">
                                    투표는 단일 선택, 설문은 객관식/서술형 혼합으로 시작할 수 있습니다.
                                    아직 저장 기능은 연결하지 않았고, 화면 구성부터 정리한 상태입니다.
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="modal-overlay" id="surveyModal">
                    <div class="modal modal-lg" style="max-width:1100px; width:95%;">
                        <div class="modal-header primary">
                            <h3 class="modal-title" id="surveyModalTitle">투표 등록</h3>
                            <button type="button" class="modal-close" data-action="closeModal">
                                <span class="material-symbols-rounded">close</span>
                            </button>
                        </div>
                        <form id="surveyForm">
                            <div class="modal-body">
                                <div class="form-row cols-2">
                                    <div class="form-field">
                                        <label class="field-label">구분</label>
                                        <select class="form-select" id="surveyType">
                                            <option value="VOTE">투표</option>
                                            <option value="SURVEY">설문</option>
                                        </select>
                                    </div>
                                    <div class="form-field">
                                        <label class="field-label">상태</label>
                                        <select class="form-select" id="surveyStatus">
                                            <option value="READY">대기중</option>
                                            <option value="OPEN">진행중</option>
                                            <option value="CLOSED">종료</option>
                                        </select>
                                    </div>
                                </div>

                                <div class="form-row cols-1">
                                    <div class="form-field">
                                        <label class="field-label">제목</label>
                                        <input type="text" class="form-input" id="surveyTitle" placeholder="제목을 입력하세요">
                                    </div>
                                </div>
                                <div class="form-row cols-2">
                                    <div class="form-field">
                                        <label class="field-label">시작일</label>
                                        <input type="date" class="form-input" id="surveyStartDt">
                                    </div>
                                    <div class="form-field">
                                        <label class="field-label">종료일</label>
                                        <input type="date" class="form-input" id="surveyEndDt">
                                    </div>
                                </div>
                                <div class="form-row cols-1">
                                    <div class="form-field">
                                        <label class="field-label">설명</label>
                                        <textarea class="form-textarea" id="surveyDesc" rows="5"
                                                  placeholder="설명과 안내 문구를 입력하세요"></textarea>
                                    </div>
                                </div>
                            </div>
                            <div class="form-row cols-1">

                                <div class="form-field">
                                    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:10px;">
                                        <label class="field-label">
                                            질문 항목
                                        </label>
                                        <button type="button"
                                                class="btn btn-primary btn-sm"
                                                id="addQuestionBtn">

                                            <span class="material-symbols-rounded">add</span>
                                            질문 추가
                                        </button>
                                    </div>
                                    <div id="questionContainer">
                                        <div class="question-box">
                                            <!-- 상단 -->
                                            <div class="question-header">


                                                <div class="question-badge"> 질문 1
                                                </div>

                                                <button type="button"
                                                        class="btn btn-danger btn-xs remove-question-btn">

                                                    질문 삭제

                                                </button>

                                            </div>

                                            <!-- 질문 -->
                                            <div class="form-row cols-2">

                                                <div class="form-field">

                                                    <label class="field-label">
                                                        질문 내용
                                                    </label>

                                                    <input type="text"
                                                           class="form-input question-input"
                                                           placeholder="질문 내용을 입력하세요">

                                                </div>

                                                <div class="form-field">

                                                    <label class="field-label">
                                                        응답 방식
                                                    </label>

                                                    <select class="form-select question-type-select">

                                                        <option value="MULTI">
                                                            객관식
                                                        </option>

                                                        <option value="SHORT">
                                                            주관식
                                                        </option>

                                                    </select>

                                                </div>

                                            </div>

                                            <!-- 보기 -->
                                            <div class="option-wrapper">

                                                <label class="field-label">
                                                    보기 항목
                                                </label>

                                                <div class="option-container">

                                                    <div class="option-row">

                                                        <div class="option-number">
                                                            1
                                                        </div>

                                                        <input type="text"
                                                               class="form-input option-input"
                                                               style="flex:1;"
                                                               placeholder="보기 내용">

                                                        <button type="button"
                                                                class="btn btn-danger remove-option-btn">

                                                            삭제

                                                        </button>

                                                    </div>

                                                </div>

                                                <button type="button"
                                                        class="btn btn-secondary btn-sm add-option-btn"
                                                        style="margin-top:10px;">

                                                    + 보기 추가

                                                </button>



                                                <div class="short-answer-box"
                                                     style="display:none; margin-top:12px;">

                                                    <label class="field-label">
                                                        답변 입력칸
                                                    </label>

                                                    <textarea
                                                            class="form-textarea"
                                                            rows="3"
                                                            placeholder="입주민이 여기에 답변 작성"
                                                            disabled
                                                    ></textarea>

                                                </div>


                                            </div>

                                        </div>

                                    </div>

                                </div>

                            </div>


                            <div class="modal-footer" style="border-top:none;">
                                <button type="button" class="btn btn-secondary" data-action="closeModal">취소</button>
                                <button type="submit" class="btn btn-primary">저장</button>
                            </div>
                        </form>
                    </div>
                </div>


            </div>
        </main>
    </div>
</div>

<script>
    const ctx = "${pageContext.request.contextPath}";
    const mgmtOfcNo = "${mgmtOfcNo}";
    var surveys = [];
    (function () {
        var page = document.getElementById("surveyManagePage");
        if (!page || page.dataset.bound === "true") return;
        page.dataset.bound = "true";

        var modal = document.getElementById("surveyModal");
        var modalTitle = document.getElementById("surveyModalTitle");
        var surveyList = document.getElementById("surveyList");
        var surveyForm = document.getElementById("surveyForm");
        var modalBody = modal.querySelector(".modal-body");
        var questionRow = document.getElementById("questionContainer").closest(".form-row.cols-1");

        if (modalBody && questionRow && !modalBody.contains(questionRow)) {
            modalBody.appendChild(questionRow);
        }


        function typeText(type) {
            return type === "VOTE" ? "투표" : "설문";
        }

        function statusText(status) {
            if (status === "OPEN") return "진행중";
            if (status === "READY") return "대기중";
            if (status === "CLOSED") return "종료";
            return "-";
        }

        function statusClass(status) {
            if (status === "OPEN") return "status-running";
            if (status === "READY") return "status-waiting";
            if (status === "CLOSED") return "status-closed";
            return "";
        }

        function renderStats(data) {

            const now = new Date();

            const currentMonth =
                now.getMonth() + 1;

            const currentYear =
                now.getFullYear();

            /* 진행중 */
            const running = data.filter(item =>
                item.surveySttsCd === "OPEN"
            ).length;

            /* 종료 */
            const closed = data.filter(item =>
                item.surveySttsCd === "CLOSED"
            ).length;

            /* 대기중 */
            const waiting = data.filter(item =>
                item.surveySttsCd === "READY"
            ).length;

            /* 이번달 등록 */
            const monthlyCount = data.filter(item => {

                if (!item.surveyBgngDt) return false;

                const date =
                    new Date(item.surveyBgngDt);

                return (
                    date.getFullYear() === currentYear &&
                    (date.getMonth() + 1) === currentMonth
                );

            }).length;

            /* 이번주 시작 예정 */
            const weeklyCount = data.filter(item => {

                if (item.surveySttsCd !== "READY") {
                    return false;
                }

                if (!item.surveyBgngDt) {
                    return false;
                }

                const startDate =
                    new Date(item.surveyBgngDt);

                const diff =
                    (startDate - now)
                    / (1000 * 60 * 60 * 24);

                return diff >= 0 && diff <= 7;

            }).length;

            /* 평균 응답률 */
            /* 전체 응답률 */

            let totalParticipant = 0;

            data.forEach(item => {

                totalParticipant +=
                    Number(item.participantCount || 0);

            });

            /* 전체 세대 수 */
            const totalResident = 360;

            /* 전체 참여율 */
            const avgRate =
                totalResident === 0
                    ? 0
                    : (totalParticipant / totalResident) * 100;

            /* 화면 출력 */
            document.getElementById("kpiRunning").textContent =
                running;

            document.getElementById("kpiWaiting").textContent =
                waiting;

            document.getElementById("kpiClosed").textContent =
                closed;

            document.getElementById("kpiAnswers").textContent =
                avgRate.toFixed(1) + "%"


            document.getElementById("sideMonthly").textContent =
                monthlyCount + "건";

            document.getElementById("sideWeekly").textContent =
                closed + "건";


            document.getElementById("sideRate").textContent =
                avgRate.toFixed(1) + "%";


            document.getElementById("surveyCount").textContent =
                data.length + "건";
        }


        function resolveSurveyNo(item) {
            return item?.surveyNo || item?.SURVEY_NO || item?.survey_no || item?.surveyno || "";
        }

        function renderList(data) {
            renderStats(data);

            if (!data.length) {
                surveyList.innerHTML = '<div class="survey-empty">조건에 맞는 항목이 없습니다.</div>';
                return;
            }

            surveyList.innerHTML = data.map(function (item, idx) {
                var surveyNo = resolveSurveyNo(item);
                var detailUrl = surveyNo
                    ? ctx + "/manager/survey/" + mgmtOfcNo + "/detail/" + encodeURIComponent(surveyNo)
                    : "#";
                var resultUrl = surveyNo
                    ? ctx + "/manager/survey/" + mgmtOfcNo + "/result/" + encodeURIComponent(surveyNo)
                    : "#";
                return ''
                    + '<div class="survey-list-item" data-survey-no="' + surveyNo + '">'
                    + '  <div class="survey-list-main">'
                    + '    <div class="survey-list-title">' + item.surveyNm + '</div>'
                    + '    <div class="survey-list-sub">'

                    + typeText(item.surveyTypeCd)
                    + '    </div>'
                    + '    <div class="survey-list-sub">' + item.surveyBgngDt + ' ~ ' + item.surveyEndDt + '</div>'
                    + '  </div>'
                    + '  <div style="display:flex; flex-direction:column; align-items:flex-end; gap:6px; flex-shrink:0;">'
                    + '    <span class="survey-status ' + statusClass(item.surveySttsCd) + '">' + statusText(item.surveySttsCd) + '</span>'
                    + '    <div style="font-size:12px; color:var(--text-tertiary);">상태: ' + statusText(item.surveySttsCd) + '</div>'
                    + '    <div style="display:flex; gap:6px;">'
                    + '      <a class="btn btn-secondary btn-sm" href="' + detailUrl + '" data-action="detail" data-idx="' + idx + '" data-survey-no="' + surveyNo + '">상세</a>'
                    + '      <a class="btn btn-primary btn-sm" href="' + resultUrl + '" data-action="result" data-idx="' + idx + '" data-survey-no="' + surveyNo + '">결과</a>'
                    + '    </div>'
                    + '  </div>'
                    + '</div>';
            }).join("");
        }

        function filtered() {
            var type = document.getElementById("filterType").value;
            var status = document.getElementById("filterStatus").value;
            var keyword = document.getElementById("filterKeyword").value.trim();

            return surveys.filter(function (item) {
                return (!type || item.surveyTypeCd === type)
                    && (!status || item.surveySttsCd === status)
                    && (!keyword || item.surveyNm.indexOf(keyword) > -1);
            });
        }

        function openModal(mode) {
            modalTitle.textContent = mode === "survey" ? "설문 등록" : "투표 등록";
            document.getElementById("surveyType").value = mode === "survey" ? "SURVEY" : "VOTE";
            document.getElementById("surveyStatus").value = "READY";
            document.getElementById("surveyTitle").value = "";
            document.getElementById("surveyStartDt").value = "";
            document.getElementById("surveyEndDt").value = "";
            document.getElementById("surveyDesc").value = "";
            modal.classList.add("open");
        }

        function closeModal() {
            modal.classList.remove("open");
        }


        page.addEventListener("click", function (e) {
            var btn = e.target.closest("[data-action]");
            if (!btn) return;

            var action = btn.dataset.action;

            if (action === "openVote") openModal("vote");
            if (action === "openSurvey") openModal("survey");
            if (action === "closeModal") closeModal();
            if (action === "search") renderList(filtered());
            if (action === "reset") {
                document.getElementById("filterType").value = "";
                document.getElementById("filterStatus").value = "";
                document.getElementById("filterKeyword").value = "";

                renderList(surveys);


            }
            if (action === "detail") {

                const idx = btn.getAttribute("data-idx");

                const row = surveys[idx];
                const resolvedSurveyNo =
                    btn.dataset.surveyNo ||
                    row?.surveyNo ||
                    row?.SURVEY_NO ||
                    row?.survey_no ||
                    row?.surveyno ||
                    "";

                console.log(row);

                if (!resolvedSurveyNo) {
                    alert("선택한 설문의 번호를 찾지 못했습니다.");
                    return;
                }

                location.href =
                    `${ctx}/manager/survey/${mgmtOfcNo}/detail/${resolvedSurveyNo}`;
            }


            if (action === "result") {

                var resultRow = surveys[Number(btn.dataset.idx)];
                var resolvedResultSurveyNo =
                    btn.dataset.surveyNo ||
                    resultRow?.surveyNo ||
                    resultRow?.SURVEY_NO ||
                    resultRow?.survey_no ||
                    resultRow?.surveyno ||
                    "";

                if (!resolvedResultSurveyNo) {
                    alert("선택한 설문의 번호를 찾지 못했습니다.");
                    return;
                }

                location.href =
                    `${ctx}/manager/survey/${mgmtOfcNo}/result/${resolvedResultSurveyNo}`;
            }
        });

        surveyForm.addEventListener("submit", async function (e) {

            e.preventDefault();

            const questionList = [];

            document.querySelectorAll(".question-box")
                .forEach(box => {

                    const question = box
                        .querySelector(".question-input")
                        .value;

                    const type = box
                        .querySelector(".question-type-select")
                        .value;

                    const items = [];

                    if (type === "MULTI") {

                        box.querySelectorAll(".option-input")
                            .forEach(input => {

                                if (input.value.trim() !== "") {

                                    items.push(input.value);

                                }
                            });
                    }

                    questionList.push({

                        question: question,
                        type: type,
                        items: items

                    });

                });

            const payload = {

                surveyNm:
                document.getElementById("surveyTitle").value,

                surveyCn:
                document.getElementById("surveyDesc").value,

                surveyTypeCd:
                document.getElementById("surveyType").value,

                surveySttsCd:
                document.getElementById("surveyStatus").value,

                surveyBgngDt:
                document.getElementById("surveyStartDt").value,

                surveyEndDt:
                document.getElementById("surveyEndDt").value,

                surveyQitemCn:
                    JSON.stringify(questionList)

            };

            if (!payload.surveyBgngDt || !payload.surveyEndDt) {

                alert("시작일과 종료일을 선택하세요.");

                return;
            }

            const csrfHeader =
                document.querySelector("meta[name='_csrf_header']").content;

            const csrfToken =
                document.querySelector("meta[name='_csrf']").content;


            try {

                const response = await fetch(
                    `${ctx}/manager/survey/${mgmtOfcNo}/register`,
                    {
                        method: "POST",
                        headers: {
                            "Content-Type": "application/json",
                            [csrfHeader]: csrfToken
                        },
                        body: JSON.stringify(payload)
                    }
                );

                console.log(response);

                if (response.ok) {

                    await showAlert("저장 성공", "success");

                    location.reload();

                } else {

                    await showAlert("서버 오류 발생", "error");

                    console.error(await response.text());
                }

            } catch (error) {

                console.error(error);

                await showAlert(String(error), "error");
            }
        });

        modal.addEventListener("click", function (e) {
            if (e.target === modal) closeModal();
        });


        document.addEventListener("keydown", function (e) {
            if (e.key === "Escape") closeModal();
        });

        /* 응답 방식 변경 */
        document.addEventListener("change", function (e) {

            if (
                e.target.classList.contains("question-type-select")
            ) {

                const questionBox =
                    e.target.closest(".question-box");

                if (!questionBox) {
                    return;
                }

                const optionWrapper =
                    questionBox.querySelector(".option-wrapper");

                const optionContainer =
                    questionBox.querySelector(".option-container");

                const addOptionBtn =
                    questionBox.querySelector(".add-option-btn");

                let shortAnswerBox =
                    questionBox.querySelector(".short-answer-box");

                if (!shortAnswerBox && optionWrapper) {
                    optionWrapper.insertAdjacentHTML(
                        "beforeend",
                        `
<div class="short-answer-box" style="display:none; margin-top:12px;">
    <label class="field-label">답변 입력칸</label>
    <textarea class="form-textarea"
              rows="3"
              placeholder="입주민이 여기에 답변 작성"
              disabled></textarea>
</div>`
                    );

                    shortAnswerBox =
                        questionBox.querySelector(".short-answer-box");
                }

                const type = e.target.value;

                /* 객관식 */
                if (type === "MULTI") {

                    if (optionWrapper) {
                        optionWrapper.style.display = "block";
                    }

                    if (optionContainer) {
                        optionContainer.style.display = "block";
                    }

                    if (addOptionBtn) {
                        addOptionBtn.style.display = "inline-flex";
                    }

                    if (shortAnswerBox) {
                        shortAnswerBox.style.display = "none";
                    }
                }

                /* 주관식 */
                else if (type === "SHORT") {

                    if (optionWrapper) {
                        optionWrapper.style.display = "block";
                    }

                    if (optionContainer) {
                        optionContainer.style.display = "none";
                    }

                    if (addOptionBtn) {
                        addOptionBtn.style.display = "none";
                    }

                    if (shortAnswerBox) {
                        shortAnswerBox.style.display = "block";
                    }
                }
            }
        });



        /* 보기 추가/삭제 */
        document.addEventListener("click", function (e) {

            /* 보기 추가 */
            if (e.target.classList.contains("add-option-btn")) {

                var optionContainer =
                    e.target.closest(".question-box")
                        .querySelector(".option-container");

                optionContainer.insertAdjacentHTML(
                    "beforeend",
                    `
<div class="option-row">

   <div class="option-number">
        +
    </div>

    <input type="text"
           class="form-input option-input"
           placeholder="보기 내용">

  <button type="button"
        class="btn btn-danger remove-option-btn">

        삭제

    </button>

</div>
            `
                );
            }

            /* 보기 삭제 */
            if (e.target.classList.contains("remove-option-btn")) {

                e.target.closest(".option-row").remove();
            }
            /* 질문 삭제 */
            if (e.target.classList.contains("remove-question-btn")) {

                e.target.closest(".question-box").remove();
            }


        });

        /* 질문 추가 */
        document.getElementById("addQuestionBtn")
            .addEventListener("click", function () {

                document.getElementById("questionContainer")
                    .insertAdjacentHTML(
                        "beforeend",
                        `
<div class="question-box"
     style="
        border:1px solid #dfe5ec;
        border-radius:12px;
        padding:18px;
        margin-top:14px;
        background:#fafbfc;
     ">

  <div class="question-header">

<div class="question-badge">질문 추가
        </div>

        <button type="button"
                class="btn btn-danger btn-xs remove-question-btn">

            질문 삭제

        </button>

    </div>

    <div class="form-row cols-2">

        <div class="form-field">

            <label class="field-label">
                질문 내용
            </label>

            <input type="text"
                   class="form-input question-input"
                   placeholder="질문 내용을 입력하세요">

        </div>

        <div class="form-field">

            <label class="field-label">
                응답 방식
            </label>

            <select class="form-select question-type-select">

                <option value="MULTI">
                    객관식
                </option>

                <option value="SHORT">
                    주관식
                </option>

            </select>

        </div>

    </div>

    <div class="option-wrapper">

        <label class="field-label">
            보기 항목
        </label>

        <div class="option-container">
<div class="option-row">

                <div class="option-number">
                    1
                </div>

                <input type="text"
                       class="form-input option-input"
                       style="flex:1;"
                       placeholder="보기 내용">

                <button type="button"
        class="btn btn-danger remove-option-btn">

                    삭제

                </button>

            </div>

        </div>

        <button type="button"
                class="btn btn-secondary btn-sm add-option-btn"
                style="margin-top:10px;">

            + 보기 추가

        </button>

        <div class="short-answer-box"
             style="display:none; margin-top:12px;">

            <label class="field-label">
                답변 입력칸
            </label>

            <textarea
                    class="form-textarea"
                    rows="3"
                    placeholder="입주민이 여기에 답변 작성"
                    disabled
            ></textarea>

        </div>

    </div>

</div>
`
                    );
            });

        async function loadSurveyList() {
            try {
                const response = await fetch(
                    `${ctx}/manager/survey/${mgmtOfcNo}/list`
                );

                if (!response.ok) {
                    throw new Error(`survey list request failed: ${response.status}`);
                }

                surveys = await response.json();

                console.log(surveys);

                renderList(surveys);
            } catch (error) {
                console.error(error);

                surveyList.innerHTML =
                    '<div class="survey-empty">목록을 불러오지 못했습니다.</div>';
            }
        }

        loadSurveyList();

    })();
</script>
</body>
</html>
