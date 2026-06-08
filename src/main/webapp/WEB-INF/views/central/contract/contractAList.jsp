<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&display=swap"
          rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap"
          rel="stylesheet"/>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        body {
            font-family: 'Manrope', sans-serif;
            background-color: #f8faf6;
        }

        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
        }

        .status-step {
            display: flex;
            align-items: flex-start;
            gap: 12px;
            position: relative;
        }

        .status-step:not(:last-child)::after {
            content: '';
            position: absolute;
            left: 11px;
            top: 26px;
            width: 2px;
            height: calc(100% - 4px);
            background: #e2e8e0;
        }

        .status-step.done:not(:last-child)::after {
            background: #226046;
        }

        .status-step.done-end::after {
            background: #e2e8e0 !important;
        }

        .status-step.done-submit:not(:last-child)::after {
            background: #e2e8e0;
        }
    </style>
</head>
<body class="bg-[#f8faf6] text-[#191c1a]">

<%@ include file="/WEB-INF/views/include/main_headerLayout.jsp" %>
<%@ include file="/WEB-INF/views/include/central_sidebar.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/centralSidebarStyle.css">

<main class="ml-80 p-8 pt-28">

    <div class="mb-6">
        <h1 class="text-xl font-bold text-[#004830] mb-1" >청약 신청 조회</h1>
        <p class="text-sm text-slate-400">내가 신청한 청약 내역을 확인할 수 있습니다.</p>
    </div>

    <c:choose>
        <c:when test="${not empty list}">
            <c:forEach var="aplct" items="${list}">
                <div class="bg-white rounded-2xl shadow-sm border border-[#eef2eb] mb-5 overflow-hidden">
                    <div class="h-1 w-full bg-gradient-to-r from-[#004830] via-[#226046] to-[#95d4b3]"></div>

                    <!-- 신청 기본 정보 -->
                    <div class="p-6 border-b border-[#eef2eb]">
                        <div class="flex items-center justify-between">
                            <div class="space-y-1">
                                <p class="text-xs text-slate-400">신청번호</p>
                                <a href="/contract/historyDetail.do?aplctNo=${aplct.APLCT_NO}"><p
                                        class="text-lg font-bold text-[#004830]">${aplct.APLCT_NO}</p></a>
                            </div>
                            <div class="text-right space-y-1">
                                <c:choose>
                                    <c:when test="${aplct.APLCT_STTS_CD == 'SUBMIT'}">
                                        <span class="inline-block px-3 py-1 rounded-full bg-blue-50 text-blue-600 text-xs font-bold">신청완료</span>
                                    </c:when>
                                    <c:when test="${aplct.APLCT_STTS_CD == 'WINNER'}">
                                        <span class="inline-block px-3 py-1 rounded-full bg-blue-50 text-blue-600 text-xs font-bold">서류 제출 필요</span>
                                    </c:when>
                                    <c:when test="${aplct.APLCT_STTS_CD == 'SUPPLEMENT'}">
                                        <span class="inline-block px-3 py-1 rounded-full bg-orange-50 text-orange-500 text-xs font-bold">서류 보완 필요</span>
                                    </c:when>
                                    <c:when test="${aplct.APLCT_STTS_CD == 'QUALIFIED'}">
                                        <span class="inline-block px-3 py-1 rounded-full bg-green-50 text-green-600 text-xs font-bold">검증 완료</span>
                                    </c:when>
                                    <c:when test="${aplct.APLCT_STTS_CD == 'INSPECTION'}">
                                        <span class="inline-block px-3 py-1 rounded-full bg-blue-50 text-blue-500 text-xs font-bold">서류 검토 중</span>
                                    </c:when>
                                    <c:when test="${aplct.APLCT_STTS_CD == 'LOSER'}">
                                        <span class="inline-block px-3 py-1 rounded-full bg-amber-50 text-amber-600 text-xs font-bold">낙첨</span>
                                    </c:when>
                                    <c:when test="${aplct.APLCT_STTS_CD == 'CANCEL'}">
                                        <span class="inline-block px-3 py-1 rounded-full bg-red-50 text-red-500 text-xs font-bold">취소</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="inline-block px-3 py-1 rounded-full bg-slate-100 text-slate-500 text-xs font-bold">${aplct.APLCT_STTS_CD}</span>
                                    </c:otherwise>
                                </c:choose>
                                <p class="text-xs text-slate-400">${fn:substring(fn:replace(aplct.REG_DT, '-', '.'), 0, 16)}
                                    신청</p>
                            </div>
                        </div>
                    </div>

                    <!-- 공고 정보 + 진행상태 -->
                    <div class="grid grid-cols-3 gap-0">

                        <!-- 공고 정보 -->
                        <div class="col-span-2 p-6 border-r border-[#eef2eb]">
                            <p class="text-xs font-bold text-[#004830] mb-3 flex items-center gap-2">
                                <span class="material-symbols-outlined text-[16px]">apartment</span>
                                공고 정보
                            </p>
                            <div class="space-y-2 text-sm">
                                <div class="flex items-center gap-2">
                                    <span class="text-slate-400 w-20 flex-shrink-0">공고명</span>
                                    <span class="text-slate-700">${aplct.TTL}</span>
                                </div>
                                <div class="flex items-center gap-2">
                                    <span class="text-slate-400 w-20 flex-shrink-0">아파트 단지</span>
                                    <span class="text-slate-700 font-medium">${aplct.APT_CMPLEX_NM}</span>
                                </div>
                                <div class="flex items-center gap-2">
                                    <span class="text-slate-400 w-20 flex-shrink-0">공고번호</span>
                                    <span class="text-slate-700">${aplct.ANN_NO}</span>
                                </div>
                                <div class="flex items-center gap-2">
                                    <span class="text-slate-400 w-20 flex-shrink-0">타입</span>
                                    <span class="text-slate-700">${aplct.TY_NM}</span>
                                </div>
                                <div class="flex items-center gap-2">
                                    <span class="text-slate-400 w-20 flex-shrink-0">전용면적</span>
                                    <span class="text-slate-700">${aplct.EXCLUSIVE_SIZE}㎡</span>
                                </div>
                            </div>
                        </div>

                            <%-- 진행 상태 --%>
                        <div class="col-span-1 p-6">
                            <p class="text-xs font-bold text-[#004830] mb-4 flex items-center gap-2">
                                <span class="material-symbols-outlined text-[16px]">timeline</span>
                                진행 상태
                            </p>
                            <div class="space-y-4">

                                    <%-- 1단계: 신청완료 --%>
                                <c:choose>
                                    <c:when test="${aplct.APLCT_STTS_CD == 'CANCEL'}">
                                        <div class="status-step done-end">
                                            <div class="w-6 h-6 rounded-full flex items-center justify-center flex-shrink-0 mt-0.5 bg-red-400 text-white">
                                                <span class="material-symbols-outlined text-[14px]">close</span>
                                            </div>
                                            <div class="pb-4">
                                                <p class="text-sm font-semibold text-red-400">취소</p>
                                                <p class="text-xs text-slate-400 mt-0.5">신청이 취소되었습니다.</p>
                                            </div>
                                        </div>
                                    </c:when>
                                    <c:when test="${aplct.APLCT_STTS_CD == 'LOSER'}">
                                        <div class="status-step done-end">
                                            <div class="w-6 h-6 rounded-full flex items-center justify-center flex-shrink-0 mt-0.5 bg-amber-400 text-white">
                                                <span class="material-symbols-outlined text-[14px]">remove</span>
                                            </div>
                                            <div class="pb-4">
                                                <p class="text-sm font-semibold text-amber-500">낙첨</p>
                                                <p class="text-xs text-slate-400 mt-0.5">아쉽게도 낙첨되었습니다.</p>
                                            </div>
                                        </div>
                                    </c:when>
                                    <c:when test="${aplct.APLCT_STTS_CD == 'SUBMIT'}">
                                        <div class="status-step done-submit">
                                            <div class="w-6 h-6 rounded-full flex items-center justify-center flex-shrink-0 mt-0.5 bg-[#226046] text-white">
                                                <span class="material-symbols-outlined text-[14px]">check</span>
                                            </div>
                                            <div class="pb-4">
                                                <p class="text-sm font-semibold text-[#226046]">신청 완료</p>
                                                <p class="text-xs text-slate-400 mt-0.5">추첨 대기 중입니다.</p>
                                            </div>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="status-step done">
                                            <div class="w-6 h-6 rounded-full flex items-center justify-center flex-shrink-0 mt-0.5 bg-[#226046] text-white">
                                                <span class="material-symbols-outlined text-[14px]">check</span>
                                            </div>
                                            <div class="pb-4">
                                                <p class="text-sm font-semibold text-[#226046]">신청 완료</p>
                                                <p class="text-xs text-slate-400 mt-0.5">청약 신청이 완료되었습니다.</p>
                                            </div>
                                        </div>
                                    </c:otherwise>
                                </c:choose>

                                    <%-- 2단계: 서류제출 --%>
                                <c:choose>
                                    <c:when test="${aplct.APLCT_STTS_CD == 'QUALIFIED'}">
                                        <div class="status-step done">
                                            <div class="w-6 h-6 rounded-full flex items-center justify-center flex-shrink-0 mt-0.5 bg-[#226046] text-white">
                                                <span class="material-symbols-outlined text-[14px]">check</span>
                                            </div>
                                            <div class="pb-4">
                                                <p class="text-sm font-semibold text-[#226046]">서류 제출 완료</p>
                                                <p class="text-xs text-slate-400 mt-0.5">서류가 확인되었습니다.</p>
                                            </div>
                                        </div>
                                    </c:when>
                                    <c:when test="${aplct.APLCT_STTS_CD == 'WINNER'}">
                                        <div class="status-step done-end">
                                            <div class="w-6 h-6 rounded-full flex items-center justify-center flex-shrink-0 mt-0.5 bg-blue-400 text-white">
                                                <span class="material-symbols-outlined text-[14px]">upload_file</span>
                                            </div>
                                            <div class="pb-4">
                                                <p class="text-sm font-semibold text-blue-500">서류 제출 필요</p>
                                                <p class="text-xs text-slate-400 mt-0.5">서류를 제출해 주세요.</p>
                                            </div>
                                        </div>
                                    </c:when>
                                    <c:when test="${aplct.APLCT_STTS_CD == 'INSPECTION'}">
                                        <div class="status-step done-end">
                                            <div class="w-6 h-6 rounded-full flex items-center justify-center flex-shrink-0 mt-0.5 bg-blue-400 text-white">
                                                <span class="material-symbols-outlined text-[14px]">manage_search</span>
                                            </div>
                                            <div class="pb-4">
                                                <p class="text-sm font-semibold text-blue-500">서류 검토 중</p>
                                                <p class="text-xs text-slate-400 mt-0.5">서류를 검토 중입니다.</p>
                                            </div>
                                        </div>
                                    </c:when>
                                    <c:when test="${aplct.APLCT_STTS_CD == 'SUPPLEMENT'}">
                                        <div class="status-step done-end">
                                            <div class="w-6 h-6 rounded-full flex items-center justify-center flex-shrink-0 mt-0.5 bg-orange-400 text-white">
                                                <span class="material-symbols-outlined text-[14px]">warning</span>
                                            </div>
                                            <div class="pb-4">
                                                <p class="text-sm font-semibold text-orange-500">서류 보완 필요</p>
                                                <p class="text-xs text-slate-400 mt-0.5">서류 보완이 필요합니다.</p>
                                            </div>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <%-- SUBMIT, LOSER, CANCEL --%>
                                        <div class="status-step">
                                            <div class="w-6 h-6 rounded-full flex items-center justify-center flex-shrink-0 mt-0.5 bg-slate-100 text-slate-300">
                                                <span class="material-symbols-outlined text-[14px]">upload_file</span>
                                            </div>
                                            <div class="pb-4">
                                                <p class="text-sm font-semibold text-slate-300">서류 제출 필요</p>
                                                <p class="text-xs text-slate-300 mt-0.5">해당 없음</p>
                                            </div>
                                        </div>
                                    </c:otherwise>
                                </c:choose>

                                    <%-- 3단계: 승인완료 --%>
                                <c:choose>
                                    <c:when test="${aplct.APLCT_STTS_CD == 'QUALIFIED'}">
                                        <div class="status-step">
                                            <div class="w-6 h-6 rounded-full flex items-center justify-center flex-shrink-0 mt-0.5 bg-[#226046] text-white">
                                                <span class="material-symbols-outlined text-[14px]">check</span>
                                            </div>
                                            <div>
                                                <p class="text-sm font-semibold text-[#226046]">승인</p>
                                                <p class="text-xs text-slate-400 mt-0.5">계약을 진행할 수 있습니다.</p>
                                            </div>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="status-step">
                                            <div class="w-6 h-6 rounded-full flex items-center justify-center flex-shrink-0 mt-0.5 bg-slate-100 text-slate-300">
                                                <span class="material-symbols-outlined text-[14px]">check</span>
                                            </div>
                                            <div>
                                                <p class="text-sm font-semibold text-slate-300">승인</p>
                                                <p class="text-xs text-slate-300 mt-0.5">대기</p>
                                            </div>
                                        </div>
                                    </c:otherwise>
                                </c:choose>

                            </div>
                        </div>
                    </div>

                    <!-- 하단 버튼 -->

                    <div class="flex justify-end gap-2 px-6 py-4 border-t border-[#eef2eb] bg-[#f8faf6]">
                        <a href="/contract/historyDetail.do?aplctNo=${aplct.APLCT_NO}"
                               class="px-5 py-2 bg-[#004830] text-white text-sm font-bold rounded-full hover:bg-[#226046] transition-colors">
                                상세보기
                        </a>
                        <a href="/contract/detail.do?annNo=${aplct.ANN_NO}"
                           class="px-5 py-2 bg-white border border-slate-200 text-sm text-slate-600 rounded-full hover:bg-slate-50 transition-colors">
                            공고 보기
                        </a>
                    </div>
                </div>
            </c:forEach>
        </c:when>
        <c:otherwise>
            <div class="bg-white rounded-2xl shadow-sm border border-[#eef2eb] p-16 text-center">
                <span class="material-symbols-outlined text-[48px] text-slate-200 mb-4 block">inbox</span>
                <p class="text-slate-400 text-sm mb-6">신청 내역이 없습니다.</p>
                <a href="/contract/notice.do"
                   class="inline-flex items-center gap-2 px-6 py-2.5 bg-[#004830] text-white text-sm font-bold rounded-full hover:bg-[#226046] transition-all">
                    공고 목록 보기
                </a>
            </div>
        </c:otherwise>
    </c:choose>

    <input type="hidden" id="csrfToken" value="${_csrf.token}"/>
    <input type="hidden" id="csrfHeader" value="${_csrf.headerName}"/>

</main>

<script>

    // 청약 신청 취소(fetch api)
    function cancelAplct(aplctNo) {
        Swal.fire({
            icon: 'warning', title: '신청을 취소하시겠습니까?', text: '취소 후 복구가 불가능합니다.',
            confirmButtonColor: '#ef4444', confirmButtonText: '취소하기',
            showCancelButton: true, cancelButtonText: '닫기'
        }).then(result => {
            if (result.isConfirmed) {
                const csrfToken = document.querySelector('#csrfToken').value;
                const csrfHeader = document.querySelector('#csrfHeader').value;
                fetch('/contract/cancel.do', {
                    method: 'PUT',
                    headers: {
                        'Content-Type': 'application/json',
                        [csrfHeader]: csrfToken
                    },
                    body: JSON.stringify({aplctNo: aplctNo})
                }).then(res => res.json()).then(result => {
                    if (result.success) {
                        Swal.fire({icon: 'success', title: '취소 완료', confirmButtonColor: '#004830'})
                            .then(() => location.reload());
                    } else {
                        Swal.fire({
                            icon: 'error',
                            title: '오류',
                            text: '취소 중 오류가 발생했습니다.',
                            confirmButtonColor: '#004830'
                        });
                    }
                });
            }
        });
    }
</script>

</body>
</html>