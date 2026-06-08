(function () {
  const state = {
    monthlyChart: null
  };

  const $ = (id) => document.getElementById(id);

  document.addEventListener('DOMContentLoaded', () => {
    loadCustomStats();
  });

  async function loadCustomStats() {
    // 통계 데이터 조회
    try {
      const response = await fetch(buildDataUrl());
      if (!response.ok) {
        throw new Error(`HTTP ${response.status}`);
      }

      const data = await response.json();
      renderHouse(data.house || {});
      renderSummary(data.summary || {});
      renderMonthlyChart(data.monthlyList || []);
      renderMeterCards(data.meterList || []);
      renderFacilityTable(data.facilityList || []);
      renderComplaint(data.complaint || {});
    } catch (error) {
      console.error(error);
      renderError();
    }
  }

  function buildDataUrl() {
    // 단지 번호 기준 URL
    const contextPath = window.customStatsContextPath || '';
    const aptCmplexNo = window.customStatsAptCmplexNo || '';

    if (aptCmplexNo) {
      return `${contextPath}/resident/stats/custom/${encodeURIComponent(aptCmplexNo)}/data`;
    }

    return `${contextPath}/resident/stats/custom/data`;
  }

  function renderHouse(house) {
    // 세대 정보
    setText('customStatsHouseText', house.displayDongHo || '-');
  }

  function renderSummary(summary) {
    // 상단 카드 영역
    setText('currentBillAmt', `${formatNumber(summary.currentBillAmt)}원`);
    setText('currentBillSub', formatBillYm(summary.billYm));

    setChangeText('previousDiffAmt', 'previousDiffSub', summary.previousDiffAmt, summary.previousDiffRate);
    setText('similarAvgAmt', `${formatNumber(summary.similarAvgAmt)}원`);
    setText('similarAvgSub', '단지 전체 기준');
    setAverageText('averageDiffAmt', 'averageDiffSub', summary.averageDiffAmt, summary.averageDiffRate);
  }

  function setChangeText(valueId, subId, diffAmt, diffRate) {
    // 전월 대비 문구
    const amount = Number(diffAmt || 0);
    const rate = Math.abs(Number(diffRate || 0));
    clearSubColor(subId);

    if (amount === 0 || rate === 0) {
      setText(valueId, '변동 없음');
      setText(subId, '전월 대비 0원 차이');
      return;
    }

    const stateText = amount > 0 ? '증가' : '감소';
    const directionText = amount > 0 ? '높음' : '낮음';
    setText(valueId, `${formatNumber(Math.abs(amount))}원 ${stateText}`);
    setText(subId, `전월보다 ${formatDecimal(rate)}% ${directionText}`);
    setSubColor(subId, amount > 0 ? 'up' : 'down');
  }

  function setAverageText(valueId, subId, diffAmt, diffRate) {
    // 단지 평균 대비 문구
    const amount = Number(diffAmt || 0);
    const rate = Math.abs(Number(diffRate || 0));

    if (amount === 0) {
      setText(valueId, '평균과 같음');
      setText(subId, '단지 전체 평균과 같은 금액');
      return;
    }

    const directionText = amount > 0 ? '높음' : '낮음';
    setText(valueId, `${formatNumber(Math.abs(amount))}원 ${directionText}`);
    setText(subId, `단지 전체 평균보다 ${formatDecimal(rate)}% ${directionText}`);
    setSubColor(subId, amount > 0 ? 'up' : 'down');
  }

  function setSubColor(id, direction) {
    const el = $(id);
    if (!el) return;
    el.classList.remove('up', 'down');
    el.classList.add(direction);
  }

  function clearSubColor(id) {
    const el = $(id);
    if (!el) return;
    el.classList.remove('up', 'down');
  }

  function renderMonthlyChart(monthlyList) {
    // 최근 3개월 막대 차트
    const canvas = $('monthlyCompareChart');
    if (!canvas || !window.Chart) {
      return;
    }

    const recentList = monthlyList.slice(-3);

    if (state.monthlyChart) {
      state.monthlyChart.destroy();
    }

    state.monthlyChart = new Chart(canvas, {
      type: 'bar',
      data: {
        labels: recentList.map((item) => formatBillYmShort(item.billYm)),
        datasets: [
          {
            label: '우리집',
            data: recentList.map((item) => item.myBillAmt || 0),
            backgroundColor: '#2c694f',
            borderRadius: 6,
            maxBarThickness: 46
          },
          {
            label: '단지 전체 평균',
            data: recentList.map((item) => item.similarAvgAmt || 0),
            backgroundColor: '#d79a2b',
            borderRadius: 6,
            maxBarThickness: 46
          }
        ]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: {
            position: 'top'
          }
        },
        scales: {
          y: {
            beginAtZero: true,
            ticks: {
              callback: (value) => `${formatNumber(value)}원`
            }
          }
        }
      }
    });
  }

  function renderMeterCards(meterList) {
    // 검침 사용량 카드
    const holder = $('meterCompareRows');
    if (!holder) {
      return;
    }

    if (!meterList.length) {
      holder.innerHTML = '<div class="empty">검침 사용량 데이터가 없습니다.</div>';
      return;
    }

    holder.innerHTML = meterList.map((meter) => {
      const diffRate = Number(meter.diffRate || 0);
      const grade = getMeterGrade(diffRate);
      const unit = meter.unitNm || '';
      const myUsage = Number(meter.myUsageVal || 0);
      const avgUsage = Number(meter.avgUsageVal || 0);
      const diffVal = Number(meter.diffVal || 0);
      const width = Math.max(8, Math.min(100, Math.round((myUsage / Math.max(avgUsage * 1.5, 1)) * 100)));
      const diffText = diffVal === 0 ? '평균과 같음' : `평균보다 ${formatNumber(Math.abs(diffVal))}${unit} ${diffVal > 0 ? '높음' : '낮음'}`;

      return `
        <div class="meter-card">
          <div class="meter-title">
            <strong>${escapeHtml(meter.meterTyNm || '-')} 사용량</strong>
            <span class="meter-grade ${grade.className}">${grade.label}</span>
          </div>
          <div class="meter-values">
            <div>
              <span>우리집</span>
              <b>${formatNumber(myUsage)}${escapeHtml(unit)}</b>
            </div>
            <div>
              <span>단지 평균</span>
              <b>${formatNumber(avgUsage)}${escapeHtml(unit)}</b>
            </div>
          </div>
          <div class="gauge">
            <div class="gauge-bar ${grade.className}" style="width:${width}%"></div>
          </div>
          <div class="meter-desc">${diffText}</div>
        </div>
      `;
    }).join('');
  }

  function getMeterGrade(diffRate) {
    // 검침 등급 기준
    if (diffRate <= -10) {
      return { label: '절약', className: 'save' };
    }

    if (diffRate >= 10) {
      return { label: '주의', className: 'warn' };
    }

    return { label: '평균', className: 'normal' };
  }

  function renderFacilityTable(facilityList) {
    // 시설 이용 현황 표
    const tbody = $('facilityUseRows');
    if (!tbody) {
      return;
    }

    if (!facilityList.length) {
      tbody.innerHTML = '<tr><td colspan="2" class="empty">이번 달 시설 이용 내역이 없습니다.</td></tr>';
      return;
    }

    tbody.innerHTML = facilityList.map((item) => `
      <tr>
        <td>${escapeHtml(item.facilityNm || '-')}</td>
        <td class="text-right">${formatNumber(item.useCnt)}회</td>
      </tr>
    `).join('');
  }

  function renderComplaint(complaint) {
    // 민원 현황
    setText('complaintAppliedCnt', `접수 ${formatNumber(complaint.appliedCnt)}건`);
    setText('complaintProcessingCnt', `처리중 ${formatNumber(complaint.processingCnt)}건`);
    setText('complaintDoneCnt', `완료 ${formatNumber(complaint.doneCnt)}건`);
  }

  function renderError() {
    // 오류 문구
    setText('currentBillAmt', '0원');
    setText('currentBillSub', '통계 데이터를 불러오지 못했습니다.');

    const meterRows = $('meterCompareRows');
    if (meterRows) {
      meterRows.innerHTML = '<div class="empty">검침 사용량 데이터를 불러오지 못했습니다.</div>';
    }

    const facilityRows = $('facilityUseRows');
    if (facilityRows) {
      facilityRows.innerHTML = '<tr><td colspan="2" class="empty">시설 이용 데이터를 불러오지 못했습니다.</td></tr>';
    }
  }

  function setText(id, value) {
    const element = $(id);
    if (element) {
      element.textContent = value;
    }
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

  function formatBillYm(value) {
    if (!value || String(value).length < 6) {
      return '-';
    }

    const text = String(value);
    return `${text.substring(0, 4)}년 ${Number(text.substring(4, 6))}월`;
  }

  function formatBillYmShort(value) {
    if (!value || String(value).length < 6) {
      return '-';
    }

    return `${Number(String(value).substring(4, 6))}월`;
  }

  function escapeHtml(value) {
    return String(value)
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;')
      .replace(/'/g, '&#039;');
  }
})();
