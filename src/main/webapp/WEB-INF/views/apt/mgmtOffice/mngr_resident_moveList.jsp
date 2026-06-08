<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>입주/퇴거 관리</title>
  <sec:csrfMetaTags/>

  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
  <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet" />

  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/office-layout.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/manager-common.css">

  <style>
    #residentMoveTable {
      table-layout: fixed;
      width: 100%;
    }

    #residentMoveTable th,
    #residentMoveTable td {
      text-align: center;
      vertical-align: middle;
      white-space: nowrap;
    }

    #residentMoveTable .td-name {
      font-weight: 700;
    }

    #residentMoveTable .td-empty {
      padding: 34px 12px;
      color: var(--text-tertiary);
      text-align: center;
    }

    #residentMoveTable .col-status { width: 11%; }
    #residentMoveTable .col-dong { width: 9%; }
    #residentMoveTable .col-ho { width: 9%; }
    #residentMoveTable .col-name { width: 14%; }
    #residentMoveTable .col-tel { width: 16%; }
    #residentMoveTable .col-head { width: 10%; }
    #residentMoveTable .col-move-in { width: 12%; }
    #residentMoveTable .col-move-out { width: 12%; }
    #residentMoveTable .col-action { width: 120px; }

    #residentMoveTable .grid-actions {
      display: flex;
      justify-content: center;
      align-items: center;
      gap: 6px;
    }

    .move-summary {
      display: flex;
      flex-wrap: wrap;
      gap: 8px;
      margin: 0 0 12px;
    }

    .move-summary .badge {
      min-width: 92px;
      justify-content: center;
    }

    .modal-body .form-help {
      margin-top: 6px;
      color: var(--text-tertiary);
      font-size: 12px;
    }
  </style>

  <script src="${pageContext.request.contextPath}/js/manager/manager-common.js"></script>
</head>

<body>
<div class="app-wrapper">
  <%@ include file="/WEB-INF/views/include/office_sidebar.jsp" %>

  <div class="main-wrap">
    <%@ include file="/WEB-INF/views/include/office_header.jsp" %>

    <main class="main-content">
      <div class="office-page" id="residentMovePage">
        <script>
          window.__MGMT_OFC_NO__ = "<c:out value='${mgmtOfcNo}'/>";
          window.__CONTEXT_PATH__ = "<c:out value='${pageContext.request.contextPath}'/>";
          window.__APT_COMPLEX_NM__ = "<c:out value='${aptCmplexNm}'/>";
        </script>

        <div class="page-header">
          <div class="page-title-block">
            <h2>입주/퇴거 관리</h2>
            <p>세대의 입주, 퇴거, 세대주 상태와 입주일, 퇴거일을 관리합니다.</p>
          </div>

          <div class="page-actions">
            <button type="button" class="btn btn-secondary" data-action="reload">
              <span class="material-symbols-rounded">refresh</span>
              새로고침
            </button>
            <button type="button" class="btn btn-primary" data-action="openRegister">
              <span class="material-symbols-rounded">add</span>
              입주/퇴거 등록
            </button>
          </div>
        </div>

        <div class="move-summary" id="moveSummary">
          <span class="badge badge-gray">전체 0건</span>
          <span class="badge badge-yellow">입주대기 0건</span>
          <span class="badge badge-green">입주 0건</span>
          <span class="badge badge-red">퇴거 0건</span>
          <span class="badge badge-blue">중도퇴거 0건</span>
        </div>

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
                <label class="field-label">입주 상태</label>
                <select class="form-select" id="filterMoveStatus">
                  <option value="">전체</option>
                  <option value="WAIT">입주대기</option>
                  <option value="LIVE">입주</option>
                  <option value="OUT">퇴거</option>
                  <option value="MID">중도퇴거</option>
                </select>
              </div>

              <div class="form-field">
                <label class="field-label">세대주 여부</label>
                <select class="form-select" id="filterHeadYn">
                  <option value="">전체</option>
                  <option value="Y">세대주</option>
                  <option value="N">세대원</option>
                </select>
              </div>

              <div class="form-field">
                <label class="field-label">동</label>
                <input type="text" class="form-input" id="filterDong" placeholder="예: 101">
              </div>
            </div>

            <div class="form-row cols-3">
              <div class="form-field">
                <label class="field-label">호수</label>
                <input type="text" class="form-input" id="filterHo" placeholder="예: 1203">
              </div>

              <div class="form-field">
                <label class="field-label">입주일 시작</label>
                <input type="date" class="form-input" id="filterMoveInStart">
              </div>

              <div class="form-field">
                <label class="field-label">입주일 종료</label>
                <input type="date" class="form-input" id="filterMoveInEnd">
              </div>
            </div>

            <div class="form-row cols-1">
              <div class="form-field">
                <label class="field-label">검색어</label>
                <div class="input-with-btn">
                  <input type="text" class="form-input" id="filterKeyword"
                         placeholder="입주민명, 연락처, 호수, 동">
                  <button type="button" class="btn btn-primary" data-action="search">검색</button>
                  <button type="button" class="btn btn-secondary" data-action="resetFilter">초기화</button>
                </div>
              </div>
            </div>
          </div>
        </div>

        <div class="panel">
          <div class="panel-header">
            <h3 class="panel-title">
              <span class="material-symbols-rounded">list_alt</span>
              입주/퇴거 목록
            </h3>
            <span class="list-count" id="moveListCount">0건</span>
          </div>

          <div class="table-wrap">
            <table class="tbl" id="residentMoveTable">
              <colgroup>
                <col class="col-status">
                <col class="col-dong">
                <col class="col-ho">
                <col class="col-name">
                <col class="col-tel">
                <col class="col-head">
                <col class="col-move-in">
                <col class="col-move-out">
                <col class="col-action">
              </colgroup>
              <thead>
              <tr>
                <th>상태</th>
                <th>동</th>
                <th>호수</th>
                <th>입주민명</th>
                <th>연락처</th>
                <th>세대주</th>
                <th>입주일</th>
                <th>퇴거일</th>
                <th>관리</th>
              </tr>
              </thead>
              <tbody id="moveTableBody"></tbody>
            </table>
          </div>

          <div id="paginationArea"
               style="display:flex; justify-content:center; gap:6px; margin-top:20px;">
          </div>


        </div>

        <div class="modal-overlay" id="residentMoveModal">
          <div class="modal modal-md">
            <div class="modal-header primary">
              <h3 class="modal-title" id="residentMoveModalTitle">입주/퇴거 등록</h3>
              <button type="button" class="modal-close" data-action="closeModal">
                <span class="material-symbols-rounded">close</span>
              </button>
            </div>

            <form id="residentMoveForm">
              <input type="hidden" name="mgmtOfcNo" id="mgmtOfcNo" value="${mgmtOfcNo}">
              <div class="modal-body">
                <div class="form-section">
                  <div class="form-section-title">
                    <span class="material-symbols-rounded">person</span>
                    주민 정보
                  </div>

                  <div class="form-row cols-2">
                    <div class="form-field">
                      <label class="field-label">사용자 번호 <span class="req">*</span></label>
                      <input type="text" class="form-input" name="userNo" id="userNo" placeholder="예: U10000001">
                    </div>

                    <div class="form-field">
                      <label class="field-label">입주민명</label>
                      <input type="text" class="form-input" name="userNm" id="userNm" readonly>
                    </div>
                  </div>

                  <div class="form-row cols-2">
                    <div class="form-field">
                      <label class="field-label">연락처</label>
                      <input type="text" class="form-input" name="userTelno" id="userTelno" readonly>
                    </div>

                    <div class="form-field">
                      <label class="field-label">세대주 여부</label>
                      <select class="form-select" name="headYn" id="headYn">
                        <option value="Y">세대주</option>
                        <option value="N">세대원</option>
                      </select>
                    </div>
                  </div>
                </div>

                <div class="form-section">
                  <div class="form-section-title">
                    <span class="material-symbols-rounded">home</span>
                    세대 정보
                  </div>

                  <div class="form-row cols-2">
                    <div class="form-field">
                      <label class="field-label">동 <span class="req">*</span></label>
                      <input type="text" class="form-input" name="dong" id="dong" placeholder="예: 101">
                    </div>

                    <div class="form-field">
                      <label class="field-label">호수 <span class="req">*</span></label>
                      <input type="text" class="form-input" name="hoNo" id="hoNo" placeholder="예: A101-1203">
                    </div>
                  </div>
                </div>

                <div class="form-section">
                  <div class="form-section-title">
                    <span class="material-symbols-rounded">update</span>
                    입주/퇴거 상태
                  </div>

                  <div class="form-row cols-2">
                    <div class="form-field">
                      <label class="field-label">상태 <span class="req">*</span></label>
                      <select class="form-select" name="inoutCd" id="inoutCd">
                        <option value="WAIT">입주대기</option>
                        <option value="LIVE">입주</option>
                        <option value="OUT">퇴거</option>
                        <option value="MID">중도퇴거</option>
                      </select>
                    </div>

                    <div class="form-field">
                      <label class="field-label">단지명</label>
                      <input type="text" class="form-input" id="complexName" readonly>
                    </div>
                  </div>

                  <div class="form-row cols-2">
                    <div class="form-field">
                      <label class="field-label">입주일</label>
                      <input type="date" class="form-input" name="moveInDt" id="moveInDt">
                    </div>

                    <div class="form-field">
                      <label class="field-label">퇴거일</label>
                      <input type="date" class="form-input" name="moveOutDt" id="moveOutDt">
                    </div>
                  </div>

                  <div class="form-help">사용자 번호와 호수는 필수입니다. 상태에 따라 입주일과 퇴거일이 자동으로 보정됩니다.</div>
                </div>
              </div>

              <div class="modal-footer">
                <button type="button"
                        class="btn btn-danger"
                        id="moveOutBtn"
                        data-action="moveOut"
                        style="display:none;">
                  퇴거 처리
                </button>

                <button type="button"
                        class="btn btn-secondary"
                        data-action="closeModal">
                  취소
                </button>

                <button type="submit"
                        class="btn btn-primary"
                        id="residentMoveSaveBtn">
                  저장
                </button>
              </div>
            </form>
          </div>
        </div>
      </div>

      <script>
        (function () {
          var page = document.getElementById("residentMovePage");
          if (!page || page.dataset.bound === "true") return;
          page.dataset.bound = "true";
          var moveOutBtn = document.getElementById("moveOutBtn");
          var mgmtOfcNo = window.__MGMT_OFC_NO__ || "";
          var contextPath = window.__CONTEXT_PATH__ || "";
          var apiBase = contextPath + "/manager/resident/move/api/" + mgmtOfcNo;

          var modal = document.getElementById("residentMoveModal");
          var form = document.getElementById("residentMoveForm");
          var modalTitle = document.getElementById("residentMoveModalTitle");
          var tbody = document.getElementById("moveTableBody");
          var listCount = document.getElementById("moveListCount");
          var summary = document.getElementById("moveSummary");
          var saveBtn = document.getElementById("residentMoveSaveBtn");
          var moveStatusSelect = document.getElementById("inoutCd");
          var moveInInput = document.getElementById("moveInDt");
          var moveOutInput = document.getElementById("moveOutDt");
          var userNoInput = document.getElementById("userNo");
          var moveInField = moveInInput.closest(".form-field");
          var moveOutField = moveOutInput.closest(".form-field");
          var moveStatusHelp = document.createElement("div");
          var currentDetail = null;
          var currentMode = "register";

          var currentPage = 1;

          var currentHoNo = null;

          var detailModeLocked = false;

          var csrfTokenEl = document.querySelector('meta[name="_csrf"]');
          var csrfHeaderEl = document.querySelector('meta[name="_csrf_header"]');
          var csrfToken = csrfTokenEl ? csrfTokenEl.getAttribute("content") : "";
          var csrfHeader = csrfHeaderEl ? csrfHeaderEl.getAttribute("content") : "X-CSRF-TOKEN";
          var STATUS_TEXT = {
            WAIT: "\uc785\uc8fc\ub300\uae30",
            LIVE: "\uc785\uc8fc",
            OUT: "\ud1f4\uac70",
            MID: "\uc911\ub3c4\ud1f4\uac70"
          };

          var STATUS_CLASS = {
            WAIT: "badge-yellow",
            LIVE: "badge-green",
            OUT: "badge-gray",
            MID: "badge-red"
          };

          function esc(value) {
            if (value === null || value === undefined) return "";
            return String(value)
              .replace(/&/g, "&amp;")
              .replace(/</g, "&lt;")
              .replace(/>/g, "&gt;")
              .replace(/"/g, "&quot;")
              .replace(/'/g, "&#39;");
          }

          function extractDongNo(value) {
            if (!value) return "";
            var str = String(value);
            return str.indexOf("_") > -1 ? str.split("_").pop() : str;
          }

          function getDisplayHo(row) {
            return row && row.ho ? row.ho : "";
          }

          function badge(text, css) {
            return '<span class="badge ' + css + '">' + esc(text) + '</span>';
          }

          function statusBadge(code, label) {
            return badge(label || STATUS_TEXT[code] || "-", STATUS_CLASS[code] || "badge-gray");
          }

          function headBadge(yn) {
            return yn === "Y"
              ? badge("\uc138\ub300\uc8fc", "badge-blue")
              : badge("\uc138\ub300\uc6d0", "badge-gray");
          }

          moveStatusHelp.className = "form-help";
          moveStatusHelp.id = "moveStatusHelp";
          moveStatusSelect.parentNode.appendChild(moveStatusHelp);

          function getMoveStatusHelp(status) {
            if (status === "WAIT") return "\uc785\uc8fc \uc804 \uc0c1\ud0dc\uc785\ub2c8\ub2e4. \ub0a0\uc9dc\ub294 \uc800\uc7a5 \uc2dc \uc790\ub3d9\uc73c\ub85c \ube44\uc6cc\uc9d1\ub2c8\ub2e4.";
            if (status === "LIVE") return "\uc785\uc8fc \uc0c1\ud0dc\uc785\ub2c8\ub2e4. \uc785\uc8fc\uc77c\ub9cc \uad00\ub9ac\ud569\ub2c8\ub2e4.";
            if (status === "OUT") return "\ud1f4\uac70 \uc0c1\ud0dc\uc785\ub2c8\ub2e4. \uc785\uc8fc\uc77c\uacfc \ud1f4\uac70\uc77c\uc744 \ud568\uaed8 \uad00\ub9ac\ud569\ub2c8\ub2e4.";
            if (status === "MID") return "\uc911\ub3c4\ud1f4\uac70\ub294 \uc785\uc8fc\uc77c\uacfc \ud1f4\uac70\uc77c\uc744 \ud568\uaed8 \uad00\ub9ac\ud569\ub2c8\ub2e4.";
            return "";
          }

          function syncMoveFields() {
            var status = moveStatusSelect.value;
            var isWait = status === "WAIT";
            var isLive = status === "LIVE";
            var isOut = status === "OUT";
            var isMid = status === "MID";

            moveStatusHelp.textContent = getMoveStatusHelp(status);
            moveInField.style.display = isWait ? "none" : "";
            moveOutField.style.display = (isWait || isLive) ? "none" : "";

            moveInInput.readOnly = detailModeLocked || isWait;
            moveOutInput.readOnly = detailModeLocked || isWait || isLive;

            if (!detailModeLocked) {
              if (isWait) {
                moveInInput.value = "";
                moveOutInput.value = "";
              } else if (isLive) {
                moveOutInput.value = "";
              } else if (!isOut && !isMid) {
                moveOutInput.value = "";
              }
            }
          }

          function collectFilters() {
            return {
              dong: document.getElementById("filterDong").value.trim(),
              ho: document.getElementById("filterHo").value.trim(),
              moveStatus: document.getElementById("filterMoveStatus").value,
              headYn: document.getElementById("filterHeadYn").value,
              keyword: document.getElementById("filterKeyword").value.trim(),
              moveInStart: document.getElementById("filterMoveInStart").value,
              moveInEnd: document.getElementById("filterMoveInEnd").value
            };
          }

          function updateSummary(payload) {
            var list = payload.list || [];
            var waitCnt = payload.waitCnt || 0;
            var liveCnt = payload.liveCnt || 0;
            var outCnt = payload.outCnt || 0;
            var midCnt = payload.midCnt || 0;
            summary.innerHTML =
              '<span class="badge badge-gray">\uc804\uccb4 ' + list.length + '\uac74</span>' +
              '<span class="badge badge-yellow">\uc785\uc8fc\ub300\uae30 ' + waitCnt + '\uac74</span>' +
              '<span class="badge badge-green">\uc785\uc8fc ' + liveCnt + '\uac74</span>' +
              '<span class="badge badge-red">\ud1f4\uac70 ' + outCnt + '\uac74</span>' +
              '<span class="badge badge-blue">\uc911\ub3c4\ud1f4\uac70 ' + midCnt + '\uac74</span>';
          }

          function renderTable(list) {
            listCount.textContent = list.length + "\uac74";

            if (!list.length) {
              tbody.innerHTML = '<tr><td colspan="9" class="td-empty">\uc870\ud68c\ub41c \uc785\uc8fc/\ud1f4\uac70 \ub0b4\uc5ed\uc774 \uc5c6\uc2b5\ub2c8\ub2e4.</td></tr>';
              return;
            }





            tbody.innerHTML = list.map(function (row) {
              return [
                "<tr>",
                "<td>" + statusBadge(row.moveStatus, row.inoutNm) + "</td>",
                "<td>" + esc(extractDongNo(row.dong) || "-") + "</td>",
                "<td>" + esc(row.ho || "-") + "</td>",
                "<td class=\"td-name\">" + esc(row.userNm || "-") + "</td>",
                "<td>" + esc(row.userTelno || "-") + "</td>",
                "<td>" + headBadge(row.headYn) + "</td>",
                "<td>" + esc(row.moveInDt || "-") + "</td>",
                "<td>" + esc(row.moveOutDt || "-") + "</td>",
                "<td>",
                "<div class=\"grid-actions\">",
                "<button type=\"button\" class=\"btn btn-xs btn-detail\" " +
                "data-action=\"detail\" " +
                "data-user-no=\"" + esc(row.userNo) + "\" " +
                "data-ho-no=\"" + esc(row.hoNo) + "\">상세</button>",

                "<button type=\"button\" class=\"btn btn-xs btn-edit\" " +
                "data-action=\"edit\" " +
                "data-user-no=\"" + esc(row.userNo) + "\" " +
                "data-ho-no=\"" + esc(row.hoNo) + "\">수정</button>",
                "</div>",
                "</td>",
                "</tr>"
              ].join("");
            }).join("");
          }


          function renderPagination(totalCount) {

            var area = document.getElementById("paginationArea");

            var totalPage = Math.ceil(totalCount / 10);

            if (totalPage <= 1) {
              area.innerHTML = "";
              return;
            }

            var blockSize = 5;

            var startPage =
                    Math.floor((currentPage - 1) / blockSize) * blockSize + 1;

            var endPage = startPage + blockSize - 1;

            if (endPage > totalPage) {
              endPage = totalPage;
            }

            var html = "";

            // 이전 블록
            if (startPage > 1) {
              html +=
                      '<button type="button" ' +
                      'class="btn btn-secondary btn-sm" ' +
                      'data-page="' + (startPage - 1) + '">' +
                      '&lt;' +
                      '</button>';
            }

            // 숫자
            for (var i = startPage; i <= endPage; i++) {

              html +=
                      '<button type="button" ' +
                      'class="btn ' +
                      (i === currentPage ? 'btn-primary' : 'btn-secondary') +
                      '" ' +
                      'data-page="' + i + '">' +
                      i +
                      '</button>';
            }

            // 다음 블록
            if (endPage < totalPage) {
              html +=
                      '<button type="button" ' +
                      'class="btn btn-secondary btn-sm" ' +
                      'data-page="' + (endPage + 1) + '">' +
                      '&gt;' +
                      '</button>';
            }

            area.innerHTML = html;
          }

          function resetForm() {
            currentHoNo = null;
            detailModeLocked = false;
            form.reset();


            document.getElementById("mgmtOfcNo").value = mgmtOfcNo;
            document.getElementById("complexName").value = window.__APT_COMPLEX_NM__ || "";
            document.getElementById("userNo").readOnly = false;
            document.getElementById("userNm").readOnly = true;
            document.getElementById("userTelno").readOnly = true;
            document.getElementById("dong").readOnly = false;
            document.getElementById("hoNo").readOnly = false;
            moveStatusSelect.disabled = false;
            document.getElementById("headYn").disabled = false;
            moveInInput.readOnly = false;
            moveOutInput.readOnly = false;
            saveBtn.style.display = "inline-flex";



            moveOutBtn.style.display = "none";
            syncMoveFields();
          }

          function fillForm(row) {
            document.getElementById("userNo").value = row.userNo || "";
            document.getElementById("userNm").value = row.userNm || "";
            document.getElementById("userTelno").value = row.userTelno || "";
            document.getElementById("dong").value =
                    currentMode === "detail" ? extractDongNo(row.dong) : (row.dong || "");
            document.getElementById("hoNo").value =
                    currentMode === "detail" ? getDisplayHo(row) : (row.hoNo || row.ho || "");
            currentHoNo = row.hoNo || row.ho || "";
            moveStatusSelect.value = row.moveStatus || row.inoutCd || "WAIT";
            document.getElementById("headYn").value = row.headYn || "N";
            moveInInput.value = row.moveInDt || "";
            moveOutInput.value = row.moveOutDt || "";
            document.getElementById("complexName").value = row.complexName || window.__APT_COMPLEX_NM__ || "";
            syncMoveFields();
          }

          function setDetailMode() {
            detailModeLocked = true;
            document.getElementById("userNo").readOnly = true;
            document.getElementById("userNm").readOnly = true;
            document.getElementById("userTelno").readOnly = true;
            document.getElementById("dong").readOnly = true;
            document.getElementById("hoNo").readOnly = true;
            moveStatusSelect.disabled = true;
            document.getElementById("headYn").disabled = true;
            saveBtn.style.display = "none";
            syncMoveFields();
            moveOutBtn.style.display =
                    moveStatusSelect.value === "LIVE"
                            ? "inline-flex"
                            : "none";
          }

          function openModal(mode) {
            currentMode = mode;
            resetForm();
            if (mode === "register") {
              modalTitle.textContent = "입주/퇴거 등록";
              modal.classList.add("open");
              return;
            }
            if (mode === "edit") {
              modalTitle.textContent = "입주/퇴거 수정";
              modal.classList.add("open");
              return;
            }
            if (mode === "detail") {
              modalTitle.textContent = "입주/퇴거 상세";
              modal.classList.add("open");
            }
          }

          async function fetchList() {
            var filters = collectFilters();

            filters.currentPage = currentPage;
            var query = new URLSearchParams(filters);
            var response = await fetch(apiBase + "?" + query.toString(), {
              headers: {
                "Accept": "application/json"
              }
            });

            if (!response.ok) {
              throw new Error("목록 조회에 실패했습니다.");
            }

            return response.json();
          }

          async function loadList() {
            try {
              var payload = await fetchList();
              updateSummary(payload);
              renderTable(payload.list || []);
              renderPagination(payload.totalCount || 0);

            } catch (err) {
              console.error(err);
              tbody.innerHTML = '<tr><td colspan="9" class="td-empty">\uc870\ud68c\ub41c \uc785\uc8fc/\ud1f4\uac70 \ub0b4\uc5ed\uc774 \uc5c6\uc2b5\ub2c8\ub2e4.</td></tr>';
              listCount.textContent = "0\uac74";
            }
          }

          async function loadDetail(userNo, hoNo, mode) {
            var response = await fetch(
                    apiBase + "/"
                    + encodeURIComponent(userNo)
                    + "/"
                    + encodeURIComponent(hoNo),
                    {
              headers: {
                "Accept": "application/json"
              }
            });

            if (!response.ok) {
              throw new Error("상세 조회에 실패했습니다.");
            }

            currentDetail = await response.json();
            openModal(mode);
            fillForm(currentDetail);
            if (mode === "detail") {
              setDetailMode();
            }
            syncMoveFields();
          }

          async function saveForm() {
            var moveStatus = moveStatusSelect.value;
            var moveInDate = moveInInput.value;
            var moveOutDate = moveOutInput.value;

// 퇴거일 삭제 시 자동으로 입주 상태 변경
            if (moveStatus === "OUT" && !moveOutDate) {
              moveStatus = "LIVE";
            }

            var payload = {
              userNo: document.getElementById("userNo").value.trim(),
              userNm: document.getElementById("userNm").value.trim(),
              userTelno: document.getElementById("userTelno").value.trim(),
              dong: document.getElementById("dong").value.trim(),
              hoNo: document.getElementById("hoNo").value.trim(),
              inoutCd: moveStatus,
              headYn: document.getElementById("headYn").value,
              moveInDt: moveInDate,
              moveOutDt: moveOutDate
            };

            var method = currentMode === "edit" ? "PUT" : "POST";

            var requestUrl = apiBase;

            if (method === "PUT") {
              requestUrl += "/"
                      + encodeURIComponent(payload.userNo)
                      + "/"
                      + encodeURIComponent(currentHoNo || payload.hoNo);
            }

            var response = await fetch(requestUrl, {
              method: method,
              headers: {
                "Content-Type": "application/json",
                "Accept": "application/json",
                [csrfHeader]: csrfToken
              },
              body: JSON.stringify(payload)
            });

            var result = await response.json();
            if (!response.ok || result.success === false) {
              throw new Error(result.message || "저장에 실패했습니다.");
            }

            modal.classList.remove("open");
            await loadList();
            alert(result.message || "저장되었습니다.");
          }

          function closeModal() {
            modal.classList.remove("open");
            currentDetail = null;
          }

          page.addEventListener("click", function (e) {
            var btn =
                    e.target.closest("[data-action]") ||
                    e.target.closest("[data-page]");

            if (!btn) return;
            var action = btn.dataset.action;
            var userNo = btn.dataset.userNo;
            var hoNo = btn.dataset.hoNo;


            var pageNo = btn.dataset.page;

            if (pageNo) {

              currentPage = parseInt(pageNo);

              loadList();

              return;
            }

            if (action === "reload") {
              loadList();
            }
            if (action === "openRegister") {
              currentDetail = null;
              openModal("register");
            }
            if (action === "search") {
              loadList();
            }
            if (action === "resetFilter") {
              ["filterMoveStatus", "filterHeadYn", "filterDong", "filterHo", "filterMoveInStart", "filterMoveInEnd", "filterKeyword"]
                .forEach(function (id) {
                  document.getElementById(id).value = "";
                });
              loadList();
            }
            if (action === "closeModal") {
              closeModal();
            }
            if (action === "detail" && userNo) {
              loadDetail(userNo, hoNo, "detail").catch(function (err) {
                console.error(err);
                alert(err.message || "상세 조회에 실패했습니다.");
              });
            }
            if (action === "edit" && userNo) {
              loadDetail(userNo, hoNo, "edit").catch(function (err) {
                  console.error(err);
                  alert(err.message || "수정 화면을 열지 못했습니다.");
                });
            }
            if (action === "moveOut") {

              detailModeLocked = false;

              currentMode = "edit";

              moveStatusSelect.disabled = false;

              moveOutInput.readOnly = false;

              saveBtn.style.display = "inline-flex";
              moveOutBtn.style.display = "none";
              moveStatusSelect.value = "OUT";
              syncMoveFields();
              moveOutInput.value = new Date()
                      .toISOString()
                      .split("T")[0];


            }
          });

          modal.addEventListener("click", function (e) {
            if (e.target === modal) {
              closeModal();
            }
          });

          form.addEventListener("submit", function (e) {
            e.preventDefault();
            saveForm().catch(function (err) {
              console.error(err);
              alert(err.message || "저장에 실패했습니다.");
            });
          });


          userNoInput.addEventListener("blur", async function () {

            var userNo = userNoInput.value.trim();

            if (!userNo) {
              return;
            }

            try {

              var response = await fetch(
                      apiBase + "/member/" + encodeURIComponent(userNo),
                      {
                        headers: {
                          "Accept": "application/json"
                        }
                      }
              );

              var result = await response.json();

              if (!result.success) {

                document.getElementById("userNm").value = "";
                document.getElementById("userTelno").value = "";

                alert(result.message || "사용자를 찾을 수 없습니다.");
                return;
              }

              document.getElementById("userNm").value = result.userNm || "";
              document.getElementById("userTelno").value = result.userTelno || "";

            } catch (err) {

              console.error(err);
              alert("사용자 조회에 실패했습니다.");
            }
          });



          moveStatusSelect.addEventListener("change", function () {
            syncMoveFields();
          });
          moveOutInput.addEventListener("change", function () {

            if (!moveOutInput.value &&
                    moveStatusSelect.value === "OUT") {

              moveStatusSelect.value = "LIVE";

              syncMoveFields();
            }
          });
          loadList();
        })();
      </script>
    </main>
  </div>
</div>
</body>
</html>
