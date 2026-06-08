<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>세대 검침 관리</title>

  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/office-layout.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/manager-common.css">
  <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet">

  <style>
    .meter-page .form-row {
      display: flex;
      flex-wrap: wrap;
      align-items: center;
      gap: 10px;
    }

    .meter-page label {
      font-weight: 800;
      color: var(--text-primary);
    }

    .meter-page input,
    .meter-page select {
      height: 36px;
      border: 1px solid var(--border);
      border-radius: var(--r-sm);
      padding: 0 10px;
      font-family: inherit;
      font-size: 13px;
      background: #fff;
    }

    .meter-page input[type="number"] {
      width: 120px;
    }

    /* 세대별 현재 검침값 입력 */
    .meter-page .meter-current-input {
      width: 112px !important;
      height: 34px;
      text-align: right;
      font-weight: 800;
      color: var(--text-primary);
      border: 1px solid #cbd5e1;
      background: #fff;
    }

    .meter-page .meter-current-input:focus {
      outline: none;
      border-color: #356859;
      box-shadow: 0 0 0 3px rgba(53, 104, 89, 0.13);
    }

    .meter-page .meter-current-input.input-error {
      border-color: #dc2626;
      background: #fef2f2;
    }

    .meter-page .input-guide {
      display: flex;
      align-items: center;
      gap: 6px;
      margin-top: 14px;
      font-size: 12px;
      color: var(--text-tertiary);
      font-weight: 700;
    }

    .meter-page .input-guide .material-symbols-rounded {
      font-size: 17px;
      color: #356859;
    }

    /*
     * 합계 카드와 목록 패널을 같은 전체 가로폭 안에서 정렬합니다.
     * 상단 합계 카드는 2x2 형태로 배치합니다.
     */
    .meter-page .summary-grid {
      display: grid;
      grid-template-columns: repeat(2, minmax(0, 1fr));
      gap: 12px;
      margin-bottom: 18px;
    }

    .meter-page .summary-card {
      background: #fff;
      border: 1px solid var(--border);
      border-radius: var(--r-md);
      padding: 18px 20px;
      display: flex;
      flex-direction: column;
      align-items: flex-start;
      justify-content: center;
      gap: 12px;
      min-width: 0;
      white-space: normal;
      box-shadow: 0 2px 10px rgba(17, 24, 39, 0.03);
    }

    .meter-page .summary-label {
      font-size: 13px;
      color: var(--text-tertiary);
      font-weight: 800;
      margin-bottom: 0;
      flex-shrink: 0;
    }

    .meter-page .summary-value {
      font-size: clamp(24px, 2vw, 40px);
      font-weight: 900;
      color: var(--text-primary);
      line-height: 1.12;
      letter-spacing: -0.05em;
      white-space: nowrap;
      flex-shrink: 0;
    }

    .meter-page .summary-sub {
      margin: 0;
      font-size: 12px;
      color: var(--text-tertiary);
      font-weight: 700;
      letter-spacing: -0.03em;
      white-space: normal;
      text-align: left;
      line-height: 1.45;
    }

    .meter-page .text-right {
      text-align: right;
    }

    .meter-page .td-bold {
      font-weight: 800;
      color: var(--text-primary);
    }

    .meter-page .empty {
      color: var(--text-tertiary);
      text-align: center;
      padding: 30px;
    }

    .meter-page .badge-meter {
      display: inline-flex;
      align-items: center;
      padding: 3px 9px;
      border-radius: 999px;
      font-size: 11px;
      font-weight: 800;
      border: 1px solid var(--border);
      white-space: nowrap;
    }

    .meter-page .badge-elc {
      background: #eff6ff;
      color: #1d4ed8;
      border-color: #bfdbfe;
    }

    .meter-page .badge-wtr {
      background: #ecfeff;
      color: #0e7490;
      border-color: #a5f3fc;
    }

    .meter-page .badge-gas {
      background: #fff7ed;
      color: #c2410c;
      border-color: #fed7aa;
    }

    .meter-page .message-box {
      display: none;
      padding: 12px 14px;
      border-radius: var(--r-sm);
      font-size: 13px;
      font-weight: 700;
      margin-bottom: 16px;
    }

    .meter-page .message-box.show {
      display: block;
    }

    .meter-page .message-box.info {
      background: #eff6ff;
      border: 1px solid #bfdbfe;
      color: #1d4ed8;
    }

    .meter-page .message-box.warn {
      background: #fffbeb;
      border: 1px solid #fde68a;
      color: #92400e;
    }

    .meter-page .message-box.error {
      background: #fef2f2;
      border: 1px solid #fecaca;
      color: #991b1b;
    }

    .meter-page .filter-row {
      display: flex;
      justify-content: space-between;
      align-items: center;
      gap: 12px;
      margin-bottom: 12px;
    }

    .meter-page .filter-group {
      display: flex;
      flex-wrap: wrap;
      align-items: center;
      gap: 8px;
    }

    .meter-page .filter-group select,
    .meter-page .filter-group input {
      height: 34px;
      font-size: 13px;
    }

    .meter-page .filter-group input[type="text"] {
      width: 160px;
    }

    .meter-page .table-info {
      font-size: 13px;
      font-weight: 700;
      color: var(--text-secondary);
    }

    .meter-page .table-wrap {
      overflow-x: auto;
    }

    /* 검침값 저장 버튼 영역 */
    .meter-page .save-area {
      display: flex;
      justify-content: flex-end;
      align-items: center;
      gap: 10px;
      padding: 0 20px 18px;
    }

    .meter-page .save-hint {
      margin-right: auto;
      font-size: 12px;
      color: var(--text-tertiary);
      font-weight: 700;
    }

    .meter-page .btn-save-meter {
      min-width: 140px;
    }

    .meter-page .btn-save-meter:disabled {
      opacity: 0.5;
      cursor: not-allowed;
    }

    .meter-page .tbl th,
    .meter-page .tbl td {
      white-space: nowrap;
    }

    @media (max-width: 768px) {
      .meter-page .summary-grid {
        grid-template-columns: 1fr;
      }

      .meter-page .filter-row {
        align-items: flex-start;
        flex-direction: column;
      }
    }

    /* PaginationInfoVO.getPagingHTML() 출력 영역 */
    .meter-page .paging-area {
      display: flex;
      justify-content: center;
      padding: 18px 20px 2px;
    }

    .meter-page .paging-area:empty {
      display: none;
    }

    .meter-page .pagination {
      display: flex;
      align-items: center;
      gap: 6px;
      list-style: none;
      padding: 0;
      margin: 0;
    }

    .meter-page .page-link {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      min-width: 34px;
      height: 34px;
      padding: 0 10px;
      border: 1px solid var(--border);
      border-radius: 8px;
      color: var(--text-secondary);
      background: #fff;
      text-decoration: none;
      font-size: 13px;
      font-weight: 700;
    }

    .meter-page .page-item.active .page-link,
    .meter-page .page-link:hover {
      color: #fff;
      border-color: #245640;
      background: #245640;
    }

    .meter-page .page-item.disabled .page-link {
      cursor: default;
      color: var(--text-tertiary);
    }

    /*
     * 세대 목록 테이블 헤더
     * - 펼쳐지는 상세 테이블 헤더에는 영향을 주지 않고 바깥 목록 헤더만 조정
     */
    .meter-page .table-wrap > .tbl > thead > tr > th {
      padding: 15px 18px;
      font-size: 14px;
      font-weight: 800;
      color: var(--text-primary);
      text-align: center !important;
      vertical-align: middle;
    }

    /* 세대 요약 행 */
    .meter-page .house-summary-row {
      cursor: pointer;
      transition: background-color 0.15s ease;
    }

    .meter-page .house-summary-row:hover {
      background: #f7fbf8;
    }

    .meter-page .house-summary-row td {
      padding: 16px 18px;
      vertical-align: middle;
    }

    .meter-page .house-total {
      color: #163d2c;
      font-weight: 800;
    }

    .meter-page .text-center {
      text-align: center;
    }

    .meter-page .accordion-icon {
      color: #52665c;
      font-size: 22px;
      vertical-align: middle;
    }

    /* 입력현황 배지 */
    .meter-page .house-status {
      display: inline-flex;
      align-items: center;
      height: 27px;
      padding: 0 12px;
      border-radius: 999px;
      font-size: 12px;
      font-weight: 700;
    }

    .meter-page .house-status.waiting {
      background: #f1f3f2;
      color: #78837d;
    }

    .meter-page .house-status.partial {
      background: #fff5dd;
      color: #9a6a06;
    }

    .meter-page .house-status.complete {
      background: #e7f4ea;
      color: #27834b;
    }

    /* 펼쳐진 상세 영역 */
    .meter-page .house-detail-row td {
      padding: 0 18px 18px;
      background: #fafcfb;
    }

    .meter-page .meter-detail-wrap {
      padding: 14px;
      border: 1px solid #d9e6dd;
      border-radius: 10px;
      background: #ffffff;
    }

    .meter-page .inner-meter-table {
      width: 100%;
      border-collapse: collapse;
    }

    .meter-page .inner-meter-table th {
      padding: 11px 12px;
      background: #f3f8f4;
      border-bottom: 1px solid #d9e6dd;
      font-size: 12px;
      font-weight: 700;
      color: #52665c;
      text-align: center;
    }

    .meter-page .inner-meter-table td {
      padding: 11px 12px;
      border-bottom: 1px solid #edf1ee;
      font-size: 13px;
      text-align: center;
    }

    .meter-page .inner-meter-table tbody tr:last-child td {
      border-bottom: 0;
    }

    .meter-page .inner-meter-table .meter-current-input {
      width: 110px;
    }


    /*
     * 세대별 검침요금 목록 패널 폭 축소
     * - max-width만 주면 브라우저 영역이 이미 좁은 경우 변화가 보이지 않는다.
     * - 따라서 현재 부모 폭에서 좌우 120px을 빼서 항상 눈에 띄게 줄인다.
     */
    .meter-page .panel.meter-list-panel {
      width: min(calc(100% - 200px), 1200px) !important;
      max-width: none !important;
      margin-left: auto !important;
      margin-right: auto !important;
      margin-bottom: 20px;
      box-sizing: border-box;
    }

    .meter-page .meter-list-panel .table-wrap {
      width: 100%;
      padding: 0 18px 16px;
      box-sizing: border-box;
    }

    .meter-page .meter-list-panel .table-wrap > .tbl {
      width: 100%;
      margin: 0 auto;
    }

    /* 입력현황 열과 배지 중앙 정렬 */
    .meter-page .meter-list-panel .house-summary-row td:nth-child(2) {
      text-align: center;
    }

    .meter-page .meter-list-panel .house-status {
      min-width: 68px;
      justify-content: center;
    }

    /* 모바일 폭에서는 목록을 다시 전체 폭으로 표시 */
    @media (max-width: 700px) {
      .meter-page .panel.meter-list-panel {
        width: 100% !important;
      }

      .meter-page .meter-list-panel .table-wrap {
        padding: 0 10px 12px;
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
      <div class="office-page meter-page">

        <div class="page-header">
          <div class="page-title-block">
            <h2>세대별 검침 입력 및 요금 계산</h2>
            <p>세대별 전기, 수도, 가스의 현재 검침 숫자를 입력하여 사용량과 개별요금을 확인합니다.</p>
          </div>
        </div>

        <div id="messageBox" class="message-box"></div>

        <!-- 조회 조건 -->
        <div class="panel">
          <div class="panel-header">
            <h3 class="panel-title">
              <span class="material-symbols-rounded">search</span>
              조회 조건
            </h3>
          </div>

          <div class="panel-body">
            <div class="form-row">
              <label for="searchYear">검침연도</label>
              <input type="number" id="searchYear">

              <label for="searchMonth">검침월</label>
              <select id="searchMonth">
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

              <button type="button" class="btn btn-primary" onclick="loadMeterChargeList()">
                <span class="material-symbols-rounded">calculate</span>
                계산 조회
              </button>

              <button type="button" class="btn btn-secondary" onclick="resetPage()">
                초기화
              </button>
            </div>

            <div class="input-guide">
              <span class="material-symbols-rounded">edit_square</span>
              조회 후 목록의 현재 검침값 칸에 숫자를 입력하면 사용량과 요금 합계가 즉시 다시 계산됩니다.
            </div>
          </div>
        </div>

        <!-- 요약 -->
        <div class="summary-grid">
          <div class="summary-card">
            <div class="summary-label">전기요금 합계</div>
            <div class="summary-value" id="electricTotal">0원</div>
            <div class="summary-sub" id="electricUsage">사용량 0 / 단가 0원</div>
          </div>

          <div class="summary-card">
            <div class="summary-label">수도요금 합계</div>
            <div class="summary-value" id="waterTotal">0원</div>
            <div class="summary-sub" id="waterUsage">사용량 0 / 단가 0원</div>
          </div>

          <div class="summary-card">
            <div class="summary-label">가스요금 합계</div>
            <div class="summary-value" id="gasTotal">0원</div>
            <div class="summary-sub" id="gasUsage">사용량 0 / 단가 0원</div>
          </div>

          <div class="summary-card">
            <div class="summary-label">검침요금 총합</div>
            <div class="summary-value" id="grandTotal">0원</div>
            <div class="summary-sub" id="meterCount">0건</div>
          </div>
        </div>

        <!-- 목록 -->
        <div class="panel meter-list-panel">
          <div class="panel-header">
            <h3 class="panel-title">
              <span class="material-symbols-rounded">speed</span>
              세대별 검침요금 목록
            </h3>
          </div>

          <div class="panel-body">
            <div class="filter-row">
              <div class="filter-group">
                <label for="keywordFilter">동/호수</label>
                <input type="text"
                       id="keywordFilter"
                       placeholder="예: 101 또는 101호"
                       onkeyup="if (event.key === 'Enter') reloadMeterSearch()">

                <button type="button"
                        class="btn btn-primary"
                        onclick="reloadMeterSearch()">
                  <span class="material-symbols-rounded">search</span>
                  검색
                </button>
              </div>

              <div class="table-info" id="tableInfo">
                조회 전
              </div>
            </div>
          </div>

          <div class="table-wrap">
            <table class="tbl">
              <thead>
              <tr>
                <th style="width: 28%;">동/호수</th>
                <th style="width: 22%;">입력현황</th>
                <th style="width: 30%;">세대 합계</th>
                <th style="width: 20%;"></th>
              </tr>
              </thead>
              <tbody id="meterChargeTbody">
              <tr>
                <td colspan="4" class="empty">
                  검침요금 계산 조회를 실행해 주세요.
                </td>
              </tr>
              </tbody>

            </table>
          </div>

          <!-- PaginationInfoVO에서 생성한 페이지 버튼 출력 -->
          <div id="meterPaging" class="paging-area"></div>

          <div class="save-area">
            <span class="save-hint">현재 검침값을 입력한 행만 저장됩니다.</span>
            <button type="button"
                    id="btnSaveMeter"
                    class="btn btn-primary btn-save-meter"
                    onclick="saveMeterReadings()"
                    disabled>
              <span class="material-symbols-rounded">save</span>
              검침값 저장
            </button>
          </div>
        </div>

      </div>
    </main>
  </div>
</div>

<script>

  const contextPath = '${pageContext.request.contextPath}';
  const mgmtOfcNo = '${mgmtOfcNo}';

  /*
   * DB 페이징 적용 후에는 현재 페이지 목록만 보관합니다.
   * 페이지 이동 전 변경값은 반드시 저장하도록 막아서 입력 유실을 방지합니다.
   */
  let meterChargeList = [];      // 서버에서 받은 검침항목 원본 목록
  let meterHouseList = [];       // hoNo 기준으로 묶은 세대 목록
  let openedHouseNo = null;      // 현재 펼쳐진 세대번호

  let meterCurrentPage = 1;
  let meterPagingVO = null;
  let serverSummary = null;

  document.addEventListener('DOMContentLoaded', function () {
    initDate();
    renderEmptyState();

    document.getElementById('meterPaging').addEventListener('click', function (e) {
      const link = e.target.closest('.page-link');

      if (!link || !link.dataset.page) {
        return;
      }

      e.preventDefault();

      if (hasModifiedInput()) {
        showMessage('입력한 검침값을 먼저 저장한 뒤 페이지를 이동해 주세요.', 'warn');
        return;
      }

      loadMeterChargeList(Number(link.dataset.page));
    });
  });

  function initDate() {
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

  /*
   * 항목 또는 동/호수 검색조건이 변경되면 1페이지부터 조회합니다.
   */
  function reloadMeterSearch() {
    if (hasModifiedInput()) {
      showMessage('입력한 검침값을 먼저 저장한 뒤 검색조건을 변경해 주세요.', 'warn');
      return;
    }

    loadMeterChargeList(1);
  }

  async function loadMeterChargeList(currentPage) {
    clearMessage();

    const billYm = getBillYm();
    const keyword = document.getElementById('keywordFilter').value.trim();

    currentPage = currentPage || 1;

    if (!billYm) {
      showMessage('검침년월을 선택해 주세요.', 'warn');
      return;
    }

    if (!mgmtOfcNo || mgmtOfcNo === 'null') {
      showMessage('관리사무소 번호가 확인되지 않았습니다.', 'error');
      return;
    }

    let url = contextPath
            + '/manager/bill/meter-charge/list/' + encodeURIComponent(mgmtOfcNo)
            + '?billYm=' + encodeURIComponent(billYm)
            + '&currentPage=' + encodeURIComponent(currentPage);

    if (keyword) {
      url += '&keyword=' + encodeURIComponent(keyword);
    }

    try {
      const response = await fetch(url);
      const result = await response.json();

      if (!response.ok || !result.success) {
        showMessage(result.message || '검침요금 계산 조회에 실패했습니다.', 'error');
        return;
      }

      if (!result.pagingVO) {
        console.error("페이징 응답이 없습니다.", result);

        showMessage(
                "페이징 조회 응답이 없습니다. Controller에서 페이징 메서드 호출 여부를 확인해 주세요.",
                "error"
        );

        return;
      }

      meterPagingVO = result.pagingVO;
      meterCurrentPage = Number(meterPagingVO.currentPage || 1);
      serverSummary = result;

      meterChargeList = (result.list || []).map(function (item) {
        item.currVal =
                item.currVal === null || item.currVal === undefined
                        ? ''
                        : item.currVal;

        item.originalCurrVal = item.currVal;
        item.originalUsageVal = Number(item.usageVal || 0);
        item.originalChargeAmt = Number(item.chargeAmt || 0);

        return item;
      });

      /*
       * 같은 세대의 전기/수도/가스 데이터를 하나의 세대 목록으로 묶는다.
       */
      meterHouseList = groupMeterListByHouse(meterChargeList);

      openedHouseNo = null;

      renderMeterHouseList();
      renderSummaryWithPageEdits();
      renderPaging(result.pagingHTML);
      updateSaveButton();

      showMessage(formatBillYm(billYm) + ' 검침요금 계산 결과를 조회했습니다.', 'info');

    } catch (e) {
      console.error(e);
      showMessage('검침요금 계산 조회 중 오류가 발생했습니다.', 'error');
    }
  }

  /**
   * 서버에서 받은 검침항목 목록을 세대별로 묶는다.
   * - 서버 목록: 전기/수도/가스 항목별 행
   * - 화면 목록: hoNo 기준 세대별 행
   */
  function groupMeterListByHouse(list) {
    const houseMap = {};

    list.forEach(function (meter, index) {
      if (!houseMap[meter.hoNo]) {
        houseMap[meter.hoNo] = {
          hoNo: meter.hoNo,
          displayDongHo: meter.displayDongHo,
          meterList: [],
          totalChargeAmt: 0,
          enteredCount: 0
        };
      }

      meter.listIndex = index;
      houseMap[meter.hoNo].meterList.push(meter);
    });

    return Object.values(houseMap).map(function (house) {
      house.totalChargeAmt = house.meterList.reduce(function (sum, meter) {
        return sum + Number(meter.chargeAmt || 0);
      }, 0);

      house.enteredCount = house.meterList.filter(function (meter) {
        return meter.currVal !== ''
                && meter.currVal !== null
                && meter.currVal !== undefined;
      }).length;

      return house;
    });
  }

  /*
   * 서버에서 조회한 전체 검색결과 합계에 현재 페이지 입력 변경분만 반영합니다.
   * 저장 완료 후에는 현재 페이지를 재조회하여 DB 합계로 다시 맞춥니다.
   */
  function renderSummaryWithPageEdits() {
    if (!serverSummary) {
      return;
    }

    const totals = {
      ELC: {
        amount: Number(serverSummary.electricTotal || 0),
        usage: Number(serverSummary.electricUsageTotal || 0),
        unitPrice: Number(serverSummary.electricUnitPrice || 0)
      },
      WTR: {
        amount: Number(serverSummary.waterTotal || 0),
        usage: Number(serverSummary.waterUsageTotal || 0),
        unitPrice: Number(serverSummary.waterUnitPrice || 0)
      },
      GAS: {
        amount: Number(serverSummary.gasTotal || 0),
        usage: Number(serverSummary.gasUsageTotal || 0),
        unitPrice: Number(serverSummary.gasUnitPrice || 0)
      }
    };

    let enteredCount = Number(serverSummary.enteredCount || 0);

    meterChargeList.forEach(function (item) {
      const code = item.billItemCd;

      if (!totals[code]) {
        return;
      }

      totals[code].amount += Number(item.chargeAmt || 0) - Number(item.originalChargeAmt || 0);
      totals[code].usage += Number(item.usageVal || 0) - Number(item.originalUsageVal || 0);

      const hadValue = item.originalCurrVal !== '' && item.originalCurrVal !== null && item.originalCurrVal !== undefined;
      const hasValue = item.currVal !== '' && item.currVal !== null && item.currVal !== undefined;

      if (!hadValue && hasValue) {
        enteredCount++;
      } else if (hadValue && !hasValue) {
        enteredCount--;
      }
    });

    const grandTotal = totals.ELC.amount + totals.WTR.amount + totals.GAS.amount;

    document.getElementById('electricTotal').textContent = formatNumber(totals.ELC.amount) + '원';
    document.getElementById('waterTotal').textContent = formatNumber(totals.WTR.amount) + '원';
    document.getElementById('gasTotal').textContent = formatNumber(totals.GAS.amount) + '원';
    document.getElementById('grandTotal').textContent = formatNumber(grandTotal) + '원';

    document.getElementById('electricUsage').textContent =
            '사용량 ' + formatNumber(totals.ELC.usage) + ' / 단가 ' + formatNumber(totals.ELC.unitPrice) + '원';
    document.getElementById('waterUsage').textContent =
            '사용량 ' + formatNumber(totals.WTR.usage) + ' / 단가 ' + formatNumber(totals.WTR.unitPrice) + '원';
    document.getElementById('gasUsage').textContent =
            '사용량 ' + formatNumber(totals.GAS.usage) + ' / 단가 ' + formatNumber(totals.GAS.unitPrice) + '원';
    document.getElementById('meterCount').textContent =
            '입력 ' + formatNumber(enteredCount) + '건 / 전체 ' + formatNumber(serverSummary.totalCount || 0) + '건';
  }

  function applyMeterInput(listIndex, inputElement) {
    const item = meterChargeList[listIndex];
    const enteredValue = inputElement.value.trim();
    const previousValue = Number(item.preVal || 0);

    inputElement.classList.remove('input-error');

    if (enteredValue === '') {
      item.currVal = '';
      item.usageVal = 0;
      item.chargeAmt = 0;
      /*
       * 값 변경 후 세대 합계와 입력상태까지 다시 계산하여 출력
       */
      meterHouseList = groupMeterListByHouse(meterChargeList);

      renderMeterHouseList();
      renderSummaryWithPageEdits();
      updateSaveButton();
      showMessage('현재 검침값이 비어 있는 행은 요금 계산에서 제외됩니다.', 'warn');
      return;
    }

    const currentValue = Number(enteredValue);

    if (!Number.isFinite(currentValue) || currentValue < previousValue) {
      inputElement.classList.add('input-error');
      showMessage('현재 검침값은 이전 검침값 이상인 숫자로 입력해 주세요.', 'warn');
      return;
    }

    item.currVal = currentValue;
    item.usageVal = currentValue - previousValue;
    item.chargeAmt = Math.round(item.usageVal * Number(item.unitPrice || 0));

    /*
     * 값 변경 후 세대 합계와 입력상태까지 다시 계산하여 출력
     */
    meterHouseList = groupMeterListByHouse(meterChargeList);

    renderMeterHouseList();
    renderSummaryWithPageEdits();
    updateSaveButton();
    showMessage('입력값을 기준으로 사용량과 계산금액을 반영했습니다.', 'info');
  }

  /**
   * 세대 목록 및 아코디언 상세 출력
   */
  function renderMeterHouseList() {

    const tbody = document.getElementById('meterChargeTbody');
    tbody.innerHTML = '';

    const totalRecord =
            meterPagingVO ? Number(meterPagingVO.totalRecord || 0) : 0;

    const startRow =
            meterPagingVO ? Number(meterPagingVO.startRow || 0) : 0;

    const endRow = Math.min(
            meterPagingVO ? Number(meterPagingVO.endRow || 0) : 0,
            totalRecord
    );

    document.getElementById('tableInfo').textContent =
            totalRecord === 0
                    ? '총 0세대'
                    : '총 ' + formatNumber(totalRecord) + '세대 / '
                    + formatNumber(startRow) + '-'
                    + formatNumber(endRow) + '세대 표시';

    if (!meterHouseList.length) {
      tbody.innerHTML =
              '<tr><td colspan="4" class="empty">조회된 검침 데이터가 없습니다.</td></tr>';
      return;
    }

    meterHouseList.forEach(function (house) {

      const isOpen = openedHouseNo === house.hoNo;

      const currentTotal = house.meterList.reduce(function (sum, meter) {
        return sum + Number(meter.chargeAmt || 0);
      }, 0);

      const enteredCount = house.meterList.filter(function (meter) {
        return meter.currVal !== ''
                && meter.currVal !== null
                && meter.currVal !== undefined;
      }).length;

      const statusText =
              enteredCount === 3
                      ? '입력완료'
                      : enteredCount > 0
                              ? '일부입력'
                              : '입력대기';

      const statusClass =
              enteredCount === 3
                      ? 'complete'
                      : enteredCount > 0
                              ? 'partial'
                              : 'waiting';

      const summaryTr = document.createElement('tr');
      summaryTr.className = 'house-summary-row';
      summaryTr.onclick = function () {
        toggleHouseAccordion(house.hoNo);
      };

      summaryTr.innerHTML =
              '<td class="td-bold">' + escapeHtml(house.displayDongHo || '-') + '</td>' +
              '<td><span class="house-status ' + statusClass + '">' + statusText + '</span></td>' +
              '<td class="text-right house-total">' + formatNumber(currentTotal) + '원</td>' +
              '<td class="text-center">' +
              '  <span class="material-symbols-rounded accordion-icon">' +
              (isOpen ? 'expand_less' : 'expand_more') +
              '  </span>' +
              '</td>';

      tbody.appendChild(summaryTr);

      if (isOpen) {
        const detailTr = document.createElement('tr');
        detailTr.className = 'house-detail-row';

        detailTr.innerHTML =
                '<td colspan="4">' +
                renderHouseDetailTable(house) +
                '</td>';

        tbody.appendChild(detailTr);
      }
    });
  }

  /**
   * 세대 행 클릭 시 상세 검침값 펼침/접힘
   */
  function toggleHouseAccordion(hoNo) {

    if (openedHouseNo === hoNo) {
      openedHouseNo = null;
    } else {
      openedHouseNo = hoNo;
    }

    renderMeterHouseList();
  }

  /**
   * 펼쳐진 세대 안의 전기/수도/가스 상세 테이블 생성
   */
  function renderHouseDetailTable(house) {

    let html = '';

    html += '<div class="meter-detail-wrap">';
    html += '  <table class="inner-meter-table">';
    html += '    <thead>';
    html += '      <tr>';
    html += '        <th>항목</th>';
    html += '        <th>이전 검침값</th>';
    html += '        <th>현재 검침값</th>';
    html += '        <th>사용량</th>';
    html += '        <th>단가</th>';
    html += '        <th>계산금액</th>';
    html += '        <th>검침결과</th>';
    html += '      </tr>';
    html += '    </thead>';
    html += '    <tbody>';

    house.meterList.forEach(function (meter) {

      const currentValue =
              meter.currVal === null || meter.currVal === undefined
                      ? ''
                      : meter.currVal;

      html += '<tr>';
      html += '  <td>' + renderMeterBadge(meter.billItemCd, meter.billItemNm) + '</td>';
      html += '  <td class="text-right">' + formatNumber(meter.preVal) + '</td>';
      html += '  <td class="text-right">';
      html += '    <input type="number"';
      html += '           class="meter-current-input"';
      html += '           min="' + Number(meter.preVal || 0) + '"';
      html += '           step="1"';
      html += '           value="' + escapeHtml(currentValue) + '"';
      html += '           onchange="applyMeterInput(' + meter.listIndex + ', this)">';
      html += '  </td>';
      html += '  <td class="text-right td-bold">' + formatNumber(meter.usageVal) + '</td>';
      html += '  <td class="text-right">' + formatNumber(meter.unitPrice) + '원</td>';
      html += '  <td class="text-right td-bold">' + formatNumber(meter.chargeAmt) + '원</td>';
      html += '  <td>' + escapeHtml(meter.meterRsltCd || '입력대기') + '</td>';
      html += '</tr>';
    });

    html += '    </tbody>';
    html += '  </table>';
    html += '</div>';

    return html;
  }

  function renderPaging(pagingHTML) {
    document.getElementById('meterPaging').innerHTML = pagingHTML || '';
  }

  function hasModifiedInput() {
    return meterChargeList.some(function (item) {
      return item.currVal !== ''
              && item.currVal !== null
              && item.currVal !== undefined
              && String(item.currVal) !== String(item.originalCurrVal);
    });
  }

  function makeSavePayload() {
    const meterList = meterChargeList
            .filter(function (item) {
              return item.currVal !== ''
                      && item.currVal !== null
                      && item.currVal !== undefined
                      && String(item.currVal) !== String(item.originalCurrVal);
            })
            .map(function (item) {
              return {
                hoNo: item.hoNo,
                billItemCd: item.billItemCd,
                currVal: Number(item.currVal)
              };
            });

    return {
      billYm: getBillYm(),
      meterList: meterList
    };
  }

  async function saveMeterReadings() {
    clearMessage();

    const payload = makeSavePayload();

    if (!payload.meterList.length) {
      showMessage('저장할 검침값이 없습니다. 값을 입력하거나 변경해 주세요.', 'warn');
      return;
    }

    const saveButton = document.getElementById('btnSaveMeter');
    const originalButtonText = saveButton.innerHTML;

    saveButton.disabled = true;
    saveButton.innerHTML =
            '<span class="material-symbols-rounded">hourglass_top</span> 저장 중';

    const url = contextPath
            + '/manager/bill/meter-charge/save/' + encodeURIComponent(mgmtOfcNo);

    try {
      const headers = {'Content-Type': 'application/json'};
      const csrfToken = document.querySelector('meta[name="_csrf"]');
      const csrfHeader = document.querySelector('meta[name="_csrf_header"]');

      if (csrfToken && csrfHeader) {
        headers[csrfHeader.getAttribute('content')] = csrfToken.getAttribute('content');
      }

      const response = await fetch(url, {
        method: 'POST',
        headers: headers,
        body: JSON.stringify(payload)
      });

      const result = await response.json();

      if (!response.ok || !result.success) {
        showMessage(result.message || '검침값 저장에 실패했습니다.', 'error');
        return;
      }

      showMessage(result.message || '검침값이 저장되었습니다.', 'info');

      /*
       * 저장된 DB 값과 상단 전체 합계를 다시 읽어 옵니다.
       * 현재 페이지는 그대로 유지합니다.
       */
      await loadMeterChargeList(meterCurrentPage);

    } catch (e) {
      console.error(e);
      showMessage('검침값 저장 중 오류가 발생했습니다.', 'error');
    } finally {
      saveButton.innerHTML = originalButtonText;
      updateSaveButton();
    }
  }

  function updateSaveButton() {
    const button = document.getElementById('btnSaveMeter');
    if (button) {
      button.disabled = !hasModifiedInput();
    }
  }

  function renderMeterBadge(code, name) {
    let cls = 'badge-meter';

    if (code === 'ELC') {
      cls += ' badge-elc';
    } else if (code === 'WTR') {
      cls += ' badge-wtr';
    } else if (code === 'GAS') {
      cls += ' badge-gas';
    }

    return '<span class="' + cls + '">' + escapeHtml(name || code || '-') + '</span>';
  }

  function resetPage() {
    if (hasModifiedInput()) {
      showMessage('입력한 검침값을 먼저 저장한 뒤 초기화해 주세요.', 'warn');
      return;
    }

    initDate();
    clearMessage();

    meterChargeList = [];
    meterPagingVO = null;
    serverSummary = null;

    document.getElementById('keywordFilter').value = '';

    renderEmptyState();
    updateSaveButton();
  }

  function renderEmptyState() {
    document.getElementById('electricTotal').textContent = '0원';
    document.getElementById('waterTotal').textContent = '0원';
    document.getElementById('gasTotal').textContent = '0원';
    document.getElementById('grandTotal').textContent = '0원';

    document.getElementById('electricUsage').textContent = '사용량 0 / 단가 0원';
    document.getElementById('waterUsage').textContent = '사용량 0 / 단가 0원';
    document.getElementById('gasUsage').textContent = '사용량 0 / 단가 0원';
    document.getElementById('meterCount').textContent = '0건';

    document.getElementById('tableInfo').textContent = '조회 전';
    document.getElementById('meterPaging').innerHTML = '';

    document.getElementById('meterChargeTbody').innerHTML =
            '<tr><td colspan="4" class="empty">검침요금 계산 조회를 실행해 주세요.</td></tr>';
  }

  function showMessage(message, type) {
    const box = document.getElementById('messageBox');
    box.className = 'message-box show ' + (type || 'info');
    box.textContent = message;
  }

  function clearMessage() {
    const box = document.getElementById('messageBox');
    box.className = 'message-box';
    box.textContent = '';
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
