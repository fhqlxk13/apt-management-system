<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>시설관리이력 – 대덕아파트</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/headerStyle.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebarStyle.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footerStyle.css">

  <style>
    body {
      font-family: 'Noto Sans KR', sans-serif !important;
      background: var(--bg);
      color: var(--text-dark);
      margin: 0;
    }

    .material-symbols-outlined {
      font-family: 'Material Symbols Outlined' !important;
    }

    .main-shell {
      display: flex;
      align-items: stretch;
      width: 100%;
      min-height: calc(100vh - 114px);
      margin-top: 114px;
      background: var(--bg);
    }

    .content-area {
      flex: 1;
      min-width: 0;
      padding: 32px 40px 64px;
    }

    .page-content-wrap {
      max-width: 1080px;
      width: 100%;
      margin: 0 auto;
    }

    .breadcrumb {
      display: flex;
      align-items: center;
      gap: 6px;
      font-size: 12px;
      color: var(--text-light);
      margin-bottom: 18px;
    }

    .breadcrumb a {
      color: var(--text-light);
      text-decoration: none;
    }

    .breadcrumb .cur {
      color: var(--green-dark);
      font-weight: 700;
    }

    .page-title {
      font-size: 22px;
      font-weight: 800;
      color: var(--text-dark);
      padding-bottom: 14px;
      border-bottom: 2px solid var(--green-dark);
      margin-bottom: 16px;
      letter-spacing: -0.4px;
    }

    .hero-card,
    .card {
      background: var(--white);
      border: 1px solid var(--border);
      border-radius: 14px;
      box-shadow: 0 10px 24px rgba(30, 60, 40, 0.05);
    }

    .hero-card {
      padding: 18px 28px 16px;
      margin-bottom: 16px;
      background: linear-gradient(135deg, var(--green-dark), #386a4d);
      color: #fff;
    }

    .hero-card h2 {
      font-size: 18px;
      margin: 0 0 6px;
    }

    .hero-card p {
      margin: 0;
      font-size: 12px;
      line-height: 1.6;
      color: rgba(255,255,255,0.82);
    }

    .card {
      padding: 20px;
      margin-bottom: 20px;
    }

    .section-hd {
      display: flex;
      align-items: center;
      justify-content: space-between;
      margin-bottom: 14px;
      padding-bottom: 10px;
      border-bottom: 1px solid var(--border);
    }

    .section-hd h3 {
      margin: 0;
      font-size: 15px;
      font-weight: 800;
      color: var(--text-dark);
    }

    .section-hd span {
      font-size: 12px;
      color: var(--text-light);
    }

    /* 주요 시설 점검 현황 카드 */
    .status-card-wrap {
      display: grid;
      grid-template-columns: repeat(5, 1fr);
      gap: 14px;
      margin-top: 18px;
    }

    .status-card-item.is-hidden {
      display: none;
    }

    .stat-card {
      background: #fff;
      border: 1px solid var(--border);
      border-radius: 14px;
      min-height: 88px;
      padding: 14px 18px;
    }

    .stat-label {
      font-size: 12px;
      font-weight: 700;
      color: #253028;
      margin-bottom: 8px;
    }

    .stat-value {
      font-size: 18px;
      font-weight: 800;
    }

    .stat-sub {
      margin-top: 6px;
      font-size: 11px;
      color: var(--text-light);
    }

    .status-empty { color: #9ca3af !important; }
    .status-wait { color: #c28b1e !important; }
    .status-ing { color: #4f6b95 !important; }
    .status-done { color: #2d3130 !important; }
    .status-fault { color: #b45454 !important; }

    .status-card-pagination {
      display: flex;
      justify-content: center;
      gap: 6px;
      margin-top: 18px;
    }

    .status-card-page-btn {
      min-width: 28px;
      height: 28px;
      border: 1px solid rgba(255,255,255,0.4);
      border-radius: 8px;
      background: rgba(255,255,255,0.15);
      color: #fff;
      font-size: 12px;
      font-weight: 800;
      cursor: pointer;
    }

    .status-card-page-btn.active {
      background: #fff;
      color: var(--green-dark);
    }

    /* 검색 영역 */
    #facilitySearchForm {
      display: flex;
      align-items: center;
      gap: 10px;
      margin: 18px 0 28px;
      flex-wrap: nowrap;
    }

    #facilitySearchForm .facility-search-input {
      width: 260px;
      height: 42px;
      border: none;
      border-radius: 999px;
      padding: 0 18px;
      background: #eef2ef;
      color: #1f2933;
      font-size: 14px;
      box-sizing: border-box;
      outline: none;
    }

    #facilitySearchForm .facility-search-input::placeholder {
      color: #9aa5a0;
    }

    #facilitySearchForm .facility-search-input:focus {
      background: #fff;
      box-shadow: 0 0 0 2px #d6e1d8;
    }

    .btn-main,
    .btn-ghost {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      min-width: 90px;
      height: 42px;
      border-radius: 999px;
      padding: 0 26px;
      font-size: 13px;
      font-weight: 800;
      text-decoration: none;
      border: none;
      cursor: pointer;
      box-sizing: border-box;
    }

    .facility-search-btn {
      background: #006b4f;
      color: #fff;
    }

    .facility-reset-btn {
      background: #66758d;
      color: #fff;
    }

    /* 표 */
    .data-table {
      width: 100%;
      border-collapse: collapse;
      font-size: 13px;
      background: #fff;
      border-radius: 12px;
      overflow: hidden;
    }

    .data-table thead th {
      text-align: center;
      background: #f3f3f3;
      color: #111827;
      padding: 12px 14px;
      font-weight: 700;
      border-top: 2px solid #333;
      border-bottom: 1px solid var(--border);
    }

    .data-table tbody td {
      padding: 13px 14px;
      border-bottom: 1px solid #edf0eb;
      color: var(--text-dark);
      vertical-align: top;
    }

    .data-table tbody tr:last-child td {
      border-bottom: none;
    }

    .date-range-tilde {
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 18px;
      font-weight: 700;
      color: #6b7280;
    }

    .sortable-th {
      cursor: pointer;
      user-select: none;
      white-space: nowrap;
      text-align: center;
    }

    .sortable-th::after {
      content: " ⇅";
      font-size: 11px;
      color: #8a968c;
    }

    /* 배지 */
    .badge {
      display: inline-flex;
      align-items: center;
      padding: 4px 10px;
      border-radius: 999px;
      font-size: 11px;
      font-weight: 800;
    }

    .badge.ok {
      background: #ecf7ef;
      color: #2f7a4d;
    }

    .badge.wait {
      background: #fff5df;
      color: #9a6b00;
    }

    .badge.danger {
      background: #fbe8e8;
      color: #a23a3a;
    }

    .badge.info {
      background: #edf4fb;
      color: #2d6688;
    }

    /* 페이징 */
    .facility-pagination {
      margin-top: 24px;
      display: flex;
      justify-content: center;
      align-items: center;
      gap: 8px;
      clear: both;
    }

    /* disabled 버튼 */
    .facility-pagination .page-link.disabled,
    .status-card-page-btn:disabled {
      opacity: 0.45;
      cursor: not-allowed;
    }

    .facility-pagination .page-link {
      min-width: 34px;
      height: 34px;
      padding: 0 12px;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      border: 1px solid var(--border);
      border-radius: 10px;
      color: var(--text-mid);
      text-decoration: none;
      font-size: 13px;
      font-weight: 800;
      background: #fff;
    }

    .facility-pagination .page-link.active {
      background: var(--green-dark);
      color: #fff;
      border-color: var(--green-dark);
    }

    /* 우리 단지 시설정보 표만 중앙정렬 */
    #facilityInfoTable tbody td,
    #facilityInfoTable thead th {
      text-align: center;
    }

    @media (max-width: 1200px) {
      .status-card-wrap {
        grid-template-columns: repeat(2, 1fr);
      }

      #facilitySearchForm {
        flex-wrap: wrap;
      }
    }

    @media (max-width: 900px) {
      .main-shell {
        flex-direction: column;
      }

      .content-area {
        padding: 24px 18px 48px;
      }

      .page-content-wrap {
        max-width: 100%;
      }

      .status-card-wrap {
        grid-template-columns: 1fr;
      }

      #facilitySearchForm .facility-search-input {
        width: 100%;
      }
    }

    /* 상세이력 표 상태 컬럼만 중앙정렬 */
    #historyTable th:nth-child(4),
    #historyTable td:nth-child(4) {
      text-align: center;
    }

    /* 상태 배지 길이 동일하게 고정 */
    #historyTable td:nth-child(4) .badge {
      width: 64px;
      justify-content: center;
      padding: 4px 0;
      box-sizing: border-box;
    }

    #historySearchForm {
      display: grid !important;

      /* 시작일 / ~ / 종료일 / 시설명 / 점검내용 / 상태 / 담당자 / 검색 / 초기화 */
      grid-template-columns:
      120px
      16px
      120px
      130px
      minmax(150px, 1fr)
      120px
      120px
      76px
      76px;

      gap: 8px;
      align-items: center;
      margin: 18px 0 20px;
    }

    #historySearchForm input[name="historyChkCn"] {
      min-width: 150px;
    }

    #historySearchForm .facility-search-input {
      width: 100% !important;
      height: 42px;
      border: none;
      border-radius: 999px;
      padding: 0 18px;
      background: #eef2ef;
      color: #1f2933;
      font-size: 14px;
      box-sizing: border-box;
      outline: none;
    }

    #historySearchForm .btn-main,
    #historySearchForm .btn-ghost {
      width: 76px;
      min-width: 76px;
      height: 40px;
      padding: 0;
      font-size: 12px;
    }

    #historySearchForm .facility-search-input::placeholder {
      color: #9aa5a0;
    }

    #historySearchForm .facility-search-input:focus {
      background: #fff;
      box-shadow: 0 0 0 2px #d6e1d8;
    }

    @media (max-width: 1200px) {
      #historySearchForm {
        grid-template-columns: repeat(2, 1fr);
      }
    }
  </style>

</head>
<body>
  <%@ include file="/WEB-INF/views/include/apt_headerLayout.jsp" %>
  <div class="main-shell">
    <%@ include file="/WEB-INF/views/include/apt_sidebarLayout.jsp" %>
    <main class="content-area">
      <div class="page-content-wrap">
        <div class="breadcrumb">
          <a href="${pageContext.request.contextPath}/">HOME</a>
          <span>›</span>
          <a href="javascript:void(0);">관리사무소</a>
          <span>›</span>
          <span class="cur">시설관리이력</span>
        </div>
        <h1 class="page-title">시설관리이력</h1>

        <section class="hero-card">
          <h2>주요 시설 점검 현황</h2>
           <p>
             우리 아파트 주요 시설의 점검 현황과
             최근 유지보수 이력을 확인할 수 있습니다.
           </p>
            <div class="status-card-wrap" id="statusCardWrap">
              <c:forEach var="card" items="${statusCardList}">
                <div class="stat-card status-card-item">
                  <div class="stat-label">${card.facilityNm}</div>

                    <%-- 점검 상태별 색상 클래스 적용--%>
                  <c:set var="statusClass" value="status-empty" />

                  <c:choose>
                    <c:when test="${card.chkSttsCd eq 'WAIT'}">
                      <c:set var="statusClass" value="status-wait" />
                    </c:when>

                    <c:when test="${card.chkSttsCd eq 'ING'}">
                      <c:set var="statusClass" value="status-ing" />
                    </c:when>

                    <c:when test="${card.chkSttsCd eq 'DONE'}">
                      <c:set var="statusClass" value="status-done" />
                    </c:when>

                    <c:when test="${card.chkSttsCd eq 'FAULT'}">
                      <c:set var="statusClass" value="status-fault" />
                    </c:when>
                  </c:choose>

                  <div class="stat-value ${statusClass}">
                      <%-- 점검상태 코드 한글 변환
                      --%>
                    <c:choose>
                      <c:when test="${card.chkSttsCd eq 'WAIT'}">점검대기</c:when>
                      <c:when test="${card.chkSttsCd eq 'ING'}">점검중</c:when>
                      <c:when test="${card.chkSttsCd eq 'DONE'}">점검완료</c:when>
                      <c:when test="${card.chkSttsCd eq 'FAULT'}">이상발견</c:when>
                      <c:otherwise>최근이력없음</c:otherwise>
                    </c:choose>
                  </div>

                  <div class="stat-sub">
                    <c:choose>
                      <c:when test="${not empty card.chkDt}">
                        최근 점검 ${card.chkDt}
                      </c:when>
                      <c:otherwise>
                        최근 점검 이력 없음
                      </c:otherwise>
                    </c:choose>
                  </div>
                </div>
              </c:forEach>
            </div>
          <div class="status-card-pagination" id="statusCardPagination"></div>
        </section>

        <section class="card">
          <div class="section-hd">

            <%-- 제목 + 단지명 영역 --%>
            <div>
              <h3 style="margin-bottom:4px;">
                우리 단지 시설정보
              </h3>

              <%-- 단지명
                   왜 분리?
                   → 제목 바로 아래에 단지명을 보여주기 위해.
              --%>
              <div style="font-size:13px; color:#6b7280; font-weight:600;">
                ${facilityAptInfo.aptCmplexNm}
              </div>
            </div>

            <%-- 시설정보 총 건수 --%>
            <div style="text-align:right;">
        <span id="facilityTotalRecordText" style="font-size:12px; color:#7b837d;">
            총 ${facilityTotalRecord}건
        </span>
            </div>

          </div>
            <form method="get"
                  id="facilitySearchForm"
                  action="${pageContext.request.contextPath}/resident/manage/facility/${aptCmplexNo}"
                  class="facility-search-box">

              <%-- 정렬 조건
                   sortColumn : 어떤 컬럼으로 정렬할지 저장
                   sortOrder  : ASC=오름차순, DESC=내림차순 저장
                   왜 hidden?
                   → 화면에는 안 보이지만 서버로 정렬값을 보내야 하기 때문.
              --%>
              <input type="hidden" name="keyword" value="${keyword}">
              <input type="hidden" name="sortColumn" id="sortColumn" value="${sortColumn}">
              <input type="hidden" name="sortOrder" id="sortOrder" value="${sortOrder}">
              <input type="hidden" name="facilityPage" id="facilityPage" value="1">

              <%-- 시설유형 셀렉트박스 --%>
                <select name="facilityTyCd"
                        class="facility-search-input"
                        style="appearance:auto; cursor:pointer;">
                  <option value="">전체 시설유형</option>
                  <option value="COMM" ${facilityTyCd eq 'COMM' ? 'selected' : ''}>커뮤니티시설</option>
                  <option value="ELV" ${facilityTyCd eq 'ELV' ? 'selected' : ''}>엘리베이터</option>
                  <option value="GYM" ${facilityTyCd eq 'GYM' ? 'selected' : ''}>피트니스센터</option>
                  <option value="SEC" ${facilityTyCd eq 'SEC' ? 'selected' : ''}>보안시설</option>
                  <option value="PLAY" ${facilityTyCd eq 'PLAY' ? 'selected' : ''}>어린이 놀이시설</option>
                  <option value="STUDY" ${facilityTyCd eq 'STUDY' ? 'selected' : ''}>독서실</option>
                  <option value="PARK" ${facilityTyCd eq 'PARK' ? 'selected' : ''}>입주민 주차장</option>
                  <option value="PARKING" ${facilityTyCd eq 'PARKING' ? 'selected' : ''}>방문자 주차구역</option>
                  <option value="MEET" ${facilityTyCd eq 'MEET' ? 'selected' : ''}>주민회의실</option>
                  <option value="WTR" ${facilityTyCd eq 'WTR' ? 'selected' : ''}>수도시설</option>
                  <option value="ELC" ${facilityTyCd eq 'ELC' ? 'selected' : ''}>전기시설</option>
                  <option value="GAS" ${facilityTyCd eq 'GAS' ? 'selected' : ''}>가스시설</option>
                  <option value="FIRE" ${facilityTyCd eq 'FIRE' ? 'selected' : ''}>소방시설</option>
                </select>

                <%-- 시설명 검색 --%>
                <input type="text"
                       name="facilityNm"
                       class="facility-search-input"
                       value="${facilityNm}"
                       placeholder="시설명 검색">

              <%-- 상세위치 검색 --%>
                <select name="dongNo"
                        class="facility-search-input"
                        style="appearance:auto; cursor:pointer;">
                  <option value="">전체 위치</option>

                  <c:forEach var="dong" items="${facilityDongList}">
                    <option value="${dong.dongNo}" ${dongNo eq dong.dongNo ? 'selected' : ''}>
                      <c:choose>
                        <c:when test="${not empty dong.dongNo}">
                          ${fn:substringAfter(dong.dongNo, '_')}동
                        </c:when>
                        <c:otherwise>단지 공용</c:otherwise>
                      </c:choose>
                    </option>
                  </c:forEach>
                </select>

                <input type="text"
                       name="locCn"
                       class="facility-search-input"
                       value="${locCn}"
                       placeholder="상세위치 검색">

              <button type="submit" class="btn-main facility-search-btn">
                검색
              </button>

              <%-- 초기화
                   왜 a 태그?
                   → 검색 파라미터 없이 처음 주소로 다시 이동시키기 위해.
              --%>
              <a href="${pageContext.request.contextPath}/resident/manage/facility/${aptCmplexNo}"
                 class="btn-ghost facility-reset-btn">
                초기화
              </a>
            </form>
          <table class="data-table" id="facilityInfoTable">

              <thead>
            <tr>
              <th class="sortable-th" data-column="facility_ty_cd">시설유형</th>
              <th class="sortable-th" data-column="facility_nm">시설명</th>
              <th class="sortable-th" data-column="dong_no">위치</th>
              <th class="sortable-th" data-column="loc_cn">상세위치</th>
            </tr>
            </thead>

            <tbody id="facilityTableBody">
            <c:choose>
              <c:when test="${not empty facilityInfoList}">
                <c:forEach var="item" items="${facilityInfoList}">
                  <tr>
                    <td>
                        <%-- 시설유형 코드 한글 변환
                             왜 사용?
                             → DB에는 COMM, ELV 같은 코드값이 저장되어 있기 때문.
                             화면에서는 사용자가 이해하기 쉽게 한글로 변환해서 보여준다.
                        --%>
                      <c:choose>
                        <c:when test="${item.facilityTyCd eq 'COMM'}">
                          커뮤니티시설
                        </c:when>
                        <c:when test="${item.facilityTyCd eq 'ELV'}">
                          엘리베이터
                        </c:when>
                        <c:when test="${item.facilityTyCd eq 'GYM'}">
                          피트니스센터
                        </c:when>
                        <c:when test="${item.facilityTyCd eq 'SEC'}">
                          보안시설
                        </c:when>
                        <c:when test="${item.facilityTyCd eq 'PLAY'}">
                          어린이 놀이시설
                        </c:when>
                        <c:when test="${item.facilityTyCd eq 'STUDY'}">
                          독서실
                        </c:when>
                        <c:when test="${item.facilityTyCd eq 'PARK'}">
                          입주민 주차장
                        </c:when>
                        <c:when test="${item.facilityTyCd eq 'PARKING'}">
                          방문자 주차구역
                        </c:when>
                        <c:when test="${item.facilityTyCd eq 'MEET'}">
                          주민회의실
                        </c:when>
                        <c:when test="${item.facilityTyCd eq 'WTR'}">
                          수도시설
                        </c:when>
                        <c:when test="${item.facilityTyCd eq 'ELC'}">
                          전기시설
                        </c:when>
                        <c:when test="${item.facilityTyCd eq 'GAS'}">
                          가스시설
                        </c:when>
                        <c:when test="${item.facilityTyCd eq 'FIRE'}">
                          소방시설
                        </c:when>
                        <c:otherwise>
                          기타시설
                        </c:otherwise>
                      </c:choose>
                    </td>
                    <td>${item.facilityNm}</td>
                    <td>
                      <c:choose>
                        <c:when test="${not empty item.dongNo}">
                          ${fn:substringAfter(item.dongNo, '_')}동
                        </c:when>
                        <c:otherwise>단지 공용</c:otherwise>
                      </c:choose>
                    </td>
                    <td>
                      <c:choose>
                        <c:when test="${not empty item.locCn}">
                          ${item.locCn}
                        </c:when>
                        <c:otherwise>-</c:otherwise>
                      </c:choose>
                    </td>
                  </tr>
                </c:forEach>
              </c:when>

              <c:otherwise>
                <tr>
                  <td colspan="4" style="text-align:center; padding:40px;">
                    등록된 시설정보가 없습니다.
                  </td>
                </tr>
              </c:otherwise>
            </c:choose>
            </tbody>
          </table>

          <%-- 우리단지 시설정보 페이징 --%>

          <%-- 시설정보 페이징 --%>
          <c:if test="${facilityTotalPage > 1}">

            <%-- pageBlockSize란?
                 → 화면에 페이지 번호를 몇 개씩 보여줄지 정하는 값.
                 여기서는 <- 1 2 3 4 5 -> 형태로 5개씩 보여준다.
            --%>
            <c:set var="facilityPageBlockSize" value="5" />
            <c:set var="facilityStartPage" value="${((facilityPage - 1) / facilityPageBlockSize) * facilityPageBlockSize + 1}" />
            <c:set var="facilityEndPage" value="${facilityStartPage + facilityPageBlockSize - 1}" />

            <c:if test="${facilityEndPage > facilityTotalPage}">
              <c:set var="facilityEndPage" value="${facilityTotalPage}" />
            </c:if>

            <div class="facility-pagination" id="facilityPagination">

              <c:if test="${facilityStartPage > 1}">
                <a class="page-link"
                   href="${pageContext.request.contextPath}/resident/manage/facility/${aptCmplexNo}?facilityPage=${facilityStartPage - 1}&currentPage=${currentPage}&facilityNm=${facilityNm}&facilityTyCd=${facilityTyCd}&locCn=${locCn}&sortColumn=${sortColumn}&sortOrder=${sortOrder}">
                  &lt;
                </a>
              </c:if>

              <c:forEach begin="${facilityStartPage}" end="${facilityEndPage}" var="page">
                <a class="page-link ${facilityPage eq page ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/resident/manage/facility/${aptCmplexNo}?facilityPage=${page}&currentPage=${currentPage}&facilityNm=${facilityNm}&facilityTyCd=${facilityTyCd}&locCn=${locCn}&sortColumn=${sortColumn}&sortOrder=${sortOrder}">
                    ${page}
                </a>
              </c:forEach>

              <c:if test="${facilityEndPage < facilityTotalPage}">
                <a class="page-link"
                   href="${pageContext.request.contextPath}/resident/manage/facility/${aptCmplexNo}?facilityPage=${facilityEndPage + 1}&currentPage=${currentPage}&facilityNm=${facilityNm}&facilityTyCd=${facilityTyCd}&locCn=${locCn}&sortColumn=${sortColumn}&sortOrder=${sortOrder}">
                  &gt;
                </a>
              </c:if>

            </div>
          </c:if>

        </section>

        <section class="card">
          <div class="section-hd">
            <h3>시설 점검 상세 이력</h3>
            <span id="historyTotalRecordText">총 ${totalRecord}건</span>
          </div>

          <form method="get"
                id="historySearchForm"
                action="${pageContext.request.contextPath}/resident/manage/facility/${aptCmplexNo}"
                class="facility-search-box"
                style="display:flex; align-items:center; gap:10px; margin:18px 0 20px;">

            <%-- 시설정보 현재 조건 유지 --%>
            <input type="hidden" name="facilityPage" value="${facilityPage}">
            <input type="hidden" name="facilityNm" value="${facilityNm}">
            <input type="hidden" name="facilityTyCd" value="${facilityTyCd}">
            <input type="hidden" name="locCn" value="${locCn}">
            <input type="hidden" name="sortColumn" value="${sortColumn}">
            <input type="hidden" name="sortOrder" value="${sortOrder}">

            <%-- 상세이력 검색 시 1페이지부터 조회 --%>
            <input type="hidden" name="currentPage" value="1">

              <input type="date"
                     name="historyChkStartDt"
                     class="facility-search-input"
                     value="${historyChkStartDt}">

              <span class="date-range-tilde">~</span>

              <input type="date"
                     name="historyChkEndDt"
                     class="facility-search-input"
                     value="${historyChkEndDt}">

              <select name="historyFacilityNm"
                      class="facility-search-input"
                      style="appearance:auto; cursor:pointer;">
                <option value="">전체 시설명</option>
                <c:set var="printedFacilityNames" value="," />

                <c:forEach var="card" items="${statusCardList}">
                  <c:set var="facilityNameKey" value=",${card.facilityNm}," />

                  <c:if test="${not empty card.facilityNm and not fn:contains(printedFacilityNames, facilityNameKey)}">

                    <option value="${card.facilityNm}" ${historyFacilityNm eq card.facilityNm ? 'selected' : ''}>
                        ${card.facilityNm}
                    </option>

                    <c:set var="printedFacilityNames" value="${printedFacilityNames}${card.facilityNm}," />
                  </c:if>
                </c:forEach>
              </select>

              <input type="text"
                     name="historyChkCn"
                     class="facility-search-input"
                     value="${historyChkCn}"
                     placeholder="점검내용 검색">

              <select name="historyChkStts"
                      class="facility-search-input"
                      style="appearance:auto; cursor:pointer;">
                <option value="">전체 상태</option>
                <option value="WAIT" ${historyChkStts eq 'WAIT' ? 'selected' : ''}>점검대기</option>
                <option value="ING" ${historyChkStts eq 'ING' ? 'selected' : ''}>점검중</option>
                <option value="DONE" ${historyChkStts eq 'DONE' ? 'selected' : ''}>점검완료</option>
                <option value="FAULT" ${historyChkStts eq 'FAULT' ? 'selected' : ''}>이상발견</option>
              </select>

              <input type="text"
                     name="historyPicNm"
                     class="facility-search-input"
                     value="${historyPicNm}"
                     placeholder="담당자 검색">

            <button type="submit" class="btn-main facility-search-btn">
              검색
            </button>

            <a href="${pageContext.request.contextPath}/resident/manage/facility/${aptCmplexNo}"
               class="btn-ghost facility-reset-btn">
              초기화
            </a>
          </form>

          <table class="data-table" id="historyTable">
            <thead>
            <tr>
              <th>점검일</th>
              <th>시설명</th>
              <th>점검내용</th>
              <th>상태</th>
              <th>담당자</th>
            </tr>
            </thead>

            <tbody id="historyTableBody">
            <c:choose>
              <c:when test="${not empty historyList}">
                <c:forEach var="history" items="${historyList}">
                  <tr>
                    <td>${history.chkDt}</td>
                    <td>${history.facilityNm}</td>
                    <td>${history.chkCn}</td>
                    <td>
                        <%-- 점검상태 코드별 배지 표시
                        --%>
                      <c:choose>
                        <c:when test="${history.chkSttsCd eq 'WAIT'}">
                          <span class="badge wait">점검대기</span>
                        </c:when>
                        <c:when test="${history.chkSttsCd eq 'ING'}">
                          <span class="badge info">점검중</span>
                        </c:when>
                        <c:when test="${history.chkSttsCd eq 'DONE'}">
                          <span class="badge ok">점검완료</span>
                        </c:when>
                        <c:when test="${history.chkSttsCd eq 'FAULT'}">
                          <span class="badge danger">이상발견</span>
                        </c:when>
                        <c:otherwise>
                          <span class="badge wait">점검대기</span>
                        </c:otherwise>
                      </c:choose>
                    </td>
                    <td>${history.picNm}</td>
                  </tr>
                </c:forEach>
              </c:when>

              <c:otherwise>
                <tr>
                  <td colspan="5" style="text-align:center; padding:40px;">
                    등록된 시설 점검 이력이 없습니다.
                  </td>
                </tr>
              </c:otherwise>
            </c:choose>
            </tbody>
          </table>

          <%-- 시설 점검 상세 이력 페이징 --%>
          <c:if test="${totalPage > 1}">

            <c:set var="historyPageBlockSize" value="5" />
            <c:set var="historyStartPage" value="${((currentPage - 1) / historyPageBlockSize) * historyPageBlockSize + 1}" />
            <c:set var="historyEndPage" value="${historyStartPage + historyPageBlockSize - 1}" />

            <c:if test="${historyEndPage > totalPage}">
              <c:set var="historyEndPage" value="${totalPage}" />
            </c:if>

            <div class="facility-pagination" id="historyPagination">

              <c:choose>
                <c:when test="${historyStartPage > 1}">
                  <a class="page-link"
                     href="${pageContext.request.contextPath}/resident/manage/facility/${aptCmplexNo}?currentPage=${historyStartPage - 1}&facilityPage=${facilityPage}&facilityNm=${facilityNm}&facilityTyCd=${facilityTyCd}&locCn=${locCn}&keyword=${keyword}&sortColumn=${sortColumn}&sortOrder=${sortOrder}">
                    &lt;
                  </a>
                </c:when>
                <c:otherwise>
                  <span class="page-link disabled">&lt;</span>
                </c:otherwise>
              </c:choose>

              <c:forEach begin="${historyStartPage}" end="${historyEndPage}" var="page">
                <a class="page-link ${currentPage eq page ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/resident/manage/facility/${aptCmplexNo}?currentPage=${page}&facilityPage=${facilityPage}&facilityNm=${facilityNm}&facilityTyCd=${facilityTyCd}&locCn=${locCn}&keyword=${keyword}&sortColumn=${sortColumn}&sortOrder=${sortOrder}">
                    ${page}
                </a>
              </c:forEach>

              <c:choose>
                <c:when test="${historyEndPage < totalPage}">
                  <a class="page-link"
                     href="${pageContext.request.contextPath}/resident/manage/facility/${aptCmplexNo}?currentPage=${historyEndPage + 1}&facilityPage=${facilityPage}&facilityNm=${facilityNm}&facilityTyCd=${facilityTyCd}&locCn=${locCn}&keyword=${keyword}&sortColumn=${sortColumn}&sortOrder=${sortOrder}">
                    &gt;
                  </a>
                </c:when>
                <c:otherwise>
                  <span class="page-link disabled">&gt;</span>
                </c:otherwise>
              </c:choose>

            </div>
          </c:if>

        </section>

          </div>

    </main>
  </div>
  <%@ include file="/WEB-INF/views/include/apt_footerLayout.jsp" %>
    <script>
      document.addEventListener("DOMContentLoaded", function () {

        /*
 * 주요 시설 점검 현황 카드 페이징
 * 한 페이지에 5개 카드만 보여준다.
 */
        const cardList = Array.from(document.querySelectorAll(".status-card-item"));
        const pagination = document.getElementById("statusCardPagination");

        const pageSize = 5;
        const pageBlockSize = 5;
        const totalPage = Math.ceil(cardList.length / pageSize);
        let currentCardPage = 1;

        function showCardPage(page) {
          currentCardPage = page;

          cardList.forEach(function (card, index) {
            const startIndex = (page - 1) * pageSize;
            const endIndex = page * pageSize;

            card.classList.toggle("is-hidden", !(index >= startIndex && index < endIndex));
          });

          renderCardPagination();
        }

        function renderCardPagination() {
          pagination.innerHTML = "";

          const currentBlock = Math.ceil(currentCardPage / pageBlockSize);
          const startPage = (currentBlock - 1) * pageBlockSize + 1;
          const endPage = Math.min(startPage + pageBlockSize - 1, totalPage);

          const prevBtn = document.createElement("button");
          prevBtn.type = "button";
          prevBtn.className = "status-card-page-btn";
          prevBtn.innerText = "<";
          prevBtn.disabled = startPage === 1;
          prevBtn.onclick = function () {
            showCardPage(startPage - 1);
          };
          pagination.appendChild(prevBtn);

          for (let i = startPage; i <= endPage; i++) {
            const btn = document.createElement("button");
            btn.type = "button";
            btn.className = "status-card-page-btn";
            btn.innerText = i;

            if (i === currentCardPage) {
              btn.classList.add("active");
            }

            btn.onclick = function () {
              showCardPage(i);
            };

            pagination.appendChild(btn);
          }

          const nextBtn = document.createElement("button");
          nextBtn.type = "button";
          nextBtn.className = "status-card-page-btn";
          nextBtn.innerText = ">";
          nextBtn.disabled = endPage === totalPage;
          nextBtn.onclick = function () {
            showCardPage(endPage + 1);
          };
          pagination.appendChild(nextBtn);
        }

        if (cardList.length > 0) {
          showCardPage(1);
        }

        /*
 * 시설정보 테이블 정렬
 * 왜 사용?
 * → 사용자가 시설유형, 시설명, 위치, 상세위치 제목을 누르면
 *   해당 기준으로 오름차순/내림차순 조회하기 위해 사용.
 */
        document.querySelectorAll(".sortable-th").forEach(function (th) {
          th.addEventListener("click", function () {
            const clickedColumn = this.dataset.column;
            const sortColumnInput = document.getElementById("sortColumn");
            const sortOrderInput = document.getElementById("sortOrder");
            const facilityPageInput = document.getElementById("facilityPage");

            if (sortColumnInput.value === clickedColumn) {
              sortOrderInput.value = sortOrderInput.value === "ASC" ? "DESC" : "ASC";
            } else {
              sortColumnInput.value = clickedColumn;
              sortOrderInput.value = "ASC";
            }

            facilityPageInput.value = "1";
            this.closest("section").querySelector("form").submit();
          });
        });

        /*
 * 시설정보 + 시설점검 상세이력 비동기 페이징
 *
 * 비동기란?
 * → 화면 전체 새로고침 없이 필요한 표 데이터만 다시 가져오는 방식.
 */
        const contextPath = "${pageContext.request.contextPath}";
        const aptCmplexNo = "${aptCmplexNo}";

        /* =========================
           시설정보 비동기 조회
           ========================= */
        function getFacilityTypeName(code) {
          const map = {
            COMM: "커뮤니티시설",
            ELV: "엘리베이터",
            GYM: "피트니스센터",
            SEC: "보안시설",
            PLAY: "어린이 놀이시설",
            STUDY: "독서실",
            PARK: "입주민 주차장",
            PARKING: "방문자 주차구역",
            MEET: "주민회의실",
            WTR: "수도시설",
            ELC: "전기시설",
            GAS: "가스시설",
            FIRE: "소방시설"
          };

          return map[code] || "기타시설";
        }

        function loadFacilityInfo(page) {
          const form = document.getElementById("facilitySearchForm");
          const params = new URLSearchParams(new FormData(form));

          params.set("facilityPage", page);

          fetch(contextPath + "/resident/manage/facility/" + aptCmplexNo + "/facility/list?" + params.toString())
                  .then(response => response.json())
                  .then(data => {
                    const tbody = document.getElementById("facilityTableBody");
                    const totalText = document.getElementById("facilityTotalRecordText");

                    tbody.innerHTML = "";
                    totalText.innerText = "총 " + data.facilityTotalRecord + "건";

                    if (!data.facilityInfoList || data.facilityInfoList.length === 0) {
                      tbody.innerHTML =
                              '<tr><td colspan="4" style="text-align:center; padding:40px;">조회된 시설정보가 없습니다.</td></tr>';
                    } else {
                      data.facilityInfoList.forEach(item => {
                        const dongText = item.dongNo ? item.dongNo.substring(item.dongNo.indexOf("_") + 1) + "동" : "단지 공용";
                        const locText = item.locCn ? item.locCn : "-";

                        tbody.innerHTML +=
                                '<tr>' +
                                '  <td>' + getFacilityTypeName(item.facilityTyCd) + '</td>' +
                                '  <td>' + item.facilityNm + '</td>' +
                                '  <td>' + dongText + '</td>' +
                                '  <td>' + locText + '</td>' +
                                '</tr>';
                      });
                    }

                    renderFacilityPagination(data.facilityPage, data.facilityTotalPage);
                  });
        }

        function renderFacilityPagination(currentPage, totalPage) {
          const pagination = document.getElementById("facilityPagination");
          pagination.innerHTML = "";

          if (totalPage <= 1) return;

          const blockSize = 5;
          const startPage = Math.floor((currentPage - 1) / blockSize) * blockSize + 1;
          const endPage = Math.min(startPage + blockSize - 1, totalPage);

          if (startPage > 1) {
            pagination.innerHTML += '<button type="button" class="page-link facility-ajax-page" data-page="' + (startPage - 1) + '">&lt;</button>';
          }

          for (let i = startPage; i <= endPage; i++) {
            pagination.innerHTML +=
                    '<button type="button" class="page-link facility-ajax-page ' + (i === currentPage ? 'active' : '') + '" data-page="' + i + '">' +
                    i +
                    '</button>';
          }

          if (endPage < totalPage) {
            pagination.innerHTML += '<button type="button" class="page-link facility-ajax-page" data-page="' + (endPage + 1) + '">&gt;</button>';
          }

          document.querySelectorAll(".facility-ajax-page").forEach(btn => {
            btn.addEventListener("click", function () {
              loadFacilityInfo(Number(this.dataset.page));
            });
          });
        }

        /* =========================
           상세이력 비동기 조회
           ========================= */
        function getHistoryBadge(row) {
          if (row.chkSttsCd === "DONE") return '<span class="badge ok">점검완료</span>';
          if (row.chkSttsCd === "ING") return '<span class="badge info">점검중</span>';
          if (row.chkSttsCd === "FAULT") return '<span class="badge danger">이상발견</span>';
          return '<span class="badge wait">점검대기</span>';
        }

        function loadHistory(page) {
          const form = document.getElementById("historySearchForm");
          const params = new URLSearchParams(new FormData(form));

          params.set("currentPage", page);

          fetch(contextPath + "/resident/manage/facility/" + aptCmplexNo + "/history/list?" + params.toString())
                  .then(response => response.json())
                  .then(data => {
                    const tbody = document.getElementById("historyTableBody");
                    const totalText = document.getElementById("historyTotalRecordText");

                    tbody.innerHTML = "";
                    totalText.innerText = "총 " + data.totalRecord + "건";

                    if (!data.historyList || data.historyList.length === 0) {
                      tbody.innerHTML =
                              '<tr><td colspan="5" style="text-align:center; padding:40px;">조회된 시설 점검 이력이 없습니다.</td></tr>';
                    } else {
                      data.historyList.forEach(row => {
                        tbody.innerHTML +=
                                '<tr>' +
                                '  <td>' + (row.chkDt || "-") + '</td>' +
                                '  <td>' + (row.facilityNm || "-") + '</td>' +
                                '  <td>' + (row.chkCn || "-") + '</td>' +
                                '  <td>' + getHistoryBadge(row) + '</td>' +
                                '  <td>' + (row.picNm || "-") + '</td>' +
                                '</tr>';
                      });
                    }

                    renderHistoryPagination(data.currentPage, data.totalPage);
                  });
        }

        function renderHistoryPagination(currentPage, totalPage) {
          const pagination = document.getElementById("historyPagination");
          pagination.innerHTML = "";

          if (totalPage <= 1) return;

          const blockSize = 5;
          const startPage = Math.floor((currentPage - 1) / blockSize) * blockSize + 1;
          const endPage = Math.min(startPage + blockSize - 1, totalPage);

          if (startPage > 1) {
            pagination.innerHTML += '<button type="button" class="page-link history-ajax-page" data-page="' + (startPage - 1) + '">&lt;</button>';
          }

          for (let i = startPage; i <= endPage; i++) {
            pagination.innerHTML +=
                    '<button type="button" class="page-link history-ajax-page ' + (i === currentPage ? 'active' : '') + '" data-page="' + i + '">' +
                    i +
                    '</button>';
          }

          if (endPage < totalPage) {
            pagination.innerHTML += '<button type="button" class="page-link history-ajax-page" data-page="' + (endPage + 1) + '">&gt;</button>';
          }

          document.querySelectorAll(".history-ajax-page").forEach(btn => {
            btn.addEventListener("click", function () {
              loadHistory(Number(this.dataset.page));
            });
          });
        }

        /* 기존 JSP 페이징 a태그 클릭을 비동기로 가로채기 */
        document.querySelectorAll("#facilityPagination .page-link").forEach(link => {
          link.addEventListener("click", function (e) {
            e.preventDefault();
            loadFacilityInfo(Number(new URL(this.href).searchParams.get("facilityPage")));
          });
        });

        document.querySelectorAll("#historyPagination .page-link").forEach(link => {
          link.addEventListener("click", function (e) {
            e.preventDefault();
            loadHistory(Number(new URL(this.href).searchParams.get("currentPage")));
          });
        });

        /* 검색 버튼도 비동기로 처리 */
        document.getElementById("facilitySearchForm").addEventListener("submit", function (e) {
          e.preventDefault();
          loadFacilityInfo(1);
        });

        document.getElementById("historySearchForm").addEventListener("submit", function (e) {
          e.preventDefault();
          loadHistory(1);
        });

      });

    </script>
</body>
</html>
