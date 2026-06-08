/**
 * ============================================================
 * mngr-facility-modal.js
 * 시설자산 관리 모달 전용 모듈
 *
 * 담당 범위
 * - 등록 모달 / 수정 모달 / 상세 모달
 * - 위치구분·동·층·호 처리
 * - 파일 영역 렌더·초기화
 * - 저장(등록·수정·정정)
 * - 시설유형 정정
 *
 * 공용 유틸 (escapeHtml, formatDate 등) 은 mngr-facility.js 에 선언되어 있음
 * 공유 상태 변수는 window 에 올려두고 양쪽 파일에서 접근
 *   - window._facilityState.currentFacilityNo
 *   - window._facilityState.currentFacility
 *   - window._facilityState.correctionUnlocked
 *
 * 로드 순서 (JSP)
 *   mngr-facility-grid.js → mngr-facility-modal.js → mngr-facility.js
 * ============================================================
 */

var FacilityModal = (function () {

    /* ── 공유 상태 접근 헬퍼 ────────────────────────────── */

    function state() {
        return window._facilityState;
    }

    /* ── 공용 유틸 참조 헬퍼 ────────────────────────────── */
    /*
     * 공용 유틸 함수는 mngr-facility.js 의 IIFE 안에 있으므로
     * window.FacilityUtil 로 노출된 것만 사용한다.
     * (mngr-facility.js 가 나중에 로드되므로 호출 시점에는 반드시 존재)
     */

    function util() {
        return window.FacilityUtil;
    }

    /* ── 수정 모드 ─────────────────────────────────────── */

    /**
     * 수정 모드 진입/해제
     * is-edit-mode 클래스 토글로 JSP CSS 가 잠금 문구 표시/숨김 처리
     * 시설유형 드롭다운은 기본 잠금 → 정정 버튼 클릭 후 서버 검증 통과 시 해제
     */
    function setEditMode(isEdit) {
        var page          = document.getElementById("facilityPage");
        var correctionBtn = document.getElementById("facilityCorrectionBtn");

        page.classList.toggle("is-edit-mode", isEdit);
        document.getElementById("facilityTyCd").disabled = isEdit;
        page.classList.remove("is-correction-unlocked");

        if (correctionBtn) {
            correctionBtn.style.display = "";
        }

        if (!isEdit) {
            state().correctionUnlocked = false;
        }
    }

    /* ── 파일 영역 초기화 ──────────────────────────────── */

    function clearFileAreas() {
        var fileInput       = document.getElementById("facilityFiles");
        var previewArea     = document.getElementById("facilityFilePreview");
        var manageArea      = document.getElementById("facilityFileManageList");
        var deleteFileUuids = document.getElementById("deleteFileUuids");

        if (fileInput)       fileInput.value       = "";
        if (deleteFileUuids) deleteFileUuids.value  = "";
        if (previewArea)     previewArea.innerHTML  = '<div class="file-preview-empty">선택된 사진이 없습니다.</div>';
        if (manageArea)      manageArea.innerHTML   = '<div class="file-preview-empty">기존 등록 사진은 상세 조회 후 수정 모드에서 표시됩니다.</div>';
    }

    /**
     * 시설종류에 따른 사진 수정 영역 제어
     * - 일반시설: 시설자산관리에서 사진 등록/수정 가능
     * - 편의시설: 조회만, 사진 수정은 편의시설 관리 화면에서 처리
     */
    function setFileSectionByFacilityKind(facility) {
        var fileEditSection = document.getElementById("facilityFileEditSection");
        var publicFileGuide = document.getElementById("publicFacilityFileGuide");
        var fileInput       = document.getElementById("facilityFiles");
        var isPublic        = facility && facility.facilityKind === "PUBLIC";

        if (fileEditSection) fileEditSection.style.display = isPublic ? "none" : "";
        if (publicFileGuide) publicFileGuide.style.display = isPublic ? "" : "none";

        if (fileInput && isPublic) {
            fileInput.value = "";
        }
    }

    /* ── 폼 전체 초기화 ────────────────────────────────── */

    function clearForm() {
        var page = document.getElementById("facilityPage");
        var form = document.getElementById("facilityForm");

        form.reset();
        state().currentFacilityNo  = null;
        state().currentFacility    = null;
        state().correctionUnlocked = false;

        document.getElementById("facilityNo").value  = "";
        document.getElementById("fileGroupNo").value = "";
        document.getElementById("useYn").value       = "Y";
        util().setUseYnValue("Y");
        page.classList.remove("is-correction-unlocked");

        var correctionGuide = document.getElementById("correctionGuide");
        if (correctionGuide) correctionGuide.style.display = "none";

        clearFileAreas();
        setFileSectionByFacilityKind(null);
        resetLocationFields();
    }

    /* ── 등록 모달 ─────────────────────────────────────── */

    function openRegisterModal() {
        if (util().isAdmin()) {
            util().alertMessage("관리자는 조회만 가능합니다.");
            return;
        }

        clearForm();
        document.getElementById("facilityModalTitle").textContent = "시설 등록";
        setEditMode(false);
        openModal("facilityModal");
    }

    /* ── 수정 모달 ─────────────────────────────────────── */

    function fillFacilityForm(facility) {
        document.getElementById("facilityNo").value   = facility.facilityNo   || "";
        document.getElementById("facilityNm").value   = facility.facilityNm   || "";
        document.getElementById("facilityTyCd").value = facility.facilityTyCd || "";
        document.getElementById("instlDt").value      = util().formatDate(facility.instlDt);
        document.getElementById("dongNo").value       = facility.dongNo       || "";
        document.getElementById("locCn").value        = facility.locCn        || "";
        setLocationTypeByFacility(facility);
        document.getElementById("fileGroupNo").value  = facility.fileGroupNo  || "";
        document.getElementById("useYn").value        = facility.useYn        || "Y";

        util().setUseYnValue(facility.useYn || "Y");
    }

    async function openEditModal(facilityNo) {
        if (util().isAdmin()) {
            util().alertMessage("관리자는 조회만 가능합니다.");
            return;
        }

        try {
            var url      = util().apiUrl("detail/" + encodeURIComponent(util().mgmtOfcNo()) + "/" + encodeURIComponent(facilityNo));
            var result   = await util().getJson(url);
            var facility = util().getResultFacility(result);

            clearForm();
            state().currentFacilityNo = facility.facilityNo;
            state().currentFacility   = facility;

            if (facility.facilityKind === "PUBLIC") {
                util().alertMessage("편의시설 정보와 사진은 편의시설 관리 화면에서 수정하세요.");
                openDetailModal(result);
                return;
            }

            document.getElementById("facilityModalTitle").textContent = "시설 수정";
            fillFacilityForm(facility);
            setFileSectionByFacilityKind(facility);
            renderManageFiles(result.fileList || result.attachFileList || facility.fileList || []);
            setEditMode(true);
            openModal("facilityModal");
        } catch (e) {
            console.error(e);
            util().alertMessage(e.message || "시설 수정 정보 조회 중 오류가 발생했습니다.");
        }
    }

    /* ── 위치구분·동·층·호 처리 ───────────────────────── */

    function resetSelect(select, placeholder) {
        if (!select) return;
        select.innerHTML = '<option value="">' + placeholder + '</option>';
    }

    function removeHouseholdPrefix(text) {
        return String(text || "")
            .replace(/^\s*\d+\s*층\s*/g, "")
            .replace(/^\s*\d+\s*호\s*/g, "")
            .trim();
    }

    function updateHouseholdLocationPreview() {
        var locationType = document.getElementById("locationType");
        var floorSelect  = document.getElementById("facilityFloor");
        var hoSelect     = document.getElementById("facilityHo");
        var locCn        = document.getElementById("locCn");

        if (!locationType || !locCn || locationType.value !== "HOUSEHOLD") return;

        var floor = floorSelect && floorSelect.value ? floorSelect.value + "층" : "";
        var ho    = hoSelect && hoSelect.value ? hoSelect.value + "호" : "";
        var text  = removeHouseholdPrefix(locCn.value);

        locCn.value = [floor, ho, text].filter(function (v) { return v !== ""; }).join(" ");
    }

    function setLocationRows() {
        var locationType = document.getElementById("locationType");
        var dongRow      = document.getElementById("dongLocationRow");
        var householdRow = document.getElementById("householdLocationRow");
        var dongNo       = document.getElementById("dongNo");
        var locCn        = document.getElementById("locCn");

        if (!locationType) return;

        if (locationType.value === "COMMON") {
            if (dongRow)      dongRow.style.display      = "none";
            if (householdRow) householdRow.style.display = "none";
            if (dongNo)       dongNo.value               = "";
            if (locCn) {
                locCn.placeholder = "예) 중앙광장, 지하1층 전기실, 관리동 옥상";
                locCn.value = removeHouseholdPrefix(locCn.value);
            }
            return;
        }

        if (locationType.value === "DONG") {
            if (dongRow)      dongRow.style.display      = "";
            if (householdRow) householdRow.style.display = "none";
            if (locCn) {
                locCn.placeholder = "예) 1층 로비, 옥상, EPS실";
                locCn.value = removeHouseholdPrefix(locCn.value);
            }
            return;
        }

        if (locationType.value === "HOUSEHOLD") {
            if (dongRow)      dongRow.style.display      = "";
            if (householdRow) householdRow.style.display = "";
            if (locCn) locCn.placeholder = "예) 세대 분전반, 수도계량기";
            updateHouseholdLocationPreview();
        }
    }

    function resetLocationFields() {
        var locationType = document.getElementById("locationType");
        var floorSelect  = document.getElementById("facilityFloor");
        var hoSelect     = document.getElementById("facilityHo");

        if (locationType) locationType.value = "COMMON";
        resetSelect(floorSelect, "층 선택");
        resetSelect(hoSelect, "호 선택");
        setLocationRows();
    }

    function setLocationTypeByFacility(facility) {
        var locationType = document.getElementById("locationType");
        if (!locationType) return;

        locationType.value = facility && facility.dongNo ? "DONG" : "COMMON";
        setLocationRows();
    }

    async function loadFloorList() {
        var dongNo      = document.getElementById("dongNo");
        var floorSelect = document.getElementById("facilityFloor");
        var hoSelect    = document.getElementById("facilityHo");

        resetSelect(floorSelect, "층 선택");
        resetSelect(hoSelect, "호 선택");
        updateHouseholdLocationPreview();

        if (!dongNo || !dongNo.value) return;

        var url  = util().apiUrl(
            "location/floors/"
            + encodeURIComponent(util().mgmtOfcNo())
            + "?dongNo="
            + encodeURIComponent(dongNo.value)
        );
        var list = await util().getJson(url);

        list.forEach(function (row) {
            var option       = document.createElement("option");
            option.value     = row.floor;
            option.textContent = row.floor + "층";
            floorSelect.appendChild(option);
        });
    }

    async function loadHoList() {
        var dongNo      = document.getElementById("dongNo");
        var floorSelect = document.getElementById("facilityFloor");
        var hoSelect    = document.getElementById("facilityHo");

        resetSelect(hoSelect, "호 선택");
        updateHouseholdLocationPreview();

        if (!dongNo || !dongNo.value || !floorSelect || !floorSelect.value) return;

        var url  = util().apiUrl(
            "location/rooms/"
            + encodeURIComponent(util().mgmtOfcNo())
            + "?dongNo="
            + encodeURIComponent(dongNo.value)
            + "&floor="
            + encodeURIComponent(floorSelect.value)
        );
        var list = await util().getJson(url);

        list.forEach(function (row) {
            var option       = document.createElement("option");
            option.value     = row.ho;
            option.textContent = row.ho + "호";
            hoSelect.appendChild(option);
        });
    }

    function buildLocationValue() {
        var locationType = document.getElementById("locationType");
        var dongNo       = document.getElementById("dongNo");
        var floorSelect  = document.getElementById("facilityFloor");
        var hoSelect     = document.getElementById("facilityHo");
        var locCn        = document.getElementById("locCn");

        if (!locationType || !locCn) return null;

        if (locationType.value === "COMMON") {
            if (dongNo) dongNo.value = "";
            return null;
        }

        if (locationType.value === "DONG") {
            locCn.value = removeHouseholdPrefix(locCn.value);
            return null;
        }

        if (locationType.value === "HOUSEHOLD") {
            var floor = floorSelect ? floorSelect.value : "";
            var ho    = hoSelect    ? hoSelect.value    : "";
            var text  = removeHouseholdPrefix(locCn.value);

            return [
                floor ? floor + "층" : "",
                ho    ? ho    + "호" : "",
                text
            ].filter(function (v) { return v !== ""; }).join(" ");
        }

        return null;
    }

    /* ── 저장 ──────────────────────────────────────────── */

    function makeFacilityFormData() {
        var form            = document.getElementById("facilityForm");
        var builtLocCn      = buildLocationValue();
        var formData        = new FormData(form);
        var useYnHidden     = document.getElementById("useYn");
        var deleteFileUuids = document.getElementById("deleteFileUuids");

        if (builtLocCn != null) formData.set("locCn", builtLocCn);
        if (useYnHidden)        formData.set("useYn", useYnHidden.value || "Y");

        if (state().currentFacilityNo) {
            formData.set("facilityNo", state().currentFacilityNo);
        }

        if (state().currentFacility && state().currentFacility.fileGroupNo) {
            formData.set("fileGroupNo", state().currentFacility.fileGroupNo);
        } else {
            formData.delete("fileGroupNo");
        }

        if (!formData.get("instlDt")) formData.delete("instlDt");
        if (deleteFileUuids) formData.set("deleteFileUuids", deleteFileUuids.value || "");
        formData.delete("facilityFiles");
        formData.delete("deleteFileUuids");

        return formData;
    }

    function hasFileSyncWork() {
        var fileInput       = document.getElementById("facilityFiles");
        var deleteFileUuids = document.getElementById("deleteFileUuids");

        return !!(
            (fileInput && fileInput.files && fileInput.files.length > 0)
            || (deleteFileUuids && deleteFileUuids.value)
        );
    }

    function makeFacilityFileFormData(facilityNo) {
        var fileInput       = document.getElementById("facilityFiles");
        var deleteFileUuids = document.getElementById("deleteFileUuids");
        var formData        = new FormData();

        formData.set("facilityNo", facilityNo);

        if (state().currentFacility && state().currentFacility.fileGroupNo) {
            formData.set("fileGroupNo", state().currentFacility.fileGroupNo);
        }

        if (deleteFileUuids) {
            formData.set("deleteFileUuids", deleteFileUuids.value || "");
        }

        if (fileInput && fileInput.files) {
            Array.from(fileInput.files).forEach(function (file) {
                formData.append("facilityFiles", file);
            });
        }

        return formData;
    }

    async function saveFacility(e) {
        e.preventDefault();

        if (util().isAdmin()) {
            util().alertMessage("관리자는 조회만 가능합니다.");
            return;
        }

        var facilityNm   = document.getElementById("facilityNm").value.trim();
        var facilityTyCd = document.getElementById("facilityTyCd").value;
        var isEdit       = !!state().currentFacilityNo;

        if (!facilityNm) {
            util().alertMessage("시설명을 입력하세요.");
            return;
        }

        if (!isEdit && !facilityTyCd) {
            util().alertMessage("시설유형을 선택하세요.");
            return;
        }

        try {
            var formData = makeFacilityFormData();
            var savedFacilityNo = state().currentFacilityNo;

            if (isEdit && state().correctionUnlocked) {
                await util().postJson(
                    util().apiUrl("type/correct/" + encodeURIComponent(util().mgmtOfcNo())),
                    {
                        facilityNo:   state().currentFacilityNo,
                        facilityTyCd: facilityTyCd
                    }
                );
                util().alertMessage("시설유형이 정정되었습니다.");
            } else if (isEdit) {
                // 기존 방식: 기본정보와 파일을 한 번에 전송
                // await util().postForm(util().apiUrl("update/" + encodeURIComponent(util().mgmtOfcNo())), formData);
                var updateResult = await util().postForm(util().apiUrl("update/" + encodeURIComponent(util().mgmtOfcNo())), formData);
                savedFacilityNo = updateResult.facilityNo || savedFacilityNo;
                util().alertMessage("시설 정보가 수정되었습니다.");
            } else {
                // 기존 방식: 기본정보와 파일을 한 번에 전송
                // await util().postForm(util().apiUrl("insert/" + encodeURIComponent(util().mgmtOfcNo())), formData);
                var insertResult = await util().postForm(util().apiUrl("insert/" + encodeURIComponent(util().mgmtOfcNo())), formData);
                savedFacilityNo = insertResult.facilityNo;
                util().alertMessage("시설이 등록되었습니다.");
            }

            if (savedFacilityNo && hasFileSyncWork()) {
                util().alertMessage("시설 정보가 저장되었습니다. 사진 처리를 이어서 진행합니다.");
                util().postForm(
                    util().apiUrl("file/sync/" + encodeURIComponent(util().mgmtOfcNo())),
                    makeFacilityFileFormData(savedFacilityNo)
                ).then(function () {
                    return util().loadFacilityList();
                }).catch(function (fileError) {
                    console.error(fileError);
                    util().alertMessage(fileError.message || "사진 처리 중 오류가 발생했습니다.");
                });
            }

            closeModal("facilityModal");
            setEditMode(false);
            await util().loadFacilityList();
        } catch (e) {
            console.error(e);
            util().alertMessage(e.message || "저장 중 오류가 발생했습니다.");
        }
    }

    /* ── 시설유형 정정 ─────────────────────────────────── */

    /**
     * 시설유형 정정 버튼 클릭 처리
     *
     * 1단계: 잠금 상태
     *        → GET /type/correct/check/{mgmtOfcNo}/{facilityNo} 로 연결 데이터 검증
     *        → 연결 데이터 없으면 facilityTyCd 드롭다운 잠금 해제 + 안내 문구 표시
     *        → 연결 데이터 있으면 변경 불가 메시지 표시
     *
     * 2단계: 잠금해제 상태
     *        → 저장 버튼 클릭 시 POST /type/correct/{mgmtOfcNo} 로 실제 정정 처리
     *        → saveFacility 내부에서 correctionUnlocked 플래그 기준으로 분기
     */
    async function openCorrection() {
        if (util().isAdmin()) {
            util().alertMessage("관리자는 조회만 가능합니다.");
            return;
        }

        if (!state().currentFacilityNo) return;

        if (state().correctionUnlocked) {
            util().alertMessage("시설유형 드롭다운에서 변경할 유형을 선택하고 저장하세요.");
            return;
        }

        try {
            var checkUrl = util().apiUrl(
                "type/correct/check/"
                + encodeURIComponent(util().mgmtOfcNo())
                + "/"
                + encodeURIComponent(state().currentFacilityNo)
            );
            var result = await util().getJson(checkUrl);

            if (!result.success) {
                util().alertMessage(result.message || "계약·점검·검침 데이터가 연결된 시설은 시설유형을 변경할 수 없습니다.");
                return;
            }

            state().correctionUnlocked = true;
            document.getElementById("facilityTyCd").disabled = false;
            document.getElementById("facilityPage").classList.add("is-correction-unlocked");

            var guideEl = document.getElementById("correctionGuide");
            if (guideEl) guideEl.style.display = "";

            util().alertMessage(result.message || "정정 가능한 시설입니다. 변경할 시설유형을 선택하고 저장하세요.");
        } catch (e) {
            console.error(e);
            util().alertMessage(e.message || "시설유형 정정 가능 여부 확인 중 오류가 발생했습니다.");
        }
    }

    /* ── 상세 모달 ─────────────────────────────────────── */

    function openDetailModal(result) {
        var facility = util().getResultFacility(result);
        var contract = result.latestContract  || null;
        var checks   = result.recentCheckList || [];
        var meter    = result.meterInfo       || null;

        /* 이용불가 사유 섹션 */
        var disabledSec = document.getElementById("detailDisabledSection");
        if (disabledSec) {
            if (facility.useYn === "N" && facility.latestFaultDt) {
                disabledSec.style.display = "";

                var chkUrl    = util().contextPath() + "/manager/checkHistory?facilityNo=" + encodeURIComponent(facility.facilityNo);
                var faultDate = util().formatDate(facility.latestFaultDt);
                var faultType = util().escapeHtml(facility.latestFaultTyCd || "점검");
                var reasonEl  = document.getElementById("detailDisabledReason");

                if (reasonEl) {
                    reasonEl.innerHTML = '<strong>' + faultDate + ' · ' + faultType + ' · 이상발견</strong>'
                        + ' 으로 이용불가 처리되었습니다.'
                        + '<a href="' + chkUrl + '">점검이력에서 확인 &rarr;</a>';
                }
            } else {
                disabledSec.style.display = "none";
            }
        }

        /* 기본정보 그리드 */
        document.getElementById("detailModalTitle").textContent = (facility.facilityNm || "시설") + " · 상세";

        /*
         * 상세 모달 하단 버튼 제어
         * - 일반시설: 수정하기 버튼 → 시설자산 수정 모달
         * - 편의시설: 편의시설 관리로 이동 버튼
         */
        var detailEditBtn = document.getElementById("detailEditBtn");
        if (detailEditBtn) {
            var isPublic = facility.facilityKind === "PUBLIC";
            detailEditBtn.dataset.facilityNo   = facility.facilityNo   || "";
            detailEditBtn.dataset.facilityKind = facility.facilityKind || "";
            detailEditBtn.textContent   = isPublic ? "편의시설 관리로 이동" : "수정하기";
            detailEditBtn.dataset.action = isPublic ? "goPublicFacility" : "editFromDetail";
        }

        document.getElementById("detailBasicGrid").innerHTML = ""
            + util().detailItem("시설번호",       util().escapeHtml(facility.facilityNo))
            + util().detailItem("시설명",         util().escapeHtml(facility.facilityNm))
            + util().detailItem("시설종류",       util().badge("badge-teal", facility.facilityKindNm || util().getFacilityKindText(facility.facilityKind)))
            + util().detailItem("시설유형",       util().badge("badge-blue", facility.facilityTyNm || facility.facilityTyCd || "-"))
            + util().detailItem("운영상태",       util().useYnBadge(facility.useYn))
            + util().detailItem("검침 연결 여부", util().badge("badge-gray", "추후 연동"))
            + util().detailItem("동",             util().escapeHtml(util().formatDongNo(facility.dongNo)))
            + util().detailItem("상세위치",       util().escapeHtml(facility.locCn  || "-"))
            + util().detailItem("설치일자",       util().escapeHtml(util().formatDate(facility.instlDt) || "-"));

        renderDetailFiles(result.fileList || result.attachFileList || facility.fileList || []);
        renderLatestContract(contract);
        renderRecentChecks(checks);
        renderMeterInfo(meter);
        openModal("facilityDetailModal");
    }

    /* ── 파일 렌더 ─────────────────────────────────────── */

    function getFileImageUrl(file) {
        if (file.viewUrl)  return file.viewUrl;
        if (file.fileUrl)  return file.fileUrl;
        if (file.googleId) return util().contextPath() + "/file/display/" + encodeURIComponent(file.googleId);
        return "";
    }

    /* 상세 모달 파일 목록 렌더 (읽기전용) */
    function renderDetailFiles(files) {
        var area = document.getElementById("detailFileList");
        if (!area) return;

        if (!files || files.length === 0) {
            area.innerHTML = '<div class="file-preview-empty">등록된 사진이 없습니다.</div>';
            return;
        }

        area.innerHTML = files.map(function (file) {
            var imgUrl = getFileImageUrl(file);
            var name   = file.fileOgName || file.fileSaveUuid || "시설사진";

            return '<div class="file-preview-item">'
                + (imgUrl ? '<img src="' + util().escapeHtml(imgUrl) + '" alt="' + util().escapeHtml(name) + '">' : "")
                + '<div class="file-preview-name">' + util().escapeHtml(name) + '</div>'
                + '</div>';
        }).join("");
    }

    /* 수정 모달 기존 파일 관리 영역 렌더 (삭제 체크박스 포함) */
    function renderManageFiles(files) {
        var area = document.getElementById("facilityFileManageList");
        if (!area) return;

        if (!files || files.length === 0) {
            area.innerHTML = '<div class="file-preview-empty">기존 등록 사진이 없습니다.</div>';
            return;
        }

        area.innerHTML = files.map(function (file) {
            var imgUrl = getFileImageUrl(file);
            var name   = file.fileOgName || file.fileSaveUuid || "시설사진";
            var uuid   = file.fileSaveUuid || "";

            return '<div class="file-manage-row">'
                + (imgUrl
                    ? '<img class="file-thumb" src="' + util().escapeHtml(imgUrl) + '" alt="' + util().escapeHtml(name) + '">'
                    : '<div class="file-thumb"></div>')
                + '<div class="file-info">'
                + '<div class="file-name">'  + util().escapeHtml(name) + '</div>'
                + '<div class="file-meta">'  + util().escapeHtml(file.fileExt || "image") + '</div>'
                + '</div>'
                + '<div class="file-actions">'
                + '<label class="file-delete-check">'
                + '<input type="checkbox" class="js-delete-file-check" value="' + util().escapeHtml(uuid) + '">삭제'
                + '</label>'
                + '</div>'
                + '</div>';
        }).join("");
    }

    /* ── 상세 섹션 렌더 ────────────────────────────────── */

    function renderLatestContract(contract) {
        var body = document.getElementById("detailContBody");

        if (!contract) {
            body.innerHTML = '<div class="ds-empty">등록된 계약이 없습니다.</div>';
            return;
        }

        body.innerHTML = '<div class="ds-row">'
            + '<span class="ds-no">' + util().escapeHtml(contract.contNo    || "-") + '</span>'
            + '<span class="ds-nm">' + util().escapeHtml(contract.contNm    || "-") + '</span>'
            + '<span>'               + util().codeBadge(AgRenderer.CODE.CONTRACT_STTS, contract.contSttsCd) + '</span>'
            + '<span class="ds-dt">' + util().escapeHtml(contract.partnerNm || "-") + '</span>'
            + '<span class="ds-dt">' + util().escapeHtml(util().formatDate(contract.contEndDt) || "-") + '</span>'
            + '</div>';
    }

    function renderRecentChecks(checks) {
        var body = document.getElementById("detailChkBody");

        if (!checks || !checks.length) {
            body.innerHTML = '<div class="ds-empty">점검이력이 없습니다.</div>';
            return;
        }

        body.innerHTML = checks.slice(0, 3).map(function (check) {
            return '<div class="ds-row">'
                + '<span class="ds-no">' + util().escapeHtml(check.facChkHstryNo || "-") + '</span>'
                + '<span class="ds-dt">' + util().escapeHtml(util().formatDate(check.chkDt) || "-") + '</span>'
                + '<span>'               + util().codeBadge(AgRenderer.CODE.CHECK_TY,   check.chkTyCd)   + '</span>'
                + '<span>'               + util().codeBadge(AgRenderer.CODE.CHECK_STTS, check.chkSttsCd) + '</span>'
                + '<span class="ds-nm" style="font-weight:400;color:#6b7a6e;">'
                +   util().escapeHtml(check.chkCn || "-")
                + '</span>'
                + '</div>';
        }).join("");
    }

    function renderMeterInfo(meter) {
        var body = document.getElementById("detailMeterBody");

        if (!meter) {
            body.innerHTML = '<div class="ds-empty">검침 연결 정보가 없습니다.</div>';
            return;
        }

        body.innerHTML = '<div class="ds-row">'
            + '<span class="ds-no">' + util().escapeHtml(meter.meterWrkNo   || meter.meterHstryNo || "-") + '</span>'
            + '<span class="ds-nm">' + util().escapeHtml(meter.partnerNm    || meter.providerNm   || "검침 연결") + '</span>'
            + '<span>'               + util().badge("badge-teal", meter.meterTyNm  || meter.meterTyCd  || "검침") + '</span>'
            + '<span>'               + util().badge("badge-blue", meter.meterMethodNm || meter.meterMethod || "연결") + '</span>'
            + '</div>';
    }

    /* ── change 이벤트 처리 (위치구분·동·층·호) ─────────── */
    /*
     * bindSearchEvents 는 mngr-facility.js 에 있으므로
     * 위치 관련 change 이벤트는 FacilityModal.handleChange 로 위임받아 처리
     */
    function handleChange(event) {
        if (event.target.id === "locationType") {
            setLocationRows();
            return;
        }

        if (event.target.id === "dongNo") {
            var locationType = document.getElementById("locationType");
            if (locationType && locationType.value === "HOUSEHOLD") {
                loadFloorList();
            }
            return;
        }

        if (event.target.id === "facilityFloor") {
            loadHoList();
            updateHouseholdLocationPreview();
            return;
        }

        if (event.target.id === "facilityHo") {
            updateHouseholdLocationPreview();
        }
    }

    return {
        openRegisterModal: openRegisterModal,
        openEditModal:     openEditModal,
        openDetailModal:   openDetailModal,
        saveFacility:      saveFacility,
        openCorrection:    openCorrection,
        handleChange:      handleChange
    };

})();
