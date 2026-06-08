<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true"%>
<!doctype html>
<html lang="ko">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1.0" />
    <title>우리집맵핑 · 매물 통합 검색</title>
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
          <span>건물·입주민</span>
          <span style="margin: 0 4px">/</span>
          <span class="bc-current">매물 통합 검색</span>
        </div>
        <div class="topbar-actions">
          <button class="topbar-icon-btn" data-tooltip="알림"><span class="material-symbols-rounded">notifications</span><div class="dot"></div></button>
          <button class="topbar-icon-btn" data-tooltip="설정"><span class="material-symbols-rounded">settings</span></button>
        </div>
      </div>

      <div class="main-content">
        <div class="page-header">
          <div>
            <div class="page-title">매물 통합 검색</div>
            <div class="page-subtitle">단지·동·호수, 거래 유형 조건으로 매물을 통합 검색합니다.</div>
          </div>
          <div class="page-header__right">
            <button class="c-btn" data-tooltip="결과를 엑셀로 내려받기"><span class="material-symbols-rounded">table_view</span>엑셀 출력하기</button>
          </div>
        </div>

        <!-- 검색 필터 -->
        <div class="c-card c-card--divide" style="margin-bottom: 14px">
          <div class="c-card__header">
            <div>
              <div class="c-card__title">검색 조건</div>
              <div class="c-card__sub">조건을 조합해 매물을 정밀하게 좁힐 수 있습니다.</div>
            </div>
            <div class="c-card__actions">
              <button class="c-btn c-btn--ghost" id="btnReset">
                <span class="material-symbols-rounded">refresh</span>초기화
              </button>
              <button class="c-btn c-btn--primary" id="btnSearch">
                <span class="material-symbols-rounded">search</span>조회
              </button>
            </div>
          </div>
          <div class="c-card__body">
            <div style="display: grid; grid-template-columns: 1.6fr 0.8fr 0.8fr 1fr 1fr; gap: 12px; margin-bottom: 16px">
              <div class="c-field">
                <label class="c-label">단지명</label>
                <input class="c-input" id="f-complex" type="text" placeholder="단지명 입력" />
              </div>
              <div class="c-field">
                <label class="c-label">동</label>
                <input class="c-input" id="f-dong" type="text" placeholder="동" />
              </div>
              <div class="c-field">
                <label class="c-label">호수</label>
                <input class="c-input" id="f-ho" type="text" placeholder="호수" />
              </div>
              <div class="c-field">
                <label class="c-label">면적 타입</label>
                <select class="c-select" id="f-type">
                  <option value="">전체</option>
                  <option>59㎡형</option>
                  <option>84㎡형</option>
                  <option>101㎡형</option>
                  <option>114㎡형</option>
                </select>
              </div>
              <div class="c-field">
                <label class="c-label">거래 유형</label>
                <select class="c-select" id="f-deal">
                  <option value="">전체</option>
                  <option>전세</option>
                  <option>월세</option>
                </select>
              </div>
            </div>
          </div>
        </div>

        <!-- 검색 결과 -->
        <div class="c-card c-card--divide">
          <div class="c-card__header">
            <div>
              <div class="c-card__title">검색 결과</div>
              <div class="c-card__sub">총 <span id="result-count" style="color: var(--accent); font-weight: 800">0</span>건 · 페이지당 10건</div>
            </div>
          </div>
          <div class="c-table-wrap">
            <table class="c-table">
              <thead>
                <tr>
                  <th>대상명</th>
                  <th style="width: 80px">구분</th>
                  <th style="width: 90px">면적 타입</th>
                  <th style="width: 110px; text-align: right">관리비</th>
                  <th style="width: 140px; text-align: right">보증금</th>
                  <th style="width: 110px; text-align: right">월세</th>
                  <th style="width: 90px; text-align: right">면적</th>
                </tr>
              </thead>
              <tbody id="result-body"></tbody>
            </table>
          </div>
          <div class="c-card__footer" style="justify-content: center">
            <div class="c-pagination" id="pagination"></div>
          </div>
        </div>
      </div>
    </div>

    <!-- 매물 상세 모달 -->
    <div class="c-modal-overlay is-hidden" id="detailOverlay" onclick="if(event.target===this)closeDetail()">
      <div class="c-modal" id="detailModal" role="dialog" aria-labelledby="detailTitle" aria-modal="true">
        <div class="c-modal__header">
          <span id="detailTitle">매물 상세</span>
          <button class="c-btn c-btn--ghost c-btn--sm" onclick="closeDetail()"><span class="material-symbols-rounded">close</span>닫기</button>
        </div>
        <div class="c-modal__body">
          <div class="c-info-grid" id="detailContent"></div>
        </div>
        <div class="c-modal__footer">
          <button class="c-btn c-btn--danger" onclick="closeDetail()">닫기</button>
          <button class="c-btn c-btn--primary" onclick="closeDetail()">계약 등록</button>
        </div>
      </div>
    </div>

    <script id="page-script">
      // 더미 데이터 — 실제로는 서버에서 받아옴
      const ALL = [];
      const types = ["59㎡형", "84㎡형", "101㎡형", "114㎡형"];
      const areas = { "59㎡형": 59.53, "84㎡형": 84.27, "101㎡형": 101.47, "114㎡형": 114.82 };
      const feeByType = { "59㎡형": 145000, "84㎡형": 198000, "101㎡형": 234000, "114㎡형": 278000 };
      const complexes = ["우리집아파트", "한강푸르지오", "마포래미안", "노원힐스테이트"];
      for (let i = 0; i < 38; i++) {
        const t = types[i % types.length];
        const isJeon = i % 2 === 0;
        ALL.push({
          dong: (101 + (i % 8)) + "동",
          ho: ((i % 12) + 1) * 100 + ((i * 3) % 6) + 1 + "호",
          complex: complexes[i % complexes.length],
          deal: isJeon ? "전세" : "월세",
          type: t,
          fee: feeByType[t],
          deposit: isJeon ? (180 + (i * 17) % 270) * 1000000 : (5 + i % 20) * 1000000,
          rent: isJeon ? null : (500 + (i * 50) % 500) * 1000,
          area: areas[t],
        });
      }

      const PAGE_SIZE = 10;
      let currentPage = 1;
      let filtered = ALL.slice();

      const fmt = (n) => n == null ? '<span class="td-dash">—</span>' : '<span class="td-num">' + n.toLocaleString() + '원</span>';

      function openDetail(idx) {
        const r = filtered[idx];
        if (!r) return;
        document.getElementById("detailTitle").textContent = r.complex + " " + r.dong + " " + r.ho;
        document.getElementById("detailContent").innerHTML = [
          ["단지명", r.complex], ["동/호수", r.dong + " " + r.ho],
          ["거래유형", r.deal], ["면적 타입", r.type],
          ["면적", r.area + "㎡"], ["관리비", r.fee ? r.fee.toLocaleString() + "원" : "-"],
          ["보증금", r.deposit ? r.deposit.toLocaleString() + "원" : "-"],
          ["월세", r.rent ? r.rent.toLocaleString() + "원/월" : "해당없음"],
        ].map(([label, val]) =>
          '<div class="c-info-block"><div class="c-label">' + label + '</div><div class="c-value">' + val + '</div></div>'
        ).join("");
        document.getElementById("detailOverlay").classList.remove("is-hidden");
      }

      function closeDetail() {
        document.getElementById("detailOverlay").classList.add("is-hidden");
      }

      function renderTable() {
        const tbody = document.getElementById("result-body");
        const start = (currentPage - 1) * PAGE_SIZE;
        const slice = filtered.slice(start, start + PAGE_SIZE);
        if (slice.length === 0) {
          tbody.innerHTML = '<tr><td colspan="7"><div class="c-empty"><span class="material-symbols-rounded">search_off</span><div class="c-empty__title">검색 결과가 없습니다</div><div class="c-empty__sub">검색 조건을 변경하거나 필터를 초기화해 보세요.</div></div></td></tr>';
        } else {
          tbody.innerHTML = slice.map((r, i) => ''
            + '<tr style="cursor:pointer" onclick="openDetail(' + (start + i) + ')">'
            + '<td><div style="font-weight:700">' + r.dong + ' ' + r.ho + '</div><div style="font-size:11px;color:var(--text-tertiary);margin-top:2px">' + r.complex + '</div></td>'
            + '<td><span class="c-badge ' + (r.deal === "전세" ? "c-badge--jeonse" : "c-badge--wolse") + '">' + r.deal + '</span></td>'
            + '<td>' + r.type + '</td>'
            + '<td style="text-align:right">' + fmt(r.fee) + '</td>'
            + '<td style="text-align:right">' + fmt(r.deposit) + '</td>'
            + '<td style="text-align:right">' + fmt(r.rent) + '</td>'
            + '<td style="text-align:right" class="td-num">' + r.area + '㎡</td>'
            + '</tr>'
          ).join("");
        }
        document.getElementById("result-count").textContent = filtered.length;
        renderPagination();
      }

      function renderPagination() {
        const el = document.getElementById("pagination");
        const last = Math.max(1, Math.ceil(filtered.length / PAGE_SIZE));
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

      function applySearch() {
        const complex = document.getElementById("f-complex").value.trim().toLowerCase();
        const dong = document.getElementById("f-dong").value.trim();
        const ho = document.getElementById("f-ho").value.trim();
        const type = document.getElementById("f-type").value;
        const deal = document.getElementById("f-deal").value;
        filtered = ALL.filter((r) => {
          if (complex && !r.complex.toLowerCase().includes(complex)) return false;
          if (dong && !r.dong.includes(dong)) return false;
          if (ho && !r.ho.includes(ho)) return false;
          if (type && r.type !== type) return false;
          if (deal && r.deal !== deal) return false;
          return true;
        });
        currentPage = 1;
        renderTable();
      }

      document.getElementById("btnSearch").addEventListener("click", applySearch);
      document.getElementById("btnReset").addEventListener("click", function () {
        ["f-complex", "f-dong", "f-ho"].forEach((id) => (document.getElementById(id).value = ""));
        ["f-type", "f-deal"].forEach((id) => (document.getElementById(id).selectedIndex = 0));
        filtered = ALL.slice();
        currentPage = 1;
        renderTable();
      });

      // Enter로 바로 조회
      ["f-complex", "f-dong", "f-ho"].forEach((id) => {
        const el = document.getElementById(id);
        if (!el) return;
        el.addEventListener("keydown", (e) => {
          if (e.key === "Enter") applySearch();
        });
      });

      renderTable();
    </script>
    <script>
      function toggleSidebar(){var s=document.getElementById("sidebar");if(s)s.classList.toggle("collapsed");}
      var logoIcon=document.getElementById("logoIcon");
      if(logoIcon){logoIcon.onclick=function(){var s=document.getElementById("sidebar");if(s&&s.classList.contains("collapsed"))toggleSidebar();};}
    </script>
  </body>
</html>
