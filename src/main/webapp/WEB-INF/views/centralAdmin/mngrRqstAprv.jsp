<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<!doctype html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>우리집맵핑 · 단지 관리자 계정</title>

    <%-- CSRF 보안 처리를 위해 JSP에 심어주는 메타 정보
         ${_csrf.headerName} -> 토큰 보낼 때, 어떤 HTTP 헤더 이름으로 보낼지 '키' 정해줌
         ${_csrf.token} -> 서버가 만들어준 CSRF 토큰 '값'
    --%>
    <meta name="_csrf_header" content="${_csrf.headerName}">
    <meta name="_csrf" content="${_csrf.token}">

    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet" />

    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/centralAside.css" />
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/centralHeader.css" />
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/centralCommon.css" />

    <style>
        body{font-family:'Noto Sans KR',sans-serif;background:#f5f6f8;color:#111827}
        .main-wrap{min-height:100vh}.main-content{padding:24px}.page-header{display:flex;justify-content:space-between;align-items:flex-start;margin-bottom:18px}.page-title{font-size:20px;font-weight:800}.page-subtitle{font-size:13px;color:#64748b;margin-top:4px}
        .topbar{height:54px;display:flex;align-items:center;justify-content:space-between;padding:0 24px;border-bottom:1px solid #e5e7eb;background:#fff}.breadcrumb{font-size:12px;color:#64748b;display:flex;align-items:center}.bc-current{font-weight:800;color:#111827}.topbar-actions{display:flex;gap:8px}.topbar-icon-btn{position:relative;border:1px solid #e5e7eb;background:#fff;border-radius:10px;width:34px;height:34px;cursor:pointer}.topbar-icon-btn .material-symbols-rounded{font-size:18px}.dot{position:absolute;right:7px;top:7px;width:6px;height:6px;background:#ef4444;border-radius:50%}
        .c-card,.panel{background:#fff;border:1px solid #e5e7eb;border-radius:14px;box-shadow:0 1px 3px rgba(15,23,42,.08);margin-bottom:16px;overflow:hidden}.c-card__header,.rqst-header{display:flex;justify-content:space-between;align-items:flex-start;padding:16px 20px 14px}.c-card__title,.rqst-title h3{font-size:14px;font-weight:800;color:#111827;margin:0}.c-card__sub,.rqst-summary{font-size:12px;color:#94a3b8;margin-top:3px}.c-card__actions,.rqst-search-row,.rqst-button-row{display:flex;align-items:center;gap:8px}.rqst-toolbar-right{display:flex;flex-direction:column;align-items:flex-end;gap:8px}.c-card__body{padding:16px 20px}.c-table-wrap{overflow-x:auto}.c-table,.data-table{width:100%;border-collapse:collapse;table-layout:fixed}.c-table th,.data-table th{background:#f8fafc;border-top:1px solid #e5e7eb;border-bottom:1px solid #e5e7eb;padding:10px 12px;font-size:12px;font-weight:800;color:#475569;text-align:left}.c-table td,.data-table td{border-bottom:1px solid #e5e7eb;padding:12px;font-size:12px;color:#334155;vertical-align:middle}.c-table tr:hover,.data-table tr:hover{background:#f9fafb}.muted{color:#64748b}.row-inactive td:not(:last-child){opacity:.45}
        .role-grid{display:grid;grid-template-columns:repeat(4,1fr);gap:12px}.role-card{border:1.5px solid #e5e7eb;border-radius:12px;padding:16px;background:#fff}.role-card__top{display:flex;align-items:flex-start;justify-content:space-between;margin-bottom:10px}.role-card__icon{width:36px;height:36px;border-radius:9px;display:flex;align-items:center;justify-content:center}.role-card__icon .material-symbols-rounded{font-size:19px}.role-card__lv{font-size:10px;font-weight:700;padding:2px 8px;border-radius:99px}.role-card__title{font-size:13px;font-weight:800}.role-card__desc{font-size:11.5px;color:#94a3b8;margin-top:3px}
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     .caveat{color: #ef4444;}
        .input-with-icon,.search-box,.select-box{position:relative}.input-with-icon{width:210px}.search-box{width:220px}.select-box{width:110px}.c-input,.fake-input,.c-select,.fake-select{height:34px;border:1px solid #e5e7eb;border-radius:8px;font-size:12px;background:#fff;outline:none}.c-input,.fake-input{width:100%;padding:0 34px 0 12px}.c-select,.fake-select{width:100%;padding:0 30px 0 12px;appearance:none}.search-icon,.select-icon{position:absolute;right:10px;top:50%;transform:translateY(-50%);font-size:17px;color:#94a3b8}.search-icon{cursor:pointer}.select-icon{pointer-events:none}
        .c-btn,.btn-sub,.btn-danger{height:34px;padding:0 12px;border-radius:8px;font-size:12px;font-weight:700;display:inline-flex;align-items:center;gap:4px;cursor:pointer}.c-btn{border:1px solid #cbd5e1;background:#fff;color:#334155}.c-btn--primary{background:#2563eb;border-color:#2563eb;color:#fff}.c-btn--ghost{background:#f8fafc;border-color:#e5e7eb;color:#334155}.c-btn--danger,.btn-danger{background:#fff1f2;border:1px solid #fecdd3;color:#be123c}.btn-sub{background:#f8fafc;border:1px solid #cbd5e1;color:#334155}.c-btn--sm{height:30px;padding:0 10px}.material-symbols-rounded{font-size:17px}
        .user-cell{display:flex;align-items:center;gap:10px}.user-avatar{width:32px;height:32px;border-radius:50%;flex-shrink:0;display:flex;align-items:center;justify-content:center;font-size:12px;font-weight:800}.user-name{font-size:13px;font-weight:700;color:#111827}.user-id{font-size:11px;color:#94a3b8;margin-top:1px}.badge,.c-badge{display:inline-flex;align-items:center;padding:4px 8px;border-radius:999px;font-size:11px;font-weight:800}.badge.info{background:#eef2ff;color:#4338ca}.badge.cancel{background:#e5e7eb;color:#374151}.badge.wait{background:#fef3c7;color:#92400e}.badge.ok{background:#dcfce7;color:#166534}.badge.reject{background:#fee2e2;color:#991b1b}.row-actions{display:flex;justify-content:flex-end;gap:6px}.icon-btn-sm{width:28px;height:28px;border:1px solid #e5e7eb;border-radius:7px;background:#fff;cursor:pointer}.icon-btn-sm.danger{color:#be123c}.rqst-check{width:15px;height:15px;accent-color:#2563eb;cursor:pointer}.table-footer{display:flex;justify-content:space-between;padding:12px 20px;font-size:12px;color:#64748b}
        .toggle-wrap{position:relative;display:inline-block;width:36px;height:20px;cursor:pointer}.toggle-wrap input{opacity:0;width:0;height:0}.toggle-track{position:absolute;inset:0;background:#e2e5ea;border-radius:99px;transition:.18s}.toggle-thumb{position:absolute;width:14px;height:14px;border-radius:50%;background:#fff;top:3px;left:3px;transition:.18s;box-shadow:0 1px 3px rgba(0,0,0,.15)}.toggle-wrap input:checked~.toggle-track{background:#16a34a}.toggle-wrap input:checked~.toggle-thumb{left:19px}.c-pagination{display:flex;justify-content:center;gap:6px;padding:14px}.c-pagination__btn{min-width:30px;height:30px;border:1px solid #e5e7eb;background:#fff;border-radius:7px;cursor:pointer}.c-pagination__btn.is-active{background:#2563eb;color:#fff;border-color:#2563eb}.c-pagination__btn.is-disabled{opacity:.4;pointer-events:none}
        .c-modal-overlay{position:fixed;inset:0;background:rgba(15,23,42,.45);display:flex;align-items:center;justify-content:center;z-index:1000}.c-modal-overlay.is-hidden{display:none}.c-modal{width:520px;background:#fff;border-radius:16px;box-shadow:0 20px 60px rgba(0,0,0,.2);overflow:hidden}.c-modal__header,.c-modal__footer{display:flex;align-items:center;justify-content:space-between;padding:16px 20px;border-bottom:1px solid #e5e7eb}.c-modal__footer{border-top:1px solid #e5e7eb;border-bottom:0;justify-content:flex-end;gap:8px}.c-modal__body{padding:20px}.c-info-grid{display:grid;grid-template-columns:1fr 1fr;gap:12px}.c-info-block{background:#f8fafc;border:1px solid #e5e7eb;border-radius:10px;padding:12px}.c-label{font-size:11px;color:#94a3b8;font-weight:700}.c-value{font-size:13px;color:#111827;font-weight:700;margin-top:4px}

        /*
            비고 펼침 영역
        */
        .remark-row{
            background:#f8fafc;
        }

        .remark-row td{
            padding:0 12px 8px 12px; /* 아래 여백 줄임 */
            border-bottom:1px solid #e5e7eb;
        }

        .remark-box{
            padding:8px 14px;        /* 내부 여백 줄임 */
            background:#f8fafc;
            border-left:3px solid #2563eb;
            border-radius:0 0 8px 8px;
            box-shadow:none;
        }

        .remark-box__title{
            display:flex;
            align-items:center;
            gap:5px;
            margin-bottom:4px;      /* 제목과 내용 사이 간격 줄임 */
            font-size:12px;
            font-weight:700;
            color:#1e3a8a;
        }

        .remark-box__content{
            font-size:12px;
            line-height:1.4;        /* 줄간격 줄임 */
            color:#475569;
            white-space:pre-wrap;
        }

        /* 관리 컬럼 오른쪽 여백 */
        .data-table th:last-child,
        .data-table td:last-child{
            padding-right:28px;
        }

        .data-table .row-actions{
            justify-content:flex-end;
        }

        .reject-reason-modal{
            width:360px; /* 모달창 너비 */
        }

        .reject-reason-content{
            padding:14px 16px;
            border-radius:10px;
            background:#f8fafc;
            border:1px solid #e5e7eb;

            font-size:13px;
            line-height:1.6;
            color:#334155;
            white-space:pre-wrap;
        }

    </style>
</head>
<body>
<%@ include file="centralAside.jsp" %>

<div class="main-wrap">
    <div class="topbar">
        <div class="breadcrumb">
            <span class="material-symbols-rounded" style="font-size:14px">home</span>
            <span style="margin:0 4px">/</span>
            <span>시설·시스템</span>
            <span style="margin:0 4px">/</span>
            <span class="bc-current">단지관리자 계정</span>
        </div>
        <div class="topbar-actions">
            <button class="topbar-icon-btn" type="button"><span class="material-symbols-rounded">notifications</span><div class="dot"></div></button>
            <button class="topbar-icon-btn" type="button"><span class="material-symbols-rounded">settings</span></button>
        </div>
    </div>

    <div class="main-content">
        <div class="page-header">
            <div>
                <div class="page-title">단지 관리자 계정 관리</div>
                <div class="page-subtitle">단지별 계정 생성·매핑, 권한 레벨 설정 및 상태를 통합 제어합니다.</div>
            </div>
            <button class="c-btn c-btn--primary" type="button" onclick="exportAccountsToExcel()">
                <span class="material-symbols-rounded">download</span>엑셀 내보내기
            </button>
        </div>

        <div class="c-card">
            <div class="c-card__header">
                <div>
                    <div class="c-card__title">권한 레벨 안내</div>
                    <div class="c-card__sub">가이드는 참고용입니다. 신규 계정 승인 시 신청된 권한으로 설정됩니다.</div>
                </div>
                <button class="c-btn c-btn--ghost c-btn--sm" type="button" onclick="toggleRoleGuide()">
                    <span class="material-symbols-rounded">unfold_more</span>권한 정의 보기
                </button>
            </div>
            <div class="c-card__body" id="roleGuideBody" style="display:none">
                <div class="role-grid" id="roleGrid"></div>
            </div>
        </div>

        <section class="panel">
            <div class="rqst-header">
                <div class="rqst-title">
                    <h3>단지 관리자 신청 계정 목록</h3>
                    <div class="rqst-summary" id="rqstSummary">총 0건 / 승인대기 0건 / 승인완료 0건 / 반려 0건</div>
                </div>

                <div class="rqst-toolbar-right">
                    <div class="rqst-search-row">
                        <div class="search-box">
                            <input type="text" id="searchInput1" class="fake-input" placeholder="이름, 아이디, 단지명 검색" oninput="searchTable('rqstTable', this.value)">
                            <span class="material-symbols-rounded search-icon" onclick="searchBtnClick('rqstTable', 'searchInput1')">search</span>
                        </div>
                        <div class="select-box">
                            <select class="fake-select" onchange="filterTable('rqstTable', this.value)">
                                <option value="all">전체</option>
                                <option value="CNL">신청취소</option>
                                <option value="WAIT" selected>승인대기</option>
                                <option value="OK">승인완료</option>
                                <option value="RJCT">반려</option>
                            </select>
                            <span class="select-icon">▾</span>
                        </div>
                    </div>
                    <div class="rqst-button-row">
                        <button type="button" class="btn-sub" onclick="openApprovalModal()"><span class="material-symbols-rounded">task_alt</span>선택 계정 승인</button>
                        <button type="button" class="btn-danger" onclick="openRejectModal()"><span class="material-symbols-rounded">cancel</span>선택 계정 반려</button>
                    </div>
                </div>
            </div>

            <div style="overflow-x:auto;">
                <table class="data-table" id="rqstTable">
                    <thead>
                    <tr>
                        <th style="width:44px"><input type="checkbox" class="rqst-check" onclick="toggleAll('rqstTable', this)"></th>
                        <th>신청자 정보</th>
                        <th>소속 단지</th>
                        <th style="width:220px">상세주소</th>
                        <th>신청 직무</th>
                        <th>신청일자</th>
                        <th>처리상태</th>
                        <th style="width:90px;text-align:right;padding-right:28px">관리</th>
                    </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
            <div class="table-footer">
<%--                <span id="rqstFooterTotal">총 <strong>0</strong>건 표시 중</span>--%>
<%--                <span>체크 후 승인/반려 버튼을 누르면 DB에 즉시 반영됩니다.</span>--%>
            </div>
        </section>

        <div class="c-card">
            <div class="c-card__header">
                <div>
                    <div class="c-card__title">단지 관리자 계정 목록 및 상태</div>
                    <div class="c-card__sub" id="acctSubtitle">총 0건 / 1 페이지</div>
                </div>
                <div class="c-card__actions">
                    <div class="input-with-icon">
                        <input type="search" id="searchInput" class="c-input" placeholder="이름·아이디·단지 검색" oninput="searchAccounts(this.value)" onkeydown="handleSearchKey(event)">
                        <span class="material-symbols-rounded search-icon" onclick="handleSearchClick()">search</span>
                    </div>
                    <div class="select-box">
                        <select class="c-select" onchange="filterStatus(this.value)">
                            <option value="">상태</option>
                            <option value="active">사용</option>
                            <option value="inactive">미사용</option>
                        </select>
                        <span class="select-icon">▾</span>
                    </div>
                    <div class="select-box">
                        <select class="c-select" id="roleFilter" onchange="filterRole(this.value)"></select>
                        <span class="select-icon">▾</span>
                    </div>
                </div>
            </div>
            <div class="c-card__body" style="padding:0">
                <div class="c-table-wrap">
                    <table class="c-table">
                        <thead>
                        <tr>
                            <th style="width:320px">관리자 정보</th>
                            <th style="width:180px">소속 단지</th>
                            <th style="width:220px">상세주소</th>
                            <th style="width:130px">권한 레벨</th>
                            <th style="width:150px">최근 접속</th>
                            <th style="width:110px">상태</th>
                        </tr>
                        </thead>
                        <tbody id="acctTbody"></tbody>
                    </table>
                </div>
                <div class="c-pagination" id="acctPagination"></div>
            </div>
        </div>
    </div>
</div>

<div class="c-modal-overlay is-hidden" id="detailOverlay" onclick="if(event.target===this)closeAccountDetail()">
    <div class="c-modal">
        <div class="c-modal__header">
            <strong id="detailAcctTitle">계정 상세</strong>
        </div>
        <div class="c-modal__body">
            <div class="c-info-grid" id="detailAcctContent"></div>
        </div>
        <div class="c-modal__footer">
            <button class="c-btn c-btn--danger" type="button" onclick="deleteAccount()">계정 숨김</button>
            <button class="c-btn" type="button" onclick="closeAccountDetail()">닫기</button>
        </div>
    </div>
</div>

<script>
    window.APP_CTX = '<%= request.getContextPath() %>';
</script>
<script src="<%= request.getContextPath() %>/js/central/admin/mngrRqstAprv.js"></script>

<!-- 반려사유 확인 모달 -->
<div class="c-modal-overlay is-hidden" id="rejectReasonOverlay" onclick="if(event.target===this)closeRejectReasonModal()">
    <div class="c-modal reject-reason-modal">
        <div class="c-modal__header">
            <strong>반려 사유</strong>
            <button type="button" class="icon-btn-sm" onclick="closeRejectReasonModal()">
                <span class="material-symbols-rounded">close</span>
            </button>
        </div>

        <div class="c-modal__body">
            <div id="rejectReasonContent" class="reject-reason-content">
                등록된 반려 사유가 없습니다.
            </div>
        </div>

        <div class="c-modal__footer">
            <button class="c-btn" type="button" onclick="closeRejectReasonModal()">확인</button>
        </div>
    </div>
</div>
</body>
</html>


