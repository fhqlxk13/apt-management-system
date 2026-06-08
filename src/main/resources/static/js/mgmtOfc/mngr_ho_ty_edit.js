// ======================================
// 평형 타입 관리
// ======================================

window.initHoTypeManager = function ({
                                         mgmtOfcNo,
                                         csrfToken,
                                         csrfHeader,
                                         renderHoTypeSelect
                                     }) {

    let isEditMode = false;
    let imageChanged = false;
    let editingHoTyNo = null;

    const btnOpenTypeDrawer =
        document.querySelector("#btnOpenTypeDrawer");

    const btnCloseTypeDrawer =
        document.querySelector("#btnCloseTypeDrawer");

    const hoTypeDrawer =
        document.querySelector("#hoTypeDrawer");

    const drawerBackdrop =
        document.querySelector("#drawerBackdrop");

    const hoTypeList =
        document.querySelector("#hoTypeList");

    const btnOpenTypeModal =
        document.querySelector("#btnOpenTypeModal");

    const btnCloseTypeModal =
        document.querySelector("#btnCloseTypeModal");

    const btnCancelTypeModal =
        document.querySelector("#btnCancelTypeModal");

    const hoTypeModal =
        document.querySelector("#hoTypeModal");

    const hoTypeModalBackdrop =
        document.querySelector("#hoTypeModalBackdrop");

    const hoUploadBox =
        document.querySelector("#hoUploadBox");

    const hoTypeImage =
        document.querySelector("#hoTypeImage");

    const hoUploadContent =
        document.querySelector(".upload-content");

    const hoPreviewImg =
        document.querySelector("#hoPreviewImg");

    const hoPreviewCard =
        document.querySelector("#hoPreviewCard");

    const hoRemoveBtn =
        document.querySelector("#hoRemoveBtn");

    const btnInsertHoType =
        document.querySelector("#btnInsertHoType");

    // =========================
    // Drawer
    // =========================

    btnOpenTypeDrawer.addEventListener(
        "click",
        async () => {

            hoTypeDrawer.classList.add("open");

            drawerBackdrop.classList.add("show");

            await loadHoTypeList();

        }
    );

    btnCloseTypeDrawer.addEventListener(
        "click",
        closeTypeDrawer
    );

    drawerBackdrop.addEventListener(
        "click",
        closeTypeDrawer
    );

    function closeTypeDrawer(){

        hoTypeDrawer.classList.remove("open");

        drawerBackdrop.classList.remove("show");

    }

    // =========================
    // Modal
    // =========================

    btnOpenTypeModal.addEventListener(
        "click",
        openInsertModal
    );

    btnCloseTypeModal.addEventListener(
        "click",
        closeTypeModal
    );

    btnCancelTypeModal.addEventListener(
        "click",
        closeTypeModal
    );

    hoTypeModalBackdrop.addEventListener(
        "click",
        closeTypeModal
    );

    function openInsertModal(){

        isEditMode = false;
        imageChanged = false;
        editingHoTyNo = null;

        document.querySelector("#tyNm").value = "";
        document.querySelector("#exclusiveSize").value = "";
        document.querySelector("#roomCnt").value = "";
        document.querySelector("#bathroomCnt").value = "";

        hoTypeImage.value = "";

        hoPreviewImg.src = "";

        hoPreviewCard.style.display = "none";

        hoUploadContent.style.display = "flex";

        document.querySelector(
            ".ho-type-modal-title"
        ).textContent = "새 평형 타입 추가";

        btnInsertHoType.textContent =
            "평형 타입 추가";

        hoTypeModal.classList.add("show");

        hoTypeModalBackdrop.classList.add("show");

    }

    function closeTypeModal(){

        hoTypeModal.classList.remove("show");

        hoTypeModalBackdrop.classList.remove("show");

        isEditMode = false;
        imageChanged = false;
        editingHoTyNo = null;

    }

    // =========================
    // Upload
    // =========================

    hoPreviewCard.style.display = "none";

    hoUploadBox.addEventListener("click", () => {

        hoTypeImage.click();

    });

    hoTypeImage.addEventListener("change", e => {

        const file = e.target.files[0];

        imageChanged = true;

        if(!file){
            return;
        }

        if(!file.type.startsWith("image/")){

            alert("이미지 파일만 업로드 가능합니다.");

            return;
        }

        const reader = new FileReader();

        reader.onload = event => {

            hoPreviewImg.src =
                event.target.result;

            hoUploadContent.style.display =
                "none";

            hoPreviewCard.style.display =
                "flex";

            hoRemoveBtn.style.display =
                "flex";

        };

        reader.readAsDataURL(file);

    });

    hoRemoveBtn.addEventListener("click", e => {

        e.stopPropagation();

        imageChanged = true;

        hoTypeImage.value = "";

        hoPreviewImg.src = "";

        hoPreviewCard.style.display = "none";

        hoUploadContent.style.display = "flex";

    });

    // =========================
    // CRUD
    // =========================

    async function loadHoTypeList(){

        try{

            const response = await fetch(
                `/manager/ho-type/hoTyList/${mgmtOfcNo}`
            );

            if(!response.ok){
                throw new Error("평형 타입 조회 실패");
            }

            const data = await response.json();

            renderHoTypeList(data);

            if(renderHoTypeSelect){
                renderHoTypeSelect(data);
            }

        }catch(error){

            console.error(error);

        }

    }

    function renderHoTypeList(list){

        if(!list || list.length === 0){

            hoTypeList.innerHTML = `
    <div class="empty-message">
        등록된 평형 타입이 없습니다.
</div>
    `;

            return;
        }

        hoTypeList.innerHTML = list.map(item => `

    <div class="ho-type-card">

        <div class="ho-type-card-top">

        <div>

        <strong class="ho-type-name">
        ${item.tyNm}
        </strong>   

    <p class="ho-type-size">
        전용 ${item.exclusiveSize}㎡
    </p>

</div>

</div>

    <div class="ho-type-card-info">

        방 ${item.roomCnt} · 욕실 ${item.bathroomCnt}

    </div>

    <div class="ho-type-card-actions">

        <button type="button"
                class="btn btn-sm btn-secondary btn-edit-type"
                data-hoty-no="${item.hoTyNo}"
                data-ty-nm="${item.tyNm}"
                data-exclusive-size="${item.exclusiveSize}"
                data-room-cnt="${item.roomCnt}"
                data-bathroom-cnt="${item.bathroomCnt}"
                data-google-id="${item.googleId}"
                >
        
            수정
        
        </button>

        <button type="button"
                class="btn btn-sm btn-danger btn-delete-type"
                data-hoty-no="${item.hoTyNo}">
        
            삭제
        
        </button>

    </div>

</div>

    `).join("");

        document
            .querySelectorAll(".btn-edit-type")
            .forEach(btn => {

                btn.addEventListener("click", () => {
                    imageChanged = false;
                    isEditMode = true;
                    hoTypeImage.value = "";

                    editingHoTyNo =
                        btn.dataset.hotyNo;

                    // input 세팅
                    document.querySelector("#tyNm").value =
                        btn.dataset.tyNm;

                    document.querySelector("#exclusiveSize").value =
                        btn.dataset.exclusiveSize;

                    document.querySelector("#roomCnt").value =
                        btn.dataset.roomCnt;

                    document.querySelector("#bathroomCnt").value =
                        btn.dataset.bathroomCnt;

                    // 이미지 세팅
                    const googleId =
                        btn.dataset.googleId;

                    if(googleId && googleId !== "null"){

                        hoPreviewImg.src =
                            `/file/display/${googleId}`;

                        hoUploadContent.style.display = "none";

                        hoPreviewCard.style.display = "flex";

                        hoRemoveBtn.style.display = "flex";
                    }else{

                        hoPreviewImg.src = "";

                        hoRemoveBtn.style.display = "none";

                        hoPreviewCard.style.display = "none";

                        hoUploadContent.style.display = "flex";
                    }

                    // 타이틀 변경
                    document.querySelector(
                        ".ho-type-modal-title"
                    ).textContent = "평형 타입 수정";

                    // 버튼 텍스트 변경
                    btnInsertHoType.textContent =
                        "수정 완료";

                    // 모달 열기
                    hoTypeModal.classList.add("show");

                    hoTypeModalBackdrop.classList.add("show");

                });

            });


        document
            .querySelectorAll(".btn-delete-type")
            .forEach(btn => {

                btn.addEventListener("click", async () => {

                    const hoTyNo =
                        btn.dataset.hotyNo;

                    const deleteConfirm = await showConfirm({
                        title: "평형 타입을 삭제하시겠습니까?",
                        confirmText: "삭제",
                        confirmColor: "#c0392b"
                    });

                    if (!deleteConfirm.isConfirmed) {
                        return;
                    }

                    try{

                        const formData =
                            new FormData();

                        formData.append(
                            "hoTyNo",
                            hoTyNo
                        );

                        const response =
                            await fetch(
                                `/manager/ho-type/delete/${mgmtOfcNo}`,
                                {
                                    method: "POST",

                                    headers: {
                                        [csrfHeader]: csrfToken
                                    },

                                    body: formData
                                }
                            );

                        if(!response.ok){
                            throw new Error("삭제 실패");
                        }

                        const result =
                            await response.json();

                        console.log(result);

                        if(!result.success){

                            alert(
                                result.message || "삭제 실패"
                            );

                            return;
                        }

                        alert("삭제 완료");

                        await loadHoTypeList();

                    }catch(error){

                        console.error(error);

                        alert("삭제 실패");
                    }

                });

            });


    }


    async function insertHoType(){

            const url = isEditMode
                ? `/manager/ho-type/update/${mgmtOfcNo}`
                : `/manager/ho-type/insert/${mgmtOfcNo}`;


            try{

                const formData = new FormData();

                formData.append(
                    "imageChanged",
                    imageChanged
                );

                formData.append(
                    "mgmtOfcNo",
                    mgmtOfcNo
                );

                formData.append(
                    "tyNm",
                    document.querySelector("#tyNm").value
                );

                formData.append(
                    "exclusiveSize",
                    document.querySelector("#exclusiveSize").value
                );

                formData.append(
                    "roomCnt",
                    document.querySelector("#roomCnt").value
                );

                formData.append(
                    "bathroomCnt",
                    document.querySelector("#bathroomCnt").value
                );

                if(isEditMode){
                    formData.append(
                        "hoTyNo",
                        editingHoTyNo
                    );
                }

                // 이미지
                const imageFile =
                    hoTypeImage.files[0];

                if(imageFile){
                    formData.append(
                        "imageFile",
                        imageFile
                    );
                }

                const response = await fetch(
                    url,
                    {
                        method: "POST",

                        headers: {
                            [csrfHeader]: csrfToken
                        },

                        body: formData
                    }
                );

                if(!response.ok){
                    throw new Error("평형 타입 등록 실패");
                }

                const result = await response.json();

                console.log(result);

                alert(
                    isEditMode
                        ? "수정 완료"
                        : "등록 완료"
                );

                closeTypeModal();

                await loadHoTypeList();

            }catch(error){

                console.error(error);

                alert("등록 실패");

            }

        }

    btnInsertHoType.addEventListener(
        "click",
        insertHoType
    );

    window.hoTypeManager = {
        loadHoTypeList
    };

};