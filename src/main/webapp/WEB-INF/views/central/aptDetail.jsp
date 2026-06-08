<%--
  Created by IntelliJ IDEA.
  User: PC-27
  Date: 2026-05-08
  Time: 오후 12:23
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html class="light" lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>우리단지정보 - 우리집맵핑</title>

    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>

    <script src="https://cdn.tailwindcss.com?plugins=forms"></script>
    <script>
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    colors: {
                        surface: "#fbf9f5",
                        primary: "#004830",
                        "primary-container": "#226046",
                        "on-surface": "#1b1c1a",
                        "surface-container": "#efeeea",
                        "surface-container-low": "#f5f3ef",
                        "outline-variant": "#c6c8b8"
                    },
                    fontFamily: {
                        headline: ["Manrope"],
                        body: ["Manrope"],
                        label: ["Manrope"]
                    }
                }
            }
        }
    </script>
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/apt/aptDetail.css">
</head>

<body class="bg-surface text-on-surface flex flex-col min-h-screen">

<%@ include file="/WEB-INF/views/include/main_headerLayout.jsp" %>
<%@ include file="/WEB-INF/views/include/central_sidebar.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/centralSidebarStyle.css">

<main class="ml-80 p-10 pt-28 flex-1">

    <!-- 상단 타이틀 -->
    <div class="flex flex-col md:flex-row md:items-center justify-between gap-6 mb-8">
        <div>
            <div class="flex items-center gap-2 text-slate-400 text-sm mb-2 font-label">
                <span>Home</span>
                <span class="material-symbols-outlined text-[16px]">chevron_right</span>
                <span>공공주택정보</span>
                <span class="material-symbols-outlined text-[16px]">chevron_right</span>
                <span class="text-primary font-bold">단지정보</span>
            </div>

            <h4 class="text-3xl font-extrabold tracking-tight text-on-surface mb-2">
                단지정보
            </h4>

            <p class="text-gray-500">
                단지의 기본 정보, 주소, 세대수, 주차 정보 등을 확인할 수 있습니다.
            </p>
        </div>

        <div class="flex items-center gap-3">

            <!-- 아파트 홈페이지 이동 -->
            <a href="${pageContext.request.contextPath}/apt/main/${aptInfo.aptCmplexNo}"
               class="inline-flex items-center gap-2 px-5 py-2.5 rounded-full bg-primary text-white border border-primary text-sm font-bold hover:bg-[#003820] transition-all shadow-sm">
                <span class="material-symbols-outlined text-[18px]">home</span>
                아파트 홈페이지
            </a>

            <!-- 단지목록 이동 -->
            <a href="${pageContext.request.contextPath}/main/apt/list.do"
               class="inline-flex items-center gap-2 px-5 py-2.5 rounded-full bg-white border border-[#e5eadf] text-sm font-bold text-slate-600 hover:text-primary hover:border-primary/40 transition-all shadow-sm">
                <span class="material-symbols-outlined text-[18px]">list</span>
                단지목록으로
            </a>

        </div>
    </div>

    <!-- 요약 카드 -->
    <section class="bg-white rounded-3xl border border-[#eef2eb] shadow-sm p-7 mb-8">
        <div class="flex flex-col lg:flex-row lg:items-center justify-between gap-6">

            <div class="flex items-start gap-4">
                <div class="w-14 h-14 rounded-2xl bg-primary/10 flex items-center justify-center shrink-0">
                    <span class="material-symbols-outlined text-primary text-3xl">apartment</span>
                </div>

                <div>
                    <div class="inline-flex items-center px-3 py-1 rounded-full bg-primary text-white text-xs font-bold mb-3">
                        ${aptInfo.sidoNm} ${aptInfo.sigunguNm}
                    </div>

                    <h5 class="text-2xl font-extrabold text-slate-900 mb-2">
                        <c:out value="${aptInfo.aptCmplexNm}" default="단지명 정보 없음"/>
                    </h5>

                    <p class="text-sm text-slate-500">
                        <c:out value="${aptInfo.dorojuso}" default="도로명주소 정보가 없습니다."/>
                    </p>
                </div>
            </div>

            <div class="grid grid-cols-3 gap-3 min-w-[360px]">
                <div class="rounded-2xl bg-[#f5f7f2] px-5 py-4 text-center">
                    <div class="text-xs font-bold text-slate-400 mb-1">세대수</div>
                    <div class="text-xl font-extrabold text-primary">
                        ${aptInfo.unitCnt}
                    </div>
                </div>

                <div class="rounded-2xl bg-[#f5f7f2] px-5 py-4 text-center">
                    <div class="text-xs font-bold text-slate-400 mb-1">동수</div>
                    <div class="text-xl font-extrabold text-primary">
                        ${aptInfo.dongCnt}
                    </div>
                </div>

                <div class="rounded-2xl bg-[#f5f7f2] px-5 py-4 text-center">
                    <div class="text-xs font-bold text-slate-400 mb-1">주차대수</div>
                    <div class="text-xl font-extrabold text-primary">
                        ${aptInfo.pkgCnt}
                    </div>
                </div>
            </div>

        </div>
    </section>

    <!-- 기본 정보 테이블 -->
    <section class="bg-white rounded-3xl border border-[#eef2eb] shadow-sm p-7 mb-8">
        <div class="section-title">
            <span class="material-symbols-outlined text-primary">info</span>
            단지 기본정보
        </div>

        <div class="overflow-hidden rounded-2xl border border-[#e5e7eb]">
            <table class="info-table">
                <tbody>
                <tr>
                    <th>명칭(단지코드)</th>
                    <td>
                        <c:out value="${aptInfo.aptCmplexNm}" default="-"/>
                        <c:if test="${not empty aptInfo.aptCmplexNo}">
                            (<c:out value="${aptInfo.aptCmplexNo}"/>)
                        </c:if>
                    </td>

                    <th>단지분류</th>
                    <td>아파트</td>
                </tr>

                <tr>
                    <th>법정동주소</th>
                    <td>
                        <c:out value="${aptInfo.sidoNm}" default=""/>
                        <c:out value="${aptInfo.sigunguNm}" default=""/>
                        <c:out value="${aptInfo.emdNm}" default=""/>
                    </td>

                    <th>도로명주소</th>
                    <td>
                        <c:out value="${aptInfo.dorojuso}" default="-"/>
                    </td>
                </tr>

                <tr>
                    <th>
                        난방방식
                        <span class="heat-help-wrap">
                            <span class="heat-help-icon">?</span>

                            <div class="heat-tooltip">
                                <dl>
                                    <dt>지역난방</dt>
                                    <dd>일정한 지역을 관할하는 발전소가 인근 아파트단지 및 주거지역으로 열을 공급하는 방식</dd>

                                    <dt>중앙난방</dt>
                                    <dd>단지 내 대형 보일러를 통해 각 세대로 공급하는 방식</dd>

                                    <dt>개별난방</dt>
                                    <dd>각 세대별 소형보일러를 설치해 난방과 온수를 공급하는 방식</dd>
                                </dl>
                            </div>
                        </span>
                    </th>
                    <td>
                        <c:out value="${aptInfo.heatTy}" default="-"/>
                    </td>

                    <th>복도유형</th>
                    <td>-</td>
                </tr>

                <tr>
                    <th>준공년도</th>
                    <td>
                        <c:out value="${aptInfo.bldYr}" default="-"/>
                    </td>

                    <th>최대층수</th>
                    <td>
                        <c:choose>
                            <c:when test="${aptInfo.maxFloor > 0}">
                                ${aptInfo.maxFloor}층
                            </c:when>
                            <c:otherwise>-</c:otherwise>
                        </c:choose>
                    </td>
                </tr>

                <tr>
                    <th>동수 / 세대수</th>
                    <td>
                        <c:choose>
                            <c:when test="${aptInfo.dongCnt > 0 or aptInfo.unitCnt > 0}">
                                ${aptInfo.dongCnt}동 / ${aptInfo.unitCnt}세대
                            </c:when>
                            <c:otherwise>-</c:otherwise>
                        </c:choose>
                    </td>

                    <th>주차가능대수</th>
                    <td>
                        <c:choose>
                            <c:when test="${aptInfo.pkgCnt > 0}">
                                ${aptInfo.pkgCnt}대
                            </c:when>
                            <c:otherwise>-</c:otherwise>
                        </c:choose>
                    </td>
                </tr>

                <tr>
                    <th>세대당 무료주차</th>
                    <td>
                        <c:choose>
                            <c:when test="${aptInfo.freePkgCnt > 0}">
                                ${aptInfo.freePkgCnt}대
                            </c:when>
                            <c:otherwise>-</c:otherwise>
                        </c:choose>
                    </td>

                    <th>CCTV 수</th>
                    <td>
                        <c:out value="${aptInfo.ccCnt}" default="-"/>
                    </td>
                </tr>

                <tr>
                    <th>시공사 / 시행사</th>
                    <td colspan="3">
                        <c:out value="${aptInfo.cnscoNm}" default="-"/>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
    </section>

    <!-- 지도 / 사진 영역 -->
    <section class="grid grid-cols-1 xl:grid-cols-2 gap-8 mb-10">

        <!-- 단지 배치도 -->
        <div class="bg-white rounded-3xl border border-[#eef2eb] shadow-sm p-7">
            <div class="section-title justify-center">
                <span class="material-symbols-outlined text-primary">map</span>
                단지배치도
            </div>
                <div class="image-box">

                    <c:choose>

                        <c:when test="${not empty layoutGoogleIdList}">

                            <div class="slider-container" id="layoutSlider">

                                <c:forEach items="${layoutGoogleIdList}" var="googleId" varStatus="status">

                                    <img
                                            src="/file/display/${googleId}"
                                            class="slider-image ${status.first ? 'active' : ''}"
                                            alt="단지배치도"
                                    />

                                </c:forEach>

                                <c:if test="${fn:length(layoutGoogleIdList) > 1}">
                                    <button type="button" class="slider-btn prev">
                                        <span class="material-symbols-outlined">chevron_left</span>
                                    </button>

                                    <button type="button" class="slider-btn next">
                                        <span class="material-symbols-outlined">chevron_right</span>
                                    </button>
                                </c:if>

                            </div>

                        </c:when>

                        <c:otherwise>

                            <div class="empty-image">
                                <span class="material-symbols-outlined">map</span>
                                <p class="text-sm font-bold">등록된 단지배치도가 없습니다.</p>
                            </div>

                        </c:otherwise>

                    </c:choose>

                </div>
        </div>

        <!-- 단지 사진 -->
        <div class="bg-white rounded-3xl border border-[#eef2eb] shadow-sm p-7">
            <div class="section-title justify-center">
                <span class="material-symbols-outlined text-primary">photo_camera</span>
                단지사진
            </div>

            <div class="image-box">

                <c:choose>

                    <c:when test="${not empty complexGoogleIdList}">

                        <div class="slider-container" id="complexSlider">

                            <c:forEach items="${complexGoogleIdList}" var="googleId" varStatus="status">

                                <img
                                        src="/file/display/${googleId}"
                                        class="slider-image ${status.first ? 'active' : ''}"
                                        alt="단지사진"
                                />

                            </c:forEach>

                            <c:if test="${fn:length(complexGoogleIdList) > 1}">
                                <button type="button" class="slider-btn prev">
                                    <span class="material-symbols-outlined">chevron_left</span>
                                </button>

                                <button type="button" class="slider-btn next">
                                    <span class="material-symbols-outlined">chevron_right</span>
                                </button>
                            </c:if>

                        </div>

                    </c:when>

                    <c:otherwise>

                        <div class="empty-image">
                            <span class="material-symbols-outlined">image</span>
                            <p class="text-sm font-bold">해당 이미지가 없습니다.</p>
                        </div>

                    </c:otherwise>

                </c:choose>

            </div>
        </div>

    </section>

</main>
<div class="image-modal" id="imageModal">

    <div class="modal-top-actions">

        <button type="button" class="modal-zoom-btn" id="zoomOutBtn">
            <span class="material-symbols-outlined">remove</span>
        </button>

        <button type="button" class="modal-zoom-btn" id="zoomInBtn">
            <span class="material-symbols-outlined">add</span>
        </button>

        <a
                id="modalDownloadBtn"
                href="#"
                class="modal-download-btn"
                download
        >
        <span class="material-symbols-outlined">
            download
        </span>
        </a>

        <div class="modal-close-btn" id="modalClose">
        <span class="material-symbols-outlined">
            close
        </span>
        </div>

    </div>

    <button type="button" class="modal-nav-btn modal-prev" id="modalPrev">
        <span class="material-symbols-outlined">chevron_left</span>
    </button>

    <div class="modal-image-wrap">
        <div id="modalImageTarget">
            <img id="modalImage" src="" alt="확대 이미지">
        </div>
    </div>

    <button type="button" class="modal-nav-btn modal-next" id="modalNext">
        <span class="material-symbols-outlined">chevron_right</span>
    </button>

</div>
<div class="ml-80">
    <%@ include file="/WEB-INF/views/include/main_footerLayout.jsp" %>
</div>

<script src="${pageContext.request.contextPath}/js/apt/aptDetail.js"></script>
</body>
</html>
