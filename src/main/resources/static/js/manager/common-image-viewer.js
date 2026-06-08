/*
 * ============================================================
 * common-image-viewer.js
 * 이미지 클릭 확대 공통 모듈
 *
 * 역할
 * - 상세/등록/수정 화면의 이미지 클릭 시 확대 모달 표시
 * - 모달 배경 클릭 시 닫기
 * - 닫기 버튼 클릭 시 닫기
 * - ESC 키 입력 시 닫기
 *
 * 사용 예시
 * ------------------------------------------------------------
 * 1) JSP에서 script 추가
 *
 * <script src="${pageContext.request.contextPath}/js/manager/common-image-viewer.js"></script>
 *
 * 2) 페이지 JS에서 초기화
 *
 * CommonImageViewer.bind("#dtlImgGrid");
 * CommonImageViewer.bind("#regImgPreview");
 * CommonImageViewer.bind("#updImgPreview");
 *
 * 3) 클릭 가능한 이미지
 *
 * <img src="..." alt="시설사진">
 *
 * 주의
 * - selector로 넘긴 영역 안의 img를 자동으로 클릭 대상으로 잡음
 * - 동적으로 나중에 추가된 img도 클릭 가능
 * - JSP 레이아웃을 거의 건드리지 않기 위한 이벤트 위임 방식
 * ============================================================
 */
window.CommonImageViewer = (function () {

    /*
     * 모달 DOM id
     * - 한 화면에 하나만 생성
     */
    var MODAL_ID = "commonImageViewerModal";

    /*
     * 확대 이미지 DOM id
     * - 클릭한 이미지 src를 여기에 반영
     */
    var IMAGE_ID = "commonImageViewerImage";

    /*
     * 모달 생성 여부
     * - 중복 생성 방지용 플래그
     */
    var initialized = false;

    /**
     * 공통 모달 스타일 생성
     * - 별도 CSS 파일 없이 바로 사용 가능하도록 JS에서 style 삽입
     */
    function createStyle() {
        var styleId = "commonImageViewerStyle";

        // 이미 style이 있으면 다시 만들지 않음
        if (document.getElementById(styleId)) {
            return;
        }

        var style = document.createElement("style");
        style.id = styleId;

        style.textContent =
            "#commonImageViewerModal {" +
            "display:none;" +
            "position:fixed;" +
            "left:0;" +
            "top:0;" +
            "width:100%;" +
            "height:100%;" +
            "z-index:9999;" +
            "background:rgba(0,0,0,.72);" +
            "align-items:center;" +
            "justify-content:center;" +
            "padding:28px;" +
            "box-sizing:border-box;" +
            "}" +

            "#commonImageViewerModal.is-open {" +
            "display:flex;" +
            "}" +

            "#commonImageViewerModal .image-viewer-box {" +
            "position:relative;" +
            "max-width:min(960px, 92vw);" +
            "max-height:88vh;" +
            "background:#fff;" +
            "border-radius:8px;" +
            "box-shadow:0 18px 45px rgba(0,0,0,.35);" +
            "overflow:hidden;" +
            "}" +

            "#commonImageViewerModal .image-viewer-head {" +
            "display:flex;" +
            "align-items:center;" +
            "justify-content:space-between;" +
            "height:42px;" +
            "padding:0 12px 0 16px;" +
            "border-bottom:1px solid #e5e7eb;" +
            "background:#fff;" +
            "}" +

            "#commonImageViewerModal .image-viewer-title {" +
            "font-size:13px;" +
            "font-weight:800;" +
            "color:#1f2937;" +
            "}" +

            "#commonImageViewerModal .image-viewer-close {" +
            "border:0;" +
            "background:transparent;" +
            "width:30px;" +
            "height:30px;" +
            "border-radius:4px;" +
            "cursor:pointer;" +
            "font-size:22px;" +
            "line-height:1;" +
            "color:#374151;" +
            "}" +

            "#commonImageViewerModal .image-viewer-close:hover {" +
            "background:#f3f4f6;" +
            "}" +

            "#commonImageViewerModal .image-viewer-body {" +
            "display:flex;" +
            "align-items:center;" +
            "justify-content:center;" +
            "max-height:calc(88vh - 42px);" +
            "background:#111827;" +
            "}" +

            "#commonImageViewerImage {" +
            "display:block;" +
            "max-width:100%;" +
            "max-height:calc(88vh - 42px);" +
            "object-fit:contain;" +
            "}" +

            ".js-image-viewer-ready img," +
            ".js-image-viewer-target {" +
            "cursor:pointer;" +
            "}";

        document.head.appendChild(style);
    }

    /**
     * 공통 모달 DOM 생성
     * - body 마지막에 모달 1개만 추가
     */
    function createModal() {
        var modal = document.getElementById(MODAL_ID);

        // 이미 모달이 있으면 기존 모달 반환
        if (modal) {
            return modal;
        }

        modal = document.createElement("div");
        modal.id = MODAL_ID;

        modal.innerHTML =
            '<div class="image-viewer-box" role="dialog" aria-modal="true" aria-label="이미지 확대 보기">' +
            '    <div class="image-viewer-head">' +
            '        <div class="image-viewer-title">이미지 확대</div>' +
            '        <button type="button" class="image-viewer-close" aria-label="닫기">×</button>' +
            '    </div>' +
            '    <div class="image-viewer-body">' +
            '        <img id="' + IMAGE_ID + '" src="" alt="확대 이미지">' +
            '    </div>' +
            '</div>';

        document.body.appendChild(modal);

        return modal;
    }

    /**
     * 이미지 확대 모달 열기
     * - 클릭한 이미지의 src를 확대 이미지에 반영
     */
    function open(src, alt) {
        var modal = document.getElementById(MODAL_ID);
        var image = document.getElementById(IMAGE_ID);

        // 모달이 없으면 생성
        if (!modal || !image) {
            init();
            modal = document.getElementById(MODAL_ID);
            image = document.getElementById(IMAGE_ID);
        }

        // 이미지 경로가 없으면 중단
        if (!src) {
            return;
        }

        image.src = src;
        image.alt = alt || "확대 이미지";
        modal.classList.add("is-open");

        // 배경 스크롤 방지
        document.body.style.overflow = "hidden";
    }

    /**
     * 이미지 확대 모달 닫기
     * - 확대 이미지 src 제거
     */
    function close() {
        var modal = document.getElementById(MODAL_ID);
        var image = document.getElementById(IMAGE_ID);

        if (!modal) {
            return;
        }

        modal.classList.remove("is-open");

        if (image) {
            image.src = "";
        }

        // 배경 스크롤 복구
        document.body.style.overflow = "";
    }

    /**
     * 공통 이벤트 연결
     * - 배경 클릭 닫기
     * - 닫기 버튼 클릭 닫기
     * - ESC 닫기
     */
    function bindModalEvents() {
        var modal = document.getElementById(MODAL_ID);

        if (!modal) {
            return;
        }

        // 모달 배경 클릭 시 닫기
        modal.addEventListener("click", function (event) {
            if (event.target === modal) {
                close();
            }
        });

        // 닫기 버튼 클릭 시 닫기
        var closeBtn = modal.querySelector(".image-viewer-close");
        if (closeBtn) {
            closeBtn.addEventListener("click", function () {
                close();
            });
        }

        // ESC 키 입력 시 닫기
        document.addEventListener("keydown", function (event) {
            if (event.key === "Escape") {
                close();
            }
        });
    }

    /**
     * 공통 모듈 초기화
     * - style 생성
     * - modal 생성
     * - modal 이벤트 연결
     */
    function init() {
        if (initialized) {
            return;
        }

        createStyle();
        createModal();
        bindModalEvents();

        initialized = true;
    }

    /**
     * 이미지 영역 바인딩
     * - selector 영역 안의 img 클릭을 확대 모달로 연결
     * - 이벤트 위임 방식이라 동적 이미지도 작동
     */
    function bind(selector) {
        init();

        var container = document.querySelector(selector);

        // 대상 영역이 없으면 중단
        if (!container) {
            return;
        }

        // 클릭 가능 영역 표시용 클래스
        container.classList.add("js-image-viewer-ready");

        // 중복 이벤트 방지
        if (container.dataset.imageViewerBound === "Y") {
            return;
        }

        container.dataset.imageViewerBound = "Y";

        // 영역 안의 이미지 클릭 이벤트 위임
        container.addEventListener("click", function (event) {
            var img = event.target.closest("img");

            if (!img || !container.contains(img)) {
                return;
            }

            // 이미지 src 우선순위
            // data-view-src가 있으면 원본 이미지로 확대 가능
            var src = img.dataset.viewSrc || img.currentSrc || img.src;
            var alt = img.alt || "확대 이미지";

            open(src, alt);
        });
    }

    return {
        init: init,
        bind: bind,
        open: open,
        close: close
    };

})();