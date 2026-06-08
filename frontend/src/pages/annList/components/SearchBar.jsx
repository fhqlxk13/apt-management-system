import { EMPTY_FILTER } from './annBits';

const SEARCH_CSS = `
.ann-search-card .ann-search-head {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  gap: 16px;
  margin-bottom: 16px;
  padding-bottom: 16px;
  border-bottom: 1px solid var(--outline-variant);
}
.ann-search-card .ann-search-title {
  margin: 0 0 4px;
  font-size: 16px;
  font-weight: 700;
  color: var(--on-surface);
}
.ann-search-card .ann-search-sub {
  margin: 0;
  font-size: 13px;
  color: var(--on-surface-variant);
}
.ann-search-card .ann-search-actions {
  display: flex;
  gap: 8px;
  flex-shrink: 0;
}
.ann-search-card .ann-search-actions .btn-outline,
.ann-search-card .ann-search-actions .btn-primary {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  height: 38px;
  margin: 0;
  padding: 0 14px;
  white-space: nowrap;
}
.ann-search-card .ann-search-actions .material-symbols-rounded {
  font-size: 18px;
}
.ann-search-fields {
  display: grid;
  grid-template-columns: minmax(160px, 2.2fr) minmax(120px, 1.2fr) minmax(128px, 1fr) minmax(128px, 1fr) minmax(96px, 0.9fr);
  gap: 12px;
  align-items: end;
}
@media (max-width: 1100px) {
  .ann-search-fields {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}
@media (max-width: 600px) {
  .ann-search-fields {
    grid-template-columns: 1fr;
  }
  .ann-search-card .ann-search-head {
    flex-direction: column;
    align-items: stretch;
  }
}
`;

export default function SearchBar({
  draft,
  onChange,
  aptOptions = [],
  onSearch,
  onReset,
}) {
  const set = (name, value) => onChange({ ...draft, [name]: value });

  return (
    <>
      <style>{SEARCH_CSS}</style>
      <section className="filter-panel ann-search-card" style={{ marginBottom: 16, padding: '20px 24px' }}>
        <div className="ann-search-head">
          <div className="ann-search-head-text">
            <h2 className="ann-search-title">검색 조건</h2>
            <p className="ann-search-sub">조건을 입력하면 공고 목록이 필터링됩니다.</p>
          </div>
          <div className="ann-search-actions">
            <button
              type="button"
              className="btn-outline"
              onClick={() => onReset({ ...EMPTY_FILTER })}
            >
              <span className="material-symbols-rounded" aria-hidden>refresh</span>
              초기화
            </button>
            <button type="button" className="btn-primary" onClick={onSearch}>
              <span className="material-symbols-rounded" aria-hidden>search</span>
              검색
            </button>
          </div>
        </div>

        <div className="ann-search-fields">
          <div className="filter-group">
            <label className="filter-label" htmlFor="searchTtl">공고 제목</label>
            <input
              id="searchTtl"
              type="text"
              className="filter-input"
              placeholder="제목 검색"
              value={draft.searchTtl}
              onChange={(e) => set('searchTtl', e.target.value)}
              onKeyDown={(e) => e.key === 'Enter' && onSearch()}
            />
          </div>
          <div className="filter-group">
            <label className="filter-label" htmlFor="searchApt">단지</label>
            <select
              id="searchApt"
              className="filter-input"
              value={draft.searchAptCmplexNo}
              onChange={(e) => set('searchAptCmplexNo', e.target.value)}
            >
              <option value="">단지 전체</option>
              {aptOptions.map((apt) => (
                <option key={apt.aptCmplexNo} value={apt.aptCmplexNo}>
                  {apt.aptCmplexNm}
                </option>
              ))}
            </select>
          </div>
          <div className="filter-group">
            <label className="filter-label" htmlFor="searchFrom">시작일</label>
            <input
              id="searchFrom"
              type="date"
              className="filter-input"
              value={draft.searchFrom}
              onChange={(e) => set('searchFrom', e.target.value)}
            />
          </div>
          <div className="filter-group">
            <label className="filter-label" htmlFor="searchTo">종료일</label>
            <input
              id="searchTo"
              type="date"
              className="filter-input"
              value={draft.searchTo}
              onChange={(e) => set('searchTo', e.target.value)}
            />
          </div>
          <div className="filter-group">
            <label className="filter-label" htmlFor="searchStatus">상태</label>
            <select
              id="searchStatus"
              className="filter-input"
              value={draft.searchStatus}
              onChange={(e) => set('searchStatus', e.target.value)}
            >
              <option value="">전체</option>
              <option value="진행중">진행중</option>
              <option value="마감">마감</option>
              <option value="예정">예정</option>
            </select>
          </div>
        </div>
      </section>
    </>
  );
}
