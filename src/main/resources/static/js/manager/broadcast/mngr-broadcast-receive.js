/**
 * 동별 방송 수신기 — WebSocket 구독 후 TTS 재생
 */
(function () {
    'use strict';

    var cfg = window.BC_RECEIVE;
    if (!cfg || !cfg.mgmtOfcNo || !cfg.dongNo) return;
    if (typeof cfg.dongValid === 'string') {
        cfg.dongValid = cfg.dongValid === 'true';
    }

    var receiveAudio = document.getElementById('receiveAudio');
    var receiveActive = false;
    var receiveObjectUrl = null;
    var broadcastSubscription = null;
    var pendingPlay = null;
    var readyToastShown = false;
    var activePlayPayload = null;
    var ackSentForBroadcastId = null;
    var receiveAudioUnlocked = false;
    var receiveAudioPrimed = false;
    var pendingPlayPayload = null;
    var SILENT_WAV = 'data:audio/wav;base64,UklGRigAAABXQVZFZm10IBIAAAABAAEARKwAAIhYAQACABAAAABkYXRhAgAAAAEA';

    function $(id) { return document.getElementById(id); }

    function topicKey(dongNo) {
        return String(dongNo).replace(/\//g, '_').replace(/\s/g, '_');
    }

    function normalizeDongNo(value) {
        return String(value == null ? '' : value).trim();
    }

    function getSubscribeDest() {
        return '/sub/broadcast/' + cfg.mgmtOfcNo + '/' + topicKey(cfg.dongNo);
    }

    var flashHideTimer = null;

    function getDongName() {
        return cfg.dongLabel || cfg.dongNo;
    }

    /** 수신기 전용 토스트 — bcReceiveToastContainer에 표시 (시연용 크게) */
    function toast(opts) {
        opts = opts || {};
        var container = document.getElementById('bcReceiveToastContainer');
        if (!container) {
            if (typeof showToast === 'function') {
                showToast(opts);
            }
            return;
        }

        var title = opts.title || '알림';
        var message = opts.message || '';
        var type = opts.type || 'info';
        var duration = opts.duration || 5000;
        var hero = !!opts.hero;

        var el = document.createElement('div');
        el.className = 'toast ' + type + (hero ? ' bc-toast-hero' : '');
        el.innerHTML =
            '<button type="button" class="toast-close" aria-label="닫기">×</button>' +
            '<div class="toast-title">' + escapeHtml(title) + '</div>' +
            '<div class="toast-message">' + escapeHtml(message) + '</div>';

        el.querySelector('.toast-close').addEventListener('click', function (e) {
            e.stopPropagation();
            el.classList.add('hide');
            setTimeout(function () { el.remove(); }, 200);
        });

        container.appendChild(el);
        setTimeout(function () {
            if (el.parentNode) {
                el.classList.add('hide');
                setTimeout(function () { el.remove(); }, 200);
            }
        }, duration);
    }

    function escapeHtml(str) {
        return String(str == null ? '' : str)
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/"/g, '&quot;');
    }

    function showReceiveFlash(title, message) {
        var box = $('bcReceiveFlash');
        var titleEl = $('bcReceiveFlashTitle');
        var textEl = $('bcReceiveFlashText');
        if (!box) return;
        if (titleEl) titleEl.textContent = title || '방송중';
        if (textEl) textEl.textContent = message || '';
        box.hidden = false;
        if (flashHideTimer) clearTimeout(flashHideTimer);
    }

    function hideReceiveFlash() {
        var box = $('bcReceiveFlash');
        if (flashHideTimer) {
            clearTimeout(flashHideTimer);
            flashHideTimer = null;
        }
        if (box) box.hidden = true;
    }

    function demoBroadcastAlert(phase) {
        var dong = getDongName();
        if (phase === 'start') {
            showReceiveFlash('방송중', dong + '에서 방송중입니다');
            toast({
                title: '📢 ' + dong + ' 방송중',
                message: '관리사무소 방송이 수신되었습니다. 잠시 후 스피커로 재생됩니다.',
                type: 'warning',
                hero: true,
                duration: 9000
            });
        } else if (phase === 'playing') {
            showReceiveFlash('재생 중', dong + ' 스피커 출력');
            toast({
                title: '▶ 재생 시작',
                message: dong + '에서 안내 방송을 재생합니다.',
                type: 'success',
                hero: true,
                duration: 6000
            });
        } else if (phase === 'done') {
            hideReceiveFlash();
            toast({
                title: '방송 종료',
                message: dong + ' 방송이 종료되었습니다.',
                type: 'info',
                duration: 4000
            });
        }
    }

    function setWsBadge(state, text) {
        var badge = $('wsStatusBadge');
        if (!badge) return;
        badge.textContent = text;
        badge.classList.remove('is-ok', 'is-busy', 'is-error');
        if (state) badge.classList.add(state);
    }

    function setReceiveUi(mode, title, msg) {
        var block = $('receiveStatus');
        var icon = $('receiveStatusIcon');
        if (block) {
            block.classList.toggle('is-playing', mode === 'playing');
        }
        if ($('receiveStatusTitle')) $('receiveStatusTitle').textContent = title;
        if ($('receiveStatusMsg')) $('receiveStatusMsg').textContent = msg;
        if (icon) {
            icon.textContent = mode === 'playing' ? 'campaign' : (mode === 'loading' ? 'hourglass_top' : 'podcasts');
        }
    }

    function buildTtsFetchHeaders(contentType) {
        var headers = { 'X-Requested-With': 'XMLHttpRequest' };
        if (contentType) {
            headers['Content-Type'] = contentType;
        }
        var csrfHeader = document.querySelector('meta[name="_csrf_header"]');
        var csrfToken = document.querySelector('meta[name="_csrf"]');
        if (csrfHeader && csrfToken) {
            headers[csrfHeader.getAttribute('content')] = csrfToken.getAttribute('content');
        }
        return headers;
    }

    function parseTtsAudioFetch(res) {
        var ct = (res.headers.get('content-type') || '').toLowerCase();
        if (!res.ok) {
            var err = new Error('TTS failed: ' + res.status);
            err.status = res.status;
            throw err;
        }
        if (ct.indexOf('audio/') === -1) {
            throw new Error('not audio');
        }
        return res.blob();
    }

    function fetchAndPlayTts(payload) {
        if (!payload || !payload.text) return Promise.reject(new Error('empty payload'));

        setReceiveUi('loading', '음성 준비 중', 'TTS 변환 후 재생합니다…');
        setWsBadge('is-busy', '방송 수신');

        var formBody = new URLSearchParams();
        formBody.set('text', payload.text);
        formBody.set('languageCode', payload.languageCode || 'ko-KR');
        formBody.set('voiceName', payload.voiceName || 'ko-KR-Standard-C');

        return fetch(cfg.contextPath + '/tts/synthesize/' + cfg.mgmtOfcNo, {
            method: 'POST',
            credentials: 'same-origin',
            headers: buildTtsFetchHeaders('application/x-www-form-urlencoded;charset=UTF-8'),
            body: formBody.toString()
        })
            .then(parseTtsAudioFetch)
            .then(function (blob) {
                if (!blob || blob.size < 128) {
                    throw new Error('invalid mp3');
                }
                return playBlob(blob, payload);
            });
    }

    function revokeReceiveUrl() {
        if (receiveObjectUrl) {
            URL.revokeObjectURL(receiveObjectUrl);
            receiveObjectUrl = null;
        }
    }

    function updateAudioUnlockUi() {
        var btn = $('receiveAudioUnlockBtn');
        var hint = $('receiveAudioHint');
        if (btn) {
            if (receiveAudioUnlocked || receiveAudioPrimed) {
                btn.hidden = true;
            } else {
                btn.hidden = false;
            }
            btn.classList.toggle('is-done', receiveAudioUnlocked);
        }
        if (hint) {
            if (receiveAudioUnlocked || receiveAudioPrimed) {
                hint.textContent = '스피커 자동 재생 준비됨. 방송 송출 시 이 탭에서 바로 들립니다.';
            }
        }
    }

    /** 브라우저 자동재생: 음소거 재생으로 허용 받은 뒤 실제 방송은 소리 켠 채 재생 */
    function primeReceiveAudioAutoplay() {
        if (!receiveAudio || receiveAudioPrimed) {
            return Promise.resolve(receiveAudioUnlocked || receiveAudioPrimed);
        }
        receiveAudio.muted = true;
        if (!receiveAudio.src) {
            receiveAudio.src = SILENT_WAV;
        }
        return receiveAudio.play().then(function () {
            receiveAudio.pause();
            try {
                receiveAudio.currentTime = 0;
            } catch (ignore) { /* seek */ }
            receiveAudio.muted = false;
            receiveAudioPrimed = true;
            receiveAudioUnlocked = true;
            updateAudioUnlockUi();
            console.log('[방송 수신] 스피커 자동 재생 준비 OK (muted prime)');
            return drainPendingPlay();
        }).catch(function (err) {
            console.warn('receive audio prime failed', err);
            receiveAudio.muted = false;
            return false;
        });
    }

    function drainPendingPlay() {
        if (!pendingPlayPayload) {
            return Promise.resolve(true);
        }
        var p = pendingPlayPayload;
        pendingPlayPayload = null;
        return fetchAndPlayTts(p);
    }

    function unlockReceiveAudio() {
        if (!receiveAudio) {
            return Promise.resolve(false);
        }
        if (receiveAudioUnlocked) {
            return drainPendingPlay().then(function () { return true; });
        }
        return primeReceiveAudioAutoplay().then(function (primed) {
            if (primed) {
                return true;
            }
            receiveAudio.muted = false;
            return receiveAudio.play().then(function () {
                receiveAudio.pause();
                try {
                    receiveAudio.currentTime = 0;
                } catch (ignore) { /* seek */ }
                receiveAudioUnlocked = true;
                receiveAudioPrimed = true;
                updateAudioUnlockUi();
                return drainPendingPlay();
            }).catch(function (err) {
                console.warn('receive audio unlock failed', err);
                var btn = $('receiveAudioUnlockBtn');
                if (btn) btn.hidden = false;
                toast({
                    title: '스피커 허용 필요',
                    message: '브라우저가 소리를 막았습니다. 「소리가 안 들릴 때만 클릭」 버튼을 한 번 눌러 주세요.',
                    type: 'warning',
                    hero: true,
                    duration: 7000
                });
                return false;
            });
        });
    }

    function playBlob(blob, payload) {
        if (!receiveAudio) return Promise.resolve();

        var dongName = cfg.dongLabel || cfg.dongNo;
        revokeReceiveUrl();
        receiveAudio.pause();
        receiveObjectUrl = URL.createObjectURL(blob);
        receiveAudio.src = receiveObjectUrl;
        receiveAudio.muted = false;
        receiveActive = true;

        var sender = payload.senderUserNm ? payload.senderUserNm + ' · ' : '';
        setReceiveUi('playing', '방송 재생 중', sender + (cfg.dongLabel || cfg.dongNo) + ' 출력');

        var last = $('receiveLastText');
        if (last) {
            last.hidden = false;
            last.textContent = payload.text;
        }

        function startPlayback() {
            receiveAudio.muted = false;
            return receiveAudio.play().then(function () {
                receiveAudioUnlocked = true;
                receiveAudioPrimed = true;
                updateAudioUnlockUi();
                demoBroadcastAlert('playing');
            });
        }

        return startPlayback().catch(function (err) {
            console.warn('receive audio play failed, try muted', err);
            if (err && err.name === 'NotAllowedError') {
                receiveAudio.muted = true;
                return receiveAudio.play().then(function () {
                    receiveAudio.muted = false;
                    receiveAudioUnlocked = true;
                    receiveAudioPrimed = true;
                    updateAudioUnlockUi();
                    demoBroadcastAlert('playing');
                });
            }
            throw err;
        }).catch(function (err) {
            console.warn('receive audio play failed', err);
            if (err && err.name === 'NotAllowedError') {
                pendingPlayPayload = payload;
                receiveActive = false;
                setReceiveUi('idle', '재생 대기', '브라우저가 소리를 막았습니다. 화면 아무 곳이나 한 번 클릭한 뒤 다시 송출해 주세요.');
                var btn = $('receiveAudioUnlockBtn');
                if (btn) btn.hidden = false;
                toast({
                    title: '자동 재생 차단',
                    message: dongName + ' 수신기: 이 탭을 한 번 클릭하거나 「소리가 안 들릴 때만 클릭」 후 송출 PC에서 방송을 다시 보내 주세요.',
                    type: 'warning',
                    hero: true,
                    duration: 8000
                });
            }
            throw err;
        });
    }

    function sendBroadcastDoneAck(payload, status) {
        if (!payload || !payload.broadcastId || !payload.senderUserNo) return;
        if (ackSentForBroadcastId === payload.broadcastId) return;

        var client = getStompClient();
        if (!client || !client.connected) return;

        ackSentForBroadcastId = payload.broadcastId;
        client.send('/pub/broadcast/done', {}, JSON.stringify({
            broadcastId: payload.broadcastId,
            mgmtOfcNo: payload.mgmtOfcNo || cfg.mgmtOfcNo,
            dongNo: payload.targetDongNo || cfg.dongNo,
            dongLabel: payload.targetDongLabel || cfg.dongLabel || cfg.dongNo,
            senderUserNo: payload.senderUserNo,
            status: status === 'DONE' ? 'DONE' : 'FAILED'
        }));
    }

    function finishReceivePlayback(status) {
        var payload = activePlayPayload;
        if (payload) {
            sendBroadcastDoneAck(payload, status || 'DONE');
        }
        activePlayPayload = null;
        receiveActive = false;
        setReceiveUi('idle', '대기 중', '방송 송출 시 이 화면에서 자동 재생됩니다.');
        setWsBadge('is-ok', '수신 대기');
        demoBroadcastAlert('done');
    }

    function onBroadcastMessage(msg) {
        var payload;
        try {
            payload = JSON.parse(msg.body);
        } catch (e) {
            console.warn('broadcast message parse failed', e);
            return;
        }
        if (!payload || payload.action !== 'PLAY') return;

        activePlayPayload = payload;
        ackSentForBroadcastId = null;

        var payloadDong = normalizeDongNo(payload.targetDongNo);
        var cfgDong = normalizeDongNo(cfg.dongNo);
        if (payloadDong && cfgDong && payloadDong !== cfgDong) {
            console.error('[방송 수신] 동 코드 불일치 — 이 수신기:', cfgDong, '송출 대상:', payloadDong);
            setWsBadge('is-error', '동 코드 불일치');
            toast({
                title: '수신 불가 (동 불일치)',
                message: '이 화면은「' + cfgDong + '」인데 송출은「' + payloadDong
                    + '」입니다. 수신기 링크의 dongNo를 송출 화면과 맞춰 주세요.',
                type: 'error',
                hero: true,
                duration: 9000
            });
            return;
        }

        console.log('[방송 수신] 1동(이 동) WS 수신 OK', getDongName(), 'dest=', getSubscribeDest(), payload);
        demoBroadcastAlert('start');

        if (pendingPlay && typeof pendingPlay.abort === 'function') {
            pendingPlay.abort();
        }
        var controller = typeof AbortController !== 'undefined' ? new AbortController() : null;
        pendingPlay = controller;

        function runPlay(retry) {
            return fetchAndPlayTts(payload).catch(function (err) {
                if (!retry && err && err.name !== 'AbortError') {
                    console.warn('receive play retry', err);
                    return runPlay(true);
                }
                throw err;
            });
        }

        runPlay(false).catch(function (err) {
            if (err && err.name === 'AbortError') return;
            if (err && err.name === 'NotAllowedError') return;
            console.warn('receive play failed', err);
            finishReceivePlayback('FAILED');
            setWsBadge('is-error', '재생 실패');
            toast({
                title: '수신 실패',
                message: '음성을 재생할 수 없습니다. TTS·로그인·송출 PC와 같은 서버 주소인지 확인해 주세요.',
                type: 'error',
                duration: 5000
            });
        }).finally(function () {
            pendingPlay = null;
        });
    }

    function getStompClient() {
        try {
            if (typeof stomp !== 'undefined' && stomp) {
                return stomp;
            }
        } catch (ignore) { /* stomp 미선언 */ }
        return null;
    }

    function isStompReady() {
        var client = getStompClient();
        return !!(client && client.connected);
    }

    function subscribeBroadcast() {
        var client = getStompClient();
        if (!client || !client.connected) {
            return false;
        }
        if (broadcastSubscription) {
            broadcastSubscription.unsubscribe();
        }
        var dest = getSubscribeDest();
        broadcastSubscription = client.subscribe(dest, onBroadcastMessage);
        console.log('[방송 수신] 구독 OK:', dest, '| host=', location.host, '| dongNo=', cfg.dongNo);
        var destEl = $('receiveSubDest');
        if (destEl) destEl.textContent = dest;
        var verifyEl = $('receiveVerifyResult');
        if (verifyEl) {
            verifyEl.textContent = '구독 중 — 송출 시 F12에 「1동(이 동) WS 수신 OK」가 보이면 정상';
            verifyEl.className = 'bc-receive-verify-result is-ok';
        }
        setWsBadge('is-ok', '수신 대기');
        setReceiveUi('idle', '대기 중', '구독 중: ' + (cfg.dongLabel || cfg.dongNo));
        if (!readyToastShown) {
            readyToastShown = true;
            toast({
                title: '수신기 준비 완료',
                message: getDongName() + ' 수신 대기 중입니다. 송출 시 이 화면에 알림이 표시됩니다.',
                type: 'success',
                duration: 5000
            });
        }
        return true;
    }

    var stompWaitTimer = null;

    function stopStompWait() {
        if (stompWaitTimer) {
            clearInterval(stompWaitTimer);
            stompWaitTimer = null;
        }
    }

    function waitForStompAndSubscribe() {
        stopStompWait();
        if (subscribeBroadcast()) {
            return;
        }
        setWsBadge('', '연결 중…');
        var tries = 0;
        var max = 120;
        stompWaitTimer = setInterval(function () {
            tries++;
            if (subscribeBroadcast()) {
                stopStompWait();
                return;
            }
            if (tries >= max) {
                stopStompWait();
                setWsBadge('is-error', 'WS 미연결');
                setReceiveUi('idle', '연결 실패',
                    '웹소켓이 연결되지 않았습니다. F12 콘솔에 「웹소켓 연결됨」이 보이는지 확인한 뒤 Ctrl+F5로 새로고침해 주세요.');
            }
        }, 500);
    }

    function bindAudioEvents() {
        if (!receiveAudio) return;
        receiveAudio.addEventListener('ended', function () {
            finishReceivePlayback('DONE');
        });
        receiveAudio.addEventListener('pause', function () {
            if (receiveActive && receiveAudio.ended) {
                finishReceivePlayback('DONE');
            }
        });
    }

    function verifyReceiveReady() {
        var lines = [];
        var ok = true;

        lines.push('서버: ' + location.host);
        lines.push('동 코드: ' + cfg.dongNo + ' (' + (cfg.dongLabel || '') + ')');
        lines.push('구독 경로: ' + getSubscribeDest());

        if (!isStompReady()) {
            ok = false;
            lines.push('웹소켓: 미연결 (F12에 「웹소켓 연결됨」 필요)');
        } else {
            lines.push('웹소켓: 연결됨');
        }

        if (!broadcastSubscription) {
            ok = false;
            lines.push('방송 구독: 없음 — 잠시 후 다시 시도');
            subscribeBroadcast();
        } else {
            lines.push('방송 구독: 활성');
        }

        if (!receiveAudioUnlocked && !receiveAudioPrimed) {
            lines.push('스피커: 자동 준비 시도 중 (방송 시 재생)');
        } else {
            lines.push('스피커: 자동 재생 준비됨');
        }

        var verifyEl = $('receiveVerifyResult');
        if (verifyEl) {
            verifyEl.textContent = lines.join(' · ');
            verifyEl.className = 'bc-receive-verify-result ' + (ok ? 'is-ok' : 'is-warn');
        }

        toast({
            title: ok ? '수신기 연결 OK' : '수신기 연결 (확인 필요)',
            message: lines.join('\n'),
            type: ok ? 'success' : 'warning',
            hero: true,
            duration: 8000
        });

        console.log('[방송 수신 점검]\n' + lines.join('\n'));
        return ok;
    }

    function bindAudioUnlock() {
        var btn = $('receiveAudioUnlockBtn');
        if (btn) {
            btn.addEventListener('click', function (e) {
                e.preventDefault();
                e.stopPropagation();
                unlockReceiveAudio();
            });
        }
        var gestures = ['pointerdown', 'touchstart', 'keydown'];
        function onFirstGesture() {
            if (!receiveAudioUnlocked && !receiveAudioPrimed) {
                unlockReceiveAudio();
            }
        }
        gestures.forEach(function (ev) {
            document.addEventListener(ev, onFirstGesture, { once: true, capture: true });
        });
    }

    var receivePageBooted = false;

    function bootReceivePage() {
        if (receivePageBooted) return;
        receivePageBooted = true;

        /* 수신기 메타에 현재 서버 주소 표시 — 호스트 불일치 진단용 */
        var originEl = $('receiveServerOrigin');
        if (originEl) originEl.textContent = location.origin;

        if (!cfg.dongValid) {
            setWsBadge('is-error', '동 코드 오류');
            console.error('[방송 수신] dongValid=false — URL의 dongNo가 DB에 없습니다. 수신기 링크를 다시 확인하세요.');
            return;
        }

        console.log('[방송 수신] 초기화 | 서버=' + location.origin
            + ' | dongNo=' + cfg.dongNo + ' | mgmtOfcNo=' + cfg.mgmtOfcNo);

        bindAudioEvents();
        bindAudioUnlock();
        updateAudioUnlockUi();
        primeReceiveAudioAutoplay();

        var verifyBtn = $('receiveVerifyBtn');
        if (verifyBtn) {
            verifyBtn.addEventListener('click', function (e) {
                e.preventDefault();
                e.stopPropagation();
                primeReceiveAudioAutoplay().finally(function () {
                    verifyReceiveReady();
                });
            });
        }

        waitForStompAndSubscribe();
        setTimeout(function () {
            if (isStompReady()) subscribeBroadcast();
        }, 1500);
    }

    document.addEventListener('DOMContentLoaded', bootReceivePage);
    /* mngr-broadcast.js 패턴과 동일 — DOM이 이미 ready일 때 대비 */
    if (document.readyState !== 'loading') {
        bootReceivePage();
    }
})();
