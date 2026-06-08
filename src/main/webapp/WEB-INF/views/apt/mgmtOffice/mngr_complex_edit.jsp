<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>단지 정보 수정</title>

    <sec:csrfMetaTags/>

    <link rel="preconnect" href="https://fonts.googleapis.com"/>
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin/>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap"
          rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0"
          rel="stylesheet"/>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/office-layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/manager-common.css">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/mgmtOfc/mngr_complex_edit.css">

</head>

<body>
<div class="app-wrapper">

    <%@ include file="/WEB-INF/views/include/office_sidebar.jsp" %>

    <div class="main-wrap">

        <%@ include file="/WEB-INF/views/include/office_header.jsp" %>

        <main class="main-content">
            <div class="office-page" id="complexEditPage">

                <div class="page-header">
                    <div class="page-title-block">
                        <h2>단지 정보 수정</h2>
                        <p>아파트 단지의 기본 정보, 위치, 시설 현황을 수정합니다.</p>
                    </div>

                </div>

                <form id="complexEditForm" enctype="multipart/form-data">

                    <div id="remainLayoutHiddenArea"></div>

                    <div id="remainComplexHiddenArea"></div>

                    <!-- =====================================================
                         hidden metadata
                    ===================================================== -->

                    <input type="hidden"
                           id="imgFileNo"
                           name="imgFileNo"
                           >

<%--                    <input type="hidden"
                           id="rprsntImgFileNo"
                           name="rprsntImgFileNo"
                           >--%>


                    <!-- 정렬 순서 -->

                    <div class="panel">

                        <div class="panel-header">
                            <h3 class="panel-title">
                                <span class="material-symbols-rounded">apartment</span>
                                기본 정보
                            </h3>
                        </div>

                        <div class="panel-body">

                            <div class="form-section">

                                <!-- 1줄 -->
                                <div class="form-row cols-3 basic-info-row">

                                    <div class="form-field">
                                        <label class="field-label">아파트명</label>

                                        <input type="text"
                                               class="form-input"
                                               id="aptCmplexNm"
                                               name="aptCmplexNm"
                                               >
                                    </div>

                                    <div class="form-field">
                                        <label class="field-label">단지번호</label>

                                        <input type="text"
                                               class="form-input readonly-input"
                                               id="aptCmplexNo"
                                               name="aptCmplexNo"
                                               readonly>
                                    </div>

                                    <div class="form-field">
                                        <label class="field-label">법정동코드</label>

                                        <input type="text"
                                               class="form-input readonly-input"
                                               id="bjdCd"
                                               name="bjdCd"

                                               readonly>
                                    </div>

                                </div>

                                <!-- 3줄 -->
                                <div class="form-row cols-3 basic-info-row">

                                    <div class="form-field">
                                        <label class="field-label">시도</label>

                                        <input type="text"
                                               class="form-input readonly-input"
                                               id="sidoNm"
                                               name="sidoNm"

                                               readonly>

                                    </div>

                                    <div class="form-field">
                                        <label class="field-label">시군구</label>

                                        <input type="text"
                                               class="form-input readonly-input"
                                               id="sigunguNm"
                                               name="sigunguNm"

                                               readonly>

                                    </div>

                                    <div class="form-field">
                                        <label class="field-label">읍면동</label>

                                        <input type="text"
                                               class="form-input readonly-input"
                                               id="emdNm"
                                               name="emdNm"

                                               readonly>

                                    </div>

                                </div>

                                <!-- 4줄 -->
                                <div class="form-row">

                                    <div class="form-field">

                                        <label class="field-label">도로명 주소</label>

                                        <div class="address-inline-group">

                                            <input type="text"
                                                   class="form-input flex-1"
                                                   id="dorojuso"
                                                   name="dorojuso"
                                                   placeholder="주소 검색 버튼을 눌러주세요"
                                                   readonly>

                                            <button type="button"
                                                    class="btn btn-address-sync"
                                                    id="btnSyncAddress">

                                                <span class="material-symbols-rounded">sync</span>
                                                주소 정보 동기화
                                            </button>

                                        </div>

                                    </div>

                                </div>

                            </div>

                        </div>

                    </div>

                    <!-- =====================================================
                         섹션 2. 단지 현황
                    ====================================================== -->
                    <div class="panel">
                        <div class="panel-header">
                            <h3 class="panel-title">
                                <span class="material-symbols-rounded">domain</span>
                                단지 현황
                            </h3>
                        </div>

                        <div class="panel-body">
                            <div class="form-section">
                                <div class="form-row cols-3 basic-info-row">

                                    <div class="form-field">
                                        <label class="field-label">세대 수</label>

                                        <input type="text"
                                               class="form-input readonly-input"
                                               id="unitCnt"
                                               name="unitCnt"

                                               readonly>

                                    </div>

                                    <div class="form-field">
                                        <label class="field-label">동 수</label>

                                        <input type="text"
                                               class="form-input readonly-input"
                                               id="dongCnt"
                                               name="dongCnt"

                                               readonly>

                                    </div>

                                    <div class="form-field">
                                        <label class="field-label">최대 층수</label>

                                        <input type="text"
                                               class="form-input readonly-input"
                                               id="maxFloor"
                                               name="maxFloor"

                                               readonly>
                                    </div>

                                </div>

                                <div class="form-row cols-3 basic-info-row">
                                    <div class="form-field">
                                        <label class="field-label">주차 가능 대수</label>
                                        <input type="number"
                                               class="form-input"
                                               id="pkgCnt"
                                               name="pkgCnt"

                                               min="0"
                                               placeholder="예: 600">
                                    </div>

                                    <div class="form-field">
                                        <label class="field-label">세대당 무료 주차 대수</label>
                                        <input type="number"
                                               class="form-input"
                                               id="freePkgCnt"
                                               name="freePkgCnt"

                                               min="0"
                                               placeholder="예: 1">
                                    </div>

                                    <div class="form-field">
                                        <label class="field-label">CCTV 수</label>
                                        <input type="text"
                                               class="form-input"
                                               id="ccCnt"
                                               name="ccCnt"

                                               placeholder="예: 32">
                                    </div>
                                </div>

                                <div class="form-row cols-2">
                                    <div class="form-field">
                                        <label class="field-label">준공 연도</label>
                                        <input type="text"
                                               class="form-input"
                                               id="bldYr"
                                               name="bldYr"

                                               maxlength="8"
                                               placeholder="예: 20050301">
                                    </div>

                                    <div class="form-field">
                                        <label class="field-label">난방 방식</label>
                                        <select class="form-select"
                                                id="heatTy"
                                                name="heatTy">

                                            <option value="">선택</option>
                                            <option value="중앙난방">중앙난방</option>
                                            <option value="개별난방">개별난방</option>
                                            <option value="지역난방">지역난방</option>

                                        </select>
                                    </div>
                                </div>

                                <div class="form-row cols-1">
                                    <div class="form-field">
                                        <label class="field-label">건설사명</label>
                                        <input type="text"
                                               class="form-input"
                                               id="cnscoNm"
                                               name="cnscoNm"

                                               placeholder="예: 현대건설">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- =====================================================
                         섹션 4. 단지 이미지
                    ===================================================== -->
                    <div class="panel">

                        <div class="panel-header">
                            <h3 class="panel-title">
                                <span class="material-symbols-rounded">photo_library</span>
                                단지 이미지
                            </h3>
                        </div>

                        <div class="panel-body">

                            <div class="form-section">

                                <div class="form-row cols-2">

                                    <!-- =========================================
                                         배치도
                                    ========================================== -->
                                    <div class="form-field">

                                        <div class="complex-image-header">
                                            <button type="button"
                                                    class="btn-file-add"
                                                    id="btnAddLayout">
                                                <span class="material-symbols-rounded">
                                                    add
                                                </span>
                                                추가
                                            </button>

                                            <label class="field-label" style="font-size: 20px">
                                                배치도
                                            </label>

                                        </div>

                                        <!--
                                            JS 렌더링 구조

                                            <div class="complex-file-item"
                                                 data-file-key=""
                                                 data-file-type=""
                                                 data-file-group-no=""
                                                 data-file-no=""
                                                 data-google-file-id=""
                                                 data-sort-order="">
                                            </div>
                                        -->

                                        <input type="file"
                                               id="layoutFileInput"
                                               accept="image/*"
                                               multiple
                                               style="display:none;">

                                        <div class="complex-file-box">

                                            <div class="complex-file-list"
                                                 id="layoutFileList"
                                                 data-file-category="layout">

                                            </div>

                                        </div>

                                    </div>

                                    <!-- =========================================
                                         단지 사진
                                    ========================================== -->
                                    <div class="form-field">

                                        <div class="complex-image-header">
                                            <button type="button"
                                                    class="btn-file-add"
                                                    id="btnAddComplexImage">
                                                <span class="material-symbols-rounded">
                                                    add
                                                </span>
                                                추가
                                            </button>

                                            <label class="field-label" style="font-size: 20px">
                                                단지 사진
                                            </label>
                                        </div>

                                        <input type="file"
                                               id="complexImgFileInput"
                                               accept="image/*"
                                               multiple
                                               style="display:none;">

                                        <div class="complex-file-box">

                                            <div class="complex-file-list sortable-list"
                                                 id="complexImageFileList"
                                                 data-file-category="complex">

                                            </div>

                                        </div>

                                    </div>

                                </div>

                            </div>

                        </div>

                    </div>

                    <input type="hidden"
                           id="isImageChanged"
                           name="isImageChanged"
                           value="N">

                    <!-- =====================================================
                         하단 버튼
                    ====================================================== -->
                    <div class="panel complex-footer-panel">
                        <div class="modal-footer complex-footer">
                            <button type="button" class="btn btn-secondary" id="btnResetComplexBottom">
                                <span class="material-symbols-rounded">refresh</span>
                                초기화
                            </button>

                            <button type="submit" class="btn btn-primary" id="btnSaveComplexBottom">
                                <span class="material-symbols-rounded">save</span>
                                수정
                            </button>
                        </div>
                    </div>

                </form>
            </div>
        </main>
    </div>
</div>
<script>
    const CONTEXT_PATH = "${pageContext.request.contextPath}";
    const MGMT_OFC_NO = "${office != null ? office.mgmtOfcNo : ''}";
</script>
<script src="https://cdn.jsdelivr.net/npm/sortablejs@latest/Sortable.min.js"></script>
<script src="${pageContext.request.contextPath}/js/mgmtOfc/mngr_complex_edit.js"></script>
</body>
</html>
