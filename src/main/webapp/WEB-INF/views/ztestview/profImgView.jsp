<%--
  Created by IntelliJ IDEA.
  User: PC-24
  Date: 2026-04-28
  Time: 오전 11:28
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
<h1>profImgView.jsp</h1>
<img src="/file/display/${file.googleId}" alt="엑스박스"/>
<a href="/file/download/${file.googleId}" class="btn-download">파일 다운로드</a>

<div>
    <button class="btn-primary" id="myHomeBtn">우리집 가기</button>
</div>
</body>
<script>
    const myHomeBtn = document.querySelector('#myHomeBtn');
    myHomeBtn.addEventListener('click', () => {
        location.href="/apt/myHome";
    });

</script>
</html>
