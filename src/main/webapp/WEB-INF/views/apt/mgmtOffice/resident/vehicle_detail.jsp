<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

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
    <title>차량 상세</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/office-layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/manager-common.css">

    <style>
        #vhclPage .detail-panel{
            background:#fff;
            border:1px solid var(--border);
            border-radius:var(--r-lg);
            padding:30px;
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
                        <h2>차량 상세</h2>
                        <p>등록 차량 상세 정보</p>
                    </div>
                </div>

                <div class="detail-panel">

                    <div class="mngr-detail-grid">

                        <div class="mngr-detail-item">
                            <div class="mngr-detail-label">입주민</div>
                            <div class="mngr-detail-value">${vehicle.userNm}</div>
                        </div>

                        <div class="mngr-detail-item">
                            <div class="mngr-detail-label">세대</div>
                            <div class="mngr-detail-value">
                                ${empty vehicle.unitDisplay ? vehicle.hoNo : vehicle.unitDisplay}
                            </div>
                        </div>

                        <div class="mngr-detail-item">
                            <div class="mngr-detail-label">차량번호</div>
                            <div class="mngr-detail-value">${vehicle.vhclNo}</div>
                        </div>

                        <div class="mngr-detail-item">
                            <div class="mngr-detail-label">차량명</div>
                            <div class="mngr-detail-value">${vehicle.vhclNm}</div>
                        </div>

                    </div>

                    <div style="display:flex;justify-content:flex-end;gap:10px;margin-top:30px;">

                        <a href="${pageContext.request.contextPath}/manager/resident/auto/list/${mgmtOfcNo}"
                           class="btn btn-secondary">
                            목록
                        </a>

                        <a href="${pageContext.request.contextPath}/manager/resident/auto/update/${mgmtOfcNo}/${vehicle.rsidVhclNo}"
                           class="btn btn-primary">
                            수정
                        </a>

                    </div>

                </div>

            </div>

        </main>

    </div>

</div>

</body>
</html>
