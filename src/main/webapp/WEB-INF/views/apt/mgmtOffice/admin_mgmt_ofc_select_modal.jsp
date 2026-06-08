<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:if test="${isAdmin}">
    <style>
        #adminMgmtOfcModalOverlay .ofc-item {
            display: flex; align-items: center; gap: 12px;
            padding: 10px 14px; border-radius: 8px; cursor: pointer;
            border: 1px solid var(--border); margin-bottom: 6px;
            transition: .15s;
        }
        #adminMgmtOfcModalOverlay .ofc-item:hover { background: #f0f7f2; border-color: #2e5c38; }
        #adminMgmtOfcModalOverlay .ofc-item.selected { background: #f0f7f2; border-color: #2e5c38; }
        #adminMgmtOfcModalOverlay .ofc-icon {
            width: 36px; height: 36px; border-radius: 50%;
            background: #e8f0ea; color: #2e5c38;
            display: flex; align-items: center; justify-content: center;
            font-size: 15px; font-weight: 700; flex-shrink: 0;
        }
        #adminMgmtOfcModalOverlay .ofc-icon.selected-icon { background: #2e5c38; color: #fff; }
        #adminMgmtOfcModalOverlay .ofc-nm { font-size: 13px; font-weight: 700; }
        #adminMgmtOfcModalOverlay .ofc-sub { font-size: 11px; color: var(--text-tertiary); }
        #adminMgmtOfcModalOverlay .ofc-address {
            max-width: 430px; margin-top: 2px;
            font-size: 11px; color: var(--text-tertiary);
            overflow: hidden; text-overflow: ellipsis; white-space: nowrap;
        }
        #adminMgmtOfcModalOverlay .ofc-empty { text-align: center; padding: 24px; font-size: 13px; color: var(--text-tertiary); }
        #adminMgmtOfcModalOverlay .ofc-list { height: 350px; overflow-y: auto; margin-top: 10px; }
        #adminMgmtOfcModalOverlay .ofc-search-row { display:flex; gap:8px; margin-bottom:4px; align-items:center; }
        /* 검색창이 지역 필터보다 과하게 길어지지 않도록 모달 안에서만 폭 제한 */
        #adminMgmtOfcModalOverlay .ofc-search-wrap { flex: 1; max-width: 190px; }
        /* 검색 버튼 실행 후 전체 조회 건수를 작게 표시 */
        #adminMgmtOfcModalOverlay .ofc-result-summary {
            margin-top: 8px; font-size: 12px; color: var(--text-tertiary);
        }
        #adminMgmtOfcModalOverlay .ofc-result-summary strong {
            color: #2e5c38; font-weight: 800;
        }
        #adminMgmtOfcModalOverlay .paging-wrap { display: flex; justify-content: center; align-items: center; gap: 4px; margin-top: 10px; flex-wrap: wrap; }
        #adminMgmtOfcModalOverlay .paging-wrap ul { display: flex; gap: 4px; padding: 0; margin: 0; list-style: none; }
        #adminMgmtOfcModalOverlay .page-link {
            min-width: 32px; height: 32px; padding: 0 8px;
            border: 1px solid var(--border); border-radius: 6px;
            background: #fff; cursor: pointer; font-size: 12px;
            display: flex; align-items: center; justify-content: center;
            text-decoration: none; color: inherit;
            transition: .15s;
        }
        #adminMgmtOfcModalOverlay .page-link:hover { background: #f0f7f2; border-color: #2e5c38; }
        #adminMgmtOfcModalOverlay .page-item.active .page-link { background: #2e5c38; color: #fff; border-color: #2e5c38; }
        /* 선택 전후 높이가 바뀌지 않도록 항상 같은 영역을 유지 */
        #adminMgmtOfcModalOverlay .selected-info {
            margin-top: 10px; padding: 10px 14px; border-radius: 8px;
            background: #f7f8f9; border: 1px solid var(--border);
            font-size: 12px; color: var(--text-secondary);
            min-height: 42px; display: flex; align-items: center;
            overflow: hidden; text-overflow: ellipsis; white-space: nowrap;
        }
        #adminMgmtOfcModalOverlay .selected-info.visible {
            background: #f0f7f2; border-color: #b7d4bb; color: var(--text-primary);
        }
        #adminMgmtOfcModalOverlay .selected-info strong { color: #2e5c38; font-weight: 800; }
    </style>

    <div class="modal-overlay" id="adminMgmtOfcModalOverlay" style="display:none;">
        <div class="modal modal-md">
            <div class="modal-header">
                <h3>관리사무소 선택</h3>
            </div>

            <div class="modal-body">
                <div class="form-section">
                    <h4 class="form-section-title">조회할 관리사무소를 선택해 주세요.</h4>

                        <%-- 검색창 --%>
                    <div class="ofc-search-row">
                        <select class="form-select" id="adminOfcSidoFilter" style="width:125px;">
                            <option value="">전체 시도</option>
                        </select>

                        <select class="form-select" id="adminOfcSigunguFilter" style="width:135px;">
                            <option value="">전체 시군구</option>
                        </select>

                        <div class="search-wrap ofc-search-wrap">
                            <span class="material-symbols-rounded">search</span>
                            <input type="text" class="form-input" id="adminOfcSearchInput" placeholder="관리사무소명, 단지명 검색">
                        </div>
                        <button type="button" class="btn btn-primary" id="btnSearchAdminMgmtOfc">
                            검색
                        </button>
                    </div>

                    <%-- 현재 검색/지역 조건 기준 전체 조회 건수 --%>
                    <div class="ofc-result-summary" id="adminOfcResultSummary">전체 <strong>0</strong>건</div>

                        <%-- 목록 --%>
                    <div class="ofc-list" id="adminOfcList">
                        <div class="ofc-empty">목록을 불러오는 중...</div>
                    </div>

                        <%-- 페이징 --%>
                    <div class="paging-wrap" id="adminOfcPaging"></div>

                        <%-- 선택 전에도 영역을 유지해서 모달 높이 흔들림을 방지 --%>
                    <div class="selected-info" id="adminOfcSelectedInfo">조회할 관리사무소를 선택해 주세요.</div>

                    <p class="form-help" style="margin-top:10px;">
                        중앙관리자는 선택한 관리사무소 기준으로 관리사무소 화면을 조회합니다.
                    </p>
                </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-primary" id="btnSaveAdminMgmtOfc" disabled>
                    선택 완료
                </button>
            </div>
        </div>
    </div>

    <script>
        (function () {
            var adminOfcContextPath = '${pageContext.request.contextPath}';
            var adminOfcCurrentPage = 1;      // 현재 페이지
            var adminOfcPageList = [];        // 서버에서 받은 현재 페이지 목록
            var adminOfcSelectedItem = null;  // 선택한 관리사무소

            document.addEventListener('DOMContentLoaded', function () {
                var overlay = document.getElementById('adminMgmtOfcModalOverlay');
                var hasSelected = '${selectedMgmtOfcNo}';

                // 선택된 관리사무소가 없으면 모달 오픈
                if (overlay && !hasSelected) overlay.style.display = 'flex';

                bindEvents();
                loadSidoFilter();
                loadAdminOfcList(1);
            });

            function bindEvents() {
                var searchInput = document.getElementById('adminOfcSearchInput');
                var searchBtn = document.getElementById('btnSearchAdminMgmtOfc');
                var saveBtn = document.getElementById('btnSaveAdminMgmtOfc');
                /*
                 * 지역 필터 요소
                 * - 필터 값을 바꾼 뒤 검색 버튼 또는 Enter로 목록 조회
                 * - 시도 변경 시 시군구 목록만 갱신해서 목록 높이 흔들림을 줄임
                 */
                var sidoFilter = document.getElementById('adminOfcSidoFilter');
                var sigunguFilter = document.getElementById('adminOfcSigunguFilter');

                if (sidoFilter) {
                    sidoFilter.addEventListener('change', function () {
                        loadSigunguFilter(this.value);
                    });
                }

                // 검색 버튼 또는 Enter 입력 시 1페이지부터 서버 재조회
                if (searchBtn) {
                    searchBtn.addEventListener('click', function () {
                        loadAdminOfcList(1);
                    });
                }

                if (searchInput) {
                    searchInput.addEventListener('keydown', function (e) {
                        if (e.key === 'Enter') {
                            e.preventDefault();
                            loadAdminOfcList(1);
                        }
                    });
                }

                // 선택 완료 버튼
                if (saveBtn) saveBtn.addEventListener('click', saveAdminOfcSession);
            }
            // 시도 필터 목록 조회
            function loadSidoFilter() {
                var sidoFilter = document.getElementById('adminOfcSidoFilter');

                fetch(adminOfcContextPath + '/manager/admin-mgmt-ofc/sido/list')
                    .then(function (r) { return r.json(); })
                    .then(function (list) {
                        sidoFilter.innerHTML = '<option value="">전체 시도</option>';

                        list.forEach(function (sidoNm) {
                            sidoFilter.innerHTML += '<option value="' + sidoNm + '">' + sidoNm + '</option>';
                        });
                    });
            }

            // 시군구 필터 목록 조회
            function loadSigunguFilter(sidoNm) {
                var sigunguFilter = document.getElementById('adminOfcSigunguFilter');

                sigunguFilter.innerHTML = '<option value="">전체 시군구</option>';

                if (!sidoNm) return;

                fetch(adminOfcContextPath + '/manager/admin-mgmt-ofc/sigungu/list?sidoNm=' + encodeURIComponent(sidoNm))
                    .then(function (r) { return r.json(); })
                    .then(function (list) {
                        list.forEach(function (sigunguNm) {
                            sigunguFilter.innerHTML += '<option value="' + sigunguNm + '">' + sigunguNm + '</option>';
                        });
                    });
            }

            // 관리사무소 목록 서버 조회
            function loadAdminOfcList(page) {
                var searchInput = document.getElementById('adminOfcSearchInput');
                var searchWord = searchInput ? searchInput.value.trim() : '';
                    /*
                     * 현재 선택된 지역 필터값
                     * - 값이 없으면 전체 조회
                     * - 값이 있으면 서버에 조건으로 전달
                     */
                var sidoFilter = document.getElementById('adminOfcSidoFilter');
                var sigunguFilter = document.getElementById('adminOfcSigunguFilter');

                var sidoNm = sidoFilter ? sidoFilter.value : '';
                var sigunguNm = sigunguFilter ? sigunguFilter.value : '';

                adminOfcCurrentPage = page;

                fetch(adminOfcContextPath + '/manager/admin-mgmt-ofc/list?page=' + page
                    + '&searchWord=' + encodeURIComponent(searchWord)
                    + '&sidoNm=' + encodeURIComponent(sidoNm)
                    + '&sigunguNm=' + encodeURIComponent(sigunguNm), {
                    headers: { 'X-Requested-With': 'XMLHttpRequest' }
                })
                    .then(function (r) { return r.json(); })
                    .then(function (data) {
                        adminOfcPageList = data.list || [];
                        renderResultSummary(data.totalRecord || 0);
                        renderOfcList();
                        renderPaging(data.pagingHTML || '');
                    })
                    .catch(function () {
                        renderResultSummary(0);
                        document.getElementById('adminOfcList').innerHTML = '<div class="ofc-empty">목록을 불러오지 못했습니다.</div>';
                        document.getElementById('adminOfcPaging').innerHTML = '';
                    });
            }

            // 검색 결과 건수 출력: 페이징 전체 건수(totalRecord)를 표시
            function renderResultSummary(totalRecord) {
                var summaryEl = document.getElementById('adminOfcResultSummary');
                if (!summaryEl) return;

                summaryEl.innerHTML = '조회 결과 <strong>' + totalRecord + '</strong>건';
            }

            // 현재 페이지 목록 출력
            function renderOfcList() {
                var listEl = document.getElementById('adminOfcList');

                if (!adminOfcPageList || adminOfcPageList.length === 0) {
                    listEl.innerHTML = '<div class="ofc-empty">검색 결과가 없습니다.</div>';
                    return;
                }

                listEl.innerHTML = adminOfcPageList.map(function (o) {
                    var isSelected = adminOfcSelectedItem && String(adminOfcSelectedItem.mgmtOfcNo) === String(o.mgmtOfcNo);

                    return '<div class="ofc-item' + (isSelected ? ' selected' : '') + '" data-ofc-no="' + o.mgmtOfcNo + '">'
                        + '<div class="ofc-icon' + (isSelected ? ' selected-icon' : '') + '">' + (o.mgmtOfcNm ? o.mgmtOfcNm.charAt(0) : '-') + '</div>'
                        + '<div>'
                        + '<div class="ofc-nm">' + (o.mgmtOfcNm || '') + '</div>'
                        + '<div class="ofc-sub">' + (o.aptCmplexNm || '') + '</div>'
                        + '<div class="ofc-address">' + (o.dorojuso || '') + '</div>'
                        + '</div>'
                        + '</div>';
                }).join('');

                // 목록 항목 선택
                listEl.querySelectorAll('.ofc-item').forEach(function (item) {
                    item.addEventListener('click', function () {
                        var ofcNo = this.dataset.ofcNo;

                        adminOfcSelectedItem = adminOfcPageList.find(function (o) {
                            return String(o.mgmtOfcNo) === String(ofcNo);
                        });

                        updateSelectedInfo();
                        renderOfcList();
                    });
                });
            }

            // 서버에서 받은 페이징 HTML 연결
            function renderPaging(pagingHTML) {
                var pagingEl = document.getElementById('adminOfcPaging');

                pagingEl.innerHTML = pagingHTML;

                pagingEl.querySelectorAll('[data-page]').forEach(function (link) {
                    link.addEventListener('click', function (e) {
                        e.preventDefault();
                        loadAdminOfcList(parseInt(this.dataset.page, 10));
                    });
                });
            }

            // 선택한 관리사무소 표시: 기존 영역의 문구만 바꿔 모달 높이를 고정
            function updateSelectedInfo() {
                var infoEl = document.getElementById('adminOfcSelectedInfo');
                var saveBtn = document.getElementById('btnSaveAdminMgmtOfc');

                if (!adminOfcSelectedItem) {
                    infoEl.classList.remove('visible');
                    infoEl.innerHTML = '조회할 관리사무소를 선택해 주세요.';
                    if (saveBtn) saveBtn.disabled = true;
                    return;
                }

                infoEl.innerHTML = '조회 기준&nbsp;&nbsp;<strong>' + (adminOfcSelectedItem.mgmtOfcNm || '') + '</strong>'
                    + '&nbsp;·&nbsp;' + (adminOfcSelectedItem.aptCmplexNm || '');

                infoEl.classList.add('visible');
                if (saveBtn) saveBtn.disabled = false;
            }

            // 선택한 관리사무소 화면으로 이동
            function saveAdminOfcSession() {
                if (!adminOfcSelectedItem) {
                    alert('관리사무소를 선택해 주세요.');
                    return;
                }

                var csrfHeader = document.querySelector("meta[name='_csrf_header']");
                var csrfToken = document.querySelector("meta[name='_csrf']");
                var headers = { 'Content-Type': 'application/json' };

                if (csrfHeader && csrfToken) headers[csrfHeader.content] = csrfToken.content;

                fetch(adminOfcContextPath + '/manager/admin-mgmt-ofc/select', {
                    method: 'POST',
                    headers: headers,
                    body: JSON.stringify({ mgmtOfcNo: adminOfcSelectedItem.mgmtOfcNo })
                })
                    .then(function (r) { return r.json(); })
                    .then(function (data) {
                        if (data.success) {
                            location.href = adminOfcContextPath + '/manager/main/' + data.mgmtOfcNo;
                            return;
                        }

                        alert(data.message || '관리사무소 선택 저장에 실패했습니다.');
                    })
                    .catch(function () {
                        alert('관리사무소 선택 저장 중 오류가 발생했습니다.');
                    });
            }
        })();
    </script>
</c:if>
