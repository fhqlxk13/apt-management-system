<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<meta charset="utf-8" />
<meta content="width=device-width, initial-scale=1.0" name="viewport" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/headerStyle.css">
<script
	src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
<link
	href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@700;800&amp;family=Manrope:wght@400;500;600&amp;family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap"
	rel="stylesheet" />
<link
	href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap"
	rel="stylesheet" />
<script id="tailwind-config">
	tailwind.config = {
		darkMode : "class",
		theme : {
			extend : {
				"colors" : {
					"tertiary-fixed" : "#ffdcc1",
					"background" : "#f8f9fa",
					"tertiary-container" : "#a45b00",
					"primary-fixed" : "#b1f0ce",
					"on-secondary-fixed-variant" : "#274e45",
					"outline" : "#707a6c",
					"primary-fixed-dim" : "#95d4b3",
					"on-background" : "#191c1d",
					"inverse-on-surface" : "#f0f1f2",
					"on-error-container" : "#93000a",
					"on-primary-fixed" : "#002114",
					"outline-variant" : "#bfcaba",
					"surface-variant" : "#e1e3e4",
					"inverse-surface" : "#2e3132",
					"surface-tint" : "#2c694e",
					"on-tertiary-fixed-variant" : "#6c3a00",
					"on-tertiary-fixed" : "#2e1500",
					"surface-container-low" : "#f3f4f5",
					"primary-container" : "#3d795d",
					"on-primary-container" : "#c1ffdd",
					"surface-dim" : "#d9dadb",
					"secondary-fixed-dim" : "#a6cfc3",
					"surface-container-high" : "#e7e8e9",
					"surface" : "#f8f9fa",
					"secondary-container" : "#bee8dc",
					"tertiary-fixed-dim" : "#ffb778",
					"on-secondary" : "#ffffff",
					"inverse-primary" : "#95d4b3",
					"primary" : "#226046",
					"secondary-fixed" : "#c1ebdf",
					"on-secondary-container" : "#436a60",
					"on-surface" : "#191c1d",
					"on-surface-variant" : "#40493d",
					"surface-container-lowest" : "#ffffff",
					"secondary" : "#3f665c",
					"on-tertiary-container" : "#ffeee2",
					"on-primary" : "#ffffff",
					"on-tertiary" : "#ffffff",
					"surface-container-highest" : "#e1e3e4",
					"error" : "#ba1a1a",
					"on-error" : "#ffffff",
					"on-secondary-fixed" : "#00201a",
					"on-primary-fixed-variant" : "#0e5138",
					"surface-container" : "#edeeef",
					"surface-bright" : "#f8f9fa",
					"tertiary" : "#814700",
					"error-container" : "#ffdad6"
				},
				"borderRadius" : {
					"DEFAULT" : "0.25rem",
					"lg" : "0.5rem",
					"xl" : "1.5rem",
					"full" : "9999px"
				},
				"fontFamily" : {
					"headline" : [ "Plus Jakarta Sans" ],
					"body" : [ "Manrope" ],
					"label" : [ "Manrope" ]
				}
			},
		},
	}
</script>
<style>
body {
	font-family: 'Manrope', sans-serif;
	background-color: #f8f9fa;
	color: #191c1d;
}

.font-headline {
	font-family: 'Plus Jakarta Sans', sans-serif;
}

.material-symbols-outlined {
	font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
}

/* Smooth Mega Menu Transition */
.mega-menu {
	max-height: 0;
	overflow: hidden;
	transition: max-height 0.5s cubic-bezier(0.4, 0, 0.2, 1), opacity 0.3s
		ease;
	opacity: 0;
	pointer-events: none;
}

.group:hover .mega-menu {
	max-height: 600px;
	opacity: 1;
	pointer-events: auto;
}
</style>
</head>
<body class="min-h-screen flex flex-col">
	<!-- TopNavBar -->
	<header
		class="fixed top-0 w-full z-50 bg-white/80 backdrop-blur-xl shadow-[0_4px_30px_rgba(0,0,0,0.04)]">
		<nav
			class="flex justify-between items-center px-8 py-4 max-w-7xl mx-auto">
			<!-- 로고 -->
			<div
				class="text-xl font-bold tracking-tight text-primary font-headline flex-none">
				우리집맵핑</div>
			<!-- 메뉴 전체를 group으로 감싸야 메가메뉴 유지됨 -->
			<div
				class="hidden md:flex items-center justify-center flex-1 relative group">
				<!-- 상단 메뉴 -->
				<div class="flex gap-8 py-2">
					<a
						class="text-primary font-bold border-b-2 border-primary pb-1 cursor-pointer transition-colors hover:text-primary">서비스
						소개</a> <a
						class="text-slate-600 hover:text-primary cursor-pointer transition-colors">계약공고</a>
					<a
						class="text-slate-600 hover:text-primary cursor-pointer transition-colors">계약
						신청 및 조회</a> <a
						class="text-slate-600 hover:text-primary cursor-pointer transition-colors">단지찾기</a>
					<a
						class="text-slate-600 hover:text-primary cursor-pointer transition-colors">시설이력조회</a>
					<a
						class="text-slate-600 hover:text-primary cursor-pointer transition-colors">공지사항</a>
				</div>
				<!-- 🔥 메가메뉴 -->
				<div
					class="mega-menu absolute left-1/2 -translate-x-1/2 top-full w-screen bg-[#226046ee] backdrop-blur-md border-t border-white/10">
					<div
						class="max-w-7xl mx-auto px-8 py-10 grid grid-cols-6 gap-10 text-sm text-white">
						<div class="space-y-4">
							<h4 class="font-bold text-base border-b border-white/20 pb-2">서비스
								소개</h4>
						</div>
						<div class="space-y-4">
							<h4 class="font-bold text-base border-b border-white/20 pb-2">계약공고</h4>
							<div class="flex flex-col gap-2 opacity-80">
								<p
									class="hover:text-white hover:underline cursor-pointer transition-all">계약
									공고</p>
							</div>
						</div>
						<div class="space-y-4">
							<h4 class="font-bold text-base border-b border-white/20 pb-2">계약
								신청 및 조회</h4>
							<div class="flex flex-col gap-2 opacity-80">
								<p
									class="hover:text-white hover:underline cursor-pointer transition-all">계약
									신청하기</p>
								<p
									class="hover:text-white hover:underline cursor-pointer transition-all">계약
									조회</p>
							</div>
						</div>
						<div class="space-y-4">
							<h4 class="font-bold text-base border-b border-white/20 pb-2">단지찾기</h4>
							<div class="flex flex-col gap-2 opacity-80">
								<p
									class="hover:text-white hover:underline cursor-pointer transition-all">단지
									목록</p>
								<p
									class="hover:text-white hover:underline cursor-pointer transition-all">단지
									검색</p>
							</div>
						</div>
						<div class="space-y-4">
							<h4 class="font-bold text-base border-b border-white/20 pb-2">시설이력
								조회</h4>
							<div class="flex flex-col gap-2 opacity-80">
								<p
									class="hover:text-white hover:underline cursor-pointer transition-all">시설
									유지보수 이력</p>
								<p
									class="hover:text-white hover:underline cursor-pointer transition-all">시설
									하자보수 이력</p>
								<p
									class="hover:text-white hover:underline cursor-pointer transition-all">시설
									점검 기록 확인</p>
							</div>
						</div>
						<div class="space-y-4">
							<h4 class="font-bold text-base border-b border-white/20 pb-2">공지사항</h4>
							<div class="flex flex-col gap-2 opacity-80">
								<p
									class="hover:text-white hover:underline cursor-pointer transition-all">공지사항</p>
								<p
									class="hover:text-white hover:underline cursor-pointer transition-all">문의게시판</p>
							</div>
						</div>
					</div>
				</div>
			</div>
			<!-- 오른쪽 버튼 -->
			<div class="flex items-center gap-4 flex-none">
				<button
					class="text-slate-600 hover:text-primary px-4 py-2 text-sm font-medium">로그인</button>
				<button
					class="bg-primary text-white px-6 py-2.5 rounded-full font-semibold hover:bg-primary/90 transition-colors">회원가입</button>
			</div>
		</nav>
	</header>
	<main class="flex-grow">
		<!-- Hero Section -->
		<section
			class="relative min-h-[870px] flex items-center pt-20 overflow-hidden">
			<div class="absolute inset-0 z-0">
				<img class="w-full h-full object-cover opacity-20"
					data-alt="Modern high-rise apartment building against a clear sky with soft, bright daylight and architectural elegance"
					src="https://lh3.googleusercontent.com/aida-public/AB6AXuBHhnh6wIbc8oTVwnu4ofpfMP3uZ0lXYmGP4YdW5_LFLAaS6jbHw-y8OQJgLj-o2C8zpqrYgjJDSAFS4vKEI6k4VasvG2hksOa2wWz3yh2z-CH2Euy0CDeaN2ELfISPSU8zxLQBE6jxAHA__IWLvPBoufF5-sBsDNruOEUOpK2m_ImLSyLhYO4D9dOJxLyhDtP44sHkMLpqikYnfB3n1WGK_xVTs6dnkLX_S2Bal2ZX6vW8l6M-PzaaAlZZp_haH_HGMsZXrRJ_XjON" />
				<div
					class="absolute inset-0 bg-gradient-to-r from-surface via-surface/60 to-transparent"></div>
			</div>
			<div class="relative z-10 max-w-7xl mx-auto px-8 w-full">
				<div class="max-w-2xl">
					<h1
						class="text-5xl md:text-6xl font-extrabold text-on-surface font-headline leading-[1.1] tracking-tight mb-6">
						당신의 다음 보금자리,<br />여기서 <span class="text-primary">맵핑</span>하세요
					</h1>
					<p
						class="text-lg text-on-surface-variant font-body leading-relaxed mb-12">
						공공주택부터 민간 분양까지, 신뢰할 수 있는 데이터로 스마트하게 내 집 마련의 꿈을 설계하세요. 투명한 정보와 간편한
						신청 프로세스를 제공합니다.</p>
				</div>
			</div>
		</section>
		<!-- Search Section (Overlapping) -->
		<section class="relative z-20 -mt-16 px-8">
			<div class="max-w-5xl mx-auto">
				<div
					class="bg-surface-container-lowest p-4 md:p-6 rounded-full shadow-[0_30px_60px_rgba(0,0,0,0.06)] flex flex-col md:flex-row items-center gap-4">
					<div
						class="flex items-center flex-1 w-full gap-3 px-6 py-3 bg-surface-container-low rounded-full">
						<span class="material-symbols-outlined text-outline">search</span>
						<input
							class="bg-transparent border-none focus:ring-0 w-full text-on-surface placeholder:text-outline-variant font-body"
							placeholder="공고, 관심지역을 검색하세요" type="text" />
					</div>
					<div
						class="flex items-center w-full md:w-auto gap-3 px-6 py-3 bg-surface-container-low rounded-full cursor-pointer group">
						<span
							class="material-symbols-outlined text-outline group-hover:text-primary transition-colors">location_on</span>
						<select
							class="bg-transparent border-none focus:ring-0 text-on-surface font-medium pr-8 font-body cursor-pointer">
							<option>지역 선택</option>
							<option>서울특별시</option>
							<option>경기도</option>
							<option>인천광역시</option>
						</select>
					</div>
					<button
						class="w-full md:w-auto bg-primary text-on-primary px-10 py-4 rounded-full font-bold text-lg hover:bg-primary-container transition-all shadow-lg hover:shadow-primary/20">
						검색하기</button>
				</div>
			</div>
		</section>
		<!-- Service Cards Section -->
		<section class="py-24 bg-surface-container-low mt-12">
			<div class="max-w-7xl mx-auto px-8">
				<div class="grid grid-cols-1 md:grid-cols-3 gap-8">
					<!-- Card 1 -->
					<div
						class="bg-surface-container-lowest p-8 rounded-xl transition-all duration-300 hover:translate-y-[-8px] group">
						<div
							class="w-16 h-16 bg-primary-container/20 rounded-2xl flex items-center justify-center mb-8">
							<span class="material-symbols-outlined text-primary text-3xl"
								data-weight="fill">description</span>
						</div>
						<h3 class="text-xl font-bold text-on-surface font-headline mb-4">계약공고</h3>
						<p class="text-on-surface-variant font-body leading-relaxed">
							최신 공공주택 분양 및 임대 공고를 실시간으로 확인하세요. 맞춤형 알림 서비스로 기회를 놓치지 마세요.</p>
						<div
							class="mt-8 flex items-center text-primary font-bold gap-2 cursor-pointer opacity-0 group-hover:opacity-100 transition-opacity">
							자세히 보기 <span class="material-symbols-outlined">arrow_forward</span>
						</div>
					</div>
					<!-- Card 2 -->
					<div
						class="bg-surface-container-lowest p-8 rounded-xl transition-all duration-300 hover:translate-y-[-8px] group">
						<div
							class="w-16 h-16 bg-primary-container/20 rounded-2xl flex items-center justify-center mb-8">
							<span class="material-symbols-outlined text-primary text-3xl"
								data-weight="fill">campaign</span>
						</div>
						<h3 class="text-xl font-bold text-on-surface font-headline mb-4">공지사항</h3>
						<p class="text-on-surface-variant font-body leading-relaxed">
							우리집맵핑의 새로운 소식과 정책 변경, 주거 지원 혜택에 대한 중요한 안내를 확인하실 수 있습니다.</p>
						<div
							class="mt-8 flex items-center text-primary font-bold gap-2 cursor-pointer opacity-0 group-hover:opacity-100 transition-opacity">
							자세히 보기 <span class="material-symbols-outlined">arrow_forward</span>
						</div>
					</div>
					<!-- Card 3 -->
					<div
						class="bg-surface-container-lowest p-8 rounded-xl transition-all duration-300 hover:translate-y-[-8px] group">
						<div
							class="w-16 h-16 bg-primary-container/20 rounded-2xl flex items-center justify-center mb-8">
							<span class="material-symbols-outlined text-primary text-3xl"
								data-weight="fill">contact_support</span>
						</div>
						<h3 class="text-xl font-bold text-on-surface font-headline mb-4">문의사항</h3>
						<p class="text-on-surface-variant font-body leading-relaxed">
							이용 중 궁금한 점이나 도움이 필요하신가요? 전문 상담사가 친절하고 정확하게 답변해 드립니다.</p>
						<div
							class="mt-8 flex items-center text-primary font-bold gap-2 cursor-pointer opacity-0 group-hover:opacity-100 transition-opacity">
							문의하기 <span class="material-symbols-outlined">arrow_forward</span>
						</div>
					</div>
				</div>
			</div>
		</section>
		<!-- Stats Section (Extra) -->
		<section class="py-20 bg-surface">
			<div class="max-w-7xl mx-auto px-8">
				<div
					class="bg-primary rounded-xl p-12 text-on-primary flex flex-wrap justify-around items-center gap-8">
					<div class="text-center">
						<div class="text-4xl font-headline font-extrabold mb-2">1,250+</div>
						<div class="text-on-primary-container/80 font-body">진행 중인 공고</div>
					</div>
					<div class="text-center">
						<div class="text-4xl font-headline font-extrabold mb-2">85,000+</div>
						<div class="text-on-primary-container/80 font-body">누적 계약 완료</div>
					</div>
					<div class="text-center">
						<div class="text-4xl font-headline font-extrabold mb-2">120k+</div>
						<div class="text-on-primary-container/80 font-body">월간 활성
							이용자</div>
					</div>
				</div>
			</div>
		</section>
	</main>
	<!-- Footer -->
	<footer class="bg-slate-50 dark:bg-slate-900 w-full py-12 mt-auto">
		<div
			class="flex flex-col md:flex-row justify-between items-center px-8 max-w-7xl mx-auto gap-4">
			<div class="flex flex-col gap-2">
				<div class="text-lg font-semibold text-primary font-headline">우리집맵핑</div>
				<div class="text-slate-500 font-body text-[0.875rem]">© 2024
					우리집맵핑. All rights reserved.</div>
			</div>
			<div class="flex gap-8">
				<a
					class="text-slate-500 font-body text-[0.875rem] hover:underline decoration-primary/30 opacity-80 hover:opacity-100 transition-opacity"
					href="#">이용약관</a> <a
					class="text-slate-500 font-body text-[0.875rem] hover:underline decoration-primary/30 opacity-80 hover:opacity-100 transition-opacity"
					href="#">개인정보처리방침</a> <a
					class="text-slate-500 font-body text-[0.875rem] hover:underline decoration-primary/30 opacity-80 hover:opacity-100 transition-opacity"
					href="#">고객센터</a> <a
					class="text-slate-500 font-body text-[0.875rem] hover:underline decoration-primary/30 opacity-80 hover:opacity-100 transition-opacity"
					href="#">찾아오시는 길</a>
			</div>
		</div>
	</footer>
</body>
</html>