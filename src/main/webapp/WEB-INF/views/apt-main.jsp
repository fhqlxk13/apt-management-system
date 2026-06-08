<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/headerStyle.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footerStyle.css">

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>대덕아파트 – 메인</title>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;600;700&family=Noto+Serif+KR:wght@400;600;700&display=swap"
          rel="stylesheet">
    <style>
        /* ═══════════════════════════════════════
           RESET & ROOT
        ═══════════════════════════════════════ */
        *, *::before, *::after {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        :root {
            --green-dark: #2d5a3d;
            --green-mid: #3d7a52;
            --green-accent: #4a9060;
            --green-light: #e8f2ec;
            --green-pale: #f4f9f6;
            --text-dark: #1a1a1a;
            --text-mid: #444;
            --text-light: #777;
            --border: #dde8e2;
            --white: #ffffff;
            --bg: #f8faf9;
        }

        html {
            scroll-behavior: smooth;
        }

        body {
            font-family: 'Noto Sans KR', sans-serif;
            background: var(--white);
            color: var(--text-dark);
        }

        a {
            text-decoration: none;
            color: inherit;
        }

        img {
            display: block;
            width: 100%;
        }


        /* ═══════════════════════════════════════
           HERO SLIDER
        ═══════════════════════════════════════ */
        .hero {
            position: relative;
            height: 520px;
            overflow: hidden;
        }

        .hero-slides {
            display: flex;
            height: 100%;
            transition: transform .7s cubic-bezier(.4, 0, .2, 1);
        }

        .hero-slide {
            min-width: 100%;
            height: 100%;
            position: relative;
            flex-shrink: 0;
        }

        .hero-slide-bg {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transform: scale(1.06);
            transition: transform 6s ease;
        }

        .hero-slide.active .hero-slide-bg {
            transform: scale(1);
        }

        .hero-overlay {
            position: absolute;
            inset: 0;
            background: linear-gradient(to bottom, rgba(0, 0, 0, .15) 0%, rgba(0, 0, 0, .45) 100%);
        }

        .hero-content {
            position: absolute;
            inset: 0;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            text-align: center;
            padding: 0 20px;
            opacity: 0;
            transform: translateY(18px);
            transition: opacity .6s .3s, transform .6s .3s;
        }

        .hero-slide.active .hero-content {
            opacity: 1;
            transform: translateY(0);
        }

        .hero-content h1 {
            font-family: 'Noto Serif KR', serif;
            font-size: clamp(32px, 5vw, 54px);
            font-weight: 700;
            color: var(--white);
            letter-spacing: -.5px;
            line-height: 1.15;
            text-shadow: 0 2px 16px rgba(0, 0, 0, .3);
        }

        .hero-content h1 em {
            color: #a8d5b5;
            font-style: normal;
        }

        .hero-content p {
            margin-top: 16px;
            font-size: 15px;
            color: rgba(255, 255, 255, .88);
            line-height: 1.8;
            letter-spacing: -.2px;
            text-shadow: 0 1px 6px rgba(0, 0, 0, .3);
        }

        /* 슬라이더 컨트롤 */
        .hero-dots {
            position: absolute;
            bottom: 22px;
            left: 50%;
            transform: translateX(-50%);
            display: flex;
            gape: 8px;
            z-index: 10;
        }

        .hero-dot {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background: rgba(255, 255, 255, .45);
            border: none;
            cursor: pointer;
            transition: all .2s;
        }

        .hero-dot.active {
            background: var(--white);
            width: 24px;
            border-radius: 4px;
        }

        .hero-arrow {
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: rgba(255, 255, 255, .18);
            border: 1.5px solid rgba(255, 255, 255, .4);
            color: var(--white);
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            z-index: 10;
            backdrop-filter: blur(4px);
            transition: background .2s, border-color .2s;
        }

        .hero-arrow:hover {
            background: rgba(255, 255, 255, .32);
            border-color: rgba(255, 255, 255, .7);
        }

        .hero-arrow.prev {
            left: 24px;
        }

        .hero-arrow.next {
            right: 24px;
        }

        .hero-arrow svg {
            width: 18px;
            height: 18px;
        }

        /* ═══════════════════════════════════════
           퀵메뉴 바
        ═══════════════════════════════════════ */
        .quick-bar {
            display: flex;
            align-items: stretch;
            max-width: 1100px;
            margin: -52px auto 0;
            position: relative;
            z-index: 100;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 8px 32px rgba(0, 0, 0, .14);
        }

        .quick-consult {
            background: var(--green-dark);
            color: var(--white);
            padding: 28px 32px;
            min-width: 220px;
            flex-shrink: 0;
            display: flex;
            flex-direction: column;
            gap: 6px;
        }

        .quick-consult .label {
            font-size: 12px;
            opacity: .75;
            letter-spacing: .5px;
        }

        .quick-consult .phone {
            font-size: 28px;
            font-weight: 700;
            letter-spacing: -.5px;
        }

        .quick-consult .address {
            font-size: 11.5px;
            opacity: .7;
            line-height: 1.6;
            margin-top: 2px;
        }

        .quick-consult-btn {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            margin-top: 10px;
            padding: 8px 14px;
            border: 1.5px solid rgba(255, 255, 255, .5);
            border-radius: 4px;
            font-size: 12.5px;
            color: var(--white);
            cursor: pointer;
            transition: background .18s;
            background: transparent;
            font-family: 'Noto Sans KR', sans-serif;
            width: fit-content;
        }

        .quick-consult-btn:hover {
            background: rgba(255, 255, 255, .15);
        }

        .quick-consult-btn svg {
            width: 13px;
            height: 13px;
        }

        .quick-menus {
            flex: 1;
            background: var(--white);
            display: grid;
            grid-template-columns:repeat(4, 1fr);
        }

        .quick-menu-item {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            gap: 10px;
            padding: 28px 16px;
            border-left: 1px solid var(--border);
            cursor: pointer;
            transition: background .18s;
            text-decoration: none;
        }

        .quick-menu-item:hover {
            background: var(--green-pale);
        }

        .quick-menu-item:hover .qm-icon {
            color: var(--green-dark);
        }

        .qm-icon {
            width: 38px;
            height: 38px;
            color: var(--text-mid);
            transition: color .18s;
        }

        .qm-label {
            font-size: 13.5px;
            font-weight: 600;
            color: var(--text-dark);
            letter-spacing: -.3px;
        }

        .qm-sub {
            font-size: 10.5px;
            color: var(--text-light);
            letter-spacing: .5px;
            margin-top: -6px;
        }

        /* ═══════════════════════════════════════
           섹션 공통
        ═══════════════════════════════════════ */
        .section-wrap {
            max-width: 1100px;
            margin: 0 auto;
            padding: 72px 24px;
        }

        .section-badge {
            display: inline-block;
            font-size: 11.5px;
            font-weight: 600;
            letter-spacing: 1.5px;
            color: var(--green-accent);
            text-transform: uppercase;
            margin-bottom: 10px;
        }

        .section-title {
            font-family: 'Noto Serif KR', serif;
            font-size: clamp(22px, 3vw, 32px);
            font-weight: 700;
            color: var(--text-dark);
            letter-spacing: -.5px;
            line-height: 1.3;
        }

        .section-title em {
            color: var(--green-dark);
            font-style: normal;
        }

        .section-desc {
            font-size: 14px;
            color: var(--text-light);
            line-height: 1.9;
            margin-top: 10px;
        }

        .section-divider {
            display: flex;
            align-items: center;
            gap: 12px;
            margin: 6px 0 32px;
        }

        .section-divider .label {
            font-size: 11px;
            font-weight: 600;
            letter-spacing: 2px;
            color: var(--green-accent);
            text-transform: uppercase;
            white-space: nowrap;
        }

        .section-divider::after {
            content: '';
            flex: 1;
            height: 1px;
            background: var(--border);
        }

        /* ═══════════════════════════════════════
           프리미엄 라이프 (슬라이드 + 카드)
        ═══════════════════════════════════════ */
        .premium-grid {
            display: grid;
            grid-template-columns:1.6fr 1fr;
            gap: 20px;
            margin-top: 8px;
        }

        .premium-main {
            position: relative;
            border-radius: 10px;
            overflow: hidden;
            height: 420px;
            cursor: pointer;
        }

        .premium-main img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform .5s;
        }

        .premium-main:hover img {
            transform: scale(1.04);
        }

        .premium-main-overlay {
            position: absolute;
            inset: 0;
            background: linear-gradient(to top, rgba(0, 0, 0, .65) 0%, transparent 60%);
        }

        .premium-main-info {
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            padding: 28px;
        }

        .premium-tag {
            display: inline-block;
            font-size: 10px;
            font-weight: 700;
            letter-spacing: 1px;
            color: var(--white);
            background: var(--green-dark);
            padding: 3px 9px;
            border-radius: 3px;
            margin-bottom: 10px;
            text-transform: uppercase;
        }

        .premium-main-info h3 {
            font-family: 'Noto Serif KR', serif;
            font-size: 22px;
            font-weight: 700;
            color: var(--white);
            letter-spacing: -.3px;
            line-height: 1.35;
        }

        .premium-main-info p {
            font-size: 13px;
            color: rgba(255, 255, 255, .8);
            margin-top: 6px;
        }

        /* 슬라이드 도트 */
        .premium-dots {
            display: flex;
            gap: 6px;
            margin-top: 14px;
        }

        .premium-dot {
            width: 6px;
            height: 6px;
            border-radius: 50%;
            background: rgba(255, 255, 255, .4);
            cursor: pointer;
            transition: all .2s;
        }

        .premium-dot.active {
            background: var(--white);
            width: 18px;
            border-radius: 3px;
        }

        .premium-sub {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .premium-card {
            position: relative;
            border-radius: 10px;
            overflow: hidden;
            height: 196px;
            cursor: pointer;
            flex: 1;
        }

        .premium-card img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform .5s;
        }

        .premium-card:hover img {
            transform: scale(1.05);
        }

        .premium-card-overlay {
            position: absolute;
            inset: 0;
            background: linear-gradient(to top, rgba(0, 0, 0, .6) 0%, transparent 55%);
        }

        .premium-card-info {
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            padding: 18px 20px;
        }

        .premium-card-info h4 {
            font-size: 15px;
            font-weight: 600;
            color: var(--white);
            letter-spacing: -.3px;
            line-height: 1.3;
        }

        .premium-card-info p {
            font-size: 12px;
            color: rgba(255, 255, 255, .75);
            margin-top: 4px;
        }

        /* ═══════════════════════════════════════
           최신 뉴스
        ═══════════════════════════════════════ */
        .news-section {
            background: var(--green-pale);
        }

        .news-inner {
            max-width: 1100px;
            margin: 0 auto;
            padding: 64px 24px;
        }

        .news-header {
            display: flex;
            align-items: flex-end;
            justify-content: space-between;
            margin-bottom: 28px;
        }

        .more-btn {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            font-size: 12.5px;
            font-weight: 600;
            color: var(--white);
            background: var(--green-dark);
            border: none;
            border-radius: 4px;
            padding: 8px 16px;
            cursor: pointer;
            font-family: 'Noto Sans KR', sans-serif;
            transition: background .18s;
            text-decoration: none;
        }

        .more-btn:hover {
            background: var(--green-mid);
        }

        .more-btn svg {
            width: 13px;
            height: 13px;
        }

        .news-grid {
            display: grid;
            grid-template-columns:repeat(3, 1fr);
            gap: 18px;
        }

        .news-card {
            background: var(--white);
            border-radius: 8px;
            border: 1px solid var(--border);
            padding: 22px;
            display: flex;
            flex-direction: column;
            gap: 10px;
            transition: box-shadow .2s, transform .2s;
        }

        .news-card:hover {
            box-shadow: 0 6px 24px rgba(45, 90, 61, .10);
            transform: translateY(-2px);
        }

        .news-card-tag {
            font-size: 10.5px;
            font-weight: 700;
            color: var(--green-accent);
            letter-spacing: 1px;
            text-transform: uppercase;
        }

        .news-card {
            height: 210px;
        }

        .news-card h4 {
            font-size: 15px;
            font-weight: 600;
            color: var(--text-dark);
            letter-spacing: -.3px;
            line-height: 1.5;
        }

        .news-card p {
            font-size: 13px;
            color: var(--text-light);
            line-height: 1.8;
            flex: 1;

            /* 여기에 말줄임 스타일 추가 */
            display: -webkit-box;
            -webkit-box-orient: vertical;
            -webkit-line-clamp: 3; /* 3줄까지 보여주고 넘치면 ... 처리 */
            overflow: hidden; /* 영역 넘치는 텍스트 숨기기 */

            /* line-height(1.8) * 3줄 = 5.4em 으로 높이를 고정해서 글자 수가 적어도 높이 유지 */
            height: 5.4em;
        }

        .news-card-date {
            font-size: 11.5px;
            color: var(--text-light);
            letter-spacing: .3px;
            padding-top: 10px;
            border-top: 1px solid var(--border);
        }

        /* ═══════════════════════════════════════
           안내 배너 (초록 배경)
        ═══════════════════════════════════════ */
        .banner-section {
            background: var(--green-dark);
            padding: 56px 24px;
        }

        .banner-inner {
            max-width: 1100px;
            margin: 0 auto;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 24px;
            flex-wrap: wrap;
        }

        .banner-text h2 {
            font-family: 'Noto Serif KR', serif;
            font-size: clamp(20px, 2.5vw, 28px);
            font-weight: 700;
            color: var(--white);
            letter-spacing: -.3px;
            line-height: 1.4;
        }

        .banner-text p {
            font-size: 14px;
            color: rgba(255, 255, 255, .72);
            margin-top: 8px;
            line-height: 1.8;
        }

        .banner-btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 13px 28px;
            border: 2px solid rgba(255, 255, 255, .6);
            border-radius: 5px;
            color: var(--white);
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            white-space: nowrap;
            transition: background .2s, border-color .2s;
            background: transparent;
            font-family: 'Noto Sans KR', sans-serif;
            flex-shrink: 0;
        }

        .banner-btn:hover {
            background: rgba(255, 255, 255, .15);
            border-color: var(--white);
        }

        .banner-btn svg {
            width: 16px;
            height: 16px;
        }


        /* ═══════════════════════════════════════
           애니메이션
        ═══════════════════════════════════════ */
        @keyframes fadeUp {
            from {
                opacity: 0;
                transform: translateY(24px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .fade-up {
            animation: fadeUp .6s ease both;
        }

        .delay-1 {
            animation-delay: .1s;
        }

        .delay-2 {
            animation-delay: .2s;
        }

        .delay-3 {
            animation-delay: .3s;
        }

        .delay-4 {
            animation-delay: .4s;
        }

        /* ═══════════════════════════════════════
           아파트 위치 지도 모달
        ═══════════════════════════════════════ */
        .apt-map-modal {
            position: fixed;
            inset: 0;
            z-index: 9999;
            display: none;
        }

        .apt-map-modal.show {
            display: block;
        }

        .apt-map-backdrop {
            position: absolute;
            inset: 0;
            background: rgba(0, 0, 0, .52);
            backdrop-filter: blur(3px);
        }

        .apt-map-dialog {
            position: absolute;
            top: 50%;
            left: 50%;
            width: min(920px, calc(100% - 32px));
            max-height: calc(100vh - 60px);
            transform: translate(-50%, -50%);
            background: var(--white);
            border-radius: 18px;
            overflow: hidden;
            box-shadow: 0 24px 70px rgba(0, 0, 0, .28);
        }

        .apt-map-header {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            gap: 18px;
            padding: 22px 24px 18px;
            border-bottom: 1px solid var(--border);
            background: var(--green-pale);
        }

        .apt-map-header h3 {
            margin: 0;
            font-size: 22px;
            font-weight: 800;
            color: var(--green-dark);
            letter-spacing: -.5px;
        }

        .apt-map-header p {
            margin: 8px 0 0;
            font-size: 14px;
            color: var(--text-mid);
            line-height: 1.6;
        }

        .apt-map-close {
            width: 38px;
            height: 38px;
            border: 0;
            border-radius: 50%;
            background: var(--white);
            color: var(--text-dark);
            font-size: 30px;
            line-height: 1;
            cursor: pointer;
            box-shadow: 0 4px 14px rgba(0, 0, 0, .08);
        }

        .apt-map-close:hover {
            background: var(--green-light);
            color: var(--green-dark);
        }

        .apt-map-body {
            padding: 22px 24px 24px;
        }

        .apt-map-box {
            width: 100%;
            height: 460px;
            border-radius: 14px;
            border: 1px solid var(--border);
            overflow: hidden;
            background: #f2f4f3;
        }

        .apt-map-info {
            display: flex;
            flex-direction: column;
            gap: 4px;
            margin-top: 14px;
            padding: 16px 18px;
            border-radius: 12px;
            background: var(--green-pale);
            border: 1px solid var(--border);
        }

        .apt-map-info strong {
            font-size: 16px;
            color: var(--green-dark);
        }

        .apt-map-info span {
            font-size: 13px;
            color: var(--text-mid);
            line-height: 1.6;
        }

        body.map-modal-open {
            overflow: hidden;
        }

        @media (max-width: 640px) {
            .apt-map-dialog {
                width: calc(100% - 20px);
            }

            .apt-map-header {
                padding: 18px;
            }

            .apt-map-body {
                padding: 16px;
            }

            .apt-map-box {
                height: 360px;
            }
        }

    </style>
</head>
<body>
<%@ include file="/WEB-INF/views/include/apt_headerLayout.jsp" %>

<main class="ml-80 pt-20 min-h-screen bg-background p-8">
    <%-- ══════════════ HERO SLIDER ══════════════ --%>
    <section class="hero" id="hero">
        <div class="hero-slides" id="heroSlides">

            <div class="hero-slide active">
                <img class="hero-slide-bg"
                     src="https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=1400&auto=format&fit=crop"
                     alt="대덕아파트 전경">
                <div class="hero-overlay"></div>
                <div class="hero-content">
                    <h1>자연을 품은<br><em>프리미엄 주거공간</em></h1>
                    <p>단순한 집이 아닌<br>삶의 가치를 높일 수 있는 아파트가 되겠습니다.</p>
                </div>
            </div>

            <div class="hero-slide">
                <img class="hero-slide-bg"
                     src="https://images.unsplash.com/photo-1486325212027-8081e485255e?w=1400&auto=format&fit=crop"
                     alt="단지 전경">
                <div class="hero-overlay"></div>
                <div class="hero-content">
                    <h1>도심 속에서<br><em>자연을 누리다</em></h1>
                    <p>쾌적한 환경과 풍요로운 생활<br>아파트가 함께합니다.</p>
                </div>
            </div>

            <div class="hero-slide">
                <img class="hero-slide-bg"
                     src="https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=1400&auto=format&fit=crop"
                     alt="인테리어">
                <div class="hero-overlay"></div>
                <div class="hero-content">
                    <h1>편안함과<br><em>품격 있는 일상</em></h1>
                    <p>세심하게 설계된 공간에서<br>매일이 특별한 하루가 됩니다.</p>
                </div>
            </div>

        </div>

        <button class="hero-arrow prev" id="heroPrev" aria-label="이전">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round">
                <path d="M15 18l-6-6 6-6"/>
            </svg>
        </button>
        <button class="hero-arrow next" id="heroNext" aria-label="다음">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round">
                <path d="M9 18l6-6-6-6"/>
            </svg>
        </button>
        <div class="hero-dots" id="heroDots">
            <button class="hero-dot active"></button>
            <button class="hero-dot"></button>
            <button class="hero-dot"></button>
        </div>
    </section>

    <%-- headerLayout.jsp에 아래 선언 --%>
    <%--<c:set var="apt" value="${aptInfo.aptComplexInfo}" />
    <c:set var="office" value="${aptInfo.mgmtOfficeInfo}" />
    <c:set var="board" value="${aptInfo.annBoardPostInfoList}" />--%>

    <%-- ══════════════ 상담 + 퀵메뉴 ══════════════ --%>
    <div class="quick-bar fade-up">
        <div class="quick-consult">
            <c:choose>
                <c:when test="${not empty mgmtOffice}">
                    <div class="quick-consult">
                        <span class="label">${apt.aptCmplexNm} 관리사무소</span>
                        <c:set var="telNo" value="${fn:replace(mgmtOffice.mgmtOfcTelno, '-', '')}"/>
                        <c:set var="telNo" value="${fn:replace(mgmtOffice.mgmtOfcTelno, ' ', '')}"/>
                        <c:set var="telLength" value="${fn:length(telNo)}"/>
                            <%-- 전화번호 '-' 처리 방법! 앞자리가 02일때와 아닐때로 나눔. 작성자 : 이윤진 --%>
                        <span class="phone">
              <c:choose>
                  <%-- case1) 서울 02 + 가운데 3자리 + 뒤 4자리 : 02-375-0332 --%>
                  <c:when test="${fn:startsWith(telNo, '02') and telLength == 9}">
                      ${fn:substring(telNo, 0, 2)}-${fn:substring(telNo, 2, 5)}-${fn:substring(telNo, 5, 9)}
                  </c:when>
                  <%-- case2) 서울 02 + 가운데 4자리 + 뒤 4자리 : 02-1234-5678 --%>
                  <c:when test="${fn:startsWith(telNo, '02') and telLength == 10}">
                      ${fn:substring(telNo, 0, 2)}-${fn:substring(telNo, 2, 6)}-${fn:substring(telNo, 6, 10)}
                  </c:when>
                  <%-- case3) 서울 제외 지역번호/휴대폰 3자리 + 가운데 3자리 + 뒤 4자리 : 031-123-4567 --%>
                  <c:when test="${not fn:startsWith(telNo, '02') and telLength == 10}">
                      ${fn:substring(telNo, 0, 3)}-${fn:substring(telNo, 3, 6)}-${fn:substring(telNo, 6, 10)}
                  </c:when>
                  <%-- case4) 서울 제외 지역번호/휴대폰 3자리 + 가운데 4자리 + 뒤 4자리 : 010-1234-5678 --%>
                  <c:when test="${not fn:startsWith(telNo, '02') and telLength == 11}">
                      ${fn:substring(telNo, 0, 3)}-${fn:substring(telNo, 3, 7)}-${fn:substring(telNo, 7, 11)}
                  </c:when>
                  <%-- 전화번호 양식에 하나도 안맞을때는 값 그대로 출력 --%>
                  <c:otherwise>
                      ${mgmtOffice.mgmtOfcTelno}
                  </c:otherwise>
              </c:choose>
              </span>
                        <span class="address">
                 ${apt.dorojuso}<br>
                                ${mgmtOffice.mgmtOfcNm}<br>
                 <c:choose>
                     <c:when test="${not empty mgmtOffice.oprStTm}">
                         운영시간 : ${mgmtOffice.oprStTm} ~ ${mgmtOffice.oprEdTm}
                     </c:when>
                     <c:otherwise>
                     </c:otherwise>
                 </c:choose>
              </span>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="quick-consult">
                        <span class="label">관리사무소</span>
                        <span class="phone">정보 없음</span>
                        <span class="address">로그인 후 관리사무소 정보를 확인할 수 있습니다.</span>
                    </div>
                </c:otherwise>
            </c:choose>
            <button type="button"
                    class="quick-consult-btn"
                    id="openAptMapBtn"
                    data-address="${fn:escapeXml(apt.dorojuso)}"
                    data-apt-name="${fn:escapeXml(apt.aptCmplexNm)}">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round">
                    <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0118 0z"/>
                    <circle cx="12" cy="10" r="3"/>
                </svg>
                아파트 위치 자세히보기
            </button>
        </div>
        <div class="quick-menus">

            <!-- 공지사항 -->
            <a href="${pageContext.request.contextPath}/resident/board/notice/${aptCmplexNo}" class="quick-menu-item">
                <svg class="qm-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6"
                     stroke-linecap="round" stroke-linejoin="round">
                    <path d="M3 11v2a2 2 0 002 2h3l5 3V6l-5 3H5a2 2 0 00-2 2z"/>
                    <path d="M16 8a4 4 0 010 8"/>
                </svg>
                <span class="qm-label">공지사항</span>
            </a>

            <!-- 관리비조회 -->
            <a href="${pageContext.request.contextPath}/resident/bill/inquiry/${apt.aptCmplexNo}"
               class="quick-menu-item">
                <svg class="qm-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6"
                     stroke-linecap="round" stroke-linejoin="round">
                    <path d="M14 2H6a2 2 0 00-2 2v16a2 2 0 002 2h12a2 2 0 002-2V8z"/>
                    <polyline points="14 2 14 8 20 8"/>
                    <path d="M8 13h8M8 17h6"/>
                    <circle cx="16" cy="17" r="1"/>
                </svg>
                <span class="qm-label">관리비조회</span>
            </a>

            <!-- 입주민 게시판 -->
            <a href="${pageContext.request.contextPath}/resident/board/free/list/${aptCmplexNo}"
               class="quick-menu-item">
                <svg class="qm-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6"
                     stroke-linecap="round" stroke-linejoin="round">
                    <path d="M21 15a2 2 0 01-2 2H7l-4 4V5a2 2 0 012-2h14a2 2 0 012 2z"/>
                </svg>
                <span class="qm-label">입주민 게시판</span>
            </a>

            <!-- 시설예약 -->
            <a href="${pageContext.request.contextPath}/resident/publicFacility/reservation/${aptCmplexNo}"
               class="quick-menu-item">
                <svg class="qm-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6"
                     stroke-linecap="round" stroke-linejoin="round">
                    <rect x="3" y="4" width="18" height="18" rx="2"/>
                    <line x1="16" y1="2" x2="16" y2="6"/>
                    <line x1="8" y1="2" x2="8" y2="6"/>
                    <line x1="3" y1="10" x2="21" y2="10"/>
                </svg>
                <span class="qm-label">시설예약</span>
            </a>

        </div>
    </div>

    <div class="apt-map-modal" id="aptMapModal" aria-hidden="true">
        <div class="apt-map-backdrop" id="aptMapBackdrop"></div>

        <div class="apt-map-dialog">
            <div class="apt-map-header">
                <div>
                    <h3 id="aptMapTitle">아파트 위치</h3>
                    <p id="aptMapAddress">${apt.dorojuso}</p>
                </div>

                <button type="button" class="apt-map-close" id="closeAptMapBtn" aria-label="지도 모달 닫기">
                    ×
                </button>
            </div>

            <div class="apt-map-body">
                <div id="aptMap" class="apt-map-box"></div>

                <div class="apt-map-info">
                    <strong>${apt.aptCmplexNm}</strong>
                    <span>${apt.dorojuso}</span>
                </div>
            </div>
        </div>
    </div>

    <%-- ══════════════ 최신 뉴스 ══════════════ --%>
    <section class="news-section">
        <div class="news-inner">
            <div class="news-header">
                <div>
                    <span class="section-badge">입주민 소식</span>
                    <h2 class="section-title" style="margin-top:6px">Latest <em>News</em></h2>
                </div>
                <a href="${pageContext.request.contextPath}/resident/board/notice/${aptCmplexNo}" class="more-btn">
                    more view
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2"
                         stroke-linecap="round">
                        <path d="M5 12h14M12 5l7 7-7 7"/>
                    </svg>
                </a>
            </div>
            <div class="news-grid">
                <div class="news-card">
                    <span class="news-card-tag">공지사항</span>
                    <h4>${board[0].ttl}</h4>
                    <p>${board[0].cn}</p>
                    <div class="news-card-date">
                        <fmt:formatDate value="${board[0].regDttm}" pattern="yyyy.MM.dd"/>
                    </div>
                </div>
                <div class="news-card">
                    <span class="news-card-tag">공지사항</span>
                    <h4>${board[1].ttl}</h4>
                    <p>${board[1].cn}</p>
                    <div class="news-card-date">
                        <fmt:formatDate value="${board[1].regDttm}" pattern="yyyy.MM.dd"/>
                    </div>
                </div>
                <div class="news-card">
                    <span class="news-card-tag">공지사항</span>
                    <h4>${board[2].ttl}</h4>
                    <p>${board[2].cn}</p>
                    <div class="news-card-date">
                        <fmt:formatDate value="${board[2].regDttm}" pattern="yyyy.MM.dd"/>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <%-- ══════════════ 안내 배너 ══════════════ --%>
    <section class="banner-section">
        <div class="banner-inner">
            <div class="banner-text">
                <h2>지금 바로 입주 문의하세요.</h2>
                <p>전문 상담사가 친절하게 안내해 드립니다.<br>평일 09:00 – 18:00 운영</p>
            </div>
            <a href="/sales" class="banner-btn">
                입주 문의하기
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round">
                    <path d="M5 12h14M12 5l7 7-7 7"/>
                </svg>
            </a>
        </div>
    </section>

    <%@ include file="/WEB-INF/views/include/apt_footerLayout.jsp" %>
</main>
<script type="text/javascript"
        src="//dapi.kakao.com/v2/maps/sdk.js?appkey=46f7d3996e1205738757a1e4f1ed1f04&libraries=services"></script>
<script>
    (function () {

        /* ── 히어로 슬라이더 ── */
        let slides = document.querySelectorAll('.hero-slide');
        let dots = document.querySelectorAll('.hero-dot');
        let slidesWrap = document.getElementById('heroSlides');
        let current = 0;
        let timer;

        function goTo(idx) {
            slides[current].classList.remove('active');
            dots[current].classList.remove('active');
            current = (idx + slides.length) % slides.length;
            slides[current].classList.add('active');
            dots[current].classList.add('active');
            slidesWrap.style.transform = 'translateX(-' + current * 100 + '%)';
        }

        function startTimer() {
            clearInterval(timer);
            timer = setInterval(function () {
                goTo(current + 1);
            }, 5000);
        }

        document.getElementById('heroNext').addEventListener('click', function () {
            goTo(current + 1);
            startTimer();
        });
        document.getElementById('heroPrev').addEventListener('click', function () {
            goTo(current - 1);
            startTimer();
        });
        dots.forEach(function (dot, i) {
            dot.addEventListener('click', function () {
                goTo(i);
                startTimer();
            });
        });
        startTimer();

        /* ── 프리미엄 슬라이드 도트 ── */
        var premiumData = [
            {
                tag: 'Premium 01', title: '쾌적한 자연환경', desc: '도심속에서 누리는 자연환경',
                src: 'https://images.unsplash.com/photo-1580587771525-78b9dba3b914?w=900&auto=format&fit=crop'
            },
            {
                tag: 'Premium 02', title: '프리미엄 단지 설계', desc: '넓고 쾌적한 조경 및 단지 설계',
                src: 'https://images.unsplash.com/photo-1486325212027-8081e485255e?w=900&auto=format&fit=crop'
            },
            {
                tag: 'Premium 03', title: '스마트 홈 시스템', desc: '첨단 IoT 기반의 스마트 생활',
                src: 'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=900&auto=format&fit=crop'
            }
        ];
        var pDots = document.querySelectorAll('.premium-dot');
        var pImg = document.getElementById('premiumMainImg');
        var pTag = document.getElementById('premiumTag');
        var pTitle = document.getElementById('premiumTitle');
        var pDesc = document.getElementById('premiumDesc');
        pDots.forEach(function (dot, i) {
            dot.addEventListener('click', function () {
                pDots.forEach(function (d) {
                    d.classList.remove('active');
                });
                dot.classList.add('active');
                pImg.style.opacity = '0';
                setTimeout(function () {
                    pImg.src = premiumData[i].src;
                    pTag.textContent = premiumData[i].tag;
                    pTitle.textContent = premiumData[i].title;
                    pDesc.textContent = premiumData[i].desc;
                    pImg.style.opacity = '1';
                }, 250);
            });
        });

        /* ── 스크롤 fade-up ── */
        var fadeEls = document.querySelectorAll('.fade-up');
        var observer = new IntersectionObserver(function (entries) {
            entries.forEach(function (entry) {
                if (entry.isIntersecting) {
                    entry.target.style.animationPlayState = 'running';
                    observer.unobserve(entry.target);
                }
            });
        }, {threshold: 0.15});
        fadeEls.forEach(function (el) {
            el.style.animationPlayState = 'paused';
            observer.observe(el);
        });
    })();

    /* ── 아파트 위치 지도 모달 ── */
    var openAptMapBtn = document.getElementById('openAptMapBtn');
    var aptMapModal = document.getElementById('aptMapModal');
    var closeAptMapBtn = document.getElementById('closeAptMapBtn');
    var aptMapBackdrop = document.getElementById('aptMapBackdrop');
    var aptMapTitle = document.getElementById('aptMapTitle');
    var aptMapAddress = document.getElementById('aptMapAddress');

    var aptMap = null;
    var aptMapMarker = null;
    var aptMapInfoWindow = null;
    var aptMapLoaded = false;

    function openAptMapModal() {
        if (!openAptMapBtn || !aptMapModal) {
            return;
        }

        var address = openAptMapBtn.getAttribute('data-address');
        var aptName = openAptMapBtn.getAttribute('data-apt-name');

        if (!address) {
            alert('아파트 주소 정보가 없습니다.');
            return;
        }

        aptMapTitle.textContent = aptName || '아파트 위치';
        aptMapAddress.textContent = address;

        aptMapModal.classList.add('show');
        aptMapModal.setAttribute('aria-hidden', 'false');
        document.body.classList.add('map-modal-open');

        /*
          display:none 상태였던 영역에 지도를 그리면 깨질 수 있어서
          모달을 먼저 보여준 뒤 relayout 처리
        */
        setTimeout(function () {
            loadAptMap(address, aptName);
        }, 80);
    }

    function closeAptMapModal() {
        if (!aptMapModal) {
            return;
        }

        aptMapModal.classList.remove('show');
        aptMapModal.setAttribute('aria-hidden', 'true');
        document.body.classList.remove('map-modal-open');
    }

    function loadAptMap(address, aptName) {
        if (typeof kakao === 'undefined' || !kakao.maps) {
            alert('카카오 지도 스크립트를 불러오지 못했습니다. JavaScript 키를 확인해 주세요.');
            return;
        }

        var mapContainer = document.getElementById('aptMap');

        if (!mapContainer) {
            return;
        }

        var geocoder = new kakao.maps.services.Geocoder();

        geocoder.addressSearch(address, function (result, status) {
            if (status !== kakao.maps.services.Status.OK || !result || result.length === 0) {
                mapContainer.innerHTML =
                    '<div style="display:flex;align-items:center;justify-content:center;height:100%;color:#666;font-size:14px;">주소로 위치를 찾을 수 없습니다.</div>';
                return;
            }

            var lat = Number(result[0].y);
            var lng = Number(result[0].x);
            var coords = new kakao.maps.LatLng(lat, lng);

            if (!aptMapLoaded) {
                aptMap = new kakao.maps.Map(mapContainer, {
                    center: coords,
                    level: 3
                });

                aptMapMarker = new kakao.maps.Marker({
                    map: aptMap,
                    position: coords
                });

                aptMapInfoWindow = new kakao.maps.InfoWindow({
                    content:
                        '<div style="padding:8px 12px;font-size:13px;font-weight:700;color:#2d5a3d;white-space:nowrap;">'
                        + escapeHtmlForMap(aptName || '아파트 위치')
                        + '</div>'
                });

                aptMapInfoWindow.open(aptMap, aptMapMarker);

                aptMapLoaded = true;
            } else {
                aptMap.setCenter(coords);
                aptMapMarker.setPosition(coords);
                aptMapInfoWindow.setContent(
                    '<div style="padding:8px 12px;font-size:13px;font-weight:700;color:#2d5a3d;white-space:nowrap;">'
                    + escapeHtmlForMap(aptName || '아파트 위치')
                    + '</div>'
                );
                aptMapInfoWindow.open(aptMap, aptMapMarker);
            }

            /*
              모달 내부 지도 깨짐 방지
            */
            setTimeout(function () {
                aptMap.relayout();
                aptMap.setCenter(coords);
            }, 120);
        });
    }

    function escapeHtmlForMap(value) {
        if (value === null || value === undefined) {
            return '';
        }

        return String(value)
            .replaceAll('&', '&amp;')
            .replaceAll('<', '&lt;')
            .replaceAll('>', '&gt;')
            .replaceAll('"', '&quot;')
            .replaceAll("'", '&#039;');
    }

    if (openAptMapBtn) {
        openAptMapBtn.addEventListener('click', openAptMapModal);
    }

    if (closeAptMapBtn) {
        closeAptMapBtn.addEventListener('click', closeAptMapModal);
    }

    if (aptMapBackdrop) {
        aptMapBackdrop.addEventListener('click', closeAptMapModal);
    }

    document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape' && aptMapModal && aptMapModal.classList.contains('show')) {
            closeAptMapModal();
        }
    });

</script>
</body>
</html>
