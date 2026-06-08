/**
 * publicFacilityItemModal.js
 * 편의시설 자원 모달 공용 JS
 *
 * 모드:
 *   insert - 자원 등록 (여러 행 추가 가능)
 *   detail - 자원 상세 (읽기전용 + 시설정보 + 형제 자원 목록)
 *   update - 자원 수정 (detail과 같은 모달, 자원명/상태만 편집)
 *
 * 공개 API:
 *   PublicFacilityItemModal.init(config)
 *   PublicFacilityItemModal.open(mode, itemNo)
 *   PublicFacilityItemModal.close()
 *   PublicFacilityItemModal.save()
 *   PublicFacilityItemModal.confirmDelete()
 */
(function () {

    /* ============================================================
       내부 상태
    ============================================================ */
    var _cfg          = {};    /* contextPath, mgmtOfcNo, cmnFacilityNo, facilityNo, isAdmin */
    var _mode         = null;  /* insert | detail | update */
    var _itemNo       = null;  /* 현재 선택된 자원번호 */
    var _facilityNo   = null;  /* 선택된 편의시설번호 */
    var _suggestTimer = null;  /* 자동완성 지연 타이머 */
    var _bound        = false; /* 정적 이벤트 중복 바인딩 방지 */

    /* ============================================================
       초기화
    ============================================================ */
    function init(config) {
        _cfg = config || {};

        /* 현재 모달에서 사용할 편의시설번호 */
        _facilityNo = _cfg.cmnFacilityNo || null;

        /* 정적 이벤트는 최초 1회만 바인딩 */
        if (!_bound) {
            _bindStaticEvents();
            _bound = true;
        }
    }

    /* ============================================================
       CSRF
    ============================================================ */
    function _csrf() {
        var tokenMeta  = document.querySelector('meta[name="_csrf"]');
        var headerMeta = document.querySelector('meta[name="_csrf_header"]');
        var headers = { "Content-Type": "application/json" };

        /* Spring Security CSRF 헤더 추가 */
        if (tokenMeta && headerMeta) {
            headers[headerMeta.content] = tokenMeta.content;
        }

        return headers;
    }

    /* ============================================================
       fetch JSON
    ============================================================ */
    async function _fetch(url, opts) {
        var res = await fetch(url, opts);

        /* HTTP 오류 처리 */
        if (!res.ok) {
            throw new Error("서버 오류: " + res.status);
        }

        return res.json();
    }

    /* ============================================================
       DOM 헬퍼
    ============================================================ */
    function _el(id) {
        return document.getElementById(id);
    }

    function _show(id) {
        var e = _el(id);
        if (e) e.style.display = "";
    }

    function _hide(id) {
        var e = _el(id);
        if (e) e.style.display = "none";
    }

    function _val(id) {
        var e = _el(id);
        return e ? e.value : "";
    }

    function _setVal(id, value) {
        var e = _el(id);
        if (e) e.value = value;
    }

    function _text(id, value) {
        var e = _el(id);
        if (e) e.textContent = value;
    }

    async function _alert(msg, icon) {
        if (typeof showAlert === "function") {
            await showAlert(msg, icon);
        } else {
            alert(msg);
        }
    }

    /* ============================================================
       상태 배지
    ============================================================ */
    function _badge(cd) {
        var map = {
            OPEN:   ["stts-open",   "사용가능"],
            USE:    ["stts-use",    "사용중"],
            REPAIR: ["stts-repair", "점검중"],
            CLOSE:  ["stts-close",  "사용중지"]
        };

        var status = map[cd];

        /* 알 수 없는 상태 코드 표시 */
        if (!status) {
            return '<span class="stts-badge">' + (cd || "-") + '</span>';
        }

        return '<span class="stts-badge ' + status[0] + '">' + status[1] + '</span>';
    }

    /* ============================================================
       모달 열기
    ============================================================ */
    function open(mode, itemNo) {
        _mode   = mode;
        _itemNo = itemNo || null;

        /* 이전 모달 상태 초기화 */
        _resetSections();

        /* 모드별 제목 설정 */
        _setTitle(mode);

        if (mode === "insert") {
            _openInsert();
        } else {
            _loadDetail(itemNo, mode);
        }
    }

    /* ============================================================
       모달 닫기
    ============================================================ */
    function close() {
        var modal = _el("pfItemModal");

        if (modal) {
            modal.classList.remove("is-open");
        }

        _mode = null;
        _itemNo = null;
    }

    /* ============================================================
       모달 표시
    ============================================================ */
    function _showModal() {
        var modal = _el("pfItemModal");

        if (modal) {
            modal.classList.add("is-open");
        }
    }

    /* ============================================================
       섹션 전체 숨기기 및 초기화
    ============================================================ */
    function _resetSections() {
        [
            "pfFacilitySearchSection",
            "pfFacilityInfoSection",
            "pfItemInfoSection",
            "pfItemInsertSection",
            "pfSiblingSection"
        ].forEach(_hide);

        var footer = _el("pfModalFooter");
        var rows   = _el("pfItemRows");
        var sib    = _el("pfSiblingList");
        var box    = _el("pfFacilitySuggestBox");
        var inp    = _el("pfFacilitySearchInput");

        /* 동적 영역 초기화 */
        if (footer) footer.innerHTML = "";
        if (rows)   rows.innerHTML   = "";
        if (sib)    sib.innerHTML    = "";

        /* 자동완성 영역 초기화 */
        if (box) {
            box.classList.remove("is-open");
            box.innerHTML = "";
        }

        if (inp) {
            inp.value = "";
        }
    }

    /* ============================================================
       타이틀
    ============================================================ */
    function _setTitle(mode) {
        var map = {
            insert: "편의시설 자원 등록",
            detail: "편의시설 자원 상세",
            update: "편의시설 자원 수정"
        };

        _text("pfModalTitle", map[mode] || "편의시설 자원");
    }

    /* ============================================================
       등록 모드 열기
    ============================================================ */
    function _openInsert() {
        /* 기본 자원 입력 행 1개 생성 */
        _addItemRow();

        /* 등록 모드 푸터 구성 */
        _setFooter("insert");

        if (_facilityNo) {
            /*
             * 편의시설이 이미 정해진 경우
             * - update/detail 화면에서 현재 편의시설 자원 등록
             */
            _loadFacilityDetail(_facilityNo, function (facility) {
                _fillFacilityInfo(facility, _facilityNo);
                _show("pfFacilityInfoSection");
                _show("pfItemInsertSection");
                _loadSiblingsForInsert(_facilityNo);
                _showModal();
            });
        } else {
            /*
             * 편의시설 미정인 경우
             * - list 화면의 자원 등록 버튼에서 검색 후 선택
             */
            _show("pfFacilitySearchSection");
            _show("pfItemInsertSection");
            _showModal();
        }
    }

    /* ============================================================
       상세/수정 데이터 로드
    ============================================================ */
    function _loadDetail(itemNo, mode) {
        var url = _cfg.contextPath
            + "/manager/publicFacility/item/detail/"
            + encodeURIComponent(_cfg.mgmtOfcNo) + "/"
            + encodeURIComponent(itemNo);

        _fetch(url)
            .then(function (data) {
                if (!data.success) {
                    _alert("자원 정보를 불러오지 못했습니다.");
                    return;
                }

                var item     = data.item        || {};
                var facility = data.facility    || {};
                var siblings = data.siblingList || [];

                /* 편의시설 정보 표시 */
                _fillFacilityInfo(facility, item.cmnFacilityNo);
                _show("pfFacilityInfoSection");

                /* 자원 정보 세팅 */
                _setVal("pfItemNo",        item.cmnFacilityItemNo || "");
                _setVal("pfItemNoDisplay", item.cmnFacilityItemNo || "");
                _setVal("pfItemNm",        item.itemNm            || "");
                _setVal("pfItemStts",      item.cmnFacilitySttsCd || "OPEN");

                _show("pfItemInfoSection");
                _setEditable(mode === "update");

                /* 같은 시설 자원 목록 */
                _renderSiblings(siblings, item.cmnFacilityItemNo);
                if (siblings.length > 0) {
                    _show("pfSiblingSection");
                }

                _setFooter(mode);
                _showModal();
            })
            .catch(function (err) {
                console.error(err);
                _alert("자원 정보 조회 중 오류가 발생했습니다.");
            });
    }

    /* ============================================================
       편의시설 정보 채우기
       - facilityNo가 조회 결과에 없으면 기존 화면값 또는 init config 값을 유지
    ============================================================ */
    function _fillFacilityInfo(facility, cmnFacilityNo) {
        var facilityNoEl = _el("pfInfoFacilityNo");
        var cmnNmEl      = _el("pfInfoCmnFacilityNm");

        /* 현재 화면에 이미 표시된 시설번호 */
        var currentFacilityNo = facilityNoEl
            ? (facilityNoEl.textContent || "").trim()
            : "";

        /* init(config)에서 넘겨받은 시설번호 */
        var configFacilityNo = (_cfg.facilityNo && _cfg.facilityNo !== "-")
            ? _cfg.facilityNo
            : "";

        /* 조회 결과 시설번호 */
        var fetchedFacilityNo = (facility && facility.facilityNo && facility.facilityNo !== "-")
            ? facility.facilityNo
            : "";

        /*
         * 시설번호 우선순위
         * 1. 조회 결과 facilityNo
         * 2. init config facilityNo
         * 3. 기존 화면에 표시된 facilityNo
         * 4. 화면 표시용 "-"
         */
        var facilityNo = fetchedFacilityNo
            || configFacilityNo
            || (currentFacilityNo && currentFacilityNo !== "-" ? currentFacilityNo : "")
            || "-";

        /* 현재 화면에 이미 표시된 편의시설명 */
        var currentCmnFacilityNm = cmnNmEl
            ? (cmnNmEl.textContent || "").trim()
            : "";

        /*
         * 편의시설명
         * - 조회 결과가 없으면 기존 화면값 유지
         */
        var cmnFacilityNm = (facility && facility.cmnFacilityNm)
            ? facility.cmnFacilityNm
            : (currentCmnFacilityNm && currentCmnFacilityNm !== "-" ? currentCmnFacilityNm : "-");

        /* 모달 상단 정보 표시 */
        _text("pfInfoFacilityNo", facilityNo);
        _text("pfInfoCmnFacilityNo", cmnFacilityNo || _cfg.cmnFacilityNo || "-");
        _text("pfInfoCmnFacilityNm", cmnFacilityNm);
    }

    /* ============================================================
       편집 가능 여부
    ============================================================ */
    function _setEditable(editable) {
        var nm   = _el("pfItemNm");
        var stts = _el("pfItemStts");

        if (nm) {
            nm.readOnly = !editable;
        }

        if (stts) {
            stts.disabled = !editable;
        }
    }

    /* ============================================================
       형제 자원 목록 렌더링
    ============================================================ */
    function _renderSiblings(list, currentItemNo) {
        var wrap = _el("pfSiblingList");

        if (!wrap) return;

        if (!list || list.length === 0) {
            wrap.innerHTML = '<div style="padding:12px;font-size:12px;color:#8a9a8e;text-align:center;">등록된 자원이 없습니다.</div>';
            return;
        }

        wrap.innerHTML = list.map(function (item) {
            var isCurrent = item.cmnFacilityItemNo === currentItemNo;

            return '<div class="pf-sibling-row' + (isCurrent ? " is-current" : "") + '">'
                + '<span class="pf-sibling-no">'   + (item.cmnFacilityItemNo || "") + '</span>'
                + '<span class="pf-sibling-nm">'   + (item.itemNm || "-")           + '</span>'
                + '<span class="pf-sibling-stts">' + _badge(item.cmnFacilitySttsCd) + '</span>'
                + '</div>';
        }).join("");
    }

    /* ============================================================
       편의시설 상세 조회
       - 모달 상단 편의시설 정보 보완용
    ============================================================ */
    function _loadFacilityDetail(cmnFacilityNo, callback) {
        /*
         * 모달용 상위 편의시설 정보 조회
         * - PUBLIC_FACILITY 타입은 자원 탭 필터 자동완성과 분리하기 위한 값
         * - 선택한 CMN 번호 기준으로 편의시설명/시설번호를 다시 조회
         */
        var url = _cfg.contextPath
            + "/manager/publicFacility/item/suggest/"
            + encodeURIComponent(_cfg.mgmtOfcNo)
            + "?suggestType=PUBLIC_FACILITY&keyword="
            + encodeURIComponent(cmnFacilityNo.replace(/^CMN/, ""));

        _fetch(url)
            .then(function (data) {
                var list = data.list || [];

                var found = list.find(function (row) {
                    return row.cmnFacilityNo === cmnFacilityNo;
                });

                if (callback) {
                    callback(found ? {
                        /* 편의시설명 */
                        cmnFacilityNm: found.cmnFacilityNm,

                        /*
                         * 시설번호
                         * - 모르는 값을 "-"로 넘기지 않음
                         * - "-"는 _fillFacilityInfo()에서 최종 표시용으로만 처리
                         */
                        facilityNo: found.facilityNo || ""
                    } : {});
                }
            })
            .catch(function () {
                if (callback) {
                    callback({});
                }
            });
    }

    /* ============================================================
       등록 모드 형제 자원 로드
    ============================================================ */
    function _loadSiblingsForInsert(cmnFacilityNo) {
        var url = _cfg.contextPath
            + "/manager/publicFacility/item/paging/"
            + encodeURIComponent(_cfg.mgmtOfcNo)
            + "?facilityNo=" + encodeURIComponent(cmnFacilityNo.replace(/^CMN/, ""))
            + "&pageSize=50&page=1";

        _fetch(url)
            .then(function (data) {
                var list = data.list || [];

                _renderSiblings(list, null);
                _show("pfSiblingSection");
            })
            .catch(function () {
                _show("pfSiblingSection");
            });
    }

    /* ============================================================
       자원 등록 행 추가
    ============================================================ */
    function _addItemRow() {
        var rows = _el("pfItemRows");

        if (!rows) return;

        var idx = rows.children.length;
        var div = document.createElement("div");

        div.className = "pf-field-row";

        div.innerHTML =
            '<div class="pf-field">'
            + (idx === 0 ? '<label>자원명 <span class="req">*</span></label>' : '<label>&nbsp;</label>')
            + '<input type="text" class="pf-input pf-row-nm" placeholder="예) 러닝머신 ' + (idx + 1) + '번">'
            + '</div>'
            + '<div class="pf-field">'
            + (idx === 0 ? '<label>상태</label>' : '<label>&nbsp;</label>')
            + '<select class="pf-select pf-row-stts">'
            + '<option value="OPEN">사용가능</option>'
            + '<option value="USE">사용중</option>'
            + '<option value="REPAIR">점검중</option>'
            + '<option value="CLOSE">사용중지</option>'
            + '</select>'
            + '</div>'
            + '<button type="button" class="pf-del-btn pf-row-del" title="행 삭제">'
            + '<span class="material-symbols-rounded">remove</span>'
            + '</button>';

        /* 행 삭제 버튼 */
        div.querySelector(".pf-row-del").addEventListener("click", function () {
            if (rows.children.length <= 1) {
                return;
            }

            div.remove();
        });

        rows.appendChild(div);
    }

    /* ============================================================
       푸터 버튼
    ============================================================ */
    function _setFooter(mode) {
        var footer = _el("pfModalFooter");

        if (!footer) return;

        var html = '<button type="button" class="pf-btn" id="pfCloseBtnFooter">닫기</button>';

        /* 상세 모드 수정 버튼 */
        if (mode === "detail" && !_cfg.isAdmin) {
            html += '<button type="button" class="pf-btn pf-btn-primary" id="pfToUpdateBtn">수정</button>';
        }

        /* 수정 모드 저장 버튼 */
        if (mode === "update" && !_cfg.isAdmin) {
            html += '<button type="button" class="pf-btn pf-btn-save" id="pfSaveBtn">저장</button>';
        }

        /* 등록 모드 저장 버튼 */
        if (mode === "insert" && !_cfg.isAdmin) {
            html += '<button type="button" class="pf-btn pf-btn-save" id="pfSaveBtn">저장</button>';
        }

        footer.innerHTML = html;

        var closeBtn = _el("pfCloseBtnFooter");
        var updateBtn = _el("pfToUpdateBtn");
        var saveBtn = _el("pfSaveBtn");

        if (closeBtn) {
            closeBtn.addEventListener("click", close);
        }

        if (updateBtn) {
            updateBtn.addEventListener("click", _switchToUpdate);
        }

        if (saveBtn) {
            saveBtn.addEventListener("click", save);
        }
    }

    /* ============================================================
       상세 → 수정 전환
    ============================================================ */
    function _switchToUpdate() {
        _mode = "update";

        _setTitle("update");
        _setEditable(true);
        _setFooter("update");
    }

    /* ============================================================
       저장
    ============================================================ */
    function save() {
        if (_mode === "insert") {
            _saveInsert();
            return;
        }

        if (_mode === "update") {
            _saveUpdate();
        }
    }

    /* ============================================================
       등록 저장
    ============================================================ */
    async function _saveInsert() {
        if (!_facilityNo) {
            _alert("편의시설을 먼저 선택하세요.");
            return;
        }

        var rows = _el("pfItemRows");
        var items = [];

        /* 입력된 자원 행 수집 */
        Array.from(rows.querySelectorAll(".pf-field-row")).forEach(function (row) {
            var nmInput = row.querySelector(".pf-row-nm");
            var sttsInput = row.querySelector(".pf-row-stts");

            var nm = nmInput ? nmInput.value.trim() : "";
            var stts = sttsInput ? sttsInput.value : "OPEN";

            if (nm) {
                items.push({
                    cmnFacilityNo: _facilityNo,
                    itemNm: nm,
                    cmnFacilitySttsCd: stts
                });
            }
        });

        if (items.length === 0) {
            _alert("자원명을 입력하세요.");
            return;
        }

        try {
            for (var i = 0; i < items.length; i++) {
                await _fetch(
                    _cfg.contextPath + "/manager/publicFacility/item/insert/" + encodeURIComponent(_cfg.mgmtOfcNo),
                    {
                        method: "POST",
                        headers: _csrf(),
                        body: JSON.stringify(items[i])
                    }
                );
            }

            await _alert(items.length + "개 자원이 등록되었습니다.", "success");
            close();
            _refresh();
        } catch (e) {
            console.error(e);
            await _alert("등록 중 오류가 발생했습니다.", "error");
        }
    }

    /* ============================================================
       수정 저장
    ============================================================ */
    async function _saveUpdate() {
        var itemNm = _val("pfItemNm").trim();

        if (!itemNm) {
            _alert("자원명을 입력하세요.");
            return;
        }

        var payload = {
            cmnFacilityItemNo: _val("pfItemNo"),
            cmnFacilityNo: _facilityNo || _cfg.cmnFacilityNo || "",
            itemNm: itemNm,
            cmnFacilitySttsCd: _val("pfItemStts")
        };

        try {
            var data = await _fetch(
                _cfg.contextPath + "/manager/publicFacility/item/update/" + encodeURIComponent(_cfg.mgmtOfcNo),
                {
                    method: "POST",
                    headers: _csrf(),
                    body: JSON.stringify(payload)
                }
            );

            if (data.success) {
                await _alert(data.message || "수정되었습니다.", "success");
                close();
                _refresh();
            } else {
                await _alert(data.message || "수정에 실패했습니다.", "error");
            }
        } catch (e) {
            console.error(e);
            await _alert("수정 중 오류가 발생했습니다.", "error");
        }
    }

    /* ============================================================
       삭제
    ============================================================ */
    async function confirmDelete() {
        var deleteConfirm = await showConfirm({
            title: "이 자원을 삭제하시겠습니까?",
            confirmText: "삭제",
            confirmColor: "#c0392b"
        });
        if (!deleteConfirm.isConfirmed) {
            return;
        }

        try {
            var data = await _fetch(
                _cfg.contextPath + "/manager/publicFacility/item/delete/" + encodeURIComponent(_cfg.mgmtOfcNo),
                {
                    method: "POST",
                    headers: _csrf(),
                    body: JSON.stringify({ cmnFacilityItemNo: _itemNo })
                }
            );

            if (data.success) {
                await _alert(data.message || "삭제되었습니다.", "success");
                close();
                _refresh();
            } else {
                await _alert(data.message || "삭제에 실패했습니다.", "error");
            }
        } catch (e) {
            console.error(e);
            await _alert("삭제 중 오류가 발생했습니다.", "error");
        }
    }

    /* ============================================================
       저장/삭제 후 목록 갱신
    ============================================================ */
    function _refresh() {
        var tbody = document.getElementById("dtlItemBody");
        var facilityNo = _facilityNo || _cfg.cmnFacilityNo || "";

        if (tbody && facilityNo) {
            /*
             * detail.jsp 인라인 테이블 갱신
             * - 기존 구조 유지
             */
            var url = _cfg.contextPath
                + "/manager/publicFacility/item/paging/"
                + encodeURIComponent(_cfg.mgmtOfcNo)
                + "?facilityNo=" + encodeURIComponent(facilityNo.replace(/^CMN/, ""))
                + "&pageSize=50&page=1";

            fetch(url)
                .then(function (res) {
                    return res.json();
                })
                .then(function (data) {
                    _renderDetailTable(data.list || []);
                })
                .catch(function () {
                    location.reload();
                });
        } else {
            /*
             * 목록 화면 모달 저장 후 새로고침 표시
             * - 목록 JSP의 canRestoreListState()에서 이 값을 보고 기존 탭/필터를 복원함
             * - 실제 탭/필터 값은 목록 화면의 saveListState()가 이미 STORAGE_KEY에 저장함
             */
            sessionStorage.setItem("publicFacilityModalRefresh", "Y");

            location.reload();
        }
    }

    /* ============================================================
       detail.jsp 자원 테이블 갱신
    ============================================================ */
    function _renderDetailTable(list) {
        var tbody = document.getElementById("dtlItemBody");

        if (!tbody) return;

        if (!list.length) {
            tbody.innerHTML = '<tr id="emptyRow"><td class="item-empty" colspan="4">등록된 자원이 없습니다.</td></tr>';
            return;
        }

        tbody.innerHTML = list.map(function (item) {
            return '<tr data-item-no="' + (item.cmnFacilityItemNo || "") + '"'
                + ' data-item-nm="' + (item.itemNm || "").replace(/"/g, "&quot;") + '"'
                + ' data-stts="' + (item.cmnFacilitySttsCd || "") + '">'
                + '<td style="text-align:center;font-size:12px;">' + (item.cmnFacilityItemNo || "") + '</td>'
                + '<td style="padding-left:10px;">' + (item.itemNm || "-") + '</td>'
                + '<td style="text-align:center;">' + _badge(item.cmnFacilitySttsCd) + '</td>'
                + '<td><div style="display:flex;gap:4px;justify-content:center;">'
                + '<button type="button" class="row-btn" data-action="edit">수정</button>'
                + '<button type="button" class="row-btn row-btn-danger" data-action="delete">삭제</button>'
                + '</div></td>'
                + '</tr>';
        }).join("");
    }

    /* ============================================================
       정적 이벤트 바인딩
    ============================================================ */
    function _bindStaticEvents() {
        var modal = _el("pfItemModal");

        /* 모달 외부 클릭 닫기 */
        if (modal) {
            modal.addEventListener("click", function (e) {
                if (e.target === modal) {
                    close();
                }
            });
        }

        /* X 버튼 닫기 */
        var xBtn = _el("pfModalCloseBtn");
        if (xBtn) {
            xBtn.addEventListener("click", close);
        }

        /* 자원 추가 버튼 */
        var addBtn = _el("pfAddRowBtn");
        if (addBtn) {
            addBtn.addEventListener("click", _addItemRow);
        }

        /* 편의시설번호 자동완성 */
        var inp = _el("pfFacilitySearchInput");
        var box = _el("pfFacilitySuggestBox");

        if (inp && box) {
            inp.addEventListener("input", function () {
                var keyword = this.value.trim();

                clearTimeout(_suggestTimer);

                if (!keyword) {
                    box.classList.remove("is-open");
                    box.innerHTML = "";
                    return;
                }

                _suggestTimer = setTimeout(function () {
                    fetch(
                        _cfg.contextPath
                        + "/manager/publicFacility/item/suggest/"
                        + encodeURIComponent(_cfg.mgmtOfcNo)
                        + "?suggestType=PUBLIC_FACILITY&keyword="
                        + encodeURIComponent(keyword)
                    )
                        .then(function (res) {
                            return res.json();
                        })
                        .then(function (data) {
                            _renderFacilitySuggest(data.list || []);
                        })
                        .catch(function () {});
                }, 200);
            });

            /* 자동완성 외부 클릭 닫기 */
            document.addEventListener("click", function (e) {
                if (!inp.contains(e.target) && !box.contains(e.target)) {
                    box.classList.remove("is-open");
                }
            });
        }
    }

    /* ============================================================
       편의시설 자동완성 렌더링
       - 리스트 화면에서 편의시설 검색 선택 시 시설번호도 함께 보존
    ============================================================ */
    function _renderFacilitySuggest(list) {
        var box = _el("pfFacilitySuggestBox");

        if (!box) return;

        if (!list.length) {
            box.innerHTML = '<div class="pf-suggest-empty">검색 결과가 없습니다.</div>';
            box.classList.add("is-open");
            return;
        }

        box.innerHTML = list.map(function (item) {
            return '<div class="pf-suggest-item"'
                + ' data-no="' + (item.cmnFacilityNo || "") + '"'
                + ' data-facility-no="' + (item.facilityNo || "") + '"'
                + ' data-cmn-facility-nm="' + (item.cmnFacilityNm || "") + '">'
                + '<span class="pf-suggest-main">' + (item.cmnFacilityNo || "") + '</span>'
                + '<span class="pf-suggest-sub">' + (item.cmnFacilityNm || "") + '</span>'
                + '</div>';
        }).join("");

        box.classList.add("is-open");

        box.querySelectorAll(".pf-suggest-item").forEach(function (item) {
            item.addEventListener("click", function () {
                /* 선택한 편의시설번호 */
                var no = item.getAttribute("data-no") || "";

                /* 선택한 편의시설의 시설번호 */
                var facilityNo = item.getAttribute("data-facility-no") || "";

                /* 선택한 편의시설명 */
                var cmnFacilityNm = item.getAttribute("data-cmn-facility-nm") || "";

                /* 검색창에는 CMN 접두어를 뺀 값 표시 */
                _el("pfFacilitySearchInput").value = no.replace(/^CMN/, "");

                /* 자동완성 닫기 */
                box.classList.remove("is-open");

                /* 현재 모달의 편의시설번호 저장 */
                _facilityNo = no;

                /*
                 * 검색 결과 row가 가진 값을 먼저 표시
                 * - suggest 응답에 facilityNo가 있으면 여기서 바로 표시됨
                 */
                _fillFacilityInfo({
                    facilityNo: facilityNo,
                    cmnFacilityNm: cmnFacilityNm
                }, no);

                _show("pfFacilityInfoSection");

                /*
                 * 추가 조회 결과로 보완
                 * - 빈 facilityNo는 기존 값을 덮지 않도록 _fillFacilityInfo()에서 방어
                 */
                _loadFacilityDetail(no, function (facility) {
                    _fillFacilityInfo(facility, no);
                    _loadSiblingsForInsert(no);
                });
            });
        });
    }

    /* ============================================================
       공개 API
    ============================================================ */
    window.PublicFacilityItemModal = {
        init: init,
        open: open,
        close: close,
        save: save,
        confirmDelete: confirmDelete
    };

})();