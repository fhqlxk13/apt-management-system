<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>관리사무소</title>
  <sec:csrfMetaTags/>

  <!-- 외부 글꼴 / 아이콘 -->
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
  <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet" />

  <!-- 공통 레이아웃 / 관리사무소 공통 CSS -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/office-layout.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/manager-common.css">

  <!-- AG Grid 공통 CSS / JS -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/ag-grid.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/ag-theme-alpine.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/manager-agGrid.css">

  <!-- 방문 차량 관리 화면 전용 CSS -->
  <style>
    #residentCarTable { table-layout: fixed; width: 100%; }
    #residentCarTable th, #residentCarTable td { text-align: center; vertical-align: middle; white-space: nowrap; }
    #residentCarTable .td-name { text-align: center; font-weight: 700; }
    #residentCarTable .td-car-name { text-align: center; }
    #residentCarTable .td-car-no { font-family: monospace; letter-spacing: -0.02em; }
    #residentCarTable .td-empty { padding: 34px 12px; color: var(--text-tertiary); text-align: center; }
    #residentCarTable .col-dong { width: 6%; }
    #residentCarTable .col-ho { width: 9%; }
    #residentCarTable .col-name { width: 11%; }
    #residentCarTable .col-type { width: 10%; }
    #residentCarTable .col-car-name { width: 14%; }
    #residentCarTable .col-car-no { width: 10%; }
    #residentCarTable .col-visit-date { width: 20%; }
    #residentCarTable .col-stay { width: 7%; }
    #residentCarTable .col-action { width: 16%; }
    #residentCarTable .grid-actions {
      display: flex;
      justify-content: center;
      align-items: center;
      gap: 4px;
      flex-wrap: nowrap;
    }

    .td-date {
      white-space: nowrap;
      font-size: 13px;
    }

    .delete-alert-box { display: flex; gap: 10px; padding: 14px 16px; background: #fff0f0; border: 1px solid #e0a8a8; border-radius: 8px; margin-bottom: 16px; }
    .delete-alert-box .material-symbols-rounded { color: #991b1b; font-size: 20px; flex-shrink: 0; margin-top: 1px; }
    .delete-alert-text { font-size: 13px; color: #7f1d1d; line-height: 1.6; }
  </style>

  <script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.20/index.global.min.js"></script>
  <script src="${pageContext.request.contextPath}/js/manager/ag-grid-community.min.js"></script>
  <script src="${pageContext.request.contextPath}/js/manager/manager-common.js"></script>
  <script src="${pageContext.request.contextPath}/js/manager/manager-agGrid.js"></script>
</head>

<body>
<div class="app-wrapper">
  <%@ include file="/WEB-INF/views/include/office_sidebar.jsp" %>

  <div class="main-wrap">
    <%@ include file="/WEB-INF/views/include/office_header.jsp" %>

    <main class="main-content">
      <div class="office-page" id="residentCarPage">

        <div class="page-header">
          <div class="page-title-block">
            <h2>방문 차량 관리</h2>
            <p>세대별 방문 차량 정보를 조회하고 관리합니다.</p>
          </div>


        </div>

        <!-- 검색 조건 -->
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
                <label class="field-label">동</label>
                <input type="text" class="form-input" id="filterDong" placeholder="예: 101동">
              </div>

              <div class="form-field">
                <label class="field-label">호수</label>
                <input type="text" class="form-input" id="filterHo" placeholder="예: 1203호">
              </div>
            </div>

            <div class="form-row cols-1">
              <div class="form-field">
                <label class="field-label">검색어</label>
                <div class="input-with-btn">
                  <input type="text" class="form-input" id="filterKeyword" placeholder="입주민명, 차량번호, 차량명 검색">
                  <button type="button" class="btn btn-primary" data-action="search">검색</button>
                  <button type="button" class="btn btn-secondary" data-action="resetFilter">초기화</button>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- 목록 -->
        <div class="panel">
          <div class="panel-header">
            <h3 class="panel-title">
              <span class="material-symbols-rounded">directions_car</span>
              등록 차량 목록
            </h3>
            <span class="list-count" id="carListCount">0건</span>
          </div>

          <div class="table-wrap">
            <table class="tbl tbl-fixed" id="residentCarTable">
              <colgroup>
                <col class="col-dong">
                <col class="col-ho">
                <col class="col-name">
                <col class="col-type">
                <col class="col-car-name">
                <col class="col-car-no">
                <col class="col-visit-date">
                <col class="col-stay">
                <col class="col-action">
              </colgroup>

              <thead>
              <tr>
                <th>동</th>
                <th>호수</th>
                <th>입주민명</th>
                <th>차량유형</th>
                <th>방문자명</th>
                <th>차량번호</th>
                <th>방문일시</th>
                <th>체류시간</th>
                <th>관리</th>
              </tr>
              </thead>

              <tbody id="carTableBody"></tbody>
            </table>
          </div>
        </div>

        <!-- 등록/상세/수정 모달 -->
        <div class="modal-overlay" id="residentCarModal">
          <div class="modal modal-md">
            <div class="modal-header primary">
              <h3 class="modal-title" id="residentCarModalTitle">차량 등록</h3>
              <button type="button" class="modal-close" data-action="closeModal">
                <span class="material-symbols-rounded">close</span>
              </button>
            </div>

            <form id="residentCarForm">

              <input type="hidden"
                     name="vstVhclRsvtNo"
                     id="vstVhclRsvtNo">

              <div class="modal-body">
                <div class="form-section">
                  <div class="form-section-title">
                    <span class="material-symbols-rounded">home</span>
                    세대 정보
                  </div>

                  <div class="form-row cols-2">
                    <div class="form-field">
                      <label class="field-label">동 <span class="req">*</span></label>
                      <input type="text" class="form-input" name="dong" placeholder="예: 101동">
                    </div>

                    <div class="form-field">
                      <label class="field-label">호수 <span class="req">*</span></label>
                      <input type="text" class="form-input" name="ho" placeholder="예: 1203호">
                    </div>
                  </div>

                  <div class="form-row cols-1">
                    <div class="form-field">
                      <label class="field-label">방문자명 <span class="req">*</span></label>
                      <input type="text" class="form-input" name="userNm">
                    </div>
                  </div>
                </div>

                <div class="form-section">
                  <div class="form-section-title">
                    <span class="material-symbols-rounded">directions_car</span>
                    차량 정보
                  </div>

                  <div class="form-row cols-2">


                    <div class="form-field">
                      <label class="field-label">차량번호 <span class="req">*</span></label>
                      <input type="text" class="form-input" name="vstVhclNo" placeholder="예: 12가 3456">
                    </div>
                  </div>

                  <div class="form-row cols-1">
                    <div class="form-field">
                      <label class="field-label">차량명</label>
                      <input type="text" class="form-input" name="vstrNm" placeholder="예: 현대 아반떼">
                    </div>
                  </div>
                </div>
              </div>

              <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-action="closeModal">닫기</button>
                <button type="button" class="btn btn-primary" id="carEditBtn" data-action="changeToEdit">수정하기</button>
                <button type="submit" class="btn btn-primary" id="carSaveBtn">저장</button>
              </div>
            </form>
          </div>
        </div>

        <!-- 삭제 확인 모달 -->
        <div class="modal-overlay" id="carDeleteModal">
          <div class="modal modal-sm">
            <div class="modal-header primary">
              <h3 class="modal-title">차량 등록 삭제</h3>
              <button type="button" class="modal-close" data-action="closeDeleteModal">
                <span class="material-symbols-rounded">close</span>
              </button>
            </div>

            <div class="modal-body">
              <div class="delete-alert-box">
                <span class="material-symbols-rounded">warning</span>
                <div class="delete-alert-text">
                  선택한 차량 등록 정보를 삭제하시겠습니까?<br>
                  삭제 후에는 복구할 수 없습니다.
                </div>
              </div>

              <div class="mngr-detail-grid" id="deleteTargetInfo"></div>
            </div>

            <div class="modal-footer">
              <button type="button" class="btn btn-secondary" data-action="closeDeleteModal">취소</button>
              <button type="button" class="btn btn-danger" id="carDeleteConfirmBtn">삭제</button>
            </div>
          </div>
        </div>

      </div>

      <script>
        (function () {
          /*
           * 페이지 중복 실행 방지
           * - 비동기 화면 전환 시 같은 JSP가 다시 로드되면 이벤트가 중복으로 붙을 수 있어서 막음
           */
          var page = document.getElementById("residentCarPage");
          if (!page || page.dataset.bound === "true") return;
          page.dataset.bound = "true";

          /*
           * 화면에서 자주 쓰는 요소를 변수로 잡아둠
           */
          var modal = document.getElementById("residentCarModal");
          var deleteModal = document.getElementById("carDeleteModal");
          var form = document.getElementById("residentCarForm");
          var modalTitle = document.getElementById("residentCarModalTitle");
          var saveBtn = document.getElementById("carSaveBtn");
          var editBtn = document.getElementById("carEditBtn");
          var tbody = document.getElementById("carTableBody");
          var listCount = document.getElementById("carListCount");
          var deleteConfirmBtn = document.getElementById("carDeleteConfirmBtn");



          var rowData = [
            <c:forEach items="${vehicleList}" var="vehicle" varStatus="st">
            {
              vstVhclRsvtNo : "${vehicle.vstVhclRsvtNo}",
              dong          : "${vehicle.dong}",
              ho            : "${vehicle.ho}",
              userNm        : "${vehicle.userNm}",
              vstVhclTyCd   : "${vehicle.vstVhclTyCd}",
              vstVhclNo     : "${vehicle.vstVhclNo}",
              vstrNm        : "${vehicle.vstrNm}",
              vstYmd        : "<fmt:formatDate value='${vehicle.vstYmd}' pattern='yyyy-MM-dd' />",
              stayHr        : "${vehicle.stayHr}"
            }<c:if test="${!st.last}">,</c:if>
            </c:forEach>
          ];

          var deleteTargetIdx = null;

          var currentMode = "create";

          /*
           * 차량 유형 코드 표시용
           * - DB에는 GEN/WRK/DLV/MOV/EMG 코드가 들어가고 화면에서는 한글명으로 보여줌
           */
          var VHCL_TY_TEXT = {
            SEDAN: "승용차",
            SUV: "SUV",
            VAN: "승합차",
            LIGHT_TRUCK: "소형트럭",
            TRUCK: "트럭",
            BIKE: "오토바이"
          };

          /*
           * 차량 유형별 뱃지 색상 클래스
           * - 실제 색상은 manager-common.css의 badge 클래스에서 관리
           */
          var VHCL_TY_BADGE = {
            SEDAN: "badge-gray",
            SUV: "badge-blue",
            VAN: "badge-yellow",
            LIGHT_TRUCK: "badge-green",
            TRUCK: "badge-red",
            BIKE: "badge-purple"
          };

          /*
           * 차량 유형 뱃지 HTML 생성
           */
          function vhclBadge(code) {
            return '<span class="badge ' + (VHCL_TY_BADGE[code] || "badge-gray") + '">'
                    + (VHCL_TY_TEXT[code] || "-")
                    + '</span>';
          }

          /*
           * 목록 테이블 렌더링
           * - 전달받은 data 배열을 tbody 안에 tr/td로 만들어 넣음
           * - 검색 결과가 없으면 안내 문구 출력
           */
          function renderTable(data) {
            listCount.textContent = data.length + "건";

            if (data.length === 0) {
              tbody.innerHTML =
                      '<tr>' +
                      '<td colspan="9" class="td-empty">등록된 차량이 없습니다.</td>' +
                      '</tr>';
              return;
            }

            tbody.innerHTML = data.map(function (row, idx) {
              return '<tr>'
                      + '<td>' + row.dong + '</td>'
                      + '<td>' + row.ho + '</td>'
                      + '<td class="td-name">' + row.userNm + '</td>'
                      + '<td>' + vhclBadge(row.vstVhclTyCd) + '</td>'
                      + '<td class="td-car-name">' + (row.vstrNm || "-") + '</td>'
                      + '<td class="td-car-no">' + row.vstVhclNo + '</td>'
                      + '<td class="td-date">'
                      + (row.vstYmd || '-')
                      + '</td>'
                      + '<td>' + (row.stayHr || "-") + '시간</td>'

                      + '<td>'
                      + '<div class="grid-actions">'
                      + '<button type="button" class="btn btn-xs btn-delete" data-action="delete" data-idx="' + idx + '">삭제</button>'
                      + '</div>'
                      + '</td>'
                      + '</tr>';
            }).join("");
          }

          /*
           * 검색 조건에 맞는 데이터만 걸러내는 함수
           * - 현재는 rowData 샘플 배열에서 필터링
           * - DB 연결 후에는 서버 검색으로 바꿀 수 있음
           */
          function getFiltered() {
            var dong = document.getElementById("filterDong").value.trim();
            var ho = document.getElementById("filterHo").value.trim();
            var keyword = document.getElementById("filterKeyword").value.trim();

            return rowData.filter(function (row) {

              return (!dong || row.dong.indexOf(dong) > -1)
                      && (!ho || row.ho.indexOf(ho) > -1)

                      && (!keyword
                              || row.userNm.indexOf(keyword) > -1
                              || row.vstVhclNo.indexOf(keyword) > -1
                              || (row.vstrNm || "").indexOf(keyword) > -1);
            });
          }

          /*
           * 검색 조건 초기화
           * - 필터 input/select 값을 모두 비우고 전체 목록 다시 출력
           */
          function resetFilter() {
            [

              "filterDong",
              "filterHo",
              "filterKeyword"
            ].forEach(function (id) {
              document.getElementById(id).value = "";
            });

            renderTable(rowData);
          }

          /*
           * 등록/상세/수정 모달 열기
           *
           * register : 빈 폼 + 저장 버튼
           * detail   : 값 채움 + 입력 비활성화 + 수정하기 버튼
           * edit     : 값 채움 + 입력 가능 + 저장 버튼
           */
          function openModal(mode, idx) {


            currentMode = mode;

            form.reset();
            setFormDisabled(false);

            saveBtn.style.display = "inline-flex";
            editBtn.style.display = "none";
            editBtn.removeAttribute("data-idx");

            if (mode === "register") {
              modalTitle.textContent = "차량 등록";
            }



            if (mode === "edit" && idx !== undefined) {
              modalTitle.textContent = "차량 수정";
              fillForm(rowData[idx]);
            }

            modal.classList.add("open");
          }

          /*
           * 선택한 행 데이터를 모달 폼에 넣는 함수
           */
          function fillForm(row) {
            form.vstVhclRsvtNo.value =
                    row.vstVhclRsvtNo || "";

            form.dong.value = row.dong || "";
            form.ho.value = row.ho || "";
            form.userNm.value = row.userNm || "";
            form.vstVhclTyCd.value = row.vstVhclTyCd || "GEN";
            form.vstVhclNo.value = row.vstVhclNo || "";
            form.vstrNm.value = row.vstrNm || "";
          }

          /*
           * 상세 모드일 때 input/select 수정 못 하게 막는 함수
           */
          function setFormDisabled(disabled) {
            form.querySelectorAll("input, select").forEach(function (el) {
              el.disabled = disabled;
            });
          }

          /*
           * 등록/상세/수정 모달 닫기
           */
          function closeModal() {
            modal.classList.remove("open");
          }

          /*
           * 삭제 확인 모달 열기
           * - 선택한 차량 정보를 삭제 확인 모달 안에 표시
           */
          function openDeleteModal(idx) {
            deleteTargetIdx = idx;
            var row = rowData[idx];

            document.getElementById("deleteTargetInfo").innerHTML =
                    '<div class="mngr-detail-item"><div class="mngr-detail-label">입주민</div><div class="mngr-detail-value">' + row.userNm + '</div></div>'
                    + '<div class="mngr-detail-item"><div class="mngr-detail-label">세대</div><div class="mngr-detail-value">' + row.dong + ' ' + row.ho + '</div></div>'
                    + '<div class="mngr-detail-item"><div class="mngr-detail-label">차량번호</div><div class="mngr-detail-value">' + row.vstVhclNo + '</div></div>'
                    + '<div class="mngr-detail-item"><div class="mngr-detail-label">차량명</div><div class="mngr-detail-value">' + (row.vstrNm || "-") + '</div></div>';

            deleteModal.classList.add("open");
          }

          /*
           * 삭제 확인 모달 닫기
           */
          function closeDeleteModal() {
            deleteModal.classList.remove("open");
            deleteTargetIdx = null;
          }

          /*
           * 페이지 내부 버튼 클릭 이벤트
           * - data-action 값으로 어떤 버튼인지 구분
           * - inline onclick 대신 이벤트 위임 방식 사용
           */
          page.addEventListener("click", function (e) {
            var btn = e.target.closest("[data-action]");
            if (!btn) return;

            var action = btn.dataset.action;
            var idx = btn.dataset.idx !== undefined ? Number(btn.dataset.idx) : undefined;

            if (action === "closeModal") closeModal();
            if (action === "delete") openDeleteModal(idx);
            if (action === "closeDeleteModal") closeDeleteModal();
            if (action === "search") renderTable(getFiltered());
            if (action === "resetFilter") resetFilter();
          });

          /*
           * 삭제 확인 버튼 처리
           * - 현재는 샘플 배열에서 제거
           * - DB 연결 후에는 삭제 Controller 호출로 변경
           */
          deleteConfirmBtn.addEventListener("click", function () {

            if (deleteTargetIdx === null) return;

            var row = rowData[deleteTargetIdx];

            location.href =
                    "${pageContext.request.contextPath}"
                    + "/manager/visit-vehicle/delete"
                    + "?vstVhclRsvtNo="
                    + row.vstVhclRsvtNo
                    + "&mgmtOfcNo=${mgmtOfcNo}";
          });
          /*
           * 등록/상세/수정 모달 바깥 영역 클릭 시 닫기
           */
          modal.addEventListener("click", function (e) {
            if (e.target === modal) {
              closeModal();
            }
          });

          /*
           * 삭제 모달 바깥 영역 클릭 시 닫기
           */
          deleteModal.addEventListener("click", function (e) {
            if (e.target === deleteModal) {
              closeDeleteModal();
            }
          });

          /*
           * 저장 버튼 처리
           * - 현재는 화면 확인용 alert
           * - DB 연결 시 fetch 또는 일반 form submit으로 변경
           */
          form.addEventListener("submit", function () {

            if (currentMode === "create") {

              form.action =
                      "${pageContext.request.contextPath}/manager/visit-vehicle/register";

            } else {

              form.action =
                      "${pageContext.request.contextPath}/manager/visit-vehicle/update";
            }

            form.method = "post";
          });
          /*
           * 화면 처음 열릴 때 목록 출력
           */
          renderTable(rowData);
        })();


      </script>
    </main>
  </div>
</div>
</body>
</html>
