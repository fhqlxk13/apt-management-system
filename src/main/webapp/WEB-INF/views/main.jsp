<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="utf-8" />
	<meta content="width=device-width, initial-scale=1.0" name="viewport" />
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
<%@ include file="/WEB-INF/views/include/main_headerLayout.jsp" %>
<main class="flex-grow">
	<!-- Hero Section -->
	<section
			class="relative min-h-[870px] flex items-center pt-20 overflow-hidden">
		<div class="absolute inset-0 z-0 overflow-hidden">

			<!-- 배경 이미지: 왼쪽부터 꽉 차게 -->
			<img class="w-full h-full object-cover object-left"
			     alt="아파트 배경 이미지"
			     src="https://i.pinimg.com/1200x/c4/a0/c1/c4a0c145de3b36ec23fc9ebd274a58af.jpg" />

			<!-- 텍스트 가독성용 오버레이 -->
			<div class="absolute inset-0 bg-gradient-to-r from-white/85 via-white/60 to-transparent"></div>

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
			<form action="${pageContext.request.contextPath}/" method="get"
			      class="bg-surface-container-lowest p-4 md:p-6 rounded-full shadow-[0_30px_60px_rgba(0,0,0,0.06)] flex flex-col md:flex-row items-center gap-4">

				<!-- 지역 선택 -->
				<div class="flex items-center w-full md:w-auto gap-3 px-6 py-3 bg-surface-container-low rounded-full group">
					<span class="material-symbols-outlined text-outline group-hover:text-primary transition-colors">location_on</span>
					<select name="sidoNm"
					        class="bg-transparent border-none focus:ring-0 text-on-surface font-medium pr-8 font-body cursor-pointer"
					        required>
						<option value="">지역 선택</option>
						<c:forEach var="sido" items="${sidoList}">
							<option value="${sido}" <c:if test="${sidoNm eq sido}">selected</c:if>>
									${sido}
							</option>
						</c:forEach>
					</select>
				</div>

				<!-- 단지명 / 주소 키워드 -->
				<div class="flex items-center flex-1 w-full gap-3 px-6 py-3 bg-surface-container-low rounded-full">
					<span class="material-symbols-outlined text-outline">search</span>
					<input
							name="keyword"
							value="${keyword}"
							class="bg-transparent border-none focus:ring-0 w-full text-on-surface placeholder:text-outline-variant font-body"
							placeholder="단지명 또는 주소를 검색하세요"
							type="text" />
				</div>

				<button type="submit"
				        class="w-full md:w-auto bg-primary text-on-primary px-10 py-4 rounded-full font-bold text-lg hover:bg-primary-container transition-all shadow-lg hover:shadow-primary/20">
					검색하기
				</button>
			</form>
		</div>
	</section>

	<!-- Search Result Section -->
	<c:if test="${searched}">
		<section id="aptSearchResult" class="py-16 bg-surface">
			<div class="max-w-7xl mx-auto px-8">

				<!-- 결과 헤더 -->
				<div class="flex flex-col md:flex-row md:items-end md:justify-between gap-3 mb-8">
					<div>
						<p class="text-sm font-semibold text-primary mb-2">검색 결과</p>
						<h2 class="text-3xl font-extrabold font-headline text-on-surface">
							<c:choose>
								<c:when test="${not empty keyword}">
									<span class="text-primary">${sidoNm}</span> · “${keyword}”
								</c:when>
								<c:otherwise>
									<span class="text-primary">${sidoNm}</span> 아파트 단지
								</c:otherwise>
							</c:choose>
						</h2>
					</div>
					<p class="text-on-surface-variant font-body">
						총 <strong class="text-primary">${pagingVO.totalRecord}</strong>건
					</p>
				</div>

				<!-- 결과 있음 -->
				<c:if test="${not empty aptList}">
					<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">

						<c:forEach var="apt" items="${aptList}">
							<a href="${pageContext.request.contextPath}/main/apt/detail.do?aptCmplexNo=${apt.aptCmplexNo}"
							   class="block no-underline text-inherit">

								<article class="h-full bg-surface-container-lowest rounded-xl p-7 shadow-sm border border-outline-variant/30 hover:-translate-y-1 hover:shadow-lg transition-all cursor-pointer">

									<div class="flex items-center justify-between gap-3 mb-5">
                        <span class="inline-flex items-center px-3 py-1 rounded-full bg-primary-container/15 text-primary text-sm font-semibold">
								${apt.sidoNm}
						</span>

										<c:if test="${not empty apt.bldYr}">
                            <span class="text-sm text-outline">
                                ${apt.bldYr} 준공
                            </span>
										</c:if>
									</div>

									<h3 class="text-xl font-bold text-on-surface font-headline mb-3">
											${apt.aptCmplexNm}
									</h3>

									<p class="text-on-surface-variant font-body leading-relaxed min-h-[48px] mb-6">
										<c:choose>
											<c:when test="${not empty apt.dorojuso}">
												${apt.dorojuso}
											</c:when>
											<c:otherwise>
												${apt.sidoNm} ${apt.sigunguNm} ${apt.emdNm}
											</c:otherwise>
										</c:choose>
									</p>

									<div class="grid grid-cols-2 gap-3 pt-5 border-t border-outline-variant/30">
										<div>
											<p class="text-xs text-outline mb-1">세대수</p>
											<p class="font-bold text-on-surface">
												<c:choose>
													<c:when test="${not empty apt.unitCnt}">
														<fmt:formatNumber value="${apt.unitCnt}" pattern="#,###"/>세대
													</c:when>
													<c:otherwise>-</c:otherwise>
												</c:choose>
											</p>
										</div>

										<div>
											<p class="text-xs text-outline mb-1">동수</p>
											<p class="font-bold text-on-surface">
												<c:choose>
													<c:when test="${not empty apt.dongCnt}">
														${apt.dongCnt}개동
													</c:when>
													<c:otherwise>-</c:otherwise>
												</c:choose>
											</p>
										</div>
									</div>

								</article>
							</a>
						</c:forEach>

					</div>

					<!-- 페이징 -->
					<c:if test="${pagingVO.totalPage gt 1}">
						<div class="flex items-center justify-center gap-2 mt-10">

							<!-- 이전 페이지 -->
							<c:if test="${pagingVO.currentPage gt 1}">
								<c:url var="prevUrl" value="/">
									<c:param name="sidoNm" value="${sidoNm}" />
									<c:param name="keyword" value="${keyword}" />
									<c:param name="currentPage" value="${pagingVO.currentPage - 1}" />
								</c:url>

								<a href="${prevUrl}#aptSearchResult"
								   class="px-4 py-2 rounded-full border border-outline-variant text-on-surface hover:bg-surface-container transition">
									이전
								</a>
							</c:if>

							<!-- 페이지 번호 -->
							<c:forEach var="pageNo"
							           begin="${pagingVO.startPage}"
							           end="${pagingVO.endPage lt pagingVO.totalPage ? pagingVO.endPage : pagingVO.totalPage}">
								<c:choose>
									<c:when test="${pageNo eq pagingVO.currentPage}">
                        <span class="w-10 h-10 inline-flex items-center justify-center rounded-full bg-primary text-on-primary font-bold">
								${pageNo}
						</span>
									</c:when>

									<c:otherwise>
										<c:url var="pageUrl" value="/">
											<c:param name="sidoNm" value="${sidoNm}" />
											<c:param name="keyword" value="${keyword}" />
											<c:param name="currentPage" value="${pageNo}" />
										</c:url>

										<a href="${pageUrl}#aptSearchResult"
										   class="w-10 h-10 inline-flex items-center justify-center rounded-full bg-surface-container-low text-on-surface hover:bg-primary hover:text-on-primary transition">
												${pageNo}
										</a>
									</c:otherwise>
								</c:choose>
							</c:forEach>

							<!-- 다음 페이지 -->
							<c:if test="${pagingVO.currentPage lt pagingVO.totalPage}">
								<c:url var="nextUrl" value="/">
									<c:param name="sidoNm" value="${sidoNm}" />
									<c:param name="keyword" value="${keyword}" />
									<c:param name="currentPage" value="${pagingVO.currentPage + 1}" />
								</c:url>

								<a href="${nextUrl}#aptSearchResult"
								   class="px-4 py-2 rounded-full border border-outline-variant text-on-surface hover:bg-surface-container transition">
									다음
								</a>
							</c:if>

						</div>
					</c:if>
				</c:if>


				<!-- 결과 없음 -->
				<c:if test="${empty aptList}">
					<div class="bg-surface-container-lowest rounded-xl p-12 text-center border border-outline-variant/30">
						<span class="material-symbols-outlined text-5xl text-outline mb-4">search_off</span>
						<h3 class="text-xl font-bold text-on-surface mb-2">검색된 단지가 없습니다.</h3>
						<p class="text-on-surface-variant">
							지역이나 검색어를 다시 확인해 주세요.
						</p>
					</div>
				</c:if>
			</div>
		</section>
	</c:if>
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
					<a href="${pageContext.request.contextPath}/contract/notice.do"
					   class="mt-8 flex items-center text-primary font-bold gap-2 cursor-pointer opacity-0 group-hover:opacity-100 transition-opacity no-underline">
						자세히 보기
						<span class="material-symbols-outlined">arrow_forward</span>
					</a>
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
					<a href="${pageContext.request.contextPath}/board/notice/list.do"
					   class="mt-8 flex items-center text-primary font-bold gap-2 cursor-pointer opacity-0 group-hover:opacity-100 transition-opacity no-underline">
						자세히 보기
						<span class="material-symbols-outlined">arrow_forward</span>
					</a>
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
					<a href="${pageContext.request.contextPath}/apt/board/inqry/list.do"
					   class="mt-8 flex items-center text-primary font-bold gap-2 cursor-pointer opacity-0 group-hover:opacity-100 transition-opacity no-underline">
						문의하기
						<span class="material-symbols-outlined">arrow_forward</span>
					</a>
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
<%@ include file="/WEB-INF/views/include/main_footerLayout.jsp" %>
</body>
</html>
