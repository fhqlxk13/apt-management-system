
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>

<html class="light" lang="ko"><head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>시설 관리 이력 조회 - 우리집맵핑</title>
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&amp;display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
    <script id="tailwind-config">
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    "colors": {
                        "surface": "#fbf9f5",
                        "primary": "#56642b",
                        "on-primary-container": "#253000",
                        "surface-container": "#efeeea",
                        "on-surface": "#1b1c1a",
                        "on-error": "#ffffff",
                        "inverse-surface": "#30312e",
                        "surface-tint": "#56642b",
                        "surface-container-low": "#f5f3ef",
                        "inverse-primary": "#bdce89",
                        "secondary-fixed-dim": "#b4cdb7",
                        "background": "#fbf9f5",
                        "secondary-fixed": "#d0e9d2",
                        "on-primary-fixed-variant": "#3e4c16",
                        "on-secondary": "#ffffff",
                        "on-background": "#1b1c1a",
                        "surface-container-high": "#eae8e4",
                        "primary-fixed": "#d9eaa3",
                        "on-tertiary-fixed-variant": "#155037",
                        "tertiary": "#30694d",
                        "on-primary": "#ffffff",
                        "on-secondary-container": "#546a58",
                        "on-tertiary-container": "#003320",
                        "error": "#ba1a1a",
                        "on-surface-variant": "#46483c",
                        "outline": "#76786b",
                        "surface-variant": "#e4e2de",
                        "inverse-on-surface": "#f2f0ed",
                        "surface-container-highest": "#e4e2de",
                        "tertiary-fixed": "#b4f0cd",
                        "primary-fixed-dim": "#bdce89",
                        "surface-container-lowest": "#ffffff",
                        "on-tertiary-fixed": "#002113",
                        "tertiary-container": "#669f80",
                        "surface-dim": "#dbdad6",
                        "error-container": "#ffdad6",
                        "outline-variant": "#c6c8b8",
                        "on-primary-fixed": "#161f00",
                        "secondary-container": "#d0e9d2",
                        "tertiary-fixed-dim": "#98d3b2",
                        "secondary": "#4e6452",
                        "on-error-container": "#93000a",
                        "on-tertiary": "#ffffff",
                        "primary-container": "#8a9a5b",
                        "on-secondary-fixed-variant": "#364c3b",
                        "on-secondary-fixed": "#0b2012",
                        "surface-bright": "#fbf9f5"
                    },
                    "borderRadius": {
                        "DEFAULT": "0.25rem",
                        "lg": "0.5rem",
                        "xl": "0.75rem",
                        "full": "9999px"
                    },
                    "fontFamily": {
                        "headline": ["Manrope"],
                        "body": ["Manrope"],
                        "label": ["Manrope"]
                    }
                },
            },
        }
    </script>
    <style>
        body { font-family: 'Manrope', sans-serif; }
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
        }
    </style>
</head>
<body class="bg-surface text-on-surface flex flex-col min-h-screen">

<%@ include file="/WEB-INF/views/include/main_headerLayout.jsp" %>
<%@ include file="/WEB-INF/views/include/central_sidebar.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/centralSidebarStyle.css">
<!-- TopNavBar -->

<main class="ml-64 p-10 pt-28 bg-[#f8f7f4]">

    <div class="w-full px-10">

        <!-- 안내 문구 -->
        <h1 class="text-5xl font-bold tracking-tight text-on-surface mb-4">시설 점검 기록 확인</h1>
        <p class="text-gray-500 mb-6">
            우리 단지의 시설 점검 기록을 한눈에 확인할 수 있습니다.
        </p>

        <!-- 검색 카드 -->
        <div class="bg-[#f1efea] p-6 rounded-2xl flex flex-wrap items-end gap-4 shadow-sm mb-6">

            <div>
                <p class="text-xs text-gray-500 mb-1">조회 조건</p>
                <select class="px-3 py-2 rounded-lg bg-white shadow-sm">
                    <option>단지 선택</option>
                </select>
            </div>

            <div>
                <p class="text-xs text-gray-500 mb-1">점검 유형</p>
                <select class="px-3 py-2 rounded-lg bg-white shadow-sm">
                    <option>전체</option>
                </select>
            </div>

            <div>
                <p class="text-xs text-gray-500 mb-1">점검 상태</p>
                <select class="px-3 py-2 rounded-lg bg-white shadow-sm">
                    <option>전체</option>
                </select>
            </div>

            <div class="flex-1">
                <p class="text-xs text-gray-500 mb-1">검색</p>
                <input type="text" placeholder="점검번호 / 시설명"
                       class="w-full px-4 py-2 rounded-lg bg-white shadow-sm">
            </div>

            <button class="bg-[#5c6b2f] text-white px-6 py-2 rounded-full">
                조회
            </button>

        </div>

        <!-- 탭 -->
        <div class="flex gap-2 mb-6">
            <button id="tab1" class="tab-btn bg-[#5c6b2f] text-white px-4 py-2 rounded-full text-sm">정기 점검</button>
            <button id="tab2" class="tab-btn bg-gray-200 px-4 py-2 rounded-full text-sm">수시 점검</button>
            <button id="tab3" class="tab-btn bg-gray-200 px-4 py-2 rounded-full text-sm">안전 점검</button>
        </div>
        <!-- 통계 카드 -->
        <div class="grid grid-cols-4 gap-4 mb-6">

            <div class="bg-green-100 p-5 rounded-2xl text-center">
                <p class="text-sm text-gray-500">전체 점검</p>
                <p class="text-2xl font-bold text-[#4d5c2b]">112</p>
            </div>

            <div class="bg-blue-100 p-5 rounded-2xl text-center">
                <p class="text-sm text-gray-500">정상</p>
                <p class="text-2xl font-bold text-blue-600">89</p>
            </div>

            <div class="bg-red-100 p-5 rounded-2xl text-center">
                <p class="text-sm text-gray-500">불량</p>
                <p class="text-2xl font-bold text-red-500">14</p>
            </div>

            <div class="bg-yellow-100 p-5 rounded-2xl text-center">
                <p class="text-sm text-gray-500">점검 예정</p>
                <p class="text-2xl font-bold text-yellow-600">9</p>
            </div>

        </div>

        <!-- 테이블 -->
        <div class="bg-white rounded-2xl overflow-hidden shadow-sm mb-6">

            <table class="w-full text-sm">

                <thead class="bg-[#f3f1ec] text-gray-500">
                <tr>
                    <th class="p-4 text-left">점검번호</th>
                    <th class="p-4 text-left">단지명</th>
                    <th class="p-4 text-left">시설 유형</th>
                    <th class="p-4 text-left">점검 유형</th>
                    <th class="p-4 text-left">점검일</th>
                    <th class="p-4 text-left">점검자</th>
                    <th class="p-4 text-left">결과</th>
                </tr>
                </thead>

                <tbody class="divide-y">

                <tr class="hover:bg-gray-50">
                    <td class="p-4">INS-2026-001</td>
                    <td class="p-4">○○아파트</td>
                    <td class="p-4">소방설비</td>
                    <td class="p-4">정기점검</td>
                    <td class="p-4">2026.03.05</td>
                    <td class="p-4">박○○</td>
                    <td class="p-4">
                        <span class="bg-blue-100 text-blue-600 px-3 py-1 rounded-full text-xs">정상</span>
                    </td>
                </tr>

                <tr class="hover:bg-gray-50">
                    <td class="p-4">INS-2026-002</td>
                    <td class="p-4">△△단지</td>
                    <td class="p-4">엘리베이터</td>
                    <td class="p-4">정기점검</td>
                    <td class="p-4">2026.03.12</td>
                    <td class="p-4">이○○</td>
                    <td class="p-4">
                        <span class="bg-red-100 text-red-500 px-3 py-1 rounded-full text-xs">불량</span>
                    </td>
                </tr>

                </tbody>

            </table>

        </div>

        <!-- 하단 카드 -->
        <div class="grid grid-cols-2 gap-4">

            <!-- 상세 -->
            <div class="bg-white p-5 rounded-2xl shadow-sm">
                <p class="font-bold mb-3">점검 기본 정보</p>

                <ul class="text-sm space-y-2">
                    <li>점검번호 : INS-2026-002</li>
                    <li>단지명 : △△단지</li>
                    <li>시설 : 엘리베이터</li>
                    <li>점검일 : 2026.03.12</li>
                </ul>
            </div>

            <!-- 체크리스트 -->
            <div class="bg-white p-5 rounded-2xl shadow-sm">
                <p class="font-bold mb-3">점검 체크리스트</p>

                <ul class="text-sm space-y-2">
                    <li>✔ 운행 속도 정상</li>
                    <li>✔ 도어 정상</li>
                    <li class="text-red-500">✖ 브레이크 이상</li>
                </ul>
            </div>

        </div>

    </div>
    </div>

</main>

</body>
<script>
    const tabs = document.querySelectorAll('.tab-btn');

    tabs.forEach(btn => {
        btn.addEventListener('click', () => {

            // 전체 초기화
            tabs.forEach(b => {
                b.classList.remove('bg-[#5c6b2f]', 'text-white');
                b.classList.add('bg-gray-200');
            });

            // 클릭한 애 활성화
            btn.classList.remove('bg-gray-200');
            btn.classList.add('bg-[#5c6b2f]', 'text-white');

        });
    });
</script>


</html>