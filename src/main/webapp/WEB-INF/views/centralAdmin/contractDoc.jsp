<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!doctype html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1.0" />
  <title>우리집맵핑 · 서류 관리</title>
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
  <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/centralAside.css" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/centralHeader.css" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/centralCommon.css" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/centralAmin/js/toggleSidebar.js"/>
  <style>
    .doc-chip {
      display: inline-flex;
      align-items: center;
      gap: 6px;
      padding: 5px 10px;
      border-radius: 999px;
      background: var(--gray-soft);
      border: 1px solid var(--border);
      font-size: 12px;
      font-weight: 700;
      color: var(--text-secondary);
      white-space: nowrap;
    }
    .doc-chip.is-blue {
      background: var(--blue-bg);
      border-color: rgba(59, 130, 246, 0.25);
      color: #1d4ed8;
    }
    .doc-chip.is-green {
      background: var(--green-bg);
      border-color: rgba(22, 163, 74, 0.25);
      color: #15803d;
    }
    .doc-chip.is-orange {
      background: var(--orange-bg);
      border-color: rgba(249, 115, 22, 0.25);
      color: #c2410c;
    }

    .doc-actions {
      display: flex;
      align-items: center;
      justify-content: flex-end;
      gap: 8px;
      flex-wrap: wrap;
    }

    .doc-preview {
      border: 1px solid var(--border);
      border-radius: var(--r-md);
      background: #fff;
      overflow: hidden;
      height: 520px;
    }
    .doc-preview iframe {
      width: 100%;
      height: 100%;
      border: 0;
      background: #fff;
    }

    .c-modal__body .form-err {
      display: block;
      margin-top: 6px;
      color: var(--red);
      font-size: 12px;
    }
    .is-hidden {
      display: none !important;
    }

    .file-fname {
      font-size: 12px;
      color: var(--text-tertiary);
      margin-left: 10px;
    }
  </style>
</head>
<body>
<%-- ================================================================ SIDEBAR ================================================================ --%>
<aside class="sidebar" id="sidebar">
  <div class="sidebar-logo">
    <div class="logo-mark">
      <div class="logo-icon" id="logoIcon"><span class="material-symbols-rounded">home_work</span></div>
      <div class="logo-text">
        <h1>우리집맵핑</h1>
        <p>중앙관리 시스템</p>
      </div>
    </div>
    <%-- onclick 제거 → JS에서 바인딩 --%>
    <button class="collapse-btn" id="btnToggleSidebar" data-tooltip="사이드바 접기">
      <span class="material-symbols-rounded">left_panel_close</span>
    </button>
  </div>
  <nav class="sidebar-nav">
    <div class="nav-group">
      <a class="nav-item"><span class="material-symbols-rounded nav-icon">grid_view</span><span class="nav-text">대시보드</span></a>
    </div>
    <div class="section-divider"></div>
    <div class="nav-group">
      <span class="section-label">건물 · 입주민</span>
      <a href="${pageContext.request.contextPath}/centralAdmin/buildSearch" class="nav-item"><span class="material-symbols-rounded nav-icon">manage_search</span><span class="nav-text">매물 통합 검색</span></a>
      <a href="${pageContext.request.contextPath}/centralAdmin/buildRegister" class="nav-item"><span class="material-symbols-rounded nav-icon">apartment</span><span class="nav-text">건물 등록 및 열람</span></a>
      <a href="${pageContext.request.contextPath}/centralAdmin/residentList" class="nav-item"><span class="material-symbols-rounded nav-icon">groups</span><span class="nav-text">입주민 관리</span></a>
    </div>
    <div class="section-divider"></div>
    <div class="nav-group">
      <span class="section-label">계약 · 재무</span>
      <a href="${pageContext.request.contextPath}/centralAdmin/contractList.do" class="nav-item"><span class="material-symbols-rounded nav-icon">contract</span><span class="nav-text">계약 관리</span></a>
      <a href="${pageContext.request.contextPath}/centralAdmin/contractDoc.do" class="nav-item active"><span class="material-symbols-rounded nav-icon">description</span><span class="nav-text">서류 관리</span></a>
      <a href="${pageContext.request.contextPath}/centralAdmin/contractForm.do" class="nav-item"><span class="material-symbols-rounded nav-icon">edit_document</span><span class="nav-text">서식 관리</span></a>
      <a href="${pageContext.request.contextPath}/centralAdmin/statistics" class="nav-item"><span class="material-symbols-rounded nav-icon">bar_chart_4_bars</span><span class="nav-text">통계</span></a>
    </div>
    <div class="section-divider"></div>
    <div class="nav-group">
      <span class="section-label">민원 · 소통</span>
      <a href="${pageContext.request.contextPath}/centralAdmin/civilCom" class="nav-item"><span class="material-symbols-rounded nav-icon">support_agent</span><span class="nav-text">민원 관리</span><span class="nav-badge">3</span></a>
      <a href="${pageContext.request.contextPath}/centralAdmin/ai" class="nav-item"><span class="material-symbols-rounded nav-icon">forum</span><span class="nav-text">문의 관리</span><span class="nav-badge yellow">4</span></a>
      <a href="${pageContext.request.contextPath}/centralAdmin/announcement" class="nav-item"><span class="material-symbols-rounded nav-icon">campaign</span><span class="nav-text">공고 관리</span></a>
      <a href="${pageContext.request.contextPath}/centralAdmin/notice" class="nav-item"><span class="material-symbols-rounded nav-icon">article</span><span class="nav-text">통합 게시판 관리</span></a>
    </div>
    <div class="section-divider"></div>
    <div class="nav-group">
      <span class="section-label">시설 · 시스템</span>
      <a href="${pageContext.request.contextPath}/centralAdmin/facility" class="nav-item"><span class="material-symbols-rounded nav-icon">handyman</span><span class="nav-text">시설 관리</span></a>
      <a href="${pageContext.request.contextPath}/centralAdmin/proHistory" class="nav-item"><span class="material-symbols-rounded nav-icon">warning</span><span class="nav-text">비정상 세대 관리</span></a>
      <a href="${pageContext.request.contextPath}/centralAdmin/mngrRqstAprv" class="nav-item"><span class="material-symbols-rounded nav-icon">manage_accounts</span><span class="nav-text">단지관리자 계정</span></a>
    </div>
  </nav>
  <div class="admin-card">
    <div class="admin-avatar"><span class="material-symbols-rounded" style="color: #fff; font-size: 18px">person</span></div>
    <div class="admin-info">
      <p>중앙관리자</p>
      <span>클로드 최고</span>
    </div>
    <button class="icon-btn" id="btnLogout" data-tooltip="로그아웃" style="flex-shrink: 0; margin-left: auto">
      <span class="material-symbols-rounded">logout</span>
    </button>
  </div>
</aside>

<%-- ================================================================ MAIN ================================================================ --%>
<div class="main-wrap">
  <div class="topbar">
    <div class="breadcrumb">
      <span class="material-symbols-rounded" style="font-size: 14px">home</span>
      <span style="margin: 0 4px">/</span>
      <span>계약·재무</span>
      <span style="margin: 0 4px">/</span>
      <span class="bc-current">서류 관리</span>
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
        <div class="page-title">서류 관리</div>
        <div class="page-subtitle">계약 관련 서류를 조회하고 관리합니다.</div>
      </div>
      <div class="page-header__right">
        <%-- onclick 제거 → id 부여 --%>
        <%--<button class="c-btn c-btn--primary" id="btnDocCreate">
          <span class="material-symbols-rounded">upload</span>서류 등록
        </button>--%>
      </div>
    </div>

    <%-- ================================================================ 필터 폼 ================================================================ --%>
    <form id="filterForm" method="get" action="${pageContext.request.contextPath}/centralAdmin/contractDoc">
      <input type="hidden" name="page" id="f-page" value="1" />
      <div class="c-card c-card--divide" style="margin-bottom:16px">
        <div class="c-card__header">
          <div>
            <div class="c-card__title">검색 조건</div>
            <div class="c-card__sub">조건을 입력하면 서류 목록이 필터링됩니다.</div>
          </div>
          <div class="c-card__actions">
            <%-- onclick 제거 → id 부여 --%>
            <button type="button" class="c-btn c-btn--ghost" id="btnFilterReset">
              <span class="material-symbols-rounded">refresh</span>초기화
            </button>
            <button type="button" class="c-btn c-btn--primary" id="btnFilterApply">
              <span class="material-symbols-rounded">search</span>검색
            </button>
          </div>
        </div>
        <div class="c-card__body c-filter-row">
          <div class="c-field" style="min-width:515px">
            <label class="c-label">서류 유형</label>
            <select class="c-select" id="f-doc-type" name="docType">
              <option value="">전체</option>
              <option value="ID">주민등록등본</option>
              <option value="FAMILY">금융정보제공동의서</option>
              <option value="RESIDENCE">개인정보수집 이용 및 제 3자 제공 동의서</option>
              <option value="CONTRACT">가족관계 증명서</option>
              <option value="ETC">기타서류</option>
            </select>
          </div>
          <div class="c-field" style="min-width:515px">
            <label class="c-label">계약 유형</label>
            <select class="c-select" id="f-doc-type" name="rentTypeCd">
              <option value="">전체</option>
              <option value="전세" <c:if test="${rentTypeCd eq '전세'}">selected</c:if>>전세</option>
              <option value="월세" <c:if test="${rentTypeCd eq '월세'}">selected</c:if>>월세</option>
            </select>
          </div>
          <div class="c-field" style="min-width:515px">
            <label class="c-label">상태</label>
            <%-- id 중복 수정: f-doc-cat → f-doc-status --%>
            <select class="c-select" id="f-doc-status" name="docStatus">
              <option value="">전체</option>
              <option value="APRV">승인</option>
              <option value="REJT">반려</option>
            </select>
          </div>
        </div>
      </div>
    </form>

    <%-- ================================================================ 테이블 ================================================================ --%>
    <div class="c-card c-card--divide">
      <div class="c-card__header">
        <div>
          <div class="c-card__title">서류 목록</div>
          <div class="c-card__sub">
            총 <span style="color:var(--accent);font-weight:800" id="docTotalCount">0</span>건 · 페이지당 10건
          </div>
        </div>
      </div>
      <div class="c-table-wrap">
        <table class="c-table" id="docTable">
          <thead>
          <tr>
            <th style="width: 80px">서류 번호</th>
            <th style="width: 160px">서류 유형</th>
            <th style="width: 120px">계약 유형</th>
            <th style="width: 160px">등록일</th>
            <th style="width: 80px">관리</th>
          </tr>
          </thead>
          <tbody id="docTbody">
          <tr id="docEmptyRow">
            <td colspan="6">
              <div class="c-empty">
                <div class="c-empty__title">등록된 서류가 없습니다</div>
                <div class="c-empty__sub">우측 상단의 "서류 등록" 버튼으로 첫 서류를 추가해보세요.</div>
              </div>
            </td>
          </tr>
          </tbody>
        </table>
      </div>

      <div class="c-card__footer" style="justify-content:center">
        <div class="c-pagination" id="docPagination">
          <button type="button" class="c-pagination__btn is-disabled"><span class="material-symbols-rounded">chevron_left</span></button>
          <button type="button" class="c-pagination__btn is-active">1</button>
          <button type="button" class="c-pagination__btn is-disabled"><span class="material-symbols-rounded">chevron_right</span></button>
        </div>
      </div>
    </div>
  </div>
</div>

<%-- ================================================================ 서류 등록/수정 모달 ================================================================ --%>
<div class="c-modal-overlay is-hidden" id="docModalOverlay">
  <div class="c-modal c-modal--lg" role="dialog" aria-modal="true">
    <div class="c-modal__header">
      <h3 class="c-modal__title" id="docModalTitle">서류 등록</h3>
      <%-- onclick 제거 → id 부여 --%>
      <button class="c-modal__close" id="btnModalClose" aria-label="닫기">
        <span class="material-symbols-rounded">close</span>
      </button>
    </div>

    <div class="c-modal__body">
      <%-- onsubmit 제거 → JS에서 바인딩 --%>
      <form id="docForm">
        <input type="hidden" id="docId" value="" />

        <div style="display: flex; flex-direction: column; gap: 16px">
          <div class="c-card c-card--divide">
            <div class="c-card__header"><div class="c-card__title">기본 정보</div></div>
            <div class="c-card__body">
              <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 14px">
                <div class="c-field">
                  <label class="c-label">구분 <span class="req">*</span></label>
                  <select id="d-cat" class="c-select">
                    <option value="">선택</option>
                    <option value="계약서">계약서</option>
                    <option value="확인서/동의서">확인서/동의서</option>
                    <option value="안내문">안내문</option>
                    <option value="기타">기타</option>
                  </select>
                  <span class="form-err" id="err-d-cat"></span>
                </div>
                <div class="c-field">
                  <label class="c-label">서류명 <span class="req">*</span></label>
                  <input type="text" id="d-name" class="c-input" placeholder="예: 표준 임대차계약서" />
                  <span class="form-err" id="err-d-name"></span>
                </div>
                <div class="c-field" style="grid-column: 1 / span 2">
                  <label class="c-label">설명</label>
                  <textarea id="d-desc" class="c-input" style="min-height: 90px; resize: vertical" placeholder="서류 사용처/주의사항 등을 간단히 기록하세요."></textarea>
                </div>
              </div>
            </div>
          </div>

          <div class="c-card c-card--divide">
            <div class="c-card__header">
              <div class="c-card__title">파일 업로드 <span style="font-size: 12px; font-weight: 600; color: var(--text-tertiary)">(선택)</span></div>
            </div>
            <div class="c-card__body">
              <div class="file-upload-row">
                <label class="c-label" style="width: 90px; flex-shrink: 0">서류 파일</label>
                <label class="file-label">
                  <%-- onchange 제거 → JS에서 바인딩 --%>
                  <input type="file" id="d-file" accept=".pdf,.doc,.docx,.hwp,.xlsx" />
                  <span class="material-symbols-rounded" style="font-size: 16px; margin-right: 5px">upload</span>파일 선택
                </label>
                <span class="file-fname" id="d-fname">선택된 파일 없음</span>
              </div>
              <div style="margin-top: 10px; font-size: 12px; color: var(--text-tertiary)">
                - PDF는 미리보기가 가능합니다. docx/hwp/xlsx는 다운로드로 확인합니다.<br />
                - 파일 업로드는 multipart/form-data로 처리됩니다.
              </div>
            </div>
          </div>
        </div>
      </form>
    </div>

    <div class="c-modal__footer">
      <%-- onclick 제거 → id 부여 --%>
      <button type="button" class="c-btn c-btn--ghost" id="btnModalCancel">닫기</button>
      <button type="button" class="c-btn c-btn--primary" id="docSubmitBtn">
        <span class="material-symbols-rounded">check</span>등록
      </button>
    </div>
  </div>
</div>

<%-- 사이드바 JS (한 번만 로드) --%>
<script src="${pageContext.request.contextPath}/js/centralAdmin/toggleSidebar.js"></script>

<script>
  /* ================================================================
     이벤트 바인딩
  ================================================================ */
  document.addEventListener('DOMContentLoaded', () => {
    // 사이드바
    document.getElementById('btnToggleSidebar').addEventListener('click', toggleSidebar);

    // 서류 등록 버튼
    document.getElementById('btnDocCreate').addEventListener('click', openDocModalForCreate);

    // 필터
    document.getElementById('btnFilterReset').addEventListener('click', resetDocFilter);
    document.getElementById('btnFilterApply').addEventListener('click', applyDocFilter);

    // 모달 닫기
    document.getElementById('btnModalClose').addEventListener('click', closeDocModal);
    document.getElementById('btnModalCancel').addEventListener('click', closeDocModal);

    // 모달 오버레이 클릭 시 닫기
    document.getElementById('docModalOverlay').addEventListener('click', (e) => {
      if (e.target === e.currentTarget) closeDocModal();
    });

    // 폼 submit
    document.getElementById('docForm').addEventListener('submit', (e) => {
      e.preventDefault();
      submitDocForm();
    });

    // 등록 버튼
    document.getElementById('docSubmitBtn').addEventListener('click', submitDocForm);

    // 파일 선택
    document.getElementById('d-file').addEventListener('change', showDocFileName);

    // 초기 목록 로드
    renderDocTable();
  });

  /* ================================================================
     모달
  ================================================================ */
  function openDocModalForCreate() {
    document.getElementById('docId').value = '';
    document.getElementById('d-cat').value = '';
    document.getElementById('d-name').value = '';
    document.getElementById('d-desc').value = '';
    document.getElementById('d-fname').textContent = '선택된 파일 없음';
    document.getElementById('docModalTitle').textContent = '서류 등록';
    document.getElementById('docSubmitBtn').querySelector('span + text, span ~ *') ;
    document.getElementById('docModalOverlay').classList.remove('is-hidden');
  }

  function closeDocModal() {
    document.getElementById('docModalOverlay').classList.add('is-hidden');
    clearDocErrors();
  }

  function clearDocErrors() {
    document.getElementById('err-d-cat').textContent = '';
    document.getElementById('err-d-name').textContent = '';
  }

  function showDocFileName() {
    const file = document.getElementById('d-file').files[0];
    document.getElementById('d-fname').textContent = file ? file.name : '선택된 파일 없음';
  }

  /* ================================================================
     유효성 검사
  ================================================================ */
  function validateDocForm() {
    let valid = true;
    clearDocErrors();

    if (!document.getElementById('d-cat').value) {
      document.getElementById('err-d-cat').textContent = '구분을 선택해주세요.';
      valid = false;
    }
    if (!document.getElementById('d-name').value.trim()) {
      document.getElementById('err-d-name').textContent = '서류명을 입력해주세요.';
      valid = false;
    }
    return valid;
  }

  /* ================================================================
     fetch API
  ================================================================ */

  // 목록 조회
  function renderDocTable(page = 1) {
    const params = new URLSearchParams({
      page,
      docName   : document.getElementById('f-doc-name')?.value ?? '',
      docType   : document.getElementById('f-doc-type')?.value ?? '',
      docStatus : document.getElementById('f-doc-status')?.value ?? '',
    });

    fetch('/centralAdmin/contractDoc/list?' + params)
            .then(res => {
              if (!res.ok) throw new Error('서버 오류: ' + res.status);
              return res.json();
            })
            .then(data => {
              renderDocRows(data.list);
              document.getElementById('docTotalCount').textContent = data.totalCount ?? 0;
              renderPagination(data.totalPage, data.currentPage);
            })
            .catch(err => console.error('[renderDocTable]', err));
  }

  // 검색
  function applyDocFilter() {
    document.getElementById('f-page').value = 1;
    renderDocTable(1);
  }

  // 초기화
  function resetDocFilter() {
    document.getElementById('f-doc-name').value = '';
    document.getElementById('f-doc-type').value = '';
    document.getElementById('f-doc-status').value = '';
    renderDocTable(1);
  }

  // 등록 / 수정
  function submitDocForm() {
    if (!validateDocForm()) return;

    const docId = document.getElementById('docId').value;
    const isEdit = !!docId;

    const formData = new FormData();
    if (isEdit) formData.append('docId', docId);
    formData.append('docCat',  document.getElementById('d-cat').value);
    formData.append('docName', document.getElementById('d-name').value.trim());
    formData.append('docDesc', document.getElementById('d-desc').value.trim());

    const file = document.getElementById('d-file').files[0];
    if (file) formData.append('docFile', file);

    const url = isEdit
            ? '/central/contractDoc/update'
            : '/central/contractDoc/save';

    fetch(url, { method: 'POST', body: formData })
            .then(res => {
              if (!res.ok) throw new Error('서버 오류: ' + res.status);
              return res.json();
            })
            .then(data => {
              if (data.result === 'success') {
                closeDocModal();
                renderDocTable();
              } else {
                alert(data.message ?? '처리 중 오류가 발생했습니다.');
              }
            })
            .catch(err => console.error('[submitDocForm]', err));
  }

  /* ================================================================
     테이블 렌더링 헬퍼
  ================================================================ */
  function renderDocRows(list) {
    const tbody = document.getElementById('docTbody');
    tbody.innerHTML = '';

    if (!list || list.length === 0) {
      tbody.innerHTML =
              '<tr id="docEmptyRow"><td colspan="6">' +
              '<div class="c-empty">' +
              '<div class="c-empty__title">등록된 서류가 없습니다</div>' +
              '<div class="c-empty__sub">우측 상단의 "서류 등록" 버튼으로 첫 서류를 추가해보세요.</div>' +
              '</div>' +
              '</td></tr>';
      return;
    }

    list.forEach(function(doc) {
      const tr = document.createElement('tr');
      tr.innerHTML =
              '<td>' + doc.docId + '</td>' +
              '<td>' + doc.docName + '</td>' +
              '<td>' + doc.docType + '</td>' +
              '<td>' + (doc.contractType ?? '-') + '</td>' +
              '<td>' + doc.regDt + '</td>' +
              '<td>' +
              '<div class="doc-actions">' +
              '<button class="c-btn c-btn--ghost" data-edit-id="' + doc.docId + '">수정</button>' +
              '<button class="c-btn c-btn--ghost" data-del-id="' + doc.docId + '">삭제</button>' +
              '</div>' +
              '</td>';
      tbody.appendChild(tr);
    });

    // 동적 생성된 수정/삭제 버튼 바인딩
    tbody.querySelectorAll('[data-edit-id]').forEach(function(btn) {
      btn.addEventListener('click', function() { openDocModalForEdit(btn.dataset.editId); });
    });
    tbody.querySelectorAll('[data-del-id]').forEach(function(btn) {
      btn.addEventListener('click', function() { deleteDoc(btn.dataset.delId); });
    });
  }

  function renderPagination(totalPage, currentPage) {
    const wrap = document.getElementById('docPagination');
    if (!totalPage || totalPage <= 1) { wrap.innerHTML = ''; return; }

    let html = '<button type="button" class="c-pagination__btn ' + (currentPage <= 1 ? 'is-disabled' : '') + '"' +
            (currentPage > 1 ? ' data-page="' + (currentPage - 1) + '"' : ' disabled') + '>' +
            '<span class="material-symbols-rounded">chevron_left</span></button>';

    for (let i = 1; i <= totalPage; i++) {
      html += '<button type="button" class="c-pagination__btn ' + (i === currentPage ? 'is-active' : '') + '"' +
              ' data-page="' + i + '">' + i + '</button>';
    }

    html += '<button type="button" class="c-pagination__btn ' + (currentPage >= totalPage ? 'is-disabled' : '') + '"' +
            (currentPage < totalPage ? ' data-page="' + (currentPage + 1) + '"' : ' disabled') + '>' +
            '<span class="material-symbols-rounded">chevron_right</span></button>';

    wrap.innerHTML = html;
    wrap.querySelectorAll('[data-page]').forEach(function(btn) {
      btn.addEventListener('click', function() { renderDocTable(Number(btn.dataset.page)); });
    });
  }

  /* ================================================================
     수정 / 삭제
  ================================================================ */
  function openDocModalForEdit(docId) {
    fetch('/centralAdmin/contractDoc/detail?docId=' + docId)
            .then(res => res.json())
            .then(doc => {
              document.getElementById('docId').value   = doc.docId;
              document.getElementById('d-cat').value   = doc.docCat;
              document.getElementById('d-name').value  = doc.docName;
              document.getElementById('d-desc').value  = doc.docDesc ?? '';
              document.getElementById('d-fname').textContent = doc.fileName ?? '선택된 파일 없음';
              document.getElementById('docModalTitle').textContent = '서류 수정';
              document.getElementById('docModalOverlay').classList.remove('is-hidden');
            })
            .catch(err => console.error('[openDocModalForEdit]', err));
  }

  function deleteDoc(docId) {
    if (!confirm('해당 서류를 삭제하시겠습니까?')) return;

    fetch('/centralAdmin/contractDoc/delete', {
      method : 'POST',
      headers: { 'Content-Type': 'application/json' },
      body   : JSON.stringify({ docId: docId }),
    })
            .then(res => res.json())
            .then(data => {
              if (data.result === 'success') renderDocTable();
              else alert(data.message ?? '삭제 중 오류가 발생했습니다.');
            })
            .catch(err => console.error('[deleteDoc]', err));
  }
</script>
</body>
</html>
