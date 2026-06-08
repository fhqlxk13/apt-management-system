/**
 * ============================================================
 * manager-common.js (고정 공통 모듈)
 *
 * ============================================================
 */


/* ============================================================
   null → "" (표시용 ONLY)
============================================================ */
function emptyIfNull(value) {
    return value == null ? "" : value;
}


/* ============================================================
   form 채우기 (표시용 ONLY)
============================================================ */
function fillForm(form, data) {

    if (!form || !data) return;

    const inputs = form.querySelectorAll("[name]");

    inputs.forEach(function (input) {
        const name = input.name;
        if (data[name] !== undefined) {
            input.value = emptyIfNull(data[name]);
        }
    });
}


/* ============================================================
   모달 열기 / 닫기 (DOM만 제어)
============================================================ */
function openModal(modalId) {
    const modal = document.getElementById(modalId);
    if (!modal) return;

    modal.classList.add("open");
    document.body.style.overflow = "hidden";
}

function closeModal(modalId) {
    const modal = document.getElementById(modalId);
    if (!modal) return;

    modal.classList.remove("open");
    document.body.style.overflow = "";
}


/* ============================================================
   모달 이벤트 (닫기 / 바깥클릭)
   → 한 번만 바인딩
============================================================ */
(function bindModalEvents() {

    if (!document.body) {
        document.addEventListener("DOMContentLoaded", bindModalEvents);
        return;
    }

    if (document.body.dataset.modalBound === "true") return;
    document.body.dataset.modalBound = "true";

    document.addEventListener("click", function (e) {

        const closeBtn = e.target.closest("[data-modal-close]");
        if (closeBtn) {
            e.stopPropagation();
            const modal = closeBtn.closest(".modal-overlay");
            if (modal) closeModal(modal.id);
            return;
        }

        // 바깥 클릭
        if (e.target.classList.contains("modal-overlay")) {
            closeModal(e.target.id);
        }
    });

})();


/* ============================================================
   GET
============================================================ */
async function getJson(url) {

    const res = await fetch(url, {
        method: "GET",
        headers: {
            "X-Requested-With": "XMLHttpRequest"
        }
    });

    const contentType = res.headers.get("content-type") || "";
    const isJson = contentType.includes("application/json");
    const body = isJson ? await res.json() : await res.text();

    if (!res.ok) {
        throw new Error(typeof body === "string" ? body : ("HTTP " + res.status));
    }

    if (!isJson) {
        throw new Error("JSON 응답이 아닙니다.");
    }

    return body;
}


/* ============================================================
   POST
============================================================ */
async function postJson(url, data) {
    const headers = {
        "Content-Type": "application/json",
        "X-Requested-With": "XMLHttpRequest"
    };

    const csrfHeader = document.querySelector('meta[name="_csrf_header"]');
    const csrfToken = document.querySelector('meta[name="_csrf"]');

    if (csrfHeader && csrfToken) {
        headers[csrfHeader.content] = csrfToken.content;
    }

    const res = await fetch(url, {
        method: "POST",
        headers: headers,
        body: JSON.stringify(data)
    });

    const contentType = res.headers.get("content-type") || "";
    const isJson = contentType.includes("application/json");
    const body = isJson ? await res.json() : await res.text();

    if (!res.ok) {
        throw new Error(typeof body === "string" ? body : ("HTTP " + res.status));
    }

    if (!isJson) {
        throw new Error("JSON 응답이 아닙니다.");
    }

    return body;
}


/* ============================================================
   alert (임시)
============================================================ */
function showAlert(message, icon) {
    alert(message);
    return Promise.resolve({ isConfirmed: true });
}

async function showAlertThen(message, next, icon) {
    await showAlert(message, icon);

    if (typeof next === "function") {
        next();
        return;
    }

    if (typeof next === "string" && next) {
        location.href = next;
    }
}

function showConfirm(options) {
    const title = typeof options === "string" ? options : (options && (options.title || options.message)) || "계속 진행하시겠습니까?";
    return Promise.resolve({ isConfirmed: confirm(title) });
}


/* ============================================================
   fragment reload
============================================================ */
function reloadFragment(url, title) {

    if (url) {
        location.href = url;
    } else {
        location.reload();
    }
}
