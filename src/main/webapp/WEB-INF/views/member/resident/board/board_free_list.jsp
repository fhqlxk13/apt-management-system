<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>자유게시판 - 목록 – 대덕아파트</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/headerStyle.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebarStyle.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footerStyle.css">

    <style>
        body {font-family: 'Noto Sans KR', sans-serif !important;background: var(--bg);color: var(--text-dark);margin: 0;}
        .material-symbols-outlined {font-family: 'Material Symbols Outlined' !important;}
        .main-shell {display:flex;align-items:stretch;width:100%;min-height:calc(100vh - 114px);margin-top:114px;background:var(--bg);}
        .content-area {flex:1;min-width:0;padding:32px 40px 64px;}
        .page-content-wrap {max-width:1080px;width:100%;margin:0 auto;}
        .breadcrumb {display:flex;align-items:center;gap:6px;font-size:12px;color:var(--text-light);margin-bottom:18px;}
        .breadcrumb a {color:var(--text-light);text-decoration:none;}
        .breadcrumb .cur {color:var(--green-dark);font-weight:700;}
        .page-title {font-size:22px;font-weight:800;color:var(--text-dark);padding-bottom:14px;border-bottom:2px solid var(--green-dark);margin-bottom:16px;letter-spacing:-.4px;}
        .hero-card,.card,.panel {background:var(--white);border:1px solid var(--border);border-radius:14px;box-shadow:0 10px 24px rgba(30,60,40,.05);}
        .card,.panel {padding:20px;margin-bottom:20px;}
        .data-table {width:100%;border-collapse:collapse;font-size:13px;background:#fff;overflow:hidden;border-radius:12px;}
        .data-table thead th {background:var(--green-pale);color:var(--text-mid);padding:12px 14px;text-align:left;font-weight:700;border-bottom:1px solid var(--border);}
        .data-table tbody td {padding:13px 14px;border-bottom:1px solid #edf0eb;color:var(--text-dark);vertical-align:top;}
        .data-table tbody tr:last-child td {border-bottom:none;}
        .data-table tbody tr:hover {background:var(--green-pale);}
        .col-no {text-align:center !important;width:70px;}
        .col-ttl {text-align:left !important;max-width:400px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;}
        .col-wrt {text-align:center !important;width:110px;}
        .col-dt {text-align:center !important;width:150px;}
        .col-inq {text-align:center !important;width:80px;}
        .fake-input,.fake-select,.fake-textarea {width:100%;border:1px solid #d8ddd4;background:#fff;border-radius:10px;padding:11px 13px;font-size:13px;color:var(--text-dark);box-sizing:border-box;}
        .btn-main,.btn-sub,.btn-danger,.btn-ghost {display:inline-flex;align-items:center;justify-content:center;min-width:120px;padding:12px 18px;border-radius:10px;font-size:13px;font-weight:800;text-decoration:none;border:1px solid var(--green-dark);cursor:pointer;box-sizing:border-box;}
        .btn-main {background:var(--green-dark);color:#fff;}
        .btn-sub {background:#edf5ef;color:var(--green-dark);}
        .btn-danger {background:#b64444;color:#fff;}
        .btn-ghost {background:#fff;color:var(--text-mid);border:1px solid var(--border);}
        .search-row {display:flex;gap:10px;flex-wrap:wrap;margin-bottom:16px;}
        .search-row .fake-input,.search-row .fake-select {max-width:220px;}
        .pagination {display:flex;align-items:center;justify-content:center;gap:4px;flex-wrap:wrap;}
        .pagination button {display:inline-flex;align-items:center;justify-content:center;width:36px;height:36px;border-radius:8px;border:1px solid var(--border);background:#fff;color:var(--text-mid);font-size:13px;font-weight:600;cursor:pointer;transition:all .15s;}
        .pagination button:hover {background:var(--green-pale);border-color:var(--green-dark);color:var(--green-dark);}
        .pagination button.active {background:var(--green-dark);color:#fff;border-color:var(--green-dark);}
        .pagination button.nav {min-width:36px;font-size:16px;color:var(--text-light);}
        .pagination button.nav:disabled {opacity:.35;cursor:default;}
        .pagination .ellipsis {width:36px;height:36px;display:inline-flex;align-items:center;justify-content:center;color:var(--text-light);font-size:13px;letter-spacing:2px;}
        .bottom-bar {display:flex;align-items:center;justify-content:space-between;margin-top:24px;}
        @media (max-width:900px){.main-shell{flex-direction:column}.content-area{padding:24px 18px 48px}.page-content-wrap{max-width:100%}}
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
                <span class="cur">자유게시판 - 목록</span>
            </div>
            <h1 class="page-title">자유게시판 - 목록</h1>

            <section class="panel">
                <form id="filterForm" action="/resident/boardFreeList/${aptCmplexNo}" method="get">
                    <input type="hidden" name="page" id="f-page" value="${pagingVO.currentPage}"/>
                    <div class="search-row">
                        <select name="searchType" class="fake-select">
                            <option value="ttl" ${searchType == 'ttl' ? 'selected' : ''}>제목</option>
                            <option value="wrtrId" ${searchType == 'wrtrId' ? 'selected' : ''}>작성자</option>
                        </select>
                        <input class="fake-input" name="searchWord" value="${searchWord}" placeholder="검색어를 입력하세요"/>
                        <button type="submit" class="btn-sub" onclick="doSearch()">검색</button>
                    </div>
                </form>

                <table class="data-table">
                    <thead>
                    <tr>
                        <th class="col-no">번호</th>
                        <th class="col-ttl">제목</th>
                        <th class="col-wrt">작성자</th>
                        <th class="col-dt">작성일</th>
                        <th class="col-inq">조회수</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${empty pagingVO.dataList}">
                            <tr>
                                <td colspan="5" style="text-align:center; padding:30px; color:var(--text-light);">
                                    등록된 게시글이 없습니다.
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="board" items="${pagingVO.dataList}" varStatus="status">
                                <tr style="cursor:pointer;"
                                    onclick="location.href='/resident/boardFreeDetail/${board.postNo}/${aptCmplexNo}'">
                                    <td class="col-no">${(pagingVO.currentPage - 1) * pagingVO.screenSize + status.index + 1}</td>
                                    <td class="col-ttl">${board.ttl}</td>
                                    <td class="col-wrt">${empty board.wrtrNm ? board.wrtrId : board.wrtrNm}</td>
                                    <td class="col-dt"><fmt:formatDate value="${board.regDttm}" pattern="yyyy-MM-dd HH:mm"/></td>
                                    <td class="col-inq">${board.inqCnt}</td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>

                <div class="bottom-bar">
                    <div></div>
                    <div class="pagination" id="pagination"></div>
                    <a href="${pageContext.request.contextPath}/resident/board/free/write/${aptCmplexNo}" class="btn-main">글쓰기</a>
                </div>

            </section>

        </div>
    </main>
</div>
<%@ include file="/WEB-INF/views/include/apt_footerLayout.jsp" %>
</body>
<script>
    const aptCmplexNo = '${aptCmplexNo}';
    const currentPage = parseInt('${pagingVO.currentPage}') || 1;
    const totalPage   = parseInt('${pagingVO.totalPage}')   || 1;

    // 페이지 이동: hidden input에 페이지 번호 세팅 후 폼 제출
    function goPage(page) {
        if (page < 1 || page > totalPage) return;
        document.querySelector('#f-page').value = page;
        document.querySelector('#filterForm').submit();
    }

    // 검색: 페이지를 1로 초기화 후 폼 제출
    function doSearch() {
        document.querySelector('#f-page').value = 1;
        document.querySelector('#filterForm').submit();
    }

    // 페이지 버튼 요소 생성 헬퍼
    function createBtn(label, cls, disabled) {
        const btn = document.createElement('button');
        btn.textContent = label;
        if (cls)      btn.className = cls;
        if (disabled) btn.disabled  = true;
        return btn;
    }

    // 현재 페이지 기준으로 표시할 페이지 번호 배열 계산
    // 예) cur=5, total=10, delta=2 → [1, 3, 4, 5, 6, 7, 10]
    function getPageRange(cur, total, delta) {
        const set = new Set([1, total]);
        for (let i = Math.max(1, cur - delta); i <= Math.min(total, cur + delta); i++) {
            set.add(i);
        }
        return [...set].sort((a, b) => a - b);
    }

    // 페이지네이션 렌더링
    function renderPagination() {
        const wrap = document.querySelector('#pagination');
        wrap.innerHTML = '';

        // 이전 버튼
        const prevBtn = createBtn('‹', 'nav', currentPage <= 1);
        prevBtn.addEventListener('click', () => goPage(currentPage - 1));
        wrap.appendChild(prevBtn);

        // 페이지 번호 버튼 + 생략 부호(...) 처리
        const pages = getPageRange(currentPage, totalPage, 2);
        let lastRendered = 0;

        pages.forEach(p => {
            // 이전에 렌더링한 페이지와 1 이상 차이나면 생략 부호 삽입
            if (p - lastRendered > 1) {
                const ellipsis = document.createElement('span');
                ellipsis.className = 'ellipsis';
                ellipsis.textContent = '…';
                wrap.appendChild(ellipsis);
            }

            const pageBtn = createBtn(p, p === currentPage ? 'active' : '', false);
            pageBtn.addEventListener('click', () => goPage(p));
            wrap.appendChild(pageBtn);
            lastRendered = p;
        });

        // 다음 버튼
        const nextBtn = createBtn('›', 'nav', currentPage >= totalPage);
        nextBtn.addEventListener('click', () => goPage(currentPage + 1));
        wrap.appendChild(nextBtn);
    }

    renderPagination();
</script>
</html>