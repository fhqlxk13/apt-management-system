<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true"%>
<!doctype html>
<html lang="ko">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1.0" />
    <title>우리집맵핑 · 통계</title>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet" />
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/centralAside.css" />
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/centralHeader.css" />
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/centralCommon.css" />
    <%--<script defer src="<%= request.getContextPath() %>/js/centralAside.js"></script>
    <script defer src="<%= request.getContextPath() %>/js/centralHeader.js"></script>--%>
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.2/dist/chart.umd.min.js"></script>
    <style>
      .page-meta-info{display:flex;align-items:center;gap:5px;font-size:11px;color:var(--text-tertiary)} .page-meta-info .material-symbols-rounded{font-size:13px}
      .chart-row-top{display:grid;grid-template-columns:1fr 1fr;gap:14px;margin-bottom:14px}
      .chart-card{background:var(--card);border:1px solid var(--border);border-radius:var(--r-md);padding:18px 22px 20px;box-shadow:var(--shadow-sm)}
      .chart-card-header{display:flex;align-items:flex-start;justify-content:space-between;gap:12px;margin-bottom:14px}
      .chart-card-title{font-size:13px;font-weight:700;color:var(--text-primary);line-height:1.3}
      .chart-card-sub{font-size:11px;color:var(--text-tertiary);margin-top:3px}
      .chart-period-sel{height:28px;padding:0 10px;border:1px solid var(--border);border-radius:6px;background:var(--card);font-family:inherit;font-size:12px;font-weight:600;color:var(--text-secondary);cursor:pointer;flex-shrink:0;outline:none;appearance:auto}
      .chart-period-sel:hover{background:var(--gray-soft)} .chart-period-sel:focus{border-color:var(--accent)}
      .chart-wrap{position:relative} .chart-wrap.h260{height:260px} .chart-wrap.h300{height:300px}
    </style>
  </head>
  <body>
    <%@ include file="centralAside.jsp" %>

    <div class="main-wrap">
      <div class="topbar">
        <div class="breadcrumb">
          <span class="material-symbols-rounded" style="font-size:14px">home</span>
          <span style="margin:0 4px">/</span>
          <span id="bc-parent">계약·재무</span>
          <span style="margin:0 4px">/</span>
          <span class="bc-current" id="bc-current">통계</span>
        </div>
        <div class="topbar-actions">
          <button class="topbar-icon-btn" data-tooltip="알림"><span class="material-symbols-rounded">notifications</span><div class="dot"></div></button>
          <button class="topbar-icon-btn" data-tooltip="설정"><span class="material-symbols-rounded">settings</span></button>
        </div>
      </div>

      <div class="main-content" id="page-content">

        <!-- 페이지 헤더 -->
        <div class="page-header">
          <div>
            <div class="page-title">통계</div>
            <div class="page-subtitle">계약 추이, 관리비 현황, 입주·공실, 세대 구성을 카테고리별로 확인합니다. 각 그래프에서 조회 기간을 개별 변경할 수 있습니다.</div>
          </div>
          <div class="page-header__right">
            <span class="page-meta-info" title="마지막 데이터 갱신 시각">
              <span class="material-symbols-rounded">update</span>기준: 2026.04.26 18:00
            </span>
            <button class="c-btn" title="현재 탭의 통계 데이터를 엑셀 파일로 다운로드합니다">
              <span class="material-symbols-rounded">table_view</span>엑셀 출력하기
            </button>
          </div>
        </div>

        <!-- 탭 내비게이션 -->
        <div class="c-tab-bar">
          <button class="c-tab-btn is-active" onclick="switchTab(0, this)" title="계약·임대 통계 보기">
            <span class="material-symbols-rounded">trending_up</span>계약·임대
          </button>
          <button class="c-tab-btn" onclick="switchTab(1, this)" title="관리비 통계 보기">
            <span class="material-symbols-rounded">receipt_long</span>관리비
          </button>
          <button class="c-tab-btn" onclick="switchTab(2, this)" title="입주·공실 통계 보기">
            <span class="material-symbols-rounded">apartment</span>입주·공실
          </button>
          <button class="c-tab-btn" onclick="switchTab(3, this)" title="세대 구성 통계 보기">
            <span class="material-symbols-rounded">family_restroom</span>세대 구성
          </button>
        </div>

        <!-- ━━━━━━━━━━ Tab 0: 계약·임대 ━━━━━━━━━━ -->
        <div class="tab-panel is-active" id="tab-0">
          <div class="chart-row-top">
            <div class="chart-card">
              <div class="chart-card-header">
                <div>
                  <div class="chart-card-title">기간별 계약 추이</div>
                  <div class="chart-card-sub">전세·월세 월별 계약 체결 건수</div>
                </div>
                <select class="chart-period-sel" title="조회 기간을 선택하세요">
                  <option value="3m">최근 3개월</option>
                  <option value="6m" selected>최근 6개월</option>
                  <option value="1y">최근 1년</option>
                  <option value="all">전체 기간</option>
                </select>
              </div>
              <div class="chart-wrap h260"><canvas id="c_contractTrend"></canvas></div>
            </div>
            <div class="chart-card">
              <div class="chart-card-header">
                <div>
                  <div class="chart-card-title">지역별 입주 비용 통계</div>
                  <div class="chart-card-sub">단지별 평균 보증금(좌축) · 월세(우축) 비교</div>
                </div>
                <select class="chart-period-sel" title="조회 기간을 선택하세요">
                  <option value="3m">최근 3개월</option>
                  <option value="6m" selected>최근 6개월</option>
                  <option value="1y">최근 1년</option>
                  <option value="all">전체 기간</option>
                </select>
              </div>
              <div class="chart-wrap h260"><canvas id="c_moveCost"></canvas></div>
            </div>
          </div>
          <div class="chart-row-bottom">
            <div class="chart-card">
              <div class="chart-card-header">
                <div>
                  <div class="chart-card-title">단지별 월별 계약 건수 현황</div>
                  <div class="chart-card-sub">각 단지의 계약 체결 건수 월별 추이 (전체 유형 합산)</div>
                </div>
                <select class="chart-period-sel" title="조회 기간을 선택하세요">
                  <option value="3m">최근 3개월</option>
                  <option value="6m" selected>최근 6개월</option>
                  <option value="1y">최근 1년</option>
                  <option value="all">전체 기간</option>
                </select>
              </div>
              <div class="chart-wrap h300"><canvas id="c_contractByComplex"></canvas></div>
            </div>
          </div>
        </div>

        <!-- ━━━━━━━━━━ Tab 1: 관리비 ━━━━━━━━━━ -->
        <div class="tab-panel" id="tab-1">
          <div class="chart-row-top">
            <div class="chart-card">
              <div class="chart-card-header">
                <div>
                  <div class="chart-card-title">지역별 관리비 미납률</div>
                  <div class="chart-card-sub">단지별 관리비 미납 세대 비율 (%) — 10% 초과 시 주의</div>
                </div>
                <select class="chart-period-sel" title="조회 기간을 선택하세요">
                  <option value="this">이번 달</option>
                  <option value="3m" selected>최근 3개월 평균</option>
                  <option value="6m">최근 6개월 평균</option>
                </select>
              </div>
              <div class="chart-wrap h260"><canvas id="c_unpaidRate"></canvas></div>
            </div>
            <div class="chart-card">
              <div class="chart-card-header">
                <div>
                  <div class="chart-card-title">관리비 항목별 구성</div>
                  <div class="chart-card-sub">전체 관리비 항목 비율 (전단지 평균)</div>
                </div>
                <select class="chart-period-sel" title="조회 기간을 선택하세요">
                  <option value="this" selected>이번 달</option>
                  <option value="3m">최근 3개월 평균</option>
                  <option value="6m">최근 6개월 평균</option>
                </select>
              </div>
              <div class="chart-wrap h260"><canvas id="c_feeDist"></canvas></div>
            </div>
          </div>
          <div class="chart-row-bottom">
            <div class="chart-card">
              <div class="chart-card-header">
                <div>
                  <div class="chart-card-title">지역별 유지보수 비용 추이</div>
                  <div class="chart-card-sub">단지별 월 유지보수 지출 비용 (만원)</div>
                </div>
                <select class="chart-period-sel" title="조회 기간을 선택하세요">
                  <option value="3m">최근 3개월</option>
                  <option value="6m" selected>최근 6개월</option>
                  <option value="1y">최근 1년</option>
                  <option value="all">전체 기간</option>
                </select>
              </div>
              <div class="chart-wrap h300"><canvas id="c_maintCost"></canvas></div>
            </div>
          </div>
        </div>

        <!-- ━━━━━━━━━━ Tab 2: 입주·공실 ━━━━━━━━━━ -->
        <div class="tab-panel" id="tab-2">
          <div class="chart-row-top">
            <div class="chart-card">
              <div class="chart-card-header">
                <div>
                  <div class="chart-card-title">지역별 공실률</div>
                  <div class="chart-card-sub">단지별 공실 세대 비율 (%) — 현재 기준</div>
                </div>
                <select class="chart-period-sel" title="조회 기간을 선택하세요">
                  <option value="this" selected>이번 달</option>
                  <option value="3m">최근 3개월 평균</option>
                  <option value="6m">최근 6개월 평균</option>
                </select>
              </div>
              <div class="chart-wrap h260"><canvas id="c_vacancy"></canvas></div>
            </div>
            <div class="chart-card">
              <div class="chart-card-header">
                <div>
                  <div class="chart-card-title">지역별 입주민 수 현황</div>
                  <div class="chart-card-sub">단지별 등록 입주민 수 (명) — 현재 기준</div>
                </div>
                <select class="chart-period-sel" title="조회 기간을 선택하세요">
                  <option value="this" selected>이번 달</option>
                  <option value="3m">최근 3개월 평균</option>
                  <option value="6m">최근 6개월 평균</option>
                </select>
              </div>
              <div class="chart-wrap h260"><canvas id="c_residentCount"></canvas></div>
            </div>
          </div>
          <div class="chart-row-bottom">
            <div class="chart-card">
              <div class="chart-card-header">
                <div>
                  <div class="chart-card-title">지역별 신규 입주 발생률 (월별)</div>
                  <div class="chart-card-sub">단지별 신규 입주민 등록 건수 월별 추이</div>
                </div>
                <select class="chart-period-sel" title="조회 기간을 선택하세요">
                  <option value="3m">최근 3개월</option>
                  <option value="6m" selected>최근 6개월</option>
                  <option value="1y">최근 1년</option>
                  <option value="all">전체 기간</option>
                </select>
              </div>
              <div class="chart-wrap h300"><canvas id="c_residentRate"></canvas></div>
            </div>
          </div>
        </div>

        <!-- ━━━━━━━━━━ Tab 3: 세대 구성 ━━━━━━━━━━ -->
        <div class="tab-panel" id="tab-3">
          <div class="chart-row-top">
            <div class="chart-card">
              <div class="chart-card-header">
                <div>
                  <div class="chart-card-title">세대 구성원 수 통계</div>
                  <div class="chart-card-sub">1인~4인 이상 세대 비율 (전단지 합산)</div>
                </div>
                <select class="chart-period-sel" title="조회 기간을 선택하세요">
                  <option value="this" selected>이번 달</option>
                  <option value="3m">최근 3개월 평균</option>
                  <option value="6m">최근 6개월 평균</option>
                </select>
              </div>
              <div class="chart-wrap h300"><canvas id="c_household"></canvas></div>
            </div>
            <div class="chart-card">
              <div class="chart-card-header">
                <div>
                  <div class="chart-card-title">연령대 분포</div>
                  <div class="chart-card-sub">전체 입주민 연령대 비율 (전단지 합산)</div>
                </div>
                <select class="chart-period-sel" title="조회 기간을 선택하세요">
                  <option value="this" selected>이번 달</option>
                  <option value="3m">최근 3개월 평균</option>
                  <option value="6m">최근 6개월 평균</option>
                </select>
              </div>
              <div class="chart-wrap h300"><canvas id="c_agePie"></canvas></div>
            </div>
          </div>
          <div class="chart-row-bottom">
            <div class="chart-card">
              <div class="chart-card-header">
                <div>
                  <div class="chart-card-title">단지별 연령대 구성 비교</div>
                  <div class="chart-card-sub">각 단지의 연령대별 세대 수 분포</div>
                </div>
                <select class="chart-period-sel" title="조회 기간을 선택하세요">
                  <option value="this" selected>이번 달</option>
                  <option value="3m">최근 3개월 평균</option>
                  <option value="6m">최근 6개월 평균</option>
                </select>
              </div>
              <div class="chart-wrap h300"><canvas id="c_ageDist"></canvas></div>
            </div>
          </div>
        </div>

      </div><!-- /.main-content -->
    </div><!-- /.main-wrap -->

    <script>
      /* ── 탭 전환 ── */
      function switchTab(idx, btn) {
        document.querySelectorAll('.tab-panel').forEach(function(el, i) {
          el.classList.toggle('is-active', i === idx);
        });
        document.querySelectorAll('.c-tab-btn').forEach(function(b) {
          b.classList.remove('is-active');
        });
        btn.classList.add('is-active');
      }

      /* ── 공통 설정 ── */
      const KR = "'Noto Sans KR', sans-serif";
      const P = {
        blue:   '#3b82f6', blueA:   'rgba(59,130,246,0.15)',
        orange: '#f97316', orangeA: 'rgba(249,115,22,0.15)',
        green:  '#16a34a', greenA:  'rgba(22,163,74,0.15)',
        purple: '#8b5cf6', purpleA: 'rgba(139,92,246,0.15)',
        red:    '#ef4444',
        cyan:   '#06b6d4',
        gray:   '#9ca3af',
      };

      const complexes = ['한강 푸르지오', '마포 래미안', '노원 힐스테이트', '송파 파크리오'];
      const mo12 = ['25.05','25.06','25.07','25.08','25.09','25.10','25.11','25.12','26.01','26.02','26.03','26.04'];

      const gridColor = '#f3f4f6';
      const tickFont  = { family: KR, size: 11 };
      const tickColor = '#6b7280';
      const legendLbl = { font: { family: KR, size: 11 }, boxWidth: 11, padding: 12, color: '#374151' };

      /* 애니메이션 비활성화: animation: false 기본 적용 */
      function baseOpts(extra) {
        var defaults = {
          animation: false,
          responsive: true,
          maintainAspectRatio: false,
          plugins: { legend: { labels: legendLbl } },
          scales: {
            x: { grid: { color: gridColor }, ticks: { font: tickFont, color: tickColor } },
            y: { grid: { color: gridColor }, ticks: { font: tickFont, color: tickColor } }
          }
        };
        if (!extra) return defaults;
        if (extra.scales) defaults.scales = extra.scales;
        if (extra.plugins) {
          defaults.plugins = Object.assign({}, defaults.plugins, extra.plugins);
          if (extra.plugins.legend) defaults.plugins.legend = extra.plugins.legend;
        }
        return defaults;
      }

      /* ── 도넛 중앙 텍스트 플러그인 ── */
      Chart.register({
        id: 'doughnutCenter',
        afterDraw: function(chart) {
          if (chart.config.type !== 'doughnut') return;
          var opts = (chart.options.plugins || {}).doughnutCenter;
          if (!opts) return;
          var ctx = chart.ctx;
          var ca = chart.chartArea;
          var cx = (ca.left + ca.right) / 2;
          var cy = (ca.top + ca.bottom) / 2;
          ctx.save();
          ctx.textAlign = 'center';
          ctx.textBaseline = 'middle';
          ctx.fillStyle = '#111827';
          ctx.font = "700 20px 'Noto Sans KR', sans-serif";
          ctx.fillText(opts.text, cx, cy - 10);
          ctx.fillStyle = '#9ca3af';
          ctx.font = "500 12px 'Noto Sans KR', sans-serif";
          ctx.fillText(opts.sub, cx, cy + 12);
          ctx.restore();
        }
      });

      /* ━━━━━━━━━━ Tab 0: 계약·임대 ━━━━━━━━━━ */

      new Chart(document.getElementById('c_contractTrend'), {
        type: 'line',
        data: {
          labels: mo12,
          datasets: [
            { label: '전세', data: [45,52,48,60,55,62,58,70,65,72,68,75], borderColor: P.blue, backgroundColor: P.blueA, borderWidth: 2, tension: 0.4, fill: true, pointRadius: 3, pointHoverRadius: 5 },
            { label: '월세', data: [38,42,40,45,43,50,48,55,52,58,54,61], borderColor: P.orange, backgroundColor: P.orangeA, borderWidth: 2, tension: 0.4, fill: true, pointRadius: 3, pointHoverRadius: 5 }
          ]
        },
        options: baseOpts()
      });

      new Chart(document.getElementById('c_moveCost'), {
        type: 'bar',
        data: {
          labels: complexes,
          datasets: [
            { label: '평균 보증금 (백만원)', data: [285, 220, 185, 310], backgroundColor: P.blue,   borderRadius: 4, yAxisID: 'y' },
            { label: '평균 월세 (만원)',      data: [72,  65,  58,  85],  backgroundColor: P.orange, borderRadius: 4, yAxisID: 'y1' }
          ]
        },
        options: {
          animation: false,
          responsive: true,
          maintainAspectRatio: false,
          plugins: { legend: { labels: legendLbl } },
          scales: {
            x:  { grid: { color: gridColor }, ticks: { font: tickFont, color: tickColor } },
            y:  { type: 'linear', position: 'left',  grid: { color: gridColor }, ticks: { font: tickFont, color: P.blue,   callback: function(v){ return v + '만'; } }, title: { display: true, text: '보증금 (백만원)', font: { family: KR, size: 10 }, color: P.blue } },
            y1: { type: 'linear', position: 'right', grid: { drawOnChartArea: false },  ticks: { font: tickFont, color: P.orange, callback: function(v){ return v + '만'; } }, title: { display: true, text: '월세 (만원)', font: { family: KR, size: 10 }, color: P.orange } }
          }
        }
      });

      new Chart(document.getElementById('c_contractByComplex'), {
        type: 'line',
        data: {
          labels: mo12,
          datasets: [
            { label: '한강 푸르지오',   data: [18,22,19,25,21,27,23,30,26,31,28,33], borderColor: P.blue,   backgroundColor: 'transparent', borderWidth: 2, tension: 0.4, pointRadius: 3, pointHoverRadius: 5 },
            { label: '마포 래미안',     data: [14,16,15,18,16,20,18,22,19,23,20,24], borderColor: P.orange, backgroundColor: 'transparent', borderWidth: 2, tension: 0.4, pointRadius: 3, pointHoverRadius: 5 },
            { label: '노원 힐스테이트', data: [11,13,12,15,13,16,14,18,15,19,16,20], borderColor: P.green,  backgroundColor: 'transparent', borderWidth: 2, tension: 0.4, pointRadius: 3, pointHoverRadius: 5 },
            { label: '송파 파크리오',   data: [22,27,24,32,27,34,30,38,33,40,36,42], borderColor: P.purple, backgroundColor: 'transparent', borderWidth: 2, tension: 0.4, pointRadius: 3, pointHoverRadius: 5 }
          ]
        },
        options: baseOpts({
          scales: {
            x: { grid: { color: gridColor }, ticks: { font: { family: KR, size: 10 }, color: tickColor } },
            y: { grid: { color: gridColor }, ticks: { font: tickFont, color: tickColor } }
          }
        })
      });

      /* ━━━━━━━━━━ Tab 1: 관리비 ━━━━━━━━━━ */

      /* 10% 초과 단지는 단지 고유색 → 빨간색으로 덮어씀 */
      var unpaidData = [5.2, 8.1, 10.4, 4.7];
      var complexColors = [P.blue, P.orange, P.green, P.purple];
      var unpaidColors = unpaidData.map(function(v, i) { return v > 10 ? P.red : complexColors[i]; });
      new Chart(document.getElementById('c_unpaidRate'), {
        type: 'bar',
        data: {
          labels: complexes,
          datasets: [
            {
              type: 'bar',
              label: '미납률 (%)',
              data: unpaidData,
              backgroundColor: unpaidColors,
              borderRadius: 5,
              barPercentage: 0.55,
              order: 1
            },
            {
              type: 'line',
              label: '위험 기준선 (10%)',
              data: [10, 10, 10, 10],
              borderColor: P.red,
              borderWidth: 1.5,
              borderDash: [6, 4],
              pointRadius: 0,
              pointHoverRadius: 0,
              fill: false,
              order: 0
            }
          ]
        },
        options: baseOpts({
          plugins: { legend: { labels: legendLbl } },
          scales: {
            x: { grid: { color: gridColor }, ticks: { font: tickFont, color: tickColor } },
            y: { max: 15, grid: { color: gridColor }, ticks: { font: tickFont, color: tickColor, callback: function(v) { return v + '%'; } } }
          }
        })
      });

      new Chart(document.getElementById('c_feeDist'), {
        type: 'doughnut',
        data: {
          labels: ['공용전기', '난방비', '급수비', '청소비', '경비비', '기타'],
          datasets: [{ data: [22, 28, 12, 15, 18, 5], backgroundColor: [P.blue, P.orange, P.cyan, P.green, P.purple, P.gray], borderWidth: 2, borderColor: '#fff' }]
        },
        options: { animation: false, responsive: true, maintainAspectRatio: false, cutout: '62%', plugins: { legend: { position: 'right', labels: legendLbl } } }
      });

      new Chart(document.getElementById('c_maintCost'), {
        type: 'line',
        data: {
          labels: mo12,
          datasets: [
            { label: '한강 푸르지오',   data: [280,310,295,320,340,305,290,350,330,360,345,380], borderColor: P.blue,   backgroundColor: 'transparent', borderWidth: 2, tension: 0.4, pointRadius: 3 },
            { label: '마포 래미안',     data: [210,225,215,240,255,230,220,260,245,270,258,285], borderColor: P.orange, backgroundColor: 'transparent', borderWidth: 2, tension: 0.4, pointRadius: 3 },
            { label: '노원 힐스테이트', data: [180,190,185,200,215,195,188,220,210,230,218,245], borderColor: P.green,  backgroundColor: 'transparent', borderWidth: 2, tension: 0.4, pointRadius: 3 },
            { label: '송파 파크리오',   data: [350,380,365,400,420,390,370,430,415,445,428,460], borderColor: P.purple, backgroundColor: 'transparent', borderWidth: 2, tension: 0.4, pointRadius: 3 }
          ]
        },
        options: baseOpts({
          scales: {
            x: { grid: { color: gridColor }, ticks: { font: { family: KR, size: 10 }, color: tickColor } },
            y: { grid: { color: gridColor }, ticks: { font: tickFont, color: tickColor, callback: function(v) { return v + '만'; } } }
          }
        })
      });

      /* ━━━━━━━━━━ Tab 2: 입주·공실 ━━━━━━━━━━ */

      new Chart(document.getElementById('c_vacancy'), {
        type: 'bar',
        data: {
          labels: complexes,
          datasets: [{ label: '공실률 (%)', data: [2.4, 4.1, 5.8, 1.9], backgroundColor: [P.blue, P.orange, P.red, P.green], borderRadius: 5, barPercentage: 0.55 }]
        },
        options: baseOpts({
          plugins: { legend: { display: false } },
          scales: {
            x: { grid: { color: gridColor }, ticks: { font: tickFont, color: tickColor } },
            y: { max: 10, grid: { color: gridColor }, ticks: { font: tickFont, color: tickColor, callback: function(v) { return v + '%'; } } }
          }
        })
      });

      new Chart(document.getElementById('c_residentCount'), {
        type: 'bar',
        data: {
          labels: complexes,
          datasets: [{ label: '입주민 수 (명)', data: [1240, 980, 856, 1520], backgroundColor: [P.blue, P.orange, P.green, P.purple], borderRadius: 5, barPercentage: 0.55 }]
        },
        options: baseOpts({ plugins: { legend: { display: false } } })
      });

      new Chart(document.getElementById('c_residentRate'), {
        type: 'line',
        data: {
          labels: mo12,
          datasets: [
            { label: '한강 푸르지오',   data: [12,15,11,18,14,20,16,22,17,24,19,26], borderColor: P.blue,   backgroundColor: 'transparent', borderWidth: 2, tension: 0.4, pointRadius: 3 },
            { label: '마포 래미안',     data: [8, 10,9, 12,11,14,12,16,13,17,14,18], borderColor: P.orange, backgroundColor: 'transparent', borderWidth: 2, tension: 0.4, pointRadius: 3 },
            { label: '노원 힐스테이트', data: [6, 8, 7, 9, 8, 11,9, 12,10,13,11,14], borderColor: P.green,  backgroundColor: 'transparent', borderWidth: 2, tension: 0.4, pointRadius: 3 },
            { label: '송파 파크리오',   data: [15,18,14,22,17,25,20,28,22,30,25,32], borderColor: P.purple, backgroundColor: 'transparent', borderWidth: 2, tension: 0.4, pointRadius: 3 }
          ]
        },
        options: baseOpts({
          scales: {
            x: { grid: { color: gridColor }, ticks: { font: { family: KR, size: 10 }, color: tickColor } },
            y: { grid: { color: gridColor }, ticks: { font: tickFont, color: tickColor } }
          }
        })
      });

      /* ━━━━━━━━━━ Tab 3: 세대 구성 ━━━━━━━━━━ */

      new Chart(document.getElementById('c_household'), {
        type: 'doughnut',
        data: {
          labels: ['1인 세대', '2인 세대', '3인 세대', '4인 이상'],
          datasets: [{ data: [18, 32, 28, 22], backgroundColor: [P.blue, P.orange, P.green, P.purple], borderWidth: 2, borderColor: '#fff' }]
        },
        options: {
          animation: false, responsive: true, maintainAspectRatio: false, cutout: '65%',
          plugins: {
            legend: { position: 'right', labels: legendLbl },
            doughnutCenter: { text: '4,596', sub: '총 세대 수' }
          }
        }
      });

      new Chart(document.getElementById('c_agePie'), {
        type: 'doughnut',
        data: {
          labels: ['20대', '30대', '40대', '50대', '60대 이상'],
          datasets: [{ data: [12, 28, 32, 18, 10], backgroundColor: [P.cyan, P.blue, P.orange, P.purple, P.gray], borderWidth: 2, borderColor: '#fff' }]
        },
        options: {
          animation: false, responsive: true, maintainAspectRatio: false, cutout: '65%',
          plugins: {
            legend: { position: 'right', labels: legendLbl },
            doughnutCenter: { text: '4,596', sub: '총 입주민' }
          }
        }
      });

      new Chart(document.getElementById('c_ageDist'), {
        type: 'bar',
        data: {
          labels: complexes,
          datasets: [
            { label: '20대',      data: [85,  62,  48,  110], backgroundColor: P.cyan,   borderRadius: 2 },
            { label: '30대',      data: [210, 162, 130, 280], backgroundColor: P.blue,   borderRadius: 2 },
            { label: '40대',      data: [280, 210, 175, 360], backgroundColor: P.orange, borderRadius: 2 },
            { label: '50대',      data: [155, 118, 98,  190], backgroundColor: P.purple, borderRadius: 2 },
            { label: '60대 이상', data: [82,  64,  52,  102], backgroundColor: P.gray,  borderRadius: 2 }
          ]
        },
        options: baseOpts({
          scales: {
            x: { stacked: true, grid: { color: gridColor }, ticks: { font: tickFont, color: tickColor } },
            y: { stacked: true, grid: { color: gridColor }, ticks: { font: tickFont, color: tickColor } }
          }
        })
      });
    </script>
    <script>
      function toggleSidebar(){var s=document.getElementById("sidebar");if(s)s.classList.toggle("collapsed");}
      var logoIcon=document.getElementById("logoIcon");
      if(logoIcon){logoIcon.onclick=function(){var s=document.getElementById("sidebar");if(s&&s.classList.contains("collapsed"))toggleSidebar();};}
    </script>
  </body>
</html>
