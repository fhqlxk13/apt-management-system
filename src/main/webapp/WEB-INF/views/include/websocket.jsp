<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:if test="${not empty sessionScope.SPRING_SECURITY_CONTEXT}">

  <c:set var="loginUser"
         value="${sessionScope.SPRING_SECURITY_CONTEXT.authentication.principal.member}" />

  <script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/stompjs/lib/stomp.min.js"></script>

  <script src="${pageContext.request.contextPath}/js/common/websocket.js"></script>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common/toast.css">

  <script src="${pageContext.request.contextPath}/js/common/toast.js"></script>


  <script>
    document.addEventListener("DOMContentLoaded", function () {

      document.body.dataset.userNo = "${loginUser.userNo}";
      document.body.dataset.contextPath = "${pageContext.request.contextPath}";

      connectWebSocket();
    });
  </script>

</c:if>

<div id="toastContainer"></div>