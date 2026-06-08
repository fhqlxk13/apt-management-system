<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>투표/설문 상세</title>
    <sec:csrfMetaTags/>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/office-layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/manager-common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        #surveyDetailPage .detail-layout {
            display: flex;
            flex-direction: column;
            gap: 16px;
        }

        #surveyDetailPage .detail-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 16px;
            flex-wrap: wrap;
        }

        #surveyDetailPage .detail-header .form-input,
        #surveyDetailPage .detail-header .form-textarea {
            width: min(780px, 100%);
        }

        #surveyDetailPage .detail-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 12px;
        }

        #surveyDetailPage .detail-box {
            background: #fff;
            border: 1px solid var(--border);
            border-radius: 8px;
            padding: 18px;
        }

        #surveyDetailPage .detail-label {
            font-size: 12px;
            color: var(--text-tertiary);
            margin-bottom: 6px;
        }

        #surveyDetailPage .detail-value {
            font-size: 15px;
            font-weight: 700;
            color: var(--text-primary);
        }

        #surveyDetailPage .question-box {
            border: 1px solid #dfe5ec;
            border-radius: 12px;
            padding: 18px;
            background: #fafbfc;
        }

        #surveyDetailPage .question-title {
            font-size: 16px;
            font-weight: 700;
            margin-bottom: 14px;
        }

        @media (max-width: 1180px) {
            #surveyDetailPage .detail-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        @media (max-width: 720px) {
            #surveyDetailPage .detail-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
<div class="app-wrapper">
    <%@ include file="/WEB-INF/views/include/office_sidebar.jsp" %>
    <div class="main-wrap">
        <%@ include file="/WEB-INF/views/include/office_header.jsp" %>
        <c:set var="activeSidebarHref" value="${pageContext.request.contextPath}/manager/survey/${mgmtOfcNo}" />
        <c:set var="activeSidebarParent" value="소통·행정 관리" />
        <c:set var="activeSidebarCurrent" value="투표·설문 관리" />
        <%@ include file="/WEB-INF/views/include/office_active_sidebar.jspf" %>
        <main class="main-content">
            <div class="office-page" id="surveyDetailPage">
                <div class="detail-layout">
                    <div class="panel">
                        <div class="panel-body">
                            <div class="detail-header">
                                <div>
                                    <input type="text" class="form-input" id="surveyTitle" placeholder="제목">







                                </div>
                                <div style="display:flex; gap:8px; flex-wrap:wrap;">
                                    <button type="button" class="btn btn-secondary" id="resultBtn">결과 보기</button>
                                    <button type="button" class="btn btn-primary" id="updateBtn">저장</button>
                                    <button type="button" class="btn btn-danger" id="deleteBtn">삭제</button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="detail-grid">
                        <div class="detail-box">
                            <div class="detail-label">상태</div>
                            <div class="detail-value">
                                <select class="form-select" id="surveyStatus">
                                    <option value="READY">대기중</option>
                                    <option value="OPEN">진행중</option>
                                    <option value="CLOSED">종료</option>
                                </select>
                            </div>
                        </div>

                        <div class="detail-box">
                            <div class="detail-label">구분</div>
                            <div class="detail-value">
                                <select class="form-select" id="surveyTypeSelect">
                                    <option value="VOTE">투표</option>
                                    <option value="SURVEY">설문</option>
                                </select>
                            </div>
                        </div>

                        <div class="detail-box">
                            <div class="detail-label">기간</div>
                            <div style="display:flex; gap:8px;">
                                <input type="date" class="form-input" id="surveyBgngDt">
                                <input type="date" class="form-input" id="surveyEndDt">
                            </div>
                        </div>


                    </div>


                    <div id="questionContainer"></div>
                </div>
            </div>
        </main>
    </div>
</div>

<script>
    const ctx = "${pageContext.request.contextPath}";
    const mgmtOfcNo = "${mgmtOfcNo}";
    const surveyNo = "${surveyNo}";
    const csrfHeader = document.querySelector('meta[name="_csrf_header"]')?.content;
    const csrfToken = document.querySelector('meta[name="_csrf"]')?.content;

    let survey = null;

    function authHeaders(base) {
        const headers = Object.assign({}, base || {});
        if (csrfHeader && csrfToken) {
            headers[csrfHeader] = csrfToken;
        }
        return headers;
    }

    function toDateInput(value) {
        if (!value) return "";
        return String(value).substring(0, 10);
    }

    function normalizeStatus(value) {
        if (value === "WAITING") return "READY";
        if (value === "RUNNING") return "OPEN";
        if (value === "READY") return "READY";
        if (value === "PROGRESS") return "OPEN";
        if (value === "END") return "CLOSED";
        return value || "READY";
    }

    document.addEventListener("DOMContentLoaded", function () {
        loadSurveyDetail();
    });

    async function loadSurveyDetail() {
        const resp = await fetch(`${ctx}/manager/survey/${mgmtOfcNo}/detail/${surveyNo}/data`);
        if (!resp.ok) {
            throw new Error("상세 정보를 불러오지 못했습니다.");
        }
        survey = await resp.json();
        renderSurveyDetail();
    }

    function renderSurveyDetail() {
        document.getElementById("surveyTitle").value = survey?.surveyNm || "";
        document.getElementById("surveyStatus").value = normalizeStatus(survey?.surveySttsCd);
        document.getElementById("surveyTypeSelect").value = survey?.surveyTypeCd || "SURVEY";
        document.getElementById("surveyBgngDt").value = toDateInput(survey?.surveyBgngDt);
        document.getElementById("surveyEndDt").value = toDateInput(survey?.surveyEndDt);




        const questionList =
            JSON.parse(survey?.surveyQitemCn || "[]");

        const container =
            document.getElementById("questionContainer");

        let html = "";

        questionList.forEach(function(q, idx){

            html +=

                '<div class="question-box" style="margin-bottom:16px;">'
                + '<div class="question-title">'
                + 'Q' + (idx + 1) + '. '
                + q.question
                + '</div>'

                + '<input type="hidden" '
                + 'class="question-input" '
                + 'value="' + q.question + '">';


            if(q.items){

                q.items.forEach(function(item){

                    html +=

                        '<input type="text" '
                        + 'class="form-input" '
                        + 'value="' + item + '" '
                        + 'style="margin-bottom:8px;">';
                });
            }

            html += '</div>';
        });

        container.innerHTML = html;





    }

    document.getElementById("updateBtn").addEventListener("click", async function () {

        const questionBoxes =
            document.querySelectorAll("#questionContainer .question-box");

        const questionList = [];

        questionBoxes.forEach(function(box){

            const inputs =
                box.querySelectorAll("input");

            const question =
                box.querySelector(".question-input").value;

            const items = [];

            for(let i = 1; i < inputs.length; i++){

                items.push(inputs[i].value);
            }

            questionList.push({
                question: question,
                type: "MULTI",
                items: items
            });
        });


        const body = {
            surveyNm: document.getElementById("surveyTitle").value,

            surveySttsCd: document.getElementById("surveyStatus").value,
            surveyTypeCd: document.getElementById("surveyTypeSelect").value,
            surveyBgngDt: document.getElementById("surveyBgngDt").value,
            surveyEndDt: document.getElementById("surveyEndDt").value,


            surveyQitemCn:
                JSON.stringify(questionList),


        };

        const resp = await fetch(`${ctx}/manager/survey/${mgmtOfcNo}/detail/${surveyNo}`, {
            method: "PUT",
            headers: authHeaders({
                "Content-Type": "application/json"
            }),
            body: JSON.stringify(body)
        });

        if (resp.ok) {
            await showAlertThen("저장 완료", `${ctx}/manager/survey/${mgmtOfcNo}`, "success");
        } else {

            const errorText = await resp.text();

            console.error(errorText);

            await showAlert("저장 실패 : " + errorText, "error");
        }
    });

    document.getElementById("deleteBtn").addEventListener("click", async function () {
        const deleteConfirm = await showConfirm({
            title: "삭제하시겠습니까?",
            confirmText: "삭제",
            confirmColor: "#c0392b"
        });
        if (!deleteConfirm.isConfirmed) return;

        const resp = await fetch(`${ctx}/manager/survey/${mgmtOfcNo}/detail/${surveyNo}`, {
            method: "DELETE",
            headers: authHeaders()
        });

        if (resp.ok) {
            await showAlertThen("삭제 완료", `${ctx}/manager/survey/${mgmtOfcNo}`, "success");
        } else {
            await showAlert("삭제 실패", "error");
        }
    });


    document.getElementById("resultBtn").addEventListener("click", function () {

        location.href =
            ctx
            + "/manager/survey/"
            + mgmtOfcNo
            + "/result/"
            + surveyNo;
    });


</script>

<script src="${pageContext.request.contextPath}/js/office-layout.js"></script>
</body>
</html>
