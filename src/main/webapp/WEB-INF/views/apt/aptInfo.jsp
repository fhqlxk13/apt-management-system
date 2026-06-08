<%--
  Created by IntelliJ IDEA.
  User: PC-27
  Date: 2026-05-13
  Time: 오후 5:01
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>

    <title>우리아파트 – ${aptInfo.aptComplexInfo.aptCmplexNm}</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/headerStyle.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebarStyle.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footerStyle.css">

    <!-- 카카오 지도 API -->
    <script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=46f7d3996e1205738757a1e4f1ed1f04&libraries=services&autoload=false"></script>

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
            margin-top: 114px;
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
            max-width: 1040px;
            width: 100%;
            margin: 0 auto;
        }

        /* 브레드크럼 */
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
            text-decoration: none;
        }

        .breadcrumb a:hover {
            color: var(--green-dark);
        }

        .breadcrumb .cur {
            color: var(--green-dark);
            font-weight: 600;
        }

        /* 페이지 제목 */
        .page-title {
            font-size: 20px;
            font-weight: 700;
            color: var(--text-dark);
            letter-spacing: -.5px;
            padding-bottom: 14px;
            border-bottom: 2px solid var(--green-dark);
            margin-bottom: 8px;
        }

        .page-desc {
            font-size: 13.5px;
            color: var(--text-mid);
            margin-bottom: 24px;
            line-height: 1.6;
        }

        /* 상단 단지 프로필 */
        .apt-profile {
            background: var(--green-dark);
            border-radius: 10px;
            padding: 22px 28px;
            display: flex;
            align-items: center;
            gap: 22px;
            margin-bottom: 22px;
        }

        .apt-icon-wrap {
            width: 60px;
            height: 60px;
            border-radius: 10px;
            background: rgba(255, 255, 255, .15);
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        .apt-icon-wrap svg {
            width: 31px;
            height: 31px;
            color: #fff;
        }

        .apt-profile-info h2 {
            font-size: 18px;
            font-weight: 700;
            color: #fff;
            letter-spacing: -.4px;
            margin: 0 0 5px;
        }

        .apt-profile-info .addr {
            font-size: 12.5px;
            color: rgba(255, 255, 255, .78);
        }

        .apt-tags {
            display: flex;
            gap: 7px;
            margin-top: 10px;
            flex-wrap: wrap;
        }

        .apt-tag {
            font-size: 11px;
            font-weight: 600;
            padding: 3px 10px;
            border-radius: 20px;
            background: rgba(255, 255, 255, .18);
            color: #fff;
        }

        /* 공통 섹션 카드 */
        .apt-section {
            border: 1px solid var(--border);
            border-radius: 8px;
            background: var(--white);
            margin-bottom: 24px;
            overflow: hidden;
        }

        .section-head {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 15px 20px;
            border-bottom: 1px solid var(--border);
            background: var(--white);
        }

        .section-head h3 {
            display: flex;
            align-items: center;
            gap: 8px;
            margin: 0;
            font-size: 15px;
            font-weight: 700;
            color: var(--text-dark);
        }

        .section-head h3 svg {
            width: 18px;
            height: 18px;
            color: var(--green-dark);
        }

        .section-sub {
            font-size: 12px;
            color: var(--text-light);
        }

        .section-body {
            padding: 20px;
        }

        /* 지도 */
        .map-wrap {
            position: relative;
        }

        #aptMap {
            width: 100%;
            height: 390px;
            border: 1px solid var(--border);
            border-radius: 8px;
            overflow: hidden;
            background: #eef1ef;
        }

        .map-info-card {
            position: absolute;
            left: 20px;
            top: 20px;
            z-index: 5;
            width: 310px;
            padding: 16px 18px;
            border: 1px solid var(--border);
            border-radius: 8px;
            background: rgba(255, 255, 255, .96);
            box-shadow: 0 6px 18px rgba(30, 45, 35, .13);
        }

        .map-info-card strong {
            display: block;
            font-size: 15px;
            font-weight: 700;
            color: var(--text-dark);
            margin-bottom: 8px;
        }

        .map-info-card p {
            margin: 0;
            font-size: 12.5px;
            color: var(--text-mid);
            line-height: 1.6;
        }

        .map-info-card .map-link {
            display: inline-flex;
            margin-top: 9px;
            font-size: 12px;
            font-weight: 600;
            color: var(--green-dark);
            text-decoration: none;
        }

        .map-info-card .map-link:hover {
            text-decoration: underline;
        }

        /* 단지배치도 */
        .layout-image-box {
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 420px;
            border: 1px solid var(--border);
            border-radius: 8px;
            background: #fafafa;
            padding: 22px;
        }

        .layout-image-box img {
            max-width: 100%;
            max-height: 620px;
            object-fit: contain;
            display: block;
        }

        .empty-image-box {
            width: 100%;
            min-height: 260px;
            border: 1px dashed var(--border);
            border-radius: 8px;
            background: var(--bg);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            color: var(--text-light);
            font-size: 13px;
            gap: 8px;
        }

        .empty-image-box svg {
            width: 38px;
            height: 38px;
            color: #cbd5d1;
        }

        /* 평형도 */
        .floor-type-tabs {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            margin-bottom: 18px;
            padding-bottom: 16px;
            border-bottom: 1px solid var(--border);
        }

        .floor-tab {
            min-width: 72px;
            height: 36px;
            padding: 0 14px;
            border: 1px solid var(--border);
            border-radius: 6px;
            background: var(--white);
            color: var(--text-mid);
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            font-family: 'Noto Sans KR', sans-serif;
            transition: all .15s;
        }

        .floor-tab:hover {
            border-color: var(--green-dark);
            color: var(--green-dark);
        }

        .floor-tab.active {
            background: var(--green-dark);
            border-color: var(--green-dark);
            color: #fff;
        }

        .floor-plan-area {
            display: grid;
            grid-template-columns: 1fr 280px;
            gap: 20px;
            align-items: stretch;
        }

        .floor-image-box {
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 360px;
            border: 1px solid var(--border);
            border-radius: 8px;
            background: #fafafa;
            padding: 22px;
        }

        .floor-image-box img {
            max-width: 100%;
            max-height: 460px;
            object-fit: contain;
            display: block;
        }

        .floor-info-card {
            border: 1px solid var(--border);
            border-radius: 8px;
            overflow: hidden;
            align-self: start;
        }

        .floor-info-title {
            padding: 13px 16px;
            background: var(--green-pale);
            border-bottom: 1px solid var(--border);
            font-size: 13.5px;
            font-weight: 700;
            color: var(--text-dark);
        }

        .floor-info-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 13px;
        }

        .floor-info-table tr {
            border-bottom: 1px solid var(--border);
        }

        .floor-info-table tr:last-child {
            border-bottom: none;
        }

        .floor-info-table th {
            width: 94px;
            padding: 11px 14px;
            background: var(--bg);
            color: var(--text-mid);
            font-weight: 600;
            text-align: left;
            border-right: 1px solid var(--border);
            white-space: nowrap;
        }

        .floor-info-table td {
            padding: 11px 14px;
            color: var(--text-dark);
        }

        @media (max-width: 1200px) {
            .content-area {
                padding: 24px 24px 48px;
            }

            .floor-plan-area {
                grid-template-columns: 1fr;
            }

            .floor-info-card {
                align-self: stretch;
            }
        }

        @media (max-width: 768px) {
            .map-info-card {
                position: static;
                width: 100%;
                margin-bottom: 12px;
            }

            #aptMap {
                height: 320px;
            }

            .apt-profile {
                align-items: flex-start;
            }
        }

        .layout-slider {
            position: relative;
            width: 100%;
        }

        .layout-slider-track {
            position: relative;
            width: 100%;
            min-height: 420px;
        }

        .layout-slide {
            display: none;
            width: 100%;
            max-height: 620px;
            object-fit: contain;
        }

        .layout-slide.active {
            display: block;
        }

        .layout-nav {
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            z-index: 5;

            width: 42px;
            height: 42px;

            border: none;
            border-radius: 50%;

            background: rgba(0, 0, 0, .45);
            color: #fff;

            font-size: 22px;
            cursor: pointer;

            transition: .15s;
        }

        .layout-nav:hover {
            background: rgba(0, 0, 0, .65);
        }

        .layout-nav.prev {
            left: 10px;
        }

        .layout-nav.next {
            right: 10px;
        }
    </style>
</head>

<body>

<%@ include file="/WEB-INF/views/include/apt_headerLayout.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebarStyle.css">
<div class="main-shell">
    <%@ include file="/WEB-INF/views/include/apt_sidebarLayout.jsp" %>

    <div class="content-area">
        <div class="page-content-wrap">

            <!-- 브레드크럼 -->
            <nav class="breadcrumb">
                <a href="${pageContext.request.contextPath}/apt/main/${aptCmplexNo}">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round">
                        <path d="M3 9.5L12 3l9 6.5V20a1 1 0 01-1 1H4a1 1 0 01-1-1V9.5z"/>
                        <path d="M9 21V12h6v9"/>
                    </svg>
                </a>

                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round"
                     style="width:10px;height:10px;color:#bbb">
                    <path d="M9 18l6-6-6-6"/>
                </svg>

                <a href="${pageContext.request.contextPath}/resident/apt/info">공공주택정보</a>

                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round"
                     style="width:10px;height:10px;color:#bbb">
                    <path d="M9 18l6-6-6-6"/>
                </svg>

                <span class="cur">우리아파트</span>
            </nav>

            <h1 class="page-title">우리아파트</h1>
            <p class="page-desc">
                우리 단지의 위치, 단지배치도, 평형도를 한눈에 확인할 수 있습니다.
            </p>

            <!-- 상단 단지 정보 -->
            <div class="apt-profile">
                <div class="apt-icon-wrap">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.7"
                         stroke-linecap="round">
                        <path d="M4 21V8l8-5 8 5v13"/>
                        <path d="M9 21v-7h6v7"/>
                        <path d="M8 10h.01M12 10h.01M16 10h.01"/>
                    </svg>
                </div>

                <div class="apt-profile-info">
                    <h2>
                        <c:choose>
                            <c:when test="${not empty aptInfo.aptComplexInfo.aptCmplexNm}">
                                ${aptInfo.aptComplexInfo.aptCmplexNm} 에 오신것을 환영합니다.
                            </c:when>
                            <c:otherwise>우리아파트</c:otherwise>
                        </c:choose>
                    </h2>

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

                    <div class="apt-tags">
                        <span class="apt-tag">${aptInfo.aptComplexInfo.unitCnt}세대</span>
                        <span class="apt-tag">${aptInfo.aptComplexInfo.dongCnt}개 동</span>

                        <c:if test="${not empty aptInfo.aptComplexInfo.bldYr}">
                <span class="apt-tag">
                  <c:choose>
                      <c:when test="${fn:length(aptInfo.aptComplexInfo.bldYr) == 8}">
                          ${fn:substring(aptInfo.aptComplexInfo.bldYr, 0, 4)}년
                          ${fn:substring(aptInfo.aptComplexInfo.bldYr, 4, 6)}월
                          ${fn:substring(aptInfo.aptComplexInfo.bldYr, 6, 8)}일 준공
                      </c:when>
                      <c:otherwise>
                          ${aptInfo.aptComplexInfo.bldYr} 준공
                      </c:otherwise>
                  </c:choose>
                </span>
                        </c:if>
                    </div>
                </div>
            </div>

            <!-- 1. 지도 -->
            <section class="apt-section">
                <div class="section-head">
                    <h3>
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"
                             stroke-linecap="round">
                            <path d="M12 21s7-5.2 7-11a7 7 0 10-14 0c0 5.8 7 11 7 11z"/>
                            <circle cx="12" cy="10" r="2.5"/>
                        </svg>
                        지도 위치
                    </h3>
                    <span class="section-sub">단지 주소 기준 위치입니다.</span>
                </div>

                <div class="section-body">
                    <div class="map-wrap">

                        <div class="map-info-card">
                            <strong>
                                <c:choose>
                                    <c:when test="${not empty aptInfo.aptComplexInfo.aptCmplexNm}">
                                        ${aptInfo.aptComplexInfo.aptCmplexNm}
                                    </c:when>
                                    <c:otherwise>우리아파트</c:otherwise>
                                </c:choose>
                            </strong>

                            <p>
                                <c:choose>
                                    <c:when test="${not empty aptInfo.aptComplexInfo.dorojuso}">
                                        ${aptInfo.aptComplexInfo.dorojuso}
                                    </c:when>
                                    <c:otherwise>
                                        ${aptInfo.aptComplexInfo.sidoNm} ${aptInfo.aptComplexInfo.sigunguNm} ${aptInfo.aptComplexInfo.emdNm}
                                    </c:otherwise>
                                </c:choose>
                            </p>

                        </div>

                        <div id="aptMap"></div>
                    </div>
                </div>
            </section>

            <!-- 2. 단지배치도 -->
            <section class="apt-section">
                <div class="section-head">
                    <h3>
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"
                             stroke-linecap="round">
                            <rect x="3" y="4" width="18" height="16" rx="2"/>
                            <path d="M8 8h3v3H8zM13 8h3v3h-3zM8 13h3v3H8zM13 13h3v3h-3z"/>
                        </svg>
                        단지배치도
                    </h3>
                    <span class="section-sub">동별 위치와 주요 시설 배치를 확인할 수 있습니다.</span>
                </div>

                <div class="section-body">
                    <div class="layout-image-box">
                        <c:choose>
                            <c:when test="${not empty layoutFiles}">

                                <div class="layout-slider">

                                    <c:if test="${fn:length(layoutFiles) > 1}">
                                        <button type="button"
                                                class="layout-nav prev"
                                                onclick="moveLayoutSlide(-1)">
                                            &#10094;
                                        </button>
                                    </c:if>

                                    <div class="layout-slider-track">

                                        <c:forEach items="${layoutFiles}"
                                                   var="file"
                                                   varStatus="status">

                                            <img
                                                    class="layout-slide ${status.first ? 'active' : ''}"
                                                    src="${pageContext.request.contextPath}/file/display/${file.googleId}"
                                                    alt="단지배치도 ${status.index + 1}"
                                                    style = "width: 100%"
                                            >

                                        </c:forEach>

                                    </div>

                                    <c:if test="${fn:length(layoutFiles) > 1}">
                                        <button type="button"
                                                class="layout-nav next"
                                                onclick="moveLayoutSlide(1)">
                                            &#10095;
                                        </button>
                                    </c:if>

                                </div>

                            </c:when>

                            <%-- 임시 이미지 경로. 실제 이미지 넣으면 이 부분만 변경 --%>
                            <c:otherwise>
                                <div class="empty-image-box">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6">
                                        <rect x="3" y="5" width="18" height="14" rx="2"/>
                                        <circle cx="8.5" cy="10" r="1.5"/>
                                        <path d="M21 15l-5-5L5 19"/>
                                    </svg>
                                    <span>등록된 단지배치도가 없습니다.</span>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </section>

            <!-- 3. 평형도 -->
            <section class="apt-section">
                <div class="section-head">
                    <h3>
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"
                             stroke-linecap="round">
                            <path d="M4 4h16v16H4z"/>
                            <path d="M4 12h7V4"/>
                            <path d="M11 12v8"/>
                            <path d="M11 15h9"/>
                        </svg>
                        평형도
                    </h3>
                    <span class="section-sub">평형별 구조와 면적 정보를 확인할 수 있습니다.</span>
                </div>

                <div class="section-body">

                    <!-- 평형 탭 -->
                    <!-- 평형 탭 -->
                    <div class="floor-type-tabs" id="floorTypeTabs"></div>

                    <div class="floor-plan-area">

                        <!-- 평형도 이미지 -->
                        <div class="floor-image-box">

                            <img
                                    id="floorPlanImg"
                                    src=""
                                    alt="평형도"
                                    style="display:none;"
                            >

                            <div class="empty-image-box" id="emptyFloorBox">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6">
                                    <rect x="4" y="4" width="16" height="16" rx="2"/>
                                    <path d="M4 12h16M12 4v16"/>
                                </svg>
                                <span>등록된 평형도가 없습니다.</span>
                            </div>

                        </div>

                        <!-- 평형 정보 -->
                        <div class="floor-info-card">

                            <div class="floor-info-title">평형 정보</div>

                            <table class="floor-info-table">
                                <tbody>

                                <tr>
                                    <th>평형</th>
                                    <td id="floorTypeText">-</td>
                                </tr>

                                <tr>
                                    <th>전용면적</th>
                                    <td id="privateAreaText">-</td>
                                </tr>

                                <tr>
                                    <th>방/욕실</th>
                                    <td id="roomBathText">-</td>
                                </tr>

                                <tr>
                                    <th>세대수</th>
                                    <td id="householdText">-</td>
                                </tr>

                                </tbody>
                            </table>

                        </div>

                    </div>
                </div>
            </section>

        </div>
    </div>
</div>

<%@ include file="/WEB-INF/views/include/apt_footerLayout.jsp" %>

<script>
    /**
     * 1. 지도 표시
     * 주소가 있으면 주소로 좌표 검색
     * 주소가 없거나 검색 실패하면 기본 좌표 사용
     */
    kakao.maps.load(function () {
        var mapContainer = document.getElementById('aptMap');

        var aptName = '${aptInfo.aptComplexInfo.aptCmplexNm}';
        var aptAddress = '';

        <c:choose>
        <c:when test="${not empty aptInfo.aptComplexInfo.dorojuso}">
        aptAddress = '${aptInfo.aptComplexInfo.dorojuso}';
        </c:when>
        <c:otherwise>
        aptAddress = '${aptInfo.aptComplexInfo.sidoNm} ${aptInfo.aptComplexInfo.sigunguNm} ${aptInfo.aptComplexInfo.emdNm}';
        </c:otherwise>
        </c:choose>

        // 기본 좌표: 서울 시청 근처. 실제 주소 검색 실패 시 사용
        var defaultPosition = new kakao.maps.LatLng(37.566826, 126.9786567);

        var mapOption = {
            center: defaultPosition,
            level: 4
        };

        var map = new kakao.maps.Map(mapContainer, mapOption);
        var geocoder = new kakao.maps.services.Geocoder();

        function setMarker(position, title) {
            var marker = new kakao.maps.Marker({
                map: map,
                position: position
            });

            var infowindow = new kakao.maps.InfoWindow({
                content:
                    '<div style="padding:8px 12px;font-size:12px;font-weight:600;white-space:nowrap;">'
                    + title +
                    '</div>'
            });

            infowindow.open(map, marker);
            map.setCenter(position);
        }

        if (aptAddress && aptAddress.trim() !== '') {
            geocoder.addressSearch(aptAddress, function (result, status) {
                if (status === kakao.maps.services.Status.OK) {
                    var position = new kakao.maps.LatLng(result[0].y, result[0].x);
                    setMarker(position, aptName || '우리아파트');
                } else {
                    setMarker(defaultPosition, aptName || '우리아파트');
                }
            });
        } else {
            setMarker(defaultPosition, aptName || '우리아파트');
        }
    });

    async function loadHoTypeList() {

        const aptCmplexNo = '${aptCmplexNo}';

        try {

            const resp = await fetch(
                '${pageContext.request.contextPath}/apt/hoTyList/'
                + aptCmplexNo
            );

            const list = await resp.json();

            renderHoTypeTabs(list);

            // 첫번째 자동 선택
            if (list && list.length > 0) {
                selectHoType(list[0]);
            }

        } catch (e) {
            console.error(e);
        }
    }

    /**
     * 평형 버튼 생성
     */
    function renderHoTypeTabs(list) {

        const tabArea = document.getElementById('floorTypeTabs');

        tabArea.innerHTML = '';

        list.forEach((item, idx) => {

            const button = document.createElement('button');

            button.type = 'button';

            button.className = 'floor-tab';

            if (idx === 0) {
                button.classList.add('active');
            }

            button.innerText = item.tyNm;

            button.addEventListener('click', function () {

                document.querySelectorAll('.floor-tab')
                    .forEach(btn => btn.classList.remove('active'));

                button.classList.add('active');

                selectHoType(item);
            });

            tabArea.appendChild(button);
        });
    }

    /**
     * 평형 선택
     */
    function selectHoType(data) {

        // 평형
        document.getElementById('floorTypeText').innerText =
            data.tyNm || '-';

        // 전용면적
        document.getElementById('privateAreaText').innerText =
            data.exclusiveSize
                ? data.exclusiveSize + '㎡'
                : '-';

        // 방/욕실
        document.getElementById('roomBathText').innerText =
            (data.roomCnt || 0)
            + '개 / '
            + (data.bathroomCnt || 0)
            + '개';

        // 세대수
        document.getElementById('householdText').innerText =
            (data.householdCnt || 0) + '세대';

        // 이미지
        const img = document.getElementById('floorPlanImg');
        const emptyBox = document.getElementById('emptyFloorBox');

        if (data.googleId) {

            img.src =
                '${pageContext.request.contextPath}'
                + '/file/display/'
                + data.googleId;

            img.style.display = 'block';

            emptyBox.style.display = 'none';

        } else {

            img.style.display = 'none';

            emptyBox.style.display = 'flex';
        }
    }

    // 실행
    loadHoTypeList();

    let currentLayoutIndex = 0;

    function moveLayoutSlide(direction) {

        const slides =
            document.querySelectorAll('.layout-slide');

        if (!slides.length) {
            return;
        }

        slides[currentLayoutIndex]
            .classList.remove('active');

        currentLayoutIndex += direction;

        if (currentLayoutIndex < 0) {
            currentLayoutIndex =
                slides.length - 1;
        }

        if (currentLayoutIndex >= slides.length) {
            currentLayoutIndex = 0;
        }

        slides[currentLayoutIndex]
            .classList.add('active');
    }


</script>

</body>
</html>
