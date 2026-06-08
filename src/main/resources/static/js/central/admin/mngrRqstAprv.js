/* =========================================================
   mngrRqstAprv.js
   중앙관리자에서 -> 단지관리자 직원계정 관리 JSP DB 연동 스크립트
   - fetch API로 Controller와 통신한다.
   - fetch란? 브라우저에서 서버 URL로 데이터를 요청하는 JavaScript 기능.
   - 왜 사용? JSP 새로고침 없이 목록/승인/반려/상태 처리를 하기 위해 사용한다.
========================================================= */

const API_BASE = window.APP_CTX + "/centralAdmin/mngrRqstAprv";
const PAGE_SIZE = 10;

// CSRF 토큰 가져오기
const CSRF_TOKEN = document.querySelector('meta[name="_csrf"]')?.content;
const CSRF_HEADER = document.querySelector('meta[name="_csrf_header"]')?.content;

const ROLES = [
    { key: "HEAD", name: "관리소장", color: "blue", icon: "shield_person", level: "HEAD",
      desc: `
              <span>단지 전체 관리</span><br>
              <span>계정/권한 승인 가능</span><br>
              <span class="caveat">모든 기능 접근 가능</span>
            `},
    { key: "ACNT", name: "회계", color: "yellow", icon: "account_balance", level: "ACNT",
      desc: `
              <span>관리비, 예산, 납부 관리</span><br>
              <span>재무 관련 기능만 사용</span><br>
              <span class="caveat">권한 승인, 행정·시설 관리 불가</span>
            `},
    { key: "ADM", name: "행정", color: "green", icon: "edit_document", level: "ADM",
      desc: `
              <span>공지사항, 민원, 입주민 관리</span><br>
              <span>운영/행정 업무 담당</span><br>
              <span class="caveat">권한 승인, 회계·시설 관리 불가</span>
            `},
    { key: "FAC", name: "시설", color: "orange", icon: "handyman", level: "FAC",
      desc: `
              <span>시설 점검, 공사, 유지보수 관리</span><br>
              <span>시설 관련 업무 담당</span><br>
              <span class="caveat">권한 승인, 행정·회계 관리 불가</span>
            `}
];

const ROLE_BG = { blue: "var(--blue-bg, #dbeafe)", yellow: "var(--yellow-bg, #fef3c7)", green: "var(--green-bg, #dcfce7)", orange: "#fed7aa" };
const ROLE_FG = { blue: "var(--accent, #1d4ed8)", yellow: "var(--yellow, #92400e)", green: "var(--green, #166534)", orange: "var(--orange, #c2410c)" };

let requestRows = [];
let accountRows = [];
let accountPage = 1;
let currentAccountId = null;

const requestSearch = { keyword: "", status: "WAIT" };
const accountSearch = { keyword: "", status: "", role: "" };

function esc(value) {
    return String(value ?? "")
        .replaceAll("&", "&amp;")
        .replaceAll("<", "&lt;")
        .replaceAll(">", "&gt;")
        .replaceAll('"', "&quot;")
        .replaceAll("'", "&#39;");
}

function roleName(code) {
    const role = ROLES.find(r => r.key === code || r.name === code);
    return role ? role.name : (code || "-");
}

function roleColor(code) {
    const role = ROLES.find(r => r.key === code || r.name === code);
    return role ? role.color : "green";
}

function dateText(value) {
    if (!value) return "-";
    return String(value).substring(0, 10);
}

function buildQuery(params) {
    const query = new URLSearchParams();
    Object.keys(params).forEach(key => {
        const value = params[key];
        if (value !== null && value !== undefined && value !== "" && value !== "all") {
            query.append(key, value);
        }
    });
    const text = query.toString();
    return text ? "?" + text : "";
}

async function checkResponse(response) {
    if (!response.ok) {
        const text = await response.text();
        throw new Error(text || "서버 요청 중 오류가 발생했습니다.");
    }
    return response.json();
}

function getJson(url) {
    return fetch(url, {
        headers: {
            "Accept": "application/json",

            //CSRF 토큰 추가
            [CSRF_HEADER]: CSRF_TOKEN
        }
    }).then(checkResponse);
}

function sendJson(url, method, body) {
    return fetch(url, {
        method: method,
        headers: {
            "Content-Type": "application/json; charset=UTF-8",
            "Accept": "application/json",

            // CSRF 토큰 추가
            [CSRF_HEADER]: CSRF_TOKEN
        },
        body: body ? JSON.stringify(body) : null
    }).then(checkResponse);
}

function loadAll() {
    return Promise.all([loadRequestList(), loadAccountList()]);
}

function loadRequestList() {
    return getJson(API_BASE + "/requests" + buildQuery(requestSearch))
        .then(data => {
            requestRows = Array.isArray(data) ? data : [];
            renderRequestTable();
        })
        .catch(err => alert(err.message));
}

function loadAccountList() {
    return getJson(API_BASE + "/accounts" + buildQuery(accountSearch))
        .then(data => {
            accountRows = Array.isArray(data) ? data : [];
            renderAccounts();
        })
        .catch(err => alert(err.message));
}

function renderRequestTable() {
    const tbody = document.querySelector("#rqstTable tbody");
    if (!tbody) return;

    if (requestRows.length === 0) {
        tbody.innerHTML = '<tr><td colspan="8" style="text-align:center;padding:24px;color:#94a3b8;">조회된 신청 계정이 없습니다.</td></tr>';
        updateRequestCount();
        return;
    }

    tbody.innerHTML = requestRows.map(row => {
        const status = (row.rqstSttsCd || "WAIT").toUpperCase();

        /*
            상태 CSS 클래스 매핑
        */
        let statusClass = "wait";
        let statusName = "승인대기";

        if (status === "OK") {
            statusClass = "ok";
            statusName = "승인완료";
        } else if (status === "RJCT") {
            statusClass = "reject";
            statusName = "반려";
        } else if (status === "CNL") {
            statusClass = "cancel";
            statusName = "신청취소";
        }

        const firstChar = (row.rqstMngrNm || "?").substring(0, 1);

        let actionHtml = "";
        if (status === "WAIT") {
            actionHtml =
                '<button type="button" class="icon-btn-sm" onclick="openApprovalModal(this)" title="승인">' +
                '<span class="material-symbols-rounded">check</span></button>' +
                '<button type="button" class="icon-btn-sm danger" onclick="openRejectModal(this)" title="반려">' +
                '<span class="material-symbols-rounded">close</span></button>';
        } else if (status === "RJCT") {
            actionHtml =
                '<button type="button" class="icon-btn-sm danger" onclick="showRejectReason(this)" title="반려사유">' +
                '<span class="material-symbols-rounded">visibility</span></button>';
        } else if (status === "OK") {
            /*
                승인완료 상태일 때만 아래로 내리는 아이콘 표시.

                publish 아이콘?
                → Material Symbols 아이콘 이름.
                여기서는 "아래 목록으로 추가/이동" 느낌을 주기 위해 사용.
            */
            actionHtml =
                '<button type="button" class="icon-btn-sm" onclick="addApprovedAccountToList(this)" title="계정 목록에 추가">' +
                '<span class="material-symbols-rounded">arrow_downward</span></button>';
        } else {
            actionHtml = '<span style="font-size:11px;color:#94a3b8;">-</span>';
        }
        /*
            비고(RMRK_CN)가 있으면
            메모 확인 아이콘 표시
        */
        if (row.rmrkCn) {
            actionHtml +=
                '<button type="button" class="icon-btn-sm" onclick="toggleRemarkRow(this)" title="비고 확인">' +
                '<span class="material-symbols-rounded">notes</span>' +
                '</button>';
        }

        return `
                <tr data-rqst-no="${esc(row.rqstNo)}"
                    data-status="${esc(status)}"
                    data-reject-reason="${esc(row.rjctRsnCn || "")}"
                    data-remark="${esc(row.rmrkCn || "")}">
                <td><input type="checkbox" class="rqst-check row-check" ${status !== "WAIT" ? "disabled" : ""}></td>
                <td>
                    <div class="user-cell">
                        <div class="user-avatar" style="background:#dbeafe;color:#1d4ed8">${esc(firstChar)}</div>
                        <div>
                            <div class="user-name">${esc(row.rqstMngrNm)}</div>
                            <div class="user-id">${esc(row.rqstLoginId)}</div>
                        </div>
                    </div>
                </td>
                <td>${esc(row.aptCmplexNm || row.aptCmplexNo || "-")}</td>
                <td class="muted">${esc(row.detailAddr || "-")}</td>
                <td><span class="badge info">${esc(row.dutyNm || roleName(row.rqstDutyCd))}</span></td>
                <td>${esc(dateText(row.rqstDt))}</td>
                <td><span class="badge ${statusClass}">${esc(statusName)}</span></td>
                <td><div class="row-actions">${actionHtml}</div></td>
            </tr>
            
            <tr class="remark-row" style="display:none;">
                <td colspan="8">
                    <div class="remark-box">
                        <div class="remark-box__title">
                            <span class="material-symbols-rounded">notes</span>
                            비고
                        </div>
                        <div class="remark-box__content">
                            ${esc(row.rmrkCn || "등록된 비고가 없습니다.")}
                        </div>
                    </div>
                </td>
            </tr>`;
    }).join("");

    updateRequestCount();
}

function updateRequestCount() {
    /*
        화면 상단 건수 계산

        주의:
        DB 값이 OK, WAIT처럼 대문자일 수도 있고
        ok, wait처럼 소문자일 수도 있어서 toUpperCase()로 통일한다.
    */
    const total = requestRows.length;
    const cancel = requestRows.filter(r => String(r.rqstSttsCd || "").toUpperCase() === "CNL").length;
    const wait = requestRows.filter(r => String(r.rqstSttsCd || "").toUpperCase() === "WAIT").length;
    const ok = requestRows.filter(r => String(r.rqstSttsCd || "").toUpperCase() === "OK").length;
    const reject = requestRows.filter(r => String(r.rqstSttsCd || "").toUpperCase() === "RJCT").length;

    const summary = document.getElementById("rqstSummary");
    if (summary) {
        summary.textContent =
            `총 ${total}건 / 신청취소 ${cancel}건 / 승인대기 ${wait}건 / 승인완료 ${ok}건 / 반려 ${reject}건`;
    }

    const footerTotal = document.getElementById("rqstFooterTotal");
    if (footerTotal) {
        footerTotal.innerHTML = `총 <strong>${total}</strong>건 표시 중`;
    }
}

function renderAccounts() {
    const tbody = document.getElementById("acctTbody");
    if (!tbody) return;

    const total = accountRows.length;
    const lastPage = Math.max(1, Math.ceil(total / PAGE_SIZE));
    if (accountPage > lastPage) accountPage = lastPage;

    const start = (accountPage - 1) * PAGE_SIZE;
    const rows = accountRows.slice(start, start + PAGE_SIZE);

    if (rows.length === 0) {
        tbody.innerHTML = '<tr class="c-table__empty"><td colspan="6">조회된 계정이 없습니다.</td></tr>';
    } else {
        tbody.innerHTML = rows.map(row => {
            const active = row.userYn !== "N";
            const color = roleColor(row.mngrDutyCd);
            const firstChar = (row.userNm || "?").substring(0, 1);

            return `
                <tr class="${active ? "" : "row-inactive"}" style="cursor:pointer" onclick="openAccountDetail('${esc(row.userNo)}')">
                    <td>
                        <div class="user-cell">
                            <div class="user-avatar" style="background:${ROLE_BG[color]};color:${ROLE_FG[color]}">${esc(firstChar)}</div>
                            <div>
                                <div class="user-name">${esc(row.userNm)}</div>
                                <div class="user-id">${esc(row.userId)}</div>
                            </div>
                        </div>
                    </td>
                    <td class="muted">${esc(row.aptCmplexNm || "-")}</td>
                    <td class="muted">${esc(row.detailAddr || "-")}</td>
                    <td><span class="c-badge" style="background:${ROLE_BG[color]};color:${ROLE_FG[color]}">${esc(row.dutyNm || roleName(row.mngrDutyCd))}</span></td>
                    <td class="muted">${esc(row.lastLoginDt || dateText(row.regDt))} <span style="color:#d1d5db;font-size:11px">${esc(row.lastLoginTm || "")}</span></td>
                    <td onclick="event.stopPropagation()">
                        <div style="display:flex;align-items:center;gap:8px">
                            <label class="toggle-wrap">
                                <input type="checkbox" ${active ? "checked" : ""} onchange="toggleActive('${esc(row.userNo)}', this)">
                                <div class="toggle-track"></div>
                                <div class="toggle-thumb"></div>
                            </label>
                            <span style="font-size:12px;font-weight:700;color:${active ? "var(--green, #166534)" : "var(--text-tertiary, #94a3b8)"}">${active ? "사용" : "미사용"}</span>
                        </div>
                    </td>
                </tr>`;
        }).join("");
    }

    const subtitle = document.getElementById("acctSubtitle");
    if (subtitle) subtitle.textContent = `총 ${total}건 / ${accountPage} 페이지`;

    renderPagination(total, accountPage, lastPage);
}

function renderPagination(total, current, last) {
    const el = document.getElementById("acctPagination");
    if (!el) return;

    if (last <= 1) {
        el.innerHTML = "";
        return;
    }

    /*
        페이지 블록이란?
        → 페이지 번호를 한 번에 전부 보여주지 않고,
          1~10, 11~20처럼 끊어서 보여주는 방식.
        왜 사용?
        → 데이터가 많을 때 페이지 버튼이 너무 길어지는 것을 막기 위해 사용.
    */
    const BLOCK_SIZE = 10;

    const currentBlock = Math.ceil(current / BLOCK_SIZE);
    const startPage = (currentBlock - 1) * BLOCK_SIZE + 1;
    const endPage = Math.min(startPage + BLOCK_SIZE - 1, last);

    let html = "";

    html += `<button class="c-pagination__btn ${current === 1 ? "is-disabled" : ""}" onclick="goPage(${current - 1})">‹</button>`;

    for (let i = startPage; i <= endPage; i++) {
        html += `<button class="c-pagination__btn ${i === current ? "is-active" : ""}" onclick="goPage(${i})">${i}</button>`;
    }

    html += `<button class="c-pagination__btn ${current === last ? "is-disabled" : ""}" onclick="goPage(${current + 1})">›</button>`;

    el.innerHTML = html;
}

function goPage(page) {
    const last = Math.max(1, Math.ceil(accountRows.length / PAGE_SIZE));
    if (page < 1 || page > last) return;
    accountPage = page;
    renderAccounts();
}

function searchTable(tableId, keyword) {
    requestSearch.keyword = (keyword || "").trim();
    loadRequestList();
}

function searchBtnClick(tableId, inputId) {
    const input = document.getElementById(inputId);
    requestSearch.keyword = input ? input.value.trim() : "";
    loadRequestList();
}

function filterTable(tableId, status) {
    requestSearch.status = status || "all";
    loadRequestList();
}

function searchAccounts(keyword) {
    accountSearch.keyword = (keyword || "").trim();
    accountPage = 1;
    loadAccountList();
}

function handleSearchKey(event) {
    if (event.key === "Enter") {
        searchAccounts(event.target.value);
    }
}

function handleSearchClick() {
    const input = document.getElementById("searchInput");
    searchAccounts(input ? input.value : "");
}

function filterStatus(status) {
    accountSearch.status = status || "";
    accountPage = 1;
    loadAccountList();
}

function filterRole(role) {
    accountSearch.role = role || "";
    accountPage = 1;
    loadAccountList();
}

function toggleAll(tableId, checkbox) {
    document.querySelectorAll("#rqstTable tbody .row-check:not(:disabled)").forEach(cb => {
        cb.checked = checkbox.checked;
    });
}

function checkedRequestNos() {
    return Array.from(document.querySelectorAll("#rqstTable tbody tr"))
        .filter(tr => tr.querySelector(".row-check")?.checked)
        .map(tr => tr.dataset.rqstNo)
        .filter(Boolean);
}

function targetRequestNos(btn) {
    if (btn) {
        const row = btn.closest("tr");
        return row && row.dataset.rqstNo ? [row.dataset.rqstNo] : [];
    }
    return checkedRequestNos();
}

function openApprovalModal(btn) {
    const rqstNos = targetRequestNos(btn);
    if (rqstNos.length === 0) {
        alert("승인할 계정을 선택해주세요.");
        return;
    }
    if (!confirm(rqstNos.length + "건을 승인 처리하시겠습니까?")) return;

    Promise.all(rqstNos.map(no => sendJson(API_BASE + "/requests/" + encodeURIComponent(no) + "/approve", "POST")))
        .then(() => loadAll())
        .then(() => alert("승인 처리가 완료되었습니다."))
        .catch(err => alert(err.message));
}

function openRejectModal(btn) {
    const rqstNos = targetRequestNos(btn);
    if (rqstNos.length === 0) {
        alert("반려할 계정을 선택해주세요.");
        return;
    }

    const reason = prompt("반려 사유를 입력해주세요.");
    if (reason === null) return;
    if (reason.trim() === "") {
        alert("반려 사유를 입력해야 합니다.");
        return;
    }

    Promise.all(rqstNos.map(no => sendJson(API_BASE + "/requests/" + encodeURIComponent(no) + "/reject", "POST", { rjctRsnCn: reason.trim() })))
        .then(() => loadRequestList())
        .then(() => alert("반려 처리가 완료되었습니다."))
        .catch(err => alert(err.message));
}

function showRejectReason(btn) {
    /*
        반려사유 모달 열기

        dataset.rejectReason이란?
        → tr 태그에 넣어둔 data-reject-reason 값을 JS에서 꺼내는 방식.
        왜 사용?
        → 목록 조회 때 이미 받은 반려사유를 다시 서버 요청 없이 보여주기 위해.
    */
    const row = btn.closest("tr");
    const reason = row?.dataset.rejectReason || "등록된 반려 사유가 없습니다.";

    document.getElementById("rejectReasonContent").textContent = reason;
    document.getElementById("rejectReasonOverlay").classList.remove("is-hidden");
}

function closeRejectReasonModal() {
    /*
        classList.add("is-hidden")이란?
        → 모달에 숨김 클래스를 붙여서 화면에서 안 보이게 하는 방식.
    */
    document.getElementById("rejectReasonOverlay").classList.add("is-hidden");
}

function toggleRemarkRow(btn) {
    /*
        비고 펼침/접힘 기능

        btn.closest("tr")
        → 클릭한 버튼이 들어있는 신청자 행을 찾는다.

        nextElementSibling
        → 신청자 행 바로 아래에 있는 비고 행을 찾는다.
    */
    const row = btn.closest("tr");
    const remarkRow = row?.nextElementSibling;

    if (!remarkRow || !remarkRow.classList.contains("remark-row")) {
        return;
    }

    const isOpen = remarkRow.style.display === "table-row";

    /*
        다른 비고 영역은 먼저 닫기
        → 여러 개가 동시에 열려서 화면이 복잡해지는 것을 방지한다.
    */
    document.querySelectorAll("#rqstTable tbody .remark-row").forEach(el => {
        if (el !== remarkRow) {
            el.style.display = "none";
        }
    });

    remarkRow.style.display = isOpen ? "none" : "table-row";
}


function addApprovedAccountToList(btn) {
    /*
        btn.closest("tr")란?
        → 클릭한 버튼에서 가장 가까운 tr, 즉 현재 행을 찾는 기능.

        왜 사용?
        → 어떤 신청 건의 버튼을 눌렀는지 RQST_NO를 알아야 하기 때문.
    */
    const row = btn.closest("tr");

    if (!row) {
        alert("선택한 신청 정보를 찾을 수 없습니다.");
        return;
    }

    const rqstNo = row.dataset.rqstNo;

    if (!rqstNo) {
        alert("신청 번호가 없습니다.");
        return;
    }

    /*
        confirm이란?
        → 확인/취소를 선택하는 기본 팝업창.

        확인을 누르면 true, 취소를 누르면 false가 반환된다.
    */
    if (!confirm("'단지 관리자 계정 목록 및 상태'에 추가하시겠습니까?")) {
        return;
    }

    /*
        서버에 승인완료 신청 건을 실제 계정 목록으로 반영 요청.

        이 API는 Controller/Service에서 만들어져 있어야 함.
        내부에서는 MEMBER, AUTH, MANAGER 등록 또는 확인 처리를 해야 한다.
    */
    sendJson(API_BASE + "/requests/" + encodeURIComponent(rqstNo) + "/add-account", "POST")
        .then(() => {
            alert("단지 관리자 계정 목록에 추가되었습니다.");

            /*
                loadAll()
                → 위 신청 목록과 아래 계정 목록을 둘 다 다시 조회한다.
                그래서 위 목록에서는 사라지고, 아래 목록에는 보이게 된다.
            */
            return loadAll();
        })
        .catch(err => alert(err.message));
}


function toggleActive(userNo, checkbox) {
    sendJson(API_BASE + "/accounts/" + encodeURIComponent(userNo) + "/use", "PUT", { userYn: checkbox.checked ? "Y" : "N" })
        .then(() => {
            alert("상태가 변경되었습니다.");
            loadAccountList();
        })
        .catch(err => {
            checkbox.checked = !checkbox.checked;
            alert(err.message);
        });
}

function openAccountDetail(userNo) {
    currentAccountId = userNo;
    getJson(API_BASE + "/accounts/" + encodeURIComponent(userNo))
        .then(row => {
            document.getElementById("detailAcctTitle").textContent = (row.userNm || "-") + " — 계정 상세";
            document.getElementById("detailAcctContent").innerHTML = [
                    ["관리자 이름", row.userNm],
                    ["아이디", row.userId],
                    ["전화번호", row.userTelno],
                    ["이메일", row.userEml],
                    ["소속 단지", row.aptCmplexNm],
                    ["상세주소", row.detailAddr],
                    ["관리사무소 번호", row.mgmtOfcNo],
                    ["권한", row.dutyNm || roleName(row.mngrDutyCd)],
                    ["최근 접속", (row.lastLoginDt || "-") + " " + (row.lastLoginTm || "")],
                    ["상태", row.userYn === "N" ? "미사용" : "사용"]
            ].map(([label, value]) => `
                <div class="c-info-block">
                    <div class="c-label">${esc(label)}</div>
                    <div class="c-value">${esc(value || "-")}</div>
                </div>`).join("");
            document.getElementById("detailOverlay").classList.remove("is-hidden");
        })
        .catch(err => alert(err.message));
}

function closeAccountDetail() {
    const overlay = document.getElementById("detailOverlay");
    if (overlay) overlay.classList.add("is-hidden");
    currentAccountId = null;
}

function deleteAccount() {
    if (!currentAccountId) return;
    if (!confirm("⚠️주의⚠️ 숨김 처리한 계정은 관리할 수 없습니다.\n해당 계정을 목록에서 숨김 처리하시겠습니까?")) return;

    fetch(API_BASE + "/accounts/" + encodeURIComponent(currentAccountId), {
        method: "DELETE",
        headers: { "Accept": "application/json" }
    })
        .then(checkResponse)
        .then(() => {
            closeAccountDetail();
            loadAccountList();
            alert("계정이 목록에서 숨김 처리되었습니다.");
        })
        .catch(err => alert(err.message));
}

function exportAccountsToExcel() {
    const header = ["관리자명", "아이디", "소속단지", "권한", "최근접속일", "최근접속시간", "상태"];
    const rows = accountRows.map(row => [
        row.userNm,
        row.userId,
        row.aptCmplexNm,
        row.dutyNm || roleName(row.mngrDutyCd),
        row.lastLoginDt || dateText(row.regDt),
        row.lastLoginTm || "",
        row.userYn === "N" ? "미사용" : "사용"
    ]);

    const csv = [header].concat(rows)
        .map(row => row.map(cell => '"' + String(cell ?? "").replaceAll('"', '""') + '"').join(","))
        .join("\n");

    const blob = new Blob(["\uFEFF" + csv], { type: "text/csv;charset=utf-8;" });
    const url = URL.createObjectURL(blob);
    const a = document.createElement("a");
    a.href = url;
    a.download = "단지관리자_계정목록.csv";
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);
}

function initRoleSelects() {
    const roleFilter = document.getElementById("roleFilter");
    if (roleFilter) {
        roleFilter.innerHTML = '<option value="">전체 권한</option>' +
            ROLES.map(role => `<option value="${role.key}">${role.name}</option>`).join("");
    }
}

function renderRoleGuide() {
    const grid = document.getElementById("roleGrid");
    if (!grid) return;

    grid.innerHTML = ROLES.map(role => {
        const color = role.color;
        return `
            <div class="role-card">
                <div class="role-card__top">
                    <div class="role-card__icon" style="background:${ROLE_BG[color]}">
                        <span class="material-symbols-rounded" style="color:${ROLE_FG[color]}">${role.icon}</span>
                    </div>
                    <span class="role-card__lv" style="background:${ROLE_BG[color]};color:${ROLE_FG[color]}">${role.level}</span>
                </div>
                <div class="role-card__title">${role.name}</div>
                <div class="role-card__desc">${role.desc}</div>
            </div>`;
    }).join("");
}

function toggleRoleGuide() {
    const body = document.getElementById("roleGuideBody");
    if (!body) return;
    body.style.display = body.style.display === "none" ? "" : "none";
}

function toggleSidebar() {
    const sidebar = document.getElementById("sidebar");
    if (sidebar) sidebar.classList.toggle("collapsed");
}

// DOMContentLoaded란?
// → HTML 화면이 다 만들어진 뒤 실행되는 이벤트. 화면 요소를 찾기 전에 실행되는 오류를 막기 위해 사용한다.
document.addEventListener("DOMContentLoaded", function () {
    initRoleSelects();
    renderRoleGuide();
    loadAll();
});

