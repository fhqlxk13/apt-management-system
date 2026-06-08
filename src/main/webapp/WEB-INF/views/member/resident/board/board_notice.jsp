<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>공지사항 – 대덕아파트</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/headerStyle.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebarStyle.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footerStyle.css">

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
    .hero-card {padding:24px 28px;margin-bottom:20px;background:linear-gradient(135deg,var(--green-dark),#386a4d);color:#fff;}
    .hero-card h2 {font-size:20px;margin:0 0 8px;letter-spacing:-.3px;} .hero-card p {margin:0;line-height:1.8;color:rgba(255,255,255,.82);font-size:13px;}
    .chip-row {display:flex;gap:8px;flex-wrap:wrap;margin-top:14px;} .chip {display:inline-flex;align-items:center;gap:4px;padding:6px 12px;border-radius:999px;font-size:12px;font-weight:700;background:rgba(255,255,255,.18);color:#fff;}
    .stats-grid {display:grid;grid-template-columns:repeat(4,minmax(0,1fr));gap:14px;margin-bottom:24px;} .stat-card {background:#fff;border:1px solid var(--border);border-radius:14px;padding:18px 18px 16px;}
    .stat-label {color:var(--text-light);font-size:12px;margin-bottom:8px;} .stat-value {font-size:24px;font-weight:800;color:var(--green-dark);letter-spacing:-.6px;} .stat-sub {margin-top:6px;font-size:12px;color:var(--text-light);}
    .grid-2 {display:grid;grid-template-columns:1.2fr .8fr;gap:18px;margin-bottom:22px;} .grid-2.equal {grid-template-columns:1fr 1fr;} .grid-3 {display:grid;grid-template-columns:repeat(3,1fr);gap:16px;margin-bottom:22px;}
    .section-hd {display:flex;align-items:center;justify-content:space-between;margin-bottom:14px;padding-bottom:10px;border-bottom:1px solid var(--border);} .section-hd h3 {margin:0;font-size:15px;font-weight:800;color:var(--text-dark);} .section-hd span {font-size:12px;color:var(--text-light);} .card,.panel {padding:20px;margin-bottom:20px;}
    .bullet-list {margin:0;padding-left:18px;color:var(--text-mid);line-height:1.8;font-size:13px;} .bullet-list li + li {margin-top:6px;}
    .data-table {width:100%;border-collapse:collapse;font-size:13px;background:#fff;overflow:hidden;border-radius:12px;} .data-table thead th {background: var(--green-pale);color: var(--text-mid);padding: 12px 14px;text-align: center;font-weight: 700;border-bottom: 1px solid var(--border);} .data-table tbody td {padding:13px 14px;border-bottom:1px solid #edf0eb;color:var(--text-dark);vertical-align:top;} .data-table tbody tr:last-child td {border-bottom:none;} .mini-table td,.mini-table th {padding:10px 12px !important;}
    .label-grid {display:grid;grid-template-columns:160px 1fr 160px 1fr;border-top:1px solid var(--border);border-left:1px solid var(--border);overflow:hidden;border-radius:12px;margin-bottom:18px;} .label-grid div {padding:13px 16px;border-right:1px solid var(--border);border-bottom:1px solid var(--border);font-size:13px;} .label-grid .th {background:var(--green-pale);color:var(--text-mid);font-weight:700;}
    .form-grid {display:grid;grid-template-columns:160px 1fr;border-top:1px solid var(--border);border-left:1px solid var(--border);overflow:hidden;border-radius:12px;} .form-grid .th,.form-grid .td {padding:14px 16px;border-right:1px solid var(--border);border-bottom:1px solid var(--border);} .form-grid .th {background:var(--green-pale);color:var(--text-mid);font-size:13px;font-weight:700;}
    .fake-input,.fake-select,.fake-textarea {width:100%;border:1px solid #d8ddd4;background:#fff;border-radius:10px;padding:11px 13px;font-size:13px;color:var(--text-dark);box-sizing:border-box;} .fake-textarea {min-height:110px;resize:vertical;}
    .inline-fields {display:flex;gap:10px;flex-wrap:wrap;} .btn-row {display:flex;justify-content:center;gap:10px;margin-top:22px;flex-wrap:wrap;}
    .btn-main,.btn-sub,.btn-danger,.btn-ghost {display:inline-flex;align-items:center;justify-content:center;min-width:120px;padding:12px 18px;border-radius:10px;font-size:13px;font-weight:800;text-decoration:none;border:none;cursor:pointer;box-sizing:border-box;} .btn-main {background:var(--green-dark);color:#fff;} .btn-sub {background:#edf5ef;color:var(--green-dark);} .btn-danger {background:#b64444;color:#fff;} .btn-ghost {background:#fff;color:var(--text-mid);border:1px solid var(--border);}
    .badge {display:inline-flex;align-items:center;padding:4px 10px;border-radius:999px;font-size:11px;font-weight:800;} .badge.ok {background:#ecf7ef;color:#2f7a4d;} .badge.wait {background:#fff5df;color:#9a6b00;} .badge.danger {background:#fbe8e8;color:#a23a3a;} .badge.info {background:#edf4fb;color:#2d6688;}
    .menu-grid {display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:16px;margin-bottom:24px;} .menu-card {background:#fff;border:1px solid var(--border);border-radius:14px;padding:20px;} .menu-card h4 {margin:0 0 8px;font-size:16px;color:var(--text-dark);} .menu-card p {margin:0 0 12px;font-size:13px;color:var(--text-light);line-height:1.7;} .menu-links {display:flex;flex-direction:column;gap:8px;} .menu-links a {text-decoration:none;color:var(--green-dark);font-size:13px;font-weight:700;}
    .seat-grid {display:grid;grid-template-columns:repeat(6,1fr);gap:10px;margin-top:10px;} .room-grid {display:grid;grid-template-columns:repeat(3,1fr);gap:10px;margin-top:10px;} .seat,.room-box {padding:16px 8px;text-align:center;border-radius:12px;font-weight:700;font-size:13px;border:1px solid var(--border);background:#fff;} .seat.available,.room-box.available {background:#f1f8f2;color:#2a6d44;} .seat.busy,.room-box.busy {background:#f8ecec;color:#9f4747;} .seat.selected,.room-box.selected {background:var(--green-dark);color:#fff;}
    .chart-box {height:240px;border:1px dashed #cfd7cf;border-radius:12px;background:linear-gradient(to top,rgba(43,103,78,.08),rgba(43,103,78,.02)),repeating-linear-gradient(to right,transparent 0 72px,rgba(0,0,0,.03) 72px 73px),repeating-linear-gradient(to bottom,transparent 0 47px,rgba(0,0,0,.04) 47px 48px);position:relative;overflow:hidden;} .chart-line {position:absolute;left:22px;right:22px;bottom:26px;top:28px;} .chart-line svg {width:100%;height:100%;}
    .chat-layout {display:grid;grid-template-columns:320px 1fr;gap:18px;} .chat-list,.chat-box {background:#fff;border:1px solid var(--border);border-radius:14px;} .chat-list {padding:16px;} .chat-box {padding:18px;} .chat-room-item {padding:12px 10px;border-radius:10px;cursor:pointer;border:1px solid transparent;} .chat-room-item.active {background:#f4f8f5;border-color:#d8e6db;} .message-stream {display:flex;flex-direction:column;gap:12px;min-height:320px;} .message {max-width:72%;padding:12px 14px;border-radius:14px;font-size:13px;line-height:1.7;} .message.me {align-self:flex-end;background:var(--green-dark);color:#fff;} .message.other {align-self:flex-start;background:#f2f4f0;color:var(--text-dark);}
    .search-row {display:flex;gap:10px;flex-wrap:wrap;margin-bottom:16px;} .search-row .fake-input,.search-row .fake-select {max-width:220px;} .notice-card {padding:18px 20px;border-radius:14px;background:linear-gradient(135deg,#fff8ea,#fff1d5);border:1px solid #f0dfb4;margin-bottom:18px;}
    .process-grid {display:grid;grid-template-columns:repeat(4,1fr);gap:14px;} .process-step {padding:18px 14px;border-radius:14px;border:1px solid var(--border);background:#fff;text-align:center;} .process-step.active {background:#eef8f0;border-color:#b8d9c0;}
    @media (max-width:1200px){.stats-grid,.menu-grid,.grid-3,.room-grid,.process-grid{grid-template-columns:repeat(2,1fr)} .grid-2,.grid-2.equal,.chat-layout{grid-template-columns:1fr} .label-grid{grid-template-columns:140px 1fr}}
    @media (max-width:900px){.main-shell{flex-direction:column}.content-area{padding:24px 18px 48px}.page-content-wrap{max-width:100%}.stats-grid,.menu-grid,.grid-3,.room-grid,.process-grid,.seat-grid{grid-template-columns:1fr}.form-grid{grid-template-columns:120px 1fr}.label-grid{grid-template-columns:120px 1fr}}

    /* 검색 영역 */
    .notice-search-wrap {
      display: flex;
      align-items: center;
      gap: 18px;
      width: 100%;
      margin-bottom: 24px;
    }

    /* 날짜 input 너비 */
    .notice-search-date {
      width: 95px;
      flex: 0 0 95px;
    }

    /* 제목 검색 너비 */
    .notice-search-keyword {
      flex: 1;
      min-width: 700px;
      max-width: 1400px;
    }

    /* input 공통 */
    .notice-search-input {
      width: 100%;
      height: 52px;
      padding: 0 14px;
      border: none;
      border-radius: 32px;
      background: #f0f3ef;
      font-size: 15px;
      font-weight: 500;
      box-sizing: border-box;
    }

    /* 검색 버튼 */
    .notice-search-btn {
      width: 138px;
      flex: 0 0 138px;
    }

    /* 초기화 버튼 */
    .notice-reset-btn {
      width: 138px;
    }

    .notice-paging-wrap {
      display: flex;
      justify-content: center;
      margin-top: 28px;
    }

    .pagination {
      display: flex;
      gap: 8px;
      padding: 0;
      margin: 0;
      list-style: none;
    }

    .page-link {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      min-width: 36px;
      height: 36px;
      padding: 0 12px;
      border-radius: 999px;
      border: 1px solid var(--border);
      background: #fff;
      color: var(--text-mid);
      text-decoration: none;
      font-size: 13px;
      font-weight: 800;
    }

    .page-item.active .page-link {
      background: var(--green-dark);
      color: #fff;
      border-color: var(--green-dark);
    }

    .page-item.disabled .page-link {
      color: #aaa;
      cursor: default;
    }

    .notice-detail-card {
      background: #fff;
      border: 1px solid var(--border);
      border-radius: 14px;
      box-shadow: 0 10px 24px rgba(30, 60, 40, .05);
      margin-bottom: 28px;
      overflow: hidden;
    }

    .notice-detail-header {
      display: flex;
      justify-content: space-between;
      align-items: flex-start;
      padding: 26px 26px 18px;
    }

    .notice-detail-title {
      margin: 0;
      font-size: 20px;
      font-weight: 800;
      color: var(--text-dark);
    }

    .notice-more-btn {
      border: none;
      background: transparent;
      font-size: 24px;
      color: var(--text-light);
      cursor: pointer;
    }

    .notice-detail-writer {
      display: flex;
      align-items: center;
      gap: 14px;
      padding: 0 26px 22px;
    }

    .notice-writer-avatar {
      width: 38px;
      height: 38px;
      border-radius: 50%;
      background: var(--green-dark);
      color: #fff;
      display: flex;
      align-items: center;
      justify-content: center;
      font-weight: 800;
    }

    .notice-writer-id {
      font-size: 13px;
      font-weight: 800;
      color: var(--text-dark);
    }

    .notice-meta {
      display: flex;
      gap: 8px;
      margin-top: 4px;
      font-size: 12px;
      color: var(--text-light);
    }

    .notice-detail-body {
      border-top: 1px solid var(--border);
      padding: 26px;
    }

    .notice-content {
      min-height: 54px;
      white-space: pre-wrap;
      font-size: 15px;
      line-height: 1.8;
      color: var(--text-dark);
    }

    .notice-file-area {
      margin: 0 26px 22px;
      display: inline-flex;
      align-items: center;
      gap: 8px;
      padding: 9px 14px;
      border: 1px solid var(--border);
      border-radius: 8px;
      font-size: 13px;
      color: var(--text-mid);
    }

    .notice-file-icon {
      font-size: 13px;
      color: var(--green-dark);
    }

    .notice-attach-icon {
      font-size: 17px;
      font-weight: 800;
    }

    .notice-attach-icon.has-file {
      color: var(--green-dark);
    }

    .notice-attach-icon.no-file {
      color: #c3c9c0;
    }

    .notice-file-empty {
      color: var(--text-light);
      font-size: 13px;
    }

    .notice-file-download {
      color: var(--green-dark);
      font-weight: 700;
      text-decoration: none;
    }
    .notice-close-btn {
      border: none;
      background: #edf5ef;
      color: var(--green-dark);
      font-size: 12px;
      font-weight: 800;
      padding: 8px 14px;
      border-radius: 999px;
      cursor: pointer;
      transition: all .2s ease;
    }

    /*
     * hover란?
     * → 마우스를 올렸을 때 적용되는 CSS 상태.
     */
    .notice-close-btn:hover {
      background: var(--green-dark);
      color: #fff;
    }

    /* 공지의 긴급배지 */
    .notice-emergency-badge {
      display: inline-flex;
      align-items: center;
      margin-right: 6px;
      padding: 2px 7px;
      border-radius: 999px;
      background: #ffe8e8;
      color: #d93025;
      font-size: 11px;
      font-weight: 900;
      vertical-align: middle;
    }
    /*
     * TOP_FIX_YN = 'Y'
     * → 사용자에게 중요한 공지임을 제목 앞에서 바로 인지시키기 위해 사용.
     */
    .detail-emergency-badge {
      display: inline-flex;
      align-items: center;
      margin-right: 8px;
      padding: 4px 10px;
      border-radius: 999px;
      background: #ffe8e8;
      color: #d93025;
      font-size: 12px;
      font-weight: 900;
      vertical-align: middle;
    }

    /* 첨부파일 없을 때 '-' 표시 */
    .notice-no-file {
      color: #9aa3af;
      font-size: 15px;
      font-weight: 600;
    }

    /* 테이블 전체 컬럼 기본 중앙정렬 */
    .data-table th,
    .data-table td {
      text-align: center;
      vertical-align: middle;
    }

    /* 제목 컬럼만 왼쪽 정렬 */
    .data-table th.title-col,
    .data-table td.title-col {
      text-align: left;
      padding-left: 26px;
    }

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
          <span class="cur">공지사항</span>
        </div>
        <h1 class="page-title">공지사항</h1>
        <p class="page-desc">단지 관리자가 등록한 우리 단지 공지사항을 확인할 수 있습니다.</p>

        <form method="get"
              action="${pageContext.request.contextPath}/resident/board/notice/${aptCmplexNo}"
              class="notice-search-wrap">
          <input type="hidden" name="currentPage" value="${pagingVO.currentPage}">

          <input type="date"
                 id="searchStartDt"
                 name="searchStartDt"
                 class="notice-search-input notice-search-date"
                 value="${searchStartDt}">

          <span class="notice-search-tilde">~</span>

          <input type="date"
                 id="searchEndDt"
                 name="searchEndDt"
                 class="notice-search-input notice-search-date"
                 value="${searchEndDt}">

          <input type="text"
                 name="searchTtl"
                 class="notice-search-input notice-search-keyword"
                 placeholder="제목 검색"
                 value="${searchDTO.searchTtl}">

          <button type="submit"
                  class="notice-search-btn">
            검색
          </button>

          <a href="${pageContext.request.contextPath}/resident/board/notice/${aptCmplexNo}"
             class="notice-reset-btn">
            초기화
          </a>
        </form>

        <section class="panel">
          <div class="section-hd">
            <h3>공지사항</h3>
            <span>총 ${totalRecord}건</span>
          </div>

          <section id="noticeDetailCard" class="notice-detail-card" style="display:none;">
            <div class="notice-detail-header">
              <h2 class="notice-detail-title">
                <span id="detailEmergencyBadge"></span>
                <span id="detailTtl"></span>
              </h2>

              <button type="button"
                      class="notice-close-btn"
                      id="noticeCloseBtn">
                접기
              </button>
            </div>

            <div class="notice-detail-writer">
              <div class="notice-writer-avatar" id="detailAvatar">T</div>

              <div>
                <div id="detailWrtrId" class="notice-writer-id"></div>
                <div class="notice-meta">
                  <span id="detailRegDttm"></span>
                  <span>조회 <span id="detailInqCnt"></span></span>
                </div>
              </div>
            </div>

            <div class="notice-detail-body">
              <div id="detailCn" class="notice-content"></div>
            </div>

            <div id="detailFileArea" class="notice-file-area">
              <span id="detailFileIcon" class="notice-file-icon">📎</span>
              <a id="detailFileLink"
                 class="notice-file-download"
                 href="javascript:void(0);"
                 style="display:none;">
              </a>
              <span id="detailFileEmpty" class="notice-file-empty">첨부파일 없음</span>
            </div>
          </section>

          <table class="data-table">
            <thead>
            <tr>
              <th>번호</th>
              <th class="title-col">제목</th>
              <th>작성자</th>
              <th>첨부파일</th>
              <th>작성일</th>
              <th>조회수</th>
            </tr>
            </thead>

            <tbody>
            <c:choose>
              <c:when test="${empty noticeList}">
                <tr>
                  <td colspan="6" style="text-align:center; padding:30px;">
                    등록된 공지사항이 없습니다.
                  </td>
                </tr>
              </c:when>

              <c:otherwise>
                <c:forEach var="notice"
                           items="${noticeList}"
                           varStatus="status">
                  <tr>
                    <td>
                        ${pagingVO.totalRecord
                                - ((pagingVO.currentPage - 1) * pagingVO.screenSize)
                                - status.index}
                    </td>
                    <td class="title-col">
                      <a href="${pageContext.request.contextPath}/resident/board/notice/detail/${aptCmplexNo}/${notice.annNo}"
                         style="color:var(--text-dark); text-decoration:none; font-weight:700;">

                        <c:if test="${notice.topFixYn eq 'Y'}">
                          <span class="notice-emergency-badge">긴급</span>
                        </c:if>

                          ${notice.ttl}
                      </a>
                    </td>

                    <td>${notice.wrtrId}</td>

                    <td>
                      <c:choose>

                        <c:when test="${not empty notice.atchFileId}">
                          <span class="notice-attach-icon has-file"
                                title="첨부파일 있음">
                            📎
                          </span>
                        </c:when>

                        <c:otherwise>
                          <span class="notice-no-file">-</span>
                        </c:otherwise>

                      </c:choose>
                    </td>

                    <td>${notice.regDttm}</td>

                    <td class="notice-inq-cnt" data-ann-no="${notice.annNo}">
                        ${notice.inqCnt}
                    </td>
                  </tr>
                </c:forEach>
              </c:otherwise>
            </c:choose>
            </tbody>
          </table>

          <div class="notice-paging-wrap">
            ${pagingHTML}
          </div>
        </section>

      </div>
    </main>
  </div>
  <%@ include file="/WEB-INF/views/include/apt_footerLayout.jsp" %>
  <script>
    document.addEventListener("DOMContentLoaded", function () {
      const titleLinks = document.querySelectorAll(".notice-title-link");

      titleLinks.forEach(function (link) {
        link.addEventListener("click", function () {
          const annNo = this.dataset.annNo;

          fetch("${pageContext.request.contextPath}/resident/board/notice/detail-ajax/${aptCmplexNo}/" + annNo)
                  .then(function (response) {
                    if (!response.ok) {
                      throw new Error("공지사항 상세 조회 실패");
                    }
                    return response.json();
                  })
                  .then(function (notice) {
                    /*
                     * textContent란?
                     * → HTML 태그로 해석하지 않고 글자 그대로 넣는 방식.
                     * 왜 사용?
                     * → DB 내용에 script 태그 등이 들어와도 실행되지 않게 막기 위해.
                     */
                    document.getElementById("noticeDetailCard").style.display = "block";

                    document.getElementById("detailTtl").textContent = notice.ttl || "";
                    const detailEmergencyBadge =
                            document.getElementById("detailEmergencyBadge");
                    /*
                     * TOP_FIX_YN = 'Y'
                     * → 긴급 공지 여부 확인.
                     * 왜 사용?
                     * → 상세 화면에서도 사용자가 중요 공지임을 바로 인지하게 하기 위해.
                     */
                    if (notice.topFixYn === "Y") {
                      detailEmergencyBadge.innerHTML =
                              '<span class="notice-emergency-badge">긴급</span>';
                    } else {
                      detailEmergencyBadge.innerHTML = "";
                    }
                    document.getElementById("detailWrtrId").textContent = notice.wrtrId || "";
                    document.getElementById("detailRegDttm").textContent = notice.regDttm || "";
                    document.getElementById("detailInqCnt").textContent = notice.inqCnt || 0;
                    const listInqCnt = document.querySelector(
                            ".notice-inq-cnt[data-ann-no='" + notice.annNo + "']"
                    );

                    if (listInqCnt) {
                      listInqCnt.textContent = notice.inqCnt || 0;
                    }
                    document.getElementById("detailCn").textContent = notice.cn || "";

                    const avatar = document.getElementById("detailAvatar");
                    avatar.textContent = notice.wrtrId ? notice.wrtrId.substring(0, 1).toUpperCase() : "N";

                    const fileArea = document.getElementById("detailFileArea");
                    const fileIcon = document.getElementById("detailFileIcon");
                    const fileLink = document.getElementById("detailFileLink");
                    const fileEmpty = document.getElementById("detailFileEmpty");

                    fileArea.style.display = "inline-flex";

                    if (notice.atchFileId) {
                      fileIcon.style.color = "var(--green-dark)";
                      fileLink.style.display = "inline";
                      fileEmpty.style.display = "none";

                      fileLink.textContent = notice.fileOgName || "첨부파일 다운로드";

                      /*
                       * 다운로드 URL
                       * → 프로젝트에 이미 파일 다운로드 컨트롤러가 있으면 그 URL에 맞춰야 함.
                       */
                      fileLink.href = "${pageContext.request.contextPath}/file/download/" + notice.atchFileId;
                    } else {
                      fileIcon.style.color = "#c3c9c0";
                      fileLink.style.display = "none";
                      fileLink.removeAttribute("href");
                      fileEmpty.style.display = "inline";
                      fileEmpty.textContent = "첨부파일 없음";
                    }

                    // 게시글 열릴 때, noticeDetailCard 위치로 스크롤 이동
                    // window.scrollTo({
                    //   top: document.getElementById("noticeDetailCard").offsetTop - 120,
                    //   behavior: "smooth"
                    // });
                  })
                  .catch(function (error) {
                    alert("공지사항 상세 내용을 불러오지 못했습니다.");
                    console.error(error);
                  });
        });
      });

      /*
       * 상세 공지 닫기 버튼
       */
      const noticeCloseBtn = document.getElementById("noticeCloseBtn");

      noticeCloseBtn.addEventListener("click", function () {

        const detailCard = document.getElementById("noticeDetailCard");

        /*
         * display:none
         * → 화면에서 요소를 완전히 숨김.
         * 어떤 상황에서 사용?
         * → 모달 닫기, 상세영역 접기, 탭 숨김 등.
         */
        detailCard.style.display = "none";

        /*
         * 접은 후 목록 위치로 자연스럽게 이동
         */
        // window.scrollTo({
        //   top: document.querySelector(".data-table").offsetTop - 120,
        //   behavior: "smooth"
        // });
      });
    });
    document.addEventListener("DOMContentLoaded", function () {
      const pagingLinks = document.querySelectorAll(".pagination .page-link");

      pagingLinks.forEach(function (link) {
        link.addEventListener("click", function (e) {
          e.preventDefault();

          const page = this.dataset.page;
          if (!page) return;

          const form = document.querySelector(".notice-search-wrap");
          const pageInput = form.querySelector("input[name='currentPage']");

          pageInput.value = page;
          form.submit();
        });
      });
    });


    /*
 * 시작일보다 종료일이 빠르면 검색을 막는다.
 * → 2026-05-20 ~ 2026-05-10 같은 잘못된 기간 검색을 방지하기 위해.
 */
    const noticeSearchForm = document.querySelector(".notice-search-wrap");
    const searchStartDt = document.getElementById("searchStartDt");
    const searchEndDt = document.getElementById("searchEndDt");

    noticeSearchForm.addEventListener("submit", function(e) {
      if (searchStartDt.value && searchEndDt.value) {
        if (searchStartDt.value > searchEndDt.value) {
          e.preventDefault();
          alert("종료일은 시작일보다 같거나 뒤 날짜여야 합니다.");
          searchEndDt.focus();
        }
      }
    });

    /*
     * 시작일 선택 시
     * 종료일은 시작일 이전 날짜 선택 불가
     */
    searchStartDt.addEventListener("change", function() {

      /*
       * min 속성
       * → 선택 가능한 최소 날짜 제한
       */
      searchEndDt.min = this.value;

      /*
       * 이미 선택된 종료일이 시작일보다 빠르면 초기화
       */
      if (searchEndDt.value && searchEndDt.value < this.value) {
        searchEndDt.value = "";
      }
    });
  </script>
</body>
</html>
