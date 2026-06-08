<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="_csrf" content="${_csrf.token}">
    <meta name="_csrf_header" content="${_csrf.headerName}">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${facility.cmnFacilityNm} 예약</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/headerStyle.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebarStyle.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footerStyle.css">

    <style>
        body {
            font-family: 'Noto Sans KR', sans-serif !important;
            background: var(--bg);
            color: var(--text-dark);
            margin: 0;
        }

        .main-shell {
            display: flex;
            align-items: stretch;
            width: 100%;
            min-height: calc(100vh - 114px);
            margin-top: 114px;
            background: var(--bg);
        }

        .content-area {
            flex: 1;
            min-width: 0;
            padding: 32px 40px 64px;
        }

        .page-content-wrap {
            max-width: 1080px;
            width: 100%;
            margin: 0 auto;
        }

        .breadcrumb {
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 12px;
            color: var(--text-light);
            margin-bottom: 18px;
        }

        .breadcrumb a {
            color: var(--text-light);
            text-decoration: none;
        }

        .breadcrumb .cur {
            color: var(--green-dark);
            font-weight: 700;
        }

        .page-title {
            font-size: 22px;
            font-weight: 800;
            color: var(--text-dark);
            padding-bottom: 14px;
            border-bottom: 2px solid var(--green-dark);
            margin-bottom: 16px;
        }

        .reserve-top-card,
        .seat-map-card,
        .reservation-card {
            background: #ffffff;
            border: 1px solid var(--border);
            border-radius: 14px;
            box-shadow: 0 10px 24px rgba(30, 60, 40, 0.05);
        }

        .reserve-top-card {
            padding: 20px 24px;
            margin-bottom: 18px;
        }

        .reserve-title {
            font-size: 20px;
            font-weight: 800;
            color: var(--text-dark);
            margin-bottom: 8px;
        }

        .reserve-desc {
            font-size: 13px;
            color: var(--text-light);
            line-height: 1.7;
        }

        .reserve-layout {
            display: grid;
            grid-template-columns: 330px 1fr;
            gap: 16px;
        }

        .seat-map-card,
        .reservation-card {
            overflow: hidden;
        }

        .card-head {
            padding: 18px 20px;
            border-bottom: 1px solid var(--border);
        }

        .card-title {
            font-size: 16px;
            font-weight: 800;
            color: var(--text-dark);
        }

        .card-desc {
            margin-top: 4px;
            font-size: 12px;
            color: var(--text-light);
        }

        .seat-map-body {
            padding: 16px;
            max-height: 560px;
            overflow-y: auto;
        }

        .seat-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 8px;
        }

        .seat-btn {
            height: 38px;
            border-radius: 10px;
            border: 1px solid #c8d8ce;
            background: #eef7f0;
            color: var(--green-dark);
            font-weight: 800;
            cursor: pointer;
        }

        .seat-btn.selected {
            background: var(--green-dark);
            border-color: var(--green-dark);
            color: #ffffff;
        }

        .seat-btn.disabled {
            border-color: #d1d5db;
            background: #e5e7eb;
            color: #6b7280;
            cursor: not-allowed;
        }

        .seat-btn.reserved {
            border-color: #fca5a5;
            background: #fee2e2;
            color: #b91c1c;
            cursor: not-allowed;
        }

        .reservation-card-body {
            padding: 22px;
        }

        .form-row {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 12px;
            margin-bottom: 16px;
        }

        .form-field label {
            display: block;
            font-size: 13px;
            font-weight: 800;
            color: #374151;
            margin-bottom: 6px;
        }

        .form-field input,
        .form-field textarea {
            width: 100%;
            border: 1px solid #d1d5db;
            border-radius: 10px;
            padding: 10px 12px;
            font-size: 14px;
            box-sizing: border-box;
        }

        .form-field textarea {
            min-height: 100px;
            resize: vertical;
        }

        .selected-box {
            padding: 14px;
            border-radius: 12px;
            background: #f0f8f2;
            border: 1px solid #c8e2cf;
            color: var(--green-dark);
            font-weight: 800;
            margin-bottom: 16px;
        }

        .btn-area {
            display: flex;
            justify-content: flex-end;
            gap: 8px;
            margin-top: 18px;
        }

        .btn {
            height: 40px;
            border-radius: 999px;
            padding: 0 20px;
            font-weight: 800;
            cursor: pointer;
            border: none;
        }

        .btn-primary {
            background: #006b4f;
            color: #ffffff;
        }

        .btn-light {
            background: #66758d;
            color: #ffffff;
        }

        @media (max-width: 900px) {
            .main-shell {
                flex-direction: column;
            }

            .content-area {
                padding: 24px 18px 48px;
            }

            .reserve-layout {
                grid-template-columns: 1fr;
            }

            .form-row {
                grid-template-columns: 1fr;
            }
        }

        .time-table-card {
            margin-top: 16px;
            background: #fff;
            border: 1px solid var(--border);
            border-radius: 14px;
            overflow: hidden;
        }

        .pf-time-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 14px;
        }

        .pf-time-table th {
            padding: 14px;
            border-bottom: 2px solid #0074d9;
            text-align: center;
            font-weight: 800;
        }

        .pf-time-table td {
            padding: 13px;
            border-bottom: 1px solid #ddd;
            text-align: center;
        }

        .time-available {
            color: #006b4f;
            font-weight: 800;
            cursor: pointer;
        }

        .time-reserved {
            color: #444;
        }

        .reservation-body{
            display:flex;
            gap:24px;
            margin-top:20px;
        }

        .time-panel{
            width:320px;
            background:#fff;
            border:1px solid #ddd;
            border-radius:14px;
            padding:20px;
        }

        .seat-panel{
            flex:1;
            background:#fff;
            border:1px solid #ddd;
            border-radius:14px;
            padding:20px;
        }

        .time-slot-list{
            margin-top:20px;
            display:flex;
            flex-direction:column;
            gap:10px;
        }

        .time-slot-btn{
            border:none;
            border-radius:10px;
            padding:12px;
            font-weight:700;
            cursor:pointer;
            background:#eef7f0;
            color:#006b4f;
        }

        .time-slot-btn.selected{
            background:#006b4f;
            color:#fff;
        }

        .empty-text{
            color:#777;
            font-size:14px;
        }

        .seat-grid{
            display:grid;
            grid-template-columns:repeat(4,1fr);
            gap:10px;
            margin-top:18px;
            margin-bottom:20px;
        }

        .purpose-textarea{
            width:100%;
            min-height:120px;
            border:1px solid #d1d5db;
            border-radius:10px;
            padding:12px;
            resize:none;
            box-sizing:border-box;
        }

        .reserve-btn{
            width:100%;
            height:46px;
            border:none;
            border-radius:12px;
            background:#006b4f;
            color:#fff;
            font-weight:800;
            margin-top:18px;
            cursor:pointer;
        }

        .reserve-btn:disabled{
            background:#cbd5d1;
            cursor:not-allowed;
        }

        .seat-btn.reserved,
        .seat-btn:disabled {
            border-color: #d1d5db;
            background: #e5e7eb;
            color: #6b7280;
            cursor: not-allowed;
        }

        .time-panel{
            width:320px;
            background:#fff;
            border:1px solid #ddd;
            border-radius:14px;
            padding:20px;
            max-height:520px;
            overflow:hidden;
        }

        .time-slot-list{
            margin-top:20px;
            display:flex;
            flex-direction:column;
            gap:10px;

            /* 시간 버튼이 많아질 때 이 영역만 스크롤 */
            max-height:390px;
            overflow-y:auto;
            padding-right:6px;
        }

        .time-slot-btn.past,
        .time-slot-btn:disabled {
            background: #e5e7eb !important;
            color: #9ca3af !important;
            cursor: not-allowed !important;
        }

        .time-slot-btn.past:hover {
            transform: none;
        }

        /*
         * [추가] 점검 이용제한 시간대 표시
         * 왜 추가? 시설 점검으로 예약할 수 없는 시간대를 일반 예약가능 버튼과 구분하기 위해 사용합니다.
         */
        .time-slot-btn.restricted {
            background: #fee2e2 !important;
            color: #b91c1c !important;
            cursor: not-allowed !important;
        }
    </style>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
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
                <a href="javascript:void(0);">생활지원서비스</a>
                <span>›</span>
                <a href="${pageContext.request.contextPath}/resident/publicFacility/reservation/${aptCmplexNo}">
                    편의시설예약
                </a>
                <span>›</span>
                <span class="cur">${facility.cmnFacilityNm} 예약</span>
            </div>

            <h1 class="page-title">${facility.cmnFacilityNm} 예약</h1>

            <div class="reserve-top-card">
                <div class="reserve-title">${facility.cmnFacilityNm} 예약</div>
                <div class="reserve-desc">
                    ${facility.cmnFacilityNm}의 예약 가능한 자원을 선택한 뒤 예약 시간을 입력하세요.
                </div>
            </div>

            <div class="reservation-body">

                <!-- 왼쪽: 시간대 목록 -->
                <div class="time-panel">

                    <h3>이용시간 선택</h3>

                    <input type="date" id="rsvtDt" name="rsvtDt" />

                    <div id="timeSlotList" class="time-slot-list">
                        <p class="empty-text">
                            예약일을 선택하면 시간대가 표시됩니다.
                        </p>
                    </div>
                </div>

                <!-- 오른쪽: 좌석 선택 -->
                <div class="seat-panel">

                    <h3>예약대상 선택</h3>

                    <div id="selectedTimeInfo" class="selected-box">
                        선택된 시간대가 없습니다.
                    </div>

                    <div id="seatGrid" class="seat-grid">

                        <c:forEach var="item" items="${itemList}">
                            <button type="button"
                                    class="seat-btn
                        ${item.cmnFacilitySttsCd ne 'OPEN' ? 'disabled' : ''}"
                                    data-item-no="${item.cmnFacilityItemNo}"
                                    data-item-nm="${item.itemNm}"
                                ${item.cmnFacilitySttsCd ne 'OPEN' ? 'disabled' : ''}>
                                    ${item.itemNm}
                            </button>
                        </c:forEach>

                    </div>

                    <label class="form-label">이용 목적</label>

                    <textarea id="purposeCn"
                              name="purposeCn"
                              class="purpose-textarea"
                              placeholder="이용 목적을 입력하세요."></textarea>

                    <button type="button"
                            id="reserveBtn"
                            class="reserve-btn"
                            disabled>
                        예약 신청
                    </button>

                </div>
            </div>

        </div>
    </main>
</div>

<%@ include file="/WEB-INF/views/include/apt_footerLayout.jsp" %>

<script>
    const contextPath = '${pageContext.request.contextPath}';

    const rsvtDtInput = document.getElementById('rsvtDt');

    /*
     * 오늘 이전 날짜 선택 방지
     * min이란? input date에서 선택 가능한 최소 날짜입니다.
     */
    const today = new Date();
    const todayText = today.toISOString().slice(0, 10);
    rsvtDtInput.min = todayText;

    /*
     * cmnFacilityNo란?
     * 공용시설 번호입니다.
     * 예: 독서실, 헬스장, 주민회의실 같은 시설을 구분하는 값입니다.
     *
     * 왜 이렇게 처리?
     * JSP model 값이 비어 있으면 Ajax URL에 //가 생기기 때문에,
     * 현재 브라우저 URL에서 마지막 값을 직접 꺼내서 사용합니다.
     */
    let cmnFacilityNo = '${cmnFacilityNo}';

    if (!cmnFacilityNo || cmnFacilityNo.trim() === '') {
        const pathArr = location.pathname.split('/');
        cmnFacilityNo = pathArr[pathArr.length - 1];
    }
    const cmnFacilityNm = '${facility.cmnFacilityNm}';

    const timeSlotList = document.getElementById('timeSlotList');
    const selectedTimeInfo = document.getElementById('selectedTimeInfo');
    const purposeCn = document.getElementById('purposeCn');
    const reserveBtn = document.getElementById('reserveBtn');

    let selectedStartDttm = '';
    let selectedEndDttm = '';
    let selectedItemNo = '';

    /*
     * Ajax란?
     * 화면 전체 새로고침 없이 서버에서 필요한 데이터만 가져오는 방식.
     * 여기서는 날짜 선택 시 시간대만 가져오기 위해 사용.
     */
    function loadTimeSlotsByDate() {
        const rsvtDt = rsvtDtInput.value;

        selectedStartDttm = '';
        selectedEndDttm = '';
        selectedItemNo = '';
        reserveBtn.disabled = true;

        selectedTimeInfo.innerText = '선택된 시간대가 없습니다.';

        document.querySelectorAll('.seat-btn').forEach(btn => {
            btn.classList.remove('selected', 'reserved');

            if (btn.classList.contains('disabled')) {
                btn.disabled = true;
            } else {
                btn.disabled = false;
            }
        });

        if (!rsvtDt) {
            timeSlotList.innerHTML = '<p class="empty-text">예약일을 선택하면 시간대가 표시됩니다.</p>';
            return;
        }

        if (!cmnFacilityNo || cmnFacilityNo.trim() === '') {
            timeSlotList.innerHTML = '<p class="empty-text">시설번호가 없어 시간대를 조회할 수 없습니다.</p>';
            return;
        }

        fetch(contextPath + '/resident/publicFacility/reservation/' + cmnFacilityNo
            + '/time-slots?searchStartDt=' + encodeURIComponent(rsvtDt))
            .then(response => response.json())
            .then(list => {
                timeSlotList.innerHTML = '';

                if (!list || list.length === 0) {
                    timeSlotList.innerHTML = '<p class="empty-text">예약 가능한 시간대가 없습니다.</p>';
                    return;
                }

                list.forEach(slot => {
                    const btn = document.createElement('button');

                    btn.type = 'button';
                    btn.className = 'time-slot-btn';
                    btn.innerText = slot.timeLabel;

                    /*
                     * 지나간 시간대 비활성화 기준
                     * 예약 시작 시간이 현재 시간보다 같거나 이전이면 선택 불가
                     */
                    const now = new Date();
                    const slotStartDate = new Date(slot.rsvtBgngDttm.replace(' ', 'T'));

                    if (slotStartDate <= now) {
                        btn.classList.add('past');
                        btn.disabled = true;
                        btn.innerText = slot.timeLabel + ' / 지난 시간';
                    } else if (slot.rsvtSttsNm === '점검중') {
                        /*
                         * [추가] 점검 이용제한 시간대 선택 차단
                         * 왜 추가? 서버 시간표 조회에서 점검중으로 내려온 시간대는 선택되지 않게 처리합니다.
                         */
                        btn.classList.add('restricted');
                        btn.disabled = true;
                        btn.title = '점검중인 시간대입니다.';
                        btn.innerText = slot.timeLabel + ' / 점검중';
                    } else {
                        btn.addEventListener('click', function () {
                            document.querySelectorAll('.time-slot-btn').forEach(other => {
                                other.classList.remove('selected');
                            });

                            btn.classList.add('selected');

                            selectedStartDttm = slot.rsvtBgngDttm;
                            selectedEndDttm = slot.rsvtEndDttm;
                            selectedItemNo = '';

                            selectedTimeInfo.innerText = '선택 시간: ' + slot.timeLabel;

                            loadReservedSeats();
                            checkReserveButton();
                        });
                    }

                    timeSlotList.appendChild(btn);
                });
            })
            .catch(error => {
                console.error(error);
                timeSlotList.innerHTML = '<p class="empty-text">시간대 조회 중 오류가 발생했습니다.</p>';
            });
    }

    /*
     * 선택한 시간대에 이미 예약된 좌석 조회
     * 예약된 좌석은 회색 비활성화 처리.
     */
    function loadReservedSeats() {
        fetch(contextPath + '/resident/publicFacility/reservation/' + cmnFacilityNo
            + '/reserved-items?rsvtBgngDttm=' + encodeURIComponent(selectedStartDttm)
            + '&rsvtEndDttm=' + encodeURIComponent(selectedEndDttm))
            .then(response => response.json())
            .then(list => {
                const reservedList = list.map(itemNo => String(itemNo));

                document.querySelectorAll('.seat-btn').forEach(btn => {
                    btn.classList.remove('selected', 'reserved');

                    /*
                     * disabled 클래스가 있는 좌석은 시설 자체가 사용불가인 좌석입니다.
                     * 예약 여부와 관계없이 계속 비활성화합니다.
                     */
                    if (btn.classList.contains('disabled')) {
                        btn.disabled = true;
                        return;
                    } else {
                        btn.disabled = false;
                    }

                    if (reservedList.includes(String(btn.dataset.itemNo))) {
                        btn.classList.add('reserved');
                        btn.disabled = true;
                    }
                });
            });
    }

    /*
     * 좌석 선택
     */
    document.querySelectorAll('.seat-btn').forEach(btn => {
        btn.addEventListener('click', function () {
            if (!selectedStartDttm || !selectedEndDttm) {
                Swal.fire({
                    icon: 'warning',
                    title: '이용시간 선택 필요',
                    text: '먼저 이용시간을 선택하세요.',
                    confirmButtonText: '확인'
                });
                return;
            }

            if (btn.disabled || btn.classList.contains('reserved')) {
                return;
            }

            document.querySelectorAll('.seat-btn').forEach(other => {
                other.classList.remove('selected');
            });

            btn.classList.add('selected');
            selectedItemNo = btn.dataset.itemNo;

            const selectedTimeBtn = document.querySelector('.time-slot-btn.selected');

            selectedTimeInfo.innerText =
                '선택 시간: ' + selectedTimeBtn.innerText
                + ' / 선택 좌석: ' + btn.dataset.itemNm;

            checkReserveButton();
        });
    });

    /*
     * 날짜 + 시간 + 좌석 + 이용목적이 모두 있어야 예약신청 버튼 활성화.
     */
    function checkReserveButton() {
        reserveBtn.disabled = !(
            rsvtDtInput.value &&
            selectedStartDttm &&
            selectedEndDttm &&
            selectedItemNo &&
            purposeCn.value.trim()
        );
    }

    /*
     * 예약 신청
     */
    reserveBtn.addEventListener('click', function () {
        if (reserveBtn.disabled) {
            return;
        }

        const csrfToken = document.querySelector('meta[name="_csrf"]').content;
        const csrfHeader = document.querySelector('meta[name="_csrf_header"]').content;

        const formData = new URLSearchParams();

        /*
         * rsvtDt란? 예약일.
         * 왜 필요? FACILITY_HSTRY.RSVT_DT 컬럼에 저장하기 위해 필요합니다.
         */
        formData.append('rsvtDt', rsvtDtInput.value);

        /*
         * cmnFacilityItemNo란? 좌석/회의실 같은 예약대상 번호.
         * 왜 필요? 어떤 좌석을 예약했는지 저장하기 위해 필요합니다.
         */
        formData.append('cmnFacilityItemNo', selectedItemNo);
        formData.append('rsvtBgngDttm', selectedStartDttm);
        formData.append('rsvtEndDttm', selectedEndDttm);
        formData.append('purposeCn', purposeCn.value.trim());

        fetch(contextPath + '/resident/publicFacility/reservation', {
            method: 'POST',
            headers: {
                [csrfHeader]: csrfToken,
                'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8'
            },
            body: formData
        })
            .then(response => {
                if (!response.ok) {
                    return response.text().then(text => {
                        throw new Error(text);
                    });
                }
                return response.text();
            })
            .then(rsvtNo => {
                Swal.fire({
                    icon: 'success',
                    title: '예약 완료',
                    text: '예약 신청이 완료되었습니다.',
                    confirmButtonText: '확인'
                }).then(() => {
                    location.href = contextPath +
                        '/resident/publicFacility/myReservation/${aptCmplexNo}';
                });
            })
            .catch(error => {
                console.error(error);
                // [변경] 서버가 보낸 비즈니스 메시지(error.message: 예) "시설 점검으로 예약할 수 없는 시간입니다.")를 우선 표시
                //  없거나 네트워크 오류인 경우 기존 폴백 문구로 표시
                Swal.fire({
                    icon: 'error',
                    title: '예약 실패',
                    text: error.message || '예약 신청 중 오류가 발생했습니다.',
                    confirmButtonText: '확인'
                });
            });
    });

    rsvtDtInput.addEventListener('change', loadTimeSlotsByDate);
    purposeCn.addEventListener('input', checkReserveButton);
</script>

</body>
</html>

