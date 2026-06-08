<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html class="light" lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>아파트 지도 - 우리집맵핑</title>

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

    <style>
        body {
            font-family: 'Manrope', sans-serif;
        }

        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
        }

        .map-card {
            height: calc(100vh - 240px);
            min-height: 650px;
            border-radius: 28px;
            overflow: hidden;
            border: 1px solid #eef2eb;
            background: #ffffff;
            box-shadow: 0 12px 30px rgba(15, 23, 42, 0.06);
            position: relative;
        }

        #map {
            width: 100%;
            height: 100%;
        }

        .map-info-window {
            width: 330px;
            padding: 18px 18px 16px;
            box-sizing: border-box;
            font-family: 'Noto Sans KR', sans-serif;
        }

        .map-info-title {
            display: block;
            font-size: 18px;
            font-weight: 900;
            color: #006b4f;
            margin-bottom: 8px;
            line-height: 1.35;
        }

        .map-info-address {
            display: block;
            font-size: 13px;
            color: #64748b;
            margin-bottom: 8px;
            line-height: 1.5;
        }

        .map-info-meta {
            display: block;
            font-size: 13px;
            font-weight: 800;
            color: #006b4f;
            margin-bottom: 12px;
        }

        /* 매물 정보 표시 */
        .map-info-rent-box {
            margin-top: 10px;
            padding: 13px 14px;
            border-radius: 12px;
            background: #fff5f5;
            border: 1px solid #fecaca;
        }

        .map-info-rent-title {
            display: block;
            color: #dc2626;
            font-size: 13px;
            font-weight: 900;
            margin-bottom: 8px;
        }

        .map-info-rent-line {
            display: block;
            color: #475569;
            font-size: 13px;
            line-height: 1.7;
            word-break: keep-all;
        }

        .map-info-btn-row {
            display: flex;
            gap: 8px;
            margin-top: 14px;
        }

        .map-info-link,
        .map-info-rent-link {
            flex: 1;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            height: 38px;
            border-radius: 10px;
            font-size: 13px;
            font-weight: 800;
            text-decoration: none;
            box-sizing: border-box;
        }

        .map-info-link:hover {
            background: #00513c;
            color: #fff;
        }

        .map-info-link {
            background: #006b4f;
            color: #fff;
            border: 0;
            cursor: pointer;
            font-family: inherit;
        }

        .map-info-rent-link {
            background: #fff;
            color: #dc2626;
            border: 1px solid #fecaca;
        }

        .map-info-rent-link:hover {
            background: #fff5f5;
            color: #b91c1c;
        }

        .map-info-rent-empty {
            display: block;
            margin-top: 8px;
            color: #94a3b8;
            font-size: 12px;
        }

        .map-floating-panel {
            position: absolute;
            top: 22px;
            left: 22px;
            width: 320px;
            z-index: 10;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border: 1px solid #eef2eb;
            border-radius: 24px;
            box-shadow: 0 12px 28px rgba(15, 23, 42, 0.12);
            padding: 18px;
        }

        .map-count-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 7px 12px;
            border-radius: 9999px;
            background: #004830;
            color: white;
            font-size: 12px;
            font-weight: 800;
        }

        .map-empty-box {
            position: absolute;
            top: 50%;
            left: 50%;
            z-index: 20;
            transform: translate(-50%, -50%);
            background: white;
            border: 1px solid #eef2eb;
            border-radius: 22px;
            padding: 28px 34px;
            text-align: center;
            box-shadow: 0 12px 30px rgba(15, 23, 42, 0.12);
        }

        /* ==============================
   아파트 상세 모달
============================== */
        .apt-detail-modal {
            position: fixed;
            inset: 0;
            z-index: 9999;
            display: none;
        }

        .apt-detail-modal.show {
            display: block;
        }

        .apt-detail-modal-backdrop {
            position: absolute;
            inset: 0;
            background: rgba(15, 23, 42, 0.55);
            backdrop-filter: blur(3px);
        }

        .apt-detail-modal-dialog {
            position: absolute;
            top: 50%;
            left: 50%;
            width: min(720px, calc(100% - 32px));
            max-height: calc(100vh - 70px);
            transform: translate(-50%, -50%);
            background: #fff;
            border-radius: 20px;
            box-shadow: 0 24px 80px rgba(0, 0, 0, 0.28);
            overflow: hidden;
        }

        .apt-detail-modal-header {
            display: flex;
            justify-content: space-between;
            gap: 18px;
            padding: 24px 28px 20px;
            border-bottom: 1px solid #e5e7eb;
            background: #f7fbf8;
        }

        .apt-detail-modal-title {
            margin: 0;
            font-size: 24px;
            font-weight: 900;
            color: #006b4f;
            letter-spacing: -0.6px;
        }

        .apt-detail-modal-address {
            margin: 8px 0 0;
            font-size: 14px;
            color: #64748b;
            line-height: 1.6;
        }

        .apt-detail-modal-close {
            width: 38px;
            height: 38px;
            border: 0;
            border-radius: 50%;
            background: #fff;
            color: #334155;
            font-size: 28px;
            line-height: 1;
            cursor: pointer;
            box-shadow: 0 4px 14px rgba(15, 23, 42, 0.12);
        }

        .apt-detail-modal-close:hover {
            background: #edf5ef;
            color: #006b4f;
        }

        .apt-detail-modal-body {
            padding: 24px 28px 28px;
            overflow-y: auto;
            max-height: calc(100vh - 210px);
        }

        .apt-detail-summary {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 12px;
            margin-bottom: 20px;
        }

        .apt-detail-summary-item {
            padding: 16px;
            border: 1px solid #e5e7eb;
            border-radius: 14px;
            background: #fff;
        }

        .apt-detail-summary-label {
            display: block;
            margin-bottom: 6px;
            font-size: 12px;
            color: #64748b;
            font-weight: 700;
        }

        .apt-detail-summary-value {
            display: block;
            font-size: 20px;
            color: #006b4f;
            font-weight: 900;
        }

        .apt-detail-info-table {
            width: 100%;
            border-collapse: collapse;
            border-top: 1px solid #e5e7eb;
        }

        .apt-detail-info-table th,
        .apt-detail-info-table td {
            padding: 14px 12px;
            border-bottom: 1px solid #e5e7eb;
            font-size: 14px;
            text-align: left;
            vertical-align: top;
        }

        .apt-detail-info-table th {
            width: 130px;
            color: #475569;
            background: #f8fafc;
            font-weight: 800;
        }

        .apt-detail-info-table td {
            color: #1f2937;
        }

        .apt-detail-btn-row {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 22px;
        }

        .apt-detail-link-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-width: 130px;
            height: 42px;
            border-radius: 12px;
            background: #006b4f;
            color: #fff;
            font-size: 14px;
            font-weight: 800;
            text-decoration: none;
        }

        .apt-detail-link-btn:hover {
            background: #00513c;
            color: #fff;
        }

        body.apt-detail-modal-open {
            overflow: hidden;
        }

        @media (max-width: 640px) {
            .apt-detail-summary {
                grid-template-columns: 1fr;
            }

            .apt-detail-modal-header,
            .apt-detail-modal-body {
                padding-left: 18px;
                padding-right: 18px;
            }
        }

    </style>
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
                <span class="text-primary font-bold">지도에서 보기</span>
            </div>

            <h1 class="text-4xl font-extrabold tracking-tight text-on-surface mb-2">
                아파트 지도
            </h1>

            <p class="text-gray-500">
                지도에서 아파트 위치를 확인하고 단지 상세정보로 이동할 수 있습니다.
            </p>
        </div>

        <div class="flex items-center gap-3">
            <a href="${pageContext.request.contextPath}/main/apt/list.do"
               class="inline-flex items-center gap-2 px-5 py-2.5 rounded-full bg-white border border-[#e5eadf] text-sm font-bold text-slate-600 hover:text-primary hover:border-primary/40 transition-all shadow-sm">
                <span class="material-symbols-outlined text-[18px]">list</span>
                단지목록으로
            </a>
        </div>
    </div>

    <!-- 지도 카드 -->
    <section class="map-card">

        <!-- 지도 위 안내 패널 -->
        <div class="map-floating-panel">
            <div class="flex items-start justify-between gap-4 mb-4">
                <div>
                    <h2 class="text-xl font-extrabold text-slate-900 mb-1">
                        지도 기반 단지 검색
                    </h2>
                    <p class="text-sm text-slate-500 leading-relaxed">
                        마커를 클릭하면 단지 요약정보와 상세보기 버튼이 표시됩니다.
                    </p>
                </div>

                <span class="material-symbols-outlined text-primary text-3xl">map</span>
            </div>

            <div class="map-count-badge">
                <span class="material-symbols-outlined text-[16px]">apartment</span>
                총 ${fn:length(aptList)}개 단지
            </div>
        </div>

        <c:if test="${empty aptList}">
            <div class="map-empty-box">
                <span class="material-symbols-outlined text-primary text-5xl mb-3">location_off</span>
                <h3 class="text-lg font-extrabold text-slate-900 mb-2">표시할 단지가 없습니다.</h3>
                <p class="text-sm text-slate-500">좌표 정보가 등록된 단지가 없습니다.</p>
            </div>
        </c:if>

        <div id="map"></div>
    </section>

    <div class="apt-detail-modal" id="aptDetailModal" aria-hidden="true">
        <div class="apt-detail-modal-backdrop" id="aptDetailModalBackdrop"></div>

        <div class="apt-detail-modal-dialog">
            <div class="apt-detail-modal-header">
                <div>
                    <h3 class="apt-detail-modal-title" id="aptDetailModalTitle">아파트 상세정보</h3>
                    <p class="apt-detail-modal-address" id="aptDetailModalAddress">-</p>
                </div>

                <button type="button"
                        class="apt-detail-modal-close"
                        id="aptDetailModalClose"
                        aria-label="상세 모달 닫기">
                    ×
                </button>
            </div>

            <div class="apt-detail-modal-body" id="aptDetailModalBody">
                상세 정보를 불러오는 중입니다.
            </div>
        </div>
    </div>
</main>

<div class="ml-80">
    <%@ include file="/WEB-INF/views/include/main_footerLayout.jsp" %>
</div>

<!-- 카카오 지도 SDK -->
<script type="text/javascript"
        src="//your_KEY"></script>

<script>
    const CONTEXT_PATH = '${pageContext.request.contextPath}';

    /*
     * Controller에서 model.addAttribute("aptList", aptList)로 넘긴 데이터
     */
    const aptList = [
        <c:forEach var="apt" items="${aptList}" varStatus="status">
        {
            aptCmplexNo: "${apt.aptCmplexNo}",
            aptCmplexNm: "${fn:escapeXml(apt.aptCmplexNm)}",
            sidoNm: "${fn:escapeXml(apt.sidoNm)}",
            sigunguNm: "${fn:escapeXml(apt.sigunguNm)}",
            dorojuso: "${fn:escapeXml(apt.dorojuso)}",
            latVal: ${empty apt.latVal ? "null" : apt.latVal},
            lonVal: ${empty apt.lonVal ? "null" : apt.lonVal},
            unitCnt: ${empty apt.unitCnt ? 0 : apt.unitCnt},
            dongCnt: ${empty apt.dongCnt ? 0 : apt.dongCnt}
        }<c:if test="${!status.last}">,</c:if>
        </c:forEach>
    ];

    /*
     * aptCmplexNo 기준 매물 요약 Map
     * 예:
     * rentSummaryMap["A10023118"] = {
     *   count: 2,
     *   jsCount: 1,
     *   peCount: 1,
     *   jsMinDpstAmt: 120000000,
     *   peMinDpstAmt: 10000000,
     *   peMinMonthlyRentAmt: 480000,
     *   list: [...]
     * }
     */
    let rentSummaryMap = {};

    let centerLat = 36.3504;
    let centerLng = 127.3845;

    const firstApt = aptList.find(function (apt) {
        return apt.latVal !== null && apt.lonVal !== null;
    });

    if (firstApt) {
        centerLat = Number(firstApt.latVal);
        centerLng = Number(firstApt.lonVal);
    }

    const mapContainer = document.getElementById("map");

    const mapOption = {
        center: new kakao.maps.LatLng(centerLat, centerLng),
        level: 8
    };

    const map = new kakao.maps.Map(mapContainer, mapOption);

    const zoomControl = new kakao.maps.ZoomControl();
    map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);

    const mapTypeControl = new kakao.maps.MapTypeControl();
    map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);

    const bounds = new kakao.maps.LatLngBounds();

    let openedInfoWindow = null;

    /*
     * 1. 매물 데이터 먼저 조회
     * 2. aptList와 aptCmplexNo 기준으로 매칭
     * 3. 매물이 있으면 빨간 마커, 없으면 파란 마커
     */
    loadRentSummaryAndDrawMarkers();

    function loadRentSummaryAndDrawMarkers() {
        fetch(CONTEXT_PATH + "/rent/list-data")
            .then(function (response) {
                if (!response.ok) {
                    throw new Error("매물 목록 조회 실패");
                }

                return response.json();
            })
            .then(function (data) {
                if (data.success) {
                    rentSummaryMap = buildRentSummaryMap(data.list || []);
                } else {
                    console.warn(data.message || "매물 목록 조회 실패");
                    rentSummaryMap = {};
                }

                drawAptMarkers();
            })
            .catch(function (error) {
                console.error("매물 목록 조회 오류:", error);

                /*
                 * 매물 API가 실패해도 아파트 지도는 정상 표시
                 */
                rentSummaryMap = {};
                drawAptMarkers();
            });
    }

    function buildRentSummaryMap(rentList) {
        const map = {};

        rentList.forEach(function (rent) {
            const aptCmplexNo = rent.aptCmplexNo;

            if (!aptCmplexNo) {
                return;
            }

            if (!map[aptCmplexNo]) {
                map[aptCmplexNo] = {
                    count: 0,
                    jsCount: 0,
                    peCount: 0,
                    jsMinDpstAmt: null,
                    peMinDpstAmt: null,
                    peMinMonthlyRentAmt: null,
                    list: []
                };
            }

            const summary = map[aptCmplexNo];

            summary.count++;
            summary.list.push(rent);

            /*
             * JS : 전세임대
             * PE : 영구임대(월세)
             */
            if (rent.rentTypeCd === "JS") {
                summary.jsCount++;

                const dpstAmt = Number(rent.dpstAmt || 0);

                if (summary.jsMinDpstAmt === null || dpstAmt < summary.jsMinDpstAmt) {
                    summary.jsMinDpstAmt = dpstAmt;
                }
            }

            if (rent.rentTypeCd === "PE") {
                summary.peCount++;

                const dpstAmt = Number(rent.dpstAmt || 0);
                const monthlyRentAmt = Number(rent.mthlyRentAmt || 0);

                if (summary.peMinDpstAmt === null || dpstAmt < summary.peMinDpstAmt) {
                    summary.peMinDpstAmt = dpstAmt;
                }

                if (summary.peMinMonthlyRentAmt === null || monthlyRentAmt < summary.peMinMonthlyRentAmt) {
                    summary.peMinMonthlyRentAmt = monthlyRentAmt;
                }
            }
        });

        return map;
    }

    function drawAptMarkers() {
        aptList.forEach(function (apt) {
            const lat = Number(apt.latVal);
            const lng = Number(apt.lonVal);

            if (!lat || !lng) {
                return;
            }

            const position = new kakao.maps.LatLng(lat, lng);
            const rentSummary = rentSummaryMap[apt.aptCmplexNo];
            const hasRent = !!rentSummary && rentSummary.count > 0;

            const marker = new kakao.maps.Marker({
                map: map,
                position: position,
                title: apt.aptCmplexNm,
                image: hasRent ? createMarkerImage("#dc2626") : createMarkerImage("#1e88ff")
            });

            bounds.extend(position);

            const rentUrl = CONTEXT_PATH + "/rent/map?aptCmplexNo=" + encodeURIComponent(apt.aptCmplexNo);

            const rentButtonHtml = hasRent
                ? '    <a class="map-info-rent-link" href="' + rentUrl + '">매물보기</a>'
                : '';

            const content =
                '<div class="map-info-window">' +
                '  <span class="map-info-title">' + escapeHtml(apt.aptCmplexNm) + '</span>' +
                '  <span class="map-info-address">' + escapeHtml(apt.dorojuso) + '</span>' +
                '  <span class="map-info-meta">' + escapeHtml(apt.unitCnt) + '세대 / ' + escapeHtml(apt.dongCnt) + '동</span>' +
                makeRentInfoHtml(rentSummary) +
                '  <div class="map-info-btn-row">' +
                '    <button type="button" class="map-info-link" onclick="openAptDetailModal(\'' + escapeJs(apt.aptCmplexNo) + '\')">상세보기</button>' +
                rentButtonHtml +
                '  </div>' +
                '</div>';

            const infowindow = new kakao.maps.InfoWindow({
                content: content,
                removable: true
            });

            kakao.maps.event.addListener(marker, "click", function () {
                if (openedInfoWindow) {
                    openedInfoWindow.close();
                }

                infowindow.open(map, marker);
                openedInfoWindow = infowindow;
            });
        });

        if (aptList.length > 1 && firstApt) {
            map.setBounds(bounds);
        }
    }

    /*
     * 빨간/파란 마커 이미지 생성
     */
    function createMarkerImage(color) {
        const svg =
            '<svg width="36" height="48" viewBox="0 0 36 48" xmlns="http://www.w3.org/2000/svg">' +
            '  <path d="M18 46C18 46 33 28.8 33 16.5C33 7.94 26.28 1 18 1C9.72 1 3 7.94 3 16.5C3 28.8 18 46 18 46Z" fill="' + color + '" stroke="white" stroke-width="1"/>' +
            '  <circle cx="18" cy="16.5" r="6.5" fill="white"/>' +
            '</svg>';

        const imageSrc = "data:image/svg+xml;charset=UTF-8," + encodeURIComponent(svg);
        const imageSize = new kakao.maps.Size(28, 38);
        const imageOption = {
            offset: new kakao.maps.Point(14, 38)
        };

        return new kakao.maps.MarkerImage(imageSrc, imageSize, imageOption);
    }

    function makeRentInfoHtml(summary) {
        if (!summary || summary.count === 0) {
            return '<span class="map-info-rent-empty">등록된 매물 없음</span>';
        }

        let html = '';

        html += '<div class="map-info-rent-box">';
        html += '  <span class="map-info-rent-title">등록 매물 ' + summary.count + '건</span>';

        if (summary.jsCount > 0) {
            html += '  <span class="map-info-rent-line">전세임대 ' + summary.jsCount + '건';
            if (summary.jsMinDpstAmt !== null) {
                html += ' · 전세 ' + formatMoney(summary.jsMinDpstAmt) + '부터';
            }
            html += '</span>';
        }

        if (summary.peCount > 0) {
            html += '  <span class="map-info-rent-line">영구임대(월세) ' + summary.peCount + '건';

            if (summary.peMinDpstAmt !== null || summary.peMinMonthlyRentAmt !== null) {
                html += ' · 보증금 ' + formatMoney(summary.peMinDpstAmt) +
                    ' / 월 ' + formatMoney(summary.peMinMonthlyRentAmt) + '부터';
            }

            html += '</span>';
        }

        html += '</div>';

        return html;
    }

    function formatMoney(value) {
        if (value === null || value === undefined || value === "") {
            return "-";
        }

        const num = Number(value);

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

    function escapeJs(value) {
        if (value === null || value === undefined) {
            return "";
        }

        return String(value)
            .replaceAll("\\", "\\\\")
            .replaceAll("'", "\\'")
            .replaceAll('"', '\\"');
    }

    function openAptDetailModal(aptCmplexNo) {
        const apt = aptList.find(function (item) {
            return String(item.aptCmplexNo) === String(aptCmplexNo);
        });

        if (!apt) {
            alert("아파트 정보를 찾을 수 없습니다.");
            return;
        }

        const modal = document.getElementById("aptDetailModal");
        const titleEl = document.getElementById("aptDetailModalTitle");
        const addressEl = document.getElementById("aptDetailModalAddress");
        const bodyEl = document.getElementById("aptDetailModalBody");

        const rentSummary = rentSummaryMap[apt.aptCmplexNo];

        titleEl.textContent = apt.aptCmplexNm || "아파트 상세정보";
        addressEl.textContent = apt.dorojuso || "-";

        bodyEl.innerHTML = makeAptDetailModalHtml(apt, rentSummary);

        modal.classList.add("show");
        modal.setAttribute("aria-hidden", "false");
        document.body.classList.add("apt-detail-modal-open");
    }

    function closeAptDetailModal() {
        const modal = document.getElementById("aptDetailModal");

        if (!modal) {
            return;
        }

        modal.classList.remove("show");
        modal.setAttribute("aria-hidden", "true");
        document.body.classList.remove("apt-detail-modal-open");
    }

    function makeAptDetailModalHtml(apt, rentSummary) {
        const detailPageUrl = CONTEXT_PATH + "/main/apt/detail.do?aptCmplexNo=" + encodeURIComponent(apt.aptCmplexNo);
        const rentUrl = CONTEXT_PATH + "/rent/map?aptCmplexNo=" + encodeURIComponent(apt.aptCmplexNo);

        const rentCount = rentSummary ? rentSummary.count : 0;

        let html = "";

        html += '<div class="apt-detail-summary">';
        html += '  <div class="apt-detail-summary-item">';
        html += '    <span class="apt-detail-summary-label">세대수</span>';
        html += '    <span class="apt-detail-summary-value">' + escapeHtml(apt.unitCnt || 0) + '</span>';
        html += '  </div>';
        html += '  <div class="apt-detail-summary-item">';
        html += '    <span class="apt-detail-summary-label">동수</span>';
        html += '    <span class="apt-detail-summary-value">' + escapeHtml(apt.dongCnt || 0) + '</span>';
        html += '  </div>';
        html += '  <div class="apt-detail-summary-item">';
        html += '    <span class="apt-detail-summary-label">등록 매물</span>';
        html += '    <span class="apt-detail-summary-value">' + escapeHtml(rentCount) + '건</span>';
        html += '  </div>';
        html += '</div>';

        html += '<table class="apt-detail-info-table">';
        html += '  <tbody>';
        html += '    <tr>';
        html += '      <th>단지명</th>';
        html += '      <td>' + escapeHtml(apt.aptCmplexNm || "-") + '</td>';
        html += '    </tr>';
        html += '    <tr>';
        html += '      <th>주소</th>';
        html += '      <td>' + escapeHtml(apt.dorojuso || "-") + '</td>';
        html += '    </tr>';
        html += '    <tr>';
        html += '      <th>지역</th>';
        html += '      <td>' + escapeHtml((apt.sidoNm || "") + " " + (apt.sigunguNm || "")) + '</td>';
        html += '    </tr>';
        html += '    <tr>';
        html += '      <th>단지 규모</th>';
        html += '      <td>' + escapeHtml(apt.unitCnt || 0) + '세대 / ' + escapeHtml(apt.dongCnt || 0) + '동</td>';
        html += '    </tr>';

        if (rentSummary && rentSummary.count > 0) {
            html += '    <tr>';
            html += '      <th>매물 정보</th>';
            html += '      <td>' + makeRentSummaryText(rentSummary) + '</td>';
            html += '    </tr>';
        }

        html += '  </tbody>';
        html += '</table>';

        html += '<div class="apt-detail-btn-row">';
        html += '  <a class="apt-detail-link-btn" href="' + detailPageUrl + '">상세 페이지 이동</a>';

        if (rentSummary && rentSummary.count > 0) {
            html += '  <a class="apt-detail-link-btn" href="' + rentUrl + '">매물보기</a>';
        }

        html += '</div>';

        return html;
    }

    function makeRentSummaryText(summary) {
        if (!summary || summary.count === 0) {
            return "등록된 매물 없음";
        }

        let lines = [];

        lines.push("등록 매물 " + summary.count + "건");

        if (summary.jsCount > 0) {
            let text = "전세임대 " + summary.jsCount + "건";

            if (summary.jsMinDpstAmt !== null) {
                text += " · 전세 " + formatMoney(summary.jsMinDpstAmt) + "부터";
            }

            lines.push(text);
        }

        if (summary.peCount > 0) {
            let text = "영구임대(월세) " + summary.peCount + "건";

            if (summary.peMinDpstAmt !== null || summary.peMinMonthlyRentAmt !== null) {
                text += " · 보증금 " + formatMoney(summary.peMinDpstAmt);
                text += " / 월 " + formatMoney(summary.peMinMonthlyRentAmt) + "부터";
            }

            lines.push(text);
        }

        return lines.map(function (line) {
            return '<div>' + escapeHtml(line) + '</div>';
        }).join("");
    }

    document.addEventListener("DOMContentLoaded", function () {
        const closeBtn = document.getElementById("aptDetailModalClose");
        const backdrop = document.getElementById("aptDetailModalBackdrop");

        if (closeBtn) {
            closeBtn.addEventListener("click", closeAptDetailModal);
        }

        if (backdrop) {
            backdrop.addEventListener("click", closeAptDetailModal);
        }

        document.addEventListener("keydown", function (e) {
            const modal = document.getElementById("aptDetailModal");

            if (e.key === "Escape" && modal && modal.classList.contains("show")) {
                closeAptDetailModal();
            }
        });
    });
</script>

</body>
</html>
