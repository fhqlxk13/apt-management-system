<%--
  Created by IntelliJ IDEA.
  User: PC-24
  Date: 2026-05-04
  Time: 오후 4:30
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>접근 거부 임시페이지</title>
</head>
<body>
    <h1>${msg}</h1>
    <a href="${prevPage}">${prevPage}</a>
</body>
<script>
    document.addEventListener('DOMContentLoaded', event => {
        alert(`\${msg}`);
        location.href = `\${prevPage}`;
    })
</script>
</html>
