<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/centralSidebarStyle.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/central/rentDetail.css">

<style>
  /* ==============================
     매물 상세 페이지 레이아웃 보정
  ============================== */

  .rent-detail-layout {
    margin-left: 336px !important;
    width: calc(100% - 336px) !important;
    min-height: 100vh !important;
    padding: 24px 40px 56px !important;
    background: #f8faf6 !important;
    box-sizing: border-box !important;
  }

  .rent-detail-content {
    width: 100% !important;
    max-width: none !important;
    margin: 0 !important;
    box-sizing: border-box !important;
  }

  .rent-detail-page {
    width: 100% !important;
    max-width: 1180px !important;
    margin: 0 auto !important;
    box-sizing: border-box !important;
  }

  .rent-detail-head {
    margin-bottom: 20px !important;
  }

  .rent-detail-head h1 {
    margin: 8px 0 10px !important;
    font-size: 38px !important;
    font-weight: 700 !important;
    color: #0b1f17 !important;
    letter-spacing: -1px !important;
  }

  .rent-detail-head p {
    margin: 0 !important;
    font-size: 16px !important;
    color: #667085 !important;
    line-height: 1.6 !important;
  }

  .rent-detail-breadcrumb {
    display: flex !important;
    align-items: center !important;
    gap: 10px !important;
    color: #98a2b3 !important;
    font-size: 14px !important;
    font-weight: 500 !important;
  }

  .rent-detail-breadcrumb a {
    color: #98a2b3 !important;
    text-decoration: none !important;
  }

  .rent-detail-breadcrumb strong {
    color: #005f46 !important;
    font-weight: 700 !important;
  }

  /*
    기존 rentDetail.css의 detail-hero가 큰 카드 역할을 해서
    안쪽 detail-summary와 이중 카드가 생김.
    여기서 바깥 카드 스타일 제거.
  */
  .detail-hero {
    display: block !important;
    width: 100% !important;
    margin: 0 0 24px !important;
    padding: 0 !important;
    background: transparent !important;
    border: 0 !important;
    border-radius: 0 !important;
    box-shadow: none !important;
    box-sizing: border-box !important;
  }

  .detail-summary {
    width: 100% !important;
    padding: 28px 32px !important;
    background: #fff !important;
    border: 1px solid #e5e7eb !important;
    border-radius: 18px !important;
    box-shadow: 0 8px 24px rgba(16, 24, 40, 0.04) !important;
    box-sizing: border-box !important;
  }

  .trade-badge {
    display: inline-flex !important;
    align-items: center !important;
    justify-content: center !important;
    padding: 8px 14px !important;
    border-radius: 999px !important;
    background: #16a34a !important;
    color: #fff !important;
    font-size: 14px !important;
    font-weight: 700 !important;
    margin-bottom: 18px !important;
  }

  .detail-title {
    margin: 0 0 18px !important;
    font-size: 30px !important;
    font-weight: 700 !important;
    color: #0b1f17 !important;
    letter-spacing: -0.6px !important;
  }

  .detail-price {
    margin-bottom: 18px !important;
    color: #007a3d !important;
    font-size: 30px !important;
    font-weight: 700 !important;
    letter-spacing: -0.7px !important;
  }

  .detail-address {
    margin: 0 0 24px !important;
    color: #667085 !important;
    font-size: 15px !important;
  }

  .summary-grid {
    display: grid !important;
    grid-template-columns: repeat(2, minmax(0, 1fr)) !important;
    gap: 14px !important;
    margin-top: 20px !important;
  }

  .summary-grid > div {
    padding: 16px 18px !important;
    border-radius: 12px !important;
    background: #f8fafc !important;
    border: 1px solid #e5e7eb !important;
  }

  .summary-grid span {
    display: block !important;
    margin-bottom: 7px !important;
    color: #667085 !important;
    font-size: 13px !important;
    font-weight: 400 !important;
  }

  .summary-grid strong {
    color: #111827 !important;
    font-size: 17px !important;
    font-weight: 600 !important;
  }

  .detail-card {
    width: 100% !important;
    padding: 28px 32px !important;
    margin-bottom: 24px !important;
    box-sizing: border-box !important;
  }

  @media (max-width: 1200px) {
    .rent-detail-layout {
      margin-left: 280px !important;
      width: calc(100% - 280px) !important;
      padding-left: 28px !important;
      padding-right: 28px !important;
    }
  }

  @media (max-width: 900px) {
    .rent-detail-layout {
      margin-left: 0 !important;
      width: 100% !important;
      padding: 88px 20px 48px !important;
    }

    .summary-grid {
      grid-template-columns: 1fr !important;
    }
  }
</style>
<%@ include file="/WEB-INF/views/include/main_headerLayout.jsp" %>
<%@ include file="/WEB-INF/views/include/central_sidebar.jsp" %>

<c:if test="${empty rentDetail}">
  <script>
    alert("매물 정보를 찾을 수 없습니다.");
    location.href = "${pageContext.request.contextPath}/rent/list";
  </script>
</c:if>

<div class="rent-detail-layout">

  <main class="rent-detail-content">
    <div class="rent-detail-page">

      <div class="rent-detail-head">
        <nav class="rent-detail-breadcrumb" aria-label="breadcrumb">
          <a href="${pageContext.request.contextPath}/">Home</a>
          <span>›</span>
          <a href="${pageContext.request.contextPath}/rent/list">매물목록</a>
          <span>›</span>
          <strong>매물 상세</strong>
        </nav>

        <h1>매물 상세</h1>

        <p>
          공공주택 임대 매물의 단지정보, 가격정보, 위치정보를 한눈에 확인할 수 있습니다.
        </p>
      </div>

      <section class="detail-hero">

        <div class="detail-summary">
          <span class="trade-badge">
            <c:out value="${rentDetail.rentTypeNm}" />
          </span>

          <h2 class="detail-title">
            <c:out value="${rentDetail.rentTtl}" />
          </h2>

          <div class="detail-price"
               id="detailPrice"
               data-rent-type="${rentDetail.rentTypeCd}"
               data-dpst-amt="${rentDetail.dpstAmt}"
               data-monthly-amt="${rentDetail.mthlyRentAmt}">
          </div>

          <p class="detail-address">
            <c:out value="${rentDetail.dorojuso}" />
          </p>

          <div class="summary-grid">
            <div>
              <span>임대유형</span>
              <strong><c:out value="${rentDetail.rentTypeNm}" /></strong>
            </div>
            <div>
              <span>층수</span>
              <strong>
                <c:out value="${rentDetail.floor}" />층 /
                최고 <c:out value="${rentDetail.dongMaxFloor}" />층
              </strong>
            </div>
            <div>
              <span>동/호수</span>
              <strong>
                <c:out value="${rentDetail.dongNm}" />
                <c:out value="${rentDetail.ho}" />호
              </strong>
            </div>
            <div>
              <span>호 상태</span>
              <strong><c:out value="${rentDetail['empty']}" /></strong>
            </div>
          </div>
        </div>
      </section>

      <section class="detail-card">
        <div class="section-title-row">
          <h3>매물 정보</h3>
        </div>

        <div class="info-table">
          <div class="info-row">
            <div class="info-label">매물번호</div>
            <div class="info-value">
              <c:out value="${rentDetail.rentLstgNo}" />
            </div>
            <div class="info-label">임대유형</div>
            <div class="info-value">
              <c:out value="${rentDetail.rentTypeNm}" />
            </div>
          </div>

          <div class="info-row">
            <div class="info-label">보증금</div>
            <div class="info-value price-text"
                 id="dpstAmtText"
                 data-value="${rentDetail.dpstAmt}">
            </div>
            <div class="info-label">월 임대료</div>
            <div class="info-value price-text"
                 id="monthlyAmtText"
                 data-value="${rentDetail.mthlyRentAmt}">
            </div>
          </div>

          <div class="info-row">
            <div class="info-label">아파트명</div>
            <div class="info-value">
              <c:out value="${rentDetail.aptCmplexNm}" />
            </div>
            <div class="info-label">호 번호</div>
            <div class="info-value">
              <c:out value="${rentDetail.hoNo}" />
            </div>
          </div>

          <div class="info-row">
            <div class="info-label">동</div>
            <div class="info-value">
              <c:out value="${rentDetail.dongNm}" />
            </div>
            <div class="info-label">호</div>
            <div class="info-value">
              <c:out value="${rentDetail.ho}" />호
            </div>
          </div>

          <div class="info-row full">
            <div class="info-label">매물 설명</div>
            <div class="info-value">
              <c:out value="${rentDetail.rentLstgCn}" />
            </div>
          </div>
        </div>
      </section>

      <section class="detail-card">
        <div class="section-title-row">
          <h3>단지 정보</h3>
        </div>

        <div class="info-table">
          <div class="info-row">
            <div class="info-label">단지명</div>
            <div class="info-value">
              <c:out value="${rentDetail.aptCmplexNm}" />
            </div>
            <div class="info-label">준공년도</div>
            <div class="info-value">
              <c:out value="${rentDetail.bldYr}" />
            </div>
          </div>

          <div class="info-row">
            <div class="info-label">세대수</div>
            <div class="info-value">
              <c:out value="${rentDetail.unitCnt}" />세대
              <c:if test="${not empty rentDetail.dongCnt}">
                / 총 <c:out value="${rentDetail.dongCnt}" />동
              </c:if>
            </div>
            <div class="info-label">동 최고층</div>
            <div class="info-value">
              <c:out value="${rentDetail.dongMaxFloor}" />층
            </div>
          </div>

          <div class="info-row">
            <div class="info-label">시도</div>
            <div class="info-value">
              <c:out value="${rentDetail.sidoNm}" />
            </div>
            <div class="info-label">시군구</div>
            <div class="info-value">
              <c:out value="${rentDetail.sigunguNm}" />
            </div>
          </div>

          <div class="info-row full">
            <div class="info-label">법정동</div>
            <div class="info-value">
              <c:out value="${rentDetail.emdNm}" />
            </div>
          </div>

          <div class="info-row full">
            <div class="info-label">주소</div>
            <div class="info-value">
              <span class="road-badge">도로명</span>
              <c:out value="${rentDetail.dorojuso}" />
            </div>
          </div>
        </div>
      </section>

      <section class="detail-card">
        <div class="section-title-row">
          <h3>위치 정보</h3>
        </div>

        <div id="detailMap"
             style="width:100%; height:380px; border-radius:18px; overflow:hidden; border:1px solid #e5e7eb;">
        </div>
      </section>

      <div style="display:flex; gap:10px; justify-content:flex-end; margin-top:22px;">
        <button type="button"
                class="detail-back-btn"
                onclick="location.href='${pageContext.request.contextPath}/rent/list'">
          목록으로
        </button>

        <button type="button"
                class="detail-back-btn"
                onclick="location.href='${pageContext.request.contextPath}/rent/map?aptCmplexNo=${rentDetail.aptCmplexNo}'">
          지도에서 보기
        </button>
      </div>

    </div>
  </main>
</div>

<script type="text/javascript"
        src="//dapi.kakao.com/v2/maps/sdk.js?appkey=46f7d3996e1205738757a1e4f1ed1f04&libraries=services"></script>

<script>
  document.addEventListener("DOMContentLoaded", function () {
    renderPriceTexts();
    initDetailMap();
  });

  function renderPriceTexts() {
    const detailPrice = document.getElementById("detailPrice");
    const rentTypeCd = detailPrice.dataset.rentType;
    const dpstAmt = Number(detailPrice.dataset.dpstAmt || 0);
    const monthlyAmt = Number(detailPrice.dataset.monthlyAmt || 0);

    if (rentTypeCd === "JS") {
      detailPrice.textContent = "전세 " + formatMoney(dpstAmt);
    } else if (rentTypeCd === "PE") {
      detailPrice.textContent = "보증금 " + formatMoney(dpstAmt) + " / 월 " + formatMoney(monthlyAmt);
    } else {
      detailPrice.textContent = formatMoney(dpstAmt);
    }

    const dpstAmtText = document.getElementById("dpstAmtText");
    const monthlyAmtText = document.getElementById("monthlyAmtText");

    if (dpstAmtText) {
      dpstAmtText.textContent = formatMoney(dpstAmtText.dataset.value);
    }

    if (monthlyAmtText) {
      monthlyAmtText.textContent = formatMoney(monthlyAmtText.dataset.value);
    }
  }

  function initDetailMap() {
    const mapEl = document.getElementById("detailMap");

    if (!mapEl || typeof kakao === "undefined") {
      return;
    }

    const address = "${rentDetail.dorojuso}";
    const aptName = "${rentDetail.aptCmplexNm}";

    const map = new kakao.maps.Map(mapEl, {
      center: new kakao.maps.LatLng(37.5665, 126.9780),
      level: 4
    });

    const geocoder = new kakao.maps.services.Geocoder();

    geocoder.addressSearch(address, function (result, status) {
      if (status !== kakao.maps.services.Status.OK || !result || result.length === 0) {
        mapEl.innerHTML = '<div style="padding:40px;text-align:center;color:#667085;">주소로 위치를 찾을 수 없습니다.</div>';
        return;
      }

      const lat = Number(result[0].y);
      const lng = Number(result[0].x);
      const coords = new kakao.maps.LatLng(lat, lng);

      map.setCenter(coords);

      const marker = new kakao.maps.Marker({
        map: map,
        position: coords
      });

      const infoWindow = new kakao.maps.InfoWindow({
        content: '<div style="padding:8px 12px;font-size:13px;font-weight:700;color:#005f46;">' + escapeHtml(aptName) + '</div>'
      });

      infoWindow.open(map, marker);
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

  function escapeHtml(value) {
    if (value === null || value === undefined) {
      return "";
    }

    return String(value)
      .replaceAll("&", "&amp;")
      .replaceAll("<", "&lt;")
      .replaceAll(">", "&gt;")
      .replaceAll('"', "&quot;")
      .replaceAll("'", "&#039;");
  }
</script>