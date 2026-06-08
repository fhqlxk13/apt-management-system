<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>우리 단지 일정</title>

    <sec:csrfMetaTags/>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/headerStyle.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebarStyle.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footerStyle.css">

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">

    <style>
        body {
            font-family: 'Noto Sans KR', sans-serif !important;
            background: var(--bg);
            color: var(--text-dark);
            margin: 0;
        }

        .material-symbols-rounded {
            font-family: 'Material Symbols Rounded' !important;
        }

        .material-symbols-outlined {
            font-family: 'Material Symbols Outlined' !important;
        }

        .main-shell {
            display: flex;
            align-items: stretch;
            width: 100%;
            min-height: calc(100vh - 114px);
            margin-top: 114px;
            background: var(--bg);
        }

        .content-area {
            flex: 1;
            min-width: 0;
            padding: 32px 40px 64px;
        }

        .page-content-wrap {
            max-width: 1080px;
            width: 100%;
            margin: 0 auto;
        }

        .breadcrumb {
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 12px;
            color: var(--text-light);
            margin-bottom: 18px;
        }

        .breadcrumb a {
            color: var(--text-light);
            text-decoration: none;
        }

        .breadcrumb .cur {
            color: var(--green-dark);
            font-weight: 700;
        }

        .page-title {
            font-size: 22px;
            font-weight: 800;
            color: var(--text-dark);
            padding-bottom: 14px;
            border-bottom: 2px solid var(--green-dark);
            margin-bottom: 16px;
            letter-spacing: -0.4px;
        }

        .calendar-hero {
            background: linear-gradient(135deg, var(--green-dark), #386a4d);
            color: #fff;
            border-radius: 14px;
            padding: 18px 28px 16px;
            margin-bottom: 16px;
            border: 1px solid var(--border);
            box-shadow: 0 10px 24px rgba(30, 60, 40, 0.05);
        }

        .calendar-hero h2 {
            font-size: 18px;
            margin: 0 0 6px;
            font-weight: 800;
        }

        .calendar-hero p {
            margin: 0;
            font-size: 12px;
            line-height: 1.6;
            color: rgba(255, 255, 255, 0.82);
        }

        .stat-row {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 14px;
            margin-bottom: 20px;
        }

        .stat-card {
            background: #fff;
            border: 1px solid var(--border);
            border-radius: 14px;
            min-height: 88px;
            padding: 14px 18px;
            display: flex;
            align-items: center;
            gap: 14px;
            box-shadow: 0 10px 24px rgba(30, 60, 40, 0.05);
        }

        .stat-icon {
            width: 46px;
            height: 46px;
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            flex-shrink: 0;
        }

        .stat-icon.green { background: #1f7a55; }
        .stat-icon.blue { background: #2563eb; }
        .stat-icon.yellow { background: #d99b1f; }
        .stat-icon.purple { background: #7c3aed; }

        .stat-icon .material-symbols-rounded {
            font-size: 26px;
        }

        .stat-value {
            font-size: 20px;
            font-weight: 800;
            color: var(--text-dark);
        }

        .stat-label {
            margin-top: 4px;
            font-size: 12px;
            font-weight: 700;
            color: var(--text-light);
        }

        .card {
            background: #fff;
            border: 1px solid var(--border);
            border-radius: 14px;
            box-shadow: 0 10px 24px rgba(30, 60, 40, 0.05);
            padding: 20px;
            margin-bottom: 20px;
        }

        .section-hd {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 14px;
            padding-bottom: 10px;
            border-bottom: 1px solid var(--border);
        }

        .section-hd h3 {
            margin: 0;
            font-size: 15px;
            font-weight: 800;
            color: var(--text-dark);
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .section-hd span {
            font-size: 12px;
            color: var(--text-light);
        }

        .tab-bar {
            display: flex;
            align-items: center;
            gap: 22px;
            margin: 0 0 18px;
            padding-bottom: 12px;
            border-bottom: 1px solid var(--border);
        }

        .tab-btn {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            height: 34px;
            padding: 0;
            border: none;
            border-radius: 0;
            background: transparent;
            color: var(--text-mid);
            font-size: 15px;
            font-weight: 800;
            cursor: pointer;
        }

        .tab-btn.active {
            color: var(--green-dark);
            background: transparent;
            border-bottom: 2px solid var(--green-dark);
        }

        .search-card {
            background: #fff;
            border: 1px solid var(--border);
            border-radius: 14px;
            box-shadow: 0 10px 24px rgba(30, 60, 40, 0.05);
            padding: 14px;
            margin-bottom: 18px;
        }

        .filter-row {
            display: flex;
            align-items: center;
            gap: 12px;
            margin: 0;
            flex-wrap: wrap;
        }

        .calendar-search-input {
            height: 38px;
            border: 1px solid #d7dce1;
            border-radius: 8px;
            padding: 0 14px;
            background: #fff;
            color: #374151;
            font-size: 13px;
            font-weight: 500;
            box-sizing: border-box;
            outline: none;
            transition: border-color 0.2s ease;
        }

        select.calendar-search-input {
            width: 150px;
            cursor: pointer;

            appearance: none;
            -webkit-appearance: none;
            -moz-appearance: none;

            padding-right: 38px;

            background-color: #fff;

            /*
             * select 화살표 직접 추가
             */
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='18' height='18' fill='none' stroke='%236b7280' stroke-width='2' viewBox='0 0 24 24'%3E%3Cpath d='m6 9 6 6 6-6'/%3E%3C/svg%3E");

            background-repeat: no-repeat;
            background-position: right 12px center;
            background-size: 16px;
        }

        .calendar-search-input::placeholder {
            color: #9ca3af;
            font-size: 13px;
        }

        .calendar-search-input:focus {
            border-color: #b8c0c8;
            box-shadow: none;
        }
        input.calendar-search-input,
        select.calendar-search-input {
            border: 1px solid #d7dce1 !important;
            box-shadow: none !important;
            border-radius: 8px;
        }

        .btn-main {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
            min-width: 72px;
            height: 36px;
            border: none;
            border-radius: 5px;
            padding: 0 16px;
            background: #006b4f;
            color: #fff;
            font-size: 13px;
            font-weight: 800;
            cursor: pointer;
        }

        .btn-main .material-symbols-rounded {
            font-size: 18px;
            font-weight: 700;
        }

        .btn-ghost {
            min-width: 58px;
            height: 34px;
            border-radius: 8px;
            padding: 0 14px;
            font-size: 12px;
            background: #fff;
            color: var(--text-mid);
            border: 1px solid var(--border);
        }

        .calendar-nav .btn-ghost {
            min-width: 58px;
            width: 58px;
            padding: 0;
        }

        .btn-mini {
            min-width: 34px;
            height: 34px;
            border-radius: 10px;
            padding: 0 10px;
            font-size: 12px;
            background: #fff;
            border: 1px solid var(--border);
            color: var(--text-mid);
        }

        .calendar-topbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
            margin-bottom: 14px;
        }

        .calendar-nav {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .calendar-title {
            min-width: 115px;
            text-align: center;
            font-size: 18px;
            font-weight: 800;
            color: #172033;
        }

        .legend-row {
            display: flex;
            align-items: center;
            gap: 12px;
            flex-wrap: wrap;
            margin: 10px 0 14px;
            padding-left: 10px;
            font-size: 12px;
            color: #64748b;
        }

        .legend-dot {
            width: 9px;
            height: 9px;
            border-radius: 50%;
            display: inline-block;
            margin-right: 4px;
        }

        .legend-dot.NOTICE { background: #2563eb; }
        .legend-dot.EVENT { background: #16a34a; }
        .legend-dot.VACATION { background: #7c3aed; }
        .legend-dot.CONSTRUCTION { background: #ea580c; }
        .legend-dot.METER { background: #0891b2; }
        .legend-dot.CHECK { background: #64748b; }

        .apt-calendar {
            table-layout: fixed;
            width: 100%;
            border-collapse: collapse;
            background: #fff;
            border-top: 2px solid #2563eb;
        }

        .apt-calendar th {
            height: 36px;
            text-align: center;
            font-size: 12px;
            font-weight: 800;
            border: 1px solid #e5e7eb;
            background: #f8fafc;
        }

        .apt-calendar td {
            height: 128px;
            vertical-align: top;
            padding: 8px 7px;
            border: 1px solid #e5e7eb;
            background: #fff;
        }

        .apt-calendar td.other-month {
            background: #eef1f4 !important;
        }

        .apt-calendar td.other-month .day-num {
            color: #b8c0cc !important;
        }

        .apt-calendar td.other-month .week-event-bar {
            opacity: 0.55;
        }

        .apt-calendar td.today {
            background: #f0f7ff;
        }

        .day-num {
            font-size: 12px;
            font-weight: 800;
            margin-bottom: 5px;
            color: #334155;
        }

        .sun .day-num {
            color: #dc2626;
        }

        .sat .day-num {
            color: #2563eb;
        }

        .schedule-chip {
            display: block;
            width: 100%;
            max-width: 100%;
            border: 1px solid currentColor;
            background: #fff;
            border-radius: 999px;
            padding: 2px 7px;
            margin-bottom: 3px;
            font-size: 10px;
            line-height: 16px;
            font-weight: 700;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            cursor: pointer;
            box-sizing: border-box;
        }

        .schedule-chip.NOTICE { color: #2563eb; }
        .schedule-chip.EVENT { color: #16a34a; }
        .schedule-chip.VACATION { color: #7c3aed; }
        .schedule-chip.CONSTRUCTION { color: #ea580c; }
        .schedule-chip.METER { color: #0891b2; }
        .schedule-chip.CHECK { color: #64748b; }

        .more-count {
            margin-top: 3px;
            font-size: 10px;
            color: #475569;
            text-align: center;
        }

        .data-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 13px;
            background: #fff;
            border-radius: 12px;
            overflow: hidden;
        }

        .data-table thead th {
            text-align: center;
            background: #f3f3f3;
            color: #111827;
            padding: 12px 14px;
            font-weight: 700;
            border-top: 2px solid #333;
            border-bottom: 1px solid var(--border);
        }

        .data-table tbody td {
            padding: 13px 14px;
            border-bottom: 1px solid #edf0eb;
            color: var(--text-dark);
            vertical-align: middle;
            text-align: center;
            white-space: nowrap;
        }

        .data-table tbody tr:last-child td {
            border-bottom: none;
        }

        .data-table .td-title {
            text-align: left;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .schedule-list-detail {
            border: none;
            background: transparent;
            padding: 0;
            color: var(--text-dark);
            font-weight: 700;
            cursor: pointer;
            max-width: 100%;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .schedule-list-detail:hover {
            color: var(--green-dark);
            text-decoration: underline;
        }

        .modal-backdrop {
            position: fixed;
            inset: 0;
            background: rgba(15, 23, 42, .45);
            display: none;
            align-items: center;
            justify-content: center;
            z-index: 1000;
        }

        .modal-backdrop.active {
            display: flex;
        }

        .modal-card {
            width: 460px;
            max-width: calc(100vw - 32px);
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 20px 60px rgba(15, 23, 42, .25);
            overflow: hidden;
        }

        .modal-head {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 16px 18px;
            border-bottom: 1px solid #e5e7eb;
        }

        .modal-title {
            font-size: 16px;
            font-weight: 800;
        }

        .modal-body {
            padding: 18px;
        }

        .detail-row {
            margin-bottom: 12px;
            font-size: 14px;
            color: #334155;
        }

        .detail-label {
            display: block;
            font-size: 12px;
            font-weight: 800;
            margin-bottom: 5px;
            color: #64748b;
        }

        .modal-foot {
            display: flex;
            justify-content: flex-end;
            gap: 8px;
            padding: 14px 18px;
            border-top: 1px solid #e5e7eb;
        }

        @media (max-width: 1200px) {
            .stat-row {
                grid-template-columns: repeat(2, 1fr);
            }

            .filter-row {
                flex-wrap: wrap;
            }
        }

        @media (max-width: 900px) {
            .main-shell {
                flex-direction: column;
            }

            .content-area {
                padding: 24px 18px 48px;
            }

            .page-content-wrap {
                max-width: 100%;
            }

            .stat-row {
                grid-template-columns: 1fr;
            }

            input.calendar-search-input,
            select.calendar-search-input {
                width: 100%;
            }

            .calendar-topbar {
                flex-direction: column;
                align-items: flex-start;
            }

            .calendar-nav {
                width: 100%;
                justify-content: flex-start;
                flex-wrap: wrap;
            }
        }

        /*
     * 초기화 버튼
     * 검색버튼보다 연한 회색 스타일로 처리.
     */
        .btn-reset {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
            min-width: 86px;
            height: 38px;
            border-radius: 8px;
            border: 1px solid #d7dce1;
            background: #fff;
            color: #4b5563;
            font-size: 13px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .btn-reset:hover {
            background: #f3f4f6;
        }

        .btn-reset .material-symbols-rounded {
            font-size: 18px;
        }
        /* 전체 일정 목록 페이징 */
        #residentScheduleCalendarPage .schedule-paging-area {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 6px;
            margin-top: 18px;
        }

        #residentScheduleCalendarPage .schedule-paging-area ul,
        #residentScheduleCalendarPage .schedule-paging-area li {
            list-style: none !important;
            padding: 0;
            margin: 0;
        }

        #residentScheduleCalendarPage .schedule-paging-area li::marker {
            display: none;
            content: '';
        }

        #residentScheduleCalendarPage .schedule-paging-area ul {
            display: flex;
            gap: 6px;
        }

        #residentScheduleCalendarPage .schedule-paging-area a,
        #residentScheduleCalendarPage .schedule-paging-area .page-link {
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

        /* 여러 날짜 일정 막대 */
        #residentScheduleCalendarPage .apt-calendar {
            overflow: visible;
        }

        #residentScheduleCalendarPage .day-num {
            padding: 8px 7px 0;
        }

        /* 캘린더 일정 막대 */
        #residentScheduleCalendarPage .week-event-bar {
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

        #residentScheduleCalendarPage .week-event-bar.NOTICE {
            background: #bfdbfe;
            color: #1d4ed8;
        }

        #residentScheduleCalendarPage .week-event-bar.EVENT {
            background: #bbf7d0;
            color: #15803d;
        }

        #residentScheduleCalendarPage .week-event-bar.VACATION {
            background: #e9d5ff;
            color: #7e22ce;
        }

        #residentScheduleCalendarPage .week-event-bar.CONSTRUCTION {
            background: #fed7aa;
            color: #c2410c;
        }

        #residentScheduleCalendarPage .week-event-bar.METER {
            background: #bae6fd;
            color: #0369a1;
        }

        #residentScheduleCalendarPage .week-event-bar.CHECK {
            background: #e2e8f0;
            color: #475569;
        }



        #residentScheduleCalendarPage .week-event-bar.hidden-event {
            display: none;
        }

        /* 캘린더 한 주 높이 고정 */
        #residentScheduleCalendarPage .apt-calendar tbody tr {
            height: 210px;
        }

        /* 날짜 칸 내부 일정이 칸 밖으로 튀어나가지 않게 처리 */
        #residentScheduleCalendarPage .apt-calendar td {
            position: relative;
            overflow: visible;
            padding: 0;
            height: 210px;
        }

        /* 숨긴 일정 */
        #residentScheduleCalendarPage .week-event-bar.hidden-event {
            display: none;
        }

        /* 전체+ 버튼 위치 고정 */
        #residentScheduleCalendarPage .calendar-more-btn {
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

        #residentScheduleCalendarPage .apt-calendar td.expanded .week-event-bar.hidden-event {
            display: block;
        }
        /*
         * 현재 보고 있는 페이지 표시
         */
        #residentScheduleCalendarPage .schedule-paging-area a.active,
        #residentScheduleCalendarPage .schedule-paging-area .page-link.active,
        #residentScheduleCalendarPage .schedule-paging-area li.active a {
            background: #166534 !important;
            border-color: #166534 !important;
            color: #fff !important;
        }
        /*
 * 전체 일정 목록 - 관리자 화면과 동일한 정렬
 */
        #residentScheduleCalendarPage .schedule-list-table {
            table-layout: fixed;
            width: 100%;
        }

        #residentScheduleCalendarPage .schedule-list-table th,
        #residentScheduleCalendarPage .schedule-list-table td {
            text-align: center;
            vertical-align: middle;
        }

        /*
         * 일정명 헤더
         */
        #residentScheduleCalendarPage .schedule-list-table th:nth-child(2) {
            text-align: left;
            padding-left: 16px;
        }

        /*
         * 위치 헤더
         */
        #residentScheduleCalendarPage .schedule-list-table th:nth-child(4) {
            text-align: left;
            padding-left: 16px;
        }

        /*
         * 등록자 헤더
         */
        #residentScheduleCalendarPage .schedule-list-table th:nth-child(5) {
            text-align: left;
            padding-left: 16px;
        }

        /*
         * 일정명 데이터
         */
        #residentScheduleCalendarPage .schedule-list-table td:nth-child(2) {
            text-align: left;
            padding-left: 16px;
        }

        /*
         * 위치 데이터
         */
        #residentScheduleCalendarPage .schedule-list-table td:nth-child(4) {
            text-align: left;
            padding-left: 16px;
        }

        /*
         * 등록자 데이터
         */
        #residentScheduleCalendarPage .schedule-list-table td:nth-child(5) {
            text-align: left;
            padding-left: 16px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
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

        #residentScheduleCalendarPage ~ .modal-backdrop .modal-card,
            /* 하루 일정 목록 모달 */
        #dayScheduleModal .modal-card {
            width: 1400px !important;
            max-width: 96vw;

            height: 85vh;
            max-height: 85vh;

            border-radius: 24px;
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
            /* 왼쪽 30%, 오른쪽 70% */
            grid-template-columns: 420px 1fr;
            padding: 28px 32px;
            gap: 28px !important;
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
        .day-schedule-title {
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
            word-break: keep-all;
            line-height: 1.5;
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
            padding: 36px 42px;
            background: #fff;
            box-shadow: none;
        }

        .side-detail-title {
            margin: 0 0 20px;
            font-size: 34px;
            line-height: 1.4;
            font-weight: 900;
            color: #111827;
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

        /* 하단 닫기 버튼 영역 */
        #dayScheduleModal .modal-foot {
            flex-shrink: 0;
            padding: 14px 22px;
            border-top: 1px solid #e5e7eb;
            background: #fff;
        }

        @keyframes detailSlideIn {
            from {
                opacity: 0;
                transform: translateX(-10px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }

        #dayScheduleModal .modal-head {
            padding: 26px 28px;
            background: linear-gradient(135deg, #f8fffb, #ffffff);
            border-bottom: 1px solid #e5e7eb;
        }

        #dayScheduleModal .modal-title {
            font-size: 26px;
            font-weight: 900;
            color: #172033;
        }

        #dayScheduleList {
            width: auto !important;
            max-height: 430px;
            overflow-y: auto;
            padding-right: 18px !important;
            border-right: 1px solid #e5e7eb;
        }

        .day-schedule-title {
            display: block;
            width: 100%;
            border: 1px solid #d7eadf;
            background: #f0fbf5;
            border-radius: 14px;
            padding: 16px 18px;
            margin-bottom: 12px;
            text-align: left;
            font-size: 15px;
            font-weight: 900;
            color: #006b4f;
            cursor: pointer;
            line-height: 1.45;
        }

        .day-schedule-title:hover,
        .day-schedule-title.active {
            background: #e2f6ea;
            border-color: #8fd3aa;
            transform: translateY(-1px);
        }

        .side-detail-title {
            margin: 0 0 22px;
            font-size: 26px;
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
            padding: 28px 32px;
            font-size: 17px;
            line-height: 2;
            color: #334155;

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
</head>

<body>
<%@ include file="/WEB-INF/views/include/apt_headerLayout.jsp" %>

<div class="main-shell">
    <%@ include file="/WEB-INF/views/include/apt_sidebarLayout.jsp" %>

    <main class="content-area">
        <div class="page-content-wrap" id="residentScheduleCalendarPage">

            <div class="breadcrumb">
                <a href="${pageContext.request.contextPath}/">HOME</a>
                <span>›</span>
                <a href="javascript:void(0);">관리사무소</a>
                <span>›</span>
                <span class="cur">우리 단지 일정</span>
            </div>

            <h1 class="page-title">우리 단지 일정</h1>

            <section class="calendar-hero">
                <h2>단지 일정 캘린더</h2>
                <p>
                    우리 아파트의 공지, 행사, 공사, 검침, 점검, 직원 휴가 일정을
                    월별 캘린더와 목록으로 확인할 수 있습니다.
                </p>
            </section>

            <div class="stat-row">
                <div class="stat-card">
                    <div class="stat-icon green">
                        <span class="material-symbols-rounded">event_available</span>
                    </div>
                    <div>
                        <div class="stat-value" id="totalCnt">0</div>
                        <div class="stat-label">전체 일정</div>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon blue">
                        <span class="material-symbols-rounded">today</span>
                    </div>
                    <div>
                        <div class="stat-value" id="todayCnt">0</div>
                        <div class="stat-label">오늘 일정</div>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon yellow">
                        <span class="material-symbols-rounded">calendar_month</span>
                    </div>
                    <div>
                        <div class="stat-value" id="monthCnt">0</div>
                        <div class="stat-label">이번 달 일정</div>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon purple">
                        <span class="material-symbols-rounded">badge</span>
                    </div>
                    <div>
                        <div class="stat-value" id="vacationCnt">0</div>
                        <div class="stat-label">직원 휴가</div>
                    </div>
                </div>
            </div>

            <div class="tab-bar">
                <button type="button" class="tab-btn active" data-tab="calendar">
                    <span class="material-symbols-rounded">calendar_month</span>
                    달력
                </button>

                <button type="button" class="tab-btn" data-tab="list">
                    <span class="material-symbols-rounded">list_alt</span>
                    전체 목록
                </button>
            </div>

            <section class="search-card">
                <div class="filter-row">

                    <select id="scheduleTy" class="calendar-search-input">
                        <option value="ALL">전체 유형</option>
                        <option value="NOTICE">공지</option>
                        <option value="EVENT">행사</option>
                        <option value="VACATION">직원휴가</option>
                        <option value="CONSTRUCTION">공사</option>
                        <option value="METER">검침</option>
                        <option value="CHECK">점검</option>
                    </select>

                    <input type="text"
                           id="keyword"
                           class="calendar-search-input"
                           placeholder="일정명, 내용, 위치, 직원명 검색">

                    <button type="button" class="btn-main" id="searchBtn">
                        <span class="material-symbols-rounded">search</span>
                        검색
                    </button>

                    <!-- 초기화 버튼 추가 -->
                    <button type="button" class="btn-reset" id="resetBtn">
                        <span class="material-symbols-rounded">refresh</span>
                        초기화
                    </button>

                </div>
            </section>

            <section class="card tab-panel active" id="calendarPanel">
                <div class="section-hd calendar-topbar">
                    <h3>
                        <span class="material-symbols-rounded">calendar_month</span>
                        월간 일정
                    </h3>

                    <div class="calendar-nav">
                        <button type="button" class="btn-mini" id="prevMonthBtn">
                            <span class="material-symbols-rounded">chevron_left</span>
                        </button>

                        <strong class="calendar-title" id="calendarTitle"></strong>

                        <button type="button" class="btn-mini" id="nextMonthBtn">
                            <span class="material-symbols-rounded">chevron_right</span>
                        </button>

                        <button type="button" class="btn-ghost" id="todayBtn">
                            오늘
                        </button>
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
                    <thead>
                    <tr>
                        <th style="color:#dc2626;">일</th>
                        <th>월</th>
                        <th>화</th>
                        <th>수</th>
                        <th>목</th>
                        <th>금</th>
                        <th style="color:#2563eb;">토</th>
                    </tr>
                    </thead>
                    <tbody id="calendarBody"></tbody>
                </table>
            </section>

            <section class="card tab-panel" id="listPanel" style="display:none;">
                <div class="section-hd">
                    <h3>
                        <span class="material-symbols-rounded">list_alt</span>
                        전체 일정 목록
                    </h3>
                    <span id="currentMonthInfo">
                        현재 조회는 월 기준 목록입니다.
                    </span>
                </div>

                <table class="data-table schedule-list-table">
                    <thead>
                    <th style="width:110px;">유형</th>
                    <th>일정명</th>
                    <th style="width:200px;">기간</th>
                    <th style="width:210px;">위치</th>
                    <th style="width:210px;">등록자/직원</th>
                    </thead>
                    <tbody id="scheduleListBody">
                    <tr>
                        <td colspan="5">조회된 일정이 없습니다.</td>
                    </tr>
                    </tbody>
                </table>
                <!--
                  목록 페이징 영역
                -->
                <div id="schedulePagingArea" class="schedule-paging-area"></div>
            </section>

        </div>
    </main>
</div>

<div class="modal-backdrop" id="detailModal">
    <div class="modal-card">
        <div class="modal-head">
            <div class="modal-title" id="detailTitle">일정 상세</div>
        </div>

        <div class="modal-body">
            <div class="detail-row">
                <span class="detail-label">유형</span>
                <span id="detailType">-</span>
            </div>

            <div class="detail-row">
                <span class="detail-label">기간</span>
                <span id="detailPeriod">-</span>
            </div>

            <div class="detail-row">
                <span class="detail-label">위치</span>
                <span id="detailLoc">-</span>
            </div>

            <div class="detail-row">
                <span class="detail-label">등록자/직원</span>
                <span id="detailPerson">-</span>
            </div>

            <div class="detail-row">
                <span class="detail-label">내용</span>
                <span id="detailCn">-</span>
            </div>
        </div>

        <div class="modal-foot">
            <button type="button" class="btn-ghost" id="closeDetailFootBtn">
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
                <div style="color:#94a3b8; font-weight:700;">
                    왼쪽 일정 제목을 선택하세요.
                </div>
            </div>
        </div>

        <div class="modal-foot">
            <button type="button" class="btn-ghost" id="closeDayScheduleBtn">
                닫기
            </button>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/views/include/apt_footerLayout.jsp" %>

<script>
    (function () {
        const contextPath = '${pageContext.request.contextPath}';
        const aptCmplexNo = '${aptCmplexNo}';

        let currentDate = new Date();

        /*
         * calendarList
         * 달력용 전체 일정
         */
        let scheduleList = [];

        /*
         * listPageList
         * 전체목록 탭 페이징용 목록
         */
        let listPageList = [];

        /*
         * pagingHTML
         * 서버에서 내려주는 페이징 HTML
         */
        let pagingHTML = '';

        /*
         * 현재 목록 페이지 번호
         */
        let currentListPage = 1;

        const calendarTitle = document.getElementById('calendarTitle');
        const calendarBody = document.getElementById('calendarBody');
        const scheduleListBody = document.getElementById('scheduleListBody');

        /*
         * pad 함수
         * 숫자를 2자리 문자열로 맞춘다.
         * 예: 1 -> 01
         */
        function pad(num) {
            return String(num).padStart(2, '0');
        }

        /*
         * 날짜를 YYYY-MM-DD 형식으로 변환한다.
         */
        function formatDate(date) {
            return date.getFullYear() + '-' + pad(date.getMonth() + 1) + '-' + pad(date.getDate());
        }

        /*
         * escapeHtml이란?
         * HTML 태그가 화면에서 실행되지 않도록 문자로 바꾸는 함수.
         * 왜 사용? DB 값에 태그가 들어와도 안전하게 출력하기 위해.
         */
        function escapeHtml(value) {
            if (value === null || value === undefined) {
                return '';
            }

            return String(value).replace(/[&<>"]/g, function (s) {
                return {
                    '&': '&amp;',
                    '<': '&lt;',
                    '>': '&gt;',
                    '"': '&quot;'
                }[s];
            });
        }

        /*
         * 현재 월의 시작일과 종료일을 구한다.
         */
        function getMonthRange() {
            const first = new Date(currentDate.getFullYear(), currentDate.getMonth(), 1);
            const last = new Date(currentDate.getFullYear(), currentDate.getMonth() + 1, 0);

            return {
                start: formatDate(first),
                end: formatDate(last)
            };
        }

        /*
         * 일정 목록 + 통계 조회
         *
         * fetch란?
         * JavaScript에서 서버로 요청을 보내는 기능.
         * 왜 사용? 화면 새로고침 없이 캘린더 일정만 다시 조회하기 위해.
         */
        function loadSchedule(page) {

            currentListPage = page || 1;

            const range = getMonthRange();

            const params = new URLSearchParams();

            params.append('monthStartDt', range.start);
            params.append('monthEndDt', range.end);
            params.append('scheduleTy', document.getElementById('scheduleTy').value);
            params.append('keyword', document.getElementById('keyword').value.trim());

            /*
             * currentPage 추가
             * 왜 사용?
             * 전체 일정 목록 페이징 조회를 위해.
             */
            params.append('currentPage', currentListPage);

            fetch(contextPath + '/resident/calendar/' + aptCmplexNo + '/list?' + params.toString())
                .then(function (res) {
                    return res.json();
                })
                .then(function (data) {

                    /*
                     * 달력용 전체 일정
                     */
                    scheduleList = data.calendarList || [];

                    /*
                     * 목록 탭 페이징용 목록
                     */
                    listPageList = data.list || [];

                    /*
                     * 서버 페이징 HTML
                     */
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

        /*
         * 상단 통계 카드 출력
         */
        function renderStat(stat) {
            document.getElementById('totalCnt').textContent = stat.totalCnt || 0;
            document.getElementById('todayCnt').textContent = stat.todayCnt || 0;
            document.getElementById('monthCnt').textContent = stat.monthCnt || 0;
            document.getElementById('vacationCnt').textContent = stat.vacationCnt || 0;
        }

        /*
         * 달력 출력
         */
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

                const weekSegments = createWeekSegments(weekStart);

                html += '<tr>';

                for (let day = 0; day < 7; day++) {
                    const cellDate = new Date(weekStart);
                    cellDate.setDate(weekStart.getDate() + day);

                    const dateStr = formatDate(cellDate);
                    const isOther = cellDate.getMonth() !== month;
                    const dayClass = day === 0 ? 'sun' : (day === 6 ? 'sat' : '');
                    const todayClass = dateStr === todayStr ? 'today' : '';

                    html += '<td class="' + dayClass + ' ' + todayClass + (isOther ? ' other-month' : '') + '" data-date="' + dateStr + '">';
                    html += '<div class="day-num">' + cellDate.getDate() + '</div>';
                    html += renderWeekBarsByDate(dateStr, day, weekSegments);
                    html += '</td>';
                }

                html += '</tr>';
            }

            calendarBody.innerHTML = html;

            document.querySelectorAll('#calendarBody td[data-date]').forEach(function(td){
                td.addEventListener('click', function(e){

                    /*
                     * 일정 막대를 눌러도 날짜 목록 모달이 뜨게 처리.
                     * 왜 사용?
                     * 관리자 화면처럼 날짜 기준 일정 목록을 먼저 보여주기 위해.
                     */
                    const dateStr = td.dataset.date;
                    const daySchedules = getSchedulesByDate(dateStr);

                    openDayScheduleModal(dateStr, daySchedules);
                });
            });

            document.querySelectorAll('.calendar-more-btn').forEach(function (btn) {
                btn.addEventListener('click', function (e) {
                    e.stopPropagation();

                    const td = btn.closest('td');
                    const dateStr = td.dataset.date;
                    const daySchedules = getSchedulesByDate(dateStr);

                    /*
                     * 전체+ 버튼 클릭 시 모달로 일정 목록을 보여준다.
                     * 왜 사용?
                     * 칸 안에서 펼치면 달력 높이가 깨지기 때문에 모달 방식이 더 안정적이다.
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
            const maxVisibleLane = 8;

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
             * 숨겨진 일정이 있을 때만 전체+ 버튼 표시
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

        function parseLocalDate(dateStr) {
            const parts = dateStr.split('-');
            return new Date(Number(parts[0]), Number(parts[1]) - 1, Number(parts[2]));
        }

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

            const laneEndDays = [];

            segments.forEach(function (seg) {
                let lane = 0;

                while (
                    laneEndDays[lane] !== undefined &&
                    laneEndDays[lane] >= seg.startDay
                    ) {
                    lane++;
                }

                seg.lane = lane;
                laneEndDays[lane] = seg.endDay;
            });

            return segments;
        }

        /*
         * 해당 날짜에 포함되는 일정 찾기
         */
        function getSchedulesByDate(dateStr) {
            return scheduleList.filter(function (item) {
                return item.startDt <= dateStr && item.endDt >= dateStr;
            });
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
        /*
         * 목록 페이징 렌더링
         */
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
        /*
         * 전체 목록 출력
         */
        function renderList() {

            if (!listPageList.length) {

                scheduleListBody.innerHTML =
                    '<tr>' +
                    '<td colspan="5">조회된 일정이 없습니다.</td>' +
                    '</tr>';

                return;
            }

            scheduleListBody.innerHTML = listPageList.map(function (item) {

                const period =
                    item.startDt === item.endDt
                        ? item.startDt
                        : item.startDt + ' ~ ' + item.endDt;

                const person = item.userNm || item.rgtrId || '-';

                return '<tr>'
                    + '<td>' + escapeHtml(item.scheduleTyNm) + '</td>'

                    + '<td class="td-title">'
                    + '<button type="button"'
                    + ' class="schedule-list-detail"'
                    + ' data-schedule-no="' + escapeHtml(item.scheduleNo) + '">'
                    + escapeHtml(item.scheduleTtl)
                    + '</button>'
                    + '</td>'

                    + '<td>' + escapeHtml(period) + '</td>'
                    + '<td>' + escapeHtml(item.locCn || '-') + '</td>'
                    + '<td>' + escapeHtml(person) + '</td>'
                    + '</tr>';

            }).join('');

            /*
             * 상세 모달 연결
             */
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

        /*
         * 일정 상세 모달 열기
         */
        function openDetailModal(item) {
            const period = item.startDt === item.endDt
                ? item.startDt
                : item.startDt + ' ~ ' + item.endDt;

            const person = item.userNm || item.rgtrId || '-';

            document.getElementById('detailTitle').textContent = item.scheduleTtl || '일정 상세';
            document.getElementById('detailType').textContent = item.scheduleTyNm || '-';
            document.getElementById('detailPeriod').textContent = period || '-';
            document.getElementById('detailLoc').textContent = item.locCn || '-';
            document.getElementById('detailPerson').textContent = person;

            /*
             * 직원휴가일 때만 휴가종류를 뱃지로 보여준다.
             *
             * innerHTML이란?
             * HTML 태그까지 화면에 넣을 수 있는 속성.
             *
             * 왜 사용?
             * 단순 글자가 아니라 <span> 뱃지를 만들어야 해서 사용.
             */
            if (item.scheduleTy === 'VACATION') {
                const vacationNm = item.scheduleSttsNm || item.scheduleTtl || '직원휴가';
                const vacationCn = item.scheduleSttsCn || item.scheduleCn || '직원 휴가 일정';
                const badgeColor = item.scheduleColorHex || '#E9D5FF';

                document.getElementById('detailCn').innerHTML =
                    '<span class="vacation-type-badge" style="background:' + escapeHtml(badgeColor) + ';">'
                    + escapeHtml(vacationNm)
                    + '</span>'
                    + '<div style="margin-top:8px;">'
                    + escapeHtml(vacationCn).replace(/#[A-Fa-f0-9]{6}/g, '').trim()
                    + '</div>';
            } else {
                /*
                 * 직원휴가가 아닌 공지/행사/공사/점검 등은 일반 내용만 출력한다.
                 */
                document.getElementById('detailCn').textContent = item.scheduleCn || '-';
            }

            document.getElementById('detailModal').classList.add('active');
        }

        /*
         * 일정 상세 모달 닫기
         */
        function closeDetailModal() {
            document.getElementById('detailModal').classList.remove('active');
        }

        document.getElementById('prevMonthBtn').addEventListener('click', function () {
            currentDate.setMonth(currentDate.getMonth() - 1);
            loadSchedule();
        });

        document.getElementById('nextMonthBtn').addEventListener('click', function () {
            currentDate.setMonth(currentDate.getMonth() + 1);
            loadSchedule();
        });

        document.getElementById('todayBtn').addEventListener('click', function () {
            currentDate = new Date();
            loadSchedule();
        });

        /*
         * 검색 버튼 클릭
         *
         * 주의:
         * addEventListener에 loadSchedule을 바로 넣으면
         * 클릭 이벤트 객체가 page 값으로 들어갈 수 있다.
         *
         * 그래서 반드시 function으로 감싸서 loadSchedule(1)을 호출한다.
         */
        document.getElementById('searchBtn').addEventListener('click', function () {
            loadSchedule(1);
        });

        document.getElementById('keyword').addEventListener('keydown', function (e) {
            if (e.key === 'Enter') {
                loadSchedule();
            }
        });

        document.querySelectorAll('.tab-btn').forEach(function (btn) {
            btn.addEventListener('click', function () {
                document.querySelectorAll('.tab-btn').forEach(function (b) {
                    b.classList.remove('active');
                });

                btn.classList.add('active');

                const tab = btn.dataset.tab;

                document.getElementById('calendarPanel').style.display = tab === 'calendar' ? 'block' : 'none';
                document.getElementById('calendarPanel').classList.toggle('active', tab === 'calendar');

                document.getElementById('listPanel').style.display = tab === 'list' ? 'block' : 'none';
                document.getElementById('listPanel').classList.toggle('active', tab === 'list');
            });
        });

        document.getElementById('closeDetailFootBtn').addEventListener('click', closeDetailModal);
        document.getElementById('closeDayScheduleBtn').addEventListener('click', function(){
            document.getElementById('dayScheduleModal').classList.remove('active');
        });

        document.getElementById('detailModal').addEventListener('click', function (e) {
            if (e.target.id === 'detailModal') {
                closeDetailModal();
            }
        });

        /*
         * 검색조건 초기화
         */
        const resetBtn = document.getElementById('resetBtn');

        if (resetBtn) {
            resetBtn.addEventListener('click', function () {
                document.getElementById('scheduleTy').value = 'ALL';
                document.getElementById('keyword').value = '';

                loadSchedule();
            });
        }

        loadSchedule();
    })();

</script>
</body>
</html>