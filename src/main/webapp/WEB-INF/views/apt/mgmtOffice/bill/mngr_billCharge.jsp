<%--
  Created by IntelliJ IDEA.
  User: PC-27
  Date: 2026-05-15
  Time: 오후 7:12
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">

  <meta name="_csrf" content="${_csrf.token}">
  <meta name="_csrf_header" content="${_csrf.headerName}">

  <title>관리비 부과</title>

  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
  <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet" />

  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/office-layout.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/manager-common.css">

  <style>
    .charge-page .charge-form-row {
      display: flex;
      flex-wrap: wrap;
      gap: 10px;
      align-items: center;
    }

    .charge-page .charge-form-row label {
      font-weight: 700;
      margin-right: 4px;
      color: var(--text-primary);
    }

    .charge-page input,
    .charge-page select {
      height: 36px;
      border: 1px solid var(--border);
      border-radius: var(--r-sm);
      padding: 0 10px;
      font-family: inherit;
      font-size: 13px;
      background: #fff;
    }

    .charge-page input[type="number"] {
      width: 130px;
    }

    .charge-page input[type="date"] {
      width: 160px;
    }

    .charge-summary-grid {
      display: grid;
      grid-template-columns: repeat(4, minmax(0, 1fr));
      gap: 14px;
      margin-bottom: 20px;
    }

    .charge-summary-card {
      background: #fff;
      border: 1px solid var(--border);
      border-radius: var(--r-md);
      padding: 16px 18px;
      min-height: 96px;
    }

    .charge-summary-label {
      font-size: 12px;
      color: var(--text-tertiary);
      font-weight: 700;
      margin-bottom: 8px;
    }

    .charge-summary-value {
      font-size: 24px;
      font-weight: 800;
      color: var(--text-primary);
      line-height: 1.2;
    }

    .charge-summary-desc {
      margin-top: 6px;
      font-size: 12px;
      color: var(--text-tertiary);
    }

    .charge-alert {
      display: none;
      padding: 12px 14px;
      border-radius: var(--r-sm);
      margin-bottom: 16px;
      font-size: 13px;
      font-weight: 700;
    }

    .charge-alert.show {
      display: block;
    }

    .charge-alert.info {
      background: var(--blue-soft);
      border: 1px solid #bfdbfe;
      color: #1e40af;
    }

    .charge-alert.warn {
      background: var(--yellow-soft);
      border: 1px solid #fde68a;
      color: #735c18;
    }

    .charge-alert.error {
      background: var(--red-soft);
      border: 1px solid #fecaca;
      color: #991b1b;
    }

    .charge-alert.success {
      background: var(--green-soft);
      border: 1px solid #bbf7d0;
      color: #166534;
    }

    .text-right {
      text-align: right;
    }

    .empty {
      color: var(--text-tertiary);
      padding: 30px;
      text-align: center;
    }

    .charge-actions {
      display: flex;
      justify-content: flex-end;
      gap: 8px;
      padding-top: 14px;
      border-top: 1px solid var(--border);
    }

    .charge-result-box {
      display: none;
      margin-top: 16px;
      padding: 14px 16px;
      border: 1px solid var(--border);
      border-radius: var(--r-sm);
      background: #f8fafc;
    }

    .charge-result-box.show {
      display: block;
    }

    .charge-result-box p {
      margin: 4px 0;
      font-size: 13px;
      color: var(--text-secondary);
    }

    .charge-result-box strong {
      color: var(--text-primary);
    }

    @media (max-width: 1280px) {
      .charge-summary-grid {
        grid-template-columns: repeat(2, minmax(0, 1fr));
      }
    }

    @media (max-width: 768px) {
      .charge-summary-grid {
        grid-template-columns: 1fr;
      }
    }
  </style>
  <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>
<!-- SweetAlert2 -->

<body>
<div class="app-wrapper">

  <%@ include file="/WEB-INF/views/include/office_sidebar.jsp" %>

  <div class="main-wrap">

    <%@ include file="/WEB-INF/views/include/office_header.jsp" %>

    <main class="main-content">
      <div class="office-page charge-page">

        <div class="page-header">
          <div class="page-title-block">
            <h2>관리비 부과</h2>
            <p>월별 지출 내역을 기준으로 세대별 관리비를 부과합니다.</p>
          </div>
        </div>

        <div id="messageBox" class="charge-alert"></div>

        <!-- 조회 조건 -->
        <div class="panel">
          <div class="panel-header">
            <h3 class="panel-title">
              <span class="material-symbols-rounded">calculate</span>
              부과 조건
            </h3>
          </div>

          <div class="panel-body">
            <div class="charge-form-row">
              <label for="chargeYear">관리연도</label>
              <input type="number" id="chargeYear">

              <label for="chargeMonth">관리월</label>
              <select id="chargeMonth">
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

              <label for="dueDt">납부기한</label>
              <input type="date" id="dueDt">

              <button type="button" class="btn btn-primary" onclick="loadPreview()">
                <span class="material-symbols-rounded">search</span>
                미리보기
              </button>

              <button type="button" class="btn btn-secondary" onclick="resetChargeForm()">
                초기화
              </button>
            </div>
          </div>
        </div>

        <!-- 요약 -->
        <div class="charge-summary-grid">
          <div class="charge-summary-card">
            <div class="charge-summary-label">관리년월</div>
            <div class="charge-summary-value" id="summaryBillYm">-</div>
            <div class="charge-summary-desc">부과 대상 월</div>
          </div>

          <div class="charge-summary-card">
            <div class="charge-summary-label">총 지출금액</div>
            <div class="charge-summary-value" id="summaryTotalExpenseAmt">0원</div>
            <div class="charge-summary-desc">해당 월 EXPENSE 합계</div>
          </div>

          <div class="charge-summary-card">
            <div class="charge-summary-label">부과 대상 세대</div>
            <div class="charge-summary-value" id="summaryHouseholdCount">0세대</div>
            <div class="charge-summary-desc">APT_DETAIL 기준</div>
          </div>

          <div class="charge-summary-card">
            <div class="charge-summary-label">세대별 예상금액</div>
            <div class="charge-summary-value" id="summaryExpectedPerHouseAmt">0원</div>
            <div class="charge-summary-desc">총 지출 ÷ 세대 수</div>
          </div>
        </div>

        <!-- 지출 항목 목록 -->
        <div class="panel">
          <div class="panel-header">
            <h3 class="panel-title">
              <span class="material-symbols-rounded">receipt_long</span>
              부과 기준 지출 항목
            </h3>
          </div>

          <div class="table-wrap">
            <table class="tbl">
              <thead>
              <tr>
                <th>항목코드</th>
                <th>항목명</th>
                <th>설명</th>
                <th class="text-right">월 지출금액</th>
                <th class="text-right">세대별 예상금액</th>
              </tr>
              </thead>
              <tbody id="expenseSummaryTbody">
              <tr>
                <td colspan="5" class="empty">미리보기를 조회해 주세요.</td>
              </tr>
              </tbody>
            </table>
          </div>

          <div class="panel-body">
            <div class="charge-actions">
              <button type="button" class="btn btn-secondary" onclick="loadPreview()">
                다시 조회
              </button>

              <button type="button" class="btn btn-primary" id="chargeBtn" onclick="executeCharge()" disabled>
                <span class="material-symbols-rounded">done_all</span>
                관리비 부과
              </button>
            </div>

            <div id="chargeResultBox" class="charge-result-box">
              <p><strong>부과 결과</strong></p>
              <p>관리년월: <span id="resultBillYm">-</span></p>
              <p>생성된 관리비 건수: <span id="resultBillCount">0</span>건</p>
              <p>생성된 상세 건수: <span id="resultDetailCount">0</span>건</p>
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

  const csrfToken = document.querySelector('meta[name="_csrf"]')?.getAttribute('content');
  const csrfHeader = document.querySelector('meta[name="_csrf_header"]')?.getAttribute('content');

  let currentPreview = null;

  document.addEventListener('DOMContentLoaded', function () {
    initChargeDate();
  });

  function initChargeDate() {
    const now = new Date();

    const year = now.getFullYear();
    const month = now.getMonth() + 1;

    document.getElementById('chargeYear').value = year;
    document.getElementById('chargeMonth').value = month;

    // 기본 납부기한: 다음 달 10일
    const dueDate = new Date(year, month, 10);
    document.getElementById('dueDt').value = formatDateInput(dueDate);
  }

  function getHeaders() {
    const headers = {
      'Content-Type': 'application/json'
    };

    if (csrfToken && csrfHeader) {
      headers[csrfHeader] = csrfToken;
    }

    return headers;
  }

  function getBillYm() {
    const year = document.getElementById('chargeYear').value;
    const month = document.getElementById('chargeMonth').value;

    if (!year || !month) {
      return '';
    }

    return String(year) + String(month).padStart(2, '0');
  }

  async function loadPreview() {
    clearMessage();
    hideResult();

    const billYm = getBillYm();

    if (!billYm || billYm.length !== 6) {
      showMessage('관리년월을 확인해 주세요.', 'error');
      return;
    }

    const url = contextPath + '/manager/bill/charge/preview/' + mgmtOfcNo
            + '?billYm=' + encodeURIComponent(billYm);

    try {
      const response = await fetch(url);

      if (!response.ok) {
        const errorText = await response.text();
        console.error('미리보기 요청 실패:', response.status, errorText);
        showMessage('미리보기 조회 중 오류가 발생했습니다. 상태코드: ' + response.status, 'error');
        return;
      }

      const result = await response.json();

      if (!result.success) {
        currentPreview = null;
        renderPreviewEmpty(result.message || '미리보기 조회에 실패했습니다.');
        showMessage(result.message || '미리보기 조회에 실패했습니다.', 'error');
        return;
      }

      currentPreview = result;
      renderPreview(result);

    } catch (e) {
      console.error(e);
      showMessage('미리보기 조회 중 오류가 발생했습니다.', 'error');
    }
  }

  function renderPreview(result) {
    const householdCount = Number(result.householdCount || 0);
    const totalExpenseAmt = Number(result.totalExpenseAmt || 0);
    const expectedPerHouseAmt = Number(result.expectedPerHouseAmt || 0);
    const alreadyChargedCount = Number(result.alreadyChargedCount || 0);
    const list = result.expenseSummaryList || [];

    document.getElementById('summaryBillYm').textContent = formatBillYm(result.billYm);
    document.getElementById('summaryTotalExpenseAmt').textContent = formatNumber(totalExpenseAmt) + '원';
    document.getElementById('summaryHouseholdCount').textContent = formatNumber(householdCount) + '세대';
    document.getElementById('summaryExpectedPerHouseAmt').textContent = formatNumber(expectedPerHouseAmt) + '원';

    renderExpenseSummaryList(list, householdCount);

    const chargeBtn = document.getElementById('chargeBtn');

    if (alreadyChargedCount > 0) {
      chargeBtn.disabled = true;
      showMessage('이미 해당 월 관리비가 부과되어 있습니다. 중복 부과할 수 없습니다.', 'warn');
      return;
    }

    if (householdCount <= 0) {
      chargeBtn.disabled = true;
      showMessage('부과 대상 세대가 없습니다.', 'warn');
      return;
    }

    if (list.length === 0 || totalExpenseAmt <= 0) {
      chargeBtn.disabled = true;
      showMessage('해당 월 지출 내역이 없습니다. 먼저 지출 내역을 등록해 주세요.', 'warn');
      return;
    }

    chargeBtn.disabled = false;
    showMessage('미리보기 조회가 완료되었습니다. 내용을 확인한 뒤 관리비를 부과해 주세요.', 'info');
  }

  function renderPreviewEmpty(message) {
    document.getElementById('summaryBillYm').textContent = '-';
    document.getElementById('summaryTotalExpenseAmt').textContent = '0원';
    document.getElementById('summaryHouseholdCount').textContent = '0세대';
    document.getElementById('summaryExpectedPerHouseAmt').textContent = '0원';

    document.getElementById('expenseSummaryTbody').innerHTML =
            '<tr><td colspan="5" class="empty">' + escapeHtml(message || '조회된 내역이 없습니다.') + '</td></tr>';

    document.getElementById('chargeBtn').disabled = true;
  }

  function renderExpenseSummaryList(list, householdCount) {
    const tbody = document.getElementById('expenseSummaryTbody');
    tbody.innerHTML = '';

    if (!list || list.length === 0) {
      tbody.innerHTML = '<tr><td colspan="5" class="empty">해당 월 지출 내역이 없습니다.</td></tr>';
      return;
    }

    list.forEach(function (item) {
      const expenseAmt = Number(item.expenseAmt || 0);
      const perHouseAmt = householdCount > 0 ? Math.floor(expenseAmt / householdCount) : 0;

      const tr = document.createElement('tr');

      tr.innerHTML =
              '<td class="td-bold">' + escapeHtml(item.expenseCd || '-') + '</td>' +
              '<td>' + escapeHtml(item.expenseCdNm || item.expenseCd || '-') + '</td>' +
              '<td>' + escapeHtml(item.expenseCdContent || '-') + '</td>' +
              '<td class="text-right">' + formatNumber(expenseAmt) + '원</td>' +
              '<td class="text-right td-bold">' + formatNumber(perHouseAmt) + '원</td>';

      tbody.appendChild(tr);
    });
  }

  async function executeCharge() {
    clearMessage();

    const billYm = getBillYm();
    const dueDt = document.getElementById('dueDt').value;

    if (!currentPreview) {
      showMessage('먼저 미리보기를 조회해 주세요.', 'warn');

      Swal.fire({
        icon: 'warning',
        title: '미리보기 필요',
        text: '먼저 미리보기를 조회해 주세요.',
        confirmButtonText: '확인',
        confirmButtonColor: '#2e5c38'
      });

      return;
    }

    if (!dueDt) {
      showMessage('납부기한을 선택해 주세요.', 'error');

      Swal.fire({
        icon: 'warning',
        title: '납부기한 선택',
        text: '납부기한을 선택해 주세요.',
        confirmButtonText: '확인',
        confirmButtonColor: '#2e5c38'
      });

      return;
    }

    if (Number(currentPreview.alreadyChargedCount || 0) > 0) {
      showMessage('이미 해당 월 관리비가 부과되어 있습니다.', 'warn');

      Swal.fire({
        icon: 'info',
        title: '이미 부과된 관리비입니다',
        text: '해당 월 관리비는 이미 부과되어 중복 부과할 수 없습니다.',
        confirmButtonText: '확인',
        confirmButtonColor: '#2e5c38'
      });

      return;
    }

    const confirmResult = await Swal.fire({
      icon: 'question',
      title: '관리비를 부과하시겠습니까?',
      html:
              '<b>' + formatBillYm(billYm) + '</b> 관리비를 부과합니다.<br>' +
              '부과 후에는 중복 부과할 수 없습니다.',
      showCancelButton: true,
      confirmButtonText: '부과하기',
      cancelButtonText: '취소',
      confirmButtonColor: '#2e5c38',
      cancelButtonColor: '#8b9490',
      reverseButtons: true
    });

    if (!confirmResult.isConfirmed) {
      return;
    }

    const payload = {
      billYm: billYm,
      dueDt: dueDt
    };

    const url = contextPath + '/manager/bill/charge/execute/' + mgmtOfcNo;

    try {
      Swal.fire({
        title: '관리비 부과 중입니다',
        text: '잠시만 기다려 주세요.',
        allowOutsideClick: false,
        allowEscapeKey: false,
        didOpen: function () {
          Swal.showLoading();
        }
      });

      const response = await fetch(url, {
        method: 'POST',
        headers: getHeaders(),
        body: JSON.stringify(payload)
      });

      if (!response.ok) {
        const errorText = await response.text();
        console.error('관리비 부과 요청 실패:', response.status, errorText);

        Swal.fire({
          icon: 'error',
          title: '관리비 부과 실패',
          text: '관리비 부과 중 오류가 발생했습니다. 상태코드: ' + response.status,
          confirmButtonText: '확인',
          confirmButtonColor: '#2e5c38'
        });

        showMessage('관리비 부과 중 오류가 발생했습니다. 상태코드: ' + response.status, 'error');
        return;
      }

      const result = await response.json();

      if (!result.success) {
        Swal.fire({
          icon: 'error',
          title: '관리비 부과 실패',
          text: result.message || '관리비 부과에 실패했습니다.',
          confirmButtonText: '확인',
          confirmButtonColor: '#2e5c38'
        });

        showMessage(result.message || '관리비 부과에 실패했습니다.', 'error');
        return;
      }

      document.getElementById('chargeBtn').disabled = true;

      document.getElementById('chargeResultBox').classList.add('show');
      document.getElementById('resultBillYm').textContent = formatBillYm(result.billYm || billYm);
      document.getElementById('resultBillCount').textContent = formatNumber(result.billInsertCount || 0);
      document.getElementById('resultDetailCount').textContent = formatNumber(result.detailInsertCount || 0);

      showMessage(result.message || '관리비 부과가 완료되었습니다.', 'success');

      await Swal.fire({
        icon: 'success',
        title: '관리비 부과 완료',
        html:
                '<div style="line-height:1.8; font-size:14px;">' +
                '<b>' + formatBillYm(result.billYm || billYm) + '</b> 관리비가 정상적으로 부과되었습니다.<br>' +
                '생성된 관리비 건수: <b>' + formatNumber(result.billInsertCount || 0) + '</b>건<br>' +
                '생성된 상세 건수: <b>' + formatNumber(result.detailInsertCount || 0) + '</b>건' +
                '</div>',
        confirmButtonText: '확인',
        confirmButtonColor: '#2e5c38'
      });

      // 중복 부과 방지를 위해 다시 미리보기 조회
      loadPreview();

    } catch (e) {
      console.error(e);

      Swal.fire({
        icon: 'error',
        title: '관리비 부과 오류',
        text: '관리비 부과 중 오류가 발생했습니다.',
        confirmButtonText: '확인',
        confirmButtonColor: '#2e5c38'
      });

      showMessage('관리비 부과 중 오류가 발생했습니다.', 'error');
    }
  }

  function resetChargeForm() {
    initChargeDate();
    currentPreview = null;
    hideResult();
    clearMessage();

    document.getElementById('summaryBillYm').textContent = '-';
    document.getElementById('summaryTotalExpenseAmt').textContent = '0원';
    document.getElementById('summaryHouseholdCount').textContent = '0세대';
    document.getElementById('summaryExpectedPerHouseAmt').textContent = '0원';
    document.getElementById('expenseSummaryTbody').innerHTML =
            '<tr><td colspan="5" class="empty">미리보기를 조회해 주세요.</td></tr>';
    document.getElementById('chargeBtn').disabled = true;
  }

  function showMessage(message, type) {
    const box = document.getElementById('messageBox');
    box.className = 'charge-alert show ' + (type || 'info');
    box.textContent = message;
  }

  function clearMessage() {
    const box = document.getElementById('messageBox');
    box.className = 'charge-alert';
    box.textContent = '';
  }

  function hideResult() {
    document.getElementById('chargeResultBox').classList.remove('show');
    document.getElementById('resultBillYm').textContent = '-';
    document.getElementById('resultBillCount').textContent = '0';
    document.getElementById('resultDetailCount').textContent = '0';
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

  function formatDateInput(date) {
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');

    return year + '-' + month + '-' + day;
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
