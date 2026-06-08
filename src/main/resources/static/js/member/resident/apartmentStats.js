(function () {
  const state = {
    occupancyChart: null,
    facilityRankChart: null,
    checkDoneChart: null
  };

  const $ = (id) => document.getElementById(id);

  document.addEventListener('DOMContentLoaded', () => {
    loadApartmentStats();
  });

  async function loadApartmentStats() {
    // 단지 통계 데이터 조회
    try {
      const response = await fetch(buildDataUrl());
      if (!response.ok) {
        throw new Error(`HTTP ${response.status}`);
      }
      const data = await response.json();
      renderHouse(data.house || {});
      renderFacilityList(data.facilityList || []);
      renderCheck(data.check || {});
    } catch (error) {
      console.error(error);
      renderError();
    }
  }

  function buildDataUrl() {
    // 단지 번호 기준 데이터 URL
    const contextPath = window.aptStatsContextPath || '';
    const aptCmplexNo = window.aptStatsAptCmplexNo || '';
    return `${contextPath}/resident/stats/apartment/${encodeURIComponent(aptCmplexNo)}/data`;
  }

  function renderHouse(house) {
    // 상단 요약 카드와 입주율 그래프
    const occupied = Number(house.occupiedCnt || 0);
    const empty = Number(house.emptyCnt || 0);

    setText('totalUnitCnt', `${formatNumber(house.totalUnitCnt)}세대`);
    setText('occupancyRate', `입주율 ${formatDecimal(house.occupancyRate)}%`);
    setText('dongCnt', `${formatNumber(house.dongCnt)}동`);
    setText('emptyCnt', `공실 ${formatNumber(empty)}세대`);

    renderDoughnutChart('occupancyChart', 'occupancyChart', ['입주', '공실'], [occupied, empty], [
      '#2c694f',
      '#d79a2b'
    ]);
  }

  function renderFacilityList(facilityList) {
    // 시설 이용 랭킹 그래프와 표
    const tbody = $('facilityRankRows');
    const total = facilityList.reduce((sum, f) => sum + Number(f.reservationCnt || 0), 0);

    setText('facilityReservationTotal', `${formatNumber(total)}건`);

    if (!tbody) return;
    if (!facilityList.length) {
      tbody.innerHTML = '<tr><td colspan="3" class="empty">이번 달 시설 이용 내역이 없습니다.</td></tr>';
      destroyChart('facilityRankChart');
      return;
    }

    renderHorizontalBarChart('facilityRankChart', 'facilityRankChart', {
      labels: facilityList.map((f) => f.facilityNm || '-'),
      data: facilityList.map((f) => Number(f.reservationCnt || 0))
    });

    tbody.innerHTML = facilityList.map((f, idx) => `
      <tr>
        <td class="rank-cell">${idx + 1}</td>
        <td>${escapeHtml(f.facilityNm || '-')}</td>
        <td class="text-right">${formatNumber(f.reservationCnt)}회</td>
      </tr>
    `).join('');
  }

  function renderCheck(check) {
    // 입주민에게 필요한 점검 요약만 표시
    const total = Number(check.totalCnt || 0);
    const done = Number(check.doneCnt || 0);
    const restricted = Number(check.restrictedCnt || 0);
    const doneRate = total === 0 ? 0 : Math.round((done / total) * 100);

    setText('checkDoneRate', `${formatNumber(doneRate)}%`);
    setText('checkDoneRateLarge', `${formatNumber(doneRate)}%`);
    setText('checkRestrictedTop', `${formatNumber(restricted)}건`);
    setText('checkTotal', `${formatNumber(total)}건`);
    setText('checkRestricted', `${formatNumber(restricted)}건`);

    renderDoughnutChart('checkDoneChart', 'checkDoneChart', ['완료', '남은 점검'], [done, Math.max(total - done, 0)], [
      '#2c694f',
      '#edf0eb'
    ]);
  }

  function renderBarChart(chartKey, canvasId, chartData) {
    const canvas = $(canvasId);
    if (!canvas || !window.Chart) return;
    destroyChart(chartKey);

    state[chartKey] = new Chart(canvas, {
      type: 'bar',
      data: chartData,
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: { position: 'top' }
        },
        scales: {
          y: {
            beginAtZero: true,
            ticks: {
              callback: (value) => formatNumber(value)
            }
          }
        }
      }
    });
  }

  function renderHorizontalBarChart(chartKey, canvasId, chartData) {
    const canvas = $(canvasId);
    if (!canvas || !window.Chart) return;
    destroyChart(chartKey);

    state[chartKey] = new Chart(canvas, {
      type: 'bar',
      data: {
        labels: chartData.labels,
        datasets: [{
          label: '예약 건수',
          data: chartData.data,
          backgroundColor: '#2c694f',
          borderRadius: 8,
          maxBarThickness: 28
        }]
      },
      options: {
        indexAxis: 'y',
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: { display: false }
        },
        scales: {
          x: {
            beginAtZero: true,
            ticks: {
              precision: 0,
              callback: (value) => formatNumber(value)
            }
          }
        }
      }
    });
  }

  function renderDoughnutChart(chartKey, canvasId, labels, data, colors) {
    const canvas = $(canvasId);
    if (!canvas || !window.Chart) return;
    destroyChart(chartKey);

    state[chartKey] = new Chart(canvas, {
      type: 'doughnut',
      data: {
        labels,
        datasets: [{
          data,
          backgroundColor: colors,
          borderWidth: 0
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        cutout: '68%',
        plugins: {
          legend: { position: 'bottom' }
        }
      }
    });
  }

  function destroyChart(chartKey) {
    if (state[chartKey]) {
      state[chartKey].destroy();
      state[chartKey] = null;
    }
  }

  function renderError() {
    // 오류 문구
    const main = document.querySelector('.content-area');
    if (!main) return;
    main.innerHTML = '<div class="empty" style="padding:60px 20px;">통계 정보를 불러오지 못했습니다.</div>';
  }

  function setText(id, value) {
    const el = $(id);
    if (el) el.textContent = value;
  }

  function formatNumber(value) {
    return Number(value || 0).toLocaleString('ko-KR');
  }

  function formatDecimal(value) {
    return Number(value || 0).toLocaleString('ko-KR', {
      minimumFractionDigits: 0,
      maximumFractionDigits: 1
    });
  }

  function escapeHtml(value) {
    return String(value || '').replace(/[&<>"']/g, (ch) => ({
      '&': '&amp;',
      '<': '&lt;',
      '>': '&gt;',
      '"': '&quot;',
      "'": '&#39;'
    }[ch]));
  }
}());
