<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true"%>
<!doctype html>
<html lang="ko">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1.0" />
    <title>우리집맵핑 · 문의 관리</title>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet" />
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/centralAside.css" />
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/centralHeader.css" />
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/centralCommon.css" />
    <%--<script defer src="<%= request.getContextPath() %>/js/centralAside.js"></script>
    <script defer src="<%= request.getContextPath() %>/js/centralHeader.js"></script>--%>
  </head>
  <body>
    <%@ include file="centralAside.jsp" %>
    <div class="main-wrap">
      <div class="topbar">
        <div class="breadcrumb">
          <span class="material-symbols-rounded" style="font-size: 14px">home</span>
          <span style="margin: 0 4px">/</span>
          <span id="bc-parent">민원·소통</span>
          <span style="margin: 0 4px">/</span>
          <span class="bc-current" id="bc-current">문의 관리</span>
        </div>
        <div class="topbar-actions">
          <button class="topbar-icon-btn" data-tooltip="알림"><span class="material-symbols-rounded">notifications</span><div class="dot"></div></button>
          <button class="topbar-icon-btn" data-tooltip="설정"><span class="material-symbols-rounded">settings</span></button>
        </div>
      </div>
      <div class="main-content" id="page-content">
        <div class="page-header">
          <div>
            <div class="page-title">AI 챗봇 문의 관리</div>
            <div class="page-subtitle">입주민이 AI 챗봇과 나눈 대화를 열람하고, 필요 시 직접 응대할 수 있습니다.</div>
          </div>
          <div class="page-header__right">
            <span class="page-meta">
              <span class="material-symbols-rounded">schedule</span>
              실시간 동기화
            </span>
          </div>
        </div>
        <div class="c-card" style="padding:0; overflow:hidden; display:flex; height: calc(100vh - 200px); min-height:480px; max-height:720px">
          <!-- 좌측 목록 -->
          <div style="width:300px; flex-shrink:0; display:flex; flex-direction:column; border-right:1px solid var(--border)">
            <div style="padding:14px 16px; display:flex; align-items:center; justify-content:space-between; font-weight:800; font-size:13px">
              <span>문의 목록</span>
              <span class="c-badge" id="chat-count">0</span>
            </div>
            <div class="c-filter-row" style="padding:10px 12px; gap:6px; flex-wrap:nowrap">
              <select class="c-select" id="sort-select" aria-label="정렬" style="height:32px; flex:1; min-width:0; padding:0 8px">
                <option value="desc">최신순</option>
                <option value="asc">오래된순</option>
              </select>
              <select class="c-select" id="range-select" aria-label="기간" style="height:32px; flex:1; min-width:0; padding:0 8px">
                <option value="all">전체</option>
                <option value="7">최근 7일</option>
                <option value="30">최근 30일</option>
              </select>
            </div>
            <div id="chat-list-body" style="flex:1; overflow:auto"></div>
            <div id="chat-list-foot" style="padding:10px 12px; display:flex; justify-content:center"></div>
          </div>
          <!-- 우측 뷰어 -->
          <div style="flex:1; min-width:0; display:flex; flex-direction:column">
            <div id="chat-head" style="padding:14px 20px; display:none; border-bottom:1px solid var(--border)">
              <strong id="chat-head-user"></strong>
              <span id="chat-head-title" style="color:var(--text-tertiary); font-size:12px; margin-left:6px"></span>
            </div>
            <div id="chat-messages" style="flex:1; overflow:auto; padding:16px 20px">
              <div id="chat-empty" style="height:100%; display:flex; flex-direction:column; align-items:center; justify-content:center; gap:10px; color:var(--text-tertiary); font-size:13px">
                <span class="material-symbols-rounded" style="font-size:44px; color:var(--border)">forum</span>
                <div>좌측에서 문의를 선택하면 대화 내용이 표시됩니다.</div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <script id="page-script">
      const CHATS = [
        { id: "user01", title: "관리비 문의", time: "2026-04-14 10:32", messages: [
          { role: "user", text: "관리비 납부 방법 알려주세요", time: "10:28" },
          { role: "ai", text: "관리비는 앱 또는 관리사무소에서 납부 가능합니다.", time: "10:28" },
          { role: "user", text: "자동이체 신청은 어디서 하나요?", time: "10:32" },
          { role: "ai", text: "자동이체는 관리사무소 방문 또는 앱 내 납부 설정에서 신청하실 수 있습니다.", time: "10:32" },
        ]},
        { id: "user02", title: "주차장 민원", time: "2026-04-14 09:15", messages: [
          { role: "user", text: "방문객 주차는 어디에 하나요?", time: "09:10" },
          { role: "ai", text: "방문객 주차는 지하 1층 B구역을 이용하시면 됩니다.", time: "09:11" },
          { role: "user", text: "주차 가능 시간도 알 수 있을까요?", time: "09:15" },
          { role: "ai", text: "방문객 주차는 오전 6시부터 오후 11시까지 이용 가능합니다.", time: "09:15" },
        ]},
        { id: "user03", title: "엘리베이터 고장", time: "2026-04-13 17:44", messages: [
          { role: "user", text: "엘리베이터 3층 버튼이 작동하지 않아요", time: "17:40" },
          { role: "ai", text: "불편을 드려 죄송합니다. 시설팀에 접수하겠습니다.", time: "17:41" },
          { role: "user", text: "언제쯤 수리가 될까요?", time: "17:44" },
          { role: "ai", text: "접수된 건은 영업일 기준 1~2일 내 처리될 예정입니다.", time: "17:44" },
        ]},
      ];
      // 더미 데이터 확장(스크롤/페이지네이션/필터 동작 확인용)
      const _TOPICS = ["관리비","주차","엘리베이터","층간소음","택배함","도어락","누수","냄새","보안","분리수거"];
      for (let i = 4; i <= 140; i++) { const id="user"+String(i).padStart(2,"0"), topic=_TOPICS[i%_TOPICS.length];
        const day=String(((i*3)%28)+1).padStart(2,"0"), hh=String(8+(i%10)).padStart(2,"0"), mm=String((i*7)%60).padStart(2,"0");
        const t=`2026-04-${day} ${hh}:${mm}`; CHATS.push({ id, title: topic+" 문의", time: t, messages: [
          { role:"user", text:`${topic} 관련 문의가 있어요.`, time:`${hh}:${mm}` },
          { role:"ai", text:"문의 내용을 확인했습니다. 추가 정보가 필요하면 안내드리겠습니다.", time:`${hh}:${mm}` },
        ]}); }

      let currentId = null;
      const msgStore = {};
      CHATS.forEach((c) => { msgStore[c.id] = [...c.messages]; });

      const LIST_PAGE_SIZE = 20;
      let listLimit = LIST_PAGE_SIZE;
      let listFiltered = CHATS.slice();
      let listRangeDays = "all";
      let listSort = "desc";
      let listPage = 1;

      function renderList(items) {
        document.getElementById("chat-count").textContent = items.length;
        const body = document.getElementById("chat-list-body");
        const foot = document.getElementById("chat-list-foot");
        if (!items.length) {
          body.innerHTML = `<div class="chat-empty-list">조회된 문의가 없습니다.</div>`;
          if (foot) foot.innerHTML = "";
          return;
        }
        const totalPages = Math.max(1, Math.ceil(items.length / LIST_PAGE_SIZE));
        if (listPage > totalPages) listPage = totalPages;
        if (listPage < 1) listPage = 1;
        const start = (listPage - 1) * LIST_PAGE_SIZE;
        const slice = items.slice(start, start + LIST_PAGE_SIZE);

        body.innerHTML = slice.map((c) => {
          const isActive = c.id === currentId;
          const bg = isActive ? "rgba(15,23,42,0.06)" : "transparent";
          const leftBar = isActive ? "inset 2px 0 0 rgba(15,23,42,0.18)" : "none";
          return `
            <div
              role="button"
              tabindex="0"
              onclick="selectChat('${c.id}')"
              onkeydown="if(event.key==='Enter'){selectChat('${c.id}');}"
              onmouseenter="hoverRow(this,true)"
              onmouseleave="hoverRow(this,false)"
              data-active="${isActive ? "1" : "0"}"
              style="padding:12px 16px; cursor:pointer; background:${bg}; box-shadow:${leftBar}; transition:background .12s;"
            >
              <div style="display:flex; align-items:center; justify-content:space-between; gap:10px; margin-bottom:2px">
                <div style="font-weight:800; font-size:13px; color:var(--text-primary)">${c.id}</div>
                <time style="font-size:11px; color:var(--text-tertiary); font-variant-numeric:tabular-nums">${String(c.time).split(' ')[1] || ''}</time>
              </div>
              <div style="font-size:12px; color:var(--text-tertiary); white-space:nowrap; overflow:hidden; text-overflow:ellipsis">${c.title}</div>
            </div>
          `;
        }).join("");

        if (foot) {
          const windowSize = 5, half = Math.floor(windowSize / 2);
          let startPage = Math.max(1, listPage - half);
          let endPage = Math.min(totalPages, startPage + windowSize - 1);
          startPage = Math.max(1, endPage - windowSize + 1);
          const pageBtns = [];
          for (let p = startPage; p <= endPage; p++) { const isActive = p === listPage;
            pageBtns.push(`<button class="c-pagination__btn${isActive ? " is-active" : ""}" type="button" onclick="setListPage(${p})" ${isActive ? "aria-current=\"page\" disabled" : ""}>${p}</button>`); }
          foot.innerHTML = `
            <div class="chat-list-foot__top">
              <div class="c-pagination c-pagination--mini" aria-label="페이지네이션">
                <button class="c-pagination__btn" type="button" onclick="setListPage(${listPage - 1})" ${listPage === 1 ? "disabled" : ""} aria-label="이전 페이지">
                  <span class="material-symbols-rounded">chevron_left</span>
                </button>
                ${pageBtns.join("")}
                <button class="c-pagination__btn" type="button" onclick="setListPage(${listPage + 1})" ${listPage === totalPages ? "disabled" : ""} aria-label="다음 페이지">
                  <span class="material-symbols-rounded">chevron_right</span>
                </button>
              </div>
            </div>
          `;
        }
      }

      function applyListFilter() {
        const now = Date.now();
        const days = Number(listRangeDays);
        const rangeMs = Number.isFinite(days) && days > 0 ? days * 24 * 60 * 60 * 1000 : 0;

        listFiltered = CHATS
          .filter((c) => {
            if (!rangeMs) return true;
            const ts = new Date(String(c.time).replace(" ", "T")).getTime();
            if (!Number.isFinite(ts)) return true;
            return now - ts <= rangeMs;
          })
          .sort((a, b) => {
            const at = String(a.time);
            const bt = String(b.time);
            return listSort === "asc" ? at.localeCompare(bt) : bt.localeCompare(at);
          });
        listPage = 1;
        renderList(listFiltered);
      }

      function setListPage(p) {
        const totalPages = Math.max(1, Math.ceil(listFiltered.length / LIST_PAGE_SIZE));
        const next = Math.min(totalPages, Math.max(1, Number(p) || 1));
        if (next === listPage) return;
        listPage = next;
        renderList(listFiltered);
        const body = document.getElementById("chat-list-body");
        if (body) body.scrollTop = 0;
      }

      function hoverRow(el, on) {
        if (!el) return;
        if (el.getAttribute("data-active") === "1") return;
        el.style.background = on ? "rgba(15,23,42,0.04)" : "transparent";
      }

      function runListSearch() {
        const r = document.getElementById("range-select");
        const s = document.getElementById("sort-select");
        listRangeDays = (r ? r.value : "all") || "all";
        listSort = (s ? s.value : "desc") || "desc";
        applyListFilter();
      }
      function selectChat(id) {
        currentId = id;
        const c = CHATS.find((x) => x.id === id);
        renderList(listFiltered);
        document.getElementById("chat-head-user").textContent = c.id;
        document.getElementById("chat-head-title").textContent = " · " + c.title;
        document.getElementById("chat-head").style.display = "";
        renderMessages(id);
      }
      function renderMessages(id) {
        const msgs = msgStore[id] || [];
        const el = document.getElementById("chat-messages");
        const rows = msgs.map((m) => {
          const isAI = m.role === "ai";
          const align = isAI ? "flex-end" : "flex-start";
          const timeAlign = isAI ? "right" : "left";
          const avatar = isAI ? "AI" : String(m.role || "US").slice(0, 2).toUpperCase();
          const bubbleStyle = "max-width:520px;background:var(--gray-soft);color:var(--text-primary);padding:9px 13px;border-radius:16px;line-height:1.55;font-size:13px";
          const avatarStyle = "width:28px;height:28px;border-radius:50%;display:flex;align-items:center;justify-content:center;background:var(--gray-soft);color:var(--text-secondary);font-size:11px;font-weight:800;flex-shrink:0";
          const timeStyle = `font-size:10px;color:var(--text-tertiary);margin-bottom:2px;text-align:${timeAlign}`;
          return `<div style="display:flex;gap:8px;align-items:flex-end;justify-content:${align}">
            ${isAI ? `<div><div style="${timeStyle}">${m.time}</div><div style="${bubbleStyle}">${m.text}</div></div><div style="${avatarStyle}">${avatar}</div>`
                   : `<div style="${avatarStyle}">${avatar}</div><div><div style="${timeStyle}">${m.time}</div><div style="${bubbleStyle}">${m.text}</div></div>`}
          </div>`;
        }).join("");
        el.innerHTML = rows || document.getElementById("chat-empty").outerHTML;
        el.scrollTop = el.scrollHeight;
        const empty = document.getElementById("chat-empty");
        if (empty) empty.style.display = "none";
      }
      document.addEventListener("DOMContentLoaded", () => {
        const rangeSel = document.getElementById("range-select");
        const sortSel = document.getElementById("sort-select");
        if (rangeSel) rangeSel.addEventListener("change", runListSearch);
        if (sortSel) sortSel.addEventListener("change", runListSearch);
        applyListFilter();
      });
    </script>
    <script>
      function toggleSidebar() {
        var sidebar = document.getElementById("sidebar");
        if (sidebar) sidebar.classList.toggle("collapsed");
      }
      var logoIcon = document.getElementById("logoIcon");
      if (logoIcon) {
        logoIcon.onclick = function () {
          var sidebar = document.getElementById("sidebar");
          if (sidebar && sidebar.classList.contains("collapsed")) toggleSidebar();
        };
      }
    </script>
    
  </body>
</html>
