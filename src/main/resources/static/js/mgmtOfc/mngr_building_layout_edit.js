document.addEventListener("DOMContentLoaded", async () => {

    let allHoList = [];

    const csrfToken = document.querySelector('meta[name="_csrf"]').content;

    const csrfHeader = document.querySelector('meta[name="_csrf_header"]').content;

    const wrap = document.querySelector(".unit-manage-wrap");

    const btnApplyHoStatus = document.querySelector("#btnApplyHoStatus");

    const btnApplyHoType = document.querySelector("#btnApplyHoType");

    const mgmtOfcNo = wrap.dataset.mgmtOfcNo;

    window.initHoTypeManager({
        mgmtOfcNo,
        csrfToken,
        csrfHeader,
        renderHoTypeSelect
    });

    // =========================
    // 컬럼 정의
    // =========================
    const columnDefs = [

        {
            headerName: "동",
            field: "dongNm",

            comparator: (a, b) => {
                return Number(a) - Number(b);
            },

            sort: "asc"
        },

        {
            headerName: "호",
            field: "ho",

            comparator: (a, b) => {
                return Number(a) - Number(b);
            },

            sort: "asc"
        },

        {
            headerName: "층",
            field: "floor",
            width: 90
        },

        {
            headerName: "호 타입",
            field: "tyNm",
            width: 140
        },

        {
            headerName: "이미지",
            field: "imageNo",
            flex: 1,
            valueFormatter: params => params.value || "-"
        },

        {
            headerName: "파노라마",
            field: "panoImageNo",
            flex: 1,
            valueFormatter: params => params.value || "-"
        },

        {
            headerName: "상태",
            field: "hoSttsCd",
            width: 140,

            valueFormatter: params => {

                switch (params.value) {

                    case "EMPTY":
                        return "공실";

                    case "LIVE":
                        return "거주중";

                    case "DISABLED":
                        return "비활성";

                    default:
                        return params.value;
                }
            }
        }

    ];

    const gridApi = agGrid.createGrid(
        document.querySelector("#unitGrid"),

        {
            columnDefs,

            rowData: [],

            defaultColDef: {
                sortable: true,
                filter: true,
                resizable: true
            },

            alwaysMultiSort: true,

            rowSelection: {
                mode: "multiRow",

                checkboxes: true,

                headerCheckbox: true,

                enableClickSelection: false,

                enableSelectionWithoutKeys: true
            },

            animateRows: true,

            onSelectionChanged: syncLayoutSelection
        }
    );

    await reloadHoData();


    /*화면 다시그리기*/
    async function reloadHoData(selectedDongNo = null) {

        try {

            const response = await fetch(
                `/manager/complexEdit/hoList/${mgmtOfcNo}`
            );

            if (!response.ok) {
                throw new Error("호 목록 조회 실패");
            }

            const data = await response.json();

            allHoList = data;

            // grid 갱신
            gridApi.setGridOption(
                "rowData",
                data
            );

            // 동 select 다시 그림
            renderDongSelect(data);

            // 기존 선택 동 유지
            if (selectedDongNo) {

                document.querySelector("#dongSelect").value =
                    selectedDongNo;

                changeDongLayout(selectedDongNo);

            }

            await window.hoTypeManager.loadHoTypeList();

        } catch (error) {

            console.error(error);

        }

    }


    function renderDongSelect(list) {

        const dongSelect =
            document.querySelector("#dongSelect");

        const dongMap = new Map();

        list.forEach(item => {

            if (!dongMap.has(item.dongNo)) {

                dongMap.set(
                    item.dongNo,
                    item.dongNm
                );
            }

        });

        const sortedList =
            [...dongMap.entries()]
                .sort((a, b) =>
                    Number(String(a[1]).replace("동", "")) -
                    Number(String(b[1]).replace("동", ""))
                );

        dongSelect.innerHTML = `
        <option value="">동 선택</option>
    ` + sortedList.map(([dongNo, dongNm]) => `
        <option value="${dongNo}">
            ${dongNm}동
        </option>
    `).join("");

        // 최초 선택
        if (sortedList.length > 0) {

            dongSelect.value = sortedList[0][0];

            changeDongLayout(sortedList[0][0]);
        }

    }


    function renderFloorLayout(list) {

        const layoutGrid = document.querySelector("#unitLayoutGrid");

        if (!list || list.length === 0) {

            layoutGrid.innerHTML = `
            <div class="empty-message">
                등록된 호 정보가 없습니다.
            </div>
        `;

            return;
        }

        // 층별 그룹핑
        const floorMap = {};

        list.forEach(item => {

            const floor = item.floor;

            if (!floorMap[floor]) {
                floorMap[floor] = [];
            }

            floorMap[floor].push(item);


        });

        // 층 내 호 정렬
        Object.values(floorMap).forEach(floorList => {

            floorList.sort((a, b) => {
                return Number(a.ho) - Number(b.ho);
            });

        });

        // 층 내림차순
        const sortedFloors =
            Object.keys(floorMap)
                .map(Number)
                .sort((a, b) => b - a);

        layoutGrid.innerHTML =
            sortedFloors.map(floor => {

                const hoList = floorMap[floor];

                return `
                <div class="unit-floor-row">
            
                    <div class="unit-floor-label">
                        ${floor}F
                    </div>
            
                    <div class="unit-floor-hos">
            
                        ${hoList.map(ho => {

                    let statusClass = "";

                    switch (ho.hoSttsCd) {

                        case "LIVE":
                            statusClass = "live";
                            break;

                        case "EMPTY":
                            statusClass = "empty";
                            break;

                        case "DISABLED":
                            statusClass = "disabled";
                            break;

                        default:
                            statusClass = "";
                    }

                    return `
                            <div class="unit-cell ${statusClass}"
                                 data-ho-no="${ho.hoNo}">
                                 
                                ${ho.ho}
                                
                            </div>
                        `;

                }).join("")}

                    </div>
            
                </div>
            `;

            }).join("");

        bindUnitCellEvent();

        syncLayoutSelection();

    }

    function bindUnitCellEvent() {

        document
            .querySelectorAll(".unit-cell")
            .forEach(cell => {

                cell.addEventListener("click", () => {

                    const hoNo =
                        cell.dataset.hoNo;

                    const isSelected =
                        cell.classList.contains("selected");

                    gridApi.forEachNode(node => {

                        if (node.data.hoNo === hoNo) {

                            node.setSelected(!isSelected);

                        }

                    });

                });

            });

    }

    function syncLayoutSelection() {

        document
            .querySelectorAll(".unit-cell")
            .forEach(cell => {

                cell.classList.remove("selected");

            });

        const selectedRows = gridApi.getSelectedRows();

        selectedRows.forEach(row => {

            const target =
                document.querySelector(
                    `.unit-cell[data-ho-no="${row.hoNo}"]`
                );

            if (target) {

                target.classList.add("selected");

            }

        });

    }

    document
        .querySelector("#dongSelect")
        .addEventListener("change", e => {

            const dongNo = e.target.value;

            changeDongLayout(dongNo);

            const selectedOption =
                e.target.options[e.target.selectedIndex];

            document.querySelector("#dongNameInput").value =
                selectedOption.text.replace("동", "");

        });

    function changeDongLayout(dongNo) {

        const filteredList =
            allHoList.filter(item =>
                item.dongNo === dongNo
            );

        const layoutTitle =
            document.querySelector("#layoutTitle");

        const selectedData =
            filteredList[0];

        if (layoutTitle && selectedData) {

            layoutTitle.textContent =
                `${selectedData.dongNm}동 배치도`;

        }

        renderFloorLayout(filteredList);

        renderDongSummary(filteredList);
    }

    function renderHoTypeSelect(list) {

        const hoTypeSelect =
            document.querySelector("#hoTypeSelect");

        if (!list || list.length === 0) {

            hoTypeSelect.innerHTML = `
            <option value="">
                평형 선택
            </option>
        `;

            return;
        }

        hoTypeSelect.innerHTML = `
        <option value="">
            평형 선택
        </option>
    ` + list.map(item => `

        <option value="${item.hoTyNo}">
            ${item.tyNm}
        </option>

    `).join("");

    }


    function renderDongSummary(list) {

        if (!list || list.length === 0) {
            return;
        }

        // 총 층수
        const maxFloor =
            Math.max(
                ...list.map(item => Number(item.floor))
            );

        // 층별 그룹핑
        const floorMap = {};

        list.forEach(item => {

            if (!floorMap[item.floor]) {
                floorMap[item.floor] = [];
            }

            floorMap[item.floor].push(item);

        });

        // 층별 최대 세대수
        const hoPerFloor =
            Math.max(
                ...Object.values(floorMap)
                    .map(v => v.length)
            );

        // 총 세대수
        const totalHo = list.length;

        document.querySelector("#totalFloorInput").value =
            maxFloor;

        document.querySelector("#hoPerFloorInput").value =
            hoPerFloor;

        document.querySelector("#totalHoInput").value =
            `${totalHo}세대`;
    }

    document
        .querySelector("#btnApplyStructure")
        .addEventListener(
            "click",
            applyStructure
        );

    async function applyStructure() {

        const dongNo =
            document.querySelector("#dongSelect").value;

        const dongNm =
            document.querySelector("#dongNameInput").value.trim();

        const totalFloor =
            Number(
                document.querySelector("#totalFloorInput").value
            );

        const hoPerFloor =
            Number(
                document.querySelector("#hoPerFloorInput").value
            );

        if (!dongNo) {

            alert("동을 선택해주세요.");

            return;
        }

        if (!dongNm) {

            alert("동 이름을 입력해주세요.");

            return;
        }

        const structureConfirm = await showConfirm({
            title: "구조 변경 시 일부 호가 구조 제거될 수 있습니다.",
            text: "계속하시겠습니까?",
            confirmText: "변경"
        });
        if (!structureConfirm.isConfirmed) {
            return;
        }

        try {

            const response = await fetch(
                `/manager/complexEdit/updateStructure/${mgmtOfcNo}`,

                {
                    method: "POST",

                    headers: {
                        "Content-Type": "application/json",
                        [csrfHeader]: csrfToken
                    },

                    body: JSON.stringify({
                        mgmtOfcNo,
                        dongNo,
                        dongNm,
                        totalFloor,
                        hoPerFloor
                    })

                }
            );

            const result =
                await response.json();

            if (!result.success) {

                alert(
                    result.message ||
                    "구조 변경 실패"
                );

                return;
            }

            alert("구조 변경 완료");

            await reloadHoData(dongNo);

        } catch (error) {

            console.error(error);

            alert("구조 변경 실패");

        }

    }

    btnApplyHoStatus.addEventListener("click", applyHoStatus)

    btnApplyHoType.addEventListener("click", applyHoType);

    async function applyHoStatus() {

        const hoSttsCd =
            document.querySelector("#hoStatusSelect").value;

        if (!hoSttsCd) {

            alert("상태를 선택해주세요.");

            return;
        }

        const selectedRows =
            gridApi.getSelectedRows();

        if (selectedRows.length === 0) {

            alert("호를 선택해주세요.");

            return;
        }

        const hoNoList =
            selectedRows.map(row => row.hoNo);

        try {

            const response = await fetch(
                `/manager/complexEdit/updateHoStatus/${mgmtOfcNo}`,
                {
                    method: "POST",

                    headers: {
                        "Content-Type": "application/json",
                        [csrfHeader]: csrfToken
                    },

                    body: JSON.stringify({
                        aptCmplexNo: wrap.dataset.aptCmplexNo,
                        hoNoList,
                        hoSttsCd
                    })

                }
            );

            const result =
                await response.json();

            if (!result.success) {

                alert(
                    result.message ||
                    "상태 변경 실패"
                );

                return;
            }

            alert("상태 변경 완료");

            const currentDongNo =
                document.querySelector("#dongSelect").value;

            await reloadHoData(currentDongNo);

        } catch (error) {

            console.error(error);

            alert("상태 변경 실패");

        }

    }


    async function applyHoType() {

        const hoTyNo = document.querySelector("#hoTypeSelect").value;

        if (!hoTyNo) {
            alert("평형 타입을 선택해주세요.");
            return;
        }

        const selectedRows =
            gridApi.getSelectedRows();

        if (selectedRows.length === 0) {

            alert("호를 선택해주세요.");

            return;
        }

        const hoNoList =
            selectedRows.map(row => row.hoNo);

        try {

            const response = await fetch(
                `/manager/complexEdit/updateHoType/${mgmtOfcNo}`,
                {
                    method: "POST",

                    headers: {
                        "Content-Type": "application/json",
                        [csrfHeader]: csrfToken
                    },

                    body: JSON.stringify({
                        hoNoList,
                        hoTyNo
                    })
                }
            );

            const result = await response.json();

            if (!result.success) {
                alert(result.message || "평형 변경 실패");
                return;
            }

            alert("평형 변경 완료");

            const currentDongNo =
                document.querySelector("#dongSelect").value;

            await reloadHoData(currentDongNo);
        } catch (error) {
            console.error(error);
            alert("평형 변경 실패");
        }
    }

});
