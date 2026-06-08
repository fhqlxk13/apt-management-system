<%--
  Created by 이윤진 IntelliJ IDEA.
  User: PC-27
  Date: 2026-05-07
  Time: 오후 2:26
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>권한 없음</title>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>
<body>

<script>
    Swal.fire({
        icon: 'warning',
        title: '권한이 없습니다!',
        text: '${message}',
        confirmButtonText: '확인',
        confirmButtonColor: '#14532d'
    }).then(function () {
        location.href = '${pageContext.request.contextPath}${redirectUrl}';
    });
</script>

</body>
</html>
