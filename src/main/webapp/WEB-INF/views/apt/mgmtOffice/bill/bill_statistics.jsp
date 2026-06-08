<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>관리비 통계</title>

    <sec:csrfMetaTags/>

    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet" />

    <!-- Google Material Symbols -->
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet" />

    <!-- 프로젝트 공통 CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/office-layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/manager-common.css">

    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>
        /* =========================================================
           관리비 통계 화면 전용 스타일
           - mngr_billItemSummary.jsp 스타일 톤 참고
           - 관리자 공통 CSS 변수와 패널 스타일을 최대한 재사용
        ========================================================= */

        .bill-statistics-top {
            display: grid;
            grid-template-columns: minmax(300px, 1fr) 2fr;
            gap: 14px;
            margin-bottom: 20px;
        }

        .bill-grand-card {
            min-height: 154px;
            padding: 28px 24px;
            border-radius: var(--r-lg);
            background: #2e5c38;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            box-shadow: 0 12px 28px rgba(46, 92, 56, 0.18);
        }

        .bill-grand-label {
            margin-bottom: 8px;
            font-size: 12px;
            color: rgba(255, 255, 255, 0.68);
        }

        .bill-grand-value {
            margin-bottom: 8px;
            font-size: 30px;
            font-weight: 900;
            color: #fff;
            letter-spacing: -0.8px;
        }

        .bill-grand-diff {
            display: inline-flex;
            align-items: center;
            gap: 4px;
            width: fit-content;
            padding: 4px 11px;
            border-radius: 99px;
            background: rgba(255, 255, 255, 0.15);
            font-size: 11px;
            color: rgba(255, 255, 255, 0.9);
        }

        .bill-stat-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 14px;
        }

        .bill-stat-card {
            min-height: 154px;
            padding: 22px 20px;
            border-radius: var(--r-lg);
            background: var(--card);
            border: 1px solid var(--border);
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .bill-stat-label {
            margin-bottom: 6px;
            font-size: 11px;
            color: var(--text-tertiary);
        }

        .bill-stat-value {
            font-size: 24px;
            font-weight: 850;
            color: var(--text-primary);
            letter-spacing: -0.5px;
        }

        .bill-stat-value.green {
            color: #2e5c38;
        }

        .bill-stat-value.warning {
            color: #d97706;
        }

        .bill-stat-value.danger {
            color: #b91c1c;
        }

        .bill-stat-sub {
            margin-top: 5px;
            font-size: 11px;
            color: var(--text-tertiary);
            line-height: 1.5;
        }

        .bill-filter-inline {
            flex-direction: row;
            align-items: center;
            gap: 6px;
        }

        .bill-filter-label {
            white-space: nowrap;
        }

        .bill-filter-period {
            width: 145px;
        }

        .bill-filter-month {
            width: 145px;
        }

        .bill-panel-subtitle {
            margin-top: 2px;
            font-size: 11px;
            color: var(--text-tertiary);
        }

        .bill-view-actions {
            display: flex;
            gap: 6px;
            align-items: center;
        }

        .chart-view-btn {
            padding: 5px 14px;
            border-radius: 6px;
            border: 1px solid var(--border);
            background: var(--card);
            color: var(--text-secondary);
            font-size: 12px;
            font-weight: 600;
            font-family: inherit;
            cursor: pointer;
        }

        .chart-view-btn.active {
            border-color: #2e5c38;
            background: #2e5c38;
            color: #fff;
        }

        .bill-chart-grid {
            display: grid;
            grid-template-columns: minmax(0, 1.45fr) minmax(340px, 0.75fr);
            gap: 16px;
            margin-bottom: 20px;
        }

        .bill-chart-panel {
            min-height: 370px;
        }

        .bill-chart-area {
            height: 292px;
            padding: 4px 4px 0;
        }

        .bill-chart-label {
            padding: 4px 20px 8px;
            font-size: 11px;
            color: var(--text-tertiary);
        }

        .bill-item-summary {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 10px;
            margin-top: 16px;
            padding-top: 16px;
            border-top: 1px solid var(--border);
        }

        .bill-item-card {
            padding: 10px 12px;
            border-radius: 8px;
            background: #f7f8f9;
        }

        .bill-item-card-head {
            display: flex;
            align-items: center;
            gap: 6px;
            margin-bottom: 4px;
        }

        .bill-item-dot {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            flex-shrink: 0;
        }

        .bill-item-label {
            font-size: 11px;
            color: var(--text-secondary);
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .bill-item-total {
            font-size: 15px;
            font-weight: 800;
            color: var(--text-primary);
        }

        .bill-item-sub {
            margin-top: 2px;
            font-size: 10px;
            color: var(--text-tertiary);
        }

        .bill-bottom-grid {
            display: grid;
            grid-template-columns: minmax(0, 0.9fr) minmax(0, 1.1fr);
            gap: 16px;
        }

        .bill-table-wrap {
            overflow-x: auto;
        }

        .bill-status-badge {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-width: 68px;
            padding: 4px 10px;
            border-radius: 99px;
            font-size: 11px;
            font-weight: 700;
        }

        .bill-status-badge.paid {
            background: #e8f5ec;
            color: #257345;
        }

        .bill-status-badge.ready {
            background: #eef3fb;
            color: #326a99;
        }

        .bill-status-badge.unpaid {
            background: #fff7ed;
            color: #c46611;
        }

        .bill-status-badge.overdue {
            background: #fef2f2;
            color: #b91c1c;
        }

        .bill-rank {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 24px;
            height: 24px;
            border-radius: 999px;
            background: #edf3ee;
            color: #2e5c38;
            font-size: 11px;
            font-weight: 800;
        }

        .bill-rank.top {
            background: #2e5c38;
            color: #fff;
        }

        .text-right {
            text-align: right;
        }

        .text-center {
            text-align: center;
        }

        .td-bold {
            font-weight: 700;
            color: var(--text-primary);
        }

        .empty-row {
            padding: 30px 0 !important;
            text-align: center !important;
            color: var(--text-tertiary);
        }

        .bill-loading {
            min-height: 180px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--text-tertiary);
            font-size: 13px;
        }

        @media (max-width: 1280px) {
            .bill-statistics-top {
                grid-template-columns: 1fr;
            }

            .bill-chart-grid {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 960px) {
            .bill-stat-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }

            .bill-bottom-grid {
                grid-template-columns: 1fr;
            }

            .bill-item-summary {
                grid-template-columns: repeat(2, minmax(0, 1fr));
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
            <div class="office-page" id="billStatisticsPage">

                <!-- 페이지 헤더 -->
                <div class="page-header">
                    <div class="page-title-block">
                        <h2>관리비 통계</h2>
                        <p>우리 아파트 단지의 월별 관리비, 항목별 비중, 납부현황을 확인합니다.</p>
                    </div>

                    <div class="page-actions">
                        <button type="button" class="btn btn-secondary" id="btnRefresh">
                            <span class="material-symbols-rounded">refresh</span>
                            새로고침
                        </button>
                    </div>
                </div>

                <!-- 조회 조건 -->
                <div class="panel">
                    <div class="panel-header">
                        <div>
                            <h3 class="panel-title">
                                <span class="material-symbols-rounded">manage_search</span>
                                조회 조건
                            </h3>
                            <div class="bill-panel-subtitle">조회할 관리비 부과월 범위를 선택해 주세요.</div>
                        </div>
                    </div>

                    <div class="filter-bar">
                        <div class="form-field bill-filter-inline">
                            <label class="field-label bill-filter-label">시작월</label>
                            <input type="month" class="form-input bill-filter-month" id="fromYm">
                        </div>

                        <div class="form-field bill-filter-inline">
                            <label class="field-label bill-filter-label">종료월</label>
                            <input type="month" class="form-input bill-filter-month" id="toYm">
                        </div>

                        <div class="form-field bill-filter-inline">
                            <label class="field-label bill-filter-label">빠른 선택</label>
                            <select class="form-select bill-filter-period" id="quickPeriod">
                                <option value="3">최근 3개월</option>
                                <option value="6">최근 6개월</option>
                                <option value="12" selected>최근 12개월</option>
                                <option value="13">최근 13개월</option>
                            </select>
                        </div>

                        <button type="button" class="btn btn-primary" id="btnSearch">
                            <span class="material-symbols-rounded">bar_chart</span>
                            통계 조회
                        </button>
                    </div>
                </div>

                <!-- 상단 요약 -->
                <div class="bill-statistics-top">

                    <div class="bill-grand-card">
                        <div>
                            <div class="bill-grand-label">조회기간 총 부과금액</div>
                            <div class="bill-grand-value" id="grandTotalBillAmt">₩0</div>
                        </div>

                        <div class="bill-grand-diff" id="grandPeriodText">
                            조회기간 -
                        </div>
                    </div>

                    <div class="bill-stat-grid">
                        <div class="bill-stat-card">
                            <div>
                                <div class="bill-stat-label">총 납부금액</div>
                                <div class="bill-stat-value green" id="statPaidAmt">₩0</div>
                                <div class="bill-stat-sub" id="statPaidCnt">납부완료 0건</div>
                            </div>
                        </div>

                        <div class="bill-stat-card">
                            <div>
                                <div class="bill-stat-label">미납·연체 금액</div>
                                <div class="bill-stat-value warning" id="statUnpaidAmt">₩0</div>
                                <div class="bill-stat-sub" id="statUnpaidCnt">미납 0건 · 연체 0건</div>
                            </div>
                        </div>

                        <div class="bill-stat-card">
                            <div>
                                <div class="bill-stat-label">납부율</div>
                                <div class="bill-stat-value green" id="statPaidRate">0.0%</div>
                                <div class="bill-stat-sub" id="statBillCnt">고지서 0건</div>
                            </div>
                        </div>

                        <div class="bill-stat-card">
                            <div>
                                <div class="bill-stat-label">평균 관리비</div>
                                <div class="bill-stat-value" id="statAvgBillAmt">₩0</div>
                                <div class="bill-stat-sub" id="statMinMaxAmt">최소 0원 · 최대 0원</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 차트 영역 -->
                <div class="bill-chart-grid">

                    <!-- 월별 추이 -->
                    <div class="panel bill-chart-panel">
                        <div class="panel-header">
                            <div>
                                <h3 class="panel-title">
                                    <span class="material-symbols-rounded">stacked_bar_chart</span>
                                    월별 관리비 부과·납부 추이
                                </h3>
                                <div class="bill-panel-subtitle">월별 부과금액과 납부금액 비교</div>
                            </div>

                            <div class="bill-view-actions">
                                <button type="button" class="chart-view-btn active" data-chart-view="bar">막대</button>
                                <button type="button" class="chart-view-btn" data-chart-view="line">선</button>
                            </div>
                        </div>

                        <div class="bill-chart-label" id="monthlyChartLabel">-</div>

                        <div class="bill-chart-area">
                            <canvas id="monthlyChart"></canvas>
                        </div>
                    </div>

                    <!-- 항목별 비중 -->
                    <div class="panel bill-chart-panel">
                        <div class="panel-header">
                            <div>
                                <h3 class="panel-title">
                                    <span class="material-symbols-rounded">donut_large</span>
                                    항목별 관리비 비중
                                </h3>
                                <div class="bill-panel-subtitle">BILL_DETAIL 기준 항목별 합계</div>
                            </div>
                        </div>

                        <div class="bill-chart-label" id="itemChartLabel">-</div>

                        <div class="bill-chart-area">
                            <canvas id="itemChart"></canvas>
                        </div>
                    </div>
                </div>

                <!-- 항목 요약 카드 -->
                <div class="panel" style="margin-bottom:20px;">
                    <div class="panel-header">
                        <div>
                            <h3 class="panel-title">
                                <span class="material-symbols-rounded">category</span>
                                항목별 요약
                            </h3>
                            <div class="bill-panel-subtitle">상위 항목 중심 관리비 비중</div>
                        </div>
                    </div>

                    <div id="itemSummary" class="bill-item-summary"></div>
                </div>

                <!-- 하단 테이블 -->
                <div class="bill-bottom-grid">

                    <!-- 납부상태별 현황 -->
                    <div class="panel">
                        <div class="panel-header">
                            <div>
                                <h3 class="panel-title">
                                    <span class="material-symbols-rounded">fact_check</span>
                                    납부상태별 현황
                                </h3>
                                <div class="bill-panel-subtitle">고지서 상태별 건수와 금액</div>
                            </div>
                        </div>

                        <div class="table-wrap bill-table-wrap">
                            <table class="data-table">
                                <thead>
                                <tr>
                                    <th>상태</th>
                                    <th class="text-right">건수</th>
                                    <th class="text-right">금액</th>
                                </tr>
                                </thead>
                                <tbody id="statusTableBody">
                                <tr>
                                    <td colspan="3" class="empty-row">조회된 데이터가 없습니다.</td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- 세대별 TOP 10 -->
                    <div class="panel">
                        <div class="panel-header">
                            <div>
                                <h3 class="panel-title">
                                    <span class="material-symbols-rounded">leaderboard</span>
                                    세대별 관리비 TOP 10
                                </h3>
                                <div class="bill-panel-subtitle">조회기간 누적 관리비가 높은 세대</div>
                            </div>
                        </div>

                        <div class="table-wrap bill-table-wrap">
                            <table class="data-table">
                                <thead>
                                <tr>
                                    <th>순위</th>
                                    <th>세대</th>
                                    <th class="text-right">누적금액</th>
                                </tr>
                                </thead>
                                <tbody id="houseTopTableBody">
                                <tr>
                                    <td colspan="3" class="empty-row">조회된 데이터가 없습니다.</td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

            </div>
        </main>
    </div>
</div>

<script>
    const contextPath = '${pageContext.request.contextPath}';
    const mgmtOfcNo = '${mgmtOfcNo}';
    const defaultFromYm = '${fromYm}';
    const defaultToYm = '${toYm}';

    let monthlyChart = null;
    let itemChart = null;
    let monthlyChartType = 'bar';

    const itemColorPalette = [
        '#2e5c38',
        '#3b82f6',
        '#f59e0b',
        '#f97316',
        '#8b5cf6',
        '#14b8a6',
        '#ef4444',
        '#64748b',
        '#84cc16',
        '#06b6d4'
    ];

    document.addEventListener('DOMContentLoaded', function () {
        initBillStatisticsPage();
    });

    function initBillStatisticsPage() {
        document.getElementById('fromYm').value = toMonthInput(defaultFromYm);
        document.getElementById('toYm').value = toMonthInput(defaultToYm);

        document.getElementById('btnSearch').addEventListener('click', loadStatistics);
        document.getElementById('btnRefresh').addEventListener('click', loadStatistics);

        document.getElementById('quickPeriod').addEventListener('change', function () {
            applyQuickPeriod(this.value);
        });

        document.querySelectorAll('.chart-view-btn').forEach(function (button) {
            button.addEventListener('click', function () {
                document.querySelectorAll('.chart-view-btn').forEach(function (btn) {
                    btn.classList.remove('active');
                });

                this.classList.add('active');
                monthlyChartType = this.dataset.chartView;

                loadStatistics();
            });
        });

        loadStatistics();
    }

    function applyQuickPeriod(monthCount) {
        const count = Number(monthCount || 12);
        const toDate = new Date();
        const fromDate = new Date();

        fromDate.setMonth(toDate.getMonth() - (count - 1));

        document.getElementById('toYm').value = toMonthInput(formatDateToYm(toDate));
        document.getElementById('fromYm').value = toMonthInput(formatDateToYm(fromDate));
    }

    async function loadStatistics() {
        const fromYm = fromMonthInput(document.getElementById('fromYm').value);
        const toYm = fromMonthInput(document.getElementById('toYm').value);

        if (!fromYm || !toYm) {
            alert('조회기간을 선택해 주세요.');
            return;
        }

        if (fromYm > toYm) {
            alert('시작월은 종료월보다 클 수 없습니다.');
            return;
        }

        setLoadingState();

        try {
            const url =
                contextPath
                + '/manager/bill/statistics/api/'
                + encodeURIComponent(mgmtOfcNo)
                + '?fromYm=' + encodeURIComponent(fromYm)
                + '&toYm=' + encodeURIComponent(toYm);

            const response = await fetch(url);

            if (!response.ok) {
                throw new Error('통계 조회 요청 실패: ' + response.status);
            }

            const result = await response.json();

            if (!result.success) {
                throw new Error(result.message || '관리비 통계 조회에 실패했습니다.');
            }

            renderStatistics(result);

        } catch (error) {
            console.error('관리비 통계 조회 오류 =', error);
            alert(error.message || '관리비 통계 조회 중 오류가 발생했습니다.');
            clearStatistics();
        }
    }

    function setLoadingState() {
        document.getElementById('itemSummary').innerHTML =
            '<div class="bill-loading" style="grid-column: 1 / -1;">통계 데이터를 조회하고 있습니다.</div>';

        document.getElementById('statusTableBody').innerHTML =
            '<tr><td colspan="3" class="empty-row">통계 데이터를 조회하고 있습니다.</td></tr>';

        document.getElementById('houseTopTableBody').innerHTML =
            '<tr><td colspan="3" class="empty-row">통계 데이터를 조회하고 있습니다.</td></tr>';
    }

    function renderStatistics(result) {
        const summary = result.summary || {};
        const monthlyList = result.monthlyList || [];
        const itemList = result.itemList || [];
        const statusList = result.statusList || [];
        const houseTopList = result.houseTopList || [];

        renderSummary(summary, result.fromYm, result.toYm);
        renderMonthlyChart(monthlyList);
        renderItemChart(itemList);
        renderItemSummary(itemList);
        renderStatusTable(statusList);
        renderHouseTopTable(houseTopList);
    }

    function renderSummary(summary, fromYm, toYm) {
        document.getElementById('grandTotalBillAmt').textContent =
            '₩' + formatNumber(summary.totalBillAmt);

        document.getElementById('grandPeriodText').textContent =
            formatYm(fromYm) + ' ~ ' + formatYm(toYm);

        document.getElementById('statPaidAmt').textContent =
            '₩' + formatNumber(summary.totalPaidAmt);

        document.getElementById('statUnpaidAmt').textContent =
            '₩' + formatNumber(summary.totalUnpaidAmt);

        document.getElementById('statPaidRate').textContent =
            Number(summary.paidRate || 0).toFixed(1) + '%';

        document.getElementById('statAvgBillAmt').textContent =
            '₩' + formatNumber(summary.avgBillAmt);

        document.getElementById('statPaidCnt').textContent =
            '납부완료 ' + formatNumber(summary.paidCnt) + '건';

        document.getElementById('statUnpaidCnt').textContent =
            '미납 ' + formatNumber(summary.unpaidCnt) +
            '건 · 연체 ' + formatNumber(summary.overdueCnt) + '건';

        document.getElementById('statBillCnt').textContent =
            '고지서 ' + formatNumber(summary.billCnt) + '건';

        document.getElementById('statMinMaxAmt').textContent =
            '최소 ' + formatNumber(summary.minBillAmt) +
            '원 · 최대 ' + formatNumber(summary.maxBillAmt) + '원';
    }

    function renderMonthlyChart(list) {
        const labels = list.map(function (item) {
            return formatYm(item.billYm);
        });

        const billData = list.map(function (item) {
            return Number(item.monthBillAmt || 0);
        });

        const paidData = list.map(function (item) {
            return Number(item.monthPaidAmt || 0);
        });

        document.getElementById('monthlyChartLabel').textContent =
            labels.length > 0
                ? labels[0] + ' ~ ' + labels[labels.length - 1] + ' 월별 추이'
                : '조회된 월별 데이터가 없습니다.';

        if (monthlyChart) {
            monthlyChart.destroy();
        }

        const ctx = document.getElementById('monthlyChart');

        monthlyChart = new Chart(ctx, {
            type: monthlyChartType,
            data: {
                labels: labels,
                datasets: [
                    {
                        label: '부과금액',
                        data: billData,
                        backgroundColor: '#2e5c38',
                        borderColor: '#2e5c38',
                        borderWidth: 2,
                        tension: 0.35
                    },
                    {
                        label: '납부금액',
                        data: paidData,
                        backgroundColor: '#8aab94',
                        borderColor: '#8aab94',
                        borderWidth: 2,
                        tension: 0.35
                    }
                ]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        labels: {
                            boxWidth: 12,
                            font: {
                                size: 12,
                                family: 'Noto Sans KR'
                            }
                        }
                    },
                    tooltip: {
                        callbacks: {
                            label: function (context) {
                                return context.dataset.label + ': ₩' + formatNumber(context.raw);
                            }
                        }
                    }
                },
                scales: {
                    y: {
                        ticks: {
                            callback: function (value) {
                                return formatShortWon(value);
                            }
                        }
                    }
                }
            }
        });
    }

    function renderItemChart(list) {
        const labels = list.map(function (item) {
            return item.billItemNm || item.billItemCd || '-';
        });

        const data = list.map(function (item) {
            return Number(item.itemTotalAmt || 0);
        });

        document.getElementById('itemChartLabel').textContent =
            list.length > 0
                ? '총 ' + list.length + '개 항목'
                : '조회된 항목 데이터가 없습니다.';

        if (itemChart) {
            itemChart.destroy();
        }

        const ctx = document.getElementById('itemChart');

        itemChart = new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: labels,
                datasets: [
                    {
                        data: data,
                        backgroundColor: itemColorPalette
                    }
                ]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                cutout: '60%',
                plugins: {
                    legend: {
                        position: 'bottom',
                        labels: {
                            boxWidth: 10,
                            font: {
                                size: 11,
                                family: 'Noto Sans KR'
                            }
                        }
                    },
                    tooltip: {
                        callbacks: {
                            label: function (context) {
                                const item = list[context.dataIndex] || {};
                                return context.label
                                    + ': ₩' + formatNumber(context.raw)
                                    + ' (' + Number(item.itemRate || 0).toFixed(1) + '%)';
                            }
                        }
                    }
                }
            }
        });
    }

    function renderItemSummary(list) {
        const container = document.getElementById('itemSummary');

        if (!list || list.length === 0) {
            container.innerHTML =
                '<div class="bill-loading" style="grid-column: 1 / -1;">조회된 항목별 데이터가 없습니다.</div>';
            return;
        }

        const topItems = list.slice(0, 8);

        let html = '';

        topItems.forEach(function (item, index) {
            const color = itemColorPalette[index % itemColorPalette.length];

            html +=
                '<div class="bill-item-card">' +
                '   <div class="bill-item-card-head">' +
                '       <span class="bill-item-dot" style="background:' + color + ';"></span>' +
                '       <span class="bill-item-label">' + escapeHtml(item.billItemNm || item.billItemCd || '-') + '</span>' +
                '   </div>' +
                '   <div class="bill-item-total">₩' + formatNumber(item.itemTotalAmt) + '</div>' +
                '   <div class="bill-item-sub">전체의 ' + Number(item.itemRate || 0).toFixed(1) + '%</div>' +
                '</div>';
        });

        container.innerHTML = html;
    }

    function renderStatusTable(list) {
        const tbody = document.getElementById('statusTableBody');

        if (!list || list.length === 0) {
            tbody.innerHTML =
                '<tr><td colspan="3" class="empty-row">조회된 납부상태 데이터가 없습니다.</td></tr>';
            return;
        }

        let html = '';

        list.forEach(function (item) {
            html +=
                '<tr>' +
                '   <td class="text-center">' +
                '       <span class="bill-status-badge ' + getStatusClass(item.pymtSttsCd) + '">' +
                escapeHtml(item.pymtSttsNm || item.pymtSttsCd || '-') +
                '       </span>' +
                '   </td>' +
                '   <td class="text-right">' + formatNumber(item.statusCnt) + '건</td>' +
                '   <td class="text-right td-bold">₩' + formatNumber(item.statusAmt) + '</td>' +
                '</tr>';
        });

        tbody.innerHTML = html;
    }

    function renderHouseTopTable(list) {
        const tbody = document.getElementById('houseTopTableBody');

        if (!list || list.length === 0) {
            tbody.innerHTML =
                '<tr><td colspan="3" class="empty-row">조회된 세대별 데이터가 없습니다.</td></tr>';
            return;
        }

        let html = '';

        list.forEach(function (item, index) {
            html +=
                '<tr>' +
                '   <td class="text-center">' +
                '       <span class="bill-rank ' + (index < 3 ? 'top' : '') + '">' + (index + 1) + '</span>' +
                '   </td>' +
                '   <td class="td-bold">' + escapeHtml(item.displayDongHo || '-') + '</td>' +
                '   <td class="text-right td-bold">₩' + formatNumber(item.houseTotalAmt) + '</td>' +
                '</tr>';
        });

        tbody.innerHTML = html;
    }

    function clearStatistics() {
        renderSummary({}, '', '');
        renderMonthlyChart([]);
        renderItemChart([]);
        renderItemSummary([]);
        renderStatusTable([]);
        renderHouseTopTable([]);
    }

    function getStatusClass(code) {
        if (code === 'PAID') {
            return 'paid';
        }

        if (code === 'OVERDUE') {
            return 'overdue';
        }

        if (code === 'UNPAID') {
            return 'unpaid';
        }

        return 'ready';
    }

    function toMonthInput(ym) {
        if (!ym || String(ym).length !== 6) {
            return '';
        }

        const value = String(ym);
        return value.substring(0, 4) + '-' + value.substring(4, 6);
    }

    function fromMonthInput(value) {
        return String(value || '').replace('-', '');
    }

    function formatDateToYm(date) {
        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, '0');

        return String(year) + month;
    }

    function formatYm(ym) {
        if (!ym || String(ym).length !== 6) {
            return '-';
        }

        const value = String(ym);
        return value.substring(0, 4) + '.' + Number(value.substring(4, 6));
    }

    function formatNumber(value) {
        return Number(value || 0).toLocaleString('ko-KR');
    }

    function formatShortWon(value) {
        const number = Number(value || 0);

        if (number >= 100000000) {
            return (number / 100000000).toFixed(1) + '억';
        }

        if (number >= 10000) {
            return Math.round(number / 10000) + '만';
        }

        return formatNumber(number);
    }

    function escapeHtml(value) {
        return String(value == null ? '' : value)
            .replaceAll('&', '&amp;')
            .replaceAll('<', '&lt;')
            .replaceAll('>', '&gt;')
            .replaceAll('"', '&quot;')
            .replaceAll("'", '&#39;');
    }
</script>
</body>
</html>