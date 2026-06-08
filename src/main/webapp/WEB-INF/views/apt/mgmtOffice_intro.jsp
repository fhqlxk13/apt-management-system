<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>관리사무소 소개 – ${aptInfo.aptComplexInfo.aptCmplexNm}</title>

  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/headerStyle.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebarStyle.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footerStyle.css">

  <style>
    body {
      font-family: 'Noto Sans KR', sans-serif !important;
      background: var(--bg);
      color: var(--text-dark);
    }

    .material-symbols-outlined {
      font-family: 'Material Symbols Outlined' !important;
    }

    .font-headline {
      font-family: 'Plus Jakarta Sans', sans-serif !important;
    }

    /* 헤더 아래 전체 영역 */
    .main-shell {
      display: flex;
      align-items: stretch;
      width: 100%;
      min-height: calc(100vh - 114px);
      margin-top: 114px; /* header 전체 높이 */
      background: var(--bg);
    }

    /* 본문 오른쪽 영역 */
    .content-area {
      flex: 1;
      padding: 32px 40px 64px;
      min-width: 0;
    }

    /* 실제 본문 폭 */
    .page-content-wrap {
      max-width: 960px;
      width: 100%;
      margin: 0 auto;
    }

    .breadcrumb {
      display: flex;
      align-items: center;
      gap: 6px;
      font-size: 12px;
      color: var(--text-light);
      margin-bottom: 20px;
    }

    .breadcrumb svg {
      width: 11px;
      height: 11px;
      flex-shrink: 0;
    }

    .breadcrumb a {
      color: var(--text-light);
      transition: color .13s;
    }

    .breadcrumb a:hover {
      color: var(--green-dark);
    }

    .breadcrumb .cur {
      color: var(--green-dark);
      font-weight: 600;
    }

    .page-title {
      font-size: 20px;
      font-weight: 700;
      color: var(--text-dark);
      letter-spacing: -.5px;
      padding-bottom: 14px;
      border-bottom: 2px solid var(--green-dark);
      margin-bottom: 24px;
    }

    .office-profile {
      background: var(--green-dark);
      border-radius: 10px;
      padding: 22px 28px;
      display: flex;
      align-items: center;
      gap: 22px;
      margin-bottom: 18px;
    }

    .office-icon-wrap {
      width: 60px;
      height: 60px;
      border-radius: 10px;
      background: rgba(255,255,255,.15);
      display: flex;
      align-items: center;
      justify-content: center;
      flex-shrink: 0;
    }

    .office-icon-wrap svg {
      width: 30px;
      height: 30px;
      color: #fff;
    }

    .office-profile-info h2 {
      font-size: 17px;
      font-weight: 700;
      color: #fff;
      letter-spacing: -.4px;
      margin-bottom: 4px;
    }

    .office-profile-info .addr {
      font-size: 12.5px;
      color: rgba(255,255,255,.75);
    }

    .office-tags {
      display: flex;
      gap: 7px;
      margin-top: 9px;
      flex-wrap: wrap;
    }

    .office-tag {
      font-size: 11px;
      font-weight: 600;
      padding: 3px 10px;
      border-radius: 20px;
      background: rgba(255,255,255,.18);
      color: #fff;
    }

    .info-table {
      width: 100%;
      border-collapse: collapse;
      border: 1px solid var(--border);
      border-radius: 8px;
      overflow: hidden;
      margin-bottom: 24px;
      font-size: 13.5px;
    }

    .info-table tr {
      border-bottom: 1px solid var(--border);
    }

    .info-table tr:last-child {
      border-bottom: none;
    }

    .info-table th {
      width: 130px;
      padding: 13px 18px;
      background: var(--green-pale);
      color: var(--text-mid);
      font-weight: 600;
      text-align: left;
      border-right: 1px solid var(--border);
      white-space: nowrap;
    }

    .info-table td {
      padding: 13px 18px;
      color: var(--text-dark);
    }

    .info-table th.r {
      border-left: 1px solid var(--border);
      border-right: 1px solid var(--border);
    }

    .section-hd {
      display: flex;
      align-items: center;
      justify-content: space-between;
      border-bottom: 1px solid var(--border);
      padding-bottom: 11px;
      margin-bottom: 16px;
    }

    .section-hd h3 {
      font-size: 14.5px;
      font-weight: 700;
      color: var(--text-dark);
    }

    .section-hd .count {
      font-size: 12.5px;
      color: var(--text-light);
    }

    .section-hd .count em {
      color: var(--green-dark);
      font-weight: 600;
      font-style: normal;
    }

    .staff-grid {
      display: grid;
      grid-template-columns: repeat(4, 1fr);
      gap: 14px;
      margin-bottom: 24px;
    }

    .staff-card {
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: 8px;
      padding: 20px 10px 16px;
      border: 1px solid var(--border);
      border-radius: 8px;
      background: var(--white);
      transition: box-shadow .18s, transform .18s;
    }

    .staff-card:hover {
      box-shadow: 0 4px 16px rgba(45,90,61,.10);
      transform: translateY(-2px);
    }

    .staff-avatar {
      width: 52px;
      height: 52px;
      border-radius: 50%;
      background: var(--green-light);
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 18px;
      font-weight: 700;
      color: var(--green-dark);
    }

    .staff-name {
      font-size: 13px;
      font-weight: 600;
      color: var(--text-dark);
    }

    .staff-role {
      font-size: 11.5px;
      color: var(--text-light);
      margin-top: -4px;
    }

    .bottom-grid {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 18px;
    }

    .bottom-card {
      border: 1px solid var(--border);
      border-radius: 8px;
      overflow: hidden;
    }

    .bottom-card-head {
      background: var(--green-pale);
      padding: 11px 18px;
      border-bottom: 1px solid var(--border);
      font-size: 13.5px;
      font-weight: 700;
      color: var(--text-dark);
    }

    .hours-table {
      width: 100%;
      border-collapse: collapse;
      font-size: 13px;
    }

    .hours-table tr {
      border-bottom: 1px solid var(--border);
    }

    .hours-table tr:last-child {
      border-bottom: none;
    }

    .hours-table th {
      width: 90px;
      padding: 11px 18px;
      background: var(--bg);
      font-weight: 500;
      color: var(--text-mid);
      text-align: left;
      border-right: 1px solid var(--border);
    }

    .hours-table td {
      padding: 11px 18px;
      color: var(--text-dark);
    }

    .hours-table td.off {
      color: var(--text-light);
    }

    .doc-list {
      list-style: none;
    }

    .doc-item {
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 11px 18px;
      border-bottom: 1px solid var(--border);
      gap: 10px;
    }

    .doc-item:last-child {
      border-bottom: none;
    }

    .doc-left {
      display: flex;
      align-items: center;
      gap: 9px;
      flex: 1;
      min-width: 0;
    }

    .doc-dot {
      width: 6px;
      height: 6px;
      border-radius: 50%;
      background: var(--green-accent);
      flex-shrink: 0;
    }

    .doc-name {
      font-size: 13px;
      color: var(--text-dark);
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
    }

    .doc-date {
      font-size: 11.5px;
      color: var(--text-light);
      flex-shrink: 0;
    }

    .doc-btn {
      display: inline-flex;
      align-items: center;
      padding: 4px 10px;
      border: 1px solid var(--border);
      border-radius: 3px;
      font-size: 11px;
      font-weight: 600;
      color: var(--text-mid);
      background: var(--white);
      cursor: pointer;
      transition: all .15s;
      flex-shrink: 0;
      font-family: 'Noto Sans KR', sans-serif;
    }

    .doc-btn:hover {
      background: var(--green-dark);
      color: #fff;
      border-color: var(--green-dark);
    }

    @media (max-width: 1200px) {
      .content-area {
        padding: 24px 24px 48px;
      }

      .staff-grid {
        grid-template-columns: repeat(2, 1fr);
      }

      .bottom-grid {
        grid-template-columns: 1fr;
      }
    }
  </style>
</head>
<body>

<%@ include file="/WEB-INF/views/include/apt_headerLayout.jsp" %>
<div class="main-shell">
  <%@ include file="/WEB-INF/views/include/apt_sidebarLayout.jsp" %>

  <div class="content-area">
    <div class="page-content-wrap">

      <nav class="breadcrumb">
        <a href="${pageContext.request.contextPath}/">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round">
            <path d="M3 9.5L12 3l9 6.5V20a1 1 0 01-1 1H4a1 1 0 01-1-1V9.5z"/>
            <path d="M9 21V12h6v9"/>
          </svg>
        </a>
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" style="width:10px;height:10px;color:#bbb">
          <path d="M9 18l6-6-6-6"/>
        </svg>
        <a href="resident/manage/intro">관리사무소</a>
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" style="width:10px;height:10px;color:#bbb">
          <path d="M9 18l6-6-6-6"/>
        </svg>
        <span class="cur">관리사무소 소개</span>
      </nav>

      <h1 class="page-title">관리사무소 소개</h1>

      <div class="office-profile">
        <div class="office-icon-wrap">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.7" stroke-linecap="round">
            <rect x="2" y="7" width="20" height="15" rx="2"/>
            <path d="M16 7V5a2 2 0 00-2-2h-4a2 2 0 00-2 2v2"/>
          </svg>
        </div>
        <div class="office-profile-info">
          <%-- 관리사무소명은 office, 단지 관련 정보는 aptInfo 사용 --%>
          <h2>${office.mgmtOfcNm}</h2>
          <div class="addr">
            <c:choose>
              <c:when test="${not empty aptInfo.aptComplexInfo.dorojuso}">
                ${aptInfo.aptComplexInfo.dorojuso}
              </c:when>
              <c:otherwise>
                ${aptInfo.aptComplexInfo.sidoNm} ${aptInfo.aptComplexInfo.sigunguNm} ${aptInfo.aptComplexInfo.emdNm}
              </c:otherwise>
            </c:choose>
          </div>
          <div class="office-tags">
            <span class="office-tag">${aptInfo.aptComplexInfo.unitCnt}세대</span>
            <span class="office-tag">${aptInfo.aptComplexInfo.dongCnt}개 동</span>
            <span class="office-tag">
                <c:choose>
                  <c:when test="${not empty aptInfo.aptComplexInfo.bldYr and fn:length(aptInfo.aptComplexInfo.bldYr) == 8}">
                    ${fn:substring(aptInfo.aptComplexInfo.bldYr, 0, 4)}년
                    ${fn:substring(aptInfo.aptComplexInfo.bldYr, 4, 6)}월
                    ${fn:substring(aptInfo.aptComplexInfo.bldYr, 6, 8)}일 준공
                  </c:when>

                  <c:otherwise>
                    ${aptInfo.aptComplexInfo.bldYr} 준공
                  </c:otherwise>
                </c:choose>
              </span>
          </div>
        </div>
      </div>

      <table class="info-table">
        <tbody>
        <tr>
          <th>대표번호</th>
          <td>
            <%-- 전화번호 '-' 추가 방법 (참고 : apt-main.jsp와 동일) --%>
            <c:set var="telNo" value="${fn:replace(office.mgmtOfcTelno, '-', '')}" />
            <c:set var="telNo" value="${fn:replace(telNo, ' ', '')}" />
            <c:set var="telLength" value="${fn:length(telNo)}" />
            <c:choose>
              <c:when test="${fn:startsWith(telNo, '02') and telLength == 9}">
                ${fn:substring(telNo, 0, 2)}-${fn:substring(telNo, 2, 5)}-${fn:substring(telNo, 5, 9)}
              </c:when>

              <c:when test="${fn:startsWith(telNo, '02') and telLength == 10}">
                ${fn:substring(telNo, 0, 2)}-${fn:substring(telNo, 2, 6)}-${fn:substring(telNo, 6, 10)}
              </c:when>

              <c:when test="${not fn:startsWith(telNo, '02') and telLength == 10}">
                ${fn:substring(telNo, 0, 3)}-${fn:substring(telNo, 3, 6)}-${fn:substring(telNo, 6, 10)}
              </c:when>

              <c:when test="${not fn:startsWith(telNo, '02') and telLength == 11}">
                ${fn:substring(telNo, 0, 3)}-${fn:substring(telNo, 3, 7)}-${fn:substring(telNo, 7, 11)}
              </c:when>

              <c:otherwise>
                ${office.mgmtOfcTelno}
              </c:otherwise>
            </c:choose>
          </td>
          <th class="r">운영시간</th>
          <td>평일 09:00 ~ 18:00</td>
        </tr>
        <tr>
          <th>점심시간</th>
          <td>12:00 ~ 13:00</td>
          <th class="r"></th>
          <td></td>
        </tr>
        <tr>
          <th>이메일</th>
          <td>
            <c:choose>
              <c:when test="${not empty office.mgmtOfcEml}">
                ${office.mgmtOfcEml}
              </c:when>
              <c:otherwise>-</c:otherwise>
            </c:choose>
          </td>
          <th class="r">휴무일</th>
          <td>토일·공휴일</td>
        </tr>
        </tbody>
      </table>

      <div class="section-hd">
        <h3>관리 직원 소개</h3>
        <span class="count">총 <em>4</em>명</span>
      </div>

      <div class="staff-grid">
        <div class="staff-card">
          <div class="staff-avatar">김</div>
          <div class="staff-name">김○○</div>
          <div class="staff-role">관리소장</div>
        </div>
        <div class="staff-card">
          <div class="staff-avatar">이</div>
          <div class="staff-name">이○○</div>
          <div class="staff-role">관리소장</div>
        </div>
        <div class="staff-card">
          <div class="staff-avatar">박</div>
          <div class="staff-name">박○○</div>
          <div class="staff-role">관리소장</div>
        </div>
        <div class="staff-card">
          <div class="staff-avatar">최</div>
          <div class="staff-name">최○○</div>
          <div class="staff-role">관리소장</div>
        </div>
      </div>

      <div class="bottom-grid">
        <div class="bottom-card">
          <div class="bottom-card-head">운영시간 안내</div>
          <table class="hours-table">
            <tbody>
            <tr><th>월 – 금</th><td>09:00 ~ 18:00</td></tr>
            <tr><th>점심시간</th><td>12:00 ~ 13:00</td></tr>
            <tr><th>토요일</th><td>09:00 ~ 13:00</td></tr>
            <tr><th>일·공휴일</th><td class="off">휴무</td></tr>
            </tbody>
          </table>
        </div>

        <div class="bottom-card">
          <div class="bottom-card-head">관리 서류 다운로드</div>
          <ul class="doc-list">
            <li class="doc-item">
              <div class="doc-left">
                <span class="doc-dot"></span>
                <span class="doc-name">관리규약 (2025년 개정)</span>
              </div>
              <span class="doc-date">2025.01.01</span>
              <button class="doc-btn" onclick="location.href='${pageContext.request.contextPath}/manage/download?file=rule_2025.pdf'">PDF</button>
            </li>
            <li class="doc-item">
              <div class="doc-left">
                <span class="doc-dot"></span>
                <span class="doc-name">업무 운영수칙</span>
              </div>
              <span class="doc-date">2024.10.10</span>
              <button class="doc-btn" onclick="location.href='${pageContext.request.contextPath}/manage/download?file=operation_rule.pdf'">PDF</button>
            </li>
            <li class="doc-item">
              <div class="doc-left">
                <span class="doc-dot"></span>
                <span class="doc-name">주차 운영 규정</span>
              </div>
              <span class="doc-date">2024.06.01</span>
              <button class="doc-btn" onclick="location.href='${pageContext.request.contextPath}/manage/download?file=parking_rule.pdf'">PDF</button>
            </li>
          </ul>
        </div>
      </div>

    </div>
  </div>
</div>

<%@ include file="/WEB-INF/views/include/apt_footerLayout.jsp" %>

</body>
</html>