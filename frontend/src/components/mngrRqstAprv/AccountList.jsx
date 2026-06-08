import { formatDateDot, RoleBadge, TablePagination } from './shared';

export default function AccountList({
  loading,
  accountSearch,
  accountRows,
  accountListLength,
  accountPage,
  accountLastPage,
  onChangeSearch,
  onSearch,
  onReset,
  onPageChange,
  onOpenDetail,
  onToggleUse,
}) {
  return (
    <>
      <div className="mngr-section-header">
        <div>
          <h3 className="compact-card-title" style={{ marginBottom: 4 }}>단지 관리자 운영 계정</h3>
        </div>
      </div>

      <div className="filter-bar" style={{ padding: 12 }}>
        <div className="compact-input-group" style={{ width: 260 }}>
          <label>검색</label>
          <input
            value={accountSearch.keyword}
            placeholder="이름, 아이디, 단지명 검색"
            onChange={(e) => onChangeSearch('keyword', e.target.value)}
            onKeyDown={(e) => e.key === 'Enter' && onSearch()}
          />
        </div>
        <div className="compact-input-group" style={{ width: 120 }}>
          <label>계정 사용</label>
          <select value={accountSearch.status} onChange={(e) => onChangeSearch('status', e.target.value)}>
            <option value="">전체</option>
            <option value="active">사용</option>
            <option value="inactive">미사용</option>
          </select>
        </div>
        <div className="compact-input-group" style={{ width: 140 }}>
          <label>권한</label>
          <select value={accountSearch.role} onChange={(e) => onChangeSearch('role', e.target.value)}>
            <option value="">전체 권한</option>
            <option value="HEAD">관리소장</option>
            <option value="ACNT">회계</option>
            <option value="ADM">행정</option>
            <option value="FAC">시설</option>
          </select>
        </div>
        <div className="filter-right-group">
          <button type="button" className="btn-primary" disabled={loading} onClick={() => onSearch()}>검색</button>
          <button type="button" className="btn-outline" disabled={loading} onClick={onReset}>초기화</button>
        </div>
      </div>

      <div className="table-wrapper" style={{ marginTop: 12 }}>
        <div className="table-container">
          <table className="data-table">
            <thead>
              <tr>
                <th>관리자 정보</th>
                <th>소속 단지</th>
                <th>상세주소</th>
                <th>권한 레벨</th>
                <th>최근 접속</th>
                <th>상태</th>
              </tr>
            </thead>
            <tbody>
              {accountRows.length === 0 ? (
                <tr><td colSpan="6" style={{ padding: 20 }}>{loading ? '조회 중입니다.' : '조회된 계정이 없습니다.'}</td></tr>
              ) : accountRows.map((row) => {
                const active = row.userYn !== 'N';
                return (
                  <tr key={row.userNo} className="mngr-clickable-row" onClick={() => onOpenDetail(row)}>
                    <td>
                      <p className="cell-title">{row.userNm || '-'}</p>
                      <p className="cell-sub">{row.userId || '-'}</p>
                    </td>
                    <td>{row.aptCmplexNm || '-'}</td>
                    <td>{row.detailAddr || '-'}</td>
                    <td><RoleBadge code={row.mngrDutyCd} name={row.dutyNm} /></td>
                    <td>
                      {formatDateDot(row.lastLoginDt || row.regDt)}
                      {row.lastLoginTm ? ` ${row.lastLoginTm}` : ''}
                    </td>
                    <td>
                      <button
                        type="button"
                        className={`account-use-btn${active ? ' active' : ' inactive'}`}
                        onClick={(e) => {
                          e.stopPropagation();
                          onToggleUse(row, !active);
                        }}
                      >
                        {active ? '사용' : '미사용'}
                      </button>
                    </td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        </div>
        {accountListLength > 0 && accountLastPage > 1 && (
          <TablePagination page={accountPage} lastPage={accountLastPage} onChange={onPageChange} />
        )}
      </div>
    </>
  );
}
