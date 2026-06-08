<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <meta name="_csrf" content="${_csrf.token}">
    <meta name="_csrf_header" content="${_csrf.headerName}">
    <title>차량등록 – 대덕아파트</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/headerStyle.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebarStyle.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footerStyle.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/apt/apt.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/member/resident/residentVhcl.css">

</head>
<body
        data-apt-cmplex-no="${aptCmplexNo}"
        data-user-no="${userNo}"
        data-member-type="${memberType}"
>
<%@ include file="/WEB-INF/views/include/apt_headerLayout.jsp" %>
<div class="main-shell">
    <%@ include file="/WEB-INF/views/include/apt_sidebarLayout.jsp" %>
    <main class="content-area">
        <div class="page-content-wrap">
            <div class="breadcrumb">
                <a href="${pageContext.request.contextPath}/">HOME</a>
                <span>›</span>
                <a href="javascript:void(0);">생활지원서비스</a>
                <span>›</span>
                <span class="cur">차량등록</span>
            </div>
            <h1 class="page-title">차량등록</h1>
            <p class="page-desc">차량 등록을 진행 하고, 등록 차량 목록을 확인할 수 있습니다.</p>
            <div style="display:flex; justify-content:flex-end; margin-bottom:16px;">
                <button class="btn-main" id="openModalBtn">
                    + 차량 등록
                </button>
            </div>
            <section>
                <div class="panel vhcl-table-wrap">
                    <div class="section-hd"><h3>등록한 차량 목록</h3><span>최근 등록</span></div>
                    <table class="data-table">
                        <thead>
                        <tr>
                            <th>번호</th>
                            <th>동</th>
                            <th>호</th>
                            <th>차량번호</th>
                            <th>차종</th>
                            <th>등록일</th>
                            <th>상태</th>
                            <th>관리</th>
                        </tr>
                        </thead>
                        <tbody>
                        </tbody>
                    </table>
                </div>
                <div id="pagination" class="btn-row" style="margin-top:auto;"></div>
            </section>

        </div>
    </main>
</div>
<div class="modal-wrap" id="vhclModal">
    <div class="modal-box">

        <div class="modal-header">
            <h3>차량 등록</h3>
            <button class="close-btn" id="closeModalBtn">×</button>
        </div>

        <div class="form-grid">

            <div class="th">차종</div>
            <div class="td">
                <input
                        id="vhclNmData"
                        class="fake-input"
                        placeholder="ex) 현대 아반떼"
                />
            </div>

            <div class="th">차량번호</div>
            <div class="td">
                <div style="display:flex; gap:8px;">
                    <input
                            id="vhclNoFront"
                            class="fake-input"
                            style="width:120px;"
                            maxlength="4"
                            placeholder="ex) 12가"
                    />
                    <input
                            id="vhclNoBack"
                            class="fake-input"
                            style="width:140px;"
                            maxlength="4"
                            placeholder="ex) 1234"
                            oninput="this.value=this.value.replace(/[^0-9]/g,'')"
                    />
                </div>

                <div class="field-guide">
                    차량번호 형식 : 12가 1234
                </div>
            </div>

            <div class="th">동 / 호수</div>
            <div class="td">

                <select id="hoSelect" class="fake-input">
                    <c:forEach var="apt" items="${aptList}">
                        <option value="${apt.hoNo}">
                                ${apt.dongNm}동 ${apt.ho}호
                        </option>
                    </c:forEach>
                </select>

            </div>

            <div class="th th-column">
                차량등록증
                <small>이미지 파일만 업로드 가능합니다</small>
            </div>

            <div class="td">

                <div id="uploadBox" class="upload-box">

                    <input
                            type="file"
                            id="fileInput"
                            hidden
                            accept="image/*"
                    >

                    <!-- 기본 상태 -->
                    <div class="upload-content">
                        <div class="plus">+</div>

                        <div class="text">
                            파일을 드래그하거나 클릭하여 업로드
                        </div>
                    </div>

                    <!-- 썸네일 -->
                    <div id="previewCard" class="preview-card">

                        <img
                                id="previewImg"
                                class="preview-img"
                        >

                        <button
                                type="button"
                                id="removeBtn"
                                class="remove-btn">
                            ×
                        </button>

                    </div>

                </div>

            </div>

        </div>

        <div class="btn-row">
            <button class="btn-main" id="registerBtn">
                차량 등록
            </button>
        </div>

    </div>
</div>
<%@ include file="/WEB-INF/views/include/apt_footerLayout.jsp" %>
<script src="${pageContext.request.contextPath}/js/member/resident/residentVhcl.js"></script>
</body>
</html>