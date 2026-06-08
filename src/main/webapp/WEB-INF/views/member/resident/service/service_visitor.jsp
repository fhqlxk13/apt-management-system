<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <meta name="_csrf" content="${_csrf.token}">
    <meta name="_csrf_header" content="${_csrf.headerName}">
    <title>방문자 차량등록 – 대덕아파트</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/headerStyle.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebarStyle.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footerStyle.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/apt/apt.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/member/resident/residentVstVhcl.css">
</head>
<body
        data-member-type="${memberType}"
>
<%@ include file="/WEB-INF/views/include/apt_headerLayout.jsp" %>

<div class="main-shell">
    <%@ include file="/WEB-INF/views/include/apt_sidebarLayout.jsp" %>
    <main class="content-area">
        <div class="page-content-wrap">

            <%--js 에서 쓰려고 data에 아파트정보 심어둠--%>
            <div id="pageData"
                 data-apt-cmplex-no="${aptInfo.aptComplexInfo.aptCmplexNo}"
                 data-apt-name="${aptInfo.aptComplexInfo.aptCmplexNm}">
            </div>

            <div class="breadcrumb">
                <a href="${pageContext.request.contextPath}/">HOME</a>
                <span>›</span>
                <a href="javascript:void(0);">생활지원서비스</a>
                <span>›</span>
                <span class="cur">방문자 차량등록</span>
            </div>
            <h1 class="page-title">방문자 차량등록</h1>
            <p class="page-desc">방문 예약을 할 수 있는 페이지 입니다.</p>

            <!-- 목록 -->
            <section class="panel">

                <div class="section-hd">
                    <h3>방문 차량 목록</h3>

                    <button type="button"
                            class="btn-main"
                            id="openModalBtn">
                        방문차량 등록하기
                    </button>
                </div>

                <div class="visit-table-wrap">

                    <table class="data-table">
                        <thead>
                        <tr>
                            <th>번호</th>
                            <th>방문자</th>
                            <th>차량번호</th>
                            <th>차량유형</th>
                            <th>방문목적</th>
                            <th>방문일시</th>
                            <th>체류시간</th>
                            <th>상태</th>
                            <th>관리</th>
                        </tr>
                        </thead>

                        <tbody id="visitTableBody">

                        </tbody>
                    </table>
                </div>
                <div class="paging-wrap">
                    <div id="pagingArea"></div>
                </div>
            </section>


            <!-- 등록 모달 -->
            <div class="modal-wrap"
                 id="visitModal">

                <div class="modal-box">

                    <div class="modal-header">

                        <h3>방문 차량 등록</h3>

                        <button type="button"
                                class="close-btn"
                                id="closeModalBtn">
                            ×
                        </button>

                    </div>

                    <div class="form-grid">

                        <div class="th">차량유형</div>
                        <div class="td">
                            <select id="vstVhclTyCd"
                                    class="fake-input">

                                <option value="">선택</option>

                                <option value="SEDAN">승용차</option>
                                <option value="SUV">SUV</option>
                                <option value="VAN">승합차</option>
                                <option value="LIGHT_TRUCK">소형트럭</option>
                                <option value="TRUCK">화물트럭</option>
                                <option value="BIKE">오토바이</option>
                            </select>
                        </div>

                        <div class="th th-column">

                            <span>
                                차량번호 뒷자리
                            </span>

                            <small>
                                차량 번호 뒤 4자리 입력
                            </small>

                        </div>

                        <div class="td">

                            <input type="text"
                                   id="vstVhclNo"
                                   class="fake-input"
                                   maxlength="4"
                                   inputmode="numeric"
                                   placeholder="숫자 4자리">

                        </div>

                        <div class="th">방문자명</div>
                        <div class="td">
                            <input type="text"
                                   id="vstRm"
                                   class="fake-input"
                                   placeholder="방문자명">
                        </div>

                        <div class="th">방문일시</div>

                        <div class="td">

                            <div class="visit-datetime-wrap">

                                <input type="date"
                                       id="visitDate"
                                       class="fake-input">

                                <select id="visitHour"
                                        class="fake-input">

                                    <option value="">
                                        시간 선택
                                    </option>

                                    <option value="00">00:00</option>
                                    <option value="01">01:00</option>
                                    <option value="02">02:00</option>
                                    <option value="03">03:00</option>
                                    <option value="04">04:00</option>
                                    <option value="05">05:00</option>
                                    <option value="06">06:00</option>
                                    <option value="07">07:00</option>
                                    <option value="08">08:00</option>
                                    <option value="09">09:00</option>
                                    <option value="10">10:00</option>
                                    <option value="11">11:00</option>
                                    <option value="12">12:00</option>
                                    <option value="13">13:00</option>
                                    <option value="14">14:00</option>
                                    <option value="15">15:00</option>
                                    <option value="16">16:00</option>
                                    <option value="17">17:00</option>
                                    <option value="18">18:00</option>
                                    <option value="19">19:00</option>
                                    <option value="20">20:00</option>
                                    <option value="21">21:00</option>
                                    <option value="22">22:00</option>
                                    <option value="23">23:00</option>

                                </select>

                            </div>

                        </div>

                        <div class="th">체류시간</div>

                        <div class="td">

                            <div class="stay-hour-wrap">

                                <input type="number"
                                       id="stayHr"
                                       class="fake-input"
                                       min="1"
                                       max="72"
                                       step="1"
                                       placeholder="최대 72">

                                <span class="time-unit">
                                    시간
                                </span>

                            </div>

                        </div>

                        <div class="th">방문목적</div>
                        <div class="td">
                            <input type="text"
                                   id="vstPrpsCn"
                                   class="fake-input"
                                   maxlength="20"
                                   placeholder="방문 목적">
                        </div>

                    </div>

                    <div class="btn-row">

                        <button type="button"
                                class="btn-sub"
                                id="closeModalBtn2">
                            취소
                        </button>

                        <button type="button"
                                class="btn-main"
                                id="registerVisitBtn">
                            등록하기
                        </button>

                    </div>

                </div>

            </div>


        </div>
    </main>
</div>
<%@ include file="/WEB-INF/views/include/apt_footerLayout.jsp" %>
<script src="${pageContext.request.contextPath}/js/member/resident/residentVstVhcl.js"></script>
</body>
</html>
