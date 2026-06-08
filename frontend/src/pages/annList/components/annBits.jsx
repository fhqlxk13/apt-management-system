/** 공고 목록 공통 상수·표시 */

export const PAGE_SIZE = 10;

const BADGE_BASE = {
  display: 'inline-block',
  fontSize: 11,
  fontWeight: 700,
  padding: '3px 10px',
  borderRadius: 9999,
  whiteSpace: 'nowrap',
};

/** 밝은 배경 + 진한 글자 (badge-rqst-* 톤) */
const STATUS_STYLE = {
  '진행중': { backgroundColor: '#ecf7ef', color: '#2f7a4d' },
  예정: { backgroundColor: '#fff5df', color: '#9a6b00' },
  마감: { backgroundColor: '#e5e7eb', color: '#4b5563' },
};

export function getStatusName(row) {
  return row?.statusNm || calcStatus(row?.rcrtBgngDt, row?.rcrtEndDt);
}

export function calcStatus(start, end) {
  if (!start || !end) return '-';
  const today = new Date();
  today.setHours(0, 0, 0, 0);
  const s = new Date(start);
  const e = new Date(end);
  if (today < s) return '예정';
  if (today > e) return '마감';
  return '진행중';
}

export function StatusBadge({ status }) {
  const name = status || '-';
  return (
    <span style={{ ...BADGE_BASE, ...(STATUS_STYLE[name] || STATUS_STYLE['예정']) }}>
      {name}
    </span>
  );
}

export function formatRange(start, end) {
  if (!start && !end) return '-';
  return `${start || '-'} ~ ${end || '-'}`;
}

export const EMPTY_FILTER = {
  searchTtl: '',
  searchAptCmplexNo: '',
  searchFrom: '',
  searchTo: '',
  searchStatus: '',
};
