<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<!doctype html>
<html lang="ko">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1.0" />
    <%--csrf--%>
    <meta name="_csrf" content="${_csrf.token}">
    <meta name="_csrf_header" content="${_csrf.headerName}">
    <title>우리집맵핑 · 공고 관리</title>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet" />
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/centralAside.css" />
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/centralHeader.css" />
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/centralCommon.css" />
    <style id="page-style">

      /* ================= 제출 서류 목록 ================= */

      .doc-list {
        display: flex;
        flex-direction: column;
        gap: 8px;
      }

      .doc-item {
        display: flex;
        align-items: center;
        gap: 10px;

        padding: 14px 16px;
        border-radius: 12px;

        background: #f3f4f6;
        border: 1px solid #e5e7eb;

        font-size: 14px;
        font-weight: 700;
        color: var(--text-primary);

        box-shadow: 0 1px 2px rgba(0,0,0,0.03);
      }

      .doc-icon {
        font-size: 18px;
        color: #10b981;
      }

      /* ================= 체크박스 그룹 ================= */

      .cb-group {
        display: flex;
        flex-wrap: wrap;
        gap: 12px;
      }

      .cb-group label {
        display: flex;
        align-items: center;
        gap: 6px;
        font-size: 13px;
        cursor: pointer;
      }

      /* ===================================================== */
      /* 공고 등록 모달 */
      /* ===================================================== */

      .c-modal--notice-form {
        width: 860px;
        max-width: 95vw;

        height: auto;              /* 내용 높이만큼만 창 높이 사용 */
        max-height: 90vh;          /* 화면보다 너무 커지면 최대 90%까지만 */
        display: flex;
        flex-direction: column;    /* header/body/footer 분리 */

        overflow: hidden;          /* 전체 스크롤 제거 */
      }

      /* header */
      .c-modal__header--compact {
        padding: 16px 20px 10px;
        flex-shrink: 0; /* 줄어들지 않게 */
      }

      /* footer */
      .c-modal__footer--compact {
        padding: 8px 20px 10px;
        flex-shrink: 0;
      }

      /* body */
      .c-modal__body--compact {
        padding: 10px 20px;

        flex: 0 0 auto;            /* 남은 공간을 억지로 채우지 않음 */
        overflow: hidden;          /* 스크롤 완전 제거 */

        display: flex;
        flex-direction: column;
        gap: 10px;
      }

      /* ================= 2열 레이아웃 ================= */

      .form-grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 10px 14px;
      }

      /* ================= 필드 압축 ================= */

      .c-modal--notice-form .c-field {
        margin-bottom: 6px;
      }

      .c-modal--notice-form .c-label {
        margin-bottom: 4px;
        font-size: 13px;
      }

      /* input 높이 줄이기 */
      .c-modal--notice-form .c-input,
      .c-modal--notice-form .c-select {
        height: 34px;
        font-size: 13px;
      }

      /* 공고 내용 textarea 높이 증가 */
      .c-modal--notice-form textarea.c-input {
        min-height: 140px;   /* 최소 높이 증가 */
        max-height: 220px;   /* 최대 높이 증가 */
        resize: vertical;    /* 세로 드래그 가능 */
      }

      /* 날짜 */
      .date-row {
        display: flex;
        gap: 6px;
        align-items: center;
      }

      .date-row input {
        flex: 1;
      }

      /* 에러 메시지 최소화 */
      .c-modal--notice-form .err-msg {
        min-height: 12px;
        font-size: 11px;
        margin-top: 2px;
      }

      /*
        공급 세대수 readonly 스타일
      */
      #f-funit[readonly] {
        color: #64748b;          /* 글자색 */
        /*background: #eff6ff;     !* 연파랑 배경 *!*/
        /*border-color: #93c5fd;   !* 테두리 색 *!*/
      }

      #f-fsite {
        color: #475569;   /* 진회색 */
      }

      /*
        날짜 input 글자색
      */
      .date-row .c-input {
        color: #475569;
      }

      /*
        날짜 placeholder 색상
      */
      .date-row .c-input::placeholder {
        color: #475569;
      }


      /* 첨부파일 input 전체 */
      #f-file {
        padding: 0;              /* 기본 안쪽 여백 제거 */
        color: #475569;
      }

      /*
        파일 선택 버튼
      */
      #f-file::file-selector-button {
        margin: 0;               /* 버튼 왼쪽 뜨는 여백 제거 */
        margin-right: 10px;

        border: 1px solid #cbd5e1;
        background: #f8fafc;

        padding: 5px 12px;
        border-radius: 8px;

        color: #334155;
        cursor: pointer;
      }

      /*
        등록 버튼 체크 아이콘 초록색
      */
      #form-submit-btn .material-symbols-rounded {
        color: #16a34a;
      }

      /* ================= 반응형 ================= */

      @media (max-width: 768px) {
        .c-modal--notice-form {
          height: 95vh;
        }

        .form-grid {
          grid-template-columns: 1fr;
        }

        .cb-group--compact {
          grid-template-columns: 1fr 1fr;
        }
      }

      /* ===================================================== */
      /* 공고 상세 모달 */
      /* ===================================================== */
      .c-modal--detail{
        width:760px;
        max-width:92vw;
      }

      .detail-form-grid{
        display:grid;
        grid-template-columns:1fr 1fr;
        gap:22px 14px;
      }

      /*
       상세 모달 라벨 스타일

       c-label이란?
       → input 위에 붙는 제목 글자.
       예: 공고 제목, 공급 세대수, 단지, 상세주소

       왜 수정?
       → 데이터 글자보다 제목을 더 크고 굵게 보여서
         화면 구분이 잘 되게 하기 위해.
     */
      .c-modal--detail .c-label {
        font-size: 13px;
        font-weight: 800;
        color: #334155;
        margin-bottom: 8px;
      }

      /*
        상세 모달 데이터 박스 기본 스타일

        detail-readonly-box란?
        → input처럼 보이지만 수정하지 않는 상세보기 전용 박스.
      */
      .detail-readonly-box {
        min-height: 34px;
        padding: 8px 12px;

        border: 1px solid #e5e7eb;
        border-radius: 8px;
        background: #ffffff;

        font-size: 13px;
        font-weight: 500;
        color: #475569;

        text-align: left;
      }

      /*
        공고 내용 박스

        왜 따로 분리?
        → 공고 내용은 긴 텍스트라서 위쪽/왼쪽부터 보여야 자연스럽다.

        white-space: pre-wrap
        → 줄바꿈을 유지해서 보여주는 속성.
      */
      .detail-readonly-box--content {
        min-height: 120px;
        padding: 14px 12px;

        display: block !important;
        text-align: left !important;

        line-height: 1.7;
        white-space: pre-wrap;

        align-items: flex-start !important;
        justify-content: flex-start !important;
      }

      /*
  제출서류를 한 줄 전체로 보여주는 상세 박스
*/
      .detail-doc-full {
        grid-column: 1 / -1; /* 2열 전체 사용 */
      }

      /*
        제출서류 한 줄 표시
      */
      .detail-doc-box {
        min-height: 34px;
        white-space: nowrap;      /* 줄바꿈 방지 */
        overflow-x: auto;         /* 길면 가로 스크롤 */
        overflow-y: hidden;
      }

      /*
        공고 내용 정렬
      */
      .detail-readonly-box--content {
        min-height: 120px;

        line-height: 1.7;
        white-space: pre-wrap;

        text-align: left;

        display: block;           /* 기존 flex 때문에 글자가 애매하게 가운데 보일 수 있어서 block으로 변경 */
        padding: 14px 12px;
      }

      .detail-full{
        grid-column:1 / -1;
      }

      .detail-status-row{
        display:flex;
        align-items:center;
        height:34px;
      }
      /* 상세 모달 제목 */
      .detail-title-row{
        display:flex;
        align-items:center;
        gap:8px;
      }

      /* ================= 공고 운영 안내 접이식 ================= */

      .announce-guide-toggle {
        border: none;
        background: transparent;
        cursor: pointer;

        display: flex;
        align-items: center;
        gap: 4px;

        font-size: 13px;
        font-weight: 700;
        color: #475569;
      }

      .announce-guide-toggle .material-symbols-rounded {
        font-size: 20px;
        transition: transform 0.2s ease;
      }

      /* 접혔을 때 본문 숨김 */
      .announce-guide-card.is-collapsed .announce-guide-body {
        display: none;
      }

      /* 접혔을 때 아이콘 회전 */
      .announce-guide-card.is-collapsed .announce-guide-toggle .material-symbols-rounded {
        transform: rotate(-90deg);
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
          <a class="nav-item" data-page="대시보드" data-parent="대시보드"><span class="material-symbols-rounded nav-icon">grid_view</span><span class="nav-text">대시보드</span></a>
        </div>
        <div class="section-divider"></div>
        <div class="nav-group">
          <span class="section-label">건물 · 입주민</span>
          <a href="<%= request.getContextPath() %>/centralAdmin/buildSearch" class="nav-item"><span class="material-symbols-rounded nav-icon">manage_search</span><span class="nav-text">매물 통합 검색</span></a>
          <a href="<%= request.getContextPath() %>/centralAdmin/buildRegister" class="nav-item"><span class="material-symbols-rounded nav-icon">apartment</span><span class="nav-text">건물 등록 및 열람</span></a>
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
          <a href="<%= request.getContextPath() %>/centralAdmin/announcement" class="nav-item active"><span class="material-symbols-rounded nav-icon">campaign</span><span class="nav-text">공고 관리</span></a>
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
          <span>민원·소통</span>
          <span style="margin: 0 4px">/</span>
          <span class="bc-current">공고 관리</span>
        </div>
        <div class="topbar-actions">
          <button class="topbar-icon-btn" data-tooltip="알림"><span class="material-symbols-rounded">notifications</span><div class="dot"></div></button>
          <button class="topbar-icon-btn" data-tooltip="설정"><span class="material-symbols-rounded">settings</span></button>
        </div>
      </div>

      <div class="main-content">
        <div class="page-header">
          <div>
            <div class="page-title">공고 관리</div>
            <div class="page-subtitle">입주자 모집·공고를 등록·수정하고 진행 상태를 한눈에 관리합니다.</div>
          </div>
          <div class="page-header__right">
            <button class="c-btn c-btn--primary" onclick="openRegister()"><span class="material-symbols-rounded">add</span>공고 등록</button>
          </div>
        </div>

        <!-- 공고 운영 안내 -->
        <div class="c-card c-card--divide announce-guide-card is-collapsed"
             id="announce-guide-card"
             style="margin-top: 16px; margin-bottom: 16px;">
          <div class="c-card__header">
            <div>
              <div class="c-card__title">공고 운영 안내</div>
              <div class="c-card__sub">입주자 모집 공고 등록 후 진행 절차와 주요 제출 서류를 확인합니다.</div>
            </div>
            <%-- 안내 접기 --%>
            <button type="button" class="announce-guide-toggle" onclick="toggleAnnounceGuide()">
              <span id="announce-guide-toggle-text">접기</span>
              <span class="material-symbols-rounded" id="announce-guide-toggle-icon">expand_more</span>
            </button>
          </div>

          <div class="c-card__body announce-guide-body">
            <!-- 핵심: 높이 맞추기 위한 grid -->
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 24px; align-items: stretch;">

              <!-- ================= 왼쪽 ================= -->
              <div style="display: flex; flex-direction: column; height: 100%;">
                <div style="font-size: 14px; font-weight: 800; margin-bottom: 12px;">
                  입주자 모집 절차
                </div>

                <!-- 핵심: 전체 높이 채우기 -->
                <div style="display: flex; flex-direction: column; gap: 12px; flex: 1;">

                  <div class="c-step-item">
                    <div class="c-step-num">1</div>
                    <div class="c-step-text">
                      <strong>공고 등록</strong>
                      <span>관리자가 모집 공고를 등록하고 신청 기간을 설정합니다.</span>
                    </div>
                  </div>

                  <div class="c-step-item">
                    <div class="c-step-num">2</div>
                    <div class="c-step-text">
                      <strong>신청 접수</strong>
                      <span>신청 기간 내 입주 희망자가 신청서를 제출합니다.</span>
                    </div>
                  </div>

                  <div class="c-step-item">
                    <div class="c-step-num">3</div>
                    <div class="c-step-text">
                      <strong>서류 심사</strong>
                      <span>제출된 서류를 기준으로 자격 요건을 심사합니다.</span>
                    </div>
                  </div>

                  <!-- 마지막 요소를 아래로 밀기 -->
                  <div class="c-step-item">
                    <div class="c-step-num">4</div>
                    <div class="c-step-text">
                      <strong>결과 발표</strong>
                      <span>심사 결과를 공지하고 당첨자에게 개별 통보합니다.</span>
                    </div>
                  </div>

                </div>
              </div>

              <!-- ================= 오른쪽 ================= -->
              <div style="display: flex; flex-direction: column; height: 100%;">
                <div style="font-size: 14px; font-weight: 800; margin-bottom: 6px;">
                  제출 서류 안내
                </div>

                <!-- 안내문 위치 이동 -->
                <div style="font-size: 12px; color: var(--text-tertiary); margin-bottom: 12px;">
                  ※ 모든 서류는 공고일 이후 발급분만 인정됩니다. <br/>
                  ※ 제출 서류는 단지별 공고 조건에 따라 달라질 수 있습니다.
                </div>

                <!-- 전체 높이 채우기 -->
                <div style="display: flex; flex-direction: column; justify-content: space-between; flex: 1;">

                  <div class="doc-item">
                    <span class="material-symbols-rounded doc-icon">check_circle</span>
                    신분증 사본
                  </div>

                  <div class="doc-item">
                    <span class="material-symbols-rounded doc-icon">check_circle</span>
                    주민등록등본
                  </div>

                  <div class="doc-item">
                    <span class="material-symbols-rounded doc-icon">check_circle</span>
                    가족관계증명서
                  </div>

                  <div class="doc-item">
                    <span class="material-symbols-rounded doc-icon">check_circle</span>
                    소득증명서
                  </div>

                  <!-- 마지막 요소 아래 정렬 -->
                  <div class="doc-item">
                    <span class="material-symbols-rounded doc-icon">check_circle</span>
                    근로소득원천징수영수증
                  </div>

                </div>
              </div>

            </div>
          </div>
        </div>

        <!-- 탭1: 목록 -->
        <div id="tab0" class="tab-panel is-active">
          <div class="c-card c-card--divide" style="margin-bottom: 16px">
            <div class="c-card__header">
              <div>
                <div class="c-card__title">검색 조건</div>
                <div class="c-card__sub">조건을 입력하면 공고 목록이 필터링됩니다.</div>
              </div>
              <div class="c-card__actions">
                <button class="c-btn c-btn--ghost" onclick="resetFilter()"><span class="material-symbols-rounded">refresh</span>초기화</button>
                <button class="c-btn c-btn--primary" onclick="doFilter()"><span class="material-symbols-rounded">search</span>검색</button>
              </div>
            </div>
            <div class="c-card__body c-filter-row">
              <div class="c-field" style="flex: 1; min-width: 200px">
                <label class="c-label">공고 제목</label>
                <input type="text" class="c-input" id="f-title" placeholder="제목 검색" />
              </div>
              <div class="c-field" style="min-width: 160px">
                <label class="c-label">단지</label>
                <select class="c-select" id="f-site">
                  <option value="">단지 전체</option>
                </select>
              </div>
              <div class="c-field" style="min-width: 130px">
                <label class="c-label">시작일</label>
                <input type="date" class="c-input" id="f-from" />
              </div>
              <div class="c-field" style="min-width: 130px">
                <label class="c-label">종료일</label>
                <input type="date" class="c-input" id="f-to" />
              </div>
              <div class="c-field" style="min-width: 120px">
                <label class="c-label">상태</label>
                <select class="c-select" id="f-status">
                  <option value="">전체</option>
                  <option>진행중</option>
                  <option>마감</option>
                  <option>예정</option>
                </select>
              </div>
            </div>
          </div>

          <div class="c-card c-card--divide">
            <div class="c-card__header">
              <div>
                <div class="c-card__title">공고 목록</div>
                <div class="c-card__sub">총 <span id="list-count" style="color: var(--accent); font-weight: 800">0</span>건 · 페이지당 10건</div>
              </div>
            </div>
            <div class="c-table-wrap">
              <table class="c-table">
                <thead>
                  <tr>
                    <th style="width: 20%;">공고 제목</th>
                    <th style="width: 170px; text-align: left;">단지</th>
                    <th style="width: 260px; text-align: left;">상세주소</th>
                    <th style="width: 180px;">공고 게시 기간</th>
                    <th style="width: 200px;">모집 기간</th>
                    <th style="width: 100px;">공급 세대수</th>
                    <th style="width: 220px;">제출 서류</th>
                    <th style="width: 120px; text-align: center;">상태</th>
                  </tr>
                </thead>
                <tbody id="list-body"></tbody>
              </table>
            </div>
            <div class="c-card__footer" style="justify-content: center">
              <div class="c-pagination" id="pagination"></div>
            </div>
          </div>

        </div>

        <!-- 공고 등록/수정 모달 -->
        <div class="c-modal-overlay is-hidden" id="form-modal" onclick="closeFormOutside(event)">
          <div class="c-modal c-modal--notice-form">

            <div class="c-modal__header c-modal__header--compact">
              <div>
                <h4 class="c-modal__title" id="form-title">입주자 모집 공고 등록</h4>
                <div class="c-card__sub">
                  필수 항목(<span style="color: var(--red)">*</span>)을 모두 입력해주세요.
                </div>
              </div>

              <button class="c-modal__close" onclick="closeFormModal()" aria-label="닫기">
                <span class="material-symbols-rounded">close</span>
              </button>
            </div>

            <div class="c-modal__body c-modal__body--compact">

              <!-- 1행: 공고 제목 / 공급 세대수 -->
              <div class="form-grid">
                <div class="c-field">
                  <label class="c-label">공고 제목 <span style="color: var(--red)">*</span></label>
                  <input type="text" id="f-ftitle" class="c-input" placeholder="예: 2026년 한강 리버뷰 입주자 모집 공고" />
                  <div class="err-msg" id="e-ftitle"></div>
                </div>

                <div class="c-field">
                  <label class="c-label">공급 세대수 <span style="color: var(--red)">*</span>(단지 선택 시, 자동조회)</label>
                  <div style="display:flex; align-items:center; gap:8px;">
                    <input type="number" id="f-funit" class="c-input" placeholder="공급 세대수 입력" style="flex:1;" />
                    <!-- 전체 세대수 표시 영역 -->
                    <span id="total-unit-text" style="font-size:13px; font-weight:700; color:#475569;">
                      /0세대
                    </span>
                  </div>
                  <div class="err-msg" id="e-funit"></div>
                </div>
              </div>

              <!-- 2행: 단지 선택 / 상세 주소 -->
              <div class="form-grid">
                <div class="c-field">
                  <label class="c-label">단지 <span style="color: var(--red)">*</span></label>
                  <select id="f-fsite" class="c-select">
                    <option value="">단지 선택</option>
                  </select>
                  <div class="err-msg" id="e-fsite"></div>
                </div>

                <div class="c-field">
                  <label class="c-label">상세 주소 <span style="color: var(--red)">*</span>(단지 선택 시, 자동입력)</label>
                  <input type="text" id="f-detail-addr" class="c-input" placeholder="예:서울특별시 강남구 강남대로 105" />
                  <div class="err-msg" id="e-detail-addr"></div>
                </div>
              </div>

              <!-- 3행: 공고 게시 기간 / 모집 기간 -->
              <div class="form-grid">
                <div class="c-field">
                  <label class="c-label">공고 게시 기간 <span style="color: var(--red)">*</span></label>
                  <div class="date-row">
                    <input type="date" id="f-pblanc-start" class="c-input" />
                    <span>~</span>
                    <input type="date" id="f-pblanc-end" class="c-input" />
                  </div>
                </div>

                <div class="c-field">
                  <label class="c-label">모집 기간 <span style="color: var(--red)">*</span></label>
                  <div class="date-row">
                    <input type="date" id="f-fstart" class="c-input" />
                    <span>~</span>
                    <input type="date" id="f-fend" class="c-input" />
                  </div>
                  <div class="err-msg" id="e-fdate"></div>
                </div>
              </div>

              <!-- 4행: 첨부파일 -->
              <div class="form-grid">
                <div class="c-field">
                  <label class="c-label">첨부파일</label>
                  <input type="file" id="f-file" class="c-input" />
                </div>
              </div>

              <div class="c-field">
                <label class="c-label">제출 서류 <span style="color: var(--red)">*</span></label>

                <div class="cb-group">

                  <label><input type="checkbox" name="sbmsnDoc" value="신분증 사본"> 신분증 사본</label>
                  <label><input type="checkbox" name="sbmsnDoc" value="주민등록등본"> 주민등록등본</label>
                  <label><input type="checkbox" name="sbmsnDoc" value="가족관계증명서"> 가족관계증명서</label>
                  <label><input type="checkbox" name="sbmsnDoc" value="소득증명서"> 소득증명서</label>
                  <label><input type="checkbox" name="sbmsnDoc" value="근로소득원천징수영수증"> 근로소득원천징수영수증</label>

                </div>
              </div>

              <!-- 4행: 공고 내용 -->
              <div class="c-field">
                <label class="c-label">공고 내용 <span style="color: var(--red)">*</span></label>
                <textarea id="f-content" class="c-input" rows="3" placeholder="공고 주요 내용을 입력하세요."></textarea>
                <div class="err-msg" id="e-content"></div>
              </div>

            </div> <!-- c-modal__body 닫기 -->

            <div class="c-modal__footer c-modal__footer--compact">
              <button class="c-btn c-btn--ghost" onclick="closeFormModal()">취소</button>
              <button class="c-btn c-btn--primary" id="form-submit-btn" onclick="submitForm()">
                <span class="material-symbols-rounded">check</span>등록
              </button>
            </div>

          </div> <!-- c-modal 닫기 -->
        </div> <!-- form-modal 닫기 -->


    <!-- 상세 모달 -->
    <div class="c-modal-overlay is-hidden" id="detail-modal" onclick="closeOutside(event)">
      <div class="c-modal c-modal--detail">
        <div class="c-modal__header">
          <div class="detail-title-row">
            <h4 class="c-modal__title">공고 상세 정보</h4>
            <div id="detail-status-badge"></div>
          </div>
          <button class="c-modal__close" onclick="closeModal()" aria-label="닫기"><span class="material-symbols-rounded">close</span></button>
        </div>
        <div class="c-modal__body" id="modal-content"></div>
        <div class="c-modal__footer">
          <button class="c-btn c-btn--danger" onclick="deleteFromModal()">삭제</button>
          <button class="c-btn" onclick="editFromModal()">수정</button>
          <button class="c-btn c-btn--ghost" onclick="closeModal()">닫기</button>
        </div>
      </div>
    </div>

  </div> <!-- main-content -->
</div> <!-- main-wrap -->




    <script>
      function toggleSidebar(){var s=document.getElementById("sidebar");if(s)s.classList.toggle("collapsed");}
      var logoIcon=document.getElementById("logoIcon");
      if(logoIcon){logoIcon.onclick=function(){var s=document.getElementById("sidebar");if(s&&s.classList.contains("collapsed"))toggleSidebar();};}
    </script>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <!-- js연결 -->
    <script src="<%= request.getContextPath() %>/js/central/admin/announcement.js"></script>

  </body>
</html>
