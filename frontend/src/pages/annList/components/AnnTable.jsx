import { TablePagination } from '../../../components/mngrRqstAprv/shared';
import { formatRange, getStatusName, PAGE_SIZE, StatusBadge } from './annBits';

export default function AnnTable({
  rows = [],
  total = 0,
  page = 1,
  onPageChange,
  onRowClick,
  loading = false,
}) {
  const totalPage = Math.max(1, Math.ceil(total / PAGE_SIZE));
  const start = (page - 1) * PAGE_SIZE;
  const slice = rows.slice(start, start + PAGE_SIZE);

  return (
    <section className="form-card">
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-end', marginBottom: 12 }}>
        <div>
          <h2 className="form-card-title">공고 목록</h2>
          <p className="table-info-text" style={{ marginTop: 6 }}>
            총 <strong>{total}</strong>건 · 페이지당 {PAGE_SIZE}건
          </p>
        </div>
      </div>

      <div className="table-wrapper">
        <div className="table-container">
          <table className="data-table">
            <thead>
              <tr>
                <th >공고 제목</th>
                <th>단지</th>
                <th>게시 기간</th>
                <th>모집 기간</th>
                <th>공급 세대수</th>
                <th>제출 서류</th>
                <th style={{ textAlign: 'center' }}>상태</th>
              </tr>
            </thead>
            <tbody>
              {loading ? (
                <tr>
                  <td colSpan={8} style={{ textAlign: 'center', padding: 24 }}>
                    불러오는 중…
                  </td>
                </tr>
              ) : slice.length === 0 ? (
                <tr>
                  <td colSpan={8} style={{ textAlign: 'center', padding: 24, color: 'var(--on-surface-variant)' }}>
                    조회된 공고가 없습니다.
                  </td>
                </tr>
              ) : (
                slice.map((row) => (
                  <tr
                    key={row.annNo}
                    onClick={() => onRowClick(row.annNo)}
                    style={{ cursor: 'pointer' }}
                  >
                    <td><span className="cell-title">{row.ttl || '-'}</span></td>
                    <td>{row.aptCmplexNm || '-'}</td>
                    <td>{formatRange(row.pblancBgngDt, row.pblancEndDt)}</td>
                    <td>{formatRange(row.rcrtBgngDt, row.rcrtEndDt)}</td>
                    <td>{row.supplyDisplay || '-'}</td>
                    <td style={{ maxWidth: 200 }}>{row.sbmsnDocNm || row.sbmsnDoc || '-'}</td>
                    <td style={{ textAlign: 'center' }}>
                      <StatusBadge status={getStatusName(row)} />
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>

        {total > PAGE_SIZE && (
          <TablePagination page={page} lastPage={totalPage} onChange={onPageChange} />
        )}
      </div>
    </section>
  );
}
