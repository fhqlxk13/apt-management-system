<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<html lang="ko">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>우리집맵핑 - 공지사항</title>
    <!-- BEGIN: External Scripts -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- BEGIN: Custom Styles -->
    <style data-purpose="typography">
        @import url('https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap');

        body {
            font-family: 'Noto+Sans+KR', sans-serif;
            background-color: #F8FAFB;
        }
    </style>
    <style data-purpose="custom-colors">
        /* Emerald Green matches the reference image button color */
        .bg-brand-green {
            background-color: #14A852;
        }

        .text-brand-green {
            color: #14A852;
        }

        .border-brand-green {
            border-color: #14A852;
        }

        .hover-bg-brand-green:hover {
            background-color: #118e45;
        }
    </style>
    <style data-purpose="component-styling">
        /* Table row hover and transition */
        .notice-row {
            transition: background-color 0.2s ease-in-out;
        }

        .notice-row:hover {
            background-color: #F0FDF4;
            cursor: pointer;
        }

        /* Custom scrollbar for aesthetic consistency */
        ::-webkit-scrollbar {
            width: 8px;
        }

        ::-webkit-scrollbar-track {
            background: #f1f1f1;
        }

        ::-webkit-scrollbar-thumb {
            background: #ccc;
            border-radius: 4px;
        }

        ::-webkit-scrollbar-thumb:hover {
            background: #999;
        }

        .pagination {
            display: flex;
            justify-content: center;
            gap: 8px;
            list-style: none;
            padding: 0;
        }

        .pagination li {
            display: inline-block;
        }

        .pagination .page-link {
            padding: 6px 10px;
            background: #f1f1f1;
            border-radius: 6px;
            text-decoration: none;
        }

        .pagination .active .page-link {
            background: #6F7F3F;
            color: white;
        }

    </style>
    <!-- END: Custom Styles -->
</head>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/centralSidebarStyle.css">

<body class="bg-[#f8faf6]">
<%@ include file="/WEB-INF/views/include/main_headerLayout.jsp" %>
<%@ include file="/WEB-INF/views/include/central_sidebar.jsp" %>

<main class="ml-80 p-10 pt-28">
    <!-- BEGIN: PageHeader -->
    <div class="mb-8" data-purpose="page-title-section">
        <h1 class="text-3xl font-bold text-gray-900 mb-2">공지사항</h1>
        <p class="text-gray-500 text-sm">우리집맵핑의 새로운 소식과 안내사항을 확인하세요.</p>
    </div>
    <!-- END: PageHeader -->
    <!-- BEGIN: SearchAndFilters -->
    <div class="bg-white p-6 rounded-2xl shadow-sm border border-gray-100 mb-6" data-purpose="filter-bar">
        <div class="flex flex-col md:flex-row md:items-center justify-between gap-4">
            <!-- Category Chips -->
            <div class="flex flex-wrap gap-2" data-purpose="category-filters">
                <button class="px-5 py-2 rounded-full bg-[#6F7F3F] text-white text-sm font-medium transition-colors hover:bg-[#5f6e35]">
                    전체
                </button>

            </div>
            <!-- Search Input -->
            <div class="relative w-full md:w-80" data-purpose="search-container">
                <input class="w-full pl-4 pr-10 py-2.5 bg-gray-50 border-gray-200 rounded-xl focus:ring-brand-green focus:border-brand-green text-sm transition-all"
                       placeholder="검색어를 입력하세요" type="text"/>
                <div class="absolute right-3 top-1/2 -translate-y-1/2">
                    <svg class="h-5 w-5 text-gray-400" fill="none" stroke="currentColor" viewbox="0 0 24 24"
                         xmlns="http://www.w3.org/2000/svg">
                        <path d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" stroke-linecap="round"
                              stroke-linejoin="round" stroke-width="2"></path>
                    </svg>
                </div>
            </div>
        </div>
    </div>
    <!-- END: SearchAndFilters -->
    <!-- BEGIN: NoticeList -->
    <div class="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden"
         data-purpose="notice-table-container">
        <div class="overflow-x-auto">
            <table class="w-full text-left border-collapse" id="notice-table">
                <thead>
                <tr class="bg-gray-50 border-b border-gray-100">
                    <th class="px-6 py-4 text-sm font-semibold text-gray-600 w-20 text-center">번호</th>
                    <th class="px-6 py-4 text-sm font-semibold text-gray-600">제목</th>
                    <th class="px-6 py-4 text-sm font-semibold text-gray-600 w-32 text-center">등록일</th>
                    <th class="px-6 py-4 text-sm font-semibold text-gray-600 w-24 text-center">조회수</th>
                </tr>
                </thead>
                <tbody class="divide-y divide-gray-100">
                <c:forEach var="notice" items="${pagingVO.dataList}" varStatus="status">
                    <tr class="notice-row" onclick="location.href='detail.do?annNo=${notice.annNo}'">

                        <!-- 번호 -->
                        <td class="px-6 py-5 text-sm text-gray-400 text-center">
                                ${(pagingVO.currentPage - 1) * pagingVO.screenSize + status.index + 1}
                        </td>
                        <!-- 제목 -->
                        <td class="px-6 py-5">
                            <span class="text-sm font-medium text-gray-900">
                                    ${notice.ttl}
                            </span>
                        </td>

                        <!-- 등록일 -->
                        <td class="px-6 py-5 text-sm text-gray-500 text-center">
                            <fmt:formatDate value="${notice.regDttm}" pattern="yyyy.MM.dd"/>
                        </td>

                        <!-- 조회수 -->
                        <td class="px-6 py-5 text-sm text-gray-500 text-center">
                                ${notice.inqCnt}
                        </td>

                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
    <!-- END: NoticeList -->
    <!-- BEGIN: Pagination -->
    <div class="mt-8 flex justify-center gap-2">
        ${pagingVO.pagingHTML}
    </div>

    <style>
        .page-link {
            display: inline-block !important;
        }

        .mt-8 > * {
            display: inline-block !important;
        }
    </style>
    <!-- END: Pagination -->
</main>
<!-- END: MainContentArea -->
</body>
<script>
    document.addEventListener("click", function (e) {
        const link = e.target.closest(".page-link");

        if (link) {
            e.preventDefault();
            const page = link.dataset.page;
            location.href = "?page=" + page;
        }
    });
</script>
</html>