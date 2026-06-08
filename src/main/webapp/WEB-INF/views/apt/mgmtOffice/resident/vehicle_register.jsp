<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">

<title>입주민 차량 등록</title>

<link rel="preconnect" href="https://fonts.googleapis.com"/>
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin/>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet"/>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/office-layout.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/manager-common.css">

<style>

:root{
    --main:#265c30;
    --main-light:#f3faf4;
    --border:#e5e7eb;
    --text:#111827;
    --muted:#6b7280;

    --wait-bg:#fff8db;
    --wait-text:#a16207;

    --aprv-bg:#dcfce7;
    --aprv-text:#166534;

    --rjct-bg:#fee2e2;
    --rjct-text:#b91c1c;

    --card-radius:20px;
}

*{
    box-sizing:border-box;
}

body{
    margin:0;
    font-family:'Noto Sans KR', sans-serif;
    background:#f5f7fb;
    color:var(--text);
}

#vhclRegisterPage .page-body{
    max-width:1400px;
    margin:0 auto;
}

#vhclRegisterPage .page-header{
    display:flex;
    justify-content:space-between;
    align-items:center;
    margin-bottom:24px;
}

#vhclRegisterPage .page-title h2{
    margin:0;
    font-size:32px;
    font-weight:800;
}

#vhclRegisterPage .page-title p{
    margin-top:8px;
    color:var(--muted);
    font-size:15px;
}

.status-badge{
    display:inline-flex;
    align-items:center;
    gap:6px;
    padding:10px 16px;
    border-radius:999px;
    font-size:14px;
    font-weight:700;
}

.status-badge.wait{
    background:var(--wait-bg);
    color:var(--wait-text);
}

.form-grid{
    display:grid;
    grid-template-columns:1fr 1fr;
    gap:24px;
}

.info-card{
    background:#fff;
    border:1px solid var(--border);
    border-radius:var(--card-radius);
    overflow:hidden;
    box-shadow:0 4px 12px rgba(0,0,0,0.04);
}

.card-header{
    display:flex;
    align-items:center;
    gap:10px;
    padding:20px 24px;
    border-bottom:1px solid var(--border);
    background:#fafafa;
}

.card-header .material-symbols-rounded{
    font-size:24px;
    color:var(--main);
}

.card-header h3{
    margin:0;
    font-size:18px;
    font-weight:700;
}

.card-body{
    padding:24px;
}

.form-row{
    display:grid;
    gap:18px;
    margin-bottom:18px;
}

.cols-2{
    grid-template-columns:1fr 1fr;
}

.cols-3{
    grid-template-columns:1fr 1fr 1fr;
}

.form-field{
    display:flex;
    flex-direction:column;
    gap:8px;
}

.form-field label{
    font-size:14px;
    font-weight:700;
    color:#374151;
}

.form-input,
.form-select,
.form-textarea{
    width:100%;
    border:1px solid #d1d5db;
    border-radius:12px;
    padding:14px 16px;
    font-size:15px;
    background:#fff;
    transition:.2s;
}

.form-input:focus,
.form-select:focus,
.form-textarea:focus{
    outline:none;
    border-color:var(--main);
    box-shadow:0 0 0 4px rgba(38,92,48,0.1);
}

.form-textarea{
    min-height:120px;
    resize:none;
}

.readonly-box{
    background:#f9fafb;
}

.info-inline{
    display:flex;
    align-items:center;
    gap:10px;
    margin-top:4px;
    color:#6b7280;
    font-size:13px;
}

.upload-box{
    display:flex;
    align-items:center;
    justify-content:flex-start;
    gap:24px;

    width:100%;

    border:2px dashed #cbd5e1;
    border-radius:18px;

    padding:28px;

    background:#fafafa;
    cursor:pointer;
    transition:.2s;
}

.upload-box:hover{
    border-color:var(--main);
    background:var(--main-light);
}

.upload-icon-box{
    width:92px;
    height:92px;

    border-radius:18px;

    background:#edf7ef;

    display:flex;
    align-items:center;
    justify-content:center;

    flex-shrink:0;
}

.upload-icon-box .material-symbols-rounded{
    font-size:46px;
    color:var(--main);
}

.upload-content{
    flex:1;
}

.upload-title{
    font-size:18px;
    font-weight:800;
    margin-bottom:8px;
}

.upload-desc{
    font-size:14px;
    color:#6b7280;
    line-height:1.5;
}

.upload-preview{
    margin-top:16px;
    padding:14px 16px;

    border-radius:12px;
    border:1px solid #dbe3ea;

    background:#f9fafb;

    display:none;
}

.upload-preview.active{
    display:block;
}
.status-select-wrap{
    display:flex;
    gap:12px;
}

.status-option{
    width:120px;
}

.status-label{
    display:flex;
    align-items:center;
    justify-content:center;

    height:52px;

    border:1px solid #d1d5db;
    border-radius:14px;

    cursor:pointer;

    transition:.2s;

    font-weight:700;
}

.status-option input{
    display:none;
}

.status-label{
    border:1px solid #d1d5db;
    border-radius:14px;
    padding:16px;
    text-align:center;
    cursor:pointer;
    transition:.2s;
    font-weight:700;
}

.status-option input:checked + .status-label{
    border-color:var(--main);
    background:var(--main-light);
    color:var(--main);
}

.reject-box{
    display:none;
}
.page-footer{
    width:100%;

    margin-top:28px;

    display:flex;
    justify-content:flex-end;
    align-items:center;

    gap:12px;
}

.page-footer .btn{
    width:auto !important;
    min-width:140px;
    height:54px;

    display:flex;
    align-items:center;
    justify-content:center;

    flex:none !important;
}
.btn{
    border:none;
    border-radius:14px;
    padding:15px 26px;
    font-size:15px;
    font-weight:700;
    cursor:pointer;
    transition:.2s;
    text-decoration:none;
}

.btn-secondary{
    background:#e5e7eb;
    color:#111827;
}

.btn-secondary:hover{
    background:#d1d5db;
}

.btn-primary{
    background:var(--main);
    color:#fff;
}

.btn-primary:hover{
    opacity:.92;
}

@media(max-width:1100px){

    .form-grid{
        grid-template-columns:1fr;
    }

}
.form-section-search{
    margin-bottom:24px;
}

.search-grid{
    display:grid;
    grid-template-columns:120px 120px 1fr 120px;
    gap:14px;
    align-items:end;
}

.search-name-field{
    min-width:0;
}

.resident-search-btn{
    height:52px;
    border:none;
    border-radius:12px;
    background:#265c30;
    color:#fff;
    font-size:15px;
    font-weight:700;
    cursor:pointer;

    display:flex;
    align-items:center;
    justify-content:center;
    gap:6px;

    transition:.2s;
}

.resident-search-btn:hover{
    opacity:.92;
}

.resident-result-box{
    margin-top:10px;
    padding-top:20px;
    border-top:1px solid #e5e7eb;
}
</style>

</head>

<body>

<div class="app-wrapper">

    <%@ include file="/WEB-INF/views/include/office_sidebar.jsp" %>

    <div class="main-wrap">

        <%@ include file="/WEB-INF/views/include/office_header.jsp" %>

        <main class="main-content">

            <div class="office-page" id="vhclRegisterPage">

                <div class="page-body">

                    <!-- HEADER -->
                    <div class="page-header">

                        <div class="page-title">
                            <h2>입주민 차량 등록</h2>
                            <p>입주민 차량 등록 및 승인 심사를 진행합니다.</p>
                        </div>

                        <div class="status-badge wait">
                            <span class="material-symbols-rounded">schedule</span>
                            승인대기
                        </div>

                    </div>

                    <form method="post"
                          id="vehicleRegisterForm"
                          enctype="multipart/form-data"
                          action="${pageContext.request.contextPath}/manager/resident/auto/register">

                    <sec:csrfInput/>

                    <input type="hidden" name="mgmtOfcNo" value="${mgmtOfcNo}">
                    <input type="hidden" id="searchMgmtOfcNo" value="${mgmtOfcNo}">

                   <div class="form-grid">

    <!-- LEFT -->
    <div>

        <!-- 세대 정보 -->
        <div class="info-card">

            <div class="card-header">
                <span class="material-symbols-rounded">home</span>
                <h3>세대 / 입주민 정보</h3>
            </div>

            <div class="card-body">

                <!-- 검색 영역 -->
                <div class="form-section-search">

                    <div class="search-grid">

                   <div class="form-field">
    <label>동</label>

    <input type="text"
           class="form-input"
           id="dongNo"
           name="dongNo"
           placeholder="101">
</div>

<div class="form-field">
    <label>호</label>

    <input type="text"
           class="form-input"
           id="hoNo"
           name="hoNo"
           placeholder="1001">
</div>

                        <div class="form-field search-name-field">
                            <label>입주민 이름</label>

                            <input type="text"
                                   class="form-input"
                                   id="residentName"
                                   placeholder="홍길동">
                        </div>

                        <button type="button"
                                class="resident-search-btn"
                                id="residentSearchBtn">

                            <span class="material-symbols-rounded">search</span>
                            조회

                        </button>

                    </div>

                </div>

                <!-- 조회 결과 -->
               <!-- 조회 결과 -->
<div class="resident-result-box">

    <div class="form-row cols-3">

        <!-- 사용자번호 -->
        <div class="form-field">
            <label>사용자번호</label>

            <input type="text"
                   class="form-input readonly-box"
                   id="userNo"
                   name="userNo"
                   readonly>
        </div>

        <!-- 입주자 여부 -->
        <div class="form-field">
            <label>입주자 여부</label>

            <input type="text"
                   class="form-input readonly-box"
                   id="residentYn"
                   readonly>
        </div>

        <!-- 세대주 여부 -->
        <div class="form-field">
            <label>세대주 여부</label>

            <input type="text"
                   class="form-input readonly-box"
                   id="headYn"
                   readonly>
        </div>

    </div>

</div>
            </div>

        </div>

        <!-- 차량 정보 -->
        <div class="info-card" style="margin-top:24px;">

            <div class="card-header">
                <span class="material-symbols-rounded">directions_car</span>
                <h3>차량 정보</h3>
            </div>

            <div class="card-body">

                <div class="form-row cols-2">

                    <div class="form-field">
                        <label>차량번호</label>

                        <input type="text"
                               class="form-input"
                               name="vhclNo"
                               placeholder="123가1234">
                    </div>

                    <div class="form-field">
                        <label>차량명</label>

                        <input type="text"
                               class="form-input"
                               name="vhclNm"
                               placeholder="예: 그랜저">
                    </div>

                </div>

                <div class="form-row cols-2">




                </div>

            </div>

        </div>

    </div>

    <!-- RIGHT -->
    <div>

        <!-- 첨부파일 -->
        <div class="info-card">

            <div class="card-header">
                <span class="material-symbols-rounded">upload_file</span>
                <h3>차량 등록증 첨부</h3>
            </div>

            <div class="card-body">

                <label class="upload-box">

                    <div class="upload-icon-box">

                        <span class="material-symbols-rounded">
                            cloud_upload
                        </span>

                    </div>

                    <div class="upload-content">

                        <div class="upload-title">
                            차량등록증 업로드
                        </div>

                        <div class="upload-desc">
                            JPG / PNG / PDF 업로드 가능<br>
                            최대 업로드 용량 10MB
                        </div>

                    </div>

                    <input type="file"
                           id="uploadFile"
                           name="uploadFile"
                           accept=".jpg,.jpeg,.png,.pdf"
                           required
                           hidden>

                </label>

                <div class="upload-preview" id="uploadPreview"></div>

            </div>

        </div>


    </div>

</div>

<!-- FOOTER -->
<div class="page-footer">

    <a href="${pageContext.request.contextPath}/manager/resident/auto/list/${mgmtOfcNo}"
       class="btn btn-secondary">
        목록
    </a>

    <button type="submit"
            class="btn btn-primary">
        차량 등록
    </button>

</div>


                    </form>

                </div>

            </div>

        </main>

    </div>

</div>

<script>
    const ctx = '${pageContext.request.contextPath}';

const uploadFile = document.getElementById('uploadFile');
const uploadPreview = document.getElementById('uploadPreview');
const vehicleRegisterForm = document.getElementById('vehicleRegisterForm');

uploadFile.addEventListener('change', function(){

    if(this.files.length > 0){

        uploadPreview.classList.add('active');
        uploadPreview.innerHTML =
            '<strong>업로드 파일 :</strong> ' + this.files[0].name;

    }

});

vehicleRegisterForm.addEventListener('submit', function(event) {
    if (!uploadFile.files || uploadFile.files.length === 0) {
        event.preventDefault();
        alert('차량등록증을 업로드해 주세요.');
    }
});

document.getElementById('residentSearchBtn')
    .addEventListener('click', async function(){

        const dongNo = document.getElementById('dongNo').value;
        const hoNo = document.getElementById('hoNo').value;
        const residentName = document.getElementById('residentName').value;

        if(!dongNo || !hoNo || !residentName){

            alert('동 / 호 / 입주민 이름을 입력하세요.');
            return;
        }

        try{

            const mgmtOfcNo = document.getElementById('searchMgmtOfcNo').value;
            const url =
                ctx + "/manager/resident/auto/search"
                + "?mgmtOfcNo=" + encodeURIComponent(mgmtOfcNo)
                + "&dongNo=" + encodeURIComponent(dongNo)
                + "&hoNo=" + encodeURIComponent(hoNo)
                + "&residentName=" + encodeURIComponent(residentName);

            const response = await fetch(url);

            if(!response.ok){
                throw new Error();
            }

            const text = await response.text();

            console.log(text);

            if(!text || text.trim() === ''){

                alert('조회 결과가 없습니다.');
                return;
            }
            const data = JSON.parse(text);

            console.log(data);

            const userNo = data.userNo || data.USER_NO || '';
            const inoutCd = data.inoutCd || data.INOUT_CD || '';
            const headYn = data.headYn || data.HEAD_YN || '';

            document.getElementById('userNo').value =
                userNo;

            document.getElementById('residentYn').value =
                inoutCd === 'LIVE'
                    ? '입주중'
                    : '퇴거';

            document.getElementById('headYn').value =
                headYn === 'Y'
                    ? '세대주'
                    : '세대원';

        }catch(e){

            console.error(e);
            alert('입주민 조회 중 오류가 발생했습니다.');

        }

    });
</script>

</body>
</html>
