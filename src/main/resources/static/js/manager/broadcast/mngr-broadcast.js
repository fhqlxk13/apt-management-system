/**
 * 방송 안내 작성 · TTS 변환 · sessionStorage 이력(문구·설정만)
 */
(function () {
    'use strict';

    var cfg = window.BC_PAGE;
    if (!cfg || !cfg.mgmtOfcNo) return;

    var LANG = 'ko-KR';
    var CHAR_RECOMMEND = 300;
    var CHAR_MAX = 500;
    var HISTORY_MAX = 20;
    var DEFAULT_RESET_VOICE = 'ko-KR-Standard-C';
    var CONVERT_BTN_HTML = '<span class="material-symbols-rounded">graphic_eq</span>음성 변환';
    // var CONVERT_DOCKER_BTN_HTML = '<span class="material-symbols-rounded">dns</span>도커 음성 변환';
    var PREVIEW_BTN_HTML = '<span class="material-symbols-rounded">hearing</span>미리듣기';

    var VOICE_OPTIONS = {
        'ko-KR-Standard-A': '여성 A',
        'ko-KR-Standard-B': '여성 B',
        'ko-KR-Standard-C': '남성 A',
        'ko-KR-Standard-D': '남성 B'
    };

    var historyRows = [];
    var selectedSourceId = '';
    var previewActive = false;
    var previewFetchAbort = null;
    var previewToken = 0;
    var broadcastActive = false;
    var senderAckSubscription = null;
    var senderAckWaitTimer = null;
    var pendingBroadcastSession = null;
    /** 방송 구역 '전체' 시 관리사무소(송출 PC) 로컬 모니터용 — WS 수신기와 별도 */
    var MGMT_LOCAL_DONG = '__MGMT_OFFICE__';
    var currentPlayerRow = null;
    var lastPlaybackBlob = null;
    var $ = function (id) { return document.getElementById(id); };

    var SOURCE_NOTES = {
        check: '점검 건을 클릭하면 좌측에 방송 초안이 채워집니다.',
        complaint: '민원 건을 클릭하면 좌측에 방송 초안이 채워집니다.',
        history: '이력에는 문구·설정만 저장됩니다. 재생은 음성 변환하기로 다시 생성해 주세요.'
    };

    function getVoiceLabel(voice) {
        return VOICE_OPTIONS[voice] || '남성 A';
    }

    function voiceFromLabel(label) {
        if (label === '남성 B') return 'ko-KR-Standard-D';
        if (label === '남성 A') return 'ko-KR-Standard-C';
        if (label === '여성 B') return 'ko-KR-Standard-B';
        return 'ko-KR-Standard-A';
    }

    function getIntro() {
        var page = document.getElementById('broadcastPage');
        return (page && page.getAttribute('data-broadcast-intro')) || '안녕하세요. 본 단지 관리사무소입니다.';
    }

    function getDummySources() {
        var intro = getIntro();
        return {
            check: [
                {
                    id: 'chk-1',
                    title: '1호기 승강기 정기 점검',
                    meta: '2026-05-29 · 이용 제한',
                    badge: '제한중',
                    badgeClass: 'warn',
                    areas: ['1동'],
                    draft: intro + '\n오늘 오후 2시부터 4시까지 1호기 엘리베이터 정기점검이 있습니다.\n이용에 불편을 드려 죄송합니다.\n감사합니다.'
                },
                {
                    id: 'chk-2',
                    title: '지하 주차장 환기시설 점검',
                    meta: '2026-05-30 · 예정',
                    badge: '점검 예정',
                    areas: ['전체'],
                    draft: intro + '\n내일 오전 10시부터 12시까지 지하 주차장 환기시설 점검이 있습니다.\n해당 시간에는 소음이 있을 수 있으므로 이용에 참고해 주시기 바랍니다.\n감사합니다.'
                }
            ],
            complaint: [
                {
                    id: 'cvpl-1',
                    title: '주차 단속 관련 협조 요청',
                    meta: '처리중 · 공용구역',
                    badge: '주차',
                    areas: ['전체'],
                    draft: intro + '\n소방 통로와 출입구 주변에 주차된 차량이 있어 안내드립니다.\n30분 이내에 차량을 옮겨 주시면 감사하겠습니다.\n감사합니다.'
                },
                {
                    id: 'cvpl-2',
                    title: '층간소음 관련 협조 안내',
                    meta: '접수 · 102동',
                    badge: '생활소음',
                    areas: ['102동'],
                    draft: intro + '\n층간소음으로 불편하신 이웃이 계셔 안내드립니다.\n심야 시간대에는 발소리와 TV 음량에 조금만 신경 써 주시기 바랍니다.\n이웃을 배려해 주셔서 감사합니다.'
                }
            ]
        };
    }

    function storageKey() {
        return 'broadcast_history_' + cfg.mgmtOfcNo;
    }

    function nowKST() {
        return new Date().toLocaleString('ko-KR');
    }

    function escapeHtml(str) {
        return (str == null ? '' : String(str))
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/"/g, '&quot;')
            .replace(/'/g, '&#039;');
    }

    function toast(opts) {
        if (typeof showToast === 'function') {
            showToast(opts);
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

    function isLikelyMp3Blob(blob) {
        if (!blob || blob.size < 128) {
            return Promise.resolve(false);
        }
        return blob.slice(0, 4).arrayBuffer().then(function (buf) {
            var b = new Uint8Array(buf);
            if (b[0] === 0xFF && (b[1] & 0xE0) === 0xE0) return true;
            return b[0] === 0x49 && b[1] === 0x44 && b[2] === 0x33;
        });
    }

    function revokeObjectUrl(audio, urlField) {
        if (audio && audio[urlField]) {
            URL.revokeObjectURL(audio[urlField]);
            audio[urlField] = null;
        }
    }

    function attachBlobToAudio(audio, blob, urlField) {
        clearAudioTimingWatch(audio);
        revokeObjectUrl(audio, urlField);
        if (!audio) return false;
        audio.pause();
        try {
            audio.currentTime = 0;
        } catch (ignore) { /* seek */ }
        if (!blob || blob.size < 128) {
            audio.removeAttribute('src');
            return false;
        }
        var url = URL.createObjectURL(blob);
        audio[urlField] = url;
        audio.src = url;
        return true;
    }

    function clearAudioElement(audio, urlField) {
        clearAudioTimingWatch(audio);
        if (!audio) return;
        audio.pause();
        revokeObjectUrl(audio, urlField);
        audio.removeAttribute('src');
    }

    function setLastPlaybackBlob(blob) {
        lastPlaybackBlob = blob && blob.size >= 128 ? blob : null;
    }

    function buildAudioFileName(row) {
        var base = 'broadcast';
        if (row && row.text) {
            base = row.text.replace(/\s+/g, ' ').trim().slice(0, 24);
            base = base.replace(/[\\/:*?"<>|]/g, '').replace(/\s+/g, '_');
        }
        if (!base) base = 'broadcast';
        var stamp = '';
        if (row && row.createdAt) {
            stamp = String(row.createdAt).replace(/[^\d]/g, '').slice(0, 12);
        }
        if (!stamp) {
            var d = new Date();
            stamp = String(d.getFullYear())
                + String(d.getMonth() + 1).padStart(2, '0')
                + String(d.getDate()).padStart(2, '0')
                + String(d.getHours()).padStart(2, '0')
                + String(d.getMinutes()).padStart(2, '0');
        }
        return base + '_' + stamp + '.mp3';
    }

    function downloadCurrentAudio() {
        if (!lastPlaybackBlob) {
            toast({ title: '다운로드', message: '음성 데이터가 없습니다. 음성 변환하기를 먼저 실행해 주세요.', type: 'error' });
            return;
        }
        var url = URL.createObjectURL(lastPlaybackBlob);
        var a = document.createElement('a');
        a.href = url;
        a.download = buildAudioFileName(currentPlayerRow);
        a.style.display = 'none';
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
        setTimeout(function () { URL.revokeObjectURL(url); }, 1000);
        toast({
            title: '다운로드',
            message: '음성 파일을 저장했습니다.',
            type: 'success',
            duration: 2400
        });
    }

    function startPlayerPlayback(audio, opts) {
        if (!audio || !audio.src) return Promise.resolve();
        opts = opts || {};
        return audio.play().then(function () {
            updatePlayerToggle(true);
        }).catch(function (err) {
            console.warn('audio play failed', err);
            updatePlayerToggle(false);
            if (opts.notifyBlocked) {
                toast({
                    title: '재생',
                    message: '자동 재생이 제한되었습니다. 재생 버튼을 눌러 주세요.',
                    type: 'info',
                    duration: 4000
                });
            } else {
                toast({
                    title: '재생 불가',
                    message: '음성을 재생할 수 없습니다.',
                    type: 'error',
                    duration: 4000
                });
            }
        });
    }

    function formatAudioTime(sec) {
        if (!isFinite(sec) || sec < 0) return '0:00';
        var s = Math.floor(sec);
        var m = Math.floor(s / 60);
        return m + ':' + String(s % 60).padStart(2, '0');
    }

    function formatTimeRange(audio) {
        if (!audio) return '0:00 / --:--';
        var cur = formatAudioTime(audio.currentTime);
        var dur = isFinite(audio.duration) && audio.duration > 0
            ? formatAudioTime(audio.duration)
            : '--:--';
        return cur + ' / ' + dur;
    }

    function updatePlayerTimeDisplay() {
        var audio = $('playerAudio');
        var el = $('playerTime');
        if (!audio || !el) return;
        el.textContent = formatTimeRange(audio);
    }

    function clearAudioTimingWatch(audio) {
        if (!audio) return;
        if (audio._bcWatchers) {
            audio._bcWatchers.forEach(function (w) {
                audio.removeEventListener(w.ev, w.fn);
            }); 
            audio._bcWatchers = null;
        }
        if (audio._bcDurTimer) {
            clearTimeout(audio._bcDurTimer);
            audio._bcDurTimer = null;
        }
    }

    function watchAudioTiming(audio, onUpdate) {
        clearAudioTimingWatch(audio);
        if (!audio || typeof onUpdate !== 'function') return;

        audio._bcWatchers = [];
        function add(ev, fn) {
            audio.addEventListener(ev, fn);
            audio._bcWatchers.push({ ev: ev, fn: fn });
        }

        function refresh() {
            onUpdate();
            if (!isFinite(audio.duration) || audio.duration <= 0) {
                if (!audio._bcDurTimer) {
                    audio._bcDurTimer = setTimeout(refresh, 120);
                }
            } else if (audio._bcDurTimer) {
                clearTimeout(audio._bcDurTimer);
                audio._bcDurTimer = null;
            }
        }

        add('loadedmetadata', refresh);
        add('durationchange', refresh);
        add('canplay', refresh);
        add('timeupdate', onUpdate);
        refresh();
    }

    function normalizeHistoryRow(row) {
        if (!row || typeof row !== 'object') return null;
        return {
            text: row.text || '',
            voice: row.voice || DEFAULT_RESET_VOICE,
            areas: Array.isArray(row.areas) ? row.areas : [],
            area: row.area || '',
            voiceLabel: row.voiceLabel || getVoiceLabel(row.voice),
            createdAt: row.createdAt || nowKST()
        };
    }

    function saveHistory() {
        try {
            if (!historyRows.length) {
                sessionStorage.removeItem(storageKey());
                return;
            }
            sessionStorage.setItem(storageKey(), JSON.stringify(historyRows.map(normalizeHistoryRow)));
        } catch (e) {
            console.warn('방송 이력 저장 실패:', e);
            toast({
                title: '이력 저장 실패',
                message: '브라우저 저장 공간이 부족합니다. 이력을 줄여 주세요.',
                type: 'warning',
                duration: 5000
            });
            if (historyRows.length > 1) {
                historyRows.pop();
                saveHistory();
            }
        }
    }

    function loadHistory() {
        try {
            var raw = sessionStorage.getItem(storageKey());
            var parsed = raw ? JSON.parse(raw) : [];
            if (!Array.isArray(parsed)) parsed = [];
            historyRows = parsed.map(normalizeHistoryRow).filter(function (r) { return r && r.text; });
        } catch (e) {
            historyRows = [];
        }
    }

    function getSelected(attr) {
        var el = document.querySelector('[' + attr + '].active');
        return el ? el.getAttribute(attr) : '';
    }

    function getAreaCheckboxes() {
        return document.querySelectorAll('#areaSelectPanel input[name="areaOpt"]');
    }

    function getAllAreaCheckbox() {
        return document.querySelector('#areaSelectPanel input[data-area-all]');
    }

    function isAreaAllCheckbox(cb) {
        return cb && cb.hasAttribute('data-area-all');
    }

    function updateAreaLabel() {
        var label = $('areaSelectLabel');
        if (label) label.textContent = formatAreaDisplay(getSelectedAreas());
    }

    function resetSelectPanelPosition(panel) {
        if (!panel) return;
        panel.classList.remove('is-drop-up', 'is-panel-fixed');
        panel.style.width = '';
        panel.style.left = '';
        panel.style.right = '';
        panel.style.top = '';
        panel.style.bottom = '';
    }

    function closeAreaPanel() {
        var panel = $('areaSelectPanel');
        var trigger = $('areaSelectTrigger');
        if (panel) {
            panel.hidden = true;
            resetSelectPanelPosition(panel);
        }
        if (trigger) {
            trigger.classList.remove('open');
            trigger.setAttribute('aria-expanded', 'false');
        }
    }

    function closeSelectPanels() {
        closeAreaPanel();
        closeVoicePanel();
    }

    function closeVoicePanel() {
        var panel = $('voiceSelectPanel');
        var trigger = $('voiceSelectTrigger');
        if (panel) {
            panel.hidden = true;
            resetSelectPanelPosition(panel);
        }
        if (trigger) {
            trigger.classList.remove('open');
            trigger.setAttribute('aria-expanded', 'false');
        }
    }

    function positionSelectPanel(panelId, triggerId) {
        var panel = $(panelId);
        var trigger = $(triggerId);
        if (!panel || !trigger || panel.hidden) return;

        panel.classList.remove('is-drop-up');
        var rect = trigger.getBoundingClientRect();
        var panelHeight = panel.offsetHeight || 168;
        var spaceBelow = window.innerHeight - rect.bottom - 12;
        var spaceAbove = rect.top - 12;
        var dropUp = panelHeight > spaceBelow && spaceAbove > spaceBelow;

        panel.classList.add('is-panel-fixed');
        panel.style.width = Math.round(rect.width) + 'px';
        panel.style.left = Math.round(rect.left) + 'px';
        panel.style.right = 'auto';

        if (dropUp) {
            panel.classList.add('is-drop-up');
            panel.style.top = 'auto';
            panel.style.bottom = Math.round(window.innerHeight - rect.top + 6) + 'px';
        } else {
            panel.style.top = Math.round(rect.bottom + 6) + 'px';
            panel.style.bottom = 'auto';
        }
    }

    function positionAreaPanel() {
        positionSelectPanel('areaSelectPanel', 'areaSelectTrigger');
    }

    function positionVoicePanel() {
        positionSelectPanel('voiceSelectPanel', 'voiceSelectTrigger');
    }

    function updateVoiceLabel() {
        var label = $('voiceSelectLabel');
        var select = $('voiceSelect');
        if (label && select) label.textContent = getVoiceLabel(select.value);
    }

    function selectVoice(voice, voiceLabel) {
        var v = voice || voiceFromLabel(voiceLabel);
        if (!VOICE_OPTIONS[v]) {
            v = DEFAULT_RESET_VOICE;
        }
        var select = $('voiceSelect');
        if (select) select.value = v;
        document.querySelectorAll('#voiceSelectPanel [data-voice]').forEach(function (opt) {
            var on = opt.getAttribute('data-voice') === v;
            opt.classList.toggle('active', on);
            opt.setAttribute('aria-selected', on ? 'true' : 'false');
        });
        updateVoiceLabel();
    }

    function bindVoiceSelect() {
        var trigger = $('voiceSelectTrigger');
        var panel = $('voiceSelectPanel');
        if (!trigger || !panel) return;

        trigger.addEventListener('click', function (e) {
            e.stopPropagation();
            var willOpen = panel.hidden;
            closeSelectPanels();
            if (willOpen) {
                panel.hidden = false;
                trigger.classList.add('open');
                trigger.setAttribute('aria-expanded', 'true');
                requestAnimationFrame(function () {
                    positionVoicePanel();
                });
            }
        });

        panel.addEventListener('click', function (e) {
            e.stopPropagation();
            var opt = e.target.closest('[data-voice]');
            if (!opt) return;
            selectVoice(opt.getAttribute('data-voice'));
            closeVoicePanel();
        });
    }

    function isBroadcastAllAreas(form) {
        return !!(form && form.areas && form.areas.indexOf('전체') >= 0);
    }

    function getSelectedAreas() {
        var allCb = getAllAreaCheckbox();
        if (allCb && allCb.checked) return ['전체'];
        var areas = [];
        getAreaCheckboxes().forEach(function (cb) {
            if (!isAreaAllCheckbox(cb) && cb.checked) areas.push(cb.value);
        });
        return areas.length ? areas : ['전체'];
    }

    /** WebSocket 동별 송출용 — dongNo·표시 라벨 */
    function formatBroadcastSendingToast(targets) {
        var origin = location.origin;
        if (!targets || !targets.length) {
            return { title: '방송 송출 중', message: '수신기에서 재생이 끝나면 완료 알림이 표시됩니다.' };
        }
        if (targets.length === 1) {
            return {
                title: '방송 송출 중 (1개 동)',
                message: targets[0].dongLabel + ' 수신기 재생 중 — 수신기 PC는 이 서버(' + origin + ')로 접속해야 합니다.'
            };
        }
        return {
            title: '방송 송출 중 (' + targets.length + '개 동)',
            message: '수신기 PC는 이 서버(' + origin + ')로 접속해야 합니다. 스피커 허용·동 코드 확인 후 재생됩니다.'
        };
    }

    function topicKeySegment(value) {
        return String(value == null ? '' : value).replace(/\//g, '_').replace(/\s/g, '_');
    }

    function getSenderUserNo() {
        var body = document.body;
        if (body && body.dataset && body.dataset.userNo) {
            return body.dataset.userNo;
        }
        return cfg.senderUserNo || '';
    }

    function createBroadcastId() {
        return 'bc-' + Date.now() + '-' + Math.random().toString(36).slice(2, 10);
    }

    function subscribeSenderAck() {
        var client = null;
        try {
            if (typeof stomp !== 'undefined' && stomp) {
                client = stomp;
            }
        } catch (ignore) { /* stomp 미선언 */ }
        var userNo = getSenderUserNo();
        if (!client || !client.connected || !userNo) {
            return false;
        }
        if (senderAckSubscription) {
            senderAckSubscription.unsubscribe();
        }
        var dest = '/sub/broadcast/sender/' + cfg.mgmtOfcNo + '/' + topicKeySegment(userNo);
        senderAckSubscription = client.subscribe(dest, onSenderBroadcastAck);
        console.log('[방송 송출] 완료 수신 구독:', dest);
        return true;
    }

    function stopSenderAckWait() {
        if (senderAckWaitTimer) {
            clearInterval(senderAckWaitTimer);
            senderAckWaitTimer = null;
        }
    }

    function ensureSenderAckSubscription() {
        stopSenderAckWait();
        if (subscribeSenderAck()) {
            return;
        }
        var tries = 0;
        senderAckWaitTimer = setInterval(function () {
            tries++;
            if (subscribeSenderAck() || tries >= 40) {
                stopSenderAckWait();
            }
        }, 500);
    }

    function onSenderBroadcastAck(msg) {
        var ack;
        try {
            ack = JSON.parse(msg.body);
        } catch (e) {
            console.warn('broadcast ack parse failed', e);
            return;
        }
        if (!ack || ack.action !== 'ACK' || !pendingBroadcastSession) return;
        if (ack.broadcastId !== pendingBroadcastSession.broadcastId) return;

        var dongNo = ack.targetDongNo;
        if (!dongNo || pendingBroadcastSession.resolved[dongNo]) return;

        pendingBroadcastSession.resolved[dongNo] = true;
        if (ack.status === 'DONE') {
            pendingBroadcastSession.done[dongNo] = ack.targetDongLabel || dongNo;
        } else {
            pendingBroadcastSession.failed[dongNo] = ack.targetDongLabel || dongNo;
        }

        if (isBroadcastSessionComplete(pendingBroadcastSession)) {
            finalizeBroadcastCompletion('ack');
        }
    }

    function isBroadcastSessionComplete(session) {
        if (!session || !session.targets || !session.targets.length) return false;

        var remote = [];
        var local = [];
        session.targets.forEach(function (t) {
            if (t.local) local.push(t);
            else remote.push(t);
        });

        var localDone = !local.length || local.every(function (t) {
            return !!session.resolved[t.dongNo];
        });
        var remoteDone = !remote.length || remote.every(function (t) {
            return !!session.resolved[t.dongNo];
        });

        if (session.allAreasMode) {
            if (!localDone) return false;
            if (remoteDone) return true;
            return !!session.remoteGraceComplete;
        }

        return localDone && remoteDone;
    }

    function clearBroadcastCompletionTimers() {
        if (!pendingBroadcastSession) return;
        if (pendingBroadcastSession.timer) {
            clearTimeout(pendingBroadcastSession.timer);
            pendingBroadcastSession.timer = null;
        }
        if (pendingBroadcastSession.remoteGraceTimer) {
            clearTimeout(pendingBroadcastSession.remoteGraceTimer);
            pendingBroadcastSession.remoteGraceTimer = null;
        }
        if (pendingBroadcastSession.watchdogTimer) {
            clearTimeout(pendingBroadcastSession.watchdogTimer);
            pendingBroadcastSession.watchdogTimer = null;
        }
    }

    function forceReleaseBroadcastUi() {
        broadcastActive = false;
        setBroadcastButtonState(false, false);
        updateBroadcastActionButtons();
    }

    function scheduleRemoteGraceFinalize() {
        if (!pendingBroadcastSession || !pendingBroadcastSession.allAreasMode) return;
        if (pendingBroadcastSession.remoteGraceTimer) return;

        pendingBroadcastSession.remoteGraceTimer = setTimeout(function () {
            if (!pendingBroadcastSession) return;
            pendingBroadcastSession.remoteGraceComplete = true;
            if (isBroadcastSessionComplete(pendingBroadcastSession)) {
                finalizeBroadcastCompletion('grace');
            }
        }, 8000);
    }

    function markMgmtLocalDone(success) {
        if (!pendingBroadcastSession) return;
        if (pendingBroadcastSession.resolved[MGMT_LOCAL_DONG]) return;

        pendingBroadcastSession.resolved[MGMT_LOCAL_DONG] = true;
        if (success) {
            pendingBroadcastSession.done[MGMT_LOCAL_DONG] = '관리사무소';
        } else {
            pendingBroadcastSession.failed[MGMT_LOCAL_DONG] = '관리사무소';
        }

        if (pendingBroadcastSession.allAreasMode) {
            scheduleRemoteGraceFinalize();
        }

        if (isBroadcastSessionComplete(pendingBroadcastSession)) {
            finalizeBroadcastCompletion('ack');
        }
    }

    function startMgmtOfficeMonitorPlayback(audio) {
        if (!audio || !audio.src) {
            markMgmtLocalDone(false);
            return;
        }

        try {
            audio.currentTime = 0;
        } catch (ignore) { /* seek */ }

        var endedOnce = false;
        function onMonitorEnded() {
            if (endedOnce) return;
            endedOnce = true;
            audio.removeEventListener('ended', onMonitorEnded);
            var eq = $('eqBars');
            if (eq) eq.classList.remove('playing');
            updatePlayerToggle(false);
            markMgmtLocalDone(true);
        }

        audio.addEventListener('ended', onMonitorEnded);
        pauseAllBroadcastAudio(audio);
        startPlayerPlayback(audio).catch(function (err) {
            console.warn('mgmt office monitor play failed', err);
            audio.removeEventListener('ended', onMonitorEnded);
            markMgmtLocalDone(false);
            toast({
                title: '관리사무소 재생',
                message: '이 PC에서 방송 음성을 재생하지 못했습니다. 브라우저 자동재생을 허용하거나 ▶ 테스트 재생 후 다시 시도해 주세요.',
                type: 'warning',
                duration: 5000
            });
        });
    }

    function computeBroadcastTimeoutMs(targetCount, allAreas) {
        var audio = $('playerAudio');
        var durationMs = 60000;
        if (audio && isFinite(audio.duration) && audio.duration > 0) {
            durationMs = Math.ceil(audio.duration * 1000);
        }
        var n = Math.max(1, targetCount || 1);
        if (!allAreas && n <= 1) {
            return Math.min(60000, Math.max(25000, durationMs + 15000));
        }
        var capped = Math.min(n, 10);
        return Math.min(90000, Math.max(40000, durationMs + 12000 + capped * 3000));
    }

    function beginBroadcastCompletionWait(broadcastId, targets, form) {
        clearBroadcastCompletionTimers();
        var sessionTargets = targets.slice();
        var allAreas = isBroadcastAllAreas(form);

        if (allAreas) {
            sessionTargets.push({
                dongNo: MGMT_LOCAL_DONG,
                dongLabel: '관리사무소',
                local: true
            });
        }

        pendingBroadcastSession = {
            broadcastId: broadcastId,
            targets: sessionTargets,
            resolved: {},
            done: {},
            failed: {},
            allAreasMode: allAreas,
            remoteGraceComplete: false,
            timer: null,
            remoteGraceTimer: null
        };
        var maxMs = computeBroadcastTimeoutMs(sessionTargets.length, allAreas);
        pendingBroadcastSession.timer = setTimeout(function () {
            finalizeBroadcastCompletion('timeout');
        }, maxMs);
        pendingBroadcastSession.watchdogTimer = setTimeout(function () {
            if (!broadcastActive && !pendingBroadcastSession) return;
            console.warn('[방송 송출] UI watchdog — 세션 강제 종료');
            finalizeBroadcastCompletion('watchdog');
        }, maxMs + 5000);
    }

    function cancelBroadcastSession() {
        clearBroadcastCompletionTimers();
        pendingBroadcastSession = null;
        forceReleaseBroadcastUi();
    }

    function finalizeBroadcastCompletion(reason) {
        var session = pendingBroadcastSession;
        if (!session) {
            forceReleaseBroadcastUi();
            return;
        }

        clearBroadcastCompletionTimers();
        pendingBroadcastSession = null;
        forceReleaseBroadcastUi();

        var doneLabels = [];
        var failedLabels = [];
        var pendingLabels = [];
        session.targets.forEach(function (t) {
            if (t.local) return;
            if (session.done[t.dongNo]) {
                doneLabels.push(session.done[t.dongNo]);
            } else if (session.failed[t.dongNo]) {
                failedLabels.push(session.failed[t.dongNo]);
            } else {
                pendingLabels.push(t.dongLabel || t.dongNo);
            }
        });

        var mgmtDone = session.done[MGMT_LOCAL_DONG];
        if (mgmtDone) {
            doneLabels.unshift(mgmtDone);
        }

        if (doneLabels.length && !failedLabels.length && !pendingLabels.length) {
            var doneMsg = doneLabels.length === 1
                ? doneLabels[0] + '에서 방송 재생이 완료되었습니다.'
                : doneLabels.join(', ') + '에서 방송 재생이 완료되었습니다.';
            toast({
                title: '방송 송출 완료',
                message: doneMsg,
                type: 'success',
                duration: 4500
            });
            return;
        }

        if (doneLabels.length) {
            toast({
                title: '방송 송출 완료 (일부)',
                message: '완료: ' + doneLabels.join(', ')
                    + (failedLabels.length ? ' · 실패: ' + failedLabels.join(', ') : '')
                    + (pendingLabels.length ? ' · 미응답: ' + pendingLabels.join(', ') : ''),
                type: 'warning',
                duration: 6000
            });
            return;
        }

        toast({
            title: reason === 'timeout' ? '방송 송출 시간 초과' : '방송 송출 실패',
            message: pendingLabels.length
                ? (pendingLabels.join(', ') + ' 수신기 응답이 없습니다. 수신 화면·웹소켓 연결을 확인해 주세요.')
                : '수신기에서 방송을 재생하지 못했습니다.',
            type: 'error',
            duration: 5500
        });
    }

    function getSelectedDongTargets() {
        var allCb = getAllAreaCheckbox();
        var targets = [];
        var pushCb = function (cb) {
            var dongNo = cb.getAttribute('data-dong-no');
            if (!dongNo) return;
            targets.push({ dongNo: dongNo, dongLabel: cb.value });
        };
        if (allCb && allCb.checked) {
            getAreaCheckboxes().forEach(function (cb) {
                if (!isAreaAllCheckbox(cb)) pushCb(cb);
            });
            return targets;
        }
        getAreaCheckboxes().forEach(function (cb) {
            if (!isAreaAllCheckbox(cb) && cb.checked) pushCb(cb);
        });
        return targets;
    }

    function waitForStompConnected(maxMs, onReady) {
        var elapsed = 0;
        var step = 200;
        var timer = setInterval(function () {
            elapsed += step;
            var client = null;
            try {
                if (typeof stomp !== 'undefined' && stomp) {
                    client = stomp;
                }
            } catch (ignore) { /* stomp 미선언 */ }
            if (client && client.connected) {
                clearInterval(timer);
                onReady(true);
                return;
            }
            if (elapsed >= maxMs) {
                clearInterval(timer);
                onReady(false);
            }
        }, step);
    }

    function publishBroadcastViaWebSocket(form, targets, broadcastId) {
        if (!targets || !targets.length) {
            toast({
                title: '방송',
                message: '방송할 동을 선택해 주세요.',
                type: 'error',
                duration: 3500
            });
            return Promise.resolve(false);
        }
        return new Promise(function (resolve) {
            waitForStompConnected(8000, function (ok) {
                var client = null;
                try {
                    if (typeof stomp !== 'undefined' && stomp) {
                        client = stomp;
                    }
                } catch (ignore) { /* stomp 미선언 */ }
                if (!ok || !client || !client.connected) {
                    toast({
                        title: '방송',
                        message: '웹소켓 연결이 필요합니다. 잠시 후 다시 시도하거나 페이지를 새로고침해 주세요.',
                        type: 'error',
                        duration: 4500
                    });
                    resolve(false);
                    return;
                }
                targets.forEach(function (t) {
                    console.log('[방송 송출] WS 전송 대상 → /sub/broadcast/'
                        + cfg.mgmtOfcNo + '/' + topicKeySegment(t.dongNo)
                        + ' (' + (t.dongLabel || t.dongNo) + ')');
                });

                client.send('/pub/broadcast/start', {}, JSON.stringify({
                    mgmtOfcNo: cfg.mgmtOfcNo,
                    broadcastId: broadcastId,
                    text: form.text,
                    languageCode: form.lang,
                    voiceName: form.voice,
                    areas: form.areas,
                    targets: targets
                }));

                if (targets.length === 1) {
                    console.log('[1동 수신 확인] 수신기 URL의 동 코드가 송출 대상과 같아야 합니다: dongNo='
                        + targets[0].dongNo);
                }
                resolve(true);
            });
        });
    }

    function formatAreaDisplay(areas) {
        if (!areas || !areas.length || areas.indexOf('전체') >= 0) return '전체';
        if (areas.length <= 2) return areas.join(', ');
        return areas[0] + ' 외 ' + (areas.length - 1) + '개 동';
    }

    function resetAreas() {
        getAreaCheckboxes().forEach(function (cb) {
            cb.checked = isAreaAllCheckbox(cb);
        });
        updateAreaLabel();
    }

    function selectAreas(areas) {
        var list = areas && areas.length ? areas : ['전체'];
        var allCb = getAllAreaCheckbox();
        if (list.indexOf('전체') >= 0) {
            resetAreas();
            return;
        }
        if (allCb) allCb.checked = false;
        getAreaCheckboxes().forEach(function (cb) {
            if (isAreaAllCheckbox(cb)) return;
            cb.checked = list.indexOf(cb.value) >= 0;
        });
        if (!document.querySelector('#areaSelectPanel input[name="areaOpt"]:not([data-area-all]):checked')) {
            resetAreas();
            return;
        }
        updateAreaLabel();
    }

    function bindAreaSelect() {
        var trigger = $('areaSelectTrigger');
        var panel = $('areaSelectPanel');
        if (!trigger || !panel) return;

        trigger.addEventListener('click', function (e) {
            e.stopPropagation();
            var willOpen = panel.hidden;
            closeSelectPanels();
            if (willOpen) {
                panel.hidden = false;
                trigger.classList.add('open');
                trigger.setAttribute('aria-expanded', 'true');
                requestAnimationFrame(function () {
                    positionAreaPanel();
                });
            }
        });

        document.addEventListener('click', closeSelectPanels);
        panel.addEventListener('click', function (e) { e.stopPropagation(); });

        getAreaCheckboxes().forEach(function (cb) {
            cb.addEventListener('change', function () {
                var allCb = getAllAreaCheckbox();
                if (isAreaAllCheckbox(cb)) {
                    if (cb.checked) {
                        getAreaCheckboxes().forEach(function (c) {
                            if (!isAreaAllCheckbox(c)) c.checked = false;
                        });
                    } else if (!document.querySelector('#areaSelectPanel input[name="areaOpt"]:not([data-area-all]):checked')) {
                        cb.checked = true;
                    }
                } else {
                    if (cb.checked && allCb) allCb.checked = false;
                    if (!document.querySelector('#areaSelectPanel input[name="areaOpt"]:not([data-area-all]):checked') && allCb) {
                        allCb.checked = true;
                    }
                }
                updateAreaLabel();
            });
        });
    }

    function getFormValues() {
        var areas = getSelectedAreas();
        return {
            text: $('ttsText').value.trim(),
            lang: LANG,
            voice: $('voiceSelect').value,
            voiceLabel: getVoiceLabel($('voiceSelect').value),
            areas: areas,
            area: formatAreaDisplay(areas)
        };
    }

    function getTtsErrorMessage(e) {
        if (e && e.name === 'AbortError') return '';
        var msg = 'TTS 변환에 실패했습니다. 서버 로그·tts-key.json 설정을 확인해주세요.';
        if (e && e.status === 403) {
            msg = '요청이 차단되었습니다(403). 페이지를 새로고침한 뒤 다시 시도해주세요.';
        } else if (String(e && e.message || '').indexOf('not audio') !== -1) {
            msg = '서버가 음성이 아닌 응답을 반환했습니다. 로그인·권한(CSRF)을 확인해주세요.';
        } else if (String(e && e.message || '').indexOf('invalid mp3') !== -1) {
            msg = '음성 데이터 형식이 올바르지 않습니다.';
        } else if (String(e && e.message || '').indexOf('TTS failed: 500') !== -1) {
            msg = 'TTS 변환 중 서버 오류가 발생했습니다. IntelliJ 콘솔 로그를 확인해주세요.';
        }
        return msg;
    }

    /* [도커 TTS 미사용]
    function getTtsDockerErrorMessage(e) {
        if (e && e.name === 'AbortError') return '';
        var msg = 'TTS 도커(8060) 연결에 실패했습니다. 도커 실행·포트 개방 상태를 확인해주세요.';
        if (e && e.status === 403) {
            msg = 'TTS 도커가 요청을 거부했습니다(403). CORS 설정을 확인해주세요.';
        } else if (String(e && e.message || '').indexOf('not audio') !== -1) {
            msg = 'TTS 도커(8060)가 음성이 아닌 응답을 반환했습니다.';
        } else if (String(e && e.message || '').indexOf('invalid mp3') !== -1) {
            msg = '도커 응답이 유효한 MP3가 아닙니다. TTS 도커 로그를 확인해주세요.';
        } else if (String(e && e.message || '').indexOf('TTS failed: 500') !== -1) {
            msg = 'TTS 도커 변환 중 오류가 발생했습니다. 도커 로그를 확인해주세요.';
        } else if (e && e.name === 'TypeError') {
            msg = 'TTS 도커(8060)에 연결할 수 없습니다. 같은 PC에서 도커가 실행 중인지 확인해주세요.';
        }
        return msg;
    }

    function getTtsServiceUrl() {
        return window.location.protocol + '//' + window.location.hostname + ':8060';
    }
    */

    function parseTtsAudioFetch(res) {
        var ct = (res.headers.get('content-type') || '').toLowerCase();
        if (!res.ok) {
            var err = new Error('TTS failed: ' + res.status + (ct ? ' (' + ct + ')' : ''));
            err.status = res.status;
            throw err;
        }
        if (ct.indexOf('audio/') === -1) {
            throw new Error('not audio response: ' + (ct || 'unknown'));
        }
        return res.arrayBuffer();
    }

    function blobFromAudioBuffer(ab) {
        if (!ab || ab.byteLength < 128) {
            throw new Error('empty audio blob');
        }
        var audioBlob = new Blob([ab], { type: 'audio/mpeg' });
        return isLikelyMp3Blob(audioBlob).then(function (ok) {
            if (!ok) {
                throw new Error('invalid mp3 payload');
            }
            return { blob: audioBlob };
        });
    }

    function synthesizeTtsRequest(v, signal) {
        var formBody = new URLSearchParams();
        formBody.set('text', v.text);
        formBody.set('languageCode', v.lang);
        formBody.set('voiceName', v.voice);
        return fetch(cfg.contextPath + '/tts/synthesize/' + cfg.mgmtOfcNo, {
            method: 'POST',
            credentials: 'same-origin',
            headers: buildTtsFetchHeaders('application/x-www-form-urlencoded;charset=UTF-8'),
            body: formBody.toString(),
            signal: signal
        })
            .then(parseTtsAudioFetch)
            .then(blobFromAudioBuffer);
    }

    /* [도커 TTS 미사용]
    function synthesizeTtsDockerRequest(v, signal) {
        var params = new URLSearchParams();
        params.set('text', v.text);
        params.set('languageCode', v.lang);
        params.set('voiceName', v.voice);
        return fetch(getTtsServiceUrl() + '/tts/synthesize?' + params.toString(), {
            method: 'GET',
            credentials: 'omit',
            signal: signal
        })
            .then(parseTtsAudioFetch)
            .then(blobFromAudioBuffer);
    }
    */

    function formatDuration(len) {
        var sec = Math.max(0, Math.round(len / 5));
        return sec >= 60 ? (Math.floor(sec / 60) + '분 ' + (sec % 60) + '초') : (sec + '초');
    }

    function updateMeta() {
        var len = $('ttsText').value.length;
        $('charCount').textContent = len;
        $('estDuration').textContent = formatDuration(len);
        var meta = $('editorMeta');
        meta.classList.remove('warn', 'over');
        if (len > CHAR_MAX) meta.classList.add('over');
        else if (len > CHAR_RECOMMEND) meta.classList.add('warn');
        updateBroadcastActionButtons();
    }

    function updateBroadcastActionButtons() {
        if (broadcastActive) return;
        var audio = $('playerAudio');
        var hasPlayerAudio = !!(audio && audio.src);
        var mainBtn = $('broadcastBtn');
        if (mainBtn) mainBtn.disabled = !hasPlayerAudio;
    }

    function setComposeLoading(on) {
        $('composeLoading').hidden = !on;
        $('convertBtn').disabled = on;
        // var dockerBtn = $('convertDockerBtn');
        // if (dockerBtn) dockerBtn.disabled = on;
        $('previewBtn').disabled = on;
        $('clearBtn').disabled = on;
        if (on) {
            if ($('broadcastBtn')) $('broadcastBtn').disabled = true;
        } else {
            updateBroadcastActionButtons();
        }
        document.querySelectorAll('#broadcastPage [data-template], #areaSelectTrigger, #areaSelectPanel input, #voiceSelectTrigger, #voiceSelectPanel [data-voice]')
            .forEach(function (el) { el.disabled = on; });
        if (on) closeSelectPanels();
    }

    function setPreviewState(on) {
        var btn = $('previewBtn');
        if (!btn) return;
        previewActive = !!on;
        if (on) {
            btn.classList.add('listening');
            btn.disabled = false;
            btn.setAttribute('aria-label', '정지');
            btn.innerHTML = '<span class="material-symbols-rounded">stop</span>정지';
        } else {
            btn.classList.remove('listening');
            btn.setAttribute('aria-label', '미리듣기');
            btn.innerHTML = PREVIEW_BTN_HTML;
        }
    }

    function setPreviewLoading(on) {
        var btn = $('previewBtn');
        if (!btn) return;
        if (on) {
            btn.disabled = true;
            btn.classList.remove('listening');
            btn.setAttribute('aria-label', '변환 중');
            btn.innerHTML = '<span class="material-symbols-rounded">hourglass_empty</span>변환중';
        } else if (!previewActive) {
            btn.disabled = false;
            btn.setAttribute('aria-label', '미리듣기');
            btn.innerHTML = PREVIEW_BTN_HTML;
        }
    }

    function stopPreview() {
        previewToken += 1;
        previewActive = false;
        if (previewFetchAbort) {
            previewFetchAbort.abort();
            previewFetchAbort = null;
        }
        setPreviewState(false);
        clearAudioElement($('previewAudio'), '_bcPreviewUrl');
    }

    function startPreviewPlayback(blob) {
        var audio = $('previewAudio');
        if (!audio) return;
        pauseAllBroadcastAudio(audio);
        if (!attachBlobToAudio(audio, blob, '_bcPreviewUrl')) {
            toast({ title: '미리듣기 실패', message: '음성 데이터가 없습니다.', type: 'error' });
            return;
        }
        audio.preload = 'auto';

        audio.addEventListener('ended', function () {
            stopPreview();
        }, { once: true });
        audio.addEventListener('error', function () {
            stopPreview();
            toast({
                title: '미리듣기 실패',
                message: '음성을 재생할 수 없습니다.',
                type: 'error'
            });
        }, { once: true });

        var playPromise = audio.play();
        if (playPromise && typeof playPromise.then === 'function') {
            playPromise.then(function () {
                setPreviewState(true);
            }).catch(function (err) {
                console.warn('preview play failed', err);
                stopPreview();
                toast({
                    title: '미리듣기',
                    message: '자동 재생이 제한되었습니다. 다시 시도해 주세요.',
                    type: 'info',
                    duration: 4000
                });
            });
        } else {
            setPreviewState(true);
        }
    }

    function togglePreview() {
        if (previewActive) {
            stopPreview();
            return;
        }

        var v = getFormValues();
        if (!v.text) {
            toast({ title: '입력 필요', message: '미리 들을 문구를 입력해주세요.', type: 'warning' });
            return;
        }
        if (v.text.length > CHAR_MAX) {
            toast({
                title: '문구가 너무 깁니다',
                message: '방송 문구는 ' + CHAR_MAX + '자 이하로 작성해주세요.',
                type: 'warning',
                duration: 4500
            });
            return;
        }

        stopPreview();
        var ac = new AbortController();
        previewFetchAbort = ac;
        var token = previewToken;
        setPreviewLoading(true);

        synthesizeTtsRequest(v, ac.signal)
            .then(function (result) {
                if (token !== previewToken) return;
                startPreviewPlayback(result.blob);
            })
            .catch(function (e) {
                if (e && e.name === 'AbortError') return;
                console.error(e);
                var msg = getTtsErrorMessage(e);
                if (msg) {
                    toast({ title: '미리듣기 실패', message: msg, type: 'error', duration: 5000 });
                }
            })
            .finally(function () {
                previewFetchAbort = null;
                setPreviewLoading(false);
            });
    }

    function setPlayerControlsEnabled(enabled) {
        var playBtn = $('playerToggleBtn');
        var resetBtn = $('playerResetBtn');
        var downloadBtn = $('playerDownloadBtn');
        if (playBtn) playBtn.disabled = !enabled;
        if (resetBtn) resetBtn.disabled = !enabled;
        if (downloadBtn) downloadBtn.disabled = !enabled;
        updateBroadcastActionButtons();
    }

    function setBroadcastButtonState(disabled, broadcasting) {
        var btn = $('broadcastBtn');
        if (!btn) return;
        btn.disabled = !!disabled;
        btn.classList.toggle('is-broadcasting', !!broadcasting);
    }

    function finishBroadcastSession() {
        clearBroadcastCompletionTimers();
        pendingBroadcastSession = null;
        broadcastActive = false;
        setBroadcastButtonState(false, false);
        updateBroadcastActionButtons();
    }

    /* [송출 PC 로컬 재생 없음] 수신기(mngr_broadcast_receive)에서만 TTS 재생
    function startLocalBroadcastPlayback(audio) {
        ...
    }
    */

    function startBroadcast() {
        var audio = $('playerAudio');
        if (!audio || !audio.src || broadcastActive) return;

        var form = getFormValues();
        var targets = getSelectedDongTargets();
        if (!targets.length) {
            toast({
                title: '방송',
                message: '방송 구역(동)을 선택해 주세요.',
                type: 'error',
                duration: 3500
            });
            return;
        }

        stopPreview();
        pauseAllBroadcastAudio(audio);
        if (audio && !audio.paused) {
            audio.pause();
            updatePlayerToggle(false);
        }

        var broadcastId = createBroadcastId();
        broadcastActive = true;
        setBroadcastButtonState(true, true);
        ensureSenderAckSubscription();

        publishBroadcastViaWebSocket(form, targets, broadcastId).then(function (sent) {
            if (!sent) {
                cancelBroadcastSession();
                return;
            }

            if (!subscribeSenderAck()) {
                console.warn('[방송 송출] 완료 ACK 구독 실패 — userNo·웹소켓 확인');
            }

            var sendingToast = formatBroadcastSendingToast(targets);
            toast({
                title: sendingToast.title,
                message: sendingToast.message,
                type: 'info',
                duration: 5500
            });
            console.log('[방송 송출] 수신기만 재생 →', targets.map(function (t) {
                return t.dongLabel + '(' + t.dongNo + ')';
            }).join(', '), 'id=', broadcastId);
            beginBroadcastCompletionWait(broadcastId, targets, form);

            if (isBroadcastAllAreas(form)) {
                console.log('[방송 송출] 전체 — 관리사무소(송출 PC) 모니터 재생');
                startMgmtOfficeMonitorPlayback(audio);
            }
        });
    }

    function resetPlayerPlayback() {
        var audio = $('playerAudio');
        if (!audio || !audio.src) return;
        audio.pause();
        try {
            audio.currentTime = 0;
        } catch (ignore) { /* seek */ }
        var eq = $('eqBars');
        if (eq) eq.classList.remove('playing');
        updatePlayerToggle(false);
        updatePlayerTimeDisplay();
    }

    function hidePlayer() {
        finishBroadcastSession();
        currentPlayerRow = null;
        clearAudioElement($('playerAudio'), '_bcObjectUrl');
        updatePlayerToggle(false);
        updatePlayerTimeDisplay();
        setPlayerControlsEnabled(false);
        $('eqBars').classList.remove('playing');
        $('playerCard').style.display = 'none';
    }

    function pauseAllBroadcastAudio(exceptEl) {
        var main = $('playerAudio');
        if (main && main !== exceptEl && !main.paused) {
            main.pause();
            updatePlayerToggle(false);
        }
        var preview = $('previewAudio');
        if (preview && preview !== exceptEl && !preview.paused) {
            preview.pause();
            if (previewActive) stopPreview();
        }
    }

    function updatePlayerToggle(isPlaying) {
        var icon = $('playerToggleIcon');
        var btn = $('playerToggleBtn');
        if (!icon || !btn) return;
        icon.textContent = isPlaying ? 'pause' : 'play_arrow';
        btn.setAttribute('aria-label', isPlaying ? '테스트 일시정지' : '테스트 재생');
        btn.setAttribute('title', isPlaying
            ? '테스트 재생 일시정지 (이 PC만, 방송 아님)'
            : '송출 담당자 본인만 이 PC에서 들어보기 (방송 아님)');
    }

    function showPlayer(row, label, blob) {
        var audio = $('playerAudio');
        if (!audio || !row) return;

        setLastPlaybackBlob(blob);
        currentPlayerRow = row;
        $('playerLabel').textContent = label || '송출자 테스트 재생';
        $('playerText').textContent = row.text;
        pauseAllBroadcastAudio();

        var hasSource = attachBlobToAudio(audio, blob, '_bcObjectUrl');
        $('playerCard').style.display = 'block';
        updatePlayerToggle(false);
        updatePlayerTimeDisplay();

        if (!hasSource || !audio.src) {
            setPlayerControlsEnabled(false);
            toast({ title: '재생 불가', message: '음성 데이터가 없습니다. 변환을 다시 시도해 주세요.', type: 'error' });
            return;
        }

        setPlayerControlsEnabled(true);
        audio.preload = 'auto';
        watchAudioTiming(audio, updatePlayerTimeDisplay);

        audio.addEventListener('error', function () {
            updatePlayerToggle(false);
            setPlayerControlsEnabled(false);
            console.warn('playerAudio error', audio.error ? audio.error.code : 0);
            toast({
                title: '재생 불가',
                message: '음성 파일을 불러오지 못했습니다. 변환을 다시 시도해 주세요.',
                type: 'error'
            });
        }, { once: true });
    }

    function bindPlayerControls() {
        var audio = $('playerAudio');
        var toggle = $('playerToggleBtn');
        var resetBtn = $('playerResetBtn');
        var eq = $('eqBars');
        if (!audio || !toggle) return;

        if (resetBtn) {
            resetBtn.addEventListener('click', function (e) {
                e.preventDefault();
                e.stopPropagation();
                resetPlayerPlayback();
            });
        }

        var broadcastBtn = $('broadcastBtn');
        if (broadcastBtn) {
            broadcastBtn.addEventListener('click', function (e) {
                e.preventDefault();
                e.stopPropagation();
                if (broadcastBtn.disabled || broadcastActive) return;
                startBroadcast();
            });
        }

        var downloadBtn = $('playerDownloadBtn');
        if (downloadBtn) {
            downloadBtn.addEventListener('click', function (e) {
                e.preventDefault();
                e.stopPropagation();
                if (downloadBtn.disabled) return;
                downloadCurrentAudio();
            });
        }

        toggle.addEventListener('click', function (e) {
            e.preventDefault();
            e.stopPropagation();
            if (!audio.src) return;
            if (audio.paused) {
                pauseAllBroadcastAudio(audio);
                startPlayerPlayback(audio);
            } else {
                audio.pause();
            }
        });
        /* ▶ 재생: WebSocket·방송 송출과 무관 — 송출 담당자 로컬 확인만 */

        audio.addEventListener('play', function () {
            pauseAllBroadcastAudio(audio);
            if (eq) eq.classList.add('playing');
            updatePlayerToggle(true);
        });
        audio.addEventListener('pause', function () {
            if (eq) eq.classList.remove('playing');
            updatePlayerToggle(false);
        });
        audio.addEventListener('ended', function () {
            if (eq) eq.classList.remove('playing');
            updatePlayerToggle(false);
            try {
                audio.currentTime = 0;
            } catch (ignore) { /* ended */ }
            updatePlayerTimeDisplay();
        });
    }

    function switchSourceTab(tab) {
        document.querySelectorAll('#broadcastPage .source-tab').forEach(function (btn) {
            var on = btn.getAttribute('data-source-tab') === tab;
            btn.classList.toggle('active', on);
            btn.setAttribute('aria-selected', on ? 'true' : 'false');
        });
        document.querySelectorAll('#broadcastPage .source-panel').forEach(function (panel) {
            panel.classList.toggle('active', panel.getAttribute('data-panel') === tab);
        });
        var note = $('sourceNote');
        if (!note) return;
        if (tab === 'history') {
            note.hidden = false;
            note.textContent = SOURCE_NOTES.history;
        } else {
            note.hidden = false;
            note.textContent = SOURCE_NOTES[tab] || '';
        }
    }

    function renderDummyPanel(type, items) {
        var panel = $('panel' + (type === 'check' ? 'Check' : 'Complaint'));
        if (!panel) return;
        panel.innerHTML = '<div class="source-list">' + items.map(function (item) {
            return '<button type="button" class="source-item" data-source-type="' + type + '" data-source-id="' + item.id + '">'
                + '<div class="source-item-title">' + escapeHtml(item.title) + '</div>'
                + '<div class="source-item-meta">' + escapeHtml(item.meta) + '</div>'
                + '<span class="source-item-badge' + (item.badgeClass ? ' ' + item.badgeClass : '') + '">'
                + escapeHtml(item.badge) + '</span></button>';
        }).join('') + '</div>';
    }

    function applySourceDraft(type, id) {
        var dummies = getDummySources();
        var list = dummies[type] || [];
        var item = list.filter(function (r) { return r.id === id; })[0];
        if (!item) return;

        selectedSourceId = type + ':' + id;
        document.querySelectorAll('#broadcastPage .source-item[data-source-type]').forEach(function (el) {
            el.classList.toggle('selected', el.getAttribute('data-source-id') === id
                && el.getAttribute('data-source-type') === type);
        });

        $('ttsText').value = item.draft;
        selectAreas(item.areas);
        updateMeta();
        $('ttsText').focus();
    }

    function initDummySources() {
        var dummies = getDummySources();
        renderDummyPanel('check', dummies.check);
        renderDummyPanel('complaint', dummies.complaint);
    }

    function renderHistory() {
        var list = $('historyList');
        var empty = $('historyEmpty');
        if (!historyRows.length) {
            list.innerHTML = '';
            list.style.display = 'none';
            empty.style.display = 'block';
            return;
        }
        empty.style.display = 'none';
        list.style.display = 'grid';
        list.innerHTML = historyRows.map(function (row, idx) {
            var title = row.text.length > 40 ? row.text.slice(0, 40) + '...' : row.text;
            return '<div class="history-item" data-idx="' + idx + '">'
                + '<div class="h-text"><div class="h-title">' + escapeHtml(title) + '</div>'
                + '<div class="h-meta">' + escapeHtml(row.area) + ' · ' + escapeHtml(row.createdAt) + '</div></div>'
                + '<div class="history-item-foot">'
                + '<div class="h-actions">'
                + '<button type="button" class="btnx btnx-ghost btnx-sm" data-action="reuse">불러오기</button>'
                + '<button type="button" class="btnx btnx-ghost btnx-sm h-btn-remove" data-action="remove">삭제</button>'
                + '</div></div></div>';
        }).join('');
    }

    function loadHistoryToComposer(row) {
        if (!row) return;
        stopPreview();
        $('ttsText').value = row.text || '';
        selectAreas(row.areas && row.areas.length ? row.areas : [row.area]);
        selectVoice(row.voice, row.voiceLabel);
        updateMeta();
        $('ttsText').focus();
        toast({
            title: '불러오기',
            message: '문구를 불러왔습니다. 재생은 음성 변환하기를 실행해 주세요.',
            type: 'info',
            duration: 3200
        });
    }

    function resetComposer() {
        stopPreview();
        selectedSourceId = '';
        document.querySelectorAll('#broadcastPage .source-item.selected').forEach(function (el) {
            el.classList.remove('selected');
        });
        $('ttsText').value = '';
        resetAreas();
        selectVoice(DEFAULT_RESET_VOICE);
        updateMeta();
        $('ttsText').focus();
    }

    async function onClearClick() {
        if ($('ttsText').value.trim()) {
            const resetConfirm = await showConfirm({ title: '작성 중인 문구를 초기화할까요?' });
            if (!resetConfirm.isConfirmed) return;
        }
        resetComposer();
    }

    function convertTts() {
        runTtsConvert({
            requestFn: synthesizeTtsRequest,
            getErrorMessage: getTtsErrorMessage,
            playerLabel: '최근 변환 음성',
            successTitle: '변환 완료',
            successMessage: '음성이 생성되었습니다.',
            failTitle: '변환 실패',
            convertBtnId: 'convertBtn',
            convertBtnHtml: CONVERT_BTN_HTML
        });
    }

    /* [도커 TTS 미사용]
    function convertTtsDocker() {
        runTtsConvert({
            requestFn: synthesizeTtsDockerRequest,
            getErrorMessage: getTtsDockerErrorMessage,
            playerLabel: '도커 변환 음성',
            successTitle: '도커 변환 완료',
            successMessage: 'TTS 도커(8060)에서 음성을 생성했습니다.',
            failTitle: '도커 변환 실패',
            convertBtnId: 'convertDockerBtn',
            convertBtnHtml: CONVERT_DOCKER_BTN_HTML
        });
    }
    */

    function runTtsConvert(opts) {
        var v = getFormValues();
        if (!v.text) {
            toast({ title: '입력 필요', message: '변환할 문구를 입력해주세요.', type: 'warning' });
            return;
        }
        if (v.text.length > CHAR_MAX) {
            toast({
                title: '문구가 너무 깁니다',
                message: '방송 문구는 ' + CHAR_MAX + '자 이하로 작성해주세요.',
                type: 'warning',
                duration: 4500
            });
            return;
        }

        stopPreview();
        setComposeLoading(true);
        opts.requestFn(v)
            .then(function (result) {
                var row = normalizeHistoryRow({
                    text: v.text,
                    voice: v.voice,
                    areas: v.areas,
                    area: v.area,
                    voiceLabel: v.voiceLabel,
                    createdAt: nowKST()
                });
                historyRows.unshift(row);
                if (historyRows.length > HISTORY_MAX) historyRows.length = HISTORY_MAX;
                saveHistory();
                renderHistory();
                showPlayer(row, opts.playerLabel, result.blob);
                switchSourceTab('history');
                toast({
                    title: opts.successTitle,
                    message: opts.successMessage,
                    type: 'success',
                    duration: 3200
                });
            })
            .catch(function (e) {
                console.error(e);
                var msg = opts.getErrorMessage(e);
                if (msg) {
                    toast({
                        title: opts.failTitle,
                        message: msg,
                        type: 'error',
                        duration: 5000
                    });
                }
            })
            .finally(function () {
                setComposeLoading(false);
                var btn = $(opts.convertBtnId);
                if (btn) btn.innerHTML = opts.convertBtnHtml;
            });
    }

    function bindEvents() {
        $('convertBtn').addEventListener('click', convertTts);
        // $('convertDockerBtn').addEventListener('click', convertTtsDocker);
        $('clearBtn').addEventListener('click', onClearClick);
        $('previewBtn').addEventListener('click', togglePreview);
        $('ttsText').addEventListener('input', updateMeta);

        $('clearHistoryBtn').addEventListener('click', async function () {
            if (!historyRows.length) return;
            const clearConfirm = await showConfirm({ title: '저장된 변환 이력을 모두 비울까요?' });
            if (!clearConfirm.isConfirmed) return;
            historyRows = [];
            saveHistory();
            renderHistory();
            hidePlayer();
            lastPlaybackBlob = null;
        });

        document.querySelectorAll('#broadcastPage .source-tab').forEach(function (btn) {
            btn.addEventListener('click', function () {
                switchSourceTab(btn.getAttribute('data-source-tab'));
            });
        });

        document.getElementById('broadcastPage').addEventListener('click', function (e) {
            var sourceBtn = e.target.closest('.source-item[data-source-type]');
            if (sourceBtn) {
                applySourceDraft(
                    sourceBtn.getAttribute('data-source-type'),
                    sourceBtn.getAttribute('data-source-id')
                );
                return;
            }
            var tplBtn = e.target.closest('[data-template]');
            if (tplBtn) {
                selectedSourceId = '';
                document.querySelectorAll('#broadcastPage .source-item.selected').forEach(function (el) {
                    el.classList.remove('selected');
                });
                $('ttsText').value = tplBtn.getAttribute('data-template') || '';
                $('ttsText').focus();
                updateMeta();
            }
        });

        $('historyList').addEventListener('click', function (e) {
            var btn = e.target.closest('button[data-action]');
            if (!btn) return;
            var item = btn.closest('[data-idx]');
            if (!item) return;
            var idx = Number(item.getAttribute('data-idx'));
            if (!Number.isFinite(idx) || !historyRows[idx]) return;

            if (btn.getAttribute('data-action') === 'reuse') {
                loadHistoryToComposer(historyRows[idx]);
                return;
            }
            if (btn.getAttribute('data-action') === 'remove') {
                historyRows.splice(idx, 1);
                saveHistory();
                renderHistory();
                if (!historyRows.length) hidePlayer();
            }
        });

        bindPlayerControls();
    }

    function init() {
        loadHistory();
        initDummySources();
        bindAreaSelect();
        bindVoiceSelect();
        switchSourceTab('check');
        bindEvents();
        updateMeta();
        updateAreaLabel();
        renderHistory();
        ensureSenderAckSubscription();
    }

    var pageBooted = false;

    function bootBroadcastPage() {
        if (pageBooted) return;
        pageBooted = true;
        init();
    }

    document.addEventListener('DOMContentLoaded', bootBroadcastPage);
    if (document.readyState !== 'loading') {
        setTimeout(bootBroadcastPage, 0);
    }
})();
