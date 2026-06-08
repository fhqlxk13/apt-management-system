<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>전입신고 – 대덕아파트</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/headerStyle.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebarStyle.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footerStyle.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <style>
        body {font-family: 'Noto Sans KR', sans-serif !important;background: var(--bg);color: var(--text-dark);margin: 0;}
        .material-symbols-outlined { font-family: 'Material Symbols Outlined' !important; }
        .main-shell {display:flex;align-items:stretch;width:100%;min-height:calc(100vh - 114px);margin-top:114px;background:var(--bg);}
        .content-area {flex:1;min-width:0;padding:32px 40px 64px;}
        .page-content-wrap {max-width:1080px;width:100%;margin:0 auto;}
        .breadcrumb {display:flex;align-items:center;gap:6px;font-size:12px;color:var(--text-light);margin-bottom:18px;}
        .breadcrumb a {color:var(--text-light);text-decoration:none;} .breadcrumb .cur {color:var(--green-dark);font-weight:700;}
        .page-title {font-size:22px;font-weight:800;color:var(--text-dark);padding-bottom:14px;border-bottom:2px solid var(--green-dark);margin-bottom:16px;letter-spacing:-.4px;}
        .page-desc {font-size:13px;line-height:1.8;color:var(--text-light);margin-bottom:24px;}
        .hero-card,.card,.panel {background:var(--white);border:1px solid var(--border);border-radius:14px;box-shadow:0 10px 24px rgba(30,60,40,.05);}
        .section-hd {display:flex;align-items:center;justify-content:space-between;margin-bottom:14px;padding-bottom:10px;border-bottom:1px solid var(--border);}
        .section-hd h3 {margin:0;font-size:15px;font-weight:800;color:var(--text-dark);}
        .section-hd span {font-size:12px;color:var(--text-light);}
        .card,.panel {padding:20px;margin-bottom:20px;}
        .form-grid {display:grid;grid-template-columns:160px 1fr;border-top:1px solid var(--border);border-left:1px solid var(--border);overflow:hidden;border-radius:12px;}
        .form-grid .th,.form-grid .td {padding:14px 16px;border-right:1px solid var(--border);border-bottom:1px solid var(--border);}
        .form-grid .th {background:var(--green-pale);color:var(--text-mid);font-size:13px;font-weight:700;}
        .fake-input,.fake-select,.fake-textarea {width:100%;border:1px solid #d8ddd4;background:#fff;border-radius:10px;padding:11px 13px;font-size:13px;color:var(--text-dark);box-sizing:border-box;}
        .fake-textarea {min-height:110px;resize:vertical;}
        .btn-row {display:flex;justify-content:center;gap:10px;margin-top:22px;flex-wrap:wrap;}
        .btn-main {display:inline-flex;align-items:center;justify-content:center;min-width:120px;padding:12px 18px;border-radius:10px;font-size:13px;font-weight:800;text-decoration:none;border:none;cursor:pointer;box-sizing:border-box;background:var(--green-dark);color:#fff;}
        @media (max-width:900px){.main-shell{flex-direction:column}.content-area{padding:24px 18px 48px}.page-content-wrap{max-width:100%}.form-grid{grid-template-columns:120px 1fr}}
    </style>
</head>
<body>
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
                <span class="cur">전입신고</span>
            </div>
            <h1 class="page-title">전입신고</h1>
            <p class="page-desc">전입신고 후 관리사무소 확인이 필요합니다.</p>

            <section class="panel">
                <div class="section-hd"><h3>전입신고서 작성</h3><span></span></div>
                <div class="form-grid">
                    <div class="th">동 / 호수 <span style="color: red;">*</span></div>
                    <div class="td">
                        <select id="hoSelect" class="fake-select">
                            <option value=""> 동 / 호수를 선택하세요</option>
                            <c:forEach var="ho" items="${hoList}">
                                <option value="${ho.HO_NO}">${ho.DONG_NM}동 ${ho.HO}호</option>
                            </c:forEach>
                        </select>
                    </div>
                    <%--<div class="th">입주자 성명</div>
                    <div class="td"><input class="fake-input" id="userNm" value="${principal.member.userNm}" readonly="readonly"/></div>
                    <div class="th">연락처</div>
                    <div class="td"><input class="fake-input" id="userTelno" value="${principal.member.userTelno}" readonly="readonly"/></div>--%>
                    <div class="th">입주일 <span style="color: red;">*</span></div>
                    <div class="td"><input class="fake-input" type="date" id="mvinPrdDt"/></div>
                    <div class="th">특이사항(선택)</div>
                    <div class="td"><textarea class="fake-textarea" id="spclCn" placeholder="특이사항을 입력해주세요."></textarea></div>
                </div>
                <div class="btn-row">
                    <button class="btn-main" onclick="submitMoveIn()">전입신고</button>
                </div>
            </section>

        </div>
    </main>
</div>
<%@ include file="/WEB-INF/views/include/apt_footerLayout.jsp" %>

<input type="hidden" id="aptCmplexNo" value="${aptCmplexNo}"/>
<input type="hidden" id="csrfToken" value="${_csrf.token}"/>
<input type="hidden" id="csrfHeader" value="${_csrf.headerName}"/>

<script>
    function submitMoveIn() {
        const hoNo = document.getElementById('hoSelect').value;
        const mvinPrdDt = document.getElementById('mvinPrdDt').value;
        const spclCn = document.getElementById('spclCn').value;

        if (!hoNo) {
            Swal.fire({
                icon: 'warning',
                title: '입력 필요',
                text: '동/호수를 선택해주세요.',
                confirmButtonText: '확인'
            });
            return;
        }
        if (!mvinPrdDt) {
            Swal.fire({
                icon: 'warning',
                title: '입력 필요',
                text: '입주 예정일을 선택해주세요.',
                confirmButtonText: '확인'
            });
            return;
        }

        const data = {
            aptCmplexNo: document.getElementById('aptCmplexNo').value,
            hoNo: hoNo,
            mvinPrdDt: mvinPrdDt,
            spclCn: spclCn
        };

        fetch('/resident/service/moving/in', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                [document.getElementById('csrfHeader').value]: document.getElementById('csrfToken').value
            },
            body: JSON.stringify(data)
        }).then(res => res.json()).then(result => {
            if (result.success) {
                Swal.fire({
                    icon: 'success',
                    title: '전입신고 완료',
                    text: '전입신고가 완료되었습니다.',
                    confirmButtonText: '확인'
                }).then(() => history.back());
            } else {
                Swal.fire({
                    icon: 'error',
                    title: '처리 실패',
                    text: '오류가 발생했습니다.',
                    confirmButtonText: '확인'
                });
            }
        });
    }
</script>
</body>
</html>
