<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <sec:csrfMetaTags/>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>우리집맵핑 · 관리사무소</title>

    <sec:csrfMetaTags/>

    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet" />

    <%-- 관리사무소 전체 레이아웃 CSS: 사이드바, 헤더, main-wrap 구조 --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/office-layout.css">

    <%-- 관리사무소 화면 공통 CSS: panel, table, modal, button, badge 등 --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/manager-common.css">

    <%-- AG Grid CSS: 직원 계정 관리 등 AG Grid 쓰는 화면용 --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/ag-grid.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/ag-theme-alpine.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/manager-agGrid.css">
</head>
<body>

<div class="app-wrapper">

    <%-- 좌측 사이드바 --%>
    <%@ include file="/WEB-INF/views/include/office_sidebar.jsp" %>

    <div class="main-wrap">

        <%-- 상단 헤더 --%>
        <%@ include file="/WEB-INF/views/include/office_header.jsp" %>

        <%-- 본문 영역: /manager/main 처음 진입 시 대시보드가 보임 --%>
        <main class="main-content">
            <div id="contentArea">
                <%@ include file="/WEB-INF/views/apt/mgmtOffice/dashboard.jsp" %>
            </div>
        </main>

    </div>
</div>

<%-- FullCalendar: 휴가 일정, 공사·점검 일정 화면에서 사용 --%>
<script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.20/index.global.min.js"></script>

<%-- AG Grid: 직원 계정 관리 등 그리드 화면에서 사용 --%>
<script src="${pageContext.request.contextPath}/js/manager/ag-grid-community.min.js"></script>

<%-- 관리사무소 공통 JS: 공통 버튼/모달/CSRF 등 --%>
<script src="${pageContext.request.contextPath}/js/manager/manager-common.js"></script>

<%-- AG Grid 공통 JS --%>
<script src="${pageContext.request.contextPath}/js/manager/manager-agGrid.js"></script>

<script>
    /*
     * 현재 contentArea에 로드된 URL
     * 같은 메뉴를 반복 클릭했을 때 불필요한 fetch를 막기 위해 사용
     */
    var currentContentUrl = "";

    /*
     * 빠르게 여러 메뉴를 클릭했을 때
     * 늦게 도착한 이전 응답이 화면을 덮어쓰지 않도록 순번 관리
     */
    var contentRequestSeq = 0;

    /*
     * fetch로 가져온 JSP 조각 안의 script 태그를 실제 실행되도록 교체
     */
    function loadScriptElement(script) {
        return new Promise(function (resolve, reject) {
            var executableScript = document.createElement("script");

            Array.prototype.forEach.call(script.attributes, function (attr) {
                executableScript.setAttribute(attr.name, attr.value);
            });

            if (script.src) {
                executableScript.onload = resolve;
                executableScript.onerror = reject;
                executableScript.async = false;
            } else {
                executableScript.text = script.text || script.textContent || script.innerHTML || "";
            }

            script.parentNode.replaceChild(executableScript, script);

            if (!script.src) {
                resolve();
            }
        });
    }

    /*
     * contentArea 안에 들어온 script들을 순서대로 실행
     */
    async function runFragmentScripts(container) {
        var scripts = Array.prototype.slice.call(container.querySelectorAll("script"));

        for (var i = 0; i < scripts.length; i++) {
            await loadScriptElement(scripts[i]);
        }
    }

    /*
     * 각 화면 JSP에서 별도 초기화 함수가 있으면 여기서 실행
     * 새 화면에 init 함수가 생기면 이 아래에 하나씩 추가
     */
    function runFragmentInit() {
        if (typeof window.initMngrAccountPage === "function") {
            window.initMngrAccountPage();
        }

        if (typeof window.initVacationPage === "function") {
            window.initVacationPage();
        }
    }

    /*
     * 사이드바 메뉴 클릭 시 본문만 비동기로 교체하는 함수
     * 단, /manager/main 첫 진입 화면은 위에서 dashboard.jsp를 include해서 바로 출력됨
     */
    function loadContent(url, title, option) {
        var contentArea = document.getElementById("contentArea");
        if (!contentArea) return;

        option = option || {};
        var forceReload = option.force === true;

        if (!forceReload && url === currentContentUrl) return;

        var requestSeq = ++contentRequestSeq;

        var hasLoadedContent = contentArea.children.length > 0 &&
            !contentArea.querySelector(".content-placeholder");

        if (!hasLoadedContent) {
            contentArea.innerHTML =
                '<div class="content-loading">' +
                '  <span class="material-symbols-rounded">progress_activity</span>' +
                '  <p>화면을 불러오는 중입니다.</p>' +
                '</div>';
        }

        fetch(url, {
            method: "GET",
            headers: {
                "X-Requested-With": "XMLHttpRequest"
            }
        })
            .then(function (response) {
                if (!response.ok) throw new Error("HTTP " + response.status);
                return response.text();
            })
            .then(async function (html) {
                if (requestSeq !== contentRequestSeq) return;

                currentContentUrl = url;
                contentArea.innerHTML = html;

                await runFragmentScripts(contentArea);
                runFragmentInit();
            })
            .catch(function (error) {
                if (requestSeq !== contentRequestSeq) return;

                contentArea.innerHTML =
                    '<div class="content-placeholder">' +
                    '  <h2>' + (title || "화면 로드 실패") + '</h2>' +
                    '  <p>화면을 불러오지 못했습니다.</p>' +
                    '</div>';

                console.error(error);
            });
    }

    /*
     * 다른 JSP나 공통 JS에서 호출할 수 있도록 전역 등록
     */
    window.loadContent = loadContent;

    /*
     * 등록/수정/삭제 후 현재 조각 화면을 강제로 다시 불러올 때 사용
     */
    window.reloadFragment = function (url, title) {
        loadContent(url, title || "", { force: true });
    };
</script>

</body>
</html>
