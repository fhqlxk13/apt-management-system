<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>아파트 호 일괄 관리</title>

    <sec:csrfMetaTags/>

    <link rel="preconnect" href="https://fonts.googleapis.com"/>
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin/>

    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap"
          rel="stylesheet"/>

    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0"
          rel="stylesheet"/>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/office-layout.css">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/manager/manager-common.css">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/mgmtOfc/mngr_building_layout_edit.css">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/member/resident/residentVhcl.css">

    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/ag-grid-community/styles/ag-theme-alpine.css">

    <script src="https://cdn.jsdelivr.net/npm/ag-grid-community/dist/ag-grid-community.min.js"></script>

</head>

<body>

<div class="app-wrapper">

    <%@ include file="/WEB-INF/views/include/office_sidebar.jsp" %>

    <div class="main-wrap">

        <%@ include file="/WEB-INF/views/include/office_header.jsp" %>

        <main class="main-content">

            <div class="office-page unit-manage-page">

                <!-- =====================================================
                     메인 컨텐츠
                ===================================================== -->
                <div class="unit-manage-wrap"
                     data-mgmt-ofc-no="${mgmtOfcNo}"
                     data-apt-cmplex-no="${complex.aptCmplexNo}"
                     data-apt-cmplex-nm="${complex.aptCmplexNm}">

                    <!-- =====================================================
                         상단 구조 설정
                    ====================================================== -->
                    <section class="unit-top-panel">

                        <div class="unit-top-grid">

                            <div class="form-field">

                                <label class="field-label">
                                    동 선택
                                </label>

                                <select class="form-select"
                                        id="dongSelect">
                                </select>

                            </div>

                            <div class="form-field">

                                <label class="field-label">
                                    동 이름 변경
                                </label>

                                <input type="text"
                                       class="form-input"
                                       id="dongNameInput"
                                       placeholder="동 이름 입력">

                            </div>

                            <div class="form-field">

                                <label class="field-label">
                                    총 층수
                                </label>

                                <input type="number"
                                       class="form-input"
                                       id="totalFloorInput">

                            </div>

                            <div class="form-field">

                                <label class="field-label">
                                    층별 세대수
                                </label>

                                <input type="number"
                                       class="form-input"
                                       id="hoPerFloorInput">

                            </div>

                            <div class="form-field">

                                <label class="field-label">
                                    현재 세대수
                                </label>

                                <input type="text"
                                       class="form-input"
                                       id="totalHoInput"
                                       readonly>

                            </div>

                            <div class="unit-top-actions">

                                <button type="button"
                                        class="btn btn-primary"
                                        id="btnApplyStructure">

                                    구조 변경 적용

                                </button>

                            </div>

                        </div>

                    </section>

                    <!-- =====================================================
                         메인 영역
                    ====================================================== -->
                    <section class="unit-main-grid">

                        <!-- =====================================================
                             좌측 층별 배치도
                        ====================================================== -->
                        <div class="unit-layout-panel">

                            <div class="unit-panel-title unit-layout-title">

                                <div class="layout-title-left">

                                <span class="material-symbols-rounded layout-title-icon">
                                    apartment
                                </span>

                                    <div>

                                        <div class="layout-main-title"
                                             id="layoutTitle">
                                            배치도
                                        </div>

                                        <div class="layout-sub-title">
                                            동별 세대 구조를 확인할 수 있습니다.
                                        </div>
                                        <div class="layout-legend">

                                            <div class="legend-item">
                                                <span class="legend-color empty"></span>
                                                공실
                                            </div>

                                            <div class="legend-item">
                                                <span class="legend-color live"></span>
                                                거주중
                                            </div>

                                            <div class="legend-item">
                                                <span class="legend-color disabled"></span>
                                                비활성
                                            </div>

                                        </div>

                                    </div>

                                </div>

                            </div>

                            <div class="unit-layout-grid"
                                 id="unitLayoutGrid">

                            </div>

                        </div>
                        <!-- =====================================================
                             우측 테이블 영역
                        ====================================================== -->

                        <div class="unit-table-panel">

                            <!-- 상단 액션 -->
                            <div class="unit-table-top">

                                <!-- 좌측 -->
                                <div class="unit-table-actions">

                                    <button type="button"
                                            class="btn btn-primary btn-type-manage"
                                            id="btnOpenTypeDrawer">

                                        평형 타입 관리

                                    </button>

                                </div>

                                <!-- 우측 -->
                                <div class="unit-bulk-actions">

                                    <!-- 상태 변경 -->
                                    <div class="unit-bulk-box">

                                        <select class="form-select"
                                                id="hoStatusSelect">

                                            <option value="">
                                                상태 선택
                                            </option>

                                            <option value="EMPTY">
                                                활성(공실)
                                            </option>

                                            <option value="DISABLED">
                                                비활성
                                            </option>

                                        </select>

                                        <button type="button"
                                                class="btn btn-primary"
                                                id="btnApplyHoStatus">

                                            선택 호 상태 적용

                                        </button>

                                    </div>

                                    <!-- 평형 변경 -->
                                    <div class="unit-bulk-box">

                                        <select class="form-select"
                                                id="hoTypeSelect">

                                            <option value="">
                                                평형 선택
                                            </option>

                                        </select>

                                        <button type="button"
                                                class="btn btn-primary"
                                                id="btnApplyHoType">

                                            선택 호 평형 적용

                                        </button>

                                    </div>

                                </div>

                            </div>


                            <!-- GRID -->
                            <div class="unit-table-area">

                                <div id="unitGrid"
                                     class="ag-theme-alpine unit-grid">
                                </div>

                            </div>

                        </div>


                    </section>

                </div>

            </div>

        </main>

    </div>

</div>


<!-- =====================================================
     평형 타입 Drawer
===================================================== -->
<div class="ho-type-drawer"
     id="hoTypeDrawer">

    <!-- 헤더 -->
    <div class="ho-type-drawer-header">

        <div>

            <h3 class="ho-type-drawer-title">
                평형 타입 관리
            </h3>

            <p class="ho-type-drawer-desc">
                단지에서 사용하는 평형 타입을 관리할 수 있습니다.
            </p>

        </div>

        <button type="button"
                class="drawer-close-btn"
                id="btnCloseTypeDrawer">

            <span class="material-symbols-rounded">
                close
            </span>

        </button>

    </div>

    <!-- 리스트 영역 -->
    <div class="ho-type-drawer-body" id="hoTypeList">


    </div>

    <!-- 하단 -->
    <div class="ho-type-drawer-footer">

        <button type="button"
                class="btn btn-primary w-full"
                id="btnOpenTypeModal">

            + 새 평형 타입 추가

        </button>

    </div>

</div>

<!-- Drawer 배경 -->
<div class="drawer-backdrop"
     id="drawerBackdrop">
</div>

<!-- =====================================================
     평형 타입 추가 모달
===================================================== -->
<div class="ho-type-modal"
     id="hoTypeModal">

    <div class="ho-type-modal-content">

        <!-- 헤더 -->
        <div class="ho-type-modal-header">

            <div>

                <h3 class="ho-type-modal-title">
                    새 평형 타입 추가
                </h3>

                <p class="ho-type-modal-desc">
                    단지에서 사용할 평형 타입 정보를 등록합니다.
                </p>

            </div>

            <button type="button"
                    class="drawer-close-btn"
                    id="btnCloseTypeModal">

                <span class="material-symbols-rounded">
                    close
                </span>

            </button>

        </div>

        <!-- 바디 -->
        <div class="ho-type-modal-body">

            <div class="ho-type-inline-grid">

                <!-- 타입명 -->
                <div class="form-field">

                    <label class="field-label">
                        타입명
                    </label>

                    <input type="text" id="tyNm" class="form-input" placeholder="예: 84A">

                </div>

                <!-- 전용면적 -->
                <div class="form-field">

                    <label class="field-label">
                        전용면적
                    </label>

                    <input type="number" id="exclusiveSize" class="form-input" placeholder="84">

                </div>

            </div>


            <!-- 방/욕실 -->
            <div class="ho-type-inline-grid">

                <div class="form-field">

                    <label class="field-label">
                        방 수
                    </label>

                    <input type="number" id="roomCnt" class="form-input" placeholder="3">

                </div>

                <div class="form-field">

                    <label class="field-label">
                        욕실 수
                    </label>

                    <input type="number" id="bathroomCnt" class="form-input" placeholder="2">

                </div>

            </div>

            <!-- 이미지 업로드 -->
            <div class="form-field">

                <label class="field-label">
                    도면 이미지
                </label>

                <div id="hoUploadBox"
                     class="upload-box">

                    <input
                            type="file"
                            id="hoTypeImage"
                            hidden
                            accept="image/*">

                    <!-- 기본 상태 -->
                    <div class="upload-content">

                        <div class="upload-plus">
                            +
                        </div>

                        <div class="upload-text">
                            파일을 드래그하거나 클릭하여 업로드
                        </div>

                    </div>

                    <!-- 썸네일 -->
                    <div id="hoPreviewCard"
                         class="preview-card">

                        <img
                                id="hoPreviewImg"
                                class="preview-img">

                        <button
                                type="button"
                                id="hoRemoveBtn"
                                class="remove-btn">

                            ×

                        </button>

                    </div>
                </div>

            </div>

        </div>

        <!-- 푸터 -->
        <div class="ho-type-modal-footer">

            <button type="button"
                    class="btn btn-secondary"
                    id="btnCancelTypeModal">

                취소

            </button>

            <button type="button" class="btn btn-primary" id="btnInsertHoType">
                평형 타입 추가
            </button>

        </div>

    </div>

</div>

<!-- 모달 배경 -->
<div class="ho-type-modal-backdrop"
     id="hoTypeModalBackdrop">
</div>


<script src="${pageContext.request.contextPath}/js/mgmtOfc/mngr_ho_ty_edit.js"></script>
<script src="${pageContext.request.contextPath}/js/mgmtOfc/mngr_building_layout_edit.js"></script>

</body>
</html>