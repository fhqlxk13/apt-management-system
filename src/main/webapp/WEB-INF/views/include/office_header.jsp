<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<c:set var="uri" value="${pageContext.request.requestURI}"/>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="mgmtPath" value="${not empty mgmtOfcNo ? '/' : ''}${mgmtOfcNo}"/>

<%--<c:set var="bcParent" value="관리사무소" />--%>
<%--<c:set var="bcCurrent" value="대시보드" />--%>

<%--<c:choose>--%>
<%--    <c:when test="${fn:contains(uri, '/manager/employee/account')}">--%>
<%--        <c:set var="bcParent" value="직원관리"/>--%>
<%--        <c:set var="bcCurrent" value="직원계정관리"/>--%>
<%--    </c:when>--%>
<%--    <c:when test="${fn:contains(uri, '/manager/vacation')}">--%>
<%--        <c:set var="bcParent" value="직원관리"/>--%>
<%--        <c:set var="bcCurrent" value="휴가일정"/>--%>
<%--    </c:when>--%>
<%--    <c:when test="${fn:contains(uri, '/manager/resident/list')}">--%>
<%--        <c:set var="bcParent" value="입주민관리"/>--%>
<%--        <c:set var="bcCurrent" value="입주민목록"/>--%>
<%--    </c:when>--%>
<%--    <c:when test="${fn:contains(uri, '/manager/resident/auth')}">--%>
<%--        <c:set var="bcParent" value="입주민관리"/>--%>
<%--        <c:set var="bcCurrent" value="회원권한변경"/>--%>
<%--    </c:when>--%>
<%--    <c:when test="${fn:contains(uri, '/manager/resident/moveList')}">--%>
<%--        <c:set var="bcParent" value="입주민관리"/>--%>
<%--        <c:set var="bcCurrent" value="입주/퇴거관리"/>--%>
<%--    </c:when>--%>
<%--    <c:when test="${fn:contains(uri, '/manager/resident/auto')}">--%>
<%--        <c:set var="bcParent" value="입주민관리"/>--%>
<%--        <c:set var="bcCurrent" value="입주민차량관리"/>--%>
<%--    </c:when>--%>
<%--    <c:when test="${fn:contains(uri, '/manager/visit/auto')}">--%>
<%--        <c:set var="bcParent" value="입주민관리"/>--%>
<%--        <c:set var="bcCurrent" value="방문차량관리"/>--%>
<%--    </c:when>--%>
<%--    <c:when test="${fn:contains(uri, '/manager/facilityList')}">--%>
<%--        <c:set var="bcParent" value="시설관리"/>--%>
<%--        <c:set var="bcCurrent" value="시설목록"/>--%>
<%--    </c:when>--%>
<%--    <c:when test="${fn:contains(uri, '/manager/publicFacilityList')}">--%>
<%--        <c:set var="bcParent" value="시설관리"/>--%>
<%--        <c:set var="bcCurrent" value="공용시설관리"/>--%>
<%--    </c:when>--%>
<%--    <c:when test="${fn:contains(uri, '/manager/meterReading')}">--%>
<%--        <c:set var="bcParent" value="시설관리"/>--%>
<%--        <c:set var="bcCurrent" value="검침기록관리"/>--%>
<%--    </c:when>--%>
<%--    <c:when test="${fn:contains(uri, '/manager/checkHistory')}">--%>
<%--        <c:set var="bcParent" value="시설관리"/>--%>
<%--        <c:set var="bcCurrent" value="유지보수점검이력"/>--%>
<%--    </c:when>--%>
<%--    <c:when test="${fn:contains(uri, '/manager/facility/workCalendar')}">--%>
<%--        <c:set var="bcParent" value="시설관리"/>--%>
<%--        <c:set var="bcCurrent" value="공사점검일정"/>--%>
<%--    </c:when>--%>
<%--    <c:when test="${fn:contains(uri, '/manager/facility/partnerList')}">--%>
<%--        <c:set var="bcParent" value="시설관리"/>--%>
<%--        <c:set var="bcCurrent" value="협력업체관리"/>--%>
<%--    </c:when>--%>
<%--    <c:when test="${fn:contains(uri, '/manager/bill/item-summary')}">--%>
<%--        <c:set var="bcParent" value="회계운영관리"/>--%>
<%--        <c:set var="bcCurrent" value="관리비항목집계"/>--%>
<%--    </c:when>--%>
<%--    <c:when test="${fn:contains(uri, '/manager/bill/issue')}">--%>
<%--        <c:set var="bcParent" value="회계운영관리"/>--%>
<%--        <c:set var="bcCurrent" value="고지서등록"/>--%>
<%--    </c:when>--%>
<%--    <c:when test="${fn:contains(uri, '/manager/bill/charge')}">--%>
<%--        <c:set var="bcParent" value="회계운영관리"/>--%>
<%--        <c:set var="bcCurrent" value="관리비부과"/>--%>
<%--    </c:when>--%>
<%--    <c:when test="${fn:contains(uri, '/manager/bill/expense')}">--%>
<%--        <c:set var="bcParent" value="회계운영관리"/>--%>
<%--        <c:set var="bcCurrent" value="지출내역관리"/>--%>
<%--    </c:when>--%>
<%--    <c:when test="${fn:contains(uri, '/manager/account/arrears')}">--%>
<%--        <c:set var="bcParent" value="회계운영관리"/>--%>
<%--        <c:set var="bcCurrent" value="연체내역관리"/>--%>
<%--    </c:when>--%>
<%--    <c:when test="${fn:contains(uri, '/manager/complex/edit')}">--%>
<%--        <c:set var="bcParent" value="단지운영관리"/>--%>
<%--        <c:set var="bcCurrent" value="단지정보수정"/>--%>
<%--    </c:when>--%>
<%--</c:choose>--%>

<header class="topbar">
    <div class="breadcrumb">
        <a href="${ctx}/manager/main${mgmtPath}" class="breadcrumb-home">
            <span class="material-symbols-rounded" style="font-size:14px;">home</span>
            <span>홈</span>
        </a>
        <span style="margin: 0 4px">/</span>
        <span id="officeBcParent">관리사무소</span>
<%--        <span id="officeBcParent">${bcParent}</span>--%>
        <span style="margin: 0 4px">/</span>
        <span class="bc-current" id="officeBcCurrent">대시보드</span>
<%--        <span class="bc-current" id="officeBcCurrent">${bcCurrent}</span>--%>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="${ctx}/js/manager/manager-common.js"></script>
    <div class="topbar-actions">
        <span class="topbar-clock" id="currentTime"></span>

        <%--
        <button type="button" class="topbar-icon-btn" title="알림">
            <span class="material-symbols-rounded">notifications</span>
            <span class="dot"></span>
        </button>
        --%>

        <%-- ADMIN은 헤더에서 조회 기준 관리사무소를 다시 선택할 수 있도록 기존 선택 모달 진입 화면으로 이동한다. --%>
        <c:if test="${isAdmin}">
            <a href="${ctx}/manager/main" class="topbar-action-btn" title="관리사무소 변경">
                <span class="material-symbols-rounded">domain</span>
                <span>관리사무소 변경</span>
            </a>
        </c:if>

        <a href="${ctx}/member/myPageAuth.do" class="topbar-user" title="마이페이지">
            <div class="topbar-user-avatar">
                <span class="material-symbols-rounded">person</span>
            </div>
            <div class="topbar-user-info">
                <p><sec:authentication property="principal.member.userId"/></p>
                <span>
                    <c:choose>
                        <c:when test="${not empty office.mgmtOfcNm}">${office.mgmtOfcNm}</c:when>
                        <c:when test="${not empty office.aptCmplexNm}">${office.aptCmplexNm}</c:when>
                        <c:otherwise>관리사무소</c:otherwise>
                    </c:choose>
                </span>
            </div>
        </a>

        <%-- 로그아웃은 사용자 정보 오른쪽에 배치해 계정 관련 동작끼리 묶는다. --%>
        <button type="button" class="topbar-icon-btn" id="logoutBtn" title="로그아웃">
            <span class="material-symbols-rounded">logout</span>
        </button>

        <form id="logoutForm" action="${ctx}/logout" method="post" style="display:none;">
            <sec:csrfInput/>
        </form>
    </div>
</header>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        function renderClock() {
            var now = new Date();
            var pad = function (value) {
                return String(value).padStart(2, "0");
            };
            var clock = document.getElementById("currentTime");

            if (!clock) {
                return;
            }

            clock.textContent =
                now.getFullYear() + "." +
                pad(now.getMonth() + 1) + "." +
                pad(now.getDate()) + " " +
                pad(now.getHours()) + ":" +
                pad(now.getMinutes());
        }

        renderClock();
        setInterval(renderClock, 60000);

        function getCleanText(element) {
            return element ? element.textContent.replace(/\s+/g, " ").trim() : "";
        }

        function updateBreadcrumbFromSidebar() {
            /*
                activeItem
                → 현재 선택된 사이드바 메뉴.
                .active 클래스가 붙은 메뉴를 찾는다.
            */
            var activeItem = document.querySelector(".sidebar .nav-item.active:not([aria-disabled='true'])");
            var parentTarget = document.getElementById("officeBcParent");
            var currentTarget = document.getElementById("officeBcCurrent");

            if (!activeItem || !parentTarget || !currentTarget) {
                return;
            }

            /*
                currentText
                → 현재 페이지명.
                예: 대시보드, 공지사항 관리, 협력업체 관리
            */
            var currentText = getCleanText(activeItem.querySelector(".nav-text"));
            /*
                parentText
                → 상위 메뉴명.
                기본값은 사이드바 로고 아래 텍스트에서 가져온다.
            */
            var parentText =
                getCleanText(document.querySelector(".sidebar-logo p")) || "관리사무소";
            // var parentText = "관리사무소";

            /*
                nav-group
                → 사이드바의 접히는 메뉴 묶음.
                이 안에 있으면 cat-label 값을 상위 메뉴명으로 사용한다.
            */
            var group = activeItem.closest(".nav-group");

            if (group) {
                parentText = getCleanText(group.querySelector(".cat-label")) || parentText;
            }

            parentTarget.textContent = parentText;
            currentTarget.textContent = currentText;

            // if (activeItem.classList.contains("nav-dashboard")) {
            //     parentText = "관리사무소";
            // }
            //
            // if (currentText) {
            //     parentTarget.textContent = parentText;
            //     currentTarget.textContent = currentText;
            // }
        }

        updateBreadcrumbFromSidebar();

        document.querySelectorAll(".sidebar .nav-item").forEach(function (item) {
            item.addEventListener("click", function () {
                window.setTimeout(updateBreadcrumbFromSidebar, 0);
            });
        });

        var logoutBtn = document.getElementById("logoutBtn");
        var logoutForm = document.getElementById("logoutForm");

        if (logoutBtn && logoutForm) {
            logoutBtn.addEventListener("click", function (e) {
                e.preventDefault();

                Swal.fire({
                    title: '로그아웃',
                    text: '로그아웃 하시겠습니까?',
                    icon: 'question',
                    showCancelButton: true,
                    confirmButtonText: '로그아웃',
                    cancelButtonText: '취소',
                    reverseButtons: false,
                    confirmButtonColor: '#4f46e5',
                    cancelButtonColor: '#9ca3af'
                }).then((result) => {
                    if (result.isConfirmed) {
                        logoutForm.submit();
                    }
                });
            });
        }
    });
</script>
<jsp:include page="/WEB-INF/views/include/websocket.jsp"/>
