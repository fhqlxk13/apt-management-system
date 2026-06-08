<%--
  Created by IntelliJ IDEA.
  User: PC-05
  Date: 2026-04-24
  Time: 오후 12:12
  To change this template use File | Settings | File Templates.
--%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>

<html class="light" lang="ko"><head>
  <meta charset="utf-8"/>
  <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
  <title>비밀번호 찾기 - 우리집맵핑</title>
  <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
  <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&amp;display=swap" rel="stylesheet"/>
  <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
  <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
  <script id="tailwind-config">
    tailwind.config = {
      darkMode: "class",
      theme: {
        extend: {
          "colors": {
            "outline": "#76786b",
            "surface-container-high": "#eae8e4",
            "inverse-surface": "#30312e",
            "error": "#ba1a1a",
            "on-primary-fixed-variant": "#3e4c16",
            "on-tertiary-fixed": "#002113",
            "surface-container-low": "#f5f3ef",
            "surface": "#fbf9f5",
            "surface-variant": "#e4e2de",
            "surface-container-lowest": "#ffffff",
            "primary-container": "#8a9a5b",
            "on-secondary": "#ffffff",
            "on-tertiary": "#ffffff",
            "on-surface-variant": "#46483c",
            "secondary-fixed": "#d0e9d2",
            "on-error": "#ffffff",
            "primary-fixed-dim": "#bdce89",
            "surface-tint": "#56642b",
            "secondary-fixed-dim": "#b4cdb7",
            "tertiary-fixed": "#b4f0cd",
            "on-primary-fixed": "#161f00",
            "error-container": "#ffdad6",
            "background": "#fbf9f5",
            "surface-bright": "#fbf9f5",
            "on-primary": "#ffffff",
            "surface-dim": "#dbdad6",
            "inverse-primary": "#bdce89",
            "tertiary-fixed-dim": "#98d3b2",
            "on-background": "#1b1c1a",
            "on-primary-container": "#253000",
            "tertiary": "#30694d",
            "on-secondary-fixed": "#0b2012",
            "surface-container": "#efeeea",
            "on-surface": "#1b1c1a",
            "secondary-container": "#d0e9d2",
            "primary-fixed": "#d9eaa3",
            "primary": "#56642b",
            "on-tertiary-container": "#003320",
            "tertiary-container": "#669f80",
            "secondary": "#4e6452",
            "inverse-on-surface": "#f2f0ed",
            "on-secondary-fixed-variant": "#364c3b",
            "outline-variant": "#c6c8b8",
            "on-tertiary-fixed-variant": "#155037",
            "surface-container-highest": "#e4e2de",
            "on-error-container": "#93000a",
            "on-secondary-container": "#546a58"
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
    .step-active { background-color: #56642b; color: white; }
    .step-inactive { background-color: #eae8e4; color: #76786b; }
  </style>
  <style>
    body {
      min-height: max(884px, 100dvh);
    }
  </style>
</head>
<<body class="bg-surface -on-surface min-h-screen flex flex-col items-center">

<form action="${pageContext.request.contextPath}/member/password/update" method="post" autocomplete="off">
  <sec:csrfInput/>
<header class="w-full max-w-md flex justify-between items-center px-6 py-8">
  <button class="-on-surface hover:opacity-80 transition-opacity active:scale-95 duration-200">
    <span class="material-symbols-outlined" data-icon="arrow_back">arrow_back</span>
  </button>
  <div class="w-6"></div>
</header>
<main class="w-full max-w-md px-6 pb-12 flex-grow">
  <div class="mb-10 -center">
  </div>

  <section class="space-y-8">
    <div class="space-y-6">
      <div class="relative group">
        <label class="block -[0.75rem] font-semibold -primary mb-2 ml-1">아이디 (이메일)</label>
        <div class="relative">
          <span class="material-symbols-outlined absolute left-4 top-1/2 -translate-y-1/2 -outline -xl" data-icon="person">person</span>
          <input class="w-full bg-surface-container-highest border-none rounded-xl pl-12 pr-4 py-4 focus:ring-2 focus:ring-primary/20 transition-all -on-surface placeholder:-outline/60" placeholder="example@mapping.com" type=""/>
        </div>
      </div>
      <div class="relative group">
        <label class="block -[0.75rem] font-semibold text-primary mb-2 ml-1">연락처 인증</label>
        <div class="flex gap-2">
          <div class="relative flex-grow">
            <span class="material-symbols-outlined absolute left-4 top-1/2 -translate-y-1/2 text-outline text-xl" data-icon="phone_iphone">phone_iphone</span>
            <input class="w-full bg-surface-container-highest border-none rounded-xl pl-12 pr-4 py-4 focus:ring-2 focus:ring-primary/20 transition-all text-on-surface placeholder:text-outline/60" placeholder="010-1234-5678" type="tel"/>
          </div>
          <button class="px-5 bg-secondary text-on-secondary rounded-xl font-semibold text-sm hover:opacity-90 active:scale-95 transition-all">인증요청</button>
        </div>
      </div>
      <div class="relative">
        <input
                class="w-full bg-surface-container-highest border-none rounded-xl px-4 py-4 focus:ring-2 focus:ring-primary/20 transition-all text-on-surface placeholder:text-outline/60"
                placeholder="인증번호 6자리 입력"
                type="text"
                name="authCode"
                autocomplete="new-password"/>
        <span class="absolute right-4 top-1/2 -translate-y-1/2 text-error text-[0.75rem] font-semibold">03:00</span>
      </div>
    </div>
    <div class="pt-4 space-y-6">
      <div class="relative">
        <label class="block text-[0.75rem] font-semibold text-primary mb-2 ml-1">새 비밀번호</label>
        <div class="relative">
          <span class="material-symbols-outlined absolute left-4 top-1/2 -translate-y-1/2 text-outline text-xl" data-icon="lock">lock</span>
          <input id="pw1"
                 class="w-full bg-surface-container-highest border-none rounded-xl pl-12 pr-12 py-4 focus:ring-2 focus:ring-primary/20 transition-all text-on-surface"
                 placeholder="영문, 숫자, 특수문자 조합 8-16자"
                 type="password"
                 name="newPw"/>
          <button class="absolute right-4 top-1/2 -translate-y-1/2 text-outline">
            <span class="material-symbols-outlined" data-icon="visibility_off">visibility_off</span>
          </button>
        </div>
      </div>
      <div class="relative">
        <label class="block text-[0.75rem] font-semibold text-primary mb-2 ml-1">새 비밀번호 확인</label>
        <div class="relative">
          <span class="material-symbols-outlined absolute left-4 top-1/2 -translate-y-1/2 text-outline text-xl" data-icon="lock_reset">lock_reset</span>
          <input id="pw2"
                 class="w-full bg-surface-container-highest border-none rounded-xl pl-12 pr-12 py-4 focus:ring-2 focus:ring-primary/20 transition-all text-on-surface"
                 placeholder="비밀번호를 한번 더 입력하세요"
                 name="confirmPw"
                 type="password"/>
        </div>
        <p id="pwMsg" class="text-[0.7rem] text-tertiary mt-2 ml-1 flex items-center gap-1">
          <span class="material-symbols-outlined text-sm" data-icon="check_circle">check_circle</span>
          비밀번호가 일치합니다.
        </p>
      </div>
    </div>
    <button type="submit">비밀번호 변경하기</button>
  </section>

  </div>
  </div>
</main>
<script>
  const pw1 = document.getElementById('pw1');
  const pw2 = document.getElementById('pw2');
  const msg = document.getElementById('pwMsg');

  pw2.addEventListener('input', () => {
    if (pw1.value && pw1.value === pw2.value) {
      msg.innerText = '비밀번호가 일치합니다.';
      msg.classList.remove('hidden');
      msg.classList.remove('text-red-500');
      msg.classList.add('text-green-600');
    } else {
      msg.innerText = '비밀번호가 일치하지 않습니다.';
      msg.classList.remove('hidden');
      msg.classList.remove('text-green-600');
      msg.classList.add('text-red-500');
    }
  });
</script>
</body></html>
