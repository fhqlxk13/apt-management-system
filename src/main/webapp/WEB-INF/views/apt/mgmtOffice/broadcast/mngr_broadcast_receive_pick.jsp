<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <sec:csrfMetaTags/>
    <title>방송 수신기 · 동 선택</title>
    <link rel="preconnect" href="https://fonts.googleapis.com"/>
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin/>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/office-layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/manager-common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common/toast.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/broadcast/mngr-broadcast.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/broadcast/mngr-broadcast-receive.css">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet"/>
</head>
<body>
<div class="app-wrapper">
    <%@ include file="/WEB-INF/views/include/office_sidebar.jsp" %>
    <div class="main-wrap">
        <%@ include file="/WEB-INF/views/include/office_header.jsp" %>
        <main class="main-content main-content--bc-receive">
            <div class="bc-receive-page">
                <header class="bc-receive-head">
                    <div>
                        <h2>방송 수신기</h2>
                        <p class="bc-receive-sub">이 PC를 담당 <strong>동 출력 장치</strong>로 쓸 동을 선택하세요.</p>
                    </div>
                </header>
                <section class="card bc-receive-card">
                    <p class="bc-receive-hint" style="margin-top:0;">
                        관리소장이 <a href="${pageContext.request.contextPath}/manager/complex/broadcast/${mgmtOfcNo}">방송 안내 관리</a>에서 송출하면,
                        선택한 동 화면에서 자동으로 안내 방송이 재생됩니다.
                    </p>
                    <ul class="bc-receive-dong-list bc-receive-dong-list--pick">
                        <c:forEach var="dong" items="${dongList}">
                            <c:set var="dongBase"
                                   value="${fn:contains(dong.dongNo, '_') ? fn:substringAfter(dong.dongNo, '_') : (empty dong.dongNm ? dong.dongNo : dong.dongNm)}"/>
                            <c:choose>
                                <c:when test="${fn:endsWith(dongBase, '동')}">
                                    <c:set var="itemLabel" value="${dongBase}"/>
                                </c:when>
                                <c:otherwise>
                                    <c:set var="itemLabel" value="${dongBase}동"/>
                                </c:otherwise>
                            </c:choose>
                            <li>
                                <a class="bc-receive-pick-btn"
                                   href="${pageContext.request.contextPath}/manager/complex/broadcast/receive/${mgmtOfcNo}?dongNo=${dong.dongNo}">
                                    <span class="material-symbols-rounded">volume_up</span>
                                    ${itemLabel} 수신기 열기
                                </a>
                            </li>
                        </c:forEach>
                    </ul>
                    <c:if test="${empty dongList}">
                        <p class="bc-receive-alert">등록된 동(APT_UNIT) 정보가 없습니다. 단지 세대 정보를 먼저 등록해 주세요.</p>
                    </c:if>
                </section>
            </div>
        </main>
    </div>
</div>
</body>
</html>
