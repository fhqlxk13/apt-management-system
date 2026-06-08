/**
 * ============================================================
 * mngr-facility-grid.js
 * 시설자산 관리 AG Grid 전용 모듈
 *
 * 정리 기준
 * - AG Grid 전체 폭은 화면에 맞게 꽉 채움
 * - 가로 스크롤 방지를 위해 minWidth를 과하게 잡지 않음
 * - 번호 컬럼 추가
 * - 번호는 전체 데이터 기준 역순 표시
 *   예: 총 18개면 18, 17, 16 ... 1
 * - 번호 컬럼도 사용자가 폭 조절 가능
 * ============================================================
 */

var FacilityGrid = (function () {

    var gridTarget = null; // AG Grid가 붙을 div 요소

    function isAdminUser() {
        return window.facilityPageConfig
            && (window.facilityPageConfig.isAdmin === true
                || window.facilityPageConfig.isAdmin === "true");
    }

    function escapeHtml(value) {
        if (value == null) return "";
        return String(value)
            .replace(/&/g, "&amp;")
            .replace(/</g, "&lt;")
            .replace(/>/g, "&gt;")
            .replace(/\"/g, "&quot;")
            .replace(/'/g, "&#39;");
    }

    function badge(cls, text) {
        return '<span class="badge ' + cls + '">' + escapeHtml(text) + '</span>';
    }

    function useYnRenderer(params) {
        var isDisabled = params.value === "N";
        var cls = isDisabled ? "status-text is-disabled" : "status-text is-available";
        var text = isDisabled ? "사용 불가" : "사용 가능";

        return '<span class="' + cls + '">' + escapeHtml(text) + '</span>';
    }

    function getFacilityTypeText(row) {
        row = row || {};

        var fallbackMap = {
            ELV: "승강기",
            WTR: "급수시설",
            ELC: "전기시설",
            GAS: "가스시설",
            PLAY: "놀이터",
            SEC: "보안시설",
            ETC: "기타시설",
            PARK: "주차장",
            FIRE: "소방시설",
            COMM: "커뮤니티",
            GYM: "헬스장",
            STUDY: "독서실",
            MEET: "회의실",
            GUEST: "게스트룸",
            SENIOR: "경로당",
            PUB_ETC: "기타 편의시설"
        };

        return row.facilityTyNm || fallbackMap[row.facilityTyCd] || row.facilityTyCd || "-";
    }

    function facilityTypeRenderer(params) {
        return badge("badge-blue", getFacilityTypeText(params.data || {}));
    }

    function facilityNameRenderer(params) {
        return '<span class="td-bold">' + escapeHtml(params.value || "-") + '</span>';
    }

    function monoRenderer(params) {
        if (params.value == null || params.value === "") {
            return '<span class="td-empty">-</span>';
        }

        return '<span class="td-mono">' + escapeHtml(params.value) + '</span>';
    }

    function formatDongNo(value) {
        if (value == null || value === "") return "공용";

        var text = String(value);
        var idx = text.lastIndexOf("_");
        var dong = idx > -1 ? text.slice(idx + 1) : text;

        return dong || "공용";
    }

    function locationRenderer(params) {
        if (params.value == null || params.value === "") {
            return '<span class="td-empty">-</span>';
        }

        return '<span class="grid-ellipsis" title="' + escapeHtml(params.value) + '">'
            + escapeHtml(params.value)
            + '</span>';
    }

    function actionRenderer(params) {
        var row = params.data || {};
        var facilityNo = escapeHtml(params.value || "");
        var isPublic = row.facilityKind === "PUBLIC";

        var html = '<div class="grid-actions">'
            + '<button type="button" class="btn btn-detail"'
            + ' data-action="detail" data-row-key="' + facilityNo + '">'
            + '상세</button>';

        if (!isAdminUser() && !isPublic) {
            html += '<button type="button" class="btn btn-edit"'
                + ' data-action="edit" data-row-key="' + facilityNo + '">'
                + '수정</button>';
        }

        html += '</div>';
        return html;
    }

    function getColumnDefs() {
        return [
            {
                headerName: "번호",
                valueGetter: function (params) {
                    /*
                     * 전체 데이터 기준 역순 번호
                     * - 전체 18개면 첫 번째 행은 18번
                     * - 다음 행은 17번
                     * - 페이지가 바뀌어도 전체 순번 기준 유지
                     * - 필터가 적용되면 필터 결과 기준으로 다시 번호 계산
                     */
                    var totalCount = params.api.getDisplayedRowCount();
                    var rowIndex = params.node.rowIndex;

                    return totalCount - rowIndex;
                },
                width: 70,
                minWidth: 45,
                cellClass: "cell-center",
                sortable: false,
                resizable: true
            },
            {
                headerName: "시설번호",
                field: "facilityNo",
                width: 105,
                minWidth: 80,
                cellClass: "cell-center",
                cellRenderer: monoRenderer
            },
            {
                headerName: "시설명",
                field: "facilityNm",
                flex: 1.1,
                minWidth: 110,
                cellRenderer: facilityNameRenderer
            },
            {
                headerName: "시설유형",
                field: "facilityTyCd",
                width: 105,
                minWidth: 80,
                cellClass: "cell-center",
                cellRenderer: facilityTypeRenderer
            },
            {
                headerName: "운영상태",
                field: "useYn",
                width: 95,
                minWidth: 75,
                cellClass: "cell-center",
                cellRenderer: useYnRenderer
            },
            {
                headerName: "동",
                field: "dongNo",
                width: 65,
                minWidth: 45,
                cellClass: "cell-center",
                valueFormatter: function (params) {
                    return formatDongNo(params.value);
                }
            },
            {
                headerName: "상세위치",
                field: "locCn",
                flex: 1.2,
                minWidth: 110,
                cellRenderer: locationRenderer
            },
            {
                headerName: "설치일자",
                field: "instlDt",
                width: 105,
                minWidth: 80,
                cellClass: "cell-center",
                cellRenderer: AgRenderer.date
            },
            {
                headerName: "관리",
                valueGetter: function (params) {
                    return params.data ? params.data.facilityNo : "";
                },
                width: isAdminUser() ? 80 : 110,
                minWidth: isAdminUser() ? 70 : 95,
                cellClass: "cell-center",
                sortable: false,
                resizable: true,
                cellRenderer: actionRenderer
            }
        ];
    }

    function init(targetId) {
        gridTarget = document.getElementById(targetId);
        if (!gridTarget) return null;

        createManagerGrid(gridTarget, getColumnDefs(), [], {
            domLayout: "autoHeight",
            paginationPageSize: 10,
            suppressCellFocus: true,
            suppressHorizontalScroll: true,
            onGridReady: function (params) {
                /*
                 * 전체 폭 강제 맞춤 유지
                 * - 컬럼이 화면 밖으로 밀려 가로 스크롤 생기는 것을 줄임
                 */
                params.api.sizeColumnsToFit();
            },
            onFirstDataRendered: function (params) {
                params.api.sizeColumnsToFit();
            }
        });

        return gridTarget.__gridApi;
    }

    function setRows(rowData) {
        setGridRowData(gridTarget, rowData || []);
        refreshSize();
    }

    function reset() {
        resetGridFilter(gridTarget);
    }

    function refreshSize() {
        var api = gridTarget && gridTarget.__gridApi;

        if (api && typeof api.sizeColumnsToFit === "function") {
            api.sizeColumnsToFit();
        }
    }

    function exportExcel(fileName) {
        var api = gridTarget && gridTarget.__gridApi;
        if (!api || typeof api.exportDataAsCsv !== "function") return false;

        api.exportDataAsCsv({
            fileName: fileName || "facility-list.csv",
            columnKeys: ["facilityNo", "facilityNm", "facilityTyCd", "useYn", "dongNo", "locCn", "instlDt"],
            allColumns: false,
            skipPinnedTop: true,
            skipPinnedBottom: true,
            prependContent: "\ufeff"
        });

        return true;
    }

    function getRows() {
        var api = gridTarget && gridTarget.__gridApi;
        var rows = [];

        if (!api || typeof api.forEachNode !== "function") {
            return rows;
        }

        api.forEachNode(function (node) {
            if (node && node.data) {
                rows.push(node.data);
            }
        });
        /**
         * 현재 페이지 번호 조회
         * - AG Grid 현재 페이지 번호 반환
         * - AG Grid 페이지 번호는 0부터 시작
         */
        function getCurrentPage() {
            /* AG Grid API */
            var api = gridTarget && gridTarget.__gridApi;

            /* 페이지 조회 가능 여부 확인 */
            var canGetPage = api && typeof api.paginationGetCurrentPage === "function";

            /* 페이지 조회 불가 처리 */
            if (!canGetPage) {
                return 0;
            }

            /* 현재 페이지 번호 반환 */
            return api.paginationGetCurrentPage();
        }

        /**
         * 지정 페이지 이동
         * - 저장된 목록 페이지 복원용
         * - AG Grid 페이지 번호는 0부터 시작
         */
        function goToPage(page) {
            /* AG Grid API */
            var api = gridTarget && gridTarget.__gridApi;

            /* 페이지 이동 가능 여부 확인 */
            var canGoPage = api && typeof api.paginationGoToPage === "function";

            /* 페이지 이동 불가 처리 */
            if (!canGoPage) {
                return;
            }

            /* 이동 페이지 번호 */
            var pageNo = Number(page) || 0;

            /* 지정 페이지 이동 */
            api.paginationGoToPage(pageNo);
        }

        return rows;
    }

    return {
        init: init,
        setRows: setRows,
        reset: reset,
        refreshSize: refreshSize,
        exportExcel: exportExcel,
        getRows: getRows,
        getCurrentPage: getCurrentPage,
        goToPage: goToPage

    };

})();