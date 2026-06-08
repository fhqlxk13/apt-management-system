<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>편의시설예약</title>

  <%-- 시설관리이력 페이지와 같은 공통 CSS --%>
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
      letter-spacing: -0.4px;
    }

    .page-desc {
      font-size: 14px;
      color: var(--text-light);
      margin-bottom: 24px;
      line-height: 1.7;
    }

    .facility-card-grid {
      display: grid;
      grid-template-columns: repeat(3, minmax(260px, 1fr));
      gap: 18px;
    }

    .facility-card {
      display: block;
      background: #ffffff;
      border: 1px solid var(--border);
      border-radius: 14px;
      padding: 28px 24px;
      text-decoration: none;
      color: var(--text-dark);
      box-shadow: 0 10px 24px rgba(30, 60, 40, 0.05);
      transition: 0.2s;
    }

    .facility-card:hover {
      border-color: var(--green-dark);
      box-shadow: 0 12px 26px rgba(30, 60, 40, 0.12);
      transform: translateY(-2px);
    }

    .facility-card-title {
      font-size: 19px;
      font-weight: 800;
      margin-bottom: 0;
    }

    .facility-card-top {
      display: flex;
      justify-content: space-between;
      align-items: flex-start;
      gap: 10px;
      margin-bottom: 14px;
    }

    .approval-badge {
      flex-shrink: 0;
      padding: 5px 9px;
      border-radius: 999px;
      font-size: 12px;
      font-weight: 800;
      white-space: nowrap;
    }

    .approval-badge.auto {
      background: #e8f5ee;
      color: #1f6b3a;
      border: 1px solid #b7dfc7;
    }

    .approval-badge.manager {
      background: #fff3dc;
      color: #9a5a00;
      border: 1px solid #ffd58a;
    }

    .facility-card-desc {
      font-size: 13px;
      color: var(--text-light);
      line-height: 1.7;
      margin-bottom: 18px;
    }

    .facility-card-link {
      font-size: 14px;
      font-weight: 800;
      color: var(--green-dark);
    }

    .empty-box {
      background: #ffffff;
      border: 1px solid var(--border);
      border-radius: 14px;
      padding: 32px;
      color: var(--text-light);
      box-shadow: 0 10px 24px rgba(30, 60, 40, 0.05);
    }

    @media (max-width: 900px) {
      .main-shell {
        flex-direction: column;
      }

      .content-area {
        padding: 24px 18px 48px;
      }

      .facility-card-grid {
        grid-template-columns: 1fr;
      }
    }
  </style>
</head>

<body>

<%-- 시설관리이력과 동일: 헤더 먼저 --%>
<%@ include file="/WEB-INF/views/include/apt_headerLayout.jsp" %>

<div class="main-shell">

  <%-- 시설관리이력과 동일: main-shell 안에 사이드바 --%>
  <%@ include file="/WEB-INF/views/include/apt_sidebarLayout.jsp" %>

  <main class="content-area">
    <div class="page-content-wrap">

      <div class="breadcrumb">
        <a href="${pageContext.request.contextPath}/">HOME</a>
        <span>›</span>
        <a href="javascript:void(0);">생활지원서비스</a>
        <span>›</span>
        <span class="cur">편의시설예약</span>
      </div>

      <h1 class="page-title">편의시설예약</h1>

      <p class="page-desc">
        예약하고 싶은 편의시설을 선택하세요.
        시설을 선택하면 예약대상을 선택하여 예약할 수 있습니다.
      </p>

      <c:choose>
        <c:when test="${not empty facilityList}">
          <div class="facility-card-grid">
            <c:forEach var="facility" items="${facilityList}">

              <a class="facility-card"
                 href="${pageContext.request.contextPath}/resident/publicFacility/reservation/${aptCmplexNo}/${facility.cmnFacilityNo}">

<%--                <div class="facility-card-title">--%>
<%--                    ${facility.cmnFacilityNm} 예약--%>
<%--                </div>--%>
                      <div class="facility-card-top">
                        <div class="facility-card-title">
                            ${facility.cmnFacilityNm} 예약
                        </div>

                        <c:choose>
                          <c:when test="${fn:contains(facility.cmnFacilityNm, '회의실')
                                        or fn:contains(facility.cmnFacilityNm, '커뮤니티룸')
                                        or fn:contains(facility.cmnFacilityNm, '라운지')
                                        or fn:contains(facility.cmnFacilityNm, '테니스장')}">
                            <span class="approval-badge manager">관리자 승인</span>
                          </c:when>

                          <c:otherwise>
                            <span class="approval-badge auto">자동승인</span>
                          </c:otherwise>
                        </c:choose>
                      </div>

                <div class="facility-card-desc">
                  <c:choose>
                    <c:when test="${not empty facility.cmnFacilityCn}">
                      ${facility.cmnFacilityCn}
                    </c:when>
                    <c:otherwise>
                      ${facility.cmnFacilityNm}을 선택하여 예약할 수 있습니다.
                    </c:otherwise>
                  </c:choose>
                </div>

                <div class="facility-card-link">
                  예약하러 가기
                </div>

              </a>

            </c:forEach>
          </div>
        </c:when>

        <c:otherwise>
          <div class="empty-box">
            예약 가능한 편의시설이 없습니다.
          </div>
        </c:otherwise>
      </c:choose>

    </div>
  </main>
</div>

<%-- 시설관리이력과 동일: 푸터 포함 --%>
<%@ include file="/WEB-INF/views/include/apt_footerLayout.jsp" %>

</body>
</html>