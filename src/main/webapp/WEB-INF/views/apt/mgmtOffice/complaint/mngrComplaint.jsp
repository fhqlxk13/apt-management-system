<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>민원 접수 현황 | 관리사무소</title>
    <sec:csrfMetaTags/>
    <link rel="preconnect" href="https://fonts.googleapis.com"/>
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin/>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/office-layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/manager-common.css">
    <style>
        #cvplTable { table-layout: fixed; width: 100%; }
        #cvplTable th, #cvplTable td {
            text-align: center; vertical-align: middle;
            overflow: hidden; text-overflow: ellipsis; white-space: nowrap;
        }
        #cvplTable .col-no   { width: 60px; }
        #cvplTable .col-date { width: 140px; }
        #cvplTable .col-unit { width: 120px; }
        #cvplTable .col-name { width: 100px; }
        #cvplTable .col-type { width: 100px; }
        #cvplTable .col-stat { width: 120px; }
        #cvplTable .col-done { width: 100px; }
        #cvplTable .col-act  { width: 80px; }
        #cvplTable tbody tr { cursor: pointer; transition: background 0.15s; }
        #cvplTable tbody tr:hover { background: var(--gray-50, #f9fafb); }

        .search-panel .search-row { display: flex; align-items: flex-end; gap: 12px; flex-wrap: wrap; }
        .search-panel .search-field { display: flex; flex-direction: column; gap: 6px; }
        .search-panel .search-field label { font-size: 12px; font-weight: 600; color: var(--text-secondary); letter-spacing: 0.02em; }
        .search-panel .date-range { display: flex; align-items: center; gap: 6px; }
        .search-panel .date-range input { width: 160px; }
        .search-panel .date-sep { font-size: 12px; color: var(--text-tertiary); flex-shrink: 0; }
        .search-panel select.filter-sel { width: 160px; }
        .search-panel .keyword-wrap { flex: 1; min-width: 220px; position: relative; }
        .search-panel .keyword-wrap .material-symbols-rounded {
            position: absolute; left: 10px; top: 50%; transform: translateY(-50%);
            font-size: 16px; color: var(--text-tertiary); pointer-events: none;
        }
        .search-panel .keyword-wrap input { width: 100%; padding-left: 34px; box-sizing: border-box; }
        .search-panel .search-actions { display: flex; gap: 8px; flex-shrink: 0; }
        .search-panel .search-divider {
            width: 1px; height: 32px; background: var(--border);
            flex-shrink: 0; align-self: flex-end; margin: 0 2px;
        }

        #cvplDetailModal .detail-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; }
        #cvplDetailModal .detail-grid .full { grid-column: span 2; }
        #cvplDetailModal .history-box {
            background: var(--gray-100); border: 1px solid var(--border);
            border-radius: var(--r-sm); padding: 12px 14px;
            font-size: 13px; line-height: 1.7; color: var(--text-secondary); min-height: 60px;
        }

        #processingNotice {
            background: var(--gray-100); border: 1px solid var(--border);
            border-radius: var(--r-sm); padding: 10px 14px;
            font-size: 13px; color: var(--text-secondary);
        }
    </style>
</head>
<body>
<div class="app-wrapper">
    <%@ include file="/WEB-INF/views/include/office_sidebar.jsp" %>

    <div class="main-wrap">
        <%@ include file="/WEB-INF/views/include/office_header.jsp" %>

        <main class="main-content">
            <div class="office-page" id="complaintPage">

                <div class="page-header">
                    <div class="page-title-block">
                        <h2>민원 관리</h2>
                        <p>입주민이 접수한 민원을 조회하고 처리 상태를 관리합니다.</p>
                    </div>
                </div>

                <div class="panel search-panel">
                    <div class="panel-body">
                        <div class="search-row">
                            <div class="search-field">
                                <label>접수 기간</label>
                                <div class="date-range">
                                    <input type="date" class="form-input" id="filterDateFrom">
                                    <span class="date-sep">~</span>
                                    <input type="date" class="form-input" id="filterDateTo">
                                </div>
                            </div>
                            <div class="search-divider"></div>
                            <div class="search-field">
                                <label>민원 유형</label>
                                <select class="form-select filter-sel" id="filterType">
                                    <option value="">전체</option>
                                    <option value="FAC">시설/하자</option>
                                    <option value="SEC">보안/안전</option>
                                    <option value="ACC">회계/관리비</option>
                                    <option value="ENV">환경/위생</option>
                                    <option value="ETC">기타</option>
                                </select>
                            </div>
                            <div class="search-field">
                                <label>처리 상태</label>
                                <select class="form-select filter-sel" id="filterStatus">
                                    <option value="">전체</option>
                                    <option value="APLY">민원 접수</option>
                                    <option value="RCPT">접수 완료</option>
                                    <option value="POCS">처리중</option>
                                    <option value="SUPL">보완 요청</option>
                                    <option value="REJS">처리 불가</option>
                                    <option value="COMP">처리 완료</option>
                                    <option value="RJCT">반려</option>
                                    <option value="END">종결</option>
                                </select>
                            </div>
                            <div class="search-divider"></div>
                            <div class="search-field">
                                <label>미처리 민원</label>
                                <div style="display:flex; align-items:center; height:32px;">
                                    <label style="display:flex; align-items:center; gap:6px; font-size:13px; cursor:pointer;">
                                        <input type="checkbox" id="filterUnhandled">미처리만 보기
                                    </label>
                                </div>
                            </div>
                            <div class="search-divider"></div>
                            <div class="search-field" style="flex:1; min-width:150px;">
                                <label>검색어</label>
                                <div class="keyword-wrap">
                                    <span class="material-symbols-rounded">search</span>
                                    <input type="text" class="form-input" id="filterKeyword" placeholder="동/호수, 신고자명, 민원 제목">
                                </div>
                            </div>
                            <div class="search-actions">
                                <button type="button" class="btn btn-primary"   id="btnSearch">검색</button>
                                <button type="button" class="btn btn-secondary" id="btnReset">초기화</button>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="panel">
                    <div class="panel-header">
                        <div class="list-header-left">
                            <h3 class="panel-title">
                                <span class="material-symbols-rounded">format_list_bulleted</span>민원 목록
                            </h3>
                            <span class="list-count" id="cvplListCount">0건</span>
                        </div>
                    </div>
                    <div class="table-wrap">
                        <table class="tbl" id="cvplTable">
                            <colgroup>
                                <col class="col-no"><col class="col-date"><col class="col-unit">
                                <col class="col-name"><col class="col-type"><col class="col-title">
                                <col class="col-stat"><col class="col-done"><col class="col-act">
                            </colgroup>
                            <thead>
                            <tr>
                                <th>번호</th><th>접수일시</th><th>동/호</th><th>신고자</th>
                                <th>유형</th><th style="text-align:left;">민원 제목</th>
                                <th>상태</th><th>처리일</th><th>관리</th>
                            </tr>
                            </thead>
                            <tbody id="cvplTableBody"></tbody>
                        </table>
                    </div>
                    <div class="pagination">
                        <span class="pagination-info" id="pageInfo"></span>
                        <div class="pagination-btns" id="pageBtns"></div>
                    </div>
                </div>

            </div>

            <!-- 민원 상세 모달 -->
            <div class="modal-overlay" id="cvplDetailModal">
                <div class="modal modal-lg">
                    <div class="modal-header primary">
                        <h3 class="modal-title" id="detailModalTitle">민원 상세</h3>
                        <button type="button" class="modal-close" id="btnCloseDetail">
                            <span class="material-symbols-rounded">close</span>
                        </button>
                    </div>
                    <div class="modal-body">

                        <!-- 기본 정보 -->
                        <div class="form-section">
                            <div class="form-section-title">
                                <span class="material-symbols-rounded">info</span>기본 정보
                            </div>
                            <div class="detail-grid">
                                <div class="mngr-detail-item">
                                    <div class="mngr-detail-label">민원번호</div>
                                    <div class="mngr-detail-value" id="dNo">-</div>
                                </div>
                                <div class="mngr-detail-item">
                                    <div class="mngr-detail-label">접수일시</div>
                                    <div class="mngr-detail-value" id="dDate">-</div>
                                </div>
                                <div class="mngr-detail-item">
                                    <div class="mngr-detail-label">신고자 (세대)</div>
                                    <div class="mngr-detail-value" id="dReporter">-</div>
                                </div>
                                <div class="mngr-detail-item">
                                    <div class="mngr-detail-label">민원 유형</div>
                                    <div class="mngr-detail-value" id="dType">-</div>
                                </div>
                                <div class="mngr-detail-item full">
                                    <div class="mngr-detail-label">현재 상태</div>
                                    <div class="mngr-detail-value" id="dStatus">-</div>
                                </div>
                            </div>
                        </div>

                        <!-- 민원 내용 -->
                        <div class="form-section">
                            <div class="form-section-title">
                                <span class="material-symbols-rounded">description</span>민원 내용
                            </div>
                            <div class="form-field" style="margin-bottom:10px;">
                                <label class="field-label">제목</label>
                                <div class="history-box" id="dTitle">-</div>
                            </div>
                            <div class="form-field">
                                <label class="field-label">상세 내용</label>
                                <div class="history-box" id="dContent" style="min-height:90px; white-space:pre-wrap;">-</div>
                            </div>
                        </div>

                        <!-- 첨부파일 -->
                        <div class="form-section" id="fileSection" style="display:none;">
                            <div class="form-section-title">
                                <span class="material-symbols-rounded">attach_file</span>첨부파일
                            </div>
                            <ul id="dFileList" style="padding:0; margin:0; list-style:none;"></ul>
                        </div>

                        <!-- 처리 내역 -->
                        <div class="form-section">
                            <div class="form-section-title">
                                <span class="material-symbols-rounded">engineering</span>처리 내역
                            </div>
                            <div class="form-field" style="margin-bottom:10px;">
                                <label class="field-label">처리 메모 / 반려 사유</label>
                                <div class="history-box" id="dAnswer" style="min-height:70px; white-space:pre-wrap;">-</div>
                            </div>
                            <div id="processingNotice" style="display:none;">
                                <span class="material-symbols-rounded" style="font-size:16px; vertical-align:middle; margin-right:4px;">lock</span>
                                현재 상태에서는 승인/반려 처리를 할 수 없습니다.
                            </div>
                        </div>

                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-primary"   id="btnApproveDetail">
                            <span class="material-symbols-rounded">check_circle</span>승인
                        </button>
                        <button type="button" class="btn btn-danger"    id="btnRejectDetail">
                            <span class="material-symbols-rounded">cancel</span>반려
                        </button>
                        <button type="button" class="btn btn-secondary" id="btnCloseDetail2">닫기</button>
                    </div>
                </div>
            </div>

        </main>
    </div>
</div>

<script>
    function showAlert(message, icon) {
        return Swal.fire({ text: message, icon: icon || 'info', confirmButtonText: '확인' });
    }

    function showPrompt({ title, text, inputPlaceholder, confirmText, confirmColor, required, requiredMessage }) {
        return Swal.fire({
            title: title,
            text: text,
            input: 'text',
            inputPlaceholder: inputPlaceholder || '',
            showCancelButton: true,
            confirmButtonText: confirmText || '확인',
            confirmButtonColor: confirmColor || '#3085d6',
            cancelButtonText: '취소',
            preConfirm: (value) => {
                if (required && !value.trim()) {
                    Swal.showValidationMessage(requiredMessage || '입력이 필요합니다.');
                    return false;
                }
                return value;
            }
        });
    }

    (function () {
        'use strict';

        /* ══════════════════════════════════════
           1. 상수
        ══════════════════════════════════════ */
        var MGMT_OFC_NO = '${mgmtOfcNo}';
        var CTX = '${pageContext.request.contextPath}' || '';

        var TYPE_TEXT  = { FAC:'시설/하자', SEC:'보안/안전', ACC:'회계/관리비', ENV:'환경/위생', ETC:'기타' };
        var TYPE_BADGE = { FAC:'badge-green', SEC:'badge-red', ACC:'badge-blue', ENV:'badge-orange', ETC:'badge-gray' };
        var STAT_TEXT  = {
            APLY:'민원 접수', RCPT:'접수 완료', POCS:'처리중',
            SUPL:'보완 요청', REJS:'처리 불가', COMP:'처리 완료',
            RJCT:'반려',      END:'종결', CNCL:'취소'
        };
        var STAT_BADGE = {
            APLY:'badge-yellow', RCPT:'badge-blue',  POCS:'badge-blue',
            SUPL:'badge-orange', REJS:'badge-gray',  COMP:'badge-green',
            RJCT:'badge-gray',   END:'badge-green', CNCL:'badge-gray'
        };

        /* 승인 시 변경될 다음 상태 (null 이면 승인 버튼 숨김) */
        var NEXT_STATUS = {
            APLY: 'RCPT',
            RCPT: 'POCS',
            POCS: 'COMP',
            SUPL: null,
            REJS: null,
            COMP: null,
            RJCT: null,
            END:  null,
            CNCL: null
        };

        /* 종결 상태 — 승인·반려 불가 */
        var TERMINAL_STATUS = { RJCT: 1, COMP: 1, END: 1, CNCL: 1, REJS: 1 };

        function findComplaint(cvplNo) {
            var key = String(cvplNo == null ? '' : cvplNo);
            for (var i = 0; i < cachedList.length; i++) {
                if (String(cachedList[i].cvplNo) === key) return cachedList[i];
            }
            return null;
        }

        function canApproveStatus(code) {
            return !!NEXT_STATUS[code];
        }

        function canRejectStatus(code) {
            return code && !TERMINAL_STATUS[code];
        }

        function updateDetailActionButtons(sttsCd) {
            var canApp = canApproveStatus(sttsCd);
            var canRej = canRejectStatus(sttsCd);
            if (!canApp && !canRej) {
                $processingNotice.style.display = 'block';
                $btnApproveDetail.style.display = 'none';
                $btnRejectDetail.style.display  = 'none';
            } else {
                $processingNotice.style.display = 'none';
                $btnApproveDetail.style.display = canApp ? 'inline-flex' : 'none';
                $btnRejectDetail.style.display  = canRej ? 'inline-flex' : 'none';
            }
        }

        /* ══════════════════════════════════════
           2. DOM 참조
        ══════════════════════════════════════ */
        var $tbody            = document.getElementById('cvplTableBody');
        var $listCount        = document.getElementById('cvplListCount');
        var $pageInfo         = document.getElementById('pageInfo');
        var $pageBtns         = document.getElementById('pageBtns');
        var $detailModal      = document.getElementById('cvplDetailModal');
        var $filterDateFrom   = document.getElementById('filterDateFrom');
        var $filterDateTo     = document.getElementById('filterDateTo');
        var $filterType       = document.getElementById('filterType');
        var $filterStatus     = document.getElementById('filterStatus');
        var $filterKeyword    = document.getElementById('filterKeyword');
        var $filterUnhandled  = document.getElementById('filterUnhandled');
        var $dNo              = document.getElementById('dNo');
        var $dDate            = document.getElementById('dDate');
        var $dReporter        = document.getElementById('dReporter');
        var $dType            = document.getElementById('dType');
        var $dStatus          = document.getElementById('dStatus');
        var $dTitle           = document.getElementById('dTitle');
        var $dContent         = document.getElementById('dContent');
        var $dAnswer         = document.getElementById('dAnswer');
        var $processingNotice = document.getElementById('processingNotice');
        var $btnApproveDetail = document.getElementById('btnApproveDetail');
        var $btnRejectDetail  = document.getElementById('btnRejectDetail');

        /* ══════════════════════════════════════
           3. 상태 변수
        ══════════════════════════════════════ */
        var currentPage = 1;
        var totalRecord = 0;
        var cachedList  = [];

        /* ══════════════════════════════════════
           4. 유틸 함수
        ══════════════════════════════════════ */
        function safe(val) { return val != null ? val : '-'; }

        function typeBadge(code) {
            return '<span class="badge ' + (TYPE_BADGE[code] || 'badge-gray') + '">'
                + (TYPE_TEXT[code] || code || '-') + '</span>';
        }

        function statBadge(code) {
            return '<span class="badge ' + (STAT_BADGE[code] || 'badge-gray') + '">'
                + (STAT_TEXT[code] || code || '-') + '</span>';
        }

        /* ══════════════════════════════════════
           5. API 호출
        ══════════════════════════════════════ */
        async function fetchList(page) {
            currentPage = page || 1;
            const cvplSttsCd = $filterUnhandled.checked ? 'UNHANDLED' : $filterStatus.value;
            const params = new URLSearchParams({
                curPage:        currentPage,
                cvplTyCd:       $filterType.value,
                cvplSttsCd:     cvplSttsCd,
                keyword:        $filterKeyword.value.trim(),
                searchDateFrom: $filterDateFrom.value,
                searchDateTo:   $filterDateTo.value
            });

            try {
                const res  = await fetch(CTX + '/manager/complex/complaintList/' + MGMT_OFC_NO + '?' + params);
                if (!res.ok) throw new Error('서버 오류: ' + res.status);
                const data = await res.json();
                cachedList  = data.list  || [];
                totalRecord = data.page.totalRecord || 0;
                renderTable(cachedList, data.page);
            } catch (err) {
                console.error('[fetchList] 실패:', err);
                $tbody.innerHTML = '<tr><td colspan="9" style="padding:34px 12px; color:var(--text-tertiary);">데이터를 불러오지 못했습니다.</td></tr>';
            }
        }

        async function saveComplaint(payload) {
            const csrfToken  = document.querySelector('meta[name="_csrf"]').getAttribute('content');
            const csrfHeader = document.querySelector('meta[name="_csrf_header"]').getAttribute('content');
            const res = await fetch(CTX + '/manager/complex/updateComplaint/' + MGMT_OFC_NO, {
                method:  'POST',
                headers: { 'Content-Type': 'application/json', [csrfHeader]: csrfToken },
                body:    JSON.stringify(payload)
            });
            if (!res.ok) throw new Error('서버 오류: ' + res.status);
            return res.json();
        }

        /* ══════════════════════════════════════
           6. 렌더링
        ══════════════════════════════════════ */
        function renderTable(list, pageVO) {
            var total    = pageVO.totalRecord || 0;
            var startRow = pageVO.startRow    || 1;
            var endRow   = Math.min(pageVO.endRow || 0, total);

            $listCount.textContent = total + '건';
            $pageInfo.textContent  = total === 0 ? '0건' : startRow + '–' + endRow + ' / ' + total + '건';

            if (!list || list.length === 0) {
                $tbody.innerHTML = '<tr><td colspan="9" style="padding:34px 12px; color:var(--text-tertiary);">조건에 맞는 민원이 없습니다.</td></tr>';
                renderPager(pageVO);
                return;
            }

            $tbody.innerHTML = list.map((row, i) => {
                const dongHo = ((row.dongNm || '') + '동 ' + (row.ho || '') + '호').trim();
                return '<tr data-cvpl-no="' + row.cvplNo + '">'
                    + '<td>' + (startRow + i) + '</td>'
                    + '<td class="td-mono">' + safe(row.cvplRegDt) + '</td>'
                    + '<td>' + dongHo + '</td>'
                    + '<td>' + safe(row.userNm) + '</td>'
                    + '<td>' + typeBadge(row.cvplTyCd) + '</td>'
                    + '<td style="text-align:left;" title="' + safe(row.cvplTtl) + '">' + safe(row.cvplTtl) + '</td>'
                    + '<td>' + statBadge(row.cvplSttsCd) + '</td>'
                    + '<td class="td-mono">' + safe(row.cvplEndDt) + '</td>'
                    + '<td><button type="button" class="btn btn-xs" data-cvpl-no="' + row.cvplNo + '">상세</button></td>'
                    + '</tr>';
            }).join('');

            renderPager(pageVO);
        }

        function renderPager(pageVO) {
            var startPage = pageVO.startPage || 1;
            var endPage   = pageVO.endPage   || 1;
            var totalPage = pageVO.totalPage || 1;

            var html = '<button type="button" class="page-btn" data-page="prev">'
                + '<span class="material-symbols-rounded">chevron_left</span></button>';

            for (var p = startPage; p <= endPage; p++) {
                html += '<button type="button" class="page-btn' + (p === currentPage ? ' active' : '')
                    + '" data-page="' + p + '">' + p + '</button>';
            }

            if (endPage < totalPage) {
                html += '<button type="button" class="page-btn" disabled>'
                    + '<span class="material-symbols-rounded">more_horiz</span></button>';
            }

            html += '<button type="button" class="page-btn" data-page="next">'
                + '<span class="material-symbols-rounded">chevron_right</span></button>';

            $pageBtns.innerHTML = html;
        }

        /* ══════════════════════════════════════
           7. 모달
        ══════════════════════════════════════ */
        async function openDetail(cvplNo) {
            const row = findComplaint(cvplNo);
            if (!row) return;

            const dongHo = ((row.dongNm || '') + '동 ' + (row.ho || '') + '호').trim();

            document.getElementById('detailModalTitle').textContent = '민원 상세 — ' + row.cvplNo;
            $dNo.textContent       = safe(row.cvplNo);
            $dDate.textContent     = safe(row.cvplRegDt);
            $dReporter.textContent = safe(row.userNm) + ' (' + dongHo + ')';
            $dType.textContent     = TYPE_TEXT[row.cvplTyCd] || safe(row.cvplTyCd);
            $dStatus.innerHTML     = statBadge(row.cvplSttsCd);
            $dTitle.textContent    = safe(row.cvplTtl);
            $dContent.textContent  = safe(row.cvplCn);
            $dAnswer.textContent   = safe(row.cvplAns);

            updateDetailActionButtons(row.cvplSttsCd);

            /* 첨부파일 조회 */
            const $fileSection = document.getElementById('fileSection');
            const $dFileList   = document.getElementById('dFileList');
            $fileSection.style.setProperty('display', 'none', 'important');
            $dFileList.innerHTML = '';

            if (row.cvplFileNo) {
                try {
                    const res   = await fetch(CTX + '/manager/complex/cvplFileList/' + MGMT_OFC_NO + '?cvplFileNo=' + row.cvplFileNo);
                    if (!res.ok) throw new Error('서버 오류: ' + res.status);
                    const files = await res.json();
                    if (files.length > 0) {
                        $dFileList.innerHTML = files.map(f => {
                            const isImage  = f.MIME_TYPE && f.MIME_TYPE.startsWith('image/');
                            const googleId = f.GOOGLE_ID || '';
                            if (isImage) {
                                return '<li style="padding:6px 0; border-bottom:1px solid var(--border);">'
                                    + '<img src="/file/display/' + googleId + '" alt="' + (f.FILE_OG_NAME || '') + '" '
                                    + 'style="max-width:100%; max-height:200px; border-radius:8px; object-fit:contain; display:block;">'
                                    + '<span style="font-size:12px; color:var(--text-tertiary);">'
                                    + (f.FILE_OG_NAME || '-') + ' (' + Math.round((f.FILE_SIZE || 0) / 1024) + 'KB)</span>'
                                    + '</li>';
                            } else {
                                return '<li style="padding:6px 0; border-bottom:1px solid var(--border); font-size:13px;">'
                                    + '<a href="/file/download/' + googleId + '" '
                                    + 'style="display:inline-flex; align-items:center; gap:6px; text-decoration:none; color:var(--text-secondary);">'
                                    + '<span class="material-symbols-rounded" style="font-size:16px;">attach_file</span>'
                                    + (f.FILE_OG_NAME || '-') + ' (' + Math.round((f.FILE_SIZE || 0) / 1024) + 'KB)'
                                    + '</a></li>';
                            }
                        }).join('');
                        $fileSection.style.setProperty('display', 'block', 'important');
                    }
                } catch (err) {
                    console.error('[fileList] 실패:', err);
                }
            }

            $detailModal.dataset.currentNo = cvplNo;
            $detailModal.classList.add('open');
        }

        function closeDetail() {
            $detailModal.classList.remove('open');
            $detailModal.dataset.currentNo = '';
            $processingNotice.style.display = 'none';
        }

        /* ══════════════════════════════════════
           8. 이벤트 바인딩
        ══════════════════════════════════════ */
        document.getElementById('btnSearch').addEventListener('click', () => fetchList(1));
        $filterKeyword.addEventListener('keydown', e => { if (e.key === 'Enter') fetchList(1); });

        document.getElementById('btnReset').addEventListener('click', () => {
            $filterDateFrom.value    = '';
            $filterDateTo.value      = '';
            $filterType.value        = '';
            $filterStatus.value      = '';
            $filterKeyword.value     = '';
            $filterUnhandled.checked = false;
            $filterStatus.disabled   = false;
            fetchList(1);
        });

        $filterUnhandled.addEventListener('change', function () {
            $filterStatus.disabled = this.checked;
            if (this.checked) $filterStatus.value = '';
        });

        $tbody.addEventListener('click', e => {
            const btn = e.target.closest('[data-cvpl-no]');
            if (btn) openDetail(btn.dataset.cvplNo);
        });

        $pageBtns.addEventListener('click', e => {
            const btn = e.target.closest('[data-page]');
            if (!btn || btn.disabled) return;
            const p         = btn.dataset.page;
            const totalPage = Math.ceil(totalRecord / 10) || 1;
            if      (p === 'prev') currentPage = Math.max(1, currentPage - 1);
            else if (p === 'next') currentPage = Math.min(totalPage, currentPage + 1);
            else                   currentPage = Number(p);
            fetchList(currentPage);
        });

        document.getElementById('btnCloseDetail').addEventListener('click',  closeDetail);
        document.getElementById('btnCloseDetail2').addEventListener('click', closeDetail);
        $detailModal.addEventListener('click', e => {
            if (document.body.classList.contains('swal2-shown')) return;
            if (e.target === $detailModal) closeDetail();
        });

        /* 승인 처리 */
        $btnApproveDetail.addEventListener('click', async () => {
            const cvplNo = $detailModal.dataset.currentNo;
            if (!cvplNo) return;

            const row       = findComplaint(cvplNo);
            const nextStts  = row ? NEXT_STATUS[row.cvplSttsCd] : null;
            if (!row || !nextStts) {
                await showAlert('현재 상태에서는 승인할 수 없습니다.', 'warning');
                return;
            }

            const memoResult = await showPrompt({
                title: '민원 승인',
                text: '처리 메모를 입력하세요. (선택사항)',
                inputPlaceholder: '메모 입력 (선택)',
                confirmText: '승인'
            });
            if (!memoResult.isConfirmed) return;

            const memo = (memoResult.value || '').trim();

            try {
                const data = await saveComplaint({ cvplNo, cvplSttsCd: nextStts, cvplAns: memo });
                if (data.success) {
                    await showAlert('승인 처리되었습니다.', 'success');
                    closeDetail();
                    fetchList(currentPage);
                } else {
                    await showAlert('승인 처리 실패: ' + (data.message || ''), 'error');
                }
            } catch (err) {
                console.error('[approveDetail] 오류:', err);
                await showAlert('승인 처리 중 오류가 발생했습니다.', 'error');
            }
        });

        /* 반려 처리 */
        $btnRejectDetail.addEventListener('click', async () => {
            const cvplNo = $detailModal.dataset.currentNo;
            if (!cvplNo) return;

            const row = findComplaint(cvplNo);
            if (!row || !canRejectStatus(row.cvplSttsCd)) {
                await showAlert('현재 상태에서는 반려할 수 없습니다.', 'warning');
                return;
            }

            const reasonResult = await showPrompt({
                title: '민원 반려',
                text: '반려 사유를 입력해 주세요.',
                inputPlaceholder: '반려 사유',
                confirmText: '반려',
                confirmColor: '#c0392b',
                required: true,
                requiredMessage: '반려 사유를 입력해야 합니다.'
            });
            if (!reasonResult.isConfirmed) return;

            const reason = String(reasonResult.value || '').trim();

            try {
                const data = await saveComplaint({ cvplNo, cvplSttsCd: 'RJCT', cvplAns: reason });
                if (data.success) {
                    await showAlert('반려 처리되었습니다.', 'success');
                    closeDetail();
                    fetchList(currentPage);
                } else {
                    await showAlert('반려 처리 실패: ' + (data.message || ''), 'error');
                }
            } catch (err) {
                console.error('[rejectDetail] 오류:', err);
                await showAlert('반려 처리 중 오류가 발생했습니다.', 'error');
            }
        });

        /* ══════════════════════════════════════
           9. 초기 로드
        ══════════════════════════════════════ */
        fetchList(1);

    })();
</script>
</body>
</html>
