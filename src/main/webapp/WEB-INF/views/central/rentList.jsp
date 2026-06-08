<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>매물 목록</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/centralSidebarStyle.css">

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: "Pretendard", "Noto Sans KR", sans-serif;
            color: #17201b;
            background: #f8faf6;
        }

        .rent-list-wrap {
            margin-left: 280px;
            padding: 88px 100px 48px;
            min-height: 100vh;
        }

        .rent-list-container {
            max-width: 1520px;
            margin: 0 auto;
        }

        .rent-list-top {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            gap: 24px;
            margin-bottom: 28px;
        }

        .rent-breadcrumb {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 12px;
            color: #98a2b3;
            font-size: 14px;
            font-weight: 500;
        }

        .rent-breadcrumb strong {
            color: #005f46;
            font-weight: 800;
        }

        .breadcrumb-arrow {
            color: #98a2b3;
            font-size: 20px;
            line-height: 1;
        }

        .rent-list-page-title {
            margin: 0 0 10px;
            font-size: 36px;
            line-height: 1.15;
            font-weight: 900;
            color: #0b1f17;
        }

        .rent-list-page-desc {
            margin: 0;
            font-size: 16px;
            color: #667085;
            line-height: 1.6;
        }

        .rent-map-move-btn {
            height: 48px;
            padding: 0 22px;
            border: 1px solid #e4e7ec;
            border-radius: 999px;
            background: #ffffff;
            color: #344054;
            font-size: 15px;
            font-weight: 800;
            cursor: pointer;
            box-shadow: 0 3px 10px rgba(16, 24, 40, 0.05);
            display: inline-flex;
            align-items: center;
            gap: 10px;
        }

        .rent-map-move-btn:hover {
            background: #f9fafb;
            border-color: #d0d5dd;
        }

        .rent-search-box {
            background: #ffffff;
            border: 1px solid #e5e7eb;
            border-radius: 12px;
            padding: 22px 24px 24px;
            box-shadow: 0 6px 18px rgba(16, 24, 40, 0.04);
            margin-bottom: 30px;
        }

        .search-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 14px 16px;
            margin-bottom: 16px;
        }

        .search-field label {
            display: block;
            margin-bottom: 8px;
            color: #344054;
            font-size: 13px;
            font-weight: 800;
        }

        .search-field select,
        .search-field input {
            width: 100%;
            height: 46px;
            border: 0;
            border-radius: 8px;
            background: #f0f2ef;
            padding: 0 14px;
            font-size: 14px;
            color: #111827;
            outline: none;
        }

        .search-field select:focus,
        .search-field input:focus {
            box-shadow: 0 0 0 2px rgba(0, 95, 70, 0.15);
        }

        .search-bottom-row {
            display: grid;
            grid-template-columns: minmax(0, 1fr) 110px;
            gap: 12px;
        }

        .keyword-input {
            width: 100%;
            height: 56px;
            border: 0;
            border-radius: 8px;
            background: #f0f2ef;
            padding: 0 20px;
            font-size: 15px;
            color: #111827;
            outline: none;
        }

        .keyword-input::placeholder {
            color: #98a2b3;
        }

        .search-btn {
            height: 56px;
            border: 0;
            border-radius: 8px;
            background: #226046;
            color: #ffffff;
            font-size: 16px;
            font-weight: 900;
            cursor: pointer;
        }

        .search-btn:hover {
            filter: brightness(0.95);
        }

        .rent-table-card {
            background: #ffffff;
            border: 1px solid #e5e7eb;
            border-radius: 12px;
            box-shadow: 0 6px 18px rgba(16, 24, 40, 0.04);
            overflow: hidden;
        }

        .table-top {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 20px 24px;
            border-bottom: 1px solid #e5e7eb;
        }

        .table-title {
            margin: 0;
            font-size: 20px;
            font-weight: 900;
            color: #0b1f17;
        }

        .table-count {
            font-size: 14px;
            color: #667085;
        }

        .table-count strong {
            color: #005f46;
            font-weight: 900;
        }

        .rent-table {
            width: 100%;
            border-collapse: collapse;
            table-layout: fixed;
        }

        .rent-table thead th {
            height: 48px;
            background: #fafbf9;
            border-bottom: 1px solid #e5e7eb;
            color: #344054;
            font-size: 13px;
            font-weight: 800;
            text-align: center;
        }

        .rent-table tbody td {
            height: 64px;
            border-bottom: 1px solid #eef0eb;
            color: #344054;
            font-size: 14px;
            font-weight: 400;
            text-align: center;
            padding: 10px 12px;
            vertical-align: middle;
        }

        .rent-table tbody tr {
            cursor: pointer;
        }

        .rent-table tbody tr:hover {
            background: #f7fbf8;
        }

        .rent-table tbody tr:last-child td {
            border-bottom: 0;
        }

        .col-no {
            width: 150px;
        }

        .col-type {
            width: 130px;
        }

        .col-apt {
            width: 320px;
        }

        .col-price {
            width: 240px;
        }

        .col-region {
            width: 190px;
        }

        .col-status {
            width: 120px;
        }

        .col-action {
            width: 150px;
        }

        .rent-no {
            color: #8a96b3;
            font-weight: 500;
        }

        .rent-apt {
          color: #344054;
          font-weight: 500;
          text-align: center;
          white-space: nowrap;
          overflow: hidden;
          text-overflow: ellipsis;
        }

        .rent-price {
            color: #005f46;
            font-weight: 600;
        }

        .status-badge {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-width: 64px;
            height: 28px;
            padding: 0 10px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 900;
        }

        .status-open {
            background: #e8f3ef;
            color: #005f46;
        }

        .status-close {
            background: #f1f3f6;
            color: #8a96b3;
        }

        .type-badge {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-width: 76px;
            height: 28px;
            border-radius: 999px;
            background: #edf5ef;
            color: #005f46;
            font-size: 12px;
            font-weight: 600;
        }

        .detail-btn {
            min-width: 82px;
            height: 34px;
            border: 0;
            border-radius: 8px;
            background: #005f46;
            color: #ffffff;
            font-size: 13px;
            font-weight: 800;
            cursor: pointer;
        }

        .detail-btn:hover {
            background: #004d39;
        }

        .empty-row td {
            height: 180px !important;
            color: #667085;
            font-size: 15px;
            font-weight: 700;
        }

        @media (max-width: 1400px) {
            .rent-list-wrap {
                margin-left: 280px;
                padding-left: 32px;
                padding-right: 32px;
            }

            .search-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        @media (max-width: 900px) {
            .rent-list-wrap {
                margin-left: 0;
                padding: 88px 20px 48px;
            }

            .rent-list-top {
                flex-direction: column;
            }

            .search-grid {
                grid-template-columns: 1fr;
            }

            .search-bottom-row {
                grid-template-columns: 1fr;
            }

            .rent-table-card {
                overflow-x: auto;
            }

            .rent-table {
                min-width: 1100px;
            }
        }

        .pagination-wrap {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 6px;
            padding: 22px 0 24px;
            border-top: 1px solid #eef0eb;
        }

        .page-btn {
            min-width: 36px;
            height: 36px;
            padding: 0 11px;
            border: 1px solid #d0d5dd;
            border-radius: 8px;
            background: #ffffff;
            color: #344054;
            font-size: 13px;
            font-weight: 800;
            cursor: pointer;
        }

        .page-btn:hover {
            background: #f7fbf8;
            border-color: #005f46;
            color: #005f46;
        }

        .page-btn.active {
            background: #005f46;
            border-color: #005f46;
            color: #ffffff;
        }

        .page-btn:disabled {
            opacity: .45;
            cursor: not-allowed;
            background: #f3f4f6;
            color: #9ca3af;
        }


    </style>
</head>

<body>

<%@ include file="/WEB-INF/views/include/main_headerLayout.jsp" %>
<%@ include file="/WEB-INF/views/include/central_sidebar.jsp" %>

<div class="rent-list-wrap">
    <div class="rent-list-container">

        <section class="rent-list-top">
            <div>
                <div class="rent-breadcrumb">
                    <span>Home</span>
                    <span class="breadcrumb-arrow">›</span>
                    <span>매물정보</span>
                    <span class="breadcrumb-arrow">›</span>
                    <strong>매물 목록</strong>
                </div>

                <h1 class="rent-list-page-title">매물 목록</h1>
                <p class="rent-list-page-desc">
                    공공주택 임대 매물을 조건별로 검색하고 상세정보를 확인할 수 있습니다.
                </p>
            </div>

            <button type="button"
                    class="rent-map-move-btn"
                    onclick="location.href='${pageContext.request.contextPath}/rent/map'">
                지도에서 보기
            </button>
        </section>

        <form id="rentSearchForm"
              method="get"
              action="${pageContext.request.contextPath}/rent/list"
              class="rent-search-box">

            <input type="hidden" name="page" id="page" value="${pagingVO.currentPage}" />

            <div class="search-grid">
                <div class="search-field">
                    <label for="rentTypeFilter">임대유형</label>
                    <select id="rentTypeFilter" name="searchRentTypeCd">
                        <option value="ALL" ${searchVO.searchRentTypeCd == 'ALL' ? 'selected' : ''}>전체</option>
                        <option value="JS" ${searchVO.searchRentTypeCd == 'JS' ? 'selected' : ''}>전세임대</option>
                        <option value="PE" ${searchVO.searchRentTypeCd == 'PE' ? 'selected' : ''}>영구임대(월세)</option>
                    </select>
                </div>

                <div class="search-field">
                    <label for="regionFilter">지역</label>
                    <select id="regionFilter" name="searchRegion">
                        <option value="ALL" ${searchVO.searchRegion == 'ALL' ? 'selected' : ''}>전체</option>

                        <c:forEach var="rent" items="${rentList}">
                            <c:set var="regionName" value="${rent.sidoNm} ${rent.sigunguNm}" />
                            <option value="${regionName}" ${searchVO.searchRegion == regionName ? 'selected' : ''}>
                                <c:out value="${regionName}" />
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="search-field">
                    <label for="amountFilter">금액</label>
                    <select id="amountFilter" name="searchAmountRange">
                        <option value="ALL" ${searchVO.searchAmountRange == 'ALL' ? 'selected' : ''}>전체</option>
                        <option value="UNDER_5000" ${searchVO.searchAmountRange == 'UNDER_5000' ? 'selected' : ''}>5,000만원 이하</option>
                        <option value="5000_10000" ${searchVO.searchAmountRange == '5000_10000' ? 'selected' : ''}>5,000만원 ~ 1억원</option>
                        <option value="10000_20000" ${searchVO.searchAmountRange == '10000_20000' ? 'selected' : ''}>1억원 ~ 2억원</option>
                        <option value="OVER_20000" ${searchVO.searchAmountRange == 'OVER_20000' ? 'selected' : ''}>2억원 이상</option>
                    </select>
                </div>

                <div class="search-field">
                    <label for="statusFilter">상태</label>
                    <select id="statusFilter" name="searchStatus">
                        <option value="ALL" ${searchVO.searchStatus == 'ALL' ? 'selected' : ''}>전체</option>
                        <option value="OPEN" ${searchVO.searchStatus == 'OPEN' ? 'selected' : ''}>공고중</option>
                        <option value="CLOSE" ${searchVO.searchStatus == 'CLOSE' ? 'selected' : ''}>마감</option>
                    </select>
                </div>
            </div>

            <div class="search-bottom-row">
                <input type="text"
                       class="keyword-input"
                       id="keywordInput"
                       name="searchKeyword"
                       value="${searchVO.searchKeyword}"
                       placeholder="매물명, 단지명 또는 주소를 입력하세요">

                <button type="submit" class="search-btn">
                    검색
                </button>
            </div>
        </form>

        <section class="rent-table-card">
            <div class="table-top">
                <h2 class="table-title">매물 목록</h2>
                <div class="table-count">
                    총 <strong id="visibleCount">${pagingVO.totalRecord}</strong>건
                </div>
            </div>

            <table class="rent-table">
                <thead>
                <tr>
                    <th class="col-no">매물번호</th>
                    <th class="col-type">임대유형</th>
                    <th class="col-apt">아파트 단지</th>
                    <th class="col-price">금액</th>
                    <th class="col-region">지역</th>
                    <th class="col-status">상태</th>
                    <th class="col-action">상세</th>
                </tr>
                </thead>

                <tbody id="rentTableBody">
                <c:choose>
                    <c:when test="${empty pagingVO.dataList}">
                        <tr class="empty-row">
                            <td colspan="7">등록된 매물이 없습니다.</td>
                        </tr>
                    </c:when>

                    <c:otherwise>
                        <c:forEach var="rent" items="${pagingVO.dataList}">
                            <c:set var="regionName" value="${rent.sidoNm} ${rent.sigunguNm}" />

                            <tr class="rent-row"
                                data-type="${rent.rentTypeCd}"
                                data-region="${regionName}"
                                data-amount="${rent.dpstAmt}"
                                data-rcrt-end-dt="${rent.rcrtEndDt}"
                                data-keyword="${rent.rentTtl} ${rent.aptCmplexNm} ${rent.dorojuso} ${rent.sidoNm} ${rent.sigunguNm} ${rent.emdNm}"
                                onclick="location.href='${pageContext.request.contextPath}/rent/detail/${rent.rentLstgNo}'">

                                <td class="rent-no">
                                    <c:out value="${rent.rentLstgNo}" />
                                </td>

                                <td>
                                    <span class="type-badge">
                                        <c:out value="${rent.rentTypeNm}" />
                                    </span>
                                </td>

                                <td class="text-left">
                                    <div class="rent-apt">
                                        <c:out value="${rent.aptCmplexNm}" />
                                    </div>
                                </td>

                                <td>
                                    <span class="rent-price"
                                          data-rent-type="${rent.rentTypeCd}"
                                          data-dpst-amt="${rent.dpstAmt}"
                                          data-monthly-amt="${rent.mthlyRentAmt}">
                                    </span>
                                </td>

                                <td>
                                    <c:out value="${regionName}" />
                                </td>

                                <td>
                                    <span class="status-badge"
                                          data-rcrt-end-dt="${rent.rcrtEndDt}">
                                    </span>
                                </td>

                                <td onclick="event.stopPropagation();">
                                    <button type="button"
                                            class="detail-btn"
                                            onclick="location.href='${pageContext.request.contextPath}/rent/detail/${rent.rentLstgNo}'">
                                        상세보기
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
                </tbody>
            </table>
            <div class="pagination-wrap">
                <button type="button"
                        class="page-btn"
                        ${pagingVO.currentPage == 1 ? 'disabled' : ''}
                        onclick="movePage(1)">
                    처음
                </button>

                <button type="button"
                        class="page-btn"
                        ${pagingVO.currentPage == 1 ? 'disabled' : ''}
                        onclick="movePage(${pagingVO.currentPage - 1})">
                    이전
                </button>

                <c:forEach var="p" begin="${pagingVO.startPage}" end="${pagingVO.endPage}">
                    <button type="button"
                            class="page-btn ${p == pagingVO.currentPage ? 'active' : ''}"
                            onclick="movePage(${p})">
                        ${p}
                    </button>
                </c:forEach>

                <button type="button"
                        class="page-btn"
                        ${pagingVO.currentPage == pagingVO.totalPage ? 'disabled' : ''}
                        onclick="movePage(${pagingVO.currentPage + 1})">
                    다음
                </button>

                <button type="button"
                        class="page-btn"
                        ${pagingVO.currentPage == pagingVO.totalPage ? 'disabled' : ''}
                        onclick="movePage(${pagingVO.totalPage})">
                    끝
                </button>
            </div>
        </section>

    </div>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        renderPriceTexts();
        renderStatusBadges();
        bindSearchForm();
    });

    function bindSearchForm() {
        const form = document.getElementById("rentSearchForm");
        const pageInput = document.getElementById("page");

        if (!form || !pageInput) {
            return;
        }

        form.addEventListener("submit", function () {
            pageInput.value = 1;
        });
    }

    function movePage(page) {
        const form = document.getElementById("rentSearchForm");
        const pageInput = document.getElementById("page");

        if (!form || !pageInput) {
            return;
        }

        pageInput.value = page;
        form.submit();
    }

    function getStatusByEndDate(endDate) {
        if (!endDate || endDate === "null" || endDate === "undefined") {
            return "OPEN";
        }

        const onlyNum = String(endDate).replaceAll("-", "").substring(0, 8);

        if (!/^\d{8}$/.test(onlyNum)) {
            return "OPEN";
        }

        const today = new Date();
        const yyyy = today.getFullYear();
        const mm = String(today.getMonth() + 1).padStart(2, "0");
        const dd = String(today.getDate()).padStart(2, "0");
        const todayStr = "" + yyyy + mm + dd;

        return onlyNum >= todayStr ? "OPEN" : "CLOSE";
    }

    function renderStatusBadges() {
        document.querySelectorAll(".status-badge").forEach(function (badge) {
            const status = getStatusByEndDate(badge.dataset.rcrtEndDt);

            if (status === "OPEN") {
                badge.textContent = "공고중";
                badge.classList.add("status-open");
            } else {
                badge.textContent = "마감";
                badge.classList.add("status-close");
            }
        });
    }

    function renderPriceTexts() {
        document.querySelectorAll(".rent-price").forEach(function (el) {
            const rentTypeCd = el.dataset.rentType;
            const dpstAmt = Number(el.dataset.dpstAmt || 0);
            const monthlyAmt = Number(el.dataset.monthlyAmt || 0);

            if (rentTypeCd === "JS") {
                el.textContent = "전세 " + formatMoney(dpstAmt);
            } else if (rentTypeCd === "PE") {
                el.textContent = "보증금 " + formatMoney(dpstAmt) + " / 월 " + formatMoney(monthlyAmt);
            } else {
                el.textContent = formatMoney(dpstAmt);
            }
        });
    }

    function formatMoney(value) {
        const num = Number(value || 0);

        if (num === 0) {
            return "0원";
        }

        const eok = Math.floor(num / 100000000);
        const man = Math.floor((num % 100000000) / 10000);

        if (eok > 0 && man > 0) {
            return eok + "억 " + man.toLocaleString() + "만";
        }

        if (eok > 0) {
            return eok + "억";
        }

        if (man > 0) {
            return man.toLocaleString() + "만";
        }

        return num.toLocaleString() + "원";
    }
</script>

</body>
</html>