<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true"%>
<!doctype html>
<html lang="ko">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>우리집맵핑 · 입주 현황 맵</title>
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
      /* resident.jsp 전용 — 동/호수 맵 */
      .building-map {
        display: flex;
        flex-direction: column;
        gap: 8px;
      }
      .floor-row {
        display: flex;
        align-items: center;
        gap: 12px;
      }
      .floor-label {
        width: 40px;
        font-weight: 800;
        color: var(--text-tertiary);
        font-size: 12px;
        text-align: right;
      }
      .unit-grid {
        display: grid;
        grid-template-columns: repeat(4, 1fr);
        gap: 8px;
        flex: 1;
      }
      .unit-cell {
        padding: 12px;
        text-align: center;
        border-radius: 8px;
        border: 1px solid var(--border);
        cursor: pointer;
        font-size: 13px;
        font-weight: 700;
        transition: transform 0.15s, box-shadow 0.15s;
        display: flex;
        flex-direction: column;
        gap: 3px;
      }
      .unit-cell:hover {
        transform: translateY(-1px);
        box-shadow: var(--shadow-sm);
      }
      .unit-cell .sub {
        font-size: 11px;
        font-weight: 500;
        opacity: 0.85;
      }
      .unit-cell.occupied { background: var(--green-bg); border-color: #a7f3d0; color: var(--green); }
      .unit-cell.vacant { background: var(--red-bg); border-color: #fecaca; color: var(--red); }
      .unit-cell.unreg { background: var(--yellow-bg); border-color: #fde68a; color: var(--yellow); }

      /* map-legend, legend-dot, info-item → centralCommon.css: c-legend, c-legend__dot, c-info-block 제공 */
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
          <a class="nav-item" data-page="대시보드" data-parent="대시보드"><span class="material-symbols-rounded nav-icon">grid_view</span><span class="nav-text">대시보드</span></a>
        </div>
        <div class="section-divider"></div>
        <div class="nav-group">
          <span class="section-label">건물 · 입주민</span>
          <a href="<%= request.getContextPath() %>/centralAdmin/buildSearch" class="nav-item"><span class="material-symbols-rounded nav-icon">manage_search</span><span class="nav-text">매물 통합 검색</span></a>
          <a href="<%= request.getContextPath() %>/centralAdmin/buildRegister" class="nav-item"><span class="material-symbols-rounded nav-icon">apartment</span><span class="nav-text">건물 등록 및 열람</span></a>
          <a href="<%= request.getContextPath() %>/centralAdmin/residentList" class="nav-item active"><span class="material-symbols-rounded nav-icon">groups</span><span class="nav-text">입주민 관리</span></a>
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
          <span class="bc-current">입주 현황 맵</span>
        </div>
        <div class="topbar-actions">
          <button class="topbar-icon-btn" data-tooltip="알림">
            <span class="material-symbols-rounded">notifications</span>
            <div class="dot"></div>
          </button>
          <button class="topbar-icon-btn" data-tooltip="설정"><span class="material-symbols-rounded">settings</span></button>
        </div>
      </div>

      <div class="main-content">
        <div class="page-header">
          <div>
            <div class="page-title">동/호수 입주 현황 맵</div>
            <div class="page-subtitle">단지별 동을 선택해 호수별 입주 상태를 한눈에 확인하고, 호수를 클릭하면 상세 정보가 열립니다.</div>
          </div>
          <div class="page-header__right">
          </div>
        </div>

        <!-- 동/호수 맵 카드 -->
        <div class="c-card c-card--divide">
          <div class="c-card__header">
            <div>
              <div class="c-card__title">호수 현황</div>
              <div class="c-card__sub" id="mapSubtitle">행복아파트 · 101동 (4층)</div>
            </div>
            <div class="c-card__actions">
              <select class="c-select" style="width: 160px">
                <option>행복아파트 · 101동</option>
                <option>행복아파트 · 102동</option>
                <option>희망빌라 · 201동</option>
                <option>미래아파트 · 301동</option>
              </select>
              <div class="c-legend">
                <span class="c-legend__item"><span class="c-legend__dot" style="background: var(--green)"></span>정상</span>
                <span class="c-legend__item"><span class="c-legend__dot" style="background: var(--red)"></span>공실</span>
                <span class="c-legend__item"><span class="c-legend__dot" style="background: var(--yellow)"></span>미등록</span>
              </div>
            </div>
          </div>
          <div class="c-card__body">
            <div class="building-map">
              <div class="floor-row">
                <div class="floor-label">4F</div>
                <div class="unit-grid">
                  <div class="unit-cell occupied" onclick="openDetail('401호 · 이*진')">401호<span class="sub">이*진</span></div>
                  <div class="unit-cell vacant" onclick="openDetail('402호 · 공실')">402호<span class="sub">공실</span></div>
                  <div class="unit-cell occupied" onclick="openDetail('403호 · 박*수')">403호<span class="sub">박*수</span></div>
                  <div class="unit-cell occupied" onclick="openDetail('404호 · 김*수')">404호<span class="sub">김*수</span></div>
                </div>
              </div>
              <div class="floor-row">
                <div class="floor-label">3F</div>
                <div class="unit-grid">
                  <div class="unit-cell occupied" onclick="openDetail('301호 · 최*민')">301호<span class="sub">최*민</span></div>
                  <div class="unit-cell occupied" onclick="openDetail('302호 · 김*영')">302호<span class="sub">김*영</span></div>
                  <div class="unit-cell unreg" onclick="openDetail('303호 · 미등록')">303호<span class="sub">미등록</span></div>
                  <div class="unit-cell occupied" onclick="openDetail('304호 · 한*수')">304호<span class="sub">한*수</span></div>
                </div>
              </div>
              <div class="floor-row">
                <div class="floor-label">2F</div>
                <div class="unit-grid">
                  <div class="unit-cell occupied" onclick="openDetail('201호 · 홍*동')">201호<span class="sub">홍*동</span></div>
                  <div class="unit-cell occupied" onclick="openDetail('202호 · 정*훈')">202호<span class="sub">정*훈</span></div>
                  <div class="unit-cell occupied" onclick="openDetail('203호 · 강*호')">203호<span class="sub">강*호</span></div>
                  <div class="unit-cell vacant" onclick="openDetail('204호 · 공실')">204호<span class="sub">공실</span></div>
                </div>
              </div>
              <div class="floor-row">
                <div class="floor-label">1F</div>
                <div class="unit-grid">
                  <div class="unit-cell occupied" onclick="openDetail('101호 · 신*아')">101호<span class="sub">신*아</span></div>
                  <div class="unit-cell occupied" onclick="openDetail('102호 · 윤*호')">102호<span class="sub">윤*호</span></div>
                  <div class="unit-cell occupied" onclick="openDetail('103호 · 서*경')">103호<span class="sub">서*경</span></div>
                  <div class="unit-cell unreg" onclick="openDetail('104호 · 미등록')">104호<span class="sub">미등록</span></div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 상세 모달 -->
    <div class="c-modal-overlay is-hidden" id="detailModal" onclick="closeOutside(event, 'detailModal')">
      <div class="c-modal c-modal--lg">
        <div class="c-modal__header">
          <h4 class="c-modal__title" id="detailTitle">세대 상세</h4>
          <button class="c-modal__close" onclick="closeModal('detailModal')" aria-label="닫기"><span class="material-symbols-rounded">close</span></button>
        </div>
        <div class="c-modal__body">
          <div class="c-info-grid" style="margin-bottom:18px">
            <div class="c-info-block">
              <div class="c-info-field__label">세대 구분 / 이름</div>
              <div class="c-info-field__val">세대주 / 홍길동 (남)</div>
            </div>
            <div class="c-info-block">
              <div class="c-info-field__label">연락처</div>
              <div class="c-info-field__val">010-1234-5678</div>
            </div>
            <div class="c-info-block">
              <div class="c-info-field__label">계약 유형 / 입주일</div>
              <div class="c-info-field__val">전세 / 2024-01-15</div>
            </div>
            <div class="c-info-block">
              <div class="c-info-field__label">계약 만료일</div>
              <div class="c-info-field__val">2026-01-14</div>
            </div>
            <div class="c-info-block">
              <div class="c-info-field__label">관리비 납부 상태</div>
              <div class="c-info-field__val" style="color: var(--green)">정상 (완납)</div>
            </div>
            <div class="c-info-block">
              <div class="c-info-field__label">보유 차량</div>
              <div class="c-info-field__val">12가 3456 (1대)</div>
            </div>
          </div>
          <div style="font-size: 12px; font-weight: 700; color: var(--text-tertiary); letter-spacing: 0.04em; text-transform: uppercase; padding-bottom: 8px; border-bottom: 1px solid var(--border); margin-bottom: 10px">세대 처리 이력</div>
          <table class="c-table" style="font-size: 12px">
            <thead>
              <tr><th>처리 일자</th><th>처리 상태</th><th>담당자</th></tr>
            </thead>
            <tbody>
              <tr><td>2024-01-15</td><td><strong>입주민 등록</strong> · 신규 계약 입주</td><td>최관리 (행정)</td></tr>
              <tr><td>2023-12-20</td><td><strong>공실 전환</strong> · 이전 세대 퇴거 완료</td><td>김소장 (관리소장)</td></tr>
            </tbody>
          </table>
        </div>
        <div class="c-modal__footer">
          <button class="c-btn c-btn--ghost" onclick="closeModal('detailModal')">닫기</button>
          <button class="c-btn c-btn--primary"><span class="material-symbols-rounded">edit</span>정보 수정</button>
        </div>
      </div>
    </div>

    <script>
      function openDetail(label) {
        document.getElementById("detailTitle").textContent = label + " · 상세";
        document.getElementById("detailModal").classList.remove("is-hidden");
      }
      function closeModal(id) { document.getElementById(id).classList.add("is-hidden"); }
      function closeOutside(e, id) { if (e.target === document.getElementById(id)) closeModal(id); }
    </script>
    <script>
      function toggleSidebar(){var s=document.getElementById("sidebar");if(s)s.classList.toggle("collapsed");}
      var logoIcon=document.getElementById("logoIcon");
      if(logoIcon){logoIcon.onclick=function(){var s=document.getElementById("sidebar");if(s&&s.classList.contains("collapsed"))toggleSidebar();};}
    </script>
  </body>
</html>
