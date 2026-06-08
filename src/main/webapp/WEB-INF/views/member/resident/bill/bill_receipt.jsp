<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>납부영수증 - 대덕아파트</title>

  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/headerStyle.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebarStyle.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footerStyle.css">

  <!-- SweetAlert2 -->
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">

  <style>
    :root {
      --receipt-green: #255f42;
      --receipt-green-deep: #173b2c;
      --receipt-green-pale: #f1f6f2;
      --receipt-bg: #f6f8f6;
      --receipt-white: #ffffff;
      --receipt-border: #dce5dd;
      --receipt-text: #13261d;
      --receipt-text-mid: #53645b;
      --receipt-text-light: #819087;
      --receipt-danger: #b64444;
    }

    * {
      box-sizing: border-box;
    }

    body {
      font-family: 'Noto Sans KR', sans-serif !important;
      background: var(--bg, var(--receipt-bg));
      color: var(--text-dark, var(--receipt-text));
      margin: 0;
    }

    .material-symbols-outlined {
      font-family: 'Material Symbols Outlined' !important;
    }

    .main-shell {
      display: flex;
      align-items: stretch;
      width: 100%;
      min-height: calc(100vh - 114px);
      margin-top: 114px;
      background: var(--bg, var(--receipt-bg));
    }

    .content-area {
      flex: 1;
      min-width: 0;
      padding: 32px 40px 64px;
    }

    .page-content-wrap {
      max-width: 1160px;
      width: 100%;
      margin: 0 auto;
    }

    .breadcrumb {
      display: flex;
      align-items: center;
      gap: 6px;
      font-size: 12px;
      color: var(--text-light, var(--receipt-text-light));
      margin-bottom: 18px;
    }

    .breadcrumb a {
      color: var(--text-light, var(--receipt-text-light));
      text-decoration: none;
    }

    .breadcrumb .cur {
      color: var(--green-dark, var(--receipt-green));
      font-weight: 700;
    }

    .page-title {
      font-size: 22px;
      font-weight: 800;
      color: var(--text-dark, var(--receipt-text));
      padding-bottom: 14px;
      border-bottom: 2px solid var(--green-dark, var(--receipt-green));
      margin: 0 0 16px;
      letter-spacing: -.4px;
    }

    .page-desc {
      font-size: 13px;
      line-height: 1.8;
      color: var(--text-light, var(--receipt-text-light));
      margin: 0 0 24px;
    }

    .panel,
    .card {
      background: var(--white, var(--receipt-white));
      border: 1px solid var(--border, var(--receipt-border));
      border-radius: 14px;
      box-shadow: 0 10px 24px rgba(30, 60, 40, .05);
    }

    .panel {
      padding: 20px;
    }

    .section-hd {
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 12px;
      margin-bottom: 14px;
      padding-bottom: 10px;
      border-bottom: 1px solid var(--border, var(--receipt-border));
    }

    .section-hd h3 {
      margin: 0;
      font-size: 15px;
      font-weight: 800;
      color: var(--text-dark, var(--receipt-text));
    }

    .section-hd span {
      font-size: 12px;
      color: var(--text-light, var(--receipt-text-light));
    }

    /* 조회 조건 */
    .search-panel {
      margin-bottom: 20px;
    }

    .search-row {
      display: flex;
      align-items: end;
      gap: 12px;
      flex-wrap: wrap;
      padding: 4px 0 2px;
    }

    .search-field {
      display: flex;
      flex-direction: column;
      gap: 7px;
    }

    .search-field label {
      font-size: 12px;
      font-weight: 700;
      color: var(--text-mid, var(--receipt-text-mid));
    }

    .search-select {
      width: 160px;
      height: 43px;
      padding: 0 13px;
      border: 1px solid var(--border, var(--receipt-border));
      border-radius: 10px;
      background: #fff;
      color: var(--text-dark, var(--receipt-text));
      font-size: 13px;
    }

    .btn-main,
    .btn-sub,
    .btn-ghost {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      min-width: 104px;
      height: 43px;
      padding: 0 18px;
      border-radius: 10px;
      font-size: 13px;
      font-weight: 800;
      text-decoration: none;
      border: none;
      cursor: pointer;
      transition: all .2s ease;
    }

    .btn-main {
      background: var(--green-dark, var(--receipt-green));
      color: #fff;
    }

    .btn-main:hover {
      background: #1f5037;
    }

    .btn-sub {
      background: #edf5ef;
      color: var(--green-dark, var(--receipt-green));
    }

    .btn-sub:hover {
      background: #e2efe6;
    }

    .btn-ghost {
      background: #fff;
      color: var(--text-mid, var(--receipt-text-mid));
      border: 1px solid var(--border, var(--receipt-border));
    }

    .btn-ghost:hover {
      background: #f7faf8;
    }

    /* 좌측 목록 + 우측 영수증 */
    .receipt-layout {
      display: grid;
      grid-template-columns: 330px minmax(0, 1fr);
      gap: 18px;
      align-items: start;
      margin-bottom: 20px;
    }

    .receipt-list-panel {
      min-height: 540px;
    }

    .receipt-list {
      display: flex;
      flex-direction: column;
      gap: 10px;
    }

    .receipt-card {
      width: 100%;
      text-align: left;
      border: 1px solid var(--border, var(--receipt-border));
      border-radius: 13px;
      padding: 15px 16px;
      background: #fff;
      cursor: pointer;
      transition: all .18s ease;
    }

    .receipt-card:hover {
      border-color: #a6c5b1;
      background: #fbfdfb;
    }

    .receipt-card.active {
      border: 2px solid var(--green-dark, var(--receipt-green));
      background: #f4f9f5;
      padding: 14px 15px;
      box-shadow: 0 7px 18px rgba(37, 95, 66, .08);
    }

    .receipt-card-top {
      display: flex;
      justify-content: space-between;
      align-items: center;
      gap: 8px;
      margin-bottom: 9px;
    }

    .receipt-month {
      font-size: 14px;
      font-weight: 800;
      color: var(--receipt-green-deep);
    }

    .receipt-amount {
      font-size: 22px;
      line-height: 1.3;
      font-weight: 800;
      color: var(--receipt-text);
      margin-bottom: 8px;
    }

    .receipt-meta {
      font-size: 12px;
      color: var(--text-light, var(--receipt-text-light));
      line-height: 1.7;
    }

    .badge {
      display: inline-flex;
      align-items: center;
      padding: 4px 10px;
      border-radius: 999px;
      font-size: 11px;
      font-weight: 800;
      white-space: nowrap;
    }

    .badge.ok {
      background: #ecf7ef;
      color: #2f7a4d;
    }

    .badge.info {
      background: #edf4fb;
      color: #2d6688;
    }

    .empty-box {
      display: flex;
      align-items: center;
      justify-content: center;
      min-height: 170px;
      padding: 22px;
      border: 1px dashed #d5dfd8;
      border-radius: 12px;
      background: #fbfcfb;
      color: var(--text-light, var(--receipt-text-light));
      font-size: 13px;
      text-align: center;
      line-height: 1.8;
    }

    /* 상세 영수증 */
    .receipt-detail-panel {
      padding: 0;
      overflow: hidden;
    }

    .receipt-document {
      padding: 24px 24px 22px;
      background: #fff;
    }

    .receipt-document-head {
      display: flex;
      justify-content: space-between;
      align-items: flex-start;
      gap: 15px;
      margin-bottom: 20px;
    }

    .receipt-document-title {
      margin: 0;
      font-size: 21px;
      font-weight: 800;
      color: var(--receipt-green-deep);
      letter-spacing: -.35px;
    }

    .receipt-document-sub {
      margin: 7px 0 0;
      color: var(--text-light, var(--receipt-text-light));
      font-size: 12px;
    }

    .paid-stamp {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      padding: 8px 13px;
      border-radius: 9px;
      background: #eef7f0;
      color: #2f7a4d;
      font-size: 12px;
      font-weight: 800;
      white-space: nowrap;
    }

    .label-grid {
      display: grid;
      grid-template-columns: 112px minmax(150px, 1fr) 112px minmax(130px, 1fr);
      width: 100%;
      border: 1px solid var(--border, var(--receipt-border));
      border-radius: 12px;
      overflow: hidden;
      margin-bottom: 18px;
      background: #fff;
    }

    .label-grid .th {
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 12px 8px;
      background: var(--green-pale, var(--receipt-green-pale));
      color: var(--text-mid, var(--receipt-text-mid));
      font-size: 13px;
      font-weight: 700;
      text-align: center;
      white-space: nowrap;
      border-right: 1px solid var(--border, var(--receipt-border));
      border-bottom: 1px solid var(--border, var(--receipt-border));
    }

    .label-grid .td {
      display: flex;
      align-items: center;
      min-width: 0;
      padding: 12px 12px;
      color: var(--text-dark, var(--receipt-text));
      font-size: 13px;
      word-break: break-all;
      border-right: 1px solid var(--border, var(--receipt-border));
      border-bottom: 1px solid var(--border, var(--receipt-border));
    }

    .label-grid > div:nth-last-child(-n+4) {
      border-bottom: none;
    }

    .label-grid > div:nth-child(4n) {
      border-right: none;
    }

    .summary-box {
      display: flex;
      justify-content: space-between;
      align-items: center;
      gap: 15px;
      padding: 17px 18px;
      margin-bottom: 20px;
      border-radius: 12px;
      background: #f4f8f5;
      border: 1px solid #dbe7de;
    }

    .summary-label {
      font-size: 13px;
      font-weight: 700;
      color: var(--receipt-text-mid);
    }

    .summary-method {
      display: block;
      margin-top: 5px;
      color: var(--text-light, var(--receipt-text-light));
      font-size: 12px;
      font-weight: 400;
    }

    .summary-amount {
      font-size: 26px;
      font-weight: 800;
      color: var(--green-dark, var(--receipt-green));
      letter-spacing: -.5px;
      white-space: nowrap;
    }

    .data-table {
      width: 100%;
      border-collapse: collapse;
      font-size: 13px;
      background: #fff;
      overflow: hidden;
      border-radius: 12px;
      table-layout: fixed;
    }

    .data-table thead th {
      background: var(--green-pale, var(--receipt-green-pale));
      color: var(--text-mid, var(--receipt-text-mid));
      padding: 12px 10px;
      text-align: center;
      font-weight: 700;
      border-bottom: 1px solid var(--border, var(--receipt-border));
      white-space: nowrap;
    }

    .data-table tbody td {
      padding: 13px 10px;
      border-bottom: 1px solid #edf0eb;
      color: var(--text-dark, var(--receipt-text));
      vertical-align: middle;
      text-align: center;
    }

    /*
     * 상세 항목 테이블 정렬
     * 1열: 항목 / 2열: 설명 / 3열: 금액
     */
    .data-table tbody td:nth-child(1) {
      text-align: center;
      font-weight: 400;
    }

    .data-table tbody td:nth-child(2) {
      text-align: center;
      font-weight: 400;
      line-height: 1.55;
      word-break: keep-all;
      color: var(--text-dark, var(--receipt-text));
    }

    .data-table tbody td:nth-child(3) {
      text-align: right;
      padding-right: 22px;
      font-weight: 700;
      color: var(--receipt-green-deep);
      white-space: nowrap;
    }

    .data-table tbody tr:last-child td {
      border-bottom: none;
    }

    .data-table .total-row td {
      background: #f7faf8;
      font-weight: 800;
      color: var(--receipt-green-deep);
      border-top: 1px solid var(--border, var(--receipt-border));
    }

    .data-table .empty-cell {
      padding: 34px 10px;
      text-align: center !important;
      color: var(--text-light, var(--receipt-text-light));
      font-weight: 400 !important;
    }

    .detail-button-row {
      display: flex;
      justify-content: flex-end;
      gap: 10px;
      flex-wrap: wrap;
      padding: 0 24px 23px;
      background: #fff;
    }

    .guide-card {
      padding: 20px;
    }

    .bullet-list {
      margin: 0;
      padding-left: 18px;
      color: var(--text-mid, var(--receipt-text-mid));
      line-height: 1.9;
      font-size: 13px;
    }

    .bullet-list li + li {
      margin-top: 5px;
    }

    /* 로딩 */
    .loading-box {
      display: flex;
      align-items: center;
      justify-content: center;
      flex-direction: column;
      gap: 12px;
      min-height: 230px;
      color: var(--text-light, var(--receipt-text-light));
      font-size: 13px;
    }

    .spinner {
      width: 28px;
      height: 28px;
      border: 3px solid #dfe9e1;
      border-top-color: var(--green-dark, var(--receipt-green));
      border-radius: 50%;
      animation: spin .8s linear infinite;
    }

    @keyframes spin {
      to {
        transform: rotate(360deg);
      }
    }

    @media (max-width: 1200px) {
      .receipt-layout {
        grid-template-columns: 300px minmax(0, 1fr);
      }

      .label-grid {
        grid-template-columns: 96px minmax(125px, 1fr) 96px minmax(120px, 1fr);
      }

      .label-grid .th,
      .label-grid .td {
        font-size: 12px;
        padding: 10px 8px;
      }
    }

    @media (max-width: 980px) {
      .main-shell {
        flex-direction: column;
      }

      .content-area {
        padding: 24px 18px 48px;
      }

      .receipt-layout {
        grid-template-columns: 1fr;
      }

      .receipt-list-panel {
        min-height: auto;
      }
    }

    @media (max-width: 700px) {
      .label-grid {
        grid-template-columns: 92px 1fr;
      }

      .label-grid > div {
        border-right: none;
      }

      .label-grid > div:nth-last-child(-n+4) {
        border-bottom: 1px solid var(--border, var(--receipt-border));
      }

      .label-grid > div:nth-last-child(-n+2) {
        border-bottom: none;
      }

      .summary-box {
        align-items: flex-start;
        flex-direction: column;
      }
    }

    /* 인쇄/PDF 저장 */
    @media print {
      body {
        background: #fff !important;
      }

      header,
      footer,
      .breadcrumb,
      .page-title,
      .page-desc,
      .search-panel,
      .receipt-list-panel,
      .guide-card,
      .detail-button-row,
      aside {
        display: none !important;
      }

      .main-shell {
        margin-top: 0 !important;
        min-height: auto !important;
        display: block !important;
      }

      .content-area {
        padding: 0 !important;
      }

      .page-content-wrap {
        max-width: 100% !important;
      }

      .receipt-layout {
        display: block !important;
      }

      .receipt-detail-panel {
        border: none !important;
        box-shadow: none !important;
      }

      .receipt-document {
        padding: 0 !important;
      }
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
        <span class="cur">납부영수증</span>
      </div>

      <h1 class="page-title">납부영수증</h1>
      <p class="page-desc">
        납부 완료된 관리비 영수증을 확인할 수 있습니다.
        조회연도를 선택한 뒤 영수증을 클릭하면 항목별 납부 내역을 확인할 수 있습니다.
      </p>

      <!-- 조회 조건 -->
      <section class="panel search-panel">
        <div class="section-hd">
          <h3>영수증 조회</h3>
          <span>납부 완료 건만 조회됩니다.</span>
        </div>

        <div class="search-row">
          <div class="search-field">
            <label for="receiptYear">조회연도</label>
            <select id="receiptYear" class="search-select"></select>
          </div>

          <button type="button" class="btn-main" onclick="loadReceiptList()">조회</button>
          <button type="button" class="btn-sub" onclick="resetReceiptSearch()">초기화</button>
        </div>
      </section>

      <section class="receipt-layout">

        <!-- 좌측 영수증 목록 -->
        <div class="panel receipt-list-panel">
          <div class="section-hd">
            <h3>납부 완료 목록</h3>
            <span id="receiptCountText">총 0건</span>
          </div>

          <div id="receiptList" class="receipt-list">
            <div class="empty-box">
              조회연도를 선택한 후<br>
              조회 버튼을 눌러 주세요.
            </div>
          </div>
        </div>

        <!-- 우측 상세 영수증 -->
        <div class="panel receipt-detail-panel">
          <div id="receiptDetailEmpty" class="empty-box" style="margin:24px; min-height:350px;">
            확인할 영수증을 선택해 주세요.
          </div>

          <div id="receiptDocument" style="display:none;">
            <div class="receipt-document">

              <div class="receipt-document-head">
                <div>
                  <h2 id="receiptTitle" class="receipt-document-title">관리비 납부영수증</h2>
                  <p class="receipt-document-sub">
                    정상 납부 처리된 관리비 결제 내역입니다.
                  </p>
                </div>

                <div id="receiptStatusBadge" class="paid-stamp">납부완료</div>
              </div>

              <!-- 기본 정보 -->
              <div class="label-grid">
                <div class="th">영수증 번호</div>
                <div class="td" id="infoPymtNo">-</div>
                <div class="th">고지서 번호</div>
                <div class="td" id="infoBillNo">-</div>

                <div class="th">세대</div>
                <div class="td" id="infoDongHo">-</div>
                <div class="th">납부월</div>
                <div class="td" id="infoBillYm">-</div>

                <div class="th">납부일</div>
                <div class="td" id="infoPayDate">-</div>
                <div class="th">결제수단</div>
                <div class="td" id="infoPayMethod">-</div>

                <div class="th">거래번호</div>
                <div class="td" id="infoImpUid">-</div>
                <div class="th">처리상태</div>
                <div class="td" id="infoPayStatus">-</div>
              </div>

              <!-- 합계 -->
              <div class="summary-box">
                <div>
                  <span class="summary-label">총 납부금액</span>
                  <span class="summary-method" id="summaryDescription">-</span>
                </div>
                <div class="summary-amount" id="summaryAmount">0원</div>
              </div>

              <!-- 상세 항목 -->
              <div class="section-hd">
                <h3>청구 항목 및 영수증 내역</h3>
                <span>고지서 상세 기준</span>
              </div>

              <table class="data-table">
                <colgroup>
                  <!-- 항목 / 설명 / 금액 -->
                  <col style="width:23%;">
                  <col style="width:57%;">
                  <col style="width:20%;">
                </colgroup>
                <thead>
                <tr>
                  <th>항목</th>
                  <th>설명</th>
                  <th>금액</th>
                </tr>
                </thead>
                <tbody id="receiptDetailTbody">
                <tr>
                  <td colspan="3" class="empty-cell">영수증 상세 내역이 없습니다.</td>
                </tr>
                </tbody>
              </table>
            </div>

            <div class="detail-button-row">
              <button type="button" class="btn-main" onclick="printReceipt()">인쇄</button>
              <button type="button" class="btn-sub" onclick="showReceiptNumber()">영수증 번호 확인</button>
              <button type="button" class="btn-ghost" onclick="scrollToReceiptList()">목록으로</button>
            </div>
          </div>
        </div>
      </section>

      <!-- 안내 -->
      <section class="card guide-card">
        <div class="section-hd">
          <h3>발급 안내</h3>
          <span>참고</span>
        </div>

        <ul class="bullet-list">
          <li>납부 완료 처리된 관리비에 한해 영수증을 조회할 수 있습니다.</li>
          <li>인쇄 버튼을 누르면 브라우저 인쇄창에서 PDF 파일로 저장할 수 있습니다.</li>
          <li>결제 오류 또는 납부내역 문의가 필요한 경우 관리사무소 또는 1:1 문의를 이용해 주세요.</li>
        </ul>
      </section>

    </div>
  </main>
</div>

<%@ include file="/WEB-INF/views/include/apt_footerLayout.jsp" %>

<!-- SweetAlert2 -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script>
  const contextPath = '${pageContext.request.contextPath}';

  /*
   * 영수증 API
   * - 영수증 목록: 납부완료 PAYMENT 목록
   * - 상세 항목  : 기존 관리비 상세 API 재사용
   */
  const RECEIPT_LIST_API = contextPath + '/resident/payment/receipt/list';
  const BILL_DETAIL_API = contextPath + '/resident/bill/detail/';

  let currentReceiptList = [];
  let selectedReceipt = null;

  document.addEventListener('DOMContentLoaded', function () {
    initializeYearSelect();

    /*
     * 영수증 화면은 납부 완료 내역을 확인하는 페이지이므로
     * 진입 즉시 현재연도 영수증 목록을 조회한다.
     */
    loadReceiptList();
  });

  /**
   * 조회연도 select 생성
   * 현재 연도부터 최근 5개년도까지 제공
   */
  function initializeYearSelect() {
    const select = document.getElementById('receiptYear');
    const currentYear = new Date().getFullYear();

    select.innerHTML = '';

    for (let i = 0; i < 5; i++) {
      const year = currentYear - i;
      const option = document.createElement('option');

      option.value = String(year);
      option.textContent = year + '년';

      if (i === 0) {
        option.selected = true;
      }

      select.appendChild(option);
    }
  }

  /**
   * 초기화
   */
  function resetReceiptSearch() {
    initializeYearSelect();
    loadReceiptList();
  }

  /**
   * 납부완료 영수증 목록 조회
   */
  async function loadReceiptList() {
    const billYear = document.getElementById('receiptYear').value;
    const listWrap = document.getElementById('receiptList');

    clearReceiptDetail();

    listWrap.innerHTML =
            '<div class="loading-box">' +
            '  <div class="spinner"></div>' +
            '  <div>납부영수증을 조회하고 있습니다.</div>' +
            '</div>';

    try {
      const response = await fetch(
              RECEIPT_LIST_API + '?billYear=' + encodeURIComponent(billYear)
      );

      if (!response.ok) {
        throw new Error('영수증 목록 조회에 실패했습니다. 상태코드: ' + response.status);
      }

      const result = await response.json();

      if (!result.success) {
        throw new Error(result.message || '영수증 목록 조회에 실패했습니다.');
      }

      currentReceiptList = result.list || [];

      renderReceiptList(currentReceiptList);

      if (currentReceiptList.length > 0) {
        await selectReceipt(currentReceiptList[0].pymtNo);
      }

    } catch (error) {
      console.error('납부영수증 목록 조회 오류 =', error);

      currentReceiptList = [];

      document.getElementById('receiptCountText').textContent = '총 0건';

      listWrap.innerHTML =
              '<div class="empty-box">' +
              '  영수증 목록 조회 중 오류가 발생했습니다.<br>' +
              '  잠시 후 다시 시도해 주세요.' +
              '</div>';

      await Swal.fire({
        icon: 'error',
        title: '조회 실패',
        text: error.message || '납부영수증 목록을 조회하지 못했습니다.',
        confirmButtonText: '확인',
        confirmButtonColor: '#255f42'
      });
    }
  }

  /**
   * 좌측 영수증 카드 목록 출력
   */
  function renderReceiptList(list) {
    const listWrap = document.getElementById('receiptList');
    const countText = document.getElementById('receiptCountText');

    countText.textContent = '총 ' + list.length + '건';

    if (!list || list.length === 0) {
      listWrap.innerHTML =
              '<div class="empty-box">' +
              '  선택한 연도에 납부 완료된<br>' +
              '  관리비 영수증이 없습니다.' +
              '</div>';
      return;
    }

    let html = '';

    list.forEach(function (receipt) {
      html +=
              '<button type="button" class="receipt-card" ' +
              '        id="receiptCard_' + escapeHtml(receipt.pymtNo) + '" ' +
              '        onclick="selectReceipt(\'' + escapeJs(receipt.pymtNo) + '\')">' +
              '  <div class="receipt-card-top">' +
              '    <span class="receipt-month">' + escapeHtml(formatBillYm(receipt.billYm)) + '</span>' +
              '    <span class="badge ok">' + escapeHtml(receipt.paySttsNm || '납부완료') + '</span>' +
              '  </div>' +
              '  <div class="receipt-amount">' + formatNumber(receipt.payAmt) + '원</div>' +
              '  <div class="receipt-meta">' +
              '    세대: ' + escapeHtml(receipt.displayDongHo || '-') + '<br>' +
              '    납부일: ' + escapeHtml(formatDate(receipt.payCmplDt)) + '<br>' +
              '    결제수단: ' + escapeHtml(receipt.payMthdNm || '-') +
              '  </div>' +
              '</button>';
    });

    listWrap.innerHTML = html;
  }

  /**
   * 선택한 영수증 상세 표시
   *
   * 기본 영수증 정보는 receipt/list 결과를 사용하고,
   * 항목별 상세는 기존 bill/detail API에서 가져온다.
   */
  async function selectReceipt(pymtNo) {
    const receipt = currentReceiptList.find(function (item) {
      return item.pymtNo === pymtNo;
    });

    if (!receipt) {
      return;
    }

    selectedReceipt = receipt;

    setActiveReceiptCard(pymtNo);
    renderReceiptBasicInfo(receipt);

    const tbody = document.getElementById('receiptDetailTbody');

    tbody.innerHTML =
            '<tr>' +
            '  <td colspan="3" class="empty-cell">상세 항목을 조회하고 있습니다.</td>' +
            '</tr>';

    try {
      const response = await fetch(
              BILL_DETAIL_API + encodeURIComponent(receipt.billNo)
      );

      if (!response.ok) {
        throw new Error('상세 내역 조회에 실패했습니다. 상태코드: ' + response.status);
      }

      const result = await response.json();

      if (!result.success) {
        throw new Error(result.message || '상세 내역 조회에 실패했습니다.');
      }

      /*
       * 기존 관리비 상세 API 응답 구조:
       * {
       *   success: true,
       *   bill: {
       *     detailList: [...]
       *   }
       * }
       */
      const bill = result.bill || result.data || result;
      const detailList = bill.detailList || [];

      renderReceiptDetailList(detailList, receipt.payAmt);

    } catch (error) {
      console.error('영수증 상세 항목 조회 오류 =', error);

      tbody.innerHTML =
              '<tr>' +
              '  <td colspan="3" class="empty-cell">상세 항목을 불러오지 못했습니다.</td>' +
              '</tr>';
    }
  }

  /**
   * 선택 카드 active 처리
   */
  function setActiveReceiptCard(pymtNo) {
    document.querySelectorAll('.receipt-card').forEach(function (card) {
      card.classList.remove('active');
    });

    const selectedCard = document.getElementById('receiptCard_' + pymtNo);

    if (selectedCard) {
      selectedCard.classList.add('active');
    }
  }

  /**
   * 영수증 기본정보 출력
   */
  function renderReceiptBasicInfo(receipt) {
    document.getElementById('receiptDetailEmpty').style.display = 'none';
    document.getElementById('receiptDocument').style.display = 'block';

    document.getElementById('receiptTitle').textContent =
            formatBillYm(receipt.billYm) + ' 관리비 납부영수증';

    document.getElementById('receiptStatusBadge').textContent =
            receipt.paySttsNm || '납부완료';

    document.getElementById('infoPymtNo').textContent = receipt.pymtNo || '-';
    document.getElementById('infoBillNo').textContent = receipt.billNo || '-';
    document.getElementById('infoDongHo').textContent = receipt.displayDongHo || '-';
    document.getElementById('infoBillYm').textContent = formatBillYm(receipt.billYm);
    document.getElementById('infoPayDate').textContent = formatDate(receipt.payCmplDt);
    document.getElementById('infoPayMethod').textContent = receipt.payMthdNm || '-';
    document.getElementById('infoImpUid').textContent = receipt.impUid || '-';
    document.getElementById('infoPayStatus').textContent = receipt.paySttsNm || '납부완료';

    document.getElementById('summaryAmount').textContent =
            formatNumber(receipt.payAmt) + '원';

    document.getElementById('summaryDescription').textContent =
            (receipt.payMthdNm || '결제') + ' 승인 완료 · ' +
            formatDate(receipt.payCmplDt);
  }

  /**
   * 관리비 항목별 영수증 테이블 출력
   */
  function renderReceiptDetailList(detailList, totalAmount) {
    const tbody = document.getElementById('receiptDetailTbody');

    if (!detailList || detailList.length === 0) {
      tbody.innerHTML =
              '<tr>' +
              '  <td colspan="3" class="empty-cell">등록된 상세 항목이 없습니다.</td>' +
              '</tr>';
      return;
    }

    let html = '';

    detailList.forEach(function (detail) {
      html +=
              '<tr>' +
              '  <td>' + escapeHtml(detail.billItemNm || detail.billItemCd || '-') + '</td>' +
              '  <td>' + escapeHtml(detail.billItemContent || '-') + '</td>' +
              '  <td>' + formatNumber(detail.billItemAmt) + '원</td>' +
              '</tr>';
    });

    html +=
            '<tr class="total-row">' +
            '  <td>합계</td>' +
            '  <td>납부 완료 금액</td>' +
            '  <td>' + formatNumber(totalAmount) + '원</td>' +
            '</tr>';

    tbody.innerHTML = html;
  }

  /**
   * 상세 영역 초기화
   */
  function clearReceiptDetail() {
    selectedReceipt = null;

    document.getElementById('receiptDetailEmpty').style.display = 'flex';
    document.getElementById('receiptDocument').style.display = 'none';

    document.getElementById('receiptDetailTbody').innerHTML =
            '<tr>' +
            '  <td colspan="3" class="empty-cell">영수증 상세 내역이 없습니다.</td>' +
            '</tr>';
  }

  /**
   * 브라우저 인쇄 기능 활용
   * 인쇄 대화상자에서 PDF로 저장 가능
   */
  function printReceipt() {
    if (!selectedReceipt) {
      Swal.fire({
        icon: 'warning',
        title: '영수증을 선택해 주세요',
        text: '인쇄할 영수증을 먼저 선택해 주세요.',
        confirmButtonText: '확인',
        confirmButtonColor: '#255f42'
      });
      return;
    }

    window.print();
  }

  /**
   * 영수증 번호 안내
   */
  function showReceiptNumber() {
    if (!selectedReceipt) {
      return;
    }

    Swal.fire({
      icon: 'success',
      title: '납부영수증 정보',
      html:
              '<div style="text-align:left; line-height:1.9; padding:5px 8px;">' +
              '  <b>영수증 번호</b> : ' + escapeHtml(selectedReceipt.pymtNo || '-') + '<br>' +
              '  <b>고지서 번호</b> : ' + escapeHtml(selectedReceipt.billNo || '-') + '<br>' +
              '  <b>결제 거래번호</b> : ' + escapeHtml(selectedReceipt.impUid || '-') +
              '</div>',
      confirmButtonText: '확인',
      confirmButtonColor: '#255f42'
    });
  }

  /**
   * 좌측 목록 위치로 이동
   */
  function scrollToReceiptList() {
    const listPanel = document.querySelector('.receipt-list-panel');

    if (listPanel) {
      listPanel.scrollIntoView({
        behavior: 'smooth',
        block: 'start'
      });
    }
  }

  /**
   * YYYYMM → YYYY년 MM월
   */
  function formatBillYm(billYm) {
    if (!billYm || String(billYm).length < 6) {
      return '-';
    }

    const value = String(billYm);
    const year = value.substring(0, 4);
    const month = Number(value.substring(4, 6));

    return year + '년 ' + month + '월';
  }

  /**
   * 날짜 표시 변환
   * ISO 문자열, YYYY-MM-DD 문자열 모두 처리
   */
  function formatDate(value) {
    if (!value) {
      return '-';
    }

    const stringValue = String(value);

    if (stringValue.length >= 10) {
      return stringValue.substring(0, 10);
    }

    return stringValue;
  }

  /**
   * 금액 천 단위 콤마
   */
  function formatNumber(value) {
    const numberValue = Number(value || 0);

    return numberValue.toLocaleString('ko-KR');
  }

  /**
   * HTML 이스케이프
   */
  function escapeHtml(value) {
    return String(value == null ? '' : value)
            .replaceAll('&', '&amp;')
            .replaceAll('<', '&lt;')
            .replaceAll('>', '&gt;')
            .replaceAll('"', '&quot;')
            .replaceAll("'", '&#39;');
  }

  /**
   * onclick 문자열용 이스케이프
   */
  function escapeJs(value) {
    return String(value == null ? '' : value)
            .replaceAll('\\', '\\\\')
            .replaceAll("'", "\\'");
  }
</script>

</body>
</html>