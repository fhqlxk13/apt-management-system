/**
 * 입주민·아파트 메인 화면용 SweetAlert2 헬퍼 (등록/수정/신청 완료·실패)
 */
function residentAlert(message, icon) {
    if (typeof Swal !== "undefined") {
        return Swal.fire({
            icon: icon || "info",
            title: String(message || ""),
            confirmButtonText: "확인",
            confirmButtonColor: "#2e5c38",
            allowOutsideClick: false
        });
    }
    alert(message);
    return Promise.resolve({ isConfirmed: true });
}

async function residentAlertThen(message, next, icon) {
    await residentAlert(message, icon || "success");
    if (typeof next === "function") {
        next();
    } else if (typeof next === "string" && next) {
        location.href = next;
    }
}
