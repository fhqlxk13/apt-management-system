<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>

<html class="light" lang="ko">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>단지 시설정보</title>

    <%-- 사용자 - 시설관리 공사/보수/점검 조회기능 완료 - 김보라 --%>

    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/centralSidebarStyle.css">

    <style>
        body{
            font-family:'Malgun Gothic', sans-serif;
            background:#fff;
            color:#222;
        }

        .facility-page{
            margin-left:260px;
            padding:120px 48px 80px;
            background:#fff;
            min-height:100vh;
        }

        .facility-container{
            max-width:1400px;
            margin:0 auto;
        }

        .facility-page-title{
            font-size:42px;
            font-weight:800;
            color:#111827;
            margin-bottom:12px;
            letter-spacing:-1px;
        }

        .facility-page-desc{
            font-size:14px;
            color:#666;
            margin-bottom:45px;
        }

        .facility-section{
            margin-bottom:60px;
        }

        .facility-section-title{
            font-size:36px;
            font-weight:800;
            color:#1f3d6d;
            margin-bottom:16px;
            letter-spacing:-1px;
        }

        .facility-table{
            width:100%;
            border-collapse:collapse;
            table-layout:fixed;
            border-top:2px solid #444;
        }

        .facility-table th{
            width:220px;
            background:#f5f5f5;
            border-bottom:1px solid #d9d9d9;
            border-right:1px solid #d9d9d9;
            padding:15px 16px;
            font-size:14px;
            font-weight:700;
            text-align:center;
            color:#333;
            vertical-align:middle;
            word-break:keep-all;
        }

        .facility-table td{
            border-bottom:1px solid #d9d9d9;
            border-right:1px solid #d9d9d9;
            padding:15px 18px;
            font-size:14px;
            color:#222;
            vertical-align:middle;
            word-break:keep-all;
            background:#fff;
        }

        .facility-table tr th:last-child,
        .facility-table tr td:last-child{
            border-right:none;
        }

        .facility-info-list{
            display:flex;
            flex-wrap:wrap;
            gap:10px 22px;
        }

        .facility-info-list span{
            position:relative;
            padding-left:12px;
        }

        .facility-info-list span::before{
            content:"•";
            position:absolute;
            left:0;
            top:0;
            color:#666;
        }


        .facility-search-form{
            margin-bottom:40px;
            padding:24px;
            display:flex;
            align-items:center;
            gap:14px;
            background:#fff;
            border:1px solid #e5e7eb;
            border-radius:14px;
            box-shadow:0 2px 8px rgba(0,0,0,0.05);
        }

        .search-label{
            font-size:14px;
            font-weight:800;
            color:#475569;
            white-space:nowrap;
        }

        .search-select,
        .search-input{
            height:42px;
            border:0;
            border-radius:6px;
            background:#eef1ee;
            padding:0 18px;
        }

        .search-button{
            height:42px;
            min-width:90px;
            border:0;
            border-radius:6px;
            background:#00583f;
            color:#fff;
            font-size:14px;
            font-weight:800;
            cursor:pointer;
        }

        .facility-card-section{
            margin-bottom:50px;
        }

        .facility-card-count{
            margin-bottom:20px;
            font-size:22px;
            font-weight:800;
            color:#00583f;
        }

        .facility-card-grid{
            display:grid;
            grid-template-columns:repeat(4, 1fr);
            gap:24px;
        }

        .facility-card{
            display:block;
            text-decoration:none;
            color:inherit;
            border:1px solid #e5e7eb;
            border-radius:18px;
            overflow:hidden;
            background:#fff;
            box-shadow:0 3px 10px rgba(15, 23, 42, 0.06);
        }

        .facility-card:hover{
            transform:translateY(-3px);
            box-shadow:0 8px 18px rgba(15, 23, 42, 0.12);
        }

        .facility-card-top{
            position:relative;
            height:150px;
            background:#eaf3ee;
            display:flex;
            align-items:center;
            justify-content:center;
        }

        .facility-card-badge{
            position:absolute;
            top:18px;
            left:18px;
            padding:7px 14px;
            border-radius:20px;
            background:#00583f;
            color:#fff;
            font-size:13px;
            font-weight:800;
        }

        .facility-card-icon{
            font-size:34px;
            color:#9bb9ad;
        }

        .facility-card-body{
            padding:24px;
        }

        .facility-card-title{
            font-size:20px;
            font-weight:800;
            color:#00583f;
            margin-bottom:8px;
        }

        .facility-card-address{
            font-size:14px;
            color:#94a3b8;
            margin-bottom:24px;
        }

        .facility-card-meta{
            display:flex;
            justify-content:space-between;
            font-size:13px;
            font-weight:800;
            color:#00583f;
        }

        .facility-empty-box{
            padding:60px;
            border:1px solid #e5e7eb;
            border-radius:14px;
            text-align:center;
            color:#64748b;
            background:#fff;
        }

        .facility-pagination{
            margin-top:30px;
            display:flex;
            justify-content:center;
        }

        .facility-pagination .pagination{
            display:flex;
            gap:8px;
            list-style:none;
            padding:0;
            margin:0;
        }

        .facility-pagination .page-link{
            min-width:36px;
            height:36px;
            padding:0 12px;
            display:flex;
            align-items:center;
            justify-content:center;
            border:1px solid #d1d5db;
            border-radius:10px;
            text-decoration:none;
            color:#334155;
            font-size:14px;
            font-weight:800;
            background:#fff;
        }

        .facility-pagination .page-link:hover{
            background:#eef1ee;
        }

        .facility-pagination .page-item.active .page-link{
            background:#00583f;
            color:#fff;
            border-color:#00583f;
        }

        .sortable-th{
            cursor:pointer;
            user-select:none;
        }

        /*
         * cursor:pointer
         * → 마우스를 올렸을 때 클릭 가능한 손가락 모양으로 보여준다.
         *
         * user-select:none
         * → 정렬 버튼을 여러 번 클릭할 때 글자가 드래그 선택되는 것을 막는다.
         */

        .facility-card.is-selected{
            border:3px solid #00583f;
            box-shadow:0 0 0 4px rgba(0, 88, 63, 0.12);
            transform:translateY(-3px);
        }

        .facility-card.is-selected .facility-card-top{
            background:#d9eee5;
        }

        .facility-card.is-selected .facility-card-title::after{
            content:"선택됨";

            display:inline-flex;
            align-items:center;
            justify-content:center;

            margin-left:8px;
            padding:4px 10px;

            border-radius:999px;

            background-color: #DBEAFE;
            color: #1D4ED8;

            font-size:11px;
            font-weight:800;

            vertical-align:middle;
        }

        /* 시설사항 검색 영역 */
        .facility-sub-search {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 16px;
        }

        /* 시설사항 검색 input/select 공통 너비 */
        .facility-sub-search .search-select,
        .facility-sub-search .search-input {
            width: 213px;
            max-width: 213px;
            flex: none;
        }

        /* 버튼 너비 통일 */
        .facility-sub-search .search-button {
            width: 90px;
            flex: none;
        }
        .facility-card-img{
            width:100%;
            height:100%;
            object-fit:cover;
            display:block;
        }

        .facility-card-img{
            width:100%;
            height:100%;
            object-fit:cover;
            display:block;
        }

        /* object-fit:cover란?
           이미지 비율은 유지하면서 카드 영역을 꽉 채우는 옵션.
           왜 사용? 사진이 찌그러지지 않게 하려고 사용.
        */
    </style>
</head>

<body class="bg-surface text-on-surface flex flex-col min-h-screen">

<%@ include file="/WEB-INF/views/include/main_headerLayout.jsp" %>
<%@ include file="/WEB-INF/views/include/central_sidebar.jsp" %>

<main class="facility-page">
    <div class="facility-container">

        <!-- 페이지 제목 -->
        <h1 class="facility-page-title">단지 시설정보</h1>

        <p class="facility-page-desc">
            공동주택 시설 및 관리 현황을 확인할 수 있습니다.
        </p>

        <!-- 검색 영역 -->
        <form method="get"
              action="${pageContext.request.contextPath}/facility/history.do"
              class="facility-search-form">
            <%-- 단지카드 페이징 처리 --%>
            <input type="hidden" name="currentPage" id="currentPage" value="${pagingVO.currentPage}" />

            <%-- 시설사항 표 페이징 처리 --%>
            <input type="hidden" name="facilityPage" id="facilityPage" value="${facilityPage}" />

            <%-- 조회 버튼을 눌렀는지 Controller에 전달 --%>
            <input type="hidden" name="searchYn" value="Y"/>

            <label class="search-label">지역</label>

            <%-- 시/도 검색 조건 --%>
                <select name="sidoNm"
                        id="sidoNm"
                        class="search-select">

                    <option value="">시/도 전체</option>

                    <c:forEach var="sido" items="${sidoList}">
                        <option value="${sido}"
                            ${dto.sidoNm eq sido ? 'selected' : ''}>
                                ${sido}
                        </option>
                    </c:forEach>

                </select>

            <%-- 시/군/구 검색 조건 --%>
                <select name="sigunguNm"
                        id="sigunguNm"
                        class="search-select">

                    <option value="">시/군/구</option>

                    <c:if test="${not empty sigunguList}">
                        <c:forEach var="sigungu" items="${sigunguList}">
                            <option value="${sigungu}"
                                ${dto.sigunguNm eq sigungu ? 'selected' : ''}>
                                    ${sigungu}
                            </option>
                        </c:forEach>
                    </c:if>

                </select>

            <label class="search-label">세대수</label>

            <%-- 세대수 구간 검색 조건 --%>
            <select name="unitRange" class="search-select">
                <option value="">전체</option>
                <option value="UNDER_300" ${dto.unitRange eq 'UNDER_300' ? 'selected' : ''}>300세대 미만</option>
                <option value="300_500" ${dto.unitRange eq '300_500' ? 'selected' : ''}>300세대 이상 500세대 미만</option>
                <option value="500_1000" ${dto.unitRange eq '500_1000' ? 'selected' : ''}>500세대 이상 1000세대 미만</option>
                <option value="OVER_1000" ${dto.unitRange eq 'OVER_1000' ? 'selected' : ''}>1000세대 이상</option>
            </select>

            <%-- 단지명 직접 검색 --%>
            <input type="text"
                   name="keyword"
                   value="${dto.keyword}"
                   class="search-input"
                   placeholder="단지명 검색"/>

            <button type="submit" class="search-button">검색</button>
        </form>

        <c:if test="${searched}">

            <section class="facility-card-section">

                <c:choose>
                    <c:when test="${not empty aptCardList}">

                        <div class="facility-card-count">
                            총 ${pagingVO.totalRecord}개 단지
                        </div>

                        <div class="facility-card-grid">
                            <c:forEach var="apt" items="${aptCardList}">
                                <a class="facility-card ${dto.aptCmplexNo eq apt.aptCmplexNo ? 'is-selected' : ''}"
                                   href="${pageContext.request.contextPath}/facility/history.do?searchYn=Y&sidoNm=${dto.sidoNm}&sigunguNm=${dto.sigunguNm}&unitRange=${dto.unitRange}&keyword=${dto.keyword}&currentPage=${pagingVO.currentPage}&aptCmplexNo=${apt.aptCmplexNo}&facilityPage=1">

                                    <div class="facility-card-top">

<%--                                        <div style="font-size:11px; color:red;">--%>
<%--                                            이미지번호: ${apt.rprsntImgFileNo}--%>
<%--                                        </div>--%>

                                        <c:choose>
                                            <c:when test="${not empty apt.rprsntImgFileNo}">
                                                <img class="facility-card-img"
                                                     src="${pageContext.request.contextPath}/file/display/${apt.rprsntImgFileNo}"
                                                     alt="${apt.aptCmplexNm}">
                                            </c:when>

                                            <c:otherwise>
                                                <span class="material-symbols-outlined facility-card-icon">apartment</span>
                                            </c:otherwise>
                                        </c:choose>

                                        <span class="facility-card-badge">
                                            ${apt.sidoNm} ${apt.sigunguNm}
                                        </span>
                                    </div>

                                    <div class="facility-card-body">
                                        <div class="facility-card-title">${apt.aptCmplexNm}</div>
                                        <div class="facility-card-address">${apt.dorojuso}</div>

                                        <div class="facility-card-meta">
                                            <span>${apt.unitCnt}세대 ${apt.dongCnt}동</span>
                                            <span>
                                                ${fn:substring(apt.bldYr, 0, 4)}.
                                                ${fn:substring(apt.bldYr, 4, 6)}.
                                                ${fn:substring(apt.bldYr, 6, 8)}
                                                준공
                                            </span>
                                        </div>
                                    </div>
                                </a>
                            </c:forEach>
                        </div>
                        <%-- 단지카드 페이징 처리 --%>
                        <c:if test="${pagingVO.totalPage > 1}">
                            <div class="facility-pagination">
                                    ${pagingVO.pagingHTML}
                            </div>
                        </c:if>

                    </c:when>

                    <c:otherwise>
                        <div class="facility-empty-box">
                            조회 조건과 일치하는 단지가 없습니다. 지역, 세대수 또는 단지명을 변경하여 다시 검색해 주세요.
                        </div>
                    </c:otherwise>
                </c:choose>

            </section>

        </c:if>

        <c:choose>

            <%-- 처음 화면: 표는 유지하고 안내 문구 출력 --%>
            <c:when test="${not searched}">
                <section class="facility-section">
                    <h2 class="facility-section-title">단지 시설정보 조회</h2>

                    <table class="facility-table">
                        <tbody>
                        <tr>
                            <td style="text-align:center; padding:60px; color:#64748b;">
                                조회 조건을 선택한 후 검색 버튼을 눌러 단지 시설정보를 확인해 주세요.
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </section>
            </c:when>

            <%-- 조회 후 결과 있음 --%>
            <c:when test="${not empty aptInfo}">

                    <!-- 단지 기본정보 -->
                    <section class="facility-section">
                        <h2 class="facility-section-title">단지 기본정보</h2>

                        <table class="facility-table">
                            <tbody>
                            <tr>
                                <th>단지명</th>
                                <td colspan="3">${aptInfo.aptCmplexNm}</td>
                            </tr>
                            <tr>
                                <th>법정동주소</th>
                                <td>${aptInfo.sidoNm} ${aptInfo.sigunguNm} ${aptInfo.emdNm}</td>
                                <th>도로명주소</th>
                                <td>${aptInfo.dorojuso}</td>
                            </tr>
                            <tr>
                                <th>난방방식</th>
                                <td>${aptInfo.heatTy}</td>
                                <th>준공년도</th>
                                <td>
                                        ${fn:substring(aptInfo.bldYr, 0, 4)}.
                                        ${fn:substring(aptInfo.bldYr, 4, 6)}.
                                        ${fn:substring(aptInfo.bldYr, 6, 8)}
                                </td>
                            </tr>
                            <tr>
                                <th>최대층수</th>
                                <td>${aptInfo.maxFloor}층</td>
                                <th>동수 / 세대수</th>
                                <td>${aptInfo.dongCnt}동 / ${aptInfo.unitCnt}세대</td>
                            </tr>
                            <tr>
                                <th>주차가능대수</th>
                                <td>${aptInfo.pkgCnt}대</td>
                                <th>세대당 무료주차</th>
                                <td>${aptInfo.freePkgCnt}대</td>
                            </tr>
                            <tr>
                                <th>CCTV 수</th>
                                <td>${aptInfo.ccCnt}대</td>
                                <th>시공사 / 시행사</th>
                                <td>${aptInfo.cnscoNm}</td>
                            </tr>
                            </tbody>
                        </table>
                    </section>

                    <!-- 관리사항 -->
                    <section class="facility-section">
                        <h2 class="facility-section-title">관리사항</h2>

                        <table class="facility-table">
                            <tbody>
                            <tr>
                                <th>협력업체</th>
                                <td colspan="3">
                                    <div class="facility-info-list">
                                        <c:choose>
                                            <c:when test="${not empty aptInfo.partnerList}">
                                                <span>${aptInfo.partnerList}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span>등록된 협력업체가 없습니다.</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </section>

                    <!-- 시설사항 -->
                    <section class="facility-section">
                        <h2 class="facility-section-title">시설사항</h2>

                        <%-- 시설유형 공통코드 select box --%>
                        <div class="facility-sub-search">

                            <select id="facilityTySearch"
                                    class="search-select">
                                <option value="">시설유형 전체</option>

                                <c:forEach var="facilityTy" items="${facilityTypeList}">
                                    <option value="${facilityTy}">
                                            ${facilityTy}
                                    </option>
                                </c:forEach>
                            </select>

                            <input type="text"
                                   id="facilityNmSearch"
                                   class="search-input"
                                   placeholder="시설명 검색">

                            <input type="text"
                                   id="facilityLocSearch"
                                   class="search-input"
                                   placeholder="상세위치 검색">

                            <button type="button"
                                    id="facilitySearchBtn"
                                    class="search-button">
                                검색
                            </button>

                            <button type="button"
                                    id="facilityResetBtn"
                                    class="search-button"
                                    style="background:#64748b;">
                                초기화
                            </button>

                        </div>

                        <table class="facility-table" id="facilitySortTable">
                            <thead>
                            <tr>
                                    <%--
                                        data-sort-col
                                        → 몇 번째 컬럼을 정렬할지 JS에 알려주는 값.
                                        0: 시설명, 1: 시설유형, 2: 위치, 3: 상세 위치
                                    --%>
                                    <th class="sortable-th" data-sort-col="0">시설유형 ⇅</th>
                                    <th class="sortable-th" data-sort-col="1">시설명 ⇅</th>
                                    <th class="sortable-th" data-sort-col="2">위치 ⇅</th>
                                    <th class="sortable-th" data-sort-col="3">상세 위치 ⇅</th>
                            </tr>
                            </thead>

                            <tbody>
                            <c:choose>
                                <c:when test="${not empty facilityInfoList}">
                                    <%--
                                        prevFacilityNo
                                        → 바로 이전에 출력한 시설번호를 저장하는 변수.

                                        왜 사용?
                                        → public_item 조인 때문에 같은 시설이 여러 번 조회되므로
                                          같은 facilityNo는 화면에 한 번만 출력하기 위해 사용.
                                    --%>
                                    <c:set var="prevFacilityNo" value="" />
                                    <c:set var="facilityPrintCnt" value="0" />

                                    <c:forEach var="item" items="${facilityInfoList}">

                                        <%--
                                            facilityNo가 있고,
                                            이전에 출력한 facilityNo와 다를 때만 출력한다.
                                        --%>
                                        <c:if test="${not empty item.facilityNo and item.facilityNo ne prevFacilityNo}">
                                            <tr class="facility-row"
                                                data-facility-nm="${item.facilityNm}"
                                                data-facility-ty="${item.facilityTyCd}"
                                                data-facility-loc="${item.locCn}">
                                                    <%-- 시설유형 출력 --%>
                                                <td>${item.facilityTyCd}</td>
                                                    <%-- 시설명 출력 --%>
                                                <td>${item.facilityNm}</td>
                                                <td>

                                                            <c:choose>
                                                                <%--
                                                                    SEC = 보안시설
                                                                    경비실 같은 보안시설은 특정 동이 아니라 단지 전체 시설로 보는 경우가 많아서
                                                                    위치를 "아파트명"만 출력한다.
                                                                --%>
                                                                <c:when test="${item.facilityTyCd eq 'SEC'}">
                                                                    ${aptInfo.aptCmplexNm}
                                                                </c:when>

                                                                <%--
                                                                    dongNo 예시: A12185003_3
                                                                    "_" 뒤 숫자만 잘라서 "SH성산아파트 3동" 형태로 출력한다.
                                                                --%>
                                                                <c:when test="${not empty item.dongNo}">
                                                                    ${aptInfo.aptCmplexNm} ${fn:substringAfter(item.dongNo, '_')}동
                                                                </c:when>

                                                                <c:otherwise>-</c:otherwise>
                                                            </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty item.locCn}">
                                                            ${item.locCn}
                                                        </c:when>
                                                        <c:otherwise>-</c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>

                                            <%-- 현재 출력한 시설번호를 저장 --%>
                                            <c:set var="prevFacilityNo" value="${item.facilityNo}" />
                                            <c:set var="facilityPrintCnt" value="${facilityPrintCnt + 1}" />
                                        </c:if>

                                    </c:forEach>

                                    <c:if test="${facilityPrintCnt eq 0}">
                                        <tr>
                                            <td colspan="4" style="text-align:center;">등록된 시설정보가 없습니다.</td>
                                        </tr>
                                    </c:if>

                                </c:when>

                                <c:otherwise>
                                    <tr>
                                        <td colspan="4" style="text-align:center;">등록된 시설정보가 없습니다.</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                            </tbody>
                        </table>

                        <div class="facility-pagination">
                            <ul class="pagination" id="facilityClientPagination"></ul>
                        </div>
                    </section>



                    <!-- 입주편의시설 조회 -->
                <section class="facility-section">
                    <h2 class="facility-section-title">주변사항</h2>

                    <table class="facility-table">
                        <tbody>
                        <tr>
                            <th>교육시설</th>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty aptInfo.educationInfra}">
                                        ${aptInfo.educationInfra}
                                    </c:when>
                                    <c:otherwise>-</c:otherwise>
                                </c:choose>
                            </td>

                            <th>교통정보</th>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty aptInfo.transitInfo}">
                                        ${aptInfo.transitInfo}
                                    </c:when>
                                    <c:otherwise>-</c:otherwise>
                                </c:choose>
                            </td>
                        </tr>

                        <tr>
                            <th>복지시설</th>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty aptInfo.welfareInfra}">
                                        ${aptInfo.welfareInfra}
                                    </c:when>
                                    <c:otherwise>-</c:otherwise>
                                </c:choose>
                            </td>

                            <th>생활편의시설</th>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty aptInfo.convenienceInfra}">
                                        ${aptInfo.convenienceInfra}
                                    </c:when>
                                    <c:otherwise>-</c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </section>

            </c:when>

            <%-- 조회 후 결과 없음 --%>
            <c:otherwise>
                <section class="facility-section">
                    <h2 class="facility-section-title">단지 시설정보 조회</h2>

                    <table class="facility-table">
                        <tbody>
                        <tr>
                            <td style="text-align:center; padding:60px; color:#64748b;">
                                입력하신 조건과 일치하는 단지 시설정보가 없습니다.
                                검색 조건을 변경한 후 다시 조회해 주세요.
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </section>
            </c:otherwise>

        </c:choose>


    </div>
</main>

<script>

    /*
     * 시/도 변경 시 자동 조회
     *
     * onchange란?
     * → select 값이 바뀌었을 때 실행되는 이벤트.
     */
    document.getElementById("sidoNm")
        .addEventListener("change", function() {

            /*
             * 선택한 시/도 기준으로
             * Controller를 다시 호출하여
             * 시/군/구 목록 재조회.
             */
            location.href =
                "${pageContext.request.contextPath}/facility/history.do"
                + "?sidoNm=" + this.value;

        });

    /*
     * 페이징 버튼 클릭 처리
     *
     * data-page란?
     * → PaginationInfoVO가 만든 페이지 번호를 담고 있는 HTML 속성.
     *
     * 왜 사용?
     * → 페이지 번호를 클릭했을 때 form의 currentPage 값을 바꿔서 다시 검색하기 위해.
     */
    document.addEventListener("click", function(e) {

        if (e.target.classList.contains("page-link")
            && e.target.dataset.page) {

            e.preventDefault();

            document.getElementById("currentPage").value = e.target.dataset.page;
            document.querySelector(".facility-search-form").dataset.paging = "Y";
            document.querySelector(".facility-search-form").submit();
        }


    });

    /*
 * 시설사항 테이블 컬럼 정렬
 *
 * 정렬이란?
 * → 데이터를 가나다순 또는 반대순으로 다시 배치하는 것.
 *
 * 왜 JS로 처리?
 * → 이미 화면에 조회된 데이터만 오름차순/내림차순으로 바꾸는 기능이라
 *   서버를 다시 호출하지 않아도 된다.
 */
    document.querySelectorAll("#facilitySortTable .sortable-th").forEach(function(th) {

        th.addEventListener("click", function() {

            const table = document.getElementById("facilitySortTable");
            const tbody = table.querySelector("tbody");

            /*
             * data-sort-col 값 가져오기
             * → 사용자가 클릭한 제목이 몇 번째 컬럼인지 확인한다.
             */
            const colIndex = Number(this.dataset.sortCol);

            /*
             * 현재 정렬 방향 확인
             * asc  = 오름차순
             * desc = 내림차순
             */
            const currentDir = this.dataset.sortDir || "desc";
            const nextDir = currentDir === "asc" ? "desc" : "asc";

            this.dataset.sortDir = nextDir;

            /*
             * tbody 안의 tr들을 배열로 변환
             * → sort()를 사용하려면 배열 형태가 편하다.
             */
            const rows = Array.from(tbody.querySelectorAll("tr"));

            rows.sort(function(a, b) {
                const aText = a.children[colIndex].innerText.trim();
                const bText = b.children[colIndex].innerText.trim();

                /*
                 * localeCompare
                 * → 한글 가나다순 정렬에 사용한다.
                 */
                if (nextDir === "asc") {
                    return aText.localeCompare(bText, "ko");
                } else {
                    return bText.localeCompare(aText, "ko");
                }
            });

            /*
             * 정렬된 tr을 tbody에 다시 붙인다.
             * appendChild는 기존 요소를 복사하는 게 아니라 위치를 이동시킨다.
             */
            rows.forEach(function(row) {
                tbody.appendChild(row);
            });
        });
    });

    /*
 * 시설사항 표 검색 + 클라이언트 페이징
 *
 * 클라이언트 검색이란?
 * → 서버를 다시 호출하지 않고, 화면에 이미 출력된 tr만 대상으로 검색하는 방식.
 *
 * 왜 사용?
 * → 검색 버튼을 눌러도 화면 전체가 새로고침되지 않고,
 *   시설사항 표 데이터만 필터링된다.
 */
    (function() {

        const pageSize = 5; // 한 페이지에 보여줄 시설사항 개수
        let currentFacilityPage = 1;

        const rows = Array.from(document.querySelectorAll("#facilitySortTable tbody .facility-row"));
        const pagination = document.getElementById("facilityClientPagination");

        const facilityNmSearch = document.getElementById("facilityNmSearch");
        const facilityTySearch = document.getElementById("facilityTySearch");
        const facilityLocSearch = document.getElementById("facilityLocSearch");

        const facilitySearchBtn = document.getElementById("facilitySearchBtn");
        const facilityResetBtn = document.getElementById("facilityResetBtn");

        let filteredRows = rows;

        if (!pagination || rows.length === 0) {
            return;
        }

        function applySearch() {
            const nmKeyword = facilityNmSearch.value.trim();
            const tyKeyword = facilityTySearch.value.trim();
            const locKeyword = facilityLocSearch.value.trim();

            /*
             * filter란?
             * → 조건에 맞는 데이터만 남기는 배열 함수.
             *
             * 여기서는 시설명/시설유형/상세위치가 검색어와 맞는 tr만 남긴다.
             */
            filteredRows = rows.filter(function(row) {
                const facilityNm = row.dataset.facilityNm || "";
                const facilityTy = row.dataset.facilityTy || "";
                const facilityLoc = row.dataset.facilityLoc || "";

                const matchNm = nmKeyword === "" || facilityNm.includes(nmKeyword);
                const matchTy = tyKeyword === "" || facilityTy.includes(tyKeyword);
                const matchLoc = locKeyword === "" || facilityLoc.includes(locKeyword);

                return matchNm && matchTy && matchLoc;
            });

            renderFacilityRows(1);
        }

        function renderFacilityRows(page) {
            currentFacilityPage = page;

            rows.forEach(function(row) {
                row.style.display = "none";
            });

            const startIndex = (page - 1) * pageSize;
            const endIndex = startIndex + pageSize;

            filteredRows.forEach(function(row, index) {
                if (index >= startIndex && index < endIndex) {
                    row.style.display = "";
                }
            });

            renderPagination();
        }

        function renderPagination() {
            pagination.innerHTML = "";

            const totalPage = Math.ceil(filteredRows.length / pageSize);

            if (totalPage <= 1) {
                return;
            }

            addPageButton("<", currentFacilityPage - 1, currentFacilityPage === 1);

            let startPage = Math.floor((currentFacilityPage - 1) / 5) * 5 + 1;
            let endPage = Math.min(startPage + 4, totalPage);

            for (let i = startPage; i <= endPage; i++) {
                addPageButton(i, i, false, i === currentFacilityPage);
            }

            addPageButton(">", currentFacilityPage + 1, currentFacilityPage === totalPage);
        }

        function addPageButton(text, page, disabled, active) {
            const li = document.createElement("li");
            li.className = "page-item" + (active ? " active" : "");

            const a = document.createElement("a");
            a.href = "#";
            a.className = "page-link";
            a.textContent = text;

            if (disabled) {
                a.style.pointerEvents = "none";
                a.style.opacity = "0.4";
            } else {
                a.addEventListener("click", function(e) {
                    e.preventDefault();
                    renderFacilityRows(page);
                });
            }

            li.appendChild(a);
            pagination.appendChild(li);
        }

        facilitySearchBtn.addEventListener("click", function() {
            applySearch();
        });

        facilityResetBtn.addEventListener("click", function() {
            facilityNmSearch.value = "";
            facilityTySearch.value = "";
            facilityLocSearch.value = "";

            filteredRows = rows;
            renderFacilityRows(1);
        });

        renderFacilityRows(1);
    })();

    /*
     * 검색 버튼 클릭 시 항상 1페이지부터 조회
     *
     * 왜 필요?
     * → 현재 5페이지에 있다가 검색하면 currentPage=5가 그대로 넘어가서
     *   검색 결과도 5페이지부터 보이는 문제가 생길 수 있다.
     */
    document.querySelector(".facility-search-form")
        .addEventListener("submit", function() {

            /*
             * paging=Y
             * → 페이지 번호를 클릭해서 넘어가는 경우.
             * 이때는 currentPage를 1로 바꾸면 안 된다.
             */
            if (this.dataset.paging === "Y") {
                this.dataset.paging = "";
                return;
            }
            /*
             * 일반 검색 버튼 submit이면 1페이지로 초기화
             */
            document.getElementById("currentPage").value = "1";
        });

    /*
 * 시설사항 표 클라이언트 페이징
 *
 * 클라이언트 페이징이란?
 * → 서버를 다시 호출하지 않고, 이미 화면에 있는 tr만 숨기고 보여주는 방식.
 *
 * 왜 사용?
 * → 페이지 번호를 눌러도 화면 전체 새로고침 없이 표 데이터만 바뀐다.
 */
    (function() {

        const pageSize = 5; // 한 페이지에 보여줄 시설사항 개수
        let currentFacilityPage = 1;

        const rows = Array.from(document.querySelectorAll("#facilitySortTable tbody .facility-row"));
        const pagination = document.getElementById("facilityClientPagination");

        if (!pagination || rows.length === 0) {
            return;
        }

        const totalPage = Math.ceil(rows.length / pageSize);

        function renderFacilityRows(page) {
            currentFacilityPage = page;

            rows.forEach(function(row, index) {
                const startIndex = (page - 1) * pageSize;
                const endIndex = startIndex + pageSize;

                row.style.display = index >= startIndex && index < endIndex ? "" : "none";
            });

            renderPagination();
        }

        function renderPagination() {
            pagination.innerHTML = "";

            if (totalPage <= 1) {
                return;
            }

            addPageButton("<", currentFacilityPage - 1, currentFacilityPage === 1);

            let startPage = Math.floor((currentFacilityPage - 1) / 5) * 5 + 1;
            let endPage = Math.min(startPage + 4, totalPage);

            for (let i = startPage; i <= endPage; i++) {
                addPageButton(i, i, false, i === currentFacilityPage);
            }

            addPageButton(">", currentFacilityPage + 1, currentFacilityPage === totalPage);
        }

        function addPageButton(text, page, disabled, active) {
            const li = document.createElement("li");
            li.className = "page-item" + (active ? " active" : "");

            const a = document.createElement("a");
            a.href = "#";
            a.className = "page-link";
            a.textContent = text;

            if (disabled) {
                a.style.pointerEvents = "none";
                a.style.opacity = "0.4";
            } else {
                a.addEventListener("click", function(e) {
                    e.preventDefault();
                    renderFacilityRows(page);
                });
            }

            li.appendChild(a);
            pagination.appendChild(li);
        }

        renderFacilityRows(1);
    })();


    /*
 * 새로고침 시 검색조건 초기화
 *
 * URL 파라미터란?
 * → 주소 뒤에 붙는 ?sidonm=서울특별시 같은 검색 조건 값.
 *
 * 왜 제거?
 * → 새로고침하면 브라우저가 같은 URL을 다시 호출해서
 *   이전 검색조건이 그대로 유지되기 때문.
 */
    window.addEventListener("load", function () {

        const url = new URL(window.location.href);

        /*
         * search
         * → URL의 ? 뒤쪽 값 전체
         * 예: ?sidonm=서울특별시&currentPage=1
         */
        if (url.search) {

            /*
             * replaceState
             * → 화면 새로고침 없이 주소창 URL만 바꾸는 기능.
             *
             * 왜 사용?
             * → 검색조건 파라미터를 주소에서 제거해서
             *   다음 새로고침 때 처음 진입 화면처럼 만들기 위해.
             */
            history.replaceState(null, "", url.pathname);
        }
    });

</script>

</body>
</html>