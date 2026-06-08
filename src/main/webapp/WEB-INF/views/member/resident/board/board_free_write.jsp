<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <meta name="_csrf" content="${_csrf.token}"/>
  <meta name="_csrf_header" content="${_csrf.headerName}"/>
  <title>자유게시판 - 글쓰기 – 대덕아파트</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/headerStyle.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebarStyle.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footerStyle.css">
  <link rel="stylesheet" href="https://cdn.ckeditor.com/ckeditor5/41.4.2/classic/ckeditor.css"/>
  <script src="https://cdn.ckeditor.com/ckeditor5/41.4.2/classic/ckeditor.js"></script>
  <style>
    .ck-editor__editable h1 { font-size: 2em; font-weight: bold; }
    .ck-editor__editable h2 { font-size: 1.5em; font-weight: bold; }
    .ck-editor__editable h3 { font-size: 1.17em; font-weight: bold; }
    body {font-family: 'Noto Sans KR', sans-serif !important;background: var(--bg);color: var(--text-dark);margin: 0;}
    .material-symbols-outlined { font-family: 'Material Symbols Outlined' !important; }
    .main-shell {display:flex;align-items:stretch;width:100%;min-height:calc(100vh - 114px);margin-top:114px;background:var(--bg);}
    .content-area {flex:1;min-width:0;padding:32px 40px 64px;}
    .page-content-wrap {max-width:1080px;width:100%;margin:0 auto;}
    .breadcrumb {display:flex;align-items:center;gap:6px;font-size:12px;color:var(--text-light);margin-bottom:18px;}
    .breadcrumb a {color:var(--text-light);text-decoration:none;} .breadcrumb .cur {color:var(--green-dark);font-weight:700;}
    .page-title {font-size:22px;font-weight:800;color:var(--text-dark);padding-bottom:14px;border-bottom:2px solid var(--green-dark);margin-bottom:16px;letter-spacing:-.4px;}
    .hero-card,.card,.panel {background:var(--white);border:1px solid var(--border);border-radius:14px;box-shadow:0 10px 24px rgba(30,60,40,.05);}
    .section-hd {display:flex;align-items:center;justify-content:space-between;margin-bottom:14px;padding-bottom:10px;border-bottom:1px solid var(--border);}
    .section-hd h3 {margin:0;font-size:15px;font-weight:800;color:var(--text-dark);}
    .card,.panel {padding:20px;margin-bottom:20px;}
    .form-grid {display:grid;grid-template-columns:160px 1fr;border-top:1px solid var(--border);border-left:1px solid var(--border);overflow:hidden;border-radius:12px;}
    .form-grid .th,.form-grid .td {padding:14px 16px;border-right:1px solid var(--border);border-bottom:1px solid var(--border);}
    .form-grid .th {background:var(--green-pale);color:var(--text-mid);font-size:13px;font-weight:700;display:flex;align-items:center;}
    .fake-input,.fake-select {width:100%;border:1px solid #d8ddd4;background:#fff;border-radius:10px;padding:11px 13px;font-size:13px;color:var(--text-dark);box-sizing:border-box;}
    .btn-row {display:flex;justify-content:center;gap:10px;margin-top:22px;flex-wrap:wrap;}
    .btn-main,.btn-sub,.btn-danger,.btn-ghost {display:inline-flex;align-items:center;justify-content:center;min-width:120px;padding:12px 18px;border-radius:10px;font-size:13px;font-weight:800;text-decoration:none;border:none;cursor:pointer;box-sizing:border-box;}
    .btn-main {background:var(--green-dark);color:#fff;}
    .btn-sub {background:#edf5ef;color:var(--green-dark);}
    .btn-ghost {background:#fff;color:var(--text-mid);border:1px solid var(--border);}

    /* 파일첨부 커스텀 */
    .file-upload-wrap {display:flex;align-items:center;gap:10px;}
    .file-upload-wrap label {display:inline-flex;align-items:center;padding:8px 16px;background:#edf5ef;color:var(--green-dark);border:1px solid var(--green-dark);border-radius:8px;font-size:13px;font-weight:700;cursor:pointer;white-space:nowrap;}
    .file-upload-wrap label:hover {background:var(--green-dark);color:#fff;}
    .file-upload-wrap input[type="file"] {display:none;}
    .file-name {font-size:13px;color:var(--text-light);}

    /* CKEditor 최소 높이 */
    .ck-editor__editable {min-height:200px !important;}

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
        <a href="javascript:void(0);">입주민게시판</a>
        <span>›</span>
        <span class="cur">자유게시판 - 글쓰기</span>
      </div>
      <h1 class="page-title">자유게시판 - 글쓰기</h1>

      <section class="panel">
        <div class="section-hd">
          <h3>게시글 작성</h3>
        </div>
        <form id="writeForm" action="/resident/boardFreeWrite.do" method="post" enctype="multipart/form-data">
          <input type="hidden" name="aptCmplexNo" value="${aptCmplexNo}"/>
          <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
          <div class="form-grid">
            <div class="th">제목</div>
            <div class="td">
              <input id="ttl" name="ttl" class="fake-input" placeholder="게시글 제목을 입력하세요."/>
            </div>
            <div class="th">내용</div>
            <div class="td">
              <div id="editor"></div>
              <textarea id="cn" name="cn" style="display:none;"></textarea>
            </div>
            <div class="th">파일첨부</div>
            <div class="td">
              <div class="file-upload-wrap">
                <label for="attachFile">파일 선택</label>
                <input type="file" id="attachFile" name="attachFile"/>
                <span class="file-name" id="fileName">선택된 파일 없음</span>
              </div>
            </div>
          </div>
          <div class="btn-row">
            <button type="button" id="submitBtn" class="btn-main">작성하기</button>
            <a class="btn-ghost" href="/resident/boardFreeList/${aptCmplexNo}">목록</a>
          </div>
        </form>
      </section>
    </div>
  </main>
</div>
<%@ include file="/WEB-INF/views/include/apt_footerLayout.jsp" %>
</body>
<script>
  let ckEditor;

  ClassicEditor.create(document.querySelector('#editor'), {
    toolbar: {
      removeItems: ['uploadImage', 'insertImage']
    }
  })
          .then(editor => { ckEditor = editor; })
          .catch(error => console.error('CKEditor 초기화 오류', error));

  document.querySelector('#attachFile').addEventListener('change', function () {
    const name = this.files[0]?.name ?? '선택된 파일 없음';
    document.querySelector('#fileName').textContent = name;
  });

  document.querySelector('#submitBtn').addEventListener('click', () => {
    const ttl = document.querySelector('#ttl').value.trim();
    const cn  = ckEditor.getData().trim();

    if (!ttl) {
      alert('제목을 입력해주세요.');
      document.querySelector('#ttl').focus();
      return;
    }

    if (!cn || cn === '<p>&nbsp;</p>') {
      alert('내용을 입력해주세요.');
      return;
    }

    document.querySelector('#cn').value = cn;
    document.querySelector('#writeForm').submit();
  });
</script>
</html>