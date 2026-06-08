<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>관리비 항목·집계</title>

    <!-- Spring Security CSRF 메타 태그: 추후 fetch POST 처리 시 CSRF 토큰 사용 가능 -->
    <sec:csrfMetaTags/>

    <!-- Google Fonts: 화면 기본 한글 폰트(Noto Sans KR) -->
    <link rel="preconnect" href="https://fonts.googleapis.com" />

    <!-- Google Fonts: 폰트 파일 로딩 최적화용 연결 -->
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />

    <!-- Google Fonts: Noto Sans KR 폰트 -->
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet" />

    <!-- Google Material Symbols: 아이콘 폰트(picture_as_pdf, bar_chart 등) -->
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet" />

    <!-- 프로젝트 공통 레이아웃 CSS: 관리사무소 사이드바/헤더/전체 레이아웃 -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/office-layout.css">

    <!-- 프로젝트 관리사무소 공통 UI CSS: 버튼/패널/폼/테이블/모달 공통 스타일 -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/manager-common.css">

    <style>
        /* =========================================================
           관리비 항목·집계 화면 전용 스타일
           - 외부 차트 라이브러리 없이 div 기반 막대 차트 사용
           - 화면 전용 inline style을 모두 이 영역으로 정리
        ========================================================= */

        .bill-summary-top {
            display: grid;
            grid-template-columns: minmax(280px, 1fr) 2fr;
            gap: 14px;
            margin-bottom: 20px;
        }

        .bill-grand-card {
            min-height: 140px;
            padding: 28px 24px;
            border-radius: var(--r-lg);
            background: #2e5c38;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .bill-grand-label {
            margin-bottom: 8px;
            font-size: 12px;
            color: rgba(255, 255, 255, 0.65);
        }

        .bill-grand-value {
            margin-bottom: 8px;
            font-size: 30px;
            font-weight: 900;
            color: #fff;
        }

        .bill-grand-diff {
            display: inline-flex;
            align-items: center;
            gap: 4px;
            padding: 3px 10px;
            border-radius: 99px;
            background: rgba(255, 255, 255, 0.15);
            font-size: 11px;
            color: rgba(255, 255, 255, 0.85);
        }

        .bill-stat-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 14px;
        }

        .bill-stat-label {
            margin-bottom: 6px;
            font-size: 11px;
            color: var(--text-tertiary);
        }

        .bill-stat-label.warning {
            color: #d97706;
        }

        .bill-stat-value {
            font-size: 26px;
            font-weight: 800;
            color: var(--text-primary);
        }

        .bill-stat-value.green {
            color: #2e5c38;
        }

        .bill-stat-value.warning {
            color: #d97706;
        }

        .bill-stat-sub {
            margin-top: 4px;
            font-size: 11px;
            color: var(--text-tertiary);
        }

        .bill-panel-subtitle {
            margin-top: 2px;
            font-size: 11px;
            color: var(--text-tertiary);
        }

        .bill-view-actions {
            display: flex;
            gap: 6px;
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

        .bill-filter-inline {
            flex-direction: row;
            align-items: center;
            gap: 6px;
        }

        .bill-filter-label {
            white-space: nowrap;
        }

        .bill-filter-base {
            width: 120px;
        }

        .bill-filter-item {
            width: 150px;
        }

        .bill-filter-period {
            width: 130px;
        }

        .bill-chart-label {
            padding: 4px 20px 8px;
            font-size: 11px;
            color: var(--text-tertiary);
        }

        .bill-chart-view {
            padding: 10px 20px 28px;
        }

        .bill-bar-chart {
            display: flex;
            align-items: flex-end;
            gap: 8px;
            height: 180px;
        }

        .bill-bar-item {
            display: flex;
            flex: 1;
            flex-direction: column;
            align-items: center;
            gap: 4px;
        }

        .bill-bar-amount {
            font-size: 10px;
            color: var(--text-secondary);
            font-weight: 700;
        }

        .bill-bar {
            width: 100%;
            border-radius: 6px 6px 0 0;
            transition: 0.3s;
        }

        .bill-bar-labels {
            display: flex;
            gap: 8px;
            margin-top: 8px;
            padding-top: 8px;
            border-top: 1px solid var(--border);
        }

        .bill-bar-label {
            flex: 1;
            text-align: center;
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
        }

        .bill-item-label {
            font-size: 11px;
            color: var(--text-secondary);
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

        .bill-list-view {
            display: none;
        }

        .text-right {
            text-align: right;
        }

        @media (max-width: 1200px) {
            .bill-summary-top {
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
    <!-- 프로젝트 공통 JSP include: 관리사무소 사이드바 -->
    <%@ include file="/WEB-INF/views/include/office_sidebar.jsp" %>

    <div class="main-wrap">
        <!-- 프로젝트 공통 JSP include: 관리사무소 헤더 -->
        <%@ include file="/WEB-INF/views/include/office_header.jsp" %>

        <main class="main-content">
            <div class="office-page" id="billItemSummaryPage">

                <!-- =====================================================
                     페이지 헤더
                     - 화면 제목
                     - PDF 내보내기 버튼
                ====================================================== -->
                <div class="page-header">
                    <div class="page-title-block">
                        <h2>관리비 항목·집계</h2>
                        <p>항목별 관리비 집계 현황을 조회합니다.</p>
                    </div>

                    <div class="page-actions">
                        <button type="button" class="btn btn-secondary" id="btnPdf">
                            <span class="material-symbols-rounded">picture_as_pdf</span>
                            PDF 내보내기
                        </button>
                    </div>
                </div>

                <!-- =====================================================
                     상단 요약 영역
                     - 당월 총 부과 금액
                     - 고지서/납부완료/미납연체 요약
                ====================================================== -->
                <div class="bill-summary-top">

                    <div class="bill-grand-card">
                        <div class="bill-grand-label">당월 총 부과 금액</div>

                        <div>
                            <div class="bill-grand-value" id="grandTotal">₩0</div>
                            <div class="bill-grand-diff" id="grandTotalDiff">— 전월 대비</div>
                        </div>
                    </div>

                    <div class="bill-stat-grid">
                        <div class="stat-card">
                            <div>
                                <div class="bill-stat-label">이번 달 고지서</div>
                                <div class="bill-stat-value" id="statBillCnt">0건</div>
                                <div class="bill-stat-sub">생성 완료</div>
                            </div>
                        </div>

                        <div class="stat-card">
                            <div>
                                <div class="bill-stat-label">납부 완료</div>
                                <div class="bill-stat-value green" id="statPaidCnt">0건</div>
                                <div class="bill-stat-sub">완납 처리 기준</div>
                            </div>
                        </div>

                        <div class="stat-card">
                            <div>
                                <div class="bill-stat-label warning">미납·연체</div>
                                <div class="bill-stat-value warning" id="statUnpaidCnt">0건</div>
                                <div class="bill-stat-sub">미납 + 장기연체</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- =====================================================
                     집계 현황 패널
                     - 차트/리스트 전환
                     - 조건 필터
                     - div 기반 막대 차트
                     - 리스트 테이블
                ====================================================== -->
                <div class="panel">
                    <div class="panel-header">
                        <div>
                            <h3 class="panel-title">
                                <span class="material-symbols-rounded">bar_chart</span>
                                관리비 집계 현황
                            </h3>
                            <div class="bill-panel-subtitle">관리비 항목 기준 집계</div>
                        </div>

                        <div class="bill-view-actions">
                            <button type="button" class="chart-view-btn active" data-view="chart">차트</button>
                            <button type="button" class="chart-view-btn" data-view="list">리스트</button>
                        </div>
                    </div>

                    <!-- 조회 조건 필터 -->
                    <div class="filter-bar">
                        <div class="form-field bill-filter-inline">
                            <label class="field-label bill-filter-label">조회 기준</label>
                            <select class="form-select bill-filter-base" id="filterBase">
                                <option value="item">항목별</option>
                                <option value="month">납부월별</option>
                            </select>
                        </div>

                        <div class="form-field bill-filter-inline">
                            <label class="field-label bill-filter-label">집계 항목</label>
                            <select class="form-select bill-filter-item" id="filterItem">
                                <option value="ALL">전체 항목</option>
                                <option value="ELEC">ELEC (전기)</option>
                                <option value="WATER">WATER (수도)</option>
                                <option value="GAS">GAS (가스)</option>
                                <option value="COMMON">COMMON (공용관리비)</option>
                            </select>
                        </div>

                        <div class="form-field bill-filter-inline">
                            <label class="field-label bill-filter-label">조회 기간</label>
                            <select class="form-select bill-filter-period" id="filterPeriod">
                                <option value="6">최근 6개월</option>
                                <option value="12">최근 12개월</option>
                                <option value="3">최근 3개월</option>
                            </select>
                        </div>

                        <button type="button" class="btn btn-primary" id="btnSearchChart">조회</button>
                    </div>

                    <!-- 현재 조회 조건 표시 -->
                    <div class="bill-chart-label" id="chartLabel">
                        항목별 · 전체 항목 · 최근 6개월
                    </div>

                    <!-- 차트 뷰 -->
                    <div id="chartView" class="bill-chart-view">
                        <div id="barChart" class="bill-bar-chart"></div>
                        <div id="barLabels" class="bill-bar-labels"></div>
                        <div id="itemSummary" class="bill-item-summary"></div>
                    </div>

                    <!-- 리스트 뷰 -->
                    <div id="listView" class="bill-list-view">
                        <div class="table-wrap">
                            <table class="tbl tbl-fixed">
                                <colgroup>
                                    <col style="width:16%;">
                                    <col style="width:14%;">
                                    <col style="width:14%;">
                                    <col style="width:14%;">
                                    <col style="width:16%;">
                                    <col style="width:26%;">
                                </colgroup>

                                <thead>
                                <tr>
                                    <th>월</th>
                                    <th class="text-right">ELEC</th>
                                    <th class="text-right">WATER</th>
                                    <th class="text-right">GAS</th>
                                    <th class="text-right">COMMON</th>
                                    <th class="text-right">합계</th>
                                </tr>
                                </thead>

                                <tbody id="listViewBody"></tbody>
                            </table>
                        </div>
                    </div>
                </div>

            </div>
        </main>
    </div>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        initBillItemSummaryPage();
    });

    function initBillItemSummaryPage() {
        var page = document.getElementById("billItemSummaryPage");
        if (!page) return;

        var currentView = "chart";

        /*
         * 화면 확인용 더미 데이터
         * 실제 DB 연결 시 BILL + BILL_DETAIL 집계 결과로 교체 예정
         */
        var months = ["1월", "2월", "3월", "4월", "5월", "6월"];

        var amounts = [
            { elec: 38000, water: 12000, gas: 9000, common: 45000 },
            { elec: 40000, water: 12400, gas: 9200, common: 45000 },
            { elec: 42000, water: 13000, gas: 9500, common: 45000 },
            { elec: 39000, water: 12200, gas: 9100, common: 45000 },
            { elec: 41000, water: 12800, gas: 9300, common: 45000 },
            { elec: 38920, water: 12400, gas: 9000, common: 45000 }
        ];

        var billSummary = {
            total: 486,
            paid: 449,
            unpaid: 37
        };

        var ITEM_LABEL = {
            elec: "전기 (ELEC)",
            water: "수도 (WATER)",
            gas: "가스 (GAS)",
            common: "공용관리비 (COMMON)"
        };

        var ITEM_COLOR = {
            elec: "#f59e0b",
            water: "#3b82f6",
            gas: "#f97316",
            common: "#2e5c38"
        };

        function initStats() {
            var grand = amounts[amounts.length - 1];
            var total = grand.elec + grand.water + grand.gas + grand.common;

            var prevGrand = amounts[amounts.length - 2];
            var prevTotal = prevGrand.elec + prevGrand.water + prevGrand.gas + prevGrand.common;

            var diff = total - prevTotal;
            var pct = Math.abs(Math.round(diff / prevTotal * 100 * 10) / 10);

            document.getElementById("grandTotal").textContent = "₩" + (total * 486).toLocaleString();

            document.getElementById("grandTotalDiff").textContent =
                (diff >= 0 ? "▲" : "▼")
                + " 전월 대비 "
                + pct
                + "% "
                + (diff >= 0 ? "증가" : "감소");

            document.getElementById("statBillCnt").textContent = billSummary.total + "건";
            document.getElementById("statPaidCnt").textContent = billSummary.paid + "건";
            document.getElementById("statUnpaidCnt").textContent = billSummary.unpaid + "건";
        }

        function renderChart() {
            var totals = amounts.map(function (amount) {
                return amount.elec + amount.water + amount.gas + amount.common;
            });

            var maxAmt = Math.max.apply(null, totals);

            document.getElementById("barChart").innerHTML = months.map(function (month, index) {
                var total = totals[index];
                var height = Math.round((total / maxAmt) * 160);
                var percent = Math.round(total / maxAmt * 100);

                var color = percent >= 90 ? "#2e5c38" : percent >= 70 ? "#4d7a58" : "#8aab94";

                return '<div class="bill-bar-item">'
                    + '<div class="bill-bar-amount">₩' + Math.round(total / 1000) + 'K</div>'
                    + '<div class="bill-bar" style="height:' + height + 'px; background:' + color + ';"></div>'
                    + '</div>';
            }).join("");

            document.getElementById("barLabels").innerHTML = months.map(function (month) {
                return '<div class="bill-bar-label">' + month + '</div>';
            }).join("");

            renderItemSummary();
        }

        function renderItemSummary() {
            var keys = ["elec", "water", "gas", "common"];

            document.getElementById("itemSummary").innerHTML = keys.map(function (key) {
                var total = amounts.reduce(function (sum, amount) {
                    return sum + amount[key];
                }, 0);

                return '<div class="bill-item-card">'
                    + '<div class="bill-item-card-head">'
                    + '<div class="bill-item-dot" style="background:' + ITEM_COLOR[key] + ';"></div>'
                    + '<span class="bill-item-label">' + ITEM_LABEL[key] + '</span>'
                    + '</div>'
                    + '<div class="bill-item-total">₩' + total.toLocaleString() + '</div>'
                    + '<div class="bill-item-sub">6개월 합산</div>'
                    + '</div>';
            }).join("");
        }

        function renderList() {
            document.getElementById("listViewBody").innerHTML = months.map(function (month, index) {
                var amount = amounts[index];
                var total = amount.elec + amount.water + amount.gas + amount.common;

                return '<tr>'
                    + '<td class="td-bold">2026년 ' + month + '</td>'
                    + '<td class="text-right">₩' + amount.elec.toLocaleString() + '</td>'
                    + '<td class="text-right">₩' + amount.water.toLocaleString() + '</td>'
                    + '<td class="text-right">₩' + amount.gas.toLocaleString() + '</td>'
                    + '<td class="text-right">₩' + amount.common.toLocaleString() + '</td>'
                    + '<td class="text-right" style="font-weight:800;">₩' + total.toLocaleString() + '</td>'
                    + '</tr>';
            }).join("");
        }

        function setView(view) {
            currentView = view;

            page.querySelectorAll(".chart-view-btn").forEach(function (btn) {
                btn.classList.toggle("active", btn.dataset.view === view);
            });

            document.getElementById("chartView").style.display = view === "chart" ? "block" : "none";
            document.getElementById("listView").style.display = view === "list" ? "block" : "none";

            if (view === "list") {
                renderList();
            }
        }

        page.addEventListener("click", function (event) {
            var viewBtn = event.target.closest(".chart-view-btn");
            if (!viewBtn) return;

            setView(viewBtn.dataset.view);
        });

        document.getElementById("btnSearchChart").addEventListener("click", function () {
            var base = document.getElementById("filterBase").value;
            var item = document.getElementById("filterItem").value;
            var period = document.getElementById("filterPeriod").value;

            document.getElementById("chartLabel").textContent =
                (base === "item" ? "항목별" : "납부월별")
                + " · "
                + (item === "ALL" ? "전체 항목" : item)
                + " · 최근 "
                + period
                + "개월";

            if (currentView === "chart") {
                renderChart();
            } else {
                renderList();
            }
        });

        initStats();
        renderChart();
    }
</script>
</body>
</html>