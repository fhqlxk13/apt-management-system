/*
  중앙관리자 : 공고 관리 JS
*/

const TODAY = new Date();

let posts = [];
let filtered = [];
let aptComplexList = [];

let currentPage = 1;
const PAGE_SIZE = 10

let currentAnnNo = null;
let formMode = "insert";

/*
  CSRF 헤더 생성

  CSRF란?
  → 로그인한 사용자의 권한을 악용한 위조 요청을 막는 보안 토큰.
  왜 사용?
  → Spring Security 사용 시 POST/PUT/DELETE 요청에 필요할 수 있다.
*/
function annSwalAvailable() {
    return typeof Swal !== "undefined" && Swal && typeof Swal.fire === "function";
}

function showAnnMessage(icon, title, text) {
    if (annSwalAvailable()) {
        return Swal.fire({
            icon: icon,
            title: title,
            text: text,
            confirmButtonText: "확인"
        });
    }
    alert(text || title);
    return Promise.resolve();
}

function goToAnnouncementListView() {
    closeFormModal();
    closeModal();

    var listTab = document.getElementById("tab0");
    if (listTab) {
        listTab.classList.add("is-active");
    }

    loadAnnouncementList();

    if (listTab && typeof listTab.scrollIntoView === "function") {
        listTab.scrollIntoView({ behavior: "smooth", block: "start" });
    }
}

function getCsrfHeaders() {
    const tokenMeta = document.querySelector('meta[name="_csrf"]');
    const headerMeta = document.querySelector('meta[name="_csrf_header"]');

    const headers = {
        "Content-Type": "application/json"
    };

    if (tokenMeta && headerMeta) {
        headers[headerMeta.getAttribute("content")] = tokenMeta.getAttribute("content");
    }

    return headers;
}

function calcStatus(start, end) {
    if (!start || !end) {
        return "-";
    }

    const s = new Date(start);
    const e = new Date(end);

    if (TODAY < s) return "예정";
    if (TODAY > e) return "마감";
    return "진행중";
}

function badgeHtml(status) {
    const map = {
        "진행중": "c-badge--active",
        "마감": "c-badge--neutral",
        "예정": "c-badge--pending"
    };

    return '<span class="c-badge ' + (map[status] || "") + '">' + status + '</span>';
}

function loadAptComplexList() {
    fetch("/centralAdmin/announcement/aptComplexList")
        .then(function (response) {
            if (!response.ok) {
                throw new Error("단지 목록 조회 실패");
            }
            return response.json();
        })
        .then(function (data) {
            aptComplexList = data || [];

            renderAptSelect("f-site", "단지 전체");
            renderAptSelect("f-fsite", "단지 선택");
        })
        .catch(function (error) {
            console.error(error);
            alert("단지 목록을 불러오지 못했습니다.");
        });
}

function renderAptSelect(selectId, defaultText) {
    const select = document.getElementById(selectId);

    if (!select) {
        return;
    }

    let html = '<option value="">' + defaultText + '</option>';

    aptComplexList.forEach(function (apt) {
        html += '<option value="' + apt.aptCmplexNo + '"';
        html += ' data-unit-cnt="' + (apt.unitCnt || 0) + '"';
        html += ' data-dorojuso="' + (apt.dorojuso || "") + '"';
        html += '>';
        html += apt.aptCmplexNm;
        html += '</option>';
    });

    select.innerHTML = html;
}

function loadAnnouncementList() {
    const params = new URLSearchParams();

    const title = document.getElementById("f-title").value;
    const aptCmplexNo = document.getElementById("f-site").value;
    const from = document.getElementById("f-from").value;
    const to = document.getElementById("f-to").value;
    const status = document.getElementById("f-status").value;

    if (title) params.append("searchTtl", title);
    if (aptCmplexNo) params.append("searchAptCmplexNo", aptCmplexNo);
    if (from) params.append("searchFrom", from);
    if (to) params.append("searchTo", to);
    if (status) params.append("searchStatus", status);

    fetch("/centralAdmin/announcement/list?" + params.toString())
        .then(function (response) {
            if (!response.ok) {
                throw new Error("공고 목록 조회 실패");
            }
            return response.json();
        })
        .then(function (data) {
            console.log("공고 목록 첫 번째 데이터:", data[0]);  //데이터 들어오나 확인
            posts = data || [];
            filtered = posts.slice();

            currentPage = 1;
            renderList();
        })
        .catch(function (error) {
            console.error(error);

            document.getElementById("list-body").innerHTML = `
                <tr>
                    <td colspan="8" style="text-align:center; padding:24px;">
                        해당하는 공고가 없습니다.
                    </td>
                </tr>
            `;
        });
}

function renderList() {
    const tbody = document.getElementById("list-body");

    const start = (currentPage - 1) * PAGE_SIZE;
    const slice = filtered.slice(start, start + PAGE_SIZE);

    if (slice.length === 0) {
        tbody.innerHTML = `
        <tr>
            <td colspan="8" style="text-align:center; padding:24px;">
                조회된 공고가 없습니다.
            </td>
        </tr>
    `;

        document.getElementById("list-count").textContent = 0;
        renderPagination();
        return;

    }

    tbody.innerHTML = slice.map(function (p) {
        /*
          st
          → 공고 상태값.
          DB에서 statusNm이 오면 그 값을 쓰고,
          없으면 모집 시작일/종료일 기준으로 화면에서 계산한다.
        */
        const st = p.statusNm || calcStatus(p.rcrtBgngDt, p.rcrtEndDt);

        return `
        <tr onclick="openDetail('${p.annNo}')" style="cursor:pointer;">
            <td>${p.ttl || "-"}</td>

            <td style="text-align:left;">
                ${p.aptCmplexNm || "-"}
            </td>

            <td style="text-align:left;">
                ${p.dorojuso || "-"}
            </td>
            
            <td>
                ${p.pblancBgngDt || "-"} ~ ${p.pblancEndDt || "-"}
            </td>

            <td>
                ${p.rcrtBgngDt || "-"} ~ ${p.rcrtEndDt || "-"}
            </td>

            <td>
                ${p.supplyDisplay || "0/0세대"}
            </td>

            <td>
                ${p.sbmsnDoc || p.sbmsnDocNm || "-"}
                ${
            p.hasFileYn === "Y"
                ? '<button type="button" class="file-down-btn" onclick="event.stopPropagation(); downloadFile(\'' + p.atchFileId + '\')">📎</button>'
                : ''
        }
            </td>

            <td style="text-align:center;">
                ${badgeHtml(st)}
            </td>
        </tr>
    `;
    }).join("");

    document.getElementById("list-count").textContent = filtered.length;
    renderPagination();
}

function renderPagination() {
    const pagination = document.getElementById("pagination");

    if (!pagination) {
        return;
    }

    const totalPage = Math.ceil(filtered.length / PAGE_SIZE);

    if (totalPage <= 1) {
        pagination.innerHTML = "";
        return;
    }

    let html = "";

    for (let i = 1; i <= totalPage; i++) {
        html += `
            <button class="c-page-btn ${i === currentPage ? "is-active" : ""}" onclick="movePage(${i})">
                ${i}
            </button>
        `;
    }

    pagination.innerHTML = html;
}

function movePage(page) {
    currentPage = page;
    renderList();
}

function doFilter() {
    loadAnnouncementList();
}

function resetFilter() {
    document.getElementById("f-title").value = "";
    document.getElementById("f-site").value = "";
    document.getElementById("f-from").value = "";
    document.getElementById("f-to").value = "";
    document.getElementById("f-status").value = "";

    loadAnnouncementList();
}

function openRegister() {
    formMode = "insert";
    currentAnnNo = null;

    /*
      등록 모달을 열 때 이전 값이 남지 않도록 초기화
    */
    clearForm();

    document.getElementById("form-title").textContent = "입주자 모집 공고 등록";
    document.getElementById("form-submit-btn").innerHTML =
        '<span class="material-symbols-rounded">check</span>등록';

    document.getElementById("form-modal").classList.remove("is-hidden");
}

function closeFormModal() {
    document.getElementById("form-modal").classList.add("is-hidden");
}

function closeFormOutside(event) {
    if (event.target.id === "form-modal") {
        closeFormModal();
    }
}

/*
  등록/수정 모달 입력값 초기화 함수
*/
function clearForm() {

    /*
      기본 입력값 초기화
    */
    document.getElementById("f-ftitle").value = "";
    document.getElementById("f-fsite").value = "";
    document.getElementById("f-detail-addr").value = "";

    document.getElementById("f-pblanc-start").value = "";
    document.getElementById("f-pblanc-end").value = "";
    document.getElementById("f-fstart").value = "";
    document.getElementById("f-fend").value = "";

    document.getElementById("f-funit").value = "";
    document.getElementById("f-content").value = "";

    /*
      전체 세대수 표시 초기화
      예: /192세대 → /0세대
    */
    document.getElementById("total-unit-text").textContent = "/0세대";

    /*
      파일 input 초기화
    */
    const fileInput = document.getElementById("f-file");

    if (fileInput) {
        fileInput.value = "";
    }

    /*
      제출서류 체크박스 초기화

      querySelectorAll이란?
      → 조건에 맞는 HTML 요소들을 여러 개 가져오는 함수.

      여기서는 name='sbmsnDoc'인 체크박스를 모두 가져온다.
    */
    document.querySelectorAll("input[name='sbmsnDoc']").forEach(function (checkbox) {
        checkbox.checked = false;
    });

    /*
      에러 메시지 초기화
    */
    clearErrors();
}

function clearErrors() {
    document.querySelectorAll(".err-msg").forEach(function (el) {
        el.textContent = "";
    });
}

function validateForm() {
    clearErrors();

    let valid = true;

    const ttl = document.getElementById("f-ftitle").value.trim();
    const aptCmplexNo = document.getElementById("f-fsite").value;
    const rcrtBgngDt = document.getElementById("f-fstart").value;
    const rcrtEndDt = document.getElementById("f-fend").value;
    const cn = document.getElementById("f-content").value.trim();

    if (!ttl) {
        document.getElementById("e-ftitle").textContent = "공고 제목을 입력해주세요.";
        valid = false;
    }

    if (!aptCmplexNo) {
        document.getElementById("e-fsite").textContent = "단지를 선택해주세요.";
        valid = false;
    }

    if (!rcrtBgngDt || !rcrtEndDt) {
        document.getElementById("e-fdate").textContent = "모집 기간을 입력해주세요.";
        valid = false;
    }

    if (rcrtBgngDt && rcrtEndDt && rcrtBgngDt > rcrtEndDt) {
        document.getElementById("e-fdate").textContent = "모집 시작일은 종료일보다 늦을 수 없습니다.";
        valid = false;
    }

    if (!cn) {
        document.getElementById("e-content").textContent = "공고 내용을 입력해주세요.";
        valid = false;
    }

    return valid;
}

function submitForm() {
    if (!validateForm()) {
        return;
    }

    /*
      제출서류 체크값 수집
      map()
      → 배열 데이터를 다른 형태로 변환할 때 사용.
      join(",")
      → 배열을 콤마 문자열로 합친다.
    */
    const sbmsnDoc = Array.from(
        document.querySelectorAll("input[name='sbmsnDoc']:checked")
    )
        .map(function (checkbox) {
            return checkbox.parentElement.textContent.trim();
        })
        .join(",");

    const payload = {
        ttl: document.getElementById("f-ftitle").value.trim(),
        aptCmplexNo: document.getElementById("f-fsite").value,
        pblancBgngDt: document.getElementById("f-pblanc-start").value,
        pblancEndDt: document.getElementById("f-pblanc-end").value,
        rcrtBgngDt: document.getElementById("f-fstart").value,
        rcrtEndDt: document.getElementById("f-fend").value,
        cn: document.getElementById("f-content").value.trim(),
        supplyCnt: document.getElementById("f-funit").value,
        sbmsnDoc: sbmsnDoc
    };

    const url = formMode === "update"
        ? "/centralAdmin/announcement/" + currentAnnNo
        : "/centralAdmin/announcement";

    const method = formMode === "update" ? "PUT" : "POST";

    const formData = new FormData();

    /*
      Blob이란?
      → 문자열 데이터를 파일처럼 감싸서 전송하는 객체.
      → @RequestPart("data")로 DTO를 받을 때 JSON 데이터를 multipart 안에 넣기 위해 사용.
    */
    formData.append(
        "data",
        new Blob([JSON.stringify(payload)], {
            type: "application/json"
        })
    );

    const file = document.getElementById("f-file").files[0];

    if (file) {
        formData.append("file", file);
    }

    fetch(url, {
        method: method,
        headers: getCsrfOnlyHeaders(),
        body: formData
    })
        .then(async function (response) {
            const text = await response.text();

            let data = {};
            if (text) {
                data = JSON.parse(text);
            }

            if (!response.ok) {
                throw new Error(data.message || "공고 저장 실패");
            }

            return data;
        })
        .then(function (data) {
            if (!data.success) {
                showAnnMessage("error", "저장 실패", "공고 저장에 실패했습니다.");
                return;
            }

            var isInsert = formMode === "insert";
            var title = isInsert ? "공고 등록 완료" : "공고 수정 완료";
            var text = isInsert
                ? "공고가 등록되었습니다. 목록으로 이동합니다."
                : "공고가 수정되었습니다. 목록을 갱신합니다.";

            showAnnMessage("success", title, text).then(function () {
                goToAnnouncementListView();
            });
        })
        .catch(function (error) {
            console.error(error);
            showAnnMessage(
                "error",
                "저장 오류",
                "공고 저장 중 오류가 발생했습니다.\n" + error.message
            );
        });
}

function openDetail(annNo) {
    /*
      currentAnnNo
      → 현재 상세보기 중인 공고번호.
      왜 사용?
      → 상세 모달에서 수정/삭제 버튼을 눌렀을 때 어떤 공고를 처리할지 알기 위해 사용한다.
    */
    currentAnnNo = annNo;

    fetch("/centralAdmin/announcement/" + annNo)
        .then(function (response) {
            /*
              response.ok
              → HTTP 상태코드가 200번대인지 확인한다.
              왜 사용?
              → 404, 500 같은 서버 오류일 때 상세 모달을 열지 않기 위해.
            */
            if (!response.ok) {
                throw new Error("공고 상세 조회 실패");
            }

            /*
              response.json()
              → 서버가 보내준 JSON 문자열을 JavaScript 객체로 변환한다.
              왜 사용?
              → data.ttl, data.sbmsnDoc 같은 방식으로 값을 꺼내기 위해.
            */
            return response.json();
        })
        .then(function (data) {
            /*
              상세 데이터 확인용 로그.
              제출서류가 안 보이면 여기에서 sbmsnDoc 값이 있는지 확인한다.
            */
            console.log("상세 데이터:", data);

            renderDetail(data);

            /*
              상세 모달 열기
            */
            document.getElementById("detail-modal").classList.remove("is-hidden");
        })
        .catch(function (error) {
            console.error(error);
            alert("공고 상세 정보를 불러오지 못했습니다.");
        });
}

function renderDetail(data) {
    /*
      공고 상세 조회 화면

      readonly-box란?
      → 수정 가능한 input이 아니라,
        input처럼 보이지만 읽기만 하는 박스.
      왜 사용?
      → 상세보기 화면을 등록/수정 모달과 비슷한 UI로 맞추기 위해.
    */
    const st = data.statusNm || calcStatus(data.rcrtBgngDt, data.rcrtEndDt);

    document.getElementById("detail-status-badge").innerHTML = badgeHtml(st);
    document.getElementById("modal-content").innerHTML = `
    <div class="detail-form-grid">

        <!-- 공고 제목: 한 줄 전체 사용 -->
        <div class="c-field">
            <label class="c-label">공고 제목</label>
            <div class="detail-readonly-box">${data.ttl || "-"}</div>
        </div>
        
        <!-- 공급 세대수 -->
        <div class="c-field">
            <label class="c-label">공급 세대수</label>
            <div class="detail-readonly-box">${data.supplyDisplay || "0/0세대"}</div>
        </div>

        <!-- 단지 / 상세주소 -->
        <div class="c-field">
            <label class="c-label">단지</label>
            <div class="detail-readonly-box">${data.aptCmplexNm || "-"}</div>
        </div>

        <div class="c-field">
            <label class="c-label">상세주소</label>
            <div class="detail-readonly-box">${data.dorojuso || "-"}</div>
        </div>

        <!-- 공고 게시 기간 / 모집 기간 -->
        <div class="c-field">
            <label class="c-label">공고 게시 기간</label>
            <div class="detail-readonly-box">
                ${data.pblancBgngDt || "-"} ~ ${data.pblancEndDt || "-"}
            </div>
        </div>

        <div class="c-field">
            <label class="c-label">모집 기간</label>
            <div class="detail-readonly-box">
                ${data.rcrtBgngDt || "-"} ~ ${data.rcrtEndDt || "-"}
            </div>
        </div>

        <!-- 제출 서류: 한 줄 전체 사용 -->
        <div class="c-field detail-doc-full">
            <label class="c-label">제출 서류</label>
            <div class="detail-readonly-box detail-doc-box">
                ${data.sbmsnDoc || "-"}
            </div>
        </div>
        

        <!-- 공고 내용: 한 줄 전체 사용 -->
        <div class="c-field detail-full">
            <label class="c-label">공고 내용</label>
            <div class="detail-readonly-box detail-readonly-box--content">${data.cn || "-"}</div>
        </div>

    </div>
`;
}

function closeModal() {
    document.getElementById("detail-modal").classList.add("is-hidden");
}

function closeOutside(event) {
    if (event.target.id === "detail-modal") {
        closeModal();
    }
}

/*
  상세 모달에서 [수정] 버튼 클릭 시 실행

  기능
  → 현재 보고 있는 공고번호(currentAnnNo)로 상세 데이터를 다시 조회하고,
    등록/수정 모달 input에 값을 채운 뒤 수정 모드로 연다.
*/
function editFromModal() {

    if (!currentAnnNo) {
        return;
    }

    fetch("/centralAdmin/announcement/" + currentAnnNo)
        .then(function (response) {

            if (!response.ok) {
                throw new Error("공고 수정 조회 실패");
            }

            return response.json();
        })
        .then(function (data) {

            console.log("수정 모달 데이터:", data);

            /*
              formMode
              → submitForm()에서 등록인지 수정인지 구분하는 값.
              update이면 PUT 요청으로 보냄.
            */
            formMode = "update";

            /*
              기본 공고 정보 세팅
            */
            document.getElementById("f-ftitle").value = data.ttl || "";
            document.getElementById("f-fsite").value = data.aptCmplexNo || "";

            /*
              공고 게시 기간
            */
            document.getElementById("f-pblanc-start").value = data.pblancBgngDt || "";
            document.getElementById("f-pblanc-end").value = data.pblancEndDt || "";

            /*
              모집 기간
            */
            document.getElementById("f-fstart").value = data.rcrtBgngDt || "";
            document.getElementById("f-fend").value = data.rcrtEndDt || "";

            /*
              공급 세대수

              supplyCnt
              → 현재 공급 세대수.
              unitCnt
              → 전체 세대수.
              그래서 input에는 supplyCnt가 들어가는 게 맞음.
            */
            document.getElementById("f-funit").value = data.supplyCnt || "0";

            /*
              전체 세대수 표시
              예: /192세대
            */
            document.getElementById("total-unit-text").textContent =
                "/" + (data.totalUnitCnt || data.unitCnt || 0) + "세대";

            /*
              상세주소 세팅

              중요!
              JSP id가 f-detail-addr이므로 여기에 넣어야 함.
            */
            document.getElementById("f-detail-addr").value = data.dorojuso || "";

            /*
              공고 내용 세팅
            */
            document.getElementById("f-content").value = data.cn || "";

            /*
              제출서류 체크박스 초기화
            */
            document.querySelectorAll("input[name='sbmsnDoc']").forEach(function (checkbox) {
                checkbox.checked = false;
            });

            /*
              제출서류 다시 체크

              DB 값 예시:
              신분증 사본,주민등록등본,소득증명서
            */
            if (data.sbmsnDoc) {
                const docs = data.sbmsnDoc.split(",");

                document.querySelectorAll("input[name='sbmsnDoc']").forEach(function (checkbox) {
                    checkbox.checked = docs.includes(checkbox.value);
                });
            }

            /*
              단지 select에 들어있는 data-unit-cnt, data-dorojuso도 다시 반영
              단, 위에서 DB 상세값을 이미 넣었으므로 보조용으로 사용.
            */
            applyAptAutoInfo();

            /*
              applyAptAutoInfo()가 공급세대수를 건드릴 수 있으므로
              공급 세대수는 마지막에 다시 한 번 세팅.
            */
            document.getElementById("f-funit").value = data.supplyCnt || "0";

            /*
              모달 제목 / 버튼 문구 변경
            */
            document.getElementById("form-title").textContent = "입주자 모집 공고 수정";
            document.getElementById("form-submit-btn").innerHTML =
                '<span class="material-symbols-rounded">check</span>수정';

            /*
              상세 모달 닫고 수정 모달 열기
            */
            closeModal();
            document.getElementById("form-modal").classList.remove("is-hidden");
        })
        .catch(function (error) {
            console.error(error);
            alert("공고 수정 정보를 불러오지 못했습니다.");
        });
}

function deleteFromModal() {
    if (!currentAnnNo) {
        return;
    }

    if (!confirm("공고를 삭제하시겠습니까?")) {
        return;
    }

    fetch("/centralAdmin/announcement/" + currentAnnNo, {
        method: "DELETE",
        headers: getCsrfHeaders()
    })
        .then(function (response) {
            if (!response.ok) {
                throw new Error("공고 삭제 실패");
            }
            return response.json();
        })
        .then(function (data) {
            if (!data.success) {
                alert("공고 삭제에 실패했습니다.");
                return;
            }

            alert("공고가 삭제되었습니다.");
            closeModal();
            loadAnnouncementList();
        })
        .catch(function (error) {
            console.error(error);
            alert("공고 삭제 중 오류가 발생했습니다.");
        });
}

/*
  단지 선택 시 자동조회

  change 이벤트란?
  → select, input 값이 바뀌었을 때 실행되는 이벤트.
*/
document.addEventListener("change", function (event) {

    if (event.target.id === "f-fsite") {

        /*
          신규 등록 시 공급 세대수 기본값 0 세팅
        */
        document.getElementById("f-funit").value = "0";

        /*
          선택한 단지의 상세주소 / 전체세대수 자동 세팅
        */
        applyAptAutoInfo();
    }
});


document.addEventListener("DOMContentLoaded", function () {
    loadAptComplexList();
    loadAnnouncementList();

    /*
      input 이벤트
      → 사용자가 글자를 입력하거나 지울 때마다 실행되는 이벤트.
    */
    const titleInput = document.getElementById("f-title");

    if (titleInput) {
        titleInput.addEventListener("input", function () {
            /*
              clearTimeout / setTimeout
              → 사용자가 글자를 칠 때마다 바로 서버 요청을 보내지 않고,
                입력이 잠깐 멈췄을 때만 검색하게 한다.
            */
            clearTimeout(window.titleSearchTimer);

            window.titleSearchTimer = setTimeout(function () {
                currentPage = 1;
                loadAnnouncementList();
            }, 300);
        });
    }
});


function downloadFile(fileGroupNo) {
    /*
      파일 다운로드
    */
    if (!fileGroupNo) {
        alert("다운로드할 첨부파일이 없습니다.");
        return;
    }

    location.href = "/centralAdmin/announcement/file/download/" + fileGroupNo;
}


function getCsrfOnlyHeaders() {
    const tokenMeta = document.querySelector('meta[name="_csrf"]');
    const headerMeta = document.querySelector('meta[name="_csrf_header"]');

    const headers = {};

    if (tokenMeta && headerMeta) {
        headers[headerMeta.getAttribute("content")] = tokenMeta.getAttribute("content");
    }

    return headers;
}

/*
  단지 자동조회 함수

  applyAptAutoInfo란?
  → 선택한 단지의 전체 세대수와 상세주소를 화면에 자동 세팅하는 함수.

  왜 사용?
  → 등록 모달에서는 단지를 직접 선택했을 때 사용하고,
    수정 모달에서는 DB에서 가져온 단지값을 select에 세팅한 뒤 다시 화면에 반영할 때 사용한다.
*/
function applyAptAutoInfo() {

    /*
      f-fsite
      → 등록/수정 모달의 단지 선택 select 박스
    */
    const siteSelect = document.getElementById("f-fsite");

    if (!siteSelect) {
        return;
    }

    const selected = siteSelect.options[siteSelect.selectedIndex];

    if (!selected) {
        return;
    }

    /*
      data-unit-cnt
      → renderAptSelect()에서 option 태그에 넣어둔 전체 세대수
    */
    const unitCnt = selected.getAttribute("data-unit-cnt") || "0";

    /*
      data-dorojuso
      → renderAptSelect()에서 option 태그에 넣어둔 상세주소
    */
    const dorojuso = selected.getAttribute("data-dorojuso") || "";

    /*
      전체 세대수 표시
      예: /192세대
    */
    document.getElementById("total-unit-text").textContent = "/" + unitCnt + "세대";

    /*
      중요!
      JSP의 상세주소 input id는 f-detail-addr임.
      기존에 f-dorojuso로 쓰면 해당 id가 없어서 값이 안 들어감.
    */
    document.getElementById("f-detail-addr").value = dorojuso;
}

/*
  공고 운영 안내 접기/펼치기

  toggle이란?
  → 특정 상태를 켰다/껐다 전환하는 기능.
  왜 사용?
  → 안내 영역을 필요할 때만 펼쳐서 화면 공간을 줄이기 위해 사용.
*/
function toggleAnnounceGuide() {
    const card = document.getElementById("announce-guide-card");
    const text = document.getElementById("announce-guide-toggle-text");
    const icon = document.getElementById("announce-guide-toggle-icon");

    if (!card) {
        return;
    }

    card.classList.toggle("is-collapsed");

    const isCollapsed = card.classList.contains("is-collapsed");

    if (text) {
        text.textContent = isCollapsed ? "펼치기" : "접기";
    }

    if (icon) {
        icon.textContent = isCollapsed ? "chevron_right" : "expand_more";
    }
}