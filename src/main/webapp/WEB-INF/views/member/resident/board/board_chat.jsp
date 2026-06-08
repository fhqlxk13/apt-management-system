<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta name="_csrf" content="${_csrf.token}">
    <meta name="_csrf_header" content="${_csrf.headerName}">
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>그룹채팅방 – 대덕아파트</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/headerStyle.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebarStyle.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footerStyle.css">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/apt/apt.css">

    <style>

        .page-desc-wrap{
            margin-bottom:18px;
        }

        .chat-layout{
            grid-template-columns:300px minmax(0, 1fr) 300px;
            gap:20px;
            align-items:stretch;
        }

        .chat-list,
        .chat-box,
        .open-chat-list{
            height:600px;
            min-height:600px;
            overflow:hidden;

            background:#fff;
            border:1px solid #e5e7eb;
            border-radius:16px;
        }

        .chat-list,
        .open-chat-list{
            overflow-y:auto;
            padding:14px;

            display:flex;
            flex-direction:column;
        }

        .chat-box{
            padding:14px;

            display:flex;
            flex-direction:column;
        }

        .chat-room-item{
            position:relative;

            height:102px;
            padding:13px 15px;
            margin-bottom:12px;

            border:1px solid #e4e9e4;
            border-radius:16px;

            background:linear-gradient(
                    180deg,
                    #ffffff 0%,
                    #fbfcfb 100%
            );

            box-shadow:0 2px 10px rgba(0,0,0,0.03);

            overflow:hidden;

            transition:
                    transform .18s ease,
                    box-shadow .18s ease,
                    border-color .18s ease,
                    background .18s ease;
        }

        .chat-room-item:hover{
            transform:translateY(-2px);

            border-color:#bfd8c7;

            background:linear-gradient(
                    180deg,
                    #ffffff 0%,
                    #f6fbf7 100%
            );

            box-shadow:0 8px 22px rgba(43,103,78,0.10);
        }

        .chat-room-item.active{
            border-color:#2b674e;

            background:linear-gradient(
                    180deg,
                    #f7fcf8 0%,
                    #eef7f1 100%
            );

            box-shadow:0 10px 24px rgba(43,103,78,0.14);
        }

        .room-top{
            display:flex;
            align-items:flex-start;
            justify-content:space-between;
            gap:12px;

            margin-bottom:8px;
        }

        .room-title{
            flex:1;

            overflow:hidden;
            text-overflow:ellipsis;
            white-space:nowrap;

            font-size:18px;
            font-weight:700;
            color:#111827;
        }

        .room-member{
            flex-shrink:0;

            padding:5px 10px;

            border:1px solid #d7e3db;
            border-radius:999px;

            background:#f7faf8;

            font-size:12px;
            font-weight:600;
            color:#2b674e;
        }

        .room-meta{
            display:flex;
            flex-direction:column;
            gap:4px;
        }

        .room-desc,
        .room-last-msg{
            overflow:hidden;
            text-overflow:ellipsis;
            white-space:nowrap;

            font-size:13px;
            line-height:1.45;
        }

        .room-desc{
            color:#6b7280;
        }

        .room-last-msg{
            color:#374151;
            font-weight:500;
        }

        .room-unread{
            position:absolute;
            top:12px;
            right:12px;

            min-width:22px;
            height:22px;
            padding:0 6px;

            display:flex;
            align-items:center;
            justify-content:center;

            border-radius:999px;

            background:#ef4444;
            color:#fff;

            font-size:11px;
            font-weight:700;

            box-shadow:0 4px 10px rgba(239,68,68,0.25);
        }

        .room-box{
            margin-bottom:10px;
            cursor:pointer;

            transition:.2s;
        }

        .room-box:hover{
            background:#f8faf8;
        }

        .message-stream{
            flex:1;
            min-height:0;
            overflow-y:auto;

            padding:12px;

            display:flex;
            flex-direction:column;
            gap:2px !important;
        }

        .message-wrap{
            display:flex;
            flex-direction:column;

            margin-bottom:10px;
        }

        .message-wrap.me{
            align-items:flex-end;
        }

        .message-wrap.other{
            align-items:flex-start;
        }

        .message-inline{
            display:inline-flex;
            align-items:flex-end;
            gap:6px;

            max-width:75%;
        }
        .message-wrap.me .message-inline{
            justify-content:flex-end;
        }

        .message-wrap.other .message-inline{
            justify-content:flex-start;
        }

        .message-time{
            font-size:10px;
            color:#999;
            white-space:nowrap;

            margin-bottom:2px;
        }

        .sender-name{
            margin-bottom:2px;
            padding-left:4px;

            font-size:13px;
            font-weight:600;

            color:#374151;
        }

        .system-message{
            margin:12px 0;

            text-align:center;

            font-size:12px;
            color:#888;
        }

        .search-row{
            width:100%;
            margin-top:12px;

            display:flex;
            align-items:center;
            gap:10px;
        }

        .search-row button{
            flex-shrink:0;

            height:44px;
            padding:0 18px;

            border:none;
            border-radius:10px;

            background:#2b674e;
            color:#fff;

            font-weight:600;
            cursor:pointer;
        }

        .search-row .fake-input{
            flex:1;
            min-width:0;
            max-width:none;
        }

        .modal-btn{
            min-width:78px !important;
            padding:8px 14px !important;
            font-size:12px !important;
            border-radius:8px !important;
        }

        .leave-btn{
            height:38px;
            padding:0 16px;

            display:flex;
            align-items:center;
            justify-content:center;

            border:none;
            border-radius:12px;

            background:linear-gradient(
                    180deg,
                    #ff6b6b 0%,
                    #ef4444 100%
            );

            color:#fff !important;

            font-size:13px;
            font-weight:600;

            cursor:pointer;

            transition:
                    transform .15s ease,
                    box-shadow .15s ease;

            box-shadow:0 6px 16px rgba(239,68,68,0.22);
        }

        .leave-btn:hover{
            transform:translateY(-1px);

            box-shadow:0 10px 22px rgba(239,68,68,0.28);
        }

        .leave-btn:active{
            transform:scale(.97);
        }

        /* 채팅 레이아웃 전용 반응형 */
        .chat-layout{
            display:grid;
            grid-template-columns:
        minmax(260px, 300px)
        minmax(480px, 1fr)
        minmax(260px, 300px);

            gap:20px;
            align-items:stretch;
            min-width:0;
        }

        .chat-list,
        .chat-box,
        .open-chat-list{
            min-width:0;
        }

        /* 1400 이하 */
        @media (max-width: 1400px){

            .chat-layout{
                grid-template-columns:
            260px
            minmax(0, 1fr)
            260px;
            }
        }

        /* 1100 이하 */
        @media (max-width: 1100px){

            .chat-layout{
                grid-template-columns:
            240px
            minmax(0, 1fr);
            }

            .open-chat-list{
                grid-column:1 / -1;
                height:320px;
                min-height:320px;
            }
        }

        /* 태블릿 */
        @media (max-width: 768px){

            .chat-layout{
                grid-template-columns:1fr;
            }

            .chat-list,
            .chat-box,
            .open-chat-list{
                height:auto;
                min-height:unset;
            }

            .message{
                max-width:88%;
            }
        }

        .room-menu-wrap{
            position:relative;
        }

        .room-menu-btn{
            width:38px;
            height:38px;

            border:none;
            border-radius:12px;

            background:transparent;

            display:flex;
            align-items:center;
            justify-content:center;

            color:#6b7280;

            font-size:24px;
            line-height:1;

            cursor:pointer;

            transition:.15s ease;
        }

        .room-menu-btn:hover{
            background:#f3f4f6;
            color:#111827;
        }

        .room-menu-dropdown{
            position:absolute;
            top:48px;
            right:0;

            width:180px;

            display:none;
            flex-direction:column;

            background:#fff;

            border:1px solid #e5e7eb;
            border-radius:14px;

            box-shadow:0 10px 30px rgba(0,0,0,0.12);

            overflow:hidden;

            z-index:30;
        }

        .room-menu-dropdown.show{
            display:flex;
        }

        .room-menu-dropdown button{
            height:46px;

            border:none;
            background:#fff;

            text-align:left;

            padding:0 16px;

            font-size:14px;
            cursor:pointer;

            transition:.15s ease;
        }

        .room-menu-dropdown button:hover{
            background:#f9fafb;
        }
        .room-menu-dropdown .danger{
            color:#dc2626;
            background:#fef2f2;
        }

        .room-menu-dropdown .danger:hover{
            background:#fee2e2;
        }

        .msg-input-wrap{
            position:relative;
            flex:1;
        }

        .msg-input-wrap .fake-input{
            padding-right:64px !important;
        }

        .msg-length{
            position:absolute;

            top:50%;
            right:14px;

            transform:translateY(-50%);

            font-size:11px;
            font-weight:500;
            color:#9ca3af;

            pointer-events:none;
        }

        .message{
            display:inline-block;

            max-width:min(520px, 70vw);

            padding:10px 14px;

            border-radius:16px;

            font-size:13px;
            line-height:1.45;

            white-space:pre-wrap;

            word-break:break-word;
            overflow-wrap:anywhere;

            box-sizing:border-box;
        }

        .message.me{
            background:#2b674e;
            color:#fff;

            border-bottom-right-radius:6px;
        }

        .message.other{
            background:#f3f4f6;
            color:#111827;

            border-bottom-left-radius:6px;
        }
    </style>

</head>
<body>
<%@ include file="/WEB-INF/views/include/apt_headerLayout.jsp" %>
<div class="main-shell">
    <%@ include file="/WEB-INF/views/include/apt_sidebarLayout.jsp" %>
    <main class="content-area">
        <div class="page-content-wrap">

            <div class="breadcrumb">
                <a href="${pageContext.request.contextPath}/">HOME</a>
                <span>›</span>
                <a href="javascript:void(0);">입주민게시판</a>
                <span>›</span>
                <span class="cur">그룹채팅방</span>
            </div>

            <h1 class="page-title">그룹채팅방</h1>

            <div class="page-desc-wrap">
                <p class="page-desc">
                    채팅방 목록 검색, 실시간 채팅을 지원합니다.
                </p>

            </div>

            <section class="chat-layout">

                <div class="chat-list">
                    <%-- 내 채팅방 --%>
                </div>

                <div class="chat-box" id="chat-content">

                    <div style="
                        height:100%;
                        display:flex;
                        align-items:center;
                        justify-content:center;
                        color:#999;
                        font-size:14px;
                    ">
                        채팅방을 선택해주세요.
                    </div>

                </div>

                <div class="open-chat-list" id="open-chat-list">
                    <%-- 오픈채팅 목록 --%>
                </div>

            </section>

        </div>
    </main>
</div>

<div id="create-room-modal"
     onclick="outsideClose(event)"
     style="display:none;
            position:fixed;
            inset:0;
            background:rgba(0,0,0,0.45);
            z-index:9999;
            align-items:center;
            justify-content:center;">

    <div style="width:420px;
                background:white;
                border-radius:16px;
                padding:24px;
                box-shadow:0 10px 30px rgba(0,0,0,0.18);">

        <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:18px;">
            <h3 style="margin:0;">채팅방 만들기</h3>

            <button onclick="closeCreateRoomModal()"
                    style="border:none;background:none;font-size:20px;cursor:pointer;">
                ×
            </button>
        </div>

        <div style="margin-bottom:14px;">
            <label style="display:block;margin-bottom:8px;font-size:13px;">
                채팅방 이름
            </label>

            <input type="text"
                   id="create-room-name"
                   maxlength="40"
                   class="fake-input"
                   placeholder="채팅방 이름 입력">
        </div>
        <div style="margin-bottom:14px;">

            <label style="display:block;margin-bottom:8px;font-size:13px;">
                채팅방 소개
            </label>

            <textarea
                    id="create-room-desc"
                    class="fake-textarea"
                    maxlength="200"
                    rows="4"
                    placeholder="채팅방 소개 입력"></textarea>

        </div>

        <div style="margin-bottom:18px;">

            <label style="display:block;margin-bottom:8px;font-size:13px;">
                채팅방 타입
            </label>

            <div style="display:flex;gap:18px;">

                <label style="display:flex;align-items:center;gap:6px;">
                    <input type="radio"
                           name="room-type"
                           value="NORMAL"
                           checked>
                    일반 채팅방
                </label>

                <label style="display:flex;align-items:center;gap:6px;">
                    <input type="radio"
                           name="room-type"
                           value="OPEN">
                    오픈 채팅방
                </label>

            </div>
        </div>

        <div style="display:flex;justify-content:flex-end;gap:10px;">

            <button onclick="submitCreateRoom()"
                    class="btn-main modal-btn">
                생성
            </button>

            <button onclick="closeCreateRoomModal()"
                    class="btn-ghost modal-btn">
                취소
            </button>

        </div>
    </div>
</div>
<div id="invite-code-modal"
     onclick="closeInviteOutside(event)"
     style="
        display:none;
        position:fixed;
        inset:0;
        background:rgba(0,0,0,0.45);
        z-index:9999;
        align-items:center;
        justify-content:center;
     ">

    <div style="
        width:420px;
        background:#fff;
        border-radius:16px;
        padding:24px;
        box-shadow:0 10px 30px rgba(0,0,0,0.18);
    ">

        <div style="
            display:flex;
            justify-content:space-between;
            align-items:center;
            margin-bottom:18px;
        ">

            <h3 style="margin:0;">초대코드</h3>

            <button
                    onclick="closeInviteCodeModal()"
                    style="
                    border:none;
                    background:none;
                    font-size:20px;
                    cursor:pointer;
                ">
                ×
            </button>
        </div>

        <div style="
            padding:18px;
            border-radius:14px;
            background:#f9fafb;
            text-align:center;
        ">

            <div style="
                margin-bottom:10px;
                font-size:13px;
                color:#666;
            ">
                아래 코드를 공유해 초대할 수 있습니다.
            </div>

            <div id="invite-code-text"
                 style="
                    font-size:22px;
                    font-weight:700;
                    letter-spacing:1px;
                    color:#2b674e;
                 ">
            </div>
        </div>
    </div>
</div>
<div id="join-code-modal"
     onclick="closeJoinCodeOutside(event)"
     style="
    display:none;
    position:fixed;
    inset:0;
    background:rgba(0,0,0,0.45);
    z-index:9999;
    align-items:center;
    justify-content:center;
 ">

    <div style="
    width:420px;
    background:#fff;
    border-radius:16px;
    padding:24px;
    box-shadow:0 10px 30px rgba(0,0,0,0.18);
">

        <div style="
        display:flex;
        justify-content:space-between;
        align-items:center;
        margin-bottom:18px;
    ">

            <h3 style="margin:0;">초대코드로 입장</h3>

            <button
                    onclick="closeJoinCodeModal()"
                    style="
                border:none;
                background:none;
                font-size:20px;
                cursor:pointer;
            ">
                ×
            </button>
        </div>

        <div style="margin-bottom:16px;">

            <input
                    id="join-code-input"
                    class="fake-input"
                    placeholder="초대코드를 입력하세요"
                    onkeydown="handleJoinCodeEnter(event)"
            >
        </div>

        <div style="
        display:flex;
        justify-content:flex-end;
        gap:10px;
    ">

            <button
                    onclick="joinByCode()"
                    class="btn-main modal-btn">
                입장하기
            </button>

            <button
                    onclick="closeJoinCodeModal()"
                    class="btn-ghost modal-btn">
                취소
            </button>

        </div>

    </div>
</div>
<%@ include file="/WEB-INF/views/include/apt_footerLayout.jsp" %>
</body>

<script>
    const userNo = '${userNo}';
    const contextPath = '${pageContext.request.contextPath}';
    const aptCmplexNo = '${aptCmplexNo}';
</script>
<script src="${pageContext.request.contextPath}/js/member/resident/residentBoardChat.js"></script>

</html>