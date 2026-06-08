<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>투표/설문 결과</title>

    <sec:csrfMetaTags/>

    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />

    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet" />

    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet" />

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/office-layout.css">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/manager/manager-common.css">


    <style>

        #surveyResultPage .result-layout{
            display:flex;
            flex-direction:column;
            gap:16px;
        }

        #surveyResultPage .summary-grid{
            display:grid;
            grid-template-columns:repeat(4,minmax(0,1fr));
            gap:12px;
        }

        #surveyResultPage .summary-card{
            background:#fff;
            border:1px solid var(--border);
            border-radius:10px;
            padding:18px;
        }

        #surveyResultPage .summary-label{
            font-size:12px;
            color:var(--text-tertiary);
            margin-bottom:8px;
        }

        #surveyResultPage .summary-value{
            font-size:28px;
            font-weight:800;
            color:var(--text-primary);
        }

        #surveyResultPage .question-card{
            border:1px solid #dfe5ec;
            border-radius:12px;
            background:#fff;
            overflow:hidden;
        }

        #surveyResultPage .question-header{
            padding:18px;
            border-bottom:1px solid #edf1f5;
            background:#fafbfc;
        }

        #surveyResultPage .question-title{
            font-size:17px;
            font-weight:700;
            color:#111827;
        }

        #surveyResultPage .question-sub{
            margin-top:6px;
            font-size:13px;
            color:#6b7280;
        }

        #surveyResultPage .question-body{
            padding:20px;
        }

        #surveyResultPage .result-row{
            margin-bottom:18px;
        }

        #surveyResultPage .result-row:last-child{
            margin-bottom:0;
        }

        #surveyResultPage .result-info{
            display:flex;
            justify-content:space-between;
            align-items:center;
            margin-bottom:8px;
            gap:12px;
        }

        #surveyResultPage .result-label{
            font-size:14px;
            font-weight:600;
            color:#111827;
        }

        #surveyResultPage .result-count{
            font-size:13px;
            color:#6b7280;
            flex-shrink:0;
        }

        #surveyResultPage .progress{
            width:100%;
            height:14px;
            background:#edf1f5;
            border-radius:999px;
            overflow:hidden;
        }

        #surveyResultPage .progress-bar{
            height:100%;
            border-radius:999px;
            background:#2f6b3d;
        }

        #surveyResultPage .essay-box{
            border:1px solid #e5e7eb;
            border-radius:10px;
            padding:14px;
            background:#fafafa;
            margin-bottom:12px;
            font-size:14px;
            line-height:1.6;
            color:#374151;
        }

        @media (max-width:1180px){

            #surveyResultPage .summary-grid{
                grid-template-columns:repeat(2,minmax(0,1fr));
            }
        }

        @media (max-width:720px){

            #surveyResultPage .summary-grid{
                grid-template-columns:1fr;
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

            <div class="office-page"
                 id="surveyResultPage">

                <div class="result-layout">

                    <!-- 상단 -->
                    <div class="panel">

                        <div class="panel-body">

                            <div style="
                                display:flex;
                                justify-content:space-between;
                                align-items:flex-start;
                                gap:16px;
                                flex-wrap:wrap;
                            ">

                                <div>

                                    <h2 id="surveyTitle"
                                        style="
                                            font-size:28px;
                                            font-weight:800;
                                            margin-bottom:10px;
                                        ">
                                        설문 제목
                                    </h2>

                                    <div id="surveyContent"
                                         style="
                                            color:#6b7280;
                                            font-size:14px;
                                            line-height:1.7;
                                         ">
                                        설문 내용
                                    </div>

                                </div>

                                <div style="
                                    display:flex;
                                    gap:8px;
                                    flex-wrap:wrap;
                                ">

                                    <button type="button"
                                            class="btn btn-secondary"
                                            id="backBtn">

                                        목록

                                    </button>

                                </div>

                            </div>

                        </div>

                    </div>

                    <!-- 요약 -->
                    <div class="summary-grid">

                        <div class="summary-card">

                            <div class="summary-label">
                                입주민 수
                            </div>

                            <div class="summary-value"
                                 id="totalResident">

                                0

                            </div>

                        </div>

                        <div class="summary-card">

                            <div class="summary-label">
                                참여 인원
                            </div>

                            <div class="summary-value"
                                 id="participantCount">

                                0

                            </div>

                        </div>

                        <div class="summary-card">

                            <div class="summary-label">
                                진행 상태
                            </div>

                            <div class="summary-value"
                                 id="surveyStatus">

                                진행중

                            </div>

                        </div>

                        <div class="summary-card">

                            <div class="summary-label">
                                응답률
                            </div>

                            <div class="summary-value"
                                 id="answerRate">

                                0%

                            </div>

                        </div>

                    </div>

                    <!-- 결과 -->
                    <div class="panel">

                        <div class="panel-header">

                            <h3 class="panel-title">

                                <span class="material-symbols-rounded">
                                    analytics
                                </span>

                                설문 결과

                            </h3>

                        </div>

                        <div class="panel-body">

                            <div id="resultContainer">

                            </div>

                        </div>

                    </div>

                </div>

            </div>

        </main>

    </div>

</div>

<script>

    const ctx = "${pageContext.request.contextPath}";
    const mgmtOfcNo = "${mgmtOfcNo}";
    const surveyNo = "${surveyNo}";

    function escapeHtml(value){

        return String(value ?? "")
            .replaceAll("&", "&amp;")
            .replaceAll("<", "&lt;")
            .replaceAll(">", "&gt;")
            .replaceAll('"', "&quot;")
            .replaceAll("'", "&#39;");
    }

    function statusText(status){

        if(status === "READY") return "대기중";
        if(status === "OPEN") return "진행중";
        if(status === "CLOSED") return "종료";

        return "-";
    }

    document
        .getElementById("backBtn")
        .addEventListener("click", function () {

            location.href =
                `${ctx}/manager/survey/${mgmtOfcNo}`;
        });

    async function loadResult(){

        try{

            const response = await fetch(
                `${ctx}/manager/survey/${mgmtOfcNo}/result/${surveyNo}/data`
            );

            const data = await response.json();

            console.log(data);

            renderResult(data);

        }catch (e){

            console.error(e);

            document
                .getElementById("resultContainer")
                .innerHTML =
                `
                    <div style="
                        padding:40px;
                        text-align:center;
                        color:#6b7280;
                    ">
                        결과를 불러오지 못했습니다.
                    </div>
                    `;
        }
    }

    function renderResult(data){

        document
            .getElementById("surveyTitle")
            .textContent =
            data.surveyNm || "-";

        document
            .getElementById("surveyContent")
            .textContent =
            data.surveyCn || "-";

        document
            .getElementById("surveyStatus")
            .textContent =
            statusText(data.surveySttsCd);

        document
            .getElementById("totalResident")
            .textContent =
            data.totalResident || 0;

        document
            .getElementById("participantCount")
            .textContent =
            data.participantCount || 0;

        document
            .getElementById("answerRate")
            .textContent =
            (data.answerRate || 0) + "%";

        const container =
            document.getElementById("resultContainer");





        const hasChoice =
            data.resultList && data.resultList.length;

        const hasShort =
            data.shortAnswerList && data.shortAnswerList.length;

        if(!hasChoice && !hasShort){

            container.innerHTML =
                `
    <div style="
        padding:40px;
        text-align:center;
        color:#6b7280;
    ">
        결과 데이터가 없습니다.
    </div>
    `;

            return;
        }





        let html = "";

        const total =
            data.participantCount || 1;

        const questionList =
            data.surveyQitemCn
                ? JSON.parse(data.surveyQitemCn)
                : [];


        if(questionList.length){

            questionList.forEach(function(q, qIdx){

            html +=

                '<div class="question-card" style="margin-bottom:16px;">'

                + '<div class="question-header">'

                + '<div class="question-title">'

                + 'Q' + (qIdx + 1) + '. '
                + escapeHtml(q.question || '-')

                + '</div>'

                + '</div>'

                + '<div class="question-body">';

                const items =
                    Array.isArray(q.items)
                        ? q.items
                        : Array.isArray(q.options)
                            ? q.options
                            : [];

                if(q.type === "SHORT" || q.type === "LONG"){

                    const textAnswers = [];

                    (data.shortAnswerList || []).forEach(function(answer){

                        try{

                            const parsed =
                                JSON.parse(answer.rspnsCn);

                            const matched =
                                parsed.find(function(r){

                                    return Number(r.questionNo) === (qIdx + 1);
                                });

                            if(!matched || !matched.answer) return;

                            textAnswers.push({
                                userNm: answer.userNm,
                                answer: matched.answer,
                                count: 1
                            });

                        }catch(e){

                            console.warn("Failed to parse short answer", e);
                        }
                    });

                    if(!textAnswers.length){

                        (data.resultList || [])
                            .filter(function(row){

                                return row.qitemNm === q.question
                                    || row.qitemNm === ("Q" + (qIdx + 1));
                            })
                            .forEach(function(row){

                                textAnswers.push({
                                    answer: row.ansrCn,
                                    count: row.ansrCnt || 1
                                });
                            });
                    }

                    html +=
                        '<div style="margin-bottom:16px;text-align:right;">'
                        + '<span style="background:#eef6ef;color:#2f6b3d;padding:6px 12px;border-radius:999px;font-size:13px;font-weight:700;">'
                        + '답변 ' + textAnswers.length + '명'
                        + '</span>'
                        + '</div>';

                    if(!textAnswers.length){

                        html +=
                            '<div style="padding:24px;text-align:center;color:#6b7280;">'
                            + '등록된 답변이 없습니다.'
                            + '</div>';
                    }

                    textAnswers.forEach(function(answer){

                        html +=
                            '<div class="essay-box">'
                            + (answer.userNm
                                ? '<div style="font-weight:700;color:#2f6b3d;margin-bottom:8px;">'
                                    + escapeHtml(answer.userNm)
                                    + '</div>'
                                : '')
                            + '<div>'
                            + escapeHtml(answer.answer)
                            + '</div>'
                            + '</div>';
                    });

                }else{

                    const questionMax =
                        Math.max(
                            0,
                            ...items.map(function(item){

                                const found =
                                    (data.resultList || []).find(r => r.ansrCn === item);

                                return found ? found.ansrCnt : 0;
                            })
                        );

                    items.forEach(function(item){

                        const found =
                            (data.resultList || []).find(r => r.ansrCn === item);

                        const count =
                            found ? found.ansrCnt : 0;

                        const percent =
                            Math.round((count / total) * 100);

                        html +=

                            '<div class="result-row">'

                            + '<div class="result-info">'

                            + '<div class="result-label">'

                            + (count === questionMax && count > 0 ? '최다 ' : '')

                            + escapeHtml(item)

                            + '</div>'

                            + '<div class="result-count">'

                            + percent
                            + '% ('
                            + count
                            + '명)'

                            + '</div>'

                            + '</div>'

                            + '<div class="progress">'

                            + '<div class="progress-bar" '
                            + 'style="width:'
                            + percent
                            + '%">'
                            + '</div>'

                            + '</div>'

                            + '</div>';
                    });
                }




            html +=
                '</div>'
                + '</div>';
        });



    }
        container.innerHTML = html;

    }

    loadResult();

</script>


</body>
</html>
