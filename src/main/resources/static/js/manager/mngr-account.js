/**
 * ============================================================
 * mngr-account.js
 * 吏곸썝 怨꾩젙 愿由??붾㈃ ?숈옉 ?ㅽ겕由쏀듃
 * ============================================================
 */

// HTML 臾몄꽌媛 ?꾩쟾??濡쒕뱶?섏뿀?????ㅽ뻾
document.addEventListener("DOMContentLoaded", function () {
    // ?섏씠吏 珥덇린???⑥닔 ?몄텧
    initMngrAccountPage();
});

/**
 * ?섏씠吏??紐⑤뱺 湲곕뒫??珥덇린?뷀븯怨??대깽?몃? 諛붿씤?⑺븯??硫붿씤 ?⑥닔
 */
function initMngrAccountPage() {

    /* [1] ?붾㈃ ?좏슚??寃??諛?湲곕낯 ?ㅼ젙 */

    // ?꾩옱 ?섏씠吏??'mngrAccountPage'?쇰뒗 ID瑜?媛吏??붿냼媛 ?덈뒗吏 ?뺤씤
    var page = document.getElementById("mngrAccountPage");
    // ?대떦 ?붿냼媛 ?놁쑝硫????ㅽ겕由쏀듃媛 ?ㅽ뻾???섏씠吏媛 ?꾨땲誘濡?利됱떆 醫낅즺
    if (!page) return;

    // JSP ?쒕쾭?먯꽌 ?꾨떖???ㅼ젙 媛앹껜(window.mngrAccountConfig)瑜?媛?몄샂 (?놁쑝硫?鍮?媛앹껜)
    var config = window.mngrAccountConfig || {};

    // ?꾨줈?앺듃??湲곕낯 寃쎈줈 (API ?몄텧 ???ъ슜)
    var contextPath = config.contextPath || "";
    // ?꾩옱 愿由?以묒씤 ?щТ??踰덊샇
    var mgmtOfcNo   = config.mgmtOfcNo || "";
    // 愿由ъ궗臾댁냼 紐낆묶 (紐⑤떖 ?쒖떆??
    var mgmtOfcNm   = config.mgmtOfcNm || "";
    // ?꾪뙆???⑥? 紐낆묶 (紐⑤떖 ?쒖떆??
    var aptCmplexNm = config.aptCmplexNm || "";
    // ?꾩옱 濡쒓렇?명븳 愿由ъ옄???대쫫
    var loginUserNm = config.loginUserNm || "";
    // 愿由ъ옄 ?щ? ?뺤씤 (true??寃쎌슦 ?곌린 沅뚰븳 ?쒗븳 ?깆뿉 ?ъ슜)
    var isAdmin     = config.isAdmin === true;

    /* [2] ?곗씠??諛?洹몃━???붿냼 ?뺤쓽 */

    // '?ъ쭅 吏곸썝' 洹몃━?쒖뿉 ?쒖떆???곗씠??諛곗뿴
    var managerRowData = [];
    // '怨꾩젙 ?앹꽦 ?붿껌' 洹몃━?쒖뿉 ?쒖떆???곗씠??諛곗뿴
    var requestRowData = [];

    // '?ъ쭅 吏곸썝' AG Grid媛 洹몃젮吏?HTML ?섎━癒쇳듃
    var managerGridEl = document.getElementById("managerGrid");
    // '怨꾩젙 ?앹꽦 ?붿껌' AG Grid媛 洹몃젮吏?HTML ?섎━癒쇳듃
    var requestGridEl = document.getElementById("requestGrid");

    // ?뺤씤(Confirm) 紐⑤떖?먯꽌 '?뱀씤' 踰꾪듉???뚮??????ㅽ뻾???⑥닔瑜??꾩떆 ??ν븯??蹂??
    var confirmCallback = null;

    /* [3] ?붾㈃ 珥덇린 ?띿뒪???명똿 */

    // ?붿껌 ?쇱쓽 ?④꺼吏??꾨뱶???щТ??踰덊샇 ?명똿
    setField("rqstMgmtOfcNoHidden", mgmtOfcNo);
    // ?붾㈃?곸뿉 ?щТ??紐낆묶 ?쒖떆 (紐낆묶 ?놁쑝硫?踰덊샇 ?쒖떆)
    setField("requestMgmtOfcNoText", mgmtOfcNm || mgmtOfcNo);
    // ?붾㈃?곸뿉 ?⑥?紐??쒖떆
    setField("requestAptCmplexNmText", aptCmplexNm);
    // ?깅줉????ぉ??濡쒓렇???ъ슜?먮챸 ?쒖떆
    setField("requestLoginUserNmText", loginUserNm);

    /* [4] ?좏떥由ы떚 ?대? ?⑥닔 (helper functions) */

    // null ?먮뒗 undefined 媛믪쓣 鍮?臾몄옄?대줈 蹂??
    function safe(value) {
        return emptyIfNull(value);
    }

    // HTML 臾몄옄??議고빀 ???뱀닔臾몄옄濡??명븳 ?쒓렇 源⑥쭚??諛⑹?
    function escapeHtml(value) {
        return String(value == null ? "" : value)
            .replace(/&/g, "&amp;")
            .replace(/</g, "&lt;")
            .replace(/>/g, "&gt;")
            .replace(/"/g, "&quot;")
            .replace(/'/g, "&#39;");
    }

    function mngrAlert(message, icon) {
        if (window.Swal && typeof window.Swal.fire === "function") {
            return window.Swal.fire({
                icon: icon || "info",
                title: message,
                confirmButtonColor: "#2e5c38"
            });
        }

        if (typeof showAlert === "function") {
            showAlert(message);
        } else if (typeof showAlert === "function") {
            showAlert(message);
        } else {
            window.alert(message);
        }

        return Promise.resolve();
    }

    // ?붿껌 ?곹깭 肄붾뱶瑜??臾몄옄濡??듭씪
    function normalizeStatus(code) {
        return MngrAccountGrid.normalizeStatus(code);
    }

    // 吏곷Т 肄붾뱶瑜??쒓?紐낆쑝濡?蹂??
    function dutyText(code) {
        return MngrAccountGrid.dutyText(code);
    }

    // ?붿껌 ?곹깭 肄붾뱶瑜??쒓?紐낆쑝濡?蹂??
    function sttsText(code) {
        return MngrAccountGrid.sttsText(code);
    }

    // ?좎쭨 媛믪쓣 yy.MM.dd ?뺥깭濡?蹂??
    function formatDate(value) {
        if (!value) return "-";
        var str = String(value);
        if (str.length >= 10 && str.indexOf("-") > -1) {
            return str.slice(2, 10).replace(/-/g, ".");
        }
        if (str.length >= 10 && str.indexOf(".") > -1) {
            return str.slice(2, 10);
        }
        return str;
    }

    // 吏?뺥븳 id瑜?媛吏?input ?붿냼??媛믪쓣 媛?몄? ?묐걹 怨듬갚 ?쒓굅
    function getField(id) {
        var el = document.getElementById(id);
        return el ? el.value.trim() : "";
    }

    // 吏?뺥븳 ID瑜?媛吏??붿냼???덉쟾?섍쾶 媛믪쓣 ?낅젰
    function setField(id, value) {
        var el = document.getElementById(id);
        if (el) el.value = safe(value);
    }

    // 吏?뺥븳 ID瑜?媛吏??붿냼???띿뒪?몃? ?덉쟾?섍쾶 蹂寃?
    function setText(id, value) {
        var el = document.getElementById(id);
        if (el) el.textContent = safe(value);
    }

    // ?꾩옱 ?섏씠吏瑜??덈줈怨좎묠?섏뿬 理쒖떊 ?곹깭 諛섏쁺
    function reloadCurrentPage(tab) {
        var url = contextPath + "/manager/employee/account/" + mgmtOfcNo;
        // 愿由ъ궗臾댁냼 踰덊샇??寃쎈줈??洹몃?濡??먭퀬, ?붿껌 泥섎━ ?꾩뿉留????곹깭瑜?荑쇰━?ㅽ듃留곸쑝濡??좎??쒕떎.
        if (tab) url += "?tab=" + encodeURIComponent(tab);
        location.href = url;
    }

    // ADMIN 怨꾩젙??寃쎌슦 ?섏젙??留됯린 ?꾪븳 泥댄겕 ?⑥닔
    function blockAdminWrite() {
        return isAdmin;
    }

    // 媛?紐⑸줉 ?ㅻ뜑??嫄댁닔 ?쒖떆瑜??곗씠??湲곗??쇰줈 媛깆떊
    function updateStats() {
        var managerTotal = managerRowData.length;
        var managerActive = managerRowData.filter(function (row) {
            return row.userYn === "Y";
        }).length;
        var managerInactive = managerRowData.filter(function (row) {
            return row.userYn === "N";
        }).length;

        var requestTotal = requestRowData.length;
        var requestWait = requestRowData.filter(function (row) {
            return normalizeStatus(row.rqstSttsCd) === "WAIT";
        }).length;
        var requestOk = requestRowData.filter(function (row) {
            return normalizeStatus(row.rqstSttsCd) === "OK";
        }).length;
        var requestReject = requestRowData.filter(function (row) {
            return normalizeStatus(row.rqstSttsCd) === "RJCT";
        }).length;
        var requestCancel = requestRowData.filter(function (row) {
            return normalizeStatus(row.rqstSttsCd) === "CNL";
        }).length;

        setText("managerTotalCount", managerTotal + "건");
        setText("managerStatusCount", "활성 " + managerActive + " / 비활성 " + managerInactive);
        setText("managerChipTotal", managerTotal);
        setText("managerChipActive", managerActive);
        setText("managerChipInactive", managerInactive);
        setText("requestTotalCount", requestTotal + "건");
        setText(
            "requestStatusCount",
            "대기 " + requestWait + " / 승인 " + requestOk + " / 반려 " + requestReject + " / 취소 " + requestCancel
        );
        setText("requestChipTotal", requestTotal);
        setText("requestChipWait", requestWait);
        setText("requestChipOk", requestOk);
        setText("requestChipReject", requestReject);
        setText("requestChipCancel", requestCancel);
    }

    /* [5] ?곗씠??濡쒕뱶 諛?洹몃━???앹꽦 ?⑥닔 */

    // ?쒕쾭?먯꽌 ?ъ쭅 吏곸썝 紐⑸줉??媛?몄샂
    function loadEmployeeList() {
        // 寃?됱뼱? 吏곷Т ?꾪꽣 媛?媛?몄삤湲?
        var keyword = getField("managerKeyword");
        var duty = getField("managerDutyFilter");

        // API URL 議곕┰ (?몄퐫??泥섎━ ?ы븿)
        var url = contextPath + "/manager/employee/list/" + mgmtOfcNo
            + "?keyword=" + encodeURIComponent(keyword)
            + "&mngrDutyCd=" + encodeURIComponent(duty);

        // 鍮꾨룞湲?GET ?붿껌 ?ㅽ뻾
        getJson(url).then(function (data) {
            // 諛쏆븘??由ъ뒪?????(?놁쑝硫?鍮?諛곗뿴)
            managerRowData = data.list || [];
            // 洹몃━???곸뿭???곗씠???꾨떖 諛??뚮뜑留?
            MngrAccountGrid.setRows(managerGridEl, managerRowData);
            // ?곷떒 ?듦퀎 ?レ옄 ?낅뜲?댄듃
            updateStats();
        }).catch(function () {
            mngrAlert("재직 직원 목록 조회 중 오류가 발생했습니다.", "error");
        });
    }

    // ?쒕쾭?먯꽌 怨꾩젙 ?앹꽦 ?붿껌 紐⑸줉??媛?몄샂
    function loadRequestList() {
        // 寃?됱뼱, 吏곷Т, ?곹깭 ?꾪꽣 媛?媛?몄삤湲?
        var keyword = getField("requestKeyword");
        var duty = getField("requestDutyFilter");
        var status = getField("requestStatusFilter");
        var dateType = getField("requestDateType");
        var searchDate = getField("requestSearchDate");

        // API URL 議곕┰
        var url = contextPath + "/manager/employee/request/list/" + mgmtOfcNo
            + "?keyword=" + encodeURIComponent(keyword)
            + "&rqstDutyCd=" + encodeURIComponent(duty)
            + "&rqstSttsCd=" + encodeURIComponent(status)
            + "&dateType=" + encodeURIComponent(dateType)
            + "&searchDate=" + encodeURIComponent(searchDate);

        // 鍮꾨룞湲?GET ?붿껌 ?ㅽ뻾
        getJson(url).then(function (data) {
            requestRowData = data.list || [];
            // 洹몃━???곸뿭???곗씠???꾨떖 諛??뚮뜑留?
            MngrAccountGrid.setRows(requestGridEl, requestRowData);
            updateStats();
        }).catch(function () {
            mngrAlert("직원 계정 요청 목록 조회 중 오류가 발생했습니다.", "error");
        });
    }

    // 珥덇린 AG Grid 媛앹껜?ㅼ쓣 ?앹꽦 (而щ읆 ?뺤쓽 ??珥덇린 ?ㅼ젙 ?ы븿)
    function createGrids() {
        MngrAccountGrid.createGrids({
            managerGridEl: managerGridEl,
            requestGridEl: requestGridEl,
            managerRowData: managerRowData,
            requestRowData: requestRowData,
            isAdmin: isAdmin
        });
    }

    /* [6] ?붾㈃ UI ?쒖뼱 ?⑥닔 (紐⑤떖, ?? */

    // ?대젮 ?덈뒗 紐⑤뱺 紐⑤떖李쎌쓣 李얠븘 ?レ쓬
    function closeAllModals() {
        page.querySelectorAll(".modal-overlay.open").forEach(function (modal) {
            closeModal(modal.id);
        });
    }

    // ?뱀젙 ???덉쓽 紐⑤뱺 ?낅젰 ?꾨뱶(input, select, textarea)瑜??쒖꽦??鍮꾪솢?깊솕
    function setFormDisabled(formId, disabled) {
        var form = document.getElementById(formId);
        if (!form) return;

        form.querySelectorAll("input:not([type=hidden]), select, textarea")
            .forEach(function (el) {
                el.disabled = disabled;
            });
    }

    // ??踰꾪듉 ?대┃ ??'?ъ쭅 吏곸썝' ??'?붿껌 ?댁뿭' ?붾㈃ ?꾪솚
    function changeTab(tab) {
        page.querySelectorAll(".tab-btn").forEach(function (btn) {
            btn.classList.toggle("active", btn.dataset.tab === tab);
        });

        document.getElementById("managerTabPanel").classList.toggle("active", tab === "manager");
        document.getElementById("requestTabPanel").classList.toggle("active", tab === "request");
    }

    // ?덈줈怨좎묠 ???붿껌 ???좎??? ?tab=request???뚮쭔 ?붿껌 ??쓣 湲곕낯?쇰줈 ?곕떎.
    function applyInitialTab() {
        var tab = new URLSearchParams(location.search).get("tab");
        changeTab(tab === "request" ? "request" : "manager");
    }

    // ?ъ쭅 吏곸썝 ?꾪꽣瑜?珥덇린?뷀븯怨?紐⑸줉 ?ㅼ떆 遺덈윭?ㅺ린
    function resetManagerFilter() {
        setField("managerKeyword", ""); // 寃?됱뼱 鍮꾩슦湲?
        var dutyFilter = document.getElementById("managerDutyFilter");
        if (dutyFilter) dutyFilter.value = ""; // 吏곷Т ?좏깮 珥덇린??
        loadEmployeeList(); // ?ъ“??
    }

    // ?붿껌 ?댁뿭 ?꾪꽣瑜?珥덇린?뷀븯怨?紐⑸줉 ?ㅼ떆 遺덈윭?ㅺ린
    function resetRequestFilter() {
        setField("requestKeyword", "");
        var dutyFilter = document.getElementById("requestDutyFilter");
        var statusFilter = document.getElementById("requestStatusFilter");
        var dateTypeFilter = document.getElementById("requestDateType");
        if (dutyFilter) dutyFilter.value = "";
        if (statusFilter) statusFilter.value = "";
        if (dateTypeFilter) dateTypeFilter.value = "RQST";
        setField("requestSearchDate", "");
        loadRequestList();
    }

    // SheetJS(XLSX) ?쇱씠釉뚮윭由щ? ?댁슜???ъ쭅 吏곸썝 紐⑸줉???묒?濡????
    function excelDownload() {
        if (typeof XLSX === "undefined") {
            mngrAlert("엑셀 다운로드 라이브러리가 로드되지 않았습니다.", "error");
            return;
        }

        // 洹몃━???곗씠?곕? ?묒???媛앹껜 諛곗뿴濡?蹂??
        var rows = managerRowData.map(function (row) {
            return {
                "직원명": safe(row.userNm),
                "아이디": safe(row.userId),
                "직무": dutyText(row.mngrDutyCd),
                "연락처": safe(row.telno),
                "이메일": safe(row.userEml),
                "상태": row.userYn === "Y" ? "활성" : "비활성"
            };
        });

        var ws = XLSX.utils.json_to_sheet(rows); // ?쒗듃 ?앹꽦
        var wb = XLSX.utils.book_new();         // ?뚰겕遺??앹꽦
        XLSX.utils.book_append_sheet(wb, ws, "재직직원"); // ?쒗듃 異붽?
        XLSX.writeFile(wb, "재직직원목록.xlsx"); // ?뚯씪 ?ㅼ슫濡쒕뱶 ?ㅽ뻾
    }

    /* [7] ?곸꽭 議고쉶 諛??섏젙 紐⑤떖 愿??湲곕뒫 */

    // ?ъ쭅 吏곸썝 ?곸꽭 ?뺣낫 紐⑤떖 ?닿린
    function openManagerDetail(row) {
        document.getElementById("accountModalTitle").textContent = "재직 직원 상세";

        fillManagerForm(row); // ?쇱뿉 ?곗씠??梨꾩슦湲?
        setFormDisabled("accountForm", true); // 紐⑤뱺 ?꾨뱶 ?쎄린 ?꾩슜 ?ㅼ젙

        // ?섎떒 踰꾪듉 援ъ꽦 (愿由ъ옄 ?꾨땲硫?'?섏젙' 踰꾪듉 異붽?)
        var footer = '<button type="button" class="btn btn-secondary" data-modal-close>닫기</button>';
        if (!isAdmin) {
            footer += '<button type="button" class="btn btn-primary" data-action="manager-edit" data-row-key="'
                + escapeHtml(row.userNo) + '">수정</button>';
        }
        document.getElementById("accountModalFooter").innerHTML = footer;

        openModal("accountModal");
    }

    // ?ъ쭅 吏곸썝 吏곷Т ?섏젙 紐⑤떖 ?닿린
    function openManagerEdit(row) {
        if (blockAdminWrite()) return;

        document.getElementById("accountModalTitle").textContent = "재직 직원 직무 수정";

        fillManagerForm(row);
        setFormDisabled("accountForm", true); // 湲곕낯? 鍮꾪솢?깊솕?섎릺

        var duty = document.getElementById("accountDutyCd");
        if (duty) duty.disabled = false; // '吏곷Т' ?꾨뱶留??좏깮 媛?ν븯寃?蹂寃?

        // ?섎떒 ???踰꾪듉 ?명똿
        document.getElementById("accountModalFooter").innerHTML =
            '<button type="button" class="btn btn-secondary" data-modal-close>취소</button>'
            + '<button type="button" class="btn btn-primary" data-action="submit-manager-update">저장</button>';

        openModal("accountModal");
    }

    // 吏곸썝 ?뺣낫瑜??앹뾽 ?????붿냼?ㅼ뿉 留ㅽ븨
    function fillManagerForm(row) {
        setField("accountUserNo", row.userNo);
        setField("accountMgmtOfcNo", row.mgmtOfcNo);
        setField("accountUserYn", row.userYn);
        setField("accountUserNm", row.userNm);
        setField("accountUserId", row.userId);
        setField("accountTelno", row.telno);
        setField("accountUserEml", row.userEml);
        setField("accountBirthDate", row.birthDate);

        var duty = document.getElementById("accountDutyCd");
        if (duty) duty.value = row.mngrDutyCd || "";
    }

    // 怨꾩젙 ?앹꽦 ?붿껌 ?쇱쓽 紐⑤뱺 ?낅젰媛?珥덇린??
    function clearRequestForm() {
        var form = document.getElementById("requestForm");
        if (form) {
            form.reset();
            // ?깅줉/?곸꽭/?섏젙 紐⑤뱶瑜?媛숈? ?쇱뿉???ъ궗?⑺븯誘濡??댁쟾 紐⑤뱶 ?쒖떆瑜?珥덇린?뷀븳??
            form.classList.remove("readonly-mode", "request-edit-mode");
        }

        setField("rqstNo", "");
        setField("rqstUserNo", "");
        setField("rqstMgmtOfcNoHidden", mgmtOfcNo);
        setField("requestMgmtOfcNoText", mgmtOfcNm || mgmtOfcNo);
        setField("requestAptCmplexNmText", aptCmplexNm);
        setField("requestLoginUserNmText", loginUserNm);

        clearSelectedMember(); // 寃?됲빐???좏깮?덈뜕 ?뚯썝 ?뺣낫??吏?

        // ?곹깭 ?쒖떆 ?곸뿭 諛?諛섎젮 ?ъ쑀 ?곸뿭 ?④?
        document.getElementById("rqstStatusSection").style.display = "none";
        document.getElementById("rqstRjctBox").style.display = "none";
        var waitBadge = document.getElementById("rqstWaitBadge");
        if (waitBadge) waitBadge.classList.remove("visible");
    }

    // ?좉퇋 怨꾩젙 ?앹꽦 ?붿껌 紐⑤떖 ?닿린
    function openRequestInsert() {
        if (blockAdminWrite()) return;

        clearRequestForm(); // 鍮???以鍮?

        // ?깅줉 紐⑤뱶???뚯썝 寃?됱쑝濡?????뚯썝???좏깮?댁빞 ?섎?濡??곸꽭/?섏젙 ?꾩슜 ?ㅽ??쇱쓣 ?쒓굅?쒕떎.
        document.getElementById("requestForm").classList.remove("readonly-mode", "request-edit-mode");

        document.getElementById("requestModalTitle").textContent = "계정 생성 요청 등록";

        setFormDisabled("requestForm", false); // ?낅젰 媛?ν븯寃??ㅼ젙

        // ?대쫫怨?ID??吏곸젒 ?낅젰???꾨땲??'?뚯썝 寃?????듯빐?쒕쭔 ?낅젰?섎룄濡?留됱쓬
        document.getElementById("rqstMngrNm").readOnly = true;
        document.getElementById("rqstLoginId").readOnly = true;

        document.getElementById("requestModalFooter").innerHTML =
            '<button type="button" class="btn btn-secondary" data-modal-close>취소</button>'
            + '<button type="button" class="btn btn-primary" data-action="submit-request-insert">등록 요청</button>';

        openModal("requestModal");
    }

    // 怨꾩젙 ?붿껌 ?곸꽭 ?뺣낫 紐⑤떖 ?닿린
    function openRequestDetail(row) {
        fillRequestForm(row);

        document.getElementById("requestModalTitle").textContent = "계정 생성 요청 상세";
        document.getElementById("rqstStatusSection").style.display = ""; // ?곹깭 ?곸뿭 ?쒖떆

        setField("rqstDt", formatDate(row.rqstDt)); // ?붿껌 ?쇱옄
        setField("rqstSttsCdText", sttsText(row.rqstSttsCd)); // ?곹깭紐??쒓?)
        var waitBadge = document.getElementById("rqstWaitBadge");
        if (waitBadge) waitBadge.classList.toggle("visible", !isAdmin && normalizeStatus(row.rqstSttsCd) === "WAIT");

        // 留뚯빟 嫄곗젅(諛섎젮) ?곹깭?쇰㈃ 諛섎젮 ?ъ쑀 諛뺤뒪瑜?蹂댁뿬以?
        if (normalizeStatus(row.rqstSttsCd) === "RJCT") {
            document.getElementById("rqstRjctBox").style.display = "";
            setField("rqstRjctRsnCn", row.rjctRsnCn);
        }

        setFormDisabled("requestForm", true); // ?곸꽭 ?뺣낫??湲곕낯?곸쑝濡??섏젙 遺덇?

        // ?곸꽭 紐⑤뱶??議고쉶 ?붾㈃泥섎읆 蹂댁씠?꾨줉 ?꾩슜 ?ㅽ????곸슜
        document.getElementById("requestForm").classList.remove("request-edit-mode");
        document.getElementById("requestForm").classList.add("readonly-mode");

        var footer = '<button type="button" class="btn btn-secondary" data-modal-close>닫기</button>';

        // 愿由ъ옄媛 ?꾨땲怨??곹깭媛 '?湲? 以묒씪 ?뚮쭔 ?섏젙 踰꾪듉 ?몄텧
        if (!isAdmin && normalizeStatus(row.rqstSttsCd) === "WAIT") {
            footer += '<button type="button" class="btn btn-primary" data-action="request-edit" data-row-key="'
                + escapeHtml(row.rqstNo) + '">수정</button>';
        }

        document.getElementById("requestModalFooter").innerHTML = footer;

        openModal("requestModal");
    }

    // 怨꾩젙 ?앹꽦 ?붿껌 ?섏젙 紐⑤떖 ?닿린
    function openRequestEdit(row) {
        if (blockAdminWrite()) return;

        fillRequestForm(row);

        // ?섏젙 紐⑤뱶???곸꽭 ?붾㈃怨??숈씪?섍쾶 ????뚯썝??怨좎젙?섍퀬, 吏곷Т/鍮꾧퀬留??섏젙 媛?ν븯寃??곕떎.
        document.getElementById("requestForm").classList.add("readonly-mode", "request-edit-mode");

        document.getElementById("requestModalTitle").textContent = "계정 생성 요청 수정";
        document.getElementById("rqstStatusSection").style.display = "";

        setField("rqstDt", formatDate(row.rqstDt));
        setField("rqstSttsCdText", sttsText(row.rqstSttsCd));
        var waitBadge = document.getElementById("rqstWaitBadge");
        if (waitBadge) waitBadge.classList.toggle("visible", normalizeStatus(row.rqstSttsCd) === "WAIT");

        setFormDisabled("requestForm", true); // ?꾩껜??留됯퀬

        // 吏곷Т? 鍮꾧퀬留??섏젙 媛?ν븯寃??댁뼱以?
        var duty = document.getElementById("rqstDutyCd");
        var rmrk = document.getElementById("rqstRmrkCn");

        if (duty) duty.disabled = false;
        if (rmrk) rmrk.disabled = false;

        document.getElementById("requestModalFooter").innerHTML =
            '<button type="button" class="btn btn-secondary" data-modal-close>취소</button>'
            + '<button type="button" class="btn btn-primary" data-action="submit-request-update">저장</button>';

        openModal("requestModal");
    }

    // ?붿껌 ?곗씠?곕? ?붿껌 ?쇱뿉 梨꾩슦湲?
    function fillRequestForm(row) {
        clearRequestForm();

        setField("rqstNo", row.rqstNo);
        setField("rqstUserNo", row.userNo);
        setField("rqstMngrNm", row.rqstMngrNm);
        setField("rqstLoginId", row.rqstLoginId);
        setField("rqstRmrkCn", row.rmrkCn);
        setField("rqstMgmtOfcNoHidden", row.mgmtOfcNo || mgmtOfcNo);

        var duty = document.getElementById("rqstDutyCd");
        if (duty) duty.value = row.rqstDutyCd || "";

        // UI???좏깮???뚯썝 ?뺣낫 ?쒖떆
        showSelectedMember({
            userNo: row.userNo,
            userNm: row.rqstMngrNm,
            userId: row.rqstLoginId
        });
    }

    /* [8] ?뚯썝 寃??諛??좏깮 濡쒖쭅 */

    // ?뚯썝 寃??李쎌뿉???뱀젙 ?뚯썝??怨⑤옄?????붾㈃???쒖떆
    function showSelectedMember(member) {
        // ?꾨컮? 泥?湲???쒖떆
        document.getElementById("selMemberAvatar").textContent = member.userNm ? member.userNm.charAt(0) : "-";
        // ?대쫫 諛??꾩씠???띿뒪???명똿
        document.getElementById("selMemberName").textContent = safe(member.userNm);
        document.getElementById("selMemberSub").textContent = safe(member.userId);
        // ?좏깮???뚯썝 ?뺣낫 ?곸뿭 ?쒖떆
        document.getElementById("rqstSelectedMember").classList.add("visible");

        // ???대? ?ㅼ젣 媛??명똿
        setField("rqstMngrNm", member.userNm);
        setField("rqstLoginId", member.userId);
        setField("rqstUserNo", member.userNo);
    }

    // ?좏깮???뚯썝 ?뺣낫 珥덇린??
    function clearSelectedMember() {
        document.getElementById("rqstSelectedMember").classList.remove("visible");
        setField("rqstMngrNm", "");
        setField("rqstLoginId", "");
        setField("rqstUserNo", "");
    }

    // ?뚯썝 李얘린 紐⑤떖?먯꽌 ?쒕쾭 API瑜??듯빐 ?뚯썝 寃??
    function doMemberSearch() {
        var keyword = getField("memberModalKeyword");
        var resultBox = document.getElementById("memberSearchResult");

        resultBox.innerHTML = '<div class="member-empty">검색 중...</div>';

        var url = contextPath + "/manager/employee/member/search/" + mgmtOfcNo
            + "?keyword=" + encodeURIComponent(keyword);

        getJson(url).then(function (data) {
            var list = data.list || [];

            if (list.length === 0) {
                resultBox.innerHTML = '<div class="member-empty">검색 결과가 없습니다.</div>';
                return;
            }

            // 寃??寃곌낵瑜?HTML 臾몄옄?대줈 ?앹꽦?섏뿬 ?쎌엯
            resultBox.innerHTML = list.map(function (member) {
                var rejectedBadge = normalizeStatus(member.rqstSttsCd) === "RJCT"
                    ? '<span class="member-rjct-badge">반려 이력</span>'
                    : '';

                return '<div class="member-item" data-action="select-member"'
                    + ' data-user-no="' + escapeHtml(member.userNo) + '"'
                    + ' data-user-nm="' + escapeHtml(member.userNm) + '"'
                    + ' data-user-id="' + escapeHtml(member.userId) + '">'
                    + '<div class="m-avatar">' + escapeHtml(member.userNm ? member.userNm.charAt(0) : "-") + '</div>'
                    + '<div>'
                    + '<div class="member-name-row"><span class="m-name">' + escapeHtml(member.userNm) + '</span>' + rejectedBadge + '</div>'
                    + '<div class="m-sub">' + escapeHtml(member.userId) + ' · ' + escapeHtml(member.userTelno) + '</div>'
                    + '</div></div>';
            }).join("");
        }).catch(function () {
            resultBox.innerHTML = '<div class="member-empty">검색 중 오류가 발생했습니다.</div>';
        });
    }

    /* [9] ?쒕쾭 ?꾩넚(??? 泥섎━ */

    // 吏곸썝 吏곷Т ?섏젙 ?댁슜 ???
    function submitManagerUpdate() {
        if (blockAdminWrite()) return;

        if (!getField("accountDutyCd")) {
            mngrAlert("직무를 선택하세요.");
            return;
        }

        postJson(contextPath + "/manager/employee/duty/update/" + mgmtOfcNo, {
            userNo: getField("accountUserNo"),
            mgmtOfcNo: mgmtOfcNo,
            mngrDutyCd: getField("accountDutyCd")
        }).then(function (result) {
            mngrAlert(result.message || "처리되었습니다.", result.success ? "success" : "error").then(function () {
                if (result.success) reloadCurrentPage();
            });
        }).catch(function () {
            mngrAlert("처리 중 오류가 발생했습니다.", "error");
        });
    }

    // ?좉퇋 怨꾩젙 ?앹꽦 ?붿껌 ???
    function submitRequestInsert() {
        if (blockAdminWrite()) return;

        if (!getField("rqstUserNo")) {
            mngrAlert("직원으로 등록할 회원을 선택하세요.");
            return;
        }

        if (!getField("rqstDutyCd")) {
            mngrAlert("직무를 선택하세요.");
            return;
        }

        postJson(contextPath + "/manager/employee/request/insert/" + mgmtOfcNo, {
            rqstLoginId: getField("rqstLoginId"),
            rqstMngrNm: getField("rqstMngrNm"),
            rqstDutyCd: getField("rqstDutyCd"),
            rmrkCn: getField("rqstRmrkCn")
        }).then(function (result) {
            mngrAlert(result.message || "처리되었습니다.", result.success ? "success" : "error").then(function () {
                if (result.success) reloadCurrentPage("request");
            });
        }).catch(function () {
            mngrAlert("처리 중 오류가 발생했습니다.", "error");
        });
    }

    // 湲곗〈 ?붿껌 ?섏젙 ???
    function submitRequestUpdate() {
        if (blockAdminWrite()) return;

        if (!getField("rqstDutyCd")) {
            mngrAlert("직무를 선택하세요.");
            return;
        }

        postJson(contextPath + "/manager/employee/request/update/" + mgmtOfcNo, {
            rqstNo: getField("rqstNo"),
            rqstDutyCd: getField("rqstDutyCd"),
            rmrkCn: getField("rqstRmrkCn")
        }).then(function (result) {
            mngrAlert(result.message || "처리되었습니다.", result.success ? "success" : "error").then(function () {
                if (result.success) reloadCurrentPage("request");
            });
        }).catch(function () {
            mngrAlert("처리 중 오류가 발생했습니다.", "error");
        });
    }

    // ?붿껌 痍⑥냼 泥섎━ (而⑦럩 紐⑤떖 ???ㅽ뻾)
    function cancelRequest(rqstNo) {
        if (blockAdminWrite()) return;

        // 紐⑸줉?먯꽌 ???李얘린
        var row = requestRowData.find(function (item) {
            return String(item.rqstNo) === String(rqstNo);
        });

        if (!row) {
            mngrAlert("요청 정보를 찾을 수 없습니다.", "error");
            return;
        }

        // ?湲??곹깭媛 ?꾨땲硫?痍⑥냼 遺덇???
        if (normalizeStatus(row.rqstSttsCd) !== "WAIT") {
            mngrAlert("승인대기 상태의 요청만 취소할 수 있습니다.");
            return;
        }

        // 怨듯넻 而⑦럩 紐⑤떖 ?닿퀬 ?뺤씤 ??API ?몄텧
        openConfirm("요청 취소", "선택한 계정 생성 요청을 취소하시겠습니까?", true, function () {
            postJson(contextPath + "/manager/employee/request/cancel/" + mgmtOfcNo, {
                rqstNo: rqstNo,
                rmrkCn: getField("confirmReason")
            }).then(function (result) {
                mngrAlert(result.message || "처리되었습니다.", result.success ? "success" : "error").then(function () {
                    if (result.success) reloadCurrentPage("request");
                });
            }).catch(function () {
                mngrAlert("처리 중 오류가 발생했습니다.", "error");
            });
        });
    }

    // 怨듯넻 ?뺤씤(Confirm) 紐⑤떖 ?몄텧 ?⑥닔
    function openConfirm(title, message, showReason, callback) {
        document.getElementById("confirmTitle").textContent = title;
        document.getElementById("confirmMessage").textContent = message;

        setField("confirmReason", "");
        // ?ъ쑀 ?낅젰李쎌씠 ?꾩슂??寃쎌슦?먮쭔 ?몄텧
        document.getElementById("confirmReasonBox").style.display = showReason ? "block" : "none";

        confirmCallback = callback; // ?ㅽ뻾???⑥닔瑜?蹂?섏뿉 ??ν빐??

        openModal("confirmModal");
    }

    /* [10] ?대깽??由ъ뒪??- ?대┃ ?대깽???꾩엫 */

    // ?섏씠吏 ?댁쓽 ?대┃ 諛쒖깮?섎뒗 紐⑤뱺 ?붿냼瑜?媛먯떆
    page.addEventListener("click", function (e) {
        // [?リ린] 踰꾪듉 ?대┃ ??紐⑤뱺 紐⑤떖 醫낅즺
        if (e.target.closest("[data-modal-close]")) {
            closeAllModals();
            return;
        }

        // data-action ?띿꽦???덈뒗 ?붿냼媛 ?뚮졇?붿? ?뺤씤
        var btn = e.target.closest("[data-action]");
        if (!btn) return;

        // HTML disabled ?띿꽦???덈뒗 踰꾪듉?대㈃ 臾댁떆
        // is-disabled ?대옒?ㅻ뒗 ?먮━寃?蹂댁씠湲??꾪븳 ?쒖떆?⑹씠誘濡??ш린??留됱? ?딆쓬
        if (btn.disabled) return;

        var action = btn.dataset.action;

        /* ?≪뀡 醫낅쪟???곕Ⅸ 遺꾧린 泥섎━ */
        if (action === "change-tab") changeTab(btn.dataset.tab);       // ???꾪솚
        if (action === "search-manager") loadEmployeeList();           // 吏곸썝 議고쉶
        if (action === "reset-manager") resetManagerFilter();         // 吏곸썝 ?꾪꽣 珥덇린??
        if (action === "search-request") loadRequestList();            // ?붿껌 議고쉶
        if (action === "reset-request") resetRequestFilter();         // ?붿껌 ?꾪꽣 珥덇린??
        if (action === "excel-download") excelDownload();              // ?묒? ?ㅼ슫濡쒕뱶

        if (action === "open-request-modal") openRequestInsert();      // ?깅줉 紐⑤떖 ?닿린

        if (action === "open-member-search") {                         // ?뚯썝 寃???앹뾽 ?닿린
            setField("memberModalKeyword", getField("memberSearchKeyword"));
            openModal("memberSearchModal");
            doMemberSearch();
        }

        if (action === "do-member-search") doMemberSearch();           // ?ㅼ젣 寃???ㅽ뻾
        if (action === "clear-member") clearSelectedMember();          // ?좏깮???뚯썝 痍⑥냼

        if (action === "select-member") {                              // 寃??寃곌낵?먯꽌 ?뚯썝 ?좏깮
            showSelectedMember({
                userNo: btn.dataset.userNo,
                userNm: btn.dataset.userNm,
                userId: btn.dataset.userId
            });
            closeModal("memberSearchModal");
        }

        if (action === "manager-detail") {                             // 吏곸썝 ?곸꽭 蹂닿린
            var managerDetailRow = managerRowData.find(function (row) {
                return String(row.userNo) === String(btn.dataset.rowKey);
            });
            if (managerDetailRow) openManagerDetail(managerDetailRow);
        }

        if (action === "manager-edit") {                               // 吏곸썝 ?섏젙 ?섍린
            var managerEditRow = managerRowData.find(function (row) {
                return String(row.userNo) === String(btn.dataset.rowKey);
            });
            if (managerEditRow) openManagerEdit(managerEditRow);
        }

        if (action === "submit-manager-update") submitManagerUpdate(); // 吏곸썝 ?섏젙 ???

        if (action === "request-detail") {                             // ?붿껌 ?곸꽭 蹂닿린
            var requestDetailRow = requestRowData.find(function (row) {
                return String(row.rqstNo) === String(btn.dataset.rowKey);
            });
            if (requestDetailRow) openRequestDetail(requestDetailRow);
        }

        if (action === "request-edit") {                               // ?붿껌 ?섏젙 ?섍린
            var requestEditRow = requestRowData.find(function (row) {
                return String(row.rqstNo) === String(btn.dataset.rowKey);
            });
            if (!requestEditRow) {
                mngrAlert("요청 정보를 찾을 수 없습니다.", "error");
                return;
            }
            if (normalizeStatus(requestEditRow.rqstSttsCd) !== "WAIT") {
                mngrAlert("승인대기 상태의 요청만 수정할 수 있습니다.");
                return;
            }
            openRequestEdit(requestEditRow);
        }

        if (action === "request-cancel") cancelRequest(btn.dataset.rowKey); // ?붿껌 痍⑥냼 ?ㅽ뻾
        if (action === "submit-request-insert") submitRequestInsert();       // ?붿껌 ?깅줉 ???
        if (action === "submit-request-update") submitRequestUpdate();       // ?붿껌 ?섏젙 ???
    });

    /* [11] 而⑦럩 紐⑤떖 理쒖쥌 ?뺤씤 踰꾪듉 ?대깽??*/
    var confirmActionBtn = document.getElementById("confirmActionBtn");
    if (confirmActionBtn) {
        confirmActionBtn.addEventListener("click", function () {
            closeModal("confirmModal");
            // ??ν빐?먯뿀??肄쒕갚 ?⑥닔媛 ?덈떎硫??ㅽ뻾
            if (typeof confirmCallback === "function") {
                confirmCallback();
            }
        });
    }

    /* [12] 珥덇린 ?ㅽ뻾 */
    createGrids();      // 洹몃━??? ?앹꽦
    applyInitialTab();  // URL??tab ?뚮씪誘명꽣??留욎떠 理쒖큹 ?쒖꽦 ??寃곗젙
    loadEmployeeList(); // 吏곸썝 ?곗씠??議고쉶
    loadRequestList();  // ?붿껌 ?곗씠??議고쉶
}

