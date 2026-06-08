/**
 * ============================================================
 * publicFacility-agGrid.js
 * 공용시설 관리 AG Grid 전용 스크립트
 *
 * 역할
 * - 공용시설 / 공용 아이템 컬럼 정의
 * - 상태/예약 배지 렌더링
 * - 목록 행 번호 계산
 * - 상세/수정/삭제/운영등록 버튼 렌더링
 *
 * 전제
 * - ag-grid-community.min.js가 먼저 로드되어야 함
 * - publicFacilityList.jsp는 목록 조회와 검색 조건만 담당
 * - 이 파일은 AG Grid 생성과 컬럼 표시만 담당
 * ============================================================
 */
(function (window) {
    "use strict";

    /**
     * null 방어 문자열 변환
     * - undefined/null 값을 빈 문자열로 통일
     */
    function text(value) {
        return value == null ? "" : String(value);
    }

    /**
     * HTML 문자 이스케이프
     * - 셀 내부 HTML 생성 시 태그 깨짐 방지
     */
    function escapeHtml(value) {
        return text(value)
            .replace(/&/g, "&amp;")
            .replace(/</g, "&lt;")
            .replace(/>/g, "&gt;")
            .replace(/\"/g, "&quot;")
            .replace(/'/g, "&#39;");
    }

    /**
     * 날짜 표시값 보정
     * - yyyy-MM-dd / yyyy.MM.dd 형태 모두 목록에서 보기 좋은 yyyy.MM.dd로 표시
     */
    function formatDate(value) {
        return text(value).replace(/-/g, ".");
    }

    /**
     * 빈 값 표시 보정
     * - 그리드에서 값이 없을 때 '-' 표시
     */
    function displayText(value) {
        var valueText = text(value).trim();
        return valueText ? valueText : "-";
    }

    /**
     * 편의시설명 표시값
     * - 편의시설명이 없으면 '-' 표시
     */
    function getFacilityName(row) {
        return displayText(row.cmnFacilityNm);
    }

    /**
     * 카테고리 표시값
     * - 시설유형명 우선 표시
     */
    function getFacilityTypeName(row) {
        return displayText(row.facilityTyNm || row.facilityTyCd);
    }

    /**
     * 동 표시값
     * - 동 정보가 있으면 동 표시
     * - 동 정보가 없으면 공용 위치 시설로 판단하여 "공용" 표시
     */
    function getDongText(row) {
        var dongText = text(row.dongNm || row.dongName || row.dongNo || row.buildingNm || row.buildingNo).trim();

        if (dongText.indexOf("_") > -1) {
            dongText = dongText.substring(dongText.lastIndexOf("_") + 1);
        }

        if (!dongText) return "공용";

        return dongText;
    }

    /**
     * 위치 표시값
     * - 공용 여부와 상관없이 상세 위치는 그대로 표시
     * - 상세 위치가 없을 때만 '-' 표시
     */
    function getLocationText(row) {
        return displayText(row.locCn || row.locationCn || row.facilityLocCn);
    }

    /**
     * 운영현황 코드 계산
     * - 서버 계산값이 있으면 우선 사용
     * - 없으면 자원 집계 수량으로 보정
     */
    function getOperationStatus(row) {
        var directStatus;
        var repairCount;
        var closeCount;

        if (!row.cmnFacilityNo) {
            return "UNREGISTERED";
        }

        directStatus = row.operStatus || row.operationStatus || row.operStatusCd || row.operationStatusCd;
        repairCount = Number(row.repairCnt || row.repairItemCnt || row.itemRepairCnt || 0);
        closeCount = Number(row.closeCnt || row.closeItemCnt || row.itemCloseCnt || 0);

        if (directStatus) return directStatus;
        if (closeCount > 0) return "CLOSE_PART";
        if (repairCount > 0) return "REPAIR_PART";

        return "NORMAL";
    }

    /**
     * 배지 HTML 생성
     * - JSP CSS의 badge 클래스를 그대로 사용
     */
    function badge(label, colorClass) {
        return '<span class="badge ' + colorClass + '">' + escapeHtml(label) + '</span>';
    }

    /**
     * 예약여부 배지 렌더링
     * - Y: 예약제
     * - N: 자유이용
     */
    function renderReserveBadge(value) {
        if (value === "Y") return badge("예약제", "badge-blue");
        if (value === "N") return badge("자유이용", "badge-gray");

        return badge("미등록", "badge-gray");
    }

    /**
     * 편의시설 운영현황 배지 렌더링
     * - 운영미등록 / 정상 / 일부 점검중 / 일부 사용중지
     */
    function renderFacilityStatusBadge(row) {
        var status = getOperationStatus(row);

        if (status === "UNREGISTERED") return badge("운영미등록", "badge-gray");
        if (status === "REPAIR_PART") return badge("일부 점검중", "badge-yellow");
        if (status === "CLOSE_PART") return badge("일부 사용중지", "badge-red");

        return badge("정상", "badge-green");
    }

    /**
     * 편의시설 자원 상태 배지 렌더링
     * - 자원상태코드 기준 표시
     */
    function renderItemStatusBadge(status) {
        if (status === "OPEN") return badge("사용가능", "badge-green");
        if (status === "USE") return badge("사용중", "badge-blue");
        if (status === "REPAIR") return badge("점검중", "badge-yellow");
        if (status === "CLOSE") return badge("사용중지", "badge-red");

        return badge("미등록", "badge-gray");
    }

    /**
     * 말줄임 셀 렌더링
     * - 긴 텍스트 컬럼 공통 처리
     */
    function renderEllipsis(value) {
        return '<span class="grid-ellipsis" title="' + escapeHtml(value) + '">' + escapeHtml(value) + '</span>';
    }

    /**
     * 역순 번호 렌더링
     * - 현재 표시 행 전체 개수 기준 역순 번호
     */
    function renderReverseNumber(params) {
        var count = params.api ? params.api.getDisplayedRowCount() : 0;
        return count - params.node.rowIndex;
    }

    /**
     * 버튼 DOM 생성
     * - cellRenderer 내부 클릭 이벤트 연결
     */
    function createButton(label, className, clickHandler) {
        var button = document.createElement("button");

        button.type = "button";
        button.className = className;
        button.textContent = label;

        button.addEventListener("click", function (event) {
            event.preventDefault();
            event.stopPropagation();

            button.blur();
            clickHandler();
        });

        return button;
    }

    /**
     * 편의시설 액션 버튼 렌더링
     * - 운영등록 완료: 상세/수정/삭제
     * - 운영미등록: 운영등록
     * - ADMIN: 상세만 표시
     */
    function renderFacilityActions(params, option) {
        var row = params.data || {};
        var wrap = document.createElement("div");

        wrap.className = "grid-actions";

        if (row.cmnFacilityNo) {
            wrap.appendChild(createButton("상세", "btn btn-secondary btn-sm", function () {
                if (typeof option.onFacilityDetail === "function") {
                    option.onFacilityDetail(row.cmnFacilityNo, row);
                }
            }));
        }

        if (option.isAdmin) {
            return wrap;
        }

        if (!row.cmnFacilityNo) {
            wrap.appendChild(createButton("운영등록", "btn btn-primary btn-sm", function () {
                if (typeof option.onFacilityRegister === "function") {
                    option.onFacilityRegister(row);
                }
            }));

            return wrap;
        }

        wrap.appendChild(createButton("수정", "btn btn-primary btn-sm", function () {
            if (typeof option.onFacilityEdit === "function") {
                option.onFacilityEdit(row.cmnFacilityNo, row);
            }
        }));

        wrap.appendChild(createButton("삭제", "btn btn-secondary btn-sm", function () {
            if (typeof option.onFacilityDelete === "function") {
                option.onFacilityDelete(row.cmnFacilityNo, row);
            }
        }));

        return wrap;
    }

    /**
     * 편의시설 자원 액션 버튼 렌더링
     * - ADMIN: 상세만 표시
     * - MNGR: 상세/수정/삭제 표시
     */
    function renderItemActions(params, option) {
        var row = params.data || {};
        var wrap = document.createElement("div");

        wrap.className = "grid-actions";

        wrap.appendChild(createButton("상세", "btn btn-secondary btn-sm", function () {
            if (typeof option.onItemDetail === "function") {
                option.onItemDetail(row.cmnFacilityItemNo, row);
            }
        }));

        if (option.isAdmin) {
            return wrap;
        }

        wrap.appendChild(createButton("수정", "btn btn-primary btn-sm", function () {
            if (typeof option.onItemEdit === "function") {
                option.onItemEdit(row.cmnFacilityItemNo, row);
            }
        }));

        wrap.appendChild(createButton("삭제", "btn btn-secondary btn-sm", function () {
            if (typeof option.onItemDelete === "function") {
                option.onItemDelete(row.cmnFacilityItemNo, row);
            }
        }));

        return wrap;
    }

    /**
     * 편의시설 컬럼 정의
     * - 시설번호 / 시설명 / 이용요금 / 운영시간 제거
     * - 편의시설번호와 편의시설명 중심 표시
     */
    function getFacilityColumnDefs(option) {
        return [
            {
                headerName: "번호",
                width: 70,
                minWidth: 60,
                maxWidth: 90,
                valueGetter: renderReverseNumber,
                cellClass: "cell-center",
                sortable: false,
                resizable: true
            },
            {
                headerName: "편의시설번호",
                field: "cmnFacilityNo",
                flex: .95,
                minWidth: 120,
                cellClass: "cell-mono",
                valueGetter: function (p) {
                    return displayText((p.data || {}).cmnFacilityNo);
                }
            },
            {
                headerName: "편의시설명",
                field: "cmnFacilityNm",
                flex: 1.35,
                minWidth: 155,
                cellClass: "cell-left",
                cellRenderer: function (p) {
                    return renderEllipsis(getFacilityName(p.data || {}));
                }
            },
            {
                headerName: "카테고리",
                field: "facilityTyNm",
                flex: .8,
                minWidth: 100,
                cellClass: "cell-center",
                cellRenderer: function (p) {
                    return badge(getFacilityTypeName(p.data || {}), "badge-blue");
                }
            },
            {
                headerName: "동",
                field: "dongNm",
                flex: .42,
                minWidth: 55,
                maxWidth: 75,
                cellClass: "cell-center",
                valueGetter: function (p) {
                    return getDongText(p.data || {});
                }
            },
            {
                headerName: "위치",
                field: "locCn",
                flex: 1.35,
                minWidth: 150,
                cellClass: "cell-left",
                cellRenderer: function (p) {
                    return renderEllipsis(getLocationText(p.data || {}));
                }
            },
            {
                headerName: "예약",
                field: "cmnFacilityRsvYn",
                flex: .65,
                minWidth: 85,
                cellClass: "cell-center",
                cellRenderer: function (p) {
                    return renderReserveBadge((p.data || {}).cmnFacilityRsvYn || (p.data || {}).rsvYn);
                }
            },
            {
                headerName: "운영현황",
                field: "operStatus",
                flex: .85,
                minWidth: 105,
                cellClass: "cell-center",
                cellRenderer: function (p) {
                    return renderFacilityStatusBadge(p.data || {});
                }
            },
            {
                headerName: "자원",
                field: "itemCnt",
                flex: .55,
                minWidth: 70,
                cellClass: "cell-center",
                valueGetter: function (p) {
                    return Number((p.data || {}).itemCnt || 0) + "개";
                }
            },
            {
                headerName: "수정일",
                field: "mdfDt",
                flex: .75,
                minWidth: 90,
                cellClass: "cell-center",
                valueFormatter: function (p) {
                    return displayText(formatDate(p.value));
                }
            },
            {
                headerName: "관리",
                field: "actions",
                flex: option.isAdmin ? .65 : 1.15,
                minWidth: option.isAdmin ? 90 : 145,
                cellClass: "cell-center",
                sortable: false,
                resizable: false,
                cellRenderer: function (p) {
                    return renderFacilityActions(p, option);
                }
            }
        ];
    }

    /**
     * 편의시설 자원 컬럼 정의
     * - 자원 탭 목록 표시 기준
     */
    function getItemColumnDefs(option) {
        return [
            {
                headerName: "번호",
                width: 70,
                minWidth: 60,
                maxWidth: 90,
                valueGetter: renderReverseNumber,
                cellClass: "cell-center",
                sortable: false,
                resizable: true
            },
            {
                headerName: "편의시설번호",
                field: "cmnFacilityNo",
                flex: 1,
                minWidth: 120,
                cellClass: "cell-mono"
            },
            {
                headerName: "자원번호",
                field: "cmnFacilityItemNo",
                flex: 1,
                minWidth: 130,
                cellClass: "cell-mono"
            },
            {
                headerName: "편의시설명",
                field: "cmnFacilityNm",
                flex: 1.2,
                minWidth: 130,
                cellClass: "cell-left",
                cellRenderer: function (p) {
                    return renderEllipsis((p.data || {}).cmnFacilityNm);
                }
            },
            {
                headerName: "자원명",
                field: "itemNm",
                flex: 1.2,
                minWidth: 130,
                cellClass: "cell-left",
                cellRenderer: function (p) {
                    return renderEllipsis((p.data || {}).itemNm);
                }
            },
            {
                headerName: "자원상태",
                field: "cmnFacilitySttsCd",
                flex: .8,
                minWidth: 100,
                cellClass: "cell-center",
                cellRenderer: function (p) {
                    return renderItemStatusBadge((p.data || {}).cmnFacilitySttsCd);
                }
            },
            {
                headerName: "관리",
                field: "actions",
                flex: option.isAdmin ? .65 : 1.05,
                minWidth: option.isAdmin ? 90 : 140,
                cellClass: "cell-center",
                sortable: false,
                resizable: false,
                cellRenderer: function (p) {
                    return renderItemActions(p, option);
                }
            }
        ];
    }

    /**
     * 현재 탭 컬럼 정의 반환
     * - 편의시설 자원 탭이면 자원 컬럼
     * - 아니면 편의시설 컬럼
     */
    function getColumnDefs(viewType, option) {
        return viewType === "PUBLIC_ITEM" ? getItemColumnDefs(option) : getFacilityColumnDefs(option);
    }

    /**
     * Grid API 행 데이터 세팅
     * - AG Grid 버전별 API 차이 방어
     */
    function setGridRowData(api, rows) {
        if (api && typeof api.setGridOption === "function") {
            api.setGridOption("rowData", rows || []);
            return;
        }

        if (api && typeof api.setRowData === "function") {
            api.setRowData(rows || []);
        }
    }

    /**
     * Grid API 컬럼 세팅
     * - AG Grid 버전별 API 차이 방어
     */
    function setGridColumnDefs(api, columnDefs) {
        if (api && typeof api.setGridOption === "function") {
            api.setGridOption("columnDefs", columnDefs);
            return;
        }

        if (api && typeof api.setColumnDefs === "function") {
            api.setColumnDefs(columnDefs);
        }
    }

    /**
     * 컬럼 폭 맞춤
     * - 가로 스크롤 방지
     */
    function fitColumns(api) {
        if (!api) return;

        window.setTimeout(function () {
            if (typeof api.sizeColumnsToFit === "function") {
                api.sizeColumnsToFit();
            }
        }, 0);
    }

    /**
     * AG Grid 생성
     * - JSP에서 window.PublicFacilityAgGrid.create(...)로 호출
     */
    function create(option) {
        var gridEl = document.getElementById(option.gridId);
        var state = {
            viewType: option.viewType || "PUBLIC_FACILITY",
            rows: []
        };
        var gridOptions;
        var api;

        option.isAdmin = option.isAdmin === true || option.isAdmin === "true";

        if (!gridEl) {
            throw new Error("공용시설 그리드 영역을 찾을 수 없습니다: " + option.gridId);
        }

        gridEl.style.height = gridEl.style.height || "560px";

        gridOptions = {
            theme: "legacy",
            rowData: [],
            columnDefs: getColumnDefs(state.viewType, option),
            defaultColDef: {
                sortable: true,
                resizable: true,
                minWidth: 80
            },
            pagination: true,
            paginationPageSize: 10,
            paginationPageSizeSelector: [10, 20, 50],
            rowHeight: 46,
            headerHeight: 42,
            animateRows: true,
            suppressCellFocus: true,
            suppressHorizontalScroll: true,
            suppressDragLeaveHidesColumns: true,
            domLayout: "normal",
            onGridReady: function (params) {
                fitColumns(params.api);
            },
            onFirstDataRendered: function (params) {
                fitColumns(params.api);
            }
        };

        if (window.agGrid && typeof window.agGrid.createGrid === "function") {
            api = window.agGrid.createGrid(gridEl, gridOptions);
        } else if (window.agGrid && typeof window.agGrid.Grid === "function") {
            new window.agGrid.Grid(gridEl, gridOptions);
            api = gridOptions.api;
        } else {
            throw new Error("AG Grid 라이브러리가 로드되지 않았습니다.");
        }

        return {
            /**
             * 행 데이터 교체
             * - 검색/조회 결과를 그리드에 반영
             */
            setRows: function (rows) {
                state.rows = rows || [];
                setGridRowData(api, state.rows);
                fitColumns(api);

                if (api && typeof api.refreshCells === "function") {
                    api.refreshCells({ force: true });
                }
            },

            /**
             * 탭 컬럼 변경
             * - 편의시설 / 편의시설 자원 탭 전환 시 호출
             */
            changeView: function (viewType) {
                state.viewType = viewType || "PUBLIC_FACILITY";
                setGridColumnDefs(api, getColumnDefs(state.viewType, option));
                setGridRowData(api, []);
                fitColumns(api);
            },

            /**
             * CSV 다운로드
             * - 엑셀 다운로드 버튼에서 호출
             */
            exportCsv: function (fileName) {
                if (api && typeof api.exportDataAsCsv === "function") {
                    api.exportDataAsCsv({ fileName: fileName || "편의시설공용_목록.csv" });
                }
            },

            /**
             * 현재 페이지 번호 조회
             * - 목록 상태 복원용
             */
            getCurrentPage: function () {
                if (api && typeof api.paginationGetCurrentPage === "function") {
                    return api.paginationGetCurrentPage();
                }

                return 0;
            },

            /**
             * 페이지 이동
             * - 목록 상태 복원용
             */
            goToPage: function (pageNo) {
                if (api && typeof api.paginationGoToPage === "function") {
                    api.paginationGoToPage(Number(pageNo || 0));
                }
            }
        };
    }

    window.PublicFacilityAgGrid = {
        create: create
    };
})(window);