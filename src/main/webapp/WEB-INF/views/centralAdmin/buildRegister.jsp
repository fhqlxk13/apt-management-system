<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true"%>
<!doctype html>
<html lang="ko">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1.0" />
    <title>우리집맵핑 · 건물 등록 및 열람</title>
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
      /* buildRegister.jsp 전용 */
      /* tab-panel, req, c-radio-group, c-drop-zone, c-upload-cat → centralCommon.css 제공 */

      /* 일괄 액션 바 */
      .bulk-bar {
        display: none;
        align-items: center;
        gap: 10px;
        padding: 10px 18px;
        background: var(--blue-bg);
        border-bottom: 1px solid rgba(59, 130, 246, 0.15);
        font-size: 12px;
        color: var(--accent);
        font-weight: 600;
      }
      .bulk-bar.is-show { display: flex; }

      /* 신규 등록 우측 요약 패널 */
      .reg-summary-list { display: flex; flex-direction: column; gap: 10px; }
      .reg-sum-row { display: flex; flex-direction: column; gap: 4px; }
      .reg-sum-row .k { font-size: 11px; font-weight: 700; color: var(--text-tertiary); letter-spacing: 0.02em; }
      .reg-sum-row .v { font-size: 13px; font-weight: 600; color: var(--text-primary); }
      .reg-sum-row .v.muted { font-weight: 500; color: var(--text-tertiary); }
      .reg-alert {
        margin-top: 12px;
        padding: 10px 12px;
        border-radius: 10px;
        background: var(--red-bg);
        border: 1px solid rgba(220, 38, 38, 0.18);
        color: var(--red);
        font-size: 12px;
        font-weight: 700;
        display: none;
      }
    </style>
  </head>
  <body>
    <aside class="sidebar" id="sidebar">
      <div class="sidebar-logo">
        <div class="logo-mark">
          <div class="logo-icon" id="logoIcon"><span class="material-symbols-rounded">home_work</span></div>
          <div class="logo-text">
            <h1>우리집맵핑</h1>
            <p>중앙관리 시스템</p>
          </div>
        </div>
        <button class="collapse-btn" onclick="toggleSidebar()" data-tooltip="사이드바 접기"><span class="material-symbols-rounded">left_panel_close</span></button>
      </div>
      <nav class="sidebar-nav">
        <div class="nav-group">
          <a class="nav-item"><span class="material-symbols-rounded nav-icon">grid_view</span><span class="nav-text">대시보드</span></a>
        </div>
        <div class="section-divider"></div>
        <div class="nav-group">
          <span class="section-label">건물 · 입주민</span>
          <a href="<%= request.getContextPath() %>/centralAdmin/buildSearch" class="nav-item"><span class="material-symbols-rounded nav-icon">manage_search</span><span class="nav-text">매물 통합 검색</span></a>
          <a href="<%= request.getContextPath() %>/centralAdmin/buildRegister" class="nav-item active"><span class="material-symbols-rounded nav-icon">apartment</span><span class="nav-text">건물 등록 및 열람</span></a>
          <a href="<%= request.getContextPath() %>/centralAdmin/residentList" class="nav-item"><span class="material-symbols-rounded nav-icon">groups</span><span class="nav-text">입주민 관리</span></a>
        </div>
        <div class="section-divider"></div>
        <div class="nav-group">
          <span class="section-label">계약 · 재무</span>
          <a href="<%= request.getContextPath() %>/centralAdmin/contractList.do" class="nav-item"><span class="material-symbols-rounded nav-icon">contract</span><span class="nav-text">계약 관리</span></a>
          <a href="<%= request.getContextPath() %>/centralAdmin/statistics" class="nav-item"><span class="material-symbols-rounded nav-icon">bar_chart_4_bars</span><span class="nav-text">통계</span></a>
        </div>
        <div class="section-divider"></div>
        <div class="nav-group">
          <span class="section-label">민원 · 소통</span>
          <a href="<%= request.getContextPath() %>/centralAdmin/civilCom" class="nav-item"><span class="material-symbols-rounded nav-icon">support_agent</span><span class="nav-text">민원 관리</span><span class="nav-badge">3</span></a>
          <a href="<%= request.getContextPath() %>/centralAdmin/ai" class="nav-item"><span class="material-symbols-rounded nav-icon">forum</span><span class="nav-text">문의 관리</span><span class="nav-badge yellow">4</span></a>
          <a href="<%= request.getContextPath() %>/centralAdmin/announcement" class="nav-item"><span class="material-symbols-rounded nav-icon">campaign</span><span class="nav-text">공고 관리</span></a>
          <a href="<%= request.getContextPath() %>/centralAdmin/notice" class="nav-item"><span class="material-symbols-rounded nav-icon">article</span><span class="nav-text">통합 게시판 관리</span></a>
        </div>
        <div class="section-divider"></div>
        <div class="nav-group">
          <span class="section-label">시설 · 시스템</span>
          <a href="<%= request.getContextPath() %>/centralAdmin/facility" class="nav-item"><span class="material-symbols-rounded nav-icon">handyman</span><span class="nav-text">시설 관리</span></a>
          <a href="<%= request.getContextPath() %>/centralAdmin/proHistory" class="nav-item"><span class="material-symbols-rounded nav-icon">warning</span><span class="nav-text">비정상 세대 관리</span></a>
          <a href="<%= request.getContextPath() %>/centralAdmin/mngrRqstAprv" class="nav-item"><span class="material-symbols-rounded nav-icon">manage_accounts</span><span class="nav-text">단지관리자 계정</span></a>
        </div>
      </nav>
      <div class="admin-card">
        <div class="admin-avatar"><span class="material-symbols-rounded" style="color: #fff; font-size: 18px">person</span></div>
        <div class="admin-info">
          <p>중앙관리자</p>
          <span>클로드 최고</span>
        </div>
        <button class="icon-btn" data-tooltip="로그아웃" style="flex-shrink: 0; margin-left: auto"><span class="material-symbols-rounded">logout</span></button>
      </div>
    </aside>

    <div class="main-wrap">
      <div class="topbar">
        <div class="breadcrumb">
          <span class="material-symbols-rounded" style="font-size: 14px">home</span>
          <span style="margin: 0 4px">/</span>
          <span>건물·입주민</span>
          <span style="margin: 0 4px">/</span>
          <span class="bc-current">건물 등록 및 열람</span>
        </div>
        <div class="topbar-actions">
          <button class="topbar-icon-btn" data-tooltip="알림"><span class="material-symbols-rounded">notifications</span><div class="dot"></div></button>
          <button class="topbar-icon-btn" data-tooltip="설정"><span class="material-symbols-rounded">settings</span></button>
        </div>
      </div>

      <div class="main-content">
        <div class="page-header">
          <div>
            <div class="page-title">건물 등록 및 열람</div>
            <div class="page-subtitle">단지·동·호수 단위로 매물 정보와 도면을 등록하고 관리합니다.</div>
          </div>
          <div class="page-header__right">
            <button class="c-btn c-btn--primary" type="button" onclick="openRegisterModal()">
              <span class="material-symbols-rounded">add</span>신규 등록
            </button>
          </div>
        </div>

        <!-- 등록된 건물 목록 -->
        <div class="c-card c-card--divide">
          <div class="c-card__header">
            <div>
              <div class="c-card__title">등록된 건물 목록 <span style="font-weight: 600; color: var(--text-tertiary); font-size: 13px">(총 <span id="total-count">0</span>건)</span></div>
              <div class="c-card__sub">대상명을 검색하거나 유형 필터로 좁혀 볼 수 있습니다.</div>
            </div>
            <div class="c-card__actions">
              <input class="c-input" id="search-input" type="text" placeholder="대상명 검색…" style="width: 200px; height: 36px" />
              <select class="c-select" id="type-filter" style="width: 130px; height: 36px">
                <option value="">전체 유형</option>
                <option>전체 배치도</option>
                <option>동 도면</option>
                <option>세대 평면도</option>
              </select>
              <button class="c-btn c-btn--ghost" type="button" onclick="resetListFilter()">
                <span class="material-symbols-rounded">refresh</span>초기화
              </button>
              <button class="c-btn c-btn--primary" type="button" onclick="applyFilter()">
                <span class="material-symbols-rounded">search</span>조회
              </button>
            </div>
          </div>

            <div class="bulk-bar" id="bulkBar">
              <span><span id="bulkCount">0</span>개 선택됨</span>
              <button class="c-btn c-btn--sm"><span class="material-symbols-rounded">download</span>내보내기</button>
              <button class="c-btn c-btn--sm c-btn--danger"><span class="material-symbols-rounded">delete</span>선택 삭제</button>
            </div>

            <div class="c-table-wrap">
              <table class="c-table" style="table-layout: fixed">
                <thead>
                  <tr>
                    <th style="width: 40px"><input type="checkbox" id="chkAll" /></th>
                    <th>대상명</th>
                    <th style="width: 110px">유형</th>
                    <th style="width: 140px">적용 범위</th>
                    <th style="width: 110px">등록일</th>
                    <th style="width: 90px">상태</th>
                  </tr>
                </thead>
                <tbody id="list-body"></tbody>
              </table>
            </div>

            <div class="c-card__footer" style="flex-direction: column; gap: 8px; align-items: center; justify-content: center">
              <div style="font-size: 13px; color: var(--text-tertiary); text-align: center" id="row-meta"></div>
              <div class="c-pagination" id="pagination"></div>
            </div>
      </div>
    </div>

    <!-- 신규 등록 모달 (목록에서 진입) -->
    <div class="c-modal-overlay is-hidden" id="registerOverlay" onclick="if(event.target===this)closeRegisterModal()">
      <div class="c-modal c-modal--lg" role="dialog" aria-modal="true" aria-labelledby="registerTitle">
        <div class="c-modal__header">
          <div style="display:flex;align-items:center;gap:10px">
            <span class="material-symbols-rounded" style="color:var(--accent)">add_home_work</span>
            <span class="c-modal__title" id="registerTitle">신규 등록</span>
          </div>
          <button class="c-modal__close" onclick="closeRegisterModal()" aria-label="닫기"><span class="material-symbols-rounded">close</span></button>
        </div>
        <div class="c-modal__body">
          <div style="display: grid; grid-template-columns: 1.4fr 1fr; gap: 16px; align-items: start">
            <div class="l-stack">
              <div class="c-card c-card--divide">
                <div class="c-card__header">
                  <div>
                    <div class="c-card__title"><span class="material-symbols-rounded" style="vertical-align: -3px; color: var(--accent)">location_city</span> 단지 및 구조</div>
                    <div class="c-card__sub">등록할 매물의 단지·동·층·호수를 입력해 주세요.</div>
                  </div>
                </div>
                <div class="c-card__body">
                  <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 12px">
                    <div class="c-field">
                      <label class="c-label">단지 <span class="req">*</span></label>
                      <input type="text" class="c-input" id="r-complex" placeholder="예) 한강 푸르지오 1단지" />
                    </div>
                    <div class="c-field">
                      <label class="c-label">동 <span class="req">*</span></label>
                      <input type="text" class="c-input" id="r-dong" placeholder="예) 101동" />
                    </div>
                    <div class="c-field">
                      <label class="c-label">층 <span class="req">*</span></label>
                      <input type="text" class="c-input" id="r-floor" placeholder="예) 12층 / B1층" />
                    </div>
                    <div class="c-field">
                      <label class="c-label">호수 <span class="req">*</span></label>
                      <input type="text" class="c-input" id="r-ho" placeholder="예) 101호" />
                    </div>
                  </div>
                </div>
              </div>

              <div class="c-card c-card--divide">
                <div class="c-card__header">
                  <div>
                    <div class="c-card__title"><span class="material-symbols-rounded" style="vertical-align: -3px; color: var(--accent)">home_pin</span> 매물 기본 정보</div>
                    <div class="c-card__sub">금액은 만원 단위로 입력해 주세요.</div>
                  </div>
                </div>
                <div class="c-card__body">
                  <div style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 12px">
                    <div class="c-field"><label class="c-label">전세가 (만원)</label><input type="number" class="c-input" id="r-jeonse" placeholder="0" min="0" /></div>
                    <div class="c-field"><label class="c-label">월세가 (만원)</label><input type="number" class="c-input" id="r-wolse" placeholder="0" min="0" /></div>
                    <div class="c-field"><label class="c-label">관리비 (만원)</label><input type="number" class="c-input" id="r-fee" placeholder="0" min="0" /></div>
                    <div class="c-field">
                      <label class="c-label">방 개수</label>
                      <select class="c-select" id="r-rooms"><option value="">선택</option><option>1개</option><option>2개</option><option>3개</option><option>4개</option><option>5개 이상</option></select>
                    </div>
                  </div>
                  <div style="margin-top: 14px; padding-top: 14px; border-top: 1px solid var(--border)">
                    <div class="c-field">
                      <label class="c-label">상세 메모</label>
                      <textarea class="c-textarea" id="r-desc" rows="4" placeholder="특이사항, 하자, 옵션, 참고사항 등을 입력하세요."></textarea>
                    </div>
                  </div>
                </div>
              </div>

              <div class="c-card c-card--divide">
                <div class="c-card__header">
                  <div>
                    <div class="c-card__title"><span class="material-symbols-rounded" style="vertical-align: -3px; color: var(--accent)">upload_file</span> 도면 업로드 <span style="font-weight:600;color:var(--text-tertiary);font-size:12px">(선택)</span></div>
                    <div class="c-card__sub">전체 배치도 / 동 도면 / 세대 평면도 중 하나를 선택해 업로드합니다.</div>
                  </div>
                </div>
                <div class="c-card__body">
                  <div class="c-upload-cat-row">
                    <label class="c-upload-cat"><input type="radio" name="floorType" value="all" checked /><span class="material-symbols-rounded">map</span>전체 배치도</label>
                    <label class="c-upload-cat"><input type="radio" name="floorType" value="building" /><span class="material-symbols-rounded">apartment</span>동 도면</label>
                    <label class="c-upload-cat"><input type="radio" name="floorType" value="unit" /><span class="material-symbols-rounded">grid_view</span>세대 평면도</label>
                  </div>
                  <div class="c-drop-zone" id="dropZone" onclick="document.getElementById('fileInput').click()">
                    <input type="file" id="fileInput" accept=".pdf,.png,.jpg,.jpeg,.dwg" multiple />
                    <span class="material-symbols-rounded c-dz__icon">upload_file</span>
                    <div class="c-dz__title">파일을 끌어다 놓거나 클릭하여 업로드</div>
                    <div class="c-dz__sub">PDF · PNG · JPG · DWG 지원 · 최대 20MB</div>
                    <div class="c-dz__preview" id="dzPreview"></div>
                  </div>
                </div>
              </div>
            </div>

            <div class="c-card c-card--divide">
              <div class="c-card__header">
                <div>
                  <div class="c-card__title"><span class="material-symbols-rounded" style="vertical-align: -3px; color: var(--accent)">checklist</span>등록 요약</div>
                  <div class="c-card__sub">필수 항목을 확인하고 저장하세요.</div>
                </div>
              </div>
              <div class="c-card__body">
                <div class="reg-summary-list">
                  <div class="reg-sum-row"><div class="k">대상</div><div class="v" id="sum-target">—</div></div>
                  <div class="reg-sum-row"><div class="k">주소</div><div class="v" id="sum-addr">—</div></div>
                  <div class="reg-sum-row"><div class="k">금액</div><div class="v" id="sum-price">—</div></div>
                  <div class="reg-sum-row"><div class="k">방 개수</div><div class="v" id="sum-rooms">—</div></div>
                  <div class="reg-sum-row"><div class="k">첨부</div><div class="v" id="sum-files">선택된 파일 없음</div></div>
                </div>
                <div class="reg-alert" id="sum-alert">필수 입력이 누락되었습니다. 단지/동/층/호를 확인하세요.</div>
              </div>
            </div>
          </div>
        </div>
        <div class="c-modal__footer">
          <button class="c-btn c-btn--ghost" type="button" onclick="closeRegisterModal()">취소</button>
          <button class="c-btn c-btn--ghost" type="button" onclick="resetRegisterForm()"><span class="material-symbols-rounded">refresh</span>초기화</button>
          <button class="c-btn c-btn--primary" type="button" onclick="submitRegisterForm()"><span class="material-symbols-rounded">save</span>등록</button>
        </div>
      </div>
    </div>

    <!-- 건물 상세 모달 -->
    <div class="c-modal-overlay is-hidden" id="detailOverlay" onclick="if(event.target===this)closeDetail()">
      <div class="c-modal" id="detailModal" role="dialog" aria-labelledby="detailTitle" aria-modal="true">
        <div class="c-modal__header">
          <span id="detailTitle">건물 상세</span>
          <button class="c-btn c-btn--ghost c-btn--sm" onclick="closeDetail()"><span class="material-symbols-rounded">close</span>닫기</button>
        </div>
        <div class="c-modal__body">
          <div class="c-info-grid" id="detailContent"></div>
        </div>
        <div class="c-modal__footer">
          <button class="c-btn c-btn--danger" onclick="closeDetail()">삭제</button>
          <button class="c-btn" onclick="closeDetail()">수정</button>
        </div>
      </div>
    </div>

    <script id="page-script">
      function openDetail(idx) {
        const r = filtered[idx];
        if (!r) return;
        const st = STATUS_MAP[r.status];
        document.getElementById("detailTitle").textContent = r.name;
        document.getElementById("detailContent").innerHTML = [
          ["유형", r.type], ["적용 범위", r.scope],
          ["파일 정보", r.meta], ["등록일", r.date],
          ["상태", '<span class="c-badge ' + st.cls + '">' + st.text + '</span>'],
        ].map(([label, val]) =>
          '<div class="c-info-block"><div class="c-label">' + label + '</div><div class="c-value">' + val + '</div></div>'
        ).join("");
        document.getElementById("detailOverlay").classList.remove("is-hidden");
      }
      function closeDetail() {
        document.getElementById("detailOverlay").classList.add("is-hidden");
      }

      function openRegisterModal() {
        document.getElementById("registerOverlay").classList.remove("is-hidden");
        updateSummary();
        validateRegisterRequired();
      }
      function closeRegisterModal() {
        document.getElementById("registerOverlay").classList.add("is-hidden");
      }

      // 드래그 앤 드롭
      const dropZone = document.getElementById("dropZone");
      const fileInput = document.getElementById("fileInput");
      const dzPreview = document.getElementById("dzPreview");
      // c-drop-zone drag states

      function renderFiles(files) {
        dzPreview.innerHTML = "";
        Array.from(files).forEach(function (f) {
          const chip = document.createElement("div");
          chip.className = "c-dz__chip";
          chip.innerHTML = '<span class="material-symbols-rounded" style="font-size:13px">insert_drive_file</span>' + f.name + '<span class="c-dz__chip__remove material-symbols-rounded">close</span>';
          chip.querySelector(".c-dz__chip__remove").addEventListener("click", function (e) {
            e.stopPropagation();
            chip.remove();
          });
          dzPreview.appendChild(chip);
        });
        updateSummary();
      }
      fileInput.addEventListener("change", function () { renderFiles(fileInput.files); });
      dropZone.addEventListener("dragover", function (e) { e.preventDefault(); dropZone.classList.add("drag-over"); });
      dropZone.addEventListener("dragleave", function () { dropZone.classList.remove("drag-over"); });
      dropZone.addEventListener("drop", function (e) { e.preventDefault(); dropZone.classList.remove("drag-over"); renderFiles(e.dataTransfer.files); });

      // 등록 목록 데이터 (실제로는 서버에서 받아옴)
      const REGISTERED = [
        { name: "한강 푸르지오 1단지 전체 배치도", meta: "PDF · 4.2 MB", type: "전체 배치도", scope: "단지 전체", date: "2026-04-22", status: "active" },
        { name: "한강 푸르지오 1단지 101동 도면", meta: "PNG · 1.8 MB", type: "동 도면", scope: "101동", date: "2026-04-20", status: "active" },
        { name: "마포 래미안 102동 세대 평면도", meta: "PDF · 2.1 MB", type: "세대 평면도", scope: "102동 전 세대", date: "2026-04-18", status: "active" },
        { name: "노원 힐스테이트 전체 배치도", meta: "PDF · 5.6 MB", type: "전체 배치도", scope: "단지 전체", date: "2026-04-15", status: "pending" },
        { name: "송파 파크리오 103동 도면", meta: "JPG · 0.9 MB", type: "동 도면", scope: "103동", date: "2026-04-10", status: "neutral" },
        { name: "마포 래미안 세대 평면도 (84㎡)", meta: "PDF · 1.4 MB", type: "세대 평면도", scope: "전 단지 84㎡", date: "2026-04-08", status: "active" },
        { name: "한강 푸르지오 102동 도면", meta: "PDF · 2.0 MB", type: "동 도면", scope: "102동", date: "2026-04-05", status: "active" },
        { name: "노원 힐스테이트 104동 세대 평면도", meta: "PNG · 1.2 MB", type: "세대 평면도", scope: "104동 전 세대", date: "2026-04-02", status: "active" },
        { name: "송파 파크리오 전체 배치도", meta: "PDF · 6.1 MB", type: "전체 배치도", scope: "단지 전체", date: "2026-03-28", status: "active" },
        { name: "마포 래미안 105동 도면", meta: "JPG · 1.5 MB", type: "동 도면", scope: "105동", date: "2026-03-22", status: "neutral" },
        { name: "한강 푸르지오 세대 평면도 (59㎡)", meta: "PDF · 1.1 MB", type: "세대 평면도", scope: "전 단지 59㎡", date: "2026-03-18", status: "pending" },
        { name: "송파 파크리오 104동 도면", meta: "PDF · 2.3 MB", type: "동 도면", scope: "104동", date: "2026-03-12", status: "active" },
      ];

      const PAGE_SIZE = 10;
      let currentPage = 1;
      let filtered = REGISTERED.slice();

      const STATUS_MAP = {
        active: { cls: "c-badge--active", text: "활성" },
        pending: { cls: "c-badge--pending", text: "검토중" },
        neutral: { cls: "c-badge--neutral", text: "비활성" },
      };
      const TYPE_BG = {
        "전체 배치도": "background: rgba(99, 102, 241, 0.1); color: #6366f1",
        "동 도면": "background: rgba(20, 184, 166, 0.1); color: #0d9488",
        "세대 평면도": "background: rgba(249, 115, 22, 0.1); color: #ea580c",
      };

      function renderList() {
        const tbody = document.getElementById("list-body");
        const start = (currentPage - 1) * PAGE_SIZE;
        const slice = filtered.slice(start, start + PAGE_SIZE);
        if (slice.length === 0) {
          tbody.innerHTML = '<tr><td colspan="6"><div class="c-empty"><span class="material-symbols-rounded">folder_off</span><div class="c-empty__title">등록된 건물이 없습니다</div><div class="c-empty__sub">검색어 또는 유형을 변경해 보세요.</div></div></td></tr>';
        } else {
          tbody.innerHTML = slice.map((r, i) => {
            const st = STATUS_MAP[r.status];
            const idx = start + i;
            return ''
              + '<tr style="cursor:pointer" onclick="openDetail(' + idx + ')">'
              + '<td onclick="event.stopPropagation()"><input type="checkbox" class="row-chk" /></td>'
              + '<td><div style="font-weight:700;overflow:hidden;text-overflow:ellipsis;white-space:nowrap">' + r.name + '</div><div style="font-size:11px;color:var(--text-tertiary);margin-top:2px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap">' + r.meta + '</div></td>'
              + '<td><span class="c-badge" style="' + (TYPE_BG[r.type] || "") + '">' + r.type + '</span></td>'
              + '<td style="overflow:hidden;text-overflow:ellipsis;white-space:nowrap">' + r.scope + '</td>'
              + '<td style="font-variant-numeric:tabular-nums">' + r.date + '</td>'
              + '<td><span class="c-badge ' + st.cls + '">' + st.text + '</span></td>'
              + '</tr>';
          }).join("");
          tbody.querySelectorAll(".row-chk").forEach((c) => c.addEventListener("change", updateBulk));
        }
        document.getElementById("total-count").textContent = filtered.length;
        const lastPage = Math.max(1, Math.ceil(filtered.length / PAGE_SIZE));
        const from = filtered.length === 0 ? 0 : start + 1;
        const to = Math.min(start + PAGE_SIZE, filtered.length);
        document.getElementById("row-meta").textContent = from + " – " + to + " / " + filtered.length + "건";
        renderPagination(lastPage);
        document.getElementById("chkAll").checked = false;
        updateBulk();
      }

      function renderPagination(last) {
        const el = document.getElementById("pagination");
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
            renderList();
          });
        });
      }

      function applyFilter() {
        const kw = document.getElementById("search-input").value.trim().toLowerCase();
        const type = document.getElementById("type-filter").value;
        filtered = REGISTERED.filter((r) => {
          if (kw && !r.name.toLowerCase().includes(kw)) return false;
          if (type && r.type !== type) return false;
          return true;
        });
        currentPage = 1;
        renderList();
      }

      function resetListFilter() {
        document.getElementById("search-input").value = "";
        document.getElementById("type-filter").value = "";
        applyFilter();
      }

      // Enter로 조회 (텍스트 입력에서만)
      document.getElementById("search-input").addEventListener("keydown", (e) => {
        if (e.key === "Enter") applyFilter();
      });

      // 일괄 체크
      const chkAll = document.getElementById("chkAll");
      const bulkBar = document.getElementById("bulkBar");
      const bulkCount = document.getElementById("bulkCount");
      function updateBulk() {
        const checked = document.querySelectorAll(".row-chk:checked");
        if (checked.length > 0) {
          bulkBar.classList.add("is-show");
          bulkCount.textContent = checked.length;
        } else {
          bulkBar.classList.remove("is-show");
        }
      }
      chkAll.addEventListener("change", function () {
        document.querySelectorAll(".row-chk").forEach(function (c) { c.checked = chkAll.checked; });
        updateBulk();
      });

      function fmtMoneyWan(v) {
        if (!v) return null;
        const n = Number(v);
        if (!Number.isFinite(n)) return null;
        return n.toLocaleString() + "만원";
      }

      function updateSummary() {
        const complex = (document.getElementById("r-complex")?.value || "").trim();
        const dong = (document.getElementById("r-dong")?.value || "").trim();
        const floor = (document.getElementById("r-floor")?.value || "").trim();
        const ho = (document.getElementById("r-ho")?.value || "").trim();
        const jeonse = fmtMoneyWan(document.getElementById("r-jeonse")?.value);
        const wolse = fmtMoneyWan(document.getElementById("r-wolse")?.value);
        const fee = fmtMoneyWan(document.getElementById("r-fee")?.value);
        const rooms = (document.getElementById("r-rooms")?.value || "").trim();

        document.getElementById("sum-target").textContent = complex ? complex : "—";
        document.getElementById("sum-addr").textContent = (dong || floor || ho) ? [dong, floor, ho].filter(Boolean).join(" · ") : "—";

        const prices = [];
        if (jeonse) prices.push("전세 " + jeonse);
        if (wolse) prices.push("월세 " + wolse);
        if (fee) prices.push("관리비 " + fee);
        document.getElementById("sum-price").textContent = prices.length ? prices.join(" / ") : "—";

        document.getElementById("sum-rooms").textContent = rooms ? rooms : "—";

        const fileCount = fileInput?.files?.length || 0;
        document.getElementById("sum-files").textContent = fileCount ? ("파일 " + fileCount + "개 선택됨") : "선택된 파일 없음";
      }

      function validateRegisterRequired() {
        const complex = (document.getElementById("r-complex")?.value || "").trim();
        const dong = (document.getElementById("r-dong")?.value || "").trim();
        const floor = (document.getElementById("r-floor")?.value || "").trim();
        const ho = (document.getElementById("r-ho")?.value || "").trim();
        const ok = !!(complex && dong && floor && ho);
        document.getElementById("sum-alert").style.display = ok ? "none" : "block";
        return ok;
      }

      function resetRegisterForm() {
        ["r-complex","r-dong","r-floor","r-ho","r-jeonse","r-wolse","r-fee","r-desc"].forEach((id) => {
          const el = document.getElementById(id);
          if (el) el.value = "";
        });
        const rooms = document.getElementById("r-rooms");
        if (rooms) rooms.selectedIndex = 0;
        if (fileInput) fileInput.value = "";
        if (dzPreview) dzPreview.innerHTML = "";
        updateSummary();
        validateRegisterRequired();
      }

      function submitRegisterForm() {
        updateSummary();
        if (!validateRegisterRequired()) return;
        alert("저장되었습니다.");
      }

      // 요약 자동 갱신
      ["r-complex","r-dong","r-floor","r-ho","r-jeonse","r-wolse","r-fee","r-desc","r-rooms"].forEach((id) => {
        const el = document.getElementById(id);
        if (!el) return;
        el.addEventListener("input", () => { updateSummary(); validateRegisterRequired(); });
        el.addEventListener("change", () => { updateSummary(); validateRegisterRequired(); });
      });

      renderList();
      updateSummary();
    </script>
    <script>
      function toggleSidebar(){var s=document.getElementById("sidebar");if(s)s.classList.toggle("collapsed");}
      var logoIcon=document.getElementById("logoIcon");
      if(logoIcon){logoIcon.onclick=function(){var s=document.getElementById("sidebar");if(s&&s.classList.contains("collapsed"))toggleSidebar();};}
    </script>
  </body>
</html>
