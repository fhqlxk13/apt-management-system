<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>우리집맞춤통계 - 대덕아파트</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/headerStyle.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebarStyle.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footerStyle.css">
  <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.4/dist/chart.umd.min.js"></script>

  <style>
    body {font-family:'Noto Sans KR',sans-serif !important;background:var(--bg);color:var(--text-dark);margin:0;}
    .material-symbols-outlined {font-family:'Material Symbols Outlined' !important;}
    .main-shell {display:flex;align-items:stretch;width:100%;min-height:calc(100vh - 114px);margin-top:114px;background:var(--bg);}
    .content-area {flex:1;min-width:0;padding:32px 40px 64px;}
    .page-content-wrap {max-width:1080px;width:100%;margin:0 auto;}
    .breadcrumb {display:flex;align-items:center;gap:6px;font-size:12px;color:var(--text-light);margin-bottom:18px;}
    .breadcrumb a {color:var(--text-light);text-decoration:none;}
    .breadcrumb .cur {color:var(--green-dark);font-weight:700;}
    .page-title {font-size:22px;font-weight:800;color:var(--text-dark);padding-bottom:14px;border-bottom:2px solid var(--green-dark);margin-bottom:16px;letter-spacing:-.4px;}
    .page-desc {font-size:13px;line-height:1.8;color:var(--text-light);margin-bottom:24px;}
    #customStatsHouseText {display:inline-flex;align-items:center;margin-right:4px;padding:2px 8px;border-radius:6px;background:#eef8f0;color:var(--green-dark);font-size:17px;font-weight:800;line-height:1.5;vertical-align:baseline;}
    .stats-grid {display:grid;grid-template-columns:repeat(4,minmax(0,1fr));gap:14px;margin-bottom:24px;}
    .stat-card,.panel {background:#fff;border:1px solid var(--border);border-radius:14px;box-shadow:0 10px 24px rgba(30,60,40,.05);}
    .stat-card {padding:18px 18px 16px;}
    .stat-label {color:var(--text-light);font-size:12px;margin-bottom:8px;}
    .stat-value {font-size:24px;font-weight:800;color:var(--green-dark);letter-spacing:-.6px;}
    .stat-sub {margin-top:6px;font-size:12px;color:var(--text-light);}
    .stat-sub.up {color:#a23a3a;font-weight:700;}
    .stat-sub.down {color:#2f7a4d;font-weight:700;}
    .panel {padding:20px;margin-bottom:20px;}
    .grid-2 {display:grid;grid-template-columns:1fr 1fr;gap:18px;margin-bottom:22px;}
    .section-hd {display:flex;align-items:center;justify-content:space-between;margin-bottom:14px;padding-bottom:10px;border-bottom:1px solid var(--border);}
    .section-hd h3 {margin:0;font-size:15px;font-weight:800;color:var(--text-dark);}
    .section-hd span {font-size:12px;color:var(--text-light);}
    .chart-box {height:280px;border:1px solid #dfe6dc;border-radius:12px;background:#fff;position:relative;overflow:hidden;padding:14px;box-sizing:border-box;}
    .chart-box canvas {width:100% !important;height:100% !important;}
    .meter-grid {display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:14px;}
    .meter-card {border:1px solid #dfe6dc;border-radius:12px;padding:16px;background:#fff;}
    .meter-title {display:flex;align-items:center;justify-content:space-between;margin-bottom:12px;}
    .meter-title strong {font-size:15px;color:var(--text-dark);}
    .meter-grade {display:inline-flex;align-items:center;padding:4px 10px;border-radius:999px;font-size:11px;font-weight:800;}
    .meter-grade.save {background:#ecf7ef;color:#2f7a4d;}
    .meter-grade.normal {background:#fff5df;color:#9a6b00;}
    .meter-grade.warn {background:#fbe8e8;color:#a23a3a;}
    .meter-values {display:grid;grid-template-columns:1fr 1fr;gap:10px;margin-bottom:14px;}
    .meter-values span {display:block;font-size:11px;color:var(--text-light);margin-bottom:4px;}
    .meter-values b {font-size:16px;color:var(--text-dark);}
    .gauge {height:10px;border-radius:999px;background:#edf0eb;overflow:hidden;position:relative;}
    .gauge-bar {height:100%;width:50%;border-radius:999px;background:#d79a2b;}
    .gauge-bar.save {background:#2f7a4d;}
    .gauge-bar.normal {background:#d79a2b;}
    .gauge-bar.warn {background:#a23a3a;}
    .meter-desc {margin-top:10px;font-size:12px;color:var(--text-light);}
    .data-table {width:100%;border-collapse:collapse;font-size:13px;background:#fff;overflow:hidden;border-radius:12px;}
    .data-table thead th {background:var(--green-pale);color:var(--text-mid);padding:12px 14px;text-align:left;font-weight:700;border-bottom:1px solid var(--border);}
    .data-table tbody td {padding:13px 14px;border-bottom:1px solid #edf0eb;color:var(--text-dark);vertical-align:top;}
    .data-table tbody tr:last-child td {border-bottom:none;}
    .mini-table td,.mini-table th {padding:10px 12px !important;}
    .text-right {text-align:right !important;}
    .empty {padding:24px !important;text-align:center;color:var(--text-light);}
    .process-grid {display:grid;grid-template-columns:repeat(3,1fr);gap:14px;}
    .process-step {padding:18px 14px;border-radius:14px;border:1px solid var(--border);background:#fff;text-align:center;}
    .process-step.active {background:#eef8f0;border-color:#b8d9c0;}
    @media (max-width:1200px){.stats-grid,.meter-grid{grid-template-columns:repeat(2,1fr)}.grid-2{grid-template-columns:1fr}}
    @media (max-width:900px){.main-shell{flex-direction:column}.content-area{padding:24px 18px 48px}.page-content-wrap{max-width:100%}.stats-grid,.meter-grid,.process-grid{grid-template-columns:1fr}}
  </style>
</head>
<body>
  <%@ include file="/WEB-INF/views/include/apt_headerLayout.jsp" %>
  <div class="main-shell">
    <%@ include file="/WEB-INF/views/include/apt_sidebarLayout.jsp" %>
    <main class="content-area">
      <div class="page-content-wrap">
        <div class="breadcrumb">
          <a href="${pageContext.request.contextPath}/">HOME</a>
          <span>&gt;</span>
          <a href="javascript:void(0);">우리아파트통계</a>
          <span>&gt;</span>
          <span class="cur">우리집맞춤통계</span>
        </div>

        <h1 class="page-title">우리집맞춤통계</h1>
        <p class="page-desc">
          <span id="customStatsHouseText">-</span> 기준 관리비와 단지 전체 평균을 비교합니다.
        </p>

        <section class="stats-grid">
          <div class="stat-card">
            <div class="stat-label">이번 달 관리비</div>
            <div class="stat-value" id="currentBillAmt">0원</div>
            <div class="stat-sub" id="currentBillSub">-</div>
          </div>
          <div class="stat-card">
            <div class="stat-label">전월 대비</div>
            <div class="stat-value" id="previousDiffAmt">변동 없음</div>
            <div class="stat-sub" id="previousDiffSub">-</div>
          </div>
          <div class="stat-card">
            <div class="stat-label">단지 전체 평균</div>
            <div class="stat-value" id="similarAvgAmt">0원</div>
            <div class="stat-sub" id="similarAvgSub">-</div>
          </div>
          <div class="stat-card">
            <div class="stat-label">비교 결과</div>
            <div class="stat-value" id="averageDiffAmt">평균과 같음</div>
            <div class="stat-sub" id="averageDiffSub">-</div>
          </div>
        </section>

        <section class="panel">
          <div class="section-hd">
            <h3>최근 3개월 관리비 비교</h3>
            <span>우리집 vs 단지 전체 평균</span>
          </div>
          <div class="chart-box">
            <canvas id="monthlyCompareChart"></canvas>
          </div>
        </section>

        <section class="panel">
          <div class="section-hd">
            <h3>검침 사용량 비교</h3>
            <span>전기 · 수도 · 가스</span>
          </div>
          <div id="meterCompareRows" class="meter-grid">
            <div class="empty">검침 사용량을 불러오는 중입니다.</div>
          </div>
        </section>

        <section class="grid-2">
          <div class="panel">
            <div class="section-hd">
              <h3>이번 달 시설 이용 현황</h3>
              <span>예약 기준</span>
            </div>
            <table class="data-table mini-table">
              <thead>
                <tr>
                  <th>시설</th>
                  <th class="text-right">이용 횟수</th>
                </tr>
              </thead>
              <tbody id="facilityUseRows">
                <tr>
                  <td colspan="2" class="empty">시설 이용 현황을 불러오는 중입니다.</td>
                </tr>
              </tbody>
            </table>
          </div>

          <div class="panel">
            <div class="section-hd">
              <h3>내 민원 처리 현황</h3>
              <span>내 민원 기준</span>
            </div>
            <div class="process-grid">
              <div class="process-step active"><strong id="complaintAppliedCnt">접수 0건</strong></div>
              <div class="process-step active"><strong id="complaintProcessingCnt">처리중 0건</strong></div>
              <div class="process-step"><strong id="complaintDoneCnt">완료 0건</strong></div>
            </div>
          </div>
        </section>
      </div>
    </main>
  </div>
  <%@ include file="/WEB-INF/views/include/apt_footerLayout.jsp" %>

  <script>
    window.customStatsContextPath = '${pageContext.request.contextPath}';
    window.customStatsAptCmplexNo = '${aptCmplexNo}';
  </script>
  <script src="${pageContext.request.contextPath}/js/member/resident/customStats.js"></script>
</body>
</html>
