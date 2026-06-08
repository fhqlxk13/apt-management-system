<%--
  Created by IntelliJ IDEA.
  User: LYR
  Date: 2026-04-29
  Time: 오후 5:11
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Title</title>
</head>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>나의 아파트 선택</title>
    <style>
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }

        tr:hover {
            background-color: #f5f5f5;
            cursor: pointer;
        }

        .btn-select {
            background: #226046;
            color: white;
            padding: 6px 12px;
            border-radius: 4px;
            text-decoration: none;
            font-size: 14px;
        }
    </style>
</head>
<body>

<c:choose>
    <c:when test="${not empty resident.myAptList}">
        <table>
            <thead>
            <tr>
                <th colspan="3"><h1>🏢 나의 아파트</h1></th>
            </tr>
            <tr>
                <th>지역</th>
                <th>아파트</th>
                <th></th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="myapt" items="${resident.myAptList}">
                <tr onclick="selectApt('${myapt.aptCmplexNo}')">
                    <td>
                        ${myapt.sidoNm}&nbsp;${myapt.sigunguNm}
                    </td>
                    <td>
                        <strong>${myapt.aptCmplexNm}</strong>
                            ${myapt.dongNm}동 ${myapt.ho}호
                    </td>
                    <td>
                        <button type="button" class="btn-select">GO!</button>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </c:when>
    <c:otherwise>
        <p>조회된 아파트가 없습니다!</p>
    </c:otherwise>
</c:choose>

<script>
    function selectApt(aptCmplexNo) {
        // 1. 나를 열어준 부모창(opener)이 살아있는지 확인
        if (window.opener && !window.opener.closed) {

            // 2. 부모창의 주소를 변경
            const url = `/apt/main/\${aptCmplexNo}`;
            window.opener.location.href = url;

            // 3. 팝업창 닫기
            window.close();
        } else {
            alert("부모창(메인 페이지)을 찾을 수 없습니다.");
            window.close();
        }
    }
</script>
</body>
</html>
</html>
