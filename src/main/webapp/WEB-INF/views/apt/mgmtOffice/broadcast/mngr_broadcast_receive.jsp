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
    <title>방송 수신 · ${dongLabel}</title>
    <link rel="preconnect" href="https://fonts.googleapis.com"/>
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin/>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/office-layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/manager-common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common/toast.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/broadcast/mngr-broadcast.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/broadcast/mngr-broadcast-receive.css">
</head>
<body>
<div class="app-wrapper">
    <%@ include file="/WEB-INF/views/include/office_sidebar.jsp" %>
    <div class="main-wrap">
        <%@ include file="/WEB-INF/views/include/office_header.jsp" %>
        <main class="main-content main-content--bc-receive">
            <div class="bc-receive-page" id="broadcastReceivePage" data-page="broadcast-receive">
                <div id="bcReceiveFlash" class="bc-receive-flash" hidden aria-live="assertive" role="status">
                    <span class="material-symbols-rounded">campaign</span>
                    <strong id="bcReceiveFlashTitle">방송중</strong>
                    <span id="bcReceiveFlashText"></span>
                </div>
                <header class="bc-receive-head">
                    <div>
                        <h2>방송 수신기</h2>
                        <p class="bc-receive-sub">이 PC를 <strong>${fn:escapeXml(dongLabel)}</strong> 출력 장치로 사용합니다.</p>
                    </div>
                    <span class="bc-receive-badge" id="wsStatusBadge">연결 대기</span>
                </header>

                <c:if test="${not dongValid}">
                    <div class="bc-receive-alert" role="alert">
                        등록되지 않은 동 코드입니다. URL의 <code>dongNo</code>를 확인해 주세요.
                    </div>
                </c:if>

                <section class="card bc-receive-card">
                    <div class="bc-receive-status" id="receiveStatus">
                        <span class="material-symbols-rounded bc-receive-icon" id="receiveStatusIcon">podcasts</span>
                        <div>
                            <p class="bc-receive-status-title" id="receiveStatusTitle">대기 중</p>
                            <p class="bc-receive-status-msg" id="receiveStatusMsg">방송 송출 시 이 화면에서 자동 재생됩니다.</p>
                        </div>
                    </div>
                    <div class="bc-receive-meta">
                        <div><span class="label">관리사무소</span><span>${mgmtOfcNo}</span></div>
                        <div><span class="label">수신 동</span><span>${fn:escapeXml(dongLabel)}</span></div>
                        <div><span class="label">동 코드</span><span>${fn:escapeXml(dongNo)}</span></div>
                        <div><span class="label">구독 경로</span><span id="receiveSubDest" class="bc-receive-subdest">—</span></div>
                        <div><span class="label">서버 주소</span><span id="receiveServerOrigin" class="bc-receive-subdest" title="송출 PC와 이 주소가 같아야 합니다">—</span></div>
                    </div>
                    <p class="bc-receive-audio-hint" id="receiveAudioHint">
                        방송이 오면 <strong>버튼 없이 자동 재생</strong>됩니다. 송출 PC와 <strong>같은 서버 주소</strong>·<strong>동 코드</strong>가 맞는지 확인하세요.
                    </p>
                    <button type="button" class="bc-receive-unlock-btn" id="receiveAudioUnlockBtn" hidden>
                        <span class="material-symbols-rounded">volume_up</span>소리가 안 들릴 때만 클릭
                    </button>
                    <button type="button" class="bc-receive-verify-btn" id="receiveVerifyBtn">
                        <span class="material-symbols-rounded">fact_check</span>수신 연결 확인
                    </button>
                    <p class="bc-receive-verify-result" id="receiveVerifyResult">페이지를 연 두면 자동으로 수신 대기합니다.</p>
                    <p class="bc-receive-last" id="receiveLastText" hidden></p>
                    <audio id="receiveAudio" preload="auto" playsinline></audio>
                </section>

                <section class="card bc-receive-links">
                    <h3>다른 동 수신기</h3>
                    <ul class="bc-receive-dong-list">
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
                                <a href="${pageContext.request.contextPath}/manager/complex/broadcast/receive/${mgmtOfcNo}?dongNo=${dong.dongNo}"
                                   class="${dong.dongNo eq dongNo ? 'active' : ''}">${itemLabel}</a>
                            </li>
                        </c:forEach>
                    </ul>
                    <p class="bc-receive-hint">
                        <a href="${pageContext.request.contextPath}/manager/complex/broadcast/${mgmtOfcNo}">방송 안내 작성</a> 화면에서 송출합니다.
                    </p>
                </section>
            </div>
        </main>
    </div>
</div>

<div id="bcReceiveToastContainer" aria-live="polite"></div>

<script src="${pageContext.request.contextPath}/js/common/toast.js"></script>
<script>
    window.BC_RECEIVE = {
        contextPath: '${pageContext.request.contextPath}',
        mgmtOfcNo: '${mgmtOfcNo}',
        dongNo: '${dongNo}',
        dongLabel: '${fn:escapeXml(dongLabel)}',
        dongValid: '${dongValid}'
    };
</script>
<script src="${pageContext.request.contextPath}/js/manager/broadcast/mngr-broadcast-receive.js"></script>
</body>
</html>
