<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>예약시설 이용이력</title>

  <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/office-layout.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/manager-common.css">

  <style>
    .pf-wrap{padding:24px}
    .pf-page-title{font-size:24px;font-weight:700;color:#1f2d1f;margin-bottom:6px}
    .pf-page-desc{font-size:13px;color:#6b7280;margin-bottom:22px}
    .pf-card{background:#fff;border:1px solid #dfe5df;border-radius:8px;margin-bottom:16px}
    .pf-card-hd{display:flex;justify-content:space-between;align-items:center;padding:14px 18px;border-bottom:1px solid #e5e7eb;font-weight:700}
    .pf-card-bd{padding:16px 18px}
    .pf-search-grid{
      display:grid;
      grid-template-columns:1.1fr 1.1fr .65fr .65fr .9fr .9fr .9fr .8fr 70px auto;
      gap:10px;
      align-items:end;
    }
    .pf-btn-reset{
      width:70px;
      padding:0;
    }
    .pf-field label{display:block;font-size:12px;font-weight:700;color:#374151;margin-bottom:6px}
    .pf-field input,.pf-field select{width:100%;height:36px;border:1px solid #d7ded7;border-radius:5px;padding:0 10px;font-size:13px}
    .pf-btn{height:36px;border:1px solid #245b36;border-radius:5px;padding:0 14px;font-weight:700;cursor:pointer}
    .pf-btn-primary{background:#245b36;color:#fff}
    .pf-btn-light{background:#fff;color:#374151;border-color:#d7ded7}
    .pf-table{width:100%;border-collapse:collapse;font-size:13px}
    .pf-table th{background:#f2f6f1;border-bottom:1px solid #d7ded7;padding:12px;text-align:center;color:#374151}
    .pf-table td{border-bottom:1px solid #edf0ed;padding:11px;text-align:center}
    /*
 * 상태 뱃지 공통 스타일
 *
 * badge란?
 * 상태를 색상으로 표시하는 UI 라벨입니다.
 * 예: 승인완료, 취소, 거절 등
 */
    .pf-badge{
      display:inline-block;
      min-width:72px;
      padding:5px 10px;
      border-radius:999px;
      font-size:12px;
      font-weight:700;
      text-align:center;
    }

    /* 승인완료 */
    .pf-badge-approved{
      background:#e8f7ee;
      color:#15803d;
    }

    /* 승인대기 */
    .pf-badge-pending{
      background:#fff7e6;
      color:#d97706;
    }

    /* 거절 */
    .pf-badge-rejected{
      background:#fee2e2;
      color:#dc2626;
    }

    /* 취소 */
    .pf-badge-cancelled{
      background:#eef2f7;
      color:#64748b;
    }

    /* 승인만료 */
    .pf-badge-expired{
      background:#ede9fe;
      color:#6d28d9;
    }
    .pf-paging{display:flex;justify-content:center;margin-top:18px}
    .pagination{display:flex;gap:4px;list-style:none;padding:0}
    .page-link{display:block;padding:6px 10px;border:1px solid #d7ded7;border-radius:4px;color:#374151;text-decoration:none}
    .page-item.active .page-link{background:#245b36;color:#fff;border-color:#245b36}
  </style>
</head>

<body>
<div class="app-wrapper">
  <%@ include file="/WEB-INF/views/include/office_sidebar.jsp" %>

  <div class="main-wrap">
    <%@ include file="/WEB-INF/views/include/office_header.jsp" %>

    <main class="main-content">
      <div class="office-page">
        <div class="pf-wrap">
          <h2 class="pf-page-title">예약시설 이용이력</h2>
          <p class="pf-page-desc">단지 내 편의시설 예약 정보를 조회합니다.</p>

          <form id="searchForm" method="get" action="${pageContext.request.contextPath}/manager/publicFacility/reservation/history/${mgmtOfcNo}">
            <div class="pf-card">
              <div class="pf-card-hd">검색 조건</div>
              <div class="pf-card-bd pf-search-grid">

                <div class="pf-field">
                  <label>시설명</label>
                  <select name="searchCmnFacilityNo">
                    <option value="">전체</option>
                    <c:forEach items="${historyFacilityList}" var="facility">
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
                    <c:forEach items="${historyItemList}" var="item">
                      <option value="${item.cmnFacilityItemNo}"
                        ${searchVO.searchItemNo eq item.cmnFacilityItemNo ? 'selected' : ''}>
                          ${item.itemNm}
                      </option>
                    </c:forEach>
                  </select>
                </div>

                <div class="pf-field">
                  <label>동</label>
                  <input name="searchDongNm" value="${searchVO.searchDongNm}" placeholder="예: 101"/>
                </div>

                <div class="pf-field">
                  <label>호</label>
                  <input name="searchHo" value="${searchVO.searchHo}" placeholder="예: 305"/>
                </div>

                <div class="pf-field">
                  <label>입주민명</label>
                  <input name="searchUserNm" value="${searchVO.searchUserNm}" placeholder="이름"/>
                </div>

                <div class="pf-field">
                  <label>이용시작</label>
                  <input type="date" name="searchStartDt" value="${searchVO.searchStartDt}"/>
                </div>

                <div class="pf-field">
                  <label>이용종료</label>
                  <input type="date" name="searchEndDt" value="${searchVO.searchEndDt}"/>
                </div>

                <div class="pf-field">
                  <label>상태</label>
                  <select name="searchRsvtSttsCd">
                    <option value="">전체</option>
                    <option value="PENDING" ${searchVO.searchRsvtSttsCd eq 'PENDING' ? 'selected' : ''}>승인대기</option>
                    <option value="APPROVED" ${searchVO.searchRsvtSttsCd eq 'APPROVED' ? 'selected' : ''}>승인완료</option>
                    <option value="REJECTED" ${searchVO.searchRsvtSttsCd eq 'REJECTED' ? 'selected' : ''}>거절</option>
                    <option value="CANCELLED" ${searchVO.searchRsvtSttsCd eq 'CANCELLED' ? 'selected' : ''}>취소</option>
                    <option value="EXPIRED" ${searchVO.searchRsvtSttsCd eq 'EXPIRED' ? 'selected' : ''}>승인만료</option>
                  </select>
                </div>

                <button type="button" class="pf-btn pf-btn-light pf-btn-reset"
                        onclick="location.href='${pageContext.request.contextPath}/manager/publicFacility/reservation/history/${mgmtOfcNo}'">
                  초기화
                </button>

                <button class="pf-btn pf-btn-primary">검색</button>
              </div>
            </div>
          </form>

          <div class="pf-card">
            <div class="pf-card-hd">
              <span>예약시설 이용이력 <b>${pagingVO.totalRecord}</b>건</span>
            </div>

            <div class="pf-card-bd">
              <table class="pf-table">
                <thead>
                <tr>
                  <th>번호</th>
                  <th>시설명</th>
                  <th>예약대상</th>
                  <th>동/호</th>
                  <th>입주민명</th>
                  <th>이용시간</th>
                  <th>상태</th>
                </tr>
                </thead>

                <tbody>
                <c:forEach items="${pagingVO.dataList}" var="row" varStatus="st">
                  <tr>
                    <td>${pagingVO.totalRecord - ((pagingVO.currentPage - 1) * pagingVO.screenSize) - st.index}</td>
                    <td>${row.cmnFacilityNm}</td>
                    <td>${row.itemNm}</td>
                    <td>${row.dongNm} / ${row.ho}</td>
                    <td>${row.userNm}</td>
                    <td>${row.rsvtBgngDttm} ~ ${row.rsvtEndDttm}</td>
                    <td>
                      <c:choose>
                        <%-- 승인완료 --%>
                        <c:when test="${row.rsvtSttsCd eq 'APPROVED'}">
                          <span class="pf-badge pf-badge-approved">
                              ${row.rsvtSttsNm}
                          </span>
                        </c:when>

                        <%-- 승인대기 --%>
                        <c:when test="${row.rsvtSttsCd eq 'PENDING'}">
                          <span class="pf-badge pf-badge-pending">
                              ${row.rsvtSttsNm}
                          </span>
                        </c:when>

                        <%-- 거절 --%>
                        <c:when test="${row.rsvtSttsCd eq 'REJECTED'}">
                          <span class="pf-badge pf-badge-rejected">
                              ${row.rsvtSttsNm}
                          </span>
                        </c:when>

                        <%-- 취소 --%>
                        <c:when test="${row.rsvtSttsCd eq 'CANCELLED'}">
                          <span class="pf-badge pf-badge-cancelled">
                              ${row.rsvtSttsNm}
                          </span>
                        </c:when>

                        <%-- 승인만료 --%>
                        <c:when test="${row.rsvtSttsCd eq 'EXPIRED'}">
                          <span class="pf-badge pf-badge-expired">
                              ${row.rsvtSttsNm}
                          </span>
                        </c:when>

                      <%-- 기타 상태 예외 처리 --%>
                      <c:otherwise>
      <span class="pf-badge">
          ${row.rsvtSttsNm}
      </span>
                        </c:otherwise>

                      </c:choose>

                    </td>
                  </tr>
                </c:forEach>
                </tbody>
              </table>

              <div class="pf-paging">${pagingVO.pagingHTML}</div>
            </div>
          </div>
        </div>
      </div>
    </main>
  </div>
</div>

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
</script>
</body>
</html>
