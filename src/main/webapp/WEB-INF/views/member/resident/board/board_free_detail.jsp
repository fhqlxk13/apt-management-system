<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
    <title>자유게시판 – 대덕아파트</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/headerStyle.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebarStyle.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footerStyle.css">
    <style>
        body {
            font-family: 'Noto Sans KR', sans-serif !important;
            background: var(--bg);
            color: var(--text-dark);
            margin: 0;
        }

        .material-symbols-outlined {
            font-family: 'Material Symbols Outlined' !important;
        }

        .main-shell {
            display: flex;
            align-items: stretch;
            width: 100%;
            min-height: calc(100vh - 114px);
            margin-top: 114px;
            background: var(--bg);
        }

        .content-area {
            flex: 1;
            min-width: 0;
            padding: 32px 40px 64px;
        }

        .page-content-wrap {
            max-width: 1080px;
            width: 100%;
            margin: 0 auto;
        }

        /* ── 브레드크럼 ── */
        .breadcrumb {
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 12px;
            color: var(--text-light);
            margin-bottom: 18px;
        }
        .breadcrumb a { color: var(--text-light); text-decoration: none; }
        .breadcrumb .cur { color: var(--green-dark); font-weight: 700; }

        /* ── 페이지 제목 ── */
        .page-title {
            font-size: 22px;
            font-weight: 800;
            color: var(--text-dark);
            padding-bottom: 14px;
            border-bottom: 2px solid var(--green-dark);
            margin-bottom: 20px;
            letter-spacing: -.4px;
        }

        /* ── 게시글 패널 ── */
        .panel {
            background: var(--white);
            border: 1px solid var(--border);
            border-radius: 14px;
            box-shadow: 0 10px 24px rgba(30,60,40,.05);
            margin-bottom: 20px;
            overflow: hidden;
        }

        /* ── 제목 행: 제목 + 번호배지 + 더보기 ── */
        .post-title-row {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            padding: 22px 24px 10px;
        }
        .post-title-left {
            display: flex;
            align-items: flex-start;
            gap: 10px;
            flex: 1;
            min-width: 0;
        }
        .post-title {
            font-size: 19px;
            font-weight: 800;
            color: var(--text-dark);
            line-height: 1.45;
            margin: 0;
            flex: 1;
        }
        .post-num-badge {
            min-width: 26px;
            height: 26px;
            border-radius: 6px;
            background: var(--green-dark);
            color: #fff;
            font-size: 12px;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
            margin-top: 2px;
        }
        /* 수정 모드 제목 입력 */
        #ttlInput {
            width: 100%;
            border: 1px solid #d8ddd4;
            background: #fff;
            border-radius: 10px;
            padding: 8px 12px;
            font-size: 18px;
            font-weight: 800;
            color: var(--text-dark);
            box-sizing: border-box;
        }

        .more-dropdown button:hover { background: var(--green-pale); }
        .more-dropdown button.danger { color: #b64444; }

        /* ── 작성자 메타 행 ── */
        .post-meta-row {
            display: flex;
            align-items: center;
            padding: 14px 24px;
            border-bottom: 1px solid var(--border);
        }
        .post-author-left {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .post-avatar {
            width: 38px;
            height: 38px;
            border-radius: 50%;
            background: var(--green-dark);
            color: #fff;
            font-size: 14px;
            font-weight: 700;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }
        .post-author-info { display: flex; flex-direction: column; gap: 3px; }
        .post-author-name { font-size: 13px; font-weight: 700; color: var(--text-dark); }
        .post-author-sub  { font-size: 11px; color: var(--text-light); display: flex; gap: 10px; }

        /* ── 본문 ── */
        .post-body {
            font-size: 15px;
            line-height: 1.9;
            color: var(--text-dark);
            padding: 20px 24px;
            white-space: pre-wrap;
            word-break: break-word;
        }
        #cnInput {
            width: 100%;
            border: 1px solid #d8ddd4;
            background: #fff;
            border-radius: 10px;
            padding: 11px 13px;
            font-size: 14px;
            color: var(--text-dark);
            min-height: 160px;
            resize: vertical;
            box-sizing: border-box;
            line-height: 1.8;
            font-family: inherit;
        }

        /* ── 첨부파일 칩 ── */
        .attach-row { padding: 0 24px 18px; }
        .attach-chip {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            border: 1px solid var(--border);
            border-radius: 8px;
            padding: 7px 14px;
            font-size: 12px;
            color: var(--text-mid);
            text-decoration: none;
            background: var(--white);
        }
        .attach-chip:hover { background: var(--green-pale); color: var(--green-dark); }

        /* ── 하단 버튼 ── */
        .btn-row {
            display: flex;
            justify-content: center;
            gap: 10px;
            padding: 16px 24px;
            border-top: 1px solid var(--border);
            flex-wrap: wrap;
        }
        .btn-main, .btn-sub, .btn-danger, .btn-ghost {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-width: 100px;
            padding: 11px 18px;
            border-radius: 10px;
            font-size: 13px;
            font-weight: 700;
            text-decoration: none;
            border: none;
            cursor: pointer;
            box-sizing: border-box;
            transition: opacity .15s;
            font-family: inherit;
        }
        .btn-main:hover, .btn-sub:hover, .btn-danger:hover, .btn-ghost:hover { opacity: .85; }
        .btn-main   { background: var(--green-dark); color: #fff; }
        .btn-sub    { background: #edf5ef; color: var(--green-dark); border: 1px solid #c6dfc8; }
        .btn-danger { background: #b64444; color: #fff; }
        .btn-ghost  { background: #fff; color: var(--text-mid); border: 1px solid var(--border); }

        /* ── 댓글 패널 ── */
        .section-hd {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 16px 24px 14px;
            border-bottom: 1px solid var(--border);
        }
        .section-hd h3 { margin: 0; font-size: 15px; font-weight: 800; color: var(--text-dark); }
        .cmt-count { font-size: 12px; color: var(--text-light); }

        /* ── 댓글 입력 ── */
        .cmt-write-wrap {
            display: flex;
            flex-direction: column;
            gap: 6px;
            padding: 14px 24px;
            border-bottom: 1px solid var(--border);
        }
        #cmtCn {
            width: 100%;
            border: 1px solid #d8ddd4;
            background: #fafafa;
            border-radius: 10px;
            padding: 11px 13px;
            font-size: 13px;
            color: var(--text-dark);
            min-height: 72px;
            resize: vertical;
            box-sizing: border-box;
            font-family: inherit;
        }
        .cmt-write-footer { display: flex; justify-content: flex-end; }

        /* ── 댓글 목록 ── */
        #cmtArea { padding: 0 24px; }

        .cmt-item {
            padding: 14px 0;
            border-bottom: 1px solid #edf0eb;
        }
        .cmt-item:last-child { border-bottom: none; }

        .cmt-item.is-reply {
            margin-left: 20px;
            padding-left: 16px;
            border-left: 3px solid #d8ddd4;
            background: #fafafa;
        }

        .cmt-meta { display: flex; align-items: center; gap: 6px; flex-wrap: wrap; }
        .cmt-author { font-size: 13px; font-weight: 700; color: var(--text-dark); }
        .cmt-date   { font-size: 11px; color: var(--text-light); }

        .cmt-actions { margin-left: auto; display: flex; gap: 10px; }
        .cmt-action-btn {
            background: none;
            border: none;
            cursor: pointer;
            font-size: 12px;
            color: var(--text-light);
            padding: 0;
            text-decoration: underline;
            text-underline-offset: 2px;
            font-family: inherit;
        }
        .cmt-action-btn:hover { color: var(--text-dark); }
        .cmt-action-btn.danger { color: #b64444; }
        .cmt-action-btn.danger:hover { color: #8a2e2e; }

        .cmt-content {
            font-size: 13px;
            color: var(--text-dark);
            margin-top: 6px;
            line-height: 1.7;
            white-space: pre-wrap;
            word-break: break-word;
        }

        .cmt-inline-write { display: flex; gap: 8px; margin-top: 10px; align-items: center; }
        .cmt-inline-input {
            flex: 1;
            border: 1px solid #d8ddd4;
            background: #fff;
            border-radius: 8px;
            padding: 8px 11px;
            font-size: 13px;
            color: var(--text-dark);
            box-sizing: border-box;
            font-family: inherit;
        }
        .cmt-inline-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 8px 14px;
            border-radius: 8px;
            font-size: 12px;
            font-weight: 700;
            border: none;
            cursor: pointer;
            white-space: nowrap;
            font-family: inherit;
        }
        .cmt-inline-btn.primary { background: var(--green-dark); color: #fff; }
        .cmt-inline-btn.cancel  { background: #fff; color: var(--text-mid); border: 1px solid var(--border); }
    </style>
</head>
<body>
<%@ include file="/WEB-INF/views/include/apt_headerLayout.jsp" %>
<div class="main-shell">
    <%@ include file="/WEB-INF/views/include/apt_sidebarLayout.jsp" %>
    <main class="content-area">
        <div class="page-content-wrap">

            <!-- 브레드크럼 -->
            <div class="breadcrumb">
                <a href="${pageContext.request.contextPath}/">HOME</a>
                <span>›</span>
                <a href="javascript:void(0);">입주민게시판</a>
                <span>›</span>
                <span class="cur">자유게시판</span>
            </div>

            <h1 class="page-title">자유게시판</h1>

            <!-- ====== 게시글 패널 ====== -->
            <section class="panel">

                <!-- 1) 제목 + 번호배지 + 더보기(본인만) -->
                <div class="post-title-row">
                    <div class="post-title-left">
                        <h2 class="post-title" id="ttl">${freeBoard.ttl}</h2>
                    </div>
                </div>

                <!-- 2) 작성자 아바타 + 이름 + 날짜 + 조회수 -->
                <div class="post-meta-row">
                    <div class="post-author-left">
                        <div class="post-avatar" id="authorAvatar"></div>
                        <div class="post-author-info">
                            <span class="post-author-name">${empty freeBoard.wrtrNm ? freeBoard.wrtrId : freeBoard.wrtrNm}</span>
                            <div class="post-author-sub">
                                <span><fmt:formatDate value="${freeBoard.regDttm}" pattern="yy.MM.dd HH:mm"/></span>
                                <span>조회 ${freeBoard.inqCnt}</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 3) 본문 -->
                <div class="post-body" id="cn">${freeBoard.cn}</div>

                <!-- 4) 첨부파일 칩 -->
                <c:if test="${not empty attachFile}">
                    <div class="attach-row">
                        <c:choose>
                            <c:when test="${fn:startsWith(attachFile.mimeType, 'image/')}">
                                <img src="${pageContext.request.contextPath}/file/display/${attachFile.googleId}"
                                     alt="${attachFile.fileOgName}"
                                     style="max-width:100%; max-height:400px; border-radius:10px; margin-bottom:10px; display:block; object-fit:contain;"/>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/file/download/${attachFile.googleId}"
                                   class="attach-chip">
                                    <span class="material-symbols-outlined" style="font-size:16px">attach_file</span>
                                        ${attachFile.fileOgName}
                                </a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:if>

                <!-- 5) 하단 버튼(목록, 수정, 삭제) -->
                <div class="btn-row">
                    <button type="button" class="btn-ghost"
                            onclick="location.href='/resident/boardFreeList/${aptCmplexNo}'">목록</button>
                    <c:if test="${freeBoard.wrtrId == pageContext.request.userPrincipal.name}">
                        <button type="button" class="btn-sub" id="updateBtn">수정</button>
                        <button type="button" class="btn-danger" id="deleteBtn">삭제</button>
                    </c:if>
                </div>

            </section>

            <!-- ====== 댓글 패널 ====== -->
            <section class="panel">
                <div class="section-hd">
                    <h3>댓글</h3>
                    <span class="cmt-count" id="cmtCountLabel"></span>
                </div>

                <div class="cmt-write-wrap">
                    <textarea id="cmtCn" placeholder="댓글을 입력하세요."></textarea>
                    <div class="cmt-write-footer">
                        <button id="cmtInsertBtn" class="btn-main" style="min-width:80px; padding:9px 16px;">등록</button>
                    </div>
                </div>

                <div id="cmtArea"></div>
            </section>

        </div>
    </main>
</div>
<%@ include file="/WEB-INF/views/include/apt_footerLayout.jsp" %>

<script>
    var postNo        = '${postNo}';
    var aptCmplexNo   = '${aptCmplexNo}';
    var isEditing     = false;
    var currentUserId = '${pageContext.request.userPrincipal.name}';
    var csrfToken     = document.querySelector('meta[name="_csrf"]').content;

    /* ── 아바타 첫 글자 채우기 ── */
    (function() {
        var el   = document.querySelector('#authorAvatar');
        var name = '${empty freeBoard.wrtrNm ? freeBoard.wrtrId : freeBoard.wrtrNm}';
        if (el && name) el.textContent = name.charAt(0).toUpperCase();
    })();

    /* ── 날짜 포맷 헬퍼: YY.MM.DD HH:mm ── */
    function fmtDate(raw) {
        var d  = new Date(raw);
        var yy = String(d.getFullYear()).slice(2);
        var mm = String(d.getMonth() + 1).padStart(2, '0');
        var dd = String(d.getDate()).padStart(2, '0');
        var hh = String(d.getHours()).padStart(2, '0');
        var mi = String(d.getMinutes()).padStart(2, '0');
        return yy + '.' + mm + '.' + dd + ' ' + hh + ':' + mi;
    }

    /* ── 게시글 삭제 ── */
    document.querySelector('#deleteBtn')?.addEventListener('click', async function() {
        if (!confirm('삭제하시겠습니까?')) return;
        try {
            var res  = await fetch('/resident/boardFreeDelete/' + postNo, {
                method: 'PUT',
                headers: { 'Content-Type': 'application/json', 'X-CSRF-TOKEN': csrfToken }
            });
            var data = await res.json();
            if (data.success) location.href = '/resident/boardFreeList/' + aptCmplexNo;
            else alert('삭제에 실패했습니다.');
        } catch (e) { console.error('삭제 오류', e); }
    });

    /* ── 게시글 수정 ── */
    document.querySelector('#updateBtn')?.addEventListener('click', async function() {
        var dd = document.querySelector('#moreDropdown');
        if (dd) dd.classList.remove('open');

        if (!isEditing) {
            var ttlEl = document.querySelector('#ttl');
            var cnEl  = document.querySelector('#cn');

            var ttlInp   = document.createElement('input');
            ttlInp.type  = 'text';
            ttlInp.id    = 'ttlInput';
            ttlInp.value = ttlEl.innerText.trim();
            ttlEl.innerHTML = '';
            ttlEl.appendChild(ttlInp);

            var cnTa         = document.createElement('textarea');
            cnTa.id          = 'cnInput';
            cnTa.textContent = cnEl.innerText.trim();
            cnEl.innerHTML   = '';
            cnEl.appendChild(cnTa);

            document.querySelector('#updateBtn').innerText = '저장';
            isEditing = true;
        } else {
            if (!confirm('수정하시겠습니까?')) return;
            var ttl = document.querySelector('#ttlInput').value.trim();
            var cn  = document.querySelector('#cnInput').value.trim();
            if (!ttl) { alert('제목을 입력해주세요.'); return; }
            if (!cn)  { alert('내용을 입력해주세요.'); return; }
            try {
                var res  = await fetch('/resident/boardFreeUpdate', {
                    method: 'PUT',
                    headers: { 'Content-Type': 'application/json', 'X-CSRF-TOKEN': csrfToken },
                    body: JSON.stringify({ postNo: postNo, ttl: ttl, cn: cn })
                });
                var data = await res.json();
                if (data.success) {
                    await residentAlertThen(
                        '수정되었습니다.',
                        '/resident/boardFreeDetail/' + aptCmplexNo + '/' + postNo,
                        'success'
                    );
                } else {
                    await residentAlert('수정에 실패했습니다.', 'error');
                }
            } catch (e) { console.error('수정 오류', e); }
        }
    });

    /* ── 댓글 등록 ── */
    document.querySelector('#cmtInsertBtn').addEventListener('click', async function() {
        var cmtCn = document.querySelector('#cmtCn').value.trim();
        if (!cmtCn) { alert('댓글을 입력해주세요.'); return; }
        try {
            var res  = await fetch('/resident/insertBoardComment/' + aptCmplexNo + '/' + postNo, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json', 'X-CSRF-TOKEN': csrfToken },
                body: JSON.stringify({ cmtCn: cmtCn })
            });
            var data = await res.json();
            if (data.success) {
                document.querySelector('#cmtCn').value = '';
                loadComments();
            }
        } catch (e) { console.error('댓글 등록 오류', e); }
    });

    /* ── 댓글 영역 이벤트 위임 ── */
    document.querySelector('#cmtArea').addEventListener('click', async function(e) {

        if (e.target.classList.contains('cmtReply')) {
            var subArea   = e.target.closest('.cmt-sub-area');
            var writeArea = subArea.querySelector('.cmt-sub-write-area');
            if (!writeArea.innerHTML.trim()) {
                writeArea.innerHTML =
                    '<div class="cmt-inline-write">'
                    + '<input type="text" class="cmt-inline-input reply-input" placeholder="답글을 입력하세요."/>'
                    + '<button class="cmt-inline-btn primary cmtSubBtn">등록</button>'
                    + '<button class="cmt-inline-btn cancel cmtSubCancel">취소</button>'
                    + '</div>';
                e.target.textContent = '답글 접기';
            } else {
                writeArea.innerHTML  = '';
                e.target.textContent = '답글';
            }
        }

        if (e.target.classList.contains('cmtSubBtn')) {
            var subArea = e.target.closest('.cmt-sub-area');
            var cmtNo   = subArea.dataset.cmtNo;
            var cmtCn   = subArea.querySelector('.reply-input').value.trim();
            if (!cmtCn) { alert('내용을 입력해주세요.'); return; }
            try {
                var res  = await fetch('/resident/insertSubComment/' + cmtNo, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json', 'X-CSRF-TOKEN': csrfToken },
                    body: JSON.stringify({ cmtCn: cmtCn, postNo: postNo })
                });
                var data = await res.json();
                if (data.success) loadComments();
                else await residentAlert('등록에 실패했습니다.', 'error');
            } catch (e) { console.error('대댓글 등록 오류', e); }
        }

        if (e.target.classList.contains('cmtSubCancel')) {
            var subArea  = e.target.closest('.cmt-sub-area');
            subArea.querySelector('.cmt-sub-write-area').innerHTML = '';
            var replyBtn = subArea.querySelector('.cmtReply');
            if (replyBtn) replyBtn.textContent = '답글';
        }

        if (e.target.classList.contains('cmtEdit')) {
            var subArea   = e.target.closest('.cmt-sub-area');
            var content   = subArea.querySelector('.cmt-sub-content').innerText.trim();
            var writeArea = subArea.querySelector('.cmt-sub-write-area');

            var wrap = document.createElement('div');
            wrap.className = 'cmt-inline-write';

            var inp       = document.createElement('input');
            inp.type      = 'text';
            inp.className = 'cmt-inline-input edit-input';
            inp.value     = content;

            var btnSave         = document.createElement('button');
            btnSave.className   = 'cmt-inline-btn primary cmtSave';
            btnSave.textContent = '저장';

            var btnCancel         = document.createElement('button');
            btnCancel.className   = 'cmt-inline-btn cancel cmtEditCancel';
            btnCancel.textContent = '취소';

            wrap.appendChild(inp);
            wrap.appendChild(btnSave);
            wrap.appendChild(btnCancel);
            writeArea.innerHTML = '';
            writeArea.appendChild(wrap);
        }

        if (e.target.classList.contains('cmtSave')) {
            var subArea = e.target.closest('.cmt-sub-area');
            var cmtNo   = subArea.dataset.cmtNo;
            var cmtCn   = subArea.querySelector('.edit-input').value.trim();
            if (!cmtCn) { alert('내용을 입력해주세요.'); return; }
            try {
                var res  = await fetch('/resident/updateBoardComment', {
                    method: 'PUT',
                    headers: { 'Content-Type': 'application/json', 'X-CSRF-TOKEN': csrfToken },
                    body: JSON.stringify({ cmtNo: cmtNo, cmtCn: cmtCn })
                });
                var data = await res.json();
                if (data.success) loadComments();
                else await residentAlert('수정에 실패했습니다.', 'error');
            } catch (e) { console.error('댓글 수정 오류', e); }
        }

        if (e.target.classList.contains('cmtEditCancel')) {
            e.target.closest('.cmt-sub-area').querySelector('.cmt-sub-write-area').innerHTML = '';
        }

        if (e.target.classList.contains('cmtDelete')) {
            if (!confirm('삭제하시겠습니까?')) return;
            var cmtNo = e.target.closest('.cmt-sub-area').dataset.cmtNo;
            try {
                var res  = await fetch('/resident/deleteBoardComment/' + cmtNo, {
                    method: 'PUT',
                    headers: { 'X-CSRF-TOKEN': csrfToken }
                });
                var data = await res.json();
                if (data.success) loadComments();
                else alert('삭제에 실패했습니다.');
            } catch (e) { console.error('댓글 삭제 오류', e); }
        }
    });

    /* ── 댓글 목록 조회 ── */
    async function loadComments() {
        var res           = await fetch('/resident/boardFreeComment/' + postNo);
        var result        = await res.json();
        var cmtArea       = document.querySelector('#cmtArea');
        var cmtCountLabel = document.querySelector('#cmtCountLabel');

        if (!result || result.length === 0) {
            cmtArea.innerHTML = '<p style="text-align:center; padding:28px 0; color:#aaa; font-size:13px;">댓글이 없습니다.</p>';
            cmtCountLabel.textContent = '';
            return;
        }

        cmtCountLabel.textContent = '총 ' + result.length + '건';

        var html = '';
        result.forEach(function(v) {
            var isReply    = v.cmtSortOrd > 0;
            var replyClass = isReply ? ' is-reply' : '';
            var replyBtn   = !isReply
                ? '<button type="button" class="cmt-action-btn cmtReply">답글</button>'
                : '';
            var editBtns   = (v.userId === currentUserId)
                ? '<button type="button" class="cmt-action-btn cmtEdit">수정</button>'
                + '<button type="button" class="cmt-action-btn danger cmtDelete">삭제</button>'
                : '';

            html += '<div class="cmt-item' + replyClass + '">'
                +   '<div class="cmt-sub-area" data-cmt-no="' + v.cmtNo + '">'
                +     '<div class="cmt-meta">'
                +       '<span class="cmt-author">' + (v.userNm || v.userId) + '</span>'
                +       '<span class="cmt-date">' + fmtDate(v.regDttm) + '</span>'
                +       '<div class="cmt-actions">' + replyBtn + editBtns + '</div>'
                +     '</div>'
                +     '<div class="cmt-sub-content cmt-content">' + v.cmtCn + '</div>'
                +     '<div class="cmt-sub-write-area"></div>'
                +   '</div>'
                + '</div>';
        });
        cmtArea.innerHTML = html;
    }

    loadComments();
</script>
</html>
