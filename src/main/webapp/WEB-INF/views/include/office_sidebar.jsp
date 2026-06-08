<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<c:set var="uri" value="${pageContext.request.requestURI}" />
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="mgmtPath" value="${not empty mgmtOfcNo ? '/' : ''}${mgmtOfcNo}" />

<aside class="sidebar" id="sidebar">
    <div class="sidebar-logo">
        <div class="logo-mark">
            <div class="logo-icon">
                <span class="material-symbols-rounded">home_work</span>
            </div>
            <div class="logo-text">
                <h1>
                    <c:choose>
                        <c:when test="${not empty office.aptCmplexNm}">
                            <!-- 단지명을 클릭 입주민 메인페이지 이동
                            예 :  /apt/main/A10023118 -->
                            <a href="${pageContext.request.contextPath}/apt/main/${office.aptCmplexNo}"
                               style="color:#ffffff !important;
                                      text-decoration:none !important;
                                      display:block;
                                      width:125px;
                                      white-space:nowrap;
                                      overflow:hidden;
                                      text-overflow:ellipsis;
                                      font-size:11px;
                                      line-height:1.15;
                                      font-weight:800;">
                                    ${office.aptCmplexNm}
                            </a>
                        </c:when>
                        <%--                        <c:when test="${not empty office.aptCmplexNm}">${office.aptCmplexNm}</c:when>--%>
                        <c:otherwise>관리사무소</c:otherwise>
                    </c:choose>
                </h1>
                <p>관리사무소</p>
            </div>
        </div>
        <button type="button" class="collapse-btn" id="sidebarToggleBtn" title="사이드바 접기">
            <span class="material-symbols-rounded" style="font-size:18px;">left_panel_close</span>
        </button>
    </div>

    <nav class="sidebar-nav">
        <a href="${ctx}/manager/main${mgmtPath}"
           class="nav-item nav-dashboard ${fn:contains(uri, '/manager/main') ? 'active' : ''}">
            <span class="material-symbols-rounded nav-icon">dashboard</span>
            <span class="nav-text">대시보드</span>
        </a>

        <div class="section-divider"></div>

        <details class="nav-group" ${fn:contains(uri, '/manager/employee') or fn:contains(uri, '/manager/vacation') ? 'open="open"' : ''}>
            <summary class="cat-btn">
                <span class="material-symbols-rounded nav-icon nav-icon-top">badge</span>
                <span class="cat-label">인사·인력 관리</span>
                <span class="material-symbols-rounded cat-chevron">expand_more</span>
            </summary>
            <div class="submenu-wrap">
                <div class="submenu-inner">
                    <span class="sub-group-label">직원 관리</span>

                    <a href="${ctx}/manager/employee/account${mgmtPath}"
                       class="nav-item ${fn:contains(uri, '/manager/employee/account') ? 'active' : ''}">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">직원 계정 관리</span>
                    </a>

                    <%--                    <a href="${ctx}/manager/vacation${mgmtPath}"--%>
                    <%--                       class="nav-item ${fn:contains(uri, '/manager/vacation') ? 'active' : ''}">--%>
                    <%--                        <span class="material-symbols-rounded nav-icon">chevron_right</span>--%>
                    <%--                        <span class="nav-text">휴가 일정</span>--%>
                    <%--                    </a>--%>
                </div>
            </div>
        </details>

        <div class="section-divider"></div>

        <details class="nav-group" ${fn:contains(uri, '/manager/resident') or fn:contains(uri, '/manager/visit/auto') ? 'open="open"' : ''}>
            <summary class="cat-btn">
                <span class="material-symbols-rounded nav-icon nav-icon-top">groups</span>
                <span class="cat-label">입주민 관리</span>
                <span class="material-symbols-rounded cat-chevron">expand_more</span>
            </summary>
            <div class="submenu-wrap">
                <div class="submenu-inner">
                    <a href="${ctx}/manager/resident/list${mgmtPath}" class="nav-item ${fn:contains(uri, '/manager/resident/list') ? 'active' : ''}">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">입주민 목록</span>
                    </a>
                    <a href="${ctx}/manager/resident/auth${mgmtPath}" class="nav-item ${fn:contains(uri, '/manager/resident/auth') ? 'active' : ''}">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">입주 신청 관리</span>
                    </a>
                    <a href="${ctx}/manager/resident/moveList${mgmtPath}" class="nav-item ${fn:contains(uri, '/manager/resident/moveList') ? 'active' : ''}">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">입주/퇴거 관리</span>
                    </a>
                    <a href="/manager/resident/auto/list/${mgmtOfcNo}" class="nav-item ${fn:contains(uri, '/manager/resident/auto') ? 'active' : ''}">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">입주민 차량 관리</span>
                    </a>
                    <a href="${ctx}/manager/visit/auto${mgmtPath}" class="nav-item ${fn:contains(uri, '/manager/visit/auto') ? 'active' : ''}">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">방문 차량 관리</span>
                    </a>
                </div>
            </div>
        </details>

        <div class="section-divider"></div>

        <%-- 시설/공사 관리 --%>
        <%--        <details class="nav-group"--%>
        <%--        ${activeMenu eq 'facilityAsset'--%>
        <%--                or activeMenu eq 'publicFacility'--%>
        <%--                or activeMenu eq 'checkHistory'--%>
        <%--                or activeMenu eq 'meterHstry'--%>
        <%--                or activeMenu eq 'facilityPartner'--%>
        <%--                or activeMenu eq 'facilityContract'--%>
        <%--                or fn:contains(uri, '/manager/publicFacility')--%>
        <%--                or fn:contains(uri, '/manager/checkHistory')--%>
        <%--                or fn:contains(uri, '/manager/meter/hstry')--%>
        <%--                or fn:contains(uri, '/manager/facility/workCalendar')--%>
        <%--                or fn:contains(uri, '/manager/facility/partner')--%>
        <%--                or fn:contains(uri, '/manager/contract')--%>
        <%--                ? 'open="open"' : ''}>--%>

        <%--            <summary class="cat-btn">--%>
        <%--                <span class="material-symbols-rounded nav-icon nav-icon-top">apartment</span>--%>
        <%--                <span class="cat-label">시설·공사 관리</span>--%>
        <%--                <span class="material-symbols-rounded cat-chevron">expand_more</span>--%>
        <%--            </summary>--%>

        <%--            <div class="submenu-wrap">--%>
        <%--                <div class="submenu-inner">--%>

        <%--                    &lt;%&ndash; 시설 관리 &ndash;%&gt;--%>
        <%--                    <span class="sub-group-label">시설 관리</span>--%>

        <%--                    <a href="${ctx}/manager/facility/page${mgmtPath}"--%>
        <%--                       class="nav-item ${activeMenu eq 'facilityAsset' ? 'active' : ''}">--%>
        <%--                        <span class="material-symbols-rounded nav-icon">chevron_right</span>--%>
        <%--                        <span class="nav-text">시설자산 관리</span>--%>
        <%--                    </a>--%>

        <%--                    &lt;%&ndash; 편의시설 관리 &ndash;%&gt;--%>
        <%--                    <details class="nav-group-sub"--%>
        <%--                    ${fn:contains(uri, '/manager/publicFacility') ? 'open="open"' : ''}>--%>

        <%--                        <summary class="nav-item nav-sub-summary ${fn:contains(uri, '/manager/publicFacility') ? 'active' : ''}">--%>
        <%--                            <span class="material-symbols-rounded nav-icon">chevron_right</span>--%>

        <%--                            <a href="${ctx}/manager/publicFacility/page${mgmtPath}"--%>
        <%--                               class="nav-text nav-sub-main-link"--%>
        <%--                               onclick="event.stopPropagation();">--%>
        <%--                                편의시설 관리--%>
        <%--                            </a>--%>

        <%--                            <span class="material-symbols-rounded nav-sub-chevron">expand_more</span>--%>
        <%--                        </summary>--%>

        <%--                        <div class="nav-sub-depth">--%>

        <%--                            <a href="${ctx}/manager/publicFacility/reservation/facilities${mgmtPath}"--%>
        <%--                               class="nav-item ${fn:contains(uri, '/manager/publicFacility/reservation/facilities') ? 'active' : ''}">--%>
        <%--                                <span class="material-symbols-rounded nav-icon">chevron_right</span>--%>
        <%--                                <span class="nav-text">편의시설 목록</span>--%>
        <%--                            </a>--%>

        <%--                            <a href="${ctx}/manager/publicFacility/reservation/approval${mgmtPath}"--%>
        <%--                               class="nav-item ${fn:contains(uri, '/manager/publicFacility/reservation/approval') ? 'active' : ''}">--%>
        <%--                                <span class="material-symbols-rounded nav-icon">chevron_right</span>--%>
        <%--                                <span class="nav-text">예약승인관리</span>--%>
        <%--                            </a>--%>

        <%--                            <a href="${ctx}/manager/publicFacility/reservation/history${mgmtPath}"--%>
        <%--                               class="nav-item ${fn:contains(uri, '/manager/publicFacility/reservation/history') ? 'active' : ''}">--%>
        <%--                                <span class="material-symbols-rounded nav-icon">chevron_right</span>--%>
        <%--                                <span class="nav-text">예약시설 이용이력</span>--%>
        <%--                            </a>--%>

        <%--                        </div>--%>
        <%--                    </details>--%>

        <%--                    &lt;%&ndash; 공사·점검 &ndash;%&gt;--%>
        <%--                    <span class="sub-group-label">공사·점검</span>--%>

        <%--                    <a href="${ctx}/manager/checkHistory${mgmtPath}"--%>
        <%--                       class="nav-item ${fn:contains(uri, '/manager/checkHistory') ? 'active' : ''}">--%>
        <%--                        <span class="material-symbols-rounded nav-icon">chevron_right</span>--%>
        <%--                        <span class="nav-text">유지보수·점검 이력</span>--%>
        <%--                    </a>--%>

        <%--                    <a href="${ctx}/manager/meter/hstry${mgmtPath}"--%>
        <%--                       class="nav-item ${fn:contains(uri, '/manager/meter/hstry') ? 'active' : ''}">--%>
        <%--                        <span class="material-symbols-rounded nav-icon">chevron_right</span>--%>
        <%--                        <span class="nav-text">검침 이력</span>--%>
        <%--                    </a>--%>

        <%--                    <a href="${ctx}/manager/facility/workCalendar${mgmtPath}"--%>
        <%--                       class="nav-item ${fn:contains(uri, '/manager/facility/workCalendar') ? 'active' : ''}">--%>
        <%--                        <span class="material-symbols-rounded nav-icon">chevron_right</span>--%>
        <%--                        <span class="nav-text">시설 일정</span>--%>
        <%--                    </a>--%>

        <%--                    &lt;%&ndash; 협력업체 &ndash;%&gt;--%>
        <%--                    <span class="sub-group-label">협력업체</span>--%>

        <%--                    <a href="${ctx}/manager/facility/partner/list${mgmtPath}"--%>
        <%--                       class="nav-item ${fn:contains(uri, '/manager/facility/partner/list') ? 'active' : ''}">--%>
        <%--                        <span class="material-symbols-rounded nav-icon">chevron_right</span>--%>
        <%--                        <span class="nav-text">협력업체 관리</span>--%>
        <%--                    </a>--%>

        <%--                    <a href="${ctx}/manager/contract${mgmtPath}"--%>
        <%--                       class="nav-item ${fn:contains(uri, '/manager/contract') ? 'active' : ''}">--%>
        <%--                        <span class="material-symbols-rounded nav-icon">chevron_right</span>--%>
        <%--                        <span class="nav-text">계약 관리</span>--%>
        <%--                    </a>--%>

        <%--                </div>--%>
        <%--            </div>--%>
        <%--        </details>--%>

        <%--&lt;%&ndash;        <details class="nav-group"&ndash;%&gt;--%>
        <%--&lt;%&ndash;        ${activeMenu eq 'facilityAsset'&ndash;%&gt;--%>
        <%--&lt;%&ndash;                or activeMenu eq 'publicFacility'&ndash;%&gt;--%>
        <%--&lt;%&ndash;                or activeMenu eq 'checkHistory'&ndash;%&gt;--%>
        <%--&lt;%&ndash;                or activeMenu eq 'meterHstry'&ndash;%&gt;--%>
        <%--&lt;%&ndash;                or activeMenu eq 'facilityPartner'&ndash;%&gt;--%>
        <%--&lt;%&ndash;                or activeMenu eq 'facilityContract'&ndash;%&gt;--%>
        <%--&lt;%&ndash;                or fn:contains(uri, '/manager/meter/hstry')&ndash;%&gt;--%>
        <%--&lt;%&ndash;                or fn:contains(uri, '/manager/contract')&ndash;%&gt;--%>
        <%--&lt;%&ndash;                ? 'open="open"' : ''}>&ndash;%&gt;--%>
        <%--&lt;%&ndash;            <summary class="cat-btn">&ndash;%&gt;--%>
        <%--&lt;%&ndash;                <span class="material-symbols-rounded nav-icon nav-icon-top">apartment</span>&ndash;%&gt;--%>
        <%--&lt;%&ndash;                <span class="cat-label">시설·공사 관리</span>&ndash;%&gt;--%>
        <%--&lt;%&ndash;                <span class="material-symbols-rounded cat-chevron">expand_more</span>&ndash;%&gt;--%>
        <%--&lt;%&ndash;            </summary>&ndash;%&gt;--%>
        <%--&lt;%&ndash;            <div class="submenu-wrap">&ndash;%&gt;--%>
        <%--&lt;%&ndash;                <div class="submenu-inner">&ndash;%&gt;--%>

        <%--&lt;%&ndash;                    &lt;%&ndash; 시설 관리 &ndash;%&gt;&ndash;%&gt;--%>
        <%--&lt;%&ndash;                    <span class="sub-group-label">시설 관리</span>&ndash;%&gt;--%>

        <%--&lt;%&ndash;                    <a href="${ctx}/manager/facility/page${mgmtPath}"&ndash;%&gt;--%>
        <%--&lt;%&ndash;                       class="nav-item ${activeMenu eq 'facilityAsset' ? 'active' : ''}">&ndash;%&gt;--%>
        <%--&lt;%&ndash;                        <span class="material-symbols-rounded nav-icon">chevron_right</span>&ndash;%&gt;--%>
        <%--&lt;%&ndash;                        <span class="nav-text">시설자산 관리</span>&ndash;%&gt;--%>
        <%--&lt;%&ndash;                    </a>&ndash;%&gt;--%>

        <%--&lt;%&ndash;                    &lt;%&ndash; 편의시설 관리: 누르면 하위 메뉴 열림, 글자 클릭 시 편의시설 관리 페이지 이동 &ndash;%&gt;&ndash;%&gt;--%>
        <%--&lt;%&ndash;                    <details class="public-facility-sub"&ndash;%&gt;--%>
        <%--&lt;%&ndash;                    ${fn:contains(uri, '/manager/publicFacility') ? 'open="open"' : ''}>&ndash;%&gt;--%>

        <%--&lt;%&ndash;                        <summary class="nav-item ${fn:contains(uri, '/manager/publicFacility') ? 'active' : ''}">&ndash;%&gt;--%>
        <%--&lt;%&ndash;                            <span class="material-symbols-rounded nav-icon">chevron_right</span>&ndash;%&gt;--%>

        <%--&lt;%&ndash;                            <a href="${ctx}/manager/publicFacility/page${mgmtPath}"&ndash;%&gt;--%>
        <%--&lt;%&ndash;                               class="nav-text public-facility-main-link"&ndash;%&gt;--%>
        <%--&lt;%&ndash;                               onclick="event.stopPropagation();">&ndash;%&gt;--%>
        <%--&lt;%&ndash;                                편의시설 관리&ndash;%&gt;--%>
        <%--&lt;%&ndash;                            </a>&ndash;%&gt;--%>

        <%--&lt;%&ndash;                            <span class="material-symbols-rounded cat-chevron" style="margin-left:auto;">&ndash;%&gt;--%>
        <%--&lt;%&ndash;                expand_more&ndash;%&gt;--%>
        <%--&lt;%&ndash;            </span>&ndash;%&gt;--%>
        <%--&lt;%&ndash;                        </summary>&ndash;%&gt;--%>

        <%--&lt;%&ndash;                        <div class="public-facility-submenu">&ndash;%&gt;--%>

        <%--&lt;%&ndash;                            <a href="${ctx}/manager/publicFacility/reservation/facilities${mgmtPath}"&ndash;%&gt;--%>
        <%--&lt;%&ndash;                               class="nav-item ${fn:contains(uri, '/manager/publicFacility/reservation/facilities') ? 'active' : ''}">&ndash;%&gt;--%>
        <%--&lt;%&ndash;                                <span class="material-symbols-rounded nav-icon">chevron_right</span>&ndash;%&gt;--%>
        <%--&lt;%&ndash;                                <span class="nav-text">편의시설 목록</span>&ndash;%&gt;--%>
        <%--&lt;%&ndash;                            </a>&ndash;%&gt;--%>

        <%--&lt;%&ndash;                            <a href="${ctx}/manager/publicFacility/reservation/approval${mgmtPath}"&ndash;%&gt;--%>
        <%--&lt;%&ndash;                               class="nav-item ${fn:contains(uri, '/manager/publicFacility/reservation/approval') ? 'active' : ''}">&ndash;%&gt;--%>
        <%--&lt;%&ndash;                                <span class="material-symbols-rounded nav-icon">chevron_right</span>&ndash;%&gt;--%>
        <%--&lt;%&ndash;                                <span class="nav-text">예약승인관리</span>&ndash;%&gt;--%>
        <%--&lt;%&ndash;                            </a>&ndash;%&gt;--%>

        <%--&lt;%&ndash;                            <a href="${ctx}/manager/publicFacility/reservation/history${mgmtPath}"&ndash;%&gt;--%>
        <%--&lt;%&ndash;                               class="nav-item ${fn:contains(uri, '/manager/publicFacility/reservation/history') ? 'active' : ''}">&ndash;%&gt;--%>
        <%--&lt;%&ndash;                                <span class="material-symbols-rounded nav-icon">chevron_right</span>&ndash;%&gt;--%>
        <%--&lt;%&ndash;                                <span class="nav-text">예약시설 이용이력</span>&ndash;%&gt;--%>
        <%--&lt;%&ndash;                            </a>&ndash;%&gt;--%>

        <%--&lt;%&ndash;                        </div>&ndash;%&gt;--%>
        <%--&lt;%&ndash;                    </details>&ndash;%&gt;--%>

        <%--&lt;%&ndash;                    &lt;%&ndash; 공사·점검 &ndash;%&gt;&ndash;%&gt;--%>
        <%--&lt;%&ndash;                    <span class="sub-group-label">공사·점검</span>&ndash;%&gt;--%>

        <%--&lt;%&ndash;                    <a href="${ctx}/manager/checkHistory${mgmtPath}"&ndash;%&gt;--%>
        <%--&lt;%&ndash;                       class="nav-item ${fn:contains(uri, '/manager/checkHistory') ? 'active' : ''}">&ndash;%&gt;--%>
        <%--&lt;%&ndash;                        <span class="material-symbols-rounded nav-icon">chevron_right</span>&ndash;%&gt;--%>
        <%--&lt;%&ndash;                        <span class="nav-text">유지보수·점검 이력</span>&ndash;%&gt;--%>
        <%--&lt;%&ndash;                    </a>&ndash;%&gt;--%>

        <%--&lt;%&ndash;                    <a href="${ctx}/manager/meter/hstry${mgmtPath}"&ndash;%&gt;--%>
        <%--&lt;%&ndash;                       class="nav-item ${fn:contains(uri, '/manager/meter/hstry') ? 'active' : ''}">&ndash;%&gt;--%>
        <%--&lt;%&ndash;                        <span class="material-symbols-rounded nav-icon">chevron_right</span>&ndash;%&gt;--%>
        <%--&lt;%&ndash;                        <span class="nav-text">검침 이력</span>&ndash;%&gt;--%>
        <%--&lt;%&ndash;                    </a>&ndash;%&gt;--%>

        <%--&lt;%&ndash;                    <a href="${ctx}/manager/facility/workCalendar${mgmtPath}"&ndash;%&gt;--%>
        <%--&lt;%&ndash;                       class="nav-item ${fn:contains(uri, '/manager/facility/workCalendar') ? 'active' : ''}">&ndash;%&gt;--%>
        <%--&lt;%&ndash;                        <span class="material-symbols-rounded nav-icon">chevron_right</span>&ndash;%&gt;--%>
        <%--&lt;%&ndash;                        <span class="nav-text">시설 일정</span>&ndash;%&gt;--%>
        <%--&lt;%&ndash;                    </a>&ndash;%&gt;--%>

        <%--&lt;%&ndash;                    &lt;%&ndash; 협력업체 &ndash;%&gt;&ndash;%&gt;--%>
        <%--&lt;%&ndash;                    <span class="sub-group-label">협력업체</span>&ndash;%&gt;--%>

        <%--&lt;%&ndash;                    <a href="${ctx}/manager/facility/partner/list${mgmtPath}"&ndash;%&gt;--%>
        <%--&lt;%&ndash;                       class="nav-item ${fn:contains(uri, '/manager/facility/partner/list') ? 'active' : ''}">&ndash;%&gt;--%>
        <%--&lt;%&ndash;                        <span class="material-symbols-rounded nav-icon">chevron_right</span>&ndash;%&gt;--%>
        <%--&lt;%&ndash;                        <span class="nav-text">협력업체 관리</span>&ndash;%&gt;--%>
        <%--&lt;%&ndash;                    </a>&ndash;%&gt;--%>

        <%--&lt;%&ndash;                    <a href="${ctx}/manager/contract${mgmtPath}"&ndash;%&gt;--%>
        <%--&lt;%&ndash;                       class="nav-item ${fn:contains(uri, '/manager/contract') ? 'active' : ''}">&ndash;%&gt;--%>
        <%--&lt;%&ndash;                        <span class="material-symbols-rounded nav-icon">chevron_right</span>&ndash;%&gt;--%>
        <%--&lt;%&ndash;                        <span class="nav-text">계약 관리</span>&ndash;%&gt;--%>
        <%--&lt;%&ndash;                    </a>&ndash;%&gt;--%>

        <%--&lt;%&ndash;                </div>&ndash;%&gt;--%>

        <%--&lt;%&ndash;                    <span class="sub-group-label">시설 관리</span>&ndash;%&gt;--%>
        <%--&lt;%&ndash;                    <a href="${ctx}/manager/facility/page${mgmtPath}" class="nav-item ${activeMenu eq 'facilityAsset' ? 'active' : ''}">&ndash;%&gt;--%>
        <%--&lt;%&ndash;                        <span class="material-symbols-rounded nav-icon">chevron_right</span>&ndash;%&gt;--%>
        <%--&lt;%&ndash;                        <span class="nav-text">시설자산 관리</span>&ndash;%&gt;--%>
        <%--&lt;%&ndash;                    </a>&ndash;%&gt;--%>
        <%--&lt;%&ndash;                    <a href="${ctx}/manager/publicFacility/page${mgmtPath}" class="nav-item ${fn:contains(uri, '/manager/publicFacility') ? 'active' : ''}">&ndash;%&gt;--%>
        <%--&lt;%&ndash;                        <span class="material-symbols-rounded nav-icon">chevron_right</span>&ndash;%&gt;--%>
        <%--&lt;%&ndash;                        <span class="nav-text">편의시설 관리</span>&ndash;%&gt;--%>
        <%--&lt;%&ndash;                    </a>&ndash;%&gt;--%>

        <%--&lt;%&ndash;                    <a href="${ctx}/manager/publicFacility/reservation/facilities${mgmtPath}"&ndash;%&gt;--%>
        <%--&lt;%&ndash;                       class="nav-item ${fn:contains(uri, '/manager/publicFacility/reservation/facilities') ? 'active' : ''}">&ndash;%&gt;--%>
        <%--&lt;%&ndash;                        <span class="material-symbols-rounded nav-icon">chevron_right</span>&ndash;%&gt;--%>
        <%--&lt;%&ndash;                        <span class="nav-text">편의시설 목록</span>&ndash;%&gt;--%>
        <%--&lt;%&ndash;                    </a>&ndash;%&gt;--%>

        <%--&lt;%&ndash;                    <a href="${ctx}/manager/publicFacility/reservation/approval${mgmtPath}"&ndash;%&gt;--%>
        <%--&lt;%&ndash;                       class="nav-item ${fn:contains(uri, '/manager/publicFacility/reservation/approval') ? 'active' : ''}">&ndash;%&gt;--%>
        <%--&lt;%&ndash;                        <span class="material-symbols-rounded nav-icon">chevron_right</span>&ndash;%&gt;--%>
        <%--&lt;%&ndash;                        <span class="nav-text">예약승인관리</span>&ndash;%&gt;--%>
        <%--&lt;%&ndash;                    </a>&ndash;%&gt;--%>

        <%--&lt;%&ndash;                    <a href="${ctx}/manager/publicFacility/reservation/history${mgmtPath}"&ndash;%&gt;--%>
        <%--&lt;%&ndash;                       class="nav-item ${fn:contains(uri, '/manager/publicFacility/reservation/history') ? 'active' : ''}">&ndash;%&gt;--%>
        <%--&lt;%&ndash;                        <span class="material-symbols-rounded nav-icon">chevron_right</span>&ndash;%&gt;--%>
        <%--&lt;%&ndash;                        <span class="nav-text">예약시설 이용이력</span>&ndash;%&gt;--%>
        <%--&lt;%&ndash;                    </a>&ndash;%&gt;--%>
        <%--                        <span class="sub-group-label">시설 관리</span>--%>

        <%--                        <a href="${ctx}/manager/facility/page${mgmtPath}"--%>
        <%--                           class="nav-item ${activeMenu eq 'facilityAsset' ? 'active' : ''}">--%>
        <%--                            <span class="material-symbols-rounded nav-icon">chevron_right</span>--%>
        <%--                            <span class="nav-text">시설자산 관리</span>--%>
        <%--                        </a>--%>

        <%--                        <details class="public-facility-sub"--%>
        <%--                        ${fn:contains(uri, '/manager/publicFacility') ? 'open="open"' : ''}>--%>

        <%--                            <summary class="nav-item ${fn:contains(uri, '/manager/publicFacility') ? 'active' : ''}">--%>
        <%--                                <span class="material-symbols-rounded nav-icon">chevron_right</span>--%>

        <%--                                <a href="${ctx}/manager/publicFacility/page${mgmtPath}"--%>
        <%--                                   class="nav-text"--%>
        <%--                                   onclick="event.stopPropagation();">--%>
        <%--                                    편의시설 관리--%>
        <%--                                </a>--%>

        <%--                                <span class="material-symbols-rounded cat-chevron"--%>
        <%--                                      style="margin-left:auto;">--%>
        <%--                                expand_more--%>
        <%--                            </span>--%>
        <%--                            </summary>--%>

        <%--                            <div class="public-facility-submenu">--%>

        <%--                                <a href="${ctx}/manager/publicFacility/reservation/facilities${mgmtPath}"--%>
        <%--                                   class="nav-item ${fn:contains(uri, '/manager/publicFacility/reservation/facilities') ? 'active' : ''}">--%>
        <%--                                    <span class="material-symbols-rounded nav-icon">chevron_right</span>--%>
        <%--                                    <span class="nav-text">편의시설 목록</span>--%>
        <%--                                </a>--%>

        <%--                                <a href="${ctx}/manager/publicFacility/reservation/approval${mgmtPath}"--%>
        <%--                                   class="nav-item ${fn:contains(uri, '/manager/publicFacility/reservation/approval') ? 'active' : ''}">--%>
        <%--                                    <span class="material-symbols-rounded nav-icon">chevron_right</span>--%>
        <%--                                    <span class="nav-text">예약승인관리</span>--%>
        <%--                                </a>--%>

        <%--                                <a href="${ctx}/manager/publicFacility/reservation/history${mgmtPath}"--%>
        <%--                                   class="nav-item ${fn:contains(uri, '/manager/publicFacility/reservation/history') ? 'active' : ''}">--%>
        <%--                                    <span class="material-symbols-rounded nav-icon">chevron_right</span>--%>
        <%--                                    <span class="nav-text">예약시설 이용이력</span>--%>
        <%--                                </a>--%>
        <%--                            </div>--%>

        <%--                    &lt;%&ndash; 공사·점검 &ndash;%&gt;--%>
        <%--                    <span class="sub-group-label">공사·점검</span>--%>
        <%--                    &lt;%&ndash;--%>
        <%--                        checkHistory : 탭1 시설점검이력(FACILITY_CHECK_HSTRY)--%>
        <%--                    &ndash;%&gt;--%>
        <%--                    <a href="${ctx}/manager/checkHistory${mgmtPath}" class="nav-item ${fn:contains(uri, '/manager/checkHistory') ? 'active' : ''}">--%>
        <%--                        <span class="material-symbols-rounded nav-icon">chevron_right</span>--%>
        <%--                        <span class="nav-text">유지보수·점검 이력</span>--%>
        <%--                    </a>--%>
        <%--                    &lt;%&ndash; 검침 이력 &ndash;%&gt;--%>
        <%--                    <a href="${ctx}/manager/meter/hstry${mgmtPath}" class="nav-item ${fn:contains(uri, '/manager/meter/hstry') ? 'active' : ''}">--%>
        <%--                        <span class="material-symbols-rounded nav-icon">chevron_right</span>--%>
        <%--                        <span class="nav-text">검침 이력</span>--%>
        <%--                    </a>--%>
        <%--                    <a href="${ctx}/manager/facility/workCalendar${mgmtPath}" class="nav-item ${fn:contains(uri, '/manager/facility/workCalendar') ? 'active' : ''}">--%>
        <%--                        <span class="material-symbols-rounded nav-icon">chevron_right</span>--%>
        <%--                        <span class="nav-text">시설 일정</span>--%>
        <%--                    </a>--%>

        <%--                    &lt;%&ndash; 협력업체 &ndash;%&gt;--%>
        <%--                    <span class="sub-group-label">협력업체</span>--%>
        <%--                    <a href="${ctx}/manager/facility/partner/list${mgmtPath}"--%>
        <%--                       class="nav-item ${fn:contains(uri, '/manager/facility/partner/list') ? 'active' : ''}">--%>
        <%--                        <span class="material-symbols-rounded nav-icon">chevron_right</span>--%>
        <%--                        <span class="nav-text">협력업체 관리</span>--%>
        <%--                    </a>--%>
        <%--                    &lt;%&ndash; 계약 관리 &ndash;%&gt;--%>
        <%--                    <a href="${ctx}/manager/contract${mgmtPath}"--%>
        <%--                       class="nav-item ${fn:contains(uri, '/manager/contract') ? 'active' : ''}">--%>
        <%--                        <span class="material-symbols-rounded nav-icon">chevron_right</span>--%>
        <%--                        <span class="nav-text">계약 관리</span>--%>
        <%--                    </a>--%>


        <%--                </div>--%>
        <%--            </div>--%>
        <%--        </details>--%>

        <%-- 시설/공사 관리 --%>
        <details class="nav-group"
        ${activeMenu eq 'facilityAsset'
                or activeMenu eq 'publicFacility'
                or activeMenu eq 'checkHistory'
                or activeMenu eq 'meterHstry'
                or activeMenu eq 'facilityPartner'
                or activeMenu eq 'facilityContract'
                or fn:contains(uri, '/manager/publicFacility')
                or fn:contains(uri, '/manager/checkHistory')
                or fn:contains(uri, '/manager/meter/hstry')
                or fn:contains(uri, '/manager/facility/workCalendar')
                or fn:contains(uri, '/manager/facility/partner')
                or fn:contains(uri, '/manager/facility/contract')
                ? 'open="open"' : ''}>

            <%--        ${fn:contains(uri, '/manager/facility')--%>
            <%--                or fn:contains(uri, '/manager/publicFacility')--%>
            <%--                or fn:contains(uri, '/manager/checkHistory')--%>
            <%--                or fn:contains(uri, '/manager/meter/hstry')--%>
            <%--                or fn:contains(uri, '/manager/contract')--%>
            <%--                ? 'open="open"' : ''}>--%>

            <summary class="cat-btn">
                <span class="material-symbols-rounded nav-icon nav-icon-top">apartment</span>
                <span class="cat-label">시설·공사 관리</span>
                <span class="material-symbols-rounded cat-chevron">expand_more</span>
            </summary>

            <div class="submenu-wrap">
                <div class="submenu-inner">

                    <span class="sub-group-label">시설 관리</span>

                    <a href="${ctx}/manager/facility/page${mgmtPath}"
                       class="nav-item ${fn:contains(uri, '/manager/facility/page') ? 'active' : ''}">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">시설자산 관리</span>
                    </a>

                    <%--                    <div class="nav-item facility-parent ${fn:contains(uri, '/manager/publicFacility') ? 'active' : ''}"--%>
                    <%--                         id="publicFacilityToggle">--%>
                    <div class="nav-item facility-parent
                         ${activeMenu eq 'publicFacility'
                           or (fn:contains(uri, '/manager/publicFacility')
                               and not fn:contains(uri, '/manager/publicFacility/reservation'))
                           ? 'active is-open' : ''}
                         ${fn:contains(uri, '/manager/publicFacility/reservation') ? 'is-open' : ''}"
                         id="publicFacilityToggle">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>

                        <a href="${ctx}/manager/publicFacility/page${mgmtPath}"
                           class="nav-text facility-parent-link">
                            편의시설 운영관리
                        </a>

                        <span class="material-symbols-rounded facility-parent-arrow">expand_more</span>
                    </div>

                    <%--                    <div class="facility-child-wrap ${fn:contains(uri, '/manager/publicFacility') ? 'is-open' : ''}"--%>
                    <%--                         id="publicFacilityChild">--%>
                    <div class="facility-child-wrap
                         ${activeMenu eq 'publicFacility'
                           or fn:contains(uri, '/manager/publicFacility')
                           ? 'is-open' : ''}"
                         id="publicFacilityChild">

                        <%--                        <a href="${ctx}/manager/publicFacility/reservation/facilities${mgmtPath}"--%>
                        <%--                           class="nav-item child-nav-item ${fn:contains(uri, '/manager/publicFacility/reservation/facilities') ? 'active' : ''}">--%>
                        <%--                            <span class="material-symbols-rounded nav-icon">chevron_right</span>--%>
                        <%--                            <span class="nav-text">편의시설 목록</span>--%>
                        <%--                        </a>--%>

                        <a href="${ctx}/manager/publicFacility/reservation/approval${mgmtPath}"
                           class="nav-item child-nav-item ${fn:contains(uri, '/manager/publicFacility/reservation/approval') ? 'active' : ''}">
                            <span class="material-symbols-rounded nav-icon">chevron_right</span>
                            <span class="nav-text">예약승인관리</span>
                        </a>

                        <a href="${ctx}/manager/publicFacility/reservation/history${mgmtPath}"
                           class="nav-item child-nav-item ${fn:contains(uri, '/manager/publicFacility/reservation/history') ? 'active' : ''}">
                            <span class="material-symbols-rounded nav-icon">chevron_right</span>
                            <span class="nav-text">예약시설 이용이력</span>
                        </a>

                    </div>

                    <span class="sub-group-label">공사·점검</span>

                    <a href="${ctx}/manager/checkHistory${mgmtPath}"
                       class="nav-item ${fn:contains(uri, '/manager/checkHistory') ? 'active' : ''}">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">유지보수·점검 이력</span>
                    </a>

                    <a href="${ctx}/manager/meter/hstry${mgmtPath}"
                       class="nav-item ${fn:contains(uri, '/manager/meter/hstry') ? 'active' : ''}">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">검침 이력</span>
                    </a>

                    <%--                    <a href="${ctx}/manager/facility/workCalendar${mgmtPath}"--%>
                    <%--                       class="nav-item ${fn:contains(uri, '/manager/facility/workCalendar') ? 'active' : ''}">--%>
                    <%--                        <span class="material-symbols-rounded nav-icon">chevron_right</span>--%>
                    <%--                        <span class="nav-text">시설 일정</span>--%>
                    <%--                    </a>--%>

                    <span class="sub-group-label">협력업체</span>

                    <a href="${ctx}/manager/facility/partner/list${mgmtPath}"
                       class="nav-item ${fn:contains(uri, '/manager/facility/partner/list') ? 'active' : ''}">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">협력업체 관리</span>
                    </a>

                    <a href="${ctx}/manager/facility/contract/list${mgmtPath}"
                       class="nav-item ${fn:contains(uri, '/manager/facility/contract') ? 'active' : ''}">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">계약 관리</span>
                    </a>

                </div>
            </div>
        </details>

        <div class="section-divider"></div>

        <details class="nav-group" ${fn:contains(uri, '/manager/bill') or fn:contains(uri, '/manager/account/arrears') ? 'open="open"' : ''}>
            <summary class="cat-btn">
                <span class="material-symbols-rounded nav-icon nav-icon-top">receipt_long</span>
                <span class="cat-label">회계·운영 관리</span>
                <span class="material-symbols-rounded cat-chevron">expand_more</span>
            </summary>
            <div class="submenu-wrap">
                <div class="submenu-inner">
                    <span class="sub-group-label">지출·예산</span>
                    <a href="${ctx}/manager/bill/expense${mgmtPath}" class="nav-item ${fn:contains(uri, '/manager/bill/expense') ? 'active' : ''}">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">지출 내역 관리</span>
                    </a>
                    <a href="${ctx}/manager/bill/meter-charge${mgmtPath}" class="nav-item ${fn:contains(uri, '/manager/bill/expense') ? 'active' : ''}">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">검침요금 계산</span>
                    </a>
                    <%--                    <a href="javascript:void(0);" class="nav-item" aria-disabled="true" title="준비중">--%>
                    <%--                        <span class="material-symbols-rounded nav-icon">chevron_right</span>--%>
                    <%--                        <span class="nav-text">예산 편성·조회</span>--%>
                    <%--&lt;%&ndash;                    </a>&ndash;%&gt;--%>
                    <%--                    <a href="javascript:void(0);" class="nav-item" aria-disabled="true" title="준비중">--%>
                    <%--                        <span class="material-symbols-rounded nav-icon">chevron_right</span>--%>
                    <%--                        <span class="nav-text">지출 통계</span>--%>
                    <%--                    </a>--%>
                    <span class="sub-group-label">관리비</span>
                    <a href="${ctx}/manager/bill/charge${mgmtPath}" class="nav-item ${fn:contains(uri, '/manager/bill/charge') ? 'active' : ''}">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">관리비 부과</span>
                    </a>
                    <a href="${ctx}/manager/bill/issue${mgmtPath}" class="nav-item ${fn:contains(uri, '/manager/bill/issue') ? 'active' : ''}">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">고지서 조회</span>
                    </a>
                    <a href="${ctx}/manager/bill/statistics${mgmtPath}" class="nav-item ${fn:contains(uri, '/manager/bill/item-summary') ? 'active' : ''}">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">관리비 통계</span>
                    </a>
                </div>
            </div>
        </details>

        <div class="section-divider"></div>

        <details class="nav-group" ${fn:contains(uri, '/mgmtOffice/mngrResidentNotice') or fn:contains(uri, '/manager/complex/broadcast') ? 'open="open"' : ''}>
            <%--        <details class="nav-group">--%>
            <summary class="cat-btn">
                <span class="material-symbols-rounded nav-icon nav-icon-top">campaign</span>
                <span class="cat-label">소통·행정 관리</span>
                <span class="material-symbols-rounded cat-chevron">expand_more</span>
            </summary>
            <div class="submenu-wrap">
                <div class="submenu-inner">
                    <span class="sub-group-label">민원</span>
                    <a href="/manager/complex/complaint/${mgmtOfcNo}" class="nav-item" aria-disabled="true">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">민원 관리</span>
                    </a>
                    <%--<a href="javascript:void(0);" class="nav-item" aria-disabled="true" title="준비중">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">민원 처리</span>
                    </a>
                    <a href="javascript:void(0);" class="nav-item" aria-disabled="true" title="준비중">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">고위 민원 알림</span>
                    </a>
                    <a href="javascript:void(0);" class="nav-item" aria-disabled="true" title="준비중">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">1:1 채팅 문의</span>
                    </a>--%>

                    <span class="sub-group-label">게시판</span>
                    <a href="/mgmtOffice/mngrResidentNotice/${mgmtOfcNo}" class="nav-item ${fn:contains(uri, '/mgmtOffice/mngrResidentNotice') ? 'active' : ''}">
                        <%--                    <a href="/mgmtOffice/mngrResidentNotice/${mgmtOfcNo}" class="nav-item" aria-disabled="true">--%>
                        <span class="material-symbols-rounded nav-icon">chevron_right</span><span class="nav-text">공지사항 관리</span></a>
                   <%--<a href="javascript:void(0);" class="nav-item" aria-disabled="true" title="준비중"><span class="material-symbols-rounded nav-icon">chevron_right</span><span class="nav-text">생활안내·운영정보</span></a>--%>
                    <a href="/manager/complex/broadcast/${mgmtOfcNo}" class="nav-item ${fn:contains(uri, '/manager/complex/broadcast') ? 'active' : ''}">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">방송 안내 관리</span>
                    </a>
                    <%--<a href="javascript:void(0);" class="nav-item" aria-disabled="true" title="준비중"><span class="material-symbols-rounded nav-icon">chevron_right</span><span class="nav-text">긴급 SMS 발송</span></a>--%>

                    <span class="sub-group-label">투표/설문</span>
                    <a href="${ctx}/manager/survey/${mgmtOfcNo}"
                       class="nav-item ${fn:contains(uri, '/manager/survey/') ? 'active' : ''}">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">투표·설문 관리</span>
                    </a>
                </div>
            </div>
        </details>

        <div class="section-divider"></div>
        <details class="nav-group" ${fn:contains(uri, '/manager/complex') or fn:contains(uri, '/manager/aptScheduleCalendar') ? 'open="open"' : ''}>
            <summary class="cat-btn">
                <span class="material-symbols-rounded nav-icon nav-icon-top">home_work</span>
                <span class="cat-label">단지 운영 관리</span>
                <span class="material-symbols-rounded cat-chevron">expand_more</span>
            </summary>
            <div class="submenu-wrap">
                <div class="submenu-inner">
                    <span class="sub-group-label">단지정보</span>
                    <a href="${ctx}/manager/complex/edit/${mgmtOfcNo}"
                       class="nav-item ${fn:contains(uri, '/manager/complex/edit') ? 'active' : ''}">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">단지 기본정보 관리</span>
                    </a>
                    <a href="${ctx}/manager/complex/buildingLayOut/${mgmtOfcNo}" class="nav-item ${fn:contains(uri, '/manager/comlex/buildingLayOut') ? 'active' : ''}">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">단지 구조 관리</span>
                    </a>
                    <span class="sub-group-label">일정</span>
                    <a href="${ctx}/manager/aptScheduleCalendar${mgmtPath}"
                       class="nav-item ${fn:contains(uri, '/manager/aptScheduleCalendar') ? 'active' : ''}">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">단지 일정 캘린더</span>
                    </a>
                </div>
            </div>
        </details>
    </nav>

    <div class="admin-card">
        <div class="admin-avatar">
            <span class="material-symbols-rounded" style="color:#fff; font-size:16px;">person</span>
        </div>
        <div class="admin-info">
            <p><sec:authentication property="principal.member.userNm"/></p>
            <span>
                <c:choose>
                    <c:when test="${not empty office.mgmtOfcNm}">${office.mgmtOfcNm}</c:when>
                    <c:when test="${not empty office.aptCmplexNm}">${office.aptCmplexNm}</c:when>
                    <c:otherwise>관리사무소</c:otherwise>
                </c:choose>
            </span>
        </div>
        <a href="${ctx}/manager/main${mgmtPath}" class="icon-btn" title="메인">
            <span class="material-symbols-rounded">home</span>
        </a>
    </div>
</aside>

<style>
    .facility-parent {
        display: flex;
        align-items: center;
        cursor: pointer;
    }

    .facility-parent-link {
        flex: 1;
        color: inherit;
        text-decoration: none;
    }

    .facility-parent-arrow {
        margin-left: auto;
        font-size: 18px;
        transition: transform .2s ease;
    }

    .facility-child-wrap {
        display: none;
        margin-left: 18px;
        padding-left: 8px;
        border-left: 1px solid rgba(255,255,255,0.1);
    }

    .facility-child-wrap.is-open {
        display: block;
    }

    .facility-parent.is-open .facility-parent-arrow {
        transform: rotate(180deg);
    }

    .child-nav-item {
        padding-left: 10px;
    }

    .facility-child-wrap.is-open {
        display: block;
    }
</style>


<%--<script>--%>
<%--    document.addEventListener("DOMContentLoaded", function () {--%>
<%--        var sidebar = document.getElementById("sidebar");--%>
<%--        var toggleBtn = document.getElementById("sidebarToggleBtn");--%>
<%--        var logoArea = document.querySelector(".sidebar-logo");--%>
<%--        var groups = Array.prototype.slice.call(document.querySelectorAll(".nav-group"));--%>
<%--        var currentPath = window.location.pathname;--%>

<%--        /* 현재 주소와 일치하는 메뉴만 active 처리 */--%>
<%--        document.querySelectorAll(".nav-item").forEach(function (item) {--%>
<%--            var href = item.getAttribute("href");--%>

<%--            item.classList.remove("active");--%>

<%--            /* 준비중 메뉴, # 메뉴는 주소 비교에서 제외 */--%>
<%--            if (!href || href === "#" || href.indexOf("javascript:") === 0) {--%>
<%--                return;--%>
<%--            }--%>

<%--            var linkPath;--%>

<%--            try {--%>
<%--                linkPath = new URL(item.href, window.location.origin).pathname;--%>
<%--            } catch (e) {--%>
<%--                return;--%>
<%--            }--%>

<%--            if (linkPath === currentPath) {--%>
<%--                item.classList.add("active");--%>

<%--                var activeGroup = item.closest(".nav-group");--%>

<%--                groups.forEach(function (group) {--%>
<%--                    group.removeAttribute("open");--%>
<%--                });--%>

<%--                if (activeGroup) {--%>
<%--                    activeGroup.setAttribute("open", "open");--%>
<%--                }--%>
<%--            }--%>
<%--        });--%>

<%--        /* 사이드바 접기 버튼 */--%>
<%--        if (toggleBtn && sidebar) {--%>
<%--            toggleBtn.addEventListener("click", function (e) {--%>
<%--                e.stopPropagation();--%>
<%--                sidebar.classList.toggle("collapsed");--%>
<%--            });--%>
<%--        }--%>

<%--        /* 로고 영역 클릭 시 사이드바 접기 */--%>
<%--        if (logoArea && sidebar) {--%>
<%--            logoArea.style.cursor = "pointer";--%>
<%--            logoArea.addEventListener("click", function (e) {--%>
<%--                if (!e.target.closest("#sidebarToggleBtn")) {--%>
<%--                    sidebar.classList.toggle("collapsed");--%>
<%--                }--%>
<%--            });--%>
<%--        }--%>

<%--        /* 카테고리 클릭 시 클릭한 그룹만 열기 */--%>
<%--        document.querySelectorAll(".nav-group > summary").forEach(function (summary) {--%>
<%--            summary.addEventListener("click", function (e) {--%>
<%--                e.preventDefault();--%>

<%--                var group = summary.closest(".nav-group");--%>
<%--                var isOpen = group.hasAttribute("open");--%>

<%--                groups.forEach(function (otherGroup) {--%>
<%--                    otherGroup.removeAttribute("open");--%>
<%--                });--%>

<%--                if (!isOpen) {--%>
<%--                    group.setAttribute("open", "open");--%>
<%--                }--%>
<%--            });--%>
<%--        });--%>

<%--        /* 메뉴 클릭 시 active 하나만 유지 */--%>
<%--        document.querySelectorAll(".nav-item").forEach(function (item) {--%>
<%--            item.addEventListener("click", function () {--%>
<%--                if (item.getAttribute("aria-disabled") === "true") {--%>
<%--                    return;--%>
<%--                }--%>

<%--                document.querySelectorAll(".nav-item").forEach(function (otherItem) {--%>
<%--                    otherItem.classList.remove("active");--%>
<%--                });--%>

<%--                item.classList.add("active");--%>

<%--                var group = item.closest(".nav-group");--%>

<%--                groups.forEach(function (otherGroup) {--%>
<%--                    if (otherGroup !== group) {--%>
<%--                        otherGroup.removeAttribute("open");--%>
<%--                    }--%>
<%--                });--%>

<%--                if (group) {--%>
<%--                    group.setAttribute("open", "open");--%>
<%--                }--%>
<%--            });--%>
<%--        });--%>
<%--    });--%>

<%--    var publicFacilityToggle = document.getElementById("publicFacilityToggle");--%>
<%--    var publicFacilityChild = document.getElementById("publicFacilityChild");--%>

<%--    if (publicFacilityToggle && publicFacilityChild) {--%>
<%--        publicFacilityToggle.addEventListener("click", function (e) {--%>
<%--            if (e.target.closest(".facility-parent-link")) {--%>
<%--                return;--%>
<%--            }--%>

<%--            e.preventDefault();--%>

<%--            publicFacilityChild.classList.toggle("is-open");--%>
<%--            publicFacilityToggle.classList.toggle("is-open");--%>
<%--        });--%>

<%--        if (publicFacilityChild.classList.contains("is-open")) {--%>
<%--            publicFacilityToggle.classList.add("is-open");--%>
<%--        }--%>
<%--    }--%>

<%--</script>--%>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        var sidebar = document.getElementById("sidebar");
        var toggleBtn = document.getElementById("sidebarToggleBtn");
        var logoArea = document.querySelector(".sidebar-logo");
        var groups = Array.prototype.slice.call(document.querySelectorAll(".nav-group"));
        var currentPath = window.location.pathname;

        var publicFacilityToggle = document.getElementById("publicFacilityToggle");
        var publicFacilityChild = document.getElementById("publicFacilityChild");

        /*
         * 현재 페이지가 편의시설 관련 주소이면
         * 시설·공사 관리 그룹과 편의시설 하위 메뉴를 강제로 열어둔다.
         */
        if (currentPath.indexOf("/manager/publicFacility") > -1) {
            var facilityGroup = null;

            groups.forEach(function (group) {
                if (group.querySelector("#publicFacilityToggle")) {
                    facilityGroup = group;
                }
            });

            if (facilityGroup) {
                facilityGroup.setAttribute("open", "open");
            }

            if (publicFacilityChild) {
                publicFacilityChild.classList.add("is-open");
            }

            if (publicFacilityToggle) {
                publicFacilityToggle.classList.add("is-open");

                /*
                 * 편의시설 등록/수정/상세처럼 /page가 아닌 편의시설 화면에서도
                 * 부모 메뉴가 현재 메뉴로 표시되도록 active를 보정한다.
                 */
                if (currentPath.indexOf("/manager/publicFacility/reservation") === -1) {
                    publicFacilityToggle.classList.add("active");
                }
            }
        }

        /*
         * 현재 주소와 일치하는 메뉴만 active 처리
         */
        document.querySelectorAll(".nav-item").forEach(function (item) {

            /*
             * 편의시설 관리 부모 메뉴는 div라 href가 없고,
             * 아래 편의시설 전용 로직에서 active / open 상태를 따로 처리한다.
             */
            if (item.id === "publicFacilityToggle") {
                return;
            }

            var href = item.getAttribute("href");

            /*
             * 편의시설 관리는 div 메뉴라 href가 없습니다.
             * 그래서 여기서 active를 지우면 표시가 사라집니다.
             */
            if (!item.classList.contains("facility-parent")) {
                item.classList.remove("active");
            }

            if (!href || href === "#" || href.indexOf("javascript:") === 0) {
                return;
            }

            var linkPath;

            try {
                linkPath = new URL(item.href, window.location.origin).pathname;
            } catch (e) {
                return;
            }

            if (linkPath === currentPath) {
                item.classList.add("active");

                var activeGroup = item.closest(".nav-group");

                groups.forEach(function (group) {
                    group.removeAttribute("open");
                });

                if (activeGroup) {
                    activeGroup.setAttribute("open", "open");
                }

                /*
                 * 편의시설 하위 메뉴 클릭 후에도 하위 메뉴 유지
                 */
                if (currentPath.indexOf("/manager/publicFacility") > -1) {
                    var facilityGroup = null;

                    if (publicFacilityToggle) {
                        publicFacilityToggle.classList.add("is-open");

                        if (currentPath.indexOf("/manager/publicFacility/reservation") === -1) {
                            publicFacilityToggle.classList.add("active");
                        }
                    }

                    if (publicFacilityChild) {
                        publicFacilityChild.classList.add("is-open");
                    }
                }
            }
        });

        /*
         * 사이드바 접기 버튼
         */
        if (toggleBtn && sidebar) {
            toggleBtn.addEventListener("click", function (e) {
                e.stopPropagation();
                sidebar.classList.toggle("collapsed");
            });
        }

        /*
         * 로고 영역 클릭 시 사이드바 접기
         */
        if (logoArea && sidebar) {
            logoArea.style.cursor = "pointer";
            logoArea.addEventListener("click", function (e) {
                if (!e.target.closest("#sidebarToggleBtn")) {
                    sidebar.classList.toggle("collapsed");
                }
            });
        }

        /*
         * 큰 카테고리 클릭 시 해당 그룹만 열기
         */
        document.querySelectorAll(".nav-group > summary").forEach(function (summary) {
            summary.addEventListener("click", function (e) {
                e.preventDefault();

                var group = summary.closest(".nav-group");
                var isOpen = group.hasAttribute("open");

                groups.forEach(function (otherGroup) {
                    otherGroup.removeAttribute("open");
                });

                if (!isOpen) {
                    group.setAttribute("open", "open");
                }
            });
        });

        /*
         * 편의시설 관리 우측 화살표 클릭 시 하위 메뉴 열고 닫기
         */
        if (publicFacilityToggle && publicFacilityChild) {
            publicFacilityToggle.addEventListener("click", function (e) {
                if (e.target.closest(".facility-parent-link")) {
                    return;
                }

                e.preventDefault();

                publicFacilityChild.classList.toggle("is-open");
                publicFacilityToggle.classList.toggle("is-open");

                var group = publicFacilityToggle.closest(".nav-group");
                if (group) {
                    group.setAttribute("open", "open");
                }
            });
        }

        /*
         * 메뉴 클릭 시 active 처리
         * 단, 편의시설 하위 메뉴는 접히지 않도록 유지한다.
         */
        document.querySelectorAll(".nav-item").forEach(function (item) {

            /*
             * 편의시설 관리 부모 메뉴는 div 안에 링크가 들어있는 구조라
             * 일반 메뉴 클릭 로직까지 같이 타면 링크 이동과 토글 처리가 충돌한다.
             */
            if (item.id === "publicFacilityToggle") {
                return;
            }

            item.addEventListener("click", function () {
                if (item.getAttribute("aria-disabled") === "true") {
                    return;
                }

                document.querySelectorAll(".nav-item").forEach(function (otherItem) {
                    otherItem.classList.remove("active");
                });

                item.classList.add("active");

                var group = item.closest(".nav-group");

                groups.forEach(function (otherGroup) {
                    if (otherGroup !== group) {
                        otherGroup.removeAttribute("open");
                    }
                });

                if (group) {
                    group.setAttribute("open", "open");
                }

                if (item.closest("#publicFacilityChild")) {
                    if (publicFacilityChild) {
                        publicFacilityChild.classList.add("is-open");
                    }

                    if (publicFacilityToggle) {
                        publicFacilityToggle.classList.add("is-open");
                    }
                }
            });
        });
    });
</script>