<%--
  Created by IntelliJ IDEA.
  User: PC-14
  Date: 2026-04-23
  Time: 오후 4:07
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<html>
<head>
    <title>아파트목록조회</title>
</head>
<style>
    #aptListBox {
        width: 400px;
        height: 300px;
        border: 1px solid #333;
        padding: 10px;
        overflow-y: auto;
        margin-top: 10px;
    }

    #aptList div {
        padding: 5px;
        border-bottom: 1px solid #eee;
    }

    #aptList div:hover {
        background-color: #f5f5f5;
    }

    #insertResidentBtn {
        margin-top: 10px;
        padding: 8px 12px;
        background-color: #4CAF50;
        color: white;
        border: none;
        cursor: pointer;
    }

    select {
        width: 100px;
        max-width: 200px;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
    }

    label {
        cursor: pointer;
    }

    #toastContainer {
        position: fixed;
        right: 24px;
        bottom: 24px;
        display: flex;
        flex-direction: column;
        gap: 12px;
        z-index: 9999;
    }

    .toast-item {
        min-width: 320px;
        background: white;
        border-radius: 14px;
        padding: 16px;
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
        border-left: 6px solid #22c55e;
        animation: toastShow .25s ease;
    }

    .toast-title {
        font-weight: 700;
        margin-bottom: 6px;
    }

    .toast-message {
        color: #555;
    }

    @keyframes toastShow {

        from {
            opacity: 0;
            transform: translateY(20px);
        }

        to {
            opacity: 1;
            transform: translateY(0);
        }
    }
</style>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<body>
<input type="button" value="apt동기화" id="aptBtn" onclick="collect()" hidden="hidden">
<button id="btnUpdateLatLng"
        class="px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600"
hidden="hidden">
    좌표 업데이트 실행
</button>

<select id="sido"></select>
<select id="sigungu"></select>
<select id="emd"></select>

<button id="searchBtn">검색</button>
<button id="publicSearchBtn" hidden="hidden">공공데이터 조회</button>

<div>
    <label>
        <input type="checkbox" id="checkAll">
        전체선택
    </label>
</div>
<div id="aptListBox">
    <div id="aptList"></div>
</div>

<div style="margin-top:10px;">
    <input type="number" id="userCount" placeholder="생성할 유저 수">
    <button id="createUserBtn">유저 생성</button>
</div>

<div id="userInfo" style="margin-top:10px;"></div>

<div style="margin-top:10px;">
    <input type="number" id="assignCount" placeholder="입주시킬 인원 수" min="1">
    <button id="assignBtn">입주시키기</button>
</div>
<div style="margin-top:20px;">

    <button id="toastTestBtn">
        토스트 테스트
    </button>

</div>

<div id="toastContainer"></div>

</body>
<script>
    $(function () {

        loadNotAssignedUserCount();

        const searchBtn = $("#searchBtn");

        $.ajax({
            url: "/api/adm/aptCmplex/sido",
            success: function (result) {
                fillSelect(sidoEl, result);
            }
        })

        const sidoEl = document.getElementById("sido");
        const sigunguEl = document.getElementById("sigungu");
        const emdEl = document.getElementById("emd");

        function fillSelect(selectEl, data) {
            selectEl.innerHTML = '';

            const defaultOption = document.createElement("option");
            defaultOption.value = "";
            defaultOption.textContent = "--선택--";
            selectEl.appendChild(defaultOption);

            data.forEach(item => {
                if (!item || item.trim() === "") return;

                const option = document.createElement("option");
                option.value = item;
                option.textContent = item;
                selectEl.appendChild(option);
            });
        }

        $("#sido").change(function () {
            fetch(`/api/adm/aptCmplex/sigungu?sido=` + $(this).val())
                .then(res => res.json())
                .then(data => {
                    fillSelect(sigunguEl, data);
                });
            console.log(sidoEl);
        });

        $("#sigungu").change(function () {
            const sido = $("#sido").val();
            fetch(
                "/api/adm/aptCmplex/emd?sido="
                + encodeURIComponent(sido)
                + "&sigungu="
                + encodeURIComponent($(this).val())
            )
                .then(res => res.json())
                .then(data => {
                    fillSelect(emdEl, data);
                });
            console.log(emdEl);
        });


        searchBtn.on("click", function () {
            const sido = $("#sido").val();
            const sigungu = $("#sigungu").val();
            const emd = $("#emd").val();

            let url = "/api/adm/aptCmplex/aptList?";

            const params = [];

            if (sido) params.push("sido=" + encodeURIComponent(sido));
            if (sigungu) params.push("sigungu=" + encodeURIComponent(sigungu));
            if (emd) params.push("emd=" + encodeURIComponent(emd));

            url += params.join("&");

            fetch(url)
                .then(res => res.json())
                .then(data => {

                    let html = "";

                    data.forEach(apt => {
                        html += `
                                <div class="apt-row">
                                    <input type="checkbox" id="apt_\${apt.aptCmplexNo}" value="\${apt.aptCmplexNo}">
                                    <label for="apt_\${apt.aptCmplexNo}">
                                        \${apt.aptCmplexNm}
                                    </label>
                                </div>
                `;
                    });

                    $("#aptList").html(html);
                });
        })

        $("#aptList").on("click", ".apt-row", function (e) {

            if (e.target.tagName === "INPUT") return;

            const checkbox = $(this).find("input[type=checkbox]");
            checkbox.prop("checked", !checkbox.prop("checked"));
        });

        $("#checkAll").on("change", function () {

            const isChecked = $(this).prop("checked");

            $("#aptList input[type=checkbox]").prop("checked", isChecked);

            $(".apt-row").toggleClass("selected", isChecked);
        });

        $("#aptList").on("change", "input[type=checkbox]", function () {

            const total = $("#aptList input[type=checkbox]").length;
            const checked = $("#aptList input[type=checkbox]:checked").length;

            $("#checkAll").prop("checked", total === checked);

            $(this).closest(".apt-row").toggleClass("selected", this.checked);
        });

        $("#aptList").on("click", ".apt-row", function (e) {

            if (e.target.tagName === "INPUT") return;

            const checkbox = $(this).find("input[type=checkbox]");
            const isChecked = !checkbox.prop("checked");

            checkbox.prop("checked", isChecked).trigger("change");
        });

    });

    $("#createUserBtn").on("click", function () {

        const count = $("#userCount").val();

        if (!count || count <= 0) {
            alert("생성할 유저 수를 입력하세요");
            return;
        }

        fetch("/api/adm/aptCmplex/user/createDummy", {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({count: count})
        })
            .then(res => res.text())
            .then(msg => {
                alert(msg);
                loadNotAssignedUserCount();
            });
    });

    function loadNotAssignedUserCount() {

        fetch("/api/adm/aptCmplex/user/notAssignedCount")
            .then(res => res.json())
            .then(count => {
                $("#userInfo").text("미입주 유저 수: " + count);
            });
    }


    async function collect() {

        const sido = $("#sido").val();
        const sigungu = $("#sigungu").val();
        const emd = $("#emd").val();

        const res = await fetch('/api/adm/aptCmplex/apt/collect', {
            method: 'POST',
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({
                sido: sido,
                sigungu: sigungu,
                emd: emd
            })
        });

        const text = await res.text();
        alert(text);
    }

    document.getElementById("btnUpdateLatLng").addEventListener("click", async () => {

        if (!confirm("좌표 업데이트를 실행하시겠습니까?")) return;

        try {
            const response = await fetch("/api/adm/aptCmplex/updateLatLng.do", {
                method: "POST"
            });

            const result = await response.text();

            alert("완료: " + result);

        } catch (e) {
            console.error(e);
            alert("실패");
        }
    });


    $("#assignBtn").on("click", function () {

        const count = $("#assignCount").val();

        if (!count || count <= 0) {
            alert("입주시킬 인원 수를 입력하세요");
            return;
        }

        const selected = [];

        $("#aptList input:checked").each(function () {
            selected.push($(this).val());
        });

        if (selected.length === 0) {
            alert("아파트 선택하세요");
            return;
        }

        fetch("/api/adm/aptCmplex/apt/assignResidents", {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({
                aptList: selected,
                count: count
            })
        })
            .then(res => res.text())
            .then(msg => alert(msg));
        $("#assignCount").val("");

        loadNotAssignedUserCount();
    });


    $("#publicSearchBtn").on("click", async function () {

        const sido = $("#sido").val();
        const sigungu = $("#sigungu").val();
        const emd = $("#emd").val();

        if (!sido) {
            alert("시/도를 선택하세요");
            return;
        }

        try {

            const response = await fetch("/api/adm/aptCmplex/apt/checkBaseInfo", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify({
                    sido: sido,
                    sigungu: sigungu,
                    emd: emd
                })
            });

            if (!response.ok) {
                throw new Error("status : " + response.status);
            }

            const result = await response.json();

            let html = "";

            if (!result || result.length === 0) {

                html = "<div>조회 결과 없음</div>";

            } else {

                result.forEach(apt => {

                    html += `
                    <div class="apt-row">
                        <div>
                            <strong>\${apt.kaptName}</strong>
                        </div>

                        <div>
                            주소 : \${apt.doroJuso ?? '-'}
                        </div>

                        <div>
                            세대수 : \${apt.kaptdaCnt ?? '-'}
                        </div>

                        <hr>
                    </div>
                `;
                });
            }

            $("#aptList").html(html);

        } catch (e) {

            console.error(e);
            alert("조회 실패");
        }
    });

    $("#toastTestBtn").on("click", function () {

        showToast({
            title: "테스트 알림",
            message: "실시간 토스트 테스트입니다.",
            type: "success"
        });

    });

</script>
<jsp:include page="/WEB-INF/views/include/websocket.jsp"/>

</html>
