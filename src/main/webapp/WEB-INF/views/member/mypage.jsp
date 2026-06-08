<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>마이페이지</title>

    <script src="https://cdn.tailwindcss.com"></script>

    <style>
        .toggle {
            width: 42px;
            height: 22px;
            appearance: none;
            background: #d1d5db;
            border-radius: 9999px;
            position: relative;
            cursor: pointer;
            transition: all 0.3s;
        }

        .toggle:checked {
            background: #16a34a;
        }

        .toggle::before {
            content: "";
            width: 18px;
            height: 18px;
            background: #fff;
            border-radius: 50%;
            position: absolute;
            top: 2px;
            left: 2px;
            transition: 0.3s;
        }

        .toggle:checked::before {
            transform: translateX(20px);
        }

        .form-group {
            display: flex;
            flex-direction: column;
            margin-bottom: 20px;
        }

        .form-label {
            font-weight: bold;
            margin-bottom: 8px;
        }

        .input-control {
            width: 100%;
            padding: 15px;
            border: 1px solid #DDD;
            border-radius: 10px;
            font-size: 14px;
            background-color: #FFF;
        }

        .input-control::placeholder {
            color: #aaa;
        }

        .toggle:disabled {
            opacity: 0.35;
            cursor: not-allowed;
            pointer-events: none;
        }

        .card {
            background: #fff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        .form-grid div {
            display: flex;
            flex-direction: column;
        }

        label {
            font-size: 14px;
            margin-bottom: 5px;
            color: #777;
        }

        input {
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 6px;
        }

        input:read-only {
            background-color: #f5f5f5;
        }

        .btn-area {
            margin-top: 20px;
            text-align: right;
        }

        button {
            padding: 10px 16px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
        }

        #editBtn {
            background: #666;
            color: #fff;
        }

        #saveBtn {
            background: #4CAF50;
            color: #fff;
        }

    </style>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/centralSidebarStyle.css">
    <%@ include file="/WEB-INF/views/include/central_sidebar.jsp" %>
</head>
<body class="bg-gray-50">

<%@ include file="/WEB-INF/views/include/main_headerLayout.jsp" %>
<div class="ml-64 min-h-screen px-20 pt-28 pb-10">
    <!-- 상단 -->
    <div class="flex justify-between items-center mb-8">
        <div>
            <h1 class="text-3xl font-bold">마이페이지</h1>
            <p class="text-gray-500">회원 정보 확인</p>
        </div>

        <div class="bg-[#E6EED6] text-[#6F7F3F] px-4 py-2 rounded-full font-semibold">
            이용중
        </div>
    </div>

    <div class="grid grid-cols-2 gap-6">

        <div class="col-span-1">
        </div>

        <div class="col-span-3 grid grid-cols-[1.2fr_1.5fr_1.3fr] gap-6">


            <!-- 좌측 프로필 -->
            <div class="bg-white rounded-2xl p-5 shadow-sm">

                <div class="w-24 h-24 mx-auto rounded-full bg-green-100 flex items-center justify-center text-2xl font-bold text-green-700">
                    <c:choose>
                        <c:when test="${empty file.googleId}">
                            ${fn:substring(member.userNm,0,1)}
                        </c:when>
                        <c:otherwise>
                            <img src="/file/display/${file.googleId}" alt="${file.googleId}" class="w-full h-full object-cover rounded-full">
                        </c:otherwise>
                    </c:choose>
                </div>

                <h2 class="text-center text-xl font-bold mt-4"></h2>

                <p class="text-center text-gray-500 text-sm">
                    가입일: <fmt:formatDate value="${member.regDt}" pattern="yyyy-MM-dd"/>
                </p>

                <div class="border-t mt-6 pt-4 grid grid-cols-2 text-center">

                    <div>
                        <p class="text-gray-400 text-xs">회원번호</p>
                        <p class="font-semibold">${member.userNo}</p>
                    </div>
                    <div>
                        <p class="text-gray-400 text-xs">회원구분</p>
                        <p class="font-semibold">
                            <c:choose>
                                <c:when test="${member.authList[0].auth =='ROLE_ADMIN'}">중앙관리자</c:when>
                                <c:when test="${member.authList[0].auth =='ROLE_MNGR'}">단지관리자</c:when>
                                <c:when test="${member.authList[0].auth =='ROLE_RESIDENT'}">입주민</c:when>
                                <c:otherwise>일반회원</c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                </div>
                <!-- 🔥 계약신청내역조회 버튼 -->
                <div class="mt-6">
                    <button onclick="openContractPage()"
                            class="w-full bg-[#226046] text-white py-4 rounded-full font-bold hover:bg-[#226046] transition">
                        계약신청내역조회
                    </button>
                </div>

                <%-- 2026.05.08 추가: 관리소장(ROLE_MNGR) / 중앙관리자(ROLE_ADMIN) 전용 관리사무소 페이지 이동 버튼 --%>
                <c:if test="${member.authList[0].auth == 'ROLE_ADMIN' || member.authList[0].auth == 'ROLE_MNGR'}">
                    <div class="mt-3">
                        <button type="button"
                                onclick="location.href='${pageContext.request.contextPath}/manager/main'"
                                class="w-full bg-white text-[#226046] border border-[#226046] py-4 rounded-full font-bold hover:bg-[#f4f9f6] transition">
                            관리사무소 페이지
                        </button>
                    </div>
                </c:if>
                <%-- // 2026.05.08 추가 끝: 관리사무소 페이지 이동 버튼 --%>

            </div>
            <div class="bg-white rounded-2xl p-6 shadow-sm">
                <form id="updateForm" action="${pageContext.request.contextPath}/member/updateSimple" method="post" class="space-y-6">

                    <!-- 🔥 반드시 필요 -->

                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>


                    <input type="hidden" name="userNo" value="${member.userNo}"/>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">

                        <!-- 이름 -->
                        <div class="space-y-2">
                            <label class="text-gray-500">이름</label>
                            <input type="text" name="userNm"
                                   value="${member.userNm}"
                                   class="w-full border rounded-lg px-4 py-3 focus:ring-2 focus:ring-green-500">
                        </div>

                        <!-- 아이디 -->
                        <div class="space-y-2">
                            <label class="text-gray-500">아이디</label>
                            <input type="text" value="${member.userId}" readonly
                                   class="w-full bg-gray-100 border rounded-lg px-4 py-3 text-gray-500">
                        </div>

                    </div>

                    <hr class="my-2"/>

                    <!-- 🔥 수정 가능 영역 -->
                    <div class="space-y-6">

                        <div class="space-y-2">
                            <label>이메일</label>
                            <input type="email" name="userEml"
                                   value="${member.userEml}"
                                   class="w-full border rounded-lg px-4 py-3 focus:ring-2 focus:ring-green-500">
                        </div>

                        <div class="space-y-2">
                            <label>연락처</label>
                            <input type="text" name="userTelno"
                                   value="${member.userTelno}"
                                   class="w-full border rounded-lg px-4 py-3 focus:ring-2 focus:ring-green-500">
                        </div>

                        <div class="space-y-2">
                            <label>비밀번호</label>
                            <input type="password" name="userPw"
                                   placeholder="변경 시 입력"
                                   class="w-full border rounded-lg px-4 py-3 focus:ring-2 focus:ring-green-500">
                        </div>

                    </div>

                    <!-- 버튼 -->
                    <div class="pt-4">
                        <button type="submit"
                                class="w-full bg-[#226046] text-white py-4 rounded-full font-bold hover:bg-[#226046] transition">
                            수정 완료
                        </button>
                    </div>

                </form>
            </div>
            <div class="bg-white rounded-2xl shadow-sm divide-y">
                <!-- 하단 버튼 -->
                <div class="flex justify-end gap-3 mt-6">
                </div>


                <!-- SMS 전체 -->
                <div class="px-6 py-5">

                    <!-- 부모 -->
                    <div class="flex justify-between items-center mb-4">
                        <div>
                            <p class="font-semibold">문자 알림</p>
                        </div>
                        <input type="checkbox"
                               id="smsRcv"
                               name="smsRcvYn"
                               class="toggle"
                        ${smsRcv ? "checked":""}>
                    </div>

                    <!-- 자식 -->
                    <div class="ml-6 space-y-4">

                        <!-- 공지 -->
                        <div class="flex justify-between items-center">
                            <div>
                                <p class="font-medium">공지사항 알림</p>
                                <p class="text-xs text-gray-400"></p>
                            </div>
                            <input type="checkbox"
                                   class="toggle sms-child"
                                   name="smsNtcRcvYn"
                            ${smsNtcRcv ? "checked":""}>
                        </div>

                        <!-- 계약 -->
                        <div class="flex justify-between items-center">
                            <div>
                                <p class="font-medium">계약 상태 알림</p>
                                <p class="text-xs text-gray-400"></p>
                            </div>
                            <input type="checkbox"
                                   class="toggle sms-child"
                                   name="smsCtrtRcvYn"
                            ${smsCtrtRcv ? "checked":""}>
                        </div>

                    </div>
                </div>

                <!-- 이메일 전체 -->
                <div class="px-6 py-5">

                    <!-- 부모 -->
                    <div class="flex justify-between items-center mb-4">
                        <div>
                            <p class="font-semibold">이메일 알림</p>
                            <p class="text-sm text-gray-400"></p>
                        </div>
                        <input type="checkbox"
                               id="emlRcv"
                               name="emlRcvYn"
                               class="toggle"
                        ${emlRcv ? "checked":""}>
                    </div>

                    <!-- 자식 -->
                    <div class="ml-6 space-y-4">

                        <!-- 공지 -->
                        <div class="flex justify-between items-center">
                            <div>
                                <p class="font-medium">공지사항 알림</p>
                                <p class="text-xs text-gray-400"></p>
                            </div>
                            <input type="checkbox"
                                   class="toggle eml-child"
                                   name="emlNtcRcvYn"
                            ${emlNtcRcv ? "checked":""}>
                        </div>

                        <!-- 계약 -->
                        <div class="flex justify-between items-center">
                            <div>
                                <p class="font-medium">계약 상태 알림</p>
                                <p class="text-xs text-gray-400"></p>
                            </div>
                            <input type="checkbox"
                                   class="toggle eml-child"
                                   name="emlCtrtRcvYn"
                            ${emlCtrtRcv ? "checked":""}>
                        </div>

                    </div>
                </div>

                <div class="p-6 flex justify-end">

                    <form action="${pageContext.request.contextPath}/member/delete"
                          method="post"
                          onsubmit="return confirm('정말 탈퇴하시겠습니까?');">

                        <button type="submit"
                                class="px-3 py-1 text-sm bg-red-500 text-white rounded-full hover:bg-red-600 transition">
                            탈퇴하기
                        </button>
                    </form>

                </div>
            </div>


        </div>
        <!-- 🔥 알림 설정 -->

        <!-- SMS 수신 (부모) -->
        <!-- 🔥 알림 설정 -->

        <meta name="_csrf" content="${_csrf.token}"/>
        <meta name="_csrf_header" content="${_csrf.headerName}"/>
    </div>
</div>
<c:if test="${msg eq 'success'}">
   <div id="toastMsg"
     class="fixed top-20 left-1/2 -translate-x-1/2 bg-[#6F7F3F] text-white px-6 py-4 rounded-xl shadow-lg flex items-center gap-3 z-50 opacity-0 translate-y-[-20px] transition-all duration-500">
        <span class="font-semibold">회원정보가 수정되었습니다.</span>
    </div>


</c:if>
</body>
<%@ include file="/WEB-INF/views/include/main_footerLayout.jsp" %>
<script>
    document.addEventListener("DOMContentLoaded", function () {

        const smsParent = document.getElementById("smsRcv");
        const emlParent = document.getElementById("emlRcv");
        const smsChildren = document.querySelectorAll(".sms-child");
        const emlChildren = document.querySelectorAll(".eml-child");



        const toast = document.getElementById("toastMsg");
        if (toast) {
            toast.classList.remove("opacity-0", "translate-y-[-20px]");

            setTimeout(() => {
                toast.classList.add("opacity-0", "translate-y-[-20px]");
            }, 3000);

            setTimeout(() => {
                toast.remove();
            }, 3500);
        }






        /* ── localStorage 키 ── */
        const LS_KEY = "alarmSettings";

        /* ── localStorage에서 복원 ── */
        function restoreFromStorage() {
            const saved = localStorage.getItem(LS_KEY);
            if (!saved) return;
            const s = JSON.parse(saved);

            smsParent.checked = s.smsRcvYn === 'Y';
            emlParent.checked = s.emlRcvYn === 'Y';

            document.querySelector("[name=smsNtcRcvYn]").checked = s.smsNtcRcvYn === 'Y';
            document.querySelector("[name=smsCtrtRcvYn]").checked = s.smsCtrtRcvYn === 'Y';
            document.querySelector("[name=emlNtcRcvYn]").checked = s.emlNtcRcvYn === 'Y';
            document.querySelector("[name=emlCtrtRcvYn]").checked = s.emlCtrtRcvYn === 'Y';
        }

        /* ── 자식 토글 활성/비활성 ── */
        function updateSmsChildren() {
            smsChildren.forEach(ch => {
                if (!smsParent.checked) {
                    ch.checked = false;
                    ch.disabled = true;
                } else {
                    ch.disabled = false;
                    ch.checked = true;
                }
            });
        }

        function updateEmlChildren() {
            emlChildren.forEach(ch => {
                if (!emlParent.checked) {
                    ch.checked = false;
                    ch.disabled = true;
                } else {
                    ch.disabled = false;
                    ch.checked = true;
                }
            });
        }

        /* ── 서버 저장 + localStorage 저장 ── */
        function updateAlarmSetting() {

            const token = document.querySelector("meta[name='_csrf']").content;
            const header = document.querySelector("meta[name='_csrf_header']").content;

            const smsOn = smsParent.checked;
            const emlOn = emlParent.checked;

            const data = {
                smsRcvYn: smsOn ? 'Y' : 'N',
                smsNtcRcvYn: smsOn && document.querySelector("[name=smsNtcRcvYn]").checked ? 'Y' : 'N',
                smsCtrtRcvYn: smsOn && document.querySelector("[name=smsCtrtRcvYn]").checked ? 'Y' : 'N',

                emlRcvYn: emlOn ? 'Y' : 'N',
                emlNtcRcvYn: emlOn && document.querySelector("[name=emlNtcRcvYn]").checked ? 'Y' : 'N',
                emlCtrtRcvYn: emlOn && document.querySelector("[name=emlCtrtRcvYn]").checked ? 'Y' : 'N'
            };

            /* localStorage에 즉시 저장 */
            localStorage.setItem(LS_KEY, JSON.stringify(data));


            fetch("/member/alarm/update", {


                method: "POST",
                headers: {
                    "Content-Type": "application/json",
                    [header]: token
                },
                body: JSON.stringify(data)
            });
        }

        /* ── 이벤트 등록 (부모) ── */
        smsParent.addEventListener("change", () => {
            updateSmsChildren();
            updateAlarmSetting();
        });

        emlParent.addEventListener("change", () => {
            updateEmlChildren();
            updateAlarmSetting();
        });

        /* ── 이벤트 등록 (자식) ── */
        smsChildren.forEach(cb => cb.addEventListener("change", updateAlarmSetting));
        emlChildren.forEach(cb => cb.addEventListener("change", updateAlarmSetting));

        /* ── 페이지 로드 시: localStorage 우선, 없으면 서버값 유지 ── */
        restoreFromStorage();
        updateSmsChildren();
        updateEmlChildren();
    });

    const saveBtn = document.getElementById("saveBtn");
    const form = document.getElementById("updateForm");

    function openContractPage() {
        window.open(
            "/contract/list.do",   // 👉 연결할 JSP or 컨트롤러 URL
            "contractPopup",
            "width=1000,height=700,scrollbars=yes"
        );
    }


</script>
</html>
