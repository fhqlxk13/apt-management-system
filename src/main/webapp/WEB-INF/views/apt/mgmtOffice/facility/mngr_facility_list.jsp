<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>시설자산 목록</title>

    <sec:csrfMetaTags/>

    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet" />

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/office-layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/manager-common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/ag-grid.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/ag-theme-alpine.css">

    <style>
        /* ============================================================
           시설자산 목록 화면 전용 스타일
           - 등록/수정/상세 모달 스타일 제거
           - list.jsp에서 실제 사용하는 검색, 카드, 그리드 스타일만 유지
        ============================================================ */
        #facilityPage { --accent:#2e5c38; --accent-light:#e8f0ea; --accent-dim:rgba(38,92,48,.08); --surface:#fff; --line:#d7dce2; --th-bg:#f0f2ef; --text-head:#1a2e1e; }
        #facilityPage .page-title-block h2 { color:var(--text-head); font-size:19px; letter-spacing:-.5px; }
        #facilityPage .page-title-block p { color:#6b7a6e; font-size:12px; }
        #facilityPage .panel { border-radius:6px; border:1px solid var(--line); box-shadow:none; margin:0; background:#fff; }
        #facilityPage .panel + .panel { margin-top:14px; }
        #facilityPage .panel-header { display:flex; align-items:center; justify-content:space-between; padding:13px 16px; border-bottom:1px solid var(--line); background:var(--surface); border-radius:6px 6px 0 0; }
        #facilityPage .panel-title { display:flex; align-items:center; gap:6px; margin:0; font-size:13px; font-weight:800; color:var(--text-head); }
        #facilityPage .panel-title .material-symbols-rounded { font-size:17px; color:var(--accent); }
        #facilityPage .panel-body { padding:14px 16px 16px; background:var(--surface); }
        #facilityPage .form-input, #facilityPage .form-select { height:32px; font-size:12px; border-color:var(--line); background:var(--surface); border-radius:4px; }
        #facilityPage .form-input:focus, #facilityPage .form-select:focus { border-color:var(--accent); box-shadow:0 0 0 2px var(--accent-dim); }
        #facilityPage .btn { border-radius:4px; min-height:32px; font-size:12px; padding:0 12px; }
        #facilityPage .btn-primary { background:var(--accent); }
        #facilityPage .btn-primary:hover { background:#1a3d1f; }
        #facilityPage .page-actions { display:flex; align-items:center; justify-content:flex-end; gap:7px; }

        /* 현황 카드 */
        #facilityPage .asset-summary-row { display:grid; grid-template-columns:repeat(4,minmax(0,1fr)); gap:10px; margin-bottom:14px; }
        #facilityPage .asset-summary-card { display:flex; align-items:center; gap:12px; min-height:74px; padding:14px 16px; border:1px solid var(--line); border-radius:6px; background:var(--surface); }
        #facilityPage .asset-summary-card .summary-icon { display:inline-flex; align-items:center; justify-content:center; width:36px; height:36px; border-radius:6px; background:var(--accent-light); color:var(--accent); flex-shrink:0; }
        #facilityPage .asset-summary-card .summary-icon .material-symbols-rounded { font-size:20px; }
        #facilityPage .asset-summary-card .summary-label { font-size:11px; font-weight:700; color:#6b7a6e; margin-bottom:2px; }
        #facilityPage .asset-summary-card .summary-value { font-size:22px; font-weight:800; color:var(--text-head); line-height:1; }
        #facilityPage .asset-summary-card.primary { background:var(--accent); border-color:#1f4027; }
        #facilityPage .asset-summary-card.primary .summary-icon { background:rgba(255,255,255,.14); color:#fff; }
        #facilityPage .asset-summary-card.primary .summary-label { color:rgba(255,255,255,.72); }
        #facilityPage .asset-summary-card.primary .summary-value { color:#fff; }

        /* 검색 */
        #facilityPage .facility-filter-panel { overflow:visible; }
        #facilityPage .facility-filter-panel .panel-body { overflow:visible; }
        #facilityPage .facility-filter-grid { display:grid; grid-template-columns:1fr 1fr 1fr 1fr 1fr 1fr 1fr minmax(240px,1.35fr) auto; gap:10px; align-items:end; }
        #facilityPage .facility-search-field { position:relative; min-width:0; z-index:20; }
        #facilityPage .search-wrap { position:relative; width:100%; }
        #facilityPage .search-wrap .material-symbols-rounded { position:absolute; left:9px; top:50%; transform:translateY(-50%); font-size:15px; color:#9caa9e; pointer-events:none; }
        #facilityPage .search-wrap input { padding-left:30px; width:100%; }
        #facilityPage .facility-search-suggest { display:none; position:absolute; left:0; right:0; top:calc(100% + 4px); z-index:60; max-height:292px; overflow:hidden; border:1px solid var(--line); border-radius:5px; background:#fff; box-shadow:0 8px 22px rgba(15,23,42,.12); }
        #facilityPage .facility-search-suggest.open { display:block; }
        #facilityPage .suggest-item { display:block; width:100%; padding:9px 11px; border:0; border-bottom:1px solid #edf0ed; background:#fff; text-align:left; cursor:pointer; font-family:inherit; }
        #facilityPage .suggest-item:hover { background:#f4f7f4; }
        #facilityPage .suggest-main { display:flex; align-items:center; gap:7px; font-size:12px; font-weight:800; color:#1f2937; }
        #facilityPage .suggest-no { font-family:'SF Mono','Consolas',monospace; font-size:11px; color:#2e5c38; }
        #facilityPage .suggest-sub { margin-top:3px; font-size:11px; color:#7a8a7d; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
        #facilityPage .suggest-empty { padding:8px 11px; font-size:11px; color:#7a8a7d; background:#fafcfb; }

        /* 목록 헤더 */
        #facilityPage .list-header-left { display:flex; align-items:center; gap:8px; min-width:0; }
        #facilityPage .list-header-right { display:flex; align-items:center; justify-content:flex-end; gap:7px; flex-shrink:0; }
        #facilityPage .list-count { font-size:12px; font-weight:800; color:var(--accent); background:var(--accent-light); border-radius:4px; padding:3px 9px; white-space:nowrap; }
        #facilityPage .result-desc { font-size:11px; color:#7a8a7d; margin-left:8px; font-weight:500; }

        /* AG Grid */
        #facilityPage .facility-grid-wrap { padding:0; height:auto; overflow:hidden; }
        #facilityPage #facilityGrid { width:100%; height:auto; border:0; }
        #facilityPage .ag-theme-alpine { --ag-font-family:'Noto Sans KR',sans-serif; --ag-font-size:12px; --ag-header-background-color:#f0f2ef; --ag-header-foreground-color:#4a5c4e; --ag-border-color:#d7dce2; --ag-row-hover-color:#f4f7f4; --ag-selected-row-background-color:#edf6ef; }
        #facilityPage .ag-header-cell-label { justify-content:center; }
        #facilityPage .ag-cell { display:flex; align-items:center; }
        #facilityPage #facilityGrid.ag-layout-auto-height .ag-center-cols-viewport,
        #facilityPage #facilityGrid.ag-layout-auto-height .ag-center-cols-container { min-height:0 !important; }
        #facilityPage #facilityGrid .ag-center-cols-viewport,
        #facilityPage #facilityGrid .ag-body-viewport { overflow-y:hidden !important; }
        #facilityPage #facilityGrid .ag-body-horizontal-scroll,
        #facilityPage #facilityGrid .ag-body-horizontal-scroll-viewport {
            display:none !important;
            height:0 !important;
            min-height:0 !important;
            max-height:0 !important;
            overflow:hidden !important;
        }
        #facilityPage .cell-center { justify-content:center; text-align:center; }
        #facilityPage .td-bold { font-weight:600; color:#111827; }
        #facilityPage .td-mono { font-family:'SF Mono','Consolas',monospace; font-size:11px; color:#6b7a6e; }
        #facilityPage .td-empty { color:#9caa9e; }
        #facilityPage .grid-ellipsis { display:block; max-width:100%; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }
        #facilityPage .grid-actions { display:inline-flex; gap:5px; align-items:center; justify-content:center; width:100%; }
        #facilityPage .grid-actions .btn { min-height:28px; height:28px; padding:0 10px; font-size:11px; border-radius:4px; }
        #facilityPage .status-text { display:inline-flex; align-items:center; justify-content:center; gap:6px; font-size:12px; font-weight:700; line-height:1; white-space:nowrap; }
        #facilityPage .status-text::before { content:""; width:7px; height:7px; border-radius:50%; flex-shrink:0; }
        #facilityPage .status-text.is-available { color:#1f7a3f; }
        #facilityPage .status-text.is-available::before { background:#22c55e; }
        #facilityPage .status-text.is-disabled { color:#b42318; }
        #facilityPage .status-text.is-disabled::before { background:#ef4444; }
#facilityPage .status-text.is-restricted { color:#c2410c; }
#facilityPage .status-text.is-restricted::before { background:#f97316; }
#facilityPage .status-text.is-wait { color:#7c3aed; }
#facilityPage .status-text.is-wait::before { background:#8b5cf6; }
#facilityPage .status-text.is-none { color:#6b7280; }
#facilityPage .status-text.is-none::before { background:#cbd5e1; }
        #facilityPage .badge { display:inline-flex; align-items:center; justify-content:center; min-height:20px; height:20px; padding:0 7px; border-radius:4px; font-size:11px; font-weight:600; line-height:20px; border:1px solid transparent; box-shadow:none; white-space:nowrap; }
        #facilityPage .badge-blue { background:#dbeafe; color:#1e3a5f; border-color:#bfdbfe; }
        #facilityPage .badge-teal { background:#eef8f6; color:#245e55; border-color:#c8e3dd; }
        #facilityPage .badge-gray { background:#e9ece9; color:#374151; border-color:#d1d5db; }

        /* 안내바 */
        #facilityPage .facility-info-line { display:flex; align-items:center; gap:8px; padding:10px 16px; border-top:1px solid var(--line); background:#f8f9fb; font-size:12px; color:#6b7a6e; }
        #facilityPage .facility-info-line .material-symbols-rounded { font-size:15px; color:var(--accent); flex-shrink:0; }
        #facilityPage .facility-info-line a { color:var(--accent); font-weight:700; text-decoration:none; margin-left:4px; }




        @media (max-width:1100px) { #facilityPage .facility-filter-grid { grid-template-columns:1fr 1fr; } }
        @media (max-width:760px) { #facilityPage .asset-summary-row { grid-template-columns:1fr 1fr; } #facilityPage .facility-filter-grid { grid-template-columns:1fr; } }


    </style>

    <script>
        <sec:authorize access="hasRole('ADMIN')" var="facilityAdmin" />
        window.facilityPageConfig = {
            contextPath: "${pageContext.request.contextPath}",
            mgmtOfcNo: "${mgmtOfcNo}",
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
                        <h2>시설자산 관리</h2>
                        <p>단지 내 시설자산 마스터 정보를 등록·조회·관리합니다</p>
                    </div>
                    <div class="page-actions"></div>
                </div>

                <div class="asset-summary-row">
                    <div class="asset-summary-card primary">
                        <div class="summary-icon"><span class="material-symbols-rounded">apartment</span></div>
                        <div><div class="summary-label">전체 시설 총수</div><div class="summary-value" id="statTotal">0</div></div>
                    </div>
                    <div class="asset-summary-card">
                        <div class="summary-icon"><span class="material-symbols-rounded">domain</span></div>
                        <div><div class="summary-label">동 지정 시설</div><div class="summary-value" id="statDong">0</div></div>
                    </div>
                    <div class="asset-summary-card">
                        <div class="summary-icon"><span class="material-symbols-rounded">location_city</span></div>
                        <div><div class="summary-label">공용 위치 시설</div><div class="summary-value" id="statCommonLoc">0</div></div>
                    </div>
                    <div class="asset-summary-card">
                        <div class="summary-icon"><span class="material-symbols-rounded">block</span></div>
                        <div><div class="summary-label">비활성 시설</div><div class="summary-value" id="statDisabled">0</div><div style="font-size:11px;color:#9caa9e;margin-top:2px;" id="statDisabledToday"></div></div>
                    </div>
                </div>

                <div class="panel facility-filter-panel">
                    <div class="panel-header">
                        <h3 class="panel-title"><span class="material-symbols-rounded">manage_search</span>검색 조건</h3>
                    </div>
                    <div class="panel-body">
                        <div class="facility-filter-grid">
                            <div class="form-field">
                                <label class="field-label">시설구분</label>
                                <select class="form-select" id="filterFacilityKind" name="facilityKind">
                                    <option value="ALL">전체</option>
                                    <option value="FACILITY">일반시설</option>
                                    <option value="PUBLIC">편의시설</option>
                                </select>
                            </div>
                            <div class="form-field">
                                <label class="field-label">시설유형</label>
                                <select class="form-select" id="filterFacTy" name="facilityTyCd">
                                    <option value="">전체</option>
                                </select>
                            </div>
                            <div class="form-field">
                                <label class="field-label">운영관리</label>
                                <select class="form-select" id="filterPublicFacilityYn" name="publicFacilityYn">
                                    <option value="">전체</option>
                                    <option value="Y">운영등록</option>
                                    <option value="N">운영미등록</option>
                                </select>
                            </div>
                            <div class="form-field">
                                <label class="field-label">활성여부</label>
                                <select class="form-select" id="filterUseYn" name="useYn">
                                    <option value="">전체</option>
                                    <option value="Y">활성</option>
                                    <option value="N">비활성</option>
                                </select>
                            </div>
                            <div class="form-field">
                                <label class="field-label">이용제한</label>
                                <select class="form-select" id="filterRestrictYn" name="restrictYn">
                                    <option value="">전체</option>
                                    <option value="ONGOING">제한중</option>
                                    <option value="UPCOMING">제한예정</option>
                                    <option value="ENDED">제한종료</option>
                                    <option value="NONE">제한없음</option>
                                </select>
                            </div>
                            <div class="form-field">
                                <label class="field-label">동</label>
                                <select class="form-select" id="filterDong" name="dongNo">
                                    <option value="">전체</option>
                                    <c:forEach var="dong" items="${dongList}">
                                        <option value="${dong.dongNo}">${fn:contains(dong.dongNo, '_') ? fn:substringAfter(dong.dongNo, '_') : (empty dong.dongNm ? dong.dongNo : dong.dongNm)}</option>
                                    </c:forEach>
                                    <option value="_COMMON_">공용 위치</option>
                                </select>
                            </div>
                            <div class="form-field">
                                <label class="field-label">설치일자</label>
                                <input type="date" class="form-input" id="filterInstlDt" name="instlDt">
                            </div>
                            <div class="form-field facility-search-field">
                                <label class="field-label">시설 검색</label>
                                <div class="search-wrap">
                                    <span class="material-symbols-rounded">search</span>
                                    <input type="text" class="form-input" id="filterKeyword" name="keyword" autocomplete="off" placeholder="시설번호 · 시설명 · 상세위치 검색">
                                    <div class="facility-search-suggest" id="facilitySuggestList"></div>
                                </div>
                            </div>
                            <div class="form-field">
                                <label class="field-label">&nbsp;</label>
                                <div class="page-actions">
                                    <button type="button" class="btn btn-secondary btn-sm" data-action="resetFacility">초기화</button>
                                    <button type="button" class="btn btn-primary btn-sm" data-action="searchFacility">검색</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="panel">
                    <div class="panel-header">
                        <div class="list-header-left">
                            <h3 class="panel-title"><span class="material-symbols-rounded">apartment</span>시설자산 목록</h3>
                            <span class="list-count" id="facilityCount">0건</span>
                            <span class="result-desc" id="resultDesc">전체 조건</span>
                        </div>
                        <div class="list-header-right">
                            <%-- 편의시설 운영관리 화면 이동 버튼 --%>
                            <button type="button" class="btn btn-secondary btn-sm" id="publicFacilityManageBtn" data-action="movePublicFacilityManage">
                                <span class="material-symbols-rounded">settings</span>편의시설 운영관리
                            </button>
                            <button type="button" class="btn btn-secondary btn-sm" data-action="exportExcel"><span class="material-symbols-rounded">download</span>엑셀 다운로드</button>
                            <sec:authorize access="!hasRole('ADMIN')">
                                <button type="button" class="btn btn-primary btn-sm" data-action="openRegister"><span class="material-symbols-rounded">add</span>시설 등록</button>
                            </sec:authorize>
                        </div>
                    </div>
                    <div class="facility-grid-wrap"><div id="facilityGrid" class="ag-theme-alpine"></div></div>
                    <div class="facility-info-line">
                        <span class="material-symbols-rounded">info</span>
                        헬스장·독서실 등 편의시설에 대한 운영 관리는 편의시설 관리에서 진행합니다.
                        <%-- //** 수정: 실제 편의시설 운영관리 목록 매핑으로 이동 --%>
                        <a href="${pageContext.request.contextPath}/manager/publicFacility/page/${mgmtOfcNo}">편의시설 관리 →</a>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/manager/ag-grid-community.min.js"></script>
<script src="${pageContext.request.contextPath}/js/manager/manager-common.js"></script>
<script src="${pageContext.request.contextPath}/js/manager/manager-agGrid.js"></script>
<script src="${pageContext.request.contextPath}/js/manager/AgRenderer.js"></script>
<script src="${pageContext.request.contextPath}/js/manager/facility/mngr-facility-grid.js"></script>
<script>
    /* ============================================================
       시설자산 목록 화면 스크립트

       이 JSP의 JS 역할
       - 이 파일은 “시설 목록 화면”만 담당한다.
       - 등록/수정 폼 화면을 직접 그리지 않는다.
       - 상세 화면을 직접 그리지 않는다.
       - 등록/수정/상세 버튼을 누르면 해당 JSP 화면으로 이동만 한다.

       유지 기능
       - 목록 조회
       - 시설구분 / 시설유형 / 운영관리 / 활성여부 / 동 / 검색어 필터 조회
       - 시설유형 select에서 일반시설 / 편의시설 optgroup 구분
       - 검색어 자동완성
       - 등록 / 상세 / 수정 화면 이동
       - AG Grid 출력
       - 엑셀 다운로드

       읽는 순서
       1. 기본 설정
       2. 공통 함수
       3. 페이지 이동
       4. 검색 조건
       5. 시설유형 필터
       6. 목록 / 현황 카드
       7. 자동완성
       8. 엑셀 다운로드
       9. 이벤트 처리
       10. 초기 실행

       목록 상태 유지 기준
       - 상세/수정 화면에서 목록 복귀 : 필터 유지
       - 사이드바/상단 메뉴/다른 화면에서 목록 진입 : 필터 초기화
       - 초기화 버튼 클릭 : 필터 초기화
    ============================================================ */
    (function () {

        /* ============================================================
           1. 기본 설정
           - JSP에서 내려준 값과 현재 화면에서 계속 써야 하는 상태값
        ============================================================ */

        /*
         * config
         * - JSP 상단 window.facilityPageConfig에 담아둔 화면 설정값
         * - contextPath, mgmtOfcNo, isAdmin을 꺼내기 위한 원본 객체
         */
        var config = window.facilityPageConfig || {};

        /*
         * contextPath
         * - 프로젝트 기본 경로
         * - 예: "" 또는 "/STEVEN_ZIPS"
         * - fetch 요청 주소와 화면 이동 주소 앞에 붙인다.
         */
        var contextPath = config.contextPath || "";

        /*
         * mgmtOfcNo
         * - 현재 조회 중인 관리사무소 번호
         * - 모든 목록/필터/화면 이동 URL에 들어간다.
         */
        var mgmtOfcNo = config.mgmtOfcNo || "";

        /*
         * isAdmin
         * - 현재 로그인 사용자가 ADMIN인지 여부
         * - ADMIN은 조회만 가능하므로 수정 화면 이동을 막기 위해 사용한다.
         */
        var isAdmin = config.isAdmin === true || config.isAdmin === "true";


        /*
         * currentList
         * - 서버에서 조회한 현재 시설 목록 배열
         * - AG Grid에 넣는 데이터이면서 자동완성과 엑셀 다운로드에서도 재사용한다.
         */
        var currentList = [];

        /*
         * suggestTimer
         * - 검색어 자동완성용 타이머
         * - 사용자가 키를 입력할 때마다 바로 실행하지 않고 0.18초 뒤에 한 번만 실행하기 위해 사용한다.
         */
        var suggestTimer = null;

        /*
         * restoreState
         * - 상세/수정 화면 이동 후 목록 복귀 시 복원 대상 상태
         * - sessionStorage에서 읽어온 목록 상태 임시 보관
         */
        var restoreState = null;

        /*
         * STORAGE_KEY
         * - 시설자산 목록 상태 저장 key
         * - 관리사무소별 목록 상태 구분용 key
         */
        var STORAGE_KEY = "facilityListState:" + mgmtOfcNo;

        /*
         * PUBLIC_TYPE_CODES
         * - 편의시설로 취급할 시설유형 코드 목록
         * - 시설유형 select에서 일반시설 / 편의시설 optgroup을 나눌 때 사용한다.
         */
        var PUBLIC_TYPE_CODES = ["MEET", "PARK", "PLAY", "COMM", "GYM", "STUDY", "PARKING"];

        /* ============================================================
           2. 공통 함수
           - 여러 함수에서 반복해서 쓰는 짧은 도우미 함수
        ============================================================ */

        /**
         * id로 DOM 요소 찾기
         * - document.getElementById(...)를 짧게 쓰기 위한 함수
         * - 예: el("filterKeyword")
         */
        function el(id) {
            return document.getElementById(id);
        }

        /**
         * 시설 API 주소 만들기
         * - JSON 데이터를 주고받는 Controller 주소용
         * - 예: apiUrl("list/12") → /manager/facility/list/12
         */
        function apiUrl(path) {
            return contextPath + "/manager/facility/" + path;
        }

        /**
         * 시설 JSP 화면 이동 주소 만들기
         * - 등록/수정/상세 JSP로 이동할 때 사용
         * - 현재는 apiUrl과 같은 앞주소를 쓰지만, 의미를 구분하려고 따로 둔다.
         */
        function pageUrl(path) {
            return contextPath + "/manager/facility/" + path;
        }

        /**
         * 알림 출력
         * - 프로젝트 공통 showAlert가 있으면 그것을 사용
         * - 없으면 기본 alert 사용
         */
        function alertMessage(message, icon) {
            if (typeof showAlert === "function") {
                return showAlert(message, icon);
            }
            alert(message);
            return Promise.resolve();
        }

        /**
         * HTML 특수문자 변환
         * - 자동완성 HTML을 문자열로 만들 때 XSS 방지용으로 사용
         * - 사용자가 입력하거나 DB에서 온 값을 HTML에 직접 넣기 전에 거친다.
         */
        function escapeHtml(value) {
            if (value == null) return "";
            return String(value)
                .replace(/&/g, "&amp;")
                .replace(/</g, "&lt;")
                .replace(/>/g, "&gt;")
                .replace(/\"/g, "&quot;")
                .replace(/'/g, "&#39;");
        }

        /**
         * CSRF 헤더 만들기
         * - Spring Security CSRF가 켜져 있을 때 fetch 요청에 필요한 헤더
         * - JSP의 <sec:csrfMetaTags/>가 만든 meta 태그에서 token/header 이름을 읽는다.
         */
        function getCsrfHeaders() {
            var tokenMeta = document.querySelector('meta[name="_csrf"]');
            var headerMeta = document.querySelector('meta[name="_csrf_header"]');
            var headers = {};

            if (tokenMeta && headerMeta) {
                headers[headerMeta.getAttribute("content")] = tokenMeta.getAttribute("content");
            }

            return headers;
        }

        /**
         * GET 방식 JSON 요청
         * - 목록 조회, 시설유형 조회 등에 사용
         * - 서버가 success:false를 주면 catch로 넘기기 위해 Error를 발생시킨다.
         */
        async function getJson(url) {
            var response = await fetch(url, {
                method: "GET",
                headers: getCsrfHeaders()
            });

            var text = await response.text();
            var data = {};

            try {
                data = text ? JSON.parse(text) : {};
            } catch (e) {
                throw new Error("서버 응답을 JSON으로 해석할 수 없습니다. 관리자에게 서버 로그 확인을 요청하세요.");
            }

            if (!response.ok || data.success === false) {
                throw new Error(data.message || "요청 처리 중 오류가 발생했습니다.");
            }

            return data;
        }

        /**
         * 여러 이름 중 실제 값 읽기
         * - 서버에서 Map으로 내려오면 CODE처럼 대문자 키가 올 수 있고,
         *   DTO/VO로 내려오면 code 같은 camelCase 키가 올 수 있다.
         * - 그 차이를 흡수하려고 후보 key 목록을 순서대로 확인한다.
         */
        function readValue(row, keyList) {
            row = row || {};

            for (var i = 0; i < keyList.length; i++) {
                if (row[keyList[i]] != null) {
                    return row[keyList[i]];
                }
            }

            return "";
        }

        /* ============================================================
           3. 페이지 이동
           - list.jsp에서는 등록/수정/상세 화면을 직접 열지 않고 이동만 한다.
        ============================================================ */

        /**
         * 시설자산 목록 상태 저장
         * - 상세/수정 화면 이동 전 현재 검색조건, 페이지 번호 저장
         * - 브라우저 탭 단위 저장을 위한 sessionStorage 사용
         */
        function saveListState() {
            /*
             * currentPage
             * - AG Grid 현재 페이지 번호
             * - 상세/수정 화면에서 목록으로 돌아올 때 같은 페이지를 복원하기 위해 저장한다.
             */
            var currentPage = FacilityGrid.getCurrentPage();

            /* 저장 대상 목록 상태 */
            var state = {
                page: currentPage,
                facilityKind: el("filterFacilityKind").value,
                facilityTyCd: el("filterFacTy").value,
                publicFacilityYn: el("filterPublicFacilityYn").value,
                useYn: el("filterUseYn").value,
                restrictYn: el("filterRestrictYn").value,
                dongNo: el("filterDong").value,
                instlDt: el("filterInstlDt").value,
                keyword: el("filterKeyword").value
            };

            /* 목록 상태 세션 저장 */
            sessionStorage.setItem(STORAGE_KEY, JSON.stringify(state));
        }

        /**
         * 시설자산 목록 상태 조회
         * - sessionStorage에 저장된 이전 목록 상태 조회
         * - JSON 파싱 실패 시 복원 제외
         */
        function readListState() {
            /* 저장 상태 문자열 */
            var savedText = sessionStorage.getItem(STORAGE_KEY);

            /* 저장 상태 없음 */
            if (!savedText) {
                return null;
            }

            try {
                /* 저장 상태 객체 변환 */
                return JSON.parse(savedText);
            } catch (e) {
                /* 저장 상태 파싱 실패 로그 */
                console.warn("시설자산 목록 상태 복원 실패", e);

                return null;
            }
        }

        /**
         * 목록 상태 복원 가능 여부
         * - 상세 화면 복귀 시 복원 대상
         * - 수정 화면 복귀 시 복원 대상
         * - 메뉴/탭 신규 진입 시 초기화 대상
         */
        function canRestoreListState() {
            /* 이전 페이지 주소 */
            var referrer = document.referrer || "";

            /* 상세 화면 복귀 여부 */
            var fromDetailPage = referrer.indexOf("/manager/facility/detail-page/") > -1;

            /* 수정 화면 복귀 여부 */
            var fromUpdatePage = referrer.indexOf("/manager/facility/update-page/") > -1;

            /* 상세/수정 복귀 여부 */
            return fromDetailPage || fromUpdatePage;
        }

        /**
         * 시설자산 목록 상태 반영
         * - 저장된 검색조건 화면 반영
         * - 시설유형은 옵션 생성 후 따로 반영 필요
         */
        function applyListState(state) {
            /* 복원 상태 없음 */
            if (!state) return;

            /* 시설구분 조건 반영 */
            el("filterFacilityKind").value = state.facilityKind || "ALL";

            /* 활성여부 조건 반영 */
            el("filterUseYn").value = state.useYn || "";

            /* 현재 점검 이용제한 조건 반영 */
            el("filterRestrictYn").value = state.restrictYn || "";

            /* 동 조건 반영 */
            el("filterDong").value = state.dongNo || "";

            /* 설치일자 조건 반영 */
            el("filterInstlDt").value = state.instlDt || "";

            /* 검색어 조건 반영 */
            el("filterKeyword").value = state.keyword || "";

            if (el("filterPublicFacilityYn")) {
                el("filterPublicFacilityYn").value = state.publicFacilityYn || "";
            }
        }

        /** 시설 등록 화면 이동 */
        function moveRegisterPage() {
            location.href = pageUrl("register/" + encodeURIComponent(mgmtOfcNo));
        }

        /** 시설 상세 화면 이동 */
        function moveDetailPage(facilityNo) {
            /* 목록 상태 저장 */
            saveListState();

            /* 상세 화면 이동 */
            location.href = pageUrl(
                "detail-page/" + encodeURIComponent(mgmtOfcNo) + "/" + encodeURIComponent(facilityNo)
            );
        }

        /** 시설 수정 화면 이동 */
        function moveUpdatePage(facilityNo) {
            /* 관리자 수정 제한 */
            if (isAdmin) {
                alertMessage("관리자는 조회만 가능합니다.");
                return;
            }

            /* 목록 상태 저장 */
            saveListState();

            /* 수정 화면 이동 */
            location.href = pageUrl(
                "update-page/" + encodeURIComponent(mgmtOfcNo) + "/" + encodeURIComponent(facilityNo)
            );
        }

        /* ============================================================
           4. 검색 조건
           - 현재 필터 값을 읽고 URLSearchParams로 만든다.
        ============================================================ */

        /**
         * 현재 검색 조건 수집
         * - 시설구분, 시설유형, 운영관리, 활성여부, 동, 설치일자, 검색어를 서버로 전달
         */
        function getSearchParams() {
            var params = new URLSearchParams();

            var facilityKindSelect = el("filterFacilityKind");          // 시설구분 select
            var publicFacilitySelect = el("filterPublicFacilityYn");    // 운영관리 select

            /* 시설구분 조건 */
            params.append("facilityKind", facilityKindSelect ? facilityKindSelect.value : "ALL");

            /* 시설유형 조건 */
            if (el("filterFacTy").value) {
                params.append("facilityTyCd", el("filterFacTy").value);
            }

            /* 운영관리 등록 여부 조건 */
            if (publicFacilitySelect && publicFacilitySelect.value) {
                params.append("publicFacilityYn", publicFacilitySelect.value);
            }

            /* 활성여부 조건 */
            if (el("filterUseYn").value) {
                params.append("useYn", el("filterUseYn").value);
            }

            /* 현재 점검 이용제한 조건 */
            if (el("filterRestrictYn").value) {
                params.append("restrictYn", el("filterRestrictYn").value);
            }

            /* 동 조건 */
            if (el("filterDong").value) {
                params.append("dongNo", el("filterDong").value);
            }

            /* 설치일자 조건 */
            appendInstallDateParams(params);

            /* 검색어 조건 */
            if (el("filterKeyword").value.trim()) {
                params.append("keyword", el("filterKeyword").value.trim());
            }

            return params;
        }
        /**
         * 설치일자 조건 추가
         * - 화면에서는 날짜 하나만 선택한다.
         * - 서버 검색 조건은 기존 범위 파라미터를 재사용한다.
         */
        function appendInstallDateParams(params) {
            var instlDt = el("filterInstlDt").value;

            if (instlDt) {
                params.append("instlStartDt", instlDt);
                params.append("instlEndDt", instlDt);
            }
        }

        /** 검색 조건 초기화 후 목록 재조회 */
        function resetSearch() {
            /* 시설구분 조건 초기화 */
            el("filterFacilityKind").value = "ALL";

            /* 시설유형 조건 초기화 */
            el("filterFacTy").value = "";

            /* 운영관리 조건 초기화 */
            el("filterPublicFacilityYn").value = "";

            /* 활성여부 조건 초기화 */
            el("filterUseYn").value = "";

            /* 현재 점검 이용제한 조건 초기화 */
            el("filterRestrictYn").value = "";

            /* 동 조건 초기화 */
            el("filterDong").value = "";

            /* 설치일자 조건 초기화 */
            el("filterInstlDt").value = "";

            /* 검색어 조건 초기화 */
            el("filterKeyword").value = "";

            /* 저장 목록 상태 삭제 */
            sessionStorage.removeItem(STORAGE_KEY);

            /* 복원 상태 초기화 */
            restoreState = null;

            /* 자동완성 닫기 */
            closeSuggestList();

            /* 그리드 필터 초기화 */
            FacilityGrid.reset();

            /* 시설자산 목록 재조회 */
            loadFacilityList();
        }

        /**
         * 목록 상단 설명 문구 만들기
         * - 예: 운영관리: 운영등록 · 활성여부: 활성 · 검색어: 승강기
         * - 실제 조회 조건을 사용자가 볼 수 있게 보여주는 용도
         */
        function makeFilterText() {
            /*
             * labels
             * - 화면 상단 목록 설명에 표시할 검색 조건 문구 모음
             * - 조건이 하나도 없으면 마지막에 "전체 조건"을 반환한다.
             */
            var labels = [];

            /*
             * facilityKindSelect
             * - 시설 대분류 필터
             * - ALL      : 전체
             * - FACILITY : 일반시설
             * - PUBLIC   : 편의시설
             */
            var facilityKindSelect = el("filterFacilityKind");

            /*
             * typeSelect
             * - 시설 세부유형 필터
             * - 승강기, 소방시설, 독서실 같은 FACILITY_TY 코드 기준
             */
            var typeSelect = el("filterFacTy");

            /*
             * publicFacilityYnSelect
             * - 편의시설 운영관리 등록 여부 필터
             * - Y : PUBLIC_FACILITY에 운영정보 등록
             * - N : 편의시설 유형이지만 운영정보 미등록
             */
            var publicFacilityYnSelect = el("filterPublicFacilityYn");

            /*
             * useYnSelect
             * - 시설 사용 여부 필터
             * - Y : 활성
             * - N : 비활성
             */
            var useYnSelect = el("filterUseYn");

            /*
             * restrictYnSelect
             * - 현재 점검 이용제한 필터
             * - Y : 제한중
             * - N : 제한없음
             */
            var restrictYnSelect = el("filterRestrictYn");

            /*
             * dongSelect
             * - 시설 위치 동 필터
             * - _COMMON_은 동이 없는 공용 위치 시설 조회용
             */
            var dongSelect = el("filterDong");

            /*
             * instlDt
             * - 설치일자 단일 날짜 조건
             */
            var instlDt = el("filterInstlDt").value;

            /*
             * keyword
             * - 시설번호, 시설명, 상세위치 통합 검색어
             */
            var keyword = el("filterKeyword").value.trim();

            /* 시설구분 조건 문구 */
            if (facilityKindSelect.value !== "ALL") {
                labels.push("시설구분: " + facilityKindSelect.options[facilityKindSelect.selectedIndex].text);
            }

            /* 시설유형 조건 문구 */
            if (typeSelect.value) {
                labels.push("시설유형: " + typeSelect.options[typeSelect.selectedIndex].text);
            }

            /* 운영관리 등록 여부 조건 문구 */
            if (publicFacilityYnSelect.value) {
                labels.push("운영관리: " + publicFacilityYnSelect.options[publicFacilityYnSelect.selectedIndex].text);
            }

            /* 활성여부 조건 문구 */
            if (useYnSelect.value) {
                labels.push("활성여부: " + useYnSelect.options[useYnSelect.selectedIndex].text);
            }

            /* 현재 점검 이용제한 조건 문구 */
            if (restrictYnSelect.value) {
                labels.push("이용제한: " + restrictYnSelect.options[restrictYnSelect.selectedIndex].text);
            }

            /* 동 조건 문구 */
            if (dongSelect.value) {
                labels.push("동: " + dongSelect.options[dongSelect.selectedIndex].text);
            }

            /* 설치일자 조건 문구 */
            if (instlDt) {
                labels.push("설치일자: " + instlDt);
            }

            /* 검색어 조건 문구 */
            if (keyword) {
                labels.push("검색어: " + keyword);
            }

            /* 조건이 없을 때 기본 문구 */
            return labels.length > 0 ? labels.join(" · ") : "전체 조건";
        }



        /* ============================================================
           5. 시설유형 필터
           - 목록은 탭으로 나누지 않고 전체 시설을 함께 조회한다.
           - 시설유형 select 안에서 일반시설 / 편의시설을 optgroup으로 구분한다.
        ============================================================ */

        /**
         * 편의시설 운영관리 화면 이동
         * - 운영시간/예약/요금 등은 시설자산이 아니라 공용시설 운영관리에서 처리
         */
        function movePublicFacilityManagePage() {
            /* 편의시설 관리 화면 이동 */
            location.href = contextPath + "/manager/publicFacility/page/" + encodeURIComponent(mgmtOfcNo);
        }

        /**
         * 시설유형 필터 목록 조회 및 화면 출력
         * - 일반시설과 편의시설을 한 select 안에서 그룹으로 구분한다.
         * - 목록 조회 자체는 항상 FACILITY 전체 기준으로 조회한다.
         * - 시설유형 select 구성에는 전체 유형이 필요하므로 facilityKind=ALL로 조회한다.
         */
        async function loadFacilityTypeFilter() {
            var select = el("filterFacTy");
            var url = apiUrl("type/list/" + encodeURIComponent(mgmtOfcNo) + "?facilityKind=ALL");

            try {
                var result = await getJson(url);
                var typeList = result.typeList || result.list || [];

                select.innerHTML = '<option value="">전체</option>';

                drawGroupedTypeOptions(select, typeList);
            } catch (e) {
                console.error(e);
                select.innerHTML = '<option value="">전체</option>';
            }
        }

        /**
         * 시설유형 select optgroup 구성
         * - 일반시설 그룹에는 소방시설, 전기시설, 급수시설 등 기본 시설유형을 표시한다.
         * - 편의시설 그룹에는 헬스장, 독서실, 놀이터 등 운영관리 대상 시설유형을 표시한다.
         */
        function drawGroupedTypeOptions(select, typeList) {
            var normalGroup = document.createElement("optgroup");
            var publicGroup = document.createElement("optgroup");

            normalGroup.label = "일반시설";
            publicGroup.label = "편의시설";

            typeList.forEach(function (item) {
                var code = readValue(item, ["code", "CODE", "codeNoCd", "CODE_NO_CD"]);
                var name = readValue(item, ["codeNm", "CODENM", "CODE_NM", "codeName", "CODE_NAME"]);
                var kind = readValue(item, ["facilityKind", "FACILITYKIND", "FACILITY_KIND", "facility_kind"]);

                if (!code) return;

                if (isPublicType(code, kind)) {
                    publicGroup.appendChild(makeOption(code, name || code));
                    return;
                }

                normalGroup.appendChild(makeOption(code, name || code));
            });

            if (normalGroup.children.length > 0) {
                select.appendChild(normalGroup);
            }

            if (publicGroup.children.length > 0) {
                select.appendChild(publicGroup);
            }
        }

        /** 해당 시설유형 코드가 편의시설인지 확인 */
        function isPublicType(code, kind) {
            code = String(code || "").toUpperCase();
            kind = String(kind || "").toUpperCase();

            return kind === "PUBLIC" || PUBLIC_TYPE_CODES.indexOf(code) > -1;
        }

        /** select option 생성 */
        function makeOption(value, text) {
            var option = document.createElement("option");
            option.value = value;
            option.textContent = text;
            return option;
        }

        /* ============================================================
           6. 목록 / 현황 카드
           - 서버에서 시설 목록을 가져와 AG Grid와 현황 카드를 갱신한다.
        ============================================================ */

        /**
         * 시설 목록 조회
         * - 현재 선택된 필터/검색어를 서버로 보낸다.
         * - 받은 목록을 currentList에 저장한다.
         * - AG Grid와 현황 카드 값을 갱신한다.
         */
        async function loadFacilityList() {
            var params = getSearchParams();
            var url = apiUrl("list/" + encodeURIComponent(mgmtOfcNo));

            if (params.toString()) {
                url += "?" + params.toString();
            }

            try {
                var result = await getJson(url);
                /* 조회 목록 반영 */
                currentList = result.list || result.facilityList || [];

                /* 그리드 행 데이터 반영 */
                FacilityGrid.setRows(currentList);

                /* 저장 페이지 복원 */
                if (restoreState && restoreState.page != null) {
                    /* 저장 페이지 번호 */
                    var restorePageNo = Number(restoreState.page) || 0;

                    /* 저장 페이지 이동 예약 */
                    setTimeout(function () {
                        /* 저장 페이지 이동 */
                        FacilityGrid.goToPage(restorePageNo);
                    }, 0);

                    /* 복원 상태 초기화 */
                    restoreState = null;
                }

                /* 목록 헤더 갱신 */
                updateListHeader(currentList.length);

                /* 현황 카드 갱신 */
                updateStats(currentList, result.stats || {});
            } catch (e) {
                console.error(e);
                alertMessage(e.message || "시설 목록 조회 중 오류가 발생했습니다.");

                currentList = [];
                FacilityGrid.setRows([]);
                updateListHeader(0);
                updateStats([], {});
            }
        }

        /** 목록 제목 옆 건수와 조건 설명 갱신 */
        function updateListHeader(count) {
            el("facilityCount").textContent = (count || 0) + "건";
            el("resultDesc").textContent = makeFilterText();
        }

        /**
         * 현황 카드 갱신
         * - 서버에서 stats가 오면 그 값을 우선 사용
         * - stats가 없으면 현재 목록 currentList 기준으로 화면에서 계산
         */
        function updateStats(list, stats) {
            stats = stats || {};
            list = list || [];

            var dongCnt = stats.dongCnt != null ? stats.dongCnt : countDongFacility(list);
            var commonLocCnt = stats.commonLocCnt != null ? stats.commonLocCnt : countCommonFacility(list);
            var disabledTotal = stats.disabledTotal != null ? stats.disabledTotal : countDisabledFacility(list);
            var disabledToday = stats.disabledToday != null ? Number(stats.disabledToday) : 0;

            el("statTotal").textContent = list.length;
            el("statDong").textContent = dongCnt;
            el("statCommonLoc").textContent = commonLocCnt;
            el("statDisabled").textContent = disabledTotal;
            el("statDisabledToday").textContent = disabledToday > 0 ? "오늘 " + disabledToday + "건 추가" : "";
        }

        /** 동 번호가 있는 시설 수 계산 */
        function countDongFacility(list) {
            return list.filter(function (row) {
                return row.dongNo;
            }).length;
        }

        /** 동 번호가 없는 공용 위치 시설 수 계산 */
        function countCommonFacility(list) {
            return list.filter(function (row) {
                return !row.dongNo;
            }).length;
        }

        /** 사용여부가 N인 이용불가 시설 수 계산 */
        function countDisabledFacility(list) {
            return list.filter(function (row) {
                return row.useYn === "N";
            }).length;
        }

        /* ============================================================
           7. 자동완성
           - 현재 조회된 목록(currentList) 안에서만 후보를 보여준다.
        ============================================================ */

        /**
         * 자동완성 실행 예약
         * - input 이벤트마다 바로 검색하지 않고 180ms 뒤에 실행
         * - 빠르게 타이핑할 때 불필요한 반복 실행 방지
         */
        function scheduleSuggest() {
            clearTimeout(suggestTimer);

            suggestTimer = setTimeout(function () {
                showSuggestList(el("filterKeyword").value);
            }, 180);
        }

        /**
         * 자동완성 목록 표시
         * - 검색어가 2글자 미만이면 닫기
         * - currentList에서 시설번호/시설명/유형/위치 등이 일치하는 최대 5건 표시
         */
        function showSuggestList(keyword) {
            var area = el("facilitySuggestList");
            var key = String(keyword || "").trim().toLowerCase();

            if (key.length < 2) {
                closeSuggestList();
                return;
            }

            var matched = currentList.filter(function (row) {
                return makeSearchText(row).indexOf(key) > -1;
            }).slice(0, 5);

            if (matched.length === 0) {
                area.innerHTML = '<div class="suggest-empty">일치하는 시설 후보가 없습니다.</div>';
                area.classList.add("open");
                return;
            }

            area.innerHTML = matched.map(makeSuggestHtml).join("");
            area.classList.add("open");
        }

        /** 자동완성 영역 닫기 */
        function closeSuggestList() {
            var area = el("facilitySuggestList");
            area.classList.remove("open");
            area.innerHTML = "";
        }

        /**
         * 자동완성 검색용 문자열 만들기
         * - 한 시설 row의 여러 컬럼을 하나의 문자열로 합친다.
         * - 검색어가 이 문자열 안에 포함되면 자동완성 후보로 표시한다.
         */
        function makeSearchText(row) {
            return [
                row.facilityNo,
                row.facilityNm,
                row.facilityTyNm,
                row.facilityTyCd,
                row.locCn,
                row.dongNo,
                row.useYn === "N" ? "비활성" : "활성"
            ].join(" ").toLowerCase();
        }

        /** 자동완성 후보 1건 HTML 생성 */
        function makeSuggestHtml(row) {
            var facilityNo = row.facilityNo || "";
            var facilityNm = row.facilityNm || "-";
            var locCn = row.locCn || "위치 정보 없음";

            return '<button type="button" class="suggest-item" data-action="selectSuggest" data-keyword="' + escapeHtml(facilityNo) + '">'
                + '<div class="suggest-main">'
                + '<span class="suggest-no">' + escapeHtml(facilityNo) + '</span>'
                + '<span>' + escapeHtml(facilityNm) + '</span>'
                + '</div>'
                + '<div class="suggest-sub">' + escapeHtml(locCn) + '</div>'
                + '</button>';
        }

        /**
         * 시설 활성여부 전환 요청
         * - 활성 시설은 비활성 처리
         * - 비활성 시설은 활성 처리
         * - 서버 API 주소가 프로젝트와 다르면 Controller 매핑명에 맞춰 path만 수정
         */
        async function toggleFacilityUseYn(facilityNo, currentUseYn) {
            /* 시설번호 없음 방어 */
            if (!facilityNo) return;

            /* ADMIN 쓰기 방어 */
            if (isAdmin) {
                alertMessage("관리자는 조회만 가능합니다.");
                return;
            }

            /* 다음 활성여부 값 */
            var nextUseYn = currentUseYn === "N" ? "Y" : "N";

            /* 사용자 확인 문구 */
            var confirmMessage = nextUseYn === "N"
                ? "해당 시설을 비활성 처리하시겠습니까?"
                : "해당 시설을 활성 처리하시겠습니까?";

            /* 취소 처리 */
            var confirmResult = await showConfirm({
                title: confirmMessage,
                confirmText: nextUseYn === "N" ? "비활성" : "활성"
            });
            if (!confirmResult.isConfirmed) return;

            try {
                //** 수정: FacilityController의 실제 사용여부 변경 매핑(/use/update/{mgmtOfcNo}) 호출
                var response = await fetch(apiUrl("use/update/" + encodeURIComponent(mgmtOfcNo)), {
                    method: "POST",
                    headers: Object.assign({
                        "Content-Type": "application/json"
                    }, getCsrfHeaders()),
                    body: JSON.stringify({
                        facilityNo: facilityNo,
                        useYn: nextUseYn
                    })
                });

                /* 응답 JSON */
                var result = await response.json();

                /* 실패 응답 처리 */
                if (!response.ok || result.success === false) {
                    throw new Error(result.message || "활성여부 변경 중 오류가 발생했습니다.");
                }

                /* 완료 알림 */
                await alertMessage(
                    nextUseYn === "N" ? "비활성 처리되었습니다." : "활성 처리되었습니다.",
                    "success"
                );

                /* 목록 재조회 */
                loadFacilityList();
            } catch (e) {
                console.error(e);
                alertMessage(e.message || "활성여부 변경 중 오류가 발생했습니다.");
            }
        }

        /* ============================================================
           8. 엑셀 다운로드
           - 실제 다운로드 기능은 mngr-facility-grid.js의 FacilityGrid.exportExcel 사용
        ============================================================ */

        /** 현재 목록 엑셀/CSV 다운로드 */
        function exportExcel() {
            if (currentList.length === 0) {
                alertMessage("다운로드할 시설 목록이 없습니다.");
                return;
            }

            /* AG Grid 현재 행 데이터 CSV 다운로드 */
            FacilityGrid.exportExcel("시설자산_목록.csv");
        }

        /* ============================================================
           9. 이벤트 처리
           - HTML의 data-action 값을 보고 어떤 동작을 할지 결정.
        ============================================================ */

        /**
         * 클릭 이벤트 처리
         * - 등록/상세/수정/검색/초기화/엑셀/자동완성 선택 버튼 처리
         */
        function handleClick(event) {
            var button = event.target.closest("[data-action]");
            if (!button) return;

            var action = button.dataset.action;
            var facilityNo = button.dataset.rowKey || button.dataset.keyword;

            if (action === "openRegister") {
                moveRegisterPage();
                return;
            }

            if (action === "detail") {
                moveDetailPage(facilityNo);
                return;
            }

            if (action === "edit") {
                moveUpdatePage(facilityNo);
                return;
            }

            if (action === "searchFacility") {
                closeSuggestList();
                loadFacilityList();
                return;
            }

            if (action === "resetFacility") {
                resetSearch();
                return;
            }

            if (action === "exportExcel") {
                exportExcel();
                return;
            }

            if (action === "movePublicFacilityManage") {
                movePublicFacilityManagePage();
                return;
            }

            if (action === "toggleUseYn") {
                toggleFacilityUseYn(facilityNo, button.dataset.useYn);
                return;
            }

            if (action === "selectSuggest") {
                el("filterKeyword").value = button.dataset.keyword || "";
                closeSuggestList();
                loadFacilityList();
            }
        }

        /**
         * select 변경 이벤트 처리
         * - 필터 변경 시 목록 재조회
         */
        function handleChange(event) {
            if (event.target.id === "filterFacTy") {
                handleTypeFilterChange(event.target.value);
                return;
            }

            if (
                event.target.id === "filterFacilityKind" ||
                event.target.id === "filterPublicFacilityYn" ||
                event.target.id === "filterUseYn" ||
                event.target.id === "filterRestrictYn" ||
                event.target.id === "filterDong" ||
                event.target.id === "filterInstlDt"
            ) {
                closeSuggestList();
                loadFacilityList();
            }
        }

        /**
         * 시설유형 필터 변경 처리
         * - 탭 이동 없이 현재 목록을 선택한 시설유형으로 다시 조회한다.
         */
        function handleTypeFilterChange(value) {
            closeSuggestList();
            loadFacilityList();
        }

        /**
         * 이벤트 연결
         * - 목록 화면에서 발생하는 클릭/변경/검색 입력 이벤트를 함수와 연결한다.
         */
        function bindEvents() {
            el("facilityPage").addEventListener("click", handleClick);
            el("facilityPage").addEventListener("change", handleChange);

            el("filterKeyword").addEventListener("input", scheduleSuggest);
            el("filterKeyword").addEventListener("keyup", function (event) {
                if (event.key === "Enter") {
                    closeSuggestList();
                    loadFacilityList();
                }
                if (event.key === "Escape") {
                    closeSuggestList();
                }
            });

            document.addEventListener("click", function (event) {
                if (!event.target.closest(".facility-search-field")) {
                    closeSuggestList();
                }
            });

            window.addEventListener("resize", function () {
                /* 화면 크기 변경 시 컬럼 폭 재계산 */
                FacilityGrid.refreshSize();
            });
        }

        /* ============================================================
           10. 초기 실행
           - 화면 로딩이 끝난 뒤 그리드 초기화, 이벤트 연결, 첫 목록 조회를 실행한다.
        ============================================================ */

        document.addEventListener("DOMContentLoaded", function () {
            /* 이전 목록 상태 조회 */
            restoreState = readListState();

            /*
             * 목록 상태 복원 기준
             * - 상세 화면 복귀 : 검색조건 복원 대상
             * - 수정 화면 복귀 : 검색조건 복원 대상
             * - 사이드바/상단 메뉴/다른 화면 진입 : 검색조건 초기화 대상
             */
            if (restoreState && !canRestoreListState()) {
                /* 저장 목록 상태 삭제 */
                sessionStorage.removeItem(STORAGE_KEY);

                /* 복원 상태 초기화 */
                restoreState = null;
            }

            /*
             * 시설자산 그리드 초기화
             * - mngr-facility-grid.js FacilityGrid 객체 기준
             * - 오류 발생 시 콘솔 노출 기준
             */
            FacilityGrid.init("facilityGrid");

            /*
             * 화면 이벤트 연결
             * - 검색 버튼 연결
             * - 초기화 버튼 연결
             * - 등록/상세/수정 버튼 연결
             * - 엑셀 다운로드 버튼 연결
             */
            bindEvents();

            /* 저장 검색조건 반영 */
            applyListState(restoreState);

            /* 시설유형 필터 생성 후 목록 조회 */
            loadFacilityTypeFilter().then(function () {
                /* 시설유형 조건 반영 */
                if (restoreState && restoreState.facilityTyCd) {
                    el("filterFacTy").value = restoreState.facilityTyCd;
                }

                /* 시설자산 목록 조회 */
                return loadFacilityList();
            });
        });

    })();
</script>
</body>
</html>
