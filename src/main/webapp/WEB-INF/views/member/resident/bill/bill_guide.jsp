<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
  <meta name="_csrf" content="${_csrf.token}">
  <meta name="_csrf_header" content="${_csrf.headerName}">
  <title>납부안내 – 대덕아파트</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/headerStyle.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebarStyle.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footerStyle.css">

  <style>
    body {font-family: 'Noto Sans KR', sans-serif !important;background: var(--bg);color: var(--text-dark);margin: 0;}
    .material-symbols-outlined { font-family: 'Material Symbols Outlined' !important; }
    .main-shell {display:flex;align-items:stretch;width:100%;min-height:calc(100vh - 114px);margin-top:114px;background:var(--bg);}
    .content-area {flex:1;min-width:0;padding:32px 40px 64px;}
    .page-content-wrap {max-width:1080px;width:100%;margin:0 auto;}
    .breadcrumb {display:flex;align-items:center;gap:6px;font-size:12px;color:var(--text-light);margin-bottom:18px;}
    .breadcrumb a {color:var(--text-light);text-decoration:none;} .breadcrumb .cur {color:var(--green-dark);font-weight:700;}
    .page-title {font-size:22px;font-weight:800;color:var(--text-dark);padding-bottom:14px;border-bottom:2px solid var(--green-dark);margin-bottom:16px;letter-spacing:-.4px;}
    .page-desc {font-size:13px;line-height:1.8;color:var(--text-light);margin-bottom:24px;}
    .hero-card,.card,.panel {background:var(--white);border:1px solid var(--border);border-radius:14px;box-shadow:0 10px 24px rgba(30,60,40,.05);}    
    .hero-card {padding:24px 28px;margin-bottom:20px;background:linear-gradient(135deg,var(--green-dark),#386a4d);color:#fff;}
    .hero-card h2 {font-size:20px;margin:0 0 8px;letter-spacing:-.3px;} .hero-card p {margin:0;line-height:1.8;color:rgba(255,255,255,.82);font-size:13px;}
    .chip-row {display:flex;gap:8px;flex-wrap:wrap;margin-top:14px;} .chip {display:inline-flex;align-items:center;gap:4px;padding:6px 12px;border-radius:999px;font-size:12px;font-weight:700;background:rgba(255,255,255,.18);color:#fff;}
    .stats-grid {display:grid;grid-template-columns:repeat(4,minmax(0,1fr));gap:14px;margin-bottom:24px;} .stat-card {background:#fff;border:1px solid var(--border);border-radius:14px;padding:18px 18px 16px;}
    .stat-label {color:var(--text-light);font-size:12px;margin-bottom:8px;} .stat-value {font-size:24px;font-weight:800;color:var(--green-dark);letter-spacing:-.6px;} .stat-sub {margin-top:6px;font-size:12px;color:var(--text-light);}
    .grid-2 {display:grid;grid-template-columns:1.2fr .8fr;gap:18px;margin-bottom:22px;} .grid-2.equal {grid-template-columns:1fr 1fr;} .grid-3 {display:grid;grid-template-columns:repeat(3,1fr);gap:16px;margin-bottom:22px;}
    .section-hd {display:flex;align-items:center;justify-content:space-between;margin-bottom:14px;padding-bottom:10px;border-bottom:1px solid var(--border);} .section-hd h3 {margin:0;font-size:15px;font-weight:800;color:var(--text-dark);} .section-hd span {font-size:12px;color:var(--text-light);} .card,.panel {padding:20px;margin-bottom:20px;}
    .bullet-list {margin:0;padding-left:18px;color:var(--text-mid);line-height:1.8;font-size:13px;} .bullet-list li + li {margin-top:6px;}
    .data-table {width:100%;border-collapse:collapse;font-size:13px;background:#fff;overflow:hidden;border-radius:12px;table-layout: fixed;} .data-table thead th {background:var(--green-pale);color:var(--text-mid);padding:12px 14px;text-align:center;font-weight:700;border-bottom:1px solid var(--border);} .data-table tbody td {padding:13px 14px;border-bottom:1px solid #edf0eb;color:var(--text-dark);vertical-align:middle;text-align: center;white-space: nowrap;} .data-table tbody tr:last-child td {border-bottom:none;} .mini-table td,.mini-table th {padding:10px 12px !important;}
    /* 납부 정보 상단 표 */
    .label-grid {
      display: grid;
      grid-template-columns: 105px minmax(150px, 1fr) 105px minmax(150px, 1fr);
      width: 100%;
      border: 1px solid var(--border);
      border-radius: 12px;
      overflow: hidden;
      margin-bottom: 18px;
      text-align: center;
      background: #fff;
    }
    .label-grid .th {
      display: flex;
      align-items: center;
      justify-content: center;   /* 제목 가운데 정렬 */
      padding: 12px 8px;
      background: var(--green-pale);
      color: var(--text-mid);
      font-size: 13px;
      font-weight: 700;
      text-align: center;
      white-space: nowrap;       /* 제목 줄바꿈 방지 */
      border-bottom: 1px solid var(--border);
    }
    .label-grid > div:not(.th) {
      display: flex;
      align-items: center;
      padding: 12px 14px;
      color: var(--text-dark);
      font-size: 13px;
      white-space: nowrap;       /* 104동 201호, 날짜 줄바꿈 방지 */
      border-bottom: 1px solid var(--border);
      min-width: 0;
    }
    .label-grid > div:nth-last-child(-n+4) {
      border-bottom: none;
    }
    .form-grid {display:grid;grid-template-columns:160px 1fr;border-top:1px solid var(--border);border-left:1px solid var(--border);overflow:hidden;border-radius:12px;} .form-grid .th,.form-grid .td {padding:14px 16px;border-right:1px solid var(--border);border-bottom:1px solid var(--border);} .form-grid .th {background:var(--green-pale);color:var(--text-mid);font-size:13px;font-weight:700;}
    .fake-input,.fake-select,.fake-textarea {width:100%;border:1px solid #d8ddd4;background:#fff;border-radius:10px;padding:11px 13px;font-size:13px;color:var(--text-dark);box-sizing:border-box;} .fake-textarea {min-height:110px;resize:vertical;}
    .inline-fields {display:flex;gap:10px;flex-wrap:wrap;} .btn-row {display:flex;justify-content:center;gap:10px;margin-top:22px;flex-wrap:wrap;}
    .btn-main,.btn-sub,.btn-danger,.btn-ghost {display:inline-flex;align-items:center;justify-content:center;min-width:120px;padding:12px 18px;border-radius:10px;font-size:13px;font-weight:800;text-decoration:none;border:none;cursor:pointer;box-sizing:border-box;} .btn-main {background:var(--green-dark);color:#fff;} .btn-sub {background:#edf5ef;color:var(--green-dark);} .btn-danger {background:#b64444;color:#fff;} .btn-ghost {background:#fff;color:var(--text-mid);border:1px solid var(--border);}
    .badge {display:inline-flex;align-items:center;padding:4px 10px;border-radius:999px;font-size:11px;font-weight:800;} .badge.ok {background:#ecf7ef;color:#2f7a4d;} .badge.wait {background:#fff5df;color:#9a6b00;} .badge.danger {background:#fbe8e8;color:#a23a3a;} .badge.info {background:#edf4fb;color:#2d6688;}
    .menu-grid {display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:16px;margin-bottom:24px;} .menu-card {background:#fff;border:1px solid var(--border);border-radius:14px;padding:20px;} .menu-card h4 {margin:0 0 8px;font-size:16px;color:var(--text-dark);} .menu-card p {margin:0 0 12px;font-size:13px;color:var(--text-light);line-height:1.7;} .menu-links {display:flex;flex-direction:column;gap:8px;} .menu-links a {text-decoration:none;color:var(--green-dark);font-size:13px;font-weight:700;}
    .seat-grid {display:grid;grid-template-columns:repeat(6,1fr);gap:10px;margin-top:10px;} .room-grid {display:grid;grid-template-columns:repeat(3,1fr);gap:10px;margin-top:10px;} .seat,.room-box {padding:16px 8px;text-align:center;border-radius:12px;font-weight:700;font-size:13px;border:1px solid var(--border);background:#fff;} .seat.available,.room-box.available {background:#f1f8f2;color:#2a6d44;} .seat.busy,.room-box.busy {background:#f8ecec;color:#9f4747;} .seat.selected,.room-box.selected {background:var(--green-dark);color:#fff;}
    .chart-box {height:240px;border:1px dashed #cfd7cf;border-radius:12px;background:linear-gradient(to top,rgba(43,103,78,.08),rgba(43,103,78,.02)),repeating-linear-gradient(to right,transparent 0 72px,rgba(0,0,0,.03) 72px 73px),repeating-linear-gradient(to bottom,transparent 0 47px,rgba(0,0,0,.04) 47px 48px);position:relative;overflow:hidden;} .chart-line {position:absolute;left:22px;right:22px;bottom:26px;top:28px;} .chart-line svg {width:100%;height:100%;}
    .chat-layout {display:grid;grid-template-columns:320px 1fr;gap:18px;} .chat-list,.chat-box {background:#fff;border:1px solid var(--border);border-radius:14px;} .chat-list {padding:16px;} .chat-box {padding:18px;} .chat-room-item {padding:12px 10px;border-radius:10px;cursor:pointer;border:1px solid transparent;} .chat-room-item.active {background:#f4f8f5;border-color:#d8e6db;} .message-stream {display:flex;flex-direction:column;gap:12px;min-height:320px;} .message {max-width:72%;padding:12px 14px;border-radius:14px;font-size:13px;line-height:1.7;} .message.me {align-self:flex-end;background:var(--green-dark);color:#fff;} .message.other {align-self:flex-start;background:#f2f4f0;color:var(--text-dark);}
    .search-row {display:flex;gap:10px;flex-wrap:wrap;margin-bottom:16px;} .search-row .fake-input,.search-row .fake-select {max-width:220px;} .notice-card {padding:18px 20px;border-radius:14px;background:linear-gradient(135deg,#fff8ea,#fff1d5);border:1px solid #f0dfb4;margin-bottom:18px;}
    .process-grid {display:grid;grid-template-columns:repeat(4,1fr);gap:14px;} .process-step {padding:18px 14px;border-radius:14px;border:1px solid var(--border);background:#fff;text-align:center;} .process-step.active {background:#eef8f0;border-color:#b8d9c0;}
    @media (max-width:1200px){.stats-grid,.menu-grid,.grid-3,.room-grid,.process-grid{grid-template-columns:repeat(2,1fr)} .grid-2,.grid-2.equal,.chat-layout{grid-template-columns:1fr} .label-grid{grid-template-columns:140px 1fr}}
    @media (max-width:900px){.main-shell{flex-direction:column}.content-area{padding:24px 18px 48px}.page-content-wrap{max-width:100%}.stats-grid,.menu-grid,.grid-3,.room-grid,.process-grid,.seat-grid{grid-template-columns:1fr}.form-grid{grid-template-columns:120px 1fr}.label-grid{grid-template-columns:120px 1fr}}
    /* =========================
   SweetAlert 결제수단 선택
   ========================= */
    .payment-method-wrap {
      display: flex;
      flex-direction: column;
      gap: 10px;
      margin-top: 16px;
      text-align: left;
    }

    .payment-method-item {
      display: flex;
      align-items: center;
      gap: 12px;
      padding: 15px 16px;
      border: 1px solid #dbe5dd;
      border-radius: 12px;
      background: #ffffff;
      cursor: pointer;
      transition: all 0.2s ease;
    }

    .payment-method-item:hover {
      border-color: #256142;
      background: #f4f8f5;
    }

    .payment-method-item:has(input:checked) {
      border-color: #256142;
      background: #f1f7f3;
      box-shadow: inset 0 0 0 1px #256142;
    }

    .payment-method-item input[type="radio"] {
      accent-color: #256142;
      width: 17px;
      height: 17px;
    }

    .payment-method-title {
      display: block;
      color: #173b2c;
      font-size: 14px;
      font-weight: 700;
    }

    .payment-method-desc {
      display: block;
      margin-top: 3px;
      color: #7b877f;
      font-size: 12px;
    }

    .payment-complete-amount {
      margin: 14px 0 4px;
      color: #173b2c;
      font-size: 27px;
      font-weight: 800;
    }

    .payment-complete-desc {
      color: #6b756e;
      font-size: 13px;
      line-height: 1.6;
    }
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
          <span>›</span>
          <a href="javascript:void(0);">아파트관리비</a>
          <span>›</span>
          <span class="cur">납부안내</span>
        </div>
        <h1 class="page-title">납부안내</h1>
        <p class="page-desc">납부 현황 카드, 상세 납부 내역, 연체 내역, 기타 청구 내역과 즉시 납부하기 버튼을 포함한 납부안내 화면입니다.</p>

        <div id="messageBox" class="notice-card" style="display:none;"></div>

        <section class="panel">
          <div class="section-hd">
            <h3>납부안내 조회</h3>
            <span>세대와 관리년월을 선택해 주세요.</span>
          </div>

          <div class="search-row">
            <select id="myHouseSelect" class="fake-select" onchange="onHouseChange()">
              <option value="">세대 정보 확인 중...</option>
            </select>

            <select id="billYear" class="fake-select"></select>

            <select id="billMonth" class="fake-select">
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

            <button type="button" class="btn-main" onclick="loadPaymentGuide()">조회</button>
          </div>
        </section>

        <section class="stats-grid">
          <div class="stat-card">
            <div class="stat-label">당월 납부대상</div>
            <div class="stat-value" id="statBillAmt">0원</div>
            <div class="stat-sub" id="statBillYm">-</div>
          </div>

          <div class="stat-card">
            <div class="stat-label">납부 기한</div>
            <div class="stat-value" id="statDueDt">-</div>
            <div class="stat-sub" id="statDueText">납부기한 확인</div>
          </div>

          <div class="stat-card">
            <div class="stat-label">연체금</div>
            <div class="stat-value" id="statLateFee">0원</div>
            <div class="stat-sub" id="statLateText">미발생</div>
          </div>

          <div class="stat-card">
            <div class="stat-label">납부 상태</div>
            <div class="stat-value" id="statPayStatus">-</div>
            <div class="stat-sub" id="statReceipt">영수증 조회</div>
          </div>
        </section>

        <section class="grid-2">
          <div class="panel">
            <div class="section-hd">
              <h3>상세 납부 내역</h3>
              <span>관리비 상세 항목</span>
            </div>

            <table class="data-table mini-table">
              <thead>
              <tr>
                <th>항목</th>
                <th>금액</th>
              </tr>
              </thead>
              <tbody id="detailTbody">
              <tr>
                <td colspan="2">조회된 납부안내가 없습니다.</td>
              </tr>
              </tbody>
            </table>
          </div>

          <div class="panel">
            <div class="section-hd">
              <h3>납부 정보</h3>
              <span>고지서 기준</span>
            </div>

            <div class="label-grid">
              <div class="th">고지서 번호</div>
              <div id="infoBillNo">-</div>
              <div class="th">세대</div>
              <div id="infoHouse">-</div>

              <div class="th">고지월</div>
              <div id="infoBillYm">-</div>
              <div class="th">고지일</div>
              <div id="infoPblancDt">-</div>

              <div class="th">납부기한</div>
              <div id="infoDueDt">-</div>
              <div class="th">납부상태</div>
              <div id="infoPayStatus">-</div>

              <div class="th">청구금액</div>
              <div id="infoBillAmt">0원</div>
              <div class="th">납부금액</div>
              <div id="infoPayAmt">0원</div>
            </div>

            <table class="data-table mini-table">
              <thead>
              <tr>
                <th>구분</th>
                <th>금액</th>
                <th>상태</th>
              </tr>
              </thead>
              <tbody>
              <tr>
                <td>연체료</td>
                <td id="lateFeeAmt">0원</td>
                <td><span class="badge ok" id="lateFeeBadge">없음</span></td>
              </tr>
              <tr>
                <td>납부상태</td>
                <td id="payStatusAmt">0원</td>
                <td><span class="badge info" id="payStatusBadge">-</span></td>
              </tr>
              </tbody>
            </table>
          </div>
        </section>

        <div class="btn-row">
          <a href="javascript:void(0);" class="btn-main" onclick="goPayment()">즉시 납부하기</a>
          <%--<a href="javascript:void(0);" class="btn-sub" onclick="downloadStatement()">상세 명세서 PDF 다운로드</a>--%>
          <a href="${pageContext.request.contextPath}/resident/bill/receipt/${aptCmplexNo}" class="btn-ghost">관리비 영수증 조회</a>
        </div>

      </div>
    </main>
  </div>
  <%@ include file="/WEB-INF/views/include/apt_footerLayout.jsp" %>
  <script>
    const contextPath = '${pageContext.request.contextPath}';
    const billNoFromPath = '${billNo}';

    let myHouseList = [];
    let selectedHouse = null;
    let currentBill = null;

    document.addEventListener('DOMContentLoaded', async function () {
      initSearchDate();

      await loadMyHouseList();

      /*
       * URL에 billNo가 있으면 해당 고지서를 바로 조회한다.
       */
      if (billNoFromPath && billNoFromPath !== 'null' && billNoFromPath !== '') {
        await loadPaymentGuideByBillNo(billNoFromPath);
        return;
      }

      /*
       * 일반 메뉴 진입 시:
       * 납부안내 상세는 바로 조회하지 않고,
       * 연도/월 select만 실제 부과월 기준으로 정리한다.
       */
      if (selectedHouse && selectedHouse.hoNo) {
        await loadAvailableGuideMonthsOnly();
      }

      resetGuideView();

      /*
       * 연도 변경 시 해당 연도의 부과월만 다시 표시
       */
      document.getElementById('billYear').addEventListener('change', async function () {
        await loadAvailableGuideMonthsOnly();
        resetGuideView();
      });

    });

    function initSearchDate() {
      const yearSelect = document.getElementById('billYear');
      const monthSelect = document.getElementById('billMonth');

      yearSelect.innerHTML = '';

      /*
       * 프로젝트 테스트 데이터 기준:
       * 납부안내 화면에서는 2025년, 2026년만 선택 가능
       */
      const availableYears = [2025, 2026];

      availableYears.forEach(function (year) {
        const option = document.createElement('option');
        option.value = String(year);
        option.textContent = year + '년';
        yearSelect.appendChild(option);
      });

      yearSelect.value = '2026';

      /*
       * 월은 실제 부과된 월 목록 조회 후 다시 그린다.
       */
      monthSelect.innerHTML = '';

      const option = document.createElement('option');
      option.value = '';
      option.textContent = '부과된 월 없음';

      monthSelect.appendChild(option);
      monthSelect.disabled = true;
    }

    function getBillYm() {
      const year = document.getElementById('billYear').value;
      const month = document.getElementById('billMonth').value;
      return String(year) + String(month).padStart(2, '0');
    }

    async function loadMyHouseList() {
      try {
        const response = await fetch(contextPath + '/resident/bill/my-houses');

        if (!response.ok) {
          showMessage('세대 목록 조회 중 오류가 발생했습니다. 상태코드: ' + response.status);
          renderHouseSelect([]);
          return;
        }

        const result = await response.json();

        if (!result.success) {
          showMessage(result.message || '세대 정보를 찾을 수 없습니다.');
          renderHouseSelect([]);
          return;
        }

        myHouseList = result.houseList || [];
        renderHouseSelect(myHouseList);

      } catch (e) {
        console.error(e);
        showMessage('세대 목록 조회 중 오류가 발생했습니다.');
        renderHouseSelect([]);
      }
    }

    function renderHouseSelect(list) {
      const select = document.getElementById('myHouseSelect');
      select.innerHTML = '';

      if (!list || list.length === 0) {
        select.innerHTML = '<option value="">세대 정보 없음</option>';
        selectedHouse = null;
        return;
      }

      select.appendChild(new Option('세대 선택', ''));

      list.forEach(function (house) {
        const option = document.createElement('option');
        option.value = house.hoNo;
        option.textContent = house.displayDongHo || house.hoNo;
        select.appendChild(option);
      });

      if (list.length === 1) {
        select.value = list[0].hoNo;
        selectedHouse = list[0];
      }

      if (currentBill && currentBill.hoNo) {
        select.value = currentBill.hoNo;

        selectedHouse = list.find(function (house) {
          return house.hoNo === currentBill.hoNo;
        }) || selectedHouse;
      }
    }

    async function onHouseChange() {
      const hoNo = document.getElementById('myHouseSelect').value;

      selectedHouse = myHouseList.find(function (house) {
        return house.hoNo === hoNo;
      }) || null;

      if (selectedHouse && selectedHouse.hoNo) {
        await loadAvailableGuideMonthsOnly();
      }

      resetGuideView();
    }

    /**
     * 납부안내 페이지 진입/연도변경/세대변경 시
     * 해당 세대의 실제 부과된 월만 월 select에 표시한다.
     *
     * 상세 납부안내는 조회하지 않는다.
     */
    async function loadAvailableGuideMonthsOnly() {
      const billYear = document.getElementById('billYear').value;

      if (!selectedHouse || !selectedHouse.hoNo) {
        renderAvailableMonthOptions([], null);
        return;
      }

      try {
        const url =
                contextPath
                + '/resident/bill/list'
                + '?hoNo=' + encodeURIComponent(selectedHouse.hoNo)
                + '&billYear=' + encodeURIComponent(billYear);

        const response = await fetch(url);

        if (!response.ok) {
          console.error('부과월 목록 조회 실패:', response.status);
          renderAvailableMonthOptions([], null);
          return;
        }

        const result = await response.json();

        if (!result.success) {
          console.error('부과월 목록 조회 실패:', result.message);
          renderAvailableMonthOptions([], null);
          return;
        }

        const billList = result.list || [];

        /*
         * 현재 선택된 월이 부과월이면 유지,
         * 아니면 가장 최신 부과월을 선택한다.
         */
        renderAvailableMonthOptions(billList, getBillYm());

      } catch (e) {
        console.error('부과월 목록 조회 오류:', e);
        renderAvailableMonthOptions([], null);
      }
    }

    /**
     * 실제 부과된 월만 월 select에 표시한다.
     *
     * @param billList 해당 연도 고지서 목록
     * @param selectedBillYm 현재 선택하려는 관리년월 ex) 202605
     * @return 최종 선택된 관리년월 ex) 202605
     */
    function renderAvailableMonthOptions(billList, selectedBillYm) {
      const monthSelect = document.getElementById('billMonth');
      const yearSelect = document.getElementById('billYear');

      if (!monthSelect || !yearSelect) {
        return selectedBillYm;
      }

      const selectedYear = yearSelect.value;
      const monthSet = new Set();

      (billList || []).forEach(function (bill) {
        if (!bill.billYm || String(bill.billYm).length !== 6) {
          return;
        }

        const billYm = String(bill.billYm);

        if (billYm.substring(0, 4) === selectedYear) {
          monthSet.add(billYm.substring(4, 6));
        }
      });

      const monthList = Array.from(monthSet).sort(function (a, b) {
        return Number(a) - Number(b);
      });

      monthSelect.innerHTML = '';

      if (monthList.length === 0) {
        const option = document.createElement('option');
        option.value = '';
        option.textContent = '부과된 월 없음';

        monthSelect.appendChild(option);
        monthSelect.disabled = true;

        return null;
      }

      monthSelect.disabled = false;

      const selectedMm =
              selectedBillYm && String(selectedBillYm).length === 6
                      ? String(selectedBillYm).substring(4, 6)
                      : null;

      /*
       * 기존 선택월이 실제 부과월이면 그대로 유지,
       * 없으면 가장 최신 부과월로 선택
       */
      const finalMm = monthSet.has(selectedMm)
              ? selectedMm
              : monthList[monthList.length - 1];

      monthList.forEach(function (mm) {
        const option = document.createElement('option');

        option.value = Number(mm);
        option.textContent = Number(mm) + '월';

        if (mm === finalMm) {
          option.selected = true;
        }

        monthSelect.appendChild(option);
      });

      return selectedYear + finalMm;
    }

    async function loadPaymentGuide() {
      hideMessage();

      if (!selectedHouse || !selectedHouse.hoNo) {
        showMessage('조회할 세대를 선택해 주세요.');
        return;
      }

      const billYm = getBillYm();

      if (!billYm || billYm.length !== 6 || document.getElementById('billMonth').disabled) {
        resetGuideView();
        showMessage('조회 가능한 관리비 고지월이 없습니다.');
        return;
      }

      try {
        const listUrl = contextPath
                + '/resident/bill/list?hoNo=' + encodeURIComponent(selectedHouse.hoNo)
                + '&billYm=' + encodeURIComponent(billYm);

        const listResponse = await fetch(listUrl);

        if (!listResponse.ok) {
          showMessage('납부안내 조회 중 오류가 발생했습니다. 상태코드: ' + listResponse.status);
          return;
        }

        const listResult = await listResponse.json();

        if (!listResult.success) {
          showMessage(listResult.message || '납부안내 조회에 실패했습니다.');
          return;
        }

        const list = listResult.list || [];

        if (list.length === 0) {
          resetGuideView();
          showMessage(formatBillYm(billYm) + ' 납부안내 내역이 없습니다.');
          return;
        }

        const billNo = list[0].billNo;

        const detailResponse = await fetch(contextPath + '/resident/bill/detail/' + encodeURIComponent(billNo));

        if (!detailResponse.ok) {
          showMessage('납부 상세 조회 중 오류가 발생했습니다. 상태코드: ' + detailResponse.status);
          return;
        }

        const detailResult = await detailResponse.json();

        if (!detailResult.success) {
          showMessage(detailResult.message || '납부 상세 조회에 실패했습니다.');
          return;
        }

        currentBill = detailResult.bill;
        renderPaymentGuide(currentBill);

      } catch (e) {
        console.error(e);
        showMessage('납부안내 조회 중 오류가 발생했습니다.');
      }
    }

    function renderPaymentGuide(bill) {
      const detailList = bill.detailList || [];

      const billAmt = Number(bill.billTotAmt || 0);
      const payAmt = Number(bill.pymtAmt || 0);
      const lateFeeAmt = Number(bill.lateFeeAmt || 0);

      document.getElementById('statBillAmt').textContent = formatNumber(billAmt) + '원';
      document.getElementById('statBillYm').textContent = formatBillYm(bill.billYm);

      document.getElementById('statDueDt').textContent = formatShortDate(bill.dueDt);
      document.getElementById('statDueText').textContent = getDueText(bill);

      document.getElementById('statLateFee').textContent = formatNumber(lateFeeAmt) + '원';
      document.getElementById('statLateText').textContent = lateFeeAmt > 0 ? '연체금 발생' : '미발생';

      document.getElementById('statPayStatus').textContent = bill.pymtSttsNm || bill.pymtSttsCd || '-';
      document.getElementById('statReceipt').textContent = bill.pymtSttsCd === 'PAID' ? '영수증 조회 가능' : '납부 후 조회 가능';

      document.getElementById('infoBillNo').textContent = bill.billNo || '-';
      document.getElementById('infoHouse').textContent = bill.displayDongHo || selectedHouse.displayDongHo || '-';
      document.getElementById('infoBillYm').textContent = formatBillYm(bill.billYm);
      document.getElementById('infoPblancDt').textContent = formatDate(bill.billPblancDt);
      document.getElementById('infoDueDt').textContent = formatDate(bill.dueDt);
      document.getElementById('infoPayStatus').textContent = bill.pymtSttsNm || bill.pymtSttsCd || '-';
      document.getElementById('infoBillAmt').textContent = formatNumber(billAmt) + '원';
      document.getElementById('infoPayAmt').textContent = formatNumber(payAmt) + '원';

      document.getElementById('lateFeeAmt').textContent = formatNumber(lateFeeAmt) + '원';
      document.getElementById('lateFeeBadge').textContent = lateFeeAmt > 0 ? '발생' : '없음';
      document.getElementById('lateFeeBadge').className = lateFeeAmt > 0 ? 'badge danger' : 'badge ok';

      document.getElementById('payStatusAmt').textContent =
              bill.pymtSttsCd === 'PAID' ? formatNumber(payAmt) + '원' : formatNumber(billAmt) + '원';

      document.getElementById('payStatusBadge').textContent = bill.pymtSttsNm || bill.pymtSttsCd || '-';
      document.getElementById('payStatusBadge').className = getStatusBadgeClass(bill.pymtSttsCd);

      renderDetailList(detailList);
    }

    function renderDetailList(detailList) {
      const tbody = document.getElementById('detailTbody');
      tbody.innerHTML = '';

      if (!detailList || detailList.length === 0) {
        tbody.innerHTML = '<tr><td colspan="2">상세 납부 내역이 없습니다.</td></tr>';
        return;
      }

      detailList.forEach(function (item) {
        const tr = document.createElement('tr');

        tr.innerHTML =
                '<td>' + escapeHtml(item.billItemNm || '-') + '</td>' +
                '<td>' + formatNumber(item.billItemAmt) + '원</td>';

        tbody.appendChild(tr);
      });
    }

    function resetGuideView() {
      currentBill = null;

      document.getElementById('statBillAmt').textContent = '0원';
      document.getElementById('statBillYm').textContent = '-';
      document.getElementById('statDueDt').textContent = '-';
      document.getElementById('statDueText').textContent = '납부기한 확인';
      document.getElementById('statLateFee').textContent = '0원';
      document.getElementById('statLateText').textContent = '미발생';
      document.getElementById('statPayStatus').textContent = '-';
      document.getElementById('statReceipt').textContent = '영수증 조회';

      document.getElementById('infoBillNo').textContent = '-';
      document.getElementById('infoHouse').textContent = '-';
      document.getElementById('infoBillYm').textContent = '-';
      document.getElementById('infoPblancDt').textContent = '-';
      document.getElementById('infoDueDt').textContent = '-';
      document.getElementById('infoPayStatus').textContent = '-';
      document.getElementById('infoBillAmt').textContent = '0원';
      document.getElementById('infoPayAmt').textContent = '0원';

      document.getElementById('lateFeeAmt').textContent = '0원';
      document.getElementById('lateFeeBadge').textContent = '없음';
      document.getElementById('lateFeeBadge').className = 'badge ok';

      document.getElementById('payStatusAmt').textContent = '0원';
      document.getElementById('payStatusBadge').textContent = '-';
      document.getElementById('payStatusBadge').className = 'badge info';

      document.getElementById('detailTbody').innerHTML =
              '<tr><td colspan="2">조회된 납부안내가 없습니다.</td></tr>';
    }

    function getDueText(bill) {
      if (!bill || !bill.dueDt) {
        return '납부기한 확인';
      }

      if (bill.pymtSttsCd === 'PAID') {
        return '납부완료';
      }

      const today = new Date();
      const due = new Date(bill.dueDt);

      today.setHours(0, 0, 0, 0);
      due.setHours(0, 0, 0, 0);

      const diffDays = Math.ceil((due - today) / (1000 * 60 * 60 * 24));

      if (diffDays < 0) {
        return '납부기한 경과';
      }

      if (diffDays === 0) {
        return '오늘까지 납부';
      }

      return diffDays + '일 남음';
    }

    function getStatusBadgeClass(code) {
      if (code === 'PAID') {
        return 'badge ok';
      }

      if (code === 'OVERDUE') {
        return 'badge danger';
      }

      if (code === 'READY' || code === 'UNPAID') {
        return 'badge wait';
      }

      return 'badge info';
    }

    const portOneImpCode = '${portOneImpCode}';
    const portOneChannelKey = '${portOneChannelKey}';

    /**
     * 즉시 납부하기
     * - SweetAlert2에서 카드결제 / 계좌이체를 선택한다.
     */
    async function goPayment() {

      if (!currentBill || !currentBill.billNo) {
        await Swal.fire({
          icon: 'warning',
          title: '고지서를 선택해 주세요',
          text: '납부할 관리비 고지서를 먼저 조회해 주세요.',
          confirmButtonText: '확인',
          confirmButtonColor: '#256142'
        });
        return;
      }

      if (currentBill.pymtSttsCd === 'PAID') {
        await Swal.fire({
          icon: 'info',
          title: '납부 완료된 관리비입니다',
          text: '이미 결제가 완료된 고지서입니다.',
          confirmButtonText: '확인',
          confirmButtonColor: '#256142'
        });
        return;
      }

      const result = await Swal.fire({
        title: '결제수단 선택',
        html:
                '<div class="payment-method-wrap">' +
                '  <label class="payment-method-item">' +
                '    <input type="radio" name="paymentMethod" value="CRD" checked>' +
                '    <span>' +
                '      <span class="payment-method-title">신용카드 결제</span>' +
                '      <span class="payment-method-desc">신용카드 또는 체크카드로 바로 납부합니다.</span>' +
                '    </span>' +
                '  </label>' +
                '  <label class="payment-method-item">' +
                '    <input type="radio" name="paymentMethod" value="TRN">' +
                '    <span>' +
                '      <span class="payment-method-title">실시간 계좌이체</span>' +
                '      <span class="payment-method-desc">은행 계좌에서 관리비를 즉시 이체합니다.</span>' +
                '    </span>' +
                '  </label>' +
                '</div>',
        showCancelButton: true,
        confirmButtonText: '결제 진행',
        cancelButtonText: '취소',
        confirmButtonColor: '#256142',
        cancelButtonColor: '#8d9690',
        reverseButtons: true,
        focusConfirm: false,
        preConfirm: function () {
          const checked =
                  document.querySelector('input[name="paymentMethod"]:checked');

          if (!checked) {
            Swal.showValidationMessage('결제수단을 선택해 주세요.');
            return false;
          }

          return checked.value;
        }
      });

      if (!result.isConfirmed) {
        return;
      }

      await requestResidentPayment(result.value);
    }

    /**
     * 결제 요청 생성 → PortOne 결제창 호출 → 서버 검증 → 완료 알림
     *
     * @param payMthdCd CRD: 카드결제, TRN: 실시간 계좌이체
     */
    async function requestResidentPayment(payMthdCd) {

      const csrfToken =
              document.querySelector('meta[name="_csrf"]').getAttribute('content');

      const csrfHeader =
              document.querySelector('meta[name="_csrf_header"]').getAttribute('content');

      let prepareResult = null;

      try {
        /* =========================
           1. 결제 요청 생성
           ========================= */
        Swal.fire({
          title: '결제 준비 중입니다',
          text: '잠시만 기다려 주세요.',
          allowOutsideClick: false,
          allowEscapeKey: false,
          didOpen: function () {
            Swal.showLoading();
          }
        });

        const prepareResponse = await fetch(
                contextPath + '/resident/payment/prepare',
                {
                  method: 'POST',
                  headers: {
                    'Content-Type': 'application/json',
                    [csrfHeader]: csrfToken
                  },
                  body: JSON.stringify({
                    billNo: currentBill.billNo,
                    payMthdCd: payMthdCd
                  })
                }
        );

        prepareResult = await prepareResponse.json();

        if (!prepareResult.success) {
          await Swal.fire({
            icon: 'error',
            title: '결제 요청 실패',
            text: prepareResult.message || '결제 요청 생성에 실패했습니다.',
            confirmButtonText: '확인',
            confirmButtonColor: '#256142'
          });
          return;
        }

        console.log('prepareResult =', prepareResult);

        const IMP = window.IMP;

        if (!IMP) {
          await cancelPaymentRequest(
                  prepareResult,
                  'PortOne 결제 모듈을 불러오지 못했습니다.'
          );

          await Swal.fire({
            icon: 'error',
            title: '결제 모듈 오류',
            text: 'PortOne 결제 모듈을 불러오지 못했습니다.',
            confirmButtonText: '확인',
            confirmButtonColor: '#256142'
          });
          return;
        }

        if (!portOneImpCode || !portOneChannelKey) {
          await cancelPaymentRequest(
                  prepareResult,
                  'PortOne 결제 설정값이 없습니다.'
          );

          await Swal.fire({
            icon: 'error',
            title: '결제 설정 오류',
            text: 'PortOne 결제 설정값을 확인할 수 없습니다.',
            confirmButtonText: '확인',
            confirmButtonColor: '#256142'
          });
          return;
        }

        Swal.close();

        /* =========================
           2. PortOne 결제창 호출
           ========================= */
        IMP.init(portOneImpCode);

        IMP.request_pay({
          channelKey: portOneChannelKey,
          pay_method: prepareResult.portOnePayMethod,
          merchant_uid: prepareResult.ordId,
          name: formatBillYm(prepareResult.billYm) + ' 아파트 관리비',
          amount: Number(prepareResult.payAmt),

          /*
           * 추후 로그인 사용자 정보로 변경 가능
           */
          buyer_name: '입주민',
          buyer_tel: '010-0000-0000',

          company: '우리집맵핑',
          language: 'ko'
        }, async function (rsp) {

          console.log('PortOne response =', rsp);

          /* =========================
             3. 결제창 취소 또는 결제 실패
             ========================= */
          if (!rsp.success) {

            await cancelPaymentRequest(
                    prepareResult,
                    rsp.error_msg || '결제가 취소되었거나 실패했습니다.'
            );

            await Swal.fire({
              icon: 'warning',
              title: '결제가 완료되지 않았습니다',
              text: rsp.error_msg || '결제가 취소되었거나 실패했습니다.',
              confirmButtonText: '확인',
              confirmButtonColor: '#256142'
            });

            return;
          }

          /* =========================
             4. 결제 성공 후 서버 검증
             ========================= */
          Swal.fire({
            title: '결제 확인 중입니다',
            text: '결제 결과를 확인하고 있습니다.',
            allowOutsideClick: false,
            allowEscapeKey: false,
            didOpen: function () {
              Swal.showLoading();
            }
          });

          const completeResponse = await fetch(
                  contextPath + '/resident/payment/complete',
                  {
                    method: 'POST',
                    headers: {
                      'Content-Type': 'application/json',
                      [csrfHeader]: csrfToken
                    },
                    body: JSON.stringify({
                      impUid: rsp.imp_uid,
                      ordId: rsp.merchant_uid
                    })
                  }
          );

          const completeResult = await completeResponse.json();

          console.log('completeResult =', completeResult);

          if (!completeResult.success) {
            /*
             * 주의:
             * PortOne 결제 자체는 이미 성공했을 수 있으므로
             * 여기서는 PAYMENT를 CANCEL로 변경하면 안 된다.
             * complete API 재처리로 복구해야 한다.
             */
            await Swal.fire({
              icon: 'warning',
              title: '결제 확인이 필요합니다',
              html:
                      '결제는 승인되었으나 시스템 반영 중 문제가 발생했습니다.<br>' +
                      '관리자에게 문의하거나 결제내역을 다시 확인해 주세요.<br><br>' +
                      '<small>' +
                      escapeHtml(completeResult.message || '') +
                      '</small>',
              confirmButtonText: '확인',
              confirmButtonColor: '#256142'
            });

            return;
          }

          /* =========================
             5. 결제 완료 SweetAlert
             ========================= */
          await Swal.fire({
            icon: 'success',
            title: '관리비 납부가 완료되었습니다',
            html:
                    '<div class="payment-complete-amount">' +
                    formatNumber(completeResult.payAmt) + '원' +
                    '</div>' +
                    '<div class="payment-complete-desc">' +
                    formatBillYm(currentBill.billYm) + ' 관리비 납부가 정상적으로 처리되었습니다.<br>' +
                    '결제수단 : ' + getPaymentMethodName(payMthdCd) +
                    '</div>',
            confirmButtonText: '확인',
            confirmButtonColor: '#256142',
            allowOutsideClick: false
          });

          /*
           * 결제 완료 후 현재 고지서 정보 다시 조회
           * 기존 JSP에 사용 중인 조회 함수명에 맞춰 사용한다.
           */
          await reloadCurrentPaymentGuide();

        });

      } catch (error) {
        console.error('결제 처리 오류 =', error);

        /*
         * PortOne 결제창이 열리기 전에 발생한 예외이고
         * prepareResult가 있다면 결제요청을 취소 처리한다.
         */
        if (prepareResult && prepareResult.ordId) {
          await cancelPaymentRequest(
                  prepareResult,
                  '결제 처리 중 오류가 발생했습니다.'
          );
        }

        await Swal.fire({
          icon: 'error',
          title: '결제 처리 오류',
          text: '결제 처리 중 오류가 발생했습니다.',
          confirmButtonText: '확인',
          confirmButtonColor: '#256142'
        });
      }
    }

    /**
     * 결제수단 화면 표시명
     */
    function getPaymentMethodName(payMthdCd) {
      if (payMthdCd === 'CRD') {
        return '신용카드';
      }

      if (payMthdCd === 'TRN') {
        return '실시간 계좌이체';
      }

      return '-';
    }


    /**
     * 결제창 취소 또는 실패 시 PAYMENT 요청 상태를 CANCEL로 변경
     */
    async function cancelPaymentRequest(prepareResult, reason) {

      const csrfToken =
              document.querySelector('meta[name="_csrf"]').getAttribute('content');

      const csrfHeader =
              document.querySelector('meta[name="_csrf_header"]').getAttribute('content');

      try {
        const response = await fetch(
                contextPath + '/resident/payment/cancel',
                {
                  method: 'POST',
                  headers: {
                    'Content-Type': 'application/json',
                    [csrfHeader]: csrfToken
                  },
                  body: JSON.stringify({
                    pymtNo: prepareResult.pymtNo,
                    ordId: prepareResult.ordId,
                    failRsnCn: reason
                  })
                }
        );

        const result = await response.json();
        console.log('cancelPaymentResult =', result);

      } catch (error) {
        console.error('결제 취소 상태 반영 실패 =', error);
      }
    }


    /**
     * 결제완료 후 납부안내를 다시 조회한다.
     *
     * 기존 화면 함수명이 loadPaymentGuide()라면 그대로 사용한다.
     * 다른 함수명을 사용하고 있다면 해당 함수 호출로 바꿔준다.
     */
    async function reloadCurrentPaymentGuide() {

      if (typeof loadPaymentGuide === 'function') {
        await loadPaymentGuide();
        return;
      }

      /*
       * 상세조회 함수명이 다른 경우를 대비한 보조 처리
       */
      if (currentBill && currentBill.billNo
              && typeof loadPaymentGuideByBillNo === 'function') {
        await loadPaymentGuideByBillNo(currentBill.billNo);
        return;
      }

      location.reload();
    }

    function downloadStatement() {
      if (!currentBill) {
        showMessage('명세서를 다운로드할 고지서를 먼저 조회해 주세요.');
        return;
      }

      alert('PDF 다운로드 기능은 추후 연결하면 됩니다. 고지서 번호: ' + currentBill.billNo);
    }

    function showMessage(message) {
      const box = document.getElementById('messageBox');
      box.style.display = 'block';
      box.textContent = message;
    }

    function hideMessage() {
      const box = document.getElementById('messageBox');
      box.style.display = 'none';
      box.textContent = '';
    }

    function formatNumber(value) {
      const num = Number(value || 0);

      if (isNaN(num)) {
        return '0';
      }

      return num.toLocaleString();
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

    function formatShortDate(value) {
      if (!value) {
        return '-';
      }

      const date = new Date(value);

      if (isNaN(date.getTime())) {
        return value;
      }

      return String(date.getMonth() + 1).padStart(2, '0') + '/'
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

    async function loadPaymentGuideByBillNo(billNo) {
      hideMessage();

      try {
        const detailResponse = await fetch(
                contextPath + '/resident/bill/detail/' + encodeURIComponent(billNo)
        );

        if (!detailResponse.ok) {
          showMessage('납부 상세 조회 중 오류가 발생했습니다. 상태코드: ' + detailResponse.status);
          return;
        }

        const detailResult = await detailResponse.json();

        if (!detailResult.success) {
          showMessage(detailResult.message || '납부 상세 조회에 실패했습니다.');
          return;
        }

        currentBill = detailResult.bill;

        // 상세 화면 렌더링
        renderPaymentGuide(currentBill);

        // 조회 조건 영역도 상세 고지서 기준으로 맞춰주기
        syncSearchConditionByBill(currentBill);

      } catch (e) {
        console.error(e);
        showMessage('납부 상세 조회 중 오류가 발생했습니다.');
      }
    }

    function syncSearchConditionByBill(bill) {
      if (!bill) {
        return;
      }

      // 연월 select 맞추기
      if (bill.billYm && String(bill.billYm).length === 6) {
        const year = String(bill.billYm).substring(0, 4);
        const month = Number(String(bill.billYm).substring(4, 6));

        document.getElementById('billYear').value = year;
        
        const monthSelect = document.getElementById('billMonth');
        monthSelect.innerHTML = '';

        const option = document.createElement('option');
        option.value = month;
        option.textContent = month + '월';
        option.selected = true;

        monthSelect.appendChild(option);
        monthSelect.disabled = false;
      }

      // 세대 select는 loadMyHouseList()가 비동기라 아직 options가 없을 수 있음
      // 그래서 hoNo 값만 보관했다가 세대 목록 렌더링 후에도 맞춰줌
      if (bill.hoNo) {
        const select = document.getElementById('myHouseSelect');

        if (select) {
          select.value = bill.hoNo;
        }

        selectedHouse = {
          hoNo: bill.hoNo,
          dongNm: bill.dongNm,
          ho: bill.ho,
          displayDongHo: bill.displayDongHo
        };
      }
    }
  </script>
  <!-- SweetAlert2 -->
  <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
  <!-- PortOne V1 JavaScript SDK -->
  <script src="https://cdn.iamport.kr/v1/iamport.js"></script>
</body>
</html>
