<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>마이페이지 비밀번호 확인</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="min-h-screen bg-gray-50 flex items-center justify-center px-4">
    <div class="w-full max-w-md bg-white rounded-2xl shadow-sm p-8">
        <h1 class="text-2xl font-bold text-gray-900">마이페이지 비밀번호 확인</h1>
        <p class="mt-2 text-sm text-gray-500">본인 확인을 위해 비밀번호를 입력하세요.</p>

        <c:if test="${not empty error}">
            <div class="mt-4 rounded-lg bg-red-50 px-4 py-3 text-sm text-red-700">
                ${error}
            </div>
        </c:if>

        <form class="mt-6 space-y-4" action="${pageContext.request.contextPath}/member/myPageAuth.do" method="post">
            <sec:csrfInput/>

            <div>
                <label for="userPw" class="mb-2 block text-sm font-medium text-gray-700">비밀번호</label>
                <input
                        type="password"
                        id="userPw"
                        name="userPw"
                        class="w-full rounded-lg border border-gray-300 px-4 py-3 outline-none focus:border-green-600"
                        placeholder="비밀번호를 입력하세요"
                        autocomplete="new-password"
                        required>
            </div>

            <div class="flex gap-3">
                <button type="button"
                        onclick="history.back()"
                        class="flex-1 rounded-lg border border-gray-300 px-4 py-3 text-sm font-semibold text-gray-700">
                    취소
                </button>
                <button type="submit"
                        class="flex-1 rounded-lg bg-green-700 px-4 py-3 text-sm font-semibold text-white">
                    확인
                </button>
            </div>
        </form>
    </div>
</body>
</html>
