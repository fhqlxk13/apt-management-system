export const PAGE_SIZE = 8;

const ROLE_NAMES = { HEAD: '관리소장', ACNT: '회계', ADM: '행정', FAC: '시설' };
const STATUS_NAMES = { CNL: '신청취소', WAIT: '승인대기', OK: '승인완료', RJCT: '반려' };

const ROLE_BADGE_CLASS = {
  HEAD: 'role-badge-head',
  DUTY_HEAD: 'role-badge-head',
  ACNT: 'role-badge-acnt',
  DUTY_ACC: 'role-badge-acnt',
  ADM: 'role-badge-adm',
  DUTY_ADMIN: 'role-badge-adm',
  FAC: 'role-badge-fac',
  DUTY_FAC: 'role-badge-fac',
};

const REQUEST_STATUS_BADGE = {
  WAIT: { className: 'badge-rqst-wait', label: '승인대기' },
  OK: { className: 'badge-rqst-ok', label: '승인완료' },
  RJCT: { className: 'badge-rqst-rjct', label: '반려' },
  CNL: { className: 'badge-rqst-cnl', label: '신청취소' },
};

export function StatusBadge({ status }) {
  const code = String(status || '').toUpperCase();
  const badge = REQUEST_STATUS_BADGE[code];
  if (badge) return <span className={badge.className}>{badge.label}</span>;
  return <span className="badge-rqst-cnl">{STATUS_NAMES[code] || code || '-'}</span>;
}

export function RoleBadge({ code, name }) {
  const roleCode = String(code || '').toUpperCase();
  return (
    <span className={`role-badge ${ROLE_BADGE_CLASS[roleCode] || 'role-badge-default'}`}>
      {name || ROLE_NAMES[roleCode] || code || '-'}
    </span>
  );
}

export function formatDateDot(value) {
  if (value == null || value === '') return '-';
  const datePart = String(value).trim().slice(0, 10);
  if (!datePart) return '-';
  return datePart.replace(/-/g, '.');
}

export function TablePagination({ page, lastPage, onChange }) {
  if (lastPage <= 1) return null;

  const blockSize = 5;
  const currentBlock = Math.floor((page - 1) / blockSize);
  const startPage = currentBlock * blockSize + 1;
  const endPage = Math.min(startPage + blockSize - 1, lastPage);
  const pages = Array.from(
    { length: endPage - startPage + 1 },
    (_, i) => startPage + i,
  );
  const prevBlockPage = Math.max(1, startPage - blockSize);
  const nextBlockPage = Math.min(lastPage, startPage + blockSize);

  return (
    <div className="table-pagination">
      <div className="pagination-right">
        <p className="table-info-text">{page} / {lastPage}</p>
        <button type="button" className="btn-page-nav" disabled={startPage === 1} onClick={() => onChange(prevBlockPage)}>◀</button>
        {pages.map((pageNo) => (
          <button
            key={pageNo}
            type="button"
            className={'btn-page-number' + (pageNo === page ? ' active' : '')}
            onClick={() => onChange(pageNo)}
          >
            {pageNo}
          </button>
        ))}
        <button type="button" className="btn-page-nav" disabled={endPage === lastPage} onClick={() => onChange(nextBlockPage)}>▶</button>
      </div>
    </div>
  );
}
