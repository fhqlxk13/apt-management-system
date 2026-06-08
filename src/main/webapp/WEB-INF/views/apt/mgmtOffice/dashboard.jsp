<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<style>
    /* dashboard.jsp 전용 CSS - 기존 인라인 스타일 값을 최대한 유지하면서 위로 모음 */
    #dashboardPage .dash-card-red{cursor:pointer;border-left:4px solid #dc2626} #dashboardPage .dash-card-orange{cursor:pointer;border-left:4px solid #d97706} #dashboardPage .dash-card-purple{cursor:pointer;border-left:4px solid #7c3aed} #dashboardPage .dash-card-green{cursor:pointer;border-left:4px solid #2e5c38}
    #dashboardPage .dash-card-red:hover,#dashboardPage .dash-card-orange:hover,#dashboardPage .dash-card-purple:hover,#dashboardPage .dash-card-green:hover{transform:translateY(-1px)}
    #dashboardPage .dash-card-body{display:flex;align-items:center;justify-content:space-between;width:100%} #dashboardPage .dash-card-label{font-size:11px;color:var(--text-tertiary);margin-bottom:6px} #dashboardPage .dash-card-value{font-size:28px;font-weight:900} #dashboardPage .dash-card-sub{font-size:11px;color:var(--text-tertiary);margin-top:4px}
    #dashboardPage .dash-red{color:#dc2626} #dashboardPage .dash-orange{color:#d97706} #dashboardPage .dash-purple{color:#7c3aed} #dashboardPage .dash-green{color:#2e5c38}
    #dashboardPage .dash-icon-box{width:44px;height:44px;border-radius:10px;display:flex;align-items:center;justify-content:center} #dashboardPage .dash-icon-red{background:#fee2e2} #dashboardPage .dash-icon-orange{background:#fef3c7} #dashboardPage .dash-icon-purple{background:#ede9fe} #dashboardPage .dash-icon-green{background:#f0f7f2} #dashboardPage .dash-icon{font-size:22px}
    #dashboardPage .dash-link-btn{display:inline-flex;align-items:center;justify-content:center;text-decoration:none}
    #dashboardPage .dash-grid-2{display:grid;grid-template-columns:1fr 1fr;gap:16px;margin-bottom:16px;align-items:stretch;grid-auto-rows:1fr}
    #dashboardPage .dash-grid-3{display:grid;grid-template-columns:1fr 1fr 1fr;gap:16px;margin-bottom:16px;align-items:stretch;grid-auto-rows:1fr}
    #dashboardPage .dash-grid-2>.dash-panel,#dashboardPage .dash-grid-3>.dash-panel{margin:0 !important;display:flex;flex-direction:column;height:100%;min-height:0}
    #dashboardPage .dash-grid-2>.dash-panel>.dash-panel-body,#dashboardPage .dash-grid-2>.dash-panel>.dash-panel-body-sm,#dashboardPage .dash-grid-3>.dash-panel>.dash-list-box{flex:1 1 auto;min-height:0}
    #dashboardPage .dash-panel{padding:0;overflow:hidden} #dashboardPage .dash-panel-head{display:flex;align-items:center;justify-content:space-between;padding:14px 18px;border-bottom:1px solid var(--border);background:#f7f8f9} #dashboardPage .dash-panel-title{font-size:13px;font-weight:700} #dashboardPage .dash-panel-title .material-symbols-rounded{font-size:15px;vertical-align:middle;margin-right:4px}
    #dashboardPage .dash-panel-body-sm{padding:12px} #dashboardPage .dash-panel-body{padding:16px 18px} #dashboardPage .dash-bill-total{margin-bottom:16px;text-align:center} #dashboardPage .dash-bill-label{font-size:11px;color:var(--text-tertiary);margin-bottom:4px} #dashboardPage .dash-bill-amount{font-size:22px;font-weight:900;color:#2e5c38}
    #dashboardPage .dash-progress-wrap{margin-bottom:12px} #dashboardPage .dash-progress-head{display:flex;justify-content:space-between;font-size:11px;margin-bottom:5px} #dashboardPage .dash-progress-label{color:var(--text-secondary)} #dashboardPage .dash-progress-pct{font-weight:700;color:#2e5c38} #dashboardPage .dash-progress-track{height:8px;background:#f0f1f3;border-radius:99px;overflow:hidden} #dashboardPage .dash-progress-bar{height:100%;background:#2e5c38;border-radius:99px;transition:.5s;width:0}
    #dashboardPage .dash-bill-cards{display:grid;grid-template-columns:repeat(3,1fr);gap:8px} #dashboardPage .dash-mini-card{border-radius:8px;padding:10px 12px;text-align:center} #dashboardPage .dash-mini-value{font-size:18px;font-weight:900} #dashboardPage .dash-mini-label{font-size:10px;margin-top:2px;opacity:.8}
    #dashboardPage .dash-list-box{padding:8px 0} #dashboardPage .dash-list-item{display:flex;align-items:center;justify-content:space-between;padding:9px 18px;border-bottom:1px solid var(--border);text-align:center} #dashboardPage .dash-list-left{flex:1;min-width:0;text-align:center} #dashboardPage .dash-list-title{font-size:12px;font-weight:700;text-align:center} #dashboardPage .dash-list-title-ellipsis{font-size:12px;font-weight:700;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;text-align:center} #dashboardPage .dash-list-sub{font-size:11px;color:var(--text-tertiary);margin-top:1px;text-align:center}
    #dashboardPage .dash-priority-dot{width:6px;height:6px;border-radius:50%;flex-shrink:0} #dashboardPage .dash-schedule-item{display:flex;align-items:center;gap:10px;padding:9px 10px;border-radius:8px;border:1px solid var(--border);margin-bottom:7px;text-align:center} #dashboardPage .dash-schedule-bar{width:4px;height:36px;border-radius:99px;flex-shrink:0} #dashboardPage .dash-schedule-body{flex:1;min-width:0;text-align:center} #dashboardPage .dash-schedule-title{font-size:12px;font-weight:700;color:var(--text-primary);overflow:hidden;text-overflow:ellipsis;white-space:nowrap;text-align:center} #dashboardPage .dash-schedule-loc{font-size:11px;color:var(--text-tertiary);margin-top:1px;text-align:center}
    #dashboardPage .dash-meter-badge{font-size:11px;font-weight:700;padding:2px 8px;border-radius:4px} #dashboardPage .dash-stat-value{font-size:13px;font-weight:900;min-width:46px;text-align:right} #dashboardPage .dash-stat-desc{font-size:11px;color:var(--text-tertiary);margin-top:1px;text-align:center} #dashboardPage .dashboard-table th,#dashboardPage .dashboard-table td{text-align:center;vertical-align:middle}
    #dashboardPage .dash-trend-body{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:14px;padding:16px}
    #dashboardPage .dash-trend-card{border:1px solid var(--border);border-radius:10px;background:#fff;padding:16px 14px;display:flex;flex-direction:column;align-items:center;gap:6px}
    #dashboardPage .dash-trend-label{font-size:13px;font-weight:800;color:var(--text-primary);margin-bottom:2px}
    #dashboardPage .dash-gauge-wrap{position:relative;width:160px;height:96px}
    #dashboardPage .dash-gauge-wrap canvas{width:100% !important;height:100% !important}
    #dashboardPage .dash-gauge-center{position:absolute;left:0;right:0;bottom:6px;text-align:center;pointer-events:none}
    #dashboardPage .dash-gauge-pct{font-size:26px;font-weight:900;line-height:1}
    #dashboardPage .dash-gauge-sub{font-size:10px;color:var(--text-tertiary);margin-top:2px}
    #dashboardPage .dash-trend-foot{display:flex;justify-content:space-between;width:100%;font-size:11px;color:var(--text-tertiary);border-top:1px dashed var(--border);padding-top:8px;margin-top:4px}
    #dashboardPage .dash-trend-foot strong{color:var(--text-primary);font-weight:700}

    #dashboardPage .dash-rsvt-summary{display:flex;align-items:center;justify-content:space-between;margin-bottom:14px;gap:12px}
    #dashboardPage .dash-rsvt-today-label{font-size:11px;color:var(--text-tertiary);margin-bottom:2px}
    #dashboardPage .dash-rsvt-today-value{font-size:28px;font-weight:900;color:#2e5c38;line-height:1}
    #dashboardPage .dash-rsvt-today-unit{font-size:12px;color:var(--text-secondary);margin-left:2px}
    #dashboardPage .dash-rsvt-pending{display:flex;align-items:center;gap:8px;padding:8px 12px;border:1px solid #fcd34d;background:#fffbeb;border-radius:8px}
    #dashboardPage .dash-rsvt-pending-icon{width:30px;height:30px;border-radius:8px;background:#fef3c7;display:flex;align-items:center;justify-content:center;color:#b45309}
    #dashboardPage .dash-rsvt-pending-icon .material-symbols-rounded{font-size:18px}
    #dashboardPage .dash-rsvt-pending-num{font-size:18px;font-weight:900;color:#b45309;line-height:1}
    #dashboardPage .dash-rsvt-pending-lbl{font-size:10px;color:#92400e}

    #dashboardPage .dash-topfac-head{display:flex;justify-content:space-between;align-items:baseline;margin-bottom:8px}
    #dashboardPage .dash-topfac-title{font-size:12px;font-weight:800;color:var(--text-primary)}
    #dashboardPage .dash-topfac-sub{font-size:10px;color:var(--text-tertiary)}
    #dashboardPage .dash-topfac-bar{margin-bottom:8px}
    #dashboardPage .dash-topfac-bar:last-child{margin-bottom:0}
    #dashboardPage .dash-topfac-bar-head{display:flex;justify-content:space-between;font-size:11px;margin-bottom:3px}
    #dashboardPage .dash-topfac-bar-name{font-weight:700;color:var(--text-primary);overflow:hidden;text-overflow:ellipsis;white-space:nowrap;max-width:70%}
    #dashboardPage .dash-topfac-bar-cnt{font-weight:700;color:var(--text-secondary)}
    #dashboardPage .dash-topfac-bar-track{height:8px;background:#eef2f5;border-radius:99px;overflow:hidden}
    #dashboardPage .dash-topfac-bar-fill{height:100%;border-radius:99px;transition:width .5s}
    #dashboardPage .dash-topfac-empty{font-size:11px;color:var(--text-tertiary);text-align:center;padding:14px}

    #dashboardPage .dash-rsvt-recent{margin-top:14px;border-top:1px solid var(--border);padding-top:8px}
    #dashboardPage .dash-rsvt-recent-title{font-size:12px;font-weight:800;color:var(--text-primary);margin-bottom:4px}
    #dashboardPage .dash-rsvt-item{display:flex;align-items:center;justify-content:space-between;padding:7px 2px;gap:8px}
    #dashboardPage .dash-rsvt-item + .dash-rsvt-item{border-top:1px dashed var(--border)}
    #dashboardPage .dash-rsvt-item-body{flex:1;min-width:0}
    #dashboardPage .dash-rsvt-item-title{font-size:12px;font-weight:700;overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
    #dashboardPage .dash-rsvt-item-sub{font-size:11px;color:var(--text-tertiary);margin-top:1px}
    #dashboardPage .dash-bill-summary-grid{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:10px;margin-top:14px}
    #dashboardPage .dash-bill-summary-card{border:1px solid #e5e7eb;border-radius:12px;background:#fff;padding:13px 14px;text-align:left}
    #dashboardPage .dash-bill-summary-value{font-size:20px;font-weight:900;color:#2e5c38;line-height:1.2}
    #dashboardPage .dash-bill-summary-label{margin-top:5px;font-size:11px;font-weight:700;color:var(--text-tertiary)}
    #dashboardPage .dash-bill-note{margin-top:14px;padding:10px 12px;border-radius:10px;background:#f8faf7;color:#6b7280;font-size:12px;line-height:1.5}
    @media (max-width:900px){#dashboardPage .dash-bill-summary-grid{grid-template-columns:1fr}}
</style>

<div class="office-page" id="dashboardPage">

    <div class="page-header">
        <div class="page-title-block">
            <h2>대시보드</h2>
            <p id="dashDate"></p>
        </div>
    </div>

    <!-- ① KPI 카드 4개: 카드 전체 클릭 시 해당 화면으로 동기 이동 -->
    <div class="stat-row">

        <div class="stat-card dash-card-red" onclick="location.href='${pageContext.request.contextPath}/manager/complex/complaint/${mgmtOfcNo}'">
            <div class="dash-card-body">
                <div>
                    <div class="dash-card-label">미처리 민원</div>
                    <div class="dash-card-value dash-red" id="kpiCvpl">0</div>
                    <div class="dash-card-sub">즉시 처리 필요</div>
                </div>
                <div class="dash-icon-box dash-icon-red">
                    <span class="material-symbols-rounded dash-icon dash-red">campaign</span>
                </div>
            </div>
        </div>

        <div class="stat-card dash-card-orange" onclick="location.href='${pageContext.request.contextPath}/manager/resident/auth/${mgmtOfcNo}'">
            <div class="dash-card-body">
                <div>
                    <div class="dash-card-label">미처리 입주민 권한</div>
                    <div class="dash-card-value dash-orange" id="kpiRqst">0</div>
                    <div class="dash-card-sub">승인 대기 중</div>
                </div>
                <div class="dash-icon-box dash-icon-orange">
                    <span class="material-symbols-rounded dash-icon dash-orange">how_to_reg</span>
                </div>
            </div>
        </div>

        <div class="stat-card dash-card-purple" onclick="location.href='${pageContext.request.contextPath}/manager/checkHistory/${mgmtOfcNo}'">
            <div class="dash-card-body">
                <div>
                    <div class="dash-card-label">7일 내 이용제한</div>
                    <div class="dash-card-value dash-purple" id="kpiUseRestrict">0</div>
                    <div class="dash-card-sub">제한중·예정 시설</div>
                </div>
                <div class="dash-icon-box dash-icon-purple">
                    <span class="material-symbols-rounded dash-icon dash-purple">build</span>
                </div>
            </div>
        </div>

        <div class="stat-card dash-card-green" onclick="location.href='${pageContext.request.contextPath}/manager/bill/issue/${mgmtOfcNo}'">
            <div class="dash-card-body">
                <div>
                    <div class="dash-card-label">최근 고지 세대</div>
                    <div class="dash-card-value dash-green" id="kpiBill">0</div>
                    <div class="dash-card-sub">관리비 고지서 발행 기준</div>
                </div>
                <div class="dash-icon-box dash-icon-green">
                    <span class="material-symbols-rounded dash-icon dash-green">receipt_long</span>
                </div>
            </div>
        </div>

    </div>

    <!-- ② 시설 예약 요약 / 최근 관리비 부과 요약 -->
    <div class="dash-grid-2">

        <div class="panel dash-panel">
            <div class="dash-panel-head">
                <span class="dash-panel-title">
                    <span class="material-symbols-rounded">event_available</span>
                    시설 예약 요약
                </span>
                <a href="${pageContext.request.contextPath}/manager/publicFacility/reservation/approval/${mgmtOfcNo}" class="btn btn-xs btn-detail dash-link-btn">이동</a>
            </div>

            <div class="dash-panel-body">
                <div class="dash-rsvt-summary">
                    <div>
                        <div class="dash-rsvt-today-label">오늘 예약</div>
                        <div>
                            <span class="dash-rsvt-today-value" id="rsvtTodayCnt">0</span>
                            <span class="dash-rsvt-today-unit">건</span>
                        </div>
                    </div>
                    <div class="dash-rsvt-pending">
                        <div class="dash-rsvt-pending-icon">
                            <span class="material-symbols-rounded">pending_actions</span>
                        </div>
                        <div>
                            <div class="dash-rsvt-pending-num" id="rsvtPendingCnt">0건</div>
                            <div class="dash-rsvt-pending-lbl">승인 대기</div>
                        </div>
                    </div>
                </div>

                <div class="dash-topfac-head">
                    <span class="dash-topfac-title">이달 예약 상위 시설</span>
                    <span class="dash-topfac-sub" id="rsvtWeekStatSub">이번주 승인 0 · 반려 0</span>
                </div>
                <div id="rsvtTopFacilityList"></div>
            </div>
        </div>

        <div class="panel dash-panel">
            <div class="dash-panel-head">
                <span class="dash-panel-title">
                    <span class="material-symbols-rounded">receipt_long</span>
                    최근 관리비 부과 요약
                </span>
                <span class="dash-list-sub" id="billBaseMonth">고지 기준월 확인 중</span>
                <a href="${pageContext.request.contextPath}/manager/bill/issue/${mgmtOfcNo}" class="btn btn-xs btn-detail dash-link-btn">이동</a>
            </div>

            <div class="dash-panel-body">
                <div class="dash-bill-total">
                    <div class="dash-bill-label" id="billTotalLabel">최근 고지 총 부과액</div>
                    <div class="dash-bill-amount" id="billTotalAmount">₩0</div>
                </div>

                <div class="dash-bill-summary-grid" id="billStatusCards"></div>
                <div class="dash-bill-note">
                    고지 규모 요약 현황입니다. 세부 현황은 관리비 고지 화면에서 확인하세요.
                </div>
            </div>
        </div>

    </div>

    <!-- ③ 최근 입주민 권한 신청 / 최근 민원 / 이번 주 점검 -->
    <div class="dash-grid-3">

        <div class="panel dash-panel">
            <div class="dash-panel-head">
                <span class="dash-panel-title">
                    <span class="material-symbols-rounded">how_to_reg</span>
                    최근 입주민 권한 신청
                </span>
                <a href="${pageContext.request.contextPath}/manager/resident/auth/${mgmtOfcNo}" class="btn btn-xs btn-detail dash-link-btn">이동</a>
            </div>
            <div id="rqstList" class="dash-list-box"></div>
        </div>

        <div class="panel dash-panel">
            <div class="dash-panel-head">
                <span class="dash-panel-title">
                    <span class="material-symbols-rounded">forum</span>
                    최근 민원
                </span>
                <a href="${pageContext.request.contextPath}/manager/complex/complaint/${mgmtOfcNo}" class="btn btn-xs btn-detail dash-link-btn">이동</a>
            </div>
            <div id="cvplList" class="dash-list-box"></div>
        </div>

        <div class="panel dash-panel">
            <div class="dash-panel-head">
                <span class="dash-panel-title">
                    <span class="material-symbols-rounded">build</span>
                    이번 주 점검 현황
                </span>
                <a href="${pageContext.request.contextPath}/manager/checkHistory/${mgmtOfcNo}" class="btn btn-xs btn-detail dash-link-btn">이동</a>
            </div>
            <div id="checkList" class="dash-list-box"></div>
        </div>

    </div>

    <!-- ④ 이번 달 주요 업무 처리 현황 -->
    <div class="panel dash-panel">
        <div class="dash-panel-head">
            <span class="dash-panel-title">
                <span class="material-symbols-rounded">trending_up</span>
                이번 달 업무 대응 요약
            </span>
            <span class="dash-list-sub">완료율보다 남은 업무와 최근 처리량을 중심으로 봅니다.</span>
        </div>

        <div class="dash-trend-body" id="operationTrendList"></div>
    </div>

</div>
<%@ include file="/WEB-INF/views/apt/mgmtOffice/admin_mgmt_ofc_select_modal.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.4/dist/chart.umd.min.js"></script>
<script>
    (function() {
        var page = document.getElementById("dashboardPage");
        if (!page || page.dataset.bound === "true") return;
        page.dataset.bound = "true";
        var contextPath = "${pageContext.request.contextPath}";
        var mgmtOfcNo = "${mgmtOfcNo}";

        /* 오늘 날짜 표시 */
        var now = new Date();
        var days = ["일","월","화","수","목","금","토"];
        document.getElementById("dashDate").textContent = now.getFullYear() + "년 " + (now.getMonth() + 1) + "월 " + now.getDate() + "일 (" + days[now.getDay()] + ")";

        var EMPTY_DASHBOARD = {
            kpi: {},
            cvplList: [],
            rqstList: [],
            checkList: [],
            billStat: {},
            monthlyStat: {},
            reservationStat: { recentList: [], topFacilityList: [] },
            operationTrend: []
        };

        function loadDashboardData() {
            if (!mgmtOfcNo) {
                return Promise.resolve(EMPTY_DASHBOARD);
            }

            return fetch(contextPath + "/manager/dashboard/" + encodeURIComponent(mgmtOfcNo), {
                method: "GET",
                headers: { "X-Requested-With": "XMLHttpRequest" }
            })
                .then(function(response) {
                    if (!response.ok) throw new Error("HTTP " + response.status);
                    return response.json();
                })
                .catch(function(error) {
                    console.error(error);
                    return EMPTY_DASHBOARD;
                });
        }

        function formatBillYm(billYm) {
            if (!billYm || String(billYm).length !== 6) return null;
            return String(billYm).substring(0, 4) + "년 " + String(billYm).substring(4, 6) + "월";
        }

        function renderDashboard(dashboardData) {
        var cvplData = dashboardData.cvplList || [];
        var rqstData = dashboardData.rqstList || [];
        var checkData = dashboardData.checkList || [];
        var billStat = dashboardData.billStat || {};
        var monthlyStat = dashboardData.monthlyStat || {};
        var reservationStat = dashboardData.reservationStat || {};
        var operationTrend = dashboardData.operationTrend || [];
        var kpi = dashboardData.kpi || {};

        /* 코드값 화면 표시용 변환 */
        var CVPL_STTS = { APLY:"접수대기", RCPT:"접수완료", POCS:"처리중", COMP:"완료" };
        var CVPL_BADGE = { APLY:"badge-gray", RCPT:"badge-yellow", POCS:"badge-blue", COMP:"badge-green" };
        var PRRT_COLOR = { HIGH:"#dc2626", MEDIUM:"#d97706", LOW:"#6b7280" };

        var RQST_TY = { MVIN:"입주", MVOT:"퇴거", CHG:"변경" };
        var RQST_STTS = { WAIT:"대기중", APRV:"승인", RJCT:"반려" };
        var RQST_BADGE = { WAIT:"badge-yellow", APRV:"badge-green", RJCT:"badge-red" };

        var CHK_TY = { REG:"정기점검", SPC:"특별점검", SAFE:"안전점검", REPAIR:"수리보수" };
        var CHK_STTS = { WAIT:"대기", ING:"진행중", DONE:"완료", FAULT:"이상발견" };
        var CHK_BADGE = { WAIT:"badge-gray", ING:"badge-yellow", DONE:"badge-green", FAULT:"badge-red" };

        /* KPI 숫자 반영 */
        document.getElementById("kpiCvpl").textContent = kpi.cvplPending != null ? kpi.cvplPending : cvplData.filter(function(r) { return r.cvplSttsCd !== "COMP"; }).length;
        document.getElementById("kpiRqst").textContent = kpi.residentAuthPending != null ? kpi.residentAuthPending : rqstData.filter(function(r) { return r.rqstSttsCd === "WAIT"; }).length;
        document.getElementById("kpiUseRestrict").textContent = kpi.useRestrictWithin7 != null ? kpi.useRestrictWithin7 : 0;
        document.getElementById("kpiBill").textContent = billStat.total || 0;

        /* 최근 관리비 부과 요약 */
        var billBaseText = formatBillYm(billStat.billYm);
        var billBaseMonthEl = document.getElementById("billBaseMonth");
        var billTotalLabelEl = document.getElementById("billTotalLabel");
        if (billBaseMonthEl) {
            billBaseMonthEl.textContent = billBaseText ? billBaseText + " 고지 기준" : "고지 내역 없음";
        }
        if (billTotalLabelEl) {
            billTotalLabelEl.textContent = billBaseText ? billBaseText + " 총 부과액" : "최근 고지 총 부과액";
        }
        var billTotalAmountEl = document.getElementById("billTotalAmount");
        if (billTotalAmountEl) {
            billTotalAmountEl.textContent = "₩" + Number(billStat.totalAmount || 0).toLocaleString("ko-KR");
        }

        var avgBillAmount = billStat.total ? Math.round(Number(billStat.totalAmount || 0) / billStat.total) : 0;
        document.getElementById("billStatusCards").innerHTML = [
            { label:"고지 세대", val:(billStat.total || 0).toLocaleString("ko-KR") + "세대" },
            { label:"세대 평균", val:"₩" + avgBillAmount.toLocaleString("ko-KR") },
            { label:"고지 기준월", val:billBaseText || "-" }
        ].map(function(s) {
            return '<div class="dash-bill-summary-card">'
                + '<div class="dash-bill-summary-value">' + s.val + '</div>'
                + '<div class="dash-bill-summary-label">' + s.label + '</div>'
                + '</div>';
        }).join("");

        /* 시설 예약 요약 */
        var topFacilities = (reservationStat.topFacilityList) || [];
        document.getElementById("rsvtTodayCnt").textContent = reservationStat.todayCount || 0;
        document.getElementById("rsvtPendingCnt").textContent = (reservationStat.pendingCount || 0) + "건";
        document.getElementById("rsvtWeekStatSub").textContent =
            "이번주 승인 " + (reservationStat.weekApprovedCount || 0)
            + " · 반려 " + (reservationStat.weekRejectedCount || 0);

        var topListEl = document.getElementById("rsvtTopFacilityList");
        if (topFacilities.length === 0) {
            topListEl.innerHTML = '<div class="dash-topfac-empty">이달 예약 데이터가 없습니다.</div>';
        } else {
            var topMax = topFacilities[0].rsvtCount || 1;
            var TOP_COLOR = ["#2e5c38", "#3b82f6", "#7c3aed"];
            topListEl.innerHTML = topFacilities.map(function(f, i) {
                var pct = Math.max(Math.round((f.rsvtCount || 0) / topMax * 100), 4);
                var color = TOP_COLOR[i] || "#888";
                return '<div class="dash-topfac-bar">'
                    + '<div class="dash-topfac-bar-head">'
                    + '<span class="dash-topfac-bar-name">' + (f.cmnFacilityNm || "-") + '</span>'
                    + '<span class="dash-topfac-bar-cnt">' + (f.rsvtCount || 0) + '건</span>'
                    + '</div>'
                    + '<div class="dash-topfac-bar-track">'
                    + '<div class="dash-topfac-bar-fill" style="width:' + pct + '%;background:' + color + ';"></div>'
                    + '</div>'
                    + '</div>';
            }).join("");
        }

        /* 이번 달 운영 통계 */
        var rqstCompleted = monthlyStat.authDone != null
            ? monthlyStat.authDone
            : rqstData.filter(function(r) { return r.rqstSttsCd === "APRV" || r.rqstSttsCd === "RJCT"; }).length;
        var rqstTotal = monthlyStat.authTotal != null ? monthlyStat.authTotal : rqstData.length;

        document.getElementById("rqstList").innerHTML = rqstData.length === 0
            ? '<div class="dash-list-sub" style="padding:20px;">최근 입주민 권한 신청이 없습니다.</div>'
            : rqstData.map(function(r) {
            return '<div class="dash-list-item">'
                + '<div class="dash-list-left">'
                + '<div class="dash-list-title">' + (r.userNm || "-") + '</div>'
                + '<div class="dash-list-sub">' + (r.hoNo || "-") + ' · ' + (RQST_TY[r.rqstTy] || r.rqstTy || "-") + ' · ' + (r.regDt || "-") + '</div>'
                + '</div>'
                + '<span class="badge ' + (RQST_BADGE[r.rqstSttsCd] || "badge-gray") + '">' + (RQST_STTS[r.rqstSttsCd] || "-") + '</span>'
                + '</div>';
        }).join("");

        /* 최근 민원 */
        document.getElementById("cvplList").innerHTML = cvplData.length === 0
            ? '<div class="dash-list-sub" style="padding:20px;">최근 민원이 없습니다.</div>'
            : cvplData.map(function(c) {
            return '<div class="dash-list-item">'
                + '<div class="dash-priority-dot" style="background:' + (PRRT_COLOR[c.prrtCd] || "#888") + ';"></div>'
                + '<div class="dash-list-left">'
                + '<div class="dash-list-title-ellipsis">' + c.ttl + '</div>'
                + '<div class="dash-list-sub">' + c.hoNo + ' · ' + c.regDt + '</div>'
                + '</div>'
                + '<span class="badge ' + (CVPL_BADGE[c.cvplSttsCd] || "badge-gray") + '">' + (CVPL_STTS[c.cvplSttsCd] || "-") + '</span>'
                + '</div>';
        }).join("");

        /* 이번 주 점검 */
        document.getElementById("checkList").innerHTML = checkData.length === 0
            ? '<div class="dash-list-sub" style="padding:20px;">최근 점검 이력이 없습니다.</div>'
            : checkData.map(function(c) {
            return '<div class="dash-list-item">'
                + '<div class="dash-list-left">'
                + '<div class="dash-list-title">' + c.facilityNm + '</div>'
                + '<div class="dash-list-sub">' + (CHK_TY[c.chkTyCd] || "-") + ' · ' + c.chkDt + '</div>'
                + '</div>'
                + '<span class="badge ' + (CHK_BADGE[c.chkSttsCd] || "badge-gray") + '">' + (CHK_STTS[c.chkSttsCd] || "-") + '</span>'
                + '</div>';
        }).join("");

        /* 이번 달 주요 업무 처리 - 반원 게이지 */
        var sevenDayCvpl = operationTrend.reduce(function(a, t) { return a + (t.cvplCnt || 0); }, 0);
        var sevenDayCheck = operationTrend.reduce(function(a, t) { return a + (t.checkCnt || 0); }, 0);
        var sevenDayAuth = operationTrend.reduce(function(a, t) { return a + (t.authCnt || 0); }, 0);

        renderOperationGaugeCards([
            {
                label:"민원 대응 현황",
                done:monthlyStat.cvplDone || 0,
                total:monthlyStat.cvplTotal || 0,
                color:"#2e5c38",
                subLabel:"처리",
                totalLabel:"접수",
                leftLabel:"7일 처리",
                leftValue:sevenDayCvpl,
                rightLabel:"미처리",
                rightValue:kpi.cvplPending != null ? kpi.cvplPending : Math.max((monthlyStat.cvplTotal || 0) - (monthlyStat.cvplDone || 0), 0)
            },
            {
                label:"점검 완료 현황",
                done:monthlyStat.checkDone || 0,
                total:monthlyStat.checkTotal || 0,
                color:"#2563eb",
                subLabel:"완료",
                totalLabel:"전체",
                leftLabel:"7일 완료",
                leftValue:sevenDayCheck,
                rightLabel:"잔여",
                rightValue:Math.max((monthlyStat.checkTotal || 0) - (monthlyStat.checkDone || 0), 0)
            },
            {
                label:"입주민 권한 처리 현황",
                done:rqstCompleted,
                total:rqstTotal,
                color:"#7c3aed",
                subLabel:"처리",
                totalLabel:"신청",
                leftLabel:"7일 처리",
                leftValue:sevenDayAuth,
                rightLabel:"대기",
                rightValue:kpi.residentAuthPending != null ? kpi.residentAuthPending : Math.max((rqstTotal || 0) - (rqstCompleted || 0), 0)
            }
        ]);

        function renderOperationGaugeCards(rows) {
            var wrap = document.getElementById("operationTrendList");
            if (!wrap) return;

            if (window.dashboardTrendCharts) {
                window.dashboardTrendCharts.forEach(function(chart) {
                    if (chart && typeof chart.destroy === "function") chart.destroy();
                });
            }
            window.dashboardTrendCharts = [];

            wrap.innerHTML = rows.map(function(row, idx) {
                var rate = row.total ? Math.round(row.done / row.total * 100) : 0;
                return '<div class="dash-trend-card">'
                    + '<div class="dash-trend-label">' + row.label + '</div>'
                    + '<div class="dash-gauge-wrap">'
                    + '<canvas id="trendGauge' + idx + '"></canvas>'
                    + '<div class="dash-gauge-center">'
                    + '<div class="dash-gauge-pct" style="color:' + (row.total ? row.color : '#9ca3af') + ';">' + (row.total ? rate + '%' : '-') + '</div>'
                    + '<div class="dash-gauge-sub">' + (row.total ? (row.subLabel || '완료') + ' ' + row.done + ' / ' + (row.totalLabel || '전체') + ' ' + row.total : '집계 없음') + '</div>'
                    + '</div>'
                    + '</div>'
                    + '<div class="dash-trend-foot">'
                    + '<span>' + (row.leftLabel || '최근 7일') + ' <strong>' + (row.leftValue || 0) + '건</strong></span>'
                    + '<span>' + (row.rightLabel || '잔여') + ' <strong>' + (row.rightValue || 0) + '건</strong></span>'
                    + '</div>'
                    + '</div>';
            }).join("");

            if (!window.Chart) return;

            rows.forEach(function(row, idx) {
                var canvas = document.getElementById("trendGauge" + idx);
                if (!canvas) return;

                var hasData = (row.total || 0) > 0;
                var done = hasData ? row.done : 0;
                var remain = hasData ? Math.max(row.total - row.done, 0) : 1;

                var chart = new Chart(canvas, {
                    type: "doughnut",
                    data: {
                        labels: ["완료", "잔여"],
                        datasets: [{
                            data: [done, remain],
                            backgroundColor: [hasData ? row.color : "#e5e7eb", "#eef2f5"],
                            borderWidth: 0
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        rotation: -90,
                        circumference: 180,
                        cutout: "72%",
                        plugins: {
                            legend: { display: false },
                            tooltip: {
                                enabled: hasData,
                                callbacks: {
                                    label: function(ctx) { return " " + ctx.label + ": " + ctx.parsed + "건"; }
                                }
                            }
                        }
                    }
                });

                window.dashboardTrendCharts.push(chart);
            });
        }

        }

        renderDashboard(EMPTY_DASHBOARD);
        loadDashboardData().then(function(dashboardData) {
            renderDashboard(dashboardData || EMPTY_DASHBOARD);
        });

    })();
</script>
