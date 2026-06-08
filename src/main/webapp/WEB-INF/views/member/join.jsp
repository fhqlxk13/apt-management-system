<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
    <meta name="_csrf" content="${_csrf.token}"/>

    <title>회원가입 | 우리집맵핑</title>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="${pageContext.request.contextPath}/js/common/file-util.js"></script>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet">

    <style>
        /* ============================================================
           우리집맵핑 회원가입 팝업
           - 공공 사용자 화면의 아이보리 배경 + 올리브 포인트 톤 적용
           - 기존 name/id 및 회원가입 JS 로직 유지
        ============================================================ */
        :root {
            --primary: #226046;
            --primary-dark: #226046;
            --primary-soft: #eef1e4;
            --primary-line: #d9dfc6;
            --bg: #f7f5f1;
            --card: #ffffff;
            --line: #e6e0d6;
            --line-strong: #d8d2c8;
            --text: #1f1f1f;
            --sub-text: #687079;
            --muted: #92969b;
            --danger: #c24136;
            --shadow: 0 22px 65px rgba(31, 31, 31, 0.07);
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: "Noto Sans KR", "Pretendard", "Malgun Gothic", sans-serif;
        }

        body {
            min-width: 360px;
            background: var(--bg);
            color: var(--text);
            font-size: 14px;
            line-height: 1.55;
            letter-spacing: -0.02em;
        }

        button, input, select {
            font: inherit;
        }

        button {
            cursor: pointer;
        }

        .join-page {
            min-height: 100vh;
            padding: 28px 32px 38px;
        }

        .brand-area {
            max-width: 1100px;
            margin: 0 auto 22px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .brand {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            color: var(--primary);
            font-size: 26px;
            font-weight: 800;
            letter-spacing: -0.06em;
        }

        .brand-mark {
            width: 34px;
            height: 34px;
            border-radius: 11px;
            background: var(--primary);
            position: relative;
        }

        .brand-mark::before {
            content: "";
            position: absolute;
            left: 8px;
            top: 11px;
            width: 18px;
            height: 14px;
            background: #fff;
            clip-path: polygon(50% 0, 100% 40%, 100% 100%, 0 100%, 0 40%);
        }

        .brand-guide {
            color: var(--muted);
            font-size: 13px;
            font-weight: 500;
        }

        .join-card {
            width: 100%;
            max-width: 1100px;
            margin: 0 auto;
            display: grid;
            grid-template-columns: 315px minmax(0, 1fr);
            background: var(--card);
            border: 1px solid var(--line);
            border-radius: 24px;
            overflow: hidden;
            box-shadow: var(--shadow);
        }

        /* ===================== 왼쪽 안내/프로필 영역 ===================== */
        .join-aside {
            position: relative;
            padding: 42px 32px;
            background:
                    radial-gradient(circle at 18% 10%, rgba(255,255,255,.55), transparent 34%),
                    linear-gradient(150deg, #eef1e5 0%, #e5ead7 100%);
            border-right: 1px solid var(--primary-line);
        }

        .join-aside::after {
            content: "";
            position: absolute;
            left: -65px;
            bottom: -78px;
            width: 210px;
            height: 210px;
            border-radius: 50%;
            border: 40px solid rgba(93, 111, 31, 0.055);
        }

        .page-badge {
            display: inline-flex;
            align-items: center;
            padding: 6px 13px;
            border: 1px solid var(--primary-line);
            border-radius: 999px;
            background: rgba(255, 255, 255, .62);
            color: var(--primary);
            font-size: 12px;
            font-weight: 700;
        }

        .join-aside h1 {
            margin-top: 18px;
            font-size: 32px;
            line-height: 1.25;
            letter-spacing: -0.07em;
        }

        .join-aside .intro {
            margin-top: 13px;
            color: #66704d;
            font-size: 13px;
            line-height: 1.75;
            word-break: keep-all;
        }

        .profile-card {
            position: relative;
            z-index: 1;
            width: 100%;
            max-width: 240px;
            margin: 34px auto 0;
            padding: 20px;
            border: 1px solid rgba(208, 215, 186, .9);
            border-radius: 18px;
            background: rgba(255, 255, 255, .72);
        }

        .profile-title {
            color: #3b432a;
            font-size: 14px;
            font-weight: 700;
            margin-bottom: 14px;
        }

        .photo-preview {
            width: 112px;
            height: 132px;
            margin: 0 auto 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
            border: 1px dashed #c9d1ad;
            border-radius: 14px;
            background: #fff;
            color: #a0a58d;
            font-size: 12px;
        }

        .photo-preview img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .photo-btn {
            width: 100%;
            height: 42px;
            border: 1px solid var(--primary-line);
            border-radius: 10px;
            background: #fff;
            color: var(--primary);
            font-size: 13px;
            font-weight: 700;
            transition: .18s;
        }

        .photo-btn:hover {
            background: var(--primary-soft);
        }

        #fileName {
            overflow: hidden;
            margin-top: 9px;
            color: #8c927d;
            font-size: 12px;
            text-align: center;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .aside-notice {
            position: relative;
            z-index: 1;
            margin-top: 22px;
            padding: 13px 14px;
            border-radius: 12px;
            background: rgba(255,255,255,.48);
            color: #66704d;
            font-size: 12px;
            line-height: 1.65;
        }

        /* ===================== 오른쪽 입력 폼 영역 ===================== */
        .join-form-panel {
            padding: 40px 46px 36px;
        }

        .panel-header {
            margin-bottom: 29px;
            padding-bottom: 20px;
            border-bottom: 1px solid var(--line);
        }

        .panel-header h2 {
            font-size: 25px;
            font-weight: 800;
            letter-spacing: -0.055em;
        }

        .panel-header p {
            margin-top: 7px;
            color: var(--sub-text);
            font-size: 13px;
        }

        .form-section {
            margin-bottom: 29px;
        }

        .section-title {
            display: flex;
            align-items: center;
            gap: 9px;
            margin-bottom: 17px;
            color: var(--primary);
            font-size: 14px;
            font-weight: 700;
        }

        .section-title::before {
            content: "";
            width: 4px;
            height: 15px;
            border-radius: 4px;
            background: var(--primary);
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 18px 16px;
        }

        .form-group {
            min-width: 0;
        }

        .form-group.full {
            grid-column: 1 / -1;
        }

        .form-label {
            display: block;
            margin-bottom: 8px;
            color: #35383b;
            font-size: 13px;
            font-weight: 600;
        }

        .required {
            margin-left: 3px;
            color: var(--danger);
        }

        .optional-text {
            margin-left: 5px;
            color: var(--muted);
            font-size: 12px;
            font-weight: 400;
        }

        .input-control {
            width: 100%;
            height: 49px;
            padding: 0 15px;
            border: 1px solid var(--line-strong);
            border-radius: 10px;
            outline: none;
            background: #fff;
            color: var(--text);
            font-size: 14px;
            transition: border-color .16s, box-shadow .16s, background .16s;
        }

        .input-control::placeholder {
            color: #afb1b2;
        }

        .input-control:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(93, 111, 31, .1);
        }

        .input-control:read-only {
            background: #faf9f7;
            color: #80858c;
        }

        .with-action {
            display: flex;
            gap: 8px;
        }

        .with-action .input-control {
            min-width: 0;
            flex: 1;
        }

        .btn-check {
            flex-shrink: 0;
            min-width: 92px;
            height: 49px;
            border: 1px solid var(--primary-line);
            border-radius: 10px;
            background: var(--primary-soft);
            color: var(--primary-dark);
            font-size: 13px;
            font-weight: 700;
            transition: .18s;
        }

        .btn-check:hover {
            border-color: var(--primary);
            background: #e6ebd6;
        }

        .input-hint {
            margin-top: 6px;
            color: var(--muted);
            font-size: 11px;
        }

        .split-input {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .split-input .input-control {
            min-width: 0;
        }

        .dash {
            flex-shrink: 0;
            color: #a2a69e;
            font-size: 14px;
        }

        /* ===================== 수신 동의 영역 ===================== */
        .receive-box {
            grid-column: 1 / -1;
            border: 1px solid var(--line);
            border-radius: 14px;
            overflow: hidden;
            background: #fdfcfb;
        }

        .toggle-group {
            min-height: 56px;
            padding: 0 17px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
        }

        .toggle-group + .toggle-group {
            border-top: 1px solid #efebe3;
        }

        .toggle-title {
            color: #363b3e;
            font-size: 13px;
            font-weight: 600;
        }

        .sub-toggle-area {
            display: none;
            padding: 0 13px 9px;
            background: #f9f8f4;
            border-top: 1px solid #efebe3;
        }

        .sub-toggle-area .toggle-group {
            min-height: 47px;
            padding: 0 7px;
        }

        .sub-toggle-area .toggle-title {
            color: var(--sub-text);
            font-size: 12px;
            font-weight: 500;
        }

        .switch {
            position: relative;
            display: inline-block;
            flex-shrink: 0;
            width: 45px;
            height: 25px;
        }

        .switch input {
            width: 0;
            height: 0;
            opacity: 0;
        }

        .slider {
            position: absolute;
            inset: 0;
            border-radius: 20px;
            background: #d7d4ce;
            transition: .2s;
        }

        .slider::before {
            content: "";
            position: absolute;
            left: 3px;
            top: 3px;
            width: 19px;
            height: 19px;
            border-radius: 50%;
            background: #fff;
            box-shadow: 0 1px 3px rgba(0,0,0,.12);
            transition: .2s;
        }

        .switch input:checked + .slider {
            background: var(--primary);
        }

        .switch input:checked + .slider::before {
            transform: translateX(20px);
        }

        /* ===================== 버튼 ===================== */
        .btn-area {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 33px;
            padding-top: 25px;
            border-top: 1px solid var(--line);
        }

        .btn-submit,
        .btn-cancel {
            height: 51px;
            padding: 0 34px;
            border-radius: 11px;
            font-size: 14px;
            font-weight: 700;
            transition: .18s;
        }

        .btn-submit {
            min-width: 148px;
            border: 1px solid var(--primary);
            background: var(--primary);
            color: #fff;
        }

        .btn-submit:hover {
            border-color: var(--primary-dark);
            background: var(--primary-dark);
        }

        .btn-cancel {
            min-width: 110px;
            border: 1px solid var(--line-strong);
            background: #fff;
            color: #5d6166;
        }

        .btn-cancel:hover {
            background: #f5f3ee;
        }

        @media (max-width: 920px) {
            .join-page {
                padding: 20px 16px 28px;
            }

            .brand-area {
                margin-bottom: 17px;
            }

            .brand-guide {
                display: none;
            }

            .join-card {
                display: block;
                border-radius: 18px;
            }

            .join-aside {
                border-right: none;
                border-bottom: 1px solid var(--primary-line);
                padding: 27px 25px;
            }

            .join-aside h1 {
                font-size: 27px;
            }

            .profile-card {
                max-width: 255px;
            }

            .join-form-panel {
                padding: 28px 23px 25px;
            }
        }

        @media (max-width: 600px) {
            .form-grid {
                grid-template-columns: 1fr;
            }

            .btn-area {
                flex-direction: column-reverse;
            }

            .btn-submit,
            .btn-cancel {
                width: 100%;
            }
        }
    </style>
</head>
<body>
<div class="join-page">
    <div class="brand-area">
        <a href="${pageContext.request.contextPath}/" class="brand-link">
            <div class="brand">
                <span class="brand-mark" aria-hidden="true"></span>
                우리집맵핑
            </div>
        </a>
        <span class="brand-guide">안전하고 편리한 공동주택 서비스</span>
    </div>

    <main class="join-card">
        <aside class="join-aside">
            <h1>회원가입</h1>

            <div class="profile-card">
                <div class="profile-title">프로필 사진 <span class="optional-text">(선택)</span></div>
                <div class="photo-preview" id="preview">미리보기</div>
                <button type="button" class="photo-btn" onclick="document.querySelector('#img').click();">사진 선택</button>
                <input type="file" id="img" name="profFile" form="joinForm" accept="image/*" style="display:none;">
                <div id="fileName">선택된 파일 없음</div>
            </div>

            <div class="aside-notice">
                입력하신 개인정보는 회원 서비스 이용 및 본인 확인 목적으로만 사용됩니다.
            </div>
        </aside>

        <section class="join-form-panel">
            <div class="panel-header">
                <h2>가입 정보 입력</h2>
                <p><span class="required">*</span> 표시는 필수 입력 항목입니다.</p>
            </div>

            <form action="${pageContext.request.contextPath}/member/join"
                  id="joinForm" method="post" enctype="multipart/form-data">

                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

                <section class="form-section">
                    <h3 class="section-title">계정 정보</h3>
                    <div class="form-grid">
                        <div class="form-group full">
                            <label class="form-label" for="userId">아이디 <span class="required">*</span></label>
                            <div class="with-action">
                                <input type="text" name="userId" id="userId" class="input-control"
                                       placeholder="영문, 숫자 조합 4~20자" autocomplete="username">
                                <button type="button" id="idCheckBtn" class="btn-check">중복확인</button>
                            </div>
                            <div class="input-hint">아이디를 입력한 후 중복확인을 진행해주세요.</div>
                            <input type="hidden" id="isIdChecked" value="N">
                        </div>

                        <div class="form-group">
                            <label class="form-label" for="userPw">비밀번호 <span class="required">*</span></label>
                            <input type="password" name="userPw" id="userPw" class="input-control"
                                   placeholder="비밀번호 입력" autocomplete="new-password">
                            <div class="input-hint">영문, 숫자, 특수문자 조합 8~20자</div>
                        </div>

                        <div class="form-group">
                            <label class="form-label" for="userPwConfirm">비밀번호 확인 <span class="required">*</span></label>
                            <input type="password" name="userPwConfirm" id="userPwConfirm" class="input-control"
                                   placeholder="비밀번호 다시 입력" autocomplete="new-password">
                        </div>
                    </div>
                </section>

                <section class="form-section">
                    <h3 class="section-title">기본 정보</h3>
                    <div class="form-grid">
                        <div class="form-group">
                            <label class="form-label" for="userNm">이름 <span class="required">*</span></label>
                            <input type="text" name="userNm" id="userNm" class="input-control"
                                   placeholder="이름을 입력하세요">
                        </div>

                        <div class="form-group">
                            <label class="form-label" for="userEml">이메일 <span class="required">*</span></label>
                            <input type="email" name="userEml" id="userEml" class="input-control"
                                   placeholder="example@email.com">
                        </div>

                        <div class="form-group full">
                            <label class="form-label" for="rrno1">주민등록번호 <span class="required">*</span></label>
                            <input type="hidden" name="userRrno" id="userRrno">
                            <div class="split-input">
                                <input type="text" class="input-control" id="rrno1" name="rrno1"
                                       maxlength="6" inputmode="numeric" placeholder="앞자리 6자">
                                <span class="dash">-</span>
                                <input type="password" class="input-control" id="rrno2" name="rrno2"
                                       maxlength="7" inputmode="numeric" placeholder="뒷자리 7자">
                            </div>
                        </div>

                        <div class="form-group full">
                            <label class="form-label" for="tel1">연락처 <span class="required">*</span></label>
                            <div class="split-input">
                                <select id="tel1" class="input-control" aria-label="휴대전화 앞자리">
                                    <option value="010" selected>010</option>
                                    <option value="011">011</option>
                                    <option value="016">016</option>
                                    <option value="017">017</option>
                                    <option value="018">018</option>
                                    <option value="019">019</option>
                                </select>
                                <span class="dash">-</span>
                                <input type="text" class="input-control" id="tel2" maxlength="4"
                                       inputmode="numeric" aria-label="휴대전화 중간자리" placeholder="0000">
                                <span class="dash">-</span>
                                <input type="text" class="input-control" id="tel3" maxlength="4"
                                       inputmode="numeric" aria-label="휴대전화 끝자리" placeholder="0000">
                            </div>
                            <input type="hidden" name="userTelno" id="userTelno">
                        </div>
                    </div>
                </section>

                <section class="form-section">
                    <h3 class="section-title">알림 수신 설정</h3>
                    <div class="form-grid">
                        <div class="receive-box">
                            <div class="toggle-group">
                                <span class="toggle-title">SMS 수신여부 <span class="optional-text">(선택)</span></span>
                                <label class="switch">
                                    <input type="checkbox" id="smsRcvYn" name="smsRcvYn">
                                    <span class="slider"></span>
                                </label>
                            </div>
                            <div id="subSmsArea" class="sub-toggle-area">
                                <div class="toggle-group">
                                    <span class="toggle-title">공지사항 알림</span>
                                    <label class="switch">
                                        <input type="checkbox" id="smsNtcRcvYn" name="smsNtcRcvYn">
                                        <span class="slider"></span>
                                    </label>
                                </div>
                                <div class="toggle-group">
                                    <span class="toggle-title">계약관련 알림</span>
                                    <label class="switch">
                                        <input type="checkbox" id="smsCtrtRcvYn" name="smsCtrtRcvYn">
                                        <span class="slider"></span>
                                    </label>
                                </div>
                            </div>
                        </div>

                        <div class="receive-box">
                            <div class="toggle-group">
                                <span class="toggle-title">e-mail 수신여부 <span class="optional-text">(선택)</span></span>
                                <label class="switch">
                                    <input type="checkbox" id="emlRcvYn" name="emlRcvYn">
                                    <span class="slider"></span>
                                </label>
                            </div>
                            <div id="subEmlArea" class="sub-toggle-area">
                                <div class="toggle-group">
                                    <span class="toggle-title">공지사항 알림</span>
                                    <label class="switch">
                                        <input type="checkbox" id="emlNtcRcvYn" name="emlNtcRcvYn">
                                        <span class="slider"></span>
                                    </label>
                                </div>
                                <div class="toggle-group">
                                    <span class="toggle-title">계약관련 알림</span>
                                    <label class="switch">
                                        <input type="checkbox" id="emlCtrtRcvYn" name="emlCtrtRcvYn">
                                        <span class="slider"></span>
                                    </label>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>

                <%-- 동기 방식 submit으로 변경할 경우 사용: <sec:csrfInput/> --%>
                <div class="btn-area">
                    <button type="button" class="btn-cancel" onclick="window.close()">취소</button>
                    <button type="submit" class="btn-submit" id="memRegBtn">회원가입 완료</button>
                </div>
            </form>
        </section>
    </main>
</div>

<script type="module">
    document.addEventListener('DOMContentLoaded', function () {
        const contextPath = '${pageContext.request.contextPath}';
        function swalWarn(message) {
            return Swal.fire({
                icon: 'warning',
                title: '입력 확인',
                text: message,
                confirmButtonText: '확인'
            });
        }

        function swalSuccess(message) {
            return Swal.fire({
                icon: 'success',
                title: '완료',
                text: message,
                confirmButtonText: '확인'
            });
        }

        function swalError(message) {
            return Swal.fire({
                icon: 'error',
                title: '오류',
                text: message,
                confirmButtonText: '확인'
            });
        }

        /**
         * 부모 알림 동의 스위치를 켜면 상세 동의를 노출하고 모두 체크한다.
         * 부모 스위치를 끄면 상세 동의를 숨기고 모두 해제한다.
         */
        function bindReceiveToggle(parentId, detailId) {
            const parentSwitch = document.querySelector(parentId);
            const detailArea = document.querySelector(detailId);

            parentSwitch.addEventListener('change', function () {
                detailArea.style.display = this.checked ? 'block' : 'none';
                detailArea.querySelectorAll('input[type="checkbox"]').forEach(function (checkbox) {
                    checkbox.checked = parentSwitch.checked;
                });
            });
        }

        bindReceiveToggle('#smsRcvYn', '#subSmsArea');
        bindReceiveToggle('#emlRcvYn', '#subEmlArea');

        // 아이디 중복확인
        const idCheckBtn = document.querySelector('#idCheckBtn');
        idCheckBtn.addEventListener('click', async function (e) {
            e.preventDefault();

            const form = document.querySelector('#joinForm');
            const userId = document.querySelector('#userId').value.trim();
            const regex = /^[a-zA-Z0-9]{4,20}$/;

            if (!userId) {
                await swalWarn('아이디를 입력해주세요.');
                form.elements['userId'].focus();
                return;
            }

            if (!regex.test(userId)) {
                await swalWarn('아이디는 영문, 숫자 조합 4~20자로 입력해주세요.');
                form.elements['userId'].focus();
                return;
            }

            try {
                // JSP EL과 JavaScript template literal 충돌을 피하기 위해 문자열 연결 방식 사용
                const resp = await fetch(contextPath + '/member/idCheck?userId=' + encodeURIComponent(userId));
                const result = await resp.json();

                if (result.res === 'NOTEXIST') {
                    document.querySelector('#isIdChecked').value = 'Y';
                    await Swal.fire({
                        icon: 'success',
                        title: '사용 가능',
                        text: result.message,
                        confirmButtonText: '확인'
                    });
                } else {
                    document.querySelector('#isIdChecked').value = 'N';
                    await Swal.fire({
                        icon: 'success',
                        title: '완료',
                        text: result.message,
                        confirmButtonText: '확인'
                    });
                }
            } catch (error) {
                console.error('아이디 중복확인 통신 에러: ', error);
                await swalError('아이디 중복확인 중 문제가 발생했습니다.');
            }
        });

        // 아이디 변경 시 중복확인 결과 초기화
        document.querySelector('#userId').addEventListener('input', function () {
            document.querySelector('#isIdChecked').value = 'N';
        });

        // 회원가입 전송
        const memRegBtn = document.querySelector('#memRegBtn');
        memRegBtn.addEventListener('click', async function (e) {
            e.preventDefault();

            const form = document.querySelector('#joinForm');
            const rrno1 = form.elements['rrno1'].value.trim();
            const rrno2 = form.elements['rrno2'].value.trim();

            document.querySelector('#userRrno').value = rrno1 + rrno2;

            const tel1 = document.querySelector('#tel1').value;
            const tel2 = document.querySelector('#tel2').value.trim();
            const tel3 = document.querySelector('#tel3').value.trim();
            document.querySelector('#userTelno').value = tel1 + tel2 + tel3;

            const validationRules = {
                userId: {
                    label: '아이디',
                    regex: /^[a-zA-Z0-9]{4,20}$/,
                    invalidMsg: '아이디는 영문, 숫자 조합 4~20자로 입력해주세요.'
                },
                userPw: {
                    label: '비밀번호',
                    regex: /^(?=.*[a-zA-Z])(?=.*\d)(?=.*[^a-zA-Z0-9가-힣\s])[^가-힣\s]{8,20}$/,
                    invalidMsg: '비밀번호는 영문, 숫자, 특수문자 조합 8~20자로 입력해주세요.'
                },
                userNm: {
                    label: '이름',
                    regex: /^[가-힣]{2,10}$/,
                    invalidMsg: '이름은 한글 2~10자로 입력해주세요.'
                },
                rrno1: {
                    label: '주민등록번호 앞자리',
                    regex: /^[0-9]{6}$/,
                    invalidMsg: '주민등록번호 형식이 올바르지 않습니다.'
                },
                rrno2: {
                    label: '주민등록번호 뒷자리',
                    regex: /^[0-9]{7}$/,
                    invalidMsg: '주민등록번호 형식이 올바르지 않습니다.'
                },
                userTelno: {
                    label: '전화번호',
                    regex: /^[0-9]{10,11}$/,
                    invalidMsg: '전화번호는 10~11자리 숫자로 입력해주세요.'
                },
                userEml: {
                    label: '이메일',
                    regex: /^[^\s@]+@[^\s@]+\.[^\s@]+$/,
                    invalidMsg: '올바른 이메일 형식이 아닙니다.'
                }
            };

            if (document.querySelector('#isIdChecked').value === 'N') {
                await swalWarn('아이디 중복확인을 해주세요.');
                form.elements['userId'].focus();
                return;
            }

            for (const [inputName, rule] of Object.entries(validationRules)) {
                const input = form.elements[inputName];
                if (!input) continue;

                const value = input.value.trim();
                if (!value) {
                    await swalWarn(rule.label + '을(를) 입력해주세요.');
                    input.focus();
                    return;
                }

                if (!rule.regex.test(value)) {
                    await swalWarn(rule.invalidMsg);
                    input.focus();
                    return;
                }
            }

            if (form.userPw.value !== form.userPwConfirm.value) {
                await swalWarn('비밀번호가 일치하지 않습니다.');
                form.userPwConfirm.focus();
                return;
            }

            const formData = new FormData(form);
            const csrfHeader = document.querySelector('meta[name="_csrf_header"]').content;
            const csrfToken = document.querySelector('meta[name="_csrf"]').content;

            formData.set('smsRcvYn', document.querySelector('#smsRcvYn').checked ? 'Y' : 'N');
            formData.set('emlRcvYn', document.querySelector('#emlRcvYn').checked ? 'Y' : 'N');

            ['#subSmsArea', '#subEmlArea'].forEach(function (area) {
                const container = document.querySelector(area);
                container.querySelectorAll('input[type="checkbox"]').forEach(function (checkbox) {
                    formData.set(checkbox.id, checkbox.checked ? 'Y' : 'N');
                });
            });

            try {
                const resp = await fetch(contextPath + '/member/join', {
                    method: 'POST',
                    headers: {
                        [csrfHeader]: csrfToken
                    },
                    body: formData
                });

                const result = await resp.json();

                if (resp.ok) {
                    await Swal.fire({
                        icon: 'success',
                        title: '회원가입 완료',
                        text: result.message || '회원가입이 완료되었습니다.',
                        confirmButtonText: '확인'
                    });

                    location.href = contextPath + '/';
                } else {
                    await swalError(result.message || '회원가입에 실패했습니다.');
                }
            } catch (error) {
                console.error('회원가입 통신 에러: ', error);
                await swalError('서버와 통신 중 문제가 발생했습니다.');
            }
        });

        // 이미지 썸네일 미리보기
        const preview = document.querySelector('#preview');
        const img = document.querySelector('#img');

        img.addEventListener('change', function () {
            if (typeof imgPreview === 'function') {
                imgPreview(img, preview);
            }

            if (img.files.length > 0) {
                document.querySelector('#fileName').textContent = img.files[0].name;
            } else {
                document.querySelector('#fileName').textContent = '선택된 파일 없음';
                preview.textContent = '미리보기';
            }
        });
    });
</script>
</body>
</html>
