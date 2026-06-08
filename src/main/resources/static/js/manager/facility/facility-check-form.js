/**
 * 시설 점검 이력 화면 전용 스크립트
 * - 상단 시설/협력업체 선택 모달 유지
 * - 시설 선택 후 점검 이력 AJAX 조회
 * - 왼쪽 이력 목록 렌더링 및 목록 내부 필터 처리
 * - 오른쪽 패널을 상세 보기 / 첫 점검 등록 / 후속이력 등록으로 전환
 * - 후속 등록은 가장 최근 이력 기준으로만 처리
 */
(function () {
    "use strict";

    document.addEventListener("DOMContentLoaded", function () {
        /** 화면 설정값 */
        var config = window.facilityCheckConfig || {};
        var contextPath = config.contextPath || "";
        var mgmtOfcNo = config.mgmtOfcNo || "";
        var isAdmin = config.isAdmin === true || config.isAdmin === "true";

        /** 등록 form */
        var form = document.getElementById("checkForm");

        /** 현재 화면 상태값 */
        var currentHistoryList = [];
        var filteredHistoryList = [];
        var latestHistory = null;
        var selectedHistory = null;

        /** DOM 단일 조회 함수 */
        function $(id) {
            return document.getElementById(id);
        }

        /** DOM 텍스트 입력 함수 */
        function setText(id, value) {
            var element = $(id);
            if (element) {
                element.textContent = safeText(value);
            }
        }

        /** DOM 값 입력 함수 */
        function setValue(id, value) {
            var element = $(id);
            if (element) {
                element.value = value || "";
            }
        }

        /** 화면 표시용 텍스트 보정 함수 */
        function safeText(value, fallback) {
            if (value === null || value === undefined) {
                return fallback || "-";
            }

            var text = String(value).trim();
            return text ? text : (fallback || "-");
        }

        /** 저장/비교용 문자열 보정 함수 */
        function safeValue(value) {
            if (value === null || value === undefined) {
                return "";
            }

            return String(value).trim();
        }

        /** HTML 특수문자 변환 함수 */
        function escapeHtml(value) {
            return safeText(value, "")
                .replace(/&/g, "&amp;")
                .replace(/</g, "&lt;")
                .replace(/>/g, "&gt;")
                .replace(/\"/g, "&quot;")
                .replace(/'/g, "&#039;");
        }

        /** 공통 모달 열기 함수 */
        function showModal(modalId) {
            if (typeof window.openModal === "function") {
                window.openModal(modalId);
                return;
            }

            var modal = $(modalId);
            if (modal) {
                modal.classList.add("open");
                modal.classList.add("is-open");
            }
        }

        /** 공통 모달 닫기 함수 */
        function hideModal(modalId) {
            if (typeof window.closeModal === "function") {
                window.closeModal(modalId);
                return;
            }

            var modal = $(modalId);
            if (modal) {
                modal.classList.remove("open");
                modal.classList.remove("is-open");
            }
        }

        /** JSON GET 함수 */
        function fetchJson(url) {
            if (typeof window.getJson === "function") {
                return window.getJson(url);
            }

            return fetch(url, {
                method: "GET",
                headers: { "X-Requested-With": "XMLHttpRequest" }
            }).then(function (response) {
                if (!response.ok) {
                    throw new Error("HTTP " + response.status);
                }

                return response.json();
            });
        }

        /** 쿼리 문자열 생성 함수 */
        function buildQuery(params) {
            var query = new URLSearchParams();

            Object.keys(params).forEach(function (key) {
                var value = params[key];

                if (value !== null && value !== undefined && String(value).trim() !== "") {
                    query.append(key, String(value).trim());
                }
            });

            return query.toString();
        }

        /** 대상 선택 상태 전환 함수 */
        function switchTargetState(emptyId, selectedId) {
            var emptyState = $(emptyId);
            var selectedState = $(selectedId);

            if (emptyState) {
                emptyState.classList.add("is-hidden");
            }

            if (selectedState) {
                selectedState.classList.remove("is-hidden");
            }
        }

        /** 중복 select option 제거 함수 */
        function removeDuplicateOptions(selectId) {
            var select = $(selectId);
            if (!select) return;

            var seen = {};

            Array.prototype.slice.call(select.options).forEach(function (option) {
                var key = option.value;
                if (!key) return;

                if (seen[key]) {
                    option.remove();
                    return;
                }

                seen[key] = true;
            });
        }

        /** 상태 배지 클래스 반환 함수 */
        function getStatusBadgeClass(statusCode) {
            if (statusCode === "WAIT") return "badge-wait";
            if (statusCode === "ING") return "badge-ing";
            if (statusCode === "DONE") return "badge-done";
            if (statusCode === "FAULT") return "badge-fault";

            return "badge-wait";
        }

        /** 이력 객체 필드 보정 함수 */
        function normalizeHistory(history) {
            history = history || {};

            return {
                facChkHstryNo: safeValue(history.facChkHstryNo || history.facChkHistNo || history.historyNo),
                facilityNo: safeValue(history.facilityNo),
                partnerNo: safeValue(history.partnerNo),
                partnerNm: safeValue(history.partnerNm),
                chkTyCd: safeValue(history.chkTyCd),
                chkTyNm: safeValue(history.chkTyNm || history.chkTyName),
                chkDt: safeValue(history.chkDt),
                chkSttsCd: safeValue(history.chkSttsCd),
                chkSttsNm: safeValue(history.chkSttsNm || history.chkStatusNm),
                chkCn: safeValue(history.chkCn),
                rmk: safeValue(history.rmk || history.rmkCn || history.rmrkCn)
            };
        }

        /** select option 목록 복사 함수 */
        function copyOptionsHtml(sourceSelectId) {
            var source = $(sourceSelectId);
            if (!source) {
                return '<option value="">전체</option>';
            }

            var html = '<option value="">전체</option>';

            Array.prototype.slice.call(source.options).forEach(function (option) {
                if (!option.value) return;

                html += '<option value="' + escapeHtml(option.value) + '">' + escapeHtml(option.textContent) + '</option>';
            });

            return html;
        }

        /** 이력 필터 DOM 보장 함수 */
        function ensureHistoryFilterBar() {
            if ($("historyFilterBar")) return;

            var listArea = document.querySelector(".history-list-area");
            var historyList = $("facilityHistoryList");

            if (!listArea || !historyList) return;

            var filterBar = document.createElement("div");
            filterBar.className = "history-filter-bar";
            filterBar.id = "historyFilterBar";
            filterBar.innerHTML = ''
                + '<div class="filter-field">'
                + '    <label class="field-label" for="historyFilterChkTyCd">점검유형</label>'
                + '    <select class="form-select" id="historyFilterChkTyCd">' + copyOptionsHtml("chkTyCd") + '</select>'
                + '</div>'
                + '<div class="filter-field">'
                + '    <label class="field-label" for="historyFilterChkSttsCd">점검상태</label>'
                + '    <select class="form-select" id="historyFilterChkSttsCd">' + copyOptionsHtml("chkSttsCd") + '</select>'
                + '</div>'
                + '<div class="filter-field filter-keyword">'
                + '    <label class="field-label" for="historyFilterKeyword">검색어</label>'
                + '    <input type="text" class="form-input" id="historyFilterKeyword" placeholder="점검내용, 비고, 업체명 검색">'
                + '</div>'
                + '<div class="filter-buttons">'
                + '    <button type="button" class="btn btn-primary" id="historySearchBtn">검색</button>'
                + '    <button type="button" class="btn" id="historyResetBtn">초기화</button>'
                + '</div>';

            listArea.insertBefore(filterBar, historyList);
        }

        /** 이력 필터 표시 전환 함수 */
        function showHistoryFilterBar(show) {
            var filterBar = $("historyFilterBar") || document.querySelector(".history-filter-bar");
            var historyList = $("facilityHistoryList");

            if (show) {
                ensureHistoryFilterBar();
                filterBar = $("historyFilterBar") || document.querySelector(".history-filter-bar");
            }

            if (filterBar) {
                filterBar.classList.toggle("is-hidden", !show);
            }

            if (historyList) {
                historyList.classList.toggle("no-filter", !show);
            }
        }

        /** 사이드 패널 제목 변경 함수 */
        function setSideTitle(panelId, titleText) {
            var panel = $(panelId);
            if (!panel) return;

            var title = panel.querySelector(".side-card-title");
            if (!title) return;

            var icon = title.querySelector(".material-symbols-rounded");
            var iconHtml = icon ? icon.outerHTML : '<span class="material-symbols-rounded">edit_note</span>';

            title.innerHTML = iconHtml + escapeHtml(titleText);
        }

        /** 상세 패널 표시 함수 */
        function showDetailPanel() {
            var detailPanel = $("historyDetailPanel");
            var formPanel = $("historyFollowFormPanel");

            if (detailPanel) {
                detailPanel.classList.remove("is-hidden");
            }

            if (formPanel) {
                formPanel.classList.add("is-hidden");
            }
        }

        /** 등록 폼 패널 표시 함수 */
        function showFormPanel() {
            var detailPanel = $("historyDetailPanel");
            var formPanel = $("historyFollowFormPanel");

            if (detailPanel) {
                detailPanel.classList.add("is-hidden");
            }

            if (formPanel) {
                formPanel.classList.remove("is-hidden");
            }
        }

        /** 등록 폼 취소 버튼 보장 함수 */
        function ensureCancelButton(show) {
            var formPanel = $("historyFollowFormPanel");
            if (!formPanel) return;

            var actionBar = formPanel.querySelector(".side-action-bar");
            if (!actionBar) return;

            var cancelButton = $("cancelFollowFormBtn");

            if (show && !cancelButton) {
                cancelButton = document.createElement("button");
                cancelButton.type = "button";
                cancelButton.className = "btn";
                cancelButton.id = "cancelFollowFormBtn";
                cancelButton.textContent = "취소";

                actionBar.insertBefore(cancelButton, actionBar.firstChild);
            }

            if (cancelButton) {
                cancelButton.classList.toggle("is-hidden", !show);
            }
        }

        /** 후속 등록 버튼 보장 함수 */
        function ensureFollowButton(show) {
            var detailPanel = $("historyDetailPanel");
            if (!detailPanel || isAdmin) return;

            var actionBar = detailPanel.querySelector(".side-action-bar");
            if (!actionBar) return;

            var followButton = $("openFollowFormBtn");

            if (show && !followButton) {
                followButton = document.createElement("button");
                followButton.type = "button";
                followButton.className = "btn btn-primary";
                followButton.id = "openFollowFormBtn";
                followButton.innerHTML = '<span class="material-symbols-rounded">edit_note</span>후속 등록';

                actionBar.appendChild(followButton);
            }

            if (followButton) {
                followButton.classList.toggle("is-hidden", !show);
            }
        }

        /** 상세 패널 빈 상태 표시 함수 */
        function showEmptyDetailMessage(message, iconName) {
            var detailPanel = $("historyDetailPanel");
            if (!detailPanel) return;

            showDetailPanel();
            ensureFollowButton(false);
            setSideTitle("historyDetailPanel", "점검 이력 상세");

            var body = detailPanel.querySelector(".side-card-body");
            if (!body) return;

            body.innerHTML = ''
                + '<div class="history-detail-empty">'
                + '    <span class="material-symbols-rounded">' + escapeHtml(iconName || "domain") + '</span>'
                + '    <p>' + escapeHtml(message || "시설을 선택하면 이력 상세 또는 첫 등록 폼이 표시됩니다.") + '</p>'
                + '</div>';
        }

        /** 이력 상세 HTML 생성 함수 */
        function buildHistoryDetailHtml(history) {
            history = normalizeHistory(history);

            return ''
                + '<table class="detail-table">'
                + '    <tr>'
                + '        <th>이력번호</th>'
                + '        <td><span class="mono">' + escapeHtml(history.facChkHstryNo) + '</span></td>'
                + '        <th>점검일자</th>'
                + '        <td>' + escapeHtml(history.chkDt) + '</td>'
                + '    </tr>'
                + '    <tr>'
                + '        <th>점검유형</th>'
                + '        <td>' + escapeHtml(history.chkTyNm) + '</td>'
                + '        <th>점검상태</th>'
                + '        <td><span class="badge ' + getStatusBadgeClass(history.chkSttsCd) + '">' + escapeHtml(history.chkSttsNm) + '</span></td>'
                + '    </tr>'
                + '    <tr>'
                + '        <th>협력업체</th>'
                + '        <td colspan="3">' + escapeHtml(history.partnerNm) + '</td>'
                + '    </tr>'
                + '    <tr>'
                + '        <th>점검내용</th>'
                + '        <td colspan="3"><div class="detail-text-box">' + escapeHtml(history.chkCn) + '</div></td>'
                + '    </tr>'
                + '    <tr>'
                + '        <th>비고</th>'
                + '        <td colspan="3"><div class="detail-text-box note">' + escapeHtml(history.rmk) + '</div></td>'
                + '    </tr>'
                + '</table>';
        }

        /** 오른쪽 상세 패널 렌더링 함수 */
        function showHistoryDetail(history) {
            var detailPanel = $("historyDetailPanel");
            if (!detailPanel) return;

            selectedHistory = normalizeHistory(history);

            showDetailPanel();
            ensureFollowButton(currentHistoryList.length > 0);
            setSideTitle("historyDetailPanel", "점검 이력 상세");

            var body = detailPanel.querySelector(".side-card-body");
            if (body) {
                body.innerHTML = buildHistoryDetailHtml(selectedHistory);
            }

            markSelectedHistory(selectedHistory.facChkHstryNo);
        }

        /** 선택 이력 표시 함수 */
        function markSelectedHistory(historyNo) {
            document.querySelectorAll(".history-item").forEach(function (item) {
                var itemNo = item.getAttribute("data-history-no") || "";
                item.classList.toggle("is-selected", itemNo === historyNo);
            });
        }

        /** 등록 폼 저장 버튼 조회 함수 */
        function formPanelSubmitButton() {
            var formPanel = $("historyFollowFormPanel");
            if (!formPanel) return null;

            var buttons = formPanel.querySelectorAll("button[type='submit']");
            return buttons.length ? buttons[buttons.length - 1] : null;
        }

        /** 등록 폼 제목/모드 설정 함수 */
        function setFormMode(mode) {
            var isFirst = mode === "first";
            var baseNo = latestHistory ? latestHistory.facChkHstryNo : "";

            showFormPanel();
            ensureCancelButton(!isFirst);
            setSideTitle("historyFollowFormPanel", isFirst ? "첫 점검 이력 등록" : "후속이력 등록");

            var formMode = $("formMode");
            if (formMode) {
                formMode.value = isFirst ? "first" : "follow";
            }

            var baseHistoryNo = $("baseHistoryNo");
            if (baseHistoryNo) {
                baseHistoryNo.value = isFirst ? "" : baseNo;
            }

            var baseHistoryText = $("baseHistoryText");
            if (baseHistoryText) {
                baseHistoryText.textContent = isFirst ? "-" : safeText(baseNo);
            }

            var formGuide = $("historyFormGuide");
            if (formGuide) {
                formGuide.textContent = isFirst
                    ? "선택된 시설에 등록된 이력이 없으므로 첫 점검 이력으로 저장됩니다."
                    : "후속 등록은 가장 최근 이력을 기준으로 저장됩니다.";
            }

            var submitButton = $("saveHistoryBtn") || formPanelSubmitButton();
            if (submitButton) {
                submitButton.textContent = isFirst ? "등록" : "후속 등록";
            }

            if (isFirst) {
                setValue("rmk", "");
            } else {
                setValue("rmk", baseNo ? "기준이력 " + baseNo + " 후속 조치" : "");
            }
        }

        /** 첫 점검 등록 폼 표시 함수 */
        function showFirstRegisterForm() {
            latestHistory = null;
            selectedHistory = null;

            showHistoryFilterBar(false);
            setFormMode("first");
        }

        /** 후속 등록 폼 표시 함수 */
        function showFollowRegisterForm() {
            if (!latestHistory) {
                showFirstRegisterForm();
                return;
            }

            setFormMode("follow");
        }

        /** 이력 목록 빈 상태 렌더링 함수 */
        function renderEmptyHistoryList(message) {
            var historyBox = $("facilityHistoryTbody");
            if (!historyBox) return;

            historyBox.innerHTML = ''
                + '<div class="history-empty">'
                + escapeHtml(message || "선택한 시설의 기존 점검 이력이 없습니다.")
                + '</div>';
        }

        /** 이력 목록 row HTML 생성 함수 */
        function buildHistoryItemHtml(history) {
            history = normalizeHistory(history);

            return ''
                + '<button type="button" class="history-item history-row-btn" data-history-no="' + escapeHtml(history.facChkHstryNo) + '">'
                + '    <div class="history-date">' + escapeHtml(history.chkDt) + '</div>'
                + '    <div class="history-main">'
                + '        <div class="history-meta">'
                + '            <span class="history-type">' + escapeHtml(history.chkTyNm) + '</span>'
                + '            <span class="badge ' + getStatusBadgeClass(history.chkSttsCd) + '">' + escapeHtml(history.chkSttsNm) + '</span>'
                + '        </div>'
                + '        <span class="history-partner">' + escapeHtml(history.partnerNm) + '</span>'
                + '        <span class="history-content">' + escapeHtml(history.chkCn) + '</span>'
                + '    </div>'
                + '</button>';
        }

        /** 기존 점검 이력 목록 렌더링 함수 */
        function renderHistoryRows(historyList) {
            var historyBox = $("facilityHistoryTbody");
            if (!historyBox) return;

            currentHistoryList = (historyList || []).map(normalizeHistory);
            filteredHistoryList = currentHistoryList.slice();
            latestHistory = currentHistoryList.length > 0 ? currentHistoryList[0] : null;

            if (currentHistoryList.length === 0) {
                renderEmptyHistoryList("선택한 시설의 기존 점검 이력이 없습니다. 첫 점검 이력을 등록하세요.");
                showFirstRegisterForm();
                return;
            }

            showHistoryFilterBar(true);

            historyBox.innerHTML = filteredHistoryList.map(buildHistoryItemHtml).join("");

            showHistoryDetail(latestHistory);
        }

        /** 이력 필터 적용 함수 */
        function applyHistoryFilter() {
            var typeValue = $("historyFilterChkTyCd") ? $("historyFilterChkTyCd").value : "";
            var statusValue = $("historyFilterChkSttsCd") ? $("historyFilterChkSttsCd").value : "";
            var keyword = $("historyFilterKeyword") ? $("historyFilterKeyword").value.trim().toLowerCase() : "";

            filteredHistoryList = currentHistoryList.filter(function (history) {
                history = normalizeHistory(history);

                var typeMatched = !typeValue || history.chkTyCd === typeValue;
                var statusMatched = !statusValue || history.chkSttsCd === statusValue;

                var keywordTarget = [
                    history.chkCn,
                    history.rmk,
                    history.partnerNm,
                    history.chkTyNm,
                    history.chkSttsNm
                ].join(" ").toLowerCase();

                var keywordMatched = !keyword || keywordTarget.indexOf(keyword) > -1;

                return typeMatched && statusMatched && keywordMatched;
            });

            renderFilteredHistoryRows();
        }

        /** 이력 필터 결과 렌더링 함수 */
        function renderFilteredHistoryRows() {
            var historyBox = $("facilityHistoryTbody");
            if (!historyBox) return;

            if (filteredHistoryList.length === 0) {
                renderEmptyHistoryList("검색 조건에 맞는 점검 이력이 없습니다.");
                showEmptyDetailMessage("검색 결과에서 선택할 이력이 없습니다.", "search_off");
                return;
            }

            historyBox.innerHTML = filteredHistoryList.map(buildHistoryItemHtml).join("");

            showHistoryDetail(filteredHistoryList[0]);
        }

        /** 이력 필터 초기화 함수 */
        function resetHistoryFilter() {
            setValue("historyFilterChkTyCd", "");
            setValue("historyFilterChkSttsCd", "");
            setValue("historyFilterKeyword", "");

            filteredHistoryList = currentHistoryList.slice();
            renderFilteredHistoryRows();
        }

        /** 선택한 시설의 기존 점검 이력 조회 함수 */
        function loadFacilityHistory(facilityNo) {
            var tbody = $("facilityHistoryTbody");

            if (tbody) {
                tbody.innerHTML = '<div class="history-empty">기존 점검 이력을 불러오는 중입니다.</div>';
            }

            showEmptyDetailMessage("기존 점검 이력을 불러오는 중입니다.", "hourglass_empty");

            fetchJson(contextPath + "/manager/checkHistory/history/list/" + encodeURIComponent(mgmtOfcNo) + "/" + encodeURIComponent(facilityNo))
                .then(function (data) {
                    if (!data || !data.success) {
                        renderHistoryRows([]);
                        return;
                    }

                    renderHistoryRows(data.historyList || []);
                })
                .catch(function () {
                    if (tbody) {
                        tbody.innerHTML = '<div class="history-empty">기존 점검 이력 조회 중 오류가 발생했습니다.</div>';
                    }

                    showEmptyDetailMessage("기존 점검 이력 조회 중 오류가 발생했습니다.", "error");
                });
        }

        /** 시설 선택 모달 행 렌더링 함수 */
        function renderFacilityRows(facilityList) {
            var tbody = $("facilityModalTbody");
            if (!tbody) return;

            if (!facilityList || facilityList.length === 0) {
                tbody.innerHTML = '<tr><td colspan="6">검색된 시설이 없습니다.</td></tr>';
                return;
            }

            tbody.innerHTML = facilityList.map(function (facility) {
                var useYn = safeText(facility.useYn, "");
                var useText = useYn === "Y" ? "Y" : "N";

                return ''
                    + '<tr class="facility-modal-row"'
                    + ' data-key="' + escapeHtml([facility.facilityNo, facility.facilityNm, facility.facilityTyNm, facility.locCn].join(" ")) + '"'
                    + ' data-facility-no="' + escapeHtml(facility.facilityNo) + '"'
                    + ' data-facility-nm="' + escapeHtml(facility.facilityNm) + '"'
                    + ' data-facility-ty="' + escapeHtml(facility.facilityTyNm) + '"'
                    + ' data-loc-cn="' + escapeHtml(facility.locCn) + '"'
                    + ' data-use-yn="' + escapeHtml(useYn) + '"'
                    + ' data-instl-dt="' + escapeHtml(facility.instlDt) + '">'
                    + '    <td>' + escapeHtml(facility.facilityNo) + '</td>'
                    + '    <td class="td-left">' + escapeHtml(facility.facilityNm) + '</td>'
                    + '    <td>' + escapeHtml(facility.facilityTyNm) + '</td>'
                    + '    <td class="td-left">' + escapeHtml(facility.locCn) + '</td>'
                    + '    <td>' + useText + '</td>'
                    + '    <td><button type="button" class="btn select-facility-btn">선택</button></td>'
                    + '</tr>';
            }).join("");
        }

        /** 협력업체 선택 모달 행 렌더링 함수 */
        function renderPartnerRows(partnerList) {
            var tbody = $("partnerModalTbody");
            if (!tbody) return;

            if (!partnerList || partnerList.length === 0) {
                tbody.innerHTML = '<tr><td colspan="6">검색된 협력업체가 없습니다.</td></tr>';
                return;
            }

            tbody.innerHTML = partnerList.map(function (partner) {
                return ''
                    + '<tr class="partner-modal-row"'
                    + ' data-key="' + escapeHtml([partner.partnerNo, partner.partnerNm, partner.bizTyNm, partner.picNm, partner.picTelno].join(" ")) + '"'
                    + ' data-partner-no="' + escapeHtml(partner.partnerNo) + '"'
                    + ' data-partner-nm="' + escapeHtml(partner.partnerNm) + '"'
                    + ' data-biz-ty="' + escapeHtml(partner.bizTyNm) + '"'
                    + ' data-pic-nm="' + escapeHtml(partner.picNm) + '"'
                    + ' data-pic-telno="' + escapeHtml(partner.picTelno) + '"'
                    + ' data-pic-email="' + escapeHtml(partner.picEmail) + '">'
                    + '    <td>' + escapeHtml(partner.partnerNo) + '</td>'
                    + '    <td class="td-left">' + escapeHtml(partner.partnerNm) + '</td>'
                    + '    <td>' + escapeHtml(partner.bizTyNm) + '</td>'
                    + '    <td>' + escapeHtml(partner.picNm) + '</td>'
                    + '    <td>' + escapeHtml(partner.picTelno) + '</td>'
                    + '    <td><button type="button" class="btn select-partner-btn">선택</button></td>'
                    + '</tr>';
            }).join("");
        }

        /** 시설 선택 모달 서버 검색 함수 */
        function searchFacilityRows() {
            var params = buildQuery({
                facilityTyCd: $("facilityFilterType") ? $("facilityFilterType").value : "",
                dongNo: $("facilityFilterDong") ? $("facilityFilterDong").value : "",
                facilityUseYn: $("facilityFilterUseYn") ? $("facilityFilterUseYn").value : "",
                facilityLocCn: $("facilityFilterLoc") ? $("facilityFilterLoc").value : "",
                facilitySearchWord: $("facilityModalSearch") ? $("facilityModalSearch").value : ""
            });

            fetchJson(contextPath + "/manager/checkHistory/facility/search/" + encodeURIComponent(mgmtOfcNo) + (params ? "?" + params : ""))
                .then(function (data) {
                    renderFacilityRows(data && data.success ? (data.facilityList || []) : []);
                })
                .catch(function () {
                    renderFacilityRows([]);
                });
        }

        /** 협력업체 선택 모달 서버 검색 함수 */
        function searchPartnerRows() {
            var params = buildQuery({
                bizTyNm: $("partnerFilterBizTy") ? $("partnerFilterBizTy").value : "",
                partnerUseYn: $("partnerFilterUseYn") ? $("partnerFilterUseYn").value : "",
                picNm: $("partnerFilterPicNm") ? $("partnerFilterPicNm").value : "",
                partnerSearchWord: $("partnerModalSearch") ? $("partnerModalSearch").value : ""
            });

            fetchJson(contextPath + "/manager/checkHistory/partner/search/" + encodeURIComponent(mgmtOfcNo) + (params ? "?" + params : ""))
                .then(function (data) {
                    renderPartnerRows(data && data.success ? (data.partnerList || []) : []);
                })
                .catch(function () {
                    renderPartnerRows([]);
                });
        }

        /** 시설 선택 처리 함수 */
        function selectFacility(button) {
            var row = button.closest(".facility-modal-row");
            if (!row) return;

            var facilityNo = row.getAttribute("data-facility-no") || "";
            var facilityNm = row.getAttribute("data-facility-nm") || "";
            var facilityTy = row.getAttribute("data-facility-ty") || "";
            var locCn = row.getAttribute("data-loc-cn") || "";
            var useYn = row.getAttribute("data-use-yn") || "";
            var instlDt = row.getAttribute("data-instl-dt") || "";
            var useText = useYn === "Y" ? "사용" : (useYn === "N" ? "미사용" : "-");

            setValue("facilityNo", facilityNo);
            setText("facilityNoText", facilityNo);
            setText("facilityNmText", facilityNm || "시설명 없음");
            setText("facilityTyText", facilityTy);
            setText("facilityUseYnText", useText);
            setText("facilityLocText", locCn);
            setText("facilityInstlDtText", instlDt);

            switchTargetState("facilityEmptyState", "facilitySelectedState");
            hideModal("facilityModal");

            loadFacilityHistory(facilityNo);
        }

        /** 협력업체 선택 처리 함수 */
        function selectPartner(button) {
            var row = button.closest(".partner-modal-row");
            if (!row) return;

            var partnerNo = row.getAttribute("data-partner-no") || "";
            var partnerNm = row.getAttribute("data-partner-nm") || "";
            var bizTy = row.getAttribute("data-biz-ty") || "";
            var picNm = row.getAttribute("data-pic-nm") || "";
            var picTelno = row.getAttribute("data-pic-telno") || "";
            var picEmail = row.getAttribute("data-pic-email") || "";

            setValue("partnerNo", partnerNo);
            setText("partnerNoText", partnerNo);
            setText("partnerNmText", partnerNm || "업체명 없음");
            setText("bizTyText", bizTy);
            setText("partnerPicNmText", picNm);
            setText("partnerPicTelText", picTelno);
            setText("partnerEmailText", picEmail);

            switchTargetState("partnerEmptyState", "partnerSelectedState");
            hideModal("partnerModal");
        }

        /** 클릭 이벤트 위임 함수 */
        document.addEventListener("click", function (event) {
            var openFacilityButton = event.target.closest("#openFacilityModalBtn, #reopenFacilityModalBtn");
            if (openFacilityButton) {
                showModal("facilityModal");
                return;
            }

            var openPartnerButton = event.target.closest("#openPartnerModalBtn, #reopenPartnerModalBtn");
            if (openPartnerButton) {
                showModal("partnerModal");
                return;
            }

            var facilitySearchButton = event.target.closest("#facilitySearchBtn");
            if (facilitySearchButton) {
                searchFacilityRows();
                return;
            }

            var facilityResetButton = event.target.closest("#facilitySearchResetBtn");
            if (facilityResetButton) {
                ["facilityFilterType", "facilityFilterDong", "facilityFilterUseYn", "facilityFilterLoc", "facilityModalSearch"].forEach(function (id) {
                    setValue(id, "");
                });

                searchFacilityRows();
                return;
            }

            var partnerSearchButton = event.target.closest("#partnerSearchBtn");
            if (partnerSearchButton) {
                searchPartnerRows();
                return;
            }

            var partnerResetButton = event.target.closest("#partnerSearchResetBtn");
            if (partnerResetButton) {
                ["partnerFilterBizTy", "partnerFilterUseYn", "partnerFilterPicNm", "partnerModalSearch"].forEach(function (id) {
                    setValue(id, "");
                });

                searchPartnerRows();
                return;
            }

            var selectFacilityButton = event.target.closest(".select-facility-btn");
            if (selectFacilityButton) {
                selectFacility(selectFacilityButton);
                return;
            }

            var selectPartnerButton = event.target.closest(".select-partner-btn");
            if (selectPartnerButton) {
                selectPartner(selectPartnerButton);
                return;
            }

            var historyRowButton = event.target.closest(".history-row-btn");
            if (historyRowButton) {
                var historyNo = historyRowButton.getAttribute("data-history-no") || "";
                var history = currentHistoryList.find(function (item) {
                    return item.facChkHstryNo === historyNo;
                });

                if (history) {
                    showHistoryDetail(history);
                }

                return;
            }

            var historySearchButton = event.target.closest("#historySearchBtn");
            if (historySearchButton) {
                applyHistoryFilter();
                return;
            }

            var historyResetButton = event.target.closest("#historyResetBtn");
            if (historyResetButton) {
                resetHistoryFilter();
                return;
            }

            var openFollowButton = event.target.closest("#openFollowFormBtn");
            if (openFollowButton) {
                showFollowRegisterForm();
                return;
            }

            var cancelFollowButton = event.target.closest("#cancelFollowFormBtn");
            if (cancelFollowButton) {
                if (selectedHistory) {
                    showHistoryDetail(selectedHistory);
                } else if (latestHistory) {
                    showHistoryDetail(latestHistory);
                } else {
                    showFirstRegisterForm();
                }
            }
        });

        /** 시설 모달 검색 Enter 처리 */
        var facilitySearch = $("facilityModalSearch");
        if (facilitySearch) {
            facilitySearch.addEventListener("keydown", function (event) {
                if (event.key === "Enter") {
                    event.preventDefault();
                    searchFacilityRows();
                }
            });
        }

        /** 협력업체 모달 검색 Enter 처리 */
        var partnerSearch = $("partnerModalSearch");
        if (partnerSearch) {
            partnerSearch.addEventListener("keydown", function (event) {
                if (event.key === "Enter") {
                    event.preventDefault();
                    searchPartnerRows();
                }
            });
        }

        /** 이력 검색 Enter 처리 */
        document.addEventListener("keydown", function (event) {
            if (event.key !== "Enter") return;

            var target = event.target;
            if (!target || target.id !== "historyFilterKeyword") return;

            event.preventDefault();
            applyHistoryFilter();
        });

        /** select 중복 옵션 정리 */
        removeDuplicateOptions("facilityFilterType");
        removeDuplicateOptions("facilityFilterDong");

        /** 최초 화면 상태 처리 */
        if ($("facilityNo") && $("facilityNo").value) {
            loadFacilityHistory($("facilityNo").value);
        } else {
            showHistoryFilterBar(false);
            showEmptyDetailMessage("시설을 선택하면 이력 상세 또는 첫 등록 폼이 표시됩니다.", "domain");
        }

        /* 저장 전 검증은 mngr_facility_check_form.jsp 인라인 submit 핸들러에서 처리 */
    });
})();