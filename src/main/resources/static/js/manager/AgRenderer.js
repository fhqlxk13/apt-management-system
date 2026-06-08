/**
 * ============================================================
 * AgRenderer.js
 * 관리사무소 AG Grid 공통 셀 렌더러 모음
 *
 * 배포 위치: /js/manager/AgRenderer.js
 *
 * 로드 순서 (JSP head):
 *   <script src=".../js/manager/ag-grid-community.min.js"></script>
 *   <script src=".../js/manager/manager-common.js"></script>
 *   <script src=".../js/manager/manager-agGrid.js"></script>
 *   <script src=".../js/manager/AgRenderer.js"></script>   ← 여기 추가
 *   ... 화면별 grid js ...
 *   ... 화면별 js ...
 * ============================================================
 */

var AgRenderer = (function () {

    /* ─────────────────────────────────────────────
       내부 유틸
    ───────────────────────────────────────────── */
    function _safe(v)   { return v == null ? '' : String(v); }
    function _escape(v) {
        return _safe(v)
            .replace(/&/g,  '&amp;')
            .replace(/</g,  '&lt;')
            .replace(/>/g,  '&gt;')
            .replace(/"/g,  '&quot;')
            .replace(/'/g,  '&#39;');
    }
    function _badge(cls, text) {
        return '<span class="badge ' + cls + '">' + _escape(text) + '</span>';
    }
    function _fromMap(map, code) {
        var key   = _safe(code).toUpperCase();
        var entry = map[key] || map[_safe(code)];
        if (!entry) return _badge('badge-gray', _safe(code) || '-');
        return _badge(entry[0], entry[1]);
    }


    /* ─────────────────────────────────────────────
       공통코드 맵
       형식: { '코드값': ['badge-클래스', '표시텍스트'] }
    ───────────────────────────────────────────── */
    var CODE = {

        /* 입주상태 */
        MOVE_STTS: {
            IN:  ['badge-green',  '입주'],
            OUT: ['badge-gray',   '전출'],
            MID: ['badge-yellow', '이주중']
        },

        /* 세대구분 */
        HOUSEHOLD_TY: {
            HEAD: ['badge-blue', '세대주'],
            MBR:  ['badge-gray', '세대원']
        },

        /* 직무 */
        JOB_TY: {
            HEAD: ['badge-green',  '관리소장'],
            ACNT: ['badge-blue',   '회계담당'],
            ADM:  ['badge-purple', '행정담당'],
            FAC:  ['badge-orange', '시설담당']
        },

        /* 계정 신청 상태 */
        ACNT_RQST_STTS: {
            WAIT: ['badge-yellow', '승인대기'],
            OK:   ['badge-green',  '승인완료'],
            RJCT: ['badge-red',    '반려'],
            CNL:  ['badge-gray',   '신청취소']
        },

        /* 차량 유형 */
        VHC_TY: {
            GEN: ['badge-gray',   '일반'],
            WRK: ['badge-blue',   '업무/공사'],
            DLV: ['badge-yellow', '배달/택배'],
            MOV: ['badge-green',  '이사차량'],
            EMG: ['badge-red',    '긴급/공용']
        },

        /* 서류 제출 상태 */
        SUBMIT_DOC_STTS: {
            SUBMIT: ['badge-yellow', '승인대기'],
            APRV:   ['badge-green',  '승인완료'],
            REJT:   ['badge-red',    '반려'],
            REQ:    ['badge-gray',   '제출요청']
        },

        /* 시설 유형 */
        FACILITY_TY: {
            ELV:  ['badge-blue',   '승강기'],
            WTR:  ['badge-green',  '급수시설'],
            ELC:  ['badge-yellow', '전기시설'],
            GAS:  ['badge-orange', '가스시설'],
            FIRE: ['badge-red',    '소방시설'],
            SEC:  ['badge-purple', '보안시설'],
            ETC:  ['badge-gray',   '기타시설']
        },

        /* 점검 상태 */
        CHECK_STTS: {
            WAIT:  ['badge-yellow', '점검대기'],
            ING:   ['badge-blue',   '점검중'],
            DONE:  ['badge-green',  '점검완료'],
            FAULT: ['badge-red',    '이상발견']
        },

        /* 점검 유형 */
        CHECK_TY: {
            REG:    ['badge-gray',   '정기점검'],
            SPC:    ['badge-blue',   '특별점검'],
            SAFE:   ['badge-green',  '안전점검'],
            REPAIR: ['badge-orange', '보수점검']
        },

        /* 계약 상태 */
        CONTRACT_STTS: {
            DRAFT:  ['badge-blue',   '작성중'],
            ACTIVE: ['badge-green',  '유효'],
            END:    ['badge-gray',   '종료'],
            TERM:   ['badge-red',    '해지']
        },

        /* 입찰 유형 */
        BID_TY: {
            GEN: ['badge-blue',   '일반경쟁입찰'],
            LIM: ['badge-purple', '제한경쟁입찰'],
            SEL: ['badge-orange', '지명경쟁입찰'],
            PRT: ['badge-gray',   '수의계약']
        },

        /* 작업 상태 */
        WRK_STTS: {
            WAIT: ['badge-yellow', '대기'],
            ING:  ['badge-blue',   '진행중'],
            DONE: ['badge-green',  '완료'],
            STOP: ['badge-red',    '중단']
        },

        /* 예약 상태 */
        RSVT_STTS: {
            REQ:     ['badge-yellow', '예약신청'],
            CONFIRM: ['badge-green',  '예약확정'],
            USE:     ['badge-blue',   '이용중'],
            DONE:    ['badge-gray',   '이용완료'],
            CANCEL:  ['badge-red',    '예약취소']
        },

        /* 방문 상태 */
        VISIT_ST: {
            REQ: ['badge-yellow', '신청'],
            APR: ['badge-green',  '승인'],
            RJC: ['badge-red',    '반려'],
            IN:  ['badge-blue',   '입차'],
            OUT: ['badge-gray',   '출차'],
            CNL: ['badge-red',    '취소']
        },

        /* 휴가 유형 */
        VAC_TY: {
            V_ANN:  ['badge-blue',   '연차'],
            V_HALF: ['badge-purple', '반차'],
            V_SICK: ['badge-red',    '병가'],
            V_OFF:  ['badge-yellow', '대체휴무'],
            V_ETC:  ['badge-gray',   '기타']
        },

        /* 일정 유형 */
        SCHEDULE_TY: {
            REPAIR: ['badge-yellow', '유지보수'],
            CHECK:  ['badge-blue',   '정기점검'],
            SAFE:   ['badge-green',  '안전점검'],
            CONST:  ['badge-purple', '공사']
        }
    };


    /* ─────────────────────────────────────────────
       user — 아바타 + 이름 + 보조텍스트
    ───────────────────────────────────────────── */
    function _renderUser(nm, sub) {
        return '<div class="avatar-row">'
            +   '<div class="avatar avatar-sm">' + _escape(nm ? nm.charAt(0) : '-') + '</div>'
            +   '<div class="avatar-info">'
            +     '<div class="name">' + _escape(_safe(nm)) + '</div>'
            +     (sub ? '<div class="sub">' + _escape(_safe(sub)) + '</div>' : '')
            +   '</div>'
            + '</div>';
    }

    /* 기본: data.userNm + data.telno */
    var user = function (params) {
        var d = params.data || {};
        return _renderUser(d.userNm, d.telno);
    };
    /* 커스텀 필드 지정 */
    user.by = function (nmField, subField) {
        return function (params) {
            var d = params.data || {};
            return _renderUser(d[nmField], d[subField]);
        };
    };


    /* ─────────────────────────────────────────────
       badge — 코드맵 기반 배지 팩토리
    ───────────────────────────────────────────── */
    function badge(map) {
        return function (params) { return _fromMap(map, params.value); };
    }


    /* ─────────────────────────────────────────────
       yn — Y/N 배지
    ───────────────────────────────────────────── */
    function yn(trueLabel, falseLabel) {
        var t = trueLabel  || '활성';
        var f = falseLabel || '비활성';
        return function (params) {
            var v = params.value;
            if (v === 'Y' || v === true  || v === 1) return _badge('badge-green', t);
            if (v === 'N' || v === false || v === 0) return _badge('badge-gray',  f);
            return _badge('badge-gray', '-');
        };
    }


    /* ─────────────────────────────────────────────
       date — 날짜 포맷
    ───────────────────────────────────────────── */
    var date = function (params) {
        if (!params.value) return '<span class="td-empty">-</span>';
        return '<span class="td-mono">' + String(params.value).replace('T', ' ').slice(0, 10) + '</span>';
    };
    date.short = function (params) {
        if (!params.value) return '<span class="td-empty">-</span>';
        return '<span class="td-mono">' + String(params.value).slice(5, 10) + '</span>';
    };
    date.datetime = function (params) {
        if (!params.value) return '<span class="td-empty">-</span>';
        return '<span class="td-mono">' + String(params.value).replace('T', ' ').slice(0, 16) + '</span>';
    };
    /* yyyy-MM-dd -> yy.MM.dd */
    date.dot = function (params) {
        if (!params.value) return '-';
        var s = String(params.value);
        if (s.length >= 10 && s.indexOf('-') > -1) {
            return s.slice(2, 10).replace(/-/g, '.');
        }
        if (s.length >= 10 && s.indexOf('.') > -1) {
            return s.slice(2, 10);
        }
        return s;
    };


    /* ─────────────────────────────────────────────
       money — 금액
    ───────────────────────────────────────────── */
    var money = function (params) {
        if (params.value == null || params.value === '') return '<span class="td-empty">-</span>';
        return '<span class="td-mono" style="display:block;text-align:right;">'
            + Number(params.value).toLocaleString() + '원</span>';
    };
    money.plain = function (params) {
        if (params.value == null || params.value === '') return '<span class="td-empty">-</span>';
        return '<span class="td-mono" style="display:block;text-align:right;">'
            + Number(params.value).toLocaleString() + '</span>';
    };


    /* ─────────────────────────────────────────────
       dday — 만료일 D-Day
    ───────────────────────────────────────────── */
    var dday = function (params) {
        if (!params.value) return '<span class="td-empty">-</span>';
        var diff = Math.ceil((new Date(params.value) - new Date()) / 86400000);
        if (diff < 0)   return _badge('badge-gray',   '만료');
        if (diff === 0) return _badge('badge-red',    'D-Day');
        if (diff <= 30) return _badge('badge-red',    'D-' + diff);
        if (diff <= 90) return _badge('badge-yellow', 'D-' + diff);
        return '<span class="td-mono td-empty">D-' + diff + '</span>';
    };


    /* ─────────────────────────────────────────────
       text — 말줄임 + tooltip
    ───────────────────────────────────────────── */
    var text = function (params) {
        var v = _escape(_safe(params.value) || '-');
        return '<span title="' + v
            + '" style="display:block;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;">'
            + v + '</span>';
    };


    /* ─────────────────────────────────────────────
       number — 숫자 우측 정렬
    ───────────────────────────────────────────── */
    var number = function (params) {
        if (params.value == null || params.value === '') return '<span class="td-empty">-</span>';
        return '<span class="td-mono" style="display:block;text-align:right;">'
            + Number(params.value).toLocaleString() + '</span>';
    };


    /* ─────────────────────────────────────────────
       actions — 버튼 셀 팩토리

       문자열 배열:
         AgRenderer.actions(['상세', '수정', '삭제'])

       객체 배열 (직접 지정):
         AgRenderer.actions([
           { label:'승인', action:'approve', cls:'btn-edit'   },
           { label:'반려', action:'reject',  cls:'btn-delete' }
         ])
    ───────────────────────────────────────────── */
    var _ACTION_MAP = {
        '상세': { action: 'detail',   cls: 'btn-detail' },
        '수정': { action: 'edit',     cls: 'btn-edit'   },
        '삭제': { action: 'delete',   cls: 'btn-delete' },
        '취소': { action: 'cancel',   cls: 'btn-delete' },
        '승인': { action: 'approve',  cls: 'btn-edit'   },
        '반려': { action: 'reject',   cls: 'btn-delete' },
        '등록': { action: 'register', cls: 'btn-edit'   }
    };
    // 수정 - 필드의 키값 들어갈 버튼 설정
    function actions(btns, keyField) {
        var resolved = btns.map(function (b) {
            if (typeof b === 'string') {
                var def = _ACTION_MAP[b] || { action: b, cls: 'btn-detail' };
                return { label: b, action: def.action, cls: def.cls };
            }
            return b;
        });

        return function (params) {
            var d = params.data || {};
            var rowKey = keyField ? d[keyField] : params.value;

            return '<div class="grid-actions">'
                + resolved.map(function (b) {
                    var disabled = typeof b.disabledWhen === 'function' && b.disabledWhen(d);
                    var disabledClass = disabled ? ' is-disabled' : '';

                    return '<button type="button" class="btn btn-xs ' + b.cls + disabledClass
                        + '" data-action="' + b.action + '"'
                        + ' data-row-key="' + _escape(rowKey) + '">'
                        + _escape(b.label)
                        + '</button>';
                }).join('')
                + '</div>';
        };
    }


    return { CODE: CODE, user: user, badge: badge, yn: yn, date: date,
        money: money, dday: dday, text: text, number: number, actions: actions };

})();
