<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>관리사무소</title>

  <%-- -김보라- 단지 일정 캘린더로 복사하여 사용중. 이건 사용안하고 있어요. --%>

  <!-- Spring Security CSRF 토큰 -->
  <sec:csrfMetaTags/>

  <!-- 공통 글꼴 / 아이콘 -->
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
  <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet" />

  <!-- 공통 레이아웃 / 관리사무소 공통 CSS -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/office-layout.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/manager-common.css">

  <!-- 휴가 일정 화면 전용 CSS -->
  <style>
    #mngrVacationPage .vac-calendar { table-layout: fixed; width: 100%; }
    #mngrVacationPage .vac-calendar th { text-align: center; padding: 8px 4px; font-size: 11px; }
    #mngrVacationPage .vac-calendar td { vertical-align: top; padding: 6px 8px; height: 90px; cursor: pointer; transition: background .12s; border-right: 1px solid var(--border); border-bottom: 1px solid var(--border); }
    #mngrVacationPage .vac-calendar td:last-child { border-right: none; }
    #mngrVacationPage .vac-calendar tr:last-child td { border-bottom: none; }
    #mngrVacationPage .vac-calendar td:hover { background: #f7f8f9; }
    #mngrVacationPage .vac-calendar td.selected { background: #f0f4ff; }
    #mngrVacationPage .vac-calendar td.today .day-num { color: var(--btn-primary); font-weight: 800; }
    #mngrVacationPage .vac-calendar td.sun .day-num { color: #c0392b; }
    #mngrVacationPage .vac-calendar td.sat .day-num { color: #2980b9; }
    #mngrVacationPage .vac-calendar .day-num { font-size: 12px; font-weight: 600; margin-bottom: 4px; }
    #mngrVacationPage .vac-calendar .day-empty { cursor: default; background: #fafafa; }
    #mngrVacationPage .vac-calendar .day-empty:hover { background: #fafafa; }

    #mngrVacationPage .vac-calendar-layout { display: grid; grid-template-columns: minmax(0, 1fr) 300px; border-top: 1px solid var(--border); }
    #mngrVacationPage .vac-calendar-wrap { overflow-x: auto; border-right: 1px solid var(--border); }
    #mngrVacationPage .vac-calendar-nav { display: flex; align-items: center; gap: 10px; }
    #mngrVacationPage .vac-calendar-title { font-size: 14px; min-width: 70px; text-align: center; }

    #mngrVacationPage .vac-day-panel { display: flex; flex-direction: column; }
    #mngrVacationPage .vac-day-head { padding: 12px 16px; border-bottom: 1px solid var(--border); background: #f7f8f9; }
    #mngrVacationPage .vac-day-label { font-size: 11px; font-weight: 700; color: var(--text-tertiary); text-transform: uppercase; letter-spacing: .04em; }
    #mngrVacationPage .vac-day-date { font-size: 18px; font-weight: 800; color: var(--text-primary); margin-top: 4px; }
    #mngrVacationPage .vac-day-body { flex: 1; overflow-y: auto; padding: 12px 16px; }
    #mngrVacationPage .vac-empty-text { color: var(--text-tertiary); font-size: 12px; text-align: center; padding: 24px 0; }

    #mngrVacationPage .vac-chip { display: block; margin-bottom: 2px; padding: 2px 6px; border-radius: 3px; font-size: 10px; font-weight: 600; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
    #mngrVacationPage .vac-chip.V_ANN { background: #eef4ff; color: #2c4a8a; }
    #mngrVacationPage .vac-chip.V_HALF { background: #f5f0fa; color: #5a3a7a; }
    #mngrVacationPage .vac-chip.V_SICK { background: #fff0f0; color: #8a2020; }
    #mngrVacationPage .vac-chip.V_OFF { background: #fffbf0; color: #8a6400; }
    #mngrVacationPage .vac-chip.V_ETC { background: #f4f4f5; color: #4a5260; }

    #mngrVacationPage .day-panel-item { display: flex; align-items: center; gap: 10px; padding: 8px 0; border-bottom: 1px solid var(--border); }
    #mngrVacationPage .day-panel-item:last-child { border-bottom: none; }
    #mngrVacationPage .day-panel-nm { font-size: 13px; font-weight: 600; color: var(--text-primary); }
    #mngrVacationPage .day-panel-sub { font-size: 11px; color: var(--text-tertiary); margin-top: 1px; }

    #mngrVacationPage .vac-list-table { table-layout: fixed; width: 100%; }
    #mngrVacationPage .vac-list-table th, #mngrVacationPage .vac-list-table td { text-align: center; vertical-align: middle; white-space: nowrap; }
    #mngrVacationPage .vac-list-table .col-user { width: 14%; }
    #mngrVacationPage .vac-list-table .col-title { width: auto; }
    #mngrVacationPage .vac-list-table .col-type { width: 14%; }
    #mngrVacationPage .vac-list-table .col-period { width: 24%; }
    #mngrVacationPage .vac-list-table .col-action { width: 180px; }
    #mngrVacationPage .vac-list-table .td-title { text-align: left; overflow: hidden; text-overflow: ellipsis; }
    #mngrVacationPage .grid-actions { display: flex; justify-content: center; align-items: center; gap: 6px; flex-wrap: nowrap; }
    #mngrVacationPage .grid-actions .btn { flex-shrink: 0; }

    #mngrVacationPage .filter-type { width: 150px; }
    #mngrVacationPage .filter-keyword { width: 280px; }
  </style>

  <!-- 공통 JS -->
  <script src="${pageContext.request.contextPath}/js/manager/manager-common.js"></script>
</head>

<body>
<div class="app-wrapper">
  <%@ include file="/WEB-INF/views/include/office_sidebar.jsp" %>

  <div class="main-wrap">
    <%@ include file="/WEB-INF/views/include/office_header.jsp" %>

    <main class="main-content">
      <div class="office-page" id="mngrVacationPage">

        <div class="page-header">
          <div class="page-title-block">
            <h2>휴가 일정</h2>
            <p>관리사무소 직원의 휴가 일정을 등록하고 월별로 확인합니다.</p>
          </div>

          <div class="page-actions">
            <button type="button" class="btn btn-primary" data-action="openRegister">
              <span class="material-symbols-rounded">add</span>
              휴가 등록
            </button>
          </div>
        </div>

        <!-- 현황 카드 -->
        <div class="stat-row">
          <div class="stat-card">
            <div class="stat-icon green">
              <span class="material-symbols-rounded">event_available</span>
            </div>
            <div>
              <div class="stat-value">${vacationStat.totalCnt}</div>
              <div class="stat-label">전체 일정</div>
            </div>
          </div>

          <div class="stat-card">
            <div class="stat-icon blue">
              <span class="material-symbols-rounded">today</span>
            </div>
            <div>
              <div class="stat-value">${vacationStat.todayCnt}</div>
              <div class="stat-label">오늘 휴가</div>
            </div>
          </div>

          <div class="stat-card">
            <div class="stat-icon yellow">
              <span class="material-symbols-rounded">calendar_month</span>
            </div>
            <div>
              <div class="stat-value">${vacationStat.monthCnt}</div>
              <div class="stat-label">이번 달 일정</div>
            </div>
          </div>

          <div class="stat-card">
            <div class="stat-icon purple">
              <span class="material-symbols-rounded">group</span>
            </div>
            <div>
              <div class="stat-value">${vacationStat.vacationUserCnt}</div>
              <div class="stat-label">휴가 직원</div>
            </div>
          </div>
        </div>

        <!-- 탭 버튼 -->
        <div class="tab-bar">
          <button type="button" class="tab-btn active" data-action="changeTab" data-tab="calendar">
            <span class="material-symbols-rounded">calendar_month</span>
            달력
          </button>

          <button type="button" class="tab-btn" data-action="changeTab" data-tab="list">
            <span class="material-symbols-rounded">list_alt</span>
            전체 목록
          </button>
        </div>

        <!-- 달력 탭 -->
        <div class="tab-panel active" id="calendarTabPanel">
          <div class="panel">
            <div class="panel-header">
              <div class="panel-title">
                <span class="material-symbols-rounded">calendar_month</span>
                월간 일정
              </div>

              <div class="vac-calendar-nav">
                <button type="button" class="btn btn-sm btn-secondary" data-action="prevMonth">
                  <span class="material-symbols-rounded">chevron_left</span>
                </button>

                <strong id="calendarTitle" class="vac-calendar-title"></strong>

                <button type="button" class="btn btn-sm btn-secondary" data-action="nextMonth">
                  <span class="material-symbols-rounded">chevron_right</span>
                </button>
              </div>
            </div>

            <div class="vac-calendar-layout">
              <div class="vac-calendar-wrap">
                <table class="tbl vac-calendar">
                  <thead>
                  <tr>
                    <th style="color:#c0392b;">일</th>
                    <th>월</th>
                    <th>화</th>
                    <th>수</th>
                    <th>목</th>
                    <th>금</th>
                    <th style="color:#2980b9;">토</th>
                  </tr>
                  </thead>

                  <tbody id="calendarBody"></tbody>
                </table>
              </div>

              <div class="vac-day-panel">
                <div class="vac-day-head">
                  <div class="vac-day-label">날짜별 현황</div>
                  <div id="dayPanelDate" class="vac-day-date">날짜를 선택하세요</div>
                </div>

                <div id="dayPanelBody" class="vac-day-body">
                  <div class="vac-empty-text">
                    달력에서 날짜를 클릭하면<br>
                    해당 날의 일정이 표시됩니다.
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- 전체 목록 탭 -->
        <div class="tab-panel" id="listTabPanel">
          <div class="panel">
            <div class="panel-header">
              <div class="panel-title">
                <span class="material-symbols-rounded">list_alt</span>
                전체 휴가 목록
              </div>

              <span class="list-count" id="listCount">${vacationStat.totalCnt}건</span>
            </div>

            <div class="filter-bar">
              <select class="form-select filter-type" id="colorFilter">
                <option value="">전체 구분</option>
                <option value="V_ANN">연차/휴가</option>
                <option value="V_HALF">반차</option>
                <option value="V_SICK">병가</option>
                <option value="V_OFF">공가/경조사</option>
                <option value="V_ETC">기타 일정</option>
              </select>

              <div class="search-wrap filter-keyword">
                <span class="material-symbols-rounded">search</span>
                <input type="text" class="form-input" id="keyword" placeholder="직원명 또는 일정 제목 검색">
              </div>

              <button type="button" class="btn btn-primary" data-action="search">검색</button>
              <button type="button" class="btn btn-secondary" data-action="reset">초기화</button>
            </div>

            <div class="table-wrap">
              <table class="tbl vac-list-table">
                <colgroup>
                  <col class="col-user">
                  <col class="col-title">
                  <col class="col-type">
                  <col class="col-period">
                  <col class="col-action">
                </colgroup>

                <thead>
                <tr>
                  <th>직원</th>
                  <th>일정 제목</th>
                  <th>구분</th>
                  <th>기간</th>
                  <th>관리</th>
                </tr>
                </thead>

                <tbody>
                <c:choose>
                  <c:when test="${empty vacationList}">
                    <tr>
                      <td colspan="5" class="vac-empty-text">등록된 휴가 일정이 없습니다.</td>
                    </tr>
                  </c:when>

                  <c:otherwise>
                    <c:forEach var="vacation" items="${vacationList}">
                      <tr class="vacation-row"
                          data-vacation-schdl-no="${vacation.vacationSchdlNo}"
                          data-user-no="${vacation.userNo}"
                          data-user-nm="${vacation.userNm}"
                          data-schdl-ttl="${vacation.schdlTtl}"
                          data-color-cd="${vacation.colorCd}"
                          data-bgng-dt="<fmt:formatDate value='${vacation.schdlBgngDt}' pattern='yyyy-MM-dd'/>"
                          data-end-dt="<fmt:formatDate value='${vacation.schdlEndDt}' pattern='yyyy-MM-dd'/>">

                        <td class="td-bold">${vacation.userNm}</td>
                        <td class="td-title">${vacation.schdlTtl}</td>
                        <td>
                          <span data-color-label="${vacation.colorCd}">${vacation.colorCd}</span>
                        </td>
                        <td>
                          <fmt:formatDate value="${vacation.schdlBgngDt}" pattern="yyyy.MM.dd"/>
                          ~
                          <fmt:formatDate value="${vacation.schdlEndDt}" pattern="yyyy.MM.dd"/>
                        </td>
                        <td>
                          <div class="grid-actions">
                            <button type="button" class="btn btn-xs btn-detail" data-action="detail" data-vacation-schdl-no="${vacation.vacationSchdlNo}">상세</button>
                            <button type="button" class="btn btn-xs btn-edit" data-action="edit" data-vacation-schdl-no="${vacation.vacationSchdlNo}">수정</button>

                            <form method="post" action="${pageContext.request.contextPath}/manager/employee/vacation/delete" class="deleteForm">
                              <input type="hidden" name="vacationSchdlNo" value="${vacation.vacationSchdlNo}">
                              <button type="submit" class="btn btn-xs btn-delete">삭제</button>
                            </form>
                          </div>
                        </td>
                      </tr>
                    </c:forEach>
                  </c:otherwise>
                </c:choose>
                </tbody>
              </table>
            </div>
          </div>
        </div>

        <!-- 등록/수정 모달 -->
        <div class="modal-overlay" id="vacationModal">
          <div class="modal modal-md">
            <div class="modal-header">
              <h3 class="modal-title" id="modalTitle">휴가 등록</h3>
              <button type="button" class="modal-close" data-modal-close>
                <span class="material-symbols-rounded">close</span>
              </button>
            </div>

            <form id="vacationForm" method="post" action="${pageContext.request.contextPath}/manager/employee/vacation/insert">
              <input type="hidden" id="vacationSchdlNo" name="vacationSchdlNo">

              <div class="modal-body">
                <div class="form-section">
                  <div class="form-section-title">
                    <span class="material-symbols-rounded">person</span>
                    직원 선택
                  </div>

                  <div class="form-row cols-1">
                    <div class="form-field">
                      <label class="field-label">직원 <span class="req">*</span></label>
                      <select class="form-select" id="userNo" name="userNo" required>
                        <option value="">선택</option>
                        <c:forEach var="manager" items="${managerList}">
                          <option value="${manager.userNo}">${manager.userNm}</option>
                        </c:forEach>
                      </select>
                    </div>
                  </div>
                </div>

                <div class="form-section">
                  <div class="form-section-title">
                    <span class="material-symbols-rounded">event</span>
                    일정 정보
                  </div>

                  <div class="form-row cols-1">
                    <div class="form-field">
                      <label class="field-label">일정 제목 <span class="req">*</span></label>
                      <input type="text" class="form-input" id="schdlTtl" name="schdlTtl" placeholder="예: 홍길동 연차" required>
                    </div>
                  </div>

                  <div class="form-row cols-2">
                    <div class="form-field">
                      <label class="field-label">시작일 <span class="req">*</span></label>
                      <input type="date" class="form-input" id="schdlBgngDt" name="schdlBgngDt" required>
                    </div>

                    <div class="form-field">
                      <label class="field-label">종료일 <span class="req">*</span></label>
                      <input type="date" class="form-input" id="schdlEndDt" name="schdlEndDt" required>
                    </div>
                  </div>

                  <div class="form-row cols-1">
                    <div class="form-field">
                      <label class="field-label">일정 구분</label>
                      <select class="form-select" id="colorCd" name="colorCd">
                        <option value="V_ANN">연차/휴가</option>
                        <option value="V_HALF">반차</option>
                        <option value="V_SICK">병가</option>
                        <option value="V_OFF">공가/경조사</option>
                        <option value="V_ETC">기타 일정</option>
                      </select>
                    </div>
                  </div>
                </div>
              </div>

              <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-modal-close>취소</button>
                <button type="submit" class="btn btn-primary">저장</button>
              </div>
            </form>
          </div>
        </div>

        <!-- 상세 모달 -->
        <div class="modal-overlay" id="detailModal">
          <div class="modal modal-sm">
            <div class="modal-header">
              <h3 class="modal-title">휴가 일정 상세</h3>
              <button type="button" class="modal-close" data-modal-close>
                <span class="material-symbols-rounded">close</span>
              </button>
            </div>

            <div class="modal-body">
              <div class="mngr-detail-grid">
                <div class="mngr-detail-item">
                  <div class="mngr-detail-label">직원</div>
                  <div class="mngr-detail-value" id="detailUserNm"></div>
                </div>

                <div class="mngr-detail-item">
                  <div class="mngr-detail-label">구분</div>
                  <div class="mngr-detail-value" id="detailColorNm"></div>
                </div>

                <div class="mngr-detail-item mngr-detail-wide">
                  <div class="mngr-detail-label">일정 제목</div>
                  <div class="mngr-detail-value" id="detailSchdlTtl"></div>
                </div>

                <div class="mngr-detail-item mngr-detail-wide">
                  <div class="mngr-detail-label">기간</div>
                  <div class="mngr-detail-value" id="detailPeriod"></div>
                </div>
              </div>
            </div>

            <div class="modal-footer">
              <button type="button" class="btn btn-secondary" data-modal-close>닫기</button>
              <button type="button" class="btn btn-primary" id="detailEditBtn">수정하기</button>
            </div>
          </div>
        </div>

      </div>
    </main>
  </div>
</div>

<script>
  document.addEventListener("DOMContentLoaded", function () {
    initVacationPage();
  });

  function initVacationPage() {
    /*
     * 화면 루트 요소
     * - 이 페이지 내부에서만 이벤트가 동작하도록 기준점을 잡음
     */
    var page = document.getElementById("mngrVacationPage");
    if (!page) return;

    /*
     * 자주 쓰는 DOM 요소
     */
    var contextPath = "${pageContext.request.contextPath}";
    var vacationModal = document.getElementById("vacationModal");
    var detailModal = document.getElementById("detailModal");
    var vacationForm = document.getElementById("vacationForm");
    var calendarBody = document.getElementById("calendarBody");
    var dayPanelDate = document.getElementById("dayPanelDate");
    var dayPanelBody = document.getElementById("dayPanelBody");
    var detailEditBtn = document.getElementById("detailEditBtn");

    /*
     * 화면 상태값
     * - currentDate: 현재 보고 있는 달력 월
     * - selectedDate: 달력에서 선택한 날짜
     * - detailTargetNo: 상세 모달에서 수정으로 넘어갈 때 사용할 일정번호
     */
    var currentDate = new Date();
    var selectedDate = null;
    var detailTargetNo = null;

    /*
     * 일정 구분 코드 표시용
     */
    var COLOR_TEXT = {
      V_ANN: "연차/휴가",
      V_HALF: "반차",
      V_SICK: "병가",
      V_OFF: "공가/경조사",
      V_ETC: "기타 일정"
    };

    /*
     * 일정 구분 뱃지 클래스
     * - 실제 색상은 manager-common.css의 badge 클래스 기준
     */
    var BADGE_CLASS = {
      V_ANN: "badge badge-blue",
      V_HALF: "badge badge-purple",
      V_SICK: "badge badge-red",
      V_OFF: "badge badge-yellow",
      V_ETC: "badge badge-gray"
    };

    /*
     * 일정 구분 코드명 반환
     */
    function colorName(code) {
      return COLOR_TEXT[code] || "-";
    }

    /*
     * 일정 구분 뱃지 클래스 반환
     */
    function badgeClass(code) {
      return BADGE_CLASS[code] || "badge badge-gray";
    }

    /*
     * 목록 tr에 들어있는 data-* 속성을 JS 객체 배열로 변환
     * - 서버에서 내려준 vacationList를 화면에 렌더링한 뒤
     * - 달력과 상세/수정 모달은 이 data-* 값을 읽어서 사용
     */
    function getRows() {
      return Array.from(page.querySelectorAll(".vacation-row")).map(function (row) {
        return {
          vacationSchdlNo: row.dataset.vacationSchdlNo,
          userNo: row.dataset.userNo,
          userNm: row.dataset.userNm,
          schdlTtl: row.dataset.schdlTtl,
          colorCd: row.dataset.colorCd,
          schdlBgngDt: row.dataset.bgngDt,
          schdlEndDt: row.dataset.endDt
        };
      });
    }

    /*
     * 일정번호로 일정 1건 찾기
     */
    function findVacation(no) {
      return getRows().find(function (row) {
        return String(row.vacationSchdlNo) === String(no);
      });
    }

    /*
     * Date 객체를 yyyy-MM-dd 문자열로 변환
     */
    function toDateStr(date) {
      return date.getFullYear() + "-"
              + String(date.getMonth() + 1).padStart(2, "0") + "-"
              + String(date.getDate()).padStart(2, "0");
    }

    /*
     * 달력 렌더링
     * - 전체 목록에 있는 휴가 데이터를 기준으로 월간 달력을 그림
     */
    function renderCalendar() {
      var rows = getRows();
      var year = currentDate.getFullYear();
      var month = currentDate.getMonth();

      document.getElementById("calendarTitle").textContent =
              year + "." + String(month + 1).padStart(2, "0");

      var first = new Date(year, month, 1);
      var lastDate = new Date(year, month + 1, 0).getDate();
      var startDay = first.getDay();
      var todayStr = toDateStr(new Date());

      var html = "";
      var day = 1;

      for (var week = 0; week < 6; week++) {
        html += "<tr>";

        for (var col = 0; col < 7; col++) {
          if ((week === 0 && col < startDay) || day > lastDate) {
            html += '<td class="day-empty"></td>';
            continue;
          }

          var dateStr = toDateStr(new Date(year, month, day));
          var dayRows = rows.filter(function (row) {
            return row.schdlBgngDt <= dateStr && row.schdlEndDt >= dateStr;
          });

          var cls = [];
          if (col === 0) cls.push("sun");
          if (col === 6) cls.push("sat");
          if (dateStr === todayStr) cls.push("today");
          if (dateStr === selectedDate) cls.push("selected");

          html += '<td class="' + cls.join(" ") + '" data-date="' + dateStr + '">';
          html += '<div class="day-num">' + day + '</div>';

          dayRows.slice(0, 3).forEach(function (row) {
            html += '<span class="vac-chip ' + row.colorCd + '">' + row.userNm + '</span>';
          });

          if (dayRows.length > 3) {
            html += '<span style="font-size:10px;color:var(--text-tertiary);">+' + (dayRows.length - 3) + '건</span>';
          }

          html += "</td>";
          day++;
        }

        html += "</tr>";

        if (day > lastDate) break;
      }

      calendarBody.innerHTML = html;
    }

    /*
     * 날짜별 현황 패널 렌더링
     */
    function renderDayPanel(dateStr) {
      selectedDate = dateStr;
      renderCalendar();

      var parts = dateStr.split("-");
      dayPanelDate.textContent = parts[0] + "." + parts[1] + "." + parts[2];

      var rows = getRows().filter(function (row) {
        return row.schdlBgngDt <= dateStr && row.schdlEndDt >= dateStr;
      });

      if (rows.length === 0) {
        dayPanelBody.innerHTML = '<div class="vac-empty-text">이 날의 휴가 일정이 없습니다.</div>';
        return;
      }

      var html = "";

      rows.forEach(function (row) {
        html += '<div class="day-panel-item">'
                + '<div class="avatar avatar-sm">' + (row.userNm ? row.userNm.charAt(0) : "-") + '</div>'
                + '<div>'
                + '<div class="day-panel-nm">' + row.userNm + '</div>'
                + '<div class="day-panel-sub">' + colorName(row.colorCd) + ' · ' + row.schdlTtl + '</div>'
                + '</div>'
                + '</div>';
      });

      dayPanelBody.innerHTML = html;
    }

    /*
     * 목록의 일정 구분 코드를 한글 뱃지로 변경
     */
    function renderColorLabels() {
      page.querySelectorAll("[data-color-label]").forEach(function (el) {
        var code = el.dataset.colorLabel;

        el.textContent = colorName(code);
        el.className = badgeClass(code);
      });
    }

    /*
     * 모달 열기/닫기
     */
    function openModal(target) {
      target.classList.add("open");
    }

    function closeModals() {
      vacationModal.classList.remove("open");
      detailModal.classList.remove("open");
    }

    /*
     * 등록/수정 모달 열기
     * - 동기 방식이므로 form action만 insert/update로 바꿔줌
     */
    function openVacationModal(mode, data) {
      vacationForm.reset();
      document.getElementById("vacationSchdlNo").value = "";

      if (mode === "insert") {
        vacationForm.action = contextPath + "/manager/employee/vacation/insert";
        document.getElementById("modalTitle").textContent = "휴가 등록";
        document.getElementById("colorCd").value = "V_ANN";
      }

      if (mode === "update" && data) {
        vacationForm.action = contextPath + "/manager/employee/vacation/update";
        document.getElementById("modalTitle").textContent = "휴가 수정";

        document.getElementById("vacationSchdlNo").value = data.vacationSchdlNo;
        document.getElementById("userNo").value = data.userNo;
        document.getElementById("schdlTtl").value = data.schdlTtl;
        document.getElementById("schdlBgngDt").value = data.schdlBgngDt;
        document.getElementById("schdlEndDt").value = data.schdlEndDt;
        document.getElementById("colorCd").value = data.colorCd || "V_ANN";
      }

      openModal(vacationModal);
    }

    /*
     * 상세 모달 열기
     */
    function openDetailModal(data) {
      if (!data) return;

      detailTargetNo = data.vacationSchdlNo;

      document.getElementById("detailUserNm").textContent = data.userNm || "-";
      document.getElementById("detailColorNm").textContent = colorName(data.colorCd);
      document.getElementById("detailSchdlTtl").textContent = data.schdlTtl || "-";
      document.getElementById("detailPeriod").textContent = data.schdlBgngDt + " ~ " + data.schdlEndDt;

      openModal(detailModal);
    }

    /*
     * 목록 검색
     * - 화면에 이미 출력된 tr을 숨김/표시 처리
     */
    function searchList() {
      var colorFilter = document.getElementById("colorFilter").value;
      var keyword = document.getElementById("keyword").value.trim();
      var rows = page.querySelectorAll(".vacation-row");
      var visible = 0;

      rows.forEach(function (row) {
        var matchColor = !colorFilter || row.dataset.colorCd === colorFilter;
        var matchKeyword = !keyword
                || row.dataset.userNm.indexOf(keyword) > -1
                || row.dataset.schdlTtl.indexOf(keyword) > -1;

        var show = matchColor && matchKeyword;

        row.style.display = show ? "" : "none";

        if (show) visible++;
      });

      document.getElementById("listCount").textContent = visible + "건";
    }

    /*
     * 검색 조건 초기화
     */
    function resetSearch() {
      document.getElementById("colorFilter").value = "";
      document.getElementById("keyword").value = "";

      page.querySelectorAll(".vacation-row").forEach(function (row) {
        row.style.display = "";
      });

      document.getElementById("listCount").textContent = "${vacationStat.totalCnt}건";
    }

    /*
     * 화면 내부 클릭 이벤트
     */
    page.addEventListener("click", function (event) {
      if (event.target.closest("[data-modal-close]")) {
        closeModals();
        return;
      }

      var dateCell = event.target.closest("td[data-date]");
      if (dateCell) {
        renderDayPanel(dateCell.dataset.date);
        return;
      }

      var btn = event.target.closest("[data-action]");
      if (!btn) return;

      var action = btn.dataset.action;

      if (action === "changeTab") {
        var tab = btn.dataset.tab;

        page.querySelectorAll(".tab-btn").forEach(function (tabBtn) {
          tabBtn.classList.toggle("active", tabBtn.dataset.tab === tab);
        });

        document.getElementById("calendarTabPanel").classList.toggle("active", tab === "calendar");
        document.getElementById("listTabPanel").classList.toggle("active", tab === "list");

        return;
      }

      if (action === "openRegister") {
        openVacationModal("insert");
        return;
      }

      if (action === "prevMonth") {
        currentDate.setMonth(currentDate.getMonth() - 1);
        renderCalendar();
        return;
      }

      if (action === "nextMonth") {
        currentDate.setMonth(currentDate.getMonth() + 1);
        renderCalendar();
        return;
      }

      if (action === "detail") {
        openDetailModal(findVacation(btn.dataset.vacationSchdlNo));
        return;
      }

      if (action === "edit") {
        openVacationModal("update", findVacation(btn.dataset.vacationSchdlNo));
        return;
      }

      if (action === "search") {
        searchList();
        return;
      }

      if (action === "reset") {
        resetSearch();
      }
    });

    /*
     * 상세 모달의 수정하기 버튼
     */
    detailEditBtn.addEventListener("click", function () {
      var data = findVacation(detailTargetNo);
      closeModals();
      openVacationModal("update", data);
    });

    /*
     * 삭제 form submit 전 확인
     * - 동기 방식이므로 확인 후 form submit 그대로 진행
     */
    page.querySelectorAll(".deleteForm").forEach(function (form) {
      form.addEventListener("submit", function (event) {
        mgmtOfficeConfirmSubmit(event, {
          title: "선택한 휴가 일정을 삭제하시겠습니까?",
          confirmText: "삭제",
          confirmColor: "#c0392b"
        });
      });
    });

    /*
     * 저장 form submit 전 날짜 검증
     * - 검증 통과 시 일반 submit으로 Controller 이동
     */
    vacationForm.addEventListener("submit", function (event) {
      var bgngDt = document.getElementById("schdlBgngDt").value;
      var endDt = document.getElementById("schdlEndDt").value;

      if (bgngDt > endDt) {
        alert("종료일은 시작일보다 빠를 수 없습니다.");
        event.preventDefault();
      }
    });

    /*
     * 초기 실행
     */
    renderColorLabels();
    renderCalendar();
  }
</script>
</body>
</html>