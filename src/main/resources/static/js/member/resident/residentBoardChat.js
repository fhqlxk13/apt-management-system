document.addEventListener("DOMContentLoaded", function () {
    loadMyRooms();
    openDiscover();
});

let roomSubscriptions = {};
let currentRoomNo = null;
let currentJoinKey = null;

/* 내 채팅방 목록에서 눌렀을때 실행됨 */
function openMyRoom(roomNo, roomNm, joinKey, el) {
    currentJoinKey = joinKey;
    currentRoomNo = roomNo;

    if (el) setActiveRoom(el);


    //새 채팅방 구독


    // 기존 메시지 로딩
    fetch(contextPath + '/residentChat/messages/' + aptCmplexNo + '?chatRoomNo=' + roomNo)
        .then(res => res.json())
        .then(list => {

            let html = `
                <div class="section-hd">
                    <h3>${roomNm}</h3>
                                        
                    <div class="room-menu-wrap">
                    
                        <button
                            class="room-menu-btn"
                            onclick="toggleRoomMenu(event)">
                            ⋮
                        </button>
                    
                        <div class="room-menu-dropdown" id="room-menu-dropdown">
                    
                            <button onclick="openInviteCodeModal()">
                                초대코드 보기
                            </button>
                    
                            <button
                                class="danger"
                                onclick="leaveRoom()">
                                방 나가기
                            </button>
                    
                        </div>
                    </div>
                </div>
                <div class="message-stream" id="message-area">
            `;

            list.forEach(msg => {
                html += renderMessage(msg);
            });

            html += `</div>
                        <div class="search-row">
                    
                            <div class="msg-input-wrap">
                    
                                <textarea
                                    id="msg"
                                    maxlength="300"
                                    class="fake-textarea chat-textarea"
                                    rows="1"
                                    onkeydown="handleEnter(event)"
                                    placeholder="메시지를 입력하세요"
                                ></textarea>
                    
                                <div class="msg-length" id="msg-length">
                                    0 / 300
                                </div>
                    
                            </div>
                    
                            <button onclick="sendMessage()">전송</button>
                    
                        </div>
                    `;

            document.getElementById("chat-content").innerHTML = html;

            const area = document.getElementById("message-area");

            area.scrollTop = area.scrollHeight;

            loadMyRooms();
        });
}


/* 오픈채팅방 리스트를 가져옴*/
function openDiscover() {

    fetch(contextPath + '/residentChat/openRooms/' + aptCmplexNo)
        .then(res => res.json())
        .then(list => {

            let html = `
                <div class="section-hd">
                    <div style="
                        display:flex;
                        align-items:center;
                        justify-content:space-between;
                        gap:10px;
                        width:100%;
                    ">
                        <h3 style="margin:0;">오픈채팅방</h3>
                    
                        <button
                            onclick="openJoinCodeModal()"
                            class="btn-main"
                            style="
                                height:34px;
                                padding:0 14px;
                                border-radius:10px;
                                font-size:12px;
                                font-weight:600;
                            ">
                            초대코드로 입장
                        </button>
                    </div>
                </div>

                <div class="search-row">
                    <input
                        class="fake-input"
                        placeholder="채팅방 검색"
                        oninput="filterElements('#open-chat-list .chat-room-item', this.value)"
                    />
                </div>
            `;

            if(list.length === 0){

                html += `
                    <div style="
                        flex:1;
                        display:flex;
                        align-items:center;
                        justify-content:center;
                        color:#999;
                        font-size:13px;
                        min-height:180px;
                    ">
                        참여 가능한 오픈채팅방이 없습니다.
                    </div>
                `;
            }

            list.forEach(room => {

                html += `
                    <div class="chat-room-item
                         data-room-no="${room.chatRoomNo}"
                         onclick="enterRoom('${room.chatRoomNo}')">

                        <div class="room-top">

                            <div class="room-title">
                                ${room.chatRoomNm}
                            </div>

                            <div class="room-member">
                                참여자 ${room.memberCnt}명
                            </div>

                        </div>

                        <div class="room-meta">

                            <div class="room-desc">
                                ${room.chatRoomDesc ?? '채팅방 소개가 없습니다.'}
                            </div>

                            <div class="room-last-msg">
                                참여하려면 클릭하세요
                            </div>

                        </div>

                    </div>
                `;
            });

            document.getElementById("open-chat-list").innerHTML = html;
        });
}

function enterRoom(roomNo) {

    Swal.fire({
        title: '채팅방 입장',
        text: '채팅방에 입장하시겠습니까?',
        icon: 'question',
        showCancelButton: true,
        confirmButtonText: '입장',
        cancelButtonText: '취소',
        reverseButtons: false
    }).then((result) => {

        if (!result.isConfirmed) {
            return;
        }

        fetch(
            contextPath +
            '/residentChat/enter/' +
            aptCmplexNo +
            '?chatRoomNo=' +
            roomNo,
            {
                method: 'POST',
                headers: {
                    ...csrfHeaders()
                }
            }
        )
            .then(res => res.json())
            .then(room => {

                Swal.fire({
                    title: '입장 완료',
                    text: '채팅방에 입장했습니다.',
                    icon: 'success',
                    timer: 1200,
                    showConfirmButton: false
                });

                loadMyRooms();

                openDiscover();

                openMyRoom(
                    room.chatRoomNo,
                    room.chatRoomNm,
                    room.chatJoinKey,
                    null
                );
            })
            .catch(() => {
                Swal.fire({
                    title: '오류',
                    text: '채팅방 입장 중 오류가 발생했습니다.',
                    icon: 'error'
                });
            });
    });
}
function setActiveRoom(el) {
    document.querySelectorAll(".chat-room-item").forEach(item => {
        item.classList.remove("active");
    });
    el.classList.add("active");
}

function loadMyRooms() {
    fetch(contextPath + '/residentChat/myRooms/' +aptCmplexNo)
        .then(res => res.json())
        .then(list => {

            let html = `
                <div class="section-hd">
                  <h3>내 채팅방 목록</h3>
                  <button onclick="openCreateRoom()" 
                          style="background:#2b674e;color:white;border:none;border-radius:6px;padding:4px 10px;cursor:pointer;">
                    +
                  </button>
                </div>
                <div class="search-row">
                <input class="fake-input" placeholder="검색" oninput="filterElements('.chat-room-item', this.value)"/>                </div>
            `;

            list.forEach(room => {

                html += `
                    <div
                        class="chat-room-item ${String(currentRoomNo) === String(room.chatRoomNo) ? 'active' : ''}"
                        data-room-no="${room.chatRoomNo}"
                        onclick="openMyRoom(
                            '${room.chatRoomNo}',
                            '${room.chatRoomNm}',
                            '${room.chatJoinKey}',
                            this
                        )">
            ${
                    room.unreadCnt > 0
                        ? `
                    <div class="room-unread">
                        ${room.unreadCnt}
                    </div>
                  `
                        : ''
                }

            <div class="room-top">

                <div class="room-title">
                    ${room.chatRoomNm}
                </div>

                <div class="room-member">
                    참여자 ${room.memberCnt}명
                </div>

            </div>

            <div class="room-meta">

                <div class="room-desc">
                    ${room.chatRoomDesc ?? '채팅방 소개가 없습니다.'}
                </div>

                <div class="room-last-msg">
                    ${room.lastMsg ?? '대화 내역이 없습니다.'}
                </div>

            </div>

        </div>
    `;
            });

            document.querySelector('.chat-list').innerHTML = html;

            subscribeRoomList(list);
        });

}

function sendMessage() {

    const input = document.getElementById("msg");

    const content = input.value;

    if (content === "") {
        return;
    }

    stomp.send("/pub/chat/send", {}, JSON.stringify({
        chatRoomNo: currentRoomNo,
        msgCn: content,
        msgTyCd: "TEXT"
    }));

    input.value = "";
    input.style.height = '44px';


    const counter =
        document.getElementById('msg-length');

    if(counter){

        counter.innerText = '0/300';
        counter.style.color = '#9ca3af';
    }
}

function openCreateRoom() {

    document.getElementById('create-room-modal').style.display = 'flex';
}

function submitCreateRoom() {

    const roomName =
        document.getElementById('create-room-name').value.trim();

    const roomDesc =
        document.getElementById('create-room-desc').value;

    const roomType =
        document.querySelector(
            'input[name="room-type"]:checked'
        ).value;

    if(roomName.length > 40){
        alert('채팅방 이름은 40자 이하만 가능합니다.');
        return;
    }

    if(roomDesc.length > 200){
        alert('소개글은 200자 이하만 가능합니다.');
        return;
    }

    if (!roomName) {
        alert('채팅방 이름을 입력하세요.');
        return;
    }

    createRoom(roomName, roomType, roomDesc);
}

function createRoom(roomName, roomType, roomDesc) {

    fetch(contextPath + '/residentChat/createRoom/' + aptCmplexNo, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json',
            ...csrfHeaders()
        },

        body: JSON.stringify({
            chatRoomNm: roomName,
            chatRoomTyCd: roomType,
            chatRoomDesc: roomDesc
        })
    })
        .then(res => res.json())
        .then(room => {

            closeCreateRoomModal();

            loadMyRooms();
            openMyRoom(
                room.chatRoomNo,
                room.chatRoomNm,
                room.chatJoinKey
            );
        });
}

function appendMessage(msg) {


    const area = document.getElementById("message-area");

    if (!area) {
        return;
    }

    // 시스템 메시지
    if (msg.senderTy === 'SYSTEM') {

        area.insertAdjacentHTML(
            'beforeend',
            `
                <div class="system-message">
                    ${msg.msgCn}
                </div>
            `
        );

        area.scrollTop = area.scrollHeight;
        updateRoomLastMessage(msg);
        return;
    }

    const isMe =
        String(msg.senderUserNo) === String(userNo);

    const html = `
                            <div class="message-wrap ${isMe ? 'me' : 'other'}">
                            
                                ${!isMe
                                    ? `
                                        <div class="sender-name">
                                            ${msg.senderUserNm}
                                        </div>
                                      `
                                    : ''
                                }
                            
                                <div class="message-inline">
                            
                                    ${isMe
                                    ? `
                                        <div class="message-time">
                                            ${formatMessageTime(msg.regDttm)}
                                        </div>
                                    
                                        <div class="message me">${escapeHtml(msg.msgCn)}</div>
                                      `
                                    : `
                                            <div class="message other">${escapeHtml(msg.msgCn)}</div>
                            
                                            <div class="message-time">
                                                ${formatMessageTime(msg.regDttm)}
                                            </div>
                                          `
                                }
                            
                                </div>
                            
                            </div>
                    `;

    area.insertAdjacentHTML('beforeend', html);

    area.scrollTop = area.scrollHeight;
    updateRoomLastMessage(msg);
}

function renderMessage(msg) {

    // 시스템 메시지
    if (msg.senderTy === 'SYSTEM') {

        return `
            <div class="system-message">
                ${msg.msgCn}
            </div>
        `;
    }

    const isMe =
        String(msg.senderUserNo) === String(userNo);

            return `
                        <div class="message-wrap ${isMe ? 'me' : 'other'}">
                        
                            ${!isMe
                                        ? `
                                    <div class="sender-name">
                                        ${msg.senderUserNm}
                                    </div>
                                  `
                                        : ''
                                    }
                        
                            <div class="message-inline">
                        
                                ${isMe
                                        ? `
                                        <div class="message-time">
                                            ${formatMessageTime(msg.regDttm)}
                                        </div>
                                        
                                        <div class="message me">${escapeHtml(msg.msgCn)}</div> 
                                      `
                                        : `
                                        <div class="message other">${escapeHtml(msg.msgCn)}</div>
                        
                                        <div class="message-time">
                                            ${formatMessageTime(msg.regDttm)}
                                        </div>
                                      `
                                    }
                        
                            </div>
                        
                        </div>
        `;
}

function closeCreateRoomModal() {

    document.getElementById('create-room-modal').style.display = 'none';

    document.getElementById('create-room-name').value = '';

    document.querySelector(
        'input[name="room-type"][value="OPEN"]'
    ).checked = true;
}

function outsideClose(e) {

    if (e.target.id === 'create-room-modal') {
        closeCreateRoomModal();
    }
}

function leaveRoom() {

    if (!currentRoomNo) {
        return;
    }

    if (!confirm('채팅방을 나가시겠습니까?')) {
        return;
    }

    fetch(
        contextPath +
        '/residentChat/leave/' +
        aptCmplexNo +
        '?chatRoomNo=' +
        currentRoomNo,
        {
            method: 'POST',
            headers: {
                ...csrfHeaders()
            }
        }
    )
        .then(res => res.text())
        .then(() => {

            currentRoomNo = null;

            // 기본 화면 복귀
            openDiscover();

            document.getElementById("chat-content").innerHTML = `
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
            `;
            // 목록 새로고침
            loadMyRooms();
        });
}
function csrfHeaders() {

    return {
        [document.querySelector('meta[name="_csrf_header"]').content]:
        document.querySelector('meta[name="_csrf"]').content
    };
}

function filterElements(selector, keyword) {

    keyword = keyword.toLowerCase().trim();

    document.querySelectorAll(selector)
        .forEach(el => {

            const title =
                el.querySelector('.room-title')?.innerText.toLowerCase() ?? '';

            const desc =
                el.querySelector('.room-desc')?.innerText.toLowerCase() ?? '';

            const targetText = `${title} ${desc}`;

            el.style.display =
                targetText.includes(keyword)
                    ? ""
                    : "none";
        });
}

function handleEnter(e) {

    if(e.key !== 'Enter'){
        return;
    }

    // Shift + Enter → 줄바꿈
    if(e.shiftKey){
        return;
    }

    // Enter → 전송
    e.preventDefault();

    sendMessage();
}
function formatMessageTime(regDttm) {

    if (!regDttm) {
        return '';
    }

    // "2026-05-07 14:21:33" -> "2026-05-07T14:21:33"
    const normalized =
        String(regDttm).replace(' ', 'T');

    const date = new Date(normalized);

    // 파싱 실패 방지
    if (isNaN(date.getTime())) {
        return '';
    }

    const now = new Date();

    const isToday =
        date.getFullYear() === now.getFullYear()
        && date.getMonth() === now.getMonth()
        && date.getDate() === now.getDate();

    if (isToday) {

        return date.toLocaleTimeString('ko-KR', {
            hour: '2-digit',
            minute: '2-digit',
            hour12: true
        });
    }

    return `${date.getMonth() + 1}월 ${date.getDate()}일`;
}

function updateRoomLastMessage(msg) {

    const roomEl = document.querySelector(
        `.chat-room-item[data-room-no="${msg.chatRoomNo}"]`
    );

    if (!roomEl) {
        return;
    }

    const lastMsgEl =
        roomEl.querySelector('.room-last-msg');

    if (lastMsgEl) {

        lastMsgEl.innerText =
            msg.senderTy === 'SYSTEM'
                ? '[알림] ' + msg.msgCn
                : msg.msgCn;
    }
}

function subscribeRoomList(roomList) {

    if (!stomp || !stomp.connected) {
        return;
    }

    roomList.forEach(room => {

        const roomNo = room.chatRoomNo;

        // 이미 구독중이면 skip
        if (roomSubscriptions[roomNo]) {
            return;
        }

        roomSubscriptions[roomNo] =
            stomp.subscribe(
                '/sub/chat/room/' + roomNo,
                function(msg) {

                    console.log(
                        "currentRoomNo =",
                        currentRoomNo,
                        "roomNo =",
                        roomNo
                    );

                    const data = JSON.parse(msg.body);

                    // 현재 보고 있는 방
                    if (String(currentRoomNo) === String(roomNo)) {

                        appendMessage(data);

                        fetch(
                            contextPath +
                            '/residentChat/read/' +
                            aptCmplexNo +
                            '?chatRoomNo=' +
                            roomNo,
                            {
                                method: 'POST',
                                headers: {
                                    ...csrfHeaders()
                                }
                            }
                        ).then(() => {

                            loadMyRooms();

                        });

                    } else {

                        // 방 목록 마지막 메시지 갱신
                        updateRoomLastMessage(data);

                        // unread 갱신
                        loadMyRooms();
                    }
                }
            );

        console.log("방 구독:", roomNo);
    });
}

function toggleRoomMenu(e){

    e.stopPropagation();

    document
        .getElementById('room-menu-dropdown')
        .classList.toggle('show');
}

document.addEventListener('click', () => {

    document
        .getElementById('room-menu-dropdown')
        ?.classList.remove('show');
});

function openInviteCodeModal(){

    document
        .getElementById('room-menu-dropdown')
        ?.classList.remove('show');

    document
        .getElementById('invite-code-modal')
        .style.display = 'flex';

    document
        .getElementById('invite-code-text')
        .innerText = currentJoinKey;
}

function closeInviteCodeModal(){

    document
        .getElementById('invite-code-modal')
        .style.display = 'none';
}

function closeInviteOutside(e){

    if(e.target.id === 'invite-code-modal'){

        closeInviteCodeModal();
    }
}
function openJoinCodeModal(){

    document
        .getElementById('join-code-modal')
        .style.display = 'flex';

    document
        .getElementById('join-code-input')
        .focus();
}

function closeJoinCodeModal(){

    document
        .getElementById('join-code-modal')
        .style.display = 'none';

    document
        .getElementById('join-code-input')
        .value = '';
}

function closeJoinCodeOutside(e){

    if(e.target.id === 'join-code-modal'){

        closeJoinCodeModal();
    }
}

function handleJoinCodeEnter(e){

    if(e.key === 'Enter'){

        e.preventDefault();

        joinByCode();
    }
}

function joinByCode(){

    const joinKey =
        document
            .getElementById('join-code-input')
            .value
            .trim();

    if(!joinKey){

        alert('초대코드를 입력하세요.');
        return;
    }

    fetch(
        contextPath +
        '/residentChat/joinByCode/' +
        aptCmplexNo +
        '?joinKey=' +
        encodeURIComponent(joinKey),
        {
            method:'POST',
            headers:{
                ...csrfHeaders()
            }
        }
    )
        .then(res => {

            if(!res.ok){

                throw new Error();
            }

            return res.json();
        })
        .then(room => {

            closeJoinCodeModal();

            loadMyRooms();

            openDiscover();

            setTimeout(() => {

                const el = document.querySelector(
                    '.chat-room-item[data-room-no="' +
                    room.chatRoomNo +
                    '"]'
                );

                openMyRoom(
                    room.chatRoomNo,
                    room.chatRoomNm,
                    room.chatJoinKey,
                    el
                );

            }, 50);
        })
        .catch(() => {

            alert('유효하지 않은 초대코드입니다.');
        });
}

document.addEventListener('input', e => {

    if(e.target.id === 'msg'){

        e.target.style.height = 'auto';

        e.target.style.height =
            Math.min(e.target.scrollHeight, 140) + 'px';

        if(e.target.value.length > 300){

            e.target.value =
                e.target.value.substring(0, 300);
        }

        const length = e.target.value.length;

        const counter =
            document.getElementById('msg-length');

        if(counter){

            counter.innerText =
                `${length}/300`;

            if(length > 250){

                counter.style.color = '#ef4444';

            }else{

                counter.style.color = '#9ca3af';
            }
        }
    }
});

function escapeHtml(str){

    if(str == null){
        return '';
    }

    return String(str)
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;')
        .replace(/'/g, '&#039;');
}