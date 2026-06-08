/**
 * ============================================================
 * manager-agGrid.js
 * 관리사무소 AG Grid 공통 모듈
 * ============================================================
 */

const defaultGridOptions = {
    theme: "legacy",

    pagination: true,
    paginationPageSize: 10,
    paginationPageSizeSelector: false,

    rowHeight: 46,
    headerHeight: 42,

    animateRows: true,
    suppressDragLeaveHidesColumns: true,

    defaultColDef: {
        sortable: true,
        resizable: true,
        minWidth: 100
    }
};

function createManagerGrid(target, columnDefs, rowData, options = {}) {
    if (!target) {
        console.error("AG Grid target 없음");
        return null;
    }

    if (typeof agGrid === "undefined" || typeof agGrid.createGrid !== "function") {
        console.error("AG Grid가 정상 로드되지 않았습니다.");
        return null;
    }

    const gridOptions = {
        ...defaultGridOptions,
        ...options,
        columnDefs: columnDefs || [],
        rowData: rowData || []
    };

    const gridApi = agGrid.createGrid(target, gridOptions);

    target.__gridOptions = gridOptions;
    target.__gridApi = gridApi;

    return gridOptions;
}

function destroyManagerGrid(target) {
    if (!target) return;

    const gridApi = target.__gridApi;

    if (gridApi && typeof gridApi.destroy === "function") {
        gridApi.destroy();
    }

    target.__gridOptions = null;
    target.__gridApi = null;
    target.innerHTML = "";
}

function setGridQuickFilter(target, keyword) {
    const gridApi = target?.__gridApi;
    if (!gridApi) return;

    gridApi.setGridOption("quickFilterText", keyword || "");
}

function resetGridFilter(target) {
    const gridApi = target?.__gridApi;
    if (!gridApi) return;

    if (typeof gridApi.setFilterModel === "function") {
        gridApi.setFilterModel(null);
    }

    gridApi.setGridOption("quickFilterText", "");
}

function setGridRowData(target, rowData) {
    const gridApi = target?.__gridApi;
    if (!gridApi) return;

    gridApi.setGridOption("rowData", rowData || []);
}
