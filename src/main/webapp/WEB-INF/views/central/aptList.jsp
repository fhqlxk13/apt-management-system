<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>

<html class="light" lang="ko">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>단지 목록 조회 - 우리집맵핑</title>

    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&amp;display=swap"
          rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap"
          rel="stylesheet"/>

    <script id="tailwind-config">
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    "colors": {
                        "surface": "#fbf9f5",
                        "primary": "#56642b",
                        "on-primary-container": "#253000",
                        "surface-container": "#efeeea",
                        "on-surface": "#1b1c1a",
                        "on-error": "#ffffff",
                        "inverse-surface": "#30312e",
                        "surface-tint": "#56642b",
                        "surface-container-low": "#f5f3ef",
                        "inverse-primary": "#bdce89",
                        "secondary-fixed-dim": "#b4cdb7",
                        "background": "#fbf9f5",
                        "secondary-fixed": "#d0e9d2",
                        "on-primary-fixed-variant": "#3e4c16",
                        "on-secondary": "#ffffff",
                        "on-background": "#1b1c1a",
                        "surface-container-high": "#eae8e4",
                        "primary-fixed": "#d9eaa3",
                        "on-tertiary-fixed-variant": "#155037",
                        "tertiary": "#30694d",
                        "on-primary": "#ffffff",
                        "on-secondary-container": "#546a58",
                        "on-tertiary-container": "#003320",
                        "error": "#ba1a1a",
                        "on-surface-variant": "#46483c",
                        "outline": "#76786b",
                        "surface-variant": "#e4e2de",
                        "inverse-on-surface": "#f2f0ed",
                        "surface-container-highest": "#e4e2de",
                        "tertiary-fixed": "#b4f0cd",
                        "primary-fixed-dim": "#bdce89",
                        "surface-container-lowest": "#ffffff",
                        "on-tertiary-fixed": "#002113",
                        "tertiary-container": "#669f80",
                        "surface-dim": "#dbdad6",
                        "error-container": "#ffdad6",
                        "outline-variant": "#c6c8b8",
                        "on-primary-fixed": "#161f00",
                        "secondary-container": "#d0e9d2",
                        "tertiary-fixed-dim": "#98d3b2",
                        "secondary": "#4e6452",
                        "on-error-container": "#93000a",
                        "on-tertiary": "#ffffff",
                        "primary-container": "#8a9a5b",
                        "on-secondary-fixed-variant": "#364c3b",
                        "on-secondary-fixed": "#0b2012",
                        "surface-bright": "#fbf9f5"
                    },
                    "borderRadius": {
                        "DEFAULT": "0.25rem",
                        "lg": "0.5rem",
                        "xl": "0.75rem",
                        "full": "9999px"
                    },
                    "fontFamily": {
                        "headline": ["Manrope"],
                        "body": ["Manrope"],
                        "label": ["Manrope"]
                    }
                }
            }
        }
    </script>

    <style>
        body {
            font-family: 'Manrope', sans-serif;
        }

        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
        }

        .pagination {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .pagination .page-item {
            list-style: none;
        }

        .pagination .page-link {
            width: 40px;
            height: 40px;
            border-radius: 9999px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #ffffff;
            border: 1px solid #e5e7eb;
            color: #94a3b8;
            font-size: 14px;
            font-weight: 700;
            transition: all .2s ease;
            text-decoration: none;
            box-shadow: 0 1px 2px rgba(0, 0, 0, .03);
        }

        .pagination .page-link:hover {
            background: #f8fafc;
            border-color: #cbd5e1;
            color: #475569;
            transform: translateY(-1px);
        }

        .pagination .active .page-link {
            background: #065f46;
            border-color: #065f46;
            color: white;
            box-shadow: 0 6px 14px rgba(6, 95, 70, .18);
        }

        .pagination .page-link[data-page] {
            cursor: pointer;
        }
    </style>
</head>

<body class="bg-surface text-on-surface flex flex-col min-h-screen">

<%@ include file="/WEB-INF/views/include/main_headerLayout.jsp" %>
<%@ include file="/WEB-INF/views/include/central_sidebar.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/centralSidebarStyle.css">

<main class="ml-80 p-10 pt-28">

    <!-- Header -->
    <div class="flex flex-col md:flex-row md:items-center justify-between gap-6 mb-8">
        <div>
            <div class="flex items-center gap-2 text-slate-400 text-sm mb-2 font-label-md">
                <span>Home</span>
                <span class="material-symbols-outlined text-[16px]" data-icon="chevron_right">chevron_right</span>
                <span>공공주택정보</span>
                <span class="material-symbols-outlined text-[16px]" data-icon="chevron_right">chevron_right</span>
                <span class="text-primary font-bold">단지목록</span>
            </div>

            <h1 class="text-4xl font-bold tracking-tight text-on-surface mb-2">
                단지목록
            </h1>

            <p class="text-gray-500 mb-6">
                단지정보를 조회하고 확인할 수 있습니다.
            </p>
        </div>

        <div class="relative group max-w-sm w-full">
            <span class="absolute left-4 top-1/2 -translate-y-1/2 material-symbols-outlined text-slate-400"
                  data-icon="search">search</span>
            <input class="pl-12 pr-4 py-3 bg-white border border-[#eef2eb] rounded-full w-full focus:ring-2 focus:ring-primary/20 transition-all text-sm shadow-sm"
                   placeholder="단지명 또는 공고문 검색"
                   type="text"/>
        </div>
    </div>

    <!-- Search & Filter Area -->
    <div class="bg-white p-6 rounded-2xl border border-[#eef2eb] mb-8 shadow-sm">

        <form action="${pageContext.request.contextPath}/main/apt/list.do"
              method="get"
              id="aptSearchForm"
              class="flex flex-wrap items-center gap-4">

            <!-- 시/도 -->
            <div class="flex items-center gap-2 min-w-[140px] flex-1">
                <span class="text-sm font-bold text-slate-500 shrink-0">지역</span>

                <select name="sidoNm"
                        id="sidoNm"
                        class="filter-select w-full bg-[#f1f3ef] border-none rounded-full px-4 py-2 text-sm focus:ring-2 focus:ring-primary/20">
                    <option value="">시/도 전체</option>

                    <c:forEach var="sido" items="${sidoList}">
                        <option value="${sido}"
                                <c:if test="${searchVO.sidoNm eq sido}">selected</c:if>>
                                ${sido}
                        </option>
                    </c:forEach>
                </select>
            </div>

            <!-- 시/군/구 -->
            <div class="flex items-center gap-2 min-w-[140px] flex-1">
                <select name="sigunguNm"
                        id="sigunguNm"
                        class="filter-select w-full bg-[#f1f3ef] border-none rounded-full px-4 py-2 text-sm focus:ring-2 focus:ring-primary/20">
                    <option value="">시/군/구</option>
                </select>
            </div>

            <!-- 세대수 -->
            <div class="flex items-center gap-2 min-w-[140px] flex-1">
                <span class="text-sm font-bold text-slate-500 shrink-0">세대수</span>

                <select name="unitCnt"
                        id="unitCnt"
                        class="filter-select w-full bg-[#f1f3ef] border-none rounded-full px-4 py-2 text-sm focus:ring-2 focus:ring-primary/20">
                    <option value="0" ${searchVO.unitCnt == 0 ? 'selected' : ''}>전체</option>
                    <option value="1" ${searchVO.unitCnt == 1 ? 'selected' : ''}>500세대 미만</option>
                    <option value="2" ${searchVO.unitCnt == 2 ? 'selected' : ''}>500세대 이상 ~ 1000세대 미만</option>
                    <option value="3" ${searchVO.unitCnt == 3 ? 'selected' : ''}>1000세대 이상</option>
                </select>
            </div>

            <!-- 단지명 -->
            <div class="flex gap-2 flex-grow">
                <div class="flex-grow min-w-[200px]">
                    <input name="keyword"
                           value="${param.keyword}"
                           class="w-full bg-[#f1f3ef] border-none rounded-full px-6 py-2 text-sm focus:ring-2 focus:ring-primary/20"
                           placeholder="단지명 검색"
                           type="text"/>
                </div>

                <button type="submit"
                        class="px-8 py-2 bg-primary text-white rounded-full font-bold text-sm hover:bg-opacity-90 transition-all">
                    검색
                </button>
            </div>

        </form>
    </div>

    <!-- 초성 필터 -->
    <div class="bg-white p-5 rounded-2xl border border-[#eef2eb] mb-6 shadow-sm">
        <div class="flex flex-wrap items-center gap-2">
            <span class="text-sm font-bold text-slate-500 mr-2">초성</span>

            <c:url var="allUrl" value="/main/apt/list.do"/>
            <a href="${allUrl}"
               class="px-4 py-2 rounded-full text-sm font-bold border transition-all
                ${empty param.initial ? 'bg-primary text-white border-primary' : 'bg-white text-slate-500 border-slate-200 hover:bg-slate-50'}">
                전체
            </a>

            <c:forEach var="initial" items="${fn:split('ㄱ,ㄴ,ㄷ,ㄹ,ㅁ,ㅂ,ㅅ,ㅇ,ㅈ,ㅊ,ㅋ,ㅌ,ㅍ,ㅎ', ',')}">
                <c:url var="initialUrl" value="/main/apt/list.do">
                    <c:param name="initial" value="${initial}"/>
                </c:url>

                <a href="${initialUrl}"
                   class="px-4 py-2 rounded-full text-sm font-bold border transition-all
                  ${param.initial eq initial ? 'bg-primary text-white border-primary' : 'bg-white text-slate-500 border-slate-200 hover:bg-slate-50'}">
                        ${initial}
                </a>
            </c:forEach>
        </div>
    </div>

    <!-- Summary Info & Toggle -->
    <div class="flex items-center justify-between mb-6">
        <div class="flex items-center gap-2">
            <span class="text-primary font-bold">총 ${pagingVO.totalRecord}개 단지</span>
        </div>

        <div class="flex bg-[#f1f3ef] p-1 rounded-full">
            <button type="button"
                    class="bg-primary text-white px-4 py-1.5 rounded-full text-xs font-bold flex items-center gap-1">
                <span class="material-symbols-outlined text-sm" data-icon="grid_view">grid_view</span>
                카드형
            </button>

            <button type="button"
                    class="text-slate-500 px-4 py-1.5 rounded-full text-xs font-bold flex items-center gap-1 hover:text-primary">
                <span class="material-symbols-outlined text-sm" data-icon="list">list</span>
                목록형
            </button>
        </div>
    </div>

    <!-- Complex Grid -->
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6 mb-12">
        <c:choose>
            <c:when test="${empty pagingVO.dataList}">
                <div class="col-span-full bg-white rounded-2xl border border-[#eef2eb] p-10 text-center text-slate-400">
                    조회된 단지가 없습니다.
                </div>
            </c:when>

            <c:otherwise>
                <c:forEach var="apt" items="${pagingVO.dataList}">

                    <!-- 상세 페이지 이동 URL -->
                    <c:url var="aptDetailUrl" value="/main/apt/detail.do">
                        <c:param name="aptCmplexNo" value="${apt.aptCmplexNo}"/>
                    </c:url>

                    <a href="${aptDetailUrl}"
                       class="complex-card block bg-white rounded-2xl border border-[#eef2eb] overflow-hidden
                    hover:-translate-y-1 hover:shadow-xl transition-all duration-200 cursor-pointer">

                        <div class="h-40 bg-[#e8f0eb] relative flex items-center justify-center">
                            <c:choose>
                                <c:when test="${not empty apt.rprsntImgFileNo}">
                                    <img
                                            src="/file/display/${apt.rprsntImgFileNo}"
                                            alt="${apt.aptCmplexNm}"
                                            style="width:100%; height:170px; object-fit:cover;"
                                    />
                                </c:when>

                                <c:otherwise>
                                    <span class="material-symbols-outlined text-primary/20 text-6xl"
                                          data-icon="apartment">
                                        apartment
                                    </span>
                                </c:otherwise>
                            </c:choose>

                            <span class="absolute top-4 left-4 bg-primary text-white px-3 py-1 rounded-full text-[10px] font-bold">
                            ${apt.sidoNm} ${apt.sigunguNm}
                          </span>
                                    </div>

                                    <div class="p-5">
                                        <h4 class="font-bold text-primary mb-1">
                                                ${apt.aptCmplexNm}
                                        </h4>

                                        <p class="text-xs text-slate-400 mb-4 line-clamp-1">
                                                ${apt.dorojuso}
                                        </p>

                                        <div class="flex justify-between items-center text-[11px] font-bold">
                            <span class="text-slate-600">
                              ${apt.unitCnt}세대 ${apt.dongCnt}동
                            </span>

                                <span class="text-primary">
                                  ${apt.bldYr} 준공
                                </span>
                            </div>
                        </div>
                    </a>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Pagination -->
    <div class="flex justify-center mt-10 mb-16">
        <c:out value="${pagingVO.pagingHTML}" escapeXml="false"/>
    </div>

</main>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script>
    $(function () {

        /*
         * 시/군/구 목록 조회
         * 컨트롤러: /apt/sigungu.do?sidoNm=...
         */
        function loadSigunguList(sidoNm, selectedValue) {
            const $sigunguNm = $("#sigunguNm");

            $sigunguNm.empty();
            $sigunguNm.append('<option value="">시/군/구</option>');

            if (!sidoNm) {
                return;
            }

            $.ajax({
                url: "${pageContext.request.contextPath}/main/apt/sigungu.do",
                type: "GET",
                data: {
                    sidoNm: sidoNm
                },
                dataType: "json",
                success: function (sigunguList) {
                    $.each(sigunguList, function (index, sigunguNm) {
                        const selected = sigunguNm === selectedValue ? "selected" : "";

                        $sigunguNm.append(
                            '<option value="' + sigunguNm + '" ' + selected + '>' + sigunguNm + '</option>'
                        );
                    });
                },
                error: function (xhr) {
                    console.error("시/군/구 조회 실패");
                    console.error("status =", xhr.status);
                    console.error("responseText =", xhr.responseText);
                    alert("시/군/구 목록을 불러오지 못했습니다.");
                }
            });
        }

        /*
         * 검색 후 다시 진입했을 때 선택값 유지
         */
        const selectedSidoNm = "${searchVO.sidoNm}";
        const selectedSigunguNm = "${searchVO.sigunguNm}";

        if (selectedSidoNm) {
            loadSigunguList(selectedSidoNm, selectedSigunguNm);
        }

        /*
         * 시/도 변경 시 시/군/구 자동 변경
         */
        $("#sidoNm").on("change", function () {
            loadSigunguList($(this).val(), "");
        });

        /*
         * 페이지 번호 클릭 시 현재 검색조건 유지하면서 page만 변경
         */
        $(document).on("click", ".page-link", function (e) {
            e.preventDefault();

            const page = $(this).data("page");

            if (!page) {
                return;
            }

            const url = new URL(window.location.href);
            url.searchParams.set("page", page);

            location.href = url.toString();
        });

    });
</script>

</body>
</html>