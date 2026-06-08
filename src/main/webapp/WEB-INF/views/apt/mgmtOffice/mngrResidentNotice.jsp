<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>공지사항 관리</title>
    <!-- 구글 아이콘 -->
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded"
          rel="stylesheet">

    <!-- 관리사무소 공통 CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/office-layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/manager-common.css">

    <style>

        #noticePage {
            color: #111827;
        }

        /* 페이지 제목 영역 */
        #noticePage .page-title-block {
            margin-bottom: 22px;
        }

        #noticePage .page-title-block h2 {
            font-size: 22px;
            font-weight: 800;
            margin-bottom: 6px;
        }

        #noticePage .page-title-block p {
            font-size: 13px;
            color: #8a94a6;
        }

        /* 공통 카드 */
        #noticePage .notice-card {
            background: #fff;
            border: 1px solid #d8dde6;
            border-radius: 7px;
            margin-bottom: 20px;
            overflow: hidden;
        }

        /* 카드 제목 */
        #noticePage .card-header {
            height: 55px;
            padding: 0 22px;
            border-bottom: 1px solid #d8dde6;
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 15px;
            font-weight: 800;
        }

        #noticePage .card-header .material-symbols-rounded {
            font-size: 18px;
            color: #8a94a6;
        }

        /* 검색 조건 */
        #noticePage .search-body {
            padding: 22px;
        }

        #noticePage .search-row {
            display: grid;
            grid-template-columns: repeat(3, minmax(220px, 1fr));
            gap: 16px;
        }

        #noticePage .search-group {
            display: flex;
            flex-direction: column;
            gap: 7px;
        }

        #noticePage .search-label {
            font-size: 12px;
            font-weight: 800;
            color: #374151;
        }

        #noticePage .search-input {
            width: 100%;
            height: 37px;
            border: 1px solid #d5dbe5;
            border-radius: 5px;
            background: #fff;
            padding: 0 12px;
            font-size: 13px;
            outline: none;
        }

        #noticePage .search-input:focus {
            border-color: #265c30;
            box-shadow: 0 0 0 2px rgba(38, 92, 48, 0.08);
        }

        /* 추가 조건 + 버튼 한 줄 정렬 */
        #noticePage .search-extra-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            height: 37px;
        }

        /* 체크박스 묶음 */
        #noticePage .search-check-wrap {
            display: flex;
            align-items: center;
            gap: 24px;
            height: 37px;
        }

        /* 추가 조건 오른쪽 버튼 */
        #noticePage .search-actions-inline {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-left: auto;
        }

        /* 작성일 기간 */
        #noticePage .date-range {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        #noticePage .date-tilde {
            font-size: 13px;
            font-weight: 700;
            color: #6b7280;
        }

        /* 버튼 영역 */
        #noticePage .search-actions {
            display: flex;
            justify-content: flex-end;
            gap: 8px;
            margin-top: 18px;
        }

        #noticePage .btn {
            height: 37px;
            min-width: 78px;
            padding: 0 16px;
            border-radius: 5px;
            border: 1px solid transparent;
            cursor: pointer;
            font-size: 13px;
            font-weight: 800;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 5px;
        }

        #noticePage .btn-search {
            background: #265c30;
            color: #fff;
        }

        #noticePage .btn-reset {
            background: #fff;
            color: #374151;
            border-color: #d5dbe5;
        }

        /* 목록 카드 */
        #noticePage .list-header {
            height: 55px;
            padding: 0 22px;
            border-bottom: 1px solid #d8dde6;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        #noticePage .list-title {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 15px;
            font-weight: 800;
        }

        #noticePage .list-title .material-symbols-rounded {
            font-size: 18px;
            color: #8a94a6;
        }

        #noticePage .list-count {
            background: #f3f4f6;
            color: #8a94a6;
            border-radius: 999px;
            padding: 2px 9px;
            font-size: 12px;
            font-weight: 800;
        }

        /* 테이블 */
        #noticePage .notice-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 13px;
        }

        #noticePage .notice-table th {
            height: 40px;
            background: #f8fafc;
            color: #8a94a6;
            font-size: 12px;
            font-weight: 800;
            border-bottom: 1px solid #d8dde6;
            text-align: center;
        }

        #noticePage .notice-table td {
            height: 54px;
            border-bottom: 1px solid #eef1f5;
            text-align: center;
            color: #111827;
        }

        #noticePage .notice-title-cell {
            text-align: left !important;
            padding-left: 18px;
            font-weight: 700;
        }

        /* 긴급 배지 */
        #noticePage .urgent-badge {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            height: 22px;
            padding: 0 8px;
            border-radius: 5px;
            background: #fff1ef;
            color: #ef4444;
            border: 1px solid #fecaca;
            font-size: 11px;
            font-weight: 800;
            margin-right: 8px;
        }

        /* 관리 버튼 영역 */
        #noticePage .notice-table td:last-child {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        /* 수정 버튼: 초기화 버튼 느낌 */
        #noticePage .btn-write {
            background: #fff;
            color: #374151;
            border: 1px solid #d5dbe5;
            border-radius: 5px;
            min-width: 66px;
            height: 34px;
        }

        /* 삭제 버튼: 검색 버튼 느낌 */
        #noticePage .btn-delete {
            background: #265c30;
            color: #fff;
            border: 1px solid #265c30;
            border-radius: 5px;
            min-width: 66px;
            height: 34px;
        }

        /* 글쓰기 버튼 */
        #noticePage .btn-register {
            background: #265c30;
            color: #fff;
            border: 1px solid #265c30;
            /*border-radius: 999px;*/
            /*
               버튼 크기
           */
            min-width: 60px;
            height: 36px;
            /*
               버튼 내부 좌우 여백
           */
            padding: 0 12px;
        }

        /* 목록 오른쪽 영역 */
        #noticePage .list-actions {
            display: flex;
            align-items: center;
            gap: 37px;
        }

        /* 모달 배경 */
        #noticePage .notice-modal-overlay {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(17, 24, 39, 0.45);
            z-index: 1000;

            /* 화면 가운데 배치 */
            align-items: center;
            justify-content: center;

            /* 모달이 화면보다 클 때 위아래 여백 확보 */
            padding: 24px;
        }

        /* open 클래스가 붙으면 모달 보이기 */
        #noticePage .notice-modal-overlay.open {
            display: flex;
        }

        /* 모달 박스 */
        #noticePage .notice-modal {
            width: 560px;
            max-width: 95vw;
            max-height: calc(100vh - 48px);

            background: #fff;
            border-radius: 7px;
            overflow: hidden;
            box-shadow: 0 20px 50px rgba(17, 24, 39, 0.18);

            /*
             * header / body / footer를 세로로 나누기 위한 구조
             * body만 스크롤되고 footer는 항상 아래에 보이게 함
             */
            display: flex;
            flex-direction: column;
        }

        /* 모달 제목 */
        #noticePage .notice-modal-header {
            height: 54px;
            padding: 0 18px;
            border-bottom: 1px solid #d8dde6;
            display: flex;
            align-items: center;
            justify-content: space-between;
            font-weight: 800;
        }

        /* 모달 내용 */
        #noticePage .notice-modal-body {
            padding: 18px;

            /*
             * 핵심:
             * 첨부파일 이미지가 많아지면 body 영역만 스크롤되게 함.
             * 취소/저장 버튼은 footer에 있으므로 밀려나지 않음.
             */
            flex: 1 1 auto;
            overflow-y: auto;
            min-height: 0;
        }

        #noticePage .form-section-title {
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 13px;
            font-weight: 800;
            color: #8a94a6;
            padding-bottom: 10px;
            border-bottom: 1px solid #d8dde6;
            margin-bottom: 16px;
        }

        /* 입력 묶음 */
        #noticePage .form-field {
            display: flex;
            flex-direction: column;
            gap: 7px;
            margin-bottom: 14px;
        }

        #noticePage .field-label {
            font-size: 12px;
            font-weight: 800;
            color: #374151;
        }

        #noticePage .req {
            color: #ef4444;
        }

        #noticePage .form-input,
        #noticePage .form-textarea {
            width: 100%;
            border: 1px solid #d5dbe5;
            border-radius: 5px;
            padding: 0 12px;
            font-size: 13px;
            outline: none;
        }

        #noticePage .form-input {
            height: 37px;
        }

        #noticePage .form-textarea {
            height: 180px;
            padding: 12px;
            resize: none;
        }

        #noticePage .form-input:focus,
        #noticePage .form-textarea:focus {
            border-color: #265c30;
            box-shadow: 0 0 0 2px rgba(38, 92, 48, 0.08);
        }

        /* 체크박스 */
        #noticePage .check-row {
            display: flex;
            align-items: center;
            gap: 7px;
            font-size: 13px;
            font-weight: 700;
            color: #374151;
        }

        /* 모달 하단 버튼 */
        #noticePage .notice-modal-footer {
            height: 64px;
            padding: 0 18px;
            border-top: 1px solid #d8dde6;
            display: flex;
            align-items: center;
            justify-content: flex-end;
            gap: 8px;
            background: #fff;

            /*
             * footer가 첨부파일 영역에 밀려서 줄어들지 않게 고정
             */
            flex: 0 0 64px;
        }

        /* 페이징 전체 영역 */
        #noticePage .notice-pagination-wrap {
            padding: 18px 0 22px;
            display: flex;
            justify-content: center;
        }

        /* ul 기본 점 제거 */
        #noticePage .pagination {
            display: flex;
            gap: 6px;
            list-style: none;
            padding: 0;
            margin: 0;
        }

        /* 페이지 버튼 */
        #noticePage .page-link {
            min-width: 34px;
            height: 34px;
            padding: 0 10px;
            border: 1px solid #d5dbe5;
            border-radius: 6px;
            background: #fff;
            color: #374151;
            font-size: 13px;
            font-weight: 800;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            text-decoration: none;
        }

        /* 현재 페이지 */
        #noticePage .page-item.active .page-link {
            background: #265c30;
            border-color: #265c30;
            color: #fff;
        }

        /* 체크박스 묶음 */
        #noticePage .search-check-wrap {
            display: flex;
            align-items: center;
            gap: 24px;
            height: 37px;
        }

        /* 체크박스 한 줄 */
        #noticePage .search-check-inline {
            display: flex;
            align-items: center;
            gap: 8px;

            font-size: 14px;
            font-weight: 700;
            color: #374151;

            cursor: pointer;
        }

        /* 체크박스 크기 */
        #noticePage .search-check-inline input[type="checkbox"] {
            width: 16px;
            height: 16px;
        }

        /* 체크박스 크기 */
        #noticePage .search-check-label input[type="checkbox"] {
            width: 15px;
            height: 15px;
        }

        /* 조회 결과 없음 row */
        #noticePage .no-data-row td {
            height: 170px !important;

            /* td를 원래 table-cell 형태로 유지 */
            display: table-cell !important;

            /* 가로 중앙 */
            text-align: center !important;

            /* 세로 중앙 */
            vertical-align: middle !important;

            border-bottom: 1px solid #eef1f5;
        }

        /* 조회 결과 없음 글씨 */
        #noticePage .no-data-cell {
            color: #6b7280 !important;
            font-size: 14px;
            font-weight: 500 !important;
            background: #fff;
        }

        /* hover 효과 제거 */
        #noticePage .notice-table tbody tr:hover {
            background: transparent !important;
        }

        /* 처리 결과 모달 배경 */
        #noticePage .notice-result-modal-overlay {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(17, 24, 39, 0.45);
            z-index: 1200;
            align-items: center;
            justify-content: center;
        }

        /* open 클래스가 있으면 표시 */
        #noticePage .notice-result-modal-overlay.open {
            display: flex;
        }

        /* 처리 결과 모달 박스 */
        #noticePage .notice-result-modal {
            width: 360px;
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 20px 50px rgba(17, 24, 39, 0.2);
            overflow: hidden;
        }

        /* 제목 */
        #noticePage .notice-result-title {
            padding: 18px 20px 8px;
            font-size: 16px;
            font-weight: 800;
            color: #111827;
        }

        /* 메시지 */
        #noticePage .notice-result-message {
            padding: 8px 20px 20px;
            font-size: 14px;
            font-weight: 500;
            color: #4b5563;
        }

        /* 하단 */
        #noticePage .notice-result-footer {
            padding: 14px 20px;
            border-top: 1px solid #e5e7eb;
            display: flex;
            justify-content: flex-end;
        }

        /* th는 table-cell 유지: 표 컬럼이 가로로 유지됨 */
        #noticePage .notice-table th {
            height: 40px;
            background: #f8fafc;
            color: #8a94a6;
            font-size: 12px;
            font-weight: 800;
            border-bottom: 1px solid #d8dde6;
            text-align: center;
            vertical-align: middle;
            white-space: nowrap;
        }

        /* 정렬 가능한 헤더 */
        #noticePage .sortable-th {
            cursor: pointer;
        }

        /* th 안쪽 내용만 가로 정렬 */
        #noticePage .sortable-inner {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 4px;
            white-space: nowrap;
        }

        /* 제목 컬럼만 왼쪽 정렬 */
        #noticePage .notice-table th.title-col,
        #noticePage .notice-table td.title-col {
            text-align: left;
        }

        /* 제목 헤더 내부도 왼쪽 정렬 */
        #noticePage .title-col .sortable-inner {
            justify-content: flex-start;
        }

        /* 제목 헤더 글씨만 오른쪽으로 조금 이동 */
        #noticePage .notice-table th.title-col .sortable-inner {
            padding-left: 8px;
        }

        /* 정렬 아이콘 */
        #noticePage .sort-icon {
            font-family: 'Material Symbols Rounded';
            font-size: 17px;
            line-height: 1;
            color: #9ca3af;
        }

        /* 활성화된 정렬 아이콘 */
        #noticePage .sort-icon.active {
            color: #265c30;
        }

        /* 파일 업로드 input 전용 */
        #noticePage input[type="file"].form-input {
            padding: 6px 12px;
            height: auto;
            line-height: normal;
        }

        /* 파일 업로드 input */
        #noticePage input[type="file"].form-input {
            height: 37px;
            padding: 0;
            display: flex;
            align-items: center;
            overflow: hidden;
        }

        /* 파일 선택 버튼 */
        #noticePage input[type="file"].form-input::file-selector-button {
            height: 37px;
            padding: 0 14px;
            border: none;
            border-right: 1px solid #d5dbe5;
            background: #f8fafc;
            color: #374151;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            margin-right: 12px;
        }

        /* hover 효과 */
        #noticePage input[type="file"].form-input::file-selector-button:hover {
            background: #eef2f7;
        }

        /*
         * 현재 첨부파일/새 첨부파일 목록이 많아질 때
         * 모달 전체가 커지는 대신 내부에서만 스크롤되게 보조 처리
         */
        #noticePage #currentFileList,
        #noticePage #newFilePreviewList {
            max-height: 260px;
            overflow-y: auto;
            padding-right: 4px;
        }

        /*
         * 이미지 미리보기 크기 고정
         * 이미지가 커져도 모달 높이를 과하게 밀지 않게 함
         */
        #noticePage #currentFileList img,
        #noticePage #newFilePreviewList img {
            width: 90px !important;
            height: 90px !important;
            object-fit: cover !important;
        }

    </style>

</head>

<body>
<%-- app-wrapper
     → 전체 화면을 사이드바 + 본문으로 나누는 최상위 박스.
    사이드바는 main-wrap 밖에 있어야 함.
--%>
<div class="app-wrapper">
    <%@ include file="/WEB-INF/views/include/office_sidebar.jsp" %>
    <div class="main-wrap">
        <%@ include file="/WEB-INF/views/include/office_header.jsp" %>
        <%-- main-content
             → 실제 페이지 내용이 들어가는 스크롤 영역.
        --%>
        <main class="main-content">
            <%-- office-page
                 → 페이지별 CSS 범위를 제한하는 박스.(공지사항 화면에만 CSS 적용)
            --%>
            <div class="office-page" id="noticePage">
                <!-- 기존 공지사항 화면 시작 -->
                <div class="notice-wrap">

                    <div class="page-title-block">
                        <h2>공지사항 관리</h2>
                        <p>입주민 공지사항을 등록하고 관리합니다.</p>
                    </div>
                    <!-- 상단 -->
                    <div class="notice-card">
                        <div class="card-header">
                            <span class="material-symbols-rounded">manage_search</span>
                            검색 조건
                        </div>

                        <div class="search-body">
                            <form id="searchForm"
                                  method="get"
                                  action="${pageContext.request.contextPath}/mgmtOffice/mngrResidentNotice/${mgmtOfcNo}">
                                <%-- 검색 시, 1페이지로 보내기 --%>
                                <input type="hidden" name="currentPage" value="1">
                                <%-- 정렬 컬럼 --%>
                                <input type="hidden"
                                       id="sortColumn"
                                       name="sortColumn"
                                       value="${empty param.sortColumn ? 'REG_DTTM' : param.sortColumn}">

                                <%-- 정렬 방향 --%>
                                <input type="hidden"
                                       id="sortOrder"
                                       name="sortOrder"
                                       value="${empty param.sortOrder ? 'DESC' : param.sortOrder}">
                                <div class="search-row">

                                    <div class="search-group">
                                        <label class="search-label">공지번호</label>
                                        <input type="text" name="searchAnnNo" class="search-input"
                                               placeholder="공지번호 검색" value="${param.searchAnnNo}">
                                    </div>

                                    <div class="search-group">
                                        <label class="search-label">제목</label>
                                        <input type="text" name="searchTtl" class="search-input"
                                               placeholder="제목 검색" value="${param.searchTtl}">
                                    </div>

                                    <div class="search-group">
                                        <label class="search-label">작성자</label>
                                        <input type="text" name="searchWrtrId" class="search-input"
                                               placeholder="작성자 검색" value="${param.searchWrtrId}">
                                    </div>

                                    <div class="search-group">
                                        <label class="search-label">작성일 시작</label>
                                        <input type="date" name="searchStartDt" class="search-input"
                                               value="${param.searchStartDt}">
                                    </div>

                                    <div class="search-group">
                                        <label class="search-label">작성일 종료</label>
                                        <input type="date" name="searchEndDt" class="search-input"
                                               value="${param.searchEndDt}">
                                    </div>

                                    <div class="search-group search-extra-group">
                                        <label class="search-label">추가 조건</label>

                                        <div class="search-extra-row">

                                            <div class="search-check-wrap">
                                                <label class="search-check-inline">
                                                    <input type="checkbox"
                                                           name="searchTopFixYn"
                                                           value="Y"
                                                    ${param.searchTopFixYn eq 'Y' ? 'checked' : ''}>
                                                    긴급공지
                                                </label>

                                                <label class="search-check-inline">
                                                    <input type="checkbox"
                                                           name="searchAttachYn"
                                                           value="Y"
                                                    ${param.searchAttachYn eq 'Y' ? 'checked' : ''}>
                                                    첨부파일
                                                </label>
                                            </div>

                                            <div class="search-actions-inline">
                                                <button type="button" class="btn btn-reset"
                                                        onclick="location.href='${pageContext.request.contextPath}/mgmtOffice/mngrResidentNotice/${mgmtOfcNo}'">
                                                    초기화
                                                </button>

                                                <button type="submit" class="btn btn-search">
                                                    <span class="material-symbols-rounded" style="font-size:16px;">search</span>
                                                    검색
                                                </button>
                                            </div>

                                        </div>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                    <!-- 목록 카드 -->
                    <div class="notice-card">
                        <!-- 목록 헤더 -->
                        <div class="list-header">
                            <div class="list-title">
                                <span class="material-symbols-rounded">campaign</span>
                                공지사항 목록
                            </div>
                            <div class="list-actions">
                                <!-- 글쓰기 버튼 -->
                                <button type="button"
                                        class="btn btn-register"
                                        id="openNoticeModalBtn">
                                    <span class="material-symbols-rounded"
                                          style="font-size:16px;">
                                        edit
                                    </span>
                                    글쓰기
                                </button>
                                <!-- 목록 건수 -->
                                <span class="list-count">
                                    총 ${noticeCount}건
                                </span>
                            </div>
                        </div>
                        <!-- 공지사항 테이블 -->
                        <table class="notice-table">
                            <thead>
                            <tr>
                                <th>번호</th>

                                <th class="sortable-th" onclick="sortNotice('ANN_NO')">
                                    <span class="sortable-inner">
                                        <span>공지번호</span>
                                        <span class="sort-icon" data-column="ANN_NO">unfold_more</span>
                                    </span>
                                </th>

                                <th class="sortable-th title-col" onclick="sortNotice('TTL')">
                                    <span class="sortable-inner">
                                        <span>제목</span>
                                        <span class="sort-icon" data-column="TTL">unfold_more</span>
                                    </span>
                                </th>

                                <th class="sortable-th" onclick="sortNotice('WRTR_ID')">
                                    <span class="sortable-inner">
                                        <span>작성자</span>
                                        <span class="sort-icon" data-column="WRTR_ID">unfold_more</span>
                                    </span>
                                </th>

                                <th>첨부파일</th>

                                <th class="sortable-th" onclick="sortNotice('REG_DTTM')">
                                    <span class="sortable-inner">
                                        <span>작성일</span>
                                        <span class="sort-icon" data-column="REG_DTTM">unfold_more</span>
                                    </span>
                                </th>

                                <th class="sortable-th" onclick="sortNotice('INQ_CNT')">
                                    <span class="sortable-inner">
                                        <span>조회수</span>
                                        <span class="sort-icon" data-column="INQ_CNT">unfold_more</span>
                                    </span>
                                </th>

                                <th>관리</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach items="${noticeList}"
                                       var="notice"
                                       varStatus="status">

                                <tr>

                                    <!-- 게시글 번호 DESC 처리 -->
                                    <td>
                                            ${pagingVO.totalRecord
                                                    - ((pagingVO.currentPage - 1) * pagingVO.screenSize)
                                                    - status.index}
                                    </td>

                                    <td>${notice.annNo}</td>

                                    <td class="notice-title-cell title-col">
                                        <c:if test="${notice.topFixYn eq 'Y'}">
                                            <span class="urgent-badge">긴급</span>
                                        </c:if>
                                            ${notice.ttl}
                                    </td>

                                    <td>${notice.wrtrId}</td>

                                    <td>
                                        <c:choose>
                                            <c:when test="${notice.fileCnt > 0}">
                                                <span class="material-symbols-rounded"
                                                      style="font-size:18px;">
                                                    attach_file
                                                </span>
                                            </c:when>

                                            <c:otherwise>-</c:otherwise>
                                        </c:choose>
                                    </td>

                                    <td>
                                        <fmt:formatDate value="${notice.regDttm}"
                                                        pattern="yyyy-MM-dd"/>
                                    </td>

                                    <td>${notice.inqCnt}</td>

                                    <td>
                                        <button type="button"
                                                class="btn btn-write editNoticeBtn"
                                                data-ann-no="${notice.annNo}">
                                            수정
                                        </button>

                                        <form method="post"
                                              action="${pageContext.request.contextPath}/mgmtOffice/notice/delete/${mgmtOfcNo}"
                                              onsubmit="return mgmtOfficeConfirmSubmit(event, { title: '삭제하시겠습니까?', confirmText: '삭제', confirmColor: '#c0392b' });">

                                                <%-- CSRF 보안 토큰 --%>
                                            <input type="hidden"
                                                   name="${_csrf.parameterName}"
                                                   value="${_csrf.token}">

                                                <%-- 삭제할 공지번호 --%>
                                            <input type="hidden"
                                                   name="annNo"
                                                   value="${notice.annNo}">

                                            <button type="submit"
                                                    class="btn btn-delete">
                                                삭제
                                            </button>
                                        </form>
                                    </td>

                                </tr>
                            </c:forEach>
                            <c:if test="${empty noticeList}">
                                <tr class="no-data-row">
                                    <td colspan="8" class="no-data-cell">
                                        조회 결과가 없습니다.
                                    </td>
                                </tr>
                            </c:if>
                            </tbody>
                        </table>
                        <!-- 페이징 영역 -->
                        <div class="notice-pagination-wrap">
                            ${pagingVO.pagingHTML}
                        </div>
                    </div>

                    <!-- 공지사항 등록 모달 -->
                    <div class="notice-modal-overlay" id="noticeModal">
                        <div class="notice-modal">

                            <div class="notice-modal-header">
                                <span>공지사항 등록</span>
                            </div>

                            <form id="noticeForm"
                                  method="post"
                                  enctype="multipart/form-data"
                                  action="${pageContext.request.contextPath}/mgmtOffice/notice/insert/${mgmtOfcNo}">
                                <%-- csrf 보안 --%>
                                <input type="hidden"
                                       name="${_csrf.parameterName}"
                                       value="${_csrf.token}">

                                <input type="hidden" name="annNo" id="modalAnnNo">
                                    <%--
                                        삭제할 기존 첨부파일 번호를 담는 영역

                                        왜 필요?
                                        → 화면에서 이미지를 remove()로 없애도,
                                          서버에는 deleteFileNos 값이 전송되어야 하기 때문.
                                    --%>
                                    <div id="deleteFileNoBox"></div>

                                <div class="notice-modal-body">
                                    <div class="form-field">
                                        <label class="field-label">공지 제목 <span class="req">*</span></label>
                                        <input type="text" name="ttl" id="modalTtl" class="form-input" required>
                                    </div>

                                    <div class="form-field">
                                        <label class="field-label">공지 내용 <span class="req">*</span></label>
                                        <textarea name="cn" id="modalCn" class="form-textarea" required></textarea>
                                    </div>

                                    <div class="form-field">
                                        <label class="field-label">첨부파일</label>

                                        <input type="file"
                                               name="uploadFiles"
                                               id="modalUploadFile"
                                               class="form-input"
                                               multiple>

                                            <!-- 새로 선택한 첨부파일 미리보기 -->
                                            <div id="newFilePreviewBox" style="display:none; margin-top:10px;">
                                                <div style="font-size:12px; font-weight:700; color:#374151; margin-bottom:6px;">
                                                    새로 추가할 첨부파일
                                                </div>

                                                <div id="newFilePreviewList"></div>
                                            </div>

                                        <div id="currentFileBox" style="display:none; margin-top:8px;">
                                            <div style="font-size:12px; font-weight:700; color:#374151; margin-bottom:6px;">
                                                현재 첨부파일
                                            </div>

                                            <div id="currentFileList"></div>
                                        </div>
                                    </div>

                                    <div class="check-row">
                                        <input type="checkbox" name="topFixYn" id="modalTopFixYn" value="Y">
                                        <label for="modalTopFixYn">긴급공지 등록</label>
                                    </div>
                                </div>

                                <div class="notice-modal-footer">
                                    <button type="button" class="btn btn-reset" id="closeNoticeModalBtn">취소</button>
                                    <button type="submit" class="btn btn-search">저장</button>
                                </div>
                            </form>
                        </div>
                    </div>
                    <!-- 처리 결과 알림 모달 -->
                    <div class="notice-result-modal-overlay" id="resultModal">
                        <div class="notice-result-modal">
                            <div class="notice-result-title" id="resultModalTitle">
                                알림
                            </div>

                            <div class="notice-result-message" id="resultModalMessage">
                                ${modalMsg}
                            </div>

                            <div class="notice-result-footer">
                                <button type="button"
                                        class="btn btn-search"
                                        id="closeResultModalBtn">
                                    확인
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<script>

    const currentFileBox = document.getElementById('currentFileBox');
    const modalUploadFile = document.getElementById('modalUploadFile');

    const newFilePreviewBox = document.getElementById('newFilePreviewBox');
    const newFilePreviewList = document.getElementById('newFilePreviewList');

    /*
     * DataTransfer
     * → 사용자가 파일을 여러 번 선택해도 기존 선택 파일을 유지하기 위한 객체
     * 왜 필요?
     * → input type="file"은 다시 선택하면 이전 파일 목록이 사라짐
     */
    let selectedFileStore = new DataTransfer();

    /*
     * 새로 선택한 파일 미리보기 출력
     */
    function renderNewFilePreview() {

        newFilePreviewList.innerHTML = '';

        if (selectedFileStore.files.length === 0) {
            newFilePreviewBox.style.display = 'none';
            return;
        }

        newFilePreviewBox.style.display = 'block';

        Array.from(selectedFileStore.files).forEach(function (file, index) {

            const row = document.createElement('div');
            row.style.display = 'flex';
            row.style.alignItems = 'center';
            row.style.gap = '8px';
            row.style.marginBottom = '8px';

            let previewHtml = '';

            /*
             * 이미지 파일이면 브라우저 임시 URL로 미리보기
             */
            if (file.type && file.type.startsWith('image/')) {
                const imageUrl = URL.createObjectURL(file);

                previewHtml =
                    '<img src="' + imageUrl + '" ' +
                    'style="width:80px; height:80px; object-fit:contain; border:1px solid #d5dbe5; border-radius:6px;">';
            } else {
                previewHtml =
                    '<span class="material-symbols-rounded" style="font-size:20px;">attach_file</span>';
            }

            row.innerHTML =
                previewHtml +
                '<span style="font-size:13px; color:#111827; flex:1;">' + file.name + '</span>' +
                '<button type="button" class="btn btn-reset" style="height:28px; min-width:50px;" data-index="' + index + '">삭제</button>';

            newFilePreviewList.appendChild(row);
        });

        /*
         * 새 파일 개별 삭제
         */
        newFilePreviewList.querySelectorAll('button[data-index]').forEach(function (btn) {
            btn.addEventListener('click', function () {

                const removeIndex = Number(this.dataset.index);
                const newStore = new DataTransfer();

                Array.from(selectedFileStore.files).forEach(function (file, index) {
                    if (index !== removeIndex) {
                        newStore.items.add(file);
                    }
                });

                selectedFileStore = newStore;
                modalUploadFile.files = selectedFileStore.files;

                renderNewFilePreview();
            });
        });
    }

    /*
     * 파일 선택 시
     * 기존 선택 파일에 새 파일을 누적 추가
     */
    modalUploadFile.addEventListener('change', function () {

        Array.from(this.files).forEach(function (file) {
            selectedFileStore.items.add(file);
        });

        modalUploadFile.files = selectedFileStore.files;

        renderNewFilePreview();
    });

    <c:if test="${not empty modalMsg}">
    const resultModal = document.getElementById('resultModal');
    const resultModalTitle = document.getElementById('resultModalTitle');
    const closeResultModalBtn = document.getElementById('closeResultModalBtn');

    /*
     * modalType
     * → success면 성공, fail이면 실패 메시지.
     */
    resultModalTitle.textContent = '${modalType}' === 'success' ? '처리 완료' : '처리 실패';

    resultModal.classList.add('open');

    closeResultModalBtn.addEventListener('click', function () {
        resultModal.classList.remove('open');
    });
    </c:if>

    /*
     * 게시판 정렬
     * 컬럼 클릭 시에만 정렬 파라미터를 붙여서 이동.
     * 새로고침하면 URL에서 정렬 파라미터를 제거해서 기본 정렬로 복귀.
     */
    function sortNotice(column) {
        const url = new URL(window.location.href);

        const currentColumn = url.searchParams.get('sortColumn');
        const currentOrder = url.searchParams.get('sortOrder') || 'DESC';

        let nextOrder = 'DESC';

        /*
         * 같은 컬럼을 다시 클릭하면 ASC / DESC 토글
         */
        if (currentColumn === column) {
            nextOrder = currentOrder === 'ASC' ? 'DESC' : 'ASC';
        }

        url.searchParams.set('sortColumn', column);
        url.searchParams.set('sortOrder', nextOrder);
        url.searchParams.set('currentPage', '1');

        location.href = url.toString();
    }

    /*
     * 새로고침 시 정렬 파라미터 제거
     * performance.navigation.type === 1
     * → 브라우저 새로고침을 의미.
     */
    window.addEventListener('load', function () {
        const navEntry = performance.getEntriesByType('navigation')[0];

        if (navEntry && navEntry.type === 'reload') {
            const url = new URL(window.location.href);

            url.searchParams.delete('sortColumn');
            url.searchParams.delete('sortOrder');
            url.searchParams.set('currentPage', '1');

            location.replace(url.toString());
        }
    });

    /*
  * 현재 정렬 상태 아이콘 표시
  * 기본 정렬(REG_DTTM DESC)은 아이콘 표시 안 함.
  */
    function applySortIcon() {

        const sortColumn = document.getElementById('sortColumn').value;
        const sortOrder = document.getElementById('sortOrder').value;

        document.querySelectorAll('.sort-icon').forEach(function (icon) {

            /*
             * 기본 아이콘
             */
            icon.textContent = 'unfold_more';
            icon.classList.remove('active');

            /*
             * 기본 정렬 상태면 표시 안 함
             * REG_DTTM DESC
             */
            if (sortColumn === 'REG_DTTM' && sortOrder === 'DESC') {
                return;
            }

            /*
             * 현재 정렬 컬럼만 아이콘 활성화
             */
            if (icon.dataset.column === sortColumn) {

                icon.textContent =
                    sortOrder === 'ASC'
                        ? 'arrow_upward'
                        : 'arrow_downward';

                icon.classList.add('active');
            }
        });
    }

    applySortIcon();

    const contextPath = '${pageContext.request.contextPath}';
    const mgmtOfcNo = '${mgmtOfcNo}';

    const modal = document.getElementById('noticeModal');
    const form = document.getElementById('noticeForm');
    const modalAnnNo = document.getElementById('modalAnnNo');
    const modalTtl = document.getElementById('modalTtl');
    const modalCn = document.getElementById('modalCn');
    const modalTopFixYn = document.getElementById('modalTopFixYn');

    const currentFileList = document.getElementById('currentFileList');
    /*
     * 삭제할 기존 첨부파일 번호를 담는 박스
     */
    const deleteFileNoBox = document.getElementById('deleteFileNoBox');

    /*
     * 글쓰기 버튼 클릭
     * -> 등록 모드로 모달 초기화
     */
    document.getElementById('openNoticeModalBtn').addEventListener('click', function () {

        /*
         * 새 파일 선택 목록 초기화
         */
        selectedFileStore = new DataTransfer();
        modalUploadFile.files = selectedFileStore.files;
        renderNewFilePreview();

        /*
         * 삭제 예정 파일번호 초기화
         * 등록 모드에서는 삭제할 기존 파일이 없음
         */
        deleteFileNoBox.innerHTML = '';

        /*
         * form.action
         * -> form 전송 URL 설정
         *
         * insert URL로 지정해서 등록 처리
         */
        form.action = contextPath + '/mgmtOffice/notice/insert/' + mgmtOfcNo;

        /* hidden 공지번호 초기화 */
        modalAnnNo.value = '';

        /* 제목 초기화 */
        modalTtl.value = '';

        /* 내용 초기화 */
        modalCn.value = '';

        /* 긴급공지 체크 해제 */
        modalTopFixYn.checked = false;

        /*
         * 파일 input 초기화
         * -> 기존 선택 파일 제거
         */
        modalUploadFile.value = '';

        /*
         * 첨부파일 삭제 체크 해제
         */
        // deleteAttachYn.checked = false;

        /*
         * 기존 첨부파일 영역 숨김
         * -> 등록 모드에서는 기존 파일 없음
         */
        currentFileBox.style.display = 'none';

        /*
         * 기존 첨부파일 목록 제거
         */
        currentFileList.innerHTML = '';

        /* 모달 열기 */
        modal.classList.add('open');
    });

    document.getElementById('closeNoticeModalBtn').addEventListener('click', function () {
        modal.classList.remove('open');
    });

    document.querySelectorAll('.editNoticeBtn').forEach(function (btn) {
        btn.addEventListener('click', function () {
            const annNo = this.dataset.annNo;

            fetch(contextPath + '/mgmtOffice/notice/detail/' + mgmtOfcNo + '/' + annNo)
                .then(response => response.json())
                .then(data => {
                    /*
                     * 수정 모드 URL
                     */
                    form.action = contextPath + '/mgmtOffice/notice/update/' + mgmtOfcNo;

                    /*
                     * 수정 모달을 새로 열 때마다
                     * 이전에 삭제 선택했던 파일번호 초기화
                     */
                    deleteFileNoBox.innerHTML = '';

                    /*
                     * 공지사항 기본값 세팅
                     */
                    modalAnnNo.value = data.annNo;
                    modalTtl.value = data.ttl;
                    modalCn.value = data.cn;
                    modalTopFixYn.checked = data.topFixYn === 'Y';

                    /*
                     * 파일 input 초기화
                     * 기존 파일명은 보안상 input type="file" 안에 넣을 수 없음
                     */
                    modalUploadFile.value = '';

                    /*
                     * 수정 모드에서 새로 추가할 파일 목록 초기화
                     */
                    selectedFileStore = new DataTransfer();
                    modalUploadFile.files = selectedFileStore.files;
                    renderNewFilePreview();

                    /*
                     * 기존 첨부파일 표시
                     * attachFileList 반복 출력
                     */
                    if (data.attachFileList && data.attachFileList.length > 0) {

                        /*
                         * 첨부파일 영역 표시
                         */
                        currentFileBox.style.display = 'block';

                        /*
                         * 기존 목록 초기화
                         */
                        currentFileList.innerHTML = '';

                        /*
                         * 첨부파일 반복
                         */
                        data.attachFileList.forEach(function (file) {

                            /*
                             * 기존 첨부파일 전체 영역
                             * 파일명 + 삭제버튼 + 미리보기를 하나로 묶음
                             *
                             * 왜 사용?
                             * -> 삭제 시 이미지까지 같이 제거하기 위해
                             */
                            const fileWrapper = document.createElement('div');

                            fileWrapper.style.border = '1px solid #e5e7eb';
                            fileWrapper.style.borderRadius = '8px';
                            fileWrapper.style.padding = '10px';
                            fileWrapper.style.marginBottom = '12px';

                            /*
                             * 상단 파일 정보 영역
                             */
                            const fileRow = document.createElement('div');

                            fileRow.style.display = 'flex';
                            fileRow.style.alignItems = 'center';
                            fileRow.style.gap = '8px';

                            fileRow.innerHTML =

                                /*
                                 * 파일 아이콘
                                 */
                                '<span class="material-symbols-rounded" style="font-size:18px;">attach_file</span>' +

                                /*
                                 * 파일명
                                 */
                                '<span style="font-size:13px; color:#111827; flex:1;">'
                                + file.fileOgName +
                                '</span>' +

                                /*
                                 * 기존 첨부파일 삭제용 hidden
                                 *
                                 * googleId란?
                                 * → 구글드라이브에 저장된 실제 파일 ID.
                                 * 왜 사용?
                                 * → ATTACH_FILE 테이블에 별도 FILE_NO가 없기 때문에,
                                 *   파일 1개를 정확히 삭제하려면 GOOGLE_ID를 기준으로 삭제하는 것이 안전함.
                                 */
                                '<input type="hidden" ' +
                                'name="deleteGoogleIds" ' +
                                'value="' + file.googleId + '" ' +
                                'disabled>' +

                                /*
                                 * 삭제 버튼
                                 */
                                '<button type="button" ' +
                                'class="btn btn-reset btn-old-file-delete" ' +
                                'style="height:32px; min-width:60px;">삭제</button>';

                            /*
                             * wrapper에 추가
                             */
                            fileWrapper.appendChild(fileRow);

                            /*
                             * 이미지 파일이면 미리보기 추가
                             */
                            if (file.mimeType && file.mimeType.startsWith('image/')) {

                                const previewBox = document.createElement('div');

                                previewBox.style.marginTop = '10px';

                                previewBox.innerHTML =
                                    '<img src="' + contextPath + '/file/display/' + file.googleId + '" ' +
                                    'style="width:120px; height:120px; border:1px solid #d5dbe5; border-radius:6px; object-fit:cover; cursor:pointer;">';

                                /*
                                 * 이미지 클릭 시 원본 새창
                                 */
                                previewBox.querySelector('img').addEventListener('click', function () {

                                    window.open(
                                        contextPath + '/file/display/' + file.googleId,
                                        '_blank'
                                    );
                                });

                                fileWrapper.appendChild(previewBox);
                            }

                            /*
 * 삭제 버튼 이벤트
 */
                            fileRow.querySelector('.btn-old-file-delete').addEventListener('click', function () {

                                /*
                                 * 삭제할 파일번호를 서버로 보내기 위한 hidden input 생성
                                 *
                                 * 왜 wrapper 안에 두지 않음?
                                 * → fileWrapper.remove()를 하면 wrapper 안의 hidden도 같이 사라짐.
                                 *   그래서 form 안의 deleteFileNoBox에 따로 보관해야 함.
                                 */
                                const deleteInput = document.createElement('input');

                                deleteInput.type = 'hidden';
                                /*
                                 * 삭제할 기존 파일의 GOOGLE_ID를 서버로 전송
                                 */
                                deleteInput.name = 'deleteGoogleIds';
                                deleteInput.value = file.googleId;

                                /*
                                 * 서버 전송용 hidden input 추가
                                 */
                                deleteFileNoBox.appendChild(deleteInput);

                                /*
                                 * 화면에서도 즉시 이미지 영역 제거
                                 */
                                fileWrapper.remove();

                                /*
                                 * 기존 첨부파일이 모두 사라지면 박스 숨김
                                 */
                                if (currentFileList.children.length === 0) {
                                    currentFileBox.style.display = 'none';
                                }
                            });

                            /*
                             * 최종 추가
                             */
                            currentFileList.appendChild(fileWrapper);
                        });

                    } else {

                        /*
                         * 첨부파일 없으면 숨김
                         */
                        currentFileBox.style.display = 'none';

                        /*
                         * 목록 비우기
                         */
                        currentFileList.innerHTML = '';
                    }

                    /*
                     * 삭제 체크 초기화
                     */
                    //deleteAttachYn.checked = false;

                    /*
                     * 새 파일 선택 초기화
                     */
                    modalUploadFile.value = '';

                    modal.classList.add('open');
                });
        });
    });

    /*
 * 페이징 클릭 처리
 * → PaginationInfoVO의 getPagingHTML()은 data-page 값만 만들어줌.
 * → 클릭하면 currentPage 파라미터를 붙여서 다시 목록 조회.
 */
    document.querySelectorAll('.page-link[data-page]').forEach(function (pageBtn) {
        pageBtn.addEventListener('click', function (event) {
            event.preventDefault();

            const page = this.dataset.page;

            /*
             * 현재 검색조건을 유지한 상태로 currentPage만 변경.
             */
            const url = new URL(window.location.href);
            url.searchParams.set('currentPage', page);

            location.href = url.toString();
        });
    });

    /*
 * 작성일 시작/종료 date input
 */
    const searchStartDt = document.querySelector('input[name="searchStartDt"]');
    const searchEndDt = document.querySelector('input[name="searchEndDt"]');

    /*
     * 시작일 선택 시
     * → 종료일은 시작일 이전 날짜 선택 불가.
     */
    searchStartDt.addEventListener('change', function () {

        /*
         * 종료일 최소 선택 가능 날짜 지정
         */
        searchEndDt.min = this.value;

        /*
         * 이미 선택된 종료일이 시작일보다 이전이면 초기화
         */
        if (searchEndDt.value && searchEndDt.value < this.value) {
            searchEndDt.value = '';
        }
    });

    /*
     * 종료일 선택 시
     * → 시작일보다 이전 날짜면 경고 후 초기화.
     */
    searchEndDt.addEventListener('change', function () {

        if (searchStartDt.value && this.value < searchStartDt.value) {

            alert('작성일 종료는 시작일보다 이전일 수 없습니다.');

            this.value = '';
        }
    });

    /*
     * 페이지 최초 진입 시에도
     * 기존 시작일 기준 min 적용.
     *
     * 예:
     * 검색 후 돌아왔을 때도 유지되게 처리.
     */
    if (searchStartDt.value) {
        searchEndDt.min = searchStartDt.value;
    }
</script>

</body>
</html>