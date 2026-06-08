<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!doctype html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1.0" />
  <title>우리집맵핑 · 서식 관리</title>
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
  <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/centralAside.css" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/centralHeader.css" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/centralCommon.css" />
  <script defer src="${pageContext.request.contextPath}/js/centralAdmin/toggleSidebar.js"></script>
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
    .table-click-row {
      cursor: pointer;
    }
    .table-click-row:hover {
      background: #f8fafc;
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
    <button class="collapse-btn" id="btnCollapseSidebar" data-tooltip="사이드바 접기">
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
      <a href="${pageContext.request.contextPath}/centralAdmin/buildSearch"   class="nav-item"><span class="material-symbols-rounded nav-icon">manage_search</span><span class="nav-text">매물 통합 검색</span></a>
      <a href="${pageContext.request.contextPath}/centralAdmin/buildRegister" class="nav-item"><span class="material-symbols-rounded nav-icon">apartment</span><span class="nav-text">건물 등록 및 열람</span></a>
      <a href="${pageContext.request.contextPath}/centralAdmin/residentList"  class="nav-item"><span class="material-symbols-rounded nav-icon">groups</span><span class="nav-text">입주민 관리</span></a>
    </div>
    <div class="section-divider"></div>
    <div class="nav-group">
      <span class="section-label">계약 · 재무</span>
      <a href="${pageContext.request.contextPath}/centralAdmin/contractList.do"     class="nav-item"><span class="material-symbols-rounded nav-icon">contract</span><span class="nav-text">계약 관리</span></a>
      <a href="${pageContext.request.contextPath}/centralAdmin/contractDoc.do"      class="nav-item"><span class="material-symbols-rounded nav-icon">description</span><span class="nav-text">서류 관리</span></a>
      <a href="${pageContext.request.contextPath}/centralAdmin/contractFormList.do" class="nav-item active"><span class="material-symbols-rounded nav-icon">edit_document</span><span class="nav-text">서식 관리</span></a>
      <a href="${pageContext.request.contextPath}/centralAdmin/statistics"          class="nav-item"><span class="material-symbols-rounded nav-icon">bar_chart_4_bars</span><span class="nav-text">통계</span></a>
    </div>
    <div class="section-divider"></div>
    <div class="nav-group">
      <span class="section-label">민원 · 소통</span>
      <a href="${pageContext.request.contextPath}/centralAdmin/civilCom"    class="nav-item"><span class="material-symbols-rounded nav-icon">support_agent</span><span class="nav-text">민원 관리</span><span class="nav-badge">3</span></a>
      <a href="${pageContext.request.contextPath}/centralAdmin/ai"          class="nav-item"><span class="material-symbols-rounded nav-icon">forum</span><span class="nav-text">문의 관리</span><span class="nav-badge yellow">4</span></a>
      <a href="${pageContext.request.contextPath}/centralAdmin/announcement" class="nav-item"><span class="material-symbols-rounded nav-icon">campaign</span><span class="nav-text">공고 관리</span></a>
      <a href="${pageContext.request.contextPath}/centralAdmin/notice"       class="nav-item"><span class="material-symbols-rounded nav-icon">article</span><span class="nav-text">통합 게시판 관리</span></a>
    </div>
    <div class="section-divider"></div>
    <div class="nav-group">
      <span class="section-label">시설 · 시스템</span>
      <a href="${pageContext.request.contextPath}/centralAdmin/facility"   class="nav-item"><span class="material-symbols-rounded nav-icon">handyman</span><span class="nav-text">시설 관리</span></a>
      <a href="${pageContext.request.contextPath}/centralAdmin/proHistory" class="nav-item"><span class="material-symbols-rounded nav-icon">warning</span><span class="nav-text">비정상 세대 관리</span></a>
      <a href="${pageContext.request.contextPath}/centralAdmin/mngrRqstAprv"   class="nav-item"><span class="material-symbols-rounded nav-icon">manage_accounts</span><span class="nav-text">하위관리자 계정</span></a>
    </div>
  </nav>
  <div class="admin-card">
    <div class="admin-avatar"><span class="material-symbols-rounded" style="color:#fff;font-size:18px">person</span></div>
    <div class="admin-info">
      <p>중앙관리자</p>
      <span>클로드 최고</span>
    </div>
    <button class="icon-btn" data-tooltip="로그아웃" style="flex-shrink:0;margin-left:auto">
      <span class="material-symbols-rounded">logout</span>
    </button>
  </div>
</aside>

<%-- ================================================================ MAIN ================================================================ --%>
<div class="main-wrap">
  <div class="topbar">
    <div class="breadcrumb">
      <span class="material-symbols-rounded" style="font-size:14px">home</span>
      <span style="margin:0 4px">/</span>
      <span>계약·재무</span>
      <span style="margin:0 4px">/</span>
      <span class="bc-current">서식 관리</span>
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
        <div class="page-title">서식 관리</div>
        <div class="page-subtitle">계약 진행에 필요한 표준 서식을 업로드·배포·버전 관리합니다.</div>
      </div>
      <div class="page-header__right">
        <%-- onclick 제거 → id 부여 --%>
        <button class="c-btn c-btn--primary" id="btnOpenCreate">
          <span class="material-symbols-rounded">upload</span>서식 등록
        </button>
      </div>
    </div>

    <%-- ================================================================ 필터 폼 ================================================================ --%>
    <%-- data-total-page: goPage() 에서 EL 대신 사용 --%>
    <form id="filterForm"
          method="get"
          action="${pageContext.request.contextPath}/centralAdmin/contractFormList.do"
          data-total-page="${pagingVO.totalPage}">
      <input type="hidden" name="page" id="f-page" value="${pagingVO.currentPage}" />
      <div class="c-card c-card--divide" style="margin-bottom:16px">
        <div class="c-card__header">
          <div>
            <div class="c-card__title">검색 조건</div>
            <div class="c-card__sub">조건을 입력하면 서식 목록이 필터링됩니다.</div>
          </div>
          <div class="c-card__actions">
            <%-- onclick 제거 → id 부여 --%>
            <button type="button" class="c-btn c-btn--ghost" id="btnResetFilter">
              <span class="material-symbols-rounded">refresh</span>초기화
            </button>
            <button type="button" class="c-btn c-btn--primary" id="btnApplyFilter">
              <span class="material-symbols-rounded">search</span>검색
            </button>
          </div>
        </div>
        <div class="c-card__body c-filter-row">
          <div class="c-field" style="min-width:515px">
            <label class="c-label">서식명</label>
            <input type="text" name="frmNm" class="c-input" id="f-doc-name" value="${frmNm}" placeholder="예: 표준 임대차계약서" />
          </div>
          <div class="c-field" style="min-width:515px">
            <label class="c-label">아파트 단지</label>
            <select name="aptCmplexNo" class="c-select" id="f-apt-no">
              <option value="">전체</option>
              <c:forEach var="apt" items="${aptList}">
                <option value="${apt.aptCmplexNo}" <c:if test="${apt.aptCmplexNo eq aptCmplexNo}">selected</c:if>>${apt.aptCmplexNm}</option>
              </c:forEach>
            </select>
          </div>
          <div class="c-field" style="min-width:515px">
            <label class="c-label">계약 유형</label>
            <select name="rentTypeCd" class="c-select" id="f-doc-ext">
              <option value="">전체</option>
              <option value="전세" <c:if test="${rentTypeCd eq '전세'}">selected</c:if>>전세</option>
              <option value="월세" <c:if test="${rentTypeCd eq '월세'}">selected</c:if>>월세</option>
            </select>
          </div>
        </div>
      </div>
    </form>

    <%-- ================================================================ 테이블 ================================================================ --%>
    <div class="c-card c-card--divide">
      <div class="c-card__header">
        <div>
          <div class="c-card__title">서식 목록</div>
          <div class="c-card__sub">총 <span style="color:var(--accent);font-weight:800">${pagingVO.totalRecord}</span>건 · 페이지당 10건</div>
        </div>
      </div>
      <div class="c-table-wrap">
        <table class="c-table" id="docTable">
          <thead>
          <tr>
            <th style="width:80px">서식 번호</th>
            <th style="width:120px">서식명</th>
            <th style="width:150px">아파트 단지 명</th>
            <th style="width:120px">계약 유형</th>
            <th style="width:100px">등록일</th>
            <th style="width:100px">등록자</th>
            <th style="width:80px">관리</th>
          </tr>
          </thead>
          <tbody id="docTbody">
          <c:choose>
            <c:when test="${empty pagingVO.dataList}">
              <tr>
                <td colspan="7">
                  <div class="c-empty">
                    <div class="c-empty__title">등록된 서식이 없습니다</div>
                    <div class="c-empty__sub">우측 상단의 &quot;서식 등록&quot; 버튼으로 첫 서식을 추가해보세요.</div>
                  </div>
                </td>
              </tr>
            </c:when>
            <c:otherwise>
              <c:forEach var="row" items="${pagingVO.dataList}">
                <%-- onclick 제거 → 이벤트 위임으로 처리 --%>
                <%-- deleteContractForm 의 event.stopPropagation 제거 → data-action 으로 처리 --%>
                <tr class="table-click-row"
                    data-frm-no="${row.frmNo}"
                    data-frm-nm="${row.frmNm}"
                    data-apt-nm="${row.aptCmplexNm}"
                    data-rent-type="${row.rentTypeCd}"
                    data-reg-dt="${row.regDt}">
                  <td style="font-weight:700">${row.frmNo}</td>
                  <td>${row.frmNm}</td>
                  <td>${row.aptCmplexNm}</td>
                  <td>${row.rentTypeCd}</td>
                  <td style="color:var(--text-secondary)">${row.regDt}</td>
                  <td>-</td>
                  <td>
                      <%-- onclick 제거 → data-action, data-frm-no 로 위임 처리 --%>
                    <button type="button"
                            class="c-btn c-btn--danger"
                            data-action="delete"
                            data-frm-no="${row.frmNo}">삭제</button>
                  </td>
                </tr>
              </c:forEach>
            </c:otherwise>
          </c:choose>
          </tbody>
        </table>
      </div>

      <div class="c-card__footer" style="justify-content:center">
        <div class="c-pagination">
          <c:if test="${pagingVO.totalPage > 1}">
            <%-- onclick 은 JS 파일의 goPage() 호출 — 페이지네이션만 예외적으로 EL 인라인 유지 --%>
            <button type="button"
                    class="c-pagination__btn <c:if test='${pagingVO.currentPage eq 1}'>is-disabled</c:if>"
                    data-page="${pagingVO.currentPage - 1}">
              <span class="material-symbols-rounded">chevron_left</span>
            </button>
            <c:forEach begin="${pagingVO.startPage}" end="${pagingVO.endPage}" var="i">
              <c:if test="${i <= pagingVO.totalPage}">
                <button type="button"
                        class="c-pagination__btn <c:if test='${pagingVO.currentPage eq i}'>is-active</c:if>"
                        data-page="${i}">${i}</button>
              </c:if>
            </c:forEach>
            <button type="button"
                    class="c-pagination__btn <c:if test='${pagingVO.currentPage eq pagingVO.totalPage}'>is-disabled</c:if>"
                    data-page="${pagingVO.currentPage + 1}">
              <span class="material-symbols-rounded">chevron_right</span>
            </button>
          </c:if>
        </div>
      </div>
    </div>
  </div>
</div>

<%-- ================================================================ 서식 상세 모달 ================================================================ --%>
<%-- onclick 제거 → JS 에서 바인딩 --%>
<div class="c-modal-overlay is-hidden" id="docDetailModalOverlay">
  <div class="c-modal c-modal--lg" role="dialog" aria-modal="true">
    <div class="c-modal__header">
      <h3 class="c-modal__title">서식 상세</h3>
      <button class="c-modal__close" id="btnCloseDetailModal" aria-label="닫기">
        <span class="material-symbols-rounded">close</span>
      </button>
    </div>
    <div class="c-modal__body">
      <div>
        <div class="c-so__section-title">서식 정보</div>
        <div class="c-info-grid">
          <div class="c-info-block"><div class="c-info-field__label">서식번호</div><div class="c-info-field__val" id="detail-frmNo">-</div></div>
          <div class="c-info-block"><div class="c-info-field__label">서식명</div><div class="c-info-field__val" id="detail-frmNm">-</div></div>
          <div class="c-info-block"><div class="c-info-field__label">아파트 단지 명</div><div class="c-info-field__val" id="detail-aptNm">-</div></div>
          <div class="c-info-block"><div class="c-info-field__label">계약 유형</div><div class="c-info-field__val" id="detail-rentType">-</div></div>
          <div class="c-info-block"><div class="c-info-field__label">등록일</div><div class="c-info-field__val" id="detail-regDt">-</div></div>
          <div class="c-info-block"><div class="c-info-field__label">수정일</div><div class="c-info-field__val" id="detail-updDt">-</div></div>
        </div>
        <div style="margin-top:14px">
          <div class="c-so__section-title">첨부 서류</div>
          <div id="so-files"></div>
        </div>
      </div>
    </div>
    <div class="c-modal__footer">
      <button type="button" class="c-btn c-btn--ghost" id="btnModifyDetail">수정</button>
      <button type="button" class="c-btn c-btn--ghost" id="btnCloseDetailModal2">닫기</button>
    </div>
  </div>
</div>

<%-- 삭제 hidden form (DB 연동 부분 — 건드리지 않음) --%>
<form id="deleteDocForm" method="post"
      action="${pageContext.request.contextPath}/centralAdmin/contractFormDelete.do"
      style="display:none;">
  <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
  <input type="hidden" name="frmNo" id="deleteFrmNo" />
</form>

<%-- ================================================================ 서식 등록 모달 ================================================================ --%>
<%-- onclick 제거 → JS 에서 바인딩 --%>
<div class="c-modal-overlay is-hidden" id="docModalOverlay">
  <div class="c-modal c-modal--lg" role="dialog" aria-modal="true">
    <div class="c-modal__header">
      <h3 class="c-modal__title" id="docModalTitle">서식 등록</h3>
      <button class="c-modal__close" id="btnCloseDocModal" aria-label="닫기">
        <span class="material-symbols-rounded">close</span>
      </button>
    </div>

    <div class="c-modal__body">
      <%-- DB 연동 form — action/name 건드리지 않음 --%>
      <form id="docForm" method="post"
            action="${pageContext.request.contextPath}/centralAdmin/contractFormInsert.do"
            enctype="multipart/form-data">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        <input type="hidden" id="docId" value="" name="frmNo"/>
        <input type="hidden" id="docMode" value="create"/>

        <div style="display:flex;flex-direction:column;gap:16px">
          <div class="c-card c-card--divide">
            <div class="c-card__header"><div class="c-card__title">기본 정보</div></div>
            <div class="c-card__body">
              <div style="display:grid;grid-template-columns:1fr 1fr;gap:14px">
                <div class="c-field">
                  <label class="c-label">계약 유형 <span class="req">*</span></label>
                  <select id="d-cat" name="rentTypeCd" class="c-select">
                    <option value="">선택</option>
                    <option value="전세">전세</option>
                    <option value="월세">월세</option>
                  </select>
                  <span class="form-err" id="err-d-cat"></span>
                </div>
                <div class="c-field">
                  <label class="c-label">서식명 <span class="req">*</span></label>
                  <input type="text" id="d-name" name="frmNm" class="c-input" placeholder="예: 표준 임대차계약서" />
                  <span class="form-err" id="err-d-name"></span>
                </div>
                <div class="c-field" style="grid-column:1 / span 2">
                  <label class="c-label">아파트 단지 <span class="req">*</span></label>
                  <select id="d-apt" name="aptCmplexNo" class="c-select">
                    <option value="">선택</option>
                    <c:forEach var="apt" items="${aptList}">
                      <option value="${apt.aptCmplexNo}">${apt.aptCmplexNm}</option>
                    </c:forEach>
                  </select>
                  <span class="form-err" id="err-d-apt"></span>
                </div>
              </div>
            </div>
          </div>

          <div class="c-card c-card--divide">
            <div class="c-card__header">
              <div class="c-card__title">계약 서식 업로드 <%--<span style="font-size:12px;font-weight:600;color:var(--text-tertiary)">(선택)</span>--%></div>
            </div>
            <div class="c-card__body">
              <div class="file-upload-row">
                <label class="c-label" style="width:90px; flex-shrink:0" >서식 파일</label>
                <label class="file-label">
                  <%-- onchange 제거 → JS 에서 바인딩 --%>
                  <input type="file" id="d-file" name="formFile" accept=".pdf,.doc,.docx,.hwp,.xlsx" />
                  <span class="material-symbols-rounded" style="font-size:16px;margin-right:5px">upload</span>파일 선택
                </label>
                <span class="file-fname" id="d-fname">선택된 파일 없음</span>
              </div>
            </div>
          </div>
        </div>
      </form>
    </div>

    <div class="c-modal__footer">
      <button type="button" class="c-btn c-btn--ghost" id="btnCloseDocModal2">닫기</button>
      <button type="button" class="c-btn c-btn--primary" id="docSubmitBtn">
        <span class="material-symbols-rounded">check</span>등록
      </button>
    </div>
  </div>
</div>

</body>
<script>
/* ================================================================
   페이지 이동
================================================================ */
function goPage(page) {
    var max = parseInt(document.getElementById('filterForm').dataset.totalPage, 10) || 1;
    if (page < 1 || page > max) return;
    document.getElementById('f-page').value = page;
    document.getElementById('filterForm').submit();
}

/* ================================================================
   필터
================================================================ */
function applyDocFilter() {
    document.getElementById('f-page').value = '1';
    document.getElementById('filterForm').submit();
}

function resetDocFilter() {
    var form = document.getElementById('filterForm');
    form.querySelectorAll('input[type=text]').forEach(function (el) { el.value = ''; });
    form.querySelectorAll('select').forEach(function (el) { el.value = ''; });
    document.getElementById('f-page').value = '1';
    form.submit();
}

/* ================================================================
   등록 모달
================================================================ */
function openDocModalForCreate() {
    resetDocForm();
    document.getElementById('docModalTitle').textContent = '서식 등록';
    document.getElementById('docSubmitBtn').innerHTML = '<span class="material-symbols-rounded">check</span>등록';
    document.getElementById('docId').value = '';
    document.getElementById('docModalOverlay').classList.remove('is-hidden');
    console.log('[DOC MODE][CREATE]',{
      mode: document.getElementById('docMode')?.value,
      frmNo: document.getElementById('docId')?.value,
      action: document.getElementById('docForm')?.action
    })
}

function closeDocModal() {
    document.getElementById('docModalOverlay').classList.add('is-hidden');
}

/* ================================================================
   상세 모달
================================================================ */
function openDocDetailModal(rowEl) {

  const frmNo = rowEl.dataset.frmNo

  document.getElementById('detail-frmNo').textContent    = rowEl.dataset.frmNo    || '-';
  document.getElementById('detail-frmNm').textContent    = rowEl.dataset.frmNm    || '-';
  document.getElementById('detail-aptNm').textContent    = rowEl.dataset.aptNm    || '-';
  document.getElementById('detail-rentType').textContent = rowEl.dataset.rentType || '-';
  document.getElementById('detail-regDt').textContent    = rowEl.dataset.regDt    || '-';
  document.getElementById('detail-updDt').textContent    = rowEl.dataset.updDt    || '-';
  document.getElementById('docDetailModalOverlay').classList.remove('is-hidden');
  document.getElementById('so-files').innerHTML =
          '<div style="color:var(--text-tertiary);font-size:13px">불러오는중...</div>'

  fetch('/centralAdmin/contractFormDetail.do?frmNo=' + encodeURIComponent(frmNo))
          .then(res => res.json())
          .then(data => {
            document.getElementById('detail-frmNo').textContent = data.frmNo || '-';
            document.getElementById('detail-frmNm').textContent = data.frmNm || '_';
            document.getElementById('detail-aptNm').textContent = data.aptCmplexNm || '_';
            document.getElementById('detail-rentType').textContent = data.rentTypeCd || '_';
            document.getElementById('detail-regDt').textContent = data.regDt || '-';
            document.getElementById('detail-updDt').textContent = data.regDt || '-';
            const files = data.files || [];
            document.getElementById('so-files').innerHTML = files.length === 0
                    ? '<div style="color:var(--text-tertiary);font-size:13px">첨부된 서류가 없습니다.</div>'
                    : files.map(f => {
                      const fileNm = f.fileNm || f.fileOgName || '파일';
                      const atchFileId = f.atchFileId || ((f.fileGroupNo && f.fileSaveUuid) ? `${f.fileGroupNo}_${f.fileSaveUuid}` : '');
                      return `
          <div class="file-row">
            <span class="file-name">
              <span class="material-symbols-rounded" style="font-size:18px;color:var(--text-tertiary)">description</span>
              ${fileNm}
            </span>
            <button type="button" class="c-btn c-btn--ghost c-btn--sm" onclick="viewFile('${atchFileId}')">보기</button>
          </div>
        `;
                    }).join('');

          })
          .catch(() => {
            document.getElementById('so-files').innerHTML =
                    '<div style="color:var(--red);font-size:13px">파일 정보를 불러오지 못했습니다.</div>';
          });
}

document.getElementById('btnModifyDetail')
        .addEventListener('click', function () {
          // 현재 상세 모달에 표시된 데이터로 수정 모달 열기
          var data = {
            frmNo      : document.getElementById('detail-frmNo').textContent,
            frmNm      : document.getElementById('detail-frmNm').textContent,
            aptCmplexNm: document.getElementById('detail-aptNm').textContent,
            rentTypeCd : document.getElementById('detail-rentType').textContent
          };
          closeDocDetailModal();
          openDocModalForEdit(data);
        });



function closeDocDetailModal() {
  document.getElementById('docDetailModalOverlay').classList.add('is-hidden');
}

/* ================================================================
   수정
================================================================ */
function openDocModalForEdit(data){

  resetDocForm();
  document.getElementById('docMode').value = 'edit';
  document.getElementById('docId').value = data.frmNo;

  document.getElementById('docModalTitle').textContent = '서식 수정';
  document.getElementById('docSubmitBtn').innerHTML = '<span class="material-symbols-rounded">check</span>수정 저장';

  document.getElementById('docForm').action = '/central/contractFormUpdate.do';

  document.getElementById('d-name').value = data.frmNm || '';
  document.getElementById('d-cat').value  = data.rentTypeCd || '';
  document.getElementById('d-apt').value  = data.aptCmplexNo || '';

  document.getElementById('docModalOverlay').classList.remove('is-hidden');
}

/* ================================================================
   삭제
================================================================ */
function deleteContractForm(frmNo) {
    if (!frmNo) return;
    if (!confirm('선택한 서식을 삭제하시겠습니까?')) return;
    document.getElementById('deleteFrmNo').value = frmNo;
    document.getElementById('deleteDocForm').submit();
}

/* ================================================================
   폼 초기화
================================================================ */
function resetDocForm() {
    document.getElementById('d-cat').value  = '';
    document.getElementById('d-name').value = '';
    var apt = document.getElementById('d-apt');
    if (apt) apt.value = '';
    document.getElementById('d-file').value = '';
    document.getElementById('d-fname').textContent = '선택된 파일 없음';
    document.getElementById('err-d-cat').textContent  = '';
    document.getElementById('err-d-name').textContent = '';
    var eapt = document.getElementById('err-d-apt');
    if (eapt) eapt.textContent = '';
}

/* ================================================================
   파일명 표시
================================================================ */
function showDocFileName(input) {
    document.getElementById('d-fname').textContent =
        input.files.length > 0 ? input.files[0].name : '선택된 파일 없음';
}

/* ================================================================
   유효성 검사 & 제출
================================================================ */
function submitDocForm() {
  var valid = true;

  function setErr(inputId, errId, msg) {
    var el    = document.getElementById(inputId);
    var err   = document.getElementById(errId);
    var empty = !el.value || !String(el.value).trim();
    el.style.borderColor = empty ? 'var(--red)' : '';
    err.textContent      = empty ? msg : '';
    if (empty) valid = false;
  }

  setErr('d-cat',  'err-d-cat',  '계약 유형을 선택해주세요');
  setErr('d-name', 'err-d-name', '서식명을 입력해주세요');
  setErr('d-apt',  'err-d-apt',  '아파트 단지를 선택해주세요');

  if (!valid) return;

  const mode = document.getElementById('docMode').value;

  if (mode !== 'edit') {
    document.getElementById('docForm').submit();
    return;
  }

  const form = document.getElementById('docForm');
  const fd = new FormData(form);
  const csrfToken  = form.querySelector('input[name="${_csrf.parameterName}"]').value;
  const csrfHeader = '${_csrf.headerName}';

  fetch(form.action, {
    method: 'POST',
    headers: { [csrfHeader]: csrfToken },
    body: fd
  })
          .then(res => { if (!res.ok) throw new Error(res.status); return res.json(); })
          .then(data => {
            if (!data.success) throw new Error(data.message || '수정 실패');
            closeDocModal();
            alert('수정되었습니다.');
            document.getElementById('filterForm').submit();
          })
          .catch(err => alert('오류: ' + err));
}

/* ================================================================
   DOMContentLoaded — 이벤트 바인딩
================================================================ */
document.addEventListener('DOMContentLoaded', function () {

    /* 등록 버튼 */
    document.getElementById('btnOpenCreate')
        .addEventListener('click', openDocModalForCreate);
    console.log('[DOC MODE][CREATE]',{
      mode: document.getElementById('docMode')?.value,
      frmNo: document.getElementById('docId')?.value,
      action: document.getElementById('docForm')?.action
    })
    /* 필터 버튼 */
    document.getElementById('btnResetFilter')
        .addEventListener('click', resetDocFilter);
    document.getElementById('btnApplyFilter')
        .addEventListener('click', applyDocFilter);

    /* 페이지네이션 위임 */
    var pagination = document.querySelector('.c-pagination');
    if (pagination) {
        pagination.addEventListener('click', function (e) {
            var btn = e.target.closest('[data-page]');
            if (!btn || btn.classList.contains('is-disabled')) return;
            goPage(parseInt(btn.dataset.page, 10));
        });
    }

    /* 테이블 이벤트 위임 (행 클릭 + 삭제) */
    document.getElementById('docTbody')
        .addEventListener('click', function (e) {
            var delBtn = e.target.closest('[data-action="delete"]');
            if (delBtn) {
                deleteContractForm(delBtn.dataset.frmNo);
                return;
            }
            var row = e.target.closest('.table-click-row');
            if (row) openDocDetailModal(row);
        });

    /* 오버레이 클릭으로 모달 닫기 */
    document.getElementById('docDetailModalOverlay')
        .addEventListener('click', function (e) {
            if (e.target === this) closeDocDetailModal();
        });
    document.getElementById('docModalOverlay')
        .addEventListener('click', function (e) {
            if (e.target === this) closeDocModal();
        });

    /* 모달 닫기 버튼 */
    document.getElementById('btnCloseDetailModal')
        .addEventListener('click', closeDocDetailModal);
    document.getElementById('btnCloseDetailModal2')
        .addEventListener('click', closeDocDetailModal);
    document.getElementById('btnCloseDocModal')
        .addEventListener('click', closeDocModal);
    document.getElementById('btnCloseDocModal2')
        .addEventListener('click', closeDocModal);

    /* 등록 제출 버튼 */
    document.getElementById('docSubmitBtn')
        .addEventListener('click', submitDocForm);

    /* 파일 input */
    document.getElementById('d-file')
        .addEventListener('change', function () {
            showDocFileName(this);
        });
});
</script>

</html>
