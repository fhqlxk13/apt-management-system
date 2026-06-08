<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>관리사무소</title>
  <sec:csrfMetaTags/>
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
  <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/office-layout.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/manager-common.css">

  <style>
    /* ═══════════════════════════════════════════
       공용시설 관리
       색상 기준: #2e5c38 (mngr_account 기준)
    ═══════════════════════════════════════════ */
    #publicFacilityPage {
      --accent:       #2e5c38;
      --accent-hover: #1f4027;
      --accent-light: #e8f0ea;
      --accent-dim:   rgba(46,92,56,.08);
      --surface:      #ffffff;
      --surface-sub:  #f8f9fb;
      --line:         #d7dce2;
      --th-bg:        #f3f5f3;
      --text-pri:     #1a1f1b;
      --text-sec:     #4a5c4e;
      --text-ter:     #8a9a8e;
    }

    /* ── 필터 (mngr_account 패턴) ── */
    #publicFacilityPage .filter-card    { justify-content: space-between; }
    #publicFacilityPage .filter-left,
    #publicFacilityPage .filter-right   { display:flex; gap:8px; align-items:center; flex-wrap:wrap; }
    #publicFacilityPage .filter-right   { margin-left:auto; }
    #publicFacilityPage .filter-select  { width:130px; }
    #publicFacilityPage .filter-keyword { width:240px; }
    #publicFacilityPage .panel-total    { margin-left:8px; font-size:12px; font-weight:800; color:#2e5c38; }
    #publicFacilityPage .list-count-text{ font-size:12px; color:var(--text-sec); white-space:nowrap; }

    /* ── summary-strip ── */
    #publicFacilityPage .summary-strip  { display:flex; align-items:center; justify-content:space-between; padding:10px 16px; background:var(--surface-sub); border-bottom:1px solid var(--line); }
    #publicFacilityPage .summary-chips  { display:flex; gap:6px; flex-wrap:wrap; }
    #publicFacilityPage .summary-chip   { padding:3px 10px; border-radius:20px; border:1px solid var(--line); font-size:12px; color:var(--text-sec); background:var(--surface); }
    #publicFacilityPage .summary-chip strong { color:var(--accent); font-weight:800; margin-left:4px; }
    #publicFacilityPage .summary-note   { font-size:11px; color:var(--text-ter); }

    /* ── grid-summary ── */
    #publicFacilityPage .grid-summary       { display:flex; align-items:center; justify-content:space-between; padding:8px 16px; border-bottom:1px solid var(--line); }
    #publicFacilityPage .grid-summary-left  { display:flex; align-items:center; gap:8px; font-size:12px; color:var(--text-sec); }
    #publicFacilityPage .grid-summary-left strong { font-size:13px; color:var(--text-pri); font-weight:700; }

    /* ── 테이블 ── */
    #publicFacilityPage .table-wrap { padding:0; overflow-x:auto; }
    #publicFacilityPage .tbl        { font-size:12px; }
    #publicFacilityPage thead th    { padding:9px 14px; background:var(--th-bg); border-bottom:1px solid var(--line); color:var(--text-sec); font-size:11px; font-weight:700; white-space:nowrap; }
    #publicFacilityPage thead th small { display:block; font-weight:400; color:var(--text-ter); font-size:10px; margin-top:1px; font-family:'SF Mono','Consolas',monospace; }
    #publicFacilityPage tbody td    { padding:10px 14px; border-bottom:1px solid var(--line); color:#374151; vertical-align:middle; }
    #publicFacilityPage tbody tr:last-child td { border-bottom:none; }
    #publicFacilityPage tbody tr:hover td { background:#f0f7f2; }
    #publicFacilityPage .td-bold    { font-weight:600; color:var(--text-pri); }
    #publicFacilityPage .td-mono    { font-family:'SF Mono','Consolas',monospace; font-size:11px; color:var(--text-ter); }
    #publicFacilityPage .td-sub     { font-size:11px; color:var(--text-ter); }
    #publicFacilityPage .empty-row  { text-align:center !important; color:var(--text-ter); padding:48px !important; font-size:13px; }

    /* ── 배지 ── */
    #publicFacilityPage .badge        { padding:2px 8px; border-radius:4px; font-size:11px; font-weight:700; }
    #publicFacilityPage .badge-green  { background:#e8f0ea; color:#1f4027; border:1px solid #b7d4bb; }
    #publicFacilityPage .badge-yellow { background:#fef3c7; color:#713f12; border:1px solid #fde68a; }
    #publicFacilityPage .badge-red    { background:#fee2e2; color:#7f1d1d; border:1px solid #fca5a5; }
    #publicFacilityPage .badge-gray   { background:#f1f3f1; color:#4a5c4e; border:1px solid var(--line); }
    #publicFacilityPage .badge-blue   { background:#dbeafe; color:#1e3a5f; border:1px solid #93c5fd; }
    #publicFacilityPage .badge-orange { background:#ffedd5; color:#7c2d12; border:1px solid #fdba74; }

    /* ── 버튼 ── */
    #publicFacilityPage .btn-primary  { background:var(--accent); border-color:var(--accent); }
    #publicFacilityPage .btn-primary:hover { background:var(--accent-hover); border-color:var(--accent-hover); }
    #publicFacilityPage .col-center   { text-align:center !important; }
    #publicFacilityPage .col-right    { text-align:right  !important; }
    #publicFacilityPage .col-manage   { text-align:center !important; width:100px; }
    #publicFacilityPage .grid-actions { display:inline-flex; gap:5px; }

    /* ── wide 모달 ── */
    .modal-wide {
      width: min(900px, 96vw) !important;
      max-width: 900px !important;
    }
    .modal-wide .modal-body {
      max-height: 76vh;
      overflow-y: auto;
    }

    /* ── 모달 2컬럼 레이아웃 ── */
    .modal-cols {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 0;
    }
    .modal-col-left {
      padding-right: 20px;
      border-right: 1px solid var(--line, #d7dce2);
    }
    .modal-col-right {
      padding-left: 20px;
    }

    /* ── readonly 모드 ── */
    #publicFacilityPage .readonly-mode input.form-input,
    #publicFacilityPage .readonly-mode select.form-select,
    #publicFacilityPage .readonly-mode textarea.form-textarea {
      background:#f8f9fb; color:#555; -webkit-text-fill-color:#555;
      border-color:#d7dce2; opacity:1; font-weight:400; cursor:default;
    }
    #publicFacilityPage .readonly-mode input.form-input:disabled,
    #publicFacilityPage .readonly-mode select.form-select:disabled,
    #publicFacilityPage .readonly-mode textarea.form-textarea:disabled {
      color:#555; -webkit-text-fill-color:#555; opacity:1;
    }
    #publicFacilityPage .readonly-mode textarea { resize:none; }

    /* ── form-section-title ── */
    .form-section-title {
      display:flex; align-items:center; gap:5px;
      font-size:12px; font-weight:800; color:var(--text-sec,#4a5c4e);
      letter-spacing:0; text-transform:none; margin-bottom:10px;
    }
    .form-section-title .material-symbols-rounded { font-size:16px; }

    /* ── 사진 그리드 ── */
    #publicFacilityPage .img-grid {
      display:grid; grid-template-columns:1fr 1fr; gap:8px; margin-top:4px;
    }
    #publicFacilityPage .img-cell {
      aspect-ratio:4/3; border-radius:6px; overflow:hidden;
      border:1px solid var(--line); background:var(--surface-sub);
      display:flex; align-items:center; justify-content:center;
      cursor:pointer; position:relative; transition:.12s;
    }
    #publicFacilityPage .img-cell:hover { border-color:var(--accent); }
    #publicFacilityPage .img-cell img   { width:100%; height:100%; object-fit:cover; }
    #publicFacilityPage .img-placeholder { display:flex; flex-direction:column; align-items:center; gap:4px; color:var(--text-ter); font-size:11px; }
    #publicFacilityPage .img-placeholder .material-symbols-rounded { font-size:22px; }
    #publicFacilityPage .img-del {
      position:absolute; top:4px; right:4px;
      width:22px; height:22px; border-radius:50%;
      background:rgba(0,0,0,.5); color:#fff;
      display:none; align-items:center; justify-content:center;
      cursor:pointer; font-size:13px;
    }
    #publicFacilityPage .img-cell:hover .img-del { display:flex; }

    /* ── 자원 테이블 ── */
    #publicFacilityPage .item-tbl { width:100%; border-collapse:collapse; font-size:12px; margin-top:4px; }
    #publicFacilityPage .item-tbl thead th {
      padding:7px 10px; background:var(--th-bg); border:1px solid var(--line);
      color:var(--text-sec); font-size:11px; font-weight:700; text-align:left;
    }
    #publicFacilityPage .item-tbl tbody td {
      padding:7px 10px; border:1px solid var(--line); vertical-align:middle;
    }
    #publicFacilityPage .item-tbl tbody tr:hover td { background:#f0f7f2; }
    #publicFacilityPage .item-tbl input.form-input  { height:28px; font-size:12px; padding:0 8px; }
    #publicFacilityPage .item-tbl select.form-select{ height:28px; font-size:12px; padding:0 8px; }
    #publicFacilityPage .item-add-row {
      display:flex; align-items:center; gap:8px; margin-top:6px;
    }
    #publicFacilityPage .item-add-row input  { flex:1; height:30px; font-size:12px; }
    #publicFacilityPage .item-add-row select { width:120px; height:30px; font-size:12px; }
    #publicFacilityPage .item-empty { padding:14px; text-align:center; font-size:12px; color:var(--text-ter); border:1px solid var(--line); border-radius:4px; }

    /* ── 예약이력 블록 ── */
    #publicFacilityPage .rsvt-block { border:1px solid var(--line); border-radius:6px; overflow:hidden; margin-top:4px; }
    #publicFacilityPage .rsvt-block-hd {
      display:flex; align-items:center; justify-content:space-between;
      padding:7px 12px; background:var(--th-bg); border-bottom:1px solid var(--line);
      font-size:11px; font-weight:800; color:var(--text-sec);
    }
    #publicFacilityPage .rsvt-block-hd a { font-size:11px; font-weight:600; color:var(--accent); text-decoration:none; }
    #publicFacilityPage .rsvt-block-hd a:hover { text-decoration:underline; }
    #publicFacilityPage .rsvt-row {
      display:flex; align-items:center; gap:10px;
      padding:8px 12px; border-bottom:1px solid var(--line); font-size:12px;
    }
    #publicFacilityPage .rsvt-row:last-child { border-bottom:none; }
    #publicFacilityPage .rsvt-row:hover { background:#f0f7f2; }
    #publicFacilityPage .rsvt-no  { font-family:monospace; font-size:11px; color:var(--text-ter); min-width:65px; }
    #publicFacilityPage .rsvt-nm  { flex:1; font-weight:600; color:var(--text-pri); }
    #publicFacilityPage .rsvt-dt  { font-size:11px; color:var(--text-ter); font-family:monospace; white-space:nowrap; }
    #publicFacilityPage .rsvt-empty { padding:16px; text-align:center; font-size:12px; color:var(--text-ter); }

    /* ── 삭제 경고 ── */
    #publicFacilityPage .del-warn {
      display:flex; gap:10px; padding:11px 13px;
      background:#fff5f5; border-left:3px solid #ef4444;
      border:1px solid #fecaca; border-left-width:3px;
      border-radius:0 4px 4px 0; margin-bottom:14px;
      font-size:12px; color:#7f1d1d; line-height:1.6;
    }
    #publicFacilityPage .del-warn .material-symbols-rounded { color:#dc2626; font-size:16px; flex-shrink:0; margin-top:2px; }

    /* ── 구분선 라벨 ── */
    #publicFacilityPage .col-label {
      font-size:11px; font-weight:800; color:var(--text-ter);
      letter-spacing:.5px; text-transform:uppercase;
      padding-bottom:8px; border-bottom:1px solid var(--line);
      margin-bottom:14px;
    }
  </style>

  <script src="${pageContext.request.contextPath}/js/manager/manager-common.js"></script>
</head>

<body>
<div class="app-wrapper">
  <%@ include file="/WEB-INF/views/include/office_sidebar.jsp" %>
  <div class="main-wrap">
    <%@ include file="/WEB-INF/views/include/office_header.jsp" %>
    <main class="main-content">
      <div class="office-page" id="publicFacilityPage">

        <!-- 페이지 헤더 -->
        <div class="page-header">
          <div class="page-title-block">
            <h2>공용시설 관리</h2>
            <p>단지 내 편의시설 정보·사진·자원·예약이력을 관리합니다.</p>
          </div>
          <div class="page-actions">
            <button type="button" class="btn btn-primary" data-action="openRegister">
              <span class="material-symbols-rounded">add</span>공용시설 등록
            </button>
          </div>
        </div>

        <!-- ══ 목록 패널 ══ -->
        <div class="panel">
          <div class="panel-header">
            <div class="panel-title">
              <span class="material-symbols-rounded">meeting_room</span>공용시설 목록
              <span class="panel-total" id="facilityTotalCount">0건</span>
            </div>
          </div>

          <div class="summary-strip">
            <div class="summary-chips">
              <span class="summary-chip">전체 <strong id="chipTotal">0</strong></span>
              <span class="summary-chip">예약가능 <strong id="chipRsv">0</strong></span>
              <span class="summary-chip">사용중지 <strong id="chipClose">0</strong></span>
            </div>
            <span class="summary-note">시설 상태와 검색어로 공용시설을 조회할 수 있습니다.</span>
          </div>

          <div class="filter-card">
            <div class="filter-left">
              <%--
                  CMN_FACILITY_STTS_CD (공통코드 PUBLIC_FACILITY_STTS)
                  OPEN 사용가능 / USE 사용중 / REPAIR 점검중 / CLOSE 사용중지
              --%>
              <select class="form-select filter-select" id="filterStts">
                <option value="">전체 상태</option>
                <option value="OPEN">사용가능</option>
                <option value="USE">사용중</option>
                <option value="REPAIR">점검중</option>
                <option value="CLOSE">사용중지</option>
              </select>
              <select class="form-select" style="width:110px;" id="filterRsvYn">
                <option value="">예약여부 전체</option>
                <option value="Y">예약 가능</option>
                <option value="N">예약 불가</option>
              </select>
            </div>
            <div class="filter-right">
              <div class="search-wrap filter-keyword">
                <span class="material-symbols-rounded">search</span>
                <input type="text" class="form-input" id="filterKeyword" placeholder="시설명 검색">
              </div>
              <button type="button" class="btn btn-primary"   data-action="searchFacility">검색</button>
              <button type="button" class="btn btn-secondary" data-action="resetFacility">초기화</button>
            </div>
          </div>

          <div class="grid-summary">
            <div class="grid-summary-left">
              <strong>공용시설 현황</strong>
              <span>FACILITY + PUBLIC_FACILITY 기준으로 표시합니다.</span>
            </div>
            <div class="grid-summary-right">
              <span class="list-count-text" id="statusCountText">전체 0건</span>
            </div>
          </div>

          <div class="table-wrap">
            <table class="tbl">
              <thead>
              <tr>
                <th>시설번호<small>CMN_FACILITY_NO</small></th>
                <th>시설명<small>CMN_FACILITY_NM</small></th>
                <th class="col-center">동<small>DONG_NO</small></th>
                <th>상세위치<small>LOC_CN</small></th>
                <th class="col-center">예약<small>RSV_YN</small></th>
                <th class="col-right">이용요금<small>CMN_FACILITY_AMT</small></th>
                <th>운영시간<small>CMN_FACILITY_OPR_HR</small></th>
                <th class="col-center">자원수<small>PUBLIC_ITEM</small></th>
                <th class="col-center">상태<small>CMN_FACILITY_STTS_CD</small></th>
                <th class="col-manage">관리</th>
              </tr>
              </thead>
              <tbody id="facilityTbody"></tbody>
            </table>
          </div>
        </div>

        <!-- ══════════════════════════════════════
             모달 1: 등록 (wide 2컬럼)
             좌: FACILITY 기본정보 + PUBLIC_FACILITY 정보
             우: 사진
             저장 흐름: FACILITY INSERT → PUBLIC_FACILITY INSERT
        ══════════════════════════════════════ -->
        <div class="modal-overlay" id="registerModal">
          <div class="modal modal-wide">
            <div class="modal-header">
              <h3 class="modal-title">공용시설 등록</h3>
              <button type="button" class="modal-close" data-action="closeRegisterModal">
                <span class="material-symbols-rounded">close</span>
              </button>
            </div>
            <form id="registerForm">
              <input type="hidden" id="regFacilityNo">
              <div class="modal-body">
                <div class="modal-cols">

                  <!-- 좌: 시설 정보 -->
                  <div class="modal-col-left">
                    <div class="col-label">시설 정보</div>

                    <!-- FACILITY -->
                    <div class="form-section">
                      <div class="form-section-title">
                        <span class="material-symbols-rounded">apartment</span>
                        시설자산 · FACILITY
                      </div>
                      <div class="form-row cols-2">
                        <div class="form-field">
                          <label class="field-label">시설명 <span class="req">*</span>
                            <small style="font-weight:400;color:var(--text-ter);font-family:monospace;">FACILITY_NM</small>
                          </label>
                          <input type="text" class="form-input" id="regFacilityNm" placeholder="예) 헬스장" required>
                        </div>
                        <div class="form-field">
                          <label class="field-label">동
                            <small style="font-weight:400;color:var(--text-ter);font-family:monospace;">DONG_NO</small>
                          </label>
                          <select class="form-select" id="regDongNo">
                            <option value="">선택 안 함</option>
                            <option value="101">101동</option>
                            <option value="102">102동</option>
                            <option value="103">103동</option>
                            <option value="공용">공용</option>
                          </select>
                        </div>
                      </div>
                      <div class="form-row cols-1">
                        <div class="form-field">
                          <label class="field-label">상세위치
                            <small style="font-weight:400;color:var(--text-ter);font-family:monospace;">LOC_CN</small>
                          </label>
                          <input type="text" class="form-input" id="regLocCn" placeholder="예) 커뮤니티센터 2층">
                        </div>
                      </div>
                    </div>

                    <!-- PUBLIC_FACILITY -->
                    <div class="form-section">
                      <div class="form-section-title">
                        <span class="material-symbols-rounded">meeting_room</span>
                        공용시설 정보 · PUBLIC_FACILITY
                      </div>
                      <div class="form-row cols-2">
                        <div class="form-field">
                          <label class="field-label">공용시설명 <span class="req">*</span>
                            <small style="font-weight:400;color:var(--text-ter);font-family:monospace;">CMN_FACILITY_NM</small>
                          </label>
                          <input type="text" class="form-input" id="regCmnNm" placeholder="예) 헬스장" required>
                        </div>
                        <div class="form-field">
                          <label class="field-label">시설 상태
                            <small style="font-weight:400;color:var(--text-ter);font-family:monospace;">CMN_FACILITY_STTS_CD</small>
                          </label>
                          <%-- 공통코드 PUBLIC_FACILITY_STTS --%>
                          <select class="form-select" id="regStts">
                            <option value="OPEN">OPEN · 사용가능</option>
                            <option value="USE">USE · 사용중</option>
                            <option value="REPAIR">REPAIR · 점검중</option>
                            <option value="CLOSE">CLOSE · 사용중지</option>
                          </select>
                        </div>
                      </div>
                      <div class="form-row cols-2">
                        <div class="form-field">
                          <label class="field-label">예약 가능 여부
                            <small style="font-weight:400;color:var(--text-ter);font-family:monospace;">CMN_FACILITY_RSV_YN</small>
                          </label>
                          <select class="form-select" id="regRsvYn">
                            <option value="Y">Y · 예약 가능</option>
                            <option value="N">N · 예약 불가</option>
                          </select>
                        </div>
                        <div class="form-field">
                          <label class="field-label">이용요금 (원)
                            <small style="font-weight:400;color:var(--text-ter);font-family:monospace;">CMN_FACILITY_AMT</small>
                          </label>
                          <input type="number" class="form-input" id="regAmt" placeholder="0 (무료)" min="0">
                        </div>
                      </div>
                      <div class="form-row cols-1">
                        <div class="form-field">
                          <label class="field-label">운영시간
                            <small style="font-weight:400;color:var(--text-ter);font-family:monospace;">CMN_FACILITY_OPR_HR</small>
                          </label>
                          <input type="text" class="form-input" id="regOprHr" placeholder="예) 06:00~22:00 (평일) / 08:00~20:00 (주말)">
                        </div>
                      </div>
                      <div class="form-row cols-1">
                        <div class="form-field">
                          <label class="field-label">시설 안내
                            <small style="font-weight:400;color:var(--text-ter);font-family:monospace;">CMN_FACILITY_CN</small>
                          </label>
                          <textarea class="form-textarea" id="regCn" rows="3" placeholder="시설 이용 안내사항을 입력하세요."></textarea>
                        </div>
                      </div>
                    </div>
                  </div>

                  <!-- 우: 사진 -->
                  <div class="modal-col-right">
                    <div class="col-label">시설 사진</div>
                    <div class="form-section">
                      <div class="form-section-title">
                        <span class="material-symbols-rounded">photo_library</span>
                        사진 등록
                        <small style="font-weight:400;color:var(--text-ter);font-size:11px;">최대 4장 · JPG, PNG</small>
                      </div>
                      <div class="img-grid" id="regImgGrid">
                        <div class="img-cell" data-slot="0" data-action="clickImgSlot">
                          <div class="img-placeholder"><span class="material-symbols-rounded">add_photo_alternate</span>사진 추가</div>
                        </div>
                        <div class="img-cell" data-slot="1" data-action="clickImgSlot">
                          <div class="img-placeholder"><span class="material-symbols-rounded">add_photo_alternate</span>사진 추가</div>
                        </div>
                        <div class="img-cell" data-slot="2" data-action="clickImgSlot">
                          <div class="img-placeholder"><span class="material-symbols-rounded">add_photo_alternate</span>사진 추가</div>
                        </div>
                        <div class="img-cell" data-slot="3" data-action="clickImgSlot">
                          <div class="img-placeholder"><span class="material-symbols-rounded">add_photo_alternate</span>사진 추가</div>
                        </div>
                      </div>
                      <input type="file" id="regImgInput" accept="image/*" multiple style="display:none;">
                      <p style="margin-top:8px;font-size:11px;color:var(--text-ter);">클릭하여 사진을 추가하거나 끌어다 놓으세요.</p>
                    </div>
                  </div>

                </div><!-- /modal-cols -->
              </div>
              <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-action="closeRegisterModal">취소</button>
                <button type="submit" class="btn btn-primary">저장</button>
              </div>
            </form>
          </div>
        </div>

        <!-- ══════════════════════════════════════
             모달 2: 수정 (wide 2컬럼)
             좌: 시설정보 수정
             우: 사진 + 자원 관리 (PUBLIC_ITEM)
             자원: ITEM_NM + CMN_FACILITY_STTS_CD 테이블로 표현
        ══════════════════════════════════════ -->
        <div class="modal-overlay" id="editModal">
          <div class="modal modal-wide">
            <div class="modal-header">
              <h3 class="modal-title" id="editModalTitle">공용시설 수정</h3>
              <button type="button" class="modal-close" data-action="closeEditModal">
                <span class="material-symbols-rounded">close</span>
              </button>
            </div>
            <form id="editForm">
              <input type="hidden" id="editCmnFacilityNo">
              <input type="hidden" id="editFacilityNo">
              <div class="modal-body">
                <div class="modal-cols">

                  <!-- 좌: 시설 정보 수정 -->
                  <div class="modal-col-left">
                    <div class="col-label">시설 정보 수정</div>
                    <div class="form-section">
                      <div class="form-section-title">
                        <span class="material-symbols-rounded">meeting_room</span>
                        공용시설 정보 · PUBLIC_FACILITY
                      </div>
                      <div class="form-row cols-2">
                        <div class="form-field">
                          <label class="field-label">공용시설명 <span class="req">*</span></label>
                          <input type="text" class="form-input" id="editCmnNm" required>
                        </div>
                        <div class="form-field">
                          <label class="field-label">시설 상태
                            <small style="font-weight:400;color:var(--text-ter);font-family:monospace;">CMN_FACILITY_STTS_CD</small>
                          </label>
                          <select class="form-select" id="editStts">
                            <option value="OPEN">OPEN · 사용가능</option>
                            <option value="USE">USE · 사용중</option>
                            <option value="REPAIR">REPAIR · 점검중</option>
                            <option value="CLOSE">CLOSE · 사용중지</option>
                          </select>
                        </div>
                      </div>
                      <div class="form-row cols-2">
                        <div class="form-field">
                          <label class="field-label">예약 가능 여부</label>
                          <select class="form-select" id="editRsvYn">
                            <option value="Y">Y · 예약 가능</option>
                            <option value="N">N · 예약 불가</option>
                          </select>
                        </div>
                        <div class="form-field">
                          <label class="field-label">이용요금 (원)</label>
                          <input type="number" class="form-input" id="editAmt" min="0">
                        </div>
                      </div>
                      <div class="form-row cols-1">
                        <div class="form-field">
                          <label class="field-label">운영시간</label>
                          <input type="text" class="form-input" id="editOprHr">
                        </div>
                      </div>
                      <div class="form-row cols-1">
                        <div class="form-field">
                          <label class="field-label">시설 안내</label>
                          <textarea class="form-textarea" id="editCn" rows="3"></textarea>
                        </div>
                      </div>
                      <div class="form-row cols-2">
                        <div class="form-field">
                          <label class="field-label">동
                            <small style="font-weight:400;color:var(--text-ter);font-family:monospace;">DONG_NO</small>
                          </label>
                          <select class="form-select" id="editDongNo">
                            <option value="">선택 안 함</option>
                            <option value="101">101동</option>
                            <option value="102">102동</option>
                            <option value="103">103동</option>
                            <option value="공용">공용</option>
                          </select>
                        </div>
                        <div class="form-field">
                          <label class="field-label">상세위치
                            <small style="font-weight:400;color:var(--text-ter);font-family:monospace;">LOC_CN</small>
                          </label>
                          <input type="text" class="form-input" id="editLocCn">
                        </div>
                      </div>
                    </div>
                  </div>

                  <!-- 우: 사진 + 자원 -->
                  <div class="modal-col-right">
                    <div class="col-label">사진 &amp; 자원 관리</div>

                    <!-- 사진 -->
                    <div class="form-section">
                      <div class="form-section-title">
                        <span class="material-symbols-rounded">photo_library</span>
                        시설 사진
                        <small style="font-weight:400;color:var(--text-ter);font-size:11px;">최대 4장</small>
                      </div>
                      <div class="img-grid" id="editImgGrid">
                        <div class="img-cell" data-slot="0" data-action="clickEditImgSlot"><div class="img-placeholder"><span class="material-symbols-rounded">add_photo_alternate</span>사진 추가</div></div>
                        <div class="img-cell" data-slot="1" data-action="clickEditImgSlot"><div class="img-placeholder"><span class="material-symbols-rounded">add_photo_alternate</span>사진 추가</div></div>
                        <div class="img-cell" data-slot="2" data-action="clickEditImgSlot"><div class="img-placeholder"><span class="material-symbols-rounded">add_photo_alternate</span>사진 추가</div></div>
                        <div class="img-cell" data-slot="3" data-action="clickEditImgSlot"><div class="img-placeholder"><span class="material-symbols-rounded">add_photo_alternate</span>사진 추가</div></div>
                      </div>
                      <input type="file" id="editImgInput" accept="image/*" multiple style="display:none;">
                    </div>

                    <!-- 자원 관리 (PUBLIC_ITEM) -->
                    <div class="form-section">
                      <div class="form-section-title">
                        <span class="material-symbols-rounded">inventory_2</span>
                        시설 자원 · PUBLIC_ITEM
                        <small style="font-weight:400;color:var(--text-ter);font-size:11px;">예약 단위 자원</small>
                      </div>
                      <%--
                          PUBLIC_ITEM
                          CMN_FACILITY_ITEM_NO  PK
                          CMN_FACILITY_NO       FK
                          ITEM_NM               자원명
                          CMN_FACILITY_STTS_CD  상태 (OPEN/REPAIR/CLOSE)
                      --%>
                      <table class="item-tbl" id="itemTbl">
                        <thead>
                        <tr>
                          <th style="width:40%;">자원명<small>ITEM_NM</small></th>
                          <th style="width:35%;">상태<small>CMN_FACILITY_STTS_CD</small></th>
                          <th style="width:25%;text-align:center;">관리</th>
                        </tr>
                        </thead>
                        <tbody id="itemTbody"></tbody>
                      </table>
                      <!-- 자원 추가 행 -->
                      <div class="item-add-row">
                        <input type="text" class="form-input" id="newItemNm" placeholder="자원명 입력">
                        <select class="form-select" id="newItemStts">
                          <option value="OPEN">사용가능</option>
                          <option value="REPAIR">점검중</option>
                          <option value="CLOSE">사용중지</option>
                        </select>
                        <button type="button" class="btn btn-secondary btn-sm" data-action="addItem">
                          <span class="material-symbols-rounded">add</span>추가
                        </button>
                      </div>
                    </div>

                  </div>
                </div><!-- /modal-cols -->
              </div>
              <div class="modal-footer">
                <button type="button" class="btn btn-danger" data-action="openDeleteFromEdit" style="margin-right:auto;">
                  <span class="material-symbols-rounded">delete</span>삭제
                </button>
                <button type="button" class="btn btn-secondary" data-action="closeEditModal">취소</button>
                <button type="submit" class="btn btn-primary">저장</button>
              </div>
            </form>
          </div>
        </div>

        <!-- ══════════════════════════════════════
             모달 3: 상세 (wide 2컬럼, readonly)
             좌: 기본정보 + 자원목록
             우: 사진 + 예약이력
        ══════════════════════════════════════ -->
        <div class="modal-overlay" id="detailModal">
          <div class="modal modal-wide">
            <div class="modal-header">
              <h3 class="modal-title" id="detailModalTitle">공용시설 상세</h3>
              <button type="button" class="modal-close" data-action="closeDetailModal">
                <span class="material-symbols-rounded">close</span>
              </button>
            </div>
            <div class="modal-body readonly-mode">
              <div class="modal-cols">

                <!-- 좌: 기본정보 + 자원목록 -->
                <div class="modal-col-left">
                  <div class="col-label">시설 정보</div>
                  <div class="form-section">
                    <div class="form-section-title">
                      <span class="material-symbols-rounded">meeting_room</span>
                      공용시설 기본정보
                    </div>
                    <div class="form-row cols-2">
                      <div class="form-field">
                        <label class="field-label">공용시설명</label>
                        <input type="text" class="form-input" id="detailNm" disabled>
                      </div>
                      <div class="form-field">
                        <label class="field-label">시설 상태</label>
                        <input type="text" class="form-input" id="detailStts" disabled>
                      </div>
                    </div>
                    <div class="form-row cols-3">
                      <div class="form-field">
                        <label class="field-label">예약 여부</label>
                        <input type="text" class="form-input" id="detailRsvYn" disabled>
                      </div>
                      <div class="form-field">
                        <label class="field-label">이용요금</label>
                        <input type="text" class="form-input" id="detailAmt" disabled>
                      </div>
                      <div class="form-field">
                        <label class="field-label">동</label>
                        <input type="text" class="form-input" id="detailDong" disabled>
                      </div>
                    </div>
                    <div class="form-row cols-1">
                      <div class="form-field">
                        <label class="field-label">운영시간</label>
                        <input type="text" class="form-input" id="detailOprHr" disabled>
                      </div>
                    </div>
                    <div class="form-row cols-1">
                      <div class="form-field">
                        <label class="field-label">상세위치</label>
                        <input type="text" class="form-input" id="detailLocCn" disabled>
                      </div>
                    </div>
                    <div class="form-row cols-1">
                      <div class="form-field">
                        <label class="field-label">시설 안내</label>
                        <textarea class="form-textarea" id="detailCn" disabled rows="2"></textarea>
                      </div>
                    </div>
                  </div>

                  <!-- 자원 목록 (읽기전용) -->
                  <div class="form-section">
                    <div class="form-section-title">
                      <span class="material-symbols-rounded">inventory_2</span>
                      시설 자원 · PUBLIC_ITEM
                    </div>
                    <table class="item-tbl">
                      <thead>
                      <tr>
                        <th>자원번호<small>CMN_FACILITY_ITEM_NO</small></th>
                        <th>자원명<small>ITEM_NM</small></th>
                        <th style="text-align:center;">상태<small>CMN_FACILITY_STTS_CD</small></th>
                      </tr>
                      </thead>
                      <tbody id="detailItemTbody"></tbody>
                    </table>
                  </div>
                </div>

                <!-- 우: 사진 + 예약이력 -->
                <div class="modal-col-right">
                  <div class="col-label">사진 &amp; 예약이력</div>

                  <!-- 사진 -->
                  <div class="form-section">
                    <div class="form-section-title">
                      <span class="material-symbols-rounded">photo_library</span>
                      시설 사진
                    </div>
                    <div class="img-grid" id="detailImgGrid"></div>
                  </div>

                  <!-- 예약이력 -->
                  <div class="form-section">
                    <div class="form-section-title">
                      <span class="material-symbols-rounded">event_available</span>
                      최근 예약이력 · FACILITY_HSTRY
                    </div>
                    <div class="rsvt-block">
                      <div class="rsvt-block-hd">
                        <span>최근 5건</span>
                        <%-- 예약 전체 조회 → 단지 운영 관리 > 예약 접수·확인 --%>
                        <a href="${pageContext.request.contextPath}/manager/complex/reservation">전체보기 →</a>
                      </div>
                      <div id="detailRsvtBody"></div>
                    </div>
                  </div>
                </div>

              </div><!-- /modal-cols -->
            </div>
            <div class="modal-footer">
              <button type="button" class="btn btn-secondary" data-action="closeDetailModal">닫기</button>
              <button type="button" class="btn btn-primary"   data-action="editFromDetail" id="detailEditBtn">수정하기</button>
            </div>
          </div>
        </div>

        <!-- 모달 4: 삭제 확인 -->
        <div class="modal-overlay" id="deleteModal">
          <div class="modal modal-sm">
            <div class="modal-header">
              <h3 class="modal-title">공용시설 삭제</h3>
              <button type="button" class="modal-close" data-action="closeDeleteModal">
                <span class="material-symbols-rounded">close</span>
              </button>
            </div>
            <div class="modal-body">
              <div class="del-warn">
                <span class="material-symbols-rounded">warning</span>
                <div>선택한 공용시설을 삭제하시겠습니까?<br>자원(PUBLIC_ITEM) 및 예약이력(FACILITY_HSTRY)도 함께 삭제됩니다.</div>
              </div>
              <div class="mngr-detail-grid" id="deleteTargetInfo"></div>
            </div>
            <div class="modal-footer">
              <button type="button" class="btn btn-secondary" data-action="closeDeleteModal">취소</button>
              <button type="button" class="btn btn-danger"    id="deleteConfirmBtn">삭제</button>
            </div>
          </div>
        </div>

      </div><!-- /office-page -->

      <script>
        (function () {
          var page = document.getElementById('publicFacilityPage');
          if (!page || page.dataset.bound === 'true') return;
          page.dataset.bound = 'true';

          /* ── 공통코드 맵 ──────────────────────────────────────────
             PUBLIC_FACILITY_STTS → CMN_FACILITY_STTS_CD
               OPEN 사용가능 / USE 사용중 / REPAIR 점검중 / CLOSE 사용중지
             RSVT_STTS → RSVT_STTS_CD
               REQ 예약신청 / CONFIRM 예약확정 / USE 이용중 / DONE 이용완료 / CANCEL 예약취소
          ────────────────────────────────────────────────────────── */
          var STTS_TEXT  = { OPEN:'사용가능', USE:'사용중', REPAIR:'점검중', CLOSE:'사용중지' };
          var STTS_BADGE = { OPEN:'badge-green', USE:'badge-blue', REPAIR:'badge-yellow', CLOSE:'badge-gray' };
          var ITEM_STTS_TEXT  = { OPEN:'사용가능', REPAIR:'점검중', CLOSE:'사용중지' };
          var ITEM_STTS_BADGE = { OPEN:'badge-green', REPAIR:'badge-yellow', CLOSE:'badge-gray' };
          var RSVT_TEXT  = { REQ:'예약신청', CONFIRM:'예약확정', USE:'이용중', DONE:'이용완료', CANCEL:'예약취소' };
          var RSVT_BADGE = { REQ:'badge-blue', CONFIRM:'badge-green', USE:'badge-orange', DONE:'badge-gray', CANCEL:'badge-red' };

          /* ── 더미 데이터 (백엔드 연결 시 AJAX 대체) ── */
          var facilityData = [
            { cmnFacilityNo:'CMN-001', facilityNo:'FAC-007', cmnFacilityNm:'헬스장',
              cmnFacilitySttsCd:'OPEN', rsvYn:'Y', cmnAmt:0, oprHr:'06:00~22:00',
              cmnCn:'이용 시 운동화 착용 필수. 예약 후 이용 가능합니다.',
              dongNo:'공용', locCn:'커뮤니티센터 2층', imgs:[],
              items:[
                { cmnFacilityItemNo:'ITEM-001', itemNm:'헬스기구 구역 A', cmnFacilitySttsCd:'OPEN' },
                { cmnFacilityItemNo:'ITEM-002', itemNm:'헬스기구 구역 B', cmnFacilitySttsCd:'REPAIR' },
              ],
              rsvts:[
                { rsvtNo:'RSV-001', hoNo:'101', itemNm:'헬스기구 구역 A', rsvtDt:'2026-05-06', rsvtBgng:'09:00', rsvtEnd:'10:00', rsvtSttsCd:'DONE' },
                { rsvtNo:'RSV-002', hoNo:'203', itemNm:'헬스기구 구역 B', rsvtDt:'2026-05-07', rsvtBgng:'18:00', rsvtEnd:'19:00', rsvtSttsCd:'CONFIRM' },
                { rsvtNo:'RSV-003', hoNo:'105', itemNm:'헬스기구 구역 A', rsvtDt:'2026-05-08', rsvtBgng:'07:00', rsvtEnd:'08:00', rsvtSttsCd:'REQ' },
              ] },
            { cmnFacilityNo:'CMN-002', facilityNo:'FAC-008', cmnFacilityNm:'독서실',
              cmnFacilitySttsCd:'OPEN', rsvYn:'Y', cmnAmt:1000, oprHr:'08:00~23:00',
              cmnCn:'1일 최대 2회 이용. 음식물 반입 금지.',
              dongNo:'공용', locCn:'커뮤니티센터 3층', imgs:[],
              items:[
                { cmnFacilityItemNo:'ITEM-003', itemNm:'A석 (1~10번)', cmnFacilitySttsCd:'OPEN' },
                { cmnFacilityItemNo:'ITEM-004', itemNm:'B석 (11~20번)', cmnFacilitySttsCd:'OPEN' },
              ], rsvts:[] },
            { cmnFacilityNo:'CMN-003', facilityNo:'FAC-009', cmnFacilityNm:'게스트룸',
              cmnFacilitySttsCd:'REPAIR', rsvYn:'N', cmnAmt:50000, oprHr:'체크인 14:00 / 체크아웃 11:00',
              cmnCn:'점검 중. 이용 불가.', dongNo:'101', locCn:'1층 게스트룸', imgs:[],
              items:[], rsvts:[] },
          ];

          var currentIdx      = null;
          var deleteTargetIdx = null;
          var editItems       = [];

          /* ── 헬퍼 ── */
          function b(cls, t)     { return '<span class="badge ' + cls + '">' + t + '</span>'; }
          function sttsB(cd)     { return b(STTS_BADGE[cd]      || 'badge-gray', STTS_TEXT[cd]      || cd); }
          function itemSttsB(cd) { return b(ITEM_STTS_BADGE[cd] || 'badge-gray', ITEM_STTS_TEXT[cd] || cd); }
          function rsvtB(cd)     { return b(RSVT_BADGE[cd]      || 'badge-gray', RSVT_TEXT[cd]      || cd); }
          function fmtAmt(n)     { return Number(n) === 0 ? '무료' : Number(n).toLocaleString() + '원'; }
          function di(l, v)      { return '<div class="mngr-detail-item"><div class="mngr-detail-label">' + l + '</div><div class="mngr-detail-value">' + v + '</div></div>'; }

          /* ── 요약 칩 ── */
          function updateChips(data) {
            document.getElementById('facilityTotalCount').textContent = data.length + '건';
            document.getElementById('chipTotal').textContent  = data.length;
            document.getElementById('chipRsv').textContent    = data.filter(function(r){ return r.rsvYn === 'Y'; }).length;
            document.getElementById('chipClose').textContent  = data.filter(function(r){ return r.cmnFacilitySttsCd === 'CLOSE'; }).length;
            document.getElementById('statusCountText').textContent = '전체 ' + data.length + '건';
          }

          /* ── 렌더 ── */
          function renderFacility(data) {
            updateChips(data);
            var tb = document.getElementById('facilityTbody');
            if (!data.length) { tb.innerHTML = '<tr><td colspan="10" class="empty-row">조건에 맞는 공용시설이 없습니다.</td></tr>'; return; }
            tb.innerHTML = data.map(function(r) {
              var realIdx = facilityData.indexOf(r);
              return '<tr>'
                      + '<td class="td-mono">' + r.cmnFacilityNo + '</td>'
                      + '<td class="td-bold">' + r.cmnFacilityNm + '</td>'
                      + '<td class="col-center td-mono">' + (r.dongNo || '—') + '</td>'
                      + '<td class="td-sub">' + (r.locCn || '—') + '</td>'
                      + '<td class="col-center">' + (r.rsvYn === 'Y' ? b('badge-green','가능') : b('badge-gray','불가')) + '</td>'
                      + '<td class="col-right td-bold">' + fmtAmt(r.cmnAmt) + '</td>'
                      + '<td class="td-sub">' + (r.oprHr || '—') + '</td>'
                      + '<td class="col-center td-mono">' + (r.items ? r.items.length : 0) + '건</td>'
                      + '<td class="col-center">' + sttsB(r.cmnFacilitySttsCd) + '</td>'
                      + '<td class="col-manage"><div class="grid-actions">'
                      + '<button type="button" class="btn btn-xs btn-detail" data-action="detail" data-idx="' + realIdx + '">상세</button>'
                      + '<button type="button" class="btn btn-xs btn-edit"   data-action="edit"   data-idx="' + realIdx + '">수정</button>'
                      + '<button type="button" class="btn btn-xs btn-delete" data-action="delete" data-idx="' + realIdx + '">삭제</button>'
                      + '</div></td></tr>';
            }).join('');
          }

          /* ── 필터 ── */
          function filtered() {
            var st  = document.getElementById('filterStts').value;
            var rsv = document.getElementById('filterRsvYn').value;
            var kw  = document.getElementById('filterKeyword').value.trim();
            return facilityData.filter(function(r){
              return (!st  || r.cmnFacilitySttsCd === st)
                      && (!rsv || r.rsvYn === rsv)
                      && (!kw  || r.cmnFacilityNm.indexOf(kw) > -1);
            });
          }

          /* ── 자원 테이블 렌더 (수정 모달) ── */
          function renderItemTbody() {
            var tb = document.getElementById('itemTbody');
            if (!editItems.length) {
              tb.innerHTML = '<tr><td colspan="3" style="text-align:center;padding:14px;color:var(--text-ter);font-size:12px;">등록된 자원이 없습니다.</td></tr>';
              return;
            }
            tb.innerHTML = editItems.map(function(item, i){
              return '<tr>'
                      + '<td><input type="text" class="form-input" value="' + item.nm + '" data-item-i="' + i + '" data-field="nm"></td>'
                      + '<td><select class="form-select" data-item-i="' + i + '" data-field="stts">'
                      + '<option value="OPEN"'   + (item.stts==='OPEN'   ?' selected':'') + '>사용가능</option>'
                      + '<option value="REPAIR"' + (item.stts==='REPAIR' ?' selected':'') + '>점검중</option>'
                      + '<option value="CLOSE"'  + (item.stts==='CLOSE'  ?' selected':'') + '>사용중지</option>'
                      + '</select></td>'
                      + '<td style="text-align:center;">'
                      + '<button type="button" class="btn btn-xs btn-delete" data-action="delItem" data-i="' + i + '">삭제</button>'
                      + '</td></tr>';
            }).join('');

            /* 인라인 편집 이벤트 */
            tb.querySelectorAll('[data-item-i]').forEach(function(el){
              el.addEventListener('change', function(){
                var i = Number(el.dataset.itemI);
                editItems[i][el.dataset.field] = el.value;
              });
            });
          }

          /* ── 모달 열기/닫기 ── */
          function openM(id)  { document.getElementById(id).classList.add('open'); }
          function closeM(id) { document.getElementById(id).classList.remove('open'); }

          /* 등록 */
          function openRegister() {
            document.getElementById('registerForm').reset();
            document.getElementById('registerModalTitle') && (document.getElementById('registerModalTitle').textContent = '공용시설 등록');
            openM('registerModal');
          }

          /* 수정 */
          function openEdit(idx) {
            var r = facilityData[idx];
            currentIdx = idx;
            document.getElementById('editModalTitle').textContent = r.cmnFacilityNm + ' · 수정';
            document.getElementById('editCmnFacilityNo').value = r.cmnFacilityNo;
            document.getElementById('editFacilityNo').value    = r.facilityNo;
            var fields = { editCmnNm: r.cmnFacilityNm, editStts: r.cmnFacilitySttsCd, editRsvYn: r.rsvYn,
              editAmt: r.cmnAmt, editOprHr: r.oprHr, editCn: r.cmnCn,
              editDongNo: r.dongNo, editLocCn: r.locCn };
            Object.keys(fields).forEach(function(k){ var el = document.getElementById(k); if (el) el.value = fields[k] || ''; });
            editItems = (r.items || []).map(function(i){ return { no: i.cmnFacilityItemNo, nm: i.itemNm, stts: i.cmnFacilitySttsCd }; });
            renderItemTbody();
            openM('editModal');
          }

          /* 상세 */
          function openDetail(idx) {
            var r = facilityData[idx];
            currentIdx = idx;
            document.getElementById('detailModalTitle').textContent = r.cmnFacilityNm + ' · 상세';
            document.getElementById('detailEditBtn').dataset.idx = idx;

            document.getElementById('detailNm').value    = r.cmnFacilityNm;
            document.getElementById('detailStts').value  = STTS_TEXT[r.cmnFacilitySttsCd] || r.cmnFacilitySttsCd;
            document.getElementById('detailRsvYn').value = r.rsvYn === 'Y' ? '예약 가능' : '예약 불가';
            document.getElementById('detailAmt').value   = fmtAmt(r.cmnAmt);
            document.getElementById('detailOprHr').value = r.oprHr || '';
            document.getElementById('detailDong').value  = r.dongNo || '—';
            document.getElementById('detailLocCn').value = r.locCn || '';
            document.getElementById('detailCn').value    = r.cmnCn || '';

            /* 사진 */
            var imgGrid = document.getElementById('detailImgGrid');
            imgGrid.innerHTML = (!r.imgs || !r.imgs.length)
                    ? '<div style="grid-column:1/-1;font-size:12px;color:var(--text-ter);padding:8px 0;">등록된 사진이 없습니다.</div>'
                    : r.imgs.map(function(src){ return '<div class="img-cell"><img src="' + src + '" alt="시설사진"></div>'; }).join('');

            /* 자원 */
            var itemTb = document.getElementById('detailItemTbody');
            if (!r.items || !r.items.length) {
              itemTb.innerHTML = '<tr><td colspan="3" style="text-align:center;padding:14px;color:var(--text-ter);font-size:12px;">등록된 자원이 없습니다.</td></tr>';
            } else {
              itemTb.innerHTML = r.items.map(function(item){
                return '<tr>'
                        + '<td class="td-mono">' + item.cmnFacilityItemNo + '</td>'
                        + '<td class="td-bold">' + item.itemNm + '</td>'
                        + '<td style="text-align:center;">' + itemSttsB(item.cmnFacilitySttsCd) + '</td>'
                        + '</tr>';
              }).join('');
            }

            /* 예약이력 */
            var rsvtBody = document.getElementById('detailRsvtBody');
            if (!r.rsvts || !r.rsvts.length) {
              rsvtBody.innerHTML = '<div class="rsvt-empty">예약이력이 없습니다.</div>';
            } else {
              rsvtBody.innerHTML = r.rsvts.slice(0,5).map(function(rv){
                return '<div class="rsvt-row">'
                        + '<span class="rsvt-no">' + rv.rsvtNo + '</span>'
                        + '<span class="rsvt-nm">' + rv.hoNo + '호 · ' + rv.itemNm + '</span>'
                        + '<span class="rsvt-dt">' + rv.rsvtDt + ' ' + rv.rsvtBgng + '~' + rv.rsvtEnd + '</span>'
                        + '<span>' + rsvtB(rv.rsvtSttsCd) + '</span>'
                        + '</div>';
              }).join('');
            }

            openM('detailModal');
          }

          /* ── 이벤트 위임 ── */
          page.addEventListener('click', function(e){
            var btn = e.target.closest('[data-action]');
            if (!btn) return;
            var action = btn.dataset.action;
            var idx    = btn.dataset.idx !== undefined ? Number(btn.dataset.idx) : undefined;

            if (action === 'openRegister')      openRegister();
            if (action === 'edit')              openEdit(idx);
            if (action === 'editFromDetail')    { closeM('detailModal'); openEdit(Number(btn.dataset.idx)); }
            if (action === 'closeRegisterModal') closeM('registerModal');
            if (action === 'closeEditModal')     closeM('editModal');
            if (action === 'detail')            openDetail(idx);
            if (action === 'closeDetailModal')  closeM('detailModal');

            /* 자원 추가 */
            if (action === 'addItem') {
              var nm = document.getElementById('newItemNm').value.trim();
              if (!nm) { alert('자원명을 입력하세요.'); return; }
              var stts = document.getElementById('newItemStts').value;
              editItems.push({ no: null, nm: nm, stts: stts });
              document.getElementById('newItemNm').value = '';
              renderItemTbody();
            }
            /* 자원 삭제 */
            if (action === 'delItem') {
              editItems.splice(Number(btn.dataset.i), 1);
              renderItemTbody();
            }

            /* 삭제 */
            if (action === 'delete') {
              deleteTargetIdx = idx;
              var r = facilityData[idx];
              document.getElementById('deleteTargetInfo').innerHTML =
                      di('CMN_FACILITY_NO', r.cmnFacilityNo) + di('시설명', r.cmnFacilityNm) + di('자원 수', (r.items ? r.items.length : 0) + '건');
              openM('deleteModal');
            }
            if (action === 'openDeleteFromEdit') {
              if (currentIdx === null) return;
              deleteTargetIdx = currentIdx;
              var r = facilityData[currentIdx];
              document.getElementById('deleteTargetInfo').innerHTML =
                      di('CMN_FACILITY_NO', r.cmnFacilityNo) + di('시설명', r.cmnFacilityNm) + di('자원 수', (r.items ? r.items.length : 0) + '건');
              openM('deleteModal');
            }
            if (action === 'closeDeleteModal') closeM('deleteModal');

            if (action === 'searchFacility') renderFacility(filtered());
            if (action === 'resetFacility')  {
              ['filterStts','filterRsvYn','filterKeyword'].forEach(function(id){ document.getElementById(id).value = ''; });
              renderFacility(facilityData);
            }
          });

          /* 삭제 확인 */
          document.getElementById('deleteConfirmBtn').addEventListener('click', function(){
            if (deleteTargetIdx === null) return;
            facilityData.splice(deleteTargetIdx, 1);
            renderFacility(facilityData);
            closeM('deleteModal'); closeM('editModal');
            deleteTargetIdx = null;
          });

          /* 등록 저장 */
          document.getElementById('registerForm').addEventListener('submit', function(e){
            e.preventDefault();
            if (!document.getElementById('regFacilityNm').value.trim()) { alert('시설명을 입력하세요.'); return; }
            if (!document.getElementById('regCmnNm').value.trim())      { alert('공용시설명을 입력하세요.'); return; }
            /* TODO: AJAX POST /manager/publicFacility/save
               FACILITY INSERT → PUBLIC_FACILITY INSERT
            */
            alert('저장 — FACILITY INSERT → PUBLIC_FACILITY INSERT');
            closeM('registerModal');
            renderFacility(facilityData);
          });

          /* 수정 저장 */
          document.getElementById('editForm').addEventListener('submit', function(e){
            e.preventDefault();
            if (!document.getElementById('editCmnNm').value.trim()) { alert('공용시설명을 입력하세요.'); return; }
            /* TODO: AJAX POST /manager/publicFacility/update
               PUBLIC_FACILITY UPDATE + PUBLIC_ITEM INSERT/UPDATE/DELETE
            */
            alert('저장 — PUBLIC_FACILITY UPDATE + PUBLIC_ITEM 동기화');
            closeM('editModal');
            renderFacility(facilityData);
          });

          /* 오버레이 닫기 */
          ['registerModal','editModal','detailModal','deleteModal'].forEach(function(id){
            document.getElementById(id).addEventListener('click', function(e){ if (e.target === this) closeM(id); });
          });

          /* ── 초기 렌더 ── */
          renderFacility(facilityData);

        })();
      </script>

    </main>
  </div>
</div>
</body>
</html>
