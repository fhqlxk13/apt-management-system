<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>관리사무소</title>

    <!-- Spring Security CSRF 토큰 -->
    <sec:csrfMetaTags/>

    <!-- 공통 한글 폰트 -->
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet" />

    <!-- 공통 아이콘 폰트 -->
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet" />

    <!-- 관리사무소 전체 레이아웃 CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/office-layout.css">

    <!-- 관리사무소 공통 화면 CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/manager-common.css">

    <style>
        #residentAuthPage .filter-actions{justify-content:flex-end} #residentAuthPage .tbl-fixed{width:100%;table-layout:fixed;border-collapse:collapse} #residentAuthPage .tbl-fixed th,#residentAuthPage .tbl-fixed td{box-sizing:border-box;vertical-align:middle;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
        #residentAuthPage .col-rqst-no{width:10%;text-align:left} #residentAuthPage .col-user{width:12%;text-align:left} #residentAuthPage .col-tel{width:14%;text-align:left} #residentAuthPage .col-type{width:10%;text-align:center} #residentAuthPage .col-unit{width:12%;text-align:left} #residentAuthPage .col-mvin-date{width:12%;text-align:center} #residentAuthPage .col-rcpt-date{width:12%;text-align:center} #residentAuthPage .col-status{width:8%;text-align:center} #residentAuthPage .col-action{width:10%;text-align:center}
        #residentAuthPage .col-action .grid-actions{justify-content:center} #residentAuthPage .empty-row{text-align:center;color:var(--text-tertiary)} #residentAuthPage .notice-box{display:flex;gap:10px;padding:14px 16px;border-radius:8px;margin-bottom:18px} #residentAuthPage .notice-approve{background:#f0f7f2;border:1px solid #a8ccb0} #residentAuthPage .notice-reject{background:#fff0f0;border:1px solid #e0a8a8}
        #residentAuthPage .notice-icon{font-size:20px;flex-shrink:0;margin-top:1px} #residentAuthPage .notice-icon.approve{color:#2e5c38} #residentAuthPage .notice-icon.reject{color:#991b1b} #residentAuthPage .notice-text{font-size:13px;line-height:1.6} #residentAuthPage .notice-text.approve{color:#1e4a2e} #residentAuthPage .notice-text.reject{color:#7f1d1d}
        #residentAuthPage .approve-detail-grid{margin-bottom:18px} #residentAuthPage .approve-check-box{display:flex;align-items:flex-start;gap:10px;padding:12px 14px;background:#fffbf0;border:1px solid #e8d080;border-radius:8px} #residentAuthPage .approve-check{margin-top:2px;width:16px;height:16px;cursor:pointer;accent-color:#2e5c38} #residentAuthPage .approve-check-label{font-size:13px;color:#6b4400;cursor:pointer;line-height:1.5}
        #residentAuthPage .reject-header{background:#7f1d1d;border-bottom-color:#6b1818} #residentAuthPage .reject-header .modal-title{color:#fff} #residentAuthPage .reject-header .modal-close{background:rgba(255,255,255,.14);color:rgba(255,255,255,.85)} #residentAuthPage .reject-section{margin-bottom:0} #residentAuthPage .reject-textarea{min-height:100px} #residentAuthPage .reject-hint{color:#991b1b;display:none}
        #residentAuthPage .btn-disabled{opacity:.45;cursor:not-allowed}
    </style>

    <!-- 관리사무소 공통 JS -->
    <script src="${pageContext.request.contextPath}/js/manager/manager-common.js"></script>
</head>

<body>
<div class="app-wrapper">

    <!-- 관리사무소 좌측 사이드바 include -->
    <%@ include file="/WEB-INF/views/include/office_sidebar.jsp" %>

    <div class="main-wrap">

        <!-- 관리사무소 상단 헤더 include -->
        <%@ include file="/WEB-INF/views/include/office_header.jsp" %>

        <main class="main-content">
            <div class="office-page" id="residentAuthPage">

                <div class="page-header">
                    <div class="page-title-block">
                        <h2>회원 권한 변경</h2>
                        <p>입주민 권한 신청 내역을 확인하고 승인 또는 반려 처리합니다.</p>
                    </div>
                </div>


                <div class="panel">
                    <div class="panel-header">
                        <h3 class="panel-title">
                            <span class="material-symbols-rounded">manage_search</span>
                            검색 조건
                        </h3>
                    </div>

                    <div class="panel-body">
                        <div class="form-row cols-3">
                            <div class="form-field">
                                <label class="field-label">요청유형</label>
                                <select class="form-select" id="filterRqstTy">
                                    <option value="">전체</option>
                                    <option value="MVIN">입주신청</option>
                                    <option value="MVOT">퇴거신청</option>
                                    <option value="CHG">명의변경</option>
                                </select>
                            </div>

                            <div class="form-field">
                                <label class="field-label">처리상태</label>
                                <select class="form-select" id="filterStatus">
                                    <option value="">전체</option>
                                    <option value="WAIT">대기</option>
                                    <option value="APRV">승인</option>
                                    <option value="RJCT">반려</option>
                                </select>
                            </div>

                            <div class="form-field">
                                <label class="field-label">이름/연락처</label>
                                <div class="search-wrap">
                                    <span class="material-symbols-rounded">search</span>
                                    <input type="text" class="form-input" id="filterKeyword" placeholder="이름 또는 연락처 검색">
                                </div>
                            </div>
                        </div>

                        <div class="form-row cols-3">
                            <div class="form-field">
                                <label class="field-label">접수일 시작</label>
                                <input type="date" class="form-input" id="filterStartDt">
                            </div>

                            <div class="form-field">
                                <label class="field-label">접수일 종료</label>
                                <input type="date" class="form-input" id="filterEndDt">
                            </div>

                            <div class="form-field">
                                <label class="field-label">&nbsp;</label>
                                <div class="page-actions filter-actions">
                                    <button type="button" class="btn btn-secondary" id="btnResetFilter">
                                        <span class="material-symbols-rounded">refresh</span>
                                        초기화
                                    </button>
                                    <button type="button" class="btn btn-primary" id="btnSearch">
                                        <span class="material-symbols-rounded">search</span>
                                        검색
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="panel">
                    <div class="panel-header">
                        <h3 class="panel-title">
                            <span class="material-symbols-rounded">how_to_reg</span>
                            입주 신청 목록
                        </h3>
                        <span class="list-count" id="rqstCount">0건</span>
                    </div>

                    <div class="table-wrap">
                        <table class="tbl tbl-fixed">
                            <colgroup>
                                <col class="col-rqst-no">
                                <col class="col-user">
                                <col class="col-tel">
                                <%-- <col class="col-type"> --%>
                                <col class="col-unit">
                                <col class="col-mvin-date">
                                <col class="col-rcpt-date">
                                <col class="col-status">
                                <col class="col-action">
                            </colgroup>
                            <thead>
                            <tr>
                                <th class="col-rqst-no">신청번호</th>
                                <th class="col-user">신청자</th>
                                <th class="col-tel">연락처</th>
                                <%-- <th class="col-type">요청유형</th> --%>
                                <th class="col-unit">동/호수</th>
                                <th class="col-mvin-date">입주예정일</th>
                                <th class="col-rcpt-date">접수일</th>
                                <th class="col-status">상태</th>
                                <th class="col-action">관리</th>
                            </tr>
                            </thead>
                            <tbody id="rqstTableBody"></tbody>
                        </table>
                    </div>
                </div>

                <div class="modal-overlay" id="rqstModal">
                    <div class="modal modal-lg">
                        <form id="rqstForm">
                            <input type="hidden" id="rqstNo">

                            <div class="modal-header">
                                <h3 class="modal-title">권한 신청 상세</h3>
                                <button type="button" class="modal-close" data-modal-close>
                                    <span class="material-symbols-rounded">close</span>
                                </button>
                            </div>

                            <div class="modal-body">
                                <div class="form-section">
                                    <div class="form-section-title">
                                        <span class="material-symbols-rounded">person</span>
                                        신청자 정보
                                    </div>

                                    <div class="form-row cols-2">
                                        <div class="form-field">
                                            <label class="field-label">신청자</label>
                                            <input type="text" class="form-input" id="detailUserNm" readonly>
                                        </div>

                                        <div class="form-field">
                                            <label class="field-label">연락처</label>
                                            <input type="text" class="form-input" id="detailTelno" readonly>
                                        </div>
                                    </div>
                                </div>

                                <div class="form-section">
                                    <div class="form-section-title">
                                        <span class="material-symbols-rounded">home</span>
                                        신청 정보
                                    </div>

                                    <div class="form-row cols-2">
                                        <div class="form-field">
                                            <label class="field-label">요청유형</label>
                                            <input type="text" class="form-input" id="detailRqstTy" readonly>
                                        </div>

                                        <div class="form-field">
                                            <label class="field-label">처리상태</label>
                                            <input type="text" class="form-input" id="detailStatus" readonly>
                                        </div>
                                    </div>

                                    <div class="form-row cols-2">
                                        <div class="form-field">
                                            <label class="field-label">동/호수</label>
                                            <input type="text" class="form-input" id="detailUnit" readonly>
                                        </div>

                                        <div class="form-field">
                                            <label class="field-label">접수일</label>
                                            <input type="text" class="form-input" id="detailRcptDt" readonly>
                                        </div>
                                    </div>

                                    <div class="form-row cols-2">
                                        <div class="form-field">
                                            <label class="field-label">입주예정일</label>
                                            <input type="text" class="form-input" id="detailMvinPrdDt" readonly>
                                        </div>

                                        <div class="form-field">
                                            <label class="field-label">퇴거예정일</label>
                                            <input type="text" class="form-input" id="detailMvoutPrdDt" readonly>
                                        </div>
                                    </div>

                                    <div class="form-row cols-1">
                                        <div class="form-field">
                                            <label class="field-label">퇴거사유/비고</label>
                                            <textarea class="form-textarea" id="detailReason" readonly></textarea>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-modal-close>닫기</button>
                                <button type="button" class="btn btn-danger" id="btnReject">반려</button>
                                <button type="button" class="btn btn-primary" id="btnApprove">승인</button>
                            </div>
                        </form>
                    </div>
                </div>

                <div class="modal-overlay" id="approveModal">
                    <div class="modal modal-sm">
                        <div class="modal-header">
                            <h3 class="modal-title">승인 처리</h3>
                            <button type="button" class="modal-close" data-close-approve>
                                <span class="material-symbols-rounded">close</span>
                            </button>
                        </div>

                        <div class="modal-body">
                            <div class="notice-box notice-approve">
                                <span class="material-symbols-rounded notice-icon approve">info</span>
                                <div class="notice-text approve">
                                    승인 처리 시 해당 신청자에게 <strong>입주민 권한이 즉시 부여</strong>됩니다.<br>
                                    아래 내용을 다시 한 번 확인한 후 승인해 주세요.
                                </div>
                            </div>

                            <div class="mngr-detail-grid approve-detail-grid" id="approveDetailGrid"></div>

                            <div class="approve-check-box">
                                <input type="checkbox" id="approveConfirmCheck" class="approve-check">
                                <label for="approveConfirmCheck" class="approve-check-label">
                                    위 신청 내용을 확인하였으며, 해당 신청자에게 입주민 권한을 부여하는 것에 동의합니다.
                                </label>
                            </div>
                        </div>

                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-close-approve>취소</button>
                            <button type="button" class="btn btn-primary btn-disabled" id="btnApproveConfirm" disabled>
                                승인 완료
                            </button>
                        </div>
                    </div>
                </div>

                <div class="modal-overlay" id="rejectModal">
                    <div class="modal modal-sm">
                        <div class="modal-header reject-header">
                            <h3 class="modal-title">반려 처리</h3>
                            <button type="button" class="modal-close" data-close-reject>
                                <span class="material-symbols-rounded">close</span>
                            </button>
                        </div>

                        <div class="modal-body">
                            <div class="notice-box notice-reject">
                                <span class="material-symbols-rounded notice-icon reject">warning</span>
                                <div class="notice-text reject">
                                    반려 처리 시 신청자에게 <strong>반려 알림이 발송</strong>됩니다.<br>
                                    반려 사유는 신청자에게 공개되므로 명확하게 작성해 주세요.
                                </div>
                            </div>

                            <div class="form-section reject-section">
                                <div class="form-row cols-1">
                                    <div class="form-field">
                                        <label class="field-label">반려 사유 <span class="req">*</span></label>
                                        <textarea class="form-textarea reject-textarea" id="rejectReason" placeholder="반려 사유를 구체적으로 입력하세요."></textarea>
                                        <span class="form-hint reject-hint" id="rejectReasonHint">반려 사유를 입력해야 합니다.</span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-close-reject>취소</button>
                            <button type="button" class="btn btn-danger" id="btnRejectConfirm">반려 처리</button>
                        </div>
                    </div>
                </div>

            </div>

            <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
            <script>
                (function () {
                    var page = document.getElementById("residentAuthPage");
                    if (!page || page.dataset.bound === "true") return;
                    page.dataset.bound = "true";

                    function showSwal(icon, title, text) {
                        return Swal.fire({
                            icon: icon,
                            title: title,
                            text: text,
                            confirmButtonText: "확인",
                            confirmButtonColor: "#2e5c38"
                        });
                    }

                    function showSuccess(title, text) {
                        return showSwal("success", title, text);
                    }

                    function showWarning(title, text) {
                        return showSwal("warning", title, text);
                    }

                    function showError(title, text) {
                        return showSwal("error", title, text);
                    }

                    function confirmAction(opts) {
                        return Swal.fire({
                            icon: opts.icon || "question",
                            title: opts.title,
                            text: opts.text,
                            showCancelButton: true,
                            confirmButtonText: opts.confirmText || "확인",
                            cancelButtonText: "취소",
                            confirmButtonColor: opts.confirmColor || "#2e5c38",
                            cancelButtonColor: "#8b9490",
                            reverseButtons: true
                        });
                    }

                    var rqstRowData = [

                        <c:forEach var="row" items="${residentAuthList}" varStatus="vs">

                        {
                            rqstNo: "${row.rqstNo}",
                            userNm: "${row.userNm}",
                            telno: "${row.userTelno}",
                            rqstTyCd: "${row.rqstTyCd}",
                            dong: "${row.dong}",
                            ho: "${row.ho}",
                            mvinPrdDt: "${row.mvinPrdDt}",
                            mvoutPrdDt: "${row.mvoutPrdDt}",
                            mvoutRsnCn: "${row.mvoutRsnCn}",
                            rcptDt: "${row.rcptDt}",
                            rqstSttsCd: "${row.rqstSttsCd}"
                        }

                        <c:if test="${!vs.last}">
                        ,
                        </c:if>

                        </c:forEach>

                    ];
                    var currentRqst = null;                    function rqstTypeText(code) {
                        return {
                            MVIN: "\uc785\uc8fc\uc2e0\uccad",
                            MVOT: "\ud1f4\uac70\uc2e0\uccad",
                            CHG: "\uba85\uc758\ubcc0\uacbd"
                        }[code] || "-";
                    }

                    function statusText(code) {
                        return {
                            WAIT: "\ub300\uae30",
                            APRV: "\uc2b9\uc778",
                            RJCT: "\ubc18\ub824"
                        }[code] || "-";
                    }

                    function statusBadge(code) {
                        var map = {
                            WAIT: "badge-yellow",
                            APRV: "badge-green",
                            RJCT: "badge-red"
                        };

                        return '<span class="badge ' + (map[code] || "badge-gray") + '">' + statusText(code) + '</span>';
                    }

                    function extractDongNo(value) {
                        if (!value) return "";
                        var str = String(value);
                        return str.indexOf("_") > -1 ? str.split("_").pop() : str;
                    }

                    function formatDong(value) {
                        var dong = extractDongNo(value);
                        return dong ? dong + "\ub3d9" : "-";
                    }

                    function formatHo(value) {
                        if (!value) return "-";
                        var str = String(value);
                        return str.endsWith("\ud638") ? str : str + "\ud638";
                    }

                    function formatDongHo(dong, ho) {
                        return formatDong(dong) + " " + formatHo(ho);
                    }
                    function getFilteredRows() {
                        var rqstTy = document.getElementById("filterRqstTy").value;
                        var status = document.getElementById("filterStatus").value;
                        var keyword = document.getElementById("filterKeyword").value.trim();
                        var startDt = document.getElementById("filterStartDt").value;
                        var endDt = document.getElementById("filterEndDt").value;

                        return rqstRowData.filter(function (row) {
                            return (!rqstTy || row.rqstTyCd === rqstTy)
                                && (!status || row.rqstSttsCd === status)
                                && (!keyword || row.userNm.indexOf(keyword) > -1 || row.telno.indexOf(keyword) > -1);
                        });
                    }

                    function renderTable() {
                        var rows = getFilteredRows();
                        var tbody = document.getElementById("rqstTableBody");

                        document.getElementById("rqstCount").textContent = rows.length + "\uac74";

                        if (rows.length === 0) {
                            tbody.innerHTML = '<tr><td colspan="8" class="empty-row">\uc870\ud68c\ub41c \uc2e0\uccad \ub0b4\uc5ed\uc774 \uc5c6\uc2b5\ub2c8\ub2e4.</td></tr>';
                            return;
                        }

                        tbody.innerHTML = rows.map(function (row) {
                            return '<tr>'
                                + '<td class="col-rqst-no td-mono">' + row.rqstNo + '</td>'
                                + '<td class="col-user td-bold">' + row.userNm + '</td>'
                                + '<td class="col-tel">' + row.telno + '</td>'
                                // + '<td class="col-type">' + rqstTypeText(row.rqstTyCd) + '</td>'
                                + '<td class="col-unit">' + formatDongHo(row.dong, row.ho) + '</td>'
                                + '<td class="col-mvin-date">' + (row.mvinPrdDt || "-") + '</td>'
                                + '<td class="col-rcpt-date">' + row.rcptDt + '</td>'
                                + '<td class="col-status">' + statusBadge(row.rqstSttsCd) + '</td>'
                                + '<td class="col-action">'
                                + '<div class="grid-actions">'
                                + '<button type="button" class="btn btn-xs btn-detail" data-action="detail" data-rqst-no="' + row.rqstNo + '">\uc0c1\uc138</button>'
                                + '</div>'
                                + '</td>'
                                + '</tr>';
                        }).join("");
                    }

                    function resetFilter() {
                        ["filterRqstTy", "filterStatus", "filterKeyword", "filterStartDt", "filterEndDt"]
                            .forEach(function (id) {
                                document.getElementById(id).value = "";
                            });

                        renderTable();
                    }

                    function openDetailModal(row) {
                        currentRqst = row;

                        document.getElementById("rqstNo").value = row.rqstNo;
                        document.getElementById("detailUserNm").value = row.userNm || "";
                        document.getElementById("detailTelno").value = row.telno || "";
                        document.getElementById("detailRqstTy").value = rqstTypeText(row.rqstTyCd);
                        document.getElementById("detailStatus").value = statusText(row.rqstSttsCd);
                        document.getElementById("detailUnit").value = formatDongHo(row.dong, row.ho);
                        document.getElementById("detailRcptDt").value =
                            row.rcptDt ? row.rcptDt.substring(0, 10) : "";

                        document.getElementById("detailMvinPrdDt").value =
                            row.mvinPrdDt ? row.mvinPrdDt.substring(0, 10) : "";

                        document.getElementById("detailMvoutPrdDt").value =
                            row.mvoutPrdDt ? row.mvoutPrdDt.substring(0, 10) : "";
                        document.getElementById("detailReason").value = row.mvoutRsnCn || "";

                        var isWait = row.rqstSttsCd === "WAIT";
                        document.getElementById("btnApprove").style.display = isWait ? "inline-flex" : "none";
                        document.getElementById("btnReject").style.display = isWait ? "inline-flex" : "none";

                        document.getElementById("rqstModal").classList.add("open");
                    }

                    function closeDetailModal() {
                        document.getElementById("rqstModal").classList.remove("open");
                    }

                    function openApproveModal() {
                        if (!currentRqst) return;

                        var row = currentRqst;
                        var items = [
                            ["\uc2e0\uccad\uc790", row.userNm],
                            ["\uc5f0\ub77d\ucc98", row.telno],
                            ["\uc694\uccad\uc720\ud615", rqstTypeText(row.rqstTyCd)],
                            ["\ub3d9/\ud638\uc218", formatDongHo(row.dong, row.ho)],
                            ["\uc785\uc8fc\uc608\uc815\uc77c", row.mvinPrdDt || "-"],
                            ["\uc811\uc218\uc77c", row.rcptDt]
                        ];

                        document.getElementById("approveDetailGrid").innerHTML = items.map(function (item) {
                            return '<div class="mngr-detail-item">'
                                + '<div class="mngr-detail-label">' + item[0] + '</div>'
                                + '<div class="mngr-detail-value">' + item[1] + '</div>'
                                + '</div>';
                        }).join("");

                        var check = document.getElementById("approveConfirmCheck");
                        var btn = document.getElementById("btnApproveConfirm");

                        check.checked = false;
                        btn.disabled = true;
                        btn.classList.add("btn-disabled");

                        document.getElementById("approveModal").classList.add("open");
                    }

                    function closeApproveModal() {
                        document.getElementById("approveModal").classList.remove("open");
                    }

                    function openRejectModal() {
                        if (!currentRqst) return;

                        document.getElementById("rejectReason").value = "";
                        document.getElementById("rejectReasonHint").style.display = "none";
                        document.getElementById("rejectModal").classList.add("open");
                    }

                    function closeRejectModal() {
                        document.getElementById("rejectModal").classList.remove("open");
                    }

                    async function approveRqst() {
                        if (!currentRqst) return;

                        var check = document.getElementById("approveConfirmCheck");
                        if (!check || !check.checked) {
                            await showWarning("확인 필요", "안내 문구를 확인한 뒤 체크박스를 선택해 주세요.");
                            return;
                        }

                        var confirmResult = await confirmAction({
                            title: "입주 신청을 승인하시겠습니까?",
                            text: (currentRqst.userNm || "신청자") + " · "
                                + formatDongHo(currentRqst.dong, currentRqst.ho),
                            confirmText: "승인"
                        });

                        if (!confirmResult.isConfirmed) return;

                        try {
                            var res = await fetch("${pageContext.request.contextPath}/office/resident/auth/approve", {
                                method: "POST",
                                headers: {
                                    "Content-Type": "application/json",
                                    [document.querySelector('meta[name="_csrf_header"]').content]:
                                    document.querySelector('meta[name="_csrf"]').content
                                },
                                body: JSON.stringify({
                                    rqstNo: currentRqst.rqstNo
                                })
                            });

                            var data = await res.json();

                            if (data.success) {
                                currentRqst.rqstSttsCd = "APRV";
                                renderTable();
                                closeApproveModal();
                                closeDetailModal();
                                await showSuccess("승인 완료", "입주 신청이 승인 처리되었습니다.");
                            } else {
                                await showError("승인 실패", data.message || "승인 처리에 실패했습니다.");
                            }
                        } catch (err) {
                            console.error(err);
                            await showError("서버 오류", "승인 처리 중 오류가 발생했습니다.");
                        }
                    }

                    async function rejectRqst() {
                        if (!currentRqst) return;

                        var reason = document.getElementById("rejectReason").value.trim();
                        var hint = document.getElementById("rejectReasonHint");

                        if (!reason) {
                            hint.style.display = "block";
                            document.getElementById("rejectReason").focus();
                            await showWarning("입력 필요", "반려 사유를 입력해 주세요.");
                            return;
                        }

                        hint.style.display = "none";

                        var confirmResult = await confirmAction({
                            icon: "warning",
                            title: "입주 신청을 반려하시겠습니까?",
                            text: "반려 사유는 신청자에게 전달됩니다.",
                            confirmText: "반려",
                            confirmColor: "#b91c1c"
                        });

                        if (!confirmResult.isConfirmed) return;

                        try {
                            var res = await fetch("${pageContext.request.contextPath}/office/resident/auth/reject", {
                                method: "POST",
                                headers: {
                                    "Content-Type": "application/json",
                                    [document.querySelector('meta[name="_csrf_header"]').content]:
                                    document.querySelector('meta[name="_csrf"]').content
                                },
                                body: JSON.stringify({
                                    rqstNo: currentRqst.rqstNo,
                                    rjctRsnCn: reason
                                })
                            });

                            var data = await res.json();

                            if (data.success) {
                                currentRqst.rqstSttsCd = "RJCT";
                                currentRqst.mvoutRsnCn = reason;
                                renderTable();
                                closeRejectModal();
                                closeDetailModal();
                                await showSuccess("반려 완료", "입주 신청이 반려 처리되었습니다.");
                            } else {
                                await showError("반려 실패", data.message || "반려 처리에 실패했습니다.");
                            }
                        } catch (err) {
                            console.error("reject error =", err);
                            await showError("서버 오류", "반려 처리 중 오류가 발생했습니다.");
                        }
                    }

                    document.getElementById("btnSearch").addEventListener("click", renderTable);
                    document.getElementById("btnResetFilter").addEventListener("click", resetFilter);

                    document.getElementById("btnApprove").addEventListener("click", function () {
                        closeDetailModal();
                        openApproveModal();
                    });

                    document.getElementById("btnReject").addEventListener("click", function () {
                        closeDetailModal();
                        openRejectModal();
                    });

                    document.getElementById("approveConfirmCheck").addEventListener("change", function () {
                        var btn = document.getElementById("btnApproveConfirm");

                        btn.disabled = !this.checked;

                        if (this.checked) {
                            btn.classList.remove("btn-disabled");
                        } else {
                            btn.classList.add("btn-disabled");
                        }
                    });

                    document.getElementById("btnApproveConfirm").addEventListener("click", approveRqst);
                    document.getElementById("btnRejectConfirm").addEventListener("click", rejectRqst);

                    page.addEventListener("click", function (e) {
                        var detailBtn = e.target.closest('[data-action="detail"]');

                        if (detailBtn) {
                            var rqstNo = detailBtn.dataset.rqstNo;
                            var row = rqstRowData.find(function (r) {
                                return r.rqstNo === rqstNo;
                            });

                            if (row) openDetailModal(row);
                        }

                        if (e.target.closest("[data-modal-close]")) closeDetailModal();
                        if (e.target.closest("[data-close-approve]")) closeApproveModal();
                        if (e.target.closest("[data-close-reject]")) closeRejectModal();

                        if (e.target.id === "rqstModal") closeDetailModal();
                        if (e.target.id === "approveModal") closeApproveModal();
                        if (e.target.id === "rejectModal") closeRejectModal();
                    });

                    renderTable();
                })();
            </script>
        </main>
    </div>
</div>
</body>
</html>
