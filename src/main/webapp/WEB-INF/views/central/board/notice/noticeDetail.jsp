<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!-- 사이드바 스타일 -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/centralSidebarStyle.css">

<body class="bg-[#f8faf6]">

<!-- 헤더 -->
<%@ include file="/WEB-INF/views/ztestview/header.jsp" %>

<!-- 사이드바 -->
<%@ include file="/WEB-INF/views/include/central_sidebar.jsp" %>


<main class="ml-80 p-10 pt-28">

    <!-- 제목 영역 -->
    <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-8 mb-6">
        <h1 class="text-2xl font-bold text-gray-900 mb-4">
            ${notice.ttl}
        </h1>

        <div class="flex items-center text-sm text-gray-500 gap-4">
            <span>작성자: ${notice.wrtrId}</span>
            <span>|</span>
            <span>
        등록일:
        <fmt:formatDate value="${notice.regDttm}" pattern="yyyy.MM.dd"/>
      </span>
            <span>|</span>
            <span>조회수: ${notice.inqCnt}</span>
        </div>
    </div>

    <!-- 내용 영역 -->
    <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-8 mb-6">
        <div class="text-gray-800 leading-relaxed whitespace-pre-line">
            ${notice.cn}
        </div>
    </div>

    <!-- 버튼 영역 -->
    <div class="flex justify-between">
        <button onclick="location.href='${pageContext.request.contextPath}/notice/list.do'"
                class="px-6 py-2 rounded-lg border border-gray-300 text-gray-600 hover:bg-gray-100 transition">
            목록
        </button>

        <div class="flex gap-2">

        </div>
    </div>

</main>

</body>