<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>관리사무소</title>

  <sec:csrfMetaTags/>

  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
  <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet" />

  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/office-layout.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/manager-common.css">

  <style>
    .bill-charge-layout {
      display: grid;
      grid-template-columns: minmax(0, 1fr) 420px;
      gap: 18px;
      align-items: start;
    }

    .bill-charge-main {
      display: grid;
      grid-template-columns: minmax(0, 1fr);
      gap: 14px;
    }

    .bill-card-body {
      padding: 16px 20px 18px;
    }

    .bill-horizontal-form {
      display: grid;
      grid-template-columns: minmax(220px, 1.5fr) auto;
      gap: 10px;
      align-items: end;
    }

    .bill-info-box {
      display: none;
      background: #f0f7f2;
      border: 1px solid #a8ccb0;
      border-radius: 8px;
      padding: 12px 16px;
      margin-top: 12px;
    }

    .bill-info-grid {
      display: grid;
      grid-template-columns: repeat(4, minmax(0, 1fr));
      gap: 12px;
      font-size: 12px;
    }

    .bill-info-label {
      color: var(--text-tertiary);
      margin-bottom: 2px;
    }

    .bill-info-value {
      font-weight: 700;
      color: var(--text-primary);
    }

    .bill-info-value.warning {
      color: #d97706;
    }

    .bill-setting-row {
      display: grid;
      grid-template-columns: repeat(3, minmax(180px, 1fr));
      gap: 14px;
    }

    .bill-item-table {
      width: 100%;
      border-collapse: collapse;
    }

    .bill-item-table th {
      padding: 8px 0;
      font-size: 11px;
      font-weight: 700;
      color: var(--text-tertiary);
      text-align: left;
      border-bottom: 1px solid var(--border);
    }

    .bill-item-table td {
      padding: 7px 0;
      border-bottom: 1px solid var(--border);
    }

    .bill-item-table .item-name-cell {
      padding-left: 10px;
    }

    .bill-item-table .amount-head {
      text-align: right;
    }

    .bill-item-table .remove-head {
      width: 36px;
    }

    .bill-item-table .form-input {
      height: 32px;
      font-size: 12px;
    }

    .bill-item-table .amount-input {
      text-align: right;
    }

    .bill-remove-btn {
      border: none;
      background: none;
      color: #dc2626;
      cursor: pointer;
      font-size: 18px;
      line-height: 1;
    }

    .bill-total-row {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 12px 0;
      border-top: 1px solid var(--border);
      margin-top: 4px;
    }

    .bill-total-label {
      font-size: 12px;
      font-weight: 700;
      color: var(--text-secondary);
    }

    .bill-total-value {
      font-size: 18px;
      font-weight: 900;
      color: #2e5c38;
    }

    .bill-file-box {
      border: 2px dashed var(--border);
      border-radius: 8px;
      padding: 14px 16px;
      text-align: center;
      cursor: pointer;
      background: #fafafa;
    }

    .bill-file-box .material-symbols-rounded {
      font-size: 24px;
      color: var(--text-tertiary);
      display: block;
      margin-bottom: 4px;
    }

    .bill-file-text {
      font-size: 12px;
      color: var(--text-secondary);
    }

    .bill-file-name {
      font-size: 12px;
      color: #2e5c38;
      margin-top: 6px;
      display: none;
    }

    .bill-generate-btn {
      width: 100%;
      padding: 14px;
      font-size: 14px;
      font-weight: 800;
      border-radius: 10px;
    }

    .bill-preview-wrap {
      position: sticky;
      top: 20px;
    }

    .bill-preview {
      background: var(--card);
      border: 1px solid var(--border);
      border-radius: 14px;
      overflow: hidden;
      box-shadow: var(--shadow-sm);
    }

    .bill-preview-head {
      background: #2e5c38;
      padding: 16px 20px;
      display: flex;
      align-items: center;
      justify-content: space-between;
    }

    .bill-preview-brand {
      display: flex;
      align-items: center;
      gap: 10px;
    }

    .bill-preview-icon {
      width: 30px;
      height: 30px;
      background: rgba(255, 255, 255, 0.2);
      border-radius: 8px;
      display: flex;
      align-items: center;
      justify-content: center;
    }

    .bill-preview-icon .material-symbols-rounded {
      color: #fff;
      font-size: 16px;
    }

    .bill-preview-title {
      font-size: 13px;
      font-weight: 800;
      color: #fff;
    }

    .bill-preview-sub {
      font-size: 10px;
      color: rgba(255, 255, 255, 0.65);
    }

    .bill-preview-ym {
      font-size: 10px;
      color: rgba(255, 255, 255, 0.65);
      text-align: right;
    }

    .bill-preview-body {
      padding: 18px 20px;
      display: flex;
      flex-direction: column;
      gap: 14px;
    }

    .bill-preview-date-grid {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 10px;
    }

    .bill-preview-date-card {
      background: #f7f8f9;
      border-radius: 8px;
      padding: 10px 12px;
    }

    .bill-preview-label {
      font-size: 10px;
      color: var(--text-tertiary);
      margin-bottom: 3px;
    }

    .bill-preview-date {
      font-size: 13px;
      font-weight: 700;
    }

    .bill-preview-date.due {
      color: #dc2626;
    }

    .bill-preview-items {
      display: flex;
      flex-direction: column;
      gap: 6px;
      min-height: 60px;
    }

    .bill-preview-empty {
      font-size: 12px;
      color: var(--text-tertiary);
      text-align: center;
      padding: 16px 0;
    }

    .bill-preview-item-list {
      border-top: 1px solid var(--border);
      padding-top: 10px;
    }

    .bill-preview-item {
      display: flex;
      justify-content: space-between;
      padding: 6px 0;
      border-bottom: 1px solid #f0f0f0;
      font-size: 12px;
    }

    .bill-preview-item span:first-child {
      color: var(--text-secondary);
    }

    .bill-preview-item span:last-child {
      font-weight: 700;
    }

    .bill-preview-total {
      background: #2e5c38;
      border-radius: 10px;
      padding: 14px 16px;
      display: flex;
      align-items: center;
      justify-content: space-between;
    }

    .bill-preview-total-label {
      font-size: 11px;
      color: rgba(255, 255, 255, 0.7);
    }

    .bill-preview-total-value {
      font-size: 20px;
      font-weight: 900;
      color: #fff;
    }

    .bill-preview-note {
      font-size: 10px;
      color: var(--text-tertiary);
      text-align: center;
    }

    .bill-unpaid-note {
      padding: 10px 20px 16px;
      font-size: 11px;
      color: var(--text-tertiary);
    }

    .bill-status-badge {
      display: inline-flex;
      padding: 2px 8px;
      border-radius: 4px;
      font-size: 11px;
      font-weight: 700;
    }

    .text-right {
      text-align: right;
    }

    @media (max-width: 1200px) {
      .bill-charge-layout {
        grid-template-columns: 1fr;
      }

      .bill-preview-wrap {
        position: static;
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
      <div class="office-page" id="billChargePage">

        <div class="page-header">
          <div class="page-title-block">
            <h2>고지서 등록</h2>
            <p>단지별 관리비 고지서와 항목 내역을 일괄 생성합니다.</p>
          </div>
        </div>

        <div class="bill-charge-layout">

          <div class="bill-charge-main">

            <div class="panel">
              <div class="panel-header">
                <h3 class="panel-title">
                  <span class="material-symbols-rounded">apartment</span>
                  단지 선택
                </h3>
              </div>

              <div class="bill-card-body">
                <div class="bill-horizontal-form">
                  <div class="form-field">
                    <label class="field-label">아파트 단지</label>
                    <select class="form-select" id="aptCmplexNo">
                      <option value="">단지를 선택하세요</option>
                      <option value="APT-001">푸르지오 1단지 (APT-001)</option>
                      <option value="APT-002">래미안 2단지 (APT-002)</option>
                      <option value="APT-003">힐스테이트 3단지 (APT-003)</option>
                    </select>
                  </div>

                  <button type="button" class="btn btn-primary" id="btnLoadComplex">조회</button>
                </div>

                <div id="complexInfo" class="bill-info-box">
                  <div class="bill-info-grid">
                    <div>
                      <div class="bill-info-label">단지명</div>
                      <div class="bill-info-value" id="ciNm">—</div>
                    </div>
                    <div>
                      <div class="bill-info-label">총 세대수</div>
                      <div class="bill-info-value" id="ciUnit">—</div>
                    </div>
                    <div>
                      <div class="bill-info-label">동 수</div>
                      <div class="bill-info-value" id="ciDong">—</div>
                    </div>
                    <div>
                      <div class="bill-info-label">전월 미납</div>
                      <div class="bill-info-value warning" id="ciUnpaid">—</div>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <div class="panel">
              <div class="panel-header">
                <h3 class="panel-title">
                  <span class="material-symbols-rounded">calendar_month</span>
                  부과 기본 설정
                </h3>
              </div>

              <div class="bill-card-body">
                <div class="bill-setting-row">
                  <div class="form-field">
                    <label class="field-label">관리비 연월 <span class="req">*</span></label>
                    <input type="month" class="form-input" id="billYm">
                  </div>

                  <div class="form-field">
                    <label class="field-label">고지일자 <span class="req">*</span></label>
                    <input type="date" class="form-input" id="billPblancDt">
                  </div>

                  <div class="form-field">
                    <label class="field-label">납부기한 <span class="req">*</span></label>
                    <input type="date" class="form-input" id="dueDt">
                  </div>
                </div>
              </div>
            </div>

            <div class="panel">
              <div class="panel-header">
                <h3 class="panel-title">
                  <span class="material-symbols-rounded">list_alt</span>
                  항목별 금액 설정
                </h3>

                <button type="button" class="btn btn-sm btn-primary" id="btnAddItem">
                  <span class="material-symbols-rounded">add</span>
                  항목 추가
                </button>
              </div>

              <div class="bill-card-body">
                <table class="bill-item-table" id="itemTable">
                  <thead>
                  <tr>
                    <th>항목 코드</th>
                    <th class="item-name-cell">항목명</th>
                    <th class="amount-head">금액</th>
                    <th class="remove-head"></th>
                  </tr>
                  </thead>
                  <tbody id="itemTableBody"></tbody>
                </table>

                <div class="bill-total-row">
                  <span class="bill-total-label">총 부과 금액</span>
                  <span class="bill-total-value" id="totalAmt">₩0</span>
                </div>

                <div class="form-field">
                  <label class="field-label">산출 근거 첨부</label>

                  <div class="bill-file-box" id="billFileTrigger">
                    <span class="material-symbols-rounded">upload_file</span>
                    <div class="bill-file-text">엑셀 또는 PDF 파일을 업로드하세요</div>
                  </div>

                  <input type="file" id="billAtchFile" accept=".xlsx,.xls,.pdf" style="display:none;">
                  <div id="billAtchFileNm" class="bill-file-name"></div>
                </div>
              </div>
            </div>

            <div class="panel" id="unpaidPanel" style="display:none;">
              <div class="panel-header">
                <h3 class="panel-title">
                  <span class="material-symbols-rounded">warning</span>
                  전월 미납 세대
                </h3>
                <span class="list-count" id="unpaidCount">0건</span>
              </div>

              <div class="table-wrap">
                <table class="tbl">
                  <thead>
                  <tr>
                    <th>호번호</th>
                    <th>부과월</th>
                    <th class="text-right">미납 금액</th>
                    <th class="text-right">연체료</th>
                    <th>상태</th>
                  </tr>
                  </thead>
                  <tbody id="unpaidTableBody"></tbody>
                </table>
              </div>

              <div class="bill-unpaid-note">
                ※ 이번 고지서 생성 시 연체료가 자동 포함됩니다.
              </div>
            </div>

            <button type="button" class="btn btn-primary bill-generate-btn" id="btnGenerate">
              <span class="material-symbols-rounded">receipt_long</span>
              고지서 일괄 생성
            </button>
          </div>

          <div class="bill-preview-wrap">
            <div class="bill-preview">

              <div class="bill-preview-head">
                <div class="bill-preview-brand">
                  <div class="bill-preview-icon">
                    <span class="material-symbols-rounded">home_work</span>
                  </div>

                  <div>
                    <div class="bill-preview-title">우리집맵핑</div>
                    <div class="bill-preview-sub">관리비 고지서 미리보기</div>
                  </div>
                </div>

                <div class="bill-preview-ym">
                  <div>부과 연월</div>
                  <div id="pvYm">—</div>
                </div>
              </div>

              <div class="bill-preview-body">
                <div class="bill-preview-date-grid">
                  <div class="bill-preview-date-card">
                    <div class="bill-preview-label">고지일</div>
                    <div class="bill-preview-date" id="pvPblancDt">—</div>
                  </div>

                  <div class="bill-preview-date-card">
                    <div class="bill-preview-label">납부기한</div>
                    <div class="bill-preview-date due" id="pvDueDt">—</div>
                  </div>
                </div>

                <div id="pvItems" class="bill-preview-items">
                  <div class="bill-preview-empty">항목을 추가하면 여기에 표시됩니다.</div>
                </div>

                <div class="bill-preview-total">
                  <div class="bill-preview-total-label">총 납부 금액</div>
                  <div class="bill-preview-total-value" id="pvTotal">₩0</div>
                </div>

                <div class="bill-preview-note">
                  ※ 샘플 미리보기입니다. 실제 발송 시 세대별로 생성됩니다.
                </div>
              </div>
            </div>
          </div>

        </div>
      </div>
    </main>
  </div>
</div>

<script>
  document.addEventListener("DOMContentLoaded", function () {
    initBillChargePage();
  });

  function initBillChargePage() {
    var page = document.getElementById("billChargePage");
    if (!page) return;

    var complexData = {
      "APT-001": { nm: "푸르지오 1단지", unitCnt: 480, dongCnt: 6 },
      "APT-002": { nm: "래미안 2단지", unitCnt: 320, dongCnt: 4 },
      "APT-003": { nm: "힐스테이트 3단지", unitCnt: 560, dongCnt: 7 }
    };

    var unpaidData = {
      "APT-001": [
        { hoNo: "101-803", billYm: "202603", billTotAmt: 210000, lateFeeAmt: 6300, pymtSttsCd: "OVERDUE" },
        { hoNo: "102-501", billYm: "202603", billTotAmt: 185000, lateFeeAmt: 0, pymtSttsCd: "UNPAID" },
        { hoNo: "103-1102", billYm: "202603", billTotAmt: 230000, lateFeeAmt: 6900, pymtSttsCd: "OVERDUE" }
      ],
      "APT-002": [
        { hoNo: "201-402", billYm: "202603", billTotAmt: 195000, lateFeeAmt: 0, pymtSttsCd: "UNPAID" }
      ],
      "APT-003": []
    };

    var defaultItems = [
      { cd: "ELEC", nm: "전기 요금", amt: 38920 },
      { cd: "WATER", nm: "수도 요금", amt: 12400 },
      { cd: "GAS", nm: "가스 요금", amt: 9000 },
      { cd: "COMMON", nm: "공용 관리비", amt: 45000 }
    ];

    var items = JSON.parse(JSON.stringify(defaultItems));

    var STTS_STYLE = {
      UNPAID: { text: "미납", bg: "#fff0e0", color: "#92400e" },
      OVERDUE: { text: "장기연체", bg: "#f5e8d0", color: "#6b3d0a" }
    };

    function loadComplex() {
      var cd = document.getElementById("aptCmplexNo").value;

      if (!cd) {
        alert("단지를 선택하세요.");
        return;
      }

      var info = complexData[cd];
      var unpaid = unpaidData[cd] || [];

      document.getElementById("complexInfo").style.display = "block";
      document.getElementById("ciNm").textContent = info.nm;
      document.getElementById("ciUnit").textContent = info.unitCnt.toLocaleString() + "세대";
      document.getElementById("ciDong").textContent = info.dongCnt + "동";
      document.getElementById("ciUnpaid").textContent = unpaid.length + "건";

      if (unpaid.length > 0) {
        document.getElementById("unpaidPanel").style.display = "block";
        document.getElementById("unpaidCount").textContent = unpaid.length + "건";

        document.getElementById("unpaidTableBody").innerHTML = unpaid.map(function (row) {
          var status = STTS_STYLE[row.pymtSttsCd] || { text: "-", bg: "#f3f4f6", color: "#4b5563" };

          return '<tr>'
                  + '<td class="td-bold">' + row.hoNo + '</td>'
                  + '<td>' + row.billYm.slice(0, 4) + "-" + row.billYm.slice(4) + '</td>'
                  + '<td class="text-right" style="font-weight:700; color:#dc2626;">₩' + row.billTotAmt.toLocaleString() + '</td>'
                  + '<td class="text-right" style="color:#d97706; font-weight:700;">'
                  + (row.lateFeeAmt > 0 ? '₩' + row.lateFeeAmt.toLocaleString() : '-') + '</td>'
                  + '<td><span class="bill-status-badge" style="background:' + status.bg + '; color:' + status.color + ';">' + status.text + '</span></td>'
                  + '</tr>';
        }).join("");
        document.getElementById("unpaidPanel").style.display = "none";
      }
    }

    function renderItems() {
      var tbody = document.getElementById("itemTableBody");

      tbody.innerHTML = items.map(function (item, idx) {
        return '<tr>'
                + '<td>'
                + '<input type="text" class="form-input" value="' + item.cd + '" data-field="cd" data-idx="' + idx + '" placeholder="예: ELEC">'
                + '</td>'
                + '<td class="item-name-cell">'
                + '<input type="text" class="form-input" value="' + item.nm + '" data-field="nm" data-idx="' + idx + '" placeholder="예: 전기 요금">'
                + '</td>'
                + '<td>'
                + '<input type="number" class="form-input amount-input" value="' + item.amt + '" data-field="amt" data-idx="' + idx + '" placeholder="0">'
                + '</td>'
                + '<td style="text-align:center;">'
                + '<button type="button" class="bill-remove-btn" data-action="removeItem" data-idx="' + idx + '">×</button>'
                + '</td>'
                + '</tr>';
      }).join("");

      calcTotal();
      updatePreview();
    }

    function calcTotal() {
      var total = items.reduce(function (sum, item) {
        return sum + (Number(item.amt) || 0);
      }, 0);

      document.getElementById("totalAmt").textContent = "₩" + total.toLocaleString();

      return total;
    }

    function updatePreview() {
      var ym = document.getElementById("billYm").value;
      var pblancDt = document.getElementById("billPblancDt").value;
      var dueDt = document.getElementById("dueDt").value;
      var total = calcTotal();

      document.getElementById("pvYm").textContent = ym ? ym.replace("-", "년 ") + "월" : "—";
      document.getElementById("pvPblancDt").textContent = pblancDt ? pblancDt.replace(/-/g, ".") : "—";
      document.getElementById("pvDueDt").textContent = dueDt ? dueDt.replace(/-/g, ".") : "—";
      document.getElementById("pvTotal").textContent = "₩" + total.toLocaleString();

      var pvItems = document.getElementById("pvItems");

      if (items.length === 0) {
        pvItems.innerHTML = '<div class="bill-preview-empty">항목을 추가하면 여기에 표시됩니다.</div>';
        return;
      }

      pvItems.innerHTML = '<div class="bill-preview-item-list">'
              + items.map(function (item) {
                return '<div class="bill-preview-item">'
                        + '<span>' + (item.nm || item.cd || "—") + '</span>'
                        + '<span>₩' + (Number(item.amt) || 0).toLocaleString() + '</span>'
                        + '</div>';
              }).join("")
              + '</div>';
    }

    document.getElementById("btnLoadComplex").addEventListener("click", loadComplex);

    ["billYm", "billPblancDt", "dueDt"].forEach(function (id) {
      document.getElementById(id).addEventListener("input", updatePreview);
    });

    document.getElementById("btnAddItem").addEventListener("click", function () {
      items.push({ cd: "", nm: "", amt: 0 });
      renderItems();
    });

    document.getElementById("itemTableBody").addEventListener("input", function (event) {
      var el = event.target;
      var field = el.dataset.field;
      var idx = el.dataset.idx;

      if (field === undefined || idx === undefined) return;

      items[Number(idx)][field] = field === "amt" ? Number(el.value) || 0 : el.value;

      calcTotal();
      updatePreview();
    });

    document.getElementById("itemTableBody").addEventListener("click", function (event) {
      var btn = event.target.closest("[data-action='removeItem']");
      if (!btn) return;

      items.splice(Number(btn.dataset.idx), 1);
      renderItems();
    });

    document.getElementById("billFileTrigger").addEventListener("click", function () {
      document.getElementById("billAtchFile").click();
    });

    document.getElementById("billAtchFile").addEventListener("change", function () {
      if (this.files.length > 0) {
        var fileNameBox = document.getElementById("billAtchFileNm");
        fileNameBox.style.display = "block";
        fileNameBox.textContent = "✓ " + this.files[0].name;
      }
    });

    document.getElementById("btnGenerate").addEventListener("click", function () {
      var cd = document.getElementById("aptCmplexNo").value;
      var ym = document.getElementById("billYm").value;
      var pblancDt = document.getElementById("billPblancDt").value;
      var dueDt = document.getElementById("dueDt").value;

      if (!cd) {
        alert("단지를 선택하세요.");
        return;
      }

      if (!ym) {
        alert("관리비 연월을 입력하세요.");
        return;
      }

      if (!pblancDt) {
        alert("고지일자를 입력하세요.");
        return;
      }

      if (!dueDt) {
        alert("납부기한을 입력하세요.");
        return;
      }

      if (items.length === 0) {
        alert("항목을 1개 이상 추가하세요.");
        return;
      }

      alert("고지서 일괄 생성 처리 연결 예정입니다.");
    });

    renderItems();
    updatePreview();
  }
</script>
</body>
</html>