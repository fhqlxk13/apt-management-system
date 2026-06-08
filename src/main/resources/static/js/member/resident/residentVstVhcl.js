document.addEventListener("DOMContentLoaded", () => {

    const body = document.body;

    const memberType = body.dataset.memberType;

    const isResident = memberType === "ResidentVO";

    const modal = document.getElementById("visitModal");

    const openModalBtn =
        document.getElementById("openModalBtn");

    const closeModalBtn =
        document.getElementById("closeModalBtn");

    const closeModalBtn2 =
        document.getElementById("closeModalBtn2");

    const registerVisitBtn =
        document.getElementById("registerVisitBtn");

    const stayHrInput =
        document.getElementById("stayHr");

    const visitDate =
        document.getElementById("visitDate");

    const pageData =
        document.getElementById("pageData");

    const aptCmplexNo =
        pageData.dataset.aptCmplexNo;

    const csrfToken =
        document.querySelector('meta[name="_csrf"]').content;

    const csrfHeader =
        document.querySelector('meta[name="_csrf_header"]').content;

    const vhclTypeMap = {

        SEDAN : "승용차",

        SUV : "SUV",

        VAN : "승합차",

        LIGHT_TRUCK : "소형트럭",

        TRUCK : "화물트럭",

        BIKE : "오토바이"
    };

    // =========================
    // 초기 세팅
    // =========================

    const now = new Date();

    const offset = now.getTimezoneOffset();

    const localToday =
        new Date(now.getTime() - offset * 60000)
            .toISOString()
            .split("T")[0];

    visitDate.min = localToday;

    loadVisitList();

    // =========================
    // 이벤트
    // =========================

    openModalBtn.addEventListener("click", () => {

        if (!isResident) {

            alert("입주민만 사용 가능한 기능입니다.");

            return;
        }

        modal.classList.add("active");
    });

    closeModalBtn.addEventListener("click", closeModal);

    closeModalBtn2.addEventListener("click", closeModal);

    //검은색 영역 누르면 꺼지게 하는 부분,
/*    window.addEventListener("click", e => {

        if (e.target === modal) {
            closeModal();
        }
    });*/

    stayHrInput.addEventListener("input", handleStayHour);

    stayHrInput.addEventListener("wheel", e => {
        e.target.blur();
    });

    registerVisitBtn.addEventListener("click", registerVisit);

    // =========================
    // 함수
    // =========================

    function closeModal() {

        modal.classList.remove("active");
    }

    function handleStayHour() {

        let value = Number(stayHrInput.value);

        if (value > 72) {
            stayHrInput.value = 72;
        }

        if (value < 1 && stayHrInput.value !== "") {
            stayHrInput.value = 1;
        }
    }

    function validateStayHour() {

        const value = Number(stayHrInput.value);

        if (!value || value < 1 || value > 72) {

            alert("체류시간은 최대 72시간까지 가능합니다.");

            return false;
        }

        return true;
    }

    function validateVhclNo(backNo) {

        const regex = /^[0-9]{4}$/;

        if (!regex.test(backNo)) {

            alert("차량번호 뒤 4자리를 입력해주세요.");

            return false;
        }

        return true;
    }

    function registerVisit() {

        const data = {

            vstVhclTyCd:
            document.getElementById("vstVhclTyCd").value,

            vstVhclNo:
                document.getElementById("vstVhclNo")
                    .value
                    .trim(),

            vstrNm:
                document.getElementById("vstRm")
                    .value
                    .trim(),

            visitDate:
            document.getElementById("visitDate").value,

            visitHour:
            document.getElementById("visitHour").value,

            stayHr:
            stayHrInput.value,

            vstPrpsCn:
                document.getElementById("vstPrpsCn")
                    .value
                    .trim()
        };

        if (!validateStayHour()) {
            return;
        }

        if (!validateVhclNo(data.vstVhclNo)) {
            return;
        }

        if (!data.visitDate || !data.visitHour) {

            alert("방문일시를 선택해주세요.");

            return;
        }

        fetch(
            "/resident/vstVhcl/register/" + aptCmplexNo,
            {
                method: "POST",

                headers: {
                    "Content-Type": "application/json",
                    [csrfHeader]: csrfToken
                },

                body: JSON.stringify(data)
            }
        )
            .then(res => {

                if (!res.ok) {
                    throw new Error("등록 실패");
                }

                return res.text();
            })
            .then(() => {

                Swal.fire({
                    icon: "success",
                    title: "방문 예약 등록 완료",
                    confirmButtonText: "확인",
                    confirmButtonColor: "#2e5c38"
                }).then(() => {
                    closeModal();
                    loadVisitList();
                });
            })
            .catch(err => {
                Swal.fire({
                    icon: "error",
                    title: err.message || "등록 실패",
                    confirmButtonText: "확인",
                    confirmButtonColor: "#2e5c38"
                });
            });
    }

    function loadVisitList(currentPage = 1) {

        fetch(
            "/resident/vstVhcl/list/"
            + aptCmplexNo
            + "?currentPage="
            + currentPage,
            {
                method: "GET",

                headers: {
                    [csrfHeader]: csrfToken
                }
            }
        )
            .then(res => {

                if (!res.ok) {
                    throw new Error("목록 조회 실패");
                }

                return res.json();
            })
            .then(pagingVO => {

                const list =
                    pagingVO.dataList;

                const tbody =
                    document.getElementById("visitTableBody");

                tbody.innerHTML = "";

                if (!list || list.length === 0) {

                    tbody.innerHTML = `
                    <tr>
                        <td colspan="9">
                            등록된 방문예약이 없습니다.
                        </td>
                    </tr>
                `;

                    document.getElementById("pagingArea")
                        .innerHTML = "";

                    return;
                }

                list.forEach((v, idx) => {

                    let statusText = "";

                    let badgeClass = "";

                    if (v.vstSttsCd === "APRV") {

                        statusText = "승인";

                        badgeClass = "ok";

                    } else {

                        statusText = "승인대기";

                        badgeClass = "wait";
                    }

                    tbody.innerHTML += `
                    <tr>
                        <td>
                            ${(currentPage - 1) * 10 + idx + 1}
                        </td>

                        <td>
                            ${v.vstrNm ?? '-'}
                        </td>

                        <td>
                            ${v.vstVhclNo ?? '-'}
                        </td>

                        <td>
                            ${vhclTypeMap[v.vstVhclTyCd] ?? '-'}
                        </td>

                        <td>
                            ${v.vstPrpsCn ?? '-'}
                        </td>

                        <td>
                            ${formatDateTime(v.vstYmd)}
                        </td>

                        <td>
                            ${v.stayHr}시간
                        </td>

                        <td>
                            <span class="badge ${badgeClass}">
                                ${statusText}
                            </span>
                        </td>

                        <td>
                            <button class="delete-btn"
                                    data-rsvt-no="${v.vstVhclRsvtNo}">
                                삭제
                            </button>
                        </td>
                    </tr>
                `;
                });

                const pagingArea =
                    document.getElementById("pagingArea");

                if(pagingVO.totalPage <= 1){

                    pagingArea.innerHTML = "";

                } else {

                    pagingArea.innerHTML =
                        pagingVO.pagingHTML;
                }

            })
            .catch(err => {

                console.error(err);

                alert(err.message);
            });
    }

    function formatDateTime(dateStr){

        if(!dateStr){
            return "-";
        }

        const date = new Date(dateStr);

        const yyyy = date.getFullYear();

        const mm =
            String(date.getMonth() + 1)
                .padStart(2,"0");

        const dd =
            String(date.getDate())
                .padStart(2,"0");

        const hh =
            String(date.getHours())
                .padStart(2,"0");

        const mi =
            String(date.getMinutes())
                .padStart(2,"0");

        return `${yyyy}.${mm}.${dd} ${hh}:${mi}`;
    }

    document.getElementById("visitTableBody")
        .addEventListener("click", e => {

            const btn =
                e.target.closest(".delete-btn");

            if(!btn){
                return;
            }

            const rsvtNo =
                btn.dataset.rsvtNo;

            if(!confirm("방문예약을 삭제하시겠습니까?")){
                return;
            }

            deleteVisit(rsvtNo);
        });

    function deleteVisit(rsvtNo){

        fetch(
            "/resident/vstVhcl/delete/"
            + aptCmplexNo
            + "/"
            + rsvtNo,
            {
                method : "DELETE",

                headers : {
                    [csrfHeader] : csrfToken
                }
            }
        )
            .then(res => {
                if(!res.ok){
                    throw new Error("삭제 실패");
                }
                alert("삭제되었습니다.");

                loadVisitList();
            })
            .catch(err => {
                console.error(err);
                alert(err.message);
            });
    }

    document.addEventListener("click", e => {

        const pageLink =
            e.target.closest(".page-link");

        if(!pageLink){
            return;
        }

        e.preventDefault();

        const page =
            pageLink.dataset.page;

        if(!page){
            return;
        }

        loadVisitList(page);
    });

});