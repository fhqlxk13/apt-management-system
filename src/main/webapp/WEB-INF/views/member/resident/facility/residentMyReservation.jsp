<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <meta name="_csrf" content="${_csrf.token}">
  <meta name="_csrf_header" content="${_csrf.headerName}">
  <title>예약내역</title>

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
    }

    .page-desc {
      font-size: 14px;
      color: var(--text-light);
      margin-bottom: 24px;
    }

    .pf-card {
      background: #fff;
      border: 1px solid var(--border);
      border-radius: 14px;
      box-shadow: 0 10px 24px rgba(30, 60, 40, 0.05);
      margin-bottom: 18px;
    }

    .pf-card-hd {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 14px 18px;
      border-bottom: 1px solid var(--border);
      font-weight: 800;
      color: var(--text-dark);
    }

    .pf-card-bd {
      padding: 16px 18px;
    }

    .pf-search-grid {
      display: grid;

      /*
       * 시설명, 예약대상 너비 확대
       *
       * 1.35fr
       * -> 기본 1칸보다 35% 더 넓게 사용
       *
       * fr 이란?
       * CSS Grid의 비율 단위입니다.
       * 화면 남는 공간을 비율로 나눠서 사용합니다.
       */
      grid-template-columns:
          1.35fr   /* 시설명 */
          1.35fr   /* 예약대상 */
          1fr      /* 시작일 */
          1fr      /* 종료일 */
          1fr      /* 상태 */
          auto     /* 초기화 */
          auto;    /* 검색 */

      gap: 10px;
      align-items: end;
    }

    .pf-field label {
      display: block;
      font-size: 12px;
      font-weight: 800;
      color: #374151;
      margin-bottom: 6px;
    }

    .pf-field input,
    .pf-field select {
      width: 100%;
      height: 38px;
      border: none;
      border-radius: 999px;
      padding: 0 14px;
      background: #eef2ef;
      font-size: 13px;
      box-sizing: border-box;
      outline: none;
    }

    /* 공통 버튼 */
    .pf-btn {
      height: 34px;
      border: none;
      border-radius: 10px;
      padding: 0 16px;
      font-size: 13px;
      font-weight: 800;
      cursor: pointer;
      white-space: nowrap;
      transition: 0.15s ease;
    }

    .pf-btn:hover {
      transform: translateY(-1px);
    }

    /* 검색 버튼 */
    .pf-btn-primary {
      background: #006b4f;
      color: #fff;
    }

    /* 초기화/닫기 버튼 */
    .pf-btn-light {
      background: #64748b;
      color: #fff;
    }

    /* 상세 버튼 */
    .pf-btn-detail {
      background: #14532d;
      color: #fff;
      box-shadow: 0 3px 8px rgba(20, 83, 45, 0.22);
    }

    /* 취소 버튼 */
    .pf-btn-cancel {
      background: #ef4444;
      color: #fff;
      box-shadow: 0 3px 8px rgba(239, 68, 68, 0.22);
    }

    /* 초기화 버튼 */
    .pf-btn-light {
      background: #64748b;
      color: #fff;
      width: 100px;
    }

    /* 검색 버튼 */
    .pf-btn-primary {
      background: #006b4f;
      color: #fff;
      width: 100px;
    }

    /* 예약내역 테이블 */
    .pf-table {
      width: 100%;
      border-collapse: collapse;
      table-layout: fixed;
      font-size: 13px;
      background: #fff;
    }

    .pf-table th {
      background: #f8faf9;
      border-top: 2px solid #222;
      border-bottom: 1px solid #dfe5e1;
      padding: 14px 10px;
      text-align: center;
      color: #111827;
      font-weight: 900;
    }

    .pf-table td {
      border-bottom: 1px solid #edf0ed;
      padding: 14px 10px;
      text-align: center;
      color: #111827;
      vertical-align: middle;
      white-space: nowrap;
    }

    .pf-table th:nth-child(1),
    .pf-table td:nth-child(1) {
      width: 70px;
    }

    .pf-table th:nth-child(2),
    .pf-table td:nth-child(2) {
      width: 170px;
    }

    .pf-table th:nth-child(3),
    .pf-table td:nth-child(3) {
      width: 170px;
    }

    .pf-table th:nth-child(4),
    .pf-table td:nth-child(4) {
      width: 280px;
    }

    .pf-table th:nth-child(5),
    .pf-table td:nth-child(5) {
      width: 110px;
    }

    .pf-table th:nth-child(6),
    .pf-table td:nth-child(6) {
      width: 150px;
    }

    /* 상태 뱃지 공통 */
    .pf-badge {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      min-width: 74px;
      height: 28px;
      padding: 0 10px;
      border-radius: 999px;
      font-size: 12px;
      font-weight: 900;
    }

    /* 승인대기 */
    .pf-badge-pending {
      background: #fff3d6;
      color: #b77900;
    }

    /* 승인완료 */
    .pf-badge-approved {
      background: #e3f2ff;
      color: #0969da;
    }

    /* 승인거절 */
    .pf-badge-rejected {
      background: #ffe4e6;
      color: #dc2626;
    }

    /* 승인취소 */
    .pf-badge-cancelled {
      background: #e5e7eb;
      color: #4b5563;
    }

    /* 승인만료 */
    .pf-badge-expired {
      background: #ede9fe;
      color: #6d28d9;
    }

    .pf-paging {
      display: flex;
      justify-content: center;
      margin-top: 18px;
    }

    .pagination {
      display: flex;
      gap: 4px;
      list-style: none;
      padding: 0;
    }

    .page-link {
      display: block;
      padding: 6px 10px;
      border: 1px solid var(--border);
      border-radius: 8px;
      color: var(--text-mid);
      text-decoration: none;
      background: #fff;
      font-weight: 800;
    }

    .page-item.active .page-link {
      background: var(--green-dark);
      color: #fff;
      border-color: var(--green-dark);
    }

    .pf-actions {
      display: flex;
      gap: 8px;
      justify-content: center;
      align-items: center;
      flex-wrap: nowrap;
    }

    .pf-modal {
      display: none;
      position: fixed;
      inset: 0;
      background: rgba(0,0,0,.35);
      z-index: 9999;
    }

    .pf-modal.is-open {
      display: flex;
      align-items: center;
      justify-content: center;
    }

    .pf-modal-box {
      width: 620px;
      background: #fff;
      border-radius: 14px;
      padding: 20px;
    }

    .pf-modal-title {
      font-size: 18px;
      font-weight: 800;
      margin-bottom: 12px;
    }

    @media (max-width: 1200px) {
      .pf-search-grid {
        grid-template-columns: repeat(2, 1fr);
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

      .pf-search-grid {
        grid-template-columns: 1fr;
      }
    }

    .pf-modal {
      display: none;
      position: fixed;
      inset: 0;
      background: rgba(17, 24, 39, 0.45);
      z-index: 9999;
    }

    .pf-modal.is-open {
      display: flex;
      align-items: center;
      justify-content: center;
    }

    .pf-modal-box {
      width: 560px;
      max-width: calc(100% - 32px);
      background: #fff;
      border-radius: 18px;
      padding: 0;
      overflow: hidden;
      box-shadow: 0 20px 50px rgba(0, 0, 0, 0.18);
    }

    .pf-modal-title {
      padding: 18px 22px;
      font-size: 18px;
      font-weight: 900;
      color: #111827;
      border-bottom: 1px solid #e5e7eb;
      background: #f8faf9;
    }

    .pf-detail-table {
      width: 100%;
      border-collapse: collapse;
      font-size: 14px;
    }

    .pf-detail-table th {
      width: 130px;
      padding: 13px 16px;
      text-align: left;
      background: #f3f6f4;
      color: #374151;
      font-weight: 800;
      border-bottom: 1px solid #e5e7eb;
    }

    .pf-detail-table td {
      padding: 13px 16px;
      color: #111827;
      border-bottom: 1px solid #e5e7eb;
      word-break: keep-all;
    }

    .pf-modal-footer {
      display: flex;
      justify-content: center;
      padding: 16px 20px 20px;
    }
  </style>
  <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
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
        <a href="javascript:void(0);">생활지원서비스</a>
        <span>›</span>
        <span class="cur">예약내역</span>
      </div>

      <h1 class="page-title">예약내역</h1>
      <p class="page-desc">단지 내 공용시설 예약 정보를 조회합니다.</p>

      <form id="searchForm"
            method="get"
            action="${pageContext.request.contextPath}/resident/publicFacility/myReservation/${aptCmplexNo}"> <div class="pf-card">
          <div class="pf-card-hd">검색 조건</div>

            <div class="pf-card-bd pf-search-grid">

              <div class="pf-field">
                <label>시설명</label>
                <select name="searchCmnFacilityNo">
                  <option value="">전체</option>
                  <c:forEach var="facility" items="${facilityFilterList}">
                    <option value="${facility.cmnFacilityNo}"
                      ${searchVO.searchCmnFacilityNo eq facility.cmnFacilityNo ? 'selected' : ''}>
                        ${facility.cmnFacilityNm}
                    </option>
                  </c:forEach>
                </select>
              </div>

              <div class="pf-field">
                <label>예약대상</label>
                <select name="searchItemNo">
                  <option value="">전체</option>
                  <c:forEach var="item" items="${itemFilterList}">
                    <option value="${item.cmnFacilityItemNo}"
                      ${searchVO.searchItemNo eq item.cmnFacilityItemNo ? 'selected' : ''}>
                        ${item.itemNm}
                    </option>
                  </c:forEach>
                </select>
              </div>

              <div class="pf-field">
                <label>시작일</label>
                <input type="date" name="searchStartDt" value="${searchVO.searchStartDt}">
              </div>

              <div class="pf-field">
                <label>종료일</label>
                <input type="date" name="searchEndDt" value="${searchVO.searchEndDt}">
              </div>

              <div class="pf-field">
                <label>상태</label>
                <select name="searchRsvtSttsCd">
                  <option value="">전체</option>
                  <option value="PENDING" ${searchVO.searchRsvtSttsCd eq 'PENDING' ? 'selected' : ''}>승인대기</option>
                  <option value="APPROVED" ${searchVO.searchRsvtSttsCd eq 'APPROVED' ? 'selected' : ''}>승인완료</option>
                  <option value="REJECTED" ${searchVO.searchRsvtSttsCd eq 'REJECTED' ? 'selected' : ''}>승인거절</option>
                  <option value="CANCELLED" ${searchVO.searchRsvtSttsCd eq 'CANCELLED' ? 'selected' : ''}>승인취소</option>
                  <option value="EXPIRED" ${searchVO.searchRsvtSttsCd eq 'EXPIRED' ? 'selected' : ''}>승인만료</option>
                </select>
              </div>

              <button type="button"
                      class="pf-btn pf-btn-light"
                      onclick="location.href='${pageContext.request.contextPath}/resident/publicFacility/myReservation/${aptCmplexNo}'">
                초기화
              </button>

              <button type="submit" class="pf-btn pf-btn-primary">
                검색
              </button>

            </div>
        </div>
      </form>

      <div class="pf-card">
        <div class="pf-card-hd">
          <span>예약내역 <b>${pagingVO.totalRecord}</b>건</span>
        </div>

        <div class="pf-card-bd">
          <table class="pf-table">
            <thead>
            <tr>
              <th>번호</th>
              <th>시설명</th>
              <th>예약대상</th>
              <th>예약시간</th>
              <th>상태</th>
              <th>관리</th>
            </tr>
            </thead>

            <tbody>
            <c:forEach items="${pagingVO.dataList}" var="row" varStatus="st">
              <tr>
                <td>${pagingVO.totalRecord - ((pagingVO.currentPage - 1) * pagingVO.screenSize) - st.index}</td>
                <td>${row.cmnFacilityNm}</td>
                <td>${row.itemNm}</td>
                <td>${row.rsvtBgngDttm} ~ ${row.rsvtEndDttm}</td>
                <td>
                  <c:set var="statusCd" value="${row.rsvtSttsCd}" />

                  <span class="pf-badge
                      ${statusCd eq 'PENDING' ? 'pf-badge-pending' : ''}
                      ${statusCd eq 'APPROVED' ? 'pf-badge-approved' : ''}
                      ${statusCd eq 'REJECTED' ? 'pf-badge-rejected' : ''}
                      ${statusCd eq 'CANCELLED' ? 'pf-badge-cancelled' : ''}
                      ${statusCd eq 'EXPIRED' ? 'pf-badge-expired' : ''}">
                      ${row.rsvtSttsNm}
                  </span>
                </td>
                <td class="pf-actions">
                  <button type="button"
                          class="pf-btn pf-btn-detail"
                          onclick="detailRsvt('${row.rsvtNo}')">
                    상세
                  </button>

                    <%--
                      취소 버튼 표시 조건

                      PENDING  : 승인대기 → 취소 가능
                      APPROVED : 승인완료 → 예약 시작 전이면 서버에서 취소 가능 여부 판단
                      REJECTED : 승인거절 → 이미 종료된 상태라 취소 불필요
                      CANCELLED: 승인취소 → 이미 취소된 상태라 취소 불필요
                    --%>
                  <c:if test="${row.rsvtSttsCd eq 'PENDING'}">
                    <button type="button"
                            class="pf-btn pf-btn-cancel"
                            onclick="cancelRsvt('${row.rsvtNo}')">
                      취소
                    </button>
                  </c:if>
                </td>
              </tr>
            </c:forEach>

            <c:if test="${empty pagingVO.dataList}">
              <tr>
                <td colspan="6">조회된 데이터가 없습니다.</td>
              </tr>
            </c:if>
            </tbody>
          </table>

          <div class="pf-paging">${pagingVO.pagingHTML}</div>
        </div>
      </div>

      <div id="detailModal" class="pf-modal">
        <div class="pf-modal-box">
          <div class="pf-modal-title">예약 상세</div>

          <div id="detailBody"></div>

          <div class="pf-modal-footer">
            <button type="button"
                    class="pf-btn pf-btn-light"
                    onclick="document.getElementById('detailModal').classList.remove('is-open')">
              닫기
            </button>
          </div>
        </div>
      </div>

    </div>
  </main>
</div>

<%@ include file="/WEB-INF/views/include/apt_footerLayout.jsp" %>

<script>
  document.addEventListener('click', function(e){
    const a = e.target.closest('.page-link');

    if(!a || !a.dataset.page) {
      return;
    }

    e.preventDefault();

    const form = document.getElementById('searchForm');
    const page = document.createElement('input');

    page.type = 'hidden';
    page.name = 'currentPage';
    page.value = a.dataset.page;

    form.appendChild(page);
    form.submit();
  });

  function detailRsvt(rsvtNo){
    fetch('${pageContext.request.contextPath}/resident/publicFacility/myReservation/detail/' + rsvtNo)
            .then(function(response) {
              return response.json();
            })
            .then(function(d) {

              /*
               * nvl 함수 역할
               * 값이 null, undefined, 빈 문자열이면 '-'로 보여주기 위한 화면용 함수입니다.
               */
              function nvl(value) {
                if(value === null || value === undefined || value === '') {
                  return '-';
                }
                return value;
              }

              function getBadgeClass(statusCd) {
                if(statusCd === 'PENDING') {
                  return 'pf-badge-pending';
                }

                if(statusCd === 'APPROVED') {
                  return 'pf-badge-approved';
                }

                if(statusCd === 'REJECTED') {
                  return 'pf-badge-rejected';
                }

                if(statusCd === 'CANCELLED') {
                  return 'pf-badge-cancelled';
                }

                if(statusCd === 'EXPIRED') {
                  return 'pf-badge-expired';
                }

                return '';
              }

              /*
               * 이용목적 필드명
               * DB 컬럼명: USE_PRPS_CN
               * Java VO 예상 필드명: usePrpsCn
               */
              document.getElementById('detailBody').innerHTML =
                      '<table class="pf-detail-table">' +
                      '<tbody>' +
                      '<tr>' +
                      '<th>예약시간</th>' +
                      '<td>' + nvl(d.rsvtBgngDttm) + ' ~ ' + nvl(d.rsvtEndDttm) + '</td>' +
                      '</tr>' +
                      '<tr>' +
                      '<th>시설명</th>' +
                      '<td>' + nvl(d.cmnFacilityNm) + '</td>' +
                      '</tr>' +
                      '<tr>' +
                      '<th>예약대상</th>' +
                      '<td>' + nvl(d.itemNm) + '</td>' +
                      '</tr>' +
                      '<tr>' +
                      '<th>이용목적</th>' +
                      '<td>' + nvl(d.purposeCn) + '</td>' +
                      '</tr>' +
                      '<tr>' +
                      '<th>동/호</th>' +
                      '<td>' + nvl(d.dongNm || d.dongNo) + ' / ' + nvl(d.ho) + '</td>' +
                      '</tr>' +
                      '<tr>' +
                      '<th>입주민명</th>' +
                      '<td>' + nvl(d.userNm) + '</td>' +
                      '</tr>' +
                      '<tr>' +
                      '<th>상태</th>' +
                      '<td><span class="pf-badge ' + getBadgeClass(d.rsvtSttsCd) + '">' + nvl(d.rsvtSttsNm) + '</span></td>' +
                      '</tr>' +
                      (d.rsvtSttsCd === 'REJECTED' || d.rsvtSttsCd === 'EXPIRED'
                              ? '<tr>' +
                              '<th>사유</th>' +
                              '<td>' + nvl(d.rejectReason) + '</td>' +
                              '</tr>'
                              : '') +
                      '</tbody>' +
                      '</table>';

              document.getElementById('detailModal').classList.add('is-open');
            });
  }

  function cancelRsvt(rsvtNo){

    Swal.fire({
      title: '예약 취소',
      text: '예약을 취소하시겠습니까?',
      icon: 'question',
      showCancelButton: true,
      confirmButtonText: '취소하기',
      cancelButtonText: '닫기',
      confirmButtonColor: '#dc2626',
      cancelButtonColor: '#6b7280'
    }).then((result) => {

      if(!result.isConfirmed){
        return;
      }

      const csrfToken =
              document.querySelector('meta[name="_csrf"]').content;

      const csrfHeader =
              document.querySelector('meta[name="_csrf_header"]').content;

      fetch(
              '${pageContext.request.contextPath}/resident/publicFacility/myReservation/cancel/' + rsvtNo,
              {
                method:'POST',
                headers:{
                  [csrfHeader]:csrfToken
                }
              }
      )
              .then(function(response){

                if(!response.ok){

                  Swal.fire({
                    icon:'error',
                    title:'오류',
                    text:'예약 취소 중 오류가 발생했습니다.'
                  });

                  return;
                }

                Swal.fire({
                  icon:'success',
                  title:'취소 완료',
                  text:'예약이 취소되었습니다.'
                }).then(() => {
                  location.reload();
                });
              })
              .catch(function(error){

                console.error(error);

                Swal.fire({
                  icon:'error',
                  title:'오류',
                  text:'예약 취소 요청 중 오류가 발생했습니다.'
                });
              });

    });
  }

</script>

</body>
</html>