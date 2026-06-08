<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!doctype html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1.0" />
  <title>우리집맵핑 · 계약 관리</title>
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
  <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/centralAside.css" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/centralHeader.css" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/centralCommon.css" />
  <script defer src="${pageContext.request.contextPath}/js/centralAdmin/toggleSidebar.js"></script>
  <script defer src="${pageContext.request.contextPath}/js/centralHeader.js"></script>
  <style>
    .so-textarea {
      width: 100%;
      padding: 10px 12px;
      border: 1px solid var(--border);
      border-radius: var(--r-sm);
      font-size: 13px;
      font-family: inherit;
      resize: vertical;
      outline: none;
      color: var(--text-primary);
    }
    .so-textarea:focus { border-color: var(--accent); }
    .so-textarea.is-error { border-color: var(--red); }
    #so-footer { width: 100%; }
    .so-modal-footer {
      display: flex;
      width: 100%;
      align-items: center;
      justify-content: space-between;
      gap: 12px;
      flex-wrap: wrap;
    }
    .so-modal-footer__actions {
      display: flex;
      gap: 8px;
      flex-wrap: wrap;
      align-items: center;
      margin-left: auto;
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
    <%-- onclick 제거 → toggleSidebar.js 에서 처리 --%>
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
      <a href="${pageContext.request.contextPath}/centralAdmin/contractList.do" class="nav-item active"><span class="material-symbols-rounded nav-icon">contract</span><span class="nav-text">계약 관리</span></a>
      <a href="${pageContext.request.contextPath}/centralAdmin/contractDoc.do"  class="nav-item"><span class="material-symbols-rounded nav-icon">description</span><span class="nav-text">서류 관리</span></a>
      <a href="${pageContext.request.contextPath}/centralAdmin/contractForm.do" class="nav-item"><span class="material-symbols-rounded nav-icon">edit_document</span><span class="nav-text">서식 관리</span></a>
      <a href="${pageContext.request.contextPath}/centralAdmin/statistics"      class="nav-item"><span class="material-symbols-rounded nav-icon">bar_chart_4_bars</span><span class="nav-text">통계</span></a>
    </div>
    <div class="section-divider"></div>
    <div class="nav-group">
      <span class="section-label">민원 · 소통</span>
      <a href="${pageContext.request.contextPath}/centralAdmin/civilCom"     class="nav-item"><span class="material-symbols-rounded nav-icon">support_agent</span><span class="nav-text">민원 관리</span><span class="nav-badge">3</span></a>
      <a href="${pageContext.request.contextPath}/centralAdmin/ai"           class="nav-item"><span class="material-symbols-rounded nav-icon">forum</span><span class="nav-text">문의 관리</span><span class="nav-badge yellow">4</span></a>
      <a href="${pageContext.request.contextPath}/centralAdmin/announcement" class="nav-item"><span class="material-symbols-rounded nav-icon">campaign</span><span class="nav-text">공고 관리</span></a>
      <a href="${pageContext.request.contextPath}/centralAdmin/notice"       class="nav-item"><span class="material-symbols-rounded nav-icon">article</span><span class="nav-text">통합 게시판 관리</span></a>
    </div>
    <div class="section-divider"></div>
    <div class="nav-group">
      <span class="section-label">시설 · 시스템</span>
      <a href="${pageContext.request.contextPath}/centralAdmin/facility"   class="nav-item"><span class="material-symbols-rounded nav-icon">handyman</span><span class="nav-text">시설 관리</span></a>
      <a href="${pageContext.request.contextPath}/centralAdmin/proHistory" class="nav-item"><span class="material-symbols-rounded nav-icon">warning</span><span class="nav-text">비정상 세대 관리</span></a>
      <a href="${pageContext.request.contextPath}/centralAdmin/mngrRqstAprv"   class="nav-item"><span class="material-symbols-rounded nav-icon">manage_accounts</span><span class="nav-text">단지관리자 계정</span></a>
    </div>
  </nav>
  <div class="admin-card">
    <div class="admin-avatar"><span class="material-symbols-rounded" style="color:#fff;font-size:18px">person</span></div>
    <div class="admin-info"><p>중앙관리자</p><span>클로드 최고</span></div>
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
      <span class="bc-current">계약 관리</span>
    </div>
    <div class="topbar-actions">
      <button class="topbar-icon-btn" data-tooltip="알림"><span class="material-symbols-rounded">notifications</span><div class="dot"></div></button>
      <button class="topbar-icon-btn" data-tooltip="설정"><span class="material-symbols-rounded">settings</span></button>
    </div>
  </div>

  <div class="main-content">
    <div class="page-header">
      <div>
        <div class="page-title">계약 관리</div>
        <div class="page-subtitle">전·월세 계약 신청을 검토하고 오프라인 계약을 직접 등록합니다.</div>
      </div>
      <div class="page-header__right">
        <%-- onclick 제거 → id 부여 --%>
        <button class="c-btn c-btn--primary" id="btnOpenRegister">
          <span class="material-symbols-rounded">add</span>계약 등록
        </button>
      </div>
    </div>

    <%-- ================================================================ 필터 폼 ================================================================ --%>
    <form id="filterForm" method="get"
          action="${pageContext.request.contextPath}/centralAdmin/contractList.do"
          data-total-page="${pagingVO.totalPage}">
      <input type="hidden" name="page" id="f-page" value="1" />
      <div class="c-card c-card--divide" style="margin-bottom:16px">
        <div class="c-card__header">
          <div>
            <div class="c-card__title">검색 조건</div>
            <div class="c-card__sub">조건을 입력하면 계약 목록이 필터링됩니다.</div>
          </div>
          <div class="c-card__actions">
            <%-- onclick 제거 → id 부여 --%>
            <button type="button" class="c-btn c-btn--ghost" id="btnResetFilter">
              <span class="material-symbols-rounded">refresh</span>초기화
            </button>
            <button type="submit" class="c-btn c-btn--primary">
              <span class="material-symbols-rounded">search</span>검색
            </button>
          </div>
        </div>
        <div class="c-card__body c-filter-row">
          <div class="c-field" style="min-width:170px">
            <label class="c-label">계약 번호</label>
            <input type="text" class="c-input" name="ctrtNo" placeholder="예: CTR-001" value="${param.ctrtNo}" />
          </div>
          <div class="c-field" style="min-width:190px">
            <label class="c-label">계약 유형</label>
            <select class="c-select" name="type">
              <option value="">전체 계약</option>
              <option value="전세" <c:if test="${param.type eq '전세'}">selected</c:if>>전세계약</option>
              <option value="월세" <c:if test="${param.type eq '월세'}">selected</c:if>>월세계약</option>
            </select>
          </div>
          <div class="c-field" style="min-width:350px">
            <label class="c-label">회원 ID</label>
            <input type="text" class="c-input" name="user" placeholder="회원 ID 검색" value="${param.user}" />
          </div>
          <div class="c-field" style="min-width:350px">
            <label class="c-label">상태</label>
            <select class="c-select" name="status">
              <option value="">전체 상태</option>
              <option value="APR" <c:if test="${param.status eq 'APR'}">selected</c:if>>승인됨</option>
              <option value="RJC" <c:if test="${param.status eq 'RJC'}">selected</c:if>>반려</option>
            </select>
          </div>
          <div class="c-field" style="min-width:350px">
            <label class="c-label">만료 임박</label>
            <select class="c-select" name="expiry">
              <option value="">전체</option>
              <option value="30"      <c:if test="${param.expiry eq '30'}">selected</c:if>>30일 이내 만료</option>
              <option value="90"      <c:if test="${param.expiry eq '90'}">selected</c:if>>90일 이내 만료</option>
              <option value="expired" <c:if test="${param.expiry eq 'expired'}">selected</c:if>>만료됨</option>
            </select>
          </div>
        </div>
      </div>
    </form>

    <%-- ================================================================ 테이블 ================================================================ --%>
    <div class="c-card c-card--divide">
      <div class="c-card__header">
        <div>
          <div class="c-card__title">계약 관리</div>
          <div class="c-card__sub">
            총 <span style="color:var(--accent);font-weight:800">${pagingVO.totalRecord}</span>건 · 페이지당 10건
          </div>
        </div>
      </div>
      <div class="c-table-wrap">
        <table class="c-table">
          <thead>
          <tr>
            <th style="width: 80px">계약 번호</th>
            <th style="width: 40px">계약 유형</th>
            <th style="width: 100px">회원 ID</th>
            <th style="width: 180px">아파트</th>
            <th style="width: 100px">계약 기간</th>
            <th style="width: 100px">계약일</th>
            <th style="width: 100px">담당자명</th>
            <th style="width: 40px">상태</th>
          </tr>
          </thead>
          <tbody id="contractTbody">
          <c:choose>
            <c:when test="${empty pagingVO.dataList}">
              <tr>
                <td colspan="8">
                  <div class="c-empty">
                    <div class="c-empty__title">조회된 계약이 없습니다</div>
                    <div class="c-empty__sub">조건을 변경하여 다시 검색해주세요.</div>
                  </div>
                </td>
              </tr>
            </c:when>
            <c:otherwise>
              <c:forEach var="ct" items="${pagingVO.dataList}">
                <%-- onclick 제거 → data-ctrt-no 로 이벤트 위임 처리 --%>
                <tr class="table-click-row" style="cursor:pointer" data-ctrt-no="${ct.rentCtrtNo}">
                  <td style="font-weight:700">${ct.rentCtrtNo}</td>
                  <td>${not empty ct.rentTypeCd ? ct.rentTypeCd : ct.rentTypeCd}</td>
                  <td>${ct.userId}</td>
                  <td>${ct.aptCmplexNm}</td>
                  <td>
                    <c:choose>
                      <c:when test="${not empty ct.mvinDt and not empty ct.mvoutDt}">
                        ${ct.mvinDt} ~ ${ct.mvoutDt}
                      </c:when>
                      <c:otherwise>-</c:otherwise>
                    </c:choose>
                  </td>
                  <td style="color:var(--text-secondary)">${ct.regDt}</td>
                  <td>${not empty ct.mgrNm ? ct.mgrNm : '-'}</td>
                  <td>
                    <c:choose>
                      <c:when test="${ct.ctrtSttsCd eq 'SUB'}"><span class="c-badge c-badge--pending">접수대기</span></c:when>
                      <c:when test="${ct.ctrtSttsCd eq 'APR'}"><span class="c-badge c-badge--active">승인됨</span></c:when>
                      <c:when test="${ct.ctrtSttsCd eq 'RJC'}"><span class="c-badge c-badge--danger">반려</span></c:when>
                      <c:otherwise><span class="c-badge">${ct.ctrtSttsCd}</span></c:otherwise>
                    </c:choose>
                  </td>
                </tr>
              </c:forEach>
            </c:otherwise>
          </c:choose>
          </tbody>
        </table>
      </div>

      <%-- 페이지네이션 — EL 값이 필요해서 onclick 예외적으로 유지 --%>
      <div class="c-card__footer" style="justify-content:center">
        <div class="c-pagination">
          <c:if test="${pagingVO.totalPage > 1}">
            <button type="button"
                    class="c-pagination__btn ${pagingVO.currentPage eq 1 ? 'is-disabled' : ''}"
                    onclick="goPage(${pagingVO.currentPage - 1})">
              <span class="material-symbols-rounded">chevron_left</span>
            </button>
            <c:forEach begin="${pagingVO.startPage}" end="${pagingVO.endPage}" var="i">
              <c:if test="${i <= pagingVO.totalPage}">
                <button type="button"
                        class="c-pagination__btn ${pagingVO.currentPage eq i ? 'is-active' : ''}"
                        onclick="goPage(${i})">${i}</button>
              </c:if>
            </c:forEach>
            <button type="button"
                    class="c-pagination__btn ${pagingVO.currentPage eq pagingVO.totalPage ? 'is-disabled' : ''}"
                    onclick="goPage(${pagingVO.currentPage + 1})">
              <span class="material-symbols-rounded">chevron_right</span>
            </button>
          </c:if>
        </div>
      </div>
    </div>
  </div>
</div>

<%-- ================================================================ 계약 등록 모달 ================================================================ --%>
<%-- onclick 제거 → JS 에서 바인딩 --%>
<div class="c-modal-overlay is-hidden" id="registerOverlay">
  <div class="c-modal c-modal--lg" role="dialog" aria-modal="true">

    <div class="c-modal__header">
      <h3 class="c-modal__title" id="registerModalTitle">등록</h3>
      <%-- onclick 제거 → id 부여 --%>
      <button class="c-modal__close" id="btnCloseRegister" aria-label="닫기">
        <span class="material-symbols-rounded">close</span>
      </button>
    </div>

    <div class="c-modal__body">
      <%-- DB 연동 form — action/name 건드리지 않음 --%>
      <form id="registerForm" method="post"
            action="${pageContext.request.contextPath}/centralAdmin/contractInsert.do"
            enctype="multipart/form-data">

        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        <input type="hidden" id="reg-rent-ctrt-no" value="" />

        <div style="display:flex;flex-direction:column;gap:16px">

          <div class="c-card c-card--divide">
            <div class="c-card__header"><div class="c-card__title">계약 기본 정보</div></div>
            <div class="c-card__body">
              <div style="display:grid;grid-template-columns:1fr 1fr;gap:14px">

                <div class="c-field">
                  <label class="c-label">회원 ID <span class="req">*</span></label>
                  <input type="text" id="r-user" name="userNo" class="c-input" placeholder="회원 ID 입력" />
                  <span class="form-err" id="err-user"></span>
                </div>

                <div class="c-field">
                  <label class="c-label">매물번호 <span class="req">*</span></label>
                  <input type="text" id="r-apt" name="rentLstgNo" class="c-input" placeholder="매물번호 입력 (예: 1)" />
                  <span class="form-err" id="err-apt"></span>
                </div>

                <div class="c-field">
                  <label class="c-label">계약 유형 <span class="req">*</span></label>
                  <select id="r-type" name="ctrtId" class="c-select">
                    <option value="">선택</option>
                    <option value="전세">전세계약</option>
                    <option value="월세">월세계약</option>
                  </select>
                  <span class="form-err" id="err-type"></span>
                </div>

                <div class="c-field">
                  <label class="c-label">계약 상태</label>
                  <input type="text" class="c-input" value="승인대기" disabled
                         style="background:var(--gray-soft);color:var(--text-tertiary);cursor:not-allowed" />
                </div>

              </div>
            </div>
          </div>

          <div class="c-card c-card--divide">
            <div class="c-card__header"><div class="c-card__title">계약 정보</div></div>
            <div class="c-card__body">
              <div style="display:grid;grid-template-columns:1fr 1fr;gap:14px">

                <div class="c-field">
                  <label class="c-label">계약 금액</label>
                  <input type="number" id="r-ctrt-amt" name="ctrtAmt" class="c-input" placeholder="원 단위 입력" min="0" />
                </div>

                <div class="c-field">
                  <label class="c-label">보증금</label>
                  <input type="number" id="r-dpst-amt" name="dpstAmt" class="c-input" placeholder="원 단위 입력" min="0" />
                </div>

                <div class="c-field">
                  <label class="c-label">계약 시작일</label>
                  <input type="date" id="r-start" name="mvinDt" class="c-input" />
                </div>

                <div class="c-field">
                  <label class="c-label">계약 종료일</label>
                  <input type="date" id="r-end" name="mvoutDt" class="c-input" />
                  <span class="form-err" id="err-date"></span>
                </div>

              </div>
            </div>
          </div>

          <div class="c-card c-card--divide">
            <div class="c-card__header"><div class="c-card__title">계약 서류 업로드</div></div>
            <div class="c-card__body">
              <div style="display:flex;flex-direction:column;gap:10px">

                <div class="file-upload-row">
                  <label class="c-label" style="width:90px;flex-shrink:0">주민등록등본</label>
                  <label class="file-label">
                    <%-- onchange 제거 → JS 에서 바인딩 --%>
                    <input type="file" id="contractFile" name="contractFile" accept=".pdf,.doc,.docx" />
                    <span class="material-symbols-rounded" style="font-size:16px;margin-right:5px">upload</span>파일 선택
                  </label>
                  <span class="file-fname" id="fname1">선택된 파일 없음</span>
                </div>

                <div class="file-upload-row">
                  <label class="c-label" style="width:90px;flex-shrink:0">가족관계증명서</label>
                  <label class="file-label">
                    <input type="file" id="idFile" name="idFile" accept=".pdf,.jpg,.png" />
                    <span class="material-symbols-rounded" style="font-size:16px;margin-right:5px">upload</span>파일 선택
                  </label>
                  <span class="file-fname" id="fname2">선택된 파일 없음</span>
                </div>

                <div class="file-upload-row">
                  <label class="c-label" style="width:90px;flex-shrink:0">금융정보제공동의서</label>
                  <label class="file-label">
                    <input type="file" id="etcFile" name="etcFile" accept=".pdf,.doc,.docx" />
                    <span class="material-symbols-rounded" style="font-size:16px;margin-right:5px">upload</span>파일 선택
                  </label>
                  <span class="file-fname" id="fname3">선택된 파일 없음</span>
                </div>

              </div>
            </div>
          </div>

        </div>
      </form>
    </div>

    <div class="c-modal__footer">
      <%-- onclick 제거 → id 부여 --%>
      <button type="button" class="c-btn c-btn--ghost" id="btnCloseRegister2">닫기</button>
      <button type="button" class="c-btn c-btn--primary" id="registerSubmitBtn">
        <span class="material-symbols-rounded">check</span>계약 등록
      </button>
    </div>

  </div>
</div>

<%-- ================================================================ 계약 상세 모달 ================================================================ --%>
<%-- onclick 제거 → JS 에서 바인딩 --%>
<div class="c-modal-overlay is-hidden" id="overlay">
  <div class="c-modal c-modal--lg" role="dialog" aria-modal="true">

    <div class="c-modal__header">
      <h3 class="c-modal__title">계약 상세</h3>
      <%-- onclick 제거 → id 부여 --%>
      <button class="c-modal__close" id="btnClosePanel" aria-label="닫기">
        <span class="material-symbols-rounded">close</span>
      </button>
    </div>

    <div class="c-modal__body">
      <div>
        <div class="c-so__section-title">계약 정보</div>
        <div class="c-info-grid" id="so-info"></div>
      </div>
      <div style="margin-top:14px">
        <div class="c-so__section-title">첨부 서류</div>
        <div id="so-files"></div>
      </div>
      <div id="so-reject-section" style="margin-top:14px;display:none">
        <div class="c-so__section-title">반려 사유 <span class="req">*</span></div>
        <textarea class="so-textarea" id="so-reason" rows="3" placeholder="반려 시 사유 입력"></textarea>
        <span class="form-err" id="err-reason"></span>
      </div>
    </div>

    <%-- renderDetail() 에서 동적으로 버튼 생성하는 부분 — DB 연동이라 건드리지 않음 --%>
    <div class="c-modal__footer" id="so-footer"></div>

  </div>
</div>

<script>
  var currentCtrtNo = null;

  /* ================================================================
     페이지네이션
  ================================================================ */
  function goPage(page) {
    var max = parseInt(document.getElementById('filterForm').dataset.totalPage, 10) || 1;
    if (page < 1 || page > max) return;
    document.getElementById('f-page').value = page;
    document.getElementById('filterForm').submit();
  }

  /* ================================================================
     필터 초기화
  ================================================================ */
  function resetFilter() {
    var form = document.getElementById('filterForm');
    form.querySelectorAll('input[type=text]').forEach(function(el){ el.value = ''; });
    form.querySelectorAll('select').forEach(function(el){ el.value = ''; });
    document.getElementById('f-page').value = '1';
    form.submit();
  }

  /* ================================================================
     엑셀 출력 — TODO: URL 수정
  ================================================================ */
  function excelDownload() {
    var form = document.getElementById('filterForm');
    var origin = form.action;
    form.action = '/central/contractExcel.do';
    form.target = '_blank';
    form.submit();
    form.action = origin;
    form.target = '';
  }

  /* ================================================================
     등록 모달
  ================================================================ */
  function resetRegisterFormForInsert() {
    var form = document.getElementById('registerForm');
    form.action = '/central/contractInsert.do';
    document.getElementById('registerModalTitle').textContent = '등록';
    document.getElementById('registerSubmitBtn').innerHTML =
            '<span class="material-symbols-rounded">check</span>등록';
    var hid = document.getElementById('reg-rent-ctrt-no');
    if (hid) {
      hid.removeAttribute('name');
      hid.value = '';
    }
    document.getElementById('r-user').value     = '';
    document.getElementById('r-apt').value      = '';
    document.getElementById('r-type').value     = '';
    document.getElementById('r-ctrt-amt').value = '';
    document.getElementById('r-dpst-amt').value = '';
    document.getElementById('r-start').value    = '';
    document.getElementById('r-end').value      = '';
    document.querySelectorAll('#registerForm input[type="file"]').forEach(function(inp) { inp.value = ''; });
    ['fname1','fname2','fname3'].forEach(function(id) {
      document.getElementById(id).textContent = '선택된 파일 없음';
      document.getElementById(id).style.color = 'var(--text-tertiary)';
    });
    ['err-user','err-apt','err-type','err-date'].forEach(function(id) {
      var e = document.getElementById(id);
      if (e) e.textContent = '';
    });
  }

  function openRegisterModal() {
    resetRegisterFormForInsert();
    document.getElementById('registerOverlay').classList.remove('is-hidden');
  }

  function closeRegisterModal() {
    document.getElementById('registerOverlay').classList.add('is-hidden');
  }

  /* ================================================================
     날짜 변환 유틸
  ================================================================ */
  function toInputDate(v) {
    if (v == null || v === '') return '';
    if (typeof v === 'string' && /^\d{4}-\d{2}-\d{2}/.test(v)) return v.substring(0, 10);
    if (typeof v === 'number' && !isNaN(v)) {
      var d0 = new Date(v);
      if (!isNaN(d0.getTime())) return d0.toISOString().substring(0, 10);
    }
    var d = new Date(v);
    if (!isNaN(d.getTime())) return d.toISOString().substring(0, 10);
    return '';
  }

  /* ================================================================
     계약 수정 모달 열기 (fetch — DB 연동 부분 건드리지 않음)
  ================================================================ */
  function openContractEdit() {
    var no = currentCtrtNo;
    if (!no) return;
    fetch('/centralAdmin/contractDetail.do?ctrtNo=' + encodeURIComponent(no))
            .then(function(res) { if (!res.ok) throw new Error(); return res.json(); })
            .then(function(data) {
              closePanel();
              ['fname1','fname2','fname3'].forEach(function(id) {
                document.getElementById(id).textContent = '선택된 파일 없음';
                document.getElementById(id).style.color = 'var(--text-tertiary)';
              });
              document.querySelectorAll('#registerForm input[type="file"]').forEach(function(inp) { inp.value = ''; });
              var form = document.getElementById('registerForm');
              form.action = '/central/contractUpdate.do';
              document.getElementById('registerModalTitle').textContent = '계약 수정';
              document.getElementById('registerSubmitBtn').innerHTML =
                      '<span class="material-symbols-rounded">check</span>수정 저장';
              var hid = document.getElementById('reg-rent-ctrt-no');
              hid.setAttribute('name', 'rentCtrtNo');
              hid.value = data.rentCtrtNo || '';
              document.getElementById('r-user').value     = data.userNo != null && data.userNo !== '' ? data.userNo : '';
              document.getElementById('r-apt').value      = data.rentLstgNo != null ? data.rentLstgNo : '';
              var tid = (data.ctrtId && String(data.ctrtId)) || '';
              if (!tid && data.rentTypeCd) {
                tid = (String(data.rentTypeCd).indexOf('월') >= 0) ? '월세' : '전세';
              }
              document.getElementById('r-type').value     = tid;
              document.getElementById('r-ctrt-amt').value = (data.ctrtAmt != null && data.ctrtAmt !== '') ? data.ctrtAmt : '';
              document.getElementById('r-dpst-amt').value = (data.dpstAmt != null && data.dpstAmt !== '') ? data.dpstAmt : '';
              document.getElementById('r-start').value    = toInputDate(data.mvinDt);
              document.getElementById('r-end').value      = toInputDate(data.mvoutDt);
              document.getElementById('registerOverlay').classList.remove('is-hidden');
            })
            .catch(function() { alert('계약 정보를 불러오지 못했습니다.'); });
  }

  /* ================================================================
     등록 유효성 검사 & submit
  ================================================================ */
  function submitRegister() {
    var valid = true;

    function setErr(inputId, errId, msg) {
      var el    = document.getElementById(inputId);
      var err   = document.getElementById(errId);
      var empty = !el.value.trim();
      el.style.borderColor = empty ? 'var(--red)' : '';
      err.textContent      = empty ? msg : '';
      if (empty) valid = false;
    }

    setErr('r-user', 'err-user', '회원 ID를 입력해주세요');
    setErr('r-apt',  'err-apt',  '매물번호를 입력해주세요');
    setErr('r-type', 'err-type', '계약 유형을 선택해주세요');

    var start   = document.getElementById('r-start').value;
    var end     = document.getElementById('r-end').value;
    var endEl   = document.getElementById('r-end');
    var errDate = document.getElementById('err-date');
    if (start && end && end < start) {
      endEl.style.borderColor = 'var(--red)';
      errDate.textContent     = '종료일은 시작일 이후여야 합니다';
      valid = false;
    } else {
      endEl.style.borderColor = '';
      errDate.textContent     = '';
    }

    if (!valid) return;
    document.getElementById('registerForm').submit();
  }

  /* ================================================================
     파일명 표시
  ================================================================ */
  function showFileName(input, targetId) {
    var el = document.getElementById(targetId);
    el.textContent = input.files[0] ? input.files[0].name : '선택된 파일 없음';
    el.style.color = input.files[0] ? 'var(--text-primary)' : 'var(--text-tertiary)';
  }

  /* ================================================================
     계약 상세 모달 (fetch — DB 연동 부분 건드리지 않음)
  ================================================================ */
  function openPanel(rentCtrtNo) {
    currentCtrtNo = rentCtrtNo;
    document.getElementById('so-info').innerHTML   = '<div style="color:var(--text-tertiary);font-size:13px;padding:12px 0">불러오는 중...</div>';
    document.getElementById('so-files').innerHTML  = '';
    document.getElementById('so-footer').innerHTML = '';
    document.getElementById('so-reject-section').style.display = 'none';
    document.getElementById('so-reason').value        = '';
    document.getElementById('err-reason').textContent = '';
    document.getElementById('overlay').classList.remove('is-hidden');

    fetch('/centralAdmin/contractDetail.do?ctrtNo=' + encodeURIComponent(rentCtrtNo))
            .then(function(res){ if(!res.ok) throw new Error(res.status); return res.json(); })
            .then(function(data){ renderDetail(data); console.log(data); })
            .catch(function(err){
              document.getElementById('so-info').innerHTML =
                      '<div style="color:var(--red);font-size:13px">데이터를 불러오지 못했습니다.</div>';
              console.error(err);
            });
  }

  function renderDetail(data) {
    var BADGE = { 'SUB':'c-badge--pending', 'APR':'c-badge--active', 'RJC':'c-badge--danger' };
    var rows = [
      ['계약번호',  data.rentCtrtNo  || '-'],
      ['계약 유형', data.rentTypeCd  || '-'],
      ['회원 ID',   data.userId      || '-'],
      ['아파트',    data.aptCmplexNm || '-'],
      ['계약 금액', data.ctrtAmt     || '-'],
      ['보증금',    data.dpstAmt     || '-'],
      ['계약 기간', (data.mvinDt && data.mvoutDt) ? data.mvinDt + ' ~ ' + data.mvoutDt : '-'],
      ['현재 상태', '<span class="c-badge ' + (BADGE[data.ctrtSttsCd]||'') + '">' + (data.ctrtSttsNm||data.ctrtSttsCd||'-') + '</span>']

    ];
    document.getElementById('so-info').innerHTML = rows.map(function(r){
      return '<div class="c-info-block"><div class="c-info-field__label">' + r[0] + '</div><div class="c-info-field__val">' + r[1] + '</div></div>';
    }).join('');

    var files = data.files || [];
    document.getElementById('so-files').innerHTML = files.length === 0
            ? '<div style="color:var(--text-tertiary);font-size:13px">첨부된 서류가 없습니다.</div>'
            : files.map(function(f){
              return '<div class="file-row"><span class="file-name">'
                      + '<span class="material-symbols-rounded" style="font-size:18px;color:var(--text-tertiary)">description</span>'
                      + f.fileNm + '</span>'
                      + '<button class="c-btn c-btn--ghost c-btn--sm" onclick="viewFile(\'' + f.atchFileId + '\')">보기</button></div>';
            }).join('');

    document.getElementById('so-reject-section').style.display =
            data.ctrtSttsCd === 'APR' ? 'none' : '';

    document.getElementById('so-footer').innerHTML = data.ctrtSttsCd === 'SUB'
            ? '<button type="button" class="c-btn c-btn--danger" onclick="doReject()"><span class="material-symbols-rounded">close</span>반려</button>'
            + '<button type="button" class="c-btn c-btn--primary" onclick="doApprove()"><span class="material-symbols-rounded">check</span>승인</button>'
            + '<button type="button" class="c-btn c-btn--ghost" onclick="closePanel()">닫기</button>'
            : '<button type="button" class="c-btn c-btn--ghost" onclick="closePanel()">닫기</button>';
  }

  function closePanel() {
    document.getElementById('overlay').classList.add('is-hidden');
    currentCtrtNo = null;
  }

  /* ================================================================
     승인 / 반려 (fetch — DB 연동 부분 건드리지 않음)
  ================================================================ */
  function doApprove() {
    if (!confirm('승인하시겠습니까?')) return;
    updateStatus('APR', null);
  }

  function doReject() {
    var reason = document.getElementById('so-reason').value.trim();
    var errEl  = document.getElementById('err-reason');
    if (!reason) {
      document.getElementById('so-reason').classList.add('is-error');
      errEl.textContent = '반려 사유를 입력해주세요.';
      return;
    }
    errEl.textContent = '';
    document.getElementById('so-reason').classList.remove('is-error');
    if (!confirm('반려 처리하시겠습니까?')) return;
    updateStatus('RJC', reason);
  }

  function updateStatus(status, reason) {
    var csrfToken  = '${_csrf.token}';
    var csrfHeader = '${_csrf.headerName}';
    var body = 'rentCtrtNo=' + encodeURIComponent(currentCtrtNo)
            + '&status='   + encodeURIComponent(status);
    if (reason) body += '&rejectReason=' + encodeURIComponent(reason);

    fetch('/centralAdmin/contractModifyStatus', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        [csrfHeader]: csrfToken
      },
      body: body
    })
            .then(function(res){ return res.json(); })
            .then(function(result){
              if (result.success) {
                alert(status === 'APR' ? '승인되었습니다.' : '반려 처리되었습니다.');
                closePanel();
                document.getElementById('filterForm').submit();
              } else {
                alert('오류: ' + (result.message || '처리 실패'));
              }
            })
            .catch(function(){ alert('서버 통신 오류가 발생했습니다.'); });
  }

  /* ================================================================
     파일 보기 — TODO: URL 수정
  ================================================================ */
  function viewFile(atchFileId) {
    window.open('/central/fileDownload.do?atchFileId=' + encodeURIComponent(atchFileId), '_blank');
  }

  /* ================================================================
     DOMContentLoaded — 이벤트 바인딩
  ================================================================ */
  document.addEventListener('DOMContentLoaded', function () {

    /* 계약 등록 버튼 */
    document.getElementById('btnOpenRegister')
            .addEventListener('click', openRegisterModal);

    /* 필터 초기화 */
    document.getElementById('btnResetFilter')
            .addEventListener('click', resetFilter);

    /* 테이블 행 클릭 → 상세 모달 (이벤트 위임) */
    document.getElementById('contractTbody')
            .addEventListener('click', function (e) {
              var row = e.target.closest('.table-click-row');
              if (row) openPanel(row.dataset.ctrtNo);
            });

    /* 등록 모달 오버레이 클릭 */
    document.getElementById('registerOverlay')
            .addEventListener('click', function (e) {
              if (e.target === this) closeRegisterModal();
            });

    /* 상세 모달 오버레이 클릭 */
    document.getElementById('overlay')
            .addEventListener('click', function (e) {
              if (e.target === this) closePanel();
            });

    /* 모달 닫기 버튼 */
    document.getElementById('btnCloseRegister')
            .addEventListener('click', closeRegisterModal);
    document.getElementById('btnCloseRegister2')
            .addEventListener('click', closeRegisterModal);
    document.getElementById('btnClosePanel')
            .addEventListener('click', closePanel);

    /* 등록 제출 */
    document.getElementById('registerSubmitBtn')
            .addEventListener('click', submitRegister);

    /* 파일 input onchange */
    document.getElementById('contractFile')
            .addEventListener('change', function () { showFileName(this, 'fname1'); });
    document.getElementById('idFile')
            .addEventListener('change', function () { showFileName(this, 'fname2'); });
    document.getElementById('etcFile')
            .addEventListener('change', function () { showFileName(this, 'fname3'); });
  });
</script>
</body>
</html>
