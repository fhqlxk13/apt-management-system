<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>단지 일정 캘린더</title>

  <sec:csrfMetaTags/>

  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
  <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet" />

  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/office-layout.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/manager-common.css">

  <style>
    #aptScheduleCalendarPage .calendar-topbar { display:flex; justify-content:space-between; align-items:center; gap:12px; margin-bottom:14px; }
    #aptScheduleCalendarPage .calendar-nav { display:flex; align-items:center; justify-content:center; gap:10px; }
    #aptScheduleCalendarPage .calendar-title { min-width:110px; text-align:center; font-size:18px; font-weight:800; color:#172033; }
    #aptScheduleCalendarPage .filter-row { display:flex; align-items:center; gap:8px; flex-wrap:wrap; padding:14px; border:1px solid var(--border); border-radius:12px; background:#fff; margin-bottom:14px; }
    #aptScheduleCalendarPage .filter-row select { width:160px; }
    #aptScheduleCalendarPage .filter-row input { width:280px; }

    #aptScheduleCalendarPage .legend-row { display:flex; align-items:center; gap:10px; flex-wrap:wrap; margin:10px 0 14px; padding-left:22px; font-size:12px; color:#64748b; }
    #aptScheduleCalendarPage .legend-dot { width:9px; height:9px; border-radius:50%; display:inline-block; margin-right:4px; }
    #aptScheduleCalendarPage .legend-dot.NOTICE { background:#2563eb; }
    #aptScheduleCalendarPage .legend-dot.EVENT { background:#16a34a; }
    #aptScheduleCalendarPage .legend-dot.VACATION { background:#7c3aed; }
    #aptScheduleCalendarPage .legend-dot.CONSTRUCTION { background:#ea580c; }
    #aptScheduleCalendarPage .legend-dot.METER { background:#0891b2; }
    #aptScheduleCalendarPage .legend-dot.CHECK { background:#64748b; }

    #aptScheduleCalendarPage .apt-calendar { table-layout:fixed; width:100%; border-collapse:collapse; background:#fff; border-top:2px solid #2563eb; }
    #aptScheduleCalendarPage .apt-calendar th { height:36px; text-align:center; font-size:12px; font-weight:800; border:1px solid #e5e7eb; background:#f8fafc; }
    #aptScheduleCalendarPage .apt-calendar td { height:128px; vertical-align:top; padding:8px 7px; border:1px solid #e5e7eb; background:#fff; }
    #aptScheduleCalendarPage .apt-calendar td.other-month { background:#fafafa; }
    #aptScheduleCalendarPage .apt-calendar td.today { background:#f0f7ff; }
    #aptScheduleCalendarPage .day-num { font-size:12px; font-weight:800; margin-bottom:5px; color:#334155; }
    #aptScheduleCalendarPage .sun .day-num { color:#dc2626; }
    #aptScheduleCalendarPage .sat .day-num { color:#2563eb; }
    #aptScheduleCalendarPage .schedule-chip { display:block; width:100%; max-width:100%; border:1px solid currentColor; background:#fff; border-radius:999px; padding:2px 7px; margin-bottom:3px; font-size:10px; line-height:16px; font-weight:700; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; cursor:pointer; }
    #aptScheduleCalendarPage .schedule-chip.NOTICE { color:#2563eb; }
    #aptScheduleCalendarPage .schedule-chip.EVENT { color:#16a34a; }
    #aptScheduleCalendarPage .schedule-chip.VACATION { color:#7c3aed; }
    #aptScheduleCalendarPage .schedule-chip.CONSTRUCTION { color:#ea580c; }
    #aptScheduleCalendarPage .schedule-chip.METER { color:#0891b2; }
    #aptScheduleCalendarPage .schedule-chip.CHECK { color:#64748b; }
    #aptScheduleCalendarPage .more-count { margin-top:3px; font-size:10px; color:#475569; text-align:center; }

    #aptScheduleCalendarPage .schedule-list-table { table-layout:fixed; width:100%; }
    #aptScheduleCalendarPage .schedule-list-table th,
    #aptScheduleCalendarPage .schedule-list-table td {
      text-align: center;
      vertical-align: middle;
    }

    /*
     * 등록자/직원 컬럼은 줄바꿈 허용
     * 왜 사용?
     * 이름이 길 경우 잘리지 않도록 처리하기 위해.
     */
    #aptScheduleCalendarPage .schedule-list-table td:last-child {
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
      font-size: 12px;
      text-align: left;
      padding-left: 16px;
    }
    #aptScheduleCalendarPage .schedule-list-table .td-title { text-align:left; overflow:hidden; text-overflow:ellipsis; }

    #aptScheduleCalendarPage .schedule-list-detail {
      border: none;
      outline: none;
      background: transparent;
      padding: 0;
      margin: 0;
      color: #111827;
      font: inherit;
      font-weight: 700;
      cursor: pointer;
      text-align: left;
      max-width: 100%;
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
    }

    #aptScheduleCalendarPage .schedule-list-detail:hover {
      color: #006b4f;
      text-decoration: underline;
    }
    #aptScheduleCalendarPage .modal-backdrop { position:fixed; inset:0; background:rgba(15,23,42,.45); display:none; align-items:center; justify-content:center; z-index:1000; }
    #aptScheduleCalendarPage .modal-backdrop.active { display:flex; }
    #aptScheduleCalendarPage .modal-card { width:460px; max-width:calc(100vw - 32px); background:#fff; border-radius:16px; box-shadow:0 20px 60px rgba(15,23,42,.25); overflow:hidden; }
    #aptScheduleCalendarPage .modal-head { display:flex; justify-content:space-between; align-items:center; padding:16px 18px; border-bottom:1px solid #e5e7eb; }
    #aptScheduleCalendarPage .modal-title { font-size:16px; font-weight:800; }
    #aptScheduleCalendarPage .modal-body { padding:18px; }
    #aptScheduleCalendarPage .form-row { margin-bottom:12px; }
    #aptScheduleCalendarPage .form-row label { display:block; font-size:12px; font-weight:800; margin-bottom:5px; color:#334155; }
    #aptScheduleCalendarPage .form-row input, #aptScheduleCalendarPage .form-row select, #aptScheduleCalendarPage .form-row textarea { width:100%; }
    /*
 * 상세 모달 읽기전용 표시 영역
 *
 * 왜 사용?
 * 수정할 수 없는 유형, 위치, 내용은 입력창처럼 보이면 헷갈리기 때문에
 * 테두리를 없애고 연한 회색 텍스트로 표시한다.
 */
    #aptScheduleCalendarPage .readonly-view {
      border: none !important;
      background: transparent !important;
      box-shadow: none !important;
      padding: 0 !important;
      color: #9ca3af !important;
      font-weight: 600;
      cursor: default;
      resize: none;
    }

    #aptScheduleCalendarPage .readonly-view:focus {
      outline: none !important;
      box-shadow: none !important;
    }

    /*
 * select 비활성 스타일 제거
 *
 * 왜 사용?
 * disabled select는 브라우저 기본 회색 박스가 남기 때문.
 */
    #aptScheduleCalendarPage select.readonly-view,
    #aptScheduleCalendarPage input.readonly-view,
    #aptScheduleCalendarPage textarea.readonly-view {
      border: none !important;
      background: transparent !important;
      box-shadow: none !important;
      color: #9ca3af !important;
      padding-left: 0 !important;
      appearance: none;
      -webkit-appearance: none;
      -moz-appearance: none;
    }
    #aptScheduleCalendarPage .modal-foot { display:flex; justify-content:flex-end; gap:8px; padding:14px 18px; border-top:1px solid #e5e7eb; }

    #aptScheduleCalendarPage .detail-row {
      margin-bottom:12px;
      font-size:14px;
      color:#334155;
    }

    #aptScheduleCalendarPage .detail-label {
      display:block;
      font-size:12px;
      font-weight:800;
      margin-bottom:5px;
      color:#64748b;
    }

    #aptScheduleCalendarPage .more-count {
      margin-top: 3px;
      font-size: 10px;
      color: #475569;
      text-align: center;
      cursor: pointer;
      font-weight: 700;
    }

    #aptScheduleCalendarPage .more-count:hover {
      color: #006b4f;
      text-decoration: underline;
    }

    /* 여러 날짜 일정 막대 */
    #aptScheduleCalendarPage .apt-calendar {
      overflow: visible;
    }



    /* 날짜 숫자에만 여백 적용 */
    #aptScheduleCalendarPage .day-num {
      padding: 8px 7px 0;
    }

    /* 일정 막대 */
    #aptScheduleCalendarPage .week-event-bar {
      position: absolute;
      left: 0;
      height: 19px;
      line-height: 19px;
      border: none;
      border-radius: 4px;
      padding: 0 8px;
      font-size: 10px;
      font-weight: 800;
      color: #334155;
      text-align: left;
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
      cursor: pointer;
      z-index: 20;
    }

    /* 파스텔톤 색상 */
    #aptScheduleCalendarPage .week-event-bar.NOTICE {
      background: #bfdbfe;
      color: #1d4ed8;
    }

    #aptScheduleCalendarPage .week-event-bar.EVENT {
      background: #bbf7d0;
      color: #15803d;
    }

    #aptScheduleCalendarPage .week-event-bar.VACATION {
      background: #e9d5ff;
      color: #7e22ce;
    }

    #aptScheduleCalendarPage .week-event-bar.CONSTRUCTION {
      background: #fed7aa;
      color: #c2410c;
    }

    #aptScheduleCalendarPage .week-event-bar.METER {
      background: #bae6fd;
      color: #0369a1;
    }

    #aptScheduleCalendarPage .week-event-bar.CHECK {
      background: #e2e8f0;
      color: #475569;
    }


    /* 기본은 4줄까지만 표시 */
    #aptScheduleCalendarPage .week-event-bar.hidden-event {
      display: none;
    }

    /* 캘린더 한 주 높이 고정 */
    #aptScheduleCalendarPage .apt-calendar tbody tr {
      height: 170px;
    }

    /* 날짜 칸 내부 일정이 칸 밖으로 튀어나가지 않게 처리 */
    #aptScheduleCalendarPage .apt-calendar td {
      position: relative;
      overflow: hidden;
      padding: 0;
      height: 170px;
    }


    /* 숨긴 일정 */
    #aptScheduleCalendarPage .week-event-bar.hidden-event {
      display: none;
    }

    /* 전체+ 버튼 위치 고정 */
    #aptScheduleCalendarPage .calendar-more-btn {
      position: absolute;
      left: 6px;
      right: 6px;
      bottom: 6px;
      height: 20px;
      line-height: 20px;
      border: none;
      border-radius: 6px;
      background: #f1f5f9;
      color: #475569;
      font-size: 10px;
      font-weight: 800;
      cursor: pointer;
      z-index: 50;
    }

    #aptScheduleCalendarPage .apt-calendar td.expanded .week-event-bar.hidden-event {
      display: block;
    }

    /* 전체 일정 목록 페이징 */
    #aptScheduleCalendarPage .schedule-paging-area {
      display: flex;
      justify-content: center;
      align-items: center;
      gap: 6px;
      margin-top: 18px;
    }

    #aptScheduleCalendarPage .schedule-paging-area ul,
    #aptScheduleCalendarPage .schedule-paging-area li {
      list-style: none !important;
      padding: 0;
      margin: 0;
    }

    #aptScheduleCalendarPage .schedule-paging-area li::marker {
      display: none;
      content: '';
    }

    #aptScheduleCalendarPage .schedule-paging-area ul {
      display: flex;
      gap: 6px;
    }

    #aptScheduleCalendarPage .schedule-paging-area a,
    #aptScheduleCalendarPage .schedule-paging-area .page-link {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      min-width: 34px;
      height: 34px;
      padding: 0 10px;
      border: 1px solid #d1d5db;
      border-radius: 8px;
      background: #fff;
      color: #334155;
      font-size: 13px;
      font-weight: 700;
      text-decoration: none;
    }
    /* 페이징 점(•) 제거 */
    #aptScheduleCalendarPage .schedule-paging-area ul {
      list-style: none !important;
    }
    #aptScheduleCalendarPage .schedule-paging-area li {
      list-style: none !important;
    }
    /*
 * 페이징 위 가로선 제거
 */
    #aptScheduleCalendarPage .schedule-paging-area {
      border-top: none !important;
      box-shadow: none !important;
    }

    #aptScheduleCalendarPage .schedule-paging-area::before,
    #aptScheduleCalendarPage .schedule-paging-area::after {
      display: none !important;
      content: none !important;
    }

    #aptScheduleCalendarPage .schedule-paging-area ul {
      border-top: none !important;
      border-bottom: none !important;
    }

    #aptScheduleCalendarPage .schedule-paging-area li {
      border-top: none !important;
    }
    /*
     * 현재 보고 있는 페이지 표시
     */
    #aptScheduleCalendarPage .schedule-paging-area a.active,
    #aptScheduleCalendarPage .schedule-paging-area .page-link.active,
    #aptScheduleCalendarPage .schedule-paging-area li.active a {
      background: #166534 !important;
      border-color: #166534 !important;
      color: #fff !important;
    }
    /*
 * 일정명 컬럼 헤더 왼쪽 정렬
 */
    #aptScheduleCalendarPage .schedule-list-table th:nth-child(2) {
      text-align: left;
      padding-left: 16px;
    }

    /*
     * 위치 컬럼 헤더 왼쪽 정렬
     */
    #aptScheduleCalendarPage .schedule-list-table th:nth-child(4) {
      text-align: left;
      padding-left: 16px;
    }

    /*
     * 등록자/직원 컬럼 헤더 왼쪽 정렬
     */
    #aptScheduleCalendarPage .schedule-list-table th:nth-child(5) {
      text-align: left;
      padding-left: 16px;
    }

    /*
     * 일정명 데이터 왼쪽 정렬
     */
    #aptScheduleCalendarPage .schedule-list-table td:nth-child(2) {
      text-align: left;
      padding-left: 16px;
    }

    /*
     * 위치 데이터 왼쪽 정렬
     */
    #aptScheduleCalendarPage .schedule-list-table td:nth-child(4) {
      text-align: left;
      padding-left: 16px;
    }

    /*
     * 등록자/직원 데이터 왼쪽 정렬
     */
    #aptScheduleCalendarPage .schedule-list-table td:nth-child(5) {
      text-align: left;
      padding-left: 16px;
    }
    /*
     * 전체 일정 목록 제목 영역
     */
    #aptScheduleCalendarPage .panel-header {
      display: flex;
      align-items: center;
      justify-content: space-between;
    }

    #aptScheduleCalendarPage .panel-header h3 {
      margin: 0;
    }

    #aptScheduleCalendarPage .section-desc {
      font-size: 12px;
      color: #94a3b8;
      white-space: nowrap;
    }

    /* =====================================================
 * 캘린더 일정 겹침 방지
 * 왜 사용?
 * 일정이 많은 경우 다음 주까지 침범하는 현상 방지
 * ===================================================== */

    /* 주 높이 */
    #aptScheduleCalendarPage .apt-calendar tbody tr{
      height:180px !important;
    }

    /* 날짜칸 */
    #aptScheduleCalendarPage .apt-calendar {
      overflow: visible !important;
    }

    #aptScheduleCalendarPage .apt-calendar tbody tr{
      height:180px !important;
    }

    #aptScheduleCalendarPage .apt-calendar td{
      position:relative !important;
      overflow:visible !important; /* 옆 칸까지 색띠가 넘어가게 함 */
      height:180px !important;
      padding:0 !important;
      vertical-align:top !important;
    }

    #aptScheduleCalendarPage .week-event-bar{
      left:3px !important;
      height:19px;
      line-height:19px;
      border-radius:4px;
      z-index:20;
    }

    /* 날짜 숫자 */
    #aptScheduleCalendarPage .day-num{
      padding:6px 6px 0 6px !important;
      margin-bottom:0 !important;
    }

    /* 일정바 */
    #aptScheduleCalendarPage .week-event-bar{
      left:3px !important;
      right:auto !important;
      max-width:none !important;
    }

    /* 숨김 일정 */
    #aptScheduleCalendarPage .week-event-bar.hidden-event{
      display:none !important;
    }

    /* 직원휴가 캘린더 바 연보라색 */
    .week-event-bar.VACATION,
    #aptScheduleCalendarPage .week-event-bar.VACATION,
    #residentScheduleCalendarPage .week-event-bar.VACATION {
      background: #E9D5FF !important;
      color: #7E22CE !important;
    }

    /* 상세 모달 휴가종류 뱃지 */
    .vacation-type-badge {
      display: inline-flex;
      align-items: center;
      padding: 5px 12px;
      border-radius: 999px;
      font-size: 12px;
      font-weight: 800;
      color: #334155;
      border: 1px solid rgba(15, 23, 42, 0.08);
    }

    .day-schedule-title{
      display:block;
      width:100%;
      border:0;
      background:#f8fafc;
      border-radius:8px;
      padding:10px 12px;
      margin-bottom:8px;
      text-align:left;
      font-weight:800;
      cursor:pointer;
    }

    .day-schedule-title:hover{
      background:#e8f7ee;
      color:#006b4f;
    }

    /* 하루 일정 목록 모달 */
    #dayScheduleModal .modal-card {
      width: 820px !important;
      max-width: calc(100vw - 48px);
      height: 620px;              /* 모달 크기 고정 */
      max-height: calc(100vh - 80px);
      border-radius: 18px;
      overflow: hidden;

      display: flex;
      flex-direction: column;
    }

    /* 상단 제목 영역 */
    #dayScheduleModal .modal-head {
      flex-shrink: 0;
      padding: 22px 26px;
      background: #fff;
      border-bottom: 1px solid #e5e7eb;
    }

    #dayScheduleModal .modal-title {
      font-size: 24px;
      font-weight: 900;
      color: #172033;
    }

    /* 내용 영역만 스크롤 구조 */
    #dayScheduleModal .modal-body {
      flex: 1;                    /* 남은 높이만 사용 */
      min-height: 0;              /* 스크롤 깨짐 방지 */
      display: grid !important;
      grid-template-columns: 340px 1fr;
      gap: 22px !important;
      padding: 24px 26px;
      overflow: hidden;           /* 모달 전체 스크롤 방지 */
    }

    /* 왼쪽 일정 목록 */
    #dayScheduleList {
      width: auto !important;
      height: 100%;
      overflow-y: auto;           /* 왼쪽 목록만 스크롤 */
      padding-right: 14px !important;
      border-right: 1px solid #e5e7eb;
    }

    /* 오른쪽 상세 영역 */
    #sideDetailArea {
      min-width: 0;
      height: 100%;
      overflow-y: auto;           /* 오른쪽 내용만 스크롤 */
      padding-right: 4px;
    }

    /* 왼쪽 일정 버튼: 예전 CSS 느낌 */
    /*.day-schedule-title {*/
    /*  display: block;*/
    /*  width: 100%;*/
    /*  border: 0;*/
    /*  background: #f8fafc;*/
    /*  border-radius: 8px;*/
    /*  padding: 11px 12px;*/
    /*  margin-bottom: 8px;*/
    /*  text-align: left;*/
    /*  font-size: 14px;*/
    /*  font-weight: 800;*/
    /*  color: #334155;*/
    /*  cursor: pointer;*/
    /*  line-height: 1.45;*/
    /*}*/
    .day-schedule-title {
      display: block;
      .day-schedule-title {
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
        overflow: hidden;
        word-break: keep-all;
        line-height: 1.5;
      }
    .side-detail-content {
      white-space: pre-line;

      word-break: keep-all;
      overflow-wrap: break-word;

      line-height: 1.9;
    }

    .day-schedule-title:hover,
    .day-schedule-title.active {
      background: #e8f7ee;
      color: #006b4f;
    }

    /* 오른쪽 상세 카드 */
    .side-detail-card {
      border: 1px solid #e5e7eb;
      border-radius: 18px;
      padding: 24px 28px;
      background: #fff;
      box-shadow: none;
    }

    .side-detail-title {
      margin: 0 0 20px;
      font-size: 24px;
      font-weight: 900;
      color: #111827;
      line-height: 1.35;
    }

    .side-detail-meta {
      display: grid;
      grid-template-columns: repeat(2, 1fr);
      gap: 12px;
      margin-bottom: 22px;
    }

    .side-detail-row {
      background: #f8fafc;
      border-radius: 12px;
      padding: 13px 14px;
      font-size: 14px;
      color: #334155;
    }

    .side-detail-label {
      display: block;
      margin-bottom: 5px;
      font-size: 12px;
      font-weight: 900;
      color: #94a3b8;
    }

    .side-detail-content {
      border-left: 5px solid #006b4f;
      background: #fafafa;
      border-radius: 14px;
      padding: 20px 22px;
      font-size: 15px;
      line-height: 1.9;
      color: #334155;
      white-space: pre-line;
      word-break: keep-all;
    }

    /* 하단 닫기 버튼 영역 */
    #dayScheduleModal .modal-foot {
      flex-shrink: 0;
      padding: 14px 22px;
      border-top: 1px solid #e5e7eb;
      background: #fff;
    }

      /*
       * pre-line이란?
       * DB 문자열 안의 줄바꿈(\n)을 화면 줄바꿈으로 보여주는 CSS.
       * 왜 사용?
       * 공지사항 내용처럼 엔터가 중요한 긴 글을 깔끔하게 보여주기 위해 사용.
       */
      white-space: pre-line;
      word-break: keep-all;
    }
  </style>

  <script src="${pageContext.request.contextPath}/js/manager/manager-common.js"></script>
</head>
<body>
<div class="app-wrapper">
  <%@ include file="/WEB-INF/views/include/office_sidebar.jsp" %>

  <div class="main-wrap">
    <%@ include file="/WEB-INF/views/include/office_header.jsp" %>

    <main class="main-content">
      <div class="office-page" id="aptScheduleCalendarPage">

        <div class="page-header">
          <div class="page-title-block">
            <h2>단지 일정 캘린더</h2>
            <p>공지, 행사, 직원 휴가, 공사, 검침, 점검 일정을 월별로 확인합니다.</p>
          </div>
          <div class="page-actions">
            <button type="button" class="btn btn-primary" id="openVacationBtn">
              <span class="material-symbols-rounded">add</span>
              휴가 등록
            </button>
          </div>
        </div>

        <div class="stat-row">
          <div class="stat-card"><div class="stat-icon green"><span class="material-symbols-rounded">event_available</span></div><div><div class="stat-value" id="totalCnt">0</div><div class="stat-label">전체 일정</div></div></div>
          <div class="stat-card"><div class="stat-icon blue"><span class="material-symbols-rounded">today</span></div><div><div class="stat-value" id="todayCnt">0</div><div class="stat-label">오늘 일정</div></div></div>
          <div class="stat-card"><div class="stat-icon yellow"><span class="material-symbols-rounded">calendar_month</span></div><div><div class="stat-value" id="monthCnt">0</div><div class="stat-label">이번 달 일정</div></div></div>
          <div class="stat-card"><div class="stat-icon purple"><span class="material-symbols-rounded">badge</span></div><div><div class="stat-value" id="vacationCnt">0</div><div class="stat-label">직원 휴가</div></div></div>
        </div>

        <div class="tab-bar">
          <button type="button" class="tab-btn active" data-tab="calendar"><span class="material-symbols-rounded">calendar_month</span>달력</button>
          <button type="button" class="tab-btn" data-tab="list"><span class="material-symbols-rounded">list_alt</span>전체 목록</button>
        </div>

        <div class="filter-row">
          <select id="scheduleTy" class="form-control">
            <option value="ALL">전체 유형</option>
            <option value="NOTICE">공지</option>
            <option value="EVENT">행사</option>
            <option value="VACATION">직원휴가</option>
            <option value="CONSTRUCTION">공사</option>
            <option value="METER">검침</option>
            <option value="CHECK">점검</option>
          </select>
          <input type="text" id="keyword" class="form-control" placeholder="일정명, 내용, 위치, 직원명 검색">
          <button type="button" class="btn btn-primary" id="searchBtn">
            <span class="material-symbols-rounded">search</span>
            검색
          </button>

          <!-- 검색조건 초기화 버튼 -->
          <button type="button" class="btn btn-secondary" id="resetBtn">
            <span class="material-symbols-rounded">refresh</span>
            초기화
          </button>
        </div>

        <div class="tab-panel active" id="calendarPanel">
          <div class="panel">
            <div class="panel-header calendar-topbar">
              <div class="panel-title"><span class="material-symbols-rounded">calendar_month</span>월간 일정</div>
              <div class="calendar-nav">
                <button type="button" class="btn btn-sm btn-secondary" id="prevMonthBtn"><span class="material-symbols-rounded">chevron_left</span></button>
                <strong class="calendar-title" id="calendarTitle"></strong>
                <button type="button" class="btn btn-sm btn-secondary" id="nextMonthBtn"><span class="material-symbols-rounded">chevron_right</span></button>
                <button type="button" class="btn btn-sm btn-secondary" id="todayBtn">오늘</button>
              </div>
            </div>

            <div class="legend-row">
              <span><i class="legend-dot NOTICE"></i>공지</span>
              <span><i class="legend-dot EVENT"></i>행사</span>
              <span><i class="legend-dot VACATION"></i>직원휴가</span>
              <span><i class="legend-dot CONSTRUCTION"></i>공사</span>
              <span><i class="legend-dot METER"></i>검침</span>
              <span><i class="legend-dot CHECK"></i>점검</span>
            </div>

            <table class="apt-calendar">
              <thead><tr><th style="color:#dc2626;">일</th><th>월</th><th>화</th><th>수</th><th>목</th><th>금</th><th style="color:#2563eb;">토</th></tr></thead>
              <tbody id="calendarBody"></tbody>
            </table>
          </div>
        </div>

        <div class="tab-panel" id="listPanel" style="display:none;">
          <div class="panel">
            <div class="panel-header">

              <div class="panel-title">
                <span class="material-symbols-rounded">list_alt</span>
                전체 일정 목록
              </div>
              <span class="section-desc" id="currentMonthInfo">
                  현재 조회는 월 기준 목록입니다.
              </span>
            </div>
            <table class="tbl schedule-list-table">
              <thead>
              <tr>
                <th style="width:130px;">구분</th>
                <th>제목</th>
                <th style="width:200px;">기간</th>
                <th style="width:250px;">위치</th>
                <th style="width:260px;">등록자/직원명</th>
              </tr>
              </thead>

              <tbody id="scheduleListBody">
              <tr>
                <td colspan="5">조회된 일정이 없습니다.</td>
              </tr>
              </tbody>
            </table>
            <!--
              페이징 영역
              왜 table 밖에 둠?
              table 안에는 tr, thead, tbody, td 같은 표 태그만 들어가야 한다.
              div를 table 안에 넣으면 브라우저가 구조를 깨뜨려서 페이징이 이상하게 표시된다.
            -->
            <div id="schedulePagingArea" class="schedule-paging-area"></div>
          </div>
        </div>

        <div class="modal-backdrop" id="vacationModal">
          <div class="modal-card">
            <div class="modal-head">
              <div class="modal-title">직원 휴가 등록</div>
            </div>
            <div class="modal-body">
              <div class="form-row">
                <label>직원명</label>
                <select id="vacUserNo" class="form-control">
                  <option value="">직원 선택</option>

                  <c:forEach var="emp" items="${managerEmployeeList}">
                    <option value="${emp.userNo}">
                        ${emp.empDisplayNm}
                    </option>
                  </c:forEach>
                </select>
              </div>
              <div class="form-row">
                <label>휴가종류</label>
                <input type="text" id="vacTitle" class="form-control" placeholder="예: 연차, 오전 반차, 병가">
              </div>
              <div class="form-row">
                <label>시작일</label>
                <input type="date" id="vacStartDt" class="form-control">
              </div>
              <div class="form-row">
                <label>종료일</label>
                <input type="date" id="vacEndDt" class="form-control">
              </div>
            </div>
            <div class="modal-foot">
              <!-- 휴가 등록 저장 버튼 -->
              <button type="button" class="btn btn-primary" id="saveVacationBtn">
                등록
              </button>
              <!-- 휴가 등록 취소 버튼 -->
              <button type="button" class="btn btn-secondary" id="cancelVacationBtn">
                취소
              </button>
            </div>
          </div>
        </div>

        <div class="modal-backdrop" id="detailModal">
          <div class="modal-card">
            <div class="modal-head">
              <div class="modal-title" id="detailTitle">일정 상세</div>
            </div>

            <div class="modal-body">
              <input type="hidden" id="detailScheduleNo">
              <input type="hidden" id="detailScheduleTy">

              <div class="form-row">
                <label>유형</label>
                <input type="text" id="detailType" class="form-control readonly-view" readonly>
              </div>

              <div class="form-row">
                <label>직원</label>
                <select id="detailUserNo" class="form-control">
                  <option value="">직원 선택</option>

                  <c:forEach var="emp" items="${managerEmployeeList}">
                    <option value="${emp.userNo}">
                        ${emp.empDisplayNm}
                    </option>
                  </c:forEach>
                </select>
              </div>

              <div class="form-row">
                <label>휴가 제목</label>
                <input type="text" id="detailScheduleTtl" class="form-control">
              </div>

              <div class="form-row">
                <label>시작일</label>
                <input type="date" id="detailStartDt" class="form-control">
              </div>

              <div class="form-row">
                <label>종료일</label>
                <input type="date" id="detailEndDt" class="form-control">
              </div>

              <div class="form-row">
                <label>위치</label>
                <input type="text" id="detailLoc" class="form-control readonly-view" readonly>
              </div>

              <div class="form-row">
                <label>내용</label>
                <textarea id="detailCn" class="form-control readonly-view" rows="3" readonly></textarea>
              </div>
            </div>

            <div class="modal-foot">
              <button type="button" class="btn btn-primary" id="editScheduleBtn" style="display:none;">
                수정
              </button>

              <button type="button" class="btn btn-danger" id="deleteScheduleBtn" style="display:none;">
                삭제
              </button>

              <button type="button" class="btn btn-secondary" id="closeDetailFootBtn">
                닫기
              </button>
            </div>
          </div>
        </div>

        <div class="modal-backdrop" id="dayScheduleModal">
          <div class="modal-card">
            <div class="modal-head">
              <div class="modal-title" id="dayScheduleTitle">일정 목록</div>
            </div>

            <div class="modal-body">
              <div id="dayScheduleList"></div>
              <div id="sideDetailArea">
                <div style="color:#94a3b8; font-weight:700;">왼쪽 일정 제목을 선택하세요.</div>
              </div>
            </div>

            <div class="modal-foot">
              <button type="button" class="btn btn-secondary" id="closeDayScheduleBtn">닫기</button>
            </div>
          </div>
        </div>

      </div>
    </main>
  </div>
</div>

<script>

  let selectedSchedule = null;

(function () {
  const contextPath = '${pageContext.request.contextPath}';
  const mgmtOfcNo = '${mgmtOfcNo}';
  const csrfHeader = document.querySelector('meta[name="_csrf_header"]')?.content;
  const csrfToken = document.querySelector('meta[name="_csrf"]')?.content;

  let currentDate = new Date();
  let scheduleList = [];

  const calendarTitle = document.getElementById('calendarTitle');
  const calendarBody = document.getElementById('calendarBody');
  const scheduleListBody = document.getElementById('scheduleListBody');

  function pad(num) { return String(num).padStart(2, '0'); }
  function formatDate(date) { return date.getFullYear() + '-' + pad(date.getMonth() + 1) + '-' + pad(date.getDate()); }
  function escapeHtml(value) {
    if (value === null || value === undefined) return '';
    return String(value).replace(/[&<>"]/g, function (s) {
      return ({'&':'&amp;', '<':'&lt;', '>':'&gt;', '"':'&quot;'}[s]);
    });
  }

  function getMonthRange() {
    const first = new Date(currentDate.getFullYear(), currentDate.getMonth(), 1);
    const last = new Date(currentDate.getFullYear(), currentDate.getMonth() + 1, 0);
    return { start: formatDate(first), end: formatDate(last) };
  }

  /* 페이징 */
  let currentListPage = 1;
  let listPageList = [];
  let pagingHTML = '';

  function loadSchedule(page) {
    currentListPage = page || 1;

    const range = getMonthRange();
    const params = new URLSearchParams();

    params.append('monthStartDt', range.start);
    params.append('monthEndDt', range.end);
    params.append('scheduleTy', document.getElementById('scheduleTy').value);
    params.append('keyword', document.getElementById('keyword').value.trim());
    params.append('currentPage', currentListPage);

    fetch(contextPath + '/manager/aptScheduleCalendar/' + mgmtOfcNo + '/list?' + params.toString())
            .then(function (res) {
              return res.json();
            })
            .then(function (data) {
              scheduleList = data.calendarList || [];
              listPageList = data.list || [];
              pagingHTML = data.pagingHTML || '';

              renderStat(data.stat || {});
              renderCalendar();
              renderList();
              renderPaging();
            })
            .catch(function () {
              alert('일정 조회 중 오류가 발생했습니다.');
            });
  }

  function renderPaging() {
    const pagingArea = document.getElementById('schedulePagingArea');

    if (!pagingArea) {
      return;
    }

    pagingArea.innerHTML = pagingHTML;

    /*
     * 현재 페이지 표시
     * 서버 pagingHTML에 active 클래스가 없어도
     * JS에서 현재 페이지 번호와 같은 버튼에 active를 직접 붙인다.
     */
    pagingArea.querySelectorAll('a, .page-link').forEach(function (link) {
      const page = Number(link.dataset.page || link.textContent.trim());

      if (page === currentListPage) {
        link.classList.add('active');

        const li = link.closest('li');
        if (li) {
          li.classList.add('active');
        }
      }
    });

    pagingArea.querySelectorAll('.page-link[data-page], a[data-page]').forEach(function (link) {
      link.addEventListener('click', function (e) {
        e.preventDefault();

        const page = Number(link.dataset.page);

        if (page > 0) {
          loadSchedule(page);
        }
      });
    });
  }

  function renderStat(stat) {
    document.getElementById('totalCnt').textContent = stat.totalCnt || 0;
    document.getElementById('todayCnt').textContent = stat.todayCnt || 0;
    document.getElementById('monthCnt').textContent = stat.monthCnt || 0;
    document.getElementById('vacationCnt').textContent = stat.vacationCnt || 0;
  }

  function renderCalendar() {
    const year = currentDate.getFullYear();
    const month = currentDate.getMonth();
    calendarTitle.textContent = year + '년 ' + (month + 1) + '월';
    /*
     * 전체 일정 목록 안내 문구 변경
     * 예)
     * 현재 조회는 5월 기준 목록입니다.
     */
    const currentMonthInfo = document.getElementById('currentMonthInfo');

    if(currentMonthInfo){
      currentMonthInfo.textContent =
              '현재 조회는 ' + (month + 1) + '월 기준 목록입니다.';
    }

    const firstDay = new Date(year, month, 1);
    const startDate = new Date(year, month, 1 - firstDay.getDay());
    const todayStr = formatDate(new Date());

    let html = '';

    for (let week = 0; week < 6; week++) {
      const weekStart = new Date(startDate);
      weekStart.setDate(startDate.getDate() + week * 7);

      /*
       * 주 단위로 일정 막대 위치 계산
       * 왜 사용?
       * 같은 주 안에서 일정끼리 겹치지 않게 줄 번호를 계산하기 위해.
       */
      const maxVisibleLane = 4;
      const weekSegments = createWeekSegments(weekStart);

      html += '<tr>';

      for (let day = 0; day < 7; day++) {
        const cellDate = new Date(weekStart);
        cellDate.setDate(weekStart.getDate() + day);

        const dateStr = formatDate(cellDate);
        const isOther = cellDate.getMonth() !== month;
        const dayClass = day === 0 ? 'sun' : (day === 6 ? 'sat' : '');
        const todayClass = dateStr === todayStr ? 'today' : '';

        html += '<td class="' + dayClass + ' ' + todayClass + (isOther ? ' other-month' : '') + '"' + ' data-date="' + dateStr + '">';
        html += '<div class="day-num">' + cellDate.getDate() + '</div>';
        html += renderWeekBarsByDate(dateStr, day, weekSegments);
        html += '</td>';
      }

      html += '</tr>';
    }

    calendarBody.innerHTML = html;

    document.querySelectorAll('#calendarBody td[data-date]').forEach(function(td){
      td.addEventListener('click', function(e){
        if (e.target.classList.contains('week-event-bar')) {
          const dateStr = td.dataset.date;
          const daySchedules = getSchedulesByDate(dateStr);

          openDayScheduleModal(dateStr, daySchedules);
          return;
        }

        const dateStr = td.dataset.date;
        const daySchedules = getSchedulesByDate(dateStr);

        openDayScheduleModal(dateStr, daySchedules);
      });
    });

    document.querySelectorAll('.calendar-more-btn').forEach(function (btn) {
      btn.addEventListener('click', function (e) {
        e.stopPropagation();

        const td = this.closest('td');
        const dateStr = td.dataset.date;
        const daySchedules = getSchedulesByDate(dateStr);

        /*
         * 전체+ 클릭 시 칸 안에서 펼치지 않고 모달로 표시한다.
         * 왜 사용?
         * 칸 안에서 expanded 처리하면 달력 높이가 깨지고 일정 막대가 겹칠 수 있기 때문.
         */
        openDayScheduleModal(dateStr, daySchedules);
      });
    });
  }

  function renderWeekBarsByDate(dateStr, dayOfWeek, weekSegments) {
    /*
     * maxVisibleLane이란?
     * 화면에 기본으로 보여줄 일정 줄 수.
     *
     * 왜 사용?
     * 일정이 너무 많을 때 캘린더 칸 밖으로 일정바가 튀어나가지 않게 하기 위해.
     */
    const maxVisibleLane = 4;

    /*
     * 현재 날짜에서 시작하는 일정만 가져온다.
     *
     * 왜 사용?
     * 여러 날짜에 걸친 일정은 시작 날짜 칸에서만 막대를 그려야
     * 같은 일정이 여러 칸에 중복 출력되지 않는다.
     */
    const startSegments = weekSegments.filter(function (seg) {
      return seg.startStr === dateStr;
    });

    /*
     * 기본 4줄을 넘는 일정 개수
     */
    const hiddenStartCount = startSegments.filter(function (seg) {
      return seg.lane >= maxVisibleLane;
    }).length;

    let html = '';

    startSegments.forEach(function (seg) {
      const spanDays = seg.endDay - seg.startDay + 1;

      /*
       * lane이 4 이상이면 처음에는 숨김 처리
       *
       * hidden-event란?
       * 처음 화면에서는 안 보이다가 전체+ 버튼을 눌렀을 때만 보이는 일정 클래스.
       */
      const isHidden = seg.lane >= maxVisibleLane;
      const hiddenClass = isHidden ? ' hidden-event' : '';

      /*
       * 숨긴 일정도 원래 lane 위치 그대로 둔다.
       *
       * 왜?
       * 전체+를 눌렀을 때 일정 순서가 섞이지 않고
       * 원래 줄 위치대로 자연스럽게 보이게 하기 위해.
       */
      const top = 32 + seg.lane * 23;

      html += '<button type="button"'
              + ' class="week-event-bar ' + escapeHtml(seg.item.scheduleTy) + hiddenClass + '"'
              + ' style="top:' + top + 'px; width:calc(' + (spanDays * 100) + '% + ' + (spanDays - 1) + 'px);"'
              + ' title="' + escapeHtml(seg.item.scheduleTtl) + '"'
              + ' data-schedule-no="' + escapeHtml(seg.item.scheduleNo) + '">';
      html += escapeHtml(seg.item.scheduleTtl);
      html += '</button>';
    });
        /*
         * 숨겨진 일정이 있을 때 전체+n 버튼 표시
         * 왜 사용?
         * 일정이 4줄을 넘으면 달력 칸이 복잡해지므로,
         * 초과 일정은 모달에서 보도록 처리한다.
         */
        if (hiddenStartCount > 0) {
          html += '<button type="button"'
                  + ' class="calendar-more-btn"'
                  + ' data-hidden-count="' + hiddenStartCount + '">';
          html += '전체 +' + hiddenStartCount;
          html += '</button>';
        }
    return html;
  }

  function getBarSpanDays(item, dateStr, dayOfWeek) {
    const start = parseLocalDate(dateStr);
    const end = parseLocalDate(item.endDt);

    const remainWeekDays = 7 - dayOfWeek;
    const diffDays = Math.floor((end - start) / (1000 * 60 * 60 * 24)) + 1;

    return Math.min(diffDays, remainWeekDays);
  }

  /*
   * yyyy-MM-dd 문자열을 로컬 날짜로 변환
   */
  function parseLocalDate(dateStr) {
    const parts = dateStr.split('-');
    return new Date(Number(parts[0]), Number(parts[1]) - 1, Number(parts[2]));
  }

  /*
   * 일정별 고정 줄 번호 생성
   *
   * lane이란?
   * 캘린더에서 일정 막대가 놓일 세로 줄 번호.
   * 왜 사용?
   * 같은 일정이 여러 주에 걸쳐도 같은 줄에 표시하기 위해.
   */
  function createWeekSegments(weekStart) {
    const weekEnd = new Date(weekStart);
    weekEnd.setDate(weekStart.getDate() + 6);

    const weekStartStr = formatDate(weekStart);
    const weekEndStr = formatDate(weekEnd);

    const segments = scheduleList
            .filter(function (item) {
              return item.startDt <= weekEndStr && item.endDt >= weekStartStr;
            })
            .map(function (item) {
              const itemStart = parseLocalDate(item.startDt);
              const itemEnd = parseLocalDate(item.endDt);

              const segStart = itemStart < weekStart ? new Date(weekStart) : itemStart;
              const segEnd = itemEnd > weekEnd ? new Date(weekEnd) : itemEnd;

              return {
                item: item,
                startStr: formatDate(segStart),
                endStr: formatDate(segEnd),
                startDay: segStart.getDay(),
                endDay: segEnd.getDay(),
                lane: 0
              };
            })
            .sort(function (a, b) {
              if (a.startDay === b.startDay) {
                return b.endDay - a.endDay;
              }
              return a.startDay - b.startDay;
            });

    /*
     * lane이란?
     * 일정 막대의 세로 줄 번호.
     * 같은 날짜 범위에 겹치는 일정은 다른 lane에 배치한다.
     */
    const laneEndDays = [];

    segments.forEach(function (seg) {
      let lane = 0;

      while (
              laneEndDays[lane] !== undefined
              && laneEndDays[lane] >= seg.startDay
              ) {
        lane++;
      }

      seg.lane = lane;
      laneEndDays[lane] = seg.endDay;
    });

    return segments;
  }

  function getSchedulesByDate(dateStr) {
    return scheduleList.filter(function (item) {
      return item.startDt <= dateStr && item.endDt >= dateStr;
    });
  }

  function renderList() {
    if (!listPageList.length) {
      scheduleListBody.innerHTML = '<tr><td colspan="5">조회된 일정이 없습니다.</td></tr>';
      return;
    }

    scheduleListBody.innerHTML = listPageList.map(function (item) {
      const period = item.startDt === item.endDt
              ? item.startDt
              : item.startDt + ' ~ ' + item.endDt;

      const person = item.userNm || item.rgtrId || '-';

      return '<tr>'
              + '<td>' + escapeHtml(item.scheduleTyNm) + '</td>'
              + '<td class="td-title">'
              + '<button type="button" class="schedule-list-detail" data-schedule-no="' + escapeHtml(item.scheduleNo) + '">'
              + escapeHtml(item.scheduleTtl)
              + '</button>'
              + '</td>'
              + '<td>' + escapeHtml(period) + '</td>'
              + '<td>' + escapeHtml(item.locCn || '-') + '</td>'
              + '<td>' + escapeHtml(person) + '</td>'
              + '</tr>';
    }).join('');

    document.querySelectorAll('.schedule-list-detail').forEach(function (btn) {
      btn.addEventListener('click', function () {
        const scheduleNo = btn.dataset.scheduleNo;

        const selected = scheduleList.find(function (item) {
          return String(item.scheduleNo) === String(scheduleNo);
        });

        if (selected) {
          openDetailModal(selected);
        }
      });
    });
  }

  function saveVacation() {
    const userNo = document.getElementById('vacUserNo').value;
    const title = document.getElementById('vacTitle').value.trim();
    const startDt = document.getElementById('vacStartDt').value;
    const endDt = document.getElementById('vacEndDt').value;

    if (!userNo) { alert('직원을 선택해 주세요.'); return; }
    if (!title) { alert('휴가 제목을 입력해 주세요.'); return; }
    if (!startDt || !endDt) { alert('휴가 기간을 선택해 주세요.'); return; }
    if (startDt > endDt) { alert('종료일은 시작일보다 빠를 수 없습니다.'); return; }

    fetch(contextPath + '/manager/aptScheduleCalendar/' + mgmtOfcNo + '/vacation', {
      method: 'POST',
      headers: Object.assign({'Content-Type': 'application/json'}, csrfHeader && csrfToken ? {[csrfHeader]: csrfToken} : {}),
      body: JSON.stringify({ userNo: userNo, scheduleTtl: title, startDt: startDt, endDt: endDt, colorCd: 'PURPLE' })
    })
      .then(function (res) { return res.json(); })
      .then(function (data) {
        alert(data.message || '처리되었습니다.');
        if (data.success) {
          closeVacationModal();
          loadSchedule();
        }
      })
      .catch(function () { alert('휴가 등록 중 오류가 발생했습니다.'); });
  }

  function openVacationModal() { document.getElementById('vacationModal').classList.add('active'); }
  function closeVacationModal() {
    document.getElementById('vacationModal').classList.remove('active');
    document.getElementById('vacUserNo').value = '';
    document.getElementById('vacTitle').value = '';
    document.getElementById('vacStartDt').value = '';
    document.getElementById('vacEndDt').value = '';
  }

  function openDayScheduleModal(dateStr, items) {
    document.getElementById('dayScheduleTitle').textContent = dateStr + ' 일정 목록';

    if (!items.length) {
      document.getElementById('dayScheduleList').innerHTML =
              '<div style="color:#94a3b8;">조회된 일정이 없습니다.</div>';
      document.getElementById('sideDetailArea').innerHTML =
              '<div style="color:#94a3b8;">일정이 없습니다.</div>';
    } else {
      document.getElementById('dayScheduleList').innerHTML = items.map(function(item){
        return '<button type="button" class="day-schedule-title" data-schedule-no="' + escapeHtml(item.scheduleNo) + '">'
                + '[' + escapeHtml(item.scheduleTyNm) + '] '
                + escapeHtml(item.scheduleTtl)
                + '</button>';
      }).join('');

      document.getElementById('sideDetailArea').innerHTML =
              '<div style="color:#94a3b8; font-weight:700;">왼쪽 일정 제목을 선택하세요.</div>';

      document.querySelectorAll('.day-schedule-title').forEach(function(btn){
        btn.addEventListener('click', function(){
          const scheduleNo = btn.dataset.scheduleNo;

          const selected = scheduleList.find(function(item){
            return String(item.scheduleNo) === String(scheduleNo);
          });

          if(selected){
            renderSideDetail(selected);
          }
        });
      });
    }

    document.getElementById('dayScheduleModal').classList.add('active');
  }

  function renderSideDetail(item) {
    const period = item.startDt === item.endDt
            ? item.startDt
            : item.startDt + ' ~ ' + item.endDt;

    const person = item.userNm || item.rgtrId || '-';

    document.querySelectorAll('.day-schedule-title').forEach(function(btn) {
      btn.classList.remove('active');
    });

    const activeBtn = document.querySelector(
            '.day-schedule-title[data-schedule-no="' + CSS.escape(String(item.scheduleNo)) + '"]'
    );

    if (activeBtn) {
      activeBtn.classList.add('active');
    }

    document.getElementById('sideDetailArea').innerHTML =
            '<div class="side-detail-card">'
            + '<h3 class="side-detail-title">' + escapeHtml(item.scheduleTtl || '-') + '</h3>'

            + '<div class="side-detail-meta">'
            + '<div class="side-detail-row">'
            + '<span class="side-detail-label">유형</span>'
            + escapeHtml(item.scheduleTyNm || '-')
            + '</div>'

            + '<div class="side-detail-row">'
            + '<span class="side-detail-label">기간</span>'
            + escapeHtml(period)
            + '</div>'

            + '<div class="side-detail-row">'
            + '<span class="side-detail-label">위치</span>'
            + escapeHtml(item.locCn || '-')
            + '</div>'

            + '<div class="side-detail-row">'
            + '<span class="side-detail-label">등록자/직원</span>'
            + escapeHtml(person)
            + '</div>'
            + '</div>'

            + '<div class="side-detail-content">'
            + '<span class="side-detail-label">내용</span>'
            + escapeHtml(item.scheduleCn || '-')
            + '</div>'

            + '</div>';
  }

  document.getElementById('closeDayScheduleBtn').addEventListener('click', function(){
    document.getElementById('dayScheduleModal').classList.remove('active');
  });
  /*
   * 일정 상세 모달 열기
   *
   * 직원 휴가(VACATION)는 이 화면에서 직접 등록한 데이터라 수정/삭제 가능.
   * 공지, 공사, 검침, 점검은 각각 다른 테이블에서 가져온 데이터라 여기서는 읽기 전용으로 처리.
   */
  function openDetailModal(item) {
    selectedSchedule = item;

    /*
     * 일정유형 비교
     * trim()이란? 앞뒤 공백 제거.
     * 왜 사용? DB 값에 공백이 섞이면 'VACATION' 비교가 실패할 수 있기 때문.
     */
    const scheduleTy = String(item.scheduleTy || '').trim();
    const editable = scheduleTy === 'VACATION';

    /*
     * 직원휴가가 아닐 경우
     * 입력창 스타일 제거
     */
    const readonlyFields = [
      'detailUserNo',
      'detailScheduleTtl',
      'detailStartDt',
      'detailEndDt'
    ];

    document.getElementById('detailTitle').textContent = item.scheduleTtl || '일정 상세';

    document.getElementById('detailScheduleNo').value = item.scheduleNo || '';
    document.getElementById('detailScheduleTy').value = item.scheduleTy || '';

    document.getElementById('detailType').value = item.scheduleTyNm || '-';
    document.getElementById('detailUserNo').value = item.userNo || '';
    document.getElementById('detailScheduleTtl').value = item.scheduleTtl || '';
    document.getElementById('detailStartDt').value = item.startDt || '';
    document.getElementById('detailEndDt').value = item.endDt || '';
    document.getElementById('detailLoc').value = item.locCn || '-';
    document.getElementById('detailCn').value = item.scheduleCn || '-';

    /*
     * 직원휴가면 수정 가능
     * 그 외 일정은 조회 전용 스타일 적용
     */
    if (editable) {

      /*
       * 수정 가능 상태
       */
      document.getElementById('detailUserNo').disabled = false;
      document.getElementById('detailScheduleTtl').readOnly = false;
      document.getElementById('detailStartDt').disabled = false;
      document.getElementById('detailEndDt').disabled = false;

      /*
       * 읽기전용 스타일 제거
       */
      readonlyFields.forEach(function(id) {
        document.getElementById(id).classList.remove('readonly-view');
      });

    } else {

      /*
       * 조회 전용 상태
       */
      document.getElementById('detailUserNo').disabled = true;
      document.getElementById('detailScheduleTtl').readOnly = true;
      document.getElementById('detailStartDt').disabled = true;
      document.getElementById('detailEndDt').disabled = true;

      /*
       * 입력창 스타일 제거
       */
      readonlyFields.forEach(function(id) {
        document.getElementById(id).classList.add('readonly-view');
      });
    }

    document.getElementById('editScheduleBtn').style.display = editable ? 'inline-flex' : 'none';
    document.getElementById('deleteScheduleBtn').style.display = editable ? 'inline-flex' : 'none';

    document.getElementById('detailModal').classList.add('active');
  }

  /*
   * 직원 휴가 일정 수정
   */
  document.getElementById('editScheduleBtn').addEventListener('click', function () {
    if (!selectedSchedule) {
      return;
    }

    if (String(selectedSchedule.scheduleTy || '').trim() !== 'VACATION') {
      alert('직원 휴가 일정만 수정할 수 있습니다.');
      return;
    }

    const userNo = document.getElementById('detailUserNo').value;
    const title = document.getElementById('detailScheduleTtl').value.trim();
    const startDt = document.getElementById('detailStartDt').value;
    const endDt = document.getElementById('detailEndDt').value;

    if (!userNo) {
      alert('직원을 선택해 주세요.');
      return;
    }

    if (!title) {
      alert('휴가 제목을 입력해 주세요.');
      return;
    }

    if (!startDt || !endDt) {
      alert('휴가 기간을 선택해 주세요.');
      return;
    }

    if (startDt > endDt) {
      alert('종료일은 시작일보다 빠를 수 없습니다.');
      return;
    }

    fetch(contextPath + '/manager/aptScheduleCalendar/' + mgmtOfcNo + '/vacation/' + selectedSchedule.scheduleNo, {
      method: 'PUT',
      headers: Object.assign(
              { 'Content-Type': 'application/json' },
              csrfHeader && csrfToken ? { [csrfHeader]: csrfToken } : {}
      ),
      body: JSON.stringify({
        userNo: userNo,
        scheduleTtl: title,
        startDt: startDt,
        endDt: endDt,
        colorCd: selectedSchedule.colorCd || 'PURPLE'
      })
    })
            .then(function (res) {
              return res.json();
            })
            .then(function (data) {
              alert(data.message || '처리되었습니다.');

              if (data.success) {
                closeDetailModal();
                loadSchedule(currentListPage);
              }
            })
            .catch(function () {
              alert('수정 중 오류가 발생했습니다.');
            });
  });

  document.getElementById('deleteScheduleBtn').addEventListener('click', async function () {
    if (!selectedSchedule) {
      return;
    }

    if (selectedSchedule.scheduleTy !== 'VACATION') {
      await showAlert('직원 휴가 일정만 삭제할 수 있습니다.', 'warning');
      return;
    }

    var deleteConfirm = await showConfirm({
      title: '휴가 일정을 삭제하시겠습니까?',
      confirmText: '삭제',
      confirmColor: '#c0392b'
    });
    if (!deleteConfirm.isConfirmed) {
      return;
    }

    try {
      var res = await fetch(contextPath + '/manager/aptScheduleCalendar/' + mgmtOfcNo + '/vacation/' + selectedSchedule.scheduleNo, {
        method: 'DELETE',
        headers: csrfHeader && csrfToken ? { [csrfHeader]: csrfToken } : {}
      });
      var data = await res.json();
      await showAlert(data.message || '처리되었습니다.', data.success ? 'success' : 'info');
      if (data.success) {
        closeDetailModal();
        loadSchedule();
      }
    } catch (err) {
      await showAlert('삭제 중 오류가 발생했습니다.', 'error');
    }
  });

  /*
   * 일정 상세 모달 닫기
   */
  function closeDetailModal() {
    document.getElementById('detailModal').classList.remove('active');
  }

  document.getElementById('prevMonthBtn').addEventListener('click', function () { currentDate.setMonth(currentDate.getMonth() - 1); loadSchedule(); });
  document.getElementById('nextMonthBtn').addEventListener('click', function () { currentDate.setMonth(currentDate.getMonth() + 1); loadSchedule(); });
  document.getElementById('todayBtn').addEventListener('click', function () { currentDate = new Date(); loadSchedule(); });
  document.getElementById('searchBtn').addEventListener('click', function () {
    loadSchedule(1);
  });

  document.getElementById('resetBtn').addEventListener('click', function () {
    document.getElementById('scheduleTy').value = 'ALL';
    document.getElementById('keyword').value = '';
    loadSchedule(1);
  });

  /*
 * 검색조건 초기화
 *
 * 왜 사용?
 * 검색조건을 기본값으로 되돌리고
 * 전체 목록을 다시 조회하기 위해 사용.
 */
  document.getElementById('resetBtn').addEventListener('click', function () {

    /*
     * select 기본값 복구
     */
    document.getElementById('scheduleTy').value = 'ALL';

    /*
     * 검색어 초기화
     */
    document.getElementById('keyword').value = '';

    /*
     * 전체 재조회
     */
    loadSchedule();
  });

  document.getElementById('keyword').addEventListener('keydown', function (e) { if (e.key === 'Enter') loadSchedule(); });

  document.querySelectorAll('.tab-btn').forEach(function (btn) {
    btn.addEventListener('click', function () {
      document.querySelectorAll('.tab-btn').forEach(function (b) { b.classList.remove('active'); });
      btn.classList.add('active');
      const tab = btn.dataset.tab;
      document.getElementById('calendarPanel').style.display = tab === 'calendar' ? 'block' : 'none';
      document.getElementById('calendarPanel').classList.toggle('active', tab === 'calendar');
      document.getElementById('listPanel').style.display = tab === 'list' ? 'block' : 'none';
      document.getElementById('listPanel').classList.toggle('active', tab === 'list');
    });
  });

  document.getElementById('openVacationBtn').addEventListener('click', openVacationModal);
  document.getElementById('cancelVacationBtn').addEventListener('click', closeVacationModal);
  document.getElementById('saveVacationBtn').addEventListener('click', saveVacation);

  document.getElementById('closeDetailFootBtn').addEventListener('click', closeDetailModal);

  document.getElementById('detailModal').addEventListener('click', function (e) {
    if (e.target.id === 'detailModal') {
      closeDetailModal();
    }
  });

  loadSchedule();
})();

</script>
</body>
</html>
