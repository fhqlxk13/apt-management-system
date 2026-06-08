<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>공지사항 상세</title>

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

        /* 헤더 아래부터 화면 시작 */
        .main-shell {
            display: flex;
            align-items: stretch;
            width: 100%;
            min-height: calc(100vh - 114px);
            margin-top: 114px;
            background: var(--bg);
        }

        /* 사이드바 오른쪽 본문 영역 */
        .content-area {
            flex: 1;
            min-width: 0;
            padding: 32px 40px 64px;
        }

        .notice-detail-wrap {
            max-width: 1080px;
            width: 100%;
            margin: 0 auto;
        }

        .notice-detail-card {
            background: #fff;
            border: 1px solid var(--border);
            border-radius: 14px;
            padding: 32px;
        }


        .notice-meta {
            color: #667085;
            font-size: 14px;
            margin-bottom: 28px;
        }

        .notice-content {
            line-height: 1.8;
            font-size: 16px;
            border-top: 1px solid var(--border);
            padding-top: 24px;
        }

        .notice-body-image-area {
            margin-bottom: 24px;
        }

        .notice-inline-image {
            display: block;
            width: 320px;
            max-width: 100%;
            height: auto;
            border: 1px solid var(--border);
            border-radius: 12px;
        }


        .notice-text {
            white-space: pre-line;
            margin: 0;
        }

        .notice-nav-list {
            margin-top: 28px;
            border-top: 1px solid var(--border);
            border-bottom: 1px solid var(--border);
        }

        .notice-nav-row {
            display: flex;
            padding: 16px 12px;
            border-bottom: 1px solid #edf0eb;
            font-size: 14px;
        }

        .notice-nav-row:last-child {
            border-bottom: none;
        }

        .notice-nav-label {
            width: 100px;
            font-weight: 800;
            color: var(--green-dark);
        }

        .notice-nav-row a {
            color: var(--text-dark);
            text-decoration: none;
            font-weight: 700;
        }

        .notice-detail-top {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 20px;
            margin-bottom: 18px;
        }

        .notice-title {
            display: flex;
            align-items: center;
            gap: 10px;
            margin: 0;
            font-size: 28px;
            font-weight: 900;
        }

        .notice-list-btn {
            flex: 0 0 auto;
            padding: 12px 22px;
            border-radius: 999px;
            background: var(--green-dark);
            color: #fff;
            text-decoration: none;
            font-weight: 800;
        }

        .notice-emergency-badge {
            display: inline-flex;
            align-items: center;
            padding: 4px 10px;
            border-radius: 999px;
            background: #ffe8e8;
            color: #d93025;
            font-size: 12px;
            font-weight: 900;
            white-space: nowrap;
        }

        .notice-file-box {
            margin-top: 18px;
            padding-top: 18px;
            border-top: 1px solid var(--border);
        }

        .notice-file-title {
            font-size: 15px;
            font-weight: 900;
            margin-bottom: 12px;
        }

        .notice-file-empty {
            color: #98a2b3;
            font-size: 14px;
        }

        .notice-file-name {
            font-size: 14px;
            font-weight: 700;
            margin-bottom: 14px;
        }

        .notice-file-name a {
            margin-left: 12px;
            color: var(--green-dark);
            text-decoration: none;
            font-weight: 900;
        }

        .notice-file-image {
            display: block;

            /*
             * 미리보기 썸네일 크기
             * 세로 이미지도 너무 커지지 않게 제한
             */
            width: 220px;
            max-width: 100%;

            /*
             * 비율 유지
             * height:auto가 핵심
             */
            height: auto;

            border: 1px solid var(--border);
            border-radius: 12px;

            cursor: pointer;

            /*
             * 부드러운 확대 효과
             */
            transition: transform 0.2s ease;
        }

        /*
         * 마우스 올리면 살짝 확대
         */
        .notice-file-image:hover {

            transform: scale(1.02);
        }

        .notice-image-link {
            display: inline-block;
            line-height: 0;
        }

        .notice-inline-image {
            display: block;
            width: 320px;
            max-width: 100%;
            height: auto;
            border: 1px solid var(--border);
            border-radius: 12px;
        }
    </style>
</head>

<body>
<%@ include file="/WEB-INF/views/include/apt_headerLayout.jsp" %>

<div class="main-shell">
    <%@ include file="/WEB-INF/views/include/apt_sidebarLayout.jsp" %>

    <main class="content-area">
        <div class="notice-detail-wrap">

            <section class="notice-detail-card">
                <div class="notice-detail-top">
                    <h1 class="notice-title">
                        <c:if test="${notice.topFixYn eq 'Y'}">
                            <span class="notice-emergency-badge">긴급</span>
                        </c:if>
                        <span>${notice.ttl}</span>
                    </h1>

                    <a class="notice-list-btn"
                       href="${pageContext.request.contextPath}/resident/board/notice/${aptCmplexNo}">
                        목록
                    </a>
                </div>

                <div class="notice-meta">
                    작성자 : ${notice.wrtrId}
                    · 작성일 : ${notice.regDttm}
                    · 조회수 : ${notice.inqCnt}
                </div>

                <%-- 공지본문 --%>
                <div class="notice-content">
                    <%-- 첨부 이미지: 본문 위쪽에 출력 --%>
                    <div class="notice-body-image-area">
                        <c:forEach var="file" items="${notice.attachFileList}">
                            <c:if test="${not empty file.googleId
                        and not empty file.mimeType
                        and file.mimeType.startsWith('image/')}">

                                <img src="${pageContext.request.contextPath}/file/display/${file.googleId}"
                                     alt="${file.fileOgName}"
                                     class="notice-inline-image">

                            </c:if>
                        </c:forEach>
                    </div>

                    <%-- 실제 공지 본문 --%>
                    <div class="notice-text">
                        <c:out value="${notice.cn}"/>
                    </div>
                </div>

                <!-- 첨부파일 영역 -->
                <div class="notice-file-box">
                    <div class="notice-file-title">첨부파일</div>

                    <c:choose>
                        <c:when test="${not empty notice.attachFileList}">

                            <c:forEach var="file" items="${notice.attachFileList}">

                                <div class="notice-file-name">
                                    📎 ${file.fileOgName}

                                    <a href="${pageContext.request.contextPath}/file/download/${file.googleId}">
                                        다운로드
                                    </a>
                                </div>
                                <%-- 미리보기 사진 --%>
<%--                                <c:if test="${not empty file.googleId--%>
<%--                                  and not empty file.mimeType--%>
<%--                                  and file.mimeType.startsWith('image/')}">--%>

<%--                                    <a href="${pageContext.request.contextPath}/file/display/${file.googleId}"--%>
<%--                                       target="_blank"--%>
<%--                                       rel="noopener noreferrer"--%>
<%--                                       class="notice-image-link">--%>

<%--                                        <img src="${pageContext.request.contextPath}/file/display/${file.googleId}"--%>
<%--                                             alt="${file.fileOgName}"--%>
<%--                                             class="notice-file-image">--%>

<%--                                    </a>--%>
<%--                                </c:if>--%>

                            </c:forEach>

                        </c:when>

                        <c:otherwise>
                            <div class="notice-file-empty">첨부파일 없음</div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="notice-nav-list">

                    <%-- 다음글 --%>
                    <div class="notice-nav-row">
                        <div class="notice-nav-label">다음글</div>

                        <div>
                            <c:choose>
                                <c:when test="${not empty nextNotice}">
                                    <a href="${pageContext.request.contextPath}/resident/board/notice/detail/${aptCmplexNo}/${nextNotice.annNo}">
                                            ${nextNotice.ttl}
                                    </a>
                                </c:when>

                                <c:otherwise>
                                    다음글이 없습니다.
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <%-- 이전글 --%>
                    <div class="notice-nav-row">
                        <div class="notice-nav-label">이전글</div>

                        <div>
                            <c:choose>
                                <c:when test="${not empty prevNotice}">
                                    <a href="${pageContext.request.contextPath}/resident/board/notice/detail/${aptCmplexNo}/${prevNotice.annNo}">
                                            ${prevNotice.ttl}
                                    </a>
                                </c:when>

                                <c:otherwise>
                                    이전글이 없습니다.
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                </div>
            </section>

        </div>
    </main>
</div>

<%@ include file="/WEB-INF/views/include/apt_footerLayout.jsp" %>
</body>
</html>