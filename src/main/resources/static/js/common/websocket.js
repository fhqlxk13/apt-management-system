let stomp = null;
let notificationSubscription = null;

function connectWebSocket() {

    if (stomp && stomp.connected) {
        console.log("이미 연결됨");
        return;
    }

    const contextPath = document.body.dataset.contextPath || "";
    const socket = new SockJS(contextPath + '/ws');

    stomp = Stomp.over(socket);
    stomp.debug = null;

    stomp.connect(
        {},
        () => {

            console.log("웹소켓 연결됨");

            if (typeof roomSubscriptions !== 'undefined') {
                roomSubscriptions = {};
            }

            subscribeNotification();

            if (typeof loadMyRooms === 'function') {
                loadMyRooms();
            }
        },
        (error) => {
            console.error("웹소켓 연결 실패", error);

            setTimeout(() => {
                connectWebSocket();
            }, 3000);
        }
    );
}

function subscribeNotification() {

    const userNo = getUserNo();

    if (!userNo) {
        console.warn("userNo 없음 → 알림 구독 안함");
        return;
    }

    if (notificationSubscription) {
        notificationSubscription.unsubscribe();
    }

    notificationSubscription =
        stomp.subscribe('/sub/notification/' + userNo, (msg) => {
            const data = JSON.parse(msg.body);

            console.log("알림:", data);
            showToast({
                title: data.title || "알림",
                message: data.message,
                type: data.type || "info",
                onClick: () => {

                    if (data.url === "/forceLogout") {

                        Swal.fire({
                            icon: "success",
                            title: "입주신청 승인",
                            text: "입주 신청서가 승인되었습니다. 다시 로그인해주세요.",
                            confirmButtonText: "확인"
                        }).then(() => {

                            document.getElementById("logoutForm").submit();

                        });

                        return;
                    }

                    if (data.url) {
                        location.href = data.url;
                    }
                }
            });
        });
}

function getUserNo() {
    return document.body.dataset.userNo;
}
