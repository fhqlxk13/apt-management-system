<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <sec:csrfMetaTags/>
    <title>방송 안내 관리</title>
    <link rel="preconnect" href="https://fonts.googleapis.com"/>
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin/>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/office-layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/manager-common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common/toast.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/broadcast/mngr-broadcast.css">
</head>
<body>
<div class="app-wrapper">
    <%@ include file="/WEB-INF/views/include/office_sidebar.jsp" %>
    <div class="main-wrap">
        <%@ include file="/WEB-INF/views/include/office_header.jsp" %>
        <main class="main-content main-content--broadcast">
            <c:set var="complexNm" value="${not empty aptCmplexNm ? aptCmplexNm : (not empty office.aptCmplexNm ? office.aptCmplexNm : '본 단지')}"/>
            <c:set var="broadcastIntro" value="안녕하세요. ${complexNm} 관리사무소입니다."/>
            <div class="office-page" id="broadcastPage" data-broadcast-intro="${fn:escapeXml(broadcastIntro)}">
                <div class="bc-wrap">
                    <div class="page-title">
                        <h2>방송 안내 관리</h2>
                        <p>${complexNm} · 업무 이력에서 초안을 불러와 음성으로 변환합니다.</p>
                    </div>

                    <div class="bc-layout">
                        <%-- 좌: 작성 + 플레이어 --%>
                        <div class="bc-main">
                            <section class="card card-compose" aria-label="broadcast-compose">
                                <div class="card-header">
                                    <span class="material-symbols-rounded">campaign</span>
                                    방송 안내 작성
                                </div>
                                <div class="card-body compose-body">
                                    <div id="composeLoading" class="compose-loading" hidden aria-live="polite">
                                        <div class="compose-spinner" role="status"></div>
                                        <span>음성을 변환하고 있습니다</span>
                                    </div>

                                    <div class="row row-compact">
                                        <span class="row-label">빠른 문구</span>
                                        <div class="chip-group">
                                            <button type="button" class="chip template-chip"
                                                    data-template="${broadcastIntro}&#10;오늘 오후 2시부터 4시까지 1호기 엘리베이터 정기점검이 있습니다.&#10;이용에 불편을 드려 죄송합니다.&#10;감사합니다.">
                                                <span class="material-symbols-rounded">elevator</span>엘리베이터
                                            </button>
                                            <button type="button" class="chip template-chip"
                                                    data-template="${broadcastIntro}&#10;오늘 오전 10시부터 12시까지 수도 점검으로 잠시 단수가 있습니다.&#10;미리 물을 비축해 주시고, 수도꼭지는 꼭 잠가 주시기 바랍니다.&#10;이용에 불편을 드려 죄송합니다.&#10;감사합니다.">
                                                <span class="material-symbols-rounded">water_drop</span>단수
                                            </button>
                                            <button type="button" class="chip template-chip"
                                                    data-template="${broadcastIntro}&#10;분리수거는 지정된 요일과 시간에 맞춰 배출해 주시면 감사하겠습니다.&#10;깨끗한 우리 아파트, 함께 지켜 주시기 바랍니다.&#10;감사합니다.">
                                                <span class="material-symbols-rounded">recycling</span>분리수거
                                            </button>
                                            <button type="button" class="chip template-chip"
                                                    data-template="${broadcastIntro}&#10;소방 통로와 출입구 주변에 주차된 차량이 있어 안내드립니다.&#10;30분 이내에 차량을 옮겨 주시면 감사하겠습니다.&#10;감사합니다.">
                                                <span class="material-symbols-rounded">local_parking</span>주차
                                            </button>
                                        </div>
                                    </div>

                                    <div class="editor">
                                        <textarea id="ttsText" maxlength="500"
                                                  placeholder="방송할 안내 문구를 입력해주세요."></textarea>

                                        <div class="editor-foot">
                                            <div class="editor-meta" id="editorMeta">
                                                <span>글자 수 <b id="charCount">0</b><span class="char-limit"> / 500</span></span>
                                                <span>예상 <b id="estDuration">0초</b></span>
                                            </div>
                                            <div class="editor-foot-right">
                                                <button type="button" class="btnx btnx-secondary btnx-sm" id="previewBtn"
                                                        aria-label="미리듣기">
                                                    <span class="material-symbols-rounded">hearing</span>미리듣기
                                                </button>
                                                <audio id="previewAudio" class="sr-only" preload="none" aria-hidden="true"></audio>
                                            </div>
                                        </div>

                                        <div class="compose-options">
                                            <div class="compose-options-fields">
                                                <div class="compose-option">
                                                    <span class="compose-option-label">방송 구역</span>
                                                    <div class="area-field">
                                                        <div class="bc-select" id="areaSelect">
                                                            <button type="button" class="bc-select-trigger" id="areaSelectTrigger"
                                                                    aria-expanded="false" aria-haspopup="listbox">
                                                                <span class="bc-select-label" id="areaSelectLabel">전체</span>
                                                                <span class="material-symbols-rounded bc-select-caret">expand_more</span>
                                                            </button>
                                                            <div class="bc-select-panel" id="areaSelectPanel" role="listbox" hidden>
                                                                <label class="bc-select-option">
                                                                    <input type="checkbox" name="areaOpt" value="전체" data-area-all checked>
                                                                    <span>전체</span>
                                                                </label>
                                                                <c:forEach var="dong" items="${dongList}">
                                                                    <c:set var="dongBase"
                                                                           value="${fn:contains(dong.dongNo, '_') ? fn:substringAfter(dong.dongNo, '_') : (empty dong.dongNm ? dong.dongNo : dong.dongNm)}"/>
                                                                    <c:choose>
                                                                        <c:when test="${fn:endsWith(dongBase, '동')}">
                                                                            <c:set var="dongLabel" value="${dongBase}"/>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <c:set var="dongLabel" value="${dongBase}동"/>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                    <label class="bc-select-option">
                                                                        <input type="checkbox" name="areaOpt" value="${dongLabel}" data-dong-no="${dong.dongNo}">
                                                                        <span>${dongLabel}</span>
                                                                    </label>
                                                                </c:forEach>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="compose-option">
                                                    <span class="compose-option-label">음성</span>
                                                    <div class="voice-field">
                                                        <div class="bc-select" id="voiceSelectWrap">
                                                            <button type="button" class="bc-select-trigger" id="voiceSelectTrigger"
                                                                    aria-expanded="false" aria-haspopup="listbox">
                                                                <span class="bc-select-label" id="voiceSelectLabel">남성 A</span>
                                                                <span class="material-symbols-rounded bc-select-caret">expand_more</span>
                                                            </button>
                                                            <div class="bc-select-panel bc-select-panel--voice" id="voiceSelectPanel" role="listbox" hidden>
                                                                <button type="button" class="bc-select-option bc-select-option--single active"
                                                                        role="option" data-voice="ko-KR-Standard-C" aria-selected="true">남성 A</button>
                                                                <button type="button" class="bc-select-option bc-select-option--single"
                                                                        role="option" data-voice="ko-KR-Standard-D" aria-selected="false">남성 B</button>
                                                                <button type="button" class="bc-select-option bc-select-option--single"
                                                                        role="option" data-voice="ko-KR-Standard-A" aria-selected="false">여성 A</button>
                                                                <button type="button" class="bc-select-option bc-select-option--single"
                                                                        role="option" data-voice="ko-KR-Standard-B" aria-selected="false">여성 B</button>
                                                            </div>
                                                            <select class="sr-only" id="voiceSelect" aria-hidden="true">
                                                                <option value="ko-KR-Standard-C" selected>남성 A</option>
                                                                <option value="ko-KR-Standard-D">남성 B</option>
                                                                <option value="ko-KR-Standard-A">여성 A</option>
                                                                <option value="ko-KR-Standard-B">여성 B</option>
                                                            </select>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="compose-options-actions">
                                                <button type="button" class="btnx btnx-ghost" id="clearBtn">
                                                    <span class="material-symbols-rounded">restart_alt</span>초기화
                                                </button>
                                                <button type="button" class="btnx btnx-primary" id="convertBtn">
                                                    <span class="material-symbols-rounded">graphic_eq</span>음성 변환
                                                </button>
                                                <%-- [도커 TTS 미사용] 브라우저 → 8060 직접 호출
                                                <button type="button" class="btnx btnx-secondary" id="convertDockerBtn"
                                                        title="TTS 도커(8060)에 직접 요청">
                                                    <span class="material-symbols-rounded">dns</span>도커 음성 변환
                                                </button>
                                                --%>
                                            </div>
                                            <div class="compose-broadcast-actions" aria-label="방송 송출">
                                                <span class="compose-broadcast-label">방송 송출</span>
                                                <button type="button" class="bc-broadcast-btn" id="broadcastBtn" disabled
                                                        title="WebSocket으로 동별 수신기에 재생 명령 전송">
                                                    <span class="material-symbols-rounded">campaign</span>방송 송출
                                                </button>
                                            </div>
                                            <p class="hint bc-receive-setup-hint">
                                                <strong>방송 송출</strong> 시 선택한 동의
                                                <strong>방송 수신기</strong>에서 재생됩니다.
                                                동별 수신기:
                                                <span class="bc-receive-setup-links">
                                                    <c:forEach var="dong" items="${dongList}" varStatus="st">
                                                        <c:set var="dongBase"
                                                               value="${fn:contains(dong.dongNo, '_') ? fn:substringAfter(dong.dongNo, '_') : (empty dong.dongNm ? dong.dongNo : dong.dongNm)}"/>
                                                        <c:choose>
                                                            <c:when test="${fn:endsWith(dongBase, '동')}">
                                                                <c:set var="dongLabel" value="${dongBase}"/>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <c:set var="dongLabel" value="${dongBase}동"/>
                                                            </c:otherwise>
                                                        </c:choose>
                                                        
                                                        <a href="${pageContext.request.contextPath}/manager/complex/broadcast/receive/${mgmtOfcNo}?dongNo=${dong.dongNo}"
                                                           target="_blank" rel="noopener">${dongLabel}</a><c:if test="${!st.last}"> · </c:if>
                                                    </c:forEach>
                                                </span>
                                            </p>
                                        </div>
                                    </div>
                                </div>
                            </section>

                            <section class="card" id="playerCard" style="display:none;" aria-label="sender-test-playback">
                                <div class="player player-compact">
                                    <div class="eq eq-sm" id="eqBars">
                                        <span></span><span></span><span></span><span></span><span></span><span></span>
                                    </div>
                                    <div class="player-info">
                                        <div class="player-label" id="playerLabel">송출자 테스트 재생</div>
                                        <p class="player-text" id="playerText"></p>
                                        <div class="player-controls">
                                            <div class="player-sq-btns" role="group" aria-label="송출자 테스트 재생">
                                                <button type="button" class="bc-sq-btn" id="playerToggleBtn"
                                                        title="송출 담당자 본인만 이 PC에서 들어보기 (방송 아님)" aria-label="테스트 재생" disabled>
                                                    <span class="material-symbols-rounded" id="playerToggleIcon">play_arrow</span>
                                                </button>
                                                <button type="button" class="bc-sq-btn bc-sq-btn-reset" id="playerResetBtn"
                                                        title="재생 초기화" aria-label="재생 초기화" disabled>
                                                    <span class="bc-stop-mark" aria-hidden="true"></span>
                                                </button>
                                            </div>
                                            <div class="player-audio-meta">
                                                <span class="player-time" id="playerTime">0:00 / --:--</span>
                                                <audio id="playerAudio" preload="metadata"></audio>
                                            </div>
                                            <button type="button" class="player-download" id="playerDownloadBtn" disabled
                                                    title="음성 파일 다운로드" aria-label="음성 파일 다운로드">
                                                <span class="material-symbols-rounded">download</span>
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </section>
                        </div>

                        <%-- 우: 업무 이력 + 변환 이력 --%>
                        <aside class="bc-side">
                            <section class="card card-side" aria-label="broadcast-sources">
                                <div class="card-header card-header-tabs">
                                    <div class="source-tabs" role="tablist">
                                        <button type="button" class="source-tab active" data-source-tab="check" role="tab" aria-selected="true">시설점검</button>
                                        <button type="button" class="source-tab" data-source-tab="complaint" role="tab" aria-selected="false">민원</button>
                                        <button type="button" class="source-tab" data-source-tab="history" role="tab" aria-selected="false">변환이력</button>
                                    </div>
                                </div>
                                <div class="card-body card-body-side">
                                    <p class="source-note" id="sourceNote">점검 건을 클릭하면 좌측에 방송 초안이 채워집니다.</p>

                                    <div class="source-panel active" id="panelCheck" data-panel="check"></div>
                                    <div class="source-panel" id="panelComplaint" data-panel="complaint"></div>
                                    <div class="source-panel" id="panelHistory" data-panel="history">
                                        <div class="history-panel-body">
                                            <div id="historyEmpty" class="source-empty">아직 변환한 방송이 없습니다.</div>
                                            <div class="source-list" id="historyList"></div>
                                        </div>
                                        <div class="history-panel-foot">
                                            <button type="button" class="btnx btnx-ghost btnx-sm" id="clearHistoryBtn">
                                                <span class="material-symbols-rounded">delete_sweep</span>비우기
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </section>
                        </aside>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<div id="toastContainer"></div>

<script>
    window.BC_PAGE = {
        contextPath: '${pageContext.request.contextPath}',
        mgmtOfcNo: '${mgmtOfcNo}'
    };
</script>
<script src="${pageContext.request.contextPath}/js/common/toast.js"></script>
<script src="${pageContext.request.contextPath}/js/manager/broadcast/mngr-broadcast.js"></script>
</body>
</html>
