/** 섹션 컴포넌트에서 같이 쓰는 라벨·인라인 스타일 */

export const annStyles = {
  textarea: {
    width: '100%',
    minHeight: 120,
    border: '1px solid var(--outline-variant)',
    borderRadius: 8,
    padding: 12,
    fontSize: 14,
    background: 'var(--surface-container-low)',
    boxSizing: 'border-box',
    outline: 'none',
    fontFamily: 'inherit',
    resize: 'vertical',
  },
  readonly: {
    background: 'var(--surface-container-high)',
    color: 'var(--on-surface-variant)',
  },
  tableInput: {
    width: '100%',
    padding: '10px 12px',
    borderRadius: 8,
    border: '1px solid var(--outline-variant)',
    boxSizing: 'border-box',
    fontSize: 14,
    background: 'var(--surface-container-low)',
    textAlign: 'left',
  },
  docList: { margin: 0, paddingLeft: 24, lineHeight: 1.75, fontSize: 14 },
};

export function ReqStar() {
  return (
    <span style={{ color: 'var(--error)', marginLeft: 4, fontWeight: 700 }} aria-hidden>
      *
    </span>
  );
}

export function LR({ htmlFor, children, req }) {
  return (
    <label htmlFor={htmlFor}>
      {children}
      {req ? <ReqStar /> : null}
    </label>
  );
}

/** name = insertAnn API 키와 동일 */
export const DATE_FIELDS = [
  ['pblancBgngDt', '게시 시작일'],
  ['pblancEndDt', '게시 종료일'],
  ['rcrtBgngDt', '모집 시작일'],
  ['rcrtEndDt', '모집 종료일'],
];

// 
export const SUPPLY_COLS = [
  { key: 'type', label: '타입', input: 'text', ph: '예: A타입' },
  { key: 'exclArea', label: '전용면적(㎡)', input: 'number', min: 0, step: '0.01', ph: '예: 65' },
  { key: 'roomCnt', label: '방 수', input: 'number', min: 0, ph: '예: 3' },
  { key: 'bathCnt', label: '욕실 수', input: 'number', min: 0, ph: '예: 2' },
  { key: 'supplyCnt', label: '공급 세대수', input: 'number', min: 0, ph: '예: 2' },
];

export const SUPPLY_LABELS = {
  sectionTitle: '공급 정보',
  sido: '시·도',
  sigungu: '시·군·구',
  emd: '읍·면·동',
  apt: '아파트 단지',
  addr: '주소',
  sidoSelect: '시·도 선택',
  sigunguSelect: '시·군·구 선택',
  needSido: '시·도를 먼저 선택하세요',
  emdSelect: '읍·면·동 선택',
  needSigungu: '시·군·구를 먼저 선택하세요',
  aptSelect: '아파트 단지 선택',
  needEmd: '읍·면·동을 먼저 선택하세요',
  addrPh: '단지를 선택하세요',
};
