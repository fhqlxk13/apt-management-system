<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true"%>
<!doctype html>
<html lang="ko">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1.0" />
    <title>우리집맵핑 · 통합 게시판 관리</title>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet" />
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/centralAside.css" />
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/centralHeader.css" />
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/centralCommon.css" />
    <%--<script defer src="<%= request.getContextPath() %>/js/centralAside.js"></script>
    <script defer src="<%= request.getContextPath() %>/js/centralHeader.js"></script>--%>
    <style id="page-style">
      .write-modal-body{display:flex}
      .write-modal-left{flex:7;padding:22px;display:flex;flex-direction:column;gap:14px;overflow-y:auto}
      .write-modal-right{flex:3;padding:18px;background:var(--gray-soft);border-left:1px solid var(--border)}
      .write-modal-right h4{font-size:13px;font-weight:700;color:var(--text-secondary);margin-bottom:8px}
      .write-modal-right ul{padding-left:16px;margin-top:6px} .write-modal-right li{font-size:12px;color:var(--text-tertiary);line-height:1.7}
      .recruit-dates{display:flex;gap:12px} .recruit-dates.is-hidden{display:none}
      .inq-meta{display:flex;gap:16px;flex-wrap:wrap;margin-bottom:8px;font-size:12px} .inq-meta strong{color:var(--text-primary);margin-right:5px}
      .inq-title-text{font-size:14px;font-weight:700;margin-bottom:8px;color:var(--text-primary)}
      .inq-body{font-size:13px;color:var(--text-secondary);line-height:1.7;background:#fff;border:1px solid var(--border);border-radius:8px;padding:12px}
      .modal-sec{padding:14px 18px} .modal-sec+.modal-sec{border-top:1px solid var(--border)} .modal-sec.sec-inquiry{background:var(--gray-soft)}
      .modal-sec-title{font-size:11px;font-weight:700;color:var(--text-tertiary);text-transform:uppercase;letter-spacing:.04em;margin-bottom:9px}
      .reply-top{display:flex;align-items:center;justify-content:space-between;margin-bottom:8px}
      .history-list{display:flex;flex-direction:column;gap:6px}
      .history-item{display:flex;align-items:center;gap:10px;font-size:12px;padding:8px 10px;border-radius:8px;background:var(--gray-soft)}
      .history-item .hi-date{color:var(--text-tertiary);white-space:nowrap} .history-item .hi-title{flex:1;color:var(--text-secondary);overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
    </style>
  </head>
  <body>
    <%@ include file="centralAside.jsp" %>

    <div class="main-wrap">
      <div class="topbar">
        <div class="breadcrumb">
          <span class="material-symbols-rounded" style="font-size: 14px">home</span>
          <span style="margin: 0 4px">/</span>
          <span>민원·소통</span>
          <span style="margin: 0 4px">/</span>
          <span class="bc-current">통합 게시판 관리</span>
        </div>
        <div class="topbar-actions">
          <button class="topbar-icon-btn" data-tooltip="알림"><span class="material-symbols-rounded">notifications</span><div class="dot"></div></button>
          <button class="topbar-icon-btn" data-tooltip="설정"><span class="material-symbols-rounded">settings</span></button>
        </div>
      </div>

      <div class="main-content">
        <div class="page-header">
          <div>
            <div class="page-title">통합 게시판 관리</div>
            <div class="page-subtitle">공지사항·공고·문의를 한 곳에서 작성·답변하고 미답변 건을 빠르게 처리합니다.</div>
          </div>
          <div class="page-header__right">
            <button class="c-btn c-btn--primary" id="btn-write" onclick="openWriteModal()"><span class="material-symbols-rounded">add</span>게시글 작성</button>
          </div>
        </div>

        <!-- 검색 조건 -->
        <div class="c-card c-card--divide" style="margin-bottom: 16px">
          <div class="c-card__header">
            <div>
              <div class="c-card__title">검색 조건</div>
              <div class="c-card__sub">공지·공고·문의 항목을 선택해 빠르게 조회합니다.</div>
            </div>
            <div class="c-card__actions">
              <button class="c-btn c-btn--ghost" onclick="resetFilters()"><span class="material-symbols-rounded">refresh</span>초기화</button>
              <button class="c-btn c-btn--primary" onclick="applyFilters()"><span class="material-symbols-rounded">search</span>검색</button>
            </div>
          </div>
          <div class="c-card__body c-filter-row">
            <div class="c-field" style="min-width: 150px">
              <label class="c-label">구분</label>
              <select class="c-select" id="filter-type" onchange="changeType(this.value)">
                <option value="전체">전체</option>
                <option value="공지사항">공지사항</option>
                <option value="공고/모집">공고/모집</option>
                <option value="문의">문의</option>
              </select>
            </div>
            <div class="c-field" style="flex: 1; min-width: 220px">
              <label class="c-label">검색</label>
              <input type="search" class="c-input" id="search-input" placeholder="제목 또는 작성자 검색" />
            </div>
            <div class="c-field board-only" style="min-width: 140px">
              <label class="c-label">상태</label>
              <select class="c-select" id="filter-status">
                <option value="">전체 상태</option>
                <option>게시중</option>
                <option>임시저장</option>
                <option>마감</option>
              </select>
            </div>
            <div class="c-field inq-only" style="min-width: 140px; display: none">
              <label class="c-label">답변 상태</label>
              <select class="c-select" id="filter-inq-status">
                <option value="">전체 답변 상태</option>
                <option value="wait">답변대기</option>
                <option value="done">답변완료</option>
              </select>
            </div>
          </div>
        </div>

        <!-- 목록 -->
        <div class="c-card c-card--divide">
          <div class="c-card__header">
            <div>
              <div class="c-card__title">목록</div>
              <div class="c-card__sub" id="table-count"></div>
            </div>
          </div>
          <div class="c-table-wrap">
            <table class="c-table" id="main-table">
              <thead id="main-thead"></thead>
              <tbody id="main-tbody"></tbody>
            </table>
          </div>
          <div class="c-card__footer" style="justify-content: center">
            <div class="c-pagination" id="pagination"></div>
          </div>
        </div>
      </div>
    </div>

    <!-- 게시글 작성/수정 모달 -->
    <div class="c-modal-overlay is-hidden" id="writeBackdrop" onclick="closeWriteOutside(event)">
      <div class="c-modal c-modal--lg">
        <div class="c-modal__header">
          <h4 class="c-modal__title" id="write-modal-title">게시글 작성</h4>
          <button class="c-modal__close" onclick="closeWriteModal()" aria-label="닫기"><span class="material-symbols-rounded">close</span></button>
        </div>
        <div class="write-modal-body">
          <div class="write-modal-left">
            <div style="display: flex; gap: 12px">
              <div class="c-field" style="flex: 1">
                <label class="c-label">게시판 선택</label>
                <select class="c-select" id="boardTypeSelect" onchange="toggleRecruitDates()">
                  <option value="">선택하세요</option>
                  <option value="공지사항">공지사항</option>
                  <option value="공고/모집">공고/모집</option>
                </select>
              </div>
              <div class="c-field" style="flex: 1">
                <label class="c-label">상단 고정</label>
                <select class="c-select">
                  <option value="N">고정 안함</option>
                  <option value="Y">상단 고정</option>
                </select>
              </div>
            </div>
            <div class="recruit-dates is-hidden" id="recruitDates">
              <div class="c-field" style="flex: 1"><label class="c-label">모집 시작일</label><input type="date" class="c-input" /></div>
              <div class="c-field" style="flex: 1"><label class="c-label">모집 종료일</label><input type="date" class="c-input" /></div>
            </div>
            <div class="c-field"><label class="c-label">제목</label><input type="text" class="c-input" placeholder="제목을 입력하세요" /></div>
            <div class="c-field"><label class="c-label">내용</label><textarea class="c-textarea" rows="8" placeholder="내용을 입력하세요"></textarea></div>
            <div class="c-field">
              <label class="c-label">첨부파일</label>
              <div style="display: flex; align-items: center; gap: 10px">
                <input type="file" id="fileInput" multiple style="display: none" />
                <label class="c-file-label" for="fileInput"><span class="material-symbols-rounded" style="font-size: 16px; vertical-align: middle">attach_file</span>파일 선택</label>
                <span style="font-size: 12px; color: var(--text-tertiary)">최대 10MB · 최대 5개</span>
              </div>
            </div>
          </div>
          <div class="write-modal-right">
            <h4>처리 안내</h4>
            <p style="font-size: 12px; color: var(--text-tertiary); line-height: 1.6">게시글 작성 시 유의 사항을 확인해 주세요.</p>
            <ul>
              <li>공지사항은 전체 입주민에게 공개됩니다.</li>
              <li>상단 고정은 최대 3개까지 설정 가능합니다.</li>
              <li>공고/모집은 반드시 모집 기간을 입력해야 합니다.</li>
              <li>부적절한 내용은 관리자에 의해 삭제될 수 있습니다.</li>
              <li>첨부파일은 jpg, png, pdf만 허용됩니다.</li>
            </ul>
          </div>
        </div>
        <div class="c-modal__footer">
          <button class="c-btn c-btn--danger" id="btn-delete-post" style="display:none" onclick="alert('삭제되었습니다.'); closeWriteModal();">삭제</button>
          <button class="c-btn c-btn--ghost" onclick="closeWriteModal()">닫기</button>
          <button class="c-btn c-btn--primary" onclick="submitPost()"><span class="material-symbols-rounded">check</span>등록</button>
        </div>
      </div>
    </div>

    <!-- 문의 상세/답변 모달 -->
    <div class="c-modal-overlay is-hidden" id="inqBackdrop" onclick="closeInqOutside(event)">
      <div class="c-modal">
        <div class="c-modal__header">
          <h4 class="c-modal__title">문의 상세 / 답변 작성</h4>
          <button class="c-modal__close" onclick="closeInqModal()" aria-label="닫기"><span class="material-symbols-rounded">close</span></button>
        </div>
        <div class="c-modal__body" style="padding: 0">
          <div class="modal-sec sec-inquiry">
            <div class="modal-sec-title">문의 원본</div>
            <div class="inq-meta">
              <span><strong>주소</strong><span id="m-addr"></span></span>
              <span><strong>입주민</strong><span id="m-name"></span></span>
              <span><strong>작성일</strong><span id="m-date"></span></span>
            </div>
            <div class="inq-title-text" id="m-title"></div>
            <div class="inq-body" id="m-body"></div>
          </div>
          <div class="modal-sec">
            <div class="reply-top">
              <div class="modal-sec-title" style="margin-bottom: 0">답변 작성</div>
              <select class="c-select" id="m-status" style="width: 130px">
                <option value="wait">답변대기</option>
                <option value="done">답변완료</option>
              </select>
            </div>
            <textarea class="c-textarea" id="m-reply" rows="5" placeholder="답변 내용을 입력하세요..."></textarea>
          </div>
          <div class="modal-sec">
            <div class="modal-sec-title">해당 세대의 이전 문의 이력</div>
            <div class="history-list" id="m-history"></div>
          </div>
        </div>
        <div class="c-modal__footer">
          <button class="c-btn c-btn--ghost" onclick="closeInqModal()">닫기</button>
          <button class="c-btn c-btn--primary" onclick="submitReply()"><span class="material-symbols-rounded">send</span>답변 등록</button>
        </div>
      </div>
    </div>

    <script>
      const boardPosts=[];(function(){
        const types=["공지사항","공고/모집"],statuses=["게시중","게시중","게시중","임시저장","마감"],authors=["중앙관리자","김관리","박담당"];
        const titles=["편의시설 이용 안내","엘리베이터 정기 점검","하자보수 접수 기간","여름 에너지 절약 캠페인","입주민 대표 회의 위원 모집","주차장 도색 공사","재활용 분리수거 가이드","방범 시스템 점검 일정","휴가철 보안 강화","복도 청소 일정 변경","수영장 운영 안내","체육관 신규 프로그램"];
        for(let i=0;i<22;i++)boardPosts.push({type:types[i%2],title:titles[i%titles.length]+" ("+(i+1)+")",author:authors[i%3],status:statuses[i%statuses.length],date:"2026-04-"+String(((i*2)%28)+1).padStart(2,"0")});
      })();

      const inquiryPosts = [
        { id: 1, addr: "101동 305호", name: "김민준", date: "2026-04-20", title: "주차장 배정 변경 요청", body: "현재 B2-12번 자리를 사용 중인데, 전기차 충전 구역으로 변경이 가능한지 문의드립니다.", status: "wait" },
        { id: 2, addr: "102동 110호", name: "이서연", date: "2026-04-19", title: "엘리베이터 소음 민원", body: "야간에 엘리베이터 작동 소음이 심해 수면에 방해가 됩니다. 점검 부탁드립니다.", status: "wait" },
        { id: 3, addr: "101동 701호", name: "박지훈", date: "2026-04-18", title: "택배 보관함 비밀번호 분실", body: "무인 택배함 비밀번호를 분실했습니다. 초기화 방법 부탁드립니다.", status: "done" },
        { id: 4, addr: "103동 202호", name: "최유진", date: "2026-04-17", title: "공용 세탁실 이용 문의", body: "공용 세탁실 이용 시간 및 예약 방법이 궁금합니다.", status: "wait" },
        { id: 5, addr: "102동 504호", name: "정도현", date: "2026-04-16", title: "관리비 항목 확인 요청", body: "이번 달 관리비 명세서에 '기타 부과금' 항목이 있어 내역 확인 요청드립니다.", status: "done" },
        { id: 6, addr: "101동 305호", name: "김민준", date: "2026-04-10", title: "입주 시 하자 보수 요청", body: "입주 초기 도배 불량 부분 수리를 요청합니다.", status: "done" },
        { id: 7, addr: "104동 801호", name: "윤서아", date: "2026-04-15", title: "방문자 주차 등록 방법", body: "부모님 방문 시 방문자 주차 등록은 어떻게 하나요?", status: "wait" },
        { id: 8, addr: "103동 401호", name: "강민호", date: "2026-04-14", title: "층간 소음 중재 요청", body: "윗층 소음이 지속되고 있어 관리사무소에서 중재 요청드립니다.", status: "done" },
        { id: 9, addr: "102동 602호", name: "한채원", date: "2026-04-13", title: "택배함 추가 설치 요청", body: "주말에 택배가 몰릴 때 보관함이 부족합니다. 증설 검토 부탁드립니다.", status: "wait" },
        { id: 10, addr: "103동 303호", name: "오지훈", date: "2026-04-12", title: "엘리베이터 광고 제거 요청", body: "엘리베이터 내부 광고가 너무 많아 광고를 줄여주시면 좋겠습니다.", status: "done" },
        { id: 11, addr: "104동 202호", name: "임나은", date: "2026-04-11", title: "분리수거장 청결 관리", body: "분리수거장이 자주 더러워 관리 강화 부탁드립니다.", status: "wait" },
      ];

      const PAGE_SIZE = 10;
      let currentTab = "전체";
      let currentPage = 1;

      const TYPE_BADGE = { 공지사항: "c-badge--neutral", "공고/모집": "c-badge--pending" };
      const STATUS_BADGE = { 게시중: "c-badge--active", 임시저장: "c-badge--neutral", 마감: "c-badge--neutral" };
      function inqBadgeHtml(s) {
        return s === "wait"
          ? '<span class="c-badge c-badge--danger">답변대기</span>'
          : '<span class="c-badge c-badge--active">답변완료</span>';
      }

      function getFiltered() {
        const q = document.getElementById("search-input").value.trim().toLowerCase();
        if (currentTab === "문의") {
          const inqStatus = document.getElementById("filter-inq-status").value;
          return inquiryPosts.filter((p) =>
            (!q || p.title.toLowerCase().includes(q) || p.name.toLowerCase().includes(q) || p.addr.toLowerCase().includes(q))
            && (!inqStatus || p.status === inqStatus)
          );
        } else {
          const status = document.getElementById("filter-status").value;
          let list = currentTab === "전체" ? boardPosts : boardPosts.filter((p) => p.type === currentTab);
          return list.filter((p) =>
            (!q || p.title.toLowerCase().includes(q) || p.author.toLowerCase().includes(q))
            && (!status || p.status === status)
          );
        }
      }

      function renderTable() {
        const thead = document.getElementById("main-thead");
        const tbody = document.getElementById("main-tbody");
        const list = getFiltered();
        const start = (currentPage - 1) * PAGE_SIZE;
        const slice = list.slice(start, start + PAGE_SIZE);

        if (currentTab === "문의") {
          thead.innerHTML = '<tr>'
            + '<th style="width:60px">번호</th>'
            + '<th style="width:130px">입주민 주소</th>'
            + '<th>문의 제목</th>'
            + '<th style="width:120px">작성일</th>'
            + '<th style="width:120px">답변 상태</th>'
            + '</tr>';
          if (slice.length === 0) {
            tbody.innerHTML = '<tr><td colspan="5"><div class="c-empty"><div class="c-empty__title">조회된 문의가 없습니다</div><div class="c-empty__sub">다른 조건으로 검색해보세요.</div></div></td></tr>';
          } else {
            tbody.innerHTML = slice.map((p) => {
              return '<tr style="cursor:pointer" data-id="' + p.id + '">'
                + '<td>' + p.id + '</td>'
                + '<td>' + p.addr + '</td>'
                + '<td style="font-weight:600">' + p.title + '</td>'
                + '<td style="color:var(--text-secondary)">' + p.date + '</td>'
                + '<td>' + inqBadgeHtml(p.status) + '</td>'
                + '</tr>';
            }).join("");
            tbody.querySelectorAll("tr").forEach((tr) => {
              tr.addEventListener("click", () => {
                const id = Number(tr.dataset.id);
                const p = inquiryPosts.find((x) => x.id === id);
                if (p) openInqModal(p);
              });
            });
          }
        } else {
          thead.innerHTML = '<tr>'
            + '<th style="width:110px">카테고리</th>'
            + '<th>제목</th>'
            + '<th style="width:110px">작성자</th>'
            + '<th style="width:100px">상태</th>'
            + '<th style="width:120px">작성일</th>'
            + '</tr>';
          if (slice.length === 0) {
            tbody.innerHTML = '<tr><td colspan="5"><div class="c-empty"><div class="c-empty__title">조회된 게시글이 없습니다</div><div class="c-empty__sub">다른 조건으로 검색해보세요.</div></div></td></tr>';
          } else {
            tbody.innerHTML = slice.map((p) => {
              return '<tr style="cursor:pointer" onclick="openWriteModal(true)">'
                + '<td><span class="c-badge ' + (TYPE_BADGE[p.type] || "") + '">' + p.type + '</span></td>'
                + '<td style="font-weight:600">' + p.title + '</td>'
                + '<td>' + p.author + '</td>'
                + '<td><span class="c-badge ' + (STATUS_BADGE[p.status] || "") + '">' + p.status + '</span></td>'
                + '<td style="color:var(--text-secondary)">' + p.date + '</td>'
                + '</tr>';
            }).join("");
          }
        }
        document.getElementById("table-count").innerHTML = '총 <strong style="color:var(--text-primary)">' + list.length + '</strong>건';

        // 필터/버튼 토글
        const inqOnly = document.querySelector(".inq-only");
        const boardOnly = document.querySelector(".apt-only");
        const btnWrite = document.getElementById("btn-write");
        if (currentTab === "문의") {
          inqOnly.style.display = "";
          boardOnly.style.display = "none";
          btnWrite.style.display = "none";
        } else {
          inqOnly.style.display = "none";
          boardOnly.style.display = "";
          btnWrite.style.display = "";
        }

        renderPagination(list.length);
      }

      function renderPagination(total) {
        const el = document.getElementById("pagination");
        const last = Math.max(1, Math.ceil(total / PAGE_SIZE));
        if (last <= 1) { el.innerHTML = ""; return; }
        const btn = (label, page, opts) => {
          const cls = ["c-pagination__btn"];
          if (opts && opts.active) cls.push("is-active");
          if (opts && opts.disabled) cls.push("is-disabled");
          return '<button class="' + cls.join(" ") + '" data-page="' + page + '">' + label + '</button>';
        };
        let html = "";
        html += btn('<span class="material-symbols-rounded">chevron_left</span>', currentPage - 1, { disabled: currentPage === 1 });
        for (let i = 1; i <= last; i++) html += btn(i, i, { active: i === currentPage });
        html += btn('<span class="material-symbols-rounded">chevron_right</span>', currentPage + 1, { disabled: currentPage === last });
        el.innerHTML = html;
        el.querySelectorAll(".c-pagination__btn").forEach((b) => {
          b.addEventListener("click", () => {
            if (b.classList.contains("is-disabled") || b.classList.contains("is-active")) return;
            currentPage = Number(b.dataset.page);
            renderTable();
          });
        });
      }

      function applyFilters() { currentPage = 1; renderTable(); }
      function resetFilters() {
        document.getElementById("search-input").value = "";
        document.getElementById("filter-status").value = "";
        document.getElementById("filter-inq-status").value = "";
        document.getElementById("filter-type").value = "전체";
        currentTab = "전체";
        currentPage = 1;
        renderTable();
      }

      function changeType(v) { currentTab = v; currentPage = 1; renderTable(); }

      function renderStats() {}

      function openWriteModal(isEdit) {
        document.getElementById("write-modal-title").textContent = isEdit ? "게시글 수정" : "게시글 작성";
        document.getElementById("btn-delete-post").style.display = isEdit ? "" : "none";
        document.getElementById("writeBackdrop").classList.remove("is-hidden");
      }
      function closeWriteModal() { document.getElementById("writeBackdrop").classList.add("is-hidden"); }
      function closeWriteOutside(e) { if (e.target === document.getElementById("writeBackdrop")) closeWriteModal(); }
      function toggleRecruitDates() {
        const val = document.getElementById("boardTypeSelect").value;
        document.getElementById("recruitDates").classList.toggle("is-hidden", val !== "공고/모집");
      }
      function submitPost() {
        alert("저장되었습니다.");
        closeWriteModal();
      }

      let currentInq = null;
      function openInqModal(p) {
        currentInq = p;
        document.getElementById("m-addr").textContent = p.addr;
        document.getElementById("m-name").textContent = p.name;
        document.getElementById("m-date").textContent = p.date;
        document.getElementById("m-title").textContent = p.title;
        document.getElementById("m-body").textContent = p.body;
        document.getElementById("m-status").value = p.status;
        document.getElementById("m-reply").value = "";
        const history = inquiryPosts.filter((x) => x.addr === p.addr && x.id !== p.id).slice(0, 3);
        const hEl = document.getElementById("m-history");
        hEl.innerHTML = history.length
          ? history.map((h) => '<div class="history-item"><span class="hi-date">' + h.date + '</span><span class="hi-title">' + h.title + '</span>' + inqBadgeHtml(h.status) + '</div>').join("")
          : '<div style="font-size:12px;color:var(--text-tertiary)">이전 문의 이력이 없습니다.</div>';
        document.getElementById("inqBackdrop").classList.remove("is-hidden");
      }
      function closeInqModal() { document.getElementById("inqBackdrop").classList.add("is-hidden"); }
      function closeInqOutside(e) { if (e.target === document.getElementById("inqBackdrop")) closeInqModal(); }

      function submitReply() {
        const reply = document.getElementById("m-reply").value.trim();
        if (!reply) { alert("답변 내용을 입력하세요."); return; }
        if (currentInq) {
          currentInq.status = document.getElementById("m-status").value;
          renderTable();
        }
        alert("답변이 등록되었습니다.");
        closeInqModal();
      }

      renderTable();
      document.getElementById("search-input").addEventListener("input", () => { currentPage = 1; renderTable(); });
    </script>
    <script>
      function toggleSidebar(){var s=document.getElementById("sidebar");if(s)s.classList.toggle("collapsed");}
      var logoIcon=document.getElementById("logoIcon");
      if(logoIcon){logoIcon.onclick=function(){var s=document.getElementById("sidebar");if(s&&s.classList.contains("collapsed"))toggleSidebar();};}
    </script>
  </body>
</html>
