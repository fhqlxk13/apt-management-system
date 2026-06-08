/**
 * ============================================================
 * mngr-facility-grid.js
 * 시설자산 관리 AG Grid 전용 모듈
 *
 * 정리 기준
 * - AG Grid 전체 폭 맞춤
 * - 가로 스크롤 방지
 * - 번호 컬럼 표시
 * - 전체 데이터 기준 역순 번호 표시
 *   예: 총 18개면 18, 17, 16 ... 1
 * - 번호 컬럼 폭 조절 가능
 * - 관리 컬럼에 상세 / 수정 / 활성상태 버튼 표시
 *
 * 활성상태 버튼 기준
 * - 현재 활성 상태  : 빨간색 "활성"
 * - 현재 비활성 상태: 회색 "비활성"
 * - 클릭 시 현재 상태의 반대값으로 변경
 * ============================================================
 */

var FacilityGrid = (function () {

    /* AG Grid가 붙을 대상 div 요소 */
    var gridTarget = null;

    /**
     * ADMIN 사용자 여부 확인
     */
    function isAdminUser() {
        /* JSP에서 내려준 화면 설정 정보 */
        var pageConfig = window.facilityPageConfig;

        /* ADMIN 여부 반환 */
        return pageConfig
            && (pageConfig.isAdmin === true || pageConfig.isAdmin === "true");
    }

    /**
     * HTML 특수문자 변환
     */
    function escapeHtml(value) {
        /* 빈 값 방어 */
        if (value == null) return "";

        /* HTML 특수문자 치환 */
        return String(value)
            .replace(/&/g, "&amp;")
            .replace(/</g, "&lt;")
            .replace(/>/g, "&gt;")
            .replace(/\"/g, "&quot;")
            .replace(/'/g, "&#39;");
    }

    /**
     * 배지 HTML 생성
     */
    function badge(cls, text) {
        /* 배지 표시 */
        return '<span class="badge ' + cls + '">' + escapeHtml(text) + '</span>';
    }

    /**
     * 활성여부 표시 렌더러
     * - FACILITY.USE_YN 원본값만 표시
     * - 점검 이용제한 상태와 섞지 않음
     */
    function useYnRenderer(params) {
        /* 비활성 여부 */
        var isDisabled = params.value === "N";

        /* 상태 CSS */
        var cls = isDisabled ? "status-text is-disabled" : "status-text is-available";

        /* 상태 문구 */
        var text = isDisabled ? "비활성" : "활성";

        /* 활성여부 표시 */
        return '<span class="' + cls + '">' + escapeHtml(text) + '</span>';
    }

    /**
     * 이용제한 표시 렌더러
     * - FACILITY_CHECK_HSTRY 이용제한 시간 기준
     * - 현재 시간이 제한 시작~종료 사이이면 제한중
     */
    function restrictRenderer(params) {
        /* 행 데이터 */
        var row = params.data || {};
        var statusCd = row.currentRestrictStatusCd || "";
        var statusNm = row.currentRestrictStatusNm || "";

        if (statusCd === "ONGOING" || row.currentRestrictYn === "Y") {
            return '<span class="status-text is-restricted">' + escapeHtml(statusNm || "제한중") + '</span>';
        }
        if (statusCd === "UPCOMING") {
            return '<span class="status-text is-wait">' + escapeHtml(statusNm || "제한예정") + '</span>';
        }
        if (statusCd === "ENDED") {
            return '<span class="status-text is-disabled">' + escapeHtml(statusNm || "제한종료") + '</span>';
        }

        return '<span class="status-text is-none">' + escapeHtml(statusNm || "제한없음") + '</span>';
    }

    /**
     * 시설유형명 반환
     */
    function getFacilityTypeText(row) {
        /* 행 데이터 기본값 */
        row = row || {};

        /* 시설유형 코드별 기본 표시명 */
        var fallbackMap = {
            ELV: "승강기",
            WTR: "급수시설",
            ELC: "전기시설",
            GAS: "가스시설",
            SEC: "보안시설",
            ETC: "기타시설",
            MEET: "회의실",
            PARK: "입주민주차장",
            PLAY: "놀이시설",
            COMM: "커뮤니티시설",
            FIRE: "소방시설",
            GYM: "피트니스센터",
            STUDY: "독서실",
            PARKING: "방문차량주차구역"
        };

        /* DB 시설유형명 우선 */
        return row.facilityTyNm || fallbackMap[row.facilityTyCd] || row.facilityTyCd || "-";
    }

    /**
     * 시설유형 배지 렌더러
     */
    function facilityTypeRenderer(params) {
        /* 시설유형 배지 표시 */
        return badge("badge-blue", getFacilityTypeText(params.data || {}));
    }

    /**
     * 운영관리 표시 렌더러
     */
    function publicOperationRenderer(params) {
        /* 행 데이터 */
        var row = params.data || {};

        /* 공용/편의시설 여부 */
        var isPublicType = row.facilityKind === "PUBLIC";

        /* 운영정보 등록 여부 */
        var isRegistered = row.publicOperRegisteredYn === "Y" || !!row.cmnFacilityNo;

        /* 일반시설은 운영관리 대상 아님 */
        if (!isPublicType) {
            return '<span class="td-empty">-</span>';
        }

        /* 운영등록/운영미등록 표시 */
        return isRegistered
            ? badge("badge-teal", "운영등록")
            : badge("badge-gray", "운영미등록");
    }

    /**
     * 시설명 강조 렌더러
     */
    function facilityNameRenderer(params) {
        /* 시설명 표시 */
        return '<span class="td-bold">' + escapeHtml(params.value || "-") + '</span>';
    }

    /**
     * 고정폭 문자 렌더러
     */
    function monoRenderer(params) {
        /* 빈 값 처리 */
        if (params.value == null || params.value === "") {
            return '<span class="td-empty">-</span>';
        }

        /* 고정폭 문자 표시 */
        return '<span class="td-mono">' + escapeHtml(params.value) + '</span>';
    }

    /**
     * 동 번호 표시값 변환
     */
    function formatDongNo(value) {
        /* 공용 위치 */
        if (value == null || value === "") return "공용";

        /* 동 번호 문자열 */
        var text = String(value);

        /* 언더바 뒤쪽 실제 동 표시 */
        var idx = text.lastIndexOf("_");
        var dong = idx > -1 ? text.slice(idx + 1) : text;

        return dong || "공용";
    }

    /**
     * 상세위치 말줄임 렌더러
     */
    function locationRenderer(params) {
        /* 빈 값 처리 */
        if (params.value == null || params.value === "") {
            return '<span class="td-empty">-</span>';
        }

        /* 상세위치 표시값 */
        var locationText = escapeHtml(params.value);

        return '<span class="grid-ellipsis" title="' + locationText + '">'
            + locationText
            + '</span>';
    }

    /**
     * 활성상태 버튼 스타일 생성
     *
     * 기준 (협력업체 관리 버튼 스타일과 동일)
     * - 현재 활성  → "비활성" 버튼 (흰색 바탕)
     * - 현재 비활성 → "활성" 버튼 (녹색 바탕)
     *
     * CSS 파일 수정 없이 바로 적용되도록 inline style 사용
     */
    function getUseButtonStyle(useYn) {
        /* 현재 비활성 → 활성 전환 버튼 (녹색) */
        if (useYn === "N") {
            return "background:#2e5c38;border:1px solid #2e5c38;color:#fff;";
        }

        /* 현재 활성 → 비활성 전환 버튼 (흰색, 상세 버튼과 동일 테두리) */
        return "background:#fff;border:1px solid #d7dce2;color:#39443d;";
    }
    /**
     * 관리 버튼 렌더러
     *
     * 버튼 문구 기준
     * - 현재 활성 시설  : "비활성" (클릭 시 비활성 처리)
     * - 현재 비활성 시설: "활성"   (클릭 시 활성 처리)
     *
     * 클릭 동작 기준
     * - data-use-yn에는 현재 상태를 담음
     * - JSP의 toggleFacilityUseYn()에서 현재 상태를 보고 반대로 변경
     */
    function actionRenderer(params) {
        /* 행 데이터 */
        var row = params.data || {};

        /* 시설번호 */
        var facilityNo = escapeHtml(params.value || row.facilityNo || "");

        /* 현재 활성여부 */
        var useYn = row.useYn === "N" ? "N" : "Y";

        /* 클릭 시 전환될 상태 문구 */
        var toggleText = useYn === "N" ? "활성" : "비활성";

        /* 현재 상태 버튼 색상 */
        var toggleStyle = getUseButtonStyle(useYn);

        /* 관리 버튼 영역 시작 */
        var html = '<div class="grid-actions">'
            + '<button type="button" class="btn btn-detail"'
            + ' data-action="detail" data-row-key="' + facilityNo + '">'
            + '상세</button>';

        /* ADMIN이 아니면 수정/활성상태 버튼 표시 */
        if (!isAdminUser()) {
            /* 수정 버튼 */
            html += '<button type="button" class="btn btn-edit"'
                + ' data-action="edit" data-row-key="' + facilityNo + '">'
                + '수정</button>';

            /* 활성상태 버튼 */
            html += '<button type="button" class="btn btn-sm"'
                + ' style="' + toggleStyle + '"'
                + ' data-action="toggleUseYn"'
                + ' data-row-key="' + facilityNo + '"'
                + ' data-use-yn="' + useYn + '">'
                + toggleText
                + '</button>';
        }

        /* 관리 버튼 영역 종료 */
        html += '</div>';

        return html;
    }

    /**
     * AG Grid 컬럼 정의 생성
     */
    function getColumnDefs() {
        return [
            {
                headerName: "번호",
                valueGetter: function (params) {
                    /* 현재 표시 행 수 */
                    var totalCount = params.api.getDisplayedRowCount();

                    /* 현재 행 인덱스 */
                    var rowIndex = params.node.rowIndex;

                    /* 전체 데이터 기준 역순 번호 */
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
                headerName: "운영관리",
                field: "publicOperRegisteredYn",
                width: 105,
                minWidth: 85,
                cellClass: "cell-center",
                cellRenderer: publicOperationRenderer
            },
            {
                headerName: "활성여부",
                field: "useYn",
                width: 90,
                minWidth: 70,
                cellClass: "cell-center",
                cellRenderer: useYnRenderer
            },
            {
                headerName: "이용제한",
                field: "currentRestrictYn",
                width: 90,
                minWidth: 75,
                cellClass: "cell-center",
                cellRenderer: restrictRenderer
            },
            {
                headerName: "동",
                field: "dongNo",
                width: 65,
                minWidth: 45,
                cellClass: "cell-center",
                valueFormatter: function (params) {
                    /* 동 표시값 */
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
                    /* 관리 버튼에 전달할 시설번호 */
                    var row = params.data;
                    return row ? row.facilityNo : "";
                },
                width: isAdminUser() ? 80 : 195,
                minWidth: isAdminUser() ? 70 : 170,
                cellClass: "cell-center",
                sortable: false,
                resizable: true,
                cellRenderer: actionRenderer
            }
        ];
    }

    /**
     * AG Grid 초기화
     */
    function init(targetId) {
        /* 그리드 대상 요소 조회 */
        gridTarget = document.getElementById(targetId);

        /* 대상 요소 없음 */
        if (!gridTarget) return null;

        /* AG Grid 생성 */
        createManagerGrid(gridTarget, getColumnDefs(), [], {
            domLayout: "autoHeight",
            paginationPageSize: 10,
            suppressCellFocus: true,
            suppressHorizontalScroll: true,

            /**
             * 그리드 준비 완료 후 컬럼 폭 맞춤
             */
            onGridReady: function (params) {
                params.api.sizeColumnsToFit();
            },

            /**
             * 최초 데이터 렌더링 후 컬럼 폭 맞춤
             */
            onFirstDataRendered: function (params) {
                params.api.sizeColumnsToFit();
            }
        });

        /* AG Grid API 반환 */
        return gridTarget.__gridApi;
    }

    /**
     * 그리드 행 데이터 설정
     */
    function setRows(rowData) {
        /* 행 데이터 기본값 */
        var rows = rowData || [];

        /* AG Grid 행 데이터 반영 */
        setGridRowData(gridTarget, rows);

        /* 컬럼 폭 재조정 */
        refreshSize();
    }

    /**
     * 그리드 필터 초기화
     */
    function reset() {
        /* 공통 그리드 필터 초기화 */
        resetGridFilter(gridTarget);
    }

    /**
     * 그리드 컬럼 폭 재조정
     */
    function refreshSize() {
        /* AG Grid API */
        var api = gridTarget && gridTarget.__gridApi;

        /* 컬럼 폭 맞춤 */
        if (api && typeof api.sizeColumnsToFit === "function") {
            api.sizeColumnsToFit();
        }
    }

    /**
     * CSV 파일 내보내기
     */
    function exportExcel(fileName) {
        /* AG Grid API */
        var api = gridTarget && gridTarget.__gridApi;

        /* 내보내기 가능 여부 */
        if (!api || typeof api.exportDataAsCsv !== "function") {
            return false;
        }

        /* CSV 내보내기 */
        api.exportDataAsCsv({
            fileName: fileName || "facility-list.csv",
            columnKeys: [
                "facilityNo",
                "facilityNm",
                "facilityTyCd",
                "publicOperRegisteredYn",
                "useYn",
                "currentRestrictYn",
                "dongNo",
                "locCn",
                "instlDt"
            ],
            allColumns: false,
            skipPinnedTop: true,
            skipPinnedBottom: true,
            prependContent: "\ufeff"
        });

        return true;
    }

    /**
     * 현재 그리드 행 데이터 반환
     */
    function getRows() {
        /* AG Grid API */
        var api = gridTarget && gridTarget.__gridApi;

        /* 행 데이터 배열 */
        var rows = [];

        /* 노드 순회 불가 */
        if (!api || typeof api.forEachNode !== "function") {
            return rows;
        }

        /* 전체 노드 순회 */
        api.forEachNode(function (node) {
            if (node && node.data) {
                rows.push(node.data);
            }
        });

        return rows;
    }

    /**
     * 현재 페이지 번호 조회
     * - AG Grid 현재 페이지 번호 반환
     * - AG Grid 페이지 번호는 0부터 시작
     */
    function getCurrentPage() {
        /* AG Grid API */
        var api = gridTarget && gridTarget.__gridApi;

        /* 페이지 조회 불가 */
        if (!api || typeof api.paginationGetCurrentPage !== "function") {
            return 0;
        }

        /* 현재 페이지 반환 */
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

        /* 페이지 이동 불가 */
        if (!api || typeof api.paginationGoToPage !== "function") {
            return;
        }

        /* 이동 페이지 번호 */
        var pageNo = Number(page) || 0;

        /* 지정 페이지 이동 */
        api.paginationGoToPage(pageNo);
    }

    /**
     * 외부 공개 함수 목록
     */
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
