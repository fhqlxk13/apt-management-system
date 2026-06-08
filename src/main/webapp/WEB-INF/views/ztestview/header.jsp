<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<header class="fixed top-0 left-0 w-full z-50 group pointer-events-none">

    <div class="absolute top-0 left-0 w-full h-20 bg-white shadow-sm pointer-events-auto border-b border-gray-100 z-40">
        <div class="absolute left-0 top-0 w-64 h-20 flex items-center px-6 opacity-0 group-hover:opacity-100 transition-opacity duration-300">
      <span class="text-xl font-bold text-[#226046] cursor-pointer">
        <a href="/">우리집맵핑</a>
      </span>
        </div>

        <div class="ml-64 h-full bg-white group-hover:border-transparent">
            <div class="max-w-[1400px] mx-auto flex items-center px-8 h-full w-full">

                <nav class="ml-8 w-[950px]">
                    <ul class="grid grid-cols-5 text-center text-base font-semibold text-gray-800">
                        <li class="cursor-pointer hover:text-[#226046] py-2 whitespace-nowrap">서비스 안내</li>
                        <li class="cursor-pointer hover:text-[#226046] py-2 whitespace-nowrap">계약 관리</li>
                        <li class="cursor-pointer hover:text-[#226046] py-2 whitespace-nowrap">단지 정보</li>
                        <li class="cursor-pointer hover:text-[#226046] py-2 whitespace-nowrap">시설 관리</li>
                        <li class="cursor-pointer hover:text-[#226046] py-2 whitespace-nowrap">고객 센터</li>
                    </ul>
                </nav>

                <div class="flex items-center gap-4 ml-auto">
                    <button class="text-gray-500 hover:text-[#226046] text-sm font-medium whitespace-nowrap">로그인
                    </button>
                    <button class="bg-[#226046] text-white px-5 py-2.5 rounded-full text-sm font-semibold hover:bg-[#1a4a35] transition-colors whitespace-nowrap">
                        회원가입
                    </button>
                </div>

            </div>
        </div>
    </div>

    <div class="absolute left-0 top-20 w-full bg-white border-t border-gray-100 shadow-lg invisible opacity-0 -translate-y-2 group-hover:visible group-hover:opacity-100 group-hover:translate-y-0 transition-all duration-300 z-50 pointer-events-auto">
        <div class="ml-64">
            <div class="max-w-[1400px] mx-auto flex items-start px-8 pt-6 pb-8 w-full">

                <div class="ml-8 w-[950px]">
                    <div class="grid grid-cols-5 text-center">

                        <div class="flex flex-col items-center space-y-3">
                            <a href="${pageContext.request.contextPath}/manage/intro"
                               class="text-sm text-gray-500 hover:text-[#226046] hover:font-bold whitespace-nowrap">우리집맵핑
                                소개</a>
                            <a href="${pageContext.request.contextPath}/manage/guide"
                               class="text-sm text-gray-500 hover:text-[#226046] hover:font-bold whitespace-nowrap">이용
                                안내</a>
                        </div>

                        <div class="flex flex-col items-center space-y-3">
                            <a href="${pageContext.request.contextPath}/fee/guide"
                               class="text-sm text-gray-500 hover:text-[#226046] hover:font-bold whitespace-nowrap">계약
                                공고</a>
                            <a href="${pageContext.request.contextPath}/service/apply"
                               class="text-sm text-gray-500 hover:text-[#226046] hover:font-bold whitespace-nowrap">계약
                                신청</a>
                            <a href="${pageContext.request.contextPath}/service/list"
                               class="text-sm text-gray-500 hover:text-[#226046] hover:font-bold whitespace-nowrap">계약
                                조회</a>
                        </div>

                        <div class="flex flex-col items-center space-y-3">
                            <a href="${pageContext.request.contextPath}/apt/list.do"
                               class="text-sm text-gray-500 hover:text-[#226046] hover:font-bold whitespace-nowrap">단지
                                목록</a>
                            <a href="${pageContext.request.contextPath}/apt/search.do"
                               class="text-sm text-gray-500 hover:text-[#226046] hover:font-bold whitespace-nowrap">단지
                                검색</a>
                        </div>

                        <div class="flex flex-col items-center space-y-3">
                            <a href="${pageContext.request.contextPath}/facility/maintenance"
                               class="text-sm text-gray-500 hover:text-[#226046] hover:font-bold whitespace-nowrap">유지보수
                                이력</a>
                            <a href="${pageContext.request.contextPath}/facility/repair"
                               class="text-sm text-gray-500 hover:text-[#226046] hover:font-bold whitespace-nowrap">하자보수
                                이력</a>
                            <a href="${pageContext.request.contextPath}/facility/inspection"
                               class="text-sm text-gray-500 hover:text-[#226046] hover:font-bold whitespace-nowrap">시설
                                점검 기록 </a>
                        </div>

                        <div class="flex flex-col items-center space-y-3">
                            <a href="${pageContext.request.contextPath}/board/notice"
                               class="text-sm text-gray-500 hover:text-[#226046] hover:font-bold whitespace-nowrap">공지사항</a>
                            <a href="${pageContext.request.contextPath}/board/free"
                               class="text-sm text-gray-500 hover:text-[#226046] hover:font-bold whitespace-nowrap">문의게시판</a>
                            <a href="${pageContext.request.contextPath}/board/faq"
                               class="text-sm text-gray-500 hover:text-[#226046] hover:font-bold whitespace-nowrap">자주
                                묻는 질문</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</header>