<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>계약공고 - 우리집맵핑</title>
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
                        "background": "#f8faf6",
                        "primary": "#004830",
                        "primary-container": "#226046",
                        "on-primary": "#ffffff",
                        "on-primary-container": "#99d8b7",
                        "secondary": "#2c6956",
                        "secondary-container": "#aeedd5",
                        "on-secondary-container": "#316d5b",
                        "surface": "#f8faf6",
                        "on-surface": "#191c1a",
                        "outline": "#707973",
                        "surface-container": "#eceeea",
                    },
                    borderRadius: {
                        "DEFAULT": "1rem",
                        "lg": "2rem",
                        "xl": "3rem",
                        "full": "9999px"
                    },
                    fontFamily: {
                        "headline": ["Plus Jakarta Sans"],
                        "body": ["Manrope"],
                        "label": ["Manrope"]
                    }
                },
            },
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
    </style>
</head>
<body class="bg-background text-on-surface overflow-x-hidden">

<%@ include file="/WEB-INF/views/include/main_headerLayout.jsp" %>
<%@ include file="/WEB-INF/views/include/central_sidebar.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/centralSidebarStyle.css">

<div class="ml-80 min-h-screen flex flex-col">
    <main class="flex-1 p-8 pt-28 space-y-8">

        <!-- 페이지 헤더 -->
        <div class="flex justify-between items-end">
            <div class="space-y-2">
                <h1 class="text-3xl font-bold text-gray-900 mb-2">계약공고</h1>
                <p class="text-gray-500 text-sm">진행 중인 계약 공고를 확인하고 참여할 수 있습니다.</p>
            </div>
        </div>

        <!-- 검색 필터 -->
        <section class="bg-white p-6 rounded-lg border border-[#eef2eb] shadow-sm space-y-4">
            <div class="grid grid-cols-4 gap-4">
                <div class="space-y-2">
                    <label class="text-xs font-bold text-slate-500 ml-1">상태</label>
                    <select id="searchStatus" class="w-full bg-[#f1f3ef] border-none rounded-lg py-3 px-4 text-sm">
                        <option value="">전체</option>
                        <option value="진행중">공고중</option>
                        <option value="예정">예정</option>
                        <option value="마감">마감</option>
                    </select>
                </div>
                <div class="space-y-2">
                    <label class="text-xs font-bold text-slate-500 ml-1">게시일</label>
                    <input type="date" id="searchFrom" class="w-full bg-[#f1f3ef] border-none rounded-lg py-3 px-4 text-sm"/>
                </div>
                <div class="space-y-2">
                    <label class="text-xs font-bold text-slate-500 ml-1">마감일</label>
                    <input type="date" id="searchTo" class="w-full bg-[#f1f3ef] border-none rounded-lg py-3 px-4 text-sm"/>
                </div>
            </div>
            <div class="flex gap-3">
                <input id="searchTtl" class="flex-1 bg-[#f1f3ef] border-none rounded-lg py-4 px-5 text-sm"
                       placeholder="공고명 또는 아파트 단지를 입력하세요" type="text"/>
                <button onclick="searchList()"
                        class="bg-[#6F7F3F] text-white px-10 py-4 rounded-lg font-bold hover:bg-[#5f6e35] transition-all">
                    검색
                </button>
                <button type="button" onclick="resetSearch()"
                        class="bg-white border border-[#d9ded4] text-slate-600 px-8 py-4 rounded-lg font-bold hover:bg-[#f8faf6] transition-all">
                    초기화
                </button>
            </div>
        </section>

        <!-- 공고 목록 테이블 -->
        <div class="bg-white rounded-lg border border-[#eef2eb] shadow-sm overflow-hidden">
            <table class="w-full text-left border-collapse">
                <colgroup>
                    <col style="width: 5%"/>  <!-- 번호 -->
                    <col style="width: 30%"/>  <!-- 공고명 -->
                    <col style="width: 15%"/>  <!-- 단지 -->
                    <col style="width: 10%"/>  <!-- 게시일 -->
                    <col style="width: 10%"/>  <!-- 마감일 -->
                    <col style="width: 10%"/>  <!-- 상태 -->
                    <col style="width: 10%"/>  <!-- 조회수 -->
                </colgroup>
                <thead class="bg-[#f1f3ef]/50 border-b border-[#eef2eb]">
                <tr>
                    <th class="px-6 py-4 text-xs font-bold text-slate-500 uppercase text-center">번호</th>
                    <th class="px-6 py-4 text-xs font-bold text-slate-500 uppercase text-left">공고명</th>
                    <th class="px-6 py-4 text-xs font-bold text-slate-500 uppercase text-center">아파트 단지</th>
                    <th class="px-6 py-4 text-xs font-bold text-slate-500 uppercase text-center">게시일</th>
                    <th class="px-6 py-4 text-xs font-bold text-slate-500 uppercase text-center">마감일</th>
                    <th class="px-6 py-4 text-xs font-bold text-slate-500 uppercase text-center">상태</th>
                    <th class="px-6 py-4 text-xs font-bold text-slate-500 uppercase text-center">조회수</th>
                </tr>
                </thead>
                <tbody id="listBody" class="divide-y divide-[#eef2eb]">
                </tbody>
            </table>
        </div>

        <!-- 페이지네이션 -->
        <div id="paging" class="flex justify-center items-center gap-2 py-4">
        </div>

    </main>
</div>

<script>
    /* =============================================
       전역 변수
    ============================================= */
    const PAGE_SIZE = 10;
    let allList = [];
    let currentPage = 1;

    /* =============================================
       1. 서버에서 공고 목록 가져오기
    ============================================= */
    async function fetchList(params = {}) {
        try {
            const res = await fetch('/contract/notice.json?' + new URLSearchParams(params));
            if (!res.ok) throw new Error('서버 오류');
            return await res.json();
        } catch (e) {
            Swal.fire({icon: 'error', title: '오류', text: '목록을 불러오지 못했습니다.', confirmButtonColor: '#5c6b2f'});
            return [];
        }
    }

    /* =============================================
       2. 공고 목록 테이블 렌더링
    ============================================= */
    function renderList(list) {
        const tbody = document.querySelector('#listBody');
        tbody.innerHTML = '';

        if (!list.length) {
            tbody.innerHTML = '<tr><td colspan="7" class="px-6 py-16 text-center text-slate-400 text-sm">공고가 없습니다.</td></tr>';
            return;
        }

        list.forEach(ann => {
            // 상태 뱃지
            const statusBadge = ann.statusNm === '진행중'
                ? '<span class="text-[#2c6956] font-bold text-sm">공고중</span>'
                : '<span class="text-slate-400 text-sm">' + ann.statusNm + '</span>';

            // 행 생성
            const tr = document.createElement('tr');
            tr.className = 'hover:bg-[#f8faf6] transition-colors group cursor-pointer';
            tr.onclick = () => window.location.href = '/contract/detail.do?annNo=' + ann.annNo;
            tr.innerHTML =
                tr.innerHTML =
                    tr.innerHTML =
                        '<td class="px-6 py-5 text-sm text-slate-400 text-center">' + ann.annNo + '</td>' +
                        '<td class="px-6 py-5 text-sm text-slate-800 text-left">' + ann.ttl + '</td>' +
                        '<td class="px-6 py-5 text-sm text-slate-600 text-center">' + (ann.aptCmplexNm || '') + '</td>' +
                        '<td class="px-6 py-5 text-sm text-slate-500 text-center">' + (ann.rcrtBgngDt ? ann.rcrtBgngDt.replace(/-/g, '.') : '') + '</td>' +
                        '<td class="px-6 py-5 text-sm text-slate-500 text-center">' + (ann.rcrtEndDt ? ann.rcrtEndDt.replace(/-/g, '.') : '') + '</td>' +
                        '<td class="px-6 py-5 text-center">' + statusBadge + '</td>' +
                        '<td class="px-6 py-5 text-sm text-slate-400 text-center">' + (ann.inqCnt || 0) + '</td>';

            tbody.appendChild(tr);
        });
    }

    /* =============================================
       3. 페이지네이션 렌더링
    ============================================= */
    function renderPaging(total) {
        const totalPage = Math.ceil(total / PAGE_SIZE);
        const paging = document.querySelector('#paging');
        paging.innerHTML = '';

        // 이전 버튼
        const prevBtn = document.createElement('button');
        prevBtn.className = 'w-10 h-10 flex items-center justify-center rounded-full border border-[#eef2eb] hover:bg-white text-slate-400';
        prevBtn.innerHTML = '<span class="material-symbols-outlined">chevron_left</span>';
        prevBtn.disabled = currentPage === 1;
        prevBtn.onclick = () => goPage(currentPage - 1);
        paging.appendChild(prevBtn);

        // 페이지 번호 버튼
        for (let i = 1; i <= totalPage; i++) {
            const btn = document.createElement('button');
            btn.className = i === currentPage
                ? 'w-10 h-10 flex items-center justify-center rounded-full bg-primary-container text-white font-bold'
                : 'w-10 h-10 flex items-center justify-center rounded-full border border-[#eef2eb] hover:bg-white text-slate-400';
            btn.textContent = i;
            btn.onclick = () => goPage(i);
            paging.appendChild(btn);
        }

        // 다음 버튼
        const nextBtn = document.createElement('button');
        nextBtn.className = 'w-10 h-10 flex items-center justify-center rounded-full border border-[#eef2eb] hover:bg-white text-slate-400';
        nextBtn.innerHTML = '<span class="material-symbols-outlined">chevron_right</span>';
        nextBtn.disabled = currentPage === totalPage;
        nextBtn.onclick = () => goPage(currentPage + 1);
        paging.appendChild(nextBtn);
    }

    /* =============================================
       4. 페이지 이동
    ============================================= */
    function goPage(page) {
        currentPage = page;
        const start = (page - 1) * PAGE_SIZE;
        const end = start + PAGE_SIZE;
        renderList(allList.slice(start, end));
        renderPaging(allList.length);
    }

    /* =============================================
       5. 검색
    ============================================= */
    async function searchList() {
        currentPage = 1;
        const params = {
            searchTtl: document.querySelector('#searchTtl').value,
            searchFrom: document.querySelector('#searchFrom').value,
            searchTo: document.querySelector('#searchTo').value,
            searchStatus: document.querySelector('#searchStatus').value
        };
        allList = await fetchList(params);
        goPage(1);
    }

    function resetSearch() {
        document.querySelector('#searchStatus').value = '';
        document.querySelector('#searchFrom').value = '';
        document.querySelector('#searchTo').value = '';
        document.querySelector('#searchTtl').value = '';
        searchList();
    }

    // 엔터 검색
    document.querySelector('#searchTtl').addEventListener('keypress', e => {
        if (e.key === 'Enter') searchList();
    });

    /* =============================================
       6. 초기 로드
    ============================================= */
    document.addEventListener('DOMContentLoaded', searchList);
</script>

</body>
</html>