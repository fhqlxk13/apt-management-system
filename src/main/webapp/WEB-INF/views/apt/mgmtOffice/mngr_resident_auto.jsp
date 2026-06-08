<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<sec:authentication property="principal" var="customUser"/>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>관리사무소</title>

    <sec:csrfMetaTags/>

    <link rel="preconnect" href="https://fonts.googleapis.com"/>
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin/>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap"
          rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0"
          rel="stylesheet"/>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/office-layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/manager-common.css">

    <style>
        /* ── 페이지 전용 ── */
        #vhclPage .filter-select {
            width: 140px;
        }

        #vhclPage .filter-keyword {
            width: 260px;
        }

        /* 승인대기 배너 */
        #vhclPage .pending-banner {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 18px;
            background: #fffbeb;
            border: 1px solid #fcd34d;
            border-radius: var(--r-md);
            margin-bottom: 16px;
            font-size: 13px;
        }

        #vhclPage .pending-banner > .material-symbols-rounded {
            color: #d97706;
            font-size: 20px;
            flex-shrink: 0;
        }

        #vhclPage .pending-banner strong {
            color: #92400e;
        }

        /* 일괄 처리 바 */
        #vhclPage .bulk-bar {
            display: none;
            align-items: center;
            gap: 8px;
            padding: 10px 22px;
            background: #f0fdf4;
            border-bottom: 1px solid #bbf7d0;
        }

        #vhclPage .bulk-bar.visible {
            display: flex;
        }

        #vhclPage .bulk-bar-text {
            flex: 1;
            font-size: 13px;
            font-weight: 700;
            color: #15803d;
        }

        /* 체크박스 */
        #vhclPage .rqst-check {
            width: 15px;
            height: 15px;
            accent-color: #265c30;
            cursor: pointer;
        }

        /* 테이블 */
        #vhclPage .col-check {
            width: 44px;
            text-align: center !important;
        }

        #vhclPage .col-center {
            text-align: center !important;
        }

        #vhclPage .col-manage {
            text-align: center !important;
            width: 140px;
        }

        #vhclPage .grid-actions {
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        #vhclPage .empty-row {
            text-align: center !important;
            color: var(--text-tertiary);
            padding: 36px !important;
        }

        #vhclPage tbody tr.row-pending td {
            background: #fffef5;
        }

        /* 삭제 경고 */
        #vhclPage .delete-warning {
            display: flex;
            gap: 10px;
            padding: 14px 16px;
            background: #fff0f0;
            border: 1px solid #e0a8a8;
            border-radius: 8px;
            margin-bottom: 16px;
        }

        #vhclPage .delete-warning-icon {
            color: #991b1b;
            font-size: 20px;
            flex-shrink: 0;
            margin-top: 1px;
        }

        #vhclPage .delete-warning-text {
            font-size: 13px;
            color: #7f1d1d;
            line-height: 1.6;
        }

        /* 첨부 이미지 미리보기 */
        #vhclPage .img-drop {
            border: 2px dashed var(--border);
            border-radius: var(--r-sm);
            padding: 20px;
            text-align: center;
            cursor: pointer;
            color: var(--text-tertiary);
            transition: 0.14s;
            position: relative;
        }

        #vhclPage .img-drop:hover {
            border-color: #2e5c38;
            background: #f0fdf4;
            color: #2e5c38;
        }

        #vhclPage .img-drop .material-symbols-rounded {
            font-size: 26px;
            display: block;
            margin-bottom: 4px;
        }

        #vhclPage .img-drop p {
            font-size: 13px;
            font-weight: 500;
        }

        #vhclPage .img-drop small {
            font-size: 11px;
        }

        #vhclPage .img-preview-box {
            width: 100%;
            height: 110px;
            border-radius: var(--r-sm);
            border: 1px solid var(--border);
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: center;
            background: var(--gray-soft);
        }

        #vhclPage .img-preview-box img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        /* 반려사유 영역 */
        #vhclPage .reject-wrap {
            margin-top: 14px;
            display: none;
        }

        #vhclPage .reject-wrap.visible {
            display: block;
        }

        /* 테이블 하단 푸터 */
        #vhclPage .tbl-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 12px 22px;
            font-size: 12px;
            color: var(--text-tertiary);
            border-top: 1px solid var(--border);
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
            <div class="office-page" id="vhclPage">
                <div class="page-header">
                    <div class="page-title-block">
                        <h2>입주민 차량 관리</h2>
                        <p>온라인 신청 차량 승인·반려 및 오프라인 직접 등록을 통합 관리합니다</p>
                    </div>
                    <div class="page-actions">

                        <button type="button" class="btn btn-primary" data-action="openRegister">
                            <span class="material-symbols-rounded">add</span>차량 직접 등록
                        </button>
                    </div>
                </div>
                <div class="summary-row">
                    <div class="summary-card s-green">
                        <div class="s-icon"><span class="material-symbols-rounded">directions_car</span></div>
                        <div>
                            <div class="s-val" id="statTotal">0</div>
                            <div class="s-label">전체 등록 차량</div>
                        </div>
                    </div>
                    <div class="summary-card s-yellow">
                        <div class="s-icon"><span class="material-symbols-rounded">pending_actions</span></div>
                        <div>
                            <div class="s-val" id="statPending">0</div>
                            <div class="s-label">승인 대기</div>
                        </div>
                    </div>
                    <div class="summary-card s-blue">
                        <div class="s-icon"><span class="material-symbols-rounded">check_circle</span></div>
                        <div>
                            <div class="s-val" id="statApproved">0</div>
                            <div class="s-label">승인 완료</div>
                        </div>
                    </div>
                    <div class="summary-card s-red">
                        <div class="s-icon"><span class="material-symbols-rounded">cancel</span></div>
                        <div>
                            <div class="s-val" id="statRejected">0</div>
                            <div class="s-label">반려</div>
                        </div>
                    </div>
                </div>

                <div class="pending-banner" id="pendingBanner" style="display:none;">
                    <span class="material-symbols-rounded">notification_important</span>
                    <span id="pendingBannerText"></span>
                </div>
                <div class="tab-bar">
                    <button type="button" class="tab-btn active" data-tab="tab-request">
                        <span class="material-symbols-rounded">inbox</span>입주민 신청 목록
                    </button>
                    <button type="button" class="tab-btn" data-tab="tab-all">
                        <span class="material-symbols-rounded">list</span>전체 등록 차량
                    </button>
                </div>
                <div class="tab-panel active" id="tab-request">
                    <div class="filter-card">
                        <select class="form-select filter-select" id="filterRqstStts">
                            <option value="">처리상태 전체</option>
                            <option value="SUBMIT">승인대기</option>
                            <option value="APRV">승인완료</option>
                            <option value="REJT">반려</option>
                        </select>

                        <input type="date" class="form-input filter-select" id="filterRqstStart" style="width:145px;">
                        <input type="date" class="form-input filter-select" id="filterRqstEnd" style="width:145px;">
                        <div class="search-wrap filter-keyword">
                            <span class="material-symbols-rounded">search</span>
                            <input type="text" class="form-input" id="filterRqstKeyword"
                                   placeholder="동·호수, 차량번호, 입주민명 검색">
                        </div>
                        <button type="button" class="btn btn-primary" data-action="searchRqst">조회</button>
                        <button type="button" class="btn btn-secondary" data-action="resetRqst">초기화</button>
                    </div>

                    <div class="panel">
                        <div class="bulk-bar" id="bulkBar">
                            <span class="material-symbols-rounded"
                                  style="color:#15803d;font-size:18px;">checklist</span>
                            <span class="bulk-bar-text" id="bulkBarText">0건 선택됨</span>
                            <button type="button" class="btn btn-primary btn-sm" data-action="bulkApprove">
                                <span class="material-symbols-rounded">task_alt</span>선택 승인
                            </button>
                            <button type="button" class="btn btn-danger btn-sm" data-action="bulkReject">
                                <span class="material-symbols-rounded">cancel</span>선택 반려
                            </button>
                        </div>

                        <div class="panel-header">
                            <div class="list-header-left">
                                <h3 class="panel-title">
                                    <span class="material-symbols-rounded">inbox</span>입주민 신청 목록
                                </h3>
                                <span class="list-count" id="rqstListCount">0건</span>
                            </div>
                            <span style="font-size:12px;color:var(--text-tertiary);">
                                체크 후 일괄 승인·반려를 적용할 수 있습니다
                            </span>
                        </div>

                        <div class="table-wrap">
                            <table class="tbl">
                                <thead>
                                <tr>
                                    <th class="col-check">
                                        <input type="checkbox" class="rqst-check" id="checkAll">
                                    </th>
                                    <th>신청자<br><small style="font-weight:400;letter-spacing:0;text-transform:none;">USER_NO
                                        → NM</small></th>
                                    <th>세대<br><small
                                            style="font-weight:400;letter-spacing:0;text-transform:none;">HO_NO</small>
                                    </th>
                                    <th class="col-center">차량유형<br><small
                                            style="font-weight:400;letter-spacing:0;text-transform:none;">VST_VHCL_TY_CD</small>
                                    </th>
                                    <th>차량명<br><small style="font-weight:400;letter-spacing:0;text-transform:none;">VHCL_NM</small>
                                    </th>
                                    <th>차량번호<br><small style="font-weight:400;letter-spacing:0;text-transform:none;">VHCL_NO</small>
                                    </th>
                                    <th class="col-center">신청일<br><small
                                            style="font-weight:400;letter-spacing:0;text-transform:none;">REG_DT</small>
                                    </th>
                                    <th class="col-center">처리상태<br><small
                                            style="font-weight:400;letter-spacing:0;text-transform:none;">SUBMIT_DOC_STTS</small>
                                    </th>
                                    <th class="col-manage">관리</th>
                                </tr>
                                </thead>
                                <tbody id="rqstTbody"></tbody>
                            </table>
                        </div>
                        <div class="tbl-footer">
                            <span id="rqstFooterText">총 <strong>0</strong>건</span>
                            <span>승인 처리 시 입주민 앱에 알림이 발송됩니다</span>
                        </div>
                    </div>
                </div>
                <div class="tab-panel" id="tab-all">
                    <div class="filter-card">
                        <select class="form-select filter-select" id="filterRegType">
                            <option value="">등록방법 전체</option>
                            <option value="ONLINE">온라인 신청</option>
                            <option value="OFFLINE">직접 등록</option>
                        </select>
                        <div class="search-wrap filter-keyword">
                            <span class="material-symbols-rounded">search</span>
                            <input type="text" class="form-input" id="filterAllKeyword"
                                   placeholder="동·호수, 차량번호, 입주민명 검색">
                        </div>
                        <button type="button" class="btn btn-primary" data-action="searchAll">조회</button>
                    </div>
                    <div class="panel">
                        <div class="panel-header">
                            <div class="list-header-left">
                                <h3 class="panel-title">
                                    <span class="material-symbols-rounded">directions_car</span>전체 등록 차량
                                </h3>
                                <span class="list-count" id="allListCount">0건</span>
                            </div>
                        </div>
                        <div class="table-wrap">
                            <table class="tbl">
                                <thead>
                                <tr>
                                    <th>입주민<br><small style="font-weight:400;letter-spacing:0;text-transform:none;">USER_NO
                                        → NM</small></th>
                                    <th>세대<br><small
                                            style="font-weight:400;letter-spacing:0;text-transform:none;">HO_NO</small>
                                    </th>
                                    <th class="col-center">차량유형<br><small
                                            style="font-weight:400;letter-spacing:0;text-transform:none;">VST_VHCL_TY_CD</small>
                                    </th>
                                    <th>차량명<br><small style="font-weight:400;letter-spacing:0;text-transform:none;">VHCL_NM</small>
                                    </th>
                                    <th>차량번호<br><small style="font-weight:400;letter-spacing:0;text-transform:none;">VHCL_NO</small>
                                    </th>
                                    <th class="col-center">등록방법</th>
                                    <th class="col-center">등록일<br><small
                                            style="font-weight:400;letter-spacing:0;text-transform:none;">REG_DT</small>
                                    </th>
                                    <th class="col-manage">관리</th>
                                </tr>
                                </thead>
                                <tbody id="allTbody"></tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <div class="modal-overlay" id="rqstModal">
                    <div class="modal modal-md">
                        <div class="modal-header primary">
                            <h3 class="modal-title" id="rqstModalTitle">차량 신청 상세</h3>
                            <button type="button" class="modal-close" data-action="closeRqstModal">
                                <span class="material-symbols-rounded">close</span>
                            </button>
                        </div>
                        <div class="modal-body">

                            <div class="form-section">
                                <div class="form-section-title">
                                    <span class="material-symbols-rounded">person</span>
                                    신청자 정보
                                </div>
                                <div class="mngr-detail-grid" id="rqstDetailGrid"></div>
                            </div>

                            <div class="form-section">
                                <div class="form-section-title">
                                    <span class="material-symbols-rounded">directions_car</span>
                                    차량 정보 · RSID_VHCL
                                </div>
                                <div class="mngr-detail-grid" id="rqstVhclGrid"></div>
                            </div>

                            <div class="form-section">
                                <div class="form-section-title">
                                    <span class="material-symbols-rounded">image</span>
                                    차량등록증 첨부
                                </div>
                                <div class="img-preview-box" id="rqstImgBox">
                                    <span class="material-symbols-rounded"
                                          style="font-size:36px;color:var(--text-tertiary);">image_not_supported</span>
                                </div>
                                <p style="font-size:11px;color:var(--text-tertiary);margin-top:6px;"
                                   id="rqstImgName"></p>
                            </div>

                            <div class="reject-wrap" id="rejectReasonWrap">
                                <div class="form-section-title" style="margin-top:0;">
                                    <span class="material-symbols-rounded">report</span>
                                    반려 사유
                                </div>
                                <div class="mngr-help-box"
                                     style="background:#fff0f0;border-color:#fca5a5;color:#991b1b;">
                                    <span class="material-symbols-rounded">info</span>
                                    <span id="rejectReasonText"></span>
                                </div>
                            </div>

                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-action="closeRqstModal">닫기</button>
                            <button type="button" class="btn btn-danger" id="rqstRejectBtn"
                                    data-action="openRejectReason" style="display:none;">
                                <span class="material-symbols-rounded">cancel</span>반려
                            </button>
                            <button type="button" class="btn btn-primary" id="rqstApproveBtn" data-action="approveOne"
                                    style="display:none;">
                                <span class="material-symbols-rounded">task_alt</span>승인
                            </button>
                        </div>
                    </div>
                </div>
                <div class="modal-overlay" id="rejectModal">
                    <div class="modal modal-sm">
                        <div class="modal-header">
                            <h3 class="modal-title">차량 신청 반려</h3>
                            <button type="button" class="modal-close" data-action="closeRejectModal">
                                <span class="material-symbols-rounded">close</span>
                            </button>
                        </div>
                        <div class="modal-body">
                            <div class="delete-warning">
                                <span class="material-symbols-rounded delete-warning-icon">warning</span>
                                <div class="delete-warning-text">
                                    반려 처리 시 입주민에게 반려 알림이 발송됩니다.<br>
                                    반려 사유를 입력해 주세요.
                                </div>
                            </div>
                            <div class="form-field">
                                <label class="field-label">반려 사유 <span class="req">*</span></label>
                                <textarea class="form-textarea" id="rejectReasonInput"
                                          placeholder="예) 차량등록증 사진이 불분명합니다. 재첨부 후 다시 신청해 주세요."></textarea>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-action="closeRejectModal">취소</button>
                            <button type="button" class="btn btn-danger" id="rejectConfirmBtn">반려 확정</button>
                        </div>
                    </div>
                </div>
                <div class="modal-overlay" id="regModal">
                    <div class="modal modal-md">
                        <div class="modal-header primary">
                            <h3 class="modal-title" id="regModalTitle">차량 직접 등록</h3>
                            <button type="button" class="modal-close" data-action="closeRegModal">
                                <span class="material-symbols-rounded">close</span>
                            </button>
                        </div>
                        <form id="regForm">
                            <div class="modal-body">

                                <div class="form-section">

                                    <div class="form-section-title">
                                        <span class="material-symbols-rounded">home</span>
                                        세대 정보
                                    </div>
                                    <div class="form-row cols-2">
                                        <div class="form-field">
                                            <label class="field-label">
                                                입주민 번호
                                                <span class="req">*</span>
                                            </label>
                                            <input
                                                    type="text"
                                                    class="form-input"
                                                    id="userNo"
                                                    name="userNo"
                                                    placeholder="예) USER001"
                                                    required>
                                        </div>
                                        <div class="form-field">
                                            <label class="field-label">
                                                세대 번호
                                                <span class="req">*</span>
                                            </label>
                                            <input
                                                    type="text"
                                                    class="form-input"
                                                    id="hoNo"
                                                    name="hoNo"
                                                    placeholder="예) HO-101-1203"
                                                    required>

                                        </div>
                                    </div>
                                </div>
                                <div class="form-section">
                                    <div class="form-section-title">
                                        <span class="material-symbols-rounded">directions_car</span>
                                        차량 정보 · RSID_VHCL
                                    </div>
                                    <div class="form-row cols-2">
                                        <div class="form-field">
                                            <label class="field-label">차량번호 <span class="req">*</span>
                                                <small style="font-weight:400;color:var(--text-tertiary);">VHCL_NO</small>
                                            </label>
                                            <input type="text" class="form-input" id="vhclNo" name="vhclNo"
                                                   placeholder="예) 12가 3456" required>
                                        </div>
                                        <div class="form-field">
                                            <label class="field-label">차량명 <span class="req">*</span>
                                                <small style="font-weight:400;color:var(--text-tertiary);">VHCL_NM</small>
                                            </label>
                                            <input type="text" class="form-input" id="vhclNm" name="vhclNm"
                                                   placeholder="예) 현대 아반떼" required>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-section">
                                    <div class="form-section-title">
                                        <span class="material-symbols-rounded">attach_file</span>
                                        차량등록증 첨부
                                        <small style="font-weight:400;color:var(--text-tertiary);text-transform:none;letter-spacing:0;">JPG
                                            · PNG · PDF · 최대 10MB</small>
                                    </div>
                                    <div class="img-drop" id="imgDrop"
                                         onclick="document.getElementById('vhclImgInput').click()">
                                        <span class="material-symbols-rounded">upload_file</span>
                                        <p>클릭하거나 파일을 끌어다 놓으세요</p>
                                        <small>차량등록증 이미지 또는 PDF</small>
                                        <input type="file"
                                               id="vhclImgInput"
                                               name="uploadFile"
                                               accept=".jpg,.jpeg,.png,.pdf"
                                               style="display:none;">
                                    </div>
                                    <div id="imgPreviewArea" style="margin-top:8px;display:none;">
                                        <div class="img-preview-box">
                                            <img id="imgPreviewEl" src="" alt="차량등록증 미리보기">
                                        </div>
                                        <p style="font-size:11px;color:var(--text-tertiary);margin-top:4px;"
                                           id="imgPreviewName"></p>
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button"
                                        class="btn btn-danger"
                                        id="regDeleteBtn"
                                        onclick="openDeleteModalDirect()">
                                    <span class="material-symbols-rounded">delete</span>삭제
                                </button>
                                <button type="button" class="btn btn-secondary" data-action="closeRegModal">취소</button>
                                <button type="button" class="btn btn-primary" id="regEditBtn" data-action="changeToEdit"
                                        style="display:none;">수정하기
                                </button>
                                <button type="submit" class="btn btn-primary" id="regSaveBtn">저장</button>
                            </div>
                    </div>
                    </form>
                </div>
            </div>
            <div class="modal-overlay" id="deleteModal">
                <div class="modal modal-sm">
                    <div class="modal-header">
                        <h3 class="modal-title">차량 삭제</h3>
                        <button type="button" class="modal-close" data-action="closeDeleteModal">
                            <span class="material-symbols-rounded">close</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <div class="delete-warning">
                            <span class="material-symbols-rounded delete-warning-icon">warning</span>
                            <div class="delete-warning-text">
                                선택한 차량 정보를 삭제하시겠습니까?<br>
                                삭제 후에는 복구할 수 없습니다.
                            </div>
                        </div>
                        <div class="mngr-detail-grid" id="deleteTargetInfo"></div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-action="closeDeleteModal">취소</button>
                        <button type="button" class="btn btn-danger" id="deleteConfirmBtn">삭제</button>
                    </div>
                </div>
            </div>
</body>

    <script>


        const CONTEXT_PATH = '${pageContext.request.contextPath}';

        (function () {
            var page = document.getElementById('vhclPage');
            if (!page || page.dataset.bound === 'true') return;
            page.dataset.bound = 'true';

            /!* ── 공통코드 매핑 ── *!/
            // VHC_TY (VST_VHCL_TY_CD)
            var VHCL_TY_TEXT = {GEN: '일반', MOV: '이사차량', WRK: '업무/공사', DLV: '배달/택배', EMG: '긴급/공용'};
            var VHCL_TY_BADGE = {
                GEN: 'badge-gray',
                MOV: 'badge-orange',
                WRK: 'badge-blue',
                DLV: 'badge-green',
                EMG: 'badge-red'
            };

            // SUBMIT_DOC_STTS
            var STTS_TEXT = {SUBMIT: '승인대기', APRV: '승인완료', REJT: '반려', REQ: '제출요청'};
            var STTS_BADGE = {SUBMIT: 'badge-yellow', APRV: 'badge-green', REJT: 'badge-red', REQ: 'badge-gray'};

            /!* ── 더미 데이터 (백엔드 연결 시 AJAX 대체) ── *!/

            let rqstData = [];

            let allData = [];


            var currentRqstIdx = null;
            var currentRegIdx = null;
            var deleteTargetIdx = null;
            var deleteTargetArr = null;
            var rejectTargetIds = [];

            /!* ── 헬퍼 ── *!/

            function b(cls, text) {
                return '<span class="badge ' + cls + '">' + text + '</span>';
            }

            function vhclTyBadge(cd) {
                return b(VHCL_TY_BADGE[cd] || 'badge-gray', VHCL_TY_TEXT[cd] || cd);
            }

            function sttsBadge(cd) {
                return b(STTS_BADGE[cd] || 'badge-gray', STTS_TEXT[cd] || cd);
            }

            function di(label, value) {
                return '<div class="mngr-detail-item">'
                    + '<div class="mngr-detail-label">' + label + '</div>'
                    + '<div class="mngr-detail-value">' + value + '</div>'
                    + '</div>';
            }

            /!* ── 요약 카드 ── *!/

            function updateStats() {
                var total = rqstData.length + allData.filter(function (r) {
                    return r.regType === 'OFFLINE';
                }).length;
                var pending = rqstData.filter(function (r) {
                    return r.stts === 'SUBMIT';
                }).length;
                var aprv = rqstData.filter(function (r) {
                    return r.stts === 'APRV';
                }).length;
                var rejt = rqstData.filter(function (r) {
                    return r.stts === 'REJT';
                }).length;

                document.getElementById('statTotal').textContent = total;
                document.getElementById('statPending').textContent = pending;
                document.getElementById('statApproved').textContent = aprv;
                document.getElementById('statRejected').textContent = rejt;

                var banner = document.getElementById('pendingBanner');
                if (pending > 0) {
                    banner.style.display = 'flex';
                    document.getElementById('pendingBannerText').innerHTML =
                        '<strong>승인 대기 중인 차량 신청이 ' + pending + '건 있습니다.</strong> 아래 목록에서 확인 후 처리해 주세요.';
                } else {
                    banner.style.display = 'none';
                }
            }

            /!* ── 탭 전환 ── *!/

            function switchTab(tabId) {
                page.querySelectorAll('.tab-panel').forEach(function (el) {
                    el.classList.remove('active');
                });
                page.querySelectorAll('.tab-btn').forEach(function (btn) {
                    btn.classList.toggle('active', btn.dataset.tab === tabId);
                });
                var panel = document.getElementById(tabId);
                if (panel) panel.classList.add('active');
            }

            page.querySelectorAll('.tab-btn').forEach(function (btn) {
                btn.addEventListener('click', function () {
                    switchTab(btn.dataset.tab);
                });
            });

            /!* ── 탭1 : 신청 목록 렌더 ── *!/

            function renderRqst(data) {
                var tbody = document.getElementById('rqstTbody');
                document.getElementById('rqstListCount').textContent = data.length + '건';
                document.getElementById('rqstFooterText').innerHTML = '총 <strong>' + data.length + '</strong>건';

                if (data.length === 0) {
                    tbody.innerHTML = '<tr><td colspan="9" class="empty-row">조건에 맞는 신청이 없습니다.</td></tr>';
                    return;
                }

                tbody.innerHTML = data.map(function (r, i) {
                    var isPending = r.stts === 'SUBMIT';
                    return '<tr class="' + (isPending ? 'row-pending' : '') + '">'
                        + '<td class="col-check"><input type="checkbox" class="rqst-check row-check" data-id="' +r.rsidVhclNo + '"></td>'
                        + '<td class="td-bold">' + (r.userNo || '-') + '</td>'
                        + '<td>' + (r.hoNo || '-') + '</td>'

                        + '<td class="col-center">' + vhclTyBadge(r.vhclTyCd) + '</td>'
                        + '<td>' + r.vhclNm + '</td>'
                        + '<td class="td-mono">' + r.vhclNo + '</td>'
                        + '<td class="col-center">' + r.regDt + '</td>'
                        + '<td class="col-center">' + sttsBadge(r.stts) + '</td>'
                        + '<td class="col-manage"><div class="grid-actions">'
                        + '<button type="button" class="btn btn-xs btn-detail" data-action="rqstDetail" data-id="' + r.rsidVhclNo + '">상세</button>'
                        + (isPending
                            ? '<button type="button" class="btn btn-xs btn-edit" data-action="approveOne" data-id="' + r.rsidVhclNo + '">승인</button>'
                            + '<button type="button" class="btn btn-xs btn-delete" data-action="openRejectOne" data-id="' + r.rsidVhclNo+ '">반려</button>'
                            : '')
                        + '</div></td>'
                        + '</tr>';
                }).join('');

                // 체크박스 이벤트 재바인딩
                bindRowChecks();
            }

            /!* ── 탭2 : 전체 차량 렌더 ── *!/

            function renderAll(data) {
                var tbody = document.getElementById('allTbody');
                document.getElementById('allListCount').textContent = data.length + '건';

                if (data.length === 0) {
                    tbody.innerHTML = '<tr><td colspan="8" class="empty-row">등록된 차량이 없습니다.</td></tr>';
                    return;
                }

                tbody.innerHTML = data.map(function (r, i) {
                    var regTypeBadge =
                        '<span class="badge badge-gray">직접등록</span>';
                    return '<tr>'
                        + '<td class="td-bold">' + (r.userNo || '-') + '</td>'
                        + '<td>' + (r.hoNo || '-') + '</td>'
                        + '<td class="col-center">' + vhclTyBadge(r.vhclTyCd) + '</td>'
                        + '<td>' + r.vhclNm + '</td>'
                        + '<td class="td-mono">' + r.vhclNo + '</td>'
                        + '<td class="col-center">' + regTypeBadge + '</td>'
                        + '<td class="col-center">' + r.regDt + '</td>'
                        + '<td class="col-manage"><div class="grid-actions">'
                        + '<button type="button" class="btn btn-xs btn-detail" data-action="allDetail" data-idx="' + i + '">상세</button>'
                        + '<button type="button" class="btn btn-xs btn-edit"   data-action="allEdit"   data-idx="' + i + '">수정</button>'
                        + '<button type="button" class="btn btn-xs btn-delete" data-action="openDelete" data-src="all" data-id="' +r.rsidVhclNo + '">삭제</button>'
                        + '</div></td>'
                        + '</tr>';
                }).join('');
            }

            /* ── 체크박스 ── */
            function bindRowChecks() {
                document.getElementById('checkAll').checked = false;
                updateBulkBar();

                page.querySelectorAll('.row-check').forEach(function (chk) {
                    chk.addEventListener('change', updateBulkBar);
                });
            }

            function getCheckedIds() {
                return Array.prototype.slice.call(
                    page.querySelectorAll('.row-check:checked')
                ).map(function (c) {
                    return c.dataset.id;
                });
            }

            function updateBulkBar() {
                var ids = getCheckedIds();
                var bar = document.getElementById('bulkBar');
                if (ids.length > 0) {
                    bar.classList.add('visible');
                    document.getElementById('bulkBarText').textContent = ids.length + '건 선택됨';
                } else {
                    bar.classList.remove('visible');
                }
            }

            document.getElementById('checkAll').addEventListener('change', function () {
                page.querySelectorAll('.row-check').forEach(function (c) {
                    c.checked = this.checked;
                }.bind(this));
                updateBulkBar();
            });

            /* ── 필터 ── */
            function getFilteredRqst() {

                var stts = document.getElementById('filterRqstStts').value;
                var start = document.getElementById('filterRqstStart').value;
                var end = document.getElementById('filterRqstEnd').value;
                var kw = document.getElementById('filterRqstKeyword').value.trim();

                return rqstData.filter(function (r) {

                    return (!stts || r.stts === stts)
                        && (!start || r.regDt >= start)
                        && (!end || r.regDt <= end)
                        && (!kw
                            || (r.dong + r.ho).indexOf(kw) > -1
                            || r.vhclNo.indexOf(kw) > -1
                            || r.userNm.indexOf(kw) > -1);
                });
            }

            function getFilteredAll() {

                var regType = document.getElementById('filterRegType').value;
                var kw = document.getElementById('filterAllKeyword').value.trim();

                return allData.filter(function (r) {

                    return (!regType || r.regType === regType)
                        && (!kw
                            || (r.dong + r.ho).indexOf(kw) > -1
                            || r.vhclNo.indexOf(kw) > -1
                            || r.userNm.indexOf(kw) > -1);
                });
            }

            /* ── 모달 제어 ── */
            function openModal(id) {
                document.getElementById(id).classList.add('open');
            }

            function closeModal(id) {
                document.getElementById(id).classList.remove('open');
            }

            // 신청 상세 모달
            function openRqstDetail(id) {
                var r = rqstData.find(function (x) {
                    return x.rsidVhclNo === id;
                });
                if (!r) return;
                currentRqstIdx = id;

                document.getElementById('rqstModalTitle').textContent = '차량 신청 상세 · ' + r.rsidVhclNo;

                document.getElementById('rqstDetailGrid').innerHTML =
                    di('신청자 · USER_NM', r.userNm)
                    + di('세대 · HO_NO', r.dong + ' ' + r.ho)
                    + di('신청일 · REG_DT', r.regDt)
                    + di('처리상태 · SUBMIT_DOC_STTS', sttsBadge(r.stts));

                document.getElementById('rqstVhclGrid').innerHTML =
                    di('차량번호 · VHCL_NO', '<span class="td-mono">' + r.vhclNo + '</span>')
                    + di('차량명 · VHCL_NM', r.vhclNm)
                    + di('차량유형 · VST_VHCL_TY_CD', vhclTyBadge(r.vhclTyCd))
                    + di('등록방법', '<span class="badge badge-blue">온라인 신청</span>');

                document.getElementById('rqstImgName').textContent = r.imgNm || '';

                var rejectWrap = document.getElementById('rejectReasonWrap');
                if (r.stts === 'REJT' && r.rejectReason) {
                    rejectWrap.classList.add('visible');
                    document.getElementById('rejectReasonText').textContent = r.rejectReason;
                } else {
                    rejectWrap.classList.remove('visible');
                }

                var approveBtn = document.getElementById('rqstApproveBtn');
                var rejectBtn = document.getElementById('rqstRejectBtn');
                if (r.stts === 'SUBMIT') {
                    approveBtn.style.display = 'inline-flex';
                    rejectBtn.style.display = 'inline-flex';
                    approveBtn.dataset.id = id;
                } else {
                    approveBtn.style.display = 'none';
                    rejectBtn.style.display = 'none';
                }

                openModal('rqstModal');
            }

            // 반려 사유 입력 모달
            function openRejectModal(ids) {
                rejectTargetIds = Array.isArray(ids) ? ids : [ids];
                document.getElementById('rejectReasonInput').value = '';
                openModal('rejectModal');
            }

            // 직접 등록 / 수정 모달
            var regForm = document.getElementById('regForm');
            var regSaveBtn = document.getElementById('regSaveBtn');
            var regEditBtn = document.getElementById('regEditBtn');
            var regDeleteBtn = document.getElementById('regDeleteBtn');


            function openRegModal(mode, idx) {
                regForm.reset();
                document.getElementById('imgPreviewArea').style.display = 'none';
                regSaveBtn.style.display = 'inline-flex';
                regEditBtn.style.display = 'none';
                regDeleteBtn.style.display = 'none';
                setRegDisabled(false);
                currentRegIdx = idx !== undefined ? idx : null;

                if (mode === 'register') {
                    document.getElementById('regModalTitle').textContent = '차량 직접 등록';
                }
                if (mode === 'detail' && currentRegIdx !== null) {
                    document.getElementById('regModalTitle').textContent = '차량 상세';
                    fillRegForm(allData[currentRegIdx]);
                    setRegDisabled(true);
                    regSaveBtn.style.display = 'none';
                    regEditBtn.style.display = 'inline-flex';
                    regDeleteBtn.style.display = 'inline-flex';
                    regEditBtn.dataset.idx = currentRegIdx;
                }
                if (mode === 'edit' && currentRegIdx !== null) {
                    document.getElementById('regModalTitle').textContent = '차량 수정';
                    fillRegForm(allData[currentRegIdx]);
                    regDeleteBtn.style.display = 'inline-flex';
                }
                openModal('regModal');
            }

            function fillRegForm(r) {

                regForm.userNo.value = r.userNo || '';

                regForm.hoNo.value = r.hoNo || '';

                regForm.vhclNo.value = r.vhclNo || '';

                regForm.vhclNm.value = r.vhclNm || '';
            }

            function setRegDisabled(disabled) {
                regForm.querySelectorAll('input, select').forEach(function (el) {
                    el.disabled = disabled;
                });
            }

            // 삭제 확인 모달
            function openDeleteModal(src, id) {

                deleteTargetArr = src === 'all' ? allData : rqstData;

                var target = deleteTargetArr.find(function (r) {
                    return r.rsidVhclNo=== id;
                });

                if (!target) {
                    alert('삭제 대상 정보를 찾을 수 없습니다.');
                    return;
                }

                deleteTargetIdx = deleteTargetArr.indexOf(target);

                document.getElementById('deleteTargetInfo').innerHTML =
                    di('입주민', target.userNm || '-')
                    + di('세대', (target.dong || '') + ' ' + (target.ho || ''))
                    + di('차량번호 · VHCL_NO', target.vhclNo || '-')
                    + di('차량명 · VHCL_NM', target.vhclNm || '-');

                openModal('deleteModal');
            }

            function approveById(id) {

                var r = rqstData.find(function (x) {
                    return x.rsidVhclNo === id;
                });

                if (!r) return;

                // 이미 승인된 경우 종료
                if (r.stts === 'APRV') {
                    return;
                }

                r.stts = 'APRV';

                // 이미 등록되어 있는지 확인
                var exists = allData.some(function (v) {
                    return v.rsidVhclNo === r.rsidVhclNo;
                });

                // 없을 때만 추가
                if (!exists) {

                    allData.push({
                        rsidVhclNo: r.rsidVhclNo,
                        userNm: r.userNm,
                        dong: r.dong,
                        ho: r.ho,
                        vhclTyCd: r.vhclTyCd,
                        vhclNm: r.vhclNm,
                        vhclNo: r.vhclNo,
                        regDt: r.regDt,
                        regType: 'ONLINE'
                    });

                }
            }

            /* ── 이미지 업로드 미리보기 ── */
            document.getElementById('vhclImgInput').addEventListener('change', function () {
                var f = this.files[0];
                if (!f) return;
                document.getElementById('imgPreviewArea').style.display = 'block';
                document.getElementById('imgPreviewName').textContent = f.name;
                if (f.type.indexOf('image') > -1) {
                    var reader = new FileReader();
                    reader.onload = function (e) {
                        document.getElementById('imgPreviewEl').src = e.target.result;
                    };
                    reader.readAsDataURL(f);
                }
            });

            /* ── 이벤트 위임 ── */
            page.addEventListener('click', function (e) {
                e.preventDefault();
                var btn = e.target.closest('[data-action]');
                if (!btn) return;
                var action = btn.dataset.action;
                var id = btn.dataset.id;
                var idx = btn.dataset.idx !== undefined ? Number(btn.dataset.idx) : undefined;
                var src = btn.dataset.src;

                // 탭 1 신청 목록
                if (action === 'rqstDetail') openRqstDetail(id);
                if (action === 'closeRqstModal') closeModal('rqstModal');

                if (action === 'approveOne') {
                    approveById(id || currentRqstIdx);
                    closeModal('rqstModal');
                    renderRqst(rqstData);
                    renderAll(allData);
                    updateStats();
                    alert('승인 처리되었습니다. 입주민에게 알림이 발송됩니다.');
                }

                if (action === 'openRejectReason') openRejectModal(currentRqstIdx);
                if (action === 'openRejectOne') openRejectModal(id);
                if (action === 'closeRejectModal') closeModal('rejectModal');

                // 일괄 처리
                if (action === 'bulkApprove') {
                    var ids = getCheckedIds();
                    if (ids.length === 0) {
                        alert('선택된 항목이 없습니다.');
                        return;
                    }
                    ids.forEach(function (i) {
                        approveById(i);
                    });
                    renderRqst(rqstData);
                    renderAll(allData);
                    updateStats();
                    alert(ids.length + '건 승인 처리되었습니다.');
                }
                if (action === 'bulkReject') {
                    var ids = getCheckedIds();
                    if (ids.length === 0) {
                        alert('선택된 항목이 없습니다.');
                        return;
                    }
                    openRejectModal(ids);
                }

                // 탭 2 전체 차량
                if (action === 'openRegister') openRegModal('register');
                if (action === 'allDetail') openRegModal('detail', idx);
                if (action === 'allEdit') openRegModal('edit', idx);
                if (action === 'changeToEdit') openRegModal('edit', Number(regEditBtn.dataset.idx));
                if (action === 'closeRegModal') closeModal('regModal');
                if (action === 'openDelete') openDeleteModal(src, id);
                if (action === 'closeDeleteModal') closeModal('deleteModal');
                if (action === 'searchRqst') renderRqst(getFilteredRqst());
                if (action === 'searchAll') renderAll(getFilteredAll());
                if (action === 'resetRqst') {
                    ['filterRqstStts', 'filterRqstStart', 'filterRqstEnd', 'filterRqstKeyword']
                        .forEach(function (id) {
                            document.getElementById(id).value = '';
                        });
                    renderRqst(rqstData);
                }
                if (action === 'resetAll') {
                    ['filterRegType', 'filterAllKeyword']
                        .forEach(function (id) {
                            document.getElementById(id).value = '';
                        });
                    renderAll(allData);
                }
            });

            document.getElementById('rejectConfirmBtn').addEventListener('click', function () {
                var reason = document.getElementById('rejectReasonInput').value.trim();
                if (!reason) {
                    alert('반려 사유를 입력해 주세요.');
                    return;
                }
                rejectTargetIds.forEach(function (id) {
                    var r = rqstData.find(function (x) {
                        return x.rsidVhclNo === id;
                    });
                    if (r) {
                        r.stts = 'REJT';
                        r.rejectReason = reason;
                    }
                });
                closeModal('rejectModal');
                closeModal('rqstModal');
                renderRqst(rqstData);
                updateStats();
                alert(rejectTargetIds.length + '건 반려 처리되었습니다.');
            });

            regForm.addEventListener('submit', async function (e) {

                e.preventDefault();

                if (!regForm.vhclNo.value.trim()) {

                    alert('차량번호를 입력하세요.');

                    return;
                }

                try {

                    const formData = new FormData();

                    formData.append("userNo", regForm.userNo.value);
                    formData.append("hoNo", regForm.hoNo.value);
                    formData.append("vhclNo", regForm.vhclNo.value);
                    formData.append("vhclNm", regForm.vhclNm.value);

                    const fileInput =
                        document.getElementById("vhclImgInput");

                    if (fileInput.files.length > 0) {

                        formData.append(
                            "uploadFile",
                            fileInput.files[0]
                        );
                    }

                    // 수정일 경우 PK 추가
                    if (currentRegIdx !== null) {

                        formData.append(
                            "rsidVhclNo",
                            allData[currentRegIdx].rsidVhclNo
                        );
                    }

                    const token =
                        document.querySelector('meta[name="_csrf"]').content;

                    const header =
                        document.querySelector('meta[name="_csrf_header"]').content;

                    const url = currentRegIdx !== null
                        ? CONTEXT_PATH + '/manager/resident/auto/update'
                        : CONTEXT_PATH + '/manager/resident/auto/register';

                    const response = await fetch(
                        url,
                        {
                            method: 'POST',
                            headers: {
                                [header]: token
                            },
                            body: formData
                        }
                    );

                    // 서버 에러 출력
                    if (!response.ok) {

                        const errMsg = await response.text();

                        console.error(errMsg);

                        alert(errMsg);

                        return;
                    }

                    const result = await response.text();

                    console.log(result);

                    await loadVehicleList();

                    alert(
                        currentRegIdx !== null
                            ? "차량 수정 완료"
                            : "차량 등록 완료"
                    );

                    closeModal('regModal');

                    regForm.reset();

                    currentRegIdx = null;

                } catch (err) {

                    console.error(err);

                    alert("등록 중 오류 발생");
                }
            });
            document.getElementById('deleteConfirmBtn').addEventListener('click', async function () {

                if (deleteTargetIdx === null || !deleteTargetArr) {
                    return;
                }
                const target = deleteTargetArr[deleteTargetIdx];
                if (!target || !target.rsidVhclNo) {
                    alert('삭제 대상 정보가 없습니다.');
                    return;
                }
                try {
                    const token = document.querySelector('meta[name="_csrf"]').content;
                    const header = document.querySelector('meta[name="_csrf_header"]').content;


                    const formData = new FormData();

                    formData.append("rsidVhclNo", target.rsidVhclNo);
                    const response = await fetch(
                        CONTEXT_PATH + '/manager/resident/auto/delete',
                        {
                            method: 'POST',
                            headers: {
                                [header]: token
                            },
                            body: formData
                        }
                    );

                    if (!response.ok) {
                        throw new Error('삭제 실패');
                    }

                    await loadVehicleList();

                    closeModal('deleteModal');

                    closeModal('regModal');

                    alert('삭제되었습니다.');
                } catch (e) {
                    console.error(e);
                    alert('삭제 중 오류 발생');
                }
            });

            ['rqstModal', 'rejectModal', 'regModal', 'deleteModal'].forEach(function (id) {
                var el = document.getElementById(id);
                el.addEventListener('click', function (e) {
                    if (e.target === el) closeModal(id);
                });
            });


        async function loadVehicleList() {

            try {

                const response = await fetch(
                    CONTEXT_PATH + '/manager/resident/auto/list'
                );

                if (!response.ok) {

                    throw new Error('목록 조회 실패');
                }

                const data = await response.json();

                allData = data;

                renderAll(allData);

                updateStats();

            } catch (e) {

                console.error(e);

                alert('차량 목록 조회 실패');
            }
        }

        renderRqst(rqstData);

        loadVehicleList();

        })();
    </script>
</html>
    </main>
</div>

</div>
</html>

