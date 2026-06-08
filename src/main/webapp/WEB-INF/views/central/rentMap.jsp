<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>임대 매물 지도</title>

  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/centralSidebarStyle.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/central/rentMap.css">
</head>
<body>

<%@ include file="/WEB-INF/views/include/main_headerLayout.jsp" %>
<%@ include file="/WEB-INF/views/include/central_sidebar.jsp" %>

<div class="rent-map-wrap with-sidebar">

  <!-- 상단 타이틀 영역 -->
  <section class="rent-map-top">
    <div class="rent-map-top-left">
      <div class="rent-breadcrumb">
        <span>Home</span>
        <span class="breadcrumb-arrow">›</span>
        <span>매물정보</span>
        <span class="breadcrumb-arrow">›</span>
        <strong>지도에서 보기</strong>
      </div>

      <h1 class="rent-map-page-title">매물 정보 지도</h1>

      <p class="rent-map-page-desc">
        지도에서 공공주택 임대 매물 위치를 확인하고 상세정보를 조회할 수 있습니다.
      </p>
    </div>

    <div class="rent-map-top-right">
      <button type="button"
              class="rent-list-move-btn"
              onclick="location.href='${pageContext.request.contextPath}/rent/list'">
        <span class="rent-list-icon">☰</span>
        매물 목록으로
      </button>
    </div>
  </section>

  <!-- 지도 + 단지 매물목록 + 상세정보 영역 -->
  <div class="rent-map-page panels-collapsed">

    <!-- 좌측: 선택 단지 매물 목록 -->
    <section class="rent-complex-list-panel">
      <div class="rent-complex-list-header">
        <div>
          <p class="rent-complex-list-label">선택 단지 매물</p>
          <h2 id="selectedComplexName"></h2>
        </div>
      </div>

      <div id="complexRentList" class="complex-rent-list"></div>
    </section>

    <!-- 가운데: 선택 매물 상세 -->
    <section class="rent-detail-panel">
      <div id="rentDetailHero" class="rent-detail-hero-area"></div>

      <div class="rent-detail-scroll">
        <div id="rentDetail"></div>
      </div>
    </section>

    <!-- 패널 닫기 버튼: 스크롤 영역 바깥에 배치 -->
    <button type="button"
            class="rent-panel-close-btn"
            onclick="closeRentPanels()"
            aria-label="매물 패널 닫기">
      <span class="material-symbols-outlined">close</span>
    </button>

    <!-- 우측: 지도 -->
    <section class="rent-map-panel">
      <div id="rentMap"></div>
    </section>

  </div>
</div>

<script>
  const CONTEXT_PATH = '${pageContext.request.contextPath}';
</script>

<script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=46f7d3996e1205738757a1e4f1ed1f04"></script>
<script src="${pageContext.request.contextPath}/js/central/rentMap.js?v=20260531_latlon_1"></script>
</body>
</html>