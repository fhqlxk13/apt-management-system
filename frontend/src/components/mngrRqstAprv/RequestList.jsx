import { formatDateDot, RoleBadge, StatusBadge, TablePagination } from './shared';

export default function RequestList({
  loading,
  requestSearch,
  requestRows,
  requestListLength,
  requestPage,
  requestLastPage,
  selectedRqstNos,
  pageWaitRqstNos,
  allPageWaitSelected,
  onChangeSearch,
  onSearch,
  onReset,
  onSelectAll,
  onSelect,
  onApprove,
  onReject,
  onPageChange,
  onOpenDetail,
}) {
  return (
    <>
      <div className="mngr-section-header">
        <div>
          <h3 className="compact-card-title" style={{ marginBottom: 4 }}>단지 관리자 신청 계정</h3>
        </div>
        <div className="actions-flex">
          <button type="button" className="btn-outline" disabled={loading || selectedRqstNos.length === 0} onClick={() => onApprove()}>선택 승인</button>
        </div>
      </div>

      <div className="filter-bar" style={{ padding: 12 }}>
        <div className="compact-input-group" style={{ width: 260 }}>
          <label>검색</label>
          <input
            value={requestSearch.keyword}
            placeholder="이름, 아이디, 단지명 검색"
            onChange={(e) => onChangeSearch('keyword', e.target.value)}
            onKeyDown={(e) => e.key === 'Enter' && onSearch()}
          />
        </div>
        <div className="compact-input-group" style={{ width: 140 }}>
          <label>처리상태</label>
          <select value={requestSearch.status} onChange={(e) => onChangeSearch('status', e.target.value)}>
            <option value="">전체</option>
            <option value="CNL">신청취소</option>
            <option value="WAIT">승인대기</option>
            <option value="OK">승인완료</option>
            <option value="RJCT">반려</option>
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
                <th>
                  <input
                    type="checkbox"
                    aria-label="현재 페이지 승인대기 신청 선택"
                    disabled={pageWaitRqstNos.length === 0}
                    checked={allPageWaitSelected}
                    onChange={(e) => onSelectAll(e.target.checked, pageWaitRqstNos)}
                  />
                </th>
                <th>신청자 정보</th>
                <th>소속 단지</th>
                <th>상세주소</th>
                <th>신청 직무</th>
                <th>신청일자</th>
                <th>처리상태</th>
                <th>비고</th>
              </tr>
            </thead>
            <tbody>
              {requestRows.length === 0 ? (
                <tr><td colSpan="8" style={{ padding: 20 }}>{loading ? '조회 중입니다.' : '조회된 신청 계정이 없습니다.'}</td></tr>
              ) : requestRows.map((row) => {
                const status = String(row.rqstSttsCd || '').toUpperCase();
                const isWait = status === 'WAIT';

                return (
                  <tr key={row.rqstNo} className="mngr-clickable-row" onClick={() => onOpenDetail(row)}>
                    <td>
                      {isWait ? (
                        <input
                          type="checkbox"
                          aria-label={`${row.rqstMngrNm || row.rqstLoginId || '신청'} 승인 선택`}
                          checked={selectedRqstNos.includes(row.rqstNo)}
                          onClick={(e) => e.stopPropagation()}
                          onChange={(e) => onSelect(row.rqstNo, e.target.checked)}
                        />
                      ) : (
                        <span className="mngr-selection-unavailable">-</span>
                      )}
                    </td>
                    <td>
                      <p className="cell-title">{row.rqstMngrNm || '-'}</p>
                      <p className="cell-sub">{row.rqstLoginId || '-'}</p>
                    </td>
                    <td>{row.aptCmplexNm || row.aptCmplexNo || '-'}</td>
                    <td>{row.detailAddr || '-'}</td>
                    <td><RoleBadge code={row.rqstDutyCd} name={row.dutyNm} /></td>
                    <td>{formatDateDot(row.rqstDt)}</td>
                    <td><StatusBadge status={status} /></td>
                    <td>
                      {isWait ? (
                        <div className="actions-flex">
                          <button type="button" className="btn-cell" onClick={(e) => { e.stopPropagation(); onApprove([row.rqstNo]); }}>승인</button>
                          <button type="button" className="btn-cell btn-cell-danger" onClick={(e) => { e.stopPropagation(); onReject([row.rqstNo]); }}>반려</button>
                        </div>
                      ) : row.rjctRsnCn ? (
                        <span className="reject-reason" title={row.rjctRsnCn}>{row.rjctRsnCn}</span>
                      ) : '-'}
                    </td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        </div>
        {requestListLength > 0 && requestLastPage > 1 && (
          <TablePagination page={requestPage} lastPage={requestLastPage} onChange={onPageChange} />
        )}
      </div>
    </>
  );
}
