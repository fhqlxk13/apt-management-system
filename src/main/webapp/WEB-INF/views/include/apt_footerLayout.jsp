<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<footer class="site-footer">
    <div class="footer-inner">
        <div class="footer-top">
            <div>
                <div class="footer-logo">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"
                         stroke-linecap="round">
                        <path d="M3 9.5L12 3l9 6.5V20a1 1 0 01-1 1H4a1 1 0 01-1-1V9.5z"/>
                        <path d="M9 21V12h6v9"/>
                    </svg>
                    <div>
                        <div class="ko">${apt.aptCmplexNm}</div>
                        <div class="en">MY HOME MAPPING</div>
                    </div>
                </div>
                <div style="margin-top:14px; font-size:12px; color:rgba(255,255,255,.35); line-height:1.9;">
                    ${mgmtOffice.mgmtOfcNm}<br>
                    <%--사업자번호: 000-00-00000 | 등록번호: 제0000호--%>
                </div>
            </div>
            <nav class="footer-nav" style="align-self:flex-start; margin-top:8px;">
                <a href="${pageContext.request.contextPath}/apt/main/mgmtInfo/${apt.aptCmplexNo}">관리사무소</a>
                <a href="${pageContext.request.contextPath}/resident/bill/inquiry/${apt.aptCmplexNo}">아파트관리비</a>
                <a href="${pageContext.request.contextPath}/service/moving">생활지원서비스</a>
                <a href="/apt/complaint/apply.do/${apt.aptCmplexNo}">민원접수</a>
                <a href="${pageContext.request.contextPath}/vote/resident">전자투표및설문</a>
                <a href="${pageContext.request.contextPath}/resident/board/free/list/${aptCmplexNo}">입주민게시판</a>
            </nav>
            <div class="footer-contact">
                <div class="label">Contact Us</div>
                <div class="phone">
                    <c:choose>
                        <c:when test="${not empty mgmtOffice.mgmtOfcTelno}">
                            <div>
                                Tel.&nbsp;
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
                            </div>
                        </c:when>
                            <c:otherwise>
                                <div>
                                    <span class="label">관리사무소</span>
                                </div>
                            </c:otherwise>
                    </c:choose>
                </div>
                <div class="detail">
                    <c:if test="${not empty mgmtOffice.mgmtOfcEml}">
                        E-mail. ${mgmtOffice.mgmtOfcEml}
                    </c:if>
                </div>
            </div>
        </div>
        <div class="footer-bottom">
            <div class="footer-info">
                고객센터 : 042-000-0000 | 이메일 : steven_zips@ddit.or.kr
            </div>
            <div class="footer-copy">© 2026 Steven.Zips All rights reserved.</div>
        </div>
    </div>
</footer>