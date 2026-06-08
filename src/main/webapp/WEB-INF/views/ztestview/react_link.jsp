<%--
  Created by IntelliJ IDEA.
  User: PC-24
  Date: 2026-05-06
  Time: 오후 12:25
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<html>
<head>
    <title>Link</title>
</head>
<body>
  <sec:authorize access="hasRole('MEMBER')">
    <a href="http://localhost:7777">리액트 페이지</a>
  </sec:authorize>
  <!-- 권한이 없는 사용자에게 보여줄 메시지 (선택 사항) -->
  <sec:authorize access="!hasRole('MEMBER')">
    <p style="color: red;">권한이 없습니다. 관리자에게 문의하세요.</p>
  </sec:authorize>
</body>
</html>
