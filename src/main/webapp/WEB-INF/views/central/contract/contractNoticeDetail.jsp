<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="isLoggedIn"
       value="${not empty sessionScope.SPRING_SECURITY_CONTEXT
               and sessionScope.SPRING_SECURITY_CONTEXT.authentication ne null
               and sessionScope.SPRING_SECURITY_CONTEXT.authentication.principal ne 'anonymousUser'}"/>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=Manrope:wght@400;500;600;700&family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap"
          rel="stylesheet"/>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script id="tailwind-config">
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    colors: {
                        "background": "#f8faf6", "primary": "#004830", "primary-container": "#226046",
                        "secondary-container": "#aeedd5", "on-secondary-container": "#316d5b",
                        "surface": "#f8faf6", "on-surface": "#191c1a",
                    },
                    fontFamily: {"headline": ["Plus Jakarta Sans"], "body": ["Manrope"]}
                }
            }
        }
    </script>
    <style>
        body {
            font-family: 'Manrope', sans-serif;
            background-color: #f8faf6;
            color: #191c1a;
        }

        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
        }

        .tab-btn {
            color: #9ca3af;
            border-bottom: 2px solid transparent;
            transition: all 0.18s;
            padding: 14px 24px;
            font-size: 14px;
            font-weight: 500;
        }

        .tab-btn.active {
            color: #004830;
            border-bottom: 2px solid #004830;
            font-weight: 700;
        }

        .tab-btn:hover {
            color: #226046;
        }

        .tab-panel {
            display: none;
        }

        .tab-panel.active {
            display: block;
            animation: fadeIn .2s ease;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(4px);
            }
            to {
                opacity: 1;
                transform: none;
            }
        }

        .modal-overlay {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(0, 0, 0, 0.5);
            z-index: 50;
            align-items: center;
            justify-content: center;
        }

        .modal-overlay.open {
            display: flex;
        }

        .info-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 13px;
        }

        .info-table th {
            background: #f8faf6;
            padding: 12px 20px;
            text-align: left;
            font-weight: 600;
            color: #555;
            border: 1px solid #e2e8e0;
        }

        .info-table td {
            padding: 12px 20px;
            color: #333;
            border: 1px solid #e2e8e0;
        }

        .supply-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 13px;
        }

        .supply-table th {
            background: #1a3a2a;
            color: white;
            padding: 12px 16px;
            text-align: center;
            font-weight: 600;
            border: 1px solid #2d5a3d;
        }

        .supply-table td {
            padding: 12px 16px;
            text-align: center;
            border: 1px solid #e2e8e0;
            color: #444;
        }

        .supply-table tbody tr:hover {
            background: #f8faf6;
        }

        .supply-table .type-cell {
            color: #004830;
            font-weight: 700;
        }
    </style>
</head>
<body class="bg-[#f8faf6] text-on-surface overflow-x-hidden">

<%@ include file="/WEB-INF/views/include/main_headerLayout.jsp" %>
<%@ include file="/WEB-INF/views/include/central_sidebar.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/centralSidebarStyle.css">

<div class="ml-80 min-h-screen flex flex-col">
    <main class="flex-1 px-8 pt-28 pb-12 space-y-4">

        <!-- 페이지 헤더 -->
        <div class="flex items-center justify-between">
            <div>
                <h1 class="text-xl font-bold text-[#004830] mb-1">공고문</h1>
                <div class="flex items-center gap-1.5 text-xs text-slate-400">
                    <span>Home</span><span>›</span>
                    <span>계약관리</span><span>›</span>
                    <a href="/contract/notice.do" class="hover:text-primary-container transition-colors">계약공고</a>
                    <span>›</span>
                    <span class="text-[#004830] font-semibold">공고문</span>
                </div>
            </div>
            <div class="flex items-center gap-2">
                <a href="/contract/notice.do"
                   class="flex items-center gap-1.5 text-sm text-slate-600 border border-slate-300 px-4 py-2 rounded bg-white hover:bg-slate-50 transition-colors">
                    목록
                </a>
            </div>
        </div>

        <!-- 공고 제목 + 상태 -->
        <section class="bg-white border border-slate-200 shadow-sm">
            <div class="px-8 py-5 border-b-2 border-[#004830]">
                <div class="flex items-center gap-3 mb-2">
                    <c:choose>
                        <c:when test="${announcement.statusNm == '진행중'}">
                            <span class="bg-[#226046] text-white text-[11px] font-bold px-2.5 py-1 rounded">공고중</span>
                        </c:when>
                        <c:when test="${announcement.statusNm == '예정'}">
                            <span class="bg-blue-500 text-white text-[11px] font-bold px-2.5 py-1 rounded">예정</span>
                        </c:when>
                        <c:otherwise>
                            <span class="bg-slate-400 text-white text-[11px] font-bold px-2.5 py-1 rounded">${announcement.statusNm}</span>
                        </c:otherwise>
                    </c:choose>
                </div>
                <h1 class="text-xl font-bold text-[#191c1a] leading-snug">${announcement.ttl}</h1>
            </div>
            <div class="px-8 py-3 bg-[#f8faf6] flex items-center gap-8 text-sm text-slate-500 border-b border-slate-200">
                <span>공고번호 : <strong class="text-slate-700">${announcement.annNo}</strong></span>
                <span>공고일 : <strong
                        class="text-slate-700">${fn:replace(announcement.pblancBgngDt, '-', '.')}</strong></span>
                <span>아파트 단지 : <strong class="text-slate-700">${announcement.aptCmplexNm}</strong></span>
                <span class="ml-auto flex items-center gap-1 text-xs text-slate-400">
                    <span class="material-symbols-outlined text-[14px]">visibility</span> ${announcement.inqCnt}
                </span>
            </div>
        </section>

        <!-- 공고 기본 정보 -->
        <section class="bg-white border border-slate-200 shadow-sm">
            <div class="flex items-center gap-2 px-6 py-4 border-b border-slate-200 bg-[#f8faf6]">
                <span class="w-1.5 h-5 bg-[#004830] rounded-sm inline-block"></span>
                <h2 class="text-sm font-bold text-[#004830]">공고 정보</h2>
            </div>
            <div class="p-6">
                <table class="info-table">
                    <tr>
                        <th style="width:120px">모집기간</th>
                        <td>${fn:replace(announcement.rcrtBgngDt, '-', '.')}
                            ~ ${fn:replace(announcement.rcrtEndDt, '-', '.')}</td>
                        <th style="width:120px">모집세대수</th>
                        <td style="width:120px">${announcement.supplyDisplay}</td>
                    </tr>
                    <tr>
                        <th>주소</th>
                        <td colspan="3">${announcement.dorojuso}</td>
                    </tr>
                </table>
            </div>
        </section>

        <!-- 공급정보 -->
        <section class="bg-white border border-slate-200 shadow-sm">
            <div class="flex items-center gap-2 px-6 py-4 border-b border-slate-200 bg-[#f8faf6]">
                <span class="w-1.5 h-5 bg-[#004830] rounded-sm inline-block"></span>
                <h2 class="text-sm font-bold text-[#004830]">공급정보</h2>
            </div>
            <div class="p-6">
                <p class="text-xs text-slate-400 mb-4">※ 임대보증금 및 월임대료는 공고문을 확인하시기 바랍니다.</p>
                <table class="supply-table">
                    <thead>
                    <tr>
                        <th>평형 타입</th>
                        <th>전용면적(㎡)</th>
                        <th>방 수</th>
                        <th>욕실 수</th>
                        <th>임대보증금(원)</th>
                        <th>월임대료(원)</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${not empty exclusiveSize}">
                            <c:forEach var="apt" items="${exclusiveSize}">
                                <tr>
                                    <td class="type-cell">${apt.TY_NM}</td>
                                    <td>${apt.EXCLUSIVE_SIZE}㎡</td>
                                    <td>${apt.ROOM_CNT}개</td>
                                    <td>${apt.BATHROOM_CNT}개</td>
                                    <td>${apt.DPST_AMT}</td>
                                    <td>${apt.MTHLY_RENT_AMT}</td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="6" class="py-10 text-slate-400">공급정보가 없습니다.</td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>
        </section>

        <!-- 공고 내용 + 제출서류 탭 -->
        <!-- 공고 내용 섹션 -->
        <section class="bg-white border border-slate-200 shadow-sm">
            <div class="flex items-center gap-2 px-6 py-4 border-b border-slate-200 bg-[#f8faf6]">
                <span class="w-1.5 h-5 bg-[#004830] rounded-sm inline-block"></span>
                <h2 class="text-sm font-bold text-[#004830]">공고 내용</h2>
            </div>
            <div class="p-8">
                <div class="text-sm text-slate-700 leading-relaxed whitespace-pre-line min-h-[120px]">
                    <c:choose>
                        <c:when test="${not empty announcement.cn}">${announcement.cn}</c:when>
                        <c:otherwise><span class="text-slate-400">공고 내용이 없습니다.</span></c:otherwise>
                    </c:choose>
                </div>
            </div>
        </section>

        <!-- 제출 서류 섹션 -->
        <section class="bg-white border border-slate-200 shadow-sm mt-4">
            <div class="flex items-center gap-2 px-6 py-4 border-b border-slate-200 bg-[#f8faf6]">
                <span class="w-1.5 h-5 bg-[#004830] rounded-sm inline-block"></span>
                <h2 class="text-sm font-bold text-[#004830]">제출 서류</h2>
            </div>
            <div class="p-8">
                <c:choose>
                    <c:when test="${not empty announcement.sbmsnDoc}">
                        <div class="space-y-2">
                            <c:forEach var="doc" items="${fn:split(announcement.sbmsnDoc, ',')}">
                                <c:set var="docTrimmed" value="${fn:trim(doc)}"/>
                                <div class="flex items-center gap-3 p-3 bg-[#f8faf6] rounded border border-slate-200">
                                    <span class="material-symbols-outlined text-[#226046] text-[18px]">description</span>
                                    <span class="text-sm text-slate-700">
                                        <c:choose>
                                            <c:when test="${docTrimmed == 'ID'}">신분증</c:when>
                                            <c:when test="${docTrimmed == 'FAMILY'}">가족관계서류</c:when>
                                            <c:when test="${docTrimmed == 'RESIDENCE'}">주민등록서류</c:when>
                                            <c:when test="${docTrimmed == 'CONTRACT'}">계약서류</c:when>
                                            <c:when test="${docTrimmed == 'INCOME'}">소득증빙서류</c:when>
                                            <c:when test="${docTrimmed == 'EMPLOY'}">재직증명서</c:when>
                                            <c:otherwise>${docTrimmed}</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <p class="text-sm text-slate-400">제출 서류 정보가 없습니다.</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </section>

        <!-- 하단 버튼 -->
        <div class="flex justify-between py-2">
            <a href="/contract/notice.do"
               class="flex items-center gap-2 px-6 py-2.5 bg-white border border-slate-300 text-sm text-slate-600 hover:bg-slate-50 transition-colors rounded">
                <span class="material-symbols-outlined text-[16px]">arrow_back</span> 목록으로
            </a>
            <c:if test="${announcement.statusNm == '진행중'}">
                <button onclick="openApplyModal()"
                        class="flex items-center gap-2 px-8 py-2.5 bg-[#004830] text-white text-sm font-bold hover:bg-[#226046] transition-all rounded">
                    신청하기
                </button>
            </c:if>
        </div>

    </main>
</div>

<!-- 공고 신청 모달 -->
<div id="applyModal" class="modal-overlay">
    <div class="bg-white rounded-xl shadow-2xl w-full max-w-lg mx-4">
        <div class="flex items-center justify-between px-6 py-4 border-b border-slate-200">
            <h2 class="text-base font-bold text-[#004830]">공고 신청</h2>
            <button onclick="closeApplyModal()" class="text-slate-400 hover:text-slate-600">
                <span class="material-symbols-outlined">close</span>
            </button>
        </div>

        <div class="p-6 space-y-4">
            <!-- 공고 정보 요약 -->
            <div class="bg-[#f8faf6] border border-slate-200 rounded p-4">
                <p class="text-xs text-slate-500 mb-1">신청 공고</p>
                <p class="text-sm font-bold text-[#004830] mb-0.5">${announcement.ttl}</p>
                <p class="text-xs text-slate-500">${announcement.aptCmplexNm} | 모집마감
                    : ${fn:replace(announcement.rcrtEndDt, '-', '.')}</p>
            </div>

            <!-- 신청자 정보 -->
            <div class="grid grid-cols-2 gap-3">
                <div>
                    <label class="block text-xs text-slate-500 mb-1">이름</label>
                    <input type="text" value="${principal.member.userNm}" readonly
                           class="w-full px-3 py-2 border border-slate-200 bg-slate-50 text-sm text-slate-500 cursor-not-allowed rounded"/>
                </div>
                <div>
                    <label class="block text-xs text-slate-500 mb-1">연락처</label>
                    <input type="text" value="${principal.member.userTelno}" readonly
                           class="w-full px-3 py-2 border border-slate-200 bg-slate-50 text-sm text-slate-500 cursor-not-allowed rounded"/>
                </div>
            </div>
            <div class="w-1/2">
                <label class="block text-xs text-slate-500 mb-1">평형 타입</label>
                <select id="exclusiveSizeSelect"
                        class="w-full px-3 py-2 border border-slate-200 text-sm rounded focus:outline-none focus:border-[#004830]">
                    <c:forEach var="apt" items="${exclusiveSize}">
                        <option value="${apt.TY_NM}" data-exclusive="${apt.EXCLUSIVE_SIZE}">${apt.TY_NM}</option>
                    </c:forEach>
                </select>
            </div>
        </div>

        <div class="flex justify-end gap-2 px-6 py-4 border-t border-slate-200 bg-slate-50 rounded-b-xl">
            <button onclick="closeApplyModal()"
                    class="px-5 py-2 bg-white border border-slate-300 text-sm text-slate-600 rounded hover:bg-slate-50 transition-colors">
                취소
            </button>
            <button onclick="submitApply()"
                    class="px-6 py-2 bg-[#004830] text-white text-sm font-bold rounded hover:bg-[#226046] transition-all">
                공고 신청
            </button>
        </div>
    </div>
</div>

<input type="hidden" id="csrfToken" name="${_csrf.parameterName}" value="${_csrf.token}"/>
<input type="hidden" id="csrfHeader" value="${_csrf.headerName}"/>
<input type="hidden" id="annNo" value="${announcement.annNo}"/>
<input type="hidden" id="aptCmplexNo" value="${announcement.aptCmplexNo}"/>

<script>
    const __IS_LOGGED_IN__ = ${isLoggedIn ? 'true' : 'false'};
    const __CTX__ = '${pageContext.request.contextPath}';

    document.querySelectorAll('.tab-btn').forEach(btn => {
        btn.addEventListener('click', () => {
            document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
            document.querySelectorAll('.tab-panel').forEach(p => p.classList.remove('active'));
            btn.classList.add('active');
            document.getElementById('tab-' + btn.dataset.tab).classList.add('active');
        });
    });

    function openApplyModal() {
        if (!__IS_LOGGED_IN__) {
            Swal.fire({
                icon: 'warning',
                title: '로그인이 필요합니다',
                text: '로그인 후 공고 신청이 가능합니다.',
                confirmButtonColor: '#004830',
                confirmButtonText: '확인'
            }).then(() => {
                location.href = __CTX__ + '/login.do';
            });
            return;
        }
        document.querySelector('#applyModal').classList.add('open');
    }

    function closeApplyModal() {
        document.querySelector('#applyModal').classList.remove('open');
    }

    function submitApply() {
        Swal.fire({
            icon: 'question', title: '신청하시겠습니까?', text: '신청 후 심사 결과를 기다려주세요.',
            confirmButtonColor: '#004830', confirmButtonText: '신청하기', showCancelButton: true, cancelButtonText: '취소'
        }).then(result => {
            if (result.isConfirmed) {
                const select = document.querySelector('#exclusiveSizeSelect');
                const data = {
                    annNo: document.querySelector('#annNo').value,
                    aptCmplexNo: document.querySelector('#aptCmplexNo').value,
                    tyNm: select.value,
                    exclusiveSize: select.options[select.selectedIndex].dataset.exclusive
                };
                fetch('/contract/request.do', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        [document.querySelector('#csrfHeader').value]: document.querySelector('#csrfToken').value
                    },
                    body: JSON.stringify(data)
                }).then(res => res.json()).then(result => {
                    if (result.success) {
                        Swal.fire({
                            icon: 'success',
                            title: '공고 신청 완료',
                            text: '심사 결과를 기다려주세요.',
                            confirmButtonColor: '#004830'
                        })
                            .then(() => window.location.href = '/contract/history.do');
                    } else {
                        Swal.fire({
                            icon: 'error',
                            title: '오류',
                            text: '신청 중 오류가 발생했습니다.',
                            confirmButtonColor: '#004830'
                        });
                    }
                });
            }
        });
    }

    document.querySelector('#applyModal').addEventListener('click', function (e) {
        if (e.target === this) closeApplyModal();
    });
</script>

</body>
</html>
