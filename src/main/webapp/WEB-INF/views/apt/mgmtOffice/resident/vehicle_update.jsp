<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="sec"
           uri="http://www.springframework.org/security/tags" %>
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
    <title>차량 등록</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/office-layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/manager-common.css">

    
<style>
#vhclPage .page-body{
    max-width:1100px;
}
#vhclPage .form-panel{
    background:#fff;
    border-radius:var(--r-lg);
    border:1px solid var(--border);
    overflow:hidden;
}
#vhclPage .form-body{
    padding:28px;
}
#vhclPage .page-footer{
    display:flex;
    justify-content:flex-end;
    gap:10px;
    padding:20px 28px;
    border-top:1px solid var(--border);
    background:#fafafa;
}
#vhclPage .img-drop{
    border:2px dashed var(--border);
    border-radius:var(--r-sm);
    padding:26px;
    text-align:center;
    cursor:pointer;
}
#vhclPage .img-drop:hover{
    border-color:#265c30;
    background:#f0fdf4;
}
#vhclPage .img-drop .material-symbols-rounded{
    font-size:30px;
    margin-bottom:8px;
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
                        <h2>차량 수정</h2>
                        <p>등록된 차량 정보를 수정합니다</p>
                    </div>
                </div>

                <form method="post"
                      enctype="multipart/form-data"
                      action="${pageContext.request.contextPath}/manager/resident/auto/update">
                       <sec:csrfInput/>
                    <input type="hidden" name="mgmtOfcNo" value="${mgmtOfcNo}">
                    <input type="hidden" name="rsidVhclNo" value="${vehicle.rsidVhclNo}">

                    <div class="form-panel">

                        <div class="form-body">

                            <div class="form-section">

                                <div class="form-section-title">
                                    <span class="material-symbols-rounded">home</span>
                                    세대 정보
                                </div>

                                <div class="form-row cols-2">

                                    <div class="form-field">
                                        <label class="field-label">입주민 번호</label>
                                        <input type="text" class="form-input" name="userNo" value="${vehicle.userNo}">
                                    </div>

                                    <div class="form-field">
                                        <label class="field-label">세대 번호</label>
                                        <input type="text" class="form-input" name="hoNo" value="${vehicle.hoNo}">
                                    </div>

                                </div>

                            </div>

                            <div class="form-section">

                                <div class="form-section-title">
                                    <span class="material-symbols-rounded">directions_car</span>
                                    차량 정보
                                </div>

                                <div class="form-row cols-2">

                                    <div class="form-field">
                                        <label class="field-label">차량번호</label>
                                        <input type="text" class="form-input" name="vhclNo" value="${vehicle.vhclNo}">
                                    </div>

                                    <div class="form-field">
                                        <label class="field-label">차량명</label>
                                        <input type="text" class="form-input" name="vhclNm" value="${vehicle.vhclNm}">
                                    </div>

                                </div>

                            </div>

                            <div class="form-section">

                                <div class="form-section-title">
                                    <span class="material-symbols-rounded">attach_file</span>
                                    차량등록증 첨부
                                </div>

                                <div class="img-drop">
                                    <span class="material-symbols-rounded">upload_file</span>
                                    <p>클릭하여 파일 업로드</p>

                                    <input type="file"
                                           name="uploadFile"
                                           accept=".jpg,.jpeg,.png,.pdf">
                                </div>

                            </div>

                        </div>

                        <div class="page-footer">

                            <a href="${pageContext.request.contextPath}/manager/resident/auto/list/${mgmtOfcNo}"
                               class="btn btn-secondary">
                                목록
                            </a>

                            <button type="submit"
                                    class="btn btn-primary">
                                저장
                            </button>

                        </div>

                    </div>

                </form>

            </div>

        </main>

    </div>

</div>

</body>
</html>
