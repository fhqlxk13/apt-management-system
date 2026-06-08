document.addEventListener("DOMContentLoaded", function () {

const body = document.body;

const memberType = body.dataset.memberType;

const isResident = memberType === "ResidentVO";

let isSubmitting = false;

const aptCmplexNo = body.dataset.aptCmplexNo;

const userNo = body.dataset.userNo;

const csrfToken = document.querySelector('meta[name="_csrf"]').content;
const csrfHeader = document.querySelector('meta[name="_csrf_header"]').content;

const registerBtn = document.querySelector("#registerBtn");

const uploadBox = document.getElementById("uploadBox");
const fileInput = document.getElementById("fileInput");
const previewCard = document.getElementById("previewCard");
const previewImg = document.getElementById("previewImg");
const removeBtn = document.getElementById("removeBtn");
const uploadContent = document.querySelector(".upload-content");

const vhclModal = document.getElementById("vhclModal");

    loadMyVhcl();

    initModal();

    initFileUpload();

    initRegister();

    initDelete();


/* =========================
   modal
========================= */

function initModal(){

    document.getElementById("openModalBtn")
        .addEventListener("click", () => {

            if (!isResident) {

                alert("입주민만 사용 가능한 기능입니다.");

                return;
            }

            vhclModal.classList.add("active");
        });

    document.getElementById("closeModalBtn")
        .addEventListener("click", () => {
            vhclModal.classList.remove("active");
        });

    vhclModal.addEventListener("click", (e) => {
        if(e.target === vhclModal){
            vhclModal.classList.remove("active");
        }
    });
}

/* =========================
   validation
========================= */

function validateVhclNo(front, back) {

    const frontRegex = /^[0-9]{2,3}[가-힣]$/;
    const backRegex = /^[0-9]{4}$/;

    const frontInput = document.getElementById("vhclNoFront");
    const backInput = document.getElementById("vhclNoBack");

    let isValid = true;

    if (!frontRegex.test(front)) {
        isValid = false;
    }

    if (!backRegex.test(back)) {
        isValid = false;
    }

    if (!isValid) {

        alert("차량번호 형식을 확인하세요 (예: 12가 1234)");

        if (!frontRegex.test(front)) {
            highlightError(frontInput);
        }

        if (!backRegex.test(back)) {
            highlightError(backInput);
        }

        return false;
    }

    return true;
}

function highlightError(el) {

    el.classList.add("input-error");

    setTimeout(() => {
        el.classList.remove("input-error");
    }, 800);
}

function validateFile(file) {

    if (!file.type.startsWith("image/")) {

        alert("이미지 파일만 업로드 가능합니다");

        return false;
    }

    return true;
}

/* =========================
   upload
========================= */

function initFileUpload(){

    uploadBox.addEventListener("click", () => {
        fileInput.click();
    });

    fileInput.addEventListener("change", () => {

        const file = fileInput.files[0];

        if (!file) return;

        if (!validateFile(file)) {

            fileInput.value = "";

            return;
        }

        previewFile(file);
    });

    removeBtn.addEventListener("click", (e) => {

        e.stopPropagation();

        fileInput.value = "";

        previewImg.src = "";

        previewCard.style.display = "none";
        uploadContent.style.display = "block";
    });

    uploadBox.addEventListener("dragover", (e) => {

        e.preventDefault();

        uploadBox.classList.add("dragover");
    });

    uploadBox.addEventListener("dragleave", () => {

        uploadBox.classList.remove("dragover");
    });

    uploadBox.addEventListener("drop", (e) => {

        e.preventDefault();

        uploadBox.classList.remove("dragover");

        const file = e.dataTransfer.files[0];

        if (!file) return;

        if (!validateFile(file)) return;

        fileInput.files = e.dataTransfer.files;

        previewFile(file);
    });
}

function previewFile(file){

    const reader = new FileReader();

    reader.onload = (e) => {

        previewImg.src = e.target.result;

        uploadContent.style.display = "none";

        previewCard.style.display = "flex";
    };

    reader.readAsDataURL(file);
}

/* =========================
   register
========================= */

function initRegister(){

    registerBtn.addEventListener("click", function () {

        if (isSubmitting) return;

        isSubmitting = true;

        registerBtn.disabled = true;
        registerBtn.innerText = "등록 중...";

        const hoSelect = document.getElementById("hoSelect");

        const selectedOption =
            hoSelect.options[hoSelect.selectedIndex];

        const formData = new FormData();

        formData.append("hoNo", hoSelect.value);

        fetch("/vhcl/check/" + aptCmplexNo, {
            method: "POST",
            headers: {
                [csrfHeader]: csrfToken
            },
            body: formData
        })
            .then(res => res.text())
            .then(result => {

                if (result === "EXTRA_REQUIRED") {

                    if (!confirm("추가 차량 등록은 비용이 발생합니다. 진행하시겠습니까?")) {

                        resetButton();

                        return;
                    }

                    submitVhcl(true);

                } else {

                    submitVhcl(false);
                }
            })
            .catch(() => resetButton());
    });
}

function submitVhcl(isExtra) {

    const formData = new FormData();

    const vhclNm =
        document.getElementById("vhclNmData")
            .value
            .trim();

    if (!vhclNm) {

        alert("차종을 입력해주세요.");

        const input =
            document.getElementById("vhclNmData");

        input.focus();

        highlightError(input);

        resetButton();

        return;
    }

    formData.append("vhclNm", vhclNm);

    const front =
        document.getElementById("vhclNoFront")
            .value
            .trim();

    const back =
        document.getElementById("vhclNoBack")
            .value
            .trim();

    if (!validateVhclNo(front, back)) {

        resetButton();

        return;
    }

    if (!fileInput.files[0]) {

        alert("차량등록증을 등록해주세요.");

        highlightError(uploadBox);

        resetButton();

        return;
    }

    const vhclNo = front + back;

    formData.append("vhclNo", vhclNo);

    const hoSelect = document.getElementById("hoSelect");

    const selectedOption =
        hoSelect.options[hoSelect.selectedIndex];

    formData.append("hoNo", hoSelect.value);

    formData.append("isExtra", isExtra);

    formData.append("file", fileInput.files[0]);

    fetch("/vhcl/register/" + aptCmplexNo, {
        method: "POST",
        headers: {
            [csrfHeader]: csrfToken
        },
        body: formData
    })
        .then(res => {

            if (!res.ok) {
                throw new Error("등록 실패");
            }

            return res.text();
        })
        .then(() => {

            Swal.fire({
                icon: "success",
                title: "등록 완료",
                confirmButtonText: '확인'
            });

            vhclModal.classList.remove("active");

            resetForm();
            loadMyVhcl();
        })
        .catch(err => {

            Swal.fire({
                icon: "error",
                title: err.message || "등록 실패",
                confirmButtonText: "확인",
                confirmButtonColor: "#2e5c38"
            });
        })
        .finally(() => {

            resetButton();
        });
}

/* =========================
   list
========================= */

function loadMyVhcl() {

    fetch(`/vhcl/myVhcl/` + aptCmplexNo, {
        method: "GET",
        headers: {
            [csrfHeader]: csrfToken
        }
    })
        .then(res => {

            if (!res.ok) {
                throw new Error("서버 오류");
            }

            return res.json();
        })
        .then(list => {

            console.log(list);

            let html = "";

            list.forEach((car,idx) => {

                let badgeClass = "";
                let statusText = "";

                const hoNo = car.hoNo;

                const parts = hoNo.split("_");

                const dong = parts[1];
                const ho = parts[2];

                if (car.vhclSttsCd === 'APRV') {

                    badgeClass = "ok";
                    statusText = "승인";

                } else if (car.vhclSttsCd === 'WAIT') {

                    badgeClass = "wait";
                    statusText = "승인대기";

                } else {

                    badgeClass = "danger";
                    statusText = "반려";
                }

                html += `
                    <tr>    
                        <td>${idx+1}</td>
                        <td>${dong}</td> 
                        <td>${ho}</td>
                        <td>${car.vhclNo}</td>
                        <td>${car.vhclNm}</td>
                        <td>${car.regDt ? car.regDt.substring(0,10) : ''}</td>
                        <td>
                            <span class="badge ${badgeClass}">
                                ${statusText}
                            </span>
                        </td>
                        <td>
                            <span
                                class="delete-text"
                                data-vhcl-id="${car.rsidVhclNo}">
                                삭제
                            </span>
                        </td>
                    </tr>
                `;
            });

            document.querySelector(
                ".data-table tbody"
            ).innerHTML = html;
        })
        .catch(err => {

            console.error(err);

            alert("차량 목록 불러오기 실패");
        });
}

/* =========================
   delete
========================= */

function initDelete(){

    document.querySelector(".data-table tbody")
        .addEventListener("click", function(e) {

            if (!e.target.classList.contains("delete-text")) {
                return;
            }

            const rsidVhclNo =
                e.target.dataset.vhclId;

            if (!confirm("삭제하시겠습니까?")) {
                return;
            }

            deleteVhcl(rsidVhclNo);
        });
}

function deleteVhcl(rsidVhclNo) {

    fetch(`/vhcl/delete/${rsidVhclNo}`, {
        method: "DELETE",
        headers: {
            [csrfHeader]: csrfToken
        }
    })
        .then(res => {

            if (!res.ok) {
                throw new Error("삭제 실패");
            }

            return res.text();
        })
        .then(() => {

            alert("삭제 완료");

            loadMyVhcl();
        })
        .catch(err => {

            alert(err.message);
        });
}

/* =========================
   common
========================= */

function resetForm() {

    document.getElementById("vhclNmData").value = "";

    document.getElementById("vhclNoFront").value = "";

    document.getElementById("vhclNoBack").value = "";

    document.getElementById("hoSelect").selectedIndex = 0;

    fileInput.value = "";

    previewImg.src = "";

    previewCard.style.display = "none";

    uploadContent.style.display = "block";
}

function resetButton() {

    isSubmitting = false;

    registerBtn.disabled = false;

    registerBtn.innerText = "차량 등록";
}

});