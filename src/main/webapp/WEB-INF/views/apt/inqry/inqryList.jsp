<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>

<html lang="ko"><head>
  <meta charset="utf-8"/>
  <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
  <script src="https://cdn.tailwindcss.com"></script>
  <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&display=swap" rel="stylesheet"/>
  <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
  <script>
    tailwind.config = {
      theme: {
        extend: {
          colors: {
            "surface": "#fbf9f1",
            "primary": "#3f4c15",
            "secondary": "#5b614c",
            "secondary-container": "#dfe5cb",
            "on-primary-container": "#cfe09a",
            "primary-container": "#56642b",
            "surface-container-low": "#f6f4eb",
            "on-surface": "#1b1c17",
            "on-surface-variant": "#46483c",
            "outline": "#76786b",
            "outline-variant": "#c7c8b8",
            "surface-container": "#f0eee6",
          }
        }
      }
    }
  </script>
  <style>
    body { font-family: 'Manrope', sans-serif; background-color: #fbf9f1; }
    .material-symbols-outlined { font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24; }

    .forest-card {
      border: 1px solid #e2e2e0;
      border-radius: 16px;
      background-color: #ffffff;
      padding: 20px 24px;
      cursor: pointer;
      transition: box-shadow 0.2s;
    }
    .forest-card:hover { box-shadow: 0 4px 16px rgba(0,0,0,0.08); }

    .status-pill {
      border-radius: 9999px;
      padding: 4px 12px;
      font-size: 12px;
      font-weight: 600;
      display: inline-block;
    }

    .detail { display: none; }
    .detail.open { display: block; }

    .chevron { transition: transform 0.25s; }
    .forest-card.open .chevron { transform: rotate(180deg); }

    .pagination{
      display:flex;
      align-items:center;
      gap:8px;
    }

    .pagination .page-item{
      list-style:none;
    }

    .pagination .page-link{
      width:38px;
      height:38px;
      border-radius:9999px;
      display:flex;
      align-items:center;
      justify-content:center;
      background:white;
      border:1px solid #e5e7eb;
      color:#6b7280;
      font-size:14px;
      font-weight:600;
      transition:.2s;
      text-decoration:none;
    }

    .pagination .page-link:hover{
      background:#f9fafb;
    }

    .pagination .active .page-link{
      background:#6F7F3F;
      color:white;
      border-color:#6F7F3F;
    }


  </style>
</head>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/centralSidebarStyle.css">
<body class="bg-surface text-on-surface min-h-screen">

<%@ include file="/WEB-INF/views/include/main_headerLayout.jsp" %>
<%@ include file="/WEB-INF/views/include/central_sidebar.jsp" %>

<main class="ml-80 p-10 pt-28">

  <!-- 제목 -->
  <div class="mb-8">
    <h1 class="text-3xl font-bold text-gray-900 mb-2">문의게시판</h1>
    <p class="text-gray-500 text-sm">입주민 문의 내역을 확인하세요.</p>
  </div>

  <!-- 검색 + 버튼 -->
  <div class="bg-white p-6 rounded-2xl shadow-sm border border-gray-100 mb-6">
    <div class="flex flex-col md:flex-row md:items-center justify-between gap-4">
      <div class="text-sm text-gray-500">
        총 <strong class="text-black">${pagingVO.totalRecord}</strong>건
      </div>
      <div class="flex items-center gap-3">
        <div class="relative w-64">
          <input class="w-full pl-4 pr-10 py-2.5 bg-gray-50 border border-gray-200 rounded-xl text-sm"
                 placeholder="문의 검색" type="text"/>
          <div class="absolute right-3 top-1/2 -translate-y-1/2">
            <svg class="h-5 w-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                    d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
            </svg>
          </div>
        </div>
        <button onclick="location.href='${pageContext.request.contextPath}/apt/board/inqry/writeForm.do'"
                class="px-5 py-2 rounded-full bg-[#6F7F3F] text-white text-sm font-medium hover:bg-[#5f6e35]">
          + 새 문의
        </button>
      </div>
    </div>
  </div>

  <!-- ✅ 카드형 아코디언 목록 (샘플 데이터 하드코딩) -->
  <div class="space-y-3">


<c:if test="${empty pagingVO.dataList}">
    <div class="text-center text-gray-400 py-20">
      등록된 문의가 없습니다.
    </div>
  </c:if>

  <c:forEach var="inqry" items="${pagingVO.dataList}">

    <div class="forest-card" onclick="toggleDetail(this)">

      <div class="flex justify-between items-center">
        <div class="flex-1 min-w-0 pr-4">
          <div class="text-xs text-gray-400 mb-1">
            NO.${inqry.postNo}
          </div>
          <div class="text-base font-semibold text-gray-900">
            ${inqry.ttl}
          </div>
          <div class="text-sm text-gray-500 mt-1">
            작성자 : ${inqry.wrtrNm}
            <c:if test="${not empty inqry.wrtrId}">
              <span class="text-gray-300">(${inqry.wrtrId})</span>
            </c:if>
          </div>
        </div>

        <div class="flex items-center gap-3 flex-shrink-0">
          <div class="flex flex-col items-end gap-1">
            <c:choose>
              <c:when test="${inqry.ansYn eq 'Y'}">
                <span class="status-pill bg-[#dfe5cb] text-[#3f4c15]">답변완료</span>
              </c:when>
              <c:otherwise>
                <span class="status-pill bg-yellow-100 text-yellow-700">답변대기</span>
              </c:otherwise>
            </c:choose>

            <div class="text-xs text-gray-400">
              <fmt:formatDate value="${inqry.regDttm}" pattern="yyyy.MM.dd"/>
            </div>

            <c:if test="${adminMode}">
              <button type="button"
                      onclick="replyInqry('${inqry.postNo}')"
                      class="text-xs text-[#6F7F3F] hover:underline mt-1">
                <c:choose>
                  <c:when test="${inqry.ansYn eq 'Y'}">답변수정</c:when>
                  <c:otherwise>답변하기</c:otherwise>
                </c:choose>
              </button>
            </c:if>

           <c:if test="${inqry.wrtrId eq sessionScope.SPRING_SECURITY_CONTEXT.authentication.principal.member.userId}">

  <div class="flex items-center gap-2 mt-1">

    <button type="button"
            onclick="goUpdate('${inqry.postNo}')"
            class="text-xs text-[#6F7F3F] hover:underline">
      수정
    </button>

    <span class="text-gray-300 text-xs">|</span>

    <button type="button"
            onclick="deleteInqry('${inqry.postNo}')"
            class="text-xs text-red-500 hover:underline">
      삭제
    </button>

  </div>

</c:if>

          </div>

          <span class="material-symbols-outlined chevron text-gray-400">expand_more</span>
        </div>
      </div>

      <div class="detail mt-5 border-t border-gray-100 pt-5">
        <div class="flex gap-4">
          <div class="w-9 h-9 rounded-full bg-gray-100 flex items-center justify-center">👤</div>
          <div class="flex-1">
            <p class="text-sm text-gray-700 leading-relaxed pt-1">
              ${inqry.cn}
            </p>

            <c:if test="${inqry.ansYn eq 'Y'}">
              <div class="mt-4 rounded-2xl border border-[#dfe5cb] bg-[#f7faf3] p-4">
                <div class="flex items-center justify-between mb-2">
                  <strong class="text-sm text-[#3f4c15]">관리자 답변</strong>
                  <span class="text-xs text-gray-400">
                    <fmt:formatDate value="${inqry.ansRegDttm}" pattern="yyyy.MM.dd HH:mm"/>
                  </span>
                </div>
                <div class="text-sm text-gray-700 leading-relaxed">
                  ${inqry.ansCn}
                </div>
                <div class="text-xs text-gray-400 mt-2">
                  작성자 : ${inqry.ansUserNm}
                </div>
              </div>
            </c:if>

            <c:if test="${inqry.ansYn ne 'Y'}">
              <div class="mt-4 rounded-2xl border border-dashed border-gray-200 bg-gray-50 p-4 text-sm text-gray-400">
                아직 관리자가 답변을 등록하지 않았습니다.
              </div>
            </c:if>
          </div>
        </div>
      </div>

    </div>

  </c:forEach>





  </div>
  <%-- 실제 서버 데이터 쓸 때는 위 하드코딩 대신 아래 c:forEach 사용
  <c:forEach var="qna" items="${qnaList}" varStatus="status">
    ...
  </c:forEach>
  --%>

  <!-- 페이징 -->
<div class="mt-10 flex justify-center">
    <c:out value="${pagingVO.pagingHTML}" escapeXml="false"/>
</div>

</main>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script>
  function toggleDetail(card) {
    const detail = card.querySelector('.detail');
    if (!detail) return;

    const isOpen = detail.classList.contains('open');

    if (isOpen) {
      // 닫기
      detail.classList.remove('open');
      card.classList.remove('open');
    } else {
      // 열기 (다른거 건드리지 않음)
      detail.classList.add('open');
      card.classList.add('open');
    }
  }

  function deleteInqry(postNo) {
    event.stopPropagation();

    if (!confirm("삭제하시겠습니까?")) return;

    location.href =
            '${pageContext.request.contextPath}/apt/board/inqry/delete.do?postNo=' + postNo;
  }

  $(document).on("click", ".page-link", function(e){

    e.preventDefault();

    const page = $(this).data("page");

    if(!page){
      return;
    }

    location.href =
            '${pageContext.request.contextPath}/apt/board/inqry/list.do?page=' + page;
  });

  function goUpdate(postNo) {

    event.stopPropagation();

    location.href =
            '${pageContext.request.contextPath}/apt/board/inqry/updateForm.do?postNo=' + postNo;
  }

  function replyInqry(postNo) {
    event.stopPropagation();

    location.href =
            '${pageContext.request.contextPath}/apt/board/inqry/replyForm.do?postNo=' + postNo;
  }

</script>
</body>
</html>
