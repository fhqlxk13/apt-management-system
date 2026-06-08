<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">

    <link rel="preconnect" href="https://fonts.googleapis.com"/>
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin/>

    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap"
          rel="stylesheet"/>

    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0"
          rel="stylesheet"/>

    <title>입주민 차량 관리</title>

    <sec:csrfMetaTags/>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/office-layout.css">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/manager/manager-common.css">

    <style>

        #vhclPage .tab-bar {
            display: flex;
            gap: 10px;
            margin-bottom: 18px;
        }


        #vhclPage .tab-btn {
            border: none;
            background: none;
            padding: 0 0 12px;
            color: #888;
            font-size: 15px;
            font-weight: 700;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 6px;
            border-bottom: 2px solid transparent;
        }

        #vhclPage .tab-btn.active {

        }

        #vhclPage .tab-panel {
            display: none;
        }

        #vhclPage .tab-panel.active {
            display: block;
        }

        #vhclPage .filter-select {
            width: 140px;
        }

        #vhclPage .filter-keyword {
            width: 280px;
        }

        #vhclPage .col-center {
            text-align: center !important;
        }

        #vhclPage .col-manage {
            text-align: center !important;
            width: 220px;
        }

        #vhclPage .grid-actions {
            display: inline-flex;
            gap: 6px;
            align-items: center;
            flex-wrap: wrap;
        }

        #vhclPage .table-wrap {
            overflow: auto;
        }

        #vhclPage .empty-row {
            text-align: center !important;
            padding: 50px !important;
            color: var(--text-tertiary);
        }

    </style>
</head>

<body>

<div class="app-wrapper">

    <%@ include file="/WEB-INF/views/include/office_sidebar.jsp" %>

    <div class="main-wrap">

        <%@ include file="/WEB-INF/views/include/office_header.jsp" %>

        <main class="main-content">

            <div class="office-page" id="vhclPage">

                <div class="page-header">

                    <div class="page-title-block">
                        <h2>입주민 차량 관리</h2>
                        <p>등록 차량 조회 및 수정 관리</p>
                    </div>

                    <div class="page-actions">

                        <a href="${pageContext.request.contextPath}/manager/resident/auto/register/${mgmtOfcNo}"
                           class="btn btn-primary">

                            <span class="material-symbols-rounded">add</span>
                            차량 등록

                        </a>

                    </div>

                </div>

                <!-- 탭 -->

                <div class="tab-bar">

                    <button type="button"
                            class="tab-btn active"
                            data-tab="request">

                        <span class="material-symbols-rounded">inbox</span>
                        입주민 신청 목록

                    </button>

                    <button type="button"
                            class="tab-btn"
                            data-tab="all">

                        <span class="material-symbols-rounded">list</span>
                        전체 등록 차량

                    </button>

                </div>

                <!-- 요약 카드 -->

                <div class="summary-row">

                    <div class="summary-card s-green">

                        <div class="s-icon">
                            <span class="material-symbols-rounded">directions_car</span>
                        </div>

                        <div>
                            <div class="s-val">${totalCnt}</div>
                            <div class="s-label">전체 차량</div>
                        </div>

                    </div>

                    <div class="summary-card s-blue">

                        <div class="s-icon">
                            <span class="material-symbols-rounded">check_circle</span>
                        </div>

                        <div>
                            <div class="s-val">${aprvCnt}</div>
                            <div class="s-label">승인 완료</div>
                        </div>

                    </div>

                    <div class="summary-card s-yellow">

                        <div class="s-icon">
                            <span class="material-symbols-rounded">schedule</span>
                        </div>

                        <div>
                            <div class="s-val">${waitCnt}</div>
                            <div class="s-label">승인 대기</div>
                        </div>

                    </div>

                    <div class="summary-card s-red">

                        <div class="s-icon">
                            <span class="material-symbols-rounded">cancel</span>
                        </div>

                        <div>
                            <div class="s-val">${rjctCnt}</div>
                            <div class="s-label">반려</div>
                        </div>

                    </div>

                </div>

                <!-- 신청 목록 탭 -->

                <div class="tab-panel active"
                     id="tab-request">

                    <div class="filter-card">

                        <select class="form-select filter-select"
                                name="stts">

                            <option value="">처리상태 전체</option>
                            <option value="WAIT">승인대기</option>
                            <option value="APRV">승인완료</option>
                            <option value="RJCT">반려</option>

                        </select>

                        <div class="search-wrap filter-keyword">

                            <span class="material-symbols-rounded">search</span>

                            <input type="text"
                                   class="form-input"
                                   placeholder="입주민명 / 차량번호 검색">

                        </div>

                        <button type="button"
                                class="btn btn-primary">
                            조회
                        </button>

                    </div>

                    <div class="panel">

                        <div class="panel-header">

                            <div class="list-header-left">

                                <h3 class="panel-title">

                                    <span class="material-symbols-rounded">inbox</span>
                                    입주민 신청 목록

                                </h3>

                            </div>

                        </div>

                        <div class="table-wrap">

                            <table class="tbl">

                                <thead>

                                <tr>

                                    <th>입주민</th>
                                    <th>세대</th>
                                    <th>차량번호</th>
                                    <th>차량명</th>
                                    <th class="col-center">처리상태</th>
                                    <th class="col-center">관리</th>

                                </tr>

                                </thead>

                                <tbody>

                                <c:forEach items="${vehicleList}" var="item">

                                    <c:if test="${fn:contains(fn:trim(item.vhclSttsCd), 'WAIT')}">

                                        <tr>

                                            <td class="td-bold">${item.userNm}</td>
                                            <td>
                                                <c:out value="${empty item.unitDisplay ? item.hoNo : item.unitDisplay}"/>
                                            </td>
                                            <td class="td-mono">${item.vhclNo}</td>
                                            <td>${item.vhclNm}</td>

                                            <td class="col-center">

                                                <span class="badge badge-yellow">
                                                    승인대기
                                                </span>

                                            </td>

                                            <td class="col-manage">

                                                <div class="grid-actions">


                                                    <form method="post"
                                                          action="${pageContext.request.contextPath}/manager/resident/auto/approve"
                                                          style="display:inline;">

                                                        <sec:csrfInput/>

                                                        <input type="hidden"
                                                               name="rsidVhclNo"
                                                               value="${item.rsidVhclNo}">

                                                        <input type="hidden"
                                                               name="mgmtOfcNo"
                                                               value="${mgmtOfcNo}">

                                                        <button type="submit"
                                                                class="btn btn-xs btn-primary">
                                                            승인
                                                        </button>

                                                    </form>

                                                    <form method="post"
                                                          action="${pageContext.request.contextPath}/manager/resident/auto/reject"
                                                          style="display:inline;">

                                                        <sec:csrfInput/>

                                                        <input type="hidden"
                                                               name="rsidVhclNo"
                                                               value="${item.rsidVhclNo}">

                                                        <input type="hidden"
                                                               name="mgmtOfcNo"
                                                               value="${mgmtOfcNo}">

                                                        <button type="submit"
                                                                class="btn btn-xs btn-delete">
                                                            반려
                                                        </button>

                                                    </form>

                                                </div>

                                            </td>

                                        </tr>

                                    </c:if>

                                </c:forEach>

                                </tbody>

                            </table>

                        </div>

                    </div>

                </div>

                <!-- 전체 차량 탭 -->

                <div class="tab-panel"
                     id="tab-all">

                    <div class="panel">

                        <div class="panel-header">

                            <div class="list-header-left">

                                <h3 class="panel-title">

                                    <span class="material-symbols-rounded">directions_car</span>
                                    전체 등록 차량

                                </h3>

                                <span class="list-count">
                                    ${vehicleList.size()}건
                                </span>

                            </div>

                        </div>

                        <div class="table-wrap">

                            <table class="tbl">

                                <thead>

                                <tr>

                                    <th>입주민</th>
                                    <th>세대</th>
                                    <th>차량번호</th>
                                    <th>차량명</th>
                                    <th class="col-center">처리상태</th>
                                    <th class="col-center">관리</th>

                                </tr>

                                </thead>

                                <tbody>

                                <c:choose>

                                    <c:when test="${empty vehicleList}">

                                        <tr>

                                            <td colspan="6"
                                                class="empty-row">

                                                등록된 차량이 없습니다.

                                            </td>

                                        </tr>

                                    </c:when>

                                    <c:otherwise>

                                        <c:forEach items="${vehicleList}"
                                                   var="item">

                                            <tr>

                                                <td class="td-bold">${item.userNm}</td>
                                                <td>
                                                    <c:out value="${empty item.unitDisplay ? item.hoNo : item.unitDisplay}"/>
                                                </td>
                                                <td class="td-mono">${item.vhclNo}</td>
                                                <td>${item.vhclNm}</td>

                                                <td class="col-center">

                                                    <c:choose>

                                                        <c:when test="${fn:trim(item.vhclSttsCd) eq 'WAIT'}">
                                                            <span class="badge badge-yellow">승인대기</span>
                                                        </c:when>

                                                        <c:when test="${fn:trim(item.vhclSttsCd) eq 'APRV'}">
                                                            <span class="badge badge-green">승인완료</span>
                                                        </c:when>

                                                        <c:when test="${fn:trim(item.vhclSttsCd) eq 'RJCT'}">
                                                            <span class="badge badge-red">반려</span>
                                                        </c:when>

                                                    </c:choose>

                                                </td>

                                                <td class="col-manage">

                                                    <div class="grid-actions">


                                                        <a href="${pageContext.request.contextPath}/manager/resident/auto/update/${mgmtOfcNo}/${item.rsidVhclNo}"
                                                           class="btn btn-xs btn-edit">
                                                            수정</a>


                                                        <c:choose>

                                                            <c:when test="${fn:trim(item.vhclSttsCd) eq 'APRV'}">

                                                                <form method="post"
                                                                      action="${pageContext.request.contextPath}/manager/resident/auto/reject"
                                                                      style="display:inline;">

                                                                    <sec:csrfInput/>

                                                                    <input type="hidden"
                                                                           name="rsidVhclNo"
                                                                           value="${item.rsidVhclNo}">

                                                                    <input type="hidden"
                                                                           name="mgmtOfcNo"
                                                                           value="${mgmtOfcNo}">

                                                                    <button type="submit"
                                                                            class="btn btn-xs btn-delete">

                                                                        반려변경

                                                                    </button>

                                                                </form>

                                                            </c:when>

                                                            <c:when test="${fn:trim(item.vhclSttsCd) eq 'RJCT'}">

                                                                <form method="post"
                                                                      action="${pageContext.request.contextPath}/manager/resident/auto/approve"
                                                                      style="display:inline;">

                                                                    <sec:csrfInput/>

                                                                    <input type="hidden"
                                                                           name="rsidVhclNo"
                                                                           value="${item.rsidVhclNo}">

                                                                    <input type="hidden"
                                                                           name="mgmtOfcNo"
                                                                           value="${mgmtOfcNo}">

                                                                    <button type="submit"
                                                                            class="btn btn-xs btn-primary">

                                                                        승인변경

                                                                    </button>

                                                                </form>

                                                            </c:when>

                                                        </c:choose>


                                                        <form method="post"
                                                              action="${pageContext.request.contextPath}/manager/resident/auto/delete"
                                                              style="display:inline;"
                                                              onsubmit="return mgmtOfficeConfirmSubmit(event, { title: '삭제하시겠습니까?', confirmText: '삭제', confirmColor: '#c0392b' });">

                                                            <sec:csrfInput/>

                                                            <input type="hidden"
                                                                   name="rsidVhclNo"
                                                                   value="${item.rsidVhclNo}">

                                                            <input type="hidden"
                                                                   name="mgmtOfcNo"
                                                                   value="${mgmtOfcNo}">

                                                            <button type="submit"
                                                                    class="btn btn-xs btn-delete">

                                                                삭제

                                                            </button>

                                                        </form>

                                                    </div>

                                                </td>

                                            </tr>

                                        </c:forEach>

                                    </c:otherwise>

                                </c:choose>

                                </tbody>

                            </table>

                        </div>

                    </div>

                </div>

            </div>

        </main>

    </div>

</div>

<script>

    document.querySelectorAll('.tab-btn').forEach(btn => {

        btn.addEventListener('click', () => {

            document.querySelectorAll('.tab-btn')
                .forEach(b => b.classList.remove('active'));

            document.querySelectorAll('.tab-panel')
                .forEach(p => p.classList.remove('active'));

            btn.classList.add('active');

            const tabId =
                btn.dataset.tab === 'request'
                    ? 'tab-request'
                    : 'tab-all';

            document.getElementById(tabId)
                .classList.add('active');
        });
    });

</script>

</body>
</html>
