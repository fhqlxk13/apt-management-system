(function () {
  const state = {
    monthlyChart: null,
    listingStatusChart: null,
    aptList: [],
    currentPage: 1
  };

  const $ = (id) => document.getElementById(id);

  document.addEventListener('DOMContentLoaded', () => {
    const year = $('aptDashboardYear');
    if (year && !year.value) {
      year.value = new Date().getFullYear();
    }

    $('aptDashboardSearchBtn')?.addEventListener('click', () => loadDashboard(1));
    $('aptDashboardSido')?.addEventListener('change', () => {
      $('aptDashboardApt').value = '';
      $('aptDashboardAptSearch').value = '';
      loadDashboard(1);
    });
    $('aptDashboardAptSearch')?.addEventListener('input', handleAptSearchInput);
    $('aptDashboardYear')?.addEventListener('change', () => loadDashboard(1));

    loadDashboard(1);
  });

  function getSearchParams() {
    // 조회 조건
    const params = new URLSearchParams();
    const sidoNm = $('aptDashboardSido')?.value || '';
    const aptCmplexNo = $('aptDashboardApt')?.value || '';
    const year = $('aptDashboardYear')?.value || new Date().getFullYear();

    if (sidoNm) params.append('sidoNm', sidoNm);
    if (aptCmplexNo) params.append('aptCmplexNo', aptCmplexNo);
    params.append('year', year);
    params.append('currentPage', state.currentPage);
    return params;
  }

  async function loadDashboard(page) {
    // 페이지 번호
    state.currentPage = page || state.currentPage || 1;

    setLoading(true);
    try {
      const response = await fetch(`${window.aptDashboardContextPath || ''}/main/apt/dashboard/data?${getSearchParams()}`);
      if (!response.ok) {
        throw new Error(`HTTP ${response.status}`);
      }
      const data = await response.json();
      renderOptions(data);
      renderSummary(data.summary || {});
      renderMonthlyChart(data.monthlyList || []);
      renderListingStatusChart(data.listingStatusList || []);
      renderTable(data.aptRowList || [], data.pagingVO || {});
      renderPagination(data.pagingVO || {});
    } catch (error) {
      console.error(error);
      renderError();
    } finally {
      setLoading(false);
    }
  }

  function renderOptions(data) {
    const selectedSido = data.search?.sidoNm || $('aptDashboardSido')?.value || '';
    const selectedApt = data.search?.aptCmplexNo || $('aptDashboardApt')?.value || '';
    state.aptList = data.aptList || [];
    fillSelect($('aptDashboardSido'), data.sidoList || [], '전체 지역', selectedSido);
    renderAptOptions(selectedApt);
  }

  function renderAptOptions(selectedValue) {
    // 단지 검색 후보
    const datalist = $('aptDashboardAptOptions');
    if (!datalist) return;

    datalist.innerHTML = '';
    state.aptList.forEach((item) => {
      const option = document.createElement('option');
      option.value = item.label || item.value;
      datalist.appendChild(option);
    });

    const selectedItem = state.aptList.find((item) => item.value === selectedValue);
    if (selectedItem) {
      $('aptDashboardApt').value = selectedItem.value || '';
      $('aptDashboardAptSearch').value = selectedItem.label || selectedItem.value || '';
    }
  }

  function handleAptSearchInput() {
    // 단지 검색 선택
    const inputValue = ($('aptDashboardAptSearch')?.value || '').trim();
    const matchedItem = state.aptList.find((item) => (item.label || item.value || '') === inputValue);
    const beforeValue = $('aptDashboardApt')?.value || '';

    if (!inputValue) {
      $('aptDashboardApt').value = '';
      if (beforeValue) loadDashboard(1);
      return;
    }

    if (matchedItem && matchedItem.value !== beforeValue) {
      $('aptDashboardApt').value = matchedItem.value || '';
      loadDashboard(1);
      return;
    }

    if (!matchedItem && beforeValue) {
      $('aptDashboardApt').value = '';
    }
  }

  function fillSelect(select, list, placeholder, selectedValue) {
    if (!select) return;
    select.innerHTML = '';
    select.appendChild(new Option(placeholder, ''));
    list.forEach((item) => {
      select.appendChild(new Option(item.label || item.value, item.value));
    });
    select.value = selectedValue || '';
  }

  function renderSummary(summary) {
    // 요약 카드
    setText('totalUnitCnt', formatNumber(summary.totalUnitCnt));
    setText('announcementCnt', formatNumber(summary.announcementCnt));
    setText('rentListingCnt', formatNumber(summary.rentListingCnt));
    setText('rentContractRate', `${formatDecimal(summary.rentContractRate)}%`);
  }

  function renderMonthlyChart(monthlyList) {
    // 월별 차트
    const canvas = $('monthlyChart');
    if (!canvas || !window.Chart) return;
    if (state.monthlyChart) state.monthlyChart.destroy();

    state.monthlyChart = new Chart(canvas, {
      type: 'bar',
      data: {
        labels: monthlyList.map((item) => `${Number(item.month)}월`),
        datasets: [
          {
            label: '공고 수',
            data: monthlyList.map((item) => item.announcementCnt || 0),
            backgroundColor: '#FFB347',
            borderRadius: 4
          },
          {
            label: '계약 완료 매물 수',
            data: monthlyList.map((item) => item.contractCnt || 0),
            backgroundColor: '#8a9a5b',
            borderRadius: 4
          }
        ]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: { legend: { position: 'top' } },
        scales: { y: { beginAtZero: true, ticks: { precision: 0 } } }
      }
    });
  }

  function renderListingStatusChart(listingStatusList) {
    // 임대 매물 상태 차트
    const canvas = $('listingStatusChart');
    if (!canvas || !window.Chart) return;
    if (state.listingStatusChart) state.listingStatusChart.destroy();

    const labels = listingStatusList.length ? listingStatusList.map((item) => item.listingStatusNm || item.listingStatusCd) : ['데이터 없음'];
    const values = listingStatusList.length ? listingStatusList.map((item) => item.rentListingCnt || 0) : [1];

    state.listingStatusChart = new Chart(canvas, {
      type: 'doughnut',
      data: {
        labels,
        datasets: [{
          data: values,
          backgroundColor: ['#8a9a5b', '#FFB347', '#30694d', '#bdce89']
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: { legend: { position: 'bottom' } }
      }
    });
  }

  function renderTable(rows, pagingVO) {
    // 단지별 목록
    const tbody = $('aptDashboardRows');
    if (!tbody) return;
    tbody.innerHTML = '';

    if (!rows.length) {
      tbody.innerHTML = '<tr><td colspan="8" class="px-8 py-8 text-center text-gray-500">조회된 통계 데이터가 없습니다.</td></tr>';
      setText('aptDashboardCountText', '전체 0개');
      return;
    }

    const startNo = Number(pagingVO.startRow || 1);

    rows.forEach((row, index) => {
      const rate = Number(row.rentContractRate || 0);
      const tr = document.createElement('tr');
      tr.className = 'hover:bg-surface-container-low/30 transition-colors';
      tr.innerHTML = `
        <td class="px-6 py-4 text-sm text-on-surface-variant">${startNo + index}</td>
        <td class="px-6 py-4 font-semibold text-on-surface">${escapeHtml(row.aptCmplexNm || '-')}</td>
        <td class="px-6 py-4 text-sm text-on-surface-variant">${escapeHtml(row.region || '-')}</td>
        <td class="px-6 py-4 text-sm text-on-surface-variant text-right">${formatNumber(row.unitCnt)}</td>
        <td class="px-6 py-4 text-sm text-on-surface-variant text-right">${formatNumber(row.announcementCnt)}</td>
        <td class="px-6 py-4 text-sm text-on-surface-variant text-right">${formatNumber(row.rentListingCnt)}</td>
        <td class="px-6 py-4">
          <div class="flex items-center gap-3">
            <div class="flex-1 bg-surface-container-low rounded-full h-1.5 min-w-[80px]">
              <div class="bg-primary-container h-1.5 rounded-full" style="width: ${Math.min(rate, 100)}%"></div>
            </div>
            <span class="font-label-sm text-primary-container min-w-[44px] text-right">${formatDecimal(rate)}%</span>
          </div>
        </td>
        <td class="px-6 py-4 text-right">
          <a class="text-primary-container hover:underline font-label-sm" href="${window.aptDashboardContextPath || ''}/main/apt/detail.do?aptCmplexNo=${encodeURIComponent(row.aptCmplexNo || '')}">상세보기</a>
        </td>
      `;
      tbody.appendChild(tr);
    });

    setText('aptDashboardCountText', `전체 ${formatNumber(pagingVO.totalRecord || rows.length)}개`);
  }

  function renderPagination(pagingVO) {
    // 페이지 버튼
    const container = $('aptDashboardPagination');
    if (!container) return;

    const totalPage = Number(pagingVO.totalPage || 0);
    const currentPage = Number(pagingVO.currentPage || 1);
    const startPage = Number(pagingVO.startPage || 1);
    const endPage = Number(pagingVO.endPage || 0);
    const blockSize = Number(pagingVO.blockSize || 5);

    container.innerHTML = '';
    if (totalPage <= 1) return;

    if (startPage > 1) {
      container.appendChild(createPageButton('Prev', startPage - blockSize, false));
    }

    for (let page = startPage; page <= endPage; page += 1) {
      container.appendChild(createPageButton(String(page), page, page === currentPage));
    }

    if (endPage < totalPage) {
      container.appendChild(createPageButton('Next', endPage + 1, false));
    }
  }

  function createPageButton(label, page, active) {
    // 페이지 버튼 생성
    const button = document.createElement('button');
    button.type = 'button';
    button.textContent = label;
    button.className = active
      ? 'min-w-9 h-9 px-3 rounded-full bg-primary-container text-white text-sm font-semibold'
      : 'min-w-9 h-9 px-3 rounded-full bg-surface-container-low text-on-surface-variant text-sm hover:bg-outline-variant/40';
    button.disabled = active;
    button.addEventListener('click', () => loadDashboard(page));
    return button;
  }

  function renderError() {
    // 오류 문구
    const tbody = $('aptDashboardRows');
    if (tbody) {
      tbody.innerHTML = '<tr><td colspan="8" class="px-8 py-8 text-center text-red-600">통계 데이터를 불러오지 못했습니다.</td></tr>';
    }
    const pagination = $('aptDashboardPagination');
    if (pagination) pagination.innerHTML = '';
  }

  function setLoading(loading) {
    const button = $('aptDashboardSearchBtn');
    if (!button) return;
    button.disabled = loading;
    button.classList.toggle('opacity-60', loading);
  }

  function setText(id, value) {
    const element = $(id);
    if (element) element.textContent = value;
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
    return String(value)
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;')
      .replace(/'/g, '&#039;');
  }
})();
