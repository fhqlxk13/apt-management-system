<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>계약 신청 내역 조회</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-[#F3F6EC] p-8">
<%@ include file="/WEB-INF/views/include/main_headerLayout.jsp" %>
<%@ include file="/WEB-INF/views/include/central_sidebar.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/centralSidebarStyle.css">
<div class="max-w-4xl mx-auto space-y-6">

  <!-- 1. 제목 -->
  <div>
    <h1 class="text-2xl font-bold">계약 신청 내역 조회</h1>
    <p class="text-gray-400 text-sm">전월세 계약 신청</p>
  </div>

  <!-- 2. 신청 카드 -->
  <div class="bg-white rounded-xl shadow border border-[#E2E8D5] p-6 space-y-4">

    <div class="flex justify-between items-center">
      <div>
        <h2 class="font-semibold text-lg">전월세 계약 신청</h2>
        <p class="text-sm text-gray-400">
          신청일 2026.04.09 · 접수번호 LS-2026-0409-11 · 신청자 김태현
        </p>
      </div>
      <span class="bg-[#E6EED6] text-[#6F7F3F] px-3 py-1 rounded-full text-sm">
  승인 완료
</span>
    </div>

    <p class="text-sm text-gray-500">
      제출한 전월세 계약서는 기준으로 거주 정보와 계약 기간을 확인하고 있습니다.
      확인이 완료되면 세대 정보와 계약 상태가 신청 내역에 반영됩니다.
    </p>

    <button class="px-4 py-2 bg-gray-100 rounded-lg text-sm">
      상세 내역 보기
    </button>

  </div>

  <!-- 3. 상태 추적 -->
  <div class="bg-white rounded-xl shadow p-6 space-y-4">

    <div class="flex justify-between items-center">
      <h2 class="text-lg font-semibold">신청 상태 추적</h2>
      <span class="text-sm text-gray-400">전월세 계약 신청 진행 상태</span>
    </div>

    <div class="grid grid-cols-4 gap-4 text-center">

      <div class="p-4 border rounded-lg">
        <div class="w-8 h-8 mx-auto bg-[#6F7F3F] text-white rounded-full flex items-center justify-center text-sm">1</div>
        <p class="mt-2 font-medium">신청 접수</p>
        <p class="text-xs text-gray-400">2026.04.12</p>
      </div>

      <div class="p-4 border rounded-lg">
        <div class="w-8 h-8 mx-auto bg-[#6F7F3F] text-white rounded-full flex items-center justify-center text-sm">2</div>

        <p class="mt-2 font-medium">서류 확인</p>
        <p class="text-xs text-gray-400">2026.04.13</p>
      </div>

      <div class="p-4 border rounded-lg">
        <div class="w-8 h-8 mx-auto bg-[#6F7F3F] text-white rounded-full flex items-center justify-center text-sm">3</div>
        <p class="mt-2 font-medium">관리사무소 검토</p>
        <p class="text-xs text-gray-400">진행 중</p>
      </div>

      <div class="p-4 border rounded-lg">
        <div class="w-8 h-8 mx-auto bg-gray-300 text-white rounded-full flex items-center justify-center text-sm">4</div>
        <p class="mt-2 font-medium">승인 완료</p>
        <p class="text-xs text-gray-400">대기</p>
      </div>

    </div>

  </div>

  <!-- 4. 안내 메시지 -->
  <div class="bg-white rounded-xl shadow p-4 text-sm text-gray-500">
    현재 단계 <b>서류 확인</b>이 완료되면 신청 내용에 세대 정보에 반영될 예정입니다.
  </div>

</div>

</body>
</html>