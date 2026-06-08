<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>입주민 목록</title>

    <link rel="preconnect" href="https://fonts.googleapis.com"/>
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin/>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet"/>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/office-layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/manager-common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/ag-grid.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/ag-theme-alpine.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/manager-agGrid.css">
    <script src="${pageContext.request.contextPath}/js/manager/ag-grid-community.min.js"></script>

    <style>
        #residentGrid .ag-header-cell-label,
        #residentGrid .ag-cell {
            justify-content: center;
        }

        #residentGrid .resident-cell-left {
            justify-content: flex-start;
        }

        .resident-actions {
            display: flex;
            justify-content: center;
        }
        .grid-badge.status-pending {
            background: #fff3cd;
            color: #856404;
        }

        .grid-badge.status-warning {
            background: #fde2e2;
            color: #c0392b;
        }
    </style>
</head>
<body>
<div class="app-wrapper">
    <%@ include file="/WEB-INF/views/include/office_sidebar.jsp" %>

    <div class="main-wrap">
        <%@ include file="/WEB-INF/views/include/office_header.jsp" %>

        <main class="main-content">
            <div class="office-page" id="residentListPage">
                <div class="page-header">
                    <div class="page-title-block">
                        <h2>입주민 목록</h2>
                        <p>세대 정보와 입주 상태를 기준으로 입주민을 조회합니다.</p>
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
                                <label class="field-label">단지명</label>
                                <select class="form-select" id="filterComplex">
                                    <option value="">전체</option>
                                    <option value="${aptCmplexNm}">${aptCmplexNm}</option>
                                </select>
                            </div>
                            <div class="form-field">
                                <label class="field-label">동</label>
                                <input type="text" class="form-input" id="filterDong" placeholder="예: 101">
                            </div>
                            <div class="form-field">
                                <label class="field-label">호</label>
                                <input type="text" class="form-input" id="filterHo" placeholder="예: 1001">
                            </div>
                        </div>

                        <div class="form-row cols-3">
                            <div class="form-field">
                                <label class="field-label">세대 구분</label>
                                <select class="form-select" id="filterHouseholdType">
                                    <option value="">전체</option>
                                    <option value="HEAD">세대주</option>
                                    <option value="MEMBER">세대원</option>
                                </select>
                            </div>
                            <div class="form-field">
                                <label class="field-label">입주 상태</label>
                                <select class="form-select" id="filterMoveStatus">
                                    <option value="">전체</option>
                                    <option value="WAIT">입주대기</option>
                                    <option value="LIVE">입주중</option>
                                    <option value="MID">중도퇴거</option>
                                    <option value="OUT">퇴거</option>



                                </select>
                            </div>
                            <div class="form-field">
                                <label class="field-label">검색어</label>
                                <input type="text" class="form-input" id="filterKeyword" placeholder="이름, 연락처, 이메일">
                            </div>
                        </div>

                        <div class="form-row cols-3">
                            <div class="form-field">
                                <label class="field-label">입주 시작</label>
                                <input type="date" class="form-input" id="filterMoveInStart">
                            </div>
                            <div class="form-field">
                                <label class="field-label">입주 종료</label>
                                <input type="date" class="form-input" id="filterMoveInEnd">
                            </div>
                            <div class="form-field">
                                <label class="field-label">&nbsp;</label>
                                <div class="page-actions">
                                    <button type="button" class="btn btn-secondary" id="btnResetResidentFilter">
                                        <span class="material-symbols-rounded">refresh</span>
                                        초기화
                                    </button>
                                    <button type="button" class="btn btn-primary" id="btnSearchResident">
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
                            <span class="material-symbols-rounded">groups</span>
                            입주민 목록
                        </h3>
                        <span class="list-count" id="residentCount">0건</span>
                    </div>
                    <div class="manager-grid-wrap">
                        <div id="residentGrid" class="ag-theme-alpine manager-ag-grid grid-size-10"></div>
                    </div>
                </div>

                <div class="modal-overlay" id="residentModal">
                    <div class="modal modal-lg">
                        <div class="modal-header primary">
                            <h3 class="modal-title">입주민 상세</h3>
                            <button type="button" class="modal-close" data-modal-close>
                                <span class="material-symbols-rounded">close</span>
                            </button>
                        </div>
                        <div class="modal-body">
                            <div class="form-section">
                                <div class="form-section-title">
                                    <span class="material-symbols-rounded">person</span>
                                    기본 정보
                                </div>
                                <div class="form-row cols-2">
                                    <div class="form-field">
                                        <label class="field-label">이름</label>
                                        <input type="text" class="form-input readonly-box" id="userNm" readonly>
                                    </div>
                                    <div class="form-field">
                                        <label class="field-label">연락처</label>
                                        <input type="text" class="form-input readonly-box" id="telno" readonly>
                                    </div>
                                </div>
                                <div class="form-row cols-2">
                                    <div class="form-field">
                                        <label class="field-label">이메일</label>
                                        <input type="text" class="form-input readonly-box" id="userEml" readonly>
                                    </div>
                                    <div class="form-field">
                                        <label class="field-label">회원번호</label>
                                        <input type="text" class="form-input readonly-box" id="userNo" readonly>
                                    </div>
                                </div>
                            </div>

                            <div class="form-section">
                                <div class="form-section-title">
                                    <span class="material-symbols-rounded">home</span>
                                    세대 정보
                                </div>
                                <div class="form-row cols-2">
                                    <div class="form-field">
                                        <label class="field-label">단지명</label>
                                        <input type="text" class="form-input readonly-box" id="complexName" readonly>
                                    </div>
                                    <div class="form-field">
                                        <label class="field-label">입주 상태</label>
                                        <input type="text" class="form-input readonly-box" id="moveStatus" readonly>
                                    </div>
                                </div>
                                <div class="form-row cols-3">
                                    <div class="form-field">
                                        <label class="field-label">동</label>
                                        <input type="text" class="form-input readonly-box" id="dong" readonly>
                                    </div>
                                    <div class="form-field">
                                        <label class="field-label">호</label>
                                        <input type="text" class="form-input readonly-box" id="ho" readonly>
                                    </div>
                                    <div class="form-field">
                                        <label class="field-label">세대 구분</label>
                                        <input type="text" class="form-input readonly-box" id="householdType" readonly>
                                    </div>
                                </div>
                                <div class="form-row cols-2">
                                    <div class="form-field">
                                        <label class="field-label">입주일</label>
                                        <input type="text" class="form-input readonly-box" id="moveInDate" readonly>
                                    </div>
                                    <div class="form-field">
                                        <label class="field-label">퇴거일</label>
                                        <input type="text" class="form-input readonly-box" id="moveOutDate" readonly>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="page-footer">
                            <button type="button" class="btn btn-secondary" data-modal-close>닫기</button>
                        </div>
                    </div>
                </div>
            </div>

            <script>
                (function () {
                    const page = document.getElementById("residentListPage");
                    if (!page || page.dataset.bound === "true") return;
                    page.dataset.bound = "true";

                    const mgmtOfcNo = "${mgmtOfcNo}";
                    const defaultComplexName = "${aptCmplexNm}";
                    const ctx = "${pageContext.request.contextPath}";
                    const residentApiUrl = ctx + "/manager/resident/list/api/" + encodeURIComponent(mgmtOfcNo);

                    const residentGridEl = document.getElementById("residentGrid");
                    const residentModal = document.getElementById("residentModal");
                    const residentCount = document.getElementById("residentCount");

                    let residentGridApi = null;

                    function setResidentCount(count) {
                        residentCount.textContent = count + "건";
                    }

                    function householdText(value) {
                        if (value === "HEAD") return "세대주";
                        if (value === "MEMBER") return "세대원";
                        return "-";
                    }

                    function moveStatusText(value) {
                        if (value === "WAIT") return "입주대기";
                        if (value === "LIVE") return "입주중";
                        if (value === "MID") return "중도퇴거";
                        if (value === "OUT") return "퇴거";



                        return "-";
                    }

                    function badgeHtml(cls, text) {
                        return '<span class="grid-badge ' + cls + '">' + text + '</span>';
                    }

                    function householdBadge(value) {
                        if (value === "HEAD") return badgeHtml("duty-head", "세대주");
                        if (value === "MEMBER") return badgeHtml("duty-adm", "세대원");
                        return '<span class="grid-badge gray">-</span>';
                    }
                    function moveStatusBadge(value) {

                        if (value === "WAIT") {
                            return badgeHtml("status-pending", "입주대기");
                        }

                        if (value === "LIVE") {
                            return badgeHtml("status-active", "입주중");
                        }

                        if (value === "MID") {
                            return badgeHtml("status-warning", "중도퇴거");
                        }
                        if (value === "OUT") {
                            return badgeHtml("status-inactive", "퇴거");
                        }

                        return '<span class="grid-badge gray">-</span>';
                    }

                    function getFilters() {
                        return {
                            complexName: document.getElementById("filterComplex").value.trim(),
                            dong: document.getElementById("filterDong").value.trim(),
                            ho: document.getElementById("filterHo").value.trim(),
                            householdType: document.getElementById("filterHouseholdType").value,
                            moveStatus: document.getElementById("filterMoveStatus").value,
                            keyword: document.getElementById("filterKeyword").value.trim(),
                            moveInStart: document.getElementById("filterMoveInStart").value,
                            moveInEnd: document.getElementById("filterMoveInEnd").value
                        };
                    }

                    function buildQueryString(filters) {
                        const params = new URLSearchParams();
                        Object.keys(filters).forEach(function (key) {
                            if (filters[key]) params.set(key, filters[key]);
                        });
                        return params.toString();
                    }

                    async function loadResidentRows() {
                        const queryString = buildQueryString(getFilters());
                        const url = queryString ? residentApiUrl + "?" + queryString : residentApiUrl;

                        try {
                            const response = await fetch(url);
                            if (!response.ok) throw new Error("입주민 목록 조회 실패");

                            const data = await response.json();
                            const rows = data.list || [];

                            if (residentGridApi) residentGridApi.setGridOption("rowData", rows);
                            setResidentCount(data.count ?? rows.length);
                        } catch (error) {
                            console.error(error);
                            if (residentGridApi) residentGridApi.setGridOption("rowData", []);
                            setResidentCount(0);
                        }
                    }

                    function openResidentModal(row) {
                        document.getElementById("userNm").value = row.userNm || "";
                        document.getElementById("telno").value = row.telno || "";
                        document.getElementById("userEml").value = row.userEml || "";
                        document.getElementById("userNo").value = row.userNo || "";
                        document.getElementById("complexName").value = row.complexName || "";

                        const dongValue = row.dong || "";

                        document.getElementById("dong").value =
                            dongValue.includes("_")
                                ? dongValue.split("_").pop()
                                : dongValue;







                        document.getElementById("ho").value = row.ho || "";
                        document.getElementById("householdType").value = householdText(row.householdType);
                        document.getElementById("moveStatus").value = moveStatusText(row.moveStatus);
                        document.getElementById("moveInDate").value = row.moveInDate || "";
                        document.getElementById("moveOutDate").value = row.moveOutDate || "";
                        residentModal.classList.add("open");
                    }

                    function closeModal() {
                        residentModal.classList.remove("open");
                    }

                    const columnDefs = [
                        {
                            headerName: "입주민",
                            field: "userNm",
                            minWidth: 220,
                            cellClass: "resident-cell-left",
                            cellRenderer: function (params) {
                                const name = params.data.userNm || "-";
                                const tel = params.data.telno || "-";
                                return ''
                                    + '<div class="avatar-row">'
                                    + '  <div class="avatar avatar-sm">' + name.charAt(0) + '</div>'
                                    + '  <div class="avatar-info">'
                                    + '    <div class="name">' + name + '</div>'
                                    + '    <div class="sub">' + tel + '</div>'
                                    + '  </div>'
                                    + '</div>';
                            }
                        },
                        { headerName: "단지명", field: "complexName", width: 180 },



                        {
                            headerName: "동",
                            field: "dong",
                            width: 100,
                            valueGetter: function (params) {
                                const dong = params.data.dong || "";

                                if (!dong.includes("_")) {
                                    return dong;
                                }

                                return dong.split("_").pop();
                            }
                        },



                        { headerName: "호", field: "ho", width: 110 },
                        {
                            headerName: "세대 구분",
                            field: "householdType",
                            width: 120,
                            cellRenderer: function (params) {
                                return householdBadge(params.value);
                            }
                        },
                        {
                            headerName: "입주 상태",
                            field: "moveStatus",
                            width: 120,
                            cellRenderer: function (params) {
                                return moveStatusBadge(params.value);
                            }
                        },
                        { headerName: "입주일", field: "moveInDate", width: 130 },
                        {
                            headerName: "상세",
                            field: "userNo",
                            width: 140,
                            sortable: false,
                            filter: false,
                            cellRenderer: function () {
                                return ''
                                    + '<div class="resident-actions">'
                                    + '  <button type="button" class="btn btn-xs btn-detail" data-action="detail">상세</button>'
                                    + '</div>';
                            }
                        }
                    ];

                    const gridOptions = {
                        theme: "legacy",
                        columnDefs: columnDefs,
                        rowData: [],
                        defaultColDef: {
                            sortable: true,
                            filter: true,
                            resizable: true,
                            suppressMovable: true
                        },
                        pagination: true,
                        paginationPageSize: 10,
                        paginationPageSizeSelector: [10, 20, 50],
                        rowHeight: 48,
                        headerHeight: 42,
                        suppressCellFocus: true,
                        onGridReady: function (params) {
                            residentGridApi = params.api;
                            loadResidentRows();
                        },
                        onCellClicked: function (event) {
                            const detailBtn = event.event.target.closest('[data-action="detail"]');
                            if (detailBtn) openResidentModal(event.data);
                        }
                    };

                    if (residentGridEl && window.agGrid) {
                        agGrid.createGrid(residentGridEl, gridOptions);
                    }

                    document.getElementById("filterComplex").value = defaultComplexName;
                    document.getElementById("btnSearchResident").addEventListener("click", loadResidentRows);
                    document.getElementById("btnResetResidentFilter").addEventListener("click", function () {
                        document.getElementById("filterComplex").value = defaultComplexName;
                        document.getElementById("filterDong").value = "";
                        document.getElementById("filterHo").value = "";
                        document.getElementById("filterHouseholdType").value = "";
                        document.getElementById("filterMoveStatus").value = "";
                        document.getElementById("filterKeyword").value = "";
                        document.getElementById("filterMoveInStart").value = "";
                        document.getElementById("filterMoveInEnd").value = "";
                        loadResidentRows();
                    });

                    page.addEventListener("click", function (event) {
                        if (event.target.closest("[data-modal-close]") || event.target === residentModal) {
                            closeModal();
                        }
                    });
                })();
            </script>
        </main>
    </div>
</div>
</body>
</html>
