<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">

    <title>고지서 조회</title>

    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet" />

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/office-layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/manager-common.css">

    <style>
        /*
         * 조회 조건 검색영역
         * - 조건별 묶음(filter-group) 사이에는 넉넉한 여백
         * - 라벨과 입력창 사이는 가깝게 유지
         */
        .issue-page .issue-form-row {
            display: flex;
            flex-wrap: wrap;
            align-items: center;
            column-gap: 24px;
            row-gap: 14px;
        }

        .issue-page .filter-group {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            flex-shrink: 0;
        }

        .issue-page .filter-actions {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            margin-left: 4px;
        }

        .issue-page .issue-form-row label {
            font-weight: 700;
            color: var(--text-primary);
            white-space: nowrap;
        }

        .issue-page input,
        .issue-page select {
            height: 36px;
            border: 1px solid var(--border);
            border-radius: var(--r-sm);
            padding: 0 10px;
            font-family: inherit;
            font-size: 13px;
            background: #fff;
        }

        .issue-page input[type="number"] {
            width: 120px;
        }

        .issue-page input[type="text"] {
            width: 140px;
        }

        .issue-page input:disabled {
            background: #f3f4f6;
            color: #9ca3af;
            cursor: not-allowed;
        }

        .issue-summary-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 14px;
            margin-bottom: 20px;
        }

        .issue-summary-card {
            background: #fff;
            border: 1px solid var(--border);
            border-radius: var(--r-md);
            padding: 16px 18px;
        }

        .issue-summary-label {
            font-size: 12px;
            color: var(--text-tertiary);
            font-weight: 700;
            margin-bottom: 8px;
        }

        .issue-summary-value {
            font-size: 24px;
            font-weight: 800;
            color: var(--text-primary);
            line-height: 1.2;
        }

        .text-right {
            text-align: right;
        }

        .empty {
            color: var(--text-tertiary);
            padding: 30px;
            text-align: center;
        }

        .td-bold {
            font-weight: 800;
        }

        .status-badge {
            display: inline-flex;
            align-items: center;
            padding: 3px 9px;
            border-radius: 4px;
            font-size: 11px;
            font-weight: 800;
            border: 1px solid var(--border);
            background: #f3f4f6;
        }

        .status-ready {
            background: #eff6ff;
            color: #1d4ed8;
            border-color: #bfdbfe;
        }

        .status-paid {
            background: #f0fdf4;
            color: #166534;
            border-color: #bbf7d0;
        }

        .status-unpaid {
            background: #fffbeb;
            color: #92400e;
            border-color: #fde68a;
        }

        .status-overdue {
            background: #fef2f2;
            color: #991b1b;
            border-color: #fecaca;
        }

        .pagination {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
            padding: 16px 20px;
            border-top: 1px solid var(--border);
            background: #fff;
        }

        .pagination-info {
            font-size: 13px;
            color: var(--text-secondary);
            font-weight: 600;
        }

        #pagingArea ul.pagination {
            display: flex;
            align-items: center;
            justify-content: flex-end;
            gap: 4px;
            padding: 0;
            margin: 0;
            border-top: 0;
            background: transparent;
            list-style: none;
        }

        #pagingArea .page-item {
            list-style: none;
        }

        #pagingArea .page-link {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-width: 32px;
            height: 32px;
            padding: 0 10px;
            border: 1px solid var(--border);
            border-radius: 6px;
            background: #fff;
            color: var(--text-secondary);
            font-size: 13px;
            font-weight: 700;
            text-decoration: none;
            cursor: pointer;
        }

        #pagingArea .page-item.active .page-link,
        #pagingArea .page-item.active span.page-link {
            background: #166534;
            border-color: #166534;
            color: #fff;
        }

        #pagingArea .page-item.disabled .page-link {
            color: #9ca3af;
            cursor: default;
        }

        .detail-total {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 14px;
            padding-top: 14px;
            border-top: 1px solid var(--border);
            font-size: 16px;
            font-weight: 800;
        }

        .detail-info-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 10px;
            margin-bottom: 16px;
        }

        .detail-info-item {
            border: 1px solid var(--border);
            border-radius: var(--r-sm);
            padding: 10px 12px;
            background: #f8fafc;
        }

        .detail-info-label {
            font-size: 11px;
            color: var(--text-tertiary);
            margin-bottom: 4px;
        }

        .detail-info-value {
            font-size: 13px;
            font-weight: 700;
            color: var(--text-primary);
        }

        @media (max-width: 1280px) {
            .issue-summary-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        @media (max-width: 768px) {
            .issue-summary-grid,
            .detail-info-grid {
                grid-template-columns: 1fr;
            }

            .pagination {
                flex-direction: column;
                align-items: flex-start;
            }
        }
    </style>
</head>

<body>
<div class="app-wrapper">

    <%@ include file="/WEB-INF/views/include/office_sidebar.jsp" %>

    <div class="main-wrap">

        <%@ include file="/WEB-INF/views/include/office_header.jsp" %>

        <main class="main-content">
            <div class="office-page issue-page">

                <div class="page-header">
                    <div class="page-title-block">
                        <h2>고지서 조회</h2>
                        <p>부과 완료된 관리비 고지서를 세대별로 조회합니다.</p>
                    </div>
                </div>

                <!-- 조회 조건 -->
                <div class="panel">
                    <div class="panel-header">
                        <h3 class="panel-title">
                            <span class="material-symbols-rounded">search</span>
                            조회 조건
                        </h3>
                    </div>

                    <div class="panel-body">
                        <div class="issue-form-row">
                            <div class="filter-group">
                                <label for="searchYear">관리연도</label>
                                <input type="number" id="searchYear">
                            </div>

                            <div class="filter-group">
                                <label for="searchMonth">관리월</label>
                                <select id="searchMonth">
                                    <option value="">전체</option>
                                    <option value="1">1월</option>
                                    <option value="2">2월</option>
                                    <option value="3">3월</option>
                                    <option value="4">4월</option>
                                    <option value="5">5월</option>
                                    <option value="6">6월</option>
                                    <option value="7">7월</option>
                                    <option value="8">8월</option>
                                    <option value="9">9월</option>
                                    <option value="10">10월</option>
                                    <option value="11">11월</option>
                                    <option value="12">12월</option>
                                </select>
                            </div>

                            <div class="filter-group">
                                <label for="pymtSttsCd">납부상태</label>
                                <select id="pymtSttsCd">
                                    <option value="">전체</option>
                                    <option value="READY">고지완료</option>
                                    <option value="PAID">납부완료</option>
                                    <option value="UNPAID">미납</option>
                                    <option value="OVERDUE">연체</option>
                                </select>
                            </div>

                            <div class="filter-group">
                                <label for="dongNo">동</label>
                                <select id="dongNo" onchange="onDongChange()">
                                    <option value="">전체</option>
                                </select>
                            </div>

                            <div class="filter-group">
                                <label for="ho">호수</label>
                                <input type="text" id="ho" placeholder="동 선택 후 입력" disabled>
                            </div>

                            <div class="filter-actions">
                                <button type="button" class="btn btn-primary" onclick="loadBillIssueList(1)">
                                    <span class="material-symbols-rounded">search</span>
                                    조회
                                </button>

                                <button type="button" class="btn btn-secondary" onclick="resetSearch()">
                                    초기화
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 요약 -->
                <div class="issue-summary-grid">
                    <div class="issue-summary-card">
                        <div class="issue-summary-label">조회 건수</div>
                        <div class="issue-summary-value" id="summaryTotalCount">0건</div>
                    </div>

                    <div class="issue-summary-card">
                        <div class="issue-summary-label">현재 페이지 총액</div>
                        <div class="issue-summary-value" id="summaryTotalAmount">0원</div>
                    </div>

                    <div class="issue-summary-card">
                        <div class="issue-summary-label">현재 관리월</div>
                        <div class="issue-summary-value" id="summaryBillYm">-</div>
                    </div>
                </div>

                <!-- 목록 -->
                <div class="panel">
                    <div class="panel-header">
                        <h3 class="panel-title">
                            <span class="material-symbols-rounded">receipt_long</span>
                            고지서 목록
                        </h3>
                    </div>

                    <div class="table-wrap">
                        <table class="tbl">
                            <thead>
                            <tr>
                                <th>관리년월</th>
                                <th>동/호수</th>
                                <th class="text-right">관리비 총액</th>
                                <th>납부기한</th>
                                <th>납부상태</th>
                                <th>고지일자</th>
                                <th>관리</th>
                            </tr>
                            </thead>
                            <tbody id="billIssueTbody">
                            <tr>
                                <td colspan="7" class="empty">조회된 고지서가 없습니다.</td>
                            </tr>
                            </tbody>
                        </table>
                    </div>

                    <div class="pagination">
                        <div class="pagination-info" id="paginationInfo">
                            총 0건
                        </div>
                        <div id="pagingArea"></div>
                    </div>
                </div>

            </div>
        </main>
    </div>
</div>

<!-- 상세 모달 -->
<div class="modal-overlay" id="billDetailModal">
    <div class="modal modal-lg">
        <div class="modal-header primary">
            <h3 class="modal-title">관리비 고지서 상세</h3>
            <button type="button" class="modal-close" onclick="closeDetailModal()">
                <span class="material-symbols-rounded">close</span>
            </button>
        </div>

        <div class="modal-body">

            <div class="detail-info-grid">
                <div class="detail-info-item">
                    <div class="detail-info-label">관리년월</div>
                    <div class="detail-info-value" id="detailBillYm">-</div>
                </div>

                <div class="detail-info-item">
                    <div class="detail-info-label">동/호수</div>
                    <div class="detail-info-value" id="detailDongHo">-</div>
                </div>

                <div class="detail-info-item">
                    <div class="detail-info-label">납부기한</div>
                    <div class="detail-info-value" id="detailDueDt">-</div>
                </div>

                <div class="detail-info-item">
                    <div class="detail-info-label">납부상태</div>
                    <div class="detail-info-value" id="detailPymtStts">-</div>
                </div>
            </div>

            <table class="tbl">
                <thead>
                <tr>
                    <th>항목</th>
                    <th>설명</th>
                    <th class="text-right">금액</th>
                </tr>
                </thead>
                <tbody id="billDetailTbody">
                <tr>
                    <td colspan="3" class="empty">상세 항목이 없습니다.</td>
                </tr>
                </tbody>
            </table>

            <div class="detail-total">
                <span>총 관리비</span>
                <span id="detailTotalAmt">0원</span>
            </div>
        </div>

        <div class="modal-footer">
            <button type="button" class="btn btn-secondary" onclick="closeDetailModal()">닫기</button>
        </div>
    </div>
</div>

<script>
    const contextPath = '${pageContext.request.contextPath}';
    const mgmtOfcNo = '${mgmtOfcNo}';

    document.addEventListener('DOMContentLoaded', function () {
        initSearchDate();
        loadDongList();

        // 처음 화면 진입 시 목록은 조회하지 않음
        renderInitialEmptyState();
    });

    function renderInitialEmptyState() {
        document.getElementById('billIssueTbody').innerHTML =
            '<tr><td colspan="7" class="empty">조회 조건을 설정한 뒤 조회 버튼을 눌러 주세요.</td></tr>';

        document.getElementById('summaryTotalCount').textContent = '0건';
        document.getElementById('summaryTotalAmount').textContent = '0원';
        document.getElementById('summaryBillYm').textContent = '-';

        document.getElementById('paginationInfo').textContent = '총 0건';
        document.getElementById('pagingArea').innerHTML = '';
    }

    // PaginationInfoVO.getPagingHTML()에서 생성한 a.page-link 클릭 처리
    document.addEventListener('click', function (e) {
        const target = e.target.closest('#pagingArea .page-link');

        if (!target) {
            return;
        }

        e.preventDefault();

        const page = target.dataset.page;

        if (page) {
            loadBillIssueList(Number(page));
        }
    });

    function initSearchDate() {
        const now = new Date();

        document.getElementById('searchYear').value = now.getFullYear();
        document.getElementById('searchMonth').value = now.getMonth() + 1;
    }

    function getBillYm() {
        const year = document.getElementById('searchYear').value;
        const month = document.getElementById('searchMonth').value;

        if (!year || !month) {
            return '';
        }

        return String(year) + String(month).padStart(2, '0');
    }

    async function loadDongList() {
        const url = contextPath + '/manager/bill/issue/dong-list/' + mgmtOfcNo;

        try {
            const response = await fetch(url);

            if (!response.ok) {
                console.error('동 목록 조회 실패:', response.status);
                return;
            }

            const result = await response.json();

            if (!result.success) {
                console.error(result.message || '동 목록 조회 실패');
                return;
            }

            const select = document.getElementById('dongNo');
            select.innerHTML = '<option value="">전체</option>';

            (result.dongList || []).forEach(function (dong) {
                const option = document.createElement('option');
                option.value = dong.dongNo;
                option.textContent = dong.dongNm || dong.dongNo;
                select.appendChild(option);
            });

        } catch (e) {
            console.error('동 목록 조회 중 오류:', e);
        }
    }

    function onDongChange() {
        const dongNo = document.getElementById('dongNo').value;
        const hoInput = document.getElementById('ho');

        if (dongNo) {
            hoInput.disabled = false;
            hoInput.placeholder = '호수 입력';
        } else {
            hoInput.value = '';
            hoInput.disabled = true;
            hoInput.placeholder = '동 선택 후 입력';
        }
    }

    async function loadBillIssueList(currentPage) {
        currentPage = currentPage || 1;

        const billYm = getBillYm();
        const pymtSttsCd = document.getElementById('pymtSttsCd').value;
        const dongNo = document.getElementById('dongNo').value;
        const ho = document.getElementById('ho').value;

        /*
         * 동은 선택 조건으로만 사용한다.
         * - 선택하지 않으면 해당 관리사무소의 전체 동 고지서를 조회한다.
         * - 호수는 동을 선택한 경우에만 입력 가능하므로 함께 조회된다.
         */
        let url = contextPath + '/manager/bill/issue/list/' + mgmtOfcNo;

        const params = [];
        params.push('currentPage=' + encodeURIComponent(currentPage));

        if (billYm) {
            params.push('billYm=' + encodeURIComponent(billYm));
        }

        if (pymtSttsCd) {
            params.push('pymtSttsCd=' + encodeURIComponent(pymtSttsCd));
        }

        if (dongNo) {
            params.push('dongNo=' + encodeURIComponent(dongNo));
        }

        if (dongNo && ho) {
            params.push('ho=' + encodeURIComponent(ho));
        }

        url += '?' + params.join('&');

        try {
            const response = await fetch(url);

            if (!response.ok) {
                alert('고지서 목록 조회 중 오류가 발생했습니다. 상태코드: ' + response.status);
                return;
            }

            const result = await response.json();

            if (!result.success) {
                alert(result.message || '고지서 목록 조회에 실패했습니다.');
                return;
            }

            renderBillIssueList(result.list || []);

            document.getElementById('summaryTotalCount').textContent =
                formatNumber(result.totalCount || 0) + '건';

            document.getElementById('summaryTotalAmount').textContent =
                formatNumber(result.pageTotalAmount || 0) + '원';

            document.getElementById('summaryBillYm').textContent =
                billYm ? formatBillYm(billYm) : '전체';

            document.getElementById('paginationInfo').textContent =
                '총 ' + formatNumber(result.totalCount || 0) + '건 / '
                + formatNumber(result.currentPage || 1) + ' / '
                + formatNumber(result.totalPage || 1) + '페이지';

            document.getElementById('pagingArea').innerHTML = result.pagingHTML || '';

        } catch (e) {
            console.error('고지서 목록 조회 중 오류:', e);
            alert('고지서 목록 조회 중 오류가 발생했습니다.');
        }
    }

    function renderBillIssueList(list) {
        const tbody = document.getElementById('billIssueTbody');
        tbody.innerHTML = '';

        if (!list || list.length === 0) {
            tbody.innerHTML = '<tr><td colspan="7" class="empty">조회된 고지서가 없습니다.</td></tr>';
            return;
        }

        list.forEach(function (item) {
            const tr = document.createElement('tr');

            tr.innerHTML =
                '<td>' + formatBillYm(item.billYm) + '</td>' +
                '<td class="td-bold">' + escapeHtml(item.displayDongHo || '-') + '</td>' +
                '<td class="text-right td-bold">' + formatNumber(item.billTotAmt) + '원</td>' +
                '<td>' + formatDate(item.dueDt) + '</td>' +
                '<td>' + renderStatusBadge(item.pymtSttsCd, item.pymtSttsNm) + '</td>' +
                '<td>' + formatDate(item.billPblancDt) + '</td>' +
                '<td>' +
                '<button type="button" class="btn btn-secondary btn-sm" onclick="openDetailModal(\'' + item.billNo + '\')">상세</button>' +
                '</td>';

            tbody.appendChild(tr);
        });
    }

    async function openDetailModal(billNo) {
        const url = contextPath + '/manager/bill/issue/detail/' + mgmtOfcNo + '/' + billNo;

        try {
            const response = await fetch(url);

            if (!response.ok) {
                alert('고지서 상세 조회 중 오류가 발생했습니다. 상태코드: ' + response.status);
                return;
            }

            const result = await response.json();

            if (!result.success) {
                alert(result.message || '고지서 상세 조회에 실패했습니다.');
                return;
            }

            renderBillDetail(result.bill);
            document.getElementById('billDetailModal').classList.add('open');

        } catch (e) {
            console.error('고지서 상세 조회 중 오류:', e);
            alert('고지서 상세 조회 중 오류가 발생했습니다.');
        }
    }

    function renderBillDetail(bill) {
        document.getElementById('detailBillYm').textContent = formatBillYm(bill.billYm);
        document.getElementById('detailDongHo').textContent = bill.displayDongHo || '-';
        document.getElementById('detailDueDt').textContent = formatDate(bill.dueDt);
        document.getElementById('detailPymtStts').innerHTML = renderStatusBadge(bill.pymtSttsCd, bill.pymtSttsNm);
        document.getElementById('detailTotalAmt').textContent = formatNumber(bill.billTotAmt) + '원';

        const tbody = document.getElementById('billDetailTbody');
        tbody.innerHTML = '';

        const detailList = bill.detailList || [];

        if (detailList.length === 0) {
            tbody.innerHTML = '<tr><td colspan="3" class="empty">상세 항목이 없습니다.</td></tr>';
            return;
        }

        detailList.forEach(function (item) {
            const tr = document.createElement('tr');

            tr.innerHTML =
                '<td class="td-bold">' + escapeHtml(item.billItemNm || item.billItemCd || '-') + '</td>' +
                '<td>' + escapeHtml(item.billItemContent || '-') + '</td>' +
                '<td class="text-right td-bold">' + formatNumber(item.billItemAmt) + '원</td>';

            tbody.appendChild(tr);
        });
    }

    function closeDetailModal() {
        document.getElementById('billDetailModal').classList.remove('open');
    }

    function resetSearch() {
        initSearchDate();

        document.getElementById('pymtSttsCd').value = '';
        document.getElementById('dongNo').value = '';
        document.getElementById('ho').value = '';
        document.getElementById('ho').disabled = true;
        document.getElementById('ho').placeholder = '동 선택 후 입력';

        // 초기화 시에도 목록 자동 조회하지 않음
        renderInitialEmptyState();
    }

    function renderStatusBadge(code, name) {
        const statusName = name || code || '-';
        let cls = 'status-badge';

        if (code === 'READY') {
            cls += ' status-ready';
        } else if (code === 'PAID') {
            cls += ' status-paid';
        } else if (code === 'UNPAID') {
            cls += ' status-unpaid';
        } else if (code === 'OVERDUE') {
            cls += ' status-overdue';
        }

        return '<span class="' + cls + '">' + escapeHtml(statusName) + '</span>';
    }

    function formatNumber(value) {
        return Number(value || 0).toLocaleString();
    }

    function formatBillYm(value) {
        if (!value || String(value).length !== 6) {
            return '-';
        }

        const str = String(value);
        return str.substring(0, 4) + '년 ' + Number(str.substring(4, 6)) + '월';
    }

    function formatDate(value) {
        if (!value) {
            return '-';
        }

        const date = new Date(value);

        if (isNaN(date.getTime())) {
            return value;
        }

        return date.getFullYear() + '-'
            + String(date.getMonth() + 1).padStart(2, '0') + '-'
            + String(date.getDate()).padStart(2, '0');
    }

    function escapeHtml(value) {
        return String(value)
            .replaceAll('&', '&amp;')
            .replaceAll('<', '&lt;')
            .replaceAll('>', '&gt;')
            .replaceAll('"', '&quot;')
            .replaceAll("'", '&#039;');
    }
</script>

</body>
</html>